"""Deterministic family-level diagnostic for the consumed A3f-R4 sprinklings.

R4-D replays the six consumed development sprinklings and archives complete
candidate-family intersection, hub, and chart-scale facts. It runs no atlas
selector, comparator, gate, or outcome classification and is not an
independent statistical trial. The held-out seed remains retired.

This diagnostic does not construct a metric, tetrad, connection, curvature,
or general-relativity limit.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import statistics
import time
from dataclasses import asdict
from pathlib import Path
from typing import Callable, Mapping

import numpy as np
import psutil

from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_atlas_coverage import (
    FROZEN_OUTER_BAND,
    complete_outer_candidates,
    independent_order_bulk,
)
from causal_atlas_packing import complete_candidate_cores
from causal_atlas_scaling import process_peak_working_set_bytes
from causal_buffered_core_feasibility import schedule_at_density
from causal_growing_atlas import (
    DEVELOPMENT_REALIZATIONS,
    DEVELOPMENT_SEED,
    FROZEN_CAPS,
    FROZEN_DENSITIES,
    FROZEN_DURATION,
    MAXIMUM_COMPLETE_CANDIDATES,
    MAXIMUM_DENSE_RELATION_ENTRIES,
    MAXIMUM_PEAK_WORKING_SET_BYTES,
    MAXIMUM_REALIZATION_SECONDS,
    content_sha256,
    materialize_candidate_carriers,
    spawn_phase_seed_states,
)
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_operator_metric import sprinkle_minkowski_diamond
from frozen_run_guard import frozen_run_set_reservation


DIAGNOSTIC_BETAS = (0.8, 1.0, 1.25)
CONSUMED_BETAS = (0.8, 1.0)
HELDOUT_SEED_RETIRED = 2026071611

EXPECTED_REPLAY: dict[tuple[int, int], dict[str, object]] = {
    (6000, 0): {
        "candidate_count": 198,
        "bulk_counts": {"0.80": 4230, "1.00": 3272},
    },
    (6000, 1): {
        "candidate_count": 234,
        "bulk_counts": {"0.80": 4324, "1.00": 3381},
    },
    (6000, 2): {
        "candidate_count": 193,
        "bulk_counts": {"0.80": 4147, "1.00": 3279},
    },
    (12000, 0): {
        "candidate_count": 1318,
        "bulk_counts": {"0.80": 8688, "1.00": 7207},
    },
    (12000, 1): {
        "candidate_count": 1271,
        "bulk_counts": {"0.80": 8761, "1.00": 7307},
    },
    (12000, 2): {
        "candidate_count": 1504,
        "bulk_counts": {"0.80": 8816, "1.00": 7283},
    },
}


def beta_key(beta: float) -> str:
    """Stable key for a diagnostic buffer rung."""

    return f"{beta:.2f}"


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_hash(path: Path, expected: str, label: str) -> str:
    actual = file_sha256(path)
    if actual.lower() != expected.lower():
        raise ValueError(
            f"{label} hash mismatch: expected {expected}, got {actual}"
        )
    return actual


def diagnostic_sprinkling_states() -> tuple[tuple[int, ...], ...]:
    """Extract only the consumed sprinkling streams from the frozen R4 tree."""

    records = spawn_phase_seed_states(
        DEVELOPMENT_SEED,
        FROZEN_DENSITIES,
        DEVELOPMENT_REALIZATIONS,
        FROZEN_CAPS,
    )
    return tuple(tuple(record["sprinkling"]) for record in records)


def summarize_complete_family(cores: np.ndarray) -> dict[str, object]:
    """Compute D1-D3 on all diamond events, including the top endpoint."""

    if cores.ndim != 2:
        raise ValueError("cores must be a two-dimensional Boolean matrix")
    candidate_count, diamond_event_count = cores.shape
    if diamond_event_count <= 0:
        raise ValueError("the diamond event set must be nonempty")
    if candidate_count == 0:
        return {
            "family_empty": True,
            "global_intersection_nonempty": None,
            "global_intersection_size": None,
            "maximum_event_multiplicity": None,
            "events_attaining_maximum_multiplicity": None,
            "diamond_event_count": diamond_event_count,
            "complete_candidate_count": 0,
            "core_size": {
                "minimum": None,
                "median": None,
                "maximum": None,
            },
            "core_size_fraction": {
                "minimum": None,
                "median": None,
                "maximum": None,
            },
            "complete_family_certificate_dead": None,
        }

    intersection = np.all(cores, axis=0)
    multiplicity = np.count_nonzero(cores, axis=0)
    maximum_multiplicity = int(np.max(multiplicity))
    sizes = sorted(int(value) for value in np.count_nonzero(cores, axis=1))
    minimum = sizes[0]
    median = float(statistics.median(sizes))
    maximum = sizes[-1]
    global_nonempty = bool(np.any(intersection))
    return {
        "family_empty": False,
        "global_intersection_nonempty": global_nonempty,
        "global_intersection_size": int(np.count_nonzero(intersection)),
        "maximum_event_multiplicity": maximum_multiplicity,
        "events_attaining_maximum_multiplicity": int(
            np.count_nonzero(multiplicity == maximum_multiplicity)
        ),
        "diamond_event_count": diamond_event_count,
        "complete_candidate_count": candidate_count,
        "core_size": {
            "minimum": minimum,
            "median": median,
            "maximum": maximum,
        },
        "core_size_fraction": {
            "minimum": float(minimum / diamond_event_count),
            "median": float(median / diamond_event_count),
            "maximum": float(maximum / diamond_event_count),
        },
        "complete_family_certificate_dead": global_nonempty,
    }


def interpretation_label(rungs: list[dict[str, object]]) -> str:
    """Apply the diagnostic-only interpretation table without aggregation."""

    by_beta = {str(rung["beta"]): rung for rung in rungs}
    consumed = [
        by_beta[beta_key(beta)]["global_intersection_nonempty"]
        for beta in CONSUMED_BETAS
    ]
    smaller = by_beta[beta_key(1.25)]
    smaller_intersection = smaller["global_intersection_nonempty"]
    smaller_minimum = smaller["core_size"]["minimum"]

    if all(value is True for value in consumed):
        if smaller_intersection is True:
            return "complete_family_obstruction_all_tested_rungs"
        if (
            smaller_intersection is False
            and smaller_minimum is not None
            and int(smaller_minimum) > 0
        ):
            return "chart_scale_breaks_common_intersection"
        if smaller_intersection is False:
            return "smaller_rung_core_vanishing_or_mixed"
    if all(value is False for value in consumed):
        return "consumed_rungs_no_global_intersection"
    return "mixed_rung_pattern"


def expected_replay(events: int, realization: int) -> dict[str, object]:
    try:
        return EXPECTED_REPLAY[(events, realization)]
    except KeyError as error:
        raise ValueError("unregistered R4 replay cell") from error


def assert_replay_equal(
    *,
    events: int,
    realization: int,
    beta: float,
    candidate_count: int,
    bulk_count: int,
) -> dict[str, object]:
    """Hard-fail on any consumed-rung replay mismatch."""

    expected = expected_replay(events, realization)
    expected_candidates = int(expected["candidate_count"])
    expected_bulk = int(expected["bulk_counts"][beta_key(beta)])
    if candidate_count != expected_candidates:
        raise RuntimeError(
            "R4 candidate-count replay mismatch: "
            f"N={events}, realization={realization}, "
            f"expected={expected_candidates}, actual={candidate_count}"
        )
    if bulk_count != expected_bulk:
        raise RuntimeError(
            "R4 bulk-count replay mismatch: "
            f"N={events}, realization={realization}, beta={beta_key(beta)}, "
            f"expected={expected_bulk}, actual={bulk_count}"
        )
    return {
        "events": events,
        "realization": realization,
        "beta": beta_key(beta),
        "candidate_count_expected": expected_candidates,
        "candidate_count_actual": candidate_count,
        "candidate_count_matches": True,
        "bulk_count_expected": expected_bulk,
        "bulk_count_actual": bulk_count,
        "bulk_count_matches": True,
    }


def evaluate_replayed_sprinkling(
    events: int,
    realization: int,
    sprinkling_state: tuple[int, ...],
    *,
    clock: Callable[[], float] = time.perf_counter,
    process: psutil.Process | None = None,
) -> dict[str, object]:
    """Reconstruct one consumed sprinkling and compute family-level facts."""

    started = clock()
    active_process = process or psutil.Process()
    if (events + 1) ** 2 > MAXIMUM_DENSE_RELATION_ENTRIES:
        raise RuntimeError("dense relation ceiling would be exceeded")

    rng = np.random.default_rng(np.asarray(sprinkling_state, dtype=np.uint32))
    points, _ = sprinkle_minkowski_diamond(rng, events, FROZEN_DURATION)
    relation = causal_relation_matrix(points)
    del points
    inclusive_counts = sparse_inclusive_interval_count_matrix(relation)
    schedule = schedule_at_density(float(events))
    candidates = complete_outer_candidates(
        inclusive_counts, schedule.outer_count, FROZEN_OUTER_BAND
    )
    if len(candidates) > MAXIMUM_COMPLETE_CANDIDATES:
        raise RuntimeError("complete candidate family exceeds R4 ceiling")
    expected_candidates = int(
        expected_replay(events, realization)["candidate_count"]
    )
    if len(candidates) != expected_candidates:
        raise RuntimeError(
            "R4 candidate-count replay mismatch: "
            f"N={events}, realization={realization}, "
            f"expected={expected_candidates}, actual={len(candidates)}"
        )

    carriers = materialize_candidate_carriers(relation, candidates)
    rungs: list[dict[str, object]] = []
    replay_assertions: list[dict[str, object]] = []
    peak = process_peak_working_set_bytes(active_process)
    for beta in DIAGNOSTIC_BETAS:
        buffer_count = beta**4 * schedule.buffer_count
        bulk = independent_order_bulk(relation, buffer_count)
        bulk_count = int(np.count_nonzero(bulk))
        _, cores = complete_candidate_cores(
            relation,
            inclusive_counts,
            candidates,
            buffer_count,
            carriers,
        )
        summary = summarize_complete_family(cores)
        summary.update(
            {
                "beta": beta_key(beta),
                "diagnostic_only_new_rung": beta == 1.25,
                "buffer_count": buffer_count,
                "bulk_count": bulk_count,
            }
        )
        rungs.append(summary)
        if beta in CONSUMED_BETAS:
            replay_assertions.append(
                assert_replay_equal(
                    events=events,
                    realization=realization,
                    beta=beta,
                    candidate_count=len(candidates),
                    bulk_count=bulk_count,
                )
            )
        peak = max(peak, process_peak_working_set_bytes(active_process))
        if peak > MAXIMUM_PEAK_WORKING_SET_BYTES:
            raise RuntimeError("peak working set exceeds R4 ceiling")

    elapsed = clock() - started
    if elapsed > MAXIMUM_REALIZATION_SECONDS:
        raise RuntimeError("per-sprinkling wall time exceeds R4 ceiling")
    return {
        "events": events,
        "realization": realization,
        "sprinkling_seed_state": sprinkling_state,
        "schedule": asdict(schedule),
        "candidate_ceiling": MAXIMUM_COMPLETE_CANDIDATES,
        "complete_candidate_count": len(candidates),
        "diamond_event_count": len(relation),
        "replay_assertions": replay_assertions,
        "rungs": rungs,
        "interpretation_label": interpretation_label(rungs),
        "runtime_seconds": elapsed,
        "phase_peak_working_set_bytes": peak,
    }


def frozen_protocol() -> dict[str, object]:
    return {
        "diagnostic_name": "A3f-R4-D",
        "consumed_development_seed": DEVELOPMENT_SEED,
        "heldout_seed": HELDOUT_SEED_RETIRED,
        "heldout_seed_status": "retired_unconsumed",
        "densities": FROZEN_DENSITIES,
        "realizations_per_density": DEVELOPMENT_REALIZATIONS,
        "duration": FROZEN_DURATION,
        "outer_band": FROZEN_OUTER_BAND,
        "diagnostic_betas": DIAGNOSTIC_BETAS,
        "consumed_betas": CONSUMED_BETAS,
        "candidate_ceiling": MAXIMUM_COMPLETE_CANDIDATES,
        "maximum_dense_relation_entries": MAXIMUM_DENSE_RELATION_ENTRIES,
        "maximum_peak_working_set_bytes": MAXIMUM_PEAK_WORKING_SET_BYTES,
        "maximum_realization_seconds": MAXIMUM_REALIZATION_SECONDS,
        "selectors_called": False,
        "comparators_called": False,
        "gates_evaluated": False,
        "independent_trial": False,
    }


def run_diagnostic() -> dict[str, object]:
    """Replay all six consumed sprinklings after exclusive reservation."""

    states = diagnostic_sprinkling_states()
    records: list[dict[str, object]] = []
    index = 0
    for events in FROZEN_DENSITIES:
        for realization in range(DEVELOPMENT_REALIZATIONS):
            records.append(
                evaluate_replayed_sprinkling(
                    events, realization, states[index]
                )
            )
            index += 1
    return {
        "stage": "A3f-R4-D",
        "status": "diagnostic_completed",
        "claim_boundary": (
            "deterministic consumed-seed diagnosis only; no selector, gate, "
            "outcome, independent trial, or downstream geometry claim"
        ),
        "protocol": frozen_protocol(),
        "expected_replay": [
            {
                "events": events,
                "realization": realization,
                **EXPECTED_REPLAY[(events, realization)],
            }
            for events in FROZEN_DENSITIES
            for realization in range(DEVELOPMENT_REALIZATIONS)
        ],
        "records": records,
    }


def write_json(path: Path, payload: dict[str, object]) -> None:
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )


def execute_reserved_diagnostic(
    output: Path,
    sentinel: Path,
    metadata: Mapping[str, object],
    runner: Callable[[], dict[str, object]] = run_diagnostic,
) -> dict[str, object]:
    """Reserve output and sentinel before any seed spawning or RNG creation."""

    with frozen_run_set_reservation((output,), sentinel, metadata):
        payload = runner()
        write_json(output, payload)
    return payload


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--sentinel", type=Path, required=True)
    parser.add_argument("--plan", type=Path, required=True)
    parser.add_argument("--tests", type=Path, required=True)
    parser.add_argument("--r4-source", type=Path, required=True)
    parser.add_argument("--guard", type=Path, required=True)
    parser.add_argument("--r4-artifact", type=Path, required=True)
    parser.add_argument("--expected-plan-sha256", required=True)
    parser.add_argument("--expected-implementation-sha256", required=True)
    parser.add_argument("--expected-tests-sha256", required=True)
    parser.add_argument("--expected-r4-source-sha256", required=True)
    parser.add_argument("--expected-guard-sha256", required=True)
    parser.add_argument("--expected-r4-artifact-sha256", required=True)
    args = parser.parse_args()

    hashes = {
        "plan_sha256": verify_hash(
            args.plan, args.expected_plan_sha256, "plan"
        ),
        "implementation_sha256": verify_hash(
            Path(__file__).resolve(),
            args.expected_implementation_sha256,
            "implementation",
        ),
        "tests_sha256": verify_hash(
            args.tests, args.expected_tests_sha256, "tests"
        ),
        "imported_r4_source_sha256": verify_hash(
            args.r4_source,
            args.expected_r4_source_sha256,
            "imported R4 source",
        ),
        "guard_sha256": verify_hash(
            args.guard, args.expected_guard_sha256, "guard"
        ),
        "reviewed_r4_artifact_sha256": verify_hash(
            args.r4_artifact,
            args.expected_r4_artifact_sha256,
            "reviewed R4 artifact",
        ),
    }
    metadata = {
        "work_item": "GRAV-GROWING-ATLAS-001",
        "protocol_sha256": hashes["plan_sha256"],
        "seed": {
            "development": DEVELOPMENT_SEED,
            "status": "consumed_deterministic_replay",
            "heldout": HELDOUT_SEED_RETIRED,
            "heldout_status": "retired_unconsumed",
        },
        "protocol": frozen_protocol(),
        **hashes,
    }
    payload = execute_reserved_diagnostic(
        args.output, args.sentinel, metadata
    )
    report = {
        "status": payload["status"],
        "records": len(payload["records"]),
        "raw_sha256": file_sha256(args.output),
        "scientific_content_sha256": content_sha256(
            payload, deterministic=False
        ),
        "deterministic_content_sha256": content_sha256(
            payload, deterministic=True
        ),
        "interpretation_labels": [
            record["interpretation_label"] for record in payload["records"]
        ],
    }
    print(json.dumps(report, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
