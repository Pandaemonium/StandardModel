#!/usr/bin/env python3
"""Option 2 literature-search harness (staging-only, no live writes) -- v2.

Python owns control flow, dedup, caps, and staging; the local LLM (Gemma via
Ollama) is used only as a text function for keyword generation and relevance
triage. The harness makes NO writes to Zotero or Neo4j (Neo4j is read-only, for
dedup). It appends ranked, audit-grade proposals to a staging file for a
human/strong-model approval pass (see lit_ingest.py).

Pipeline per topic:
  1. Gemma proposes plain keyword sets (no boolean operators).
  2. Each keyword is searched across one or more `scholarly` backends.
  3. Results are round-robin merged across (backend, keyword) so narrow keywords
     are not starved by broad ones; deduped within the batch by arxiv/doi/title.
  4. Deterministic must-have / exclude term filters (precision lever).
  5. Cross-run dedup against prior staging output, then against the live Neo4j
     graph (read-only existence check on arxiv_id / doi / title_key).
  6. Two-pass Gemma triage: a generous recall pass (scores) and a skeptic pass
     that flags lexical-overlap false positives. Conflicts -> REVIEW.
  7. Proposals are appended to staging.jsonl. Nothing is committed.

v2 changes (from Codex review 2026-06-21): audit-grade records (run_id, model,
prompt_version, backends, keywords, candidate_key, found_by), cross-run staging
dedup, MCP retry + session restart, multi-backend merge, title-key graph dedup,
structured topics with must_have/exclude, two-pass scored triage.

Design boundary that must NOT change: Gemma never executes tools or writes to the
corpus; concept/claim graph edges stay human-curated; ingest is a separate,
human-gated step.

Usage:
  python Scripts/lit_harness.py --topic "..." --no-gemma-keywords --no-triage   # fast plumbing
  python Scripts/lit_harness.py --topic "..."                                     # full run
  python Scripts/lit_harness.py --topics-file Scripts/lit/topics.txt             # batch / overnight
"""
from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import threading
import time
import uuid
from datetime import datetime, timezone

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Reuse the tested .mcp.json loader / ${VAR} expander from the MCP helper.
sys.path.insert(0, os.path.join(REPO_ROOT, "Scripts", "mcp"))
from mcp_call import load_server  # noqa: E402

OLLAMA_URL = os.environ.get("OLLAMA_URL", "http://localhost:11434/api/generate")
DEFAULT_MODEL = os.environ.get("LIT_HARNESS_MODEL", "gemma4:12b")

SCHEMA_VERSION = 2
PROMPT_VERSION = "2026-06-21"  # bump when the keyword/triage prompts change


# --------------------------------------------------------------------------- #
# Pure helpers (unit-tested in Scripts/lit/test_lit_harness.py).
# --------------------------------------------------------------------------- #
def norm_arxiv(a: str) -> str:
    a = (a or "").strip()
    a = re.sub(r"(?i)^arxiv:", "", a)
    a = re.sub(r"v\d+$", "", a)  # strip version suffix (1308.2822v2 -> 1308.2822)
    return a


def norm_doi(d: str) -> str:
    d = (d or "").strip().lower()
    d = re.sub(r"^https?://(dx\.)?doi\.org/", "", d)
    return d


def title_key(title: str) -> str:
    """Lowercased alphanumeric title (matches the Neo4j Paper.title_key convention)."""
    return re.sub(r"[^a-z0-9]+", "", (title or "").lower())


def candidate_key(arxiv: str, doi: str, title: str) -> str:
    """Stable dedup key: normalized arxiv, else doi, else title_key."""
    return norm_arxiv(arxiv) or norm_doi(doi) or title_key(title)


def extract_json(text: str):
    """Pull the first JSON array/object out of an LLM reply (strips code fences)."""
    if not text:
        return None
    t = text.strip()
    t = re.sub(r"^```[a-zA-Z0-9]*\n?", "", t)
    t = re.sub(r"\n?```$", "", t).strip()
    for opener, closer in (("[", "]"), ("{", "}")):
        s, e = t.find(opener), t.rfind(closer)
        if s != -1 and e != -1 and e > s:
            try:
                return json.loads(t[s:e + 1])
            except json.JSONDecodeError:
                pass
    try:
        return json.loads(t)
    except json.JSONDecodeError:
        return None


