"""Semantic vector search over the Neo4j paper graph (coglab).

Embeds each `Paper` node's title+abstract with `Qwen/Qwen3-Embedding-0.6B` on
the Intel Arc (XPU), stores the vector on the node, and maintains a Neo4j native
`VECTOR INDEX`. A query embeds the natural-language text (with the model's
asymmetric "query" prompt) and runs `db.index.vector.queryNodes`, so semantic
search is fused with the existing graph (authors, tags, claims, collections).

Run with the lean-explore tool-env interpreter (it carries `+xpu` torch,
`sentence-transformers`, the cached embedding model, and the `neo4j` driver):

    PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
    "$PY" Scripts/lit/neo4j_paper_search.py                 # embed new papers + ensure index
    "$PY" Scripts/lit/neo4j_paper_search.py --reembed       # re-embed everything
    "$PY" Scripts/lit/neo4j_paper_search.py --query "celestial holography soft theorems"
    "$PY" Scripts/lit/neo4j_paper_search.py --query "spin foam simplicity" --format markdown

`ensure_embeddings()` is importable so an ingest step can call it as its final
action; it is idempotent and cheap when nothing is new (it skips the model load
entirely when every Paper already has an embedding).

Neo4j connection comes from the env: NEO4J_URI, NEO4J_USERNAME, NEO4J_PASSWORD,
NEO4J_DATABASE (the MCP server's own credentials).

Query mode is scoped to the null-edge collections (`9W59V3K9`, `null-edge-lit`)
by default. Pass `--all-projects` only when shared-graph recall is intentional.
"""

import argparse
import json
import os
import re
import sys

# Models are cached; keep HuggingFace offline and quiet.
os.environ.setdefault("HF_HUB_OFFLINE", "1")
os.environ.setdefault("TRANSFORMERS_OFFLINE", "1")
os.environ.setdefault("TQDM_DISABLE", "1")
os.environ.setdefault("HF_HUB_DISABLE_PROGRESS_BARS", "1")

from neo4j import GraphDatabase  # lightweight; torch + sentence-transformers are
                                 # imported lazily so the no-op path stays cheap.

MODEL_NAME = "Qwen/Qwen3-Embedding-0.6B"
EMB_DIM = 1024  # Qwen3-Embedding-0.6B output dimension
INDEX_NAME = "paper_embedding"
EMB_PROP = "embedding"
BATCH = 64
NULL_EDGE_COLLECTIONS = ("9W59V3K9", "null-edge-lit")
REQUIRED_ENV = ("NEO4J_URI", "NEO4J_USERNAME", "NEO4J_PASSWORD")


def _device() -> str:
    import torch

    return "xpu" if hasattr(torch, "xpu") and torch.xpu.is_available() else "cpu"


def _require_env() -> None:
    missing = [name for name in REQUIRED_ENV if not os.environ.get(name)]
    if missing:
        names = ", ".join(missing)
        raise SystemExit(
            f"Missing Neo4j environment variable(s): {names}. "
            "Run from a shell that has the Neo4j credentials, or use the MCP "
            "server/session wrapper documented in Scripts/MCP_SERVERS.md."
        )


def _driver():
    _require_env()
    uri = os.environ["NEO4J_URI"]
    auth = (os.environ["NEO4J_USERNAME"], os.environ["NEO4J_PASSWORD"])
    return GraphDatabase.driver(uri, auth=auth), os.environ.get("NEO4J_DATABASE", "neo4j")


def _doc_text(title, abstract) -> str:
    title = (title or "").strip()
    abstract = (abstract or "").strip()
    return f"{title}\n\n{abstract}".strip() if abstract else title


def _ensure_index(session) -> None:
    # Dimension is interpolated, not a param: index OPTIONS reject parameters.
    session.run(
        f"CREATE VECTOR INDEX {INDEX_NAME} IF NOT EXISTS "
        f"FOR (p:Paper) ON (p.{EMB_PROP}) "
        f"OPTIONS {{indexConfig: {{"
        f"`vector.dimensions`: {EMB_DIM}, `vector.similarity_function`: 'cosine'}}}}"
    )


