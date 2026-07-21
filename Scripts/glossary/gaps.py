"""List unwritten link targets (dead-end links) as the glossary writing backlog.

Authors intentionally link to concepts before those records exist; this report
turns every dangling ``prerequisites``/``related``/``contrasts`` target into a
prioritized to-write list, ordered by how many written terms already cite it.
"""

from __future__ import annotations

import argparse
from pathlib import Path

from common import (
    TERM_SOURCE_DIR,
    compact_json,
    load_records,
    missing_link_targets,
    validate_records,
)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--source-dir",
        type=Path,
        default=TERM_SOURCE_DIR,
        help="directory containing canonical *.jsonl shards",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="emit one machine-readable JSON object instead of text",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=0,
        help="show at most this many targets (0 means all)",
    )
    args = parser.parse_args()

    records, locations, errors = load_records(args.source_dir)
    errors.extend(validate_records(records, locations))
    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        print("Fix validation errors before reading the gap report.")
        return 1

    missing = missing_link_targets(records)
    ranked = sorted(
        missing.items(),
        key=lambda item: (-len(item[1]), item[0]),
    )
    if args.limit > 0:
        ranked = ranked[: args.limit]

    if args.json:
        payload = {
            "written_terms": len(records),
            "missing_targets": len(missing),
            "targets": [
                {
                    "id": target,
                    "reference_count": len(references),
                    "referenced_by": [
                        {"id": source_id, "field": field}
                        for source_id, field in references
                    ],
                }
                for target, references in ranked
            ],
        }
        print(compact_json(payload))
        return 0

    if not missing:
        print(f"No unwritten link targets; {len(records)} term(s) written.")
        return 0

    print(
        f"{len(missing)} unwritten link target(s) cited by written terms "
        f"({len(records)} term(s) written). Most-cited first:"
    )
    for target, references in ranked:
        citing = ", ".join(
            f"{source_id} ({field})" for source_id, field in references
        )
        print(f"  {target}  [{len(references)}]  <- {citing}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
