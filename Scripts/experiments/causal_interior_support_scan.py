"""Order-only development scan for two-sided interior and retarded shells.

This companion to ``causal_intrinsic_probe_metric.py`` evaluates every tuple in
the frozen development grid proposed for the next intrinsic selector.  It uses
only the finite causal relation, interval counts, and supplied scales after a
sprinkling has been generated.  Embedding coordinates are never inspected for
parameter selection or scoring.

The scan evaluates every marked event in each two-sided interior.  Its
``rank_capable`` statistic means only that a shell contains at least the four
points needed to test the already existing four-probe selectors.  It is not a
rank-four input to the proposed basis-free successor selector.
"""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    open_interval_count_matrix,
    two_sided_interior,
)
from causal_operator_metric import (
    diamond_volume_4d,
    finite_statistics,
    sprinkle_minkowski_diamond,
)


SCALE_RATIOS = (0.75, 1.0, 1.25, 1.5)
INTERIOR_BANDS = ((0.5, 2.0), (1.0, 4.0))
ABUNDANCE_THRESHOLDS = (0.25, 0.5)
SHELL_BANDS = ((0.5, 4.0), (1.0, 4.0))


def shell_counts_for_all_marks(
    relation: np.ndarray,
    interval_counts: np.ndarray,
    interior: np.ndarray,
    ell: float,
    selector_scale: float,
    shell_lower: float,
    shell_upper: float,
) -> np.ndarray:
    """Retarded-shell sizes for every event in the supplied interior."""

    marks = np.flatnonzero(interior)
    if len(marks) == 0:
        return np.empty(0, dtype=np.int64)
    nu = (selector_scale / ell) ** 4
    counts = interval_counts[:, marks].astype(float) + 1.0
    shell = (
        relation[:, marks]
        & interior[:, None]
        & (counts >= shell_lower * nu)
        & (counts <= shell_upper * nu)
    )
    return np.count_nonzero(shell, axis=0)


def run_scan(args: argparse.Namespace) -> dict[str, object]:
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    if args.minimum_shell_count <= 0:
        raise ValueError("minimum shell count must be positive")

    tuples = list(
        itertools.product(
            SCALE_RATIOS,
            INTERIOR_BANDS,
            ABUNDANCE_THRESHOLDS,
            SHELL_BANDS,
        )
    )
    seed_sequence = np.random.SeedSequence(args.seed)
    child_seeds = iter(
        seed_sequence.spawn(len(args.events) * args.realizations)
    )
    result_rows: list[dict[str, object]] = []

    for events in args.events:
        ell = (diamond_volume_4d(args.duration) / events) ** 0.25
        if args.nonlocality_scale <= ell:
            raise ValueError(
                f"nonlocality scale is not above ell for N={events}"
            )
        aggregates = {
            parameters: {"interiors": [], "shells": []}
            for parameters in tuples
        }

        for _ in range(args.realizations):
            rng = np.random.default_rng(next(child_seeds))
            points, _ = sprinkle_minkowski_diamond(
                rng, events, args.duration
            )
            relation = causal_relation_matrix(points, args.block_size)
            interval_counts = open_interval_count_matrix(relation)

            for parameters in tuples:
                scale_ratio, interior_band, abundance, shell_band = parameters
                selector_scale = scale_ratio * args.nonlocality_scale
                interior = two_sided_interior(
                    relation,
                    interval_counts,
                    ell,
                    selector_scale,
                    interior_band[0],
                    interior_band[1],
                    abundance,
                )
                shell_counts = shell_counts_for_all_marks(
                    relation,
                    interval_counts,
                    interior,
                    ell,
                    selector_scale,
                    shell_band[0],
                    shell_band[1],
                )
                aggregates[parameters]["interiors"].append(
                    int(np.count_nonzero(interior))
                )
                aggregates[parameters]["shells"].extend(
                    int(count) for count in shell_counts
                )

        for parameters in tuples:
            scale_ratio, interior_band, abundance, shell_band = parameters
            interiors = aggregates[parameters]["interiors"]
            shells = aggregates[parameters]["shells"]
            marked_events = len(shells)
            result_rows.append(
                {
                    "events": events,
                    "ell": ell,
                    "scale_ratio": scale_ratio,
                    "interior_band": list(interior_band),
                    "interior_abundance_threshold": abundance,
                    "retarded_shell_band": list(shell_band),
                    "realizations_with_interior_rate": sum(
                        count > 0 for count in interiors
                    )
                    / len(interiors),
                    "interior_count": finite_statistics(interiors),
                    "marked_events_evaluated": marked_events,
                    "retarded_shell_count": finite_statistics(shells),
                    "retarded_shell_nonempty_rate": (
                        sum(count > 0 for count in shells) / marked_events
                        if marked_events
                        else 0.0
                    ),
                    "retarded_shell_rank_capable_rate": (
                        sum(
                            count >= args.minimum_shell_count
                            for count in shells
                        )
                        / marked_events
                        if marked_events
                        else 0.0
                    ),
                }
            )

    return {
        "status": "order-only development scan; external numerical oracle",
        "embedding_coordinates_used_after_sprinkling": False,
        "settings": {
            "events": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "nonlocality_scale": args.nonlocality_scale,
            "minimum_shell_count": args.minimum_shell_count,
            "seed": args.seed,
            "scale_ratios": list(SCALE_RATIOS),
            "interior_bands": [list(band) for band in INTERIOR_BANDS],
            "interior_abundance_thresholds": list(ABUNDANCE_THRESHOLDS),
            "retarded_shell_bands": [list(band) for band in SHELL_BANDS],
        },
        "results": result_rows,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", nargs="+", type=int, default=[400, 800, 1200])
    parser.add_argument("--realizations", type=int, default=10)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--nonlocality-scale", type=float, default=0.18)
    parser.add_argument("--minimum-shell-count", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20260715)
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_scan(args)
    encoded = json.dumps(result, indent=2, sort_keys=True)
    if args.output is not None:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(encoded + "\n", encoding="utf-8", newline="\n")
    print(encoded)


if __name__ == "__main__":
    main()
