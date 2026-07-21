"""Validate canonical glossary JSONL records and report unwritten link targets.

Dangling ``prerequisites``/``related``/``contrasts`` targets are allowed by
policy (they are the writing backlog, not errors); this script summarizes them
and ``gaps.py`` lists them in detail. Use ``--strict`` to fail on them.
"""

from __future__ import annotations

import argparse
from pathlib import Path

from common import TERM_SOURCE_DIR, load_records, missing_link_targets, validate_records


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--source-dir",
        type=Path,
        default=TERM_SOURCE_DIR,
        help="directory containing canonical *.jsonl shards",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="treat unwritten link targets as errors instead of backlog",
    )
    args = parser.parse_args()

    records, locations, errors = load_records(args.source_dir)
    errors.extend(validate_records(records, locations))
    missing = missing_link_targets(records)
    if args.strict:
        for target, references in missing.items():
            for source_id, field in references:
                errors.append(
                    f"{locations.get(source_id, source_id)}: {field} target is "
                    f"not written yet: {target!r}"
                )
    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        print(f"Glossary validation failed with {len(errors)} error(s).")
        return 1

    print(
        f"Glossary validation passed: {len(records)} term(s) in "
        f"{len(list(args.source_dir.glob('*.jsonl')))} shard(s)."
    )
    if missing:
        reference_count = sum(len(references) for references in missing.values())
        print(
            f"Backlog: {len(missing)} unwritten link target(s) referenced "
            f"{reference_count} time(s); run Scripts/glossary/gaps.py for the list."
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
