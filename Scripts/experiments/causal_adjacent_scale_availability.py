"""Order-only adjacent-scale availability gate for intrinsic probes.

Stage A3 scanned selector scales as fixed fractions of the supplied causal
operator scale ``L``.  At its lower densities this can leave no multiplicative
room for the requested triple ``s / r, s, r * s`` between the discreteness
scale ``ell`` and ``L``.  This companion benchmark first performs that analytic
hierarchy check and then tests the finite causal order only when the hierarchy
exists.

The central scale is frozen at the geometric mean ``sqrt(ell * L)``.  It
maximizes the smaller multiplicative clearance to the two endpoints.  Hence
the adjacent triple exists exactly when ``L / ell > r**2``.  The interior and
retarded-shell count bands are frozen from the best Stage A3 order-side tuple.
No embedding coordinate, target metric, signature, or probe rank is inspected
after the causal relation has been generated.

This is an external numerical oracle, not a proof or a continuum result.
"""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path

import numpy as np
from scipy import sparse

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    two_sided_interior,
)
from causal_operator_metric import (
    diamond_volume_4d,
    finite_statistics,
    sprinkle_minkowski_diamond,
)


INTERIOR_BAND = (0.5, 2.0)
INTERIOR_ABUNDANCE_THRESHOLD = 0.25
RETARDED_SHELL_BAND = (0.5, 4.0)


def sparse_inclusive_interval_count_matrix(
    relation: np.ndarray,
) -> sparse.csr_matrix:
    """Inclusive interval counts on exactly the comparable ordered pairs.

    If ``R`` is the strict relation matrix, ``R @ R`` counts strict open
    intervals. Multiplication by ``R`` removes any two-step path outside the
    supplied relation, and adding ``R`` includes the future endpoint. The
    sparse support is therefore exactly the set of comparable pairs, including
    links whose open-interval count is zero.
    """

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be a square matrix")
    relation_sparse = sparse.csr_matrix(relation, dtype=np.int32)
    open_counts = (relation_sparse @ relation_sparse).multiply(
        relation_sparse
    )
    inclusive_counts = (open_counts + relation_sparse).tocsr()
    inclusive_counts.sum_duplicates()
    inclusive_counts.eliminate_zeros()
    inclusive_counts.sort_indices()
    return inclusive_counts


def sparse_two_sided_interior(
    inclusive_counts: sparse.csr_matrix,
    ell: float,
    selector_scale: float,
    band_lower: float,
    band_upper: float,
    abundance_threshold: float,
) -> np.ndarray:
    """Order-only two-sided interior from sparse inclusive interval counts."""

    if inclusive_counts.shape[0] != inclusive_counts.shape[1]:
        raise ValueError("inclusive count matrix must be square")
    if ell <= 0.0 or selector_scale <= 0.0:
        raise ValueError("interior scales must be positive")
    if not 0.0 < band_lower < band_upper:
        raise ValueError("interior band bounds must be positive and ordered")
    if abundance_threshold <= 0.0:
        raise ValueError("abundance threshold must be positive")

    nu = (selector_scale / ell) ** 4
    in_band = inclusive_counts.copy()
    in_band.data = (
        (in_band.data >= band_lower * nu)
        & (in_band.data <= band_upper * nu)
    ).astype(np.int8)
    in_band.eliminate_zeros()
    past_abundance = np.asarray(in_band.sum(axis=0)).ravel()
    future_abundance = np.asarray(in_band.sum(axis=1)).ravel()
    required = abundance_threshold * nu
    return (past_abundance >= required) & (future_abundance >= required)


