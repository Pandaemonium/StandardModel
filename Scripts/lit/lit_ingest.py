"""Ingest arXiv papers into Zotero + the Neo4j paper graph.

This is the previously-missing approval/ingest step referenced in
``Scripts/lit/README.md`` (the harness only stages to ``staging.jsonl``; it does
not write to Zotero or Neo4j). Per paper it:

1. dedup pre-checks against Neo4j on normalized ``arxiv_id`` / ``doi`` and skips
   anything already in the graph (the convention in ``Scripts/MCP_SERVERS.md``);
2. adds the item to Zotero via the configured ``zotero_write`` MCP server (which
   handles the arXiv -> Zotero metadata fetch and is itself idempotent), capturing
   the Zotero item key -- that key is the canonical ``paper_key``;
3. upserts a canonical ``:Paper`` node with ``IN_COLLECTION`` / ``AUTHORED_BY`` /
   ``HAS_TAG`` edges -- the exact shape ``neo4j_paper_search.py`` and its scoped
   vector query rely on (the ``IN_COLLECTION`` edge is required for a paper to be
   visible to the default null-edge-scoped search).

Then once, at the end, it calls ``neo4j_paper_search.ensure_embeddings()`` so the
new papers are semantically searchable (idempotent; cheap when nothing is new).

Run with the lean-explore tool-env interpreter (it carries the ``neo4j`` driver
and, for the embed step, torch + sentence-transformers):

    PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
    "$PY" Scripts/lit/lit_ingest.py 2502.16500 2312.08526 1502.04683
    "$PY" Scripts/lit/lit_ingest.py --from-staging Scripts/lit/staging.jsonl
    "$PY" Scripts/lit/lit_ingest.py 1502.04683 --dry-run      # dedup check only
    "$PY" Scripts/lit/lit_ingest.py 1502.04683 --no-embed     # skip the embed step

Credentials come from the environment (same as the MCP servers):
``ZOTERO_API_KEY`` for ``zotero_write``; ``NEO4J_URI`` / ``NEO4J_USERNAME`` /
``NEO4J_PASSWORD`` (+ optional ``NEO4J_DATABASE``) for the graph.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
import urllib.request
import xml.etree.ElementTree as ET

HERE = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(os.path.dirname(HERE))
MCP_CALL = os.path.join(REPO_ROOT, "Scripts", "mcp", "mcp_call.py")
DEFAULT_COLLECTION = "9W59V3K9"  # null-edge-lit (the real one; not the 12-paper legacy dup)
ARXIV_API = "http://export.arxiv.org/api/query?id_list={}"
ATOM = "{http://www.w3.org/2005/Atom}"
ARX = "{http://arxiv.org/schemas/atom}"

# neo4j_paper_search lives next to this file; reuse its driver + embedder.
sys.path.insert(0, HERE)
import neo4j_paper_search as nps  # noqa: E402


def normalize_arxiv(raw: str) -> str:
    """Strip an ``arXiv:`` prefix and a trailing ``vN`` version; keep old-style
    ``cat/NNNNNNN`` ids intact."""
    s = raw.strip()
    s = re.sub(r"^arxiv:", "", s, flags=re.IGNORECASE)
    s = re.sub(r"v\d+$", "", s)
    return s


def title_key(title: str) -> str:
    return re.sub(r"[^a-z0-9]+", "", (title or "").lower())


def fetch_arxiv_meta(arxiv_id: str) -> dict | None:
    """Fetch title/abstract/authors/year/url/doi from the arXiv API (stdlib)."""
    url = ARXIV_API.format(urllib.request.quote(arxiv_id))
    try:
        with urllib.request.urlopen(url, timeout=30) as resp:
            xml = resp.read()
    except Exception as exc:  # network/HTTP
        print(f"  ! arXiv metadata fetch failed for {arxiv_id}: {exc}", flush=True)
        return None
    root = ET.fromstring(xml)
    entry = root.find(f"{ATOM}entry")
    if entry is None or entry.find(f"{ATOM}title") is None:
        return None
    title = " ".join((entry.findtext(f"{ATOM}title") or "").split())
    abstract = " ".join((entry.findtext(f"{ATOM}summary") or "").split())
    authors = [
        " ".join((a.findtext(f"{ATOM}name") or "").split())
        for a in entry.findall(f"{ATOM}author")
    ]
    published = entry.findtext(f"{ATOM}published") or ""
    year = published[:4]
    doi = entry.findtext(f"{ARX}doi") or ""
    abs_url = f"http://arxiv.org/abs/{arxiv_id}"
    return {
        "title": title,
        "abstract": abstract,
        "authors": [a for a in authors if a],
        "year": year,
        "doi": doi,
        "url": abs_url,
    }


def _scan_zotero_key(payload: dict) -> str | None:
    """Pull an 8-char Zotero item key out of a create-items response, whether the
    item was newly written (``successful``/``success``) or already present
    (``unchanged``)."""
    for bucket in ("successful", "success", "unchanged"):
        section = payload.get(bucket)
        if not isinstance(section, dict):
            continue
        for val in section.values():
            if isinstance(val, str) and re.fullmatch(r"[A-Z0-9]{8}", val):
                return val
            if isinstance(val, dict):
                key = val.get("key") or (val.get("data") or {}).get("key")
                if key:
                    return key
    return None


def _zotero_data(payload: dict) -> dict | None:
    """Return the full Zotero item ``data`` block if present (fresh add)."""
    section = payload.get("successful")
    if isinstance(section, dict):
        for val in section.values():
            if isinstance(val, dict) and isinstance(val.get("data"), dict):
                return val["data"]
    return None


def zotero_add(arxiv_id: str, collection: str, tags: list[str]) -> dict | None:
    """Add (idempotently) via the zotero_write MCP server; return the parsed
    JSON-RPC content payload, or None on failure."""
    args = {"arxiv_id": arxiv_id, "collection_key": collection, "tags": tags}
    with tempfile.NamedTemporaryFile(
        "w", suffix=".json", delete=False, encoding="utf-8"
    ) as fh:
        json.dump(args, fh)
        args_path = fh.name
    try:
        proc = subprocess.run(
            [sys.executable, MCP_CALL, "zotero_write", "zotero_add_item_by_arxiv",
             "--args-file", args_path],
            cwd=REPO_ROOT, text=True, encoding="utf-8",
            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        )
    finally:
        os.unlink(args_path)
    if proc.returncode != 0:
        print(f"  ! zotero add failed for {arxiv_id}: {proc.stderr.strip()}", flush=True)
        return None
    try:
        return json.loads(proc.stdout.strip())
    except json.JSONDecodeError:
        print(f"  ! could not parse zotero response for {arxiv_id}:\n{proc.stdout[:400]}",
              flush=True)
        return None


def existing_paper(session, arxiv_id: str, doi: str):
    rec = session.run(
        "MATCH (p:Paper) WHERE p.arxiv_id = $a OR ($d <> '' AND p.doi = $d) "
        "RETURN p.paper_key AS key, p.title AS title LIMIT 1",
        a=arxiv_id, d=doi or "",
    ).single()
    return (rec["key"], rec["title"]) if rec else None


UPSERT = """
MERGE (paper:Paper {paper_key: $paper_key})
SET paper.zotero_key = $paper_key,
    paper.arxiv_id = $arxiv_id,
    paper.doi = $doi,
    paper.title = $title,
    paper.abstract = $abstract,
    paper.year = $year,
    paper.date = $year,
    paper.url = $url,
    paper.source = 'zotero',
    paper.item_type = 'preprint',
    paper.title_key = $title_key,
    paper.updated_at = datetime()
