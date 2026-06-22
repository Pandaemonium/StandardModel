"""Semantic vector search over the StandardModel repo's OWN documents (Neo4j).

The `coglab` graph is shared with other projects (AutoLab). To stay isolated,
this ingests *this repo's* prose (Sources/, AgentTasks/, docs/, top-level *.md)
and Lean source (PhysicsSM/**/*.lean) under project-scoped labels - `:NEDoc`
(source file) and `:NEChunk` (a chunk), both `project='null-edge'` - so they
never collide with AutoLab's `Doc`/`LeanFile`/`Chunk` nodes. Files are read FULL
from disk (the graph's 20k-char body cap does not apply). Long files are chunked
(markdown by heading, Lean by declaration, then size-windowed); each chunk is
embedded with `Qwen/Qwen3-Embedding-0.6B` on the Intel Arc (XPU) and indexed by a
native `VECTOR INDEX` `ne_chunk_embedding` (cosine). A query embeds the text with
the model's asymmetric "query" prompt and runs `db.index.vector.queryNodes`,
returning chunks with their parent file + heading.

Run with the lean-explore tool-env interpreter (it carries `+xpu` torch,
`sentence-transformers`, the cached model, and the `neo4j` driver):

    PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
    "$PY" Scripts/lit/neo4j_doc_search.py --dry-run     # list files + chunk counts, no writes/model
    "$PY" Scripts/lit/neo4j_doc_search.py               # ingest changed files + build index
    "$PY" Scripts/lit/neo4j_doc_search.py --reembed     # re-ingest everything
    "$PY" Scripts/lit/neo4j_doc_search.py --query "where is the Plucker mass determinant identity proved"
    "$PY" Scripts/lit/neo4j_doc_search.py --query "Dirac slash" --format markdown

Ingest is idempotent: a file is re-chunked only when its content hash (`sha`)
changes, so re-runs are cheap. Neo4j connection comes from the env: NEO4J_URI,
NEO4J_USERNAME, NEO4J_PASSWORD, NEO4J_DATABASE.
"""

import argparse
import hashlib
import json
import os
import re
import sys
from pathlib import Path

os.environ.setdefault("HF_HUB_OFFLINE", "1")
os.environ.setdefault("TRANSFORMERS_OFFLINE", "1")
os.environ.setdefault("TQDM_DISABLE", "1")
os.environ.setdefault("HF_HUB_DISABLE_PROGRESS_BARS", "1")

from neo4j import GraphDatabase  # lightweight; torch/sentence-transformers lazy

REPO = Path(__file__).resolve().parents[2]
MODEL_NAME = "Qwen/Qwen3-Embedding-0.6B"
EMB_DIM = 1024
DOC_LABEL = "NEDoc"
CHUNK_LABEL = "NEChunk"
INDEX_NAME = "ne_chunk_embedding"
PROJECT = "null-edge"
MAX_CHARS = 1800
OVERLAP = 200
BATCH = 64

MD_DIRS = ["Sources", "AgentTasks", "docs"]
LEAN_DIRS = ["PhysicsSM"]

# Build/vendor/extraction trees to never ingest. Aristotle submission bundles
# (aristotle-output / *extracted* / *project_aristotle*) contain nested duplicate
# copies of repo files, with paths that also blow past the Windows path limit.
EXCLUDE_PARTS = {
    ".lake", ".git", "node_modules", ".venv",
    "aristotle-output", "aristotle-submit",
}
EXCLUDE_SUBSTR = ("extracted", "project_aristotle")

# Lean lines that begin a declaration or its preamble (docstring/attribute).
DECL_RE = re.compile(
    r"^\s*(/--|/-!|@\[|theorem|lemma|def|noncomputable|structure|instance|"
    r"class|abbrev|inductive|example|namespace|section)\b"
)
DECL_NAME_RE = re.compile(
    r"^\s*(?:noncomputable\s+)?"
    r"(?:theorem|lemma|def|structure|instance|class|abbrev|inductive)\s+"
    r"([A-Za-z0-9_.']+)"
)
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


def _excluded(p: Path) -> bool:
    parts = p.parts
    if any(part in EXCLUDE_PARTS for part in parts):
        return True
    return any(sub in part for part in parts for sub in EXCLUDE_SUBSTR)


def iter_files():
    """All repo docs/lean to ingest, excluding build/vendor/extraction trees."""
    for p in sorted(REPO.glob("*.md")):
        yield p
    for d in MD_DIRS:
        for p in sorted((REPO / d).rglob("*.md")):
            if not _excluded(p):
                yield p
    for d in LEAN_DIRS:
        for p in sorted((REPO / d).rglob("*.lean")):
            if not _excluded(p):
                yield p


def _window(text: str):
    text = text.strip()
    if not text:
        return []
    if len(text) <= MAX_CHARS:
        return [text]
    out, i = [], 0
    while i < len(text):
        out.append(text[i : i + MAX_CHARS])
        i += MAX_CHARS - OVERLAP
    return out


