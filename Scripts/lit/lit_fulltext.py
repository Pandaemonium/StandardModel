"""Add paper full text to the Neo4j graph as embedded, semantically-searchable chunks.

Companion to ``lit_ingest.py`` (which only stores title + abstract on each
``:Paper`` node). This script fetches the body text of each paper, splits it into
section-aware chunks, embeds every chunk with the *same* model used for paper
abstracts (``Qwen/Qwen3-Embedding-0.6B``, 1024-dim), and upserts:

    (:Paper)-[:HAS_CHUNK]->(:PaperChunk {
        chunk_key,   # "<arxiv_id>#<ord>"  (stable -> MERGE, no duplicates)
        paper_key, arxiv_id, ord, section, text, embedding
    })

plus a native ``VECTOR INDEX paper_chunk_embedding`` over ``PaperChunk.embedding``.
This keeps full-text retrieval distinct from the abstract-level ``paper_embedding``
index: use the abstract index to find *which* papers are relevant, the chunk index
to find *where in a paper* a result lives.

Source priority (arXiv corpus -> PDFs are the fallback, not the main path):

1. arXiv LaTeX e-print (``arxiv.org/e-print/<id>``): a gzipped tar of ``.tex``.
   Pure stdlib; cleaner than PDF text (real sections, math intact, no column /
   ligature / hyphenation garbage). Covers the arXiv majority.
2. PDF -> text fallback (non-arXiv, or LaTeX source unavailable). Requires
   ``pymupdf`` (``fitz``); if it is not installed the paper is reported skipped.

Nothing binary is written to the repo: raw downloads stay in memory (or a
gitignored cache); only chunks + embeddings persist, in Neo4j.

Run with the lean-explore tool-env interpreter (carries torch +
sentence-transformers + the cached model + the neo4j driver):

    PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
    "$PY" Scripts/lit/lit_fulltext.py                       # null-edge collection, new papers only
    "$PY" Scripts/lit/lit_fulltext.py --limit 5             # first 5 (smoke test)
    "$PY" Scripts/lit/lit_fulltext.py --ids 1611.08388 1011.0761
    "$PY" Scripts/lit/lit_fulltext.py --refresh             # re-chunk papers that already have chunks
    "$PY" Scripts/lit/lit_fulltext.py --dry-run --limit 3   # fetch + chunk, print counts, no writes

Neo4j credentials come from the env (NEO4J_URI / NEO4J_USERNAME / NEO4J_PASSWORD
[/ NEO4J_DATABASE]); same as the MCP server.
"""

from __future__ import annotations

import argparse
import gzip
import io
import os
import re
import sys
import tarfile
import time

import requests

HERE = os.path.dirname(os.path.abspath(__file__))

# Reuse the driver, model name, dim, and device selection from the abstract-level
# search module so chunk embeddings stay consistent with paper embeddings.
sys.path.insert(0, HERE)
import neo4j_paper_search as nps  # noqa: E402

DEFAULT_COLLECTION = "9W59V3K9"  # null-edge-lit
CHUNK_INDEX = "paper_chunk_embedding"
EPRINT_URL = "https://arxiv.org/e-print/{}"
USER_AGENT = "PhysicsSM-lit-fulltext/1.0 (mailto:blueshampoo@gmail.com)"
FETCH_DELAY_S = 3.0  # arXiv asks for ~1 request / 3s; be a polite citizen.

# Section-aware packing targets (word-based; ~1.4 tokens/word for this corpus).
WORDS_PER_CHUNK = 600
WORD_OVERLAP = 90

HEADING = "HEADING"  # private sentinel inserted for \section et al.


# --------------------------------------------------------------------------- #
# Fetch
# --------------------------------------------------------------------------- #
def fetch_eprint(arxiv_id: str) -> bytes | None:
    """Download the raw arXiv e-print blob (tar.gz, gz, or PDF)."""
    url = EPRINT_URL.format(arxiv_id)
    try:
        resp = requests.get(url, headers={"User-Agent": USER_AGENT}, timeout=60)
    except requests.RequestException as exc:
        print(f"  ! e-print fetch failed for {arxiv_id}: {exc}", flush=True)
        return None
    if resp.status_code != 200 or not resp.content:
        print(f"  ! e-print fetch HTTP {resp.status_code} for {arxiv_id}", flush=True)
        return None
    return resp.content


