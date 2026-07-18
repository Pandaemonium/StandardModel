"""Buffered outer-regulator and inner causal-germ gate.

Stage A3e separates the compact Alexandrov boundary regulator from the
unchanged three-scale evaluation germ. Two count-derived outer buffer rungs
are selected by complete minimum-excess orbits, with the smaller rung required
to be genuinely nested in the larger. Coordinates are unavailable to every
order-side selector and are used only if the frozen support gate passes.

This is an external finite oracle. It is not a continuum theorem, intrinsic
tetrad reconstruction, or derivation of gravitational dynamics.
"""

from __future__ import annotations

import argparse
import json
import math
import time
from dataclasses import dataclass
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
    sparse_two_sided_interior,
)
from causal_compact_bracket_carrier import (
    ENDPOINT_COUNT_BAND,
    MINIMUM_SHELL_COUNT,
    TIGHT_EXCESS_CAP,
    CountBalancedBracket,
    _operator_row_at_mark,
    carrier_jaccard,
    induced_counts_match_global,
    open_bracket_carrier,
    select_count_balanced_brackets,
    symmetric_matrix_disagreement,
)
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_larger_diamond_support import fixed_density_geometry
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    corrected_gamma,
    finite_statistics,
    matrix_relative_error,
    signature,
    sprinkle_minkowski_diamond,
)


TIGHT_BUFFER_RATIO = 24.0
REFINEMENT_BUFFER_RATIO = 32.0
MINIMUM_MARK_RATE = 0.80
MINIMUM_RANK_RATE = 0.80
MINIMUM_SOURCE_CLOSURE_RATE = 0.80
MINIMUM_NESTED_JACCARD = 0.40
MAXIMUM_SHELL_DISAGREEMENT = 0.25
MAXIMUM_PAIRING_DISAGREEMENT = 0.25
MAXIMUM_COORDINATE_METRIC_ERROR = 0.50
MINIMUM_LORENTZIAN_RATE = 0.80
MAXIMUM_ORBIT_MEMBERS = 64
MINIMUM_REALIZATIONS_PASSING = 4
ALL_CANDIDATES_LIMIT = 2_000_000_000


@dataclass(frozen=True)
class OuterOrderEvaluation:
    """Order-side evaluation of one selected outer regulator."""

    buffer_ratio: float
    bracket: CountBalancedBracket
    carrier: np.ndarray
    shell_counts: tuple[int, int, int]
    raw_shell_counts: tuple[int, int, int]
    source_closure_rates: tuple[float, float, float]
    mark_is_common_interior: bool
    rank_capable: bool


@dataclass(frozen=True)
class NestedPairEvaluation:
    """One genuine tight/refinement nesting around a common mark."""

    tight_index: int
    refinement_index: int
    jaccard: float
    shell_disagreements: tuple[float, float, float]


@dataclass(frozen=True)
class MarkOrderEvaluation:
    """Internal order-side record retained for an optional Phase 2 replay."""

    mark: int
    tight: tuple[OuterOrderEvaluation, ...]
    refinement: tuple[OuterOrderEvaluation, ...]
    nested_pairs: tuple[NestedPairEvaluation, ...]
    resource_failure: bool


def analytic_minimum_buffer_ratio(
    ell: float,
    operator_scale: float,
    adjacent_ratio: float,
) -> float:
    """Count ratio needed for the worst source plus one minimal witness."""

    if ell <= 0.0 or operator_scale <= 0.0:
        raise ValueError("ell and operator scale must be positive")
    if adjacent_ratio <= 1.0:
        raise ValueError("adjacent ratio must exceed one")
    largest_scale = adjacent_ratio * math.sqrt(ell * operator_scale)
    minimum_extent = (4.0**0.25 + 0.5**0.25) * largest_scale
    return (minimum_extent / operator_scale) ** 4


