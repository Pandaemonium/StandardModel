"""Shared JSONL loading, validation, and indexing for the glossary."""

from __future__ import annotations

import json
import re
import unicodedata
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[2]
GLOSSARY_ROOT = REPO_ROOT / "Glossary"
TERM_SOURCE_DIR = GLOSSARY_ROOT / "terms"
CONFIG_PATH = GLOSSARY_ROOT / "glossary.json"
DEFAULT_OUTPUT_DIR = REPO_ROOT / "Index" / "glossary"

ID_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
REQUIRED_STRING_FIELDS = ("id", "term", "summary", "explanation", "why", "status")
LIST_FIELDS = (
    "aliases",
    "domains",
    "prerequisites",
    "related",
    "contrasts",
    "lean_refs",
    "doc_refs",
    "source_refs",
)
LINK_FIELDS = ("prerequisites", "related", "contrasts")
OPTIONAL_STRING_FIELDS = ("kind", "notation", "example", "conventions")
KNOWN_FIELDS = set(REQUIRED_STRING_FIELDS + LIST_FIELDS + OPTIONAL_STRING_FIELDS)
ALLOWED_STATUSES = {"draft", "reviewed", "stable"}
ALLOWED_KINDS = {"term", "notation", "acronym"}

COMPACT_KEYS = {
    "term": "t",
    "aliases": "a",
    "domains": "d",
    "kind": "k",
    "summary": "s",
    "explanation": "x",
    "why": "w",
    "notation": "n",
    "example": "e",
    "conventions": "cv",
    "prerequisites": "p",
    "related": "r",
    "contrasts": "ct",
    "lean_refs": "lr",
    "doc_refs": "dr",
    "source_refs": "sr",
    "status": "z",
}


def compact_json(value: Any) -> str:
    """Serialize deterministically with no formatting-only tokens."""

    return json.dumps(value, ensure_ascii=True, separators=(",", ":"))


def normalize_lookup(value: str) -> str:
    """Normalize a term, alias, or query for exact lookup."""

    normalized = unicodedata.normalize("NFKC", value).casefold().strip()
    return re.sub(r"\s+", " ", normalized)


def source_files(source_dir: Path = TERM_SOURCE_DIR) -> list[Path]:
    """Return canonical JSONL shards in deterministic order."""

    return sorted(source_dir.glob("*.jsonl"), key=lambda path: path.as_posix())


def load_records(
    source_dir: Path = TERM_SOURCE_DIR,
) -> tuple[list[dict[str, Any]], dict[str, str], list[str]]:
    """Load records while retaining useful file and line diagnostics."""

    records: list[dict[str, Any]] = []
    locations: dict[str, str] = {}
    errors: list[str] = []
    files = source_files(source_dir)
    if not files:
        return [], {}, [f"no .jsonl files found under {source_dir}"]

    for path in files:
        with path.open("r", encoding="utf-8") as handle:
            for line_number, raw_line in enumerate(handle, start=1):
                if not raw_line.strip():
                    continue
                location = f"{path.relative_to(REPO_ROOT)}:{line_number}"
                try:
                    record = json.loads(raw_line)
                except json.JSONDecodeError as exc:
                    errors.append(f"{location}: invalid JSON: {exc.msg}")
                    continue
                if not isinstance(record, dict):
                    errors.append(f"{location}: each line must be a JSON object")
                    continue
                record_id = record.get("id")
                if isinstance(record_id, str):
                    if record_id in locations:
                        errors.append(
                            f"{location}: duplicate id {record_id!r}; first seen at "
                            f"{locations[record_id]}"
                        )
                    else:
                        locations[record_id] = location
                records.append(record)

    return records, locations, errors


def _location(record: dict[str, Any], locations: dict[str, str]) -> str:
    record_id = record.get("id")
    if isinstance(record_id, str):
        return locations.get(record_id, f"record {record_id!r}")
    return "record with missing id"


def _validate_local_doc_ref(ref: str, location: str, errors: list[str]) -> None:
    if ref.startswith(("http://", "https://")):
        return
    path_text = ref.split("#", maxsplit=1)[0]
    path = Path(path_text)
    if path.is_absolute():
        errors.append(f"{location}: doc_refs must use repository-relative paths: {ref!r}")
        return
    resolved = (REPO_ROOT / path).resolve()
    try:
        resolved.relative_to(REPO_ROOT.resolve())
    except ValueError:
        errors.append(f"{location}: doc_ref escapes the repository: {ref!r}")
        return
    if not resolved.exists():
        errors.append(f"{location}: doc_ref does not exist: {ref!r}")


