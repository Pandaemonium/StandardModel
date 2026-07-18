"""Equivariant greedy packing gate for protected causal-diamond cores.

Stage A3f-R2 changes only the selector used by the killed A3f-R1 uniform-atlas
benchmark.  It materializes the complete order-selected carrier/core family,
maximizes marginal coverage of an independently defined order bulk, samples
uniformly from every exact residual tie orbit, and compares with an independently
streamed uniform atlas on the same realization.

Coordinates generate the oracle causal relation and are discarded before every
selector and statistic in this module.  This is a finite atlas-packing test, not
an operator-locality result or a continuum-GR derivation.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import time
from dataclasses import asdict, dataclass
from itertools import combinations
from pathlib import Path

import numpy as np
from scipy import sparse

from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_atlas_coverage import (
    FROZEN_ATLAS_SIZE,
    FROZEN_BUFFER_RADIUS_MULTIPLIERS,
    FROZEN_DENSITIES,
    FROZEN_OUTER_BAND,
    MAXIMUM_REFINEMENT_DRIFT,
    MINIMUM_ALL_EVENT_COVERAGE,
    MINIMUM_BULK_COVERAGE,
    MINIMUM_REALIZATIONS_PASSING,
    MINIMUM_REPEATED_COVERAGE,
    _rng,
    complete_outer_candidates,
    independent_order_bulk,
    sampled_induced_count_tripwire,
    spawn_realization_seed_states,
)
from causal_buffered_core_feasibility import schedule_at_density
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_operator_metric import sprinkle_minkowski_diamond


FROZEN_SEED = 2026071608
MAXIMUM_COMPLETE_CANDIDATES = 2000
MINIMUM_COMPLETE_UNION_ALL_EVENT_COVERAGE = 0.60
MINIMUM_COMPLETE_UNION_BULK_COVERAGE = 0.80
MINIMUM_ALL_EVENT_IMPROVEMENT = 0.10


@dataclass(frozen=True)
class GreedyStep:
    """One archived bulk-first, all-event-second greedy choice."""

    step: int
    maximum_bulk_marginal: int
    maximum_all_event_marginal: int
    exact_tie_orbit: tuple[tuple[int, int, int], ...]
    chosen_candidate: tuple[int, int, int]


@dataclass(frozen=True)
class AtlasMetrics:
    """Order-only coverage and overlap data for one selected atlas."""

    selected_candidates: tuple[tuple[int, int, int], ...]
    core_sizes: tuple[int, ...]
    all_event_coverage: float
    covered_bulk_count: int
    bulk_coverage: float | None
    repeated_covered_bulk_count: int
    repeated_given_covered_bulk: float | None
    maximum_multiplicity: int
    overlap_edges: tuple[tuple[int, int], ...]
    overlap_graph_connected: bool


@dataclass(frozen=True)
class PackingEvaluation:
    """Frozen A3f-R2 result for one buffer rung in one realization."""

    buffer_radius_multiplier: float
    buffer_count: float
    complete_candidate_count: int
    resource_gate_passes: bool
    complete_union_all_event_coverage: float | None
    complete_union_bulk_coverage: float | None
    complete_union_feasibility_passes: bool
    bulk_count: int
    greedy_steps: tuple[GreedyStep, ...]
    greedy: AtlasMetrics
    uniform_control: AtlasMetrics
    all_event_coverage_improvement: float
    positive_all_event_marginal_after_first: bool
    core_containment_tripwire: bool
    induced_count_tripwire: bool
    selection_replay_tripwire: bool
    uniform_replay_tripwire: bool
    passes_empirical_gate: bool


def _empty_metrics() -> AtlasMetrics:
    return AtlasMetrics((), (), 0.0, 0, None, 0, None, 0, (), False)


def _validate_candidates(candidates: np.ndarray) -> None:
    if candidates.ndim != 2 or candidates.shape[1] != 3:
        raise ValueError("candidates must have shape (C,3)")


def complete_candidate_carriers(
    relation: np.ndarray,
    candidates: np.ndarray,
) -> np.ndarray:
    """Materialize every open outer carrier without candidate truncation."""

    _validate_candidates(candidates)
    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if len(candidates) > MAXIMUM_COMPLETE_CANDIDATES:
        raise ValueError("complete candidate family exceeds resource ceiling")
    event_count = len(relation)
    carriers = np.zeros((len(candidates), event_count), dtype=bool)
    for index, (past, future, _) in enumerate(candidates):
        past_index = int(past)
        future_index = int(future)
        if not relation[past_index, future_index]:
            raise ValueError("candidate endpoints must be strictly comparable")
        carriers[index] = relation[past_index] & relation[:, future_index]
    return carriers


def complete_candidate_cores(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    candidates: np.ndarray,
    buffer_count: float,
    carriers: np.ndarray | None = None,
) -> tuple[np.ndarray, np.ndarray]:
    """Materialize every ambient-count protected core before selection."""

    _validate_candidates(candidates)
    if inclusive_counts.shape != relation.shape:
        raise ValueError("relation and count matrix shapes must agree")
    if buffer_count < 0.0:
        raise ValueError("buffer count must be nonnegative")
    if carriers is None:
        carriers = complete_candidate_carriers(relation, candidates)
    expected_shape = (len(candidates), len(relation))
    if carriers.shape != expected_shape:
        raise ValueError("carrier matrix has the wrong shape")

    count_csc = inclusive_counts.tocsc()
    cores = np.zeros_like(carriers)
    for index, (past, future, _) in enumerate(candidates):
        past_eligible = np.zeros(len(relation), dtype=bool)
        row_start = inclusive_counts.indptr[int(past)]
        row_stop = inclusive_counts.indptr[int(past) + 1]
        row_indices = inclusive_counts.indices[row_start:row_stop]
        row_values = inclusive_counts.data[row_start:row_stop]
        past_eligible[row_indices[row_values >= buffer_count]] = True

        future_eligible = np.zeros(len(relation), dtype=bool)
        col_start = count_csc.indptr[int(future)]
        col_stop = count_csc.indptr[int(future) + 1]
        col_indices = count_csc.indices[col_start:col_stop]
        col_values = count_csc.data[col_start:col_stop]
        future_eligible[col_indices[col_values >= buffer_count]] = True
        cores[index] = carriers[index] & past_eligible & future_eligible
    return carriers, cores


def marginal_scores(
    cores: np.ndarray,
    available: np.ndarray,
    covered: np.ndarray,
    universe: np.ndarray,
) -> np.ndarray:
    """Cardinal marginal scores for every currently available core."""

    if cores.ndim != 2:
        raise ValueError("cores must be a two-dimensional Boolean matrix")
    if available.shape != (len(cores),):
        raise ValueError("available mask has the wrong shape")
    if covered.shape != (cores.shape[1],) or universe.shape != covered.shape:
        raise ValueError("event masks have the wrong shape")
    residual = universe & ~covered
    return np.count_nonzero(cores[available] & residual, axis=1)


def exact_greedy_tie_indices(
    cores: np.ndarray,
    available: np.ndarray,
    covered: np.ndarray,
    bulk: np.ndarray,
) -> tuple[np.ndarray, int, int]:
    """Return the complete bulk-maximal then all-event-maximal tie set."""

    available_indices = np.flatnonzero(available)
    if len(available_indices) == 0:
        return np.empty(0, dtype=np.int64), 0, 0
    bulk_scores = marginal_scores(cores, available, covered, bulk)
    maximum_bulk = int(np.max(bulk_scores))
    primary = available_indices[bulk_scores == maximum_bulk]
    all_scores = np.count_nonzero(cores[primary] & ~covered, axis=1)
    maximum_all = int(np.max(all_scores))
    return primary[all_scores == maximum_all], maximum_bulk, maximum_all


def greedy_maximum_coverage(
    candidates: np.ndarray,
    cores: np.ndarray,
    bulk: np.ndarray,
    atlas_size: int,
    rng: np.random.Generator,
) -> tuple[np.ndarray, tuple[GreedyStep, ...]]:
    """Bulk-first greedy coverage with uniform sampling on every exact tie."""

    _validate_candidates(candidates)
    if cores.shape != (len(candidates), len(bulk)):
        raise ValueError("core matrix has the wrong shape")
    if atlas_size <= 0:
        raise ValueError("atlas size must be positive")
    available = np.ones(len(candidates), dtype=bool)
    covered = np.zeros(len(bulk), dtype=bool)
    selected: list[int] = []
    steps: list[GreedyStep] = []
    for step_index in range(min(atlas_size, len(candidates))):
        tied, maximum_bulk, maximum_all = exact_greedy_tie_indices(
            cores, available, covered, bulk
        )
        chosen = int(tied[int(rng.integers(len(tied)))])
        tie_orbit = tuple(
            tuple(int(value) for value in candidates[index]) for index in tied
        )
        chosen_candidate = tuple(int(value) for value in candidates[chosen])
        steps.append(
            GreedyStep(
                step=step_index + 1,
                maximum_bulk_marginal=maximum_bulk,
                maximum_all_event_marginal=maximum_all,
                exact_tie_orbit=tie_orbit,
                chosen_candidate=chosen_candidate,
            )
        )
        selected.append(chosen)
        available[chosen] = False
        covered |= cores[chosen]
    return np.asarray(selected, dtype=np.int64), tuple(steps)


def sample_uniform_indices(
    candidate_count: int,
    atlas_size: int,
    rng: np.random.Generator,
) -> np.ndarray:
    """Uniform control subset sampled after complete-family construction."""

    if candidate_count < 0 or atlas_size <= 0:
        raise ValueError("candidate count and atlas size must be valid")
    if candidate_count <= atlas_size:
        return np.arange(candidate_count, dtype=np.int64)
    return np.sort(
        rng.choice(candidate_count, size=atlas_size, replace=False)
    ).astype(np.int64, copy=False)


def core_overlap_edges(selected_cores: np.ndarray) -> tuple[tuple[int, int], ...]:
    """Edges of the nonempty protected-core intersection graph."""

    if selected_cores.ndim != 2:
        raise ValueError("selected cores must form a matrix")
    return tuple(
        (left, right)
        for left in range(len(selected_cores))
        for right in range(left + 1, len(selected_cores))
        if np.any(selected_cores[left] & selected_cores[right])
    )


def overlap_graph_connected(
    selected_cores: np.ndarray,
    edges: tuple[tuple[int, int], ...] | None = None,
) -> bool:
    """Whether all nonempty selected cores lie in one overlap component."""

    if selected_cores.ndim != 2 or len(selected_cores) == 0:
        return False
    if np.any(np.count_nonzero(selected_cores, axis=1) == 0):
        return False
    if len(selected_cores) == 1:
        return True
    if edges is None:
        edges = core_overlap_edges(selected_cores)
    neighbors = [set() for _ in range(len(selected_cores))]
    for left, right in edges:
        neighbors[left].add(right)
        neighbors[right].add(left)
    seen = {0}
    frontier = [0]
    while frontier:
        current = frontier.pop()
        for neighbor in neighbors[current] - seen:
            seen.add(neighbor)
            frontier.append(neighbor)
    return len(seen) == len(selected_cores)


def evaluate_selected_atlas(
    candidates: np.ndarray,
    cores: np.ndarray,
    selected: np.ndarray,
    bulk: np.ndarray,
) -> AtlasMetrics:
    """Compute all order-only statistics for fixed candidate indices."""

    _validate_candidates(candidates)
    if cores.shape != (len(candidates), len(bulk)):
        raise ValueError("core matrix has the wrong shape")
    if np.any(selected < 0) or np.any(selected >= len(candidates)):
        raise IndexError("selected candidate index is out of range")
    selected_cores = cores[selected]
    multiplicity = (
        np.sum(selected_cores, axis=0, dtype=np.int64)
        if len(selected_cores)
        else np.zeros(len(bulk), dtype=np.int64)
    )
    covered = multiplicity > 0
    covered_bulk = bulk & covered
    repeated_bulk = covered_bulk & (multiplicity >= 2)
    bulk_count = int(np.count_nonzero(bulk))
    covered_bulk_count = int(np.count_nonzero(covered_bulk))
    repeated_count = int(np.count_nonzero(repeated_bulk))
    edges = core_overlap_edges(selected_cores)
    return AtlasMetrics(
        selected_candidates=tuple(
            tuple(int(value) for value in candidates[index]) for index in selected
        ),
        core_sizes=tuple(
            int(np.count_nonzero(core)) for core in selected_cores
        ),
        all_event_coverage=float(np.mean(covered)),
        covered_bulk_count=covered_bulk_count,
        bulk_coverage=(
            float(covered_bulk_count / bulk_count) if bulk_count else None
        ),
        repeated_covered_bulk_count=repeated_count,
        repeated_given_covered_bulk=(
            float(repeated_count / covered_bulk_count)
            if covered_bulk_count
            else None
        ),
        maximum_multiplicity=int(np.max(multiplicity, initial=0)),
        overlap_edges=edges,
        overlap_graph_connected=overlap_graph_connected(selected_cores, edges),
    )


def exact_optimal_coverage(
    cores: np.ndarray,
    universe: np.ndarray,
    atlas_size: int,
) -> int:
    """Exhaustive optimum for hostile small-family tests only."""

    if cores.ndim != 2 or cores.shape[1:] != universe.shape:
        raise ValueError("core family and universe shapes disagree")
    if atlas_size <= 0:
        raise ValueError("atlas size must be positive")
    choose = min(atlas_size, len(cores))
    if choose == 0:
        return 0
    return max(
        int(np.count_nonzero(np.any(cores[list(indices)], axis=0) & universe))
        for indices in combinations(range(len(cores)), choose)
    )


def greedy_approximation_factor(atlas_size: int) -> float:
    """Finite K-step maximum-coverage factor 1-(1-1/K)^K."""

    if atlas_size <= 0:
        raise ValueError("atlas size must be positive")
    return float(1.0 - (1.0 - 1.0 / atlas_size) ** atlas_size)


def _failed_resource_evaluation(
    beta: float,
    buffer_count: float,
    candidate_count: int,
    bulk_count: int,
) -> PackingEvaluation:
    """Resource failure; zero improvement is an unobserved conservative value."""

    return PackingEvaluation(
        buffer_radius_multiplier=beta,
        buffer_count=buffer_count,
        complete_candidate_count=candidate_count,
        resource_gate_passes=False,
        complete_union_all_event_coverage=None,
        complete_union_bulk_coverage=None,
        complete_union_feasibility_passes=False,
        bulk_count=bulk_count,
        greedy_steps=(),
        greedy=_empty_metrics(),
        uniform_control=_empty_metrics(),
        all_event_coverage_improvement=0.0,
        positive_all_event_marginal_after_first=False,
        core_containment_tripwire=False,
        induced_count_tripwire=False,
        selection_replay_tripwire=False,
        uniform_replay_tripwire=False,
        passes_empirical_gate=False,
    )


def evaluate_packing_rung(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    complete_candidates: np.ndarray,
    buffer_radius_multiplier: float,
    base_buffer_count: float,
    greedy_seed_state: tuple[int, ...],
    uniform_seed_state: tuple[int, ...],
    atlas_size: int = FROZEN_ATLAS_SIZE,
    carriers: np.ndarray | None = None,
) -> PackingEvaluation:
    """Evaluate one complete-core greedy packing rung and fresh control."""

    if buffer_radius_multiplier <= 0.0 or base_buffer_count <= 0.0:
        raise ValueError("buffer scales must be positive")
    if atlas_size <= 0:
        raise ValueError("atlas size must be positive")
    _validate_candidates(complete_candidates)
    buffer_count = buffer_radius_multiplier**4 * base_buffer_count
    bulk = independent_order_bulk(relation, buffer_count)
    bulk_count = int(np.count_nonzero(bulk))
    candidate_count = len(complete_candidates)
    if candidate_count > MAXIMUM_COMPLETE_CANDIDATES:
        return _failed_resource_evaluation(
            buffer_radius_multiplier,
            buffer_count,
            candidate_count,
            bulk_count,
        )

    carriers, cores = complete_candidate_cores(
        relation,
        inclusive_counts,
        complete_candidates,
        buffer_count,
        carriers,
    )
    complete_union = np.any(cores, axis=0) if len(cores) else np.zeros(
        len(relation), dtype=bool
    )
    complete_all_coverage = float(np.mean(complete_union))
    complete_bulk_covered = int(np.count_nonzero(complete_union & bulk))
    complete_bulk_coverage = (
        float(complete_bulk_covered / bulk_count) if bulk_count else None
    )
    feasibility = bool(
        complete_all_coverage >= MINIMUM_COMPLETE_UNION_ALL_EVENT_COVERAGE
        and complete_bulk_coverage is not None
        and complete_bulk_coverage >= MINIMUM_COMPLETE_UNION_BULK_COVERAGE
    )

    greedy_indices, greedy_steps = greedy_maximum_coverage(
        complete_candidates,
        cores,
        bulk,
        atlas_size,
        _rng(greedy_seed_state),
    )
    replay_indices, replay_steps = greedy_maximum_coverage(
        complete_candidates,
        cores,
        bulk,
        atlas_size,
        _rng(greedy_seed_state),
    )
    uniform_indices = sample_uniform_indices(
        candidate_count, atlas_size, _rng(uniform_seed_state)
    )
    uniform_replay = sample_uniform_indices(
        candidate_count, atlas_size, _rng(uniform_seed_state)
    )
    greedy_metrics = evaluate_selected_atlas(
        complete_candidates, cores, greedy_indices, bulk
    )
    uniform_metrics = evaluate_selected_atlas(
        complete_candidates, cores, uniform_indices, bulk
    )
    improvement = (
        greedy_metrics.all_event_coverage - uniform_metrics.all_event_coverage
    )
    positive_later_marginal = any(
        step.maximum_all_event_marginal > 0 for step in greedy_steps[1:]
    )
    containment_tripwire = bool(
        np.all(~cores | carriers) if len(cores) else True
    )
    tripwire_indices = np.unique(
        np.concatenate((greedy_indices, uniform_indices))
    )
    induced_tripwire = bool(
        len(greedy_indices) == atlas_size
        and len(uniform_indices) == atlas_size
        and all(
            sampled_induced_count_tripwire(
                relation, inclusive_counts, carriers[int(index)]
            )
            for index in tripwire_indices
        )
    )
    selection_replay = bool(
        np.array_equal(greedy_indices, replay_indices)
        and greedy_steps == replay_steps
    )
    uniform_replay_passes = bool(
        np.array_equal(uniform_indices, uniform_replay)
    )
    passes = bool(
        atlas_size <= candidate_count <= MAXIMUM_COMPLETE_CANDIDATES
        and feasibility
        and greedy_metrics.all_event_coverage >= MINIMUM_ALL_EVENT_COVERAGE
        and greedy_metrics.bulk_coverage is not None
        and greedy_metrics.bulk_coverage >= MINIMUM_BULK_COVERAGE
        and greedy_metrics.repeated_given_covered_bulk is not None
        and greedy_metrics.repeated_given_covered_bulk
        >= MINIMUM_REPEATED_COVERAGE
        and greedy_metrics.overlap_graph_connected
        and positive_later_marginal
        and containment_tripwire
        and induced_tripwire
        and selection_replay
        and uniform_replay_passes
    )
    return PackingEvaluation(
        buffer_radius_multiplier=buffer_radius_multiplier,
        buffer_count=buffer_count,
        complete_candidate_count=candidate_count,
        resource_gate_passes=True,
        complete_union_all_event_coverage=complete_all_coverage,
        complete_union_bulk_coverage=complete_bulk_coverage,
        complete_union_feasibility_passes=feasibility,
        bulk_count=bulk_count,
        greedy_steps=greedy_steps,
        greedy=greedy_metrics,
        uniform_control=uniform_metrics,
        all_event_coverage_improvement=improvement,
        positive_all_event_marginal_after_first=positive_later_marginal,
        core_containment_tripwire=containment_tripwire,
        induced_count_tripwire=induced_tripwire,
        selection_replay_tripwire=selection_replay,
        uniform_replay_tripwire=uniform_replay_passes,
        passes_empirical_gate=passes,
    )


def spawn_packing_seed_states(
    seed: int,
    densities: tuple[int, ...],
    realizations: int,
) -> tuple[tuple[tuple[int, ...], ...], ...]:
    """One sprinkling, three greedy, and three uniform streams per run."""

    return spawn_realization_seed_states(
        seed,
        densities,
        realizations,
        2 * len(FROZEN_BUFFER_RADIUS_MULTIPLIERS),
    )


def _median(values: list[float | None]) -> float | None:
    finite = [value for value in values if value is not None and np.isfinite(value)]
    return float(np.median(finite)) if finite else None


def summarize_density(realizations: list[dict[str, object]]) -> dict[str, object]:
    """Cluster first over realizations for every frozen buffer rung."""

    summary: dict[str, object] = {}
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        rows = [
            next(
                rung
                for rung in realization["rungs"]
                if rung["buffer_radius_multiplier"] == beta
            )
            for realization in realizations
        ]
        passing = int(sum(bool(row["passes_empirical_gate"]) for row in rows))
        median_improvement = _median(
            [float(row["all_event_coverage_improvement"]) for row in rows]
        )
        summary[str(beta)] = {
            "realizations_passing": passing,
            "density_pass": bool(
                passing >= MINIMUM_REALIZATIONS_PASSING
                and median_improvement is not None
                and median_improvement >= MINIMUM_ALL_EVENT_IMPROVEMENT
            ),
            "median_complete_candidate_count": _median(
                [float(row["complete_candidate_count"]) for row in rows]
            ),
            "median_complete_union_all_event_coverage": _median(
                [row["complete_union_all_event_coverage"] for row in rows]
            ),
            "median_complete_union_bulk_coverage": _median(
                [row["complete_union_bulk_coverage"] for row in rows]
            ),
            "median_greedy_all_event_coverage": _median(
                [row["greedy"]["all_event_coverage"] for row in rows]
            ),
            "median_greedy_bulk_coverage": _median(
                [row["greedy"]["bulk_coverage"] for row in rows]
            ),
            "median_greedy_repeated_given_covered_bulk": _median(
                [
                    row["greedy"]["repeated_given_covered_bulk"]
                    for row in rows
                ]
            ),
            "median_uniform_all_event_coverage": _median(
                [row["uniform_control"]["all_event_coverage"] for row in rows]
            ),
            "median_all_event_coverage_improvement": median_improvement,
        }
    return summary


def final_gates(
    density_summaries: dict[str, dict[str, object]],
) -> dict[str, object]:
    """Adjacent-rung, two-density, improvement, and drift disposition."""

    density_keys = [str(events) for events in FROZEN_DENSITIES]
    adjacent_pairs = ((0.8, 1.0), (1.0, 1.25))
    pair_passes: dict[str, bool] = {}
    for left, right in adjacent_pairs:
        pair_passes[f"{left}-{right}"] = all(
            bool(density_summaries[key][str(beta)]["density_pass"])
            for key in density_keys
            for beta in (left, right)
        )

    drift: dict[str, object] = {}
    metrics = (
        "median_greedy_all_event_coverage",
        "median_greedy_bulk_coverage",
        "median_greedy_repeated_given_covered_bulk",
        "median_all_event_coverage_improvement",
    )
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        lower = density_summaries[density_keys[0]][str(beta)]
        upper = density_summaries[density_keys[1]][str(beta)]
        metric_drift = {
            metric: (
                abs(float(lower[metric]) - float(upper[metric]))
                if lower[metric] is not None and upper[metric] is not None
                else None
            )
            for metric in metrics
        }
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

    stage_pass = any(
        pair_passes[f"{left}-{right}"]
        and bool(drift[str(left)]["passes"])
        and bool(drift[str(right)]["passes"])
        for left, right in adjacent_pairs
    )
    return {
        "adjacent_pair_density_passes": pair_passes,
        "refinement_drift": drift,
        "stage_passes_packing_gate": bool(stage_pass),
        "operator_gate_open": False,
        "g2_closed": True,
    }


def _without_runtime_fields(value: object) -> object:
    """Recursively remove only object fields named ``runtime_seconds``."""

    if isinstance(value, dict):
        return {
            key: _without_runtime_fields(item)
            for key, item in value.items()
            if key != "runtime_seconds"
        }
    if isinstance(value, (list, tuple)):
        return [_without_runtime_fields(item) for item in value]
    return value


def scientific_content_sha256(payload: dict[str, object]) -> str:
    """Hash compact sorted JSON after recursively dropping runtime fields."""

    canonical = json.dumps(
        _without_runtime_fields(payload),
        sort_keys=True,
        separators=(",", ":"),
    ).encode("utf-8")
    return hashlib.sha256(canonical).hexdigest()


def file_sha256(path: Path) -> str:
    """Raw SHA-256 of an artifact exactly as written."""

    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_benchmark(
    seed: int = FROZEN_SEED,
    densities: tuple[int, ...] = FROZEN_DENSITIES,
    realizations: int = 5,
    duration: float = 1.0,
) -> dict[str, object]:
    """Run the once-only frozen A3f-R2 held-out packing benchmark."""

    if seed != FROZEN_SEED:
        raise ValueError("the frozen seed is exactly 2026071608")
    if densities != FROZEN_DENSITIES:
        raise ValueError("the frozen densities are exactly (4800, 9600)")
    if realizations != 5:
        raise ValueError("the frozen benchmark requires five realizations")
    if duration != 1.0:
        raise ValueError("the frozen duration is exactly one")
    seed_states = spawn_packing_seed_states(seed, densities, realizations)
    density_records: dict[str, list[dict[str, object]]] = {
        str(events): [] for events in densities
    }
    records: list[dict[str, object]] = []
    root_index = 0
    for events in densities:
        schedule = schedule_at_density(float(events))
        for realization_index in range(realizations):
            started = time.perf_counter()
            role_states = seed_states[root_index]
            root_index += 1
            points, _ = sprinkle_minkowski_diamond(
                _rng(role_states[0]), events, duration
            )
            relation = causal_relation_matrix(points)
            del points
            inclusive_counts = sparse_inclusive_interval_count_matrix(relation)
            candidates = complete_outer_candidates(
                inclusive_counts, schedule.outer_count, FROZEN_OUTER_BAND
            )
            carriers = (
                complete_candidate_carriers(relation, candidates)
                if len(candidates) <= MAXIMUM_COMPLETE_CANDIDATES
                else None
            )
            rungs = []
            for rung_index, beta in enumerate(
                FROZEN_BUFFER_RADIUS_MULTIPLIERS
            ):
                evaluation = evaluate_packing_rung(
                    relation,
                    inclusive_counts,
                    candidates,
                    beta,
                    schedule.buffer_count,
                    role_states[1 + rung_index],
                    role_states[1 + len(FROZEN_BUFFER_RADIUS_MULTIPLIERS) + rung_index],
                    carriers=carriers,
                )
                rungs.append(asdict(evaluation))
            record = {
                "events": events,
                "realization": realization_index,
                "seed_states": {
                    "sprinkling": role_states[0],
                    "greedy": role_states[1:4],
                    "uniform_control": role_states[4:7],
                },
                "schedule": asdict(schedule),
                "rungs": rungs,
                "runtime_seconds": time.perf_counter() - started,
            }
            records.append(record)
            density_records[str(events)].append(record)

    summaries = {
        key: summarize_density(rows) for key, rows in density_records.items()
    }
    return {
        "stage": "A3f-R2",
        "claim_boundary": (
            "finite order-atlas packing/overlap only; no operator locality or G2"
        ),
        "frozen_protocol": {
            "seed": seed,
            "densities": densities,
            "realizations": realizations,
            "duration": duration,
            "outer_band": FROZEN_OUTER_BAND,
            "buffer_radius_multipliers": FROZEN_BUFFER_RADIUS_MULTIPLIERS,
            "atlas_size": FROZEN_ATLAS_SIZE,
            "maximum_complete_candidates": MAXIMUM_COMPLETE_CANDIDATES,
            "minimum_complete_union_all_event_coverage": (
                MINIMUM_COMPLETE_UNION_ALL_EVENT_COVERAGE
            ),
            "minimum_complete_union_bulk_coverage": (
                MINIMUM_COMPLETE_UNION_BULK_COVERAGE
            ),
            "minimum_all_event_coverage": MINIMUM_ALL_EVENT_COVERAGE,
            "minimum_bulk_coverage": MINIMUM_BULK_COVERAGE,
            "minimum_repeated_coverage": MINIMUM_REPEATED_COVERAGE,
            "minimum_all_event_improvement": MINIMUM_ALL_EVENT_IMPROVEMENT,
            "minimum_realizations_passing": MINIMUM_REALIZATIONS_PASSING,
            "maximum_refinement_drift": MAXIMUM_REFINEMENT_DRIFT,
            "scientific_hash_canonicalization": (
                "recursively remove object fields named runtime_seconds; "
                "json.dumps(sort_keys=True,separators=(',',':')); UTF-8; "
                "no trailing newline"
            ),
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
    report = {
        "gates": payload["gates"],
        "artifact_hashes": {
            "raw_sha256": file_sha256(args.output),
            "scientific_content_sha256": scientific_content_sha256(payload),
        },
    }
    print(json.dumps(report, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