def maximum_admitted_carrier_count(
    half_count_target: float,
    buffer_ratio: float,
    endpoint_upper: float = ENDPOINT_COUNT_BAND[1],
    excess_cap: float = TIGHT_EXCESS_CAP,
) -> float:
    """Arithmetic upper count admitted by the balanced-endpoint rule."""

    if half_count_target <= 0.0 or buffer_ratio <= 0.0:
        raise ValueError("count targets and buffer ratios must be positive")
    if endpoint_upper <= 0.0 or excess_cap <= 0.0:
        raise ValueError("endpoint and excess bounds must be positive")
    return excess_cap * 16.0 * endpoint_upper * buffer_ratio * half_count_target


def complete_minimum_excess_orbit(
    brackets: list[CountBalancedBracket],
) -> list[CountBalancedBracket]:
    """Retain every exact tie at the minimum invariant excess score."""

    if not brackets:
        return []
    minimum = min(bracket.rapidity_excess for bracket in brackets)
    return [bracket for bracket in brackets if bracket.rapidity_excess == minimum]


def genuinely_nested(
    relation: np.ndarray,
    tight: CountBalancedBracket,
    refinement: CountBalancedBracket,
) -> bool:
    """Whether the tight bracket lies strictly inside the refinement bracket."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    return bool(
        relation[refinement.past_endpoint, tight.past_endpoint]
        and relation[tight.future_endpoint, refinement.future_endpoint]
    )


def full_inner_intervals_preserve_counts(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    germ: np.ndarray,
) -> bool:
    """Check counts only for germ pairs whose complete interval stays in germ."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if germ.shape != (len(relation),):
        raise ValueError("germ has the wrong shape")
    indices = np.flatnonzero(germ)
    local_relation = relation[np.ix_(indices, indices)]
    local_counts = sparse_inclusive_interval_count_matrix(local_relation)
    for local_left, left in enumerate(indices):
        for local_right, right in enumerate(indices):
            if not relation[left, right]:
                continue
            open_interval = relation[left] & relation[:, right]
            if np.any(open_interval & ~germ):
                continue
            if local_counts[local_left, local_right] != inclusive_counts[left, right]:
                return False
    return True


def _all_buffer_candidates(
    inclusive_counts: sparse.csr_matrix,
    mark: int,
    half_count_target: float,
    buffer_ratio: float,
) -> list[CountBalancedBracket]:
    return select_count_balanced_brackets(
        inclusive_counts,
        mark,
        buffer_ratio * half_count_target,
        ENDPOINT_COUNT_BAND,
        TIGHT_EXCESS_CAP,
        ALL_CANDIDATES_LIMIT,
    )


def select_nested_minimum_orbits(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    mark: int,
    half_count_target: float,
    tight_buffer_ratio: float = TIGHT_BUFFER_RATIO,
    refinement_buffer_ratio: float = REFINEMENT_BUFFER_RATIO,
) -> tuple[
    list[CountBalancedBracket],
    list[CountBalancedBracket],
    list[tuple[int, int]],
]:
    """Select the full outer minimum orbit and nested inner minimum orbits."""

    refinement_candidates = _all_buffer_candidates(
        inclusive_counts,
        mark,
        half_count_target,
        refinement_buffer_ratio,
    )
    refinement = complete_minimum_excess_orbit(refinement_candidates)
    if not refinement:
        return [], [], []

    tight_candidates = _all_buffer_candidates(
        inclusive_counts,
        mark,
        half_count_target,
        tight_buffer_ratio,
    )
    tight: list[CountBalancedBracket] = []
    pair_endpoints: list[tuple[tuple[int, int], tuple[int, int]]] = []
    for outer in refinement:
        nested_candidates = [
            candidate
            for candidate in tight_candidates
            if genuinely_nested(relation, candidate, outer)
        ]
        for inner in complete_minimum_excess_orbit(nested_candidates):
            tight.append(inner)
            pair_endpoints.append(
                (
                    (inner.past_endpoint, inner.future_endpoint),
                    (outer.past_endpoint, outer.future_endpoint),
                )
            )

    tight_by_endpoint = {
        (bracket.past_endpoint, bracket.future_endpoint): bracket
        for bracket in tight
    }
    refinement_by_endpoint = {
        (bracket.past_endpoint, bracket.future_endpoint): bracket
        for bracket in refinement
    }
    ordered_tight = [tight_by_endpoint[key] for key in sorted(tight_by_endpoint)]
    ordered_refinement = [
        refinement_by_endpoint[key] for key in sorted(refinement_by_endpoint)
    ]
    tight_index = {
        (bracket.past_endpoint, bracket.future_endpoint): index
        for index, bracket in enumerate(ordered_tight)
    }
    refinement_index = {
        (bracket.past_endpoint, bracket.future_endpoint): index
        for index, bracket in enumerate(ordered_refinement)
    }
    pairs = sorted(
        {
            (tight_index[inner], refinement_index[outer])
            for inner, outer in pair_endpoints
        }
    )
    return ordered_tight, ordered_refinement, pairs


