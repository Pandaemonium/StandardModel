"""Compact order-derived Alexandrov carrier gate.

Stage A3c showed that a global fixed-count shell is controlled by the
infrared Alexandrov boundary. This experiment replaces that shell by an
equivariant ensemble of finite brackets ``p < x < q``. Endpoint balance and
the bracket score use only inclusive interval counts. Embedding coordinates
are unavailable to every selector and are reopened only after selection for
the declared coordinate-control pairing.

The primary statistics are clustered first by mark and then by realization.
Pooled bracket counts are diagnostic only. This is an external finite oracle,
not a continuum theorem or a bare-graph metric reconstruction.
"""

from __future__ import annotations

import argparse
import json
import time
from dataclasses import dataclass
from itertools import combinations
from pathlib import Path

import numpy as np
from scipy import sparse

from causal_adjacent_scale_availability import (
    INTERIOR_ABUNDANCE_THRESHOLD,
    INTERIOR_BAND,
    RETARDED_SHELL_BAND,
    adjacent_scale_schedule,
    sparse_adjacent_scale_support,
    sparse_inclusive_interval_count_matrix,
    sparse_shell_counts_at_marks,
    sparse_two_sided_interior,
)
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_larger_diamond_support import fixed_density_geometry
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    corrected_gamma,
    diamond_volume_4d,
    finite_statistics,
    matrix_relative_error,
    project_convention_row,
    signature,
    smeared_bd_row,
    sprinkle_minkowski_diamond,
)


ENDPOINT_COUNT_BAND = (0.75, 1.25)
TIGHT_EXCESS_CAP = 1.5
LOOSE_EXCESS_CAP = 2.0
MAX_BRACKETS = 32
MINIMUM_BRACKETS = 8
MARKS_PER_REALIZATION = 8
MINIMUM_SHELL_COUNT = 4
MINIMUM_RATE = 0.80
MAXIMUM_BOUNDARY_RATE_DRIFT = 0.10
MAXIMUM_CARRIER_SIZE_DRIFT = 0.15
MINIMUM_OVERLAP_JACCARD = 0.25
MAXIMUM_OVERLAP_METRIC_DISAGREEMENT = 0.25
MAXIMUM_REFINEMENT_METRIC_DISAGREEMENT = 0.25
MAXIMUM_COORDINATE_METRIC_ERROR = 0.50


@dataclass(frozen=True)
class CountBalancedBracket:
    """One label-equivariantly selected bracket around a marked event."""

    past_endpoint: int
    future_endpoint: int
    past_half_count: int
    future_half_count: int
    inclusive_carrier_count: int
    rapidity_excess: float


@dataclass(frozen=True)
class BracketEvaluation:
    """Internal evaluation record for one already-selected bracket."""

    bracket: CountBalancedBracket
    carrier: np.ndarray
    shell_counts: tuple[int, int, int]
    mark_is_common_interior: bool
    rank_capable: bool
    pairing: np.ndarray
    coordinate_metric_error: float
    pairing_signature: tuple[int, int, int]


def count_rapidity_excess(
    past_half_count: int,
    future_half_count: int,
    inclusive_carrier_count: int,
) -> float:
    """Count-volume excess above the collinear four-volume composition."""

    if past_half_count <= 0 or future_half_count <= 0:
        raise ValueError("half-interval counts must be positive")
    if inclusive_carrier_count <= 0:
        raise ValueError("carrier count must be positive")
    minimum = (
        past_half_count**0.25 + future_half_count**0.25
    ) ** 4
    return float(inclusive_carrier_count / minimum)


def _score_stratified_mask(
    scores: np.ndarray, maximum_brackets: int
) -> np.ndarray:
    """Keep low/high score strata and all ties without using event labels."""

    if scores.ndim != 1:
        raise ValueError("scores must be one-dimensional")
    if maximum_brackets <= 0 or maximum_brackets % 2:
        raise ValueError("maximum_brackets must be positive and even")
    if len(scores) <= maximum_brackets:
        return np.ones(len(scores), dtype=bool)
    half = maximum_brackets // 2
    low_cutoff = np.partition(scores, half - 1)[half - 1]
    high_cutoff = np.partition(scores, len(scores) - half)[len(scores) - half]
    return (scores <= low_cutoff) | (scores >= high_cutoff)


