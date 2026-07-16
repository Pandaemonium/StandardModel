"""Fixed-density larger-diamond control for adjacent retarded support.

Stage A3b recovered an adjacent selector-scale hierarchy but found that the
largest retarded shell was empty at almost every common-interior mark. Density
refinement in a fixed diamond changes both ``ell`` and the selector schedule,
so it does not isolate boundary truncation.

This experiment instead fixes the discreteness scale ``ell``, operator scale
``L``, adjacent ratio, and every count band. Integer four-volume multipliers
``m`` are realized by

``duration_m = duration_1 * m**(1/4)`` and ``events_m = events_1 * m``.

The expected density and all local selector scales are therefore unchanged
while the Alexandrov boundary moves farther away. Coordinates are used only to
generate each oracle causal relation. All interiors, shells, marks, and gates
then use the finite order and inclusive interval cardinalities alone.

This is an external numerical boundary control, not a proof or a continuum
result.
"""

from __future__ import annotations

import argparse
import json
import time
from pathlib import Path

import numpy as np

from causal_adjacent_scale_availability import (
    INTERIOR_ABUNDANCE_THRESHOLD,
    INTERIOR_BAND,
    RETARDED_SHELL_BAND,
    adjacent_scale_schedule,
    sparse_adjacent_scale_support,
    sparse_inclusive_interval_count_matrix,
)
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_operator_metric import (
    diamond_volume_4d,
    finite_statistics,
    sprinkle_minkowski_diamond,
)


def fixed_density_geometry(
    reference_events: int,
    reference_duration: float,
    volume_multiplier: int,
) -> tuple[int, float, float]:
    """Return event count, duration, and ell at fixed expected density."""

    if reference_events <= 0:
        raise ValueError("reference events must be positive")
    if reference_duration <= 0.0:
        raise ValueError("reference duration must be positive")
    if volume_multiplier <= 0:
        raise ValueError("volume multiplier must be a positive integer")
    events = reference_events * volume_multiplier
    duration = reference_duration * volume_multiplier**0.25
    ell = (diamond_volume_4d(duration) / events) ** 0.25
    return events, duration, ell


def _rate(numerator: int, denominator: int) -> float:
    return numerator / denominator if denominator else 0.0