def salvage_json_objects(text: str) -> list:
    """Recover individual balanced {...} JSON objects from a garbled/truncated reply.

    Used as a last resort when a full array does not parse. Only safe where a
    partial result is acceptable (the skeptic pass), NOT for recall (where a
    missing item must mean REVIEW, not a silently dropped paper).
    """
    objs, depth, start = [], 0, None
    for i, ch in enumerate(text):
        if ch == "{":
            if depth == 0:
                start = i
            depth += 1
        elif ch == "}" and depth > 0:
            depth -= 1
            if depth == 0 and start is not None:
                try:
                    objs.append(json.loads(text[start:i + 1]))
                except json.JSONDecodeError:
                    pass
                start = None
    return objs


def make_candidate(hit: dict, source_label: str) -> dict:
    """Build a candidate record from a scholarly hit. source_label is 'backend|keyword'."""
    backend, _, query = source_label.partition("|")
    ax, doi = norm_arxiv(hit.get("arxiv_id", "")), norm_doi(hit.get("doi", ""))
    return {
        "candidate_key": candidate_key(ax, doi, hit.get("title", "")),
        "title": hit.get("title", ""), "year": hit.get("year", ""),
        "arxiv_id": ax, "doi": doi, "url": hit.get("url", ""),
        "abstract": hit.get("abstract", ""),
        "backend": backend, "query": query,
        "citation_count": hit.get("citation_count"),
        "found_by": [source_label],
    }


def round_robin_merge(per_source: list[tuple[str, list[dict]]], max_total: int) -> list[dict]:
    """Interleave hits across sources (backend|keyword); dedup by candidate_key.

    A paper found by several sources accumulates them in `found_by` (a strength
    signal). The per-topic cap is applied to the round-robin order.
    """
    merged: dict[str, dict] = {}
    order: list[str] = []
    depth = max((len(h) for _, h in per_source), default=0)
    for i in range(depth):
        for label, hits in per_source:
            if i >= len(hits):
                continue
            h = hits[i]
            key = candidate_key(h.get("arxiv_id", ""), h.get("doi", ""), h.get("title", ""))
            if not key:
                continue
            if key in merged:
                if label not in merged[key]["found_by"]:
                    merged[key]["found_by"].append(label)
                continue
            merged[key] = make_candidate(h, label)
            order.append(key)
    out = [merged[k] for k in order]
    for r in out:
        r["found_by_count"] = len(r["found_by"])
    return out[:max_total]


def passes_term_filters(cand: dict, must_have: list[str], exclude: list[str]) -> bool:
    """Deterministic precision filter over title+abstract (case-insensitive)."""
    hay = f"{cand.get('title', '')} {cand.get('abstract', '')}".lower()
    if must_have and not all(t.lower() in hay for t in must_have):
        return False
    if exclude and any(t.lower() in hay for t in exclude):
        return False
    return True


def load_seen_keys(path: str) -> set[str]:
    """Candidate keys already present in a prior staging file (cross-run dedup)."""
    seen: set[str] = set()
    if not path or not os.path.exists(path):
        return seen
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                continue
            key = rec.get("candidate_key") or candidate_key(
                rec.get("arxiv_id", ""), rec.get("doi", ""), rec.get("title", ""))
            if key:
                seen.add(key)
    return seen


def normalize_topic(spec) -> dict:
    """Accept a plain string or a dict; return a normalized topic spec."""
    if isinstance(spec, str):
        return {"topic": spec.strip()}
    if isinstance(spec, dict) and spec.get("topic"):
        out = {"topic": str(spec["topic"]).strip()}
        for k in ("pillar", "must_have", "exclude", "extra_keywords", "tags", "collection"):
            if spec.get(k) is not None:
                out[k] = spec[k]
        return out
    raise ValueError(f"invalid topic spec: {spec!r}")


