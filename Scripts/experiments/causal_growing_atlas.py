"""Growing bounded-multiplicity causal-atlas benchmark.

Stage A3f-R4 tests whether the complete order-only protected-core family can
support a growing atlas with connected but non-collapsed overlap topology.  A
development phase selects the smallest preregistered multiplicity cap, then a
held-out phase runs automatically on a disjoint seed.  Coordinates are used
only to generate the oracle causal relation and are discarded before every
candidate, selector, nerve, and gate computation.

This is a finite atlas/nerve experiment on flat manifold-generated controls,
not an operator-metric, tetrad, curvature, or general-relativity derivation.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import time
from dataclasses import asdict, dataclass
from itertools import combinations
from pathlib import Path
from typing import Callable

import numpy as np
import psutil
from scipy import sparse

from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_atlas_coverage import (
    FROZEN_OUTER_BAND,
    complete_outer_candidates,
    independent_order_bulk,
    sampled_induced_count_tripwire,
)
from causal_atlas_packing import (
    complete_candidate_cores,
    evaluate_selected_atlas,
    greedy_maximum_coverage,
)
from causal_atlas_scaling import process_peak_working_set_bytes
from causal_buffered_core_feasibility import schedule_at_density
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_operator_metric import sprinkle_minkowski_diamond
from frozen_run_guard import frozen_run_set_reservation


DEVELOPMENT_SEED = 2026071610
HELDOUT_SEED = 2026071611
FROZEN_DENSITIES = (6000, 12000)
FROZEN_BUFFER_RADIUS_MULTIPLIERS = (0.8, 1.0)
DEVELOPMENT_REALIZATIONS = 3
HELDOUT_REALIZATIONS = 5
FROZEN_CAPS = (5, 8, 12)
RANDOM_CONTROL_DRAWS = 5
FROZEN_DURATION = 1.0
MAXIMUM_COMPLETE_CANDIDATES = 4000
MAXIMUM_DENSE_RELATION_ENTRIES = 12001**2
MAXIMUM_PEAK_WORKING_SET_BYTES = 6 * 1024**3
MAXIMUM_REALIZATION_SECONDS = 600.0
MINIMUM_HEADROOM = 0.02
MINIMUM_BULK_COVERAGE = 0.70
MINIMUM_FAMILY_CAPTURE = 0.80
MINIMUM_HEADROOM_CAPTURE = 0.50
MINIMUM_REPEATED_COVERAGE = 0.35
MAXIMUM_EDGE_DENSITY = 0.90
MINIMUM_TRIANGLE_PARTICIPATION = 0.80
MAXIMUM_REFINEMENT_DRIFT = 0.15


@dataclass(frozen=True)
class CapacityStep:
    """One exact capacity-constrained greedy choice."""

    step: int
    maximum_bulk_marginal: int
    maximum_all_event_marginal: int
    exact_tie_orbit: tuple[tuple[int, int, int], ...]
    chosen_candidate: tuple[int, int, int]


def atlas_size(events: int) -> int:
    """Frozen growing cardinality ``ceil(2 N^(1/4))``."""

    if events <= 0:
        raise ValueError("event count must be positive")
    return int(math.ceil(2.0 * events**0.25))


def _rng(seed_state: tuple[int, ...]) -> np.random.Generator:
    return np.random.default_rng(np.asarray(seed_state, dtype=np.uint32))


def _seed_state(root: np.random.SeedSequence) -> tuple[int, ...]:
    return tuple(int(value) for value in root.generate_state(4))


def spawn_phase_seed_states(
    seed: int,
    densities: tuple[int, ...],
    realizations: int,
    caps: tuple[int, ...],
) -> tuple[dict[str, object], ...]:
    """Create disjoint replayable streams for one complete phase."""

    if not densities or any(events <= 0 for events in densities):
        raise ValueError("densities must be positive")
    if realizations <= 0 or not caps or any(cap <= 0 for cap in caps):
        raise ValueError("realizations and caps must be positive")
    run_roots = np.random.SeedSequence(seed).spawn(len(densities) * realizations)
    records: list[dict[str, object]] = []
    for run_root in run_roots:
        role_count = 1 + len(FROZEN_BUFFER_RADIUS_MULTIPLIERS) * (
            1 + len(caps) * (1 + RANDOM_CONTROL_DRAWS)
        )
        roles = run_root.spawn(role_count)
        cursor = 0
        sprinkling = _seed_state(roles[cursor])
        cursor += 1
        rungs: dict[str, object] = {}
        for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
            unconstrained = _seed_state(roles[cursor])
            cursor += 1
            cap_states: dict[str, object] = {}
            for cap in caps:
                greedy = _seed_state(roles[cursor])
                cursor += 1
                controls = tuple(
                    _seed_state(roles[cursor + offset])
                    for offset in range(RANDOM_CONTROL_DRAWS)
                )
                cursor += RANDOM_CONTROL_DRAWS
                cap_states[str(cap)] = {
                    "greedy": greedy,
                    "random_controls": controls,
                }
            rungs[str(beta)] = {
                "unconstrained_greedy": unconstrained,
                "caps": cap_states,
            }
        if cursor != role_count:
            raise RuntimeError("seed role accounting mismatch")
        records.append({"sprinkling": sprinkling, "rungs": rungs})
    return tuple(records)


def materialize_candidate_carriers(
    relation: np.ndarray,
    candidates: np.ndarray,
) -> np.ndarray:
    """Materialize every open carrier under the R4 candidate ceiling."""

    if candidates.ndim != 2 or candidates.shape[1] != 3:
        raise ValueError("candidates must have shape (C,3)")
    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if len(candidates) > MAXIMUM_COMPLETE_CANDIDATES:
        raise ValueError("complete candidate family exceeds R4 ceiling")
    carriers = np.zeros((len(candidates), len(relation)), dtype=bool)
    for index, (past_value, future_value, _) in enumerate(candidates):
        past = int(past_value)
        future = int(future_value)
        if not relation[past, future]:
            raise ValueError("candidate endpoints must be comparable")
        carriers[index] = relation[past] & relation[:, future]
    return carriers


def capacity_feasible_mask(
    cores: np.ndarray,
    available: np.ndarray,
    multiplicity: np.ndarray,
    cap: int,
) -> np.ndarray:
    """Candidates whose addition preserves the eventwise multiplicity cap."""

    if cores.ndim != 2:
        raise ValueError("cores must be a matrix")
    if available.shape != (len(cores),):
        raise ValueError("available mask has the wrong shape")
    if multiplicity.shape != (cores.shape[1],):
        raise ValueError("multiplicity has the wrong shape")
    if cap <= 0:
        raise ValueError("multiplicity cap must be positive")
    nonempty = np.any(cores, axis=1)
    respects = np.all(~cores | (multiplicity < cap), axis=1)
    return available & nonempty & respects


def capacity_greedy_tie_indices(
    cores: np.ndarray,
    feasible: np.ndarray,
    covered: np.ndarray,
    bulk: np.ndarray,
) -> tuple[np.ndarray, int, int]:
    """Complete bulk-first, all-event-second tie orbit among feasible charts."""

    indices = np.flatnonzero(feasible)
    if len(indices) == 0:
        return np.empty(0, dtype=np.int64), 0, 0
    residual_bulk = bulk & ~covered
    bulk_scores = np.count_nonzero(cores[indices] & residual_bulk, axis=1)
    maximum_bulk = int(np.max(bulk_scores))
    primary = indices[bulk_scores == maximum_bulk]
    all_scores = np.count_nonzero(cores[primary] & ~covered, axis=1)
    maximum_all = int(np.max(all_scores))
    return primary[all_scores == maximum_all], maximum_bulk, maximum_all


def capacity_constrained_greedy(
    candidates: np.ndarray,
    cores: np.ndarray,
    bulk: np.ndarray,
    size: int,
    cap: int,
    rng: np.random.Generator,
) -> tuple[np.ndarray, tuple[CapacityStep, ...]]:
    """Bulk-first greedy selection restricted by a fixed overlap capacity."""

    if candidates.ndim != 2 or candidates.shape[1] != 3:
        raise ValueError("candidates must have shape (C,3)")
    if cores.shape != (len(candidates), len(bulk)):
        raise ValueError("core matrix has the wrong shape")
    if size <= 0 or cap <= 0:
        raise ValueError("atlas size and cap must be positive")
    available = np.ones(len(candidates), dtype=bool)
    covered = np.zeros(len(bulk), dtype=bool)
    multiplicity = np.zeros(len(bulk), dtype=np.int64)
    selected: list[int] = []
    steps: list[CapacityStep] = []
    for step_index in range(size):
        feasible = capacity_feasible_mask(cores, available, multiplicity, cap)
        tied, maximum_bulk, maximum_all = capacity_greedy_tie_indices(
            cores, feasible, covered, bulk
        )
        if len(tied) == 0:
            break
        chosen = int(tied[int(rng.integers(len(tied)))])
        steps.append(
            CapacityStep(
                step=step_index + 1,
                maximum_bulk_marginal=maximum_bulk,
                maximum_all_event_marginal=maximum_all,
                exact_tie_orbit=tuple(
                    tuple(int(value) for value in candidates[index])
                    for index in tied
                ),
                chosen_candidate=tuple(
                    int(value) for value in candidates[chosen]
                ),
            )
        )
        selected.append(chosen)
        available[chosen] = False
        covered |= cores[chosen]
        multiplicity += cores[chosen]
        if int(np.max(multiplicity, initial=0)) > cap:
            raise RuntimeError("capacity selector exceeded its cap")
    return np.asarray(selected, dtype=np.int64), tuple(steps)


def random_priority_feasible(
    cores: np.ndarray,
    size: int,
    cap: int,
    rng: np.random.Generator,
) -> np.ndarray:
    """Random-priority feasible control, not uniform over feasible subsets."""

    if cores.ndim != 2 or size <= 0 or cap <= 0:
        raise ValueError("invalid core matrix, atlas size, or cap")
    multiplicity = np.zeros(cores.shape[1], dtype=np.int64)
    selected: list[int] = []
    for value in rng.permutation(len(cores)):
        index = int(value)
        core = cores[index]
        if not np.any(core) or np.any(multiplicity[core] >= cap):
            continue
        selected.append(index)
        multiplicity += core
        if len(selected) == size:
            break
    return np.asarray(selected, dtype=np.int64)


def occupied_triangles(
    selected_cores: np.ndarray,
) -> tuple[tuple[int, int, int], ...]:
    """Genuine triple intersections, not merely graph triangles."""

    if selected_cores.ndim != 2:
        raise ValueError("selected cores must be a matrix")
    return tuple(
        (left, middle, right)
        for left, middle, right in combinations(range(len(selected_cores)), 3)
        if np.any(
            selected_cores[left]
            & selected_cores[middle]
            & selected_cores[right]
        )
    )


def extended_atlas_metrics(
    candidates: np.ndarray,
    cores: np.ndarray,
    selected: np.ndarray,
    bulk: np.ndarray,
) -> dict[str, object]:
    """Coverage plus literal finite-nerve observables for one atlas."""

    base = asdict(evaluate_selected_atlas(candidates, cores, selected, bulk))
    selected_cores = cores[selected]
    multiplicity = (
        np.sum(selected_cores, axis=0, dtype=np.int64)
        if len(selected_cores)
        else np.zeros(len(bulk), dtype=np.int64)
    )
    triangles = occupied_triangles(selected_cores)
    participating = {index for triangle in triangles for index in triangle}
    edge_count = len(base["overlap_edges"])
    possible_edges = len(selected) * (len(selected) - 1) // 2
    histogram = np.bincount(
        multiplicity, minlength=len(selected) + 1
    ).astype(np.int64)
    base.update(
        {
            "selected_indices": tuple(int(index) for index in selected),
            "multiplicity_histogram": {
                str(index): int(value) for index, value in enumerate(histogram)
            },
            "occupied_triangles": triangles,
            "triangle_participation": (
                float(len(participating) / len(selected)) if len(selected) else 0.0
            ),
            "edge_density": (
                float(edge_count / possible_edges) if possible_edges else 0.0
            ),
            "full_common_intersection": bool(
                len(selected_cores) and np.any(np.all(selected_cores, axis=0))
            ),
        }
    )
    return base


def _median(values: list[float]) -> float:
    if not values:
        raise ValueError("a median requires observations")
    return float(np.median(np.asarray(values, dtype=float)))


def coverage_captures(
    selected: dict[str, object],
    controls: list[dict[str, object]],
    complete_all: float,
    complete_bulk: float,
) -> dict[str, float | None]:
    """Family and saturation-aware headroom capture in both channels."""

    selected_all = float(selected["all_event_coverage"])
    selected_bulk_value = selected["bulk_coverage"]
    if selected_bulk_value is None or complete_all <= 0.0 or complete_bulk <= 0.0:
        return {
            "median_control_all_event_coverage": None,
            "median_control_bulk_coverage": None,
            "all_event_family_capture": None,
            "bulk_family_capture": None,
            "all_event_headroom": None,
            "bulk_headroom": None,
            "all_event_headroom_capture": None,
            "bulk_headroom_capture": None,
        }
    selected_bulk = float(selected_bulk_value)
    control_all = _median(
        [float(control["all_event_coverage"]) for control in controls]
    )
    control_bulk = _median(
        [float(control["bulk_coverage"]) for control in controls]
    )
    all_headroom = complete_all - control_all
    bulk_headroom = complete_bulk - control_bulk
    return {
        "median_control_all_event_coverage": control_all,
        "median_control_bulk_coverage": control_bulk,
        "all_event_family_capture": selected_all / complete_all,
        "bulk_family_capture": selected_bulk / complete_bulk,
        "all_event_headroom": all_headroom,
        "bulk_headroom": bulk_headroom,
        "all_event_headroom_capture": (
            (selected_all - control_all) / all_headroom
            if all_headroom >= MINIMUM_HEADROOM
            else None
        ),
        "bulk_headroom_capture": (
            (selected_bulk - control_bulk) / bulk_headroom
            if bulk_headroom >= MINIMUM_HEADROOM
            else None
        ),
    }


def classify_cell(
    gates: dict[str, bool],
    inadmissible_reasons: list[str],
) -> str:
    """Apply the exhaustive R4 outcome taxonomy to one evaluated cell."""

    if inadmissible_reasons:
        return "INADMISSIBLE"
    return "PASS" if gates and all(gates.values()) else "FAIL"


def evaluate_capacity_cell(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    candidates: np.ndarray,
    carriers: np.ndarray,
    cores: np.ndarray,
    bulk: np.ndarray,
    cap: int,
    size: int,
    greedy_seed_state: tuple[int, ...],
    control_seed_states: tuple[tuple[int, ...], ...],
) -> dict[str, object]:
    """Evaluate one cap/buffer cell with exact outcome accounting."""

    if len(control_seed_states) != RANDOM_CONTROL_DRAWS:
        raise ValueError("exactly five control streams are required")
    complete_union = np.any(cores, axis=0) if len(cores) else np.zeros(
        len(relation), dtype=bool
    )
    bulk_count = int(np.count_nonzero(bulk))
    complete_bulk_count = int(np.count_nonzero(complete_union & bulk))
    complete_all = float(np.mean(complete_union))
    complete_bulk = (
        float(complete_bulk_count / bulk_count) if bulk_count else 0.0
    )
    containment = bool(np.all(~cores | carriers) if len(cores) else True)
    bulk_containment = bool(np.all(~cores | bulk) if len(cores) else True)
    candidate_count_tripwire = bool(
        all(
            int(np.count_nonzero(carriers[index])) == int(candidate[2]) - 1
            for index, candidate in enumerate(candidates)
        )
    )

    greedy, steps = capacity_constrained_greedy(
        candidates, cores, bulk, size, cap, _rng(greedy_seed_state)
    )
    replay, replay_steps = capacity_constrained_greedy(
        candidates, cores, bulk, size, cap, _rng(greedy_seed_state)
    )
    greedy_replay = bool(np.array_equal(greedy, replay) and steps == replay_steps)
    controls: list[np.ndarray] = []
    control_replay = True
    for seed_state in control_seed_states:
        selected = random_priority_feasible(cores, size, cap, _rng(seed_state))
        replayed = random_priority_feasible(cores, size, cap, _rng(seed_state))
        controls.append(selected)
        control_replay &= bool(np.array_equal(selected, replayed))

    greedy_metrics = extended_atlas_metrics(candidates, cores, greedy, bulk)
    control_metrics = [
        extended_atlas_metrics(candidates, cores, selected, bulk)
        for selected in controls
    ]
    captures = coverage_captures(
        greedy_metrics, control_metrics, complete_all, complete_bulk
    ) if all(len(selected) == size for selected in controls) else {}
    positive_later = any(
        step.maximum_all_event_marginal > 0 for step in steps[1:]
    )
    selected_for_tripwire = np.unique(
        np.concatenate([greedy, *controls])
    ) if controls else greedy
    induced_tripwire = bool(
        all(
            sampled_induced_count_tripwire(
                relation, inclusive_counts, carriers[int(index)]
            )
            for index in selected_for_tripwire
        )
    )

    tripwires = {
        "candidate_count": candidate_count_tripwire,
        "core_carrier_containment": containment,
        "core_bulk_containment": bulk_containment,
        "induced_count": induced_tripwire,
        "greedy_replay": greedy_replay,
        "control_replay": control_replay,
        "coverage_factorization": bool(
            complete_bulk_count == int(np.count_nonzero(complete_union))
        ),
    }
    all_tripwires = all(tripwires.values())
    greedy_complete = len(greedy) == size
    controls_complete = all(len(selected) == size for selected in controls)
    cap_respected = int(greedy_metrics["maximum_multiplicity"]) <= cap
    full_intersection = bool(greedy_metrics["full_common_intersection"])
    impossible_tripwire = (
        cap_respected and full_intersection and len(greedy) > cap
    )

    inadmissible_reasons: list[str] = []
    if len(candidates) < size:
        inadmissible_reasons.append("candidate family smaller than K_N")
    if not controls_complete:
        inadmissible_reasons.append("random-feasible control shortfall")
    if not all_tripwires:
        inadmissible_reasons.append("runtime tripwire failure")
    if not cap_respected:
        inadmissible_reasons.append("selector exceeded capacity")
    if impossible_tripwire:
        inadmissible_reasons.append("full-intersection entailment failure")
    if captures and (
        captures["all_event_headroom_capture"] is None
        or captures["bulk_headroom_capture"] is None
    ):
        inadmissible_reasons.append("control-saturated headroom")

    gates: dict[str, bool] = {
        "2_exact_cardinality": greedy_complete and controls_complete,
        "3_capacity": cap_respected,
        "4_connected": bool(greedy_metrics["overlap_graph_connected"]),
        "5_not_full_intersection": not full_intersection,
        "6_edge_density": float(greedy_metrics["edge_density"])
        < MAXIMUM_EDGE_DENSITY,
        "7_triangle_participation": float(
            greedy_metrics["triangle_participation"]
        )
        >= MINIMUM_TRIANGLE_PARTICIPATION,
        "8_repeated_coverage": (
            greedy_metrics["repeated_given_covered_bulk"] is not None
            and float(greedy_metrics["repeated_given_covered_bulk"])
            >= MINIMUM_REPEATED_COVERAGE
        ),
        "9_bulk_coverage": (
            greedy_metrics["bulk_coverage"] is not None
            and float(greedy_metrics["bulk_coverage"])
            >= MINIMUM_BULK_COVERAGE
        ),
        "10_family_capture": bool(
            captures
            and captures["all_event_family_capture"] is not None
            and captures["bulk_family_capture"] is not None
            and float(captures["all_event_family_capture"])
            >= MINIMUM_FAMILY_CAPTURE
            and float(captures["bulk_family_capture"])
            >= MINIMUM_FAMILY_CAPTURE
        ),
        "11_headroom_capture": bool(
            captures
            and captures["all_event_headroom_capture"] is not None
            and captures["bulk_headroom_capture"] is not None
            and float(captures["all_event_headroom_capture"])
            >= MINIMUM_HEADROOM_CAPTURE
            and float(captures["bulk_headroom_capture"])
            >= MINIMUM_HEADROOM_CAPTURE
        ),
        "12_positive_later_marginal": positive_later,
    }
    outcome = classify_cell(gates, inadmissible_reasons)
    return {
        "cap": cap,
        "atlas_size": size,
        "outcome": outcome,
        "inadmissible_reasons": inadmissible_reasons,
        "complete_union_all_event_coverage": complete_all,
        "complete_union_bulk_coverage": complete_bulk,
        "greedy": greedy_metrics,
        "greedy_steps": [asdict(step) for step in steps],
        "random_feasible_controls": control_metrics,
        "captures": captures,
        "positive_all_event_marginal_after_first": positive_later,
        "tripwires": tripwires,
        "gates": gates,
    }


def resource_failure_cells(
    caps: tuple[int, ...],
    reason: str,
) -> list[dict[str, object]]:
    """Structurally distinct cells for a relation-wide resource failure."""

    return [
        {
            "cap": cap,
            "outcome": "INADMISSIBLE",
            "inadmissible_reasons": [reason],
            "gates": {},
            "tripwires": {},
        }
        for cap in caps
    ]


def evaluate_realization(
    events: int,
    realization: int,
    seed_record: dict[str, object],
    caps: tuple[int, ...],
    *,
    clock: Callable[[], float] = time.perf_counter,
    process: psutil.Process | None = None,
) -> dict[str, object]:
    """Evaluate every requested cap and buffer on one shared sprinkling."""

    started = clock()
    active_process = process or psutil.Process()
    size = atlas_size(events)
    if (events + 1) ** 2 > MAXIMUM_DENSE_RELATION_ENTRIES:
        raise ValueError("dense relation ceiling would be exceeded")
    sprinkling_state = tuple(seed_record["sprinkling"])
    points, _ = sprinkle_minkowski_diamond(
        _rng(sprinkling_state), events, FROZEN_DURATION
    )
    relation = causal_relation_matrix(points)
    del points
    inclusive_counts = sparse_inclusive_interval_count_matrix(relation)
    schedule = schedule_at_density(float(events))
    candidates = complete_outer_candidates(
        inclusive_counts, schedule.outer_count, FROZEN_OUTER_BAND
    )
    peak = process_peak_working_set_bytes(active_process)
    rungs: list[dict[str, object]] = []
    if len(candidates) > MAXIMUM_COMPLETE_CANDIDATES:
        for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
            rungs.append(
                {
                    "buffer_radius_multiplier": beta,
                    "cells": resource_failure_cells(
                        caps, "complete candidate family exceeds ceiling"
                    ),
                }
            )
        return {
            "events": events,
            "realization": realization,
            "seed_states": seed_record,
            "schedule": asdict(schedule),
            "complete_candidate_count": len(candidates),
            "phase_peak_working_set_bytes": peak,
            "runtime_seconds": clock() - started,
            "resource_failure": "complete candidate family exceeds ceiling",
            "rungs": rungs,
        }
    if peak > MAXIMUM_PEAK_WORKING_SET_BYTES:
        reason = "peak working set exceeds ceiling"
        for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
            rungs.append(
                {
                    "buffer_radius_multiplier": beta,
                    "cells": resource_failure_cells(caps, reason),
                }
            )
        return {
            "events": events,
            "realization": realization,
            "seed_states": seed_record,
            "schedule": asdict(schedule),
            "complete_candidate_count": len(candidates),
            "phase_peak_working_set_bytes": peak,
            "runtime_seconds": clock() - started,
            "resource_failure": reason,
            "rungs": rungs,
        }

    carriers = materialize_candidate_carriers(relation, candidates)
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        buffer_count = beta**4 * schedule.buffer_count
        bulk = independent_order_bulk(relation, buffer_count)
        _, cores = complete_candidate_cores(
            relation,
            inclusive_counts,
            candidates,
            buffer_count,
            carriers,
        )
        rung_states = seed_record["rungs"][str(beta)]
        unconstrained, unconstrained_steps = greedy_maximum_coverage(
            candidates,
            cores,
            bulk,
            size,
            _rng(tuple(rung_states["unconstrained_greedy"])),
        )
        cells: list[dict[str, object]] = []
        for cap in caps:
            cap_states = rung_states["caps"][str(cap)]
            cells.append(
                evaluate_capacity_cell(
                    relation,
                    inclusive_counts,
                    candidates,
                    carriers,
                    cores,
                    bulk,
                    cap,
                    size,
                    tuple(cap_states["greedy"]),
                    tuple(tuple(state) for state in cap_states["random_controls"]),
                )
            )
        rungs.append(
            {
                "buffer_radius_multiplier": beta,
                "buffer_count": buffer_count,
                "bulk_count": int(np.count_nonzero(bulk)),
                "unconstrained_greedy": extended_atlas_metrics(
                    candidates, cores, unconstrained, bulk
                ),
                "unconstrained_greedy_steps": [
                    asdict(step) for step in unconstrained_steps
                ],
                "cells": cells,
            }
        )
        peak = max(peak, process_peak_working_set_bytes(active_process))

    elapsed = clock() - started
    if elapsed > MAXIMUM_REALIZATION_SECONDS:
        for rung in rungs:
            for cell in rung["cells"]:
                cell["outcome"] = "INADMISSIBLE"
                cell["inadmissible_reasons"] = [
                    "per-sprinkling wall time exceeds ceiling"
                ]
    if peak > MAXIMUM_PEAK_WORKING_SET_BYTES:
        for rung in rungs:
            for cell in rung["cells"]:
                cell["outcome"] = "INADMISSIBLE"
                cell["inadmissible_reasons"] = [
                    "peak working set exceeds ceiling"
                ]
    return {
        "events": events,
        "realization": realization,
        "seed_states": seed_record,
        "schedule": asdict(schedule),
        "atlas_size": size,
        "complete_candidate_count": len(candidates),
        "phase_peak_working_set_bytes": peak,
        "runtime_seconds": elapsed,
        "resource_failure": None,
        "rungs": rungs,
    }


def _cell_rows(
    records: list[dict[str, object]],
    events: int,
    beta: float,
    cap: int,
) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for record in records:
        if int(record["events"]) != events:
            continue
        rung = next(
            item
            for item in record["rungs"]
            if float(item["buffer_radius_multiplier"]) == beta
        )
        rows.append(next(cell for cell in rung["cells"] if int(cell["cap"]) == cap))
    return rows


def outcome_counts(rows: list[dict[str, object]]) -> dict[str, int]:
    """Count the exhaustive PASS/FAIL/INADMISSIBLE taxonomy."""

    return {
        outcome: sum(row["outcome"] == outcome for row in rows)
        for outcome in ("PASS", "FAIL", "INADMISSIBLE")
    }


def summarize_cell(rows: list[dict[str, object]]) -> dict[str, object]:
    """Cluster realization metrics only after retaining all raw outcomes."""

    counts = outcome_counts(rows)
    observed = [row for row in rows if row["outcome"] != "INADMISSIBLE"]

    def med(path: tuple[str, ...]) -> float | None:
        values: list[float] = []
        for row in observed:
            value: object = row
            for key in path:
                value = value[key]
            if value is not None:
                values.append(float(value))
        return _median(values) if values else None

    return {
        "outcomes": counts,
        "median_all_event_family_capture": med(
            ("captures", "all_event_family_capture")
        ),
        "median_bulk_family_capture": med(("captures", "bulk_family_capture")),
        "median_all_event_headroom_capture": med(
            ("captures", "all_event_headroom_capture")
        ),
        "median_bulk_headroom_capture": med(
            ("captures", "bulk_headroom_capture")
        ),
        "median_repeated_coverage": med(
            ("greedy", "repeated_given_covered_bulk")
        ),
        "median_triangle_participation": med(
            ("greedy", "triangle_participation")
        ),
        "median_edge_density": med(("greedy", "edge_density")),
        "median_maximum_multiplicity": med(
            ("greedy", "maximum_multiplicity")
        ),
    }


def development_decision(records: list[dict[str, object]]) -> dict[str, object]:
    """Choose the smallest cap or classify the development stop honestly."""

    summaries: dict[str, object] = {}
    qualifying: list[int] = []
    cap_fail_driven: dict[int, bool] = {}
    for cap in FROZEN_CAPS:
        cells: dict[str, object] = {}
        cap_qualifies = True
        has_fail_driven_disqualification = False
        has_inadmissible_driven_disqualification = False
        for events in FROZEN_DENSITIES:
            for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
                rows = _cell_rows(records, events, beta, cap)
                summary = summarize_cell(rows)
                counts = summary["outcomes"]
                qualifies = counts["PASS"] >= 2
                summary["qualifies"] = qualifies
                cells[f"{events}:{beta}"] = summary
                if not qualifies:
                    cap_qualifies = False
                    if counts["FAIL"] >= 2:
                        has_fail_driven_disqualification = True
                    else:
                        has_inadmissible_driven_disqualification = True
        summaries[str(cap)] = {
            "qualifies": cap_qualifies,
            "cells": cells,
        }
        if cap_qualifies:
            qualifying.append(cap)
        cap_fail_driven[cap] = bool(
            has_fail_driven_disqualification
            and not has_inadmissible_driven_disqualification
        )
    if qualifying:
        return {
            "outcome": "CAP_SELECTED",
            "chosen_cap": min(qualifying),
            "cap_summaries": summaries,
        }
    if all(cap_fail_driven.values()):
        outcome = "FAIL"
    else:
        outcome = "INADMISSIBLE"
    return {
        "outcome": outcome,
        "chosen_cap": None,
        "cap_summaries": summaries,
    }


def heldout_decision(
    records: list[dict[str, object]],
    cap: int,
) -> dict[str, object]:
    """Apply four-of-five cells and cross-density drift gates."""

    summaries: dict[str, object] = {}
    failed_cells: list[dict[str, object]] = []
    for events in FROZEN_DENSITIES:
        for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
            rows = _cell_rows(records, events, beta, cap)
            summary = summarize_cell(rows)
            counts = summary["outcomes"]
            passes = counts["PASS"] >= 4
            summary["passes"] = passes
            summaries[f"{events}:{beta}"] = summary
            if not passes:
                failed_cells.append(summary)
    if failed_cells:
        outcome = (
            "FAIL"
            if all(cell["outcomes"]["FAIL"] >= 2 for cell in failed_cells)
            else "INADMISSIBLE"
        )
        return {
            "outcome": outcome,
            "stage_passes": False,
            "cell_summaries": summaries,
            "drifts": {},
        }

    metric_names = (
        "median_all_event_family_capture",
        "median_bulk_family_capture",
        "median_all_event_headroom_capture",
        "median_bulk_headroom_capture",
        "median_repeated_coverage",
        "median_triangle_participation",
    )
    drifts: dict[str, object] = {}
    drift_passes = True
    low, high = FROZEN_DENSITIES
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        metrics: dict[str, float | None] = {}
        for name in metric_names:
            low_value = summaries[f"{low}:{beta}"][name]
            high_value = summaries[f"{high}:{beta}"][name]
            drift = (
                abs(float(high_value) - float(low_value))
                if low_value is not None and high_value is not None
                else None
            )
            metrics[name] = drift
            drift_passes &= drift is not None and drift <= MAXIMUM_REFINEMENT_DRIFT
        drifts[str(beta)] = metrics
    return {
        "outcome": "PASS" if drift_passes else "FAIL",
        "stage_passes": bool(drift_passes),
        "cell_summaries": summaries,
        "drifts": drifts,
    }


def run_phase(
    seed: int,
    realizations: int,
    caps: tuple[int, ...],
) -> list[dict[str, object]]:
    """Run one frozen phase after the output-set reservation exists."""

    states = spawn_phase_seed_states(
        seed, FROZEN_DENSITIES, realizations, caps
    )
    records: list[dict[str, object]] = []
    index = 0
    for events in FROZEN_DENSITIES:
        for realization in range(realizations):
            records.append(
                evaluate_realization(
                    events, realization, states[index], caps
                )
            )
            index += 1
    return records


def frozen_protocol() -> dict[str, object]:
    """Machine-readable copy of every approved R4 design constant."""

    return {
        "development_seed": DEVELOPMENT_SEED,
        "heldout_seed": HELDOUT_SEED,
        "densities": FROZEN_DENSITIES,
        "buffer_radius_multipliers": FROZEN_BUFFER_RADIUS_MULTIPLIERS,
        "development_realizations": DEVELOPMENT_REALIZATIONS,
        "heldout_realizations": HELDOUT_REALIZATIONS,
        "capacity_candidates": FROZEN_CAPS,
        "random_control_draws": RANDOM_CONTROL_DRAWS,
        "atlas_size_rule": "ceil(2*N^(1/4))",
        "atlas_sizes": {
            str(events): atlas_size(events) for events in FROZEN_DENSITIES
        },
        "duration": FROZEN_DURATION,
        "outer_band": FROZEN_OUTER_BAND,
        "maximum_complete_candidates": MAXIMUM_COMPLETE_CANDIDATES,
        "maximum_dense_relation_entries": MAXIMUM_DENSE_RELATION_ENTRIES,
        "maximum_peak_working_set_bytes": MAXIMUM_PEAK_WORKING_SET_BYTES,
        "maximum_realization_seconds": MAXIMUM_REALIZATION_SECONDS,
        "minimum_headroom": MINIMUM_HEADROOM,
        "minimum_bulk_coverage": MINIMUM_BULK_COVERAGE,
        "minimum_family_capture": MINIMUM_FAMILY_CAPTURE,
        "minimum_headroom_capture": MINIMUM_HEADROOM_CAPTURE,
        "minimum_repeated_coverage": MINIMUM_REPEATED_COVERAGE,
        "maximum_edge_density": MAXIMUM_EDGE_DENSITY,
        "minimum_triangle_participation": MINIMUM_TRIANGLE_PARTICIPATION,
        "maximum_refinement_drift": MAXIMUM_REFINEMENT_DRIFT,
    }


def run_chained_benchmark() -> tuple[dict[str, object], dict[str, object]]:
    """Run development, then held-out automatically if a cap qualifies."""

    development_records = run_phase(
        DEVELOPMENT_SEED, DEVELOPMENT_REALIZATIONS, FROZEN_CAPS
    )
    decision = development_decision(development_records)
    development = {
        "stage": "A3f-R4-development",
        "claim_boundary": (
            "finite protected-core atlas/nerve selection only; G2 and all "
            "downstream geometry remain closed"
        ),
        "protocol": frozen_protocol(),
        "records": development_records,
        "decision": decision,
    }
    chosen = decision["chosen_cap"]
    if chosen is None:
        heldout = {
            "stage": "A3f-R4-heldout",
            "status": "retired_unconsumed",
            "heldout_seed": HELDOUT_SEED,
            "reason": "development did not select a cap",
            "development_outcome": decision["outcome"],
            "stage_passes": False,
        }
        return development, heldout
    heldout_records = run_phase(
        HELDOUT_SEED, HELDOUT_REALIZATIONS, (int(chosen),)
    )
    heldout = {
        "stage": "A3f-R4-heldout",
        "status": "completed",
        "protocol": frozen_protocol(),
        "chosen_cap": chosen,
        "records": heldout_records,
        "decision": heldout_decision(heldout_records, int(chosen)),
    }
    return development, heldout


def _without_fields(value: object, omitted: frozenset[str]) -> object:
    if isinstance(value, dict):
        return {
            key: _without_fields(item, omitted)
            for key, item in value.items()
            if key not in omitted
        }
    if isinstance(value, list):
        return [_without_fields(item, omitted) for item in value]
    if isinstance(value, tuple):
        return [_without_fields(item, omitted) for item in value]
    return value


def content_sha256(payload: dict[str, object], *, deterministic: bool) -> str:
    """Hash scientific or runtime-and-peak-independent artifact content."""

    omitted = {"runtime_seconds"}
    if deterministic:
        omitted.add("phase_peak_working_set_bytes")
    canonical = json.dumps(
        _without_fields(payload, frozenset(omitted)),
        sort_keys=True,
        separators=(",", ":"),
    ).encode("utf-8")
    return hashlib.sha256(canonical).hexdigest()


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _verify_hash(path: Path, expected: str, label: str) -> str:
    actual = file_sha256(path)
    if actual.lower() != expected.lower():
        raise ValueError(f"{label} hash mismatch: expected {expected}, got {actual}")
    return actual


def _write_json(path: Path, payload: dict[str, object]) -> None:
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--development-output", type=Path, required=True)
    parser.add_argument("--heldout-output", type=Path, required=True)
    parser.add_argument("--sentinel", type=Path, required=True)
    parser.add_argument("--plan", type=Path, required=True)
    parser.add_argument("--tests", type=Path, required=True)
    parser.add_argument("--expected-plan-sha256", required=True)
    parser.add_argument("--expected-implementation-sha256", required=True)
    parser.add_argument("--expected-tests-sha256", required=True)
    args = parser.parse_args()

    implementation = Path(__file__).resolve()
    hashes = {
        "plan_sha256": _verify_hash(
            args.plan, args.expected_plan_sha256, "plan"
        ),
        "implementation_sha256": _verify_hash(
            implementation,
            args.expected_implementation_sha256,
            "implementation",
        ),
        "tests_sha256": _verify_hash(
            args.tests, args.expected_tests_sha256, "tests"
        ),
    }
    metadata = {
        "work_item": "GRAV-GROWING-ATLAS-001",
        "protocol_sha256": hashes["plan_sha256"],
        "seed": {
            "development": DEVELOPMENT_SEED,
            "heldout": HELDOUT_SEED,
        },
        **hashes,
        "protocol": frozen_protocol(),
    }
    outputs = (args.development_output, args.heldout_output)
    with frozen_run_set_reservation(outputs, args.sentinel, metadata):
        development, heldout = run_chained_benchmark()
        _write_json(args.development_output, development)
        _write_json(args.heldout_output, heldout)

    report = {
        "development_decision": development["decision"],
        "heldout_decision": heldout.get("decision", heldout),
        "artifact_hashes": {
            str(path): {
                "raw_sha256": file_sha256(path),
                "scientific_content_sha256": content_sha256(
                    payload, deterministic=False
                ),
                "deterministic_content_sha256": content_sha256(
                    payload, deterministic=True
                ),
            }
            for path, payload in zip(outputs, (development, heldout), strict=True)
        },
    }
    print(json.dumps(report, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