def _raw_and_qualified_shell_counts(
    inclusive_counts: sparse.csr_matrix,
    interior: np.ndarray,
    mark: int,
    ell: float,
    scale: float,
) -> tuple[int, int]:
    """Count raw shell candidates and those surviving source interiority."""

    nu = (scale / ell) ** 4
    column = inclusive_counts.getcol(mark).tocoo()
    keep = (
        (column.data >= RETARDED_SHELL_BAND[0] * nu)
        & (column.data <= RETARDED_SHELL_BAND[1] * nu)
    )
    raw_sources = column.row[keep]
    qualified = int(np.count_nonzero(interior[raw_sources]))
    return len(raw_sources), qualified


def evaluate_outer_order(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    mark: int,
    bracket: CountBalancedBracket,
    buffer_ratio: float,
    scales: tuple[float, float, float],
    ell: float,
) -> OuterOrderEvaluation:
    """Evaluate the unchanged inner germ in one induced outer carrier."""

    carrier = open_bracket_carrier(relation, bracket)
    if not carrier[mark]:
        raise ValueError("the outer carrier does not contain its mark")
    indices = np.flatnonzero(carrier)
    local_mark_positions = np.flatnonzero(indices == mark)
    if len(local_mark_positions) != 1:
        raise ValueError("the mark does not have a unique local index")
    local_mark = int(local_mark_positions[0])
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
    raw_and_qualified = tuple(
        _raw_and_qualified_shell_counts(
            local_counts,
            interior,
            local_mark,
            ell,
            scale,
        )
        for scale, interior in zip(scales, interiors, strict=True)
    )
    raw_counts = tuple(pair[0] for pair in raw_and_qualified)
    shell_counts = tuple(pair[1] for pair in raw_and_qualified)
    closure_rates = tuple(
        qualified / raw if raw else 0.0
        for raw, qualified in raw_and_qualified
    )
    mark_is_common = all(interior[local_mark] for interior in interiors)
    rank_capable = mark_is_common and min(shell_counts) >= MINIMUM_SHELL_COUNT
    return OuterOrderEvaluation(
        buffer_ratio=buffer_ratio,
        bracket=bracket,
        carrier=carrier,
        shell_counts=shell_counts,
        raw_shell_counts=raw_counts,
        source_closure_rates=closure_rates,
        mark_is_common_interior=bool(mark_is_common),
        rank_capable=bool(rank_capable),
    )


def _normalized_disagreement(left: int, right: int) -> float:
    denominator = max(left, right)
    return abs(left - right) / denominator if denominator else 0.0


