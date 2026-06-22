"""Create a compact semantic context pack for an Aristotle job.

The pack combines top hits from the repo document/Lean index and the scoped
paper index into one Markdown file under `AgentTasks/context-packs/`. Include
that file in focused Aristotle submissions instead of sending large, duplicated
context trees.

Example:

    PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
    "$PY" Scripts/aristotle/make_context_pack.py \
        --query "Dirac slash bundle momentum squares to Pluecker scalar" \
        --slug dirac-pluecker
"""

from __future__ import annotations

import argparse
import datetime as dt
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
LIT_DIR = REPO / "Scripts" / "lit"
DEFAULT_OUT_DIR = REPO / "AgentTasks" / "context-packs"

sys.path.insert(0, str(LIT_DIR))

import neo4j_doc_search  # noqa: E402
import neo4j_paper_search  # noqa: E402


def _slug(text: str) -> str:
    text = text.strip().lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    return text.strip("-")[:80] or "context-pack"


def _clip(text: str, limit: int) -> str:
    text = (text or "").strip()
    if len(text) <= limit:
        return text
    return text[: limit - 20].rstrip() + "\n...[truncated]"


def _write_doc_hits(lines: list[str], hits, max_chars: int) -> None:
    lines.append("## Repo docs and Lean hits")
    lines.append("")
    if not hits:
        lines.append("No repo hits returned.")
        lines.append("")
        return
    for i, hit in enumerate(hits, 1):
        heading = f" [{hit['heading']}]" if hit.get("heading") else ""
        lines.append(f"### {i}. `{hit['path']}`{heading}")
        lines.append("")
        lines.append(f"Score: `{hit['score']:.3f}`")
        lines.append("")
        lines.append("```text")
        lines.append(_clip(hit.get("text") or "", max_chars))
        lines.append("```")
        lines.append("")


def _write_paper_hits(lines: list[str], hits, max_chars: int) -> None:
    lines.append("## Scoped paper hits")
    lines.append("")
    if not hits:
        lines.append("No paper hits returned.")
        lines.append("")
        return
    for i, hit in enumerate(hits, 1):
        lines.append(f"### {i}. {hit.get('title') or '(untitled)'}")
        lines.append("")
        lines.append(f"Score: `{hit['score']:.3f}`")
        if hit.get("key"):
            lines.append(f"Zotero key: `{hit['key']}`")
        if hit.get("arxiv"):
            lines.append(f"arXiv: `{hit['arxiv']}`")
        if hit.get("doi"):
            lines.append(f"DOI: `{hit['doi']}`")
        if hit.get("url"):
            lines.append(f"URL: {hit['url']}")
        abstract = _clip(hit.get("abstract") or "", max_chars)
        if abstract:
            lines.append("")
            lines.append("Abstract:")
            lines.append("")
            lines.append(abstract)
        lines.append("")


def make_pack(ns: argparse.Namespace) -> Path:
    slug = ns.slug or _slug(ns.query)
    stamp = dt.datetime.now().strftime("%Y%m%d-%H%M%S")
    out_dir = Path(ns.out_dir)
    if not out_dir.is_absolute():
        out_dir = REPO / out_dir
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / f"{slug}-{stamp}.md"

    doc_hits = []
    paper_hits = []
    if not ns.skip_docs:
        doc_hits = neo4j_doc_search.query_results(ns.query, ns.doc_k)
    if not ns.skip_papers:
        collections = ns.paper_collection or list(neo4j_paper_search.NULL_EDGE_COLLECTIONS)
        paper_hits = neo4j_paper_search.query_results(
            ns.query,
            ns.paper_k,
            collections=collections,
            all_projects=ns.all_papers,
        )

    lines = [
        "# Aristotle semantic context pack",
        "",
        f"Generated: {dt.datetime.now().isoformat(timespec='seconds')}",
        f"Query: `{ns.query}`",
        "",
        "Use this as context, not as proof. Verify every imported theorem",
        "statement and source convention against the live repo before relying on it.",
        "",
    ]
    _write_doc_hits(lines, doc_hits, ns.max_chars)
    _write_paper_hits(lines, paper_hits, ns.max_chars)
    out_path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")
    return out_path


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--query", required=True, help="natural-language theorem or branch target")
    ap.add_argument("--slug", help="filename slug; default is derived from query")
    ap.add_argument("--out-dir", default=str(DEFAULT_OUT_DIR), help="output directory")
    ap.add_argument("--doc-k", type=int, default=8, help="repo doc/Lean hits")
    ap.add_argument("--paper-k", type=int, default=5, help="paper hits")
    ap.add_argument("--max-chars", type=int, default=1800, help="max text per hit")
    ap.add_argument("--skip-docs", action="store_true", help="omit repo doc/Lean hits")
    ap.add_argument("--skip-papers", action="store_true", help="omit paper hits")
    ap.add_argument(
        "--paper-collection",
        action="append",
        default=None,
        help="paper collection key to include; repeatable",
    )
    ap.add_argument(
        "--all-papers",
        action="store_true",
        help="search all paper nodes instead of scoped null-edge collections",
    )
    ns = ap.parse_args()
    out = make_pack(ns)
    print(out.relative_to(REPO).as_posix())


if __name__ == "__main__":
    main()