def ensure_embeddings(reembed: bool = False) -> int:
    """Embed Paper nodes lacking an embedding (or all, if reembed); ensure the
    vector index. Idempotent; cheap when nothing is new (no model load). Returns
    the number of papers embedded. Safe as the final step of any paper ingest.
    """
    driver, db = _driver()
    try:
        with driver.session(database=db) as session:
            _ensure_index(session)
            where = "" if reembed else f"WHERE p.{EMB_PROP} IS NULL"
            rows = session.run(
                f"MATCH (p:Paper) {where} "
                "RETURN elementId(p) AS eid, p.title AS title, p.abstract AS abstract"
            ).data()
            if not rows:
                print("no papers need embedding; vector index ensured", flush=True)
                return 0

            from sentence_transformers import SentenceTransformer

            dev = _device()
            print(f"loading {MODEL_NAME} on {dev} for {len(rows)} papers ...", flush=True)
            model = SentenceTransformer(MODEL_NAME, device=dev)
            dim = int(model.get_sentence_embedding_dimension())
            if dim != EMB_DIM:
                raise SystemExit(
                    f"model dim {dim} != index dim {EMB_DIM}; "
                    "update EMB_DIM and rebuild the index"
                )

            done = 0
            for i in range(0, len(rows), BATCH):
                chunk = rows[i : i + BATCH]
                texts = [_doc_text(r["title"], r["abstract"]) for r in chunk]
                vecs = model.encode(
                    texts, normalize_embeddings=True, convert_to_numpy=True, batch_size=BATCH
                )
                payload = [
                    {"eid": r["eid"], "vec": [float(x) for x in v]}
                    for r, v in zip(chunk, vecs)
                ]
                session.run(
                    "UNWIND $rows AS row "
                    f"MATCH (p) WHERE elementId(p) = row.eid SET p.{EMB_PROP} = row.vec",
                    rows=payload,
                )
                done += len(chunk)
                print(f"  embedded {done}/{len(rows)}", flush=True)

            print(f"done: embedded {done} papers; vector index ensured", flush=True)
            return done
    finally:
        driver.close()


def query_results(
    text: str,
    k: int,
    collections=None,
    all_projects: bool = False,
):
    _require_env()

    from sentence_transformers import SentenceTransformer

    model = SentenceTransformer(MODEL_NAME, device=_device())
    # Qwen3-Embedding is asymmetric: encode the search text with the query prompt.
    qvec = model.encode(
        [text], prompt_name="query", normalize_embeddings=True, convert_to_numpy=True
    )[0]
    qvec = [float(x) for x in qvec]
    collections = list(collections or NULL_EDGE_COLLECTIONS)
    candidate_k = k if all_projects else max(k * 8, 50)

    driver, db = _driver()
    try:
        with driver.session(database=db) as session:
            results = session.run(
                f"CALL db.index.vector.queryNodes('{INDEX_NAME}', $candidate_k, $vec) "
                "YIELD node, score "
                "OPTIONAL MATCH (node)-[:IN_COLLECTION]->(c:Collection) "
                "WITH node, score, collect(DISTINCT c.collection_key) AS collections "
                "WHERE $all_projects OR any(key IN collections WHERE key IN $collections) "
                "RETURN node.title AS title, node.arxiv_id AS arxiv, node.year AS year, "
                "node.paper_key AS key, node.doi AS doi, node.url AS url, "
                "node.abstract AS abstract, collections, score "
                "ORDER BY score DESC LIMIT $k",
                candidate_k=candidate_k,
                k=k,
                vec=qvec,
                collections=collections,
                all_projects=all_projects,
            ).data()
    finally:
        driver.close()
    return results


CHUNK_INDEX = "paper_chunk_embedding"


