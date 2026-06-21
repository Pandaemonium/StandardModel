#!/usr/bin/env python3
"""Regression tests for Scripts/lit_harness.py (no pytest / network needed).

Run: python Scripts/lit/test_lit_harness.py
Exits non-zero on the first failure. Covers the pure helpers (normalizers, JSON
extraction, round-robin merge, term filters, staging dedup, triage combination)
and an end-to-end process_topic run against fake MCP + Gemma.
"""
from __future__ import annotations

import argparse
import io
import json
import os
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
import lit_harness as lh  # noqa: E402

_failures: list[str] = []


def check(name: str, cond: bool, detail: str = "") -> None:
    print(f"{'PASS' if cond else 'FAIL'}  {name}" + (f"  -- {detail}" if detail and not cond else ""))
    if not cond:
        _failures.append(name)


# --------------------------------------------------------------------------- #
def test_normalizers():
    check("norm_arxiv strips version", lh.norm_arxiv("1308.2822v2") == "1308.2822")
    check("norm_arxiv strips prefix", lh.norm_arxiv("arXiv:hep-th/0510161") == "hep-th/0510161")
    check("norm_doi lowercases+strips", lh.norm_doi("https://doi.org/10.1/AB") == "10.1/ab")
    check("title_key alnum only", lh.title_key("Why the Tsirelson Bound?") == "whythetsirelsonbound")
    check("candidate_key prefers arxiv", lh.candidate_key("1308.2822v2", "10.1/x", "T") == "1308.2822")
    check("candidate_key falls to doi", lh.candidate_key("", "10.1/X", "T") == "10.1/x")
    check("candidate_key falls to title", lh.candidate_key("", "", "A B") == "ab")


def test_extract_json():
    check("fenced array", lh.extract_json('```json\n[1,2,3]\n```') == [1, 2, 3])
    check("object", lh.extract_json('{"a":1}') == {"a": 1})
    check("array amid prose", lh.extract_json('here: [{"id":"C1"}] done') == [{"id": "C1"}])
    check("garbage -> None", lh.extract_json("no json here") is None)
    check("empty -> None", lh.extract_json("") is None)


def test_round_robin_merge():
    a = [{"title": "A", "arxiv_id": "1", "doi": ""}, {"title": "B", "arxiv_id": "2", "doi": ""}]
    b = [{"title": "C", "arxiv_id": "3", "doi": ""}, {"title": "A", "arxiv_id": "1", "doi": ""}]
    merged = lh.round_robin_merge([("inspire|k1", a), ("arxiv|k2", b)], max_total=10)
    keys = [m["candidate_key"] for m in merged]
    check("round-robin interleaves+dedups", keys == ["1", "3", "2"], str(keys))
    found = {m["candidate_key"]: m["found_by_count"] for m in merged}
    check("found_by_count counts sources", found["1"] == 2 and found["2"] == 1, str(found))
    capped = lh.round_robin_merge([("s|k", a)], max_total=1)
    check("cap applied", len(capped) == 1)


def test_term_filters():
    c = {"title": "Quantum widgets", "abstract": "belief propagation machine learning"}
    check("exclude hits", lh.passes_term_filters(c, [], ["machine learning"]) is False)
    check("must_have missing", lh.passes_term_filters(c, ["gizmo"], []) is False)
    check("must_have present", lh.passes_term_filters(c, ["widgets"], []) is True)
    check("clean passes", lh.passes_term_filters({"title": "X", "abstract": "y"}, [], []) is True)


def test_load_seen_keys():
    with tempfile.TemporaryDirectory() as d:
        path = os.path.join(d, "staging.jsonl")
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(json.dumps({"candidate_key": "1308.2822"}) + "\n")
            fh.write(json.dumps({"arxiv_id": "2222.0002", "doi": "", "title": "X"}) + "\n")
            fh.write("not json\n")
        seen = lh.load_seen_keys(path)
        check("seen from candidate_key", "1308.2822" in seen)
        check("seen recomputed from fields", "2222.0002" in seen)
        check("missing file -> empty", lh.load_seen_keys(os.path.join(d, "nope.jsonl")) == set())


