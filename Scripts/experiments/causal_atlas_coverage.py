"""Outer-first buffered causal-atlas coverage and overlap gate.

Stage A3f-R1 samples outer Alexandrov intervals before choosing any evaluation
event. It measures how their ambient-count protected cores cover an independently
defined order bulk on a genuine two-density shrinking schedule. Coordinates are
used only to generate the oracle causal relation and are unavailable to every
selector and reported order-side statistic.

This stage does not evaluate operator rows, probe rank, a metric, or curvature.
It is an external finite oracle, not a continuum theorem.
"""

from __future__ import annotations

import argparse
import json
import time
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np
from scipy import sparse

from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_buffered_core_feasibility import schedule_at_density
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_operator_metric import sprinkle_minkowski_diamond


FROZEN_DENSITIES = (4800, 9600)
FROZEN_BUFFER_RADIUS_MULTIPLIERS = (0.8, 1.0, 1.25)
FROZEN_ATLAS_SIZE = 16
FROZEN_OUTER_BAND = (0.90, 1.10)
FROZEN_SEED = 2026071607
MINIMUM_ALL_EVENT_COVERAGE = 0.50
MINIMUM_BULK_COVERAGE = 0.60
MINIMUM_REPEATED_COVERAGE = 0.35
MINIMUM_REALIZATIONS_PASSING = 4
MAXIMUM_REFINEMENT_DRIFT = 0.10


@dataclass(frozen=True)
class AtlasEvaluation:
    """Order-only result for one buffer rung in one realization."""

    buffer_radius_multiplier: float
    buffer_count: float
    complete_candidate_count: int
    sampled_candidates: tuple[tuple[int, int, int], ...]
    carrier_sizes: tuple[int, ...]
    core_sizes: tuple[int, ...]
    all_event_coverage: float
    bulk_count: int
    covered_bulk_count: int
    bulk_coverage: float | None
    repeated_covered_bulk_count: int
    repeated_given_covered_bulk: float | None
    maximum_multiplicity: int
    nonempty_carrier_overlap_pairs: int
    nonempty_core_overlap_pairs: int
    carrier_jaccard_values: tuple[float, ...]
    core_jaccard_values: tuple[float, ...]
    runtime_count_tripwire: bool
    passes_empirical_gate: bool


@dataclass(frozen=True)
class AtlasRegulator:
    """One order-selected outer Alexandrov endpoint pair."""

    past_endpoint: int
    future_endpoint: int
    inclusive_count: int


@dataclass(frozen=True)
class OverlapEvaluation:
    """Relabeling-invariant overlap data for one distinct carrier pair."""

    carrier_intersection_count: int
    core_intersection_count: int
    carrier_jaccard: float
    core_jaccard: float


def rung_key(buffer_radius_multiplier: float) -> str:
    """Stable JSON key for a frozen buffer-radius rung."""

    return f"{buffer_radius_multiplier:.2f}"


def integer_candidate_band(
    outer_count_target: float,
    band: tuple[float, float] = FROZEN_OUTER_BAND,
) -> tuple[int, int]:
    """Inclusive integer interval corresponding to the real count band."""

    if outer_count_target <= 0.0:
        raise ValueError("outer count target must be positive")
    if not 0.0 < band[0] < band[1]:
        raise ValueError("outer band must be positive and ordered")
    return (
        int(np.ceil(band[0] * outer_count_target)),
        int(np.floor(band[1] * outer_count_target)),
    )


def complete_outer_candidates(
    inclusive_counts: sparse.csr_matrix,
    outer_count_target: float,
    band: tuple[float, float] = FROZEN_OUTER_BAND,
) -> np.ndarray:
    """Complete equivariant set of comparable pairs in the outer count band."""

    if inclusive_counts.shape[0] != inclusive_counts.shape[1]:
        raise ValueError("inclusive count matrix must be square")
    if outer_count_target <= 0.0:
        raise ValueError("outer count target must be positive")
    if not 0.0 < band[0] < band[1]:
        raise ValueError("outer band must be positive and ordered")
    lower, upper = integer_candidate_band(outer_count_target, band)
    coo = inclusive_counts.tocoo()
    keep = (
        (coo.data >= lower)
        & (coo.data <= upper)
    )
    return np.column_stack(
        (
            coo.row[keep].astype(np.int64, copy=False),
            coo.col[keep].astype(np.int64, copy=False),
            coo.data[keep].astype(np.int64, copy=False),
        )
    )