def _chunk_markdown(text: str):
    """Split at heading lines; window long sections. Returns (heading, text)."""
    sections, cur, cur_h = [], [], ""

    def flush(h, lines):
        body = "\n".join(lines).strip()
        if body:
            sections.append((h, body))

    for line in text.splitlines():
        if line.lstrip().startswith("#"):
            flush(cur_h, cur)
            cur, cur_h = [line], line.strip("# ").strip()
        else:
            cur.append(line)
    flush(cur_h, cur)
    return [(h, w) for h, body in sections for w in _window(body)]


def _is_preamble(lines) -> bool:
    """True if `lines` so far contain only comments/attributes (no code yet)."""
    in_block = False
    for raw in lines:
        s = raw.strip()
        if not s:
            continue
        if in_block:
            if "-/" in s:
                in_block = False
            continue
        if s.startswith("/-"):
            in_block = "-/" not in s
            continue
        if s.startswith("--") or s.startswith("@["):
            continue
        return False
    return True


def _chunk_lean(text: str):
    """Split at declaration boundaries (keeping a decl's docstring/attrs with
    it), then window long declarations. Returns (decl_name, text)."""
    sections, cur, cur_name = [], [], ""

    def flush(name, lines):
        body = "\n".join(lines).strip()
        if body:
            sections.append((name, body))

    for line in text.splitlines():
        if DECL_RE.match(line) and cur and not _is_preamble(cur):
            flush(cur_name, cur)
            cur, cur_name = [line], ""
        else:
            cur.append(line)
        if not cur_name:
            m = DECL_NAME_RE.search(line)
            if m:
                cur_name = m.group(1)
    flush(cur_name, cur)
    return [(h, w) for h, body in sections for w in _window(body)]


def _chunks_for(path: Path, text: str):
    return _chunk_markdown(text) if path.suffix == ".md" else _chunk_lean(text)


def _title(path: Path, text: str) -> str:
    if path.suffix == ".md":
        for line in text.splitlines():
            if line.lstrip().startswith("# "):
                return line.strip("# ").strip()[:200]
        return path.stem
    return path.relative_to(REPO).as_posix()


def _read(path: Path):
    """Read text, or None if the file cannot be opened (e.g. long Windows path)."""
    try:
        return path.read_text(encoding="utf-8", errors="replace")
    except OSError as exc:
        print(f"  [skip] {path.name}: {exc}", file=sys.stderr)
        return None


def dry_run() -> None:
    files = list(iter_files())
    total, by_kind, biggest = 0, {"md": 0, "lean": 0}, []
    leaked = [p for p in files if ".lake" in p.parts]
    for p in files:
        text = _read(p)
        if text is None:
            continue
        ch = _chunks_for(p, text)
        total += len(ch)
        by_kind["lean" if p.suffix == ".lean" else "md"] += 1
        biggest.append((len(ch), p.relative_to(REPO).as_posix()))
    biggest.sort(reverse=True)
    print(f"files: {len(files)}  ({by_kind['md']} md, {by_kind['lean']} lean)")
    print(f"total chunks: {total}")
    print(f".lake leakage (must be 0): {len(leaked)}")
    print("largest:")
    for n, rel in biggest[:10]:
        print(f"  {n:4d}  {rel}")


def _setup(session) -> None:
    session.run(
        f"CREATE CONSTRAINT ne_doc_path IF NOT EXISTS "
        f"FOR (d:{DOC_LABEL}) REQUIRE d.path IS UNIQUE"
    )
    session.run(
        f"CREATE CONSTRAINT ne_chunk_key IF NOT EXISTS "
        f"FOR (c:{CHUNK_LABEL}) REQUIRE c.chunk_key IS UNIQUE"
    )
    session.run(
        f"CREATE VECTOR INDEX {INDEX_NAME} IF NOT EXISTS "
        f"FOR (c:{CHUNK_LABEL}) ON (c.embedding) "
        f"OPTIONS {{indexConfig: {{"
        f"`vector.dimensions`: {EMB_DIM}, `vector.similarity_function`: 'cosine'}}}}"
    )