def evaluate_mark_order(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    mark: int,
    scales: tuple[float, float, float],
    ell: float,
    operator_scale: float,
) -> MarkOrderEvaluation:
    """Evaluate both frozen regulator rungs at one order-selected mark."""

    half_target = (operator_scale / ell) ** 4
    tight_brackets, refinement_brackets, pair_indices = (
        select_nested_minimum_orbits(
            relation,
            inclusive_counts,
            mark,
            half_target,
        )
    )
    resource_failure = (
        len(tight_brackets) > MAXIMUM_ORBIT_MEMBERS
        or len(refinement_brackets) > MAXIMUM_ORBIT_MEMBERS
    )
    if resource_failure:
        return MarkOrderEvaluation(mark, (), (), (), True)

    tight = tuple(
        evaluate_outer_order(
            relation,
            inclusive_counts,
            mark,
            bracket,
            TIGHT_BUFFER_RATIO,
            scales,
            ell,
        )
        for bracket in tight_brackets
    )
    refinement = tuple(
        evaluate_outer_order(
            relation,
            inclusive_counts,
            mark,
            bracket,
            REFINEMENT_BUFFER_RATIO,
            scales,
            ell,
        )
        for bracket in refinement_brackets
    )
    nested_pairs = tuple(
        NestedPairEvaluation(
            tight_index=tight_index,
            refinement_index=refinement_index,
            jaccard=carrier_jaccard(
                tight[tight_index].carrier,
                refinement[refinement_index].carrier,
            ),
            shell_disagreements=tuple(
                _normalized_disagreement(left, right)
                for left, right in zip(
                    tight[tight_index].shell_counts,
                    refinement[refinement_index].shell_counts,
                    strict=True,
                )
            ),
        )
        for tight_index, refinement_index in pair_indices
    )
    return MarkOrderEvaluation(mark, tight, refinement, nested_pairs, False)


def _rate(numerator: int, denominator: int) -> float:
    return numerator / denominator if denominator else 0.0


def _bracket_record(evaluation: OuterOrderEvaluation) -> dict[str, object]:
    bracket = evaluation.bracket
    return {
        "past_endpoint": bracket.past_endpoint,
        "future_endpoint": bracket.future_endpoint,
        "past_half_count": bracket.past_half_count,
        "future_half_count": bracket.future_half_count,
        "inclusive_carrier_count": bracket.inclusive_carrier_count,
        "rapidity_excess": bracket.rapidity_excess,
        "carrier_size": int(np.count_nonzero(evaluation.carrier)),
        "shell_counts": list(evaluation.shell_counts),
        "raw_shell_counts": list(evaluation.raw_shell_counts),
        "source_closure_rates": list(evaluation.source_closure_rates),
        "mark_is_common_interior": evaluation.mark_is_common_interior,
        "rank_capable": evaluation.rank_capable,
    }


def _orbit_summary(
    evaluations: tuple[OuterOrderEvaluation, ...],
) -> dict[str, object]:
    count = len(evaluations)
    return {
        "orbit_size": count,
        "rank_capable_rate": _rate(
            sum(item.rank_capable for item in evaluations), count
        ),
        "minimum_source_closure_rate": finite_statistics(
            [min(item.source_closure_rates) for item in evaluations]
        ),
        "carrier_size": finite_statistics(
            [int(np.count_nonzero(item.carrier)) for item in evaluations]
        ),
        "brackets": [_bracket_record(item) for item in evaluations],
    }


def mark_order_record(evaluation: MarkOrderEvaluation) -> dict[str, object]:
    """Convert one internal mark evaluation to a JSON-safe record."""

    qualifying = bool(evaluation.tight and evaluation.refinement)
    overlap_pairs = [
        pair for pair in evaluation.nested_pairs
        if pair.jaccard >= MINIMUM_NESTED_JACCARD
    ]
    shell_disagreements = [
        value
        for pair in evaluation.nested_pairs
        for value in pair.shell_disagreements
    ]
    return {
        "mark": evaluation.mark,
        "resource_failure": evaluation.resource_failure,
        "qualifies_nonempty_orbits": qualifying,
        "tight": _orbit_summary(evaluation.tight),
        "refinement": _orbit_summary(evaluation.refinement),
        "nested_pair_count": len(evaluation.nested_pairs),
        "has_overlap_pair": bool(overlap_pairs),
        "nested_overlap_jaccard": finite_statistics(
            [pair.jaccard for pair in evaluation.nested_pairs]
        ),
        "nested_shell_disagreement": finite_statistics(shell_disagreements),
        "nested_pairs": [
            {
                "tight_index": pair.tight_index,
                "refinement_index": pair.refinement_index,
                "jaccard": pair.jaccard,
                "shell_disagreements": list(pair.shell_disagreements),
            }
            for pair in evaluation.nested_pairs
        ],
    }