def all_candidate_regulators(
    inclusive_counts: sparse.csr_matrix,
    outer_count_target: float,
    band: tuple[float, float] = FROZEN_OUTER_BAND,
) -> tuple[AtlasRegulator, ...]:
    """Dataclass view of the complete equivariant candidate set."""

    rows = complete_outer_candidates(inclusive_counts, outer_count_target, band)
    return tuple(
        AtlasRegulator(int(past), int(future), int(count))
        for past, future, count in rows
    )


def sample_outer_candidates(
    candidates: np.ndarray,
    atlas_size: int,
    rng: np.random.Generator,
) -> np.ndarray:
    """Uniformly sample a subset after complete candidate construction."""

    if candidates.ndim != 2 or candidates.shape[1] != 3:
        raise ValueError("candidates must have shape (K,3)")
    if atlas_size <= 0:
        raise ValueError("atlas size must be positive")
    if len(candidates) <= atlas_size:
        return candidates.copy()
    selected = rng.choice(len(candidates), size=atlas_size, replace=False)
    return candidates[selected]


def sample_uniform_regulators(
    candidates: tuple[AtlasRegulator, ...] | list[AtlasRegulator],
    atlas_size: int,
    rng: np.random.Generator,
) -> tuple[AtlasRegulator, ...]:
    """Uniform subset sampler with a canonical order after sampling."""

    if atlas_size <= 0:
        raise ValueError("atlas size must be positive")
    if len(candidates) <= atlas_size:
        return tuple(candidates)
    selected = np.sort(
        rng.choice(len(candidates), size=atlas_size, replace=False)
    )
    return tuple(candidates[int(index)] for index in selected)


def outer_carrier(relation: np.ndarray, past: int, future: int) -> np.ndarray:
    """Open Alexandrov interval between a comparable endpoint pair."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if not 0 <= past < len(relation) or not 0 <= future < len(relation):
        raise IndexError("outer endpoint is outside the relation")
    if not relation[past, future]:
        raise ValueError("outer endpoints must be strictly comparable")
    return relation[past] & relation[:, future]


def open_carrier(
    relation: np.ndarray,
    regulator: AtlasRegulator,
) -> np.ndarray:
    """Open carrier using the structured regulator API."""

    return outer_carrier(
        relation, regulator.past_endpoint, regulator.future_endpoint
    )


def protected_core(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    regulator_or_past: AtlasRegulator | int,
    future_or_buffer: int | float,
    buffer_count: float | None = None,
) -> np.ndarray:
    """Ambient-count two-sided protected core of one outer interval."""

    if inclusive_counts.shape != relation.shape:
        raise ValueError("relation and count matrix shapes must agree")
    if isinstance(regulator_or_past, AtlasRegulator):
        past = regulator_or_past.past_endpoint
        future = regulator_or_past.future_endpoint
        resolved_buffer = float(future_or_buffer)
    else:
        if buffer_count is None:
            raise ValueError("buffer count is required with integer endpoints")
        past = int(regulator_or_past)
        future = int(future_or_buffer)
        resolved_buffer = float(buffer_count)
    if resolved_buffer < 0.0:
        raise ValueError("buffer count must be nonnegative")
    carrier = outer_carrier(relation, past, future)
    past_counts = np.zeros(len(relation), dtype=np.int64)
    past_row = inclusive_counts.getrow(past)
    past_counts[past_row.indices] = past_row.data
    future_counts = np.zeros(len(relation), dtype=np.int64)
    future_column = inclusive_counts.getcol(future).tocoo()
    future_counts[future_column.row] = future_column.data
    return (
        carrier
        & (past_counts >= resolved_buffer)
        & (future_counts >= resolved_buffer)
    )


def independent_order_bulk(
    relation: np.ndarray,
    buffer_count: float,
) -> np.ndarray:
    """Events with enough global predecessors and successors for the buffer."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if buffer_count < 0.0:
        raise ValueError("buffer count must be nonnegative")
    predecessor_count = np.count_nonzero(relation, axis=0)
    successor_count = np.count_nonzero(relation, axis=1)
    return (
        (predecessor_count >= buffer_count)
        & (successor_count >= buffer_count)
    )


