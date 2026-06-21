#!/usr/bin/env python3
"""Scan Lean code for forbidden proof-placeholder tokens.

This checker is intentionally quieter than raw grep:

* Lean line comments, block comments, and docstrings are ignored.
* String literals are ignored.
* Draft directories are skipped by default unless ``--include-draft`` is used.

The goal is to find tokens that matter to the Lean kernel while avoiding the
large false-positive cost of prose comments and task notes.
"""

from __future__ import annotations

import argparse
import pathlib
import re
import sys
from collections.abc import Iterable


REPO_ROOT = pathlib.Path(__file__).resolve().parents[1]
BASE_FORBIDDEN_TERMS = ("sorry", "admit", "axiom", "opaque", "unsafe")
NATIVE_DECIDE_TERM = "native_decide"
DEFAULT_PATHS = (
    "PhysicsSM",
    "PhysicsSM.lean",
    "PhysicsSMSPL.lean",
    "CodeLatticeE8",
    "CodeLatticeE8.lean",
    "CodeLatticeE8SPL.lean",
)
DEFAULT_DRAFT_PARTS = {
    "Draft",
    "CodeLatticeE8Draft",
}


def rel(path: pathlib.Path) -> str:
    try:
        return path.resolve().relative_to(REPO_ROOT).as_posix()
    except ValueError:
        return str(path)


def mask_comments_and_strings(text: str) -> str:
    """Replace Lean comments and strings with spaces, preserving positions."""
    out: list[str] = []
    i = 0
    n = len(text)
    block_depth = 0
    in_line_comment = False
    in_string = False

    while i < n:
        ch = text[i]
        nxt = text[i + 1] if i + 1 < n else ""

        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
                out.append("\n")
            else:
                out.append(" ")
            i += 1
            continue

        if block_depth > 0:
            if ch == "/" and nxt == "-":
                out.extend("  ")
                block_depth += 1
                i += 2
            elif ch == "-" and nxt == "/":
                out.extend("  ")
                block_depth -= 1
                i += 2
            else:
                out.append("\n" if ch == "\n" else " ")
                i += 1
            continue

        if in_string:
            if ch == "\\" and i + 1 < n:
                out.extend("  ")
                i += 2
            elif ch == '"':
                in_string = False
                out.append(" ")
                i += 1
            else:
                out.append("\n" if ch == "\n" else " ")
                i += 1
            continue

        if ch == "-" and nxt == "-":
            out.extend("  ")
            in_line_comment = True
            i += 2
        elif ch == "/" and nxt == "-":
            out.extend("  ")
            block_depth = 1
            i += 2
        elif ch == '"':
            out.append(" ")
            in_string = True
            i += 1
        else:
            out.append(ch)
            i += 1

    return "".join(out)


def iter_lean_files(paths: Iterable[pathlib.Path], include_draft: bool) -> list[pathlib.Path]:
    files: list[pathlib.Path] = []
    for path in paths:
        resolved = path if path.is_absolute() else REPO_ROOT / path
        if not resolved.exists():
            raise FileNotFoundError(f"path does not exist: {path}")
        if resolved.is_file():
            candidates = [resolved] if resolved.suffix == ".lean" else []
        else:
            candidates = list(resolved.rglob("*.lean"))
        for candidate in candidates:
            relative_parts = candidate.resolve().relative_to(REPO_ROOT).parts
            if not include_draft and any(part in DEFAULT_DRAFT_PARTS for part in relative_parts):
                continue
            files.append(candidate)
    return sorted(set(files))


def line_col(text: str, offset: int) -> tuple[int, int]:
    line = text.count("\n", 0, offset) + 1
    line_start = text.rfind("\n", 0, offset) + 1
    return line, offset - line_start + 1


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8")

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "paths",
        nargs="*",
        type=pathlib.Path,
        help="Lean files or directories to scan. Defaults to trusted roots.",
    )
    parser.add_argument(
        "--include-draft",
        action="store_true",
        help="Include draft roots/directories that may intentionally contain placeholders.",
    )
    parser.add_argument(
        "--forbid-native-decide",
        action="store_true",
        help="Also report native_decide. Use this for Aristotle outputs or files that must avoid it.",
    )
    args = parser.parse_args()

    terms = BASE_FORBIDDEN_TERMS
    if args.forbid_native_decide:
        terms = (*terms, NATIVE_DECIDE_TERM)
    forbidden_re = re.compile(r"\b(" + "|".join(map(re.escape, terms)) + r")\b")

    paths = args.paths or [pathlib.Path(path) for path in DEFAULT_PATHS]
    files = iter_lean_files(paths, args.include_draft)

    hit_count = 0
    for path in files:
        text = path.read_text(encoding="utf-8")
        masked = mask_comments_and_strings(text)
        for match in forbidden_re.finditer(masked):
            line, col = line_col(masked, match.start())
            source_line = text.splitlines()[line - 1].rstrip()
            print(f"{rel(path)}:{line}:{col}: {match.group(1)}: {source_line}")
            hit_count += 1

    if hit_count:
        print(f"\nFound {hit_count} forbidden Lean-code token(s).", file=sys.stderr)
        return 1
    print(f"Scanned {len(files)} Lean file(s); no forbidden Lean-code tokens found.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