def select_count_balanced_brackets(
    inclusive_counts: sparse.csr_matrix,
    mark: int,
    half_count_target: float,
    endpoint_count_band: tuple[float, float],
    excess_cap: float,
    maximum_brackets: int = MAX_BRACKETS,
) -> list[CountBalancedBracket]:
    """Select a complete score-stratified bracket ensemble from counts only."""

    if inclusive_counts.shape[0] != inclusive_counts.shape[1]:
        raise ValueError("inclusive count matrix must be square")
    if not 0 <= mark < inclusive_counts.shape[0]:
        raise IndexError("mark is outside the order")
    if half_count_target <= 0.0:
        raise ValueError("half_count_target must be positive")
    lower_factor, upper_factor = endpoint_count_band
    if not 0.0 < lower_factor < upper_factor:
        raise ValueError("endpoint count band must be positive and ordered")
    if excess_cap <= 0.0:
        raise ValueError("excess_cap must be positive")

    lower = lower_factor * half_count_target
    upper = upper_factor * half_count_target
    past_column = inclusive_counts.getcol(mark).tocoo()
    past_keep = (past_column.data >= lower) & (past_column.data <= upper)
    past = past_column.row[past_keep].astype(np.int64)
    past_counts = past_column.data[past_keep].astype(np.int64)

    future_row = inclusive_counts.getrow(mark).tocoo()
    future_keep = (future_row.data >= lower) & (future_row.data <= upper)
    future = future_row.col[future_keep].astype(np.int64)
    future_counts = future_row.data[future_keep].astype(np.int64)
    if len(past) == 0 or len(future) == 0:
        return []

    carrier_counts = inclusive_counts[past][:, future].toarray()
    past_grid = np.broadcast_to(past_counts[:, None], carrier_counts.shape)
    future_grid = np.broadcast_to(future_counts[None, :], carrier_counts.shape)
    comparable = carrier_counts > 0
    minimum = (past_grid**0.25 + future_grid**0.25) ** 4
    excess = np.full(carrier_counts.shape, np.inf, dtype=float)
    excess[comparable] = carrier_counts[comparable] / minimum[comparable]
    eligible = comparable & (excess <= excess_cap)
    rows, columns = np.nonzero(eligible)
    if len(rows) == 0:
        return []
    scores = excess[rows, columns]
    retain = _score_stratified_mask(scores, maximum_brackets)

    brackets = [
        CountBalancedBracket(
            past_endpoint=int(past[row]),
            future_endpoint=int(future[column]),
            past_half_count=int(past_counts[row]),
            future_half_count=int(future_counts[column]),
            inclusive_carrier_count=int(carrier_counts[row, column]),
            rapidity_excess=float(excess[row, column]),
        )
        for row, column in zip(rows[retain], columns[retain], strict=True)
    ]
    return sorted(
        brackets,
        key=lambda bracket: (
            bracket.rapidity_excess,
            bracket.past_endpoint,
            bracket.future_endpoint,
        ),
    )