def _median(values: list[float]) -> float | None:
    return float(np.median(values)) if values else None


def summarize_phase1_realization(
    evaluations: list[MarkOrderEvaluation],
) -> dict[str, object]:
    """Cluster bracket evidence at marks before the realization gate."""

    records = [mark_order_record(item) for item in evaluations]
    qualifying = [
        (item, record)
        for item, record in zip(evaluations, records, strict=True)
        if record["qualifies_nonempty_orbits"] and not item.resource_failure
    ]
    mark_count = len(evaluations)
    qualifying_rate = _rate(len(qualifying), mark_count)
    rank_by_rung = {
        "tight": [float(record["tight"]["rank_capable_rate"]) for _, record in qualifying],
        "refinement": [
            float(record["refinement"]["rank_capable_rate"])
            for _, record in qualifying
        ],
    }
    closure_by_rung = {
        "tight": [
            float(record["tight"]["minimum_source_closure_rate"]["median"])
            for _, record in qualifying
            if record["tight"]["minimum_source_closure_rate"]["median"] is not None
        ],
        "refinement": [
            float(record["refinement"]["minimum_source_closure_rate"]["median"])
            for _, record in qualifying
            if record["refinement"]["minimum_source_closure_rate"]["median"]
            is not None
        ],
    }
    overlap_rate = _rate(
        sum(bool(record["has_overlap_pair"]) for _, record in qualifying),
        len(qualifying),
    )
    shell_errors = [
        float(record["nested_shell_disagreement"]["median"])
        for _, record in qualifying
        if record["nested_shell_disagreement"]["median"] is not None
    ]
    median_rank = {key: _median(values) for key, values in rank_by_rung.items()}
    median_closure = {
        key: _median(values) for key, values in closure_by_rung.items()
    }
    shell_error = _median(shell_errors)
    nonvacuous = (
        bool(qualifying)
        and all(value is not None and value > 0.0 for value in median_rank.values())
        and shell_error is not None
    )
    passes = (
        nonvacuous
        and qualifying_rate >= MINIMUM_MARK_RATE
        and all(
            value is not None and value >= MINIMUM_RANK_RATE
            for value in median_rank.values()
        )
        and all(
            value is not None and value >= MINIMUM_SOURCE_CLOSURE_RATE
            for value in median_closure.values()
        )
        and overlap_rate >= MINIMUM_MARK_RATE
        and shell_error <= MAXIMUM_SHELL_DISAGREEMENT
        and not any(item.resource_failure for item in evaluations)
    )
    return {
        "marks_evaluated": mark_count,
        "qualifying_mark_rate": qualifying_rate,
        "median_rank_capable_rate": median_rank,
        "median_source_closure_rate": median_closure,
        "qualifying_mark_overlap_rate": overlap_rate,
        "median_nested_shell_disagreement": shell_error,
        "nonvacuity_precondition": nonvacuous,
        "resource_failure": any(item.resource_failure for item in evaluations),
        "passes_phase1": passes,
        "mark_results": records,
    }


def spawn_realization_seed_states(
    seed: int,
    realizations: int,
) -> list[tuple[tuple[int, ...], tuple[int, ...]]]:
    """Produce independent reproducible sprinkling and mark RNG states."""

    if realizations <= 0:
        raise ValueError("realizations must be positive")
    root = np.random.SeedSequence(seed)
    pairs = []
    for realization_seed in root.spawn(realizations):
        sprinkle_seed, mark_seed = realization_seed.spawn(2)
        pairs.append(
            (
                tuple(int(value) for value in sprinkle_seed.generate_state(4)),
                tuple(int(value) for value in mark_seed.generate_state(4)),
            )
        )
    return pairs


def _rng(seed_state: tuple[int, ...]) -> np.random.Generator:
    return np.random.default_rng(np.array(seed_state, dtype=np.uint32))


