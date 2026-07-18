"""Fresh smaller-core growing-atlas benchmark for Stage A3f-R5.

R5 reuses the reviewed R4 selector, controls, metrics, gates, taxonomy, and
resource ceilings.  Beta 1.25 is the sole result-bearing rung.  Beta 1.00 is
recomputed on each same fresh sprinkling as a diagnostic negative control and
is excluded from every development, held-out, drift, pass, fail, and kill
decision.

Complete-family intersection, hub, and core-size facts are computed before any
selector on both rungs.  This is a finite atlas/nerve experiment on flat
manifold-generated controls, not a metric, tetrad, curvature, or GR result.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import time
from dataclasses import asdict
from pathlib import Path
from typing import Callable

import numpy as np
import psutil
from scipy import sparse

import causal_growing_atlas as r4
from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_atlas_coverage import (
    FROZEN_OUTER_BAND,
    complete_outer_candidates,
    independent_order_bulk,
)
from causal_atlas_packing import (
    complete_candidate_cores,
    greedy_maximum_coverage,
)
from causal_atlas_scaling import process_peak_working_set_bytes
from causal_buffered_core_feasibility import schedule_at_density
from causal_growing_atlas_diagnostic import beta_key, summarize_complete_family
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_operator_metric import sprinkle_minkowski_diamond
from frozen_run_guard import frozen_run_set_reservation


DEVELOPMENT_SEED = 2026071612
HELDOUT_SEED = 2026071613
PRIMARY_BETA = 1.25
DIAGNOSTIC_BETA = 1.00
FROZEN_BUFFER_RADIUS_MULTIPLIERS = (PRIMARY_BETA, DIAGNOSTIC_BETA)

FROZEN_DENSITIES = r4.FROZEN_DENSITIES
DEVELOPMENT_REALIZATIONS = r4.DEVELOPMENT_REALIZATIONS
HELDOUT_REALIZATIONS = r4.HELDOUT_REALIZATIONS
FROZEN_CAPS = r4.FROZEN_CAPS
RANDOM_CONTROL_DRAWS = r4.RANDOM_CONTROL_DRAWS
FROZEN_DURATION = r4.FROZEN_DURATION
MAXIMUM_COMPLETE_CANDIDATES = r4.MAXIMUM_COMPLETE_CANDIDATES
MAXIMUM_DENSE_RELATION_ENTRIES = r4.MAXIMUM_DENSE_RELATION_ENTRIES
MAXIMUM_PEAK_WORKING_SET_BYTES = r4.MAXIMUM_PEAK_WORKING_SET_BYTES
MAXIMUM_REALIZATION_SECONDS = r4.MAXIMUM_REALIZATION_SECONDS
MAXIMUM_REFINEMENT_DRIFT = r4.MAXIMUM_REFINEMENT_DRIFT


def atlas_size(events: int) -> int:
    """The unchanged R4 growing-cardinality schedule."""

    return r4.atlas_size(events)


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
    """Create disjoint streams for both frozen R5 rungs and all controls."""

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
            rungs[beta_key(beta)] = {
                "unconstrained_greedy": unconstrained,
                "caps": cap_states,
            }
        if cursor != role_count:
            raise RuntimeError("seed role accounting mismatch")
        records.append({"sprinkling": sprinkling, "rungs": rungs})
    return tuple(records)


def selector_reaches_target(cell: dict[str, object]) -> bool:
    """Whether constrained greedy reaches K_N while respecting its cap."""

    metrics = cell["greedy"]
    selected = metrics["selected_candidates"]
    return bool(
        len(selected) == int(cell["atlas_size"])
        and int(metrics["maximum_multiplicity"]) <= int(cell["cap"])
    )


def mechanism_label(
    family: dict[str, object],
    reaches_target: bool,
) -> str | None:
    """Apply the preregistered family/selector mechanism labels."""

    intersection = family["global_intersection_nonempty"]
    if intersection is True:
        return "certificate_dead"
    if intersection is False:
        return (
            "empty_intersection_greedy_reaches_target"
            if reaches_target
            else "empty_intersection_greedy_trapped"
        )
    return None


def diagnostic_capacity_cell(
    raw_cell: dict[str, object],
    family: dict[str, object],
) -> dict[str, object]:
    """Remove all result-bearing assignments from one beta-1.00 cell."""

    reaches = selector_reaches_target(raw_cell)
    controls_reach = tuple(
        len(control["selected_candidates"]) == int(raw_cell["atlas_size"])
        and int(control["maximum_multiplicity"]) <= int(raw_cell["cap"])
        for control in raw_cell["random_feasible_controls"]
    )
    archived = {
        key: value
        for key, value in raw_cell.items()
        if key not in {"outcome", "inadmissible_reasons", "gates"}
    }
    archived.update(
        {
            "decision_role": "diagnostic_negative_control",
            "selector_reaches_target": reaches,
            "random_controls_reach_target": controls_reach,
            "unexpected_nonhostile_control": reaches,
            "mechanism_label": mechanism_label(family, reaches),
            "diagnostic_runtime_notes": raw_cell["inadmissible_reasons"],
            "archived_primary_threshold_comparisons": raw_cell["gates"],
        }
    )
    return archived


def primary_capacity_cell(
    raw_cell: dict[str, object],
    family: dict[str, object],
) -> dict[str, object]:
    """Attach the descriptive family mechanism to one primary cell."""

    raw_cell["decision_role"] = "result_bearing_primary"
    raw_cell["selector_reaches_target"] = selector_reaches_target(raw_cell)
    raw_cell["mechanism_label"] = mechanism_label(
        family, bool(raw_cell["selector_reaches_target"])
    )
    return raw_cell


def diagnostic_resource_failure_cells(
    caps: tuple[int, ...],
    size: int,
    reason: str,
) -> list[dict[str, object]]:
    """Archive diagnostic resource failure without assigning an outcome."""

    return [
        {
            "cap": cap,
            "atlas_size": size,
            "decision_role": "diagnostic_negative_control",
            "selector_reaches_target": False,
            "random_controls_reach_target": (),
            "unexpected_nonhostile_control": False,
            "mechanism_label": None,
            "diagnostic_runtime_notes": [reason],
            "tripwires": {},
        }
        for cap in caps
    ]


def evaluate_rung(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    candidates: np.ndarray,
    carriers: np.ndarray,
    schedule: object,
    beta: float,
    size: int,
    caps: tuple[int, ...],
    rung_states: dict[str, object],
) -> dict[str, object]:
    """Compute family facts first, then selectors, for one frozen rung."""

    if beta not in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        raise ValueError("beta is not a frozen R5 rung")
    buffer_count = beta**4 * schedule.buffer_count
    bulk = independent_order_bulk(relation, buffer_count)
    _, cores = complete_candidate_cores(
        relation,
        inclusive_counts,
        candidates,
        buffer_count,
        carriers,
    )
    family = summarize_complete_family(cores)
    family.update(
        {
            "beta": beta_key(beta),
            "buffer_count": buffer_count,
            "bulk_count": int(np.count_nonzero(bulk)),
        }
    )

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
        raw = r4.evaluate_capacity_cell(
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
        cells.append(
            primary_capacity_cell(raw, family)
            if beta == PRIMARY_BETA
            else diagnostic_capacity_cell(raw, family)
        )
    return {
        "buffer_radius_multiplier": beta,
        "decision_role": (
            "result_bearing_primary"
            if beta == PRIMARY_BETA
            else "diagnostic_negative_control"
        ),
        "buffer_count": buffer_count,
        "bulk_count": int(np.count_nonzero(bulk)),
        "family_diagnostic_preselection": family,
        "unconstrained_greedy": r4.extended_atlas_metrics(
            candidates, cores, unconstrained, bulk
        ),
        "unconstrained_greedy_steps": [
            asdict(step) for step in unconstrained_steps
        ],
        "cells": cells,
    }


def _resource_failure_rungs(
    caps: tuple[int, ...],
    size: int,
    reason: str,
) -> list[dict[str, object]]:
    rungs: list[dict[str, object]] = []
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        primary = beta == PRIMARY_BETA
        rungs.append(
            {
                "buffer_radius_multiplier": beta,
                "decision_role": (
                    "result_bearing_primary"
                    if primary
                    else "diagnostic_negative_control"
                ),
                "family_diagnostic_preselection": {
                    "status": "not_computed_resource_failure",
                    "reason": reason,
                },
                "cells": (
                    r4.resource_failure_cells(caps, reason)
                    if primary
                    else diagnostic_resource_failure_cells(caps, size, reason)
                ),
            }
        )
    return rungs


def _overwrite_resource_outcomes(
    rungs: list[dict[str, object]],
    reason: str,
) -> None:
    for rung in rungs:
        primary = rung["decision_role"] == "result_bearing_primary"
        for cell in rung["cells"]:
            if primary:
                cell["outcome"] = "INADMISSIBLE"
                cell["inadmissible_reasons"] = [reason]
            else:
                cell["diagnostic_runtime_notes"] = [reason]


def evaluate_realization(
    events: int,
    realization: int,
    seed_record: dict[str, object],
    caps: tuple[int, ...],
    *,
    clock: Callable[[], float] = time.perf_counter,
    process: psutil.Process | None = None,
) -> dict[str, object]:
    """Evaluate both rungs on one shared fresh sprinkling."""

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
    if len(candidates) > MAXIMUM_COMPLETE_CANDIDATES:
        reason = "complete candidate family exceeds ceiling"
        return {
            "events": events,
            "realization": realization,
            "seed_states": seed_record,
            "schedule": asdict(schedule),
            "atlas_size": size,
            "complete_candidate_count": len(candidates),
            "phase_peak_working_set_bytes": peak,
            "runtime_seconds": clock() - started,
            "resource_failure": reason,
            "rungs": _resource_failure_rungs(caps, size, reason),
        }
    if peak > MAXIMUM_PEAK_WORKING_SET_BYTES:
        reason = "peak working set exceeds ceiling"
        return {
            "events": events,
            "realization": realization,
            "seed_states": seed_record,
            "schedule": asdict(schedule),
            "atlas_size": size,
            "complete_candidate_count": len(candidates),
            "phase_peak_working_set_bytes": peak,
            "runtime_seconds": clock() - started,
            "resource_failure": reason,
            "rungs": _resource_failure_rungs(caps, size, reason),
        }

    carriers = r4.materialize_candidate_carriers(relation, candidates)
    rungs: list[dict[str, object]] = []
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        rung_states = seed_record["rungs"][beta_key(beta)]
        rungs.append(
            evaluate_rung(
                relation,
                inclusive_counts,
                candidates,
                carriers,
                schedule,
                beta,
                size,
                caps,
                rung_states,
            )
        )
        peak = max(peak, process_peak_working_set_bytes(active_process))

    elapsed = clock() - started
    if elapsed > MAXIMUM_REALIZATION_SECONDS:
        _overwrite_resource_outcomes(
            rungs, "per-sprinkling wall time exceeds ceiling"
        )
    if peak > MAXIMUM_PEAK_WORKING_SET_BYTES:
        _overwrite_resource_outcomes(rungs, "peak working set exceeds ceiling")
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
    cap: int,
) -> list[dict[str, object]]:
    """Return only primary-rung cells for result-bearing decisions."""

    rows: list[dict[str, object]] = []
    for record in records:
        if int(record["events"]) != events:
            continue
        rung = next(
            item
            for item in record["rungs"]
            if float(item["buffer_radius_multiplier"]) == PRIMARY_BETA
        )
        if rung["decision_role"] != "result_bearing_primary":
            raise RuntimeError("primary rung has the wrong decision role")
        rows.append(next(cell for cell in rung["cells"] if int(cell["cap"]) == cap))
    return rows


def development_decision(records: list[dict[str, object]]) -> dict[str, object]:
    """Select a cap from beta 1.25 only; beta 1.00 cannot enter."""

    summaries: dict[str, object] = {}
    qualifying: list[int] = []
    cap_fail_driven: dict[int, bool] = {}
    for cap in FROZEN_CAPS:
        cells: dict[str, object] = {}
        cap_qualifies = True
        has_fail = False
        has_inadmissible = False
        for events in FROZEN_DENSITIES:
            rows = _cell_rows(records, events, cap)
            summary = r4.summarize_cell(rows)
            counts = summary["outcomes"]
            qualifies = counts["PASS"] >= 2
            summary["qualifies"] = qualifies
            cells[str(events)] = summary
            if not qualifies:
                cap_qualifies = False
                if counts["FAIL"] >= 2:
                    has_fail = True
                else:
                    has_inadmissible = True
        summaries[str(cap)] = {"qualifies": cap_qualifies, "cells": cells}
        if cap_qualifies:
            qualifying.append(cap)
        cap_fail_driven[cap] = bool(has_fail and not has_inadmissible)
    if qualifying:
        return {
            "outcome": "CAP_SELECTED",
            "chosen_cap": min(qualifying),
            "primary_beta": PRIMARY_BETA,
            "diagnostic_beta_excluded": DIAGNOSTIC_BETA,
            "cap_summaries": summaries,
        }
    return {
        "outcome": "FAIL" if all(cap_fail_driven.values()) else "INADMISSIBLE",
        "chosen_cap": None,
        "primary_beta": PRIMARY_BETA,
        "diagnostic_beta_excluded": DIAGNOSTIC_BETA,
        "cap_summaries": summaries,
    }


def heldout_decision(
    records: list[dict[str, object]],
    cap: int,
) -> dict[str, object]:
    """Apply four-of-five and drift to beta 1.25 only."""

    summaries: dict[str, object] = {}
    failed: list[dict[str, object]] = []
    for events in FROZEN_DENSITIES:
        rows = _cell_rows(records, events, cap)
        summary = r4.summarize_cell(rows)
        counts = summary["outcomes"]
        passes = counts["PASS"] >= 4
        summary["passes"] = passes
        summaries[str(events)] = summary
        if not passes:
            failed.append(summary)
    if failed:
        outcome = (
            "FAIL"
            if all(cell["outcomes"]["FAIL"] >= 2 for cell in failed)
            else "INADMISSIBLE"
        )
        return {
            "outcome": outcome,
            "stage_passes": False,
            "primary_beta": PRIMARY_BETA,
            "diagnostic_beta_excluded": DIAGNOSTIC_BETA,
            "cell_summaries": summaries,
            "drifts": {},
        }

    names = (
        "median_all_event_family_capture",
        "median_bulk_family_capture",
        "median_all_event_headroom_capture",
        "median_bulk_headroom_capture",
        "median_repeated_coverage",
        "median_triangle_participation",
    )
    low, high = FROZEN_DENSITIES
    drifts: dict[str, float | None] = {}
    drift_passes = True
    for name in names:
        low_value = summaries[str(low)][name]
        high_value = summaries[str(high)][name]
        drift = (
            abs(float(high_value) - float(low_value))
            if low_value is not None and high_value is not None
            else None
        )
        drifts[name] = drift
        drift_passes &= drift is not None and drift <= MAXIMUM_REFINEMENT_DRIFT
    return {
        "outcome": "PASS" if drift_passes else "FAIL",
        "stage_passes": bool(drift_passes),
        "primary_beta": PRIMARY_BETA,
        "diagnostic_beta_excluded": DIAGNOSTIC_BETA,
        "cell_summaries": summaries,
        "drifts": drifts,
    }


def run_phase(
    seed: int,
    realizations: int,
    caps: tuple[int, ...],
) -> list[dict[str, object]]:
    """Run one phase after the complete output set is reserved."""

    states = spawn_phase_seed_states(seed, FROZEN_DENSITIES, realizations, caps)
    records: list[dict[str, object]] = []
    index = 0
    for events in FROZEN_DENSITIES:
        for realization in range(realizations):
            records.append(evaluate_realization(events, realization, states[index], caps))
            index += 1
    return records


def frozen_protocol() -> dict[str, object]:
    """Machine-readable copy of the reviewed R5 protocol."""

    return {
        "stage": "A3f-R5",
        "development_seed": DEVELOPMENT_SEED,
        "heldout_seed": HELDOUT_SEED,
        "densities": FROZEN_DENSITIES,
        "development_realizations": DEVELOPMENT_REALIZATIONS,
        "heldout_realizations": HELDOUT_REALIZATIONS,
        "primary_beta": PRIMARY_BETA,
        "diagnostic_negative_control_beta": DIAGNOSTIC_BETA,
        "diagnostic_excluded_from_all_decisions": True,
        "unexpected_nonhostile_control_gate_effect": False,
        "family_diagnostics_before_selection": True,
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
        "minimum_headroom": r4.MINIMUM_HEADROOM,
        "minimum_bulk_coverage": r4.MINIMUM_BULK_COVERAGE,
        "minimum_family_capture": r4.MINIMUM_FAMILY_CAPTURE,
        "minimum_headroom_capture": r4.MINIMUM_HEADROOM_CAPTURE,
        "minimum_repeated_coverage": r4.MINIMUM_REPEATED_COVERAGE,
        "maximum_edge_density": r4.MAXIMUM_EDGE_DENSITY,
        "minimum_triangle_participation": r4.MINIMUM_TRIANGLE_PARTICIPATION,
        "maximum_refinement_drift": MAXIMUM_REFINEMENT_DRIFT,
        "completed_result_byte_policy": "immutable",
    }


def run_chained_benchmark() -> tuple[dict[str, object], dict[str, object]]:
    """Run development and conditionally continue to held-out."""

    development_records = run_phase(
        DEVELOPMENT_SEED, DEVELOPMENT_REALIZATIONS, FROZEN_CAPS
    )
    decision = development_decision(development_records)
    development = {
        "stage": "A3f-R5-development",
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
        return development, {
            "stage": "A3f-R5-heldout",
            "status": "retired_unconsumed",
            "heldout_seed": HELDOUT_SEED,
            "reason": "development did not select a cap",
            "development_outcome": decision["outcome"],
            "stage_passes": False,
        }
    heldout_records = run_phase(
        HELDOUT_SEED, HELDOUT_REALIZATIONS, (int(chosen),)
    )
    return development, {
        "stage": "A3f-R5-heldout",
        "status": "completed",
        "protocol": frozen_protocol(),
        "chosen_cap": chosen,
        "records": heldout_records,
        "decision": heldout_decision(heldout_records, int(chosen)),
    }


def content_sha256(payload: dict[str, object], *, deterministic: bool) -> str:
    return r4.content_sha256(payload, deterministic=deterministic)


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_hash(path: Path, expected: str, label: str) -> str:
    actual = file_sha256(path)
    if actual.lower() != expected.lower():
        raise ValueError(f"{label} hash mismatch: expected {expected}, got {actual}")
    return actual


def write_json(path: Path, payload: dict[str, object]) -> None:
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )


def execute_reserved_benchmark(
    development_output: Path,
    heldout_output: Path,
    sentinel: Path,
    metadata: dict[str, object],
    runner: Callable[
        [], tuple[dict[str, object], dict[str, object]]
    ] = run_chained_benchmark,
) -> tuple[dict[str, object], dict[str, object]]:
    """Reserve sentinel and both outputs before any seed spawning or RNG use."""

    with frozen_run_set_reservation(
        (development_output, heldout_output), sentinel, metadata
    ):
        development, heldout = runner()
        write_json(development_output, development)
        write_json(heldout_output, heldout)
    return development, heldout


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--development-output", type=Path, required=True)
    parser.add_argument("--heldout-output", type=Path, required=True)
    parser.add_argument("--sentinel", type=Path, required=True)
    parser.add_argument("--plan", type=Path, required=True)
    parser.add_argument("--tests", type=Path, required=True)
    parser.add_argument("--r4-source", type=Path, required=True)
    parser.add_argument("--r4d-source", type=Path, required=True)
    parser.add_argument("--guard", type=Path, required=True)
    parser.add_argument("--theorem-module", type=Path, required=True)
    parser.add_argument("--expected-plan-sha256", required=True)
    parser.add_argument("--expected-implementation-sha256", required=True)
    parser.add_argument("--expected-tests-sha256", required=True)
    parser.add_argument("--expected-r4-source-sha256", required=True)
    parser.add_argument("--expected-r4d-source-sha256", required=True)
    parser.add_argument("--expected-guard-sha256", required=True)
    parser.add_argument("--expected-theorem-module-sha256", required=True)
    args = parser.parse_args()

    implementation = Path(__file__).resolve()
    hashes = {
        "plan_sha256": verify_hash(args.plan, args.expected_plan_sha256, "plan"),
        "implementation_sha256": verify_hash(
            implementation,
            args.expected_implementation_sha256,
            "implementation",
        ),
        "tests_sha256": verify_hash(
            args.tests, args.expected_tests_sha256, "tests"
        ),
        "imported_r4_source_sha256": verify_hash(
            args.r4_source, args.expected_r4_source_sha256, "R4 source"
        ),
        "imported_r4d_source_sha256": verify_hash(
            args.r4d_source, args.expected_r4d_source_sha256, "R4-D source"
        ),
        "guard_sha256": verify_hash(
            args.guard, args.expected_guard_sha256, "reservation guard"
        ),
        "theorem_module_sha256": verify_hash(
            args.theorem_module,
            args.expected_theorem_module_sha256,
            "theorem module",
        ),
    }
    metadata = {
        "work_item": "GRAV-GROWING-ATLAS-001",
        "protocol_sha256": hashes["plan_sha256"],
        "seed": {
            "development": DEVELOPMENT_SEED,
            "heldout": HELDOUT_SEED,
        },
        "protocol": frozen_protocol(),
        **hashes,
    }
    development, heldout = execute_reserved_benchmark(
        args.development_output,
        args.heldout_output,
        args.sentinel,
        metadata,
    )
    outputs = (args.development_output, args.heldout_output)
    payloads = (development, heldout)
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
            for path, payload in zip(outputs, payloads, strict=True)
        },
    }
    print(json.dumps(report, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