def open_bracket_carrier(
    relation: np.ndarray, bracket: CountBalancedBracket
) -> np.ndarray:
    """Open Alexandrov bracket ``p < z < q`` as a Boolean carrier."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    p = bracket.past_endpoint
    q = bracket.future_endpoint
    if not (0 <= p < len(relation) and 0 <= q < len(relation)):
        raise IndexError("a bracket endpoint is outside the relation")
    return relation[p] & relation[:, q]


def induced_counts_match_global(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    carrier: np.ndarray,
) -> bool:
    """Check interval convexity of an induced carrier against global counts."""

    if carrier.shape != (len(relation),):
        raise ValueError("carrier has the wrong shape")
    indices = np.flatnonzero(carrier)
    local_relation = relation[np.ix_(indices, indices)]
    local_counts = sparse_inclusive_interval_count_matrix(local_relation)
    restricted = inclusive_counts[indices][:, indices]
    return (local_counts != restricted).nnz == 0


def _operator_row_at_mark(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    mark: int,
    ell: float,
    nonlocality_scale: float,
) -> np.ndarray:
    inclusive_column = np.asarray(
        inclusive_counts.getcol(mark).toarray()
    ).ravel()
    open_counts = np.maximum(inclusive_column - 1, 0).astype(np.int64)
    source_row = smeared_bd_row(
        relation[:, mark],
        open_counts,
        mark,
        ell,
        nonlocality_scale,
    )
    return project_convention_row(source_row)


def evaluate_selected_bracket(
    bracket: CountBalancedBracket,
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    mark: int,
    scales: tuple[float, float, float],
    ell: float,
    operator_row: np.ndarray,
    coordinate_probes: np.ndarray,
) -> BracketEvaluation:
    """Evaluate induced-order support and a post-selection coordinate control."""

    carrier = open_bracket_carrier(relation, bracket)
    if not carrier[mark]:
        raise ValueError("selected bracket does not contain its mark")
    indices = np.flatnonzero(carrier)
    target_local = int(np.flatnonzero(indices == mark)[0])
    local_counts = inclusive_counts[indices][:, indices].tocsr()
    interiors = tuple(
        sparse_two_sided_interior(
            local_counts,
            ell,
            scale,
            INTERIOR_BAND[0],
            INTERIOR_BAND[1],
            INTERIOR_ABUNDANCE_THRESHOLD,
        )
        for scale in scales
    )
    local_mark = np.array([target_local], dtype=np.int64)
    shell_counts = tuple(
        int(
            sparse_shell_counts_at_marks(
                local_counts,
                interior,
                local_mark,
                ell,
                scale,
                RETARDED_SHELL_BAND[0],
                RETARDED_SHELL_BAND[1],
            )[0]
        )
        for scale, interior in zip(scales, interiors, strict=True)
    )
    mark_is_common = all(interior[target_local] for interior in interiors)
    rank_capable = mark_is_common and min(shell_counts) >= MINIMUM_SHELL_COUNT

    restricted_row = operator_row * carrier
    pairing = corrected_gamma(restricted_row, coordinate_probes, mark)
    return BracketEvaluation(
        bracket=bracket,
        carrier=carrier,
        shell_counts=shell_counts,
        mark_is_common_interior=bool(mark_is_common),
        rank_capable=bool(rank_capable),
        pairing=pairing,
        coordinate_metric_error=matrix_relative_error(
            pairing, MINKOWSKI_INVERSE
        ),
        pairing_signature=signature(pairing),
    )


def symmetric_matrix_disagreement(left: np.ndarray, right: np.ndarray) -> float:
    """Symmetric relative Frobenius disagreement between two matrices."""

    denominator = max(
        float(np.linalg.norm(left, ord="fro")),
        float(np.linalg.norm(right, ord="fro")),
        1.0e-15,
    )
    return float(np.linalg.norm(left - right, ord="fro") / denominator)


def carrier_jaccard(left: np.ndarray, right: np.ndarray) -> float:
    """Jaccard overlap of two Boolean carriers."""

    if left.shape != right.shape:
        raise ValueError("carriers must have the same shape")
    union = np.count_nonzero(left | right)
    return float(np.count_nonzero(left & right) / union) if union else 1.0


def _median_pairing(evaluations: list[BracketEvaluation]) -> np.ndarray | None:
    if not evaluations:
        return None
    return np.median(
        np.stack([evaluation.pairing for evaluation in evaluations]), axis=0
    )


def evaluate_mark(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    coordinate_probes: np.ndarray,
    mark: int,
    scales: tuple[float, float, float],
    ell: float,
    nonlocality_scale: float,
    maximum_brackets: int,
) -> dict[str, object]:
    """Evaluate both frozen bracket ensembles at one order-selected mark."""

    half_target = (nonlocality_scale / ell) ** 4
    tight = select_count_balanced_brackets(
        inclusive_counts,
        mark,
        half_target,
        ENDPOINT_COUNT_BAND,
        TIGHT_EXCESS_CAP,
        maximum_brackets,
    )
    loose = select_count_balanced_brackets(
        inclusive_counts,
        mark,
        half_target,
        ENDPOINT_COUNT_BAND,
        LOOSE_EXCESS_CAP,
        maximum_brackets,
    )
    operator_row = _operator_row_at_mark(
        relation, inclusive_counts, mark, ell, nonlocality_scale
    )
    cache: dict[tuple[int, int], BracketEvaluation] = {}
    for bracket in [*tight, *loose]:
        key = (bracket.past_endpoint, bracket.future_endpoint)
        if key not in cache:
            cache[key] = evaluate_selected_bracket(
                bracket,
                relation,
                inclusive_counts,
                mark,
                scales,
                ell,
                operator_row,
                coordinate_probes,
            )
    tight_evaluations = [
        cache[(bracket.past_endpoint, bracket.future_endpoint)]
        for bracket in tight
    ]
    loose_evaluations = [
        cache[(bracket.past_endpoint, bracket.future_endpoint)]
        for bracket in loose
    ]

    overlap_disagreements: list[float] = []
    overlap_jaccards: list[float] = []
    for left, right in combinations(tight_evaluations, 2):
        overlap = carrier_jaccard(left.carrier, right.carrier)
        if overlap >= MINIMUM_OVERLAP_JACCARD:
            overlap_jaccards.append(overlap)
            overlap_disagreements.append(
                symmetric_matrix_disagreement(left.pairing, right.pairing)
            )

    tight_pairing = _median_pairing(tight_evaluations)
    loose_pairing = _median_pairing(loose_evaluations)
    refinement_disagreement = (
        None
        if tight_pairing is None or loose_pairing is None
        else symmetric_matrix_disagreement(tight_pairing, loose_pairing)
    )
    tight_count = len(tight_evaluations)
    rank_count = sum(evaluation.rank_capable for evaluation in tight_evaluations)
    signature_count = sum(
        evaluation.pairing_signature == (1, 3, 0)
        for evaluation in tight_evaluations
    )
    return {
        "mark": mark,
        "half_count_target": half_target,
        "tight_bracket_count": tight_count,
        "loose_bracket_count": len(loose_evaluations),
        "qualifies_minimum_brackets": tight_count >= MINIMUM_BRACKETS,
        "tight_rank_capable_rate": rank_count / tight_count if tight_count else 0.0,
        "tight_lorentzian_signature_rate": (
            signature_count / tight_count if tight_count else 0.0
        ),
        "tight_common_interior_rate": (
            sum(
                evaluation.mark_is_common_interior
                for evaluation in tight_evaluations
            )
            / tight_count
            if tight_count
            else 0.0
        ),
        "tight_carrier_size": finite_statistics(
            [int(np.count_nonzero(evaluation.carrier)) for evaluation in tight_evaluations]
        ),
        "tight_rapidity_excess": finite_statistics(
            [evaluation.bracket.rapidity_excess for evaluation in tight_evaluations]
        ),
        "tight_shell_count_by_scale": [
            finite_statistics(
                [evaluation.shell_counts[index] for evaluation in tight_evaluations]
            )
            for index in range(3)
        ],
        "tight_coordinate_metric_error": finite_statistics(
            [evaluation.coordinate_metric_error for evaluation in tight_evaluations]
        ),
        "has_overlap_pair": bool(overlap_disagreements),
        "overlap_pair_count": len(overlap_disagreements),
        "overlap_jaccard": finite_statistics(overlap_jaccards),
        "overlap_metric_disagreement": finite_statistics(overlap_disagreements),
        "tight_loose_metric_disagreement": refinement_disagreement,
    }


def _values(rows: list[dict[str, object]], key: str) -> list[float]:
    return [float(row[key]) for row in rows if row.get(key) is not None]


def summarize_realization(mark_rows: list[dict[str, object]]) -> dict[str, object]:
    """Cluster bracket data at marks before producing realization statistics."""

    qualifying = [row for row in mark_rows if row["qualifies_minimum_brackets"]]
    overlap_qualified = [row for row in qualifying if row["has_overlap_pair"]]
    tight_metric_errors = [
        float(row["tight_coordinate_metric_error"]["median"])
        for row in qualifying
        if row["tight_coordinate_metric_error"]["median"] is not None
    ]
    overlap_errors = [
        float(row["overlap_metric_disagreement"]["median"])
        for row in overlap_qualified
        if row["overlap_metric_disagreement"]["median"] is not None
    ]
    carrier_sizes = [
        float(row["tight_carrier_size"]["median"])
        for row in qualifying
        if row["tight_carrier_size"]["median"] is not None
    ]
    refinement_errors = _values(qualifying, "tight_loose_metric_disagreement")
    rank_rates = _values(qualifying, "tight_rank_capable_rate")
    signature_rates = _values(qualifying, "tight_lorentzian_signature_rate")
    mark_count = len(mark_rows)
    qualifying_rate = len(qualifying) / mark_count if mark_count else 0.0
    overlap_rate = (
        len(overlap_qualified) / len(qualifying) if qualifying else 0.0
    )
    median_rank_rate = float(np.median(rank_rates)) if rank_rates else 0.0
    return {
        "marks_evaluated": mark_count,
        "qualifying_mark_rate": qualifying_rate,
        "qualifying_marks": len(qualifying),
        "median_clustered_rank_capable_rate": median_rank_rate,
        "median_clustered_signature_rate": (
            float(np.median(signature_rates)) if signature_rates else 0.0
        ),
        "median_tight_carrier_size": (
            float(np.median(carrier_sizes)) if carrier_sizes else None
        ),
        "qualifying_mark_overlap_rate": overlap_rate,
        "median_overlap_metric_disagreement": (
            float(np.median(overlap_errors)) if overlap_errors else None
        ),
        "median_refinement_metric_disagreement": (
            float(np.median(refinement_errors)) if refinement_errors else None
        ),
        "median_coordinate_metric_error": (
            float(np.median(tight_metric_errors)) if tight_metric_errors else None
        ),
        "passes_availability_rank_gate": (
            qualifying_rate >= MINIMUM_RATE and median_rank_rate >= MINIMUM_RATE
        ),
        "mark_results": mark_rows,
    }


def _median_present(rows: list[dict[str, object]], key: str) -> float | None:
    values = _values(rows, key)
    return float(np.median(values)) if values else None


def run_scan(args: argparse.Namespace) -> dict[str, object]:
    """Run the frozen fixed-density bracket-carrier ladder."""

    if args.reference_events <= 0 or args.reference_duration <= 0.0:
        raise ValueError("reference geometry must be positive")
    if args.realizations <= 0 or args.marks_per_realization <= 0:
        raise ValueError("realization and mark counts must be positive")
    if not args.volume_multipliers or any(
        multiplier <= 0 for multiplier in args.volume_multipliers
    ):
        raise ValueError("volume multipliers must be positive")
    if len(set(args.volume_multipliers)) != len(args.volume_multipliers):
        raise ValueError("volume multipliers must be distinct")
    if args.nonlocality_scale <= 0.0 or args.adjacent_ratio <= 1.0:
        raise ValueError("operator scale and adjacent ratio are invalid")

    reference_ell = (
        diamond_volume_4d(args.reference_duration) / args.reference_events
    ) ** 0.25
    scales, hierarchy_valid = adjacent_scale_schedule(
        reference_ell, args.nonlocality_scale, args.adjacent_ratio
    )
    if not hierarchy_valid:
        raise ValueError("the adjacent scale hierarchy is invalid")

    seed_sequence = np.random.SeedSequence(args.seed)
    child_seeds = iter(
        seed_sequence.spawn(len(args.volume_multipliers) * args.realizations)
    )
    result_rows: list[dict[str, object]] = []
    for multiplier in args.volume_multipliers:
        events, duration, ell = fixed_density_geometry(
            args.reference_events, args.reference_duration, multiplier
        )
        realizations: list[dict[str, object]] = []
        runtimes: list[float] = []
        for _ in range(args.realizations):
            rng = np.random.default_rng(next(child_seeds))
            start = time.perf_counter()
            points, _ = sprinkle_minkowski_diamond(rng, events, duration)
            relation = causal_relation_matrix(points, args.block_size)
            inclusive_counts = sparse_inclusive_interval_count_matrix(relation)
            _, _, _, common_marks, _ = sparse_adjacent_scale_support(
                inclusive_counts,
                ell,
                args.nonlocality_scale,
                args.adjacent_ratio,
            )
            sample_size = min(args.marks_per_realization, len(common_marks))
            sampled_marks = (
                np.sort(rng.choice(common_marks, size=sample_size, replace=False))
                if sample_size
                else np.empty(0, dtype=np.int64)
            )
            mark_rows = [
                evaluate_mark(
                    relation,
                    inclusive_counts,
                    points,
                    int(mark),
                    scales,
                    ell,
                    args.nonlocality_scale,
                    args.maximum_brackets,
                )
                for mark in sampled_marks
            ]
            realization = summarize_realization(mark_rows)
            realization["common_marks_available"] = len(common_marks)
            realization["sampled_marks"] = [int(mark) for mark in sampled_marks]
            realizations.append(realization)
            runtimes.append(time.perf_counter() - start)

        result_rows.append(
            {
                "volume_multiplier": multiplier,
                "events": events,
                "duration": duration,
                "ell": ell,
                "realizations_evaluated": args.realizations,
                "availability_rank_realizations_passing": sum(
                    row["passes_availability_rank_gate"] for row in realizations
                ),
                "clustered_rank_capable_rate": finite_statistics(
                    _values(realizations, "median_clustered_rank_capable_rate")
                ),
                "qualifying_mark_rate": finite_statistics(
                    _values(realizations, "qualifying_mark_rate")
                ),
                "tight_carrier_size": finite_statistics(
                    _values(realizations, "median_tight_carrier_size")
                ),
                "qualifying_mark_overlap_rate": finite_statistics(
                    _values(realizations, "qualifying_mark_overlap_rate")
                ),
                "overlap_metric_disagreement": finite_statistics(
                    _values(realizations, "median_overlap_metric_disagreement")
                ),
                "refinement_metric_disagreement": finite_statistics(
                    _values(realizations, "median_refinement_metric_disagreement")
                ),
                "coordinate_metric_error": finite_statistics(
                    _values(realizations, "median_coordinate_metric_error")
                ),
                "clustered_lorentzian_signature_rate": finite_statistics(
                    _values(realizations, "median_clustered_signature_rate")
                ),
                "runtime_seconds": finite_statistics(runtimes),
                "realizations": realizations,
            }
        )

    by_multiplier = {
        int(row["volume_multiplier"]): row for row in result_rows
    }
    largest = by_multiplier[max(by_multiplier)]
    four_row = by_multiplier.get(4)
    two_row = by_multiplier.get(2)
    availability_rank_gate = (
        four_row is not None
        and int(four_row["availability_rank_realizations_passing"]) >= 4
    )
    boundary_rate_drift = None
    carrier_size_drift = None
    if two_row is not None and four_row is not None:
        rate_two = two_row["clustered_rank_capable_rate"]["median"]
        rate_four = four_row["clustered_rank_capable_rate"]["median"]
        size_two = two_row["tight_carrier_size"]["median"]
        size_four = four_row["tight_carrier_size"]["median"]
        if rate_two is not None and rate_four is not None:
            boundary_rate_drift = abs(float(rate_four) - float(rate_two))
        if size_two is not None and size_four is not None and float(size_two) > 0.0:
            carrier_size_drift = abs(float(size_four) - float(size_two)) / float(
                size_two
            )

    overlap_rate = largest["qualifying_mark_overlap_rate"]["median"]
    overlap_error = largest["overlap_metric_disagreement"]["median"]
    refinement_error = largest["refinement_metric_disagreement"]["median"]
    metric_error = largest["coordinate_metric_error"]["median"]
    signature_rate = largest["clustered_lorentzian_signature_rate"]["median"]
    gates = {
        "availability_and_rank": bool(availability_rank_gate),
        "boundary_rank_rate_stability": (
            boundary_rate_drift is not None
            and boundary_rate_drift <= MAXIMUM_BOUNDARY_RATE_DRIFT
        ),
        "boundary_carrier_size_stability": (
            carrier_size_drift is not None
            and carrier_size_drift <= MAXIMUM_CARRIER_SIZE_DRIFT
        ),
        "overlap_availability": overlap_rate is not None and overlap_rate >= MINIMUM_RATE,
        "overlap_metric_stability": (
            overlap_error is not None
            and overlap_error <= MAXIMUM_OVERLAP_METRIC_DISAGREEMENT
        ),
        "compactness_refinement_stability": (
            refinement_error is not None
            and refinement_error <= MAXIMUM_REFINEMENT_METRIC_DISAGREEMENT
        ),
        "coordinate_metric_control": (
            metric_error is not None
            and metric_error <= MAXIMUM_COORDINATE_METRIC_ERROR
        ),
        "lorentzian_signature_control": (
            signature_rate is not None and signature_rate >= MINIMUM_RATE
        ),
    }
    return {
        "status": "external finite compact-bracket carrier gate",
        "selector_uses_embedding_coordinates": False,
        "coordinates_used_for_postselection_control": True,
        "primary_inference_unit": "realization clustered through marks",
        "settings": {
            "reference_events": args.reference_events,
            "reference_duration": args.reference_duration,
            "reference_ell": reference_ell,
            "volume_multipliers": args.volume_multipliers,
            "realizations": args.realizations,
            "marks_per_realization": args.marks_per_realization,
            "nonlocality_scale": args.nonlocality_scale,
            "adjacent_ratio": args.adjacent_ratio,
            "adjacent_scales": list(scales),
            "endpoint_count_band": list(ENDPOINT_COUNT_BAND),
            "tight_excess_cap": TIGHT_EXCESS_CAP,
            "loose_excess_cap": LOOSE_EXCESS_CAP,
            "maximum_brackets": args.maximum_brackets,
            "minimum_brackets": MINIMUM_BRACKETS,
            "minimum_shell_count": MINIMUM_SHELL_COUNT,
            "seed": args.seed,
        },
        "boundary_rate_drift_2_to_4": boundary_rate_drift,
        "carrier_size_relative_drift_2_to_4": carrier_size_drift,
        "gates": gates,
        "passes_all_gates": all(gates.values()),
        "results": result_rows,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reference-events", type=int, default=1200)
    parser.add_argument("--reference-duration", type=float, default=1.0)
    parser.add_argument(
        "--volume-multipliers", nargs="+", type=int, default=[1, 2, 4]
    )
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument(
        "--marks-per-realization", type=int, default=MARKS_PER_REALIZATION
    )
    parser.add_argument("--maximum-brackets", type=int, default=MAX_BRACKETS)
    parser.add_argument("--nonlocality-scale", type=float, default=0.18)
    parser.add_argument("--adjacent-ratio", type=float, default=1.25)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=2026071605)
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