def test_combine_triage():
    recall = {
        "C1": {"topic_fit": 5, "formalization_value": 4, "source_importance": 3, "evidence": "core"},
        "C2": {"topic_fit": 4, "formalization_value": 2, "source_importance": 2, "evidence": "ml?"},
    }
    skeptic = {"C1": {"off_topic_risk": 0, "verdict": "KEEP", "reason": "on topic"},
               "C2": {"off_topic_risk": 5, "verdict": "REJECT", "reason": "lexical overlap"}}
    out = lh.combine_triage(recall, skeptic, n=3)
    check("recall+KEEP -> INCLUDE", out["C1"]["decision"] == "INCLUDE")
    check("recall+REJECT -> REVIEW", out["C2"]["decision"] == "REVIEW")
    check("absent -> SKIP", out["C3"]["decision"] == "SKIP")
    check("INCLUDE ranks above REVIEW", out["C1"]["rank"] == 1 and out["C2"]["rank"] == 2)
    check("composite computed", out["C1"]["composite"] == 12)


# --------------------------------------------------------------------------- #
class FakeScholarly:
    """Returns the same 3 canned hits for any (tool, query)."""
    HITS = [
        {"title": "Alpha widgets", "arxiv_id": "1111.0001", "doi": "10.1/a",
         "year": "2020", "abstract": "about widgets and gizmos", "url": "u1", "citation_count": 5},
        {"title": "Beta ML", "arxiv_id": "2222.0002", "doi": "",
         "year": "2021", "abstract": "belief propagation machine learning widgets", "url": "u2"},
        {"title": "Gamma widgets", "arxiv_id": "3333.0003", "doi": "",
         "year": "2019", "abstract": "widgets quantum theory", "url": "u3"},
    ]

    def call(self, tool, arguments):
        return {"results": [dict(h) for h in self.HITS]}


class FakeNeo4j:
    """Reports Alpha (1111.0001) as already in the library."""
    def call(self, tool, arguments):
        return [{"arxivs": ["1111.0001"], "dois": [], "titlekeys": []}]


def fake_gemma(prompt, model, timeout, fmt=None, temperature=None):
    if "keyword sets" in prompt:
        return json.dumps(["widgets quantum"])
    if "RECALL pass" in prompt:
        # C1 is the only new+unfiltered candidate (Gamma) after exclude+dedup.
        return json.dumps([{"id": "C1", "topic_fit": 5, "formalization_value": 4,
                            "source_importance": 3, "evidence": "on topic"}])
    if "SKEPTICAL" in prompt:
        return json.dumps([{"id": "C1", "off_topic_risk": 0, "verdict": "KEEP", "reason": "fine"}])
    return "[]"


def make_cfg(**over):
    base = dict(backends=["search-inspirehep", "search-arxiv"], limit=5, keywords=2,
                max_per_topic=12, sleep=0.0, model="fake", gemma_timeout=5.0,
                no_gemma_keywords=False, no_triage=False, single_pass=False,
                tags=["null-edge-program"], collection="9W59V3K9")
    base.update(over)
    return argparse.Namespace(**base)


def test_process_topic_end_to_end():
    orig = lh.gemma_generate
    lh.gemma_generate = fake_gemma
    try:
        spec = {"topic": "widgets", "exclude": ["machine learning"]}
        out = io.StringIO()
        seen: set[str] = set()
        stats = lh.process_topic(spec, FakeScholarly(), FakeNeo4j(), make_cfg(),
                                 out, seen, {"run_id": "RID", "model": "fake"})
        rows = [json.loads(l) for l in out.getvalue().splitlines()]
        check("exclude removed Beta(ML)", all("Beta" not in r["title"] for r in rows))
        check("Alpha deduped (in library)", all(r["candidate_key"] != "1111.0001" for r in rows))
        check("exactly Gamma staged", len(rows) == 1 and rows[0]["candidate_key"] == "3333.0003")
        r = rows[0]
        check("decision INCLUDE", r["decision"] == "INCLUDE")
        check("audit fields present",
              r["schema_version"] == 2 and r["run_id"] == "RID" and r["prompt_version"]
              and r["scores"].get("topic_fit") == 5)
        check("duplicates counted", stats["duplicates"] == 1)
        check("seen updated", "3333.0003" in seen)
        # Gamma is found by both backends (found_by_count=2): composite 5+4+3-0 +1 corroboration = 13
        check("corroboration bonus applied", r.get("composite") == 13, str(r.get("composite")))
    finally:
        lh.gemma_generate = orig


