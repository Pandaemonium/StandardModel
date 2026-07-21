"""Ingest a batch of proposed glossary records into the canonical shards.

Input is a JSON file containing either an array of term records or an object
with a ``records`` array (the shape drafting agents return). The script
normalizes each record, skips ones that cannot be repaired, appends the rest
to topic shards, and refuses to write anything unless the combined glossary
still validates. Dangling link targets are allowed; they become the gap
report (``gaps.py``), not errors.

Normalization performed per record:

- unknown fields are dropped (warned);
- strings are stripped; empty optional fields are removed;
- ``status`` is forced to ``draft`` unless ``--keep-status`` is given;
- common typographic non-ASCII characters are replaced with ASCII;
- list fields are de-duplicated preserving order; self-links are removed;
- a target cited in several link fields keeps only the strongest one
  (prerequisites over related over contrasts);
- aliases that collide with the term after normalization are dropped;
- local ``doc_refs`` that do not exist on disk are dropped (warned).

Shard choice: ``--shard`` if given, otherwise the record's first domain
(``<domain>.jsonl`` under ``Glossary/terms/``). A record whose id already
exists is skipped unless ``--update`` replaces the old record in place.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

from common import (
    KNOWN_FIELDS,
    LINK_FIELDS,
    REPO_ROOT,
    TERM_SOURCE_DIR,
    compact_json,
    missing_link_targets,
    normalize_lookup,
    validate_records,
)

# Typographic characters that drafting models commonly emit, mapped to the
# ASCII forms the repository requires. Keys use escapes so this file itself
# stays ASCII-only.
ASCII_REPLACEMENTS = {
    "\u2018": "'",
    "\u2019": "'",
    "\u201c": '"',
    "\u201d": '"',
    "\u2013": "-",
    "\u2014": "-",
    "\u2212": "-",
    "\u00d7": "x",
    "\u00a0": " ",
    "\u2026": "...",
    "\u2192": "->",
    "\u2190": "<-",
    "\u00b7": "*",
}


def asciify(value: str) -> str:
    for source, replacement in ASCII_REPLACEMENTS.items():
        value = value.replace(source, replacement)
    return value


def normalize_record(
    record: dict[str, Any], warnings: list[str], keep_status: bool
) -> dict[str, Any] | None:
    record_id = record.get("id")
    if not isinstance(record_id, str) or not record_id.strip():
        warnings.append("record without a usable id was skipped")
        return None
    label = record_id.strip()

    unknown = sorted(set(record) - KNOWN_FIELDS)
    if unknown:
        warnings.append(f"{label}: dropped unknown fields: {', '.join(unknown)}")

    cleaned: dict[str, Any] = {}
    for field, value in record.items():
        if field not in KNOWN_FIELDS:
            continue
        if isinstance(value, str):
            value = asciify(value).strip()
            if value:
                cleaned[field] = value
        elif isinstance(value, list):
            items: list[str] = []
            for item in value:
                if isinstance(item, str):
                    item = asciify(item).strip()
                    if item and item not in items:
                        items.append(item)
            if items:
                cleaned[field] = items

    if not keep_status and cleaned.get("status") != "draft":
        if "status" in cleaned:
            warnings.append(
                f"{label}: status {cleaned['status']!r} reset to 'draft' "
                "(promotion is a human review decision)"
            )
        cleaned["status"] = "draft"

    for field in LINK_FIELDS:
        if field in cleaned:
            targets = [t for t in cleaned[field] if t != cleaned.get("id")]
            if len(targets) != len(cleaned[field]):
                warnings.append(f"{label}: removed self-link from {field}")
            if targets:
                cleaned[field] = targets
            else:
                del cleaned[field]

    seen_targets: set[str] = set()
    for field in LINK_FIELDS:
        if field not in cleaned:
            continue
        kept = [t for t in cleaned[field] if t not in seen_targets]
        if len(kept) != len(cleaned[field]):
            warnings.append(
                f"{label}: kept only the strongest relationship for targets "
                "cited in multiple link fields"
            )
        seen_targets.update(kept)
        if kept:
            cleaned[field] = kept
        else:
            del cleaned[field]

    term = cleaned.get("term")
    if isinstance(term, str) and "aliases" in cleaned:
        used = {normalize_lookup(term)}
        aliases = []
        for alias in cleaned["aliases"]:
            normalized = normalize_lookup(alias)
            if normalized in used:
                warnings.append(f"{label}: dropped alias duplicating the term: {alias!r}")
                continue
            used.add(normalized)
            aliases.append(alias)
        if aliases:
            cleaned["aliases"] = aliases
        else:
            del cleaned["aliases"]

    if "doc_refs" in cleaned:
        refs = []
        for ref in cleaned["doc_refs"]:
            if ref.startswith(("http://", "https://")):
                refs.append(ref)
                continue
            path = REPO_ROOT / ref.split("#", maxsplit=1)[0]
            if path.exists():
                refs.append(ref)
            else:
                warnings.append(f"{label}: dropped nonexistent doc_ref {ref!r}")
        if refs:
            cleaned["doc_refs"] = refs
        else:
            del cleaned["doc_refs"]

    return cleaned


def load_shards(source_dir: Path) -> dict[str, list[dict[str, Any]]]:
    shards: dict[str, list[dict[str, Any]]] = {}
    for path in sorted(source_dir.glob("*.jsonl")):
        records = []
        with path.open("r", encoding="utf-8") as handle:
            for raw_line in handle:
                if raw_line.strip():
                    records.append(json.loads(raw_line))
        shards[path.stem] = records
    return shards


def write_shard(source_dir: Path, shard: str, records: list[dict[str, Any]]) -> None:
    records = sorted(records, key=lambda record: record["id"])
    path = source_dir / f"{shard}.jsonl"
    with path.open("w", encoding="utf-8", newline="\n") as handle:
        for record in records:
            handle.write(compact_json(record) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("batch", type=Path, help="JSON file with proposed records")
    parser.add_argument(
        "--source-dir",
        type=Path,
        default=TERM_SOURCE_DIR,
        help="directory containing canonical *.jsonl shards",
    )
    parser.add_argument(
        "--shard",
        help="force every accepted record into this shard (default: first domain)",
    )
    parser.add_argument(
        "--update",
        action="store_true",
        help="replace existing records with the incoming version",
    )
    parser.add_argument(
        "--keep-status",
        action="store_true",
        help="trust the incoming status field instead of forcing draft",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="report what would change without writing any shard",
    )
    args = parser.parse_args()

    with args.batch.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)
    if isinstance(payload, dict):
        payload = payload.get("records", [])
    if not isinstance(payload, list):
        print("ERROR: batch must be a JSON array or an object with 'records'")
        return 1

    warnings: list[str] = []
    shards = load_shards(args.source_dir)
    existing_shard_by_id = {
        record["id"]: shard
        for shard, records in shards.items()
        for record in records
        if isinstance(record.get("id"), str)
    }

    accepted: list[tuple[str, dict[str, Any]]] = []
    skipped = 0
    batch_ids: set[str] = set()
    for raw_record in payload:
        if not isinstance(raw_record, dict):
            warnings.append("non-object batch entry was skipped")
            skipped += 1
            continue
        record = normalize_record(raw_record, warnings, args.keep_status)
        if record is None:
            skipped += 1
            continue
        record_id = record["id"]
        if record_id in batch_ids:
            warnings.append(f"{record_id}: duplicate within batch; first version kept")
            skipped += 1
            continue

        field_errors = validate_records([record], {record_id: record_id})
        if field_errors:
            for error in field_errors:
                warnings.append(f"rejected: {error}")
            skipped += 1
            continue

        if record_id in existing_shard_by_id and not args.update:
            warnings.append(f"{record_id}: already exists; skipped (use --update)")
            skipped += 1
            continue

        shard = args.shard or existing_shard_by_id.get(record_id) or record["domains"][0]
        batch_ids.add(record_id)
        accepted.append((shard, record))

    for shard, record in accepted:
        records = shards.setdefault(shard, [])
        records[:] = [item for item in records if item.get("id") != record["id"]]
        records.append(record)

    combined = [record for records in shards.values() for record in records]
    locations = {
        record["id"]: record["id"]
        for record in combined
        if isinstance(record.get("id"), str)
    }
    errors = validate_records(combined, locations)
    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        print(
            f"Ingest aborted: combined glossary would fail validation with "
            f"{len(errors)} error(s). Nothing was written."
        )
        return 1

    for warning in warnings:
        print(f"WARNING: {warning}")

    touched = sorted({shard for shard, _ in accepted})
    if not args.dry_run:
        for shard in touched:
            write_shard(args.source_dir, shard, shards[shard])

    missing = missing_link_targets(combined)
    mode = "would add" if args.dry_run else "added"
    print(
        f"Ingest {mode} {len(accepted)} record(s) into "
        f"{', '.join(touched) if touched else 'no shards'}; "
        f"skipped {skipped}; glossary now {len(combined)} term(s), "
        f"{len(missing)} unwritten link target(s)."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