def order_bulk(relation: np.ndarray, buffer_count: float) -> np.ndarray:
    """Structured-name alias for the independent order-bulk denominator."""

    return independent_order_bulk(relation, buffer_count)


def coverage_multiplicity(
    cores: tuple[np.ndarray, ...] | list[np.ndarray],
    event_count: int,
) -> np.ndarray:
    """Number of atlas protected cores containing each event."""

    if event_count <= 0:
        raise ValueError("event count must be positive")
    if not cores:
        return np.zeros(event_count, dtype=np.int64)
    if any(core.shape != (event_count,) for core in cores):
        raise ValueError("a core has the wrong shape")
    return np.sum(np.stack(cores), axis=0, dtype=np.int64)


def mask_jaccard(left: np.ndarray, right: np.ndarray) -> float | None:
    """Jaccard overlap, undefined only when both masks are empty."""

    if left.shape != right.shape or left.ndim != 1:
        raise ValueError("masks must be one-dimensional with equal shape")
    union = np.count_nonzero(left | right)
    if union == 0:
        return None
    return float(np.count_nonzero(left & right) / union)


def boolean_jaccard(left: np.ndarray, right: np.ndarray) -> float:
    """Total Jaccard convention with empty/empty assigned one."""

    value = mask_jaccard(left, right)
    return 1.0 if value is None else value


def overlap_evaluations(
    carriers: tuple[np.ndarray, ...] | list[np.ndarray],
    cores: tuple[np.ndarray, ...] | list[np.ndarray],
) -> tuple[OverlapEvaluation, ...]:
    """Evaluate only distinct pairs with nonempty protected-core overlap."""

    if len(carriers) != len(cores):
        raise ValueError("carrier and core collections must have equal length")
    values: list[OverlapEvaluation] = []
    for left in range(len(cores)):
        for right in range(left + 1, len(cores)):
            core_intersection = int(
                np.count_nonzero(cores[left] & cores[right])
            )
            if core_intersection == 0:
                continue
            values.append(
                OverlapEvaluation(
                    carrier_intersection_count=int(
                        np.count_nonzero(carriers[left] & carriers[right])
                    ),
                    core_intersection_count=core_intersection,
                    carrier_jaccard=boolean_jaccard(
                        carriers[left], carriers[right]
                    ),
                    core_jaccard=boolean_jaccard(cores[left], cores[right]),
                )
            )
    return tuple(values)


def sampled_induced_count_tripwire(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    carrier: np.ndarray,
    maximum_pairs: int = 32,
) -> bool:
    """Check ambient/induced counts on bounded comparable carrier pairs."""

    if carrier.shape != (len(relation),):
        raise ValueError("carrier has the wrong shape")
    if maximum_pairs <= 0:
        raise ValueError("maximum pairs must be positive")
    indices = np.flatnonzero(carrier)
    restricted = inclusive_counts[indices][:, indices].tocoo()
    for local_left, local_right, ambient in zip(
        restricted.row[:maximum_pairs],
        restricted.col[:maximum_pairs],
        restricted.data[:maximum_pairs],
        strict=True,
    ):
        left = int(indices[local_left])
        right = int(indices[local_right])
        induced_open = np.count_nonzero(
            relation[left, indices] & relation[indices, right]
        )
        if induced_open + 1 != int(ambient):
            return False
    return True