def sparse_shell_counts_at_marks(
    inclusive_counts: sparse.csr_matrix,
    interior: np.ndarray,
    marks: np.ndarray,
    ell: float,
    selector_scale: float,
    shell_lower: float,
    shell_upper: float,
) -> np.ndarray:
    """Retarded-shell cardinalities without a dense count submatrix."""

    if inclusive_counts.shape[0] != inclusive_counts.shape[1]:
        raise ValueError("inclusive count matrix must be square")
    if interior.shape != (inclusive_counts.shape[0],):
        raise ValueError("interior has the wrong shape")
    if marks.ndim != 1:
        raise ValueError("marks must be a one-dimensional index array")
    if len(marks) == 0:
        return np.empty(0, dtype=np.int64)
    if np.any(marks < 0) or np.any(marks >= inclusive_counts.shape[0]):
        raise IndexError("a mark is outside the relation")
    if ell <= 0.0 or selector_scale <= 0.0:
        raise ValueError("retarded-shell scales must be positive")
    if not 0.0 < shell_lower < shell_upper:
        raise ValueError("shell bounds must be positive and ordered")

    nu = (selector_scale / ell) ** 4
    marked_counts = inclusive_counts[:, marks].tocoo()
    keep = (
        interior[marked_counts.row]
        & (marked_counts.data >= shell_lower * nu)
        & (marked_counts.data <= shell_upper * nu)
    )
    return np.bincount(
        marked_counts.col[keep], minlength=len(marks)
    ).astype(np.int64)


def adjacent_scale_schedule(
    ell: float,
    operator_scale: float,
    adjacent_ratio: float,
) -> tuple[tuple[float, float, float], bool]:
    """Return the max-clearance scale triple and its strict hierarchy flag."""

    if ell <= 0.0 or operator_scale <= 0.0:
        raise ValueError("ell and operator scale must be positive")
    if adjacent_ratio <= 1.0:
        raise ValueError("adjacent ratio must exceed one")
    central = math.sqrt(ell * operator_scale)
    scales = (
        central / adjacent_ratio,
        central,
        adjacent_ratio * central,
    )
    hierarchy_valid = scales[0] > ell and scales[2] < operator_scale
    return scales, hierarchy_valid


def hierarchy_event_threshold(
    duration: float,
    operator_scale: float,
    adjacent_ratio: float,
) -> float:
    """Continuous event-count threshold for the strict adjacent hierarchy.

    With ``ell = (V / N)**(1/4)``, the hierarchy condition is equivalent to
    ``N > V * r**8 / L**4``.  The returned real threshold preserves that
    strict inequality without introducing a rounding convention.
    """

    if duration <= 0.0 or operator_scale <= 0.0:
        raise ValueError("duration and operator scale must be positive")
    if adjacent_ratio <= 1.0:
        raise ValueError("adjacent ratio must exceed one")
    return (
        diamond_volume_4d(duration)
        * adjacent_ratio**8
        / operator_scale**4
    )


def shell_counts_at_marks(
    relation: np.ndarray,
    interval_counts: np.ndarray,
    interior: np.ndarray,
    marks: np.ndarray,
    ell: float,
    selector_scale: float,
    shell_lower: float,
    shell_upper: float,
) -> np.ndarray:
    """Retarded-shell cardinalities at an explicitly supplied mark set."""

    if marks.ndim != 1:
        raise ValueError("marks must be a one-dimensional index array")
    if len(marks) == 0:
        return np.empty(0, dtype=np.int64)
    if np.any(marks < 0) or np.any(marks >= len(relation)):
        raise IndexError("a mark is outside the relation")
    if ell <= 0.0 or selector_scale <= 0.0:
        raise ValueError("retarded-shell scales must be positive")
    if not 0.0 < shell_lower < shell_upper:
        raise ValueError("shell bounds must be positive and ordered")

    nu = (selector_scale / ell) ** 4
    counts = interval_counts[:, marks].astype(float) + 1.0
    shell = (
        relation[:, marks]
        & interior[:, None]
        & (counts >= shell_lower * nu)
        & (counts <= shell_upper * nu)
    )
    return np.count_nonzero(shell, axis=0)