def test_process_topic_cross_run_dedup():
    orig = lh.gemma_generate
    lh.gemma_generate = fake_gemma
    try:
        spec = {"topic": "widgets", "exclude": ["machine learning"]}
        out = io.StringIO()
        seen = {"3333.0003"}  # Gamma already staged in a prior run
        stats = lh.process_topic(spec, FakeScholarly(), FakeNeo4j(), make_cfg(),
                                 out, seen, {"run_id": "RID", "model": "fake"})
        check("prev-staged not re-proposed", out.getvalue().strip() == "")
        check("previously_staged counted", stats["previously_staged"] == 1)
    finally:
        lh.gemma_generate = orig


def test_triage_skeptic_unavailable_fallback():
    """If the skeptic pass cannot be parsed, only topic_fit==5 stays INCLUDE; rest -> REVIEW."""
    def fake(prompt, model, timeout, fmt=None, temperature=None):
        if "RECALL pass" in prompt:
            return json.dumps([
                {"id": "C1", "topic_fit": 5, "formalization_value": 4, "source_importance": 4, "evidence": "core"},
                {"id": "C2", "topic_fit": 3, "formalization_value": 2, "source_importance": 2, "evidence": "maybe"}])
        if "SKEPTICAL" in prompt:
            return "this is not json at all"  # force skeptic parse failure
        return "[]"
    orig = lh.gemma_generate
    lh.gemma_generate = fake
    try:
        cands = [{"title": "A", "year": "1", "abstract": "x"}, {"title": "B", "year": "1", "abstract": "y"}]
        decisions, failed = lh.triage({"topic": "t"}, cands, "fake", 5.0, two_pass=True)
        check("recall still ok when skeptic fails", failed is False)
        check("topic_fit==5 stays INCLUDE", decisions["C1"]["decision"] == "INCLUDE")
        check("lower topic_fit -> REVIEW", decisions["C2"]["decision"] == "REVIEW")
    finally:
        lh.gemma_generate = orig


def test_combine_triage_salvaged_recall():
    """When recall was salvaged (incomplete), absent candidates -> REVIEW, not SKIP."""
    recall = {"C1": {"topic_fit": 5, "formalization_value": 3, "source_importance": 3, "evidence": "x"}}
    out = lh.combine_triage(recall, {}, n=3, recall_complete=False)
    check("salvaged: scored item still decided", out["C1"]["decision"] in ("INCLUDE", "REVIEW"))
    check("salvaged: absent C2 -> REVIEW", out["C2"]["decision"] == "REVIEW")
    check("salvaged: absent C3 -> REVIEW", out["C3"]["decision"] == "REVIEW")
    out2 = lh.combine_triage(recall, {}, n=3, recall_complete=True)
    check("clean: absent C2 -> SKIP", out2["C2"]["decision"] == "SKIP")


def test_salvage_json_objects():
    truncated = '```json\n[\n  {"id":"C1","verdict":"KEEP"},\n  {"id":"C2","verdict":"REJ'
    objs = lh.salvage_json_objects(truncated)
    check("salvage recovers complete objects", objs == [{"id": "C1", "verdict": "KEEP"}], str(objs))
    garbled = 'noise {"id":"C1","x":1} junk {"id":"C2","x":2} tail'
    check("salvage skips noise", lh.salvage_json_objects(garbled) == [{"id": "C1", "x": 1}, {"id": "C2", "x": 2}])
    check("salvage empty on none", lh.salvage_json_objects("no objects here") == [])


def main() -> int:
    for fn in [test_normalizers, test_extract_json, test_round_robin_merge, test_term_filters,
               test_load_seen_keys, test_combine_triage, test_process_topic_end_to_end,
               test_process_topic_cross_run_dedup, test_triage_skeptic_unavailable_fallback,
               test_salvage_json_objects, test_combine_triage_salvaged_recall]:
        fn()
    print(f"\n{'ALL PASS' if not _failures else 'FAILURES: ' + ', '.join(_failures)}")
    return 1 if _failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