def evaluate_atlas(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    complete_candidates: np.ndarray,
    buffer_radius_multiplier: float,
    base_buffer_count: float,
    atlas_size: int,
    rng: np.random.Generator,
) -> AtlasEvaluation:
    """Evaluate one independently sampled atlas using only order and counts."""

    if buffer_radius_multiplier <= 0.0 or base_buffer_count <= 0.0:
        raise ValueError("buffer scales must be positive")
    sampled = sample_outer_candidates(complete_candidates, atlas_size, rng)
    buffer_count = buffer_radius_multiplier**4 * base_buffer_count
    carriers: list[np.ndarray] = []
    cores: list[np.ndarray] = []
    for past, future, _ in sampled:
        carriers.append(outer_carrier(relation, int(past), int(future)))
        cores.append(
            protected_core(
                relation,
                inclusive_counts,
                int(past),
                int(future),
                buffer_count,
            )
        )

    if cores:
        multiplicity = np.sum(np.stack(cores), axis=0, dtype=np.int64)
    else:
        multiplicity = np.zeros(len(relation), dtype=np.int64)
    covered = multiplicity > 0
    bulk = independent_order_bulk(relation, buffer_count)
    covered_bulk = bulk & covered
    repeated_bulk = covered_bulk & (multiplicity >= 2)
    bulk_count = int(np.count_nonzero(bulk))
    covered_bulk_count = int(np.count_nonzero(covered_bulk))
    bulk_coverage = (
        float(covered_bulk_count / bulk_count) if bulk_count else None
    )
    repeated_count = int(np.count_nonzero(repeated_bulk))
    repeated_rate = (
        float(repeated_count / covered_bulk_count)
        if covered_bulk_count
        else None
    )

    carrier_jaccards: list[float] = []
    core_jaccards: list[float] = []
    nonempty_carrier_overlap_pairs = 0
    nonempty_core_overlap_pairs = 0
    for left in range(len(sampled)):
        for right in range(left + 1, len(sampled)):
            carrier_intersection = np.count_nonzero(
                carriers[left] & carriers[right]
            )
            if carrier_intersection:
                nonempty_carrier_overlap_pairs += 1
            carrier_overlap = mask_jaccard(carriers[left], carriers[right])
            if carrier_overlap is not None:
                carrier_jaccards.append(carrier_overlap)
            core_intersection = np.count_nonzero(cores[left] & cores[right])
            if core_intersection:
                nonempty_core_overlap_pairs += 1
            core_overlap = mask_jaccard(cores[left], cores[right])
            if core_overlap is not None:
                core_jaccards.append(core_overlap)

    tripwire = bool(carriers) and sampled_induced_count_tripwire(
        relation, inclusive_counts, carriers[0]
    )
    all_event_coverage = float(np.mean(covered))
    passes = bool(
        len(complete_candidates) >= atlas_size
        and all_event_coverage >= MINIMUM_ALL_EVENT_COVERAGE
        and bulk_coverage is not None
        and bulk_coverage >= MINIMUM_BULK_COVERAGE
        and repeated_rate is not None
        and repeated_rate >= MINIMUM_REPEATED_COVERAGE
        and nonempty_core_overlap_pairs >= 1
        and tripwire
    )
    return AtlasEvaluation(
        buffer_radius_multiplier=buffer_radius_multiplier,
        buffer_count=buffer_count,
        complete_candidate_count=len(complete_candidates),
        sampled_candidates=tuple(
            (int(past), int(future), int(count))
            for past, future, count in sampled
        ),
        carrier_sizes=tuple(int(np.count_nonzero(mask)) for mask in carriers),
        core_sizes=tuple(int(np.count_nonzero(mask)) for mask in cores),
        all_event_coverage=all_event_coverage,
        bulk_count=bulk_count,
        covered_bulk_count=covered_bulk_count,
        bulk_coverage=bulk_coverage,
        repeated_covered_bulk_count=repeated_count,
        repeated_given_covered_bulk=repeated_rate,
        maximum_multiplicity=int(np.max(multiplicity, initial=0)),
        nonempty_carrier_overlap_pairs=nonempty_carrier_overlap_pairs,
        nonempty_core_overlap_pairs=nonempty_core_overlap_pairs,
        carrier_jaccard_values=tuple(carrier_jaccards),
        core_jaccard_values=tuple(core_jaccards),
        runtime_count_tripwire=tripwire,
        passes_empirical_gate=passes,
    )