def adjacent_scale_support(
    relation: np.ndarray,
    interval_counts: np.ndarray,
    ell: float,
    operator_scale: float,
    adjacent_ratio: float,
) -> tuple[
    tuple[float, float, float],
    tuple[np.ndarray, np.ndarray, np.ndarray],
    np.ndarray,
    np.ndarray,
    np.ndarray,
]:
    """Interiors and shell counts on the common adjacent-scale mark set.

    The shell-count matrix has one row per common mark and one column per
    scale, ordered as ``s / r, s, r * s``.
    """

    scales, hierarchy_valid = adjacent_scale_schedule(
        ell, operator_scale, adjacent_ratio
    )
    if not hierarchy_valid:
        raise ValueError("the adjacent scale triple is outside (ell, L)")

    interiors = tuple(
        two_sided_interior(
            relation,
            interval_counts,
            ell,
            scale,
            INTERIOR_BAND[0],
            INTERIOR_BAND[1],
            INTERIOR_ABUNDANCE_THRESHOLD,
        )
        for scale in scales
    )
    common_interior = np.logical_and.reduce(interiors)
    marks = np.flatnonzero(common_interior)
    columns = [
        shell_counts_at_marks(
            relation,
            interval_counts,
            interior,
            marks,
            ell,
            scale,
            RETARDED_SHELL_BAND[0],
            RETARDED_SHELL_BAND[1],
        )
        for scale, interior in zip(scales, interiors, strict=True)
    ]
    shell_counts = (
        np.column_stack(columns)
        if len(marks)
        else np.empty((0, len(scales)), dtype=np.int64)
    )
    return scales, interiors, common_interior, marks, shell_counts


def sparse_adjacent_scale_support(
    inclusive_counts: sparse.csr_matrix,
    ell: float,
    operator_scale: float,
    adjacent_ratio: float,
) -> tuple[
    tuple[float, float, float],
    tuple[np.ndarray, np.ndarray, np.ndarray],
    np.ndarray,
    np.ndarray,
    np.ndarray,
]:
    """Sparse equivalent of ``adjacent_scale_support``."""

    scales, hierarchy_valid = adjacent_scale_schedule(
        ell, operator_scale, adjacent_ratio
    )
    if not hierarchy_valid:
        raise ValueError("the adjacent scale triple is outside (ell, L)")

    interiors = tuple(
        sparse_two_sided_interior(
            inclusive_counts,
            ell,
            scale,
            INTERIOR_BAND[0],
            INTERIOR_BAND[1],
            INTERIOR_ABUNDANCE_THRESHOLD,
        )
        for scale in scales
    )
    common_interior = np.logical_and.reduce(interiors)
    marks = np.flatnonzero(common_interior)
    columns = [
        sparse_shell_counts_at_marks(
            inclusive_counts,
            interior,
            marks,
            ell,
            scale,
            RETARDED_SHELL_BAND[0],
            RETARDED_SHELL_BAND[1],
        )
        for scale, interior in zip(scales, interiors, strict=True)
    ]
    shell_counts = (
        np.column_stack(columns)
        if len(marks)
        else np.empty((0, len(scales)), dtype=np.int64)
    )
    return scales, interiors, common_interior, marks, shell_counts


def _rate(numerator: int, denominator: int) -> float:
    return numerator / denominator if denominator else 0.0