def latex_from_blob(blob: bytes) -> str | None:
    """Pull concatenated ``.tex`` source out of an arXiv e-print blob.

    Handles the three real shapes: a tar (optionally gzipped) of source files, a
    single gzipped ``.tex``, or a PDF (returns None so the caller can fall back).
    """
    if blob[:5] == b"%PDF-":
        return None
    # Try tar (gzip-transparent via "r:*").
    try:
        with tarfile.open(fileobj=io.BytesIO(blob), mode="r:*") as tar:
            texts = []
            for member in tar.getmembers():
                if not member.isfile() or not member.name.lower().endswith(".tex"):
                    continue
                fh = tar.extractfile(member)
                if fh is None:
                    continue
                texts.append(fh.read().decode("utf-8", errors="replace"))
            if texts:
                return _pick_main(texts)
    except tarfile.TarError:
        pass
    # Try single gzipped file (often one .tex with no extension preserved).
    try:
        raw = gzip.decompress(blob)
        return raw.decode("utf-8", errors="replace")
    except (OSError, EOFError):
        pass
    return None


def _pick_main(texts: list[str]) -> str:
    """Order source so the document with ``\\documentclass`` leads, then append
    the rest (multi-file papers \\input their sections)."""
    mains = [t for t in texts if "\\documentclass" in t]
    rest = [t for t in texts if "\\documentclass" not in t]
    return "\n\n".join(mains + rest)


def pdf_to_text(blob: bytes) -> str | None:
    """Fallback: extract text from a PDF blob via pymupdf, if available."""
    try:
        import fitz  # pymupdf
    except ImportError:
        print("  ! PDF fallback needs pymupdf (not installed); skipping", flush=True)
        return None
    try:
        with fitz.open(stream=blob, filetype="pdf") as doc:
            return "\n".join(page.get_text() for page in doc)
    except Exception as exc:  # malformed PDF
        print(f"  ! PDF text extraction failed: {exc}", flush=True)
        return None


# --------------------------------------------------------------------------- #
# De-LaTeX (heuristic, robust over correct)
# --------------------------------------------------------------------------- #
_COMMENT = re.compile(r"(?<!\\)%.*?$", re.MULTILINE)
_ENVS_DROP = ("figure", "figure*", "table", "table*", "thebibliography")
_SECTION = re.compile(r"\\(?:sub)*section\*?\s*\{([^}]*)\}")


def delatex(src: str) -> str:
    """Reduce LaTeX source to readable prose with heading sentinels for chunking."""
    src = _COMMENT.sub("", src)
    # Restrict to the document body if delimited.
    m = re.search(r"\\begin\{document\}(.*)\\end\{document\}", src, re.DOTALL)
    if m:
        src = m.group(1)
    for env in _ENVS_DROP:
        src = re.sub(
            rf"\\begin\{{{re.escape(env)}\}}.*?\\end\{{{re.escape(env)}\}}",
            " ",
            src,
            flags=re.DOTALL,
        )
    # Promote section headings to a sentinel we can split on later.
    src = _SECTION.sub(lambda mm: f"\n{HEADING}{mm.group(1).strip()}{HEADING}\n", src)
    # Drop remaining \begin/\end environment markers (keep their inner text).
    src = re.sub(r"\\(?:begin|end)\s*\{[^}]*\}", " ", src)
    # Drop labels/refs/cites that carry no prose value.
    src = re.sub(r"\\(?:label|ref|eqref|cite[a-z]*|input|include)\s*\{[^}]*\}", " ", src)
    # Strip a command but keep its braced argument text: \textbf{x} -> x.
    for _ in range(3):
        src = re.sub(r"\\[a-zA-Z@]+\*?(?:\[[^\]]*\])?\s*\{([^{}]*)\}", r"\1", src)
    # Remaining bare commands -> space; tidy stray braces.
    src = re.sub(r"\\[a-zA-Z@]+\*?", " ", src)
    src = src.replace("{", " ").replace("}", " ").replace("\\\\", " ")
    src = re.sub(r"[ \t]+", " ", src)
    src = re.sub(r"\n{2,}", "\n", src)
    return src.strip()