def evaluate_atlas_rung(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    complete_candidates: tuple[AtlasRegulator, ...] | list[AtlasRegulator],
    buffer_radius_multiplier: float,
    base_buffer_count: float,
    atlas_size: int,
    rng: np.random.Generator,
) -> AtlasEvaluation:
    """Structured-regulator entry point for one order-only atlas rung."""

    candidate_array = np.array(
        [
            (
                item.past_endpoint,
                item.future_endpoint,
                item.inclusive_count,
            )
            for item in complete_candidates
        ],
        dtype=np.int64,
    ).reshape((-1, 3))
    return evaluate_atlas(
        relation,
        inclusive_counts,
        candidate_array,
        buffer_radius_multiplier,
        base_buffer_count,
        atlas_size,
        rng,
    )


def atlas_rung_record(evaluation: AtlasEvaluation) -> dict[str, object]:
    """JSON-ready record for a completed atlas-rung evaluation."""

    return asdict(evaluation)


def spawn_realization_seed_states(
    seed: int,
    densities: tuple[int, ...],
    realizations: int,
    rung_count: int,
) -> tuple[tuple[tuple[int, ...], ...], ...]:
    """Reproducible distinct seeds for sprinkling and each atlas rung."""

    if not densities or any(events <= 0 for events in densities):
        raise ValueError("densities must be positive")
    if realizations <= 0 or rung_count <= 0:
        raise ValueError("realizations and rung count must be positive")
    roots = np.random.SeedSequence(seed).spawn(len(densities) * realizations)
    records = []
    for root in roots:
        children = root.spawn(1 + rung_count)
        records.append(
            tuple(
                tuple(int(value) for value in child.generate_state(4))
                for child in children
            )
        )
    return tuple(records)


def spawn_role_seed_states(
    seed: int,
    realizations: int,
) -> tuple[tuple[tuple[int, ...], ...], ...]:
    """Frozen one-sprinkling plus three-atlas stream layout."""

    return spawn_realization_seed_states(
        seed,
        densities=(1,),
        realizations=realizations,
        rung_count=len(FROZEN_BUFFER_RADIUS_MULTIPLIERS),
    )


def _rng(seed_state: tuple[int, ...]) -> np.random.Generator:
    """Reconstruct exactly the generator archived in one role record."""

    return np.random.default_rng(np.array(seed_state, dtype=np.uint32))


def _median(values: list[float | None]) -> float | None:
    finite = [value for value in values if value is not None and np.isfinite(value)]
    return float(np.median(finite)) if finite else None


def summarize_density(
    realizations: list[dict[str, object]],
) -> dict[str, object]:
    """Cluster first at realization level for each frozen buffer rung."""

    by_rung: dict[str, object] = {}
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        rows = [
            next(
                rung
                for rung in realization["rungs"]
                if rung["buffer_radius_multiplier"] == beta
            )
            for realization in realizations
        ]
        by_rung[str(beta)] = {
            "realizations_passing": int(
                sum(bool(row["passes_empirical_gate"]) for row in rows)
            ),
            "density_pass": bool(
                sum(bool(row["passes_empirical_gate"]) for row in rows)
                >= MINIMUM_REALIZATIONS_PASSING
            ),
            "median_all_event_coverage": _median(
                [row["all_event_coverage"] for row in rows]
            ),
            "median_bulk_coverage": _median(
                [row["bulk_coverage"] for row in rows]
            ),
            "median_repeated_given_covered_bulk": _median(
                [row["repeated_given_covered_bulk"] for row in rows]
            ),
            "median_complete_candidate_count": _median(
                [float(row["complete_candidate_count"]) for row in rows]
            ),
        }
    return by_rung