def validate_records(
    records: list[dict[str, Any]], locations: dict[str, str]
) -> list[str]:
    """Validate the schema rules that matter to the build and link graph."""

    errors: list[str] = []
    for record in records:
        location = _location(record, locations)
        unknown = sorted(set(record) - KNOWN_FIELDS)
        if unknown:
            errors.append(f"{location}: unknown fields: {', '.join(unknown)}")

        for field in REQUIRED_STRING_FIELDS:
            value = record.get(field)
            if not isinstance(value, str) or not value.strip():
                errors.append(f"{location}: {field} must be a non-empty string")

        record_id = record.get("id")
        if isinstance(record_id, str) and not ID_PATTERN.fullmatch(record_id):
            errors.append(f"{location}: id must be lowercase kebab-case")

        status = record.get("status")
        if isinstance(status, str) and status not in ALLOWED_STATUSES:
            errors.append(
                f"{location}: status must be one of {sorted(ALLOWED_STATUSES)}"
            )

        kind = record.get("kind")
        if kind is not None and (
            not isinstance(kind, str) or kind not in ALLOWED_KINDS
        ):
            errors.append(f"{location}: kind must be one of {sorted(ALLOWED_KINDS)}")

        for field in OPTIONAL_STRING_FIELDS:
            value = record.get(field)
            if value is not None and (not isinstance(value, str) or not value.strip()):
                errors.append(f"{location}: {field} must be a non-empty string")

        for field in LIST_FIELDS:
            values = record.get(field)
            if values is None:
                continue
            if not isinstance(values, list):
                errors.append(f"{location}: {field} must be an array")
                continue
            if any(not isinstance(value, str) or not value.strip() for value in values):
                errors.append(f"{location}: {field} entries must be non-empty strings")
                continue
            if len(values) != len(set(values)):
                errors.append(f"{location}: {field} contains duplicate entries")

        domains = record.get("domains")
        if isinstance(domains, list):
            if not domains:
                errors.append(f"{location}: domains must contain at least one value")
            for domain in domains:
                if isinstance(domain, str) and not ID_PATTERN.fullmatch(domain):
                    errors.append(
                        f"{location}: domain {domain!r} must be lowercase kebab-case"
                    )

        summary = record.get("summary")
        if isinstance(summary, str) and len(summary) > 280:
            errors.append(f"{location}: summary exceeds 280 characters")

        aliases = record.get("aliases", [])
        term = record.get("term")
        if isinstance(term, str) and isinstance(aliases, list):
            normalized_names = [normalize_lookup(term)] + [
                normalize_lookup(alias)
                for alias in aliases
                if isinstance(alias, str)
            ]
            if len(normalized_names) != len(set(normalized_names)):
                errors.append(f"{location}: term and aliases overlap after normalization")

        linked_targets: dict[str, str] = {}
        for field in LINK_FIELDS:
            values = record.get(field, [])
            if not isinstance(values, list):
                continue
            for target in values:
                if not isinstance(target, str):
                    continue
                if target == record_id:
                    errors.append(f"{location}: {field} cannot link a term to itself")
                if not ID_PATTERN.fullmatch(target):
                    errors.append(
                        f"{location}: {field} target must be lowercase kebab-case: "
                        f"{target!r}"
                    )
                previous = linked_targets.get(target)
                if previous is not None:
                    errors.append(
                        f"{location}: {target!r} appears in both {previous} and {field}"
                    )
                else:
                    linked_targets[target] = field

        doc_refs = record.get("doc_refs", [])
        if isinstance(doc_refs, list):
            for ref in doc_refs:
                if isinstance(ref, str):
                    _validate_local_doc_ref(ref, location, errors)

    return errors


def missing_link_targets(
    records: list[dict[str, Any]],
) -> dict[str, list[tuple[str, str]]]:
    """Map each unwritten link target to the (source id, field) pairs citing it.

    Dangling targets are allowed by policy: authors link to the concept graph
    they intend, and the gap report turns unwritten targets into the writing
    backlog. See docs/GLOSSARY.md.
    """

    ids = {
        record["id"]
        for record in records
        if isinstance(record.get("id"), str)
    }
    missing: dict[str, list[tuple[str, str]]] = {}
    for record in records:
        record_id = record.get("id")
        if not isinstance(record_id, str):
            continue
        for field in LINK_FIELDS:
            values = record.get(field, [])
            if not isinstance(values, list):
                continue
            for target in values:
                if isinstance(target, str) and target and target not in ids:
                    missing.setdefault(target, []).append((record_id, field))
    for references in missing.values():
        references.sort()
    return dict(sorted(missing.items()))


def make_indexes(
    records: list[dict[str, Any]],
) -> tuple[dict[str, list[str]], dict[str, dict[str, list[str]]]]:
    """Build normalized lookup and reverse-link indexes.

    Link targets without a written record are skipped here; they surface in
    the gap report (`missing_link_targets`) instead of the backlink index.
    """

    aliases: dict[str, list[str]] = {}
    backlinks: dict[str, dict[str, list[str]]] = {
        record["id"]: {
            "prerequisite_of": [],
            "related_from": [],
            "contrasted_by": [],
        }
        for record in records
    }
    reverse_names = {
        "prerequisites": "prerequisite_of",
        "related": "related_from",
        "contrasts": "contrasted_by",
    }

    for record in records:
        record_id = record["id"]
        for name in [record["term"], *record.get("aliases", [])]:
            aliases.setdefault(normalize_lookup(name), []).append(record_id)
        for field, reverse_name in reverse_names.items():
            for target in record.get(field, []):
                if target in backlinks:
                    backlinks[target][reverse_name].append(record_id)

    for ids_for_name in aliases.values():
        ids_for_name.sort()
    for groups in backlinks.values():
        for linked_ids in groups.values():
            linked_ids.sort()
    return dict(sorted(aliases.items())), dict(sorted(backlinks.items()))


def compact_record(record: dict[str, Any]) -> dict[str, Any]:
    """Create the documented short-key representation for agent retrieval."""

    result: dict[str, Any] = {"id": record["id"]}
    for key, value in record.items():
        if key == "id" or value in (None, "", []):
            continue
        result[COMPACT_KEYS[key]] = value
    return result
