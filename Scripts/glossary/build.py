"""Build deterministic agent indexes and the static glossary browser."""

from __future__ import annotations

import argparse
import json
import shutil
from pathlib import Path
from typing import Any

from common import (
    CONFIG_PATH,
    DEFAULT_OUTPUT_DIR,
    GLOSSARY_ROOT,
    REPO_ROOT,
    compact_json,
    compact_record,
    load_records,
    make_indexes,
    missing_link_targets,
    validate_records,
)


UI_FILES = ("index.html", "styles.css", "app.js")


def write_text(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as handle:
        handle.write(value)


def write_json(path: Path, value: Any) -> None:
    write_text(path, compact_json(value) + "\n")


def check_output_path(output_dir: Path) -> Path:
    resolved = output_dir.resolve()
    try:
        resolved.relative_to(REPO_ROOT.resolve())
    except ValueError as exc:
        raise ValueError("output directory must stay inside the repository") from exc
    if resolved in {REPO_ROOT.resolve(), GLOSSARY_ROOT.resolve()}:
        raise ValueError("refusing to use a source directory as generated output")
    return resolved


def load_config() -> dict[str, Any]:
    with CONFIG_PATH.open("r", encoding="utf-8") as handle:
        config = json.load(handle)
    required = {"schema_version", "title", "audience"}
    missing = sorted(required - set(config))
    if missing:
        raise ValueError(f"glossary.json is missing: {', '.join(missing)}")
    if config["schema_version"] != 1:
        raise ValueError("unsupported glossary schema_version")
    return config


def build(output_dir: Path) -> int:
    output_dir = check_output_path(output_dir)
    records, locations, errors = load_records()
    errors.extend(validate_records(records, locations))
    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        print(f"Glossary build stopped with {len(errors)} validation error(s).")
        return 1

    config = load_config()
    records.sort(key=lambda record: record["id"])
    aliases, backlinks = make_indexes(records)
    graph = {
        record["id"]: {
            field: record.get(field, [])
            for field in ("prerequisites", "related", "contrasts")
        }
        for record in records
    }

    output_dir.mkdir(parents=True, exist_ok=True)
    site_dir = output_dir / "site"
    term_dir = site_dir / "terms"
    term_dir.mkdir(parents=True, exist_ok=True)

    expected_term_files = {f"{record['id']}.json" for record in records}
    for old_path in term_dir.glob("*.json"):
        if old_path.name not in expected_term_files:
            old_path.unlink()

    missing = missing_link_targets(records)
    compact_lines = [compact_json(compact_record(record)) for record in records]
    write_text(output_dir / "terms.compact.jsonl", "\n".join(compact_lines) + "\n")
    write_json(output_dir / "aliases.json", aliases)
    write_json(output_dir / "graph.json", graph)
    write_json(output_dir / "backlinks.json", backlinks)
    write_json(
        output_dir / "missing.json",
        {
            target: [
                {"id": source_id, "field": field} for source_id, field in references
            ]
            for target, references in missing.items()
        },
    )

    domains = sorted({domain for record in records for domain in record["domains"]})
    search_index = [
        {
            "id": record["id"],
            "term": record["term"],
            "aliases": record.get("aliases", []),
            "domains": record["domains"],
            "summary": record["summary"],
            "status": record["status"],
        }
        for record in records
    ]
    manifest = {
        **config,
        "term_count": len(records),
        "domains": domains,
    }
    write_json(site_dir / "manifest.json", manifest)
    write_json(site_dir / "search-index.json", search_index)
    for record in records:
        write_json(
            term_dir / f"{record['id']}.json",
            {**record, "backlinks": backlinks[record["id"]]},
        )

    ui_dir = GLOSSARY_ROOT / "ui"
    for filename in UI_FILES:
        source = ui_dir / filename
        if not source.exists():
            raise FileNotFoundError(f"missing glossary UI source: {source}")
        shutil.copyfile(source, site_dir / filename)

    print(
        f"Built {len(records)} glossary term(s) into "
        f"{output_dir.relative_to(REPO_ROOT)}."
    )
    if missing:
        print(
            f"Backlog: {len(missing)} unwritten link target(s); see "
            f"{(output_dir / 'missing.json').relative_to(REPO_ROOT)} or run "
            "Scripts/glossary/gaps.py."
        )
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="generated output directory inside the repository",
    )
    args = parser.parse_args()
    try:
        return build(args.output_dir)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"ERROR: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