def _summary_median(row: dict[str, object], metric: str) -> float | None:
    value = row.get(metric)
    if isinstance(value, dict):
        value = value.get("median")
    if value is None:
        return None
    return float(value)


def _phase1_global(
    density_summaries: list[dict[str, object]],
) -> dict[str, object]:
    """Nonvacuous adjacent-rung and refinement gate for two densities."""

    if len(density_summaries) != 2:
        raise ValueError("phase 1 requires exactly two density summaries")
    rung_gates: dict[str, object] = {}
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        key = rung_key(beta)
        rows = [summary["by_rung"][key] for summary in density_summaries]
        nonvacuity = all(
            int(row.get("nonempty_bulk_realizations", 0))
            >= MINIMUM_REALIZATIONS_PASSING
            and int(row.get("covered_bulk_realizations", 0))
            >= MINIMUM_REALIZATIONS_PASSING
            for row in rows
        )
        density_pass = all(
            int(row.get("realizations_passing", 0))
            >= MINIMUM_REALIZATIONS_PASSING
            for row in rows
        )
        drifts: dict[str, float | None] = {}
        for metric in (
            "all_event_coverage",
            "bulk_coverage",
            "repeated_coverage",
        ):
            lower = _summary_median(rows[0], metric)
            upper = _summary_median(rows[1], metric)
            drifts[metric] = (
                abs(lower - upper)
                if lower is not None and upper is not None
                else None
            )
        passes = bool(
            nonvacuity
            and density_pass
            and all(
                value is not None and value <= MAXIMUM_REFINEMENT_DRIFT
                for value in drifts.values()
            )
        )
        rung_gates[key] = {
            "nonvacuity_precondition": nonvacuity,
            "both_densities_pass": density_pass,
            "refinement_drifts": drifts,
            "passes": passes,
        }

    pair_gates = {}
    for left, right in ((0.8, 1.0), (1.0, 1.25)):
        pair_gates[f"{rung_key(left)}-{rung_key(right)}"] = bool(
            rung_gates[rung_key(left)]["passes"]
            and rung_gates[rung_key(right)]["passes"]
        )
    return {
        "rung_gates": rung_gates,
        "adjacent_pair_passes": pair_gates,
        "passes_phase1": any(pair_gates.values()),
        "operator_gate_open": False,
        "g2_closed": True,
    }


def final_gates(
    density_summaries: dict[str, dict[str, object]],
) -> dict[str, object]:
    """Adjacent-rung and two-density stability gates."""

    density_keys = [str(events) for events in FROZEN_DENSITIES]
    adjacent_pairs = ((0.8, 1.0), (1.0, 1.25))
    pair_passes: dict[str, bool] = {}
    for left, right in adjacent_pairs:
        pair_passes[f"{left}-{right}"] = all(
            bool(density_summaries[key][str(left)]["density_pass"])
            and bool(density_summaries[key][str(right)]["density_pass"])
            for key in density_keys
        )

    drift: dict[str, object] = {}
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        lower = density_summaries[density_keys[0]][str(beta)]
        upper = density_summaries[density_keys[1]][str(beta)]
        metric_drift: dict[str, float | None] = {}
        for metric in (
            "median_all_event_coverage",
            "median_bulk_coverage",
            "median_repeated_given_covered_bulk",
        ):
            left_value = lower[metric]
            right_value = upper[metric]
            metric_drift[metric] = (
                abs(float(left_value) - float(right_value))
                if left_value is not None and right_value is not None
                else None
            )
        drift[str(beta)] = {
            "metrics": metric_drift,
            "passes": bool(
                bool(lower["density_pass"])
                and bool(upper["density_pass"])
                and all(
                    value is not None and value <= MAXIMUM_REFINEMENT_DRIFT
                    for value in metric_drift.values()
                )
            ),
        }

    stage_pass = any(pair_passes.values()) and any(
        all(bool(drift[str(beta)]["passes"]) for beta in pair)
        for pair in adjacent_pairs
        if pair_passes[f"{pair[0]}-{pair[1]}"]
    )
    return {
        "adjacent_pair_density_passes": pair_passes,
        "refinement_drift": drift,
        "stage_passes_coverage_gate": bool(stage_pass),
        "operator_gate_open": False,
        "g2_closed": True,
    }