def _sample_marks(
    mark_rng: np.random.Generator,
    common_marks: np.ndarray,
    marks_per_realization: int,
) -> np.ndarray:
    sample_size = min(marks_per_realization, len(common_marks))
    if sample_size == 0:
        return np.empty(0, dtype=np.int64)
    return np.sort(mark_rng.choice(common_marks, size=sample_size, replace=False))


def _phase2_mark(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    points: np.ndarray,
    evaluation: MarkOrderEvaluation,
    ell: float,
    operator_scale: float,
) -> dict[str, object]:
    operator_row = _operator_row_at_mark(
        relation,
        inclusive_counts,
        evaluation.mark,
        ell,
        operator_scale,
    )
    pairings: dict[tuple[str, int], np.ndarray] = {}
    metric_errors: list[float] = []
    signatures: list[bool] = []
    for name, orbit in (
        ("tight", evaluation.tight),
        ("refinement", evaluation.refinement),
    ):
        for index, item in enumerate(orbit):
            if not item.rank_capable:
                continue
            pairing = corrected_gamma(
                operator_row * item.carrier,
                points,
                evaluation.mark,
            )
            pairings[(name, index)] = pairing
            metric_errors.append(matrix_relative_error(pairing, MINKOWSKI_INVERSE))
            signatures.append(signature(pairing) == (1, 3, 0))

    nested_errors = []
    for pair in evaluation.nested_pairs:
        tight = pairings.get(("tight", pair.tight_index))
        refinement = pairings.get(("refinement", pair.refinement_index))
        if tight is not None and refinement is not None:
            nested_errors.append(symmetric_matrix_disagreement(tight, refinement))
    return {
        "mark": evaluation.mark,
        "rank_capable_pairings": len(pairings),
        "nested_pairing_disagreement": finite_statistics(nested_errors),
        "coordinate_metric_error": finite_statistics(metric_errors),
        "lorentzian_signature_rate": _rate(sum(signatures), len(signatures)),
    }


def _phase2_realization(mark_rows: list[dict[str, object]]) -> dict[str, object]:
    nested = [
        float(row["nested_pairing_disagreement"]["median"])
        for row in mark_rows
        if row["nested_pairing_disagreement"]["median"] is not None
    ]
    metric = [
        float(row["coordinate_metric_error"]["median"])
        for row in mark_rows
        if row["coordinate_metric_error"]["median"] is not None
    ]
    signatures = [
        float(row["lorentzian_signature_rate"])
        for row in mark_rows
        if int(row["rank_capable_pairings"]) > 0
    ]
    return {
        "marks_with_coordinate_controls": len(metric),
        "median_nested_pairing_disagreement": _median(nested),
        "median_coordinate_metric_error": _median(metric),
        "median_lorentzian_signature_rate": _median(signatures),
        "mark_results": mark_rows,
    }