def query_chunks(
    text: str,
    k: int,
    collections=None,
    all_projects: bool = False,
):
    """Full-text search over :PaperChunk nodes (paper *body* text), scoped via the
    parent :Paper's collection. Complements query_results (abstract-level)."""
    _require_env()

    from sentence_transformers import SentenceTransformer

    model = SentenceTransformer(MODEL_NAME, device=_device())
    qvec = model.encode(
        [text], prompt_name="query", normalize_embeddings=True, convert_to_numpy=True
    )[0]
    qvec = [float(x) for x in qvec]
    collections = list(collections or NULL_EDGE_COLLECTIONS)
    candidate_k = k if all_projects else max(k * 8, 50)

    driver, db = _driver()
    try:
        with driver.session(database=db) as session:
            results = session.run(
                f"CALL db.index.vector.queryNodes('{CHUNK_INDEX}', $candidate_k, $vec) "
                "YIELD node, score "
                "MATCH (p:Paper)-[:HAS_CHUNK]->(node) "
                "OPTIONAL MATCH (p)-[:IN_COLLECTION]->(c:Collection) "
                "WITH node, score, p, collect(DISTINCT c.collection_key) AS collections "
                "WHERE $all_projects OR any(key IN collections WHERE key IN $collections) "
                "RETURN p.title AS title, p.arxiv_id AS arxiv, p.paper_key AS key, "
                "node.section AS section, node.ord AS ord, node.text AS text, score "
                "ORDER BY score DESC LIMIT $k",
                candidate_k=candidate_k,
                k=k,
                vec=qvec,
                collections=collections,
                all_projects=all_projects,
            ).data()
    finally:
        driver.close()
    return results


def _print_chunks(text: str, results, scoped: bool) -> None:
    scope = "null-edge collections" if scoped else "all projects"
    print(f'\nTop {len(results)} chunks for: "{text}" ({scope})\n')
    for r in results:
        head = f" [{r['section']}]" if r.get("section") else ""
        loc = f"{r['title']} (arXiv:{r.get('arxiv')}, chunk {r.get('ord')})"
        print(f"  {r['score']:.3f}  {loc}{head}")
        snippet = " ".join((r.get("text") or "").split())
        print(f"        {snippet[:400]}\n")


def _print_text(text: str, results, scoped: bool) -> None:
    scope = "all projects" if not scoped else "null-edge collections"
    print(f'\nTop {len(results)} papers for: "{text}" ({scope})\n')
    for r in results:
        tag = f"  arXiv:{r['arxiv']}" if r.get("arxiv") else ""
        yr = f" ({r['year']})" if r.get("year") else ""
        key = f"  [{r['key']}]" if r.get("key") else ""
        print(f"  {r['score']:.3f}  {r['title']}{yr}{tag}{key}")


def _print_markdown(text: str, results, scoped: bool) -> None:
    scope = "null-edge collections" if scoped else "all projects"
    print(f"# Paper semantic search\n\nQuery: `{text}`\n\nScope: {scope}\n")
    for i, r in enumerate(results, 1):
        print(f"## {i}. {r.get('title') or '(untitled)'}")
        print(f"\nScore: `{r['score']:.3f}`")
        if r.get("key"):
            print(f"Zotero key: `{r['key']}`")
        if r.get("arxiv"):
            print(f"arXiv: `{r['arxiv']}`")
        if r.get("doi"):
            print(f"DOI: `{r['doi']}`")
        if r.get("url"):
            print(f"URL: {r['url']}")
        if r.get("abstract"):
            print("\nAbstract:")
            print((r.get("abstract") or "").strip())
        print()


def query(
    text: str, k: int, fmt: str, collections, all_projects: bool, chunks: bool = False
) -> None:
    if chunks:
        results = query_chunks(text, k, collections=collections, all_projects=all_projects)
    else:
        results = query_results(text, k, collections=collections, all_projects=all_projects)
    scoped = not all_projects
    if fmt == "json":
        print(
            json.dumps(
                {
                    "query": text,
                    "mode": "chunks" if chunks else "papers",
                    "scope": "all-projects" if all_projects else list(collections),
                    "results": results,
                },
                indent=2,
                ensure_ascii=False,
            )
        )
    elif chunks:
        _print_chunks(text, results, scoped)
    elif fmt == "markdown":
        _print_markdown(text, results, scoped)
    else:
        _print_text(text, results, scoped)