def run_benchmark(
    seed: int = FROZEN_SEED,
    densities: tuple[int, ...] = FROZEN_DENSITIES,
    realizations: int = 5,
    duration: float = 1.0,
) -> dict[str, object]:
    """Run the frozen two-density A3f-R1 coverage benchmark."""

    if seed != FROZEN_SEED:
        raise ValueError("the frozen seed is exactly 2026071607")
    if densities != FROZEN_DENSITIES:
        raise ValueError("the frozen densities are exactly (4800, 9600)")
    if realizations != 5:
        raise ValueError("the frozen benchmark requires five realizations")
    if duration <= 0.0:
        raise ValueError("duration must be positive")
    if duration != 1.0:
        raise ValueError("the frozen duration is exactly one")
    seed_states = spawn_realization_seed_states(
        seed,
        densities,
        realizations,
        len(FROZEN_BUFFER_RADIUS_MULTIPLIERS),
    )
    records: list[dict[str, object]] = []
    density_records: dict[str, list[dict[str, object]]] = {
        str(events): [] for events in densities
    }

    root_index = 0
    for events in densities:
        schedule = schedule_at_density(float(events))
        for realization_index in range(realizations):
            started = time.perf_counter()
            realization_seed_states = seed_states[root_index]
            root_index += 1
            points, _ = sprinkle_minkowski_diamond(
                _rng(realization_seed_states[0]),
                events,
                duration,
            )
            relation = causal_relation_matrix(points)
            del points
            inclusive_counts = sparse_inclusive_interval_count_matrix(relation)
            candidates = complete_outer_candidates(
                inclusive_counts, schedule.outer_count
            )
            rungs = []
            for beta, atlas_seed_state in zip(
                FROZEN_BUFFER_RADIUS_MULTIPLIERS,
                realization_seed_states[1:],
                strict=True,
            ):
                evaluation = evaluate_atlas(
                    relation,
                    inclusive_counts,
                    candidates,
                    beta,
                    schedule.buffer_count,
                    FROZEN_ATLAS_SIZE,
                    _rng(atlas_seed_state),
                )
                rungs.append(asdict(evaluation))
            record = {
                "events": events,
                "realization": realization_index,
                "seed_states": realization_seed_states,
                "schedule": asdict(schedule),
                "rungs": rungs,
                "runtime_seconds": time.perf_counter() - started,
            }
            records.append(record)
            density_records[str(events)].append(record)

    summaries = {
        key: summarize_density(value) for key, value in density_records.items()
    }
    return {
        "stage": "A3f-R1",
        "claim_boundary": (
            "finite order-atlas coverage/overlap only; no operator locality or G2"
        ),
        "frozen_protocol": {
            "seed": seed,
            "densities": densities,
            "realizations": realizations,
            "duration": duration,
            "outer_band": FROZEN_OUTER_BAND,
            "buffer_radius_multipliers": FROZEN_BUFFER_RADIUS_MULTIPLIERS,
            "atlas_size": FROZEN_ATLAS_SIZE,
            "minimum_all_event_coverage": MINIMUM_ALL_EVENT_COVERAGE,
            "minimum_bulk_coverage": MINIMUM_BULK_COVERAGE,
            "minimum_repeated_coverage": MINIMUM_REPEATED_COVERAGE,
            "minimum_realizations_passing": MINIMUM_REALIZATIONS_PASSING,
            "maximum_refinement_drift": MAXIMUM_REFINEMENT_DRIFT,
        },
        "realizations": records,
        "density_summaries": summaries,
        "gates": final_gates(summaries),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--seed", type=int, default=FROZEN_SEED)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    payload = run_benchmark(seed=args.seed, realizations=args.realizations)
    args.output.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(json.dumps(payload["gates"], indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
