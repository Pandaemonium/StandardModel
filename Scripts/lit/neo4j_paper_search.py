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


def query(text: str, k: int, fmt: str, collections, all_projects: bool) -> None:
    results = query_results(text, k, collections=collections, all_projects=all_projects)
    scoped = not all_projects
    if fmt == "json":
        print(
            json.dumps(
                {
                    "query": text,
                    "scope": "all-projects" if all_projects else list(collections),
                    "results": results,
                },
                indent=2,
                ensure_ascii=False,
            )
        )
    elif fmt == "markdown":
        _print_markdown(text, results, scoped)
    else:
        _print_text(text, results, scoped)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--query", help="natural-language search; omit to ingest")
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

    if ns.query:
        collections = ns.collection or list(NULL_EDGE_COLLECTIONS)
        query(ns.query, ns.k, ns.format, collections, ns.all_projects)
    else:
        ensure_embeddings(ns.reembed)


if __name__ == "__main__":
    main()