def _run_phase2(
    args: argparse.Namespace,
    seed_states: list[tuple[tuple[int, ...], tuple[int, ...]]],
    phase1_internal: list[list[MarkOrderEvaluation]],
    events: int,
    duration: float,
    ell: float,
    scales: tuple[float, float, float],
) -> dict[str, object]:
    realizations = []
    for seed_pair, archived in zip(seed_states, phase1_internal, strict=True):
        points, _ = sprinkle_minkowski_diamond(_rng(seed_pair[0]), events, duration)
        relation = causal_relation_matrix(points, args.block_size)
        inclusive_counts = sparse_inclusive_interval_count_matrix(relation)
        _, _, _, common_marks, _ = sparse_adjacent_scale_support(
            inclusive_counts,
            ell,
            args.nonlocality_scale,
            args.adjacent_ratio,
        )
        sampled_marks = _sample_marks(
            _rng(seed_pair[1]), common_marks, args.marks_per_realization
        )
        if [int(mark) for mark in sampled_marks] != [item.mark for item in archived]:
            raise RuntimeError("Phase 2 did not reproduce the archived mark sample")
        replayed = [
            evaluate_mark_order(
                relation,
                inclusive_counts,
                int(mark),
                scales,
                ell,
                args.nonlocality_scale,
            )
            for mark in sampled_marks
        ]
        if [mark_order_record(item) for item in replayed] != [
            mark_order_record(item) for item in archived
        ]:
            raise RuntimeError("Phase 2 did not reproduce the archived selection")
        mark_rows = [
            _phase2_mark(
                relation,
                inclusive_counts,
                points,
                item,
                ell,
                args.nonlocality_scale,
            )
            for item in replayed
        ]
        realizations.append(_phase2_realization(mark_rows))

    nested = [
        float(row["median_nested_pairing_disagreement"])
        for row in realizations
        if row["median_nested_pairing_disagreement"] is not None
    ]
    metric = [
        float(row["median_coordinate_metric_error"])
        for row in realizations
        if row["median_coordinate_metric_error"] is not None
    ]
    lorentzian = [
        float(row["median_lorentzian_signature_rate"])
        for row in realizations
        if row["median_lorentzian_signature_rate"] is not None
    ]
    enough = min(len(nested), len(metric), len(lorentzian)) >= (
        MINIMUM_REALIZATIONS_PASSING
    )
    nested_median = _median(nested)
    metric_median = _median(metric)
    lorentzian_median = _median(lorentzian)
    gates = {
        "nonvacuous_coordinate_denominator": enough,
        "nested_pairing_stability": (
            enough
            and nested_median is not None
            and nested_median <= MAXIMUM_PAIRING_DISAGREEMENT
        ),
        "coordinate_metric_control": (
            enough
            and metric_median is not None
            and metric_median <= MAXIMUM_COORDINATE_METRIC_ERROR
        ),
        "lorentzian_signature_control": (
            enough
            and lorentzian_median is not None
            and lorentzian_median >= MINIMUM_LORENTZIAN_RATE
        ),
    }
    return {
        "gates": gates,
        "passes_phase2": all(gates.values()),
        "clustered_nested_pairing_disagreement": finite_statistics(nested),
        "clustered_coordinate_metric_error": finite_statistics(metric),
        "clustered_lorentzian_signature_rate": finite_statistics(lorentzian),
        "realizations": realizations,
    }