def ingest(reembed: bool) -> None:
    files = list(iter_files())
    driver, db = _driver()
    model = None
    try:
        with driver.session(database=db) as session:
            _setup(session)
            changed = total_chunks = 0
            for p in files:
                text = _read(p)
                if text is None:
                    continue
                sha = hashlib.sha256(text.encode("utf-8")).hexdigest()
                relp = p.relative_to(REPO).as_posix()

                row = session.run(
                    f"MATCH (d:{DOC_LABEL} {{path: $path}}) "
                    f"OPTIONAL MATCH (d)-[:HAS_CHUNK]->(c:{CHUNK_LABEL}) "
                    "RETURN d.sha AS sha, count(c) AS n",
                    path=relp,
                ).single()
                if not reembed and row and row["sha"] == sha and row["n"] > 0:
                    continue

                ch = _chunks_for(p, text)
                if not ch:
                    continue

                # Upsert the doc node and clear any old chunks.
                session.run(
                    f"MERGE (d:{DOC_LABEL} {{path: $path}}) "
                    "SET d.project = $proj, d.kind = $kind, d.title = $title, d.sha = $sha "
                    f"WITH d OPTIONAL MATCH (d)-[:HAS_CHUNK]->(c:{CHUNK_LABEL}) DETACH DELETE c",
                    path=relp,
                    proj=PROJECT,
                    kind=("lean" if p.suffix == ".lean" else "md"),
                    title=_title(p, text),
                    sha=sha,
                )

                if model is None:
                    from sentence_transformers import SentenceTransformer

                    dev = _device()
                    print(f"loading {MODEL_NAME} on {dev} ...", flush=True)
                    model = SentenceTransformer(MODEL_NAME, device=dev)
                    if int(model.get_sentence_embedding_dimension()) != EMB_DIM:
                        raise SystemExit("embedding dim mismatch; update EMB_DIM")

                vecs = model.encode(
                    [c[1] for c in ch],
                    normalize_embeddings=True,
                    convert_to_numpy=True,
                    batch_size=BATCH,
                )
                rows = [
                    {
                        "ckey": f"{relp}#{i}",
                        "ord": i,
                        "heading": (ch[i][0] or "")[:200],
                        "text": ch[i][1],
                        "vec": [float(x) for x in vecs[i]],
                    }
                    for i in range(len(ch))
                ]
                session.run(
                    f"MATCH (d:{DOC_LABEL} {{path: $path}}) "
                    "UNWIND $rows AS row "
                    f"CREATE (d)-[:HAS_CHUNK]->(c:{CHUNK_LABEL} {{"
                    "chunk_key: row.ckey, project: $proj, path: $path, ord: row.ord, "
                    "heading: row.heading, text: row.text, embedding: row.vec})",
                    path=relp,
                    proj=PROJECT,
                    rows=rows,
                )
                changed += 1
                total_chunks += len(ch)
                print(f"  {relp}: {len(ch)} chunks", flush=True)

            if changed == 0:
                print("no changed files; vector index ensured", flush=True)
            else:
                print(
                    f"ingested {changed} files, {total_chunks} chunks; "
                    f"vector index '{INDEX_NAME}' ensured",
                    flush=True,
                )
    finally:
        driver.close()


def query_results(text: str, k: int):
    _require_env()

    from sentence_transformers import SentenceTransformer

    model = SentenceTransformer(MODEL_NAME, device=_device())
    qvec = model.encode(
        [text], prompt_name="query", normalize_embeddings=True, convert_to_numpy=True
    )[0]
    qvec = [float(x) for x in qvec]

    driver, db = _driver()
    try:
        with driver.session(database=db) as session:
            results = session.run(
                f"CALL db.index.vector.queryNodes('{INDEX_NAME}', $k, $vec) "
                "YIELD node, score "
                "WHERE node.project = $project "
                "RETURN node.path AS path, node.heading AS heading, node.text AS text, "
                "score ORDER BY score DESC",
                k=k,
                vec=qvec,
                project=PROJECT,
            ).data()
    finally:
        driver.close()
    return results


def _print_text(text: str, results) -> None:
    print(f'\nTop {len(results)} chunks for: "{text}"\n')
    for r in results:
        head = f"  [{r['heading']}]" if r.get("heading") else ""
        snippet = " ".join((r["text"] or "").split())[:180]
        print(f"  {r['score']:.3f}  {r['path']}{head}\n         {snippet}")


def _print_markdown(text: str, results) -> None:
    print(f"# Repo semantic search\n\nQuery: `{text}`\n")
    for i, r in enumerate(results, 1):
        heading = f" [{r['heading']}]" if r.get("heading") else ""
        print(f"## {i}. {r['path']}{heading}")
        print(f"\nScore: `{r['score']:.3f}`\n")
        print("```text")
        print((r.get("text") or "").strip())
        print("```\n")


def query(text: str, k: int, fmt: str) -> None:
    results = query_results(text, k)
    if fmt == "json":
        print(json.dumps({"query": text, "results": results}, indent=2, ensure_ascii=False))
    elif fmt == "markdown":
        _print_markdown(text, results)
    else:
        _print_text(text, results)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--query", help="natural-language search; omit to ingest")
    ap.add_argument("--reembed", action="store_true", help="re-ingest all files")
    ap.add_argument("--dry-run", action="store_true", help="list files + chunk counts, no writes")
    ap.add_argument("--k", type=int, default=10, help="number of search results")
    ap.add_argument(
        "--format",
        choices=("text", "json", "markdown"),
        default="text",
        help="query output format",
    )
    ns = ap.parse_args()

    if ns.dry_run:
        dry_run()
    elif ns.query:
        query(ns.query, ns.k, ns.format)
    else:
        ingest(ns.reembed)


if __name__ == "__main__":
    main()