# --------------------------------------------------------------------------- #
# Chunking
# --------------------------------------------------------------------------- #
def chunk(text: str) -> list[tuple[str, str]]:
    """Return [(section, chunk_text), ...], packed section-aware with overlap."""
    # Split into (heading, body) segments on the sentinel.
    parts = text.split(HEADING)
    segments: list[tuple[str, str]] = []
    if len(parts) == 1:
        segments.append(("", parts[0]))
    else:
        # parts alternates: pre-text, heading, body, heading, body, ...
        if parts[0].strip():
            segments.append(("", parts[0]))
        i = 1
        while i < len(parts):
            heading = parts[i].strip()
            body = parts[i + 1] if i + 1 < len(parts) else ""
            segments.append((heading, body))
            i += 2

    out: list[tuple[str, str]] = []
    for section, body in segments:
        words = body.split()
        if not words:
            continue
        step = max(1, WORDS_PER_CHUNK - WORD_OVERLAP)
        for start in range(0, len(words), step):
            window = words[start : start + WORDS_PER_CHUNK]
            piece = " ".join(window).strip()
            if len(piece) >= 40:  # drop trivial tail fragments
                out.append((section[:200], piece))
            if start + WORDS_PER_CHUNK >= len(words):
                break
    return out


# --------------------------------------------------------------------------- #
# Neo4j
# --------------------------------------------------------------------------- #
def ensure_chunk_index(session) -> None:
    session.run(
        f"CREATE VECTOR INDEX {CHUNK_INDEX} IF NOT EXISTS "
        "FOR (pc:PaperChunk) ON (pc.embedding) "
        f"OPTIONS {{indexConfig: {{`vector.dimensions`: {nps.EMB_DIM}, "
        "`vector.similarity_function`: 'cosine'}}"
    )


def papers_in_scope(session, collection: str, ids: list[str] | None):
    if ids:
        rows = session.run(
            "MATCH (p:Paper) WHERE p.arxiv_id IN $ids "
            "RETURN p.paper_key AS key, p.arxiv_id AS arxiv, p.title AS title",
            ids=ids,
        ).data()
    else:
        rows = session.run(
            "MATCH (p:Paper)-[:IN_COLLECTION]->(c:Collection {collection_key: $col}) "
            "WHERE p.arxiv_id IS NOT NULL AND p.arxiv_id <> '' "
            "RETURN p.paper_key AS key, p.arxiv_id AS arxiv, p.title AS title "
            "ORDER BY p.arxiv_id",
            col=collection,
        ).data()
    return rows


def has_chunks(session, paper_key: str) -> bool:
    rec = session.run(
        "MATCH (:Paper {paper_key: $k})-[:HAS_CHUNK]->(pc:PaperChunk) "
        "RETURN count(pc) AS n",
        k=paper_key,
    ).single()
    return bool(rec and rec["n"] > 0)


def upsert_chunks(session, paper_key, arxiv_id, rows) -> None:
    # Clear prior chunks for a clean refresh, then re-create.
    session.run(
        "MATCH (:Paper {paper_key: $k})-[:HAS_CHUNK]->(pc:PaperChunk) DETACH DELETE pc",
        k=paper_key,
    )
    session.run(
        "MATCH (p:Paper {paper_key: $k}) "
        "UNWIND $rows AS row "
        "MERGE (pc:PaperChunk {chunk_key: row.chunk_key}) "
        "SET pc.paper_key = $k, pc.arxiv_id = $arxiv, pc.ord = row.ord, "
        "    pc.section = row.section, pc.text = row.text, pc.embedding = row.vec "
        "MERGE (p)-[:HAS_CHUNK]->(pc)",
        k=paper_key,
        arxiv=arxiv_id,
        rows=rows,
    )