# --------------------------------------------------------------------------- #
# Full-text read (reconstruct a whole paper from its chunks)
# --------------------------------------------------------------------------- #
# Chunks are written by lit_fulltext.py with a 90-word overlap *inside* each
# section (WORDS_PER_CHUNK=600, WORD_OVERLAP=90); section changes start a fresh
# window with no overlap. To read a paper end to end we pull all its chunks in
# `ord` order and de-overlap consecutive same-section chunks. Scan a little above
# the nominal 90 for robustness.
MAX_OVERLAP_SCAN = 200


def fetch_chunks(ident: str):
    """Return (meta, rows) for a paper identified by arXiv id or paper_key.

    rows are PaperChunk dicts ordered by `ord`. `ident` is matched against both
    `arxiv_id` and `paper_key`; an arXiv version suffix (e.g. ``v2``) is stripped
    so ``1611.08388v2`` still resolves. Returns ``(None, [])`` if no chunks exist
    (the paper may be ingested abstract-only; run ``lit_fulltext.py`` to add body
    text).
    """
    _require_env()
    ident = ident.strip()
    bare = re.sub(r"v\d+$", "", ident)
    driver, db = _driver()
    try:
        with driver.session(database=db) as session:
            rows = session.run(
                "MATCH (p:Paper)-[:HAS_CHUNK]->(pc:PaperChunk) "
                "WHERE p.arxiv_id IN $ids OR p.paper_key = $ident "
                "RETURN p.title AS title, p.arxiv_id AS arxiv, p.paper_key AS key, "
                "pc.ord AS ord, pc.section AS section, pc.text AS text "
                "ORDER BY pc.ord",
                ids=[ident, bare],
                ident=ident,
            ).data()
    finally:
        driver.close()
    if not rows:
        return None, []
    meta = {
        "title": rows[0]["title"],
        "arxiv": rows[0]["arxiv"],
        "key": rows[0]["key"],
        "n": len(rows),
    }
    return meta, rows


def _overlap_len(a, b) -> int:
    """Largest L such that the last L words of `a` equal the first L words of `b`."""
    cap = min(len(a), len(b), MAX_OVERLAP_SCAN)
    for length in range(cap, 0, -1):
        if a[-length:] == b[:length]:
            return length
    return 0


def reconstruct_fulltext(rows, with_sections: bool = True) -> str:
    """Stitch ordered chunks back into readable body text.

    Consecutive same-section chunks are de-overlapped by detecting the shared
    boundary; section changes start a fresh segment. The result is the de-LaTeX'd
    prose the semantic index sees - good for reading or auditing a whole paper, not
    a substitute for the canonical PDF when quoting exact equations.
    """
    parts: list[str] = []
    prev_section = None
    prev_words: list[str] = []
    for r in rows:
        words = (r.get("text") or "").split()
        if not words:
            continue
        section = r.get("section") or ""
        if not parts:
            if with_sections and section:
                parts.append(f"## {section}\n\n")
            parts.append(" ".join(words))
        elif section != prev_section:
            parts.append(f"\n\n## {section}\n\n" if (with_sections and section) else "\n\n")
            parts.append(" ".join(words))
        else:
            tail = words[_overlap_len(prev_words, words):]
            if tail:
                parts.append(" " + " ".join(tail))
        prev_section = section
        prev_words = words
    return "".join(parts).strip()


def read_fulltext(ident: str, with_sections: bool = True):
    """Return a dict {title, arxiv, key, n, text} for one paper, or None."""
    meta, rows = fetch_chunks(ident)
    if not meta:
        return None
    meta = dict(meta)
    meta["text"] = reconstruct_fulltext(rows, with_sections=with_sections)
    return meta


