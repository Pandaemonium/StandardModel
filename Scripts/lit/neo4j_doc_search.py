"""Semantic vector search over the StandardModel repo's OWN documents (Neo4j).

The `coglab` graph is shared with other projects (AutoLab). To stay isolated,
this ingests *this repo's* prose (Markdown and LaTeX under Sources/,
AgentTasks/, docs/, AutonomousLab/, plus top-level Markdown)
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
    "$PY" Scripts/lit/neo4j_doc_search.py               # ingest (sha-skips unchanged) + build index
    "$PY" Scripts/lit/neo4j_doc_search.py --changed     # fast: only git-changed files (avoids full per-file scan)
    "$PY" Scripts/lit/neo4j_doc_search.py --path Sources/Paper.tex  # targeted refresh
    "$PY" Scripts/lit/neo4j_doc_search.py --reembed     # re-ingest everything
    "$PY" Scripts/lit/neo4j_doc_search.py --exact-path PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean
    "$PY" Scripts/lit/neo4j_doc_search.py --exact-declaration plucker_mass_operator
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
import subprocess
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

MD_DIRS = ["Sources", "AgentTasks", "docs", "AutonomousLab"]
LEAN_DIRS = ["PhysicsSM"]
PROSE_SUFFIXES = {".md", ".tex"}

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


def _git_changed_paths():
    """Resolved paths of git-changed files (staged, unstaged, untracked), or None
    if git is unavailable. Used by --changed to skip the full per-file scan."""
    try:
        res = subprocess.run(
            ["git", "-C", str(REPO), "status", "--porcelain"],
            capture_output=True, text=True, check=True,
        )
    except (OSError, subprocess.CalledProcessError) as exc:
        print(f"  [changed] git status failed ({exc}); falling back to full scan",
              file=sys.stderr)
        return None
    paths = set()
    for line in res.stdout.splitlines():
        if not line.strip():
            continue
        entry = line[3:]  # strip the two status columns + space
        if " -> " in entry:  # rename/copy: take the destination path
            entry = entry.split(" -> ", 1)[1]
        entry = entry.strip().strip('"')
        paths.add((REPO / entry).resolve())
    return paths


def _ingestible(p: Path) -> bool:
    """Whether a resolved repository path belongs to an indexed source root."""
    try:
        rel = p.resolve().relative_to(REPO.resolve())
    except ValueError:
        return False
    if _excluded(rel):
        return False
    if len(rel.parts) == 1:
        return rel.suffix.lower() == ".md"
    root = rel.parts[0]
    return ((root in MD_DIRS and rel.suffix.lower() in PROSE_SUFFIXES) or
            (root in LEAN_DIRS and rel.suffix.lower() == ".lean"))


def iter_files(changed_only: bool = False):
    """Repo docs/lean to ingest, excluding build/vendor/extraction trees. With
    `changed_only`, restrict to git-changed files (cheap incremental refresh)."""
    changed = _git_changed_paths() if changed_only else None

    if changed is not None:
        candidates: set[Path] = set()
        for path in changed:
            if path.is_file():
                if _ingestible(path):
                    candidates.add(path)
                continue
            if not path.is_dir() or _excluded(path):
                continue
            for child in path.rglob("*"):
                if child.is_file() and _ingestible(child):
                    candidates.add(child)
        yield from sorted(candidates)
        return

    def keep(p: Path) -> bool:
        return True

    for p in sorted(REPO.glob("*.md")):
        if keep(p):
            yield p
    for d in MD_DIRS:
        prose = [
            p
            for suffix in PROSE_SUFFIXES
            for p in (REPO / d).rglob(f"*{suffix}")
        ]
        for p in sorted(prose):
            if not _excluded(p) and keep(p):
                yield p
    for d in LEAN_DIRS:
        for p in sorted((REPO / d).rglob("*.lean")):
            if not _excluded(p) and keep(p):
                yield p


def selected_files(paths: list[str]) -> list[Path]:
    """Validate and resolve explicitly selected repository files."""
    selected = []
    for raw in paths:
        path = (REPO / _normalize_repo_path(raw)).resolve()
        if not path.is_file():
            raise SystemExit(f"Selected path is not a file: {raw}")
        if not _ingestible(path):
            raise SystemExit(f"Selected path is outside indexed source roots: {raw}")
        selected.append(path)
    return sorted(set(selected))


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


LATEX_SECTION_RE = re.compile(
    r"^\\(?P<level>part|chapter|section|subsection|subsubsection)\*?"
    r"\{(?P<title>[^}]*)\}"
)


def _chunk_latex(text: str):
    """Split LaTeX prose at section commands, then window long sections."""
    sections, cur, cur_h = [], [], "preamble"

    def flush(heading, lines):
        body = "\n".join(lines).strip()
        if body:
            sections.append((heading, body))

    for line in text.splitlines():
        match = LATEX_SECTION_RE.match(line.strip())
        if match:
            flush(cur_h, cur)
            cur = [line]
            cur_h = match.group("title").strip() or match.group("level")
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
    if path.suffix == ".lean":
        return _chunk_lean(text)
    if path.suffix == ".tex":
        return _chunk_latex(text)
    return _chunk_markdown(text)


def _title(path: Path, text: str) -> str:
    if path.suffix == ".md":
        for line in text.splitlines():
            if line.lstrip().startswith("# "):
                return line.strip("# ").strip()[:200]
        return path.stem
    if path.suffix == ".tex":
        match = re.search(r"\\title\{([^}]*)\}", text)
        return (match.group(1).strip() if match else path.stem)[:200]
    return path.relative_to(REPO).as_posix()


def _read(path: Path):
    """Read text, or None if the file cannot be opened (e.g. long Windows path)."""
    try:
        return path.read_text(encoding="utf-8", errors="replace")
    except OSError as exc:
        print(f"  [skip] {path.name}: {exc}", file=sys.stderr)
        return None


def dry_run(changed_only: bool = False, selected_paths: list[str] | None = None) -> None:
    files = (
        selected_files(selected_paths)
        if selected_paths
        else list(iter_files(changed_only=changed_only))
    )
    total, by_kind, biggest = 0, {"md": 0, "tex": 0, "lean": 0}, []
    leaked = [p for p in files if ".lake" in p.parts]
    for p in files:
        text = _read(p)
        if text is None:
            continue
        ch = _chunks_for(p, text)
        total += len(ch)
        kind = "lean" if p.suffix == ".lean" else "tex" if p.suffix == ".tex" else "md"
        by_kind[kind] += 1
        biggest.append((len(ch), p.relative_to(REPO).as_posix()))
    biggest.sort(reverse=True)
    print(
        f"files: {len(files)}  "
        f"({by_kind['md']} md, {by_kind['tex']} tex, {by_kind['lean']} lean)"
    )
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


def ingest(
    reembed: bool,
    changed_only: bool = False,
    selected_paths: list[str] | None = None,
) -> None:
    files = (
        selected_files(selected_paths)
        if selected_paths
        else list(iter_files(changed_only=changed_only))
    )
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
                    kind=(
                        "lean" if p.suffix == ".lean"
                        else "tex" if p.suffix == ".tex"
                        else "md"
                    ),
                    title=_title(p, text),
                    sha=sha,
                )

                if model is None:
                    from sentence_transformers import SentenceTransformer

                    dev = _device()
                    print(f"loading {MODEL_NAME} on {dev} ...", flush=True)
                    model = SentenceTransformer(MODEL_NAME, device=dev)
                    if int(model.get_embedding_dimension()) != EMB_DIM:
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


def _normalize_repo_path(path: str) -> str:
    """Normalize a user-supplied repository-relative path for exact lookup."""
    normalized = path.replace("\\", "/")
    while normalized.startswith("./"):
        normalized = normalized[2:]
    return normalized


def exact_results(path: str | None, declaration: str | None):
    """Return deterministic graph records by exact path and/or declaration.

    Unlike semantic vector search, this route does not load an embedding model
    and is suitable for Archivist known-answer checks. A path-only lookup
    returns one document summary. A declaration lookup returns every exactly
    named declaration chunk, optionally restricted to one repository path.
    """
    if path is None and declaration is None:
        raise ValueError("exact lookup requires a path or declaration")

    normalized_path = _normalize_repo_path(path) if path is not None else None
    driver, db = _driver()
    try:
        with driver.session(database=db) as session:
            if declaration is None:
                return session.run(
                    f"MATCH (d:{DOC_LABEL} {{project: $project, path: $path}}) "
                    f"OPTIONAL MATCH (d)-[:HAS_CHUNK]->(c:{CHUNK_LABEL}) "
                    "RETURN d.path AS path, d.title AS title, d.kind AS kind, "
                    "d.sha AS sha, count(c) AS chunk_count",
                    project=PROJECT,
                    path=normalized_path,
                ).data()

            return session.run(
                f"MATCH (d:{DOC_LABEL} {{project: $project}})-[:HAS_CHUNK]->"
                f"(c:{CHUNK_LABEL} {{project: $project, heading: $declaration}}) "
                "WHERE $path IS NULL OR d.path = $path "
                "RETURN d.path AS path, d.sha AS sha, c.heading AS declaration, "
                "c.ord AS ord, c.text AS text ORDER BY d.path, c.ord",
                project=PROJECT,
                path=normalized_path,
                declaration=declaration,
            ).data()
    finally:
        driver.close()


def exact(path: str | None, declaration: str | None, fmt: str) -> None:
    results = exact_results(path, declaration)
    payload = {"path": path, "declaration": declaration, "results": results}
    if fmt == "json":
        print(json.dumps(payload, indent=2, ensure_ascii=False))
        return

    label = declaration or _normalize_repo_path(path or "")
    print(f'\nExact repository records for: "{label}"\n')
    for row in results:
        if declaration is None:
            print(
                f"  {row['path']}  kind={row['kind']}  "
                f"chunks={row['chunk_count']}  sha={row['sha']}"
            )
        else:
            snippet = " ".join((row.get("text") or "").split())[:180]
            print(f"  {row['path']}#{row['ord']} [{row['declaration']}]\n         {snippet}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--query", help="natural-language search; omit to ingest")
    ap.add_argument(
        "--exact-path",
        help="deterministic repository-relative path lookup; may restrict "
        "--exact-declaration",
    )
    ap.add_argument(
        "--exact-declaration",
        help="deterministic exact Lean declaration-heading lookup (no embedding model)",
    )
    ap.add_argument("--reembed", action="store_true", help="re-ingest all files")
    ap.add_argument(
        "--path",
        action="append",
        default=[],
        help="refresh one repository-relative file; repeat for multiple files",
    )
    ap.add_argument(
        "--changed",
        action="store_true",
        help="ingest only git-changed files (staged/unstaged/untracked); fast "
        "incremental refresh after a few edits",
    )
    ap.add_argument("--dry-run", action="store_true", help="list files + chunk counts, no writes")
    ap.add_argument("--k", type=int, default=10, help="number of search results")
    ap.add_argument(
        "--format",
        choices=("text", "json", "markdown"),
        default="text",
        help="query output format",
    )
    ns = ap.parse_args()

    if ns.changed and ns.path:
        ap.error("--changed and --path are mutually exclusive")

    if ns.dry_run:
        dry_run(changed_only=ns.changed, selected_paths=ns.path)
    elif ns.exact_path or ns.exact_declaration:
        exact(ns.exact_path, ns.exact_declaration, ns.format)
    elif ns.query:
        query(ns.query, ns.k, ns.format)
    else:
        ingest(ns.reembed, changed_only=ns.changed, selected_paths=ns.path)


if __name__ == "__main__":
    main()