# --------------------------------------------------------------------------- #
# Driver
# --------------------------------------------------------------------------- #
def get_text(arxiv_id: str) -> str | None:
    blob = fetch_eprint(arxiv_id)
    if blob is None:
        return None
    src = latex_from_blob(blob)
    if src is not None:
        text = delatex(src)
        if len(text) >= 500:  # sanity: a real body, not an empty/stub source
            return text
    # Fallback: the blob was a PDF, or LaTeX yielded too little.
    if blob[:5] == b"%PDF-":
        pdf_text = pdf_to_text(blob)
        if pdf_text:
            return re.sub(r"[ \t]+", " ", pdf_text).strip()
    return None


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    ap.add_argument("--collection", default=DEFAULT_COLLECTION,
                    help=f"collection key to scope (default {DEFAULT_COLLECTION})")
    ap.add_argument("--ids", nargs="*", help="explicit arXiv ids (overrides collection scope)")
    ap.add_argument("--limit", type=int, default=0, help="cap number of papers (0 = all)")
    ap.add_argument("--refresh", action="store_true",
                    help="re-chunk papers that already have chunks")
    ap.add_argument("--dry-run", action="store_true",
                    help="fetch + chunk + print counts; no embedding, no writes")
    ns = ap.parse_args()

    ids = [re.sub(r"v\d+$", "", i.strip()) for i in ns.ids] if ns.ids else None

    driver, db = nps._driver()
    model = None  # lazy-loaded on first paper that needs embedding
    added = skipped = failed = 0
    try:
        with driver.session(database=db) as session:
            if not ns.dry_run:
                ensure_chunk_index(session)
            papers = papers_in_scope(session, ns.collection, ids)
            if ns.limit:
                papers = papers[: ns.limit]
            print(f"{len(papers)} papers in scope", flush=True)

            for idx, p in enumerate(papers, 1):
                key, arxiv, title = p["key"], p["arxiv"], p["title"]
                if not ns.refresh and not ns.dry_run and has_chunks(session, key):
                    print(f"skip  {arxiv}: already chunked", flush=True)
                    skipped += 1
                    continue

                text = get_text(arxiv)
                time.sleep(FETCH_DELAY_S)
                if not text:
                    print(f"  ! no text for {arxiv}: {title}", flush=True)
                    failed += 1
                    continue

                pieces = chunk(text)
                if not pieces:
                    print(f"  ! no chunks for {arxiv}", flush=True)
                    failed += 1
                    continue

                if ns.dry_run:
                    print(f"would-chunk {arxiv}: {len(pieces)} chunks "
                          f"({len(text)} chars)  {title}", flush=True)
                    added += 1
                    continue

                if model is None:
                    from sentence_transformers import SentenceTransformer

                    dev = nps._device()
                    print(f"loading {nps.MODEL_NAME} on {dev} ...", flush=True)
                    model = SentenceTransformer(nps.MODEL_NAME, device=dev)
                    dim = int(model.get_sentence_embedding_dimension())
                    if dim != nps.EMB_DIM:
                        raise SystemExit(
                            f"model dim {dim} != index dim {nps.EMB_DIM}"
                        )

                texts = [pc[1] for pc in pieces]
                vecs = model.encode(
                    texts, normalize_embeddings=True, convert_to_numpy=True,
                    batch_size=nps.BATCH,
                )
                rows = [
                    {
                        "chunk_key": f"{arxiv}#{i}",
                        "ord": i,
                        "section": pieces[i][0],
                        "text": pieces[i][1],
                        "vec": [float(x) for x in v],
                    }
                    for i, v in enumerate(vecs)
                ]
                upsert_chunks(session, key, arxiv, rows)
                print(f"[{idx}/{len(papers)}] added {arxiv}: {len(rows)} chunks  {title}",
                      flush=True)
                added += 1
    finally:
        driver.close()

    print(f"\nsummary: added={added} skipped={skipped} failed={failed}", flush=True)
    return 1 if failed and not added else 0


if __name__ == "__main__":
    raise SystemExit(main())