def run_scan(args: argparse.Namespace) -> dict[str, object]:
    """Run the frozen two-phase Stage A3e gate."""

    if args.reference_events <= 0 or args.reference_duration <= 0.0:
        raise ValueError("reference geometry must be positive")
    if args.volume_multiplier <= 0:
        raise ValueError("volume multiplier must be positive")
    if args.realizations <= 0 or args.marks_per_realization <= 0:
        raise ValueError("realization and mark counts must be positive")
    if args.nonlocality_scale <= 0.0 or args.adjacent_ratio <= 1.0:
        raise ValueError("operator scale and adjacent ratio are invalid")

    events, duration, ell = fixed_density_geometry(
        args.reference_events,
        args.reference_duration,
        args.volume_multiplier,
    )
    scales, hierarchy_valid = adjacent_scale_schedule(
        ell,
        args.nonlocality_scale,
        args.adjacent_ratio,
    )
    if not hierarchy_valid:
        raise ValueError("the adjacent scale hierarchy is invalid")
    half_target = (args.nonlocality_scale / ell) ** 4
    minimum_buffer = analytic_minimum_buffer_ratio(
        ell,
        args.nonlocality_scale,
        args.adjacent_ratio,
    )
    if TIGHT_BUFFER_RATIO <= minimum_buffer:
        raise ValueError("the tight buffer does not exceed the analytic minimum")
    maximum_carrier = maximum_admitted_carrier_count(
        half_target,
        REFINEMENT_BUFFER_RATIO,
    )
    if events + 1 <= maximum_carrier:
        raise ValueError("the control diamond fails the arithmetic carrier threshold")

    seed_states = spawn_realization_seed_states(args.seed, args.realizations)
    phase1_internal: list[list[MarkOrderEvaluation]] = []
    phase1_realizations = []
    runtimes = []
    for sprinkle_seed, mark_seed in seed_states:
        start = time.perf_counter()
        points, _ = sprinkle_minkowski_diamond(
            _rng(sprinkle_seed), events, duration
        )
        relation = causal_relation_matrix(points, args.block_size)
        inclusive_counts = sparse_inclusive_interval_count_matrix(relation)
        _, _, _, common_marks, _ = sparse_adjacent_scale_support(
            inclusive_counts,
            ell,
            args.nonlocality_scale,
            args.adjacent_ratio,
        )
        sampled_marks = _sample_marks(
            _rng(mark_seed), common_marks, args.marks_per_realization
        )
        evaluations = [
            evaluate_mark_order(
                relation,
                inclusive_counts,
                int(mark),
                scales,
                ell,
                args.nonlocality_scale,
            )
            for mark in sampled_marks
        ]
        tripwire_carrier = next(
            (
                item.refinement[0].carrier
                for item in evaluations
                if item.refinement
            ),
            None,
        )
        tripwire = (
            induced_counts_match_global(
                relation,
                inclusive_counts,
                tripwire_carrier,
            )
            if tripwire_carrier is not None
            else None
        )
        summary = summarize_phase1_realization(evaluations)
        summary["common_marks_available"] = len(common_marks)
        summary["sampled_marks"] = [int(mark) for mark in sampled_marks]
        summary["induced_count_tripwire"] = tripwire
        if tripwire is not True:
            summary["passes_phase1"] = False
        phase1_internal.append(evaluations)
        phase1_realizations.append(summary)
        runtimes.append(time.perf_counter() - start)

    realizations_passing = sum(
        bool(row["passes_phase1"]) for row in phase1_realizations
    )
    phase1_pass = realizations_passing >= MINIMUM_REALIZATIONS_PASSING
    phase2 = (
        _run_phase2(
            args,
            seed_states,
            phase1_internal,
            events,
            duration,
            ell,
            scales,
        )
        if phase1_pass
        else None
    )
    return {
        "status": "external finite nested-regulator inner-germ gate",
        "selector_uses_embedding_coordinates": False,
        "coordinates_used_for_postselection_control": phase2 is not None,
        "primary_inference_unit": "realization clustered through marks",
        "settings": {
            "reference_events": args.reference_events,
            "reference_duration": args.reference_duration,
            "volume_multiplier": args.volume_multiplier,
            "events": events,
            "duration": duration,
            "ell": ell,
            "realizations": args.realizations,
            "marks_per_realization": args.marks_per_realization,
            "nonlocality_scale": args.nonlocality_scale,
            "adjacent_ratio": args.adjacent_ratio,
            "adjacent_scales": list(scales),
            "half_count_target": half_target,
            "analytic_minimum_buffer_ratio": minimum_buffer,
            "tight_buffer_ratio": TIGHT_BUFFER_RATIO,
            "refinement_buffer_ratio": REFINEMENT_BUFFER_RATIO,
            "endpoint_count_band": list(ENDPOINT_COUNT_BAND),
            "rapidity_excess_cap": TIGHT_EXCESS_CAP,
            "maximum_admitted_refinement_carrier_count": maximum_carrier,
            "maximum_orbit_members": MAXIMUM_ORBIT_MEMBERS,
            "minimum_shell_count": MINIMUM_SHELL_COUNT,
            "seed": args.seed,
        },
        "phase1": {
            "realizations_passing": realizations_passing,
            "minimum_realizations_passing": MINIMUM_REALIZATIONS_PASSING,
            "passes_phase1": phase1_pass,
            "runtime_seconds": finite_statistics(runtimes),
            "realizations": phase1_realizations,
        },
        "phase2": phase2,
        "passes_all_gates": bool(
            phase1_pass and phase2 is not None and phase2["passes_phase2"]
        ),
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reference-events", type=int, default=1200)
    parser.add_argument("--reference-duration", type=float, default=1.0)
    parser.add_argument("--volume-multiplier", type=int, default=8)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--marks-per-realization", type=int, default=8)
    parser.add_argument("--nonlocality-scale", type=float, default=0.18)
    parser.add_argument("--adjacent-ratio", type=float, default=1.25)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=2026071606)
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