def combine_triage(recall: dict, skeptic: dict, n: int, recall_complete: bool = True) -> dict:
    """Merge recall + skeptic passes into per-candidate decisions/scores/ranks.

    recall[cid]   -> {topic_fit, formalization_value, source_importance, evidence}
    skeptic[cid]  -> {off_topic_risk, verdict, reason}
    Not in recall            -> SKIP.
    In recall, skeptic KEEP  -> INCLUDE.
    In recall, skeptic REJECT/high off_topic_risk -> REVIEW (conflict).
    Rank by composite = topic_fit + formalization_value + source_importance - off_topic_risk.
    """
    out: dict[str, dict] = {}
    scored: list[tuple[float, str]] = []
    for i in range(1, n + 1):
        cid = f"C{i}"
        r = recall.get(cid)
        if not r:
            # absent from a CLEAN recall = deliberate omission (SKIP); absent from a
            # SALVAGED recall = uncertain, so REVIEW rather than silently drop.
            out[cid] = {"decision": "SKIP" if recall_complete else "REVIEW", "rank": None,
                        "reason": "" if recall_complete else "recall salvaged; item not scored",
                        "evidence": "", "scores": {}, "composite": None}
            continue
        s = skeptic.get(cid) or {}
        off = int(s.get("off_topic_risk", 0) or 0)
        verdict = str(s.get("verdict", "KEEP")).strip().upper()
        decision = "REVIEW" if (verdict == "REJECT" or off >= 4) else "INCLUDE"
        scores = {
            "topic_fit": int(r.get("topic_fit", 0) or 0),
            "formalization_value": int(r.get("formalization_value", 0) or 0),
            "source_importance": int(r.get("source_importance", 0) or 0),
            "off_topic_risk": off,
        }
        composite = (scores["topic_fit"] + scores["formalization_value"]
                     + scores["source_importance"] - off)
        out[cid] = {"decision": decision, "rank": None, "reason": s.get("reason", ""),
                    "evidence": r.get("evidence", ""), "scores": scores, "composite": composite}
        scored.append((composite, cid))
    for rank, (_, cid) in enumerate(sorted(scored, key=lambda x: x[0], reverse=True), 1):
        out[cid]["rank"] = rank
    return out


# --------------------------------------------------------------------------- #
# MCP session with retry + restart (robust for long overnight runs).
# --------------------------------------------------------------------------- #
class McpSession:
    def __init__(self, server: str, call_timeout: float = 60.0, retries: int = 2) -> None:
        self.server = server
        self.call_timeout = call_timeout
        self.retries = retries
        self._spawn()

    def _spawn(self) -> None:
        command, env = load_server(self.server)
        self._proc = subprocess.Popen(
            command, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE, env=env, cwd=REPO_ROOT)
        self._err: list[bytes] = []
        threading.Thread(
            target=lambda: self._err.append(self._proc.stderr.read() or b""),
            daemon=True).start()
        self._id = 0
        self._handshake()

    def restart(self) -> None:
        try:
            self._proc.kill()
        except Exception:
            pass
        self._spawn()

    def _send(self, obj: dict) -> None:
        self._proc.stdin.write((json.dumps(obj) + "\n").encode("utf-8"))
        self._proc.stdin.flush()

    def _recv(self, want_id: int):
        while True:
            line = self._proc.stdout.readline()
            if not line:
                return None
            line = line.strip()
            if not line:
                continue
            try:
                msg = json.loads(line)
            except json.JSONDecodeError:
                continue
            if msg.get("id") == want_id:
                return msg

    def _handshake(self) -> None:
        self._id += 1
        self._send({"jsonrpc": "2.0", "id": self._id, "method": "initialize",
                    "params": {"protocolVersion": "2025-03-26", "capabilities": {},
                               "clientInfo": {"name": "lit_harness", "version": "0.2.0"}}})
        if self._recv(self._id) is None:
            raise RuntimeError(f"{self.server}: no initialize response\n{self._stderr()}")
        self._send({"jsonrpc": "2.0", "method": "notifications/initialized"})

    def _call_once(self, tool: str, arguments: dict):
        self._id += 1
        call_id = self._id
        watchdog = threading.Timer(self.call_timeout, self._proc.kill)
        watchdog.start()
        try:
            self._send({"jsonrpc": "2.0", "id": call_id, "method": "tools/call",
                        "params": {"name": tool, "arguments": arguments}})
            resp = self._recv(call_id)
        finally:
            watchdog.cancel()
        if resp is None:
            raise RuntimeError(f"{self.server}.{tool}: no response / timeout\n{self._stderr()}")
        if "error" in resp:
            raise RuntimeError(f"{self.server}.{tool}: {json.dumps(resp['error'])}")
        return self._payload(resp.get("result", resp))

    def call(self, tool: str, arguments: dict):
        """tools/call with retry + session restart on transport failure."""
        last: Exception | None = None
        for attempt in range(self.retries + 1):
            try:
                return self._call_once(tool, arguments)
            except (RuntimeError, OSError, ValueError) as exc:
                last = exc
                if attempt < self.retries:
                    time.sleep(min(2 ** attempt, 8))
                    self.restart()
        raise last  # type: ignore[misc]

    @staticmethod
    def _payload(result):
        """Prefer structuredContent; else parse concatenated text content blocks.

        Handles the scholarly/zotero servers (structuredContent object) and the
        neo4j server (JSON array in text content).
        """
        if isinstance(result, dict):
            sc = result.get("structuredContent")
            if sc is not None:
                return sc
            content = result.get("content")
            if isinstance(content, list):
                texts = [b.get("text", "") for b in content
                         if isinstance(b, dict) and b.get("type") == "text"]
                joined = "\n".join(t for t in texts if t)
                if joined:
                    try:
                        return json.loads(joined)
                    except json.JSONDecodeError:
                        return joined
        return result

    def _stderr(self) -> str:
        return (self._err[0].decode("utf-8", "replace") if self._err else "").strip()

    def close(self) -> None:
        try:
            self._proc.stdin.close()
            self._proc.wait(timeout=5)
        except Exception:
            self._proc.kill()