def run_scan(args: argparse.Namespace) -> dict[str, object]:
    if not args.events or any(events <= 0 for events in args.events):
        raise ValueError("events must contain positive integers")
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    if args.duration <= 0.0:
        raise ValueError("duration must be positive")
    if args.nonlocality_scale <= 0.0:
        raise ValueError("nonlocality scale must be positive")
    if args.adjacent_ratio <= 1.0:
        raise ValueError("adjacent ratio must exceed one")
    if args.minimum_shell_count <= 0:
        raise ValueError("minimum shell count must be positive")
    if not 0.0 <= args.minimum_availability_rate <= 1.0:
        raise ValueError("minimum availability rate must lie in [0, 1]")

    seed_sequence = np.random.SeedSequence(args.seed)
    child_seeds = iter(
        seed_sequence.spawn(len(args.events) * args.realizations)
    )
    result_rows: list[dict[str, object]] = []

    for events in args.events:
        realization_seeds = [next(child_seeds) for _ in range(args.realizations)]
        volume = diamond_volume_4d(args.duration)
        ell = (volume / events) ** 0.25
        scales, hierarchy_valid = adjacent_scale_schedule(
            ell, args.nonlocality_scale, args.adjacent_ratio
        )
        lower_clearance = scales[0] / ell
        upper_clearance = args.nonlocality_scale / scales[2]

        interior_counts: list[list[int]] = [[], [], []]
        common_interior_counts: list[int] = []
        shell_counts_by_scale: list[list[int]] = [[], [], []]
        minimum_shell_counts: list[int] = []
        realizations_with_capable_mark = 0

        if hierarchy_valid:
            for realization_seed in realization_seeds:
                rng = np.random.default_rng(realization_seed)
                points, _ = sprinkle_minkowski_diamond(
                    rng, events, args.duration
                )
                relation = causal_relation_matrix(points, args.block_size)
                inclusive_counts = sparse_inclusive_interval_count_matrix(
                    relation
                )
                _, interiors, _, marks, shell_counts = (
                    sparse_adjacent_scale_support(
                        inclusive_counts,
                        ell,
                        args.nonlocality_scale,
                        args.adjacent_ratio,
                    )
                )

                for scale_index, interior in enumerate(interiors):
                    interior_counts[scale_index].append(
                        int(np.count_nonzero(interior))
                    )
                common_interior_counts.append(len(marks))

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
            common_interior_realizations, len(common_interior_counts)
        )
        capable_realization_rate = _rate(
            realizations_with_capable_mark, len(common_interior_counts)
        )
        capable_mark_rate = _rate(rank_capable_marks, common_marks)
        passes_gate = hierarchy_valid and all(
            rate >= args.minimum_availability_rate
            for rate in (
                common_interior_rate,
                capable_realization_rate,
                capable_mark_rate,
            )
        )

        result_rows.append(
            {
                "events": events,
                "ell": ell,
                "operator_scale_over_ell": args.nonlocality_scale / ell,
                "adjacent_scales": list(scales),
                "adjacent_scale_ratios_to_operator_scale": [
                    scale / args.nonlocality_scale for scale in scales
                ],
                "lower_hierarchy_clearance": lower_clearance,
                "upper_hierarchy_clearance": upper_clearance,
                "hierarchy_valid": hierarchy_valid,
                "realizations_evaluated": (
                    args.realizations if hierarchy_valid else 0
                ),
                "interior_count_by_scale": [
                    finite_statistics(counts) for counts in interior_counts
                ],
                "realizations_with_common_interior_rate": common_interior_rate,
                "common_interior_count": finite_statistics(
                    common_interior_counts
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
            }
        )

    return {
        "status": "order-only adjacent-scale availability scan; external numerical oracle",
        "embedding_coordinates_used_after_sprinkling": False,
        "scale_schedule": "s = sqrt(ell * L), evaluated at (s/r, s, r*s)",
        "strict_hierarchy_condition": "L / ell > r^2",
        "continuous_event_threshold": hierarchy_event_threshold(
            args.duration,
            args.nonlocality_scale,
            args.adjacent_ratio,
        ),
        "settings": {
            "events": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "nonlocality_scale": args.nonlocality_scale,
            "adjacent_ratio": args.adjacent_ratio,
            "interior_band": list(INTERIOR_BAND),
            "interior_abundance_threshold": (
                INTERIOR_ABUNDANCE_THRESHOLD
            ),
            "retarded_shell_band": list(RETARDED_SHELL_BAND),
            "minimum_shell_count": args.minimum_shell_count,
            "minimum_availability_rate": args.minimum_availability_rate,
            "seed": args.seed,
        },
        "results": result_rows,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", nargs="+", type=int, default=[400, 800, 1200])
    parser.add_argument("--realizations", type=int, default=10)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--nonlocality-scale", type=float, default=0.18)
    parser.add_argument("--adjacent-ratio", type=float, default=1.25)
    parser.add_argument("--minimum-shell-count", type=int, default=4)
    parser.add_argument("--minimum-availability-rate", type=float, default=0.80)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20260716)
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