def list_fulltext(collections=None, all_projects: bool = False):
    """List papers that have full-text chunks (with chunk counts), scoped to the
    null-edge collections by default."""
    _require_env()
    collections = list(collections or NULL_EDGE_COLLECTIONS)
    driver, db = _driver()
    try:
        with driver.session(database=db) as session:
            rows = session.run(
                "MATCH (p:Paper)-[:HAS_CHUNK]->(pc:PaperChunk) "
                "OPTIONAL MATCH (p)-[:IN_COLLECTION]->(c:Collection) "
                "WITH p, collect(DISTINCT c.collection_key) AS cols, count(pc) AS n "
                "WHERE $all_projects OR any(key IN cols WHERE key IN $collections) "
                "RETURN p.title AS title, p.arxiv_id AS arxiv, p.paper_key AS key, n "
                "ORDER BY p.arxiv_id",
                collections=collections,
                all_projects=all_projects,
            ).data()
    finally:
        driver.close()
    return rows


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--query", help="natural-language search; omit to ingest")
    ap.add_argument(
        "--chunks",
        action="store_true",
        help="search paper full-text chunks (:PaperChunk) instead of abstracts",
    )
    ap.add_argument(
        "--read",
        metavar="ARXIV_OR_KEY",
        help="reconstruct and print one paper's full text from its stored chunks "
        "(matches arXiv id or Zotero paper_key)",
    )
    ap.add_argument(
        "--list-fulltext",
        action="store_true",
        help="list papers that have full-text chunks (with chunk counts)",
    )
    ap.add_argument(
        "--save",
        metavar="PATH",
        help="with --read, also write the reconstructed text to PATH (UTF-8, LF)",
    )
    ap.add_argument(
        "--no-sections",
        action="store_true",
        help="with --read, omit reconstructed section headings",
    )
    ap.add_argument("--reembed", action="store_true", help="re-embed all papers, not just new ones")
    ap.add_argument("--k", type=int, default=10, help="number of search results")
    ap.add_argument(
        "--collection",
        action="append",
        default=None,
        help="collection key to include in scoped query; repeatable",
    )
    ap.add_argument(
        "--all-projects",
        action="store_true",
        help="search all Paper nodes instead of only null-edge collections",
    )
    ap.add_argument(
        "--format",
        choices=("text", "json", "markdown"),
        default="text",
        help="query output format",
    )
    ns = ap.parse_args()

    if ns.list_fulltext:
        rows = list_fulltext(
            collections=ns.collection, all_projects=ns.all_projects
        )
        if ns.format == "json":
            print(json.dumps({"count": len(rows), "papers": rows}, indent=2, ensure_ascii=False))
        else:
            print(f"\n{len(rows)} papers with full-text chunks\n")
            for r in rows:
                print(f"  {r['n']:>4} chunks  arXiv:{r.get('arxiv') or '-':<14} {r['title']}")
            print("\nRead one end to end with: --read <arXiv id or paper_key>")
    elif ns.read:
        paper = read_fulltext(ns.read, with_sections=not ns.no_sections)
        if not paper:
            raise SystemExit(
                f"No full-text chunks for '{ns.read}'. The paper may be abstract-only; "
                "add body text with Scripts/lit/lit_fulltext.py --ids <arxiv_id>."
            )
        if ns.format == "json":
            print(json.dumps(paper, indent=2, ensure_ascii=False))
        else:
            print(f"# {paper['title']}")
            print(f"arXiv:{paper.get('arxiv')}  paper_key:{paper.get('key')}  "
                  f"({paper['n']} chunks)\n")
            print(paper["text"])
        if ns.save:
            with open(ns.save, "w", encoding="utf-8", newline="\n") as handle:
                handle.write(f"# {paper['title']}\n")
                handle.write(f"arXiv:{paper.get('arxiv')}  paper_key:{paper.get('key')}"
                             f"  ({paper['n']} chunks)\n\n")
                handle.write(paper["text"] + "\n")
            print(f"\n[saved {len(paper['text'])} chars to {ns.save}]", file=sys.stderr)
    elif ns.query:
        collections = ns.collection or list(NULL_EDGE_COLLECTIONS)
        query(ns.query, ns.k, ns.format, collections, ns.all_projects, chunks=ns.chunks)
    else:
        ensure_embeddings(ns.reembed)


if __name__ == "__main__":
    main()
