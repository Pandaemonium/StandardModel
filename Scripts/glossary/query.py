"""Read exact terms, searches, and link neighborhoods with compact JSON output."""

from __future__ import annotations

import argparse
import json
from typing import Any

from common import (
    compact_json,
    load_records,
    make_indexes,
    normalize_lookup,
    validate_records,
)


def summary(record: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": record["id"],
        "term": record["term"],
        "domains": record["domains"],
        "summary": record["summary"],
        "status": record["status"],
    }


def search_score(record: dict[str, Any], query: str) -> tuple[int, str, str] | None:
    normalized_id = normalize_lookup(record["id"])
    names = [normalize_lookup(record["term"])] + [
        normalize_lookup(alias) for alias in record.get("aliases", [])
    ]
    if query == normalized_id or query in names:
        rank = 0
    elif normalized_id.startswith(query) or any(name.startswith(query) for name in names):
        rank = 1
    elif query in normalized_id or any(query in name for name in names):
        rank = 2
    elif query in normalize_lookup(record["summary"]):
        rank = 3
    elif query in normalize_lookup(record["explanation"]):
        rank = 4
    else:
        return None
    return rank, record["term"].casefold(), record["id"]


def emit(value: Any, pretty: bool) -> None:
    if pretty:
        print(json.dumps(value, ensure_ascii=True, indent=2))
    else:
        print(compact_json(value))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", help="term id, name, alias, or search text")
    parser.add_argument(
        "--search",
        action="store_true",
        help="return ranked summary matches instead of exact lookup",
    )
    parser.add_argument(
        "--neighbors",
        action="store_true",
        help="include one-hop outgoing links and backlinks",
    )
    parser.add_argument("--limit", type=int, default=20)
    parser.add_argument("--pretty", action="store_true")
    args = parser.parse_args()

    records, locations, errors = load_records()
    errors.extend(validate_records(records, locations))
    if errors:
        emit({"errors": errors}, args.pretty)
        return 1

    by_id = {record["id"]: record for record in records}
    aliases, backlinks = make_indexes(records)
    normalized_query = normalize_lookup(args.query)

    if args.search:
        if args.limit < 1:
            parser.error("--limit must be at least 1")
        ranked = []
        for record in records:
            score = search_score(record, normalized_query)
            if score is not None:
                ranked.append((score, summary(record)))
        ranked.sort(key=lambda item: item[0])
        emit(
            {
                "query": args.query,
                "matches": [item[1] for item in ranked[: args.limit]],
            },
            args.pretty,
        )
        return 0

    candidates: list[str]
    if args.query in by_id:
        candidates = [args.query]
    else:
        candidates = aliases.get(normalized_query, [])
    if not candidates:
        emit({"query": args.query, "not_found": True}, args.pretty)
        return 1
    if len(candidates) > 1:
        emit(
            {
                "query": args.query,
                "ambiguous": [summary(by_id[record_id]) for record_id in candidates],
            },
            args.pretty,
        )
        return 2

    record = by_id[candidates[0]]
    if not args.neighbors:
        emit(record, args.pretty)
        return 0

    outgoing = []
    for relationship in ("prerequisites", "related", "contrasts"):
        for record_id in record.get(relationship, []):
            target = by_id.get(record_id)
            if target is None:
                outgoing.append(
                    {"relationship": relationship, "id": record_id, "unwritten": True}
                )
            else:
                outgoing.append({"relationship": relationship, **summary(target)})
    incoming = []
    for relationship, record_ids in backlinks[record["id"]].items():
        for record_id in record_ids:
            incoming.append({"relationship": relationship, **summary(by_id[record_id])})
    emit({"term": record, "outgoing": outgoing, "backlinks": incoming}, args.pretty)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