# --------------------------------------------------------------------------- #
# Gemma (Ollama /api/generate) -- text function only. Imported lazily so the
# pure helpers and unit tests do not require urllib/network at import time.
# --------------------------------------------------------------------------- #
def gemma_generate(prompt: str, model: str, timeout: float,
                   fmt: str | None = None, temperature: float | None = None) -> str:
    import urllib.request
    payload: dict = {"model": model, "prompt": prompt, "stream": False}
    if fmt:
        payload["format"] = fmt  # Ollama structured output, e.g. "json"
    if temperature is not None:
        payload["options"] = {"temperature": temperature}
    body = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(OLLAMA_URL, data=body,
                                 headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return json.loads(resp.read().decode("utf-8")).get("response", "")


def _gemma_json_list(prompt: str, model: str, timeout: float,
                     temperature: float = 0.0, retries: int = 2,
                     salvage: bool = False) -> tuple[list, bool, bool]:
    """Call Gemma and coerce the reply to a list. Returns (items, ok, complete).

    complete=True only for a clean full array (or {"k": [...]}) parse. complete=False
    means items were salvaged from a garbled/truncated reply, so absent items are
    UNCERTAIN (caller should treat them as REVIEW, not a deliberate omission).
    ok=False means nothing parsed at all even after retries.
    """
    # NOTE: do NOT pass fmt="json" here -- gemma4:12b degrades badly under
    # Ollama's JSON-format constraint (emits garbled/meta output). Plain
    # generation + extract_json (which strips ```json fences) is reliable.
    for _ in range(retries + 1):
        raw = gemma_generate(prompt, model, timeout, temperature=temperature)
        data = extract_json(raw)
        if isinstance(data, list):
            return data, True, True
        if isinstance(data, dict):  # tolerate {"results": [...]} style wrappers
            for v in data.values():
                if isinstance(v, list):
                    return v, True, True
        if salvage:  # recover individual {...} objects from a garbled/truncated reply
            objs = salvage_json_objects(raw)
            if objs:
                return objs, True, False
    return [], False, False


def gen_keywords(spec: dict, model: str, n: int, timeout: float) -> list[str]:
    topic = spec["topic"]
    exclude = spec.get("exclude") or []
    hint = f" Avoid keywords about: {', '.join(exclude)}." if exclude else ""
    prompt = (
        "You generate literature-search keyword sets for physics papers.\n"
        f'Topic: "{topic}".' + (f' Focus: {spec["pillar"]}.' if spec.get("pillar") else "") + "\n"
        f"Output ONLY a JSON array of {n} plain keyword strings, ordered broad to "
        "narrow. Each is 2-5 words naming a distinct facet to search on INSPIRE-HEP "
        "/ arXiv. No boolean operators, no quotes, no AND/OR." + hint + " No prose."
    )
    kws: list[str] = []
    data, _, _ = _gemma_json_list(prompt, model, timeout, temperature=0.3)
    if isinstance(data, list):
        kws = [str(x).strip() for x in data if str(x).strip()][:n]
    kws += [str(x).strip() for x in (spec.get("extra_keywords") or []) if str(x).strip()]
    seen, out = set(), []
    for k in kws or [topic]:
        if k.lower() not in seen:
            seen.add(k.lower())
            out.append(k)
    return out


def _triage_lines(cands: list[dict]) -> str:
    lines = []
    for i, c in enumerate(cands, 1):
        abstract = " ".join((c.get("abstract") or "").split())[:200]
        lines.append(f"C{i} | {c.get('title', '')} | {c.get('year', '')} | {abstract}")
    return "\n".join(lines)


def triage_recall(spec: dict, cands: list[dict], model: str, timeout: float) -> tuple[dict, bool, bool]:
    prompt = (
        "You screen physics papers for relevance (RECALL pass -- be generous; list "
        "every candidate that could plausibly be relevant).\n"
        f'Topic: "{spec["topic"]}".'
        + (f' Focus: {spec["pillar"]}.' if spec.get("pillar") else "") + "\n"
        "For each plausibly-relevant candidate give integer scores 0-5: topic_fit, "
        "formalization_value (worth formalizing in Lean), source_importance "
        "(centrality), and a <=10 word evidence phrase.\n\nCANDIDATES:\n"
        + _triage_lines(cands) + "\n\n"
        'Output ONLY a JSON array: [{"id":"C1","topic_fit":5,"formalization_value":3,'
        '"source_importance":4,"evidence":"..."}]. Omit clearly irrelevant ones. No prose.'
    )
    out: dict[str, dict] = {}
    items, ok, complete = _gemma_json_list(prompt, model, timeout, salvage=True, retries=3)
    for item in items:
        if isinstance(item, dict) and item.get("id"):
            out[str(item["id"]).strip().upper()] = item
    return out, ok, complete


def triage_skeptic(spec: dict, cands: list[dict], keep_ids: list[str],
                   model: str, timeout: float) -> tuple[dict, bool]:
    kept = [(cid, cands[int(cid[1:]) - 1]) for cid in keep_ids
            if cid[1:].isdigit() and 0 < int(cid[1:]) <= len(cands)]
    lines = []
    for cid, c in kept:
        abstract = " ".join((c.get("abstract") or "").split())[:200]
        lines.append(f"{cid} | {c.get('title', '')} | {c.get('year', '')} | {abstract}")
    excl = spec.get("exclude") or []
    xhint = (f' Treat as off-topic anything primarily about: {", ".join(excl)}.' if excl else "")
    prompt = (
        "You are a SKEPTICAL reviewer guarding against false positives from keyword "
        "overlap. A paper that merely shares vocabulary (e.g. a machine-learning "
        'paper using "probabilistic"/"belief propagation") is NOT relevant to '
        "quantum-foundations physics.\n"
        f'Topic: "{spec["topic"]}".' + xhint + "\n\nCANDIDATES:\n" + "\n".join(lines) + "\n\n"
        'Output ONLY a JSON array: [{"id":"C1","off_topic_risk":0,"verdict":"KEEP",'
        '"reason":"<=12 words"}] where off_topic_risk is 0-5 and verdict is KEEP or '
        "REJECT. No prose."
    )
    out: dict[str, dict] = {}
    items, ok, _ = _gemma_json_list(prompt, model, timeout, salvage=True)
    for item in items:
        if isinstance(item, dict) and item.get("id"):
            out[str(item["id"]).strip().upper()] = item
    return out, ok


def triage(spec: dict, cands: list[dict], model: str, timeout: float,
           two_pass: bool) -> tuple[dict, bool]:
    """Return (decisions, failed). failed=True means recall could not be parsed."""
    recall, ok, recall_complete = triage_recall(spec, cands, model, timeout)
    if not ok:
        return {}, True
    skeptic, sk_ok = ({}, True)
    if two_pass and recall:
        skeptic, sk_ok = triage_skeptic(spec, cands, list(recall.keys()), model, timeout)
    decisions = combine_triage(recall, skeptic, len(cands), recall_complete)
    if two_pass and not sk_ok:  # FP guard unavailable -> keep only top-confidence as INCLUDE
        for d in decisions.values():
            if d["decision"] == "INCLUDE" and d.get("scores", {}).get("topic_fit", 0) < 5:
                d["decision"] = "REVIEW"
                d["reason"] = d.get("reason") or "skeptic pass unavailable; topic_fit<5"
    return decisions, False


# --------------------------------------------------------------------------- #
# Orchestration.
# --------------------------------------------------------------------------- #
def existing_in_graph(neo4j, arxivs, dois, titlekeys):
    arxivs = sorted({a for a in arxivs if a})
    dois = sorted({d for d in dois if d})
    titlekeys = sorted({t for t in titlekeys if t})
    if not (arxivs or dois or titlekeys):
        return set(), set(), set()
    query = (
        "MATCH (p:Paper) WHERE p.arxiv_id IN $arxivs OR toLower(p.doi) IN $dois "
        "OR p.title_key IN $titlekeys "
        "RETURN [x IN collect(DISTINCT p.arxiv_id) WHERE x <> ''] AS arxivs, "
        "[x IN collect(DISTINCT toLower(p.doi)) WHERE x <> ''] AS dois, "
        "[x IN collect(DISTINCT p.title_key) WHERE x <> ''] AS titlekeys"
    )
    payload = neo4j.call("read-cypher", {"query": query,
                                         "params": {"arxivs": arxivs, "dois": dois,
                                                    "titlekeys": titlekeys}})
    if isinstance(payload, list) and payload and isinstance(payload[0], dict):
        row = payload[0]
        return (set(row.get("arxivs") or []), set(row.get("dois") or []),
                set(row.get("titlekeys") or []))
    return set(), set(), set()


def process_topic(spec, scholarly, neo4j, cfg, staging, seen_keys, run_meta) -> dict:
    topic = spec["topic"]
    print(f"\n=== TOPIC: {topic}")
    must_have = spec.get("must_have") or []
    exclude = spec.get("exclude") or []
    tags = spec.get("tags") or cfg.tags
    collection = spec.get("collection") or cfg.collection

    # 1) keywords
    if cfg.no_gemma_keywords:
        keywords = [topic] + [str(x).strip() for x in (spec.get("extra_keywords") or []) if str(x).strip()]
    else:
        try:
            keywords = gen_keywords(spec, cfg.model, cfg.keywords, cfg.gemma_timeout)
        except Exception as exc:
            print(f"  [warn] keyword generation failed, using topic verbatim: {exc}")
            keywords = [topic]
    print(f"  keywords ({len(keywords)}): {keywords}")

    # 2) search every (backend, keyword)
    per_source: list[tuple[str, list[dict]]] = []
    for kw in keywords:
        for backend in cfg.backends:
            try:
                payload = scholarly.call(backend, {"query": kw, "limit": cfg.limit})
                hits = payload.get("results", []) if isinstance(payload, dict) else []
            except Exception as exc:
                print(f"  [warn] search failed {backend}/{kw!r}: {exc}")
                hits = []
            per_source.append((f"{backend}|{kw}", hits))
            time.sleep(cfg.sleep)

    # 3) round-robin merge + 4) term filters
    cands = round_robin_merge(per_source, cfg.max_per_topic * 2)  # room before filtering
    kept = [c for c in cands if passes_term_filters(c, must_have, exclude)]
    filtered = len(cands) - len(kept)
    cands = kept[:cfg.max_per_topic]
    print(f"  candidates: {len(cands)} (term-filtered out {filtered}; "
          f"{sum(1 for _, h in per_source if h)}/{len(per_source)} productive searches)")

    # 5a) cross-run staging dedup
    prev = [c for c in cands if c["candidate_key"] in seen_keys]
    cands = [c for c in cands if c["candidate_key"] not in seen_keys]

    # 5b) graph dedup (read-only)
    dup = 0
    if neo4j is not None and cands:
        try:
            ex_ax, ex_doi, ex_t = existing_in_graph(
                neo4j, [c["arxiv_id"] for c in cands], [c["doi"] for c in cands],
                [title_key(c["title"]) for c in cands])
            for c in cands:
                c["in_library"] = (c["arxiv_id"] in ex_ax or (bool(c["doi"]) and c["doi"] in ex_doi)
                                   or title_key(c["title"]) in ex_t)
                dup += 1 if c["in_library"] else 0
        except Exception as exc:
            print(f"  [warn] neo4j dedup failed, marking unchecked: {exc}")
            for c in cands:
                c["in_library"] = None
    else:
        for c in cands:
            c["in_library"] = None
    new_list = [c for c in cands if not c.get("in_library")]
    print(f"  previously staged: {len(prev)} | already in library: {dup} | new: {len(new_list)}")

    # 6) two-pass triage
    decisions: dict[str, dict] = {}
    if not cfg.no_triage and new_list:
        failed = False
        try:
            decisions, failed = triage(spec, new_list, cfg.model, cfg.gemma_timeout, not cfg.single_pass)
        except Exception as exc:
            print(f"  [warn] triage error: {exc}")
            failed = True
        if failed:
            # Parse failure must NOT masquerade as "nothing relevant" (all SKIP);
            # escalate every candidate to human REVIEW instead.
            print("  [warn] triage produced no parseable scores; marking all REVIEW")
            decisions = {f"C{i}": {"decision": "REVIEW", "rank": None, "scores": {},
                                   "composite": None, "evidence": "", "reason": "triage parse failed"}
                         for i in range(1, len(new_list) + 1)}
        # reward multi-backend corroboration: a paper found by >=2 (backend,keyword)
        # sources is a stronger signal -> small composite bonus, then re-rank.
        for i, c in enumerate(new_list, 1):
            d = decisions.get(f"C{i}")
            if d and d.get("composite") is not None and c.get("found_by_count", 1) >= 2:
                d["composite"] += 1
        scored = [(d["composite"], cid) for cid, d in decisions.items() if d.get("composite") is not None]
        for rank, (_, cid) in enumerate(sorted(scored, key=lambda x: -x[0]), 1):
            decisions[cid]["rank"] = rank
        n_inc = sum(1 for d in decisions.values() if d["decision"] == "INCLUDE")
        n_rev = sum(1 for d in decisions.values() if d["decision"] == "REVIEW")
        n_skp = sum(1 for d in decisions.values() if d["decision"] == "SKIP")
        print(f"  triage: INCLUDE={n_inc} REVIEW={n_rev} SKIP={n_skp}")

    # 7) stage proposals (no live writes)
    now = datetime.now(timezone.utc).isoformat()
    written = 0
    for i, c in enumerate(new_list, 1):
        d = decisions.get(f"C{i}", {})
        record = {
            "schema_version": SCHEMA_VERSION, "run_id": run_meta["run_id"], "ts": now,
            "prompt_version": PROMPT_VERSION, "model": run_meta["model"],
            "backends": cfg.backends, "limit": cfg.limit, "keywords": keywords,
            "topic": topic, "pillar": spec.get("pillar"),
            "candidate_key": c["candidate_key"],
            "title": c["title"], "year": c["year"], "arxiv_id": c["arxiv_id"],
            "doi": c["doi"], "url": c["url"], "citation_count": c.get("citation_count"),
            "found_by": c["found_by"], "found_by_count": c.get("found_by_count", 1),
            "in_library": c["in_library"],
            "decision": d.get("decision", "REVIEW"), "rank": d.get("rank"),
            "scores": d.get("scores", {}), "composite": d.get("composite"),
            "evidence": d.get("evidence", ""), "reason": d.get("reason", ""),
            "suggested_collection": collection, "suggested_tags": tags,
            "abstract": " ".join((c["abstract"] or "").split()),
        }
        staging.write(json.dumps(record, ensure_ascii=False) + "\n")
        seen_keys.add(c["candidate_key"])  # avoid intra-run re-proposal too
        written += 1
    staging.flush()
    return {"candidates": len(cands) + len(prev), "previously_staged": len(prev),
            "duplicates": dup, "staged": written}


def load_topics(args) -> list[dict]:
    specs: list = list(args.topic or [])
    if args.topics_file:
        with open(args.topics_file, encoding="utf-8") as fh:
            text = fh.read()
        try:
            data = json.loads(text)
            if isinstance(data, list):
                specs += data
                text = ""
        except json.JSONDecodeError:
            pass
        for line in text.splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            try:  # allow JSONL (one structured topic per line)
                obj = json.loads(line)
                specs.append(obj if isinstance(obj, (dict, str)) else line)
            except json.JSONDecodeError:
                specs.append(line)
    out, seen = [], set()
    for s in specs:
        spec = normalize_topic(s)
        if spec["topic"] not in seen:
            seen.add(spec["topic"])
            out.append(spec)
    return out


def main() -> int:
    p = argparse.ArgumentParser(description="Staging-only literature-search harness (Option 2, v2).")
    p.add_argument("--topic", action="append", help="a topic (repeatable)")
    p.add_argument("--topics-file", help="topics: one per line, or a JSON list, or JSONL of dicts")
    p.add_argument("--backends", default="search-inspirehep,search-arxiv",
                   help="comma-separated scholarly tools")
    p.add_argument("--limit", type=int, default=5, help="results per (keyword, backend)")
    p.add_argument("--keywords", type=int, default=4, help="keyword sets Gemma proposes per topic")
    p.add_argument("--max-per-topic", type=int, default=12, help="cap on candidates per topic")
    p.add_argument("--sleep", type=float, default=1.0, help="seconds between search calls")
    p.add_argument("--model", default=DEFAULT_MODEL, help="Ollama model for keyword/triage steps")
    p.add_argument("--gemma-timeout", type=float, default=600.0, help="per-call Gemma timeout (s)")
    p.add_argument("--mcp-timeout", type=float, default=60.0, help="per-call MCP timeout (s)")
    p.add_argument("--mcp-retries", type=int, default=2, help="MCP retries (with session restart)")
    p.add_argument("--collection", default="9W59V3K9", help="suggested Zotero collection (staging hint)")
    p.add_argument("--tags", nargs="*", default=["null-edge-program"], help="suggested tags (staging hint)")
    p.add_argument("--staging", default=os.path.join(REPO_ROOT, "Scripts", "lit", "staging.jsonl"))
    p.add_argument("--restage", action="store_true", help="ignore prior staging (re-propose seen papers)")
    p.add_argument("--single-pass", action="store_true", help="recall-only triage (skip skeptic pass)")
    p.add_argument("--no-gemma-keywords", action="store_true", help="use the topic verbatim")
    p.add_argument("--no-triage", action="store_true", help="skip Gemma triage (search+dedup only)")
    p.add_argument("--no-dedup", action="store_true", help="skip the Neo4j existence check")
    args = p.parse_args()
    args.backends = [b.strip() for b in args.backends.split(",") if b.strip()]

    topics = load_topics(args)
    if not topics:
        p.error("no topics given (use --topic or --topics-file)")

    os.makedirs(os.path.dirname(args.staging), exist_ok=True)
    seen_keys = set() if args.restage else load_seen_keys(args.staging)
    run_meta = {"run_id": datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ") + "-" + uuid.uuid4().hex[:8],
                "model": args.model}
    print(f"run_id={run_meta['run_id']} staging -> {args.staging}")
    print(f"backends={args.backends} model={args.model} two_pass={not args.single_pass} "
          f"keywords={not args.no_gemma_keywords} triage={not args.no_triage} "
          f"dedup={not args.no_dedup} seen={len(seen_keys)}")

    try:
        scholarly = McpSession("scholarly", call_timeout=args.mcp_timeout, retries=args.mcp_retries)
    except Exception as exc:
        print(f"[fatal] cannot start scholarly MCP: {exc}")
        return 1
    neo4j = None
    if not args.no_dedup:
        try:
            neo4j = McpSession("neo4j_graph", call_timeout=args.mcp_timeout, retries=args.mcp_retries)
        except Exception as exc:
            print(f"[warn] neo4j MCP unavailable; continuing WITHOUT graph dedup: {exc}")
    totals = {"candidates": 0, "previously_staged": 0, "duplicates": 0, "staged": 0}
    try:
        with open(args.staging, "a", encoding="utf-8", newline="\n") as staging:
            for spec in topics:
                try:  # one topic's failure must not abort an unattended batch
                    stats = process_topic(spec, scholarly, neo4j, args, staging, seen_keys, run_meta)
                except Exception as exc:
                    print(f"[warn] topic failed, skipping: {spec.get('topic')!r}: {exc}")
                    continue
                for k in totals:
                    totals[k] += stats[k]
    finally:
        scholarly.close()
        if neo4j is not None:
            neo4j.close()

    print(f"\nDONE run_id={run_meta['run_id']}: topics={len(topics)} "
          f"candidates={totals['candidates']} prev_staged={totals['previously_staged']} "
          f"duplicates={totals['duplicates']} staged={totals['staged']}")
    print("Staging is a PROPOSAL file -- no Zotero/Neo4j writes were made.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