def run_scan(args: argparse.Namespace) -> dict[str, object]:
    if args.reference_events <= 0:
        raise ValueError("reference events must be positive")
    if args.reference_duration <= 0.0:
        raise ValueError("reference duration must be positive")
    if not args.volume_multipliers or any(
        multiplier <= 0 for multiplier in args.volume_multipliers
    ):
        raise ValueError("volume multipliers must be positive integers")
    if len(set(args.volume_multipliers)) != len(args.volume_multipliers):
        raise ValueError("volume multipliers must be distinct")
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    if args.nonlocality_scale <= 0.0:
        raise ValueError("nonlocality scale must be positive")
    if args.adjacent_ratio <= 1.0:
        raise ValueError("adjacent ratio must exceed one")
    if args.minimum_shell_count <= 0:
        raise ValueError("minimum shell count must be positive")
    if not 0.0 <= args.minimum_availability_rate <= 1.0:
        raise ValueError("minimum availability rate must lie in [0, 1]")

    reference_ell = (
        diamond_volume_4d(args.reference_duration) / args.reference_events
    ) ** 0.25
    scales, hierarchy_valid = adjacent_scale_schedule(
        reference_ell,
        args.nonlocality_scale,
        args.adjacent_ratio,
    )
    if not hierarchy_valid:
        raise ValueError("the fixed adjacent scale triple is outside (ell, L)")

    seed_sequence = np.random.SeedSequence(args.seed)
    child_seeds = iter(
        seed_sequence.spawn(
            len(args.volume_multipliers) * args.realizations
        )
    )
    result_rows: list[dict[str, object]] = []

    for volume_multiplier in args.volume_multipliers:
        events, duration, ell = fixed_density_geometry(
            args.reference_events,
            args.reference_duration,
            volume_multiplier,
        )
        realization_seeds = [next(child_seeds) for _ in range(args.realizations)]
        interior_counts: list[list[int]] = [[], [], []]
        common_interior_counts: list[int] = []
        common_interior_fractions: list[float] = []
        shell_counts_by_scale: list[list[int]] = [[], [], []]
        minimum_shell_counts: list[int] = []
        realizations_with_capable_mark = 0
        relation_seconds: list[float] = []
        interval_seconds: list[float] = []
        support_seconds: list[float] = []

        for realization_seed in realization_seeds:
            rng = np.random.default_rng(realization_seed)
            points, _ = sprinkle_minkowski_diamond(rng, events, duration)

            start = time.perf_counter()
            relation = causal_relation_matrix(points, args.block_size)
            relation_seconds.append(time.perf_counter() - start)

            start = time.perf_counter()
            inclusive_counts = sparse_inclusive_interval_count_matrix(relation)
            interval_seconds.append(time.perf_counter() - start)

            start = time.perf_counter()
            _, interiors, _, marks, shell_counts = (
                sparse_adjacent_scale_support(
                    inclusive_counts,
                    ell,
                    args.nonlocality_scale,
                    args.adjacent_ratio,
                )
            )
            support_seconds.append(time.perf_counter() - start)

            for scale_index, interior in enumerate(interiors):
                interior_counts[scale_index].append(
                    int(np.count_nonzero(interior))
                )
            common_interior_counts.append(len(marks))
            common_interior_fractions.append(len(marks) / len(relation))

            if len(marks):
                for scale_index in range(3):
                    shell_counts_by_scale[scale_index].extend(
                        int(count) for count in shell_counts[:, scale_index]
                    )
                minima = np.min(shell_counts, axis=1)
                minimum_shell_counts.extend(int(count) for count in minima)
                if np.any(minima >= args.minimum_shell_count):
                    realizations_with_capable_mark += 1

        common_marks = len(minimum_shell_counts)
        common_interior_realizations = sum(
            count > 0 for count in common_interior_counts
        )
        rank_capable_marks = sum(
            count >= args.minimum_shell_count
            for count in minimum_shell_counts
        )
        nonempty_marks = sum(count > 0 for count in minimum_shell_counts)
        common_interior_rate = _rate(
            common_interior_realizations, args.realizations
        )
        capable_realization_rate = _rate(
            realizations_with_capable_mark, args.realizations
        )
        capable_mark_rate = _rate(rank_capable_marks, common_marks)
        passes_gate = all(
            rate >= args.minimum_availability_rate
            for rate in (
                common_interior_rate,
                capable_realization_rate,
                capable_mark_rate,
            )
        )

        result_rows.append(
            {
                "volume_multiplier": volume_multiplier,
                "events": events,
                "duration": duration,
                "diamond_volume": diamond_volume_4d(duration),
                "ell": ell,
                "ell_relative_error_from_reference": abs(
                    ell - reference_ell
                )
                / reference_ell,
                "duration_over_operator_scale": (
                    duration / args.nonlocality_scale
                ),
                "largest_selector_scale_over_duration": scales[2] / duration,
                "realizations_evaluated": args.realizations,
                "interior_count_by_scale": [
                    finite_statistics(counts) for counts in interior_counts
                ],
                "realizations_with_common_interior_rate": common_interior_rate,
                "common_interior_count": finite_statistics(
                    common_interior_counts
                ),
                "common_interior_fraction": finite_statistics(
                    common_interior_fractions
                ),
                "common_marks_evaluated": common_marks,
                "minimum_shell_count_across_scales": finite_statistics(
                    minimum_shell_counts
                ),
                "retarded_shell_count_by_scale": [
                    finite_statistics(counts)
                    for counts in shell_counts_by_scale
                ],
                "triple_shell_nonempty_rate": _rate(
                    nonempty_marks, common_marks
                ),
                "triple_shell_rank_capable_rate": capable_mark_rate,
                "realizations_with_rank_capable_common_mark_rate": (
                    capable_realization_rate
                ),
                "passes_availability_gate": passes_gate,
                "runtime_seconds": {
                    "relation": finite_statistics(relation_seconds),
                    "inclusive_interval_counts": finite_statistics(
                        interval_seconds
                    ),
                    "support_gate": finite_statistics(support_seconds),
                },
            }
        )

    return {
        "status": "order-only fixed-density larger-diamond boundary control; external numerical oracle",
        "embedding_coordinates_used_after_sprinkling": False,
        "frozen_local_scales_across_volume_ladder": True,
        "scale_schedule": "s = sqrt(ell * L), evaluated at (s/r, s, r*s)",
        "settings": {
            "reference_events": args.reference_events,
            "reference_duration": args.reference_duration,
            "reference_ell": reference_ell,
            "volume_multipliers": args.volume_multipliers,
            "realizations": args.realizations,
            "nonlocality_scale": args.nonlocality_scale,
            "adjacent_ratio": args.adjacent_ratio,
            "adjacent_scales": list(scales),
            "interior_band": list(INTERIOR_BAND),
            "interior_abundance_threshold": INTERIOR_ABUNDANCE_THRESHOLD,
            "retarded_shell_band": list(RETARDED_SHELL_BAND),
            "minimum_shell_count": args.minimum_shell_count,
            "minimum_availability_rate": args.minimum_availability_rate,
            "seed": args.seed,
        },
        "results": result_rows,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reference-events", type=int, default=1200)
    parser.add_argument("--reference-duration", type=float, default=1.0)
    parser.add_argument(
        "--volume-multipliers", nargs="+", type=int, default=[1, 2, 4]
    )
    parser.add_argument("--realizations", type=int, default=10)
    parser.add_argument("--nonlocality-scale", type=float, default=0.18)
    parser.add_argument("--adjacent-ratio", type=float, default=1.25)
    parser.add_argument("--minimum-shell-count", type=int, default=4)
    parser.add_argument("--minimum-availability-rate", type=float, default=0.80)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=2026071603)
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