MERGE (c:Collection {collection_key: $collection})
  ON CREATE SET c.name = 'null-edge-lit'
MERGE (paper)-[:IN_COLLECTION]->(c)
FOREACH (aname IN $authors |
  MERGE (a:Author {name: aname})
  MERGE (paper)-[:AUTHORED_BY]->(a))
FOREACH (tname IN $tags |
  MERGE (t:Tag {name: tname})
  MERGE (paper)-[:HAS_TAG]->(t))
"""


def upsert_node(session, meta: dict, collection: str) -> None:
    session.run(
        UPSERT,
        paper_key=meta["paper_key"], arxiv_id=meta["arxiv_id"], doi=meta.get("doi", ""),
        title=meta["title"], abstract=meta.get("abstract", ""), year=meta.get("year", ""),
        url=meta.get("url", ""), title_key=title_key(meta["title"]),
        authors=meta.get("authors", []), tags=meta.get("tags", []), collection=collection,
    )


def jobs_from_staging(path: str, extra_tags: list[str], collection: str):
    out = []
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            row = json.loads(line)
            if str(row.get("decision", "")).upper() != "INCLUDE":
                continue
            aid = row.get("arxiv_id")
            if not aid:
                continue
            tags = sorted(set(["null-edge", *extra_tags, *row.get("suggested_tags", [])]))
            out.append((aid, tags, row.get("suggested_collection") or collection))
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("arxiv_ids", nargs="*", help="arXiv ids to ingest")
    ap.add_argument("--from-staging", help="read INCLUDE rows from a staging.jsonl file")
    ap.add_argument("--collection", default=DEFAULT_COLLECTION,
                    help=f"Zotero/Neo4j collection key (default {DEFAULT_COLLECTION})")
    ap.add_argument("--tag", action="append", default=[],
                    help="extra tag applied to every paper; repeatable")
    ap.add_argument("--dry-run", action="store_true",
                    help="dedup-check only; no Zotero/Neo4j writes")
    ap.add_argument("--no-embed", action="store_true",
                    help="skip the final ensure_embeddings() step")
    ap.add_argument("--force", action="store_true",
                    help="ingest even if the paper is already in the graph")
    ns = ap.parse_args()

    jobs = [(aid, sorted(set(["null-edge", *ns.tag])), ns.collection) for aid in ns.arxiv_ids]
    if ns.from_staging:
        jobs += jobs_from_staging(ns.from_staging, ns.tag, ns.collection)
    if not jobs:
        ap.error("provide arXiv ids or --from-staging")

    driver, db = nps._driver()
    added = skipped = failed = 0
    try:
        with driver.session(database=db) as session:
            for raw_id, tags, collection in jobs:
                arxiv_id = normalize_arxiv(raw_id)
                meta = fetch_arxiv_meta(arxiv_id) or {}
                doi = meta.get("doi", "")
                hit = existing_paper(session, arxiv_id, doi)
                if hit and not ns.force:
                    print(f"skip  {arxiv_id}: already in graph [{hit[0]}] {hit[1]}", flush=True)
                    skipped += 1
                    continue
                if ns.dry_run:
                    print(f"would-add  {arxiv_id}: {meta.get('title', '(no metadata)')}", flush=True)
                    continue
                payload = zotero_add(arxiv_id, collection, tags)
                if payload is None:
                    failed += 1
                    continue
                key = _scan_zotero_key(payload)
                if not key:
                    print(f"  ! no Zotero key returned for {arxiv_id}; skipping node", flush=True)
                    failed += 1
                    continue
                # Prefer Zotero's normalized metadata; fall back to the arXiv fetch.
                zdata = _zotero_data(payload) or {}
                node = {
                    "paper_key": key,
                    "arxiv_id": arxiv_id,
                    "doi": (zdata.get("DOI") or doi or ""),
                    "title": (zdata.get("title") or meta.get("title") or ""),
                    "abstract": (zdata.get("abstractNote") or meta.get("abstract") or ""),
                    "year": ((zdata.get("date") or meta.get("year") or "")[:4]),
                    "url": (meta.get("url") or zdata.get("url") or ""),
                    "authors": ([c.get("name") for c in zdata.get("creators", []) if c.get("name")]
                                or meta.get("authors", [])),
                    "tags": tags,
                }
                if not node["title"]:
                    print(f"  ! no title for {arxiv_id}; skipping node", flush=True)
                    failed += 1
                    continue
                upsert_node(session, node, collection)
                print(f"added {arxiv_id}: [{key}] {node['title']}", flush=True)
                added += 1
    finally:
        driver.close()

    print(f"\nsummary: added={added} skipped={skipped} failed={failed}", flush=True)
    if added and not ns.no_embed and not ns.dry_run:
        nps.ensure_embeddings()
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
