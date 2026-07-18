"""Complete-family bulk-saturation scaling for causal-atlas cores.

Stage A3f-R3 tests a scaling law generated post hoc from the spent R2 data on
fresh, interleaved densities.  The complete order-selected candidate family is
materialized, but each protected core is streamed directly into union masks.
No candidate-by-event core matrix, selector, operator row, or coordinate
control is part of this stage.

Coordinates are used only to generate the oracle causal relation and are
discarded before every order-side statistic.  This is a finite candidate-family
measurement, not a continuum-metric or general-relativity derivation.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import time
from dataclasses import asdict
from pathlib import Path
from typing import Callable

import numpy as np
import psutil
from scipy import sparse

from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_atlas_coverage import (
    FROZEN_BUFFER_RADIUS_MULTIPLIERS,
    FROZEN_OUTER_BAND,
    complete_outer_candidates,
    independent_order_bulk,
    integer_candidate_band,
    sampled_induced_count_tripwire,
)
from causal_buffered_core_feasibility import (
    protected_core_fraction_4d_from_z,
    schedule_at_density,
)
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_operator_metric import sprinkle_minkowski_diamond


FROZEN_SEED = 2026071609
FROZEN_DENSITIES = (6000, 12000)
FROZEN_REALIZATIONS = 5
FROZEN_DURATION = 1.0
MAXIMUM_COMPLETE_CANDIDATES = 4000
MAXIMUM_DENSE_RELATION_ENTRIES = 12001**2
MAXIMUM_PEAK_WORKING_SET_BYTES = 6 * 1024**3
MAXIMUM_REALIZATION_SECONDS = 600.0
MINIMUM_COMPLETE_CANDIDATES = 16
MINIMUM_VALID_REALIZATIONS = 4
MAXIMUM_SCALED_DEFICIT_DRIFT = 0.20
MAXIMUM_F4_BULK_FRACTION_ERROR = 0.05
MINIMUM_NARROW_ALL_EVENT_COVERAGE = 0.60
DESIGN_CENTERS = {0.8: 12.85, 1.0: 17.16, 1.25: 26.73}


def effective_count_threshold(buffer_count: float) -> int:
    """Natural threshold equivalent to comparing integer counts with ``H``."""

    if not math.isfinite(buffer_count) or buffer_count < 0.0:
        raise ValueError("buffer count must be finite and nonnegative")
    return int(math.ceil(buffer_count))


def flat_bulk_fraction_prediction(buffer_count: float, events: int) -> float:
    """Flat 4D two-sided bulk fraction at the archived real count ratio."""

    if not math.isfinite(buffer_count) or buffer_count < 0.0:
        raise ValueError("buffer count must be finite and nonnegative")
    if events <= 0:
        raise ValueError("events must be positive")
    z = 2.0 * (buffer_count / events) ** 0.25
    return protected_core_fraction_4d_from_z(z)


def process_peak_working_set_bytes(
    process: psutil.Process | None = None,
) -> int:
    """Return the OS peak working set when available, otherwise current RSS."""

    info = (process or psutil.Process()).memory_info()
    return int(getattr(info, "peak_wset", info.rss))


def _size_summary(values: list[int]) -> dict[str, int | float | None]:
    if not values:
        return {
            "count": 0,
            "minimum": None,
            "median": None,
            "maximum": None,
            "mean": None,
        }
    array = np.asarray(values, dtype=np.int64)
    return {
        "count": len(values),
        "minimum": int(np.min(array)),
        "median": float(np.median(array)),
        "maximum": int(np.max(array)),
        "mean": float(np.mean(array)),
    }


def candidate_content_sha256(candidates: np.ndarray) -> str:
    """Hash the exact ordered candidate array in a platform-stable encoding."""

    _validate_candidates(candidates)
    canonical = np.ascontiguousarray(candidates, dtype="<i8")
    return hashlib.sha256(canonical.tobytes()).hexdigest()


def _validate_candidates(candidates: np.ndarray) -> None:
    if candidates.ndim != 2 or candidates.shape[1] != 3:
        raise ValueError("candidates must have shape (C,3)")


def spawn_scaling_seed_states(
    seed: int,
    densities: tuple[int, ...],
    realizations: int,
) -> tuple[tuple[int, ...], ...]:
    """Create one distinct, directly replayable sprinkling stream per run."""

    if not densities or any(events <= 0 for events in densities):
        raise ValueError("densities must be positive")
    if realizations <= 0:
        raise ValueError("realizations must be positive")
    roots = np.random.SeedSequence(seed).spawn(len(densities) * realizations)
    return tuple(
        tuple(int(value) for value in root.generate_state(4))
        for root in roots
    )


def _rng(seed_state: tuple[int, ...]) -> np.random.Generator:
    return np.random.default_rng(np.asarray(seed_state, dtype=np.uint32))


def _empty_rungs(
    base_buffer_count: float,
    events: int,
) -> list[dict[str, object]]:
    rows = []
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        buffer_count = beta**4 * base_buffer_count
        rows.append(
            {
                "buffer_radius_multiplier": beta,
                "buffer_count": buffer_count,
                "effective_count_threshold": effective_count_threshold(
                    buffer_count
                ),
                "bulk_count": None,
                "bulk_fraction": None,
                "flat_f4_bulk_fraction_prediction": (
                    flat_bulk_fraction_prediction(buffer_count, events)
                ),
                "flat_f4_absolute_error": None,
                "complete_union_all_event_count": None,
                "complete_union_bulk_count": None,
                "complete_union_all_event_coverage": None,
                "complete_union_bulk_coverage": None,
                "scaled_saturation_deficit": None,
                "scaled_deficit_over_design_center": None,
                "core_size_summary": None,
                "core_carrier_containment_tripwire": False,
                "core_bulk_containment_tripwire": False,
                "integer_factorization_tripwire": False,
                "floating_factorization_tripwire": False,
                "nonempty_bulk": False,
                "admissible": False,
            }
        )
    return rows


def resource_failure_record(
    phase: str,
    reason: str,
    events: int,
    base_buffer_count: float,
    complete_candidate_count: int | None,
    phase_peak_working_set_bytes: dict[str, int],
) -> dict[str, object]:
    """Return the distinct failure shape; unavailable coverages stay ``None``."""

    return {
        "status": "resource_failure",
        "resource_failure": {"phase": phase, "reason": reason},
        "complete_candidate_count": complete_candidate_count,
        "candidate_count_tripwire": False,
        "carrier_size_summary": None,
        "induced_count_tripwire": False,
        "phase_peak_working_set_bytes": phase_peak_working_set_bytes,
        "rungs": _empty_rungs(base_buffer_count, events),
    }


def stream_complete_family(
    relation: np.ndarray,
    inclusive_counts: sparse.csr_matrix,
    candidates: np.ndarray,
    base_buffer_count: float,
    events: int,
    *,
    maximum_candidates: int = MAXIMUM_COMPLETE_CANDIDATES,
    maximum_peak_bytes: int = MAXIMUM_PEAK_WORKING_SET_BYTES,
    maximum_seconds: float = MAXIMUM_REALIZATION_SECONDS,
    started_at: float | None = None,
    process: psutil.Process | None = None,
    clock: Callable[[], float] = time.perf_counter,
    include_union_masks: bool = False,
) -> dict[str, object]:
    """Stream all candidate cores into complete-family union masks.

    The real buffer value is converted once to ``ceil(H)``.  This is exactly
    equivalent to comparing integer inclusive counts and strict global degrees
    with ``H``, and it supplies the common natural threshold required by the
    finite core-to-bulk containment theorem.
    """

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if inclusive_counts.shape != relation.shape:
        raise ValueError("relation and count matrix shapes must agree")
    _validate_candidates(candidates)
    if events <= 0 or len(relation) != events + 1:
        raise ValueError("relation size must be the random-event count plus one")
    if base_buffer_count <= 0.0:
        raise ValueError("base buffer count must be positive")
    if maximum_candidates <= 0 or maximum_peak_bytes <= 0 or maximum_seconds <= 0:
        raise ValueError("resource ceilings must be positive")

    start = clock() if started_at is None else started_at
    active_process = process or psutil.Process()
    phase_peaks: dict[str, int] = {}

    def sample_peak(phase: str) -> int:
        peak = process_peak_working_set_bytes(active_process)
        phase_peaks[phase] = peak
        return peak

    if len(candidates) > maximum_candidates:
        return resource_failure_record(
            "candidate_family",
            "complete candidate family exceeds the frozen ceiling",
            events,
            base_buffer_count,
            len(candidates),
            phase_peaks,
        )
    if sample_peak("candidate_family") > maximum_peak_bytes:
        return resource_failure_record(
            "candidate_family",
            "peak working set exceeds the frozen ceiling",
            events,
            base_buffer_count,
            len(candidates),
            phase_peaks,
        )

    event_count = len(relation)
    betas = FROZEN_BUFFER_RADIUS_MULTIPLIERS
    buffer_counts = {beta: beta**4 * base_buffer_count for beta in betas}
    thresholds = {
        beta: effective_count_threshold(buffer_counts[beta]) for beta in betas
    }
    bulks = {
        beta: independent_order_bulk(relation, float(thresholds[beta]))
        for beta in betas
    }
    all_event_unions = {
        beta: np.zeros(event_count, dtype=bool) for beta in betas
    }
    bulk_unions = {
        beta: np.zeros(event_count, dtype=bool) for beta in betas
    }
    core_sizes: dict[float, list[int]] = {beta: [] for beta in betas}
    carrier_sizes: list[int] = []
    carrier_containment = {beta: True for beta in betas}
    bulk_containment = {beta: True for beta in betas}

    if len(candidates):
        matrix_values = np.asarray(
            inclusive_counts[candidates[:, 0], candidates[:, 1]]
        ).reshape(-1)
        candidate_count_tripwire = bool(
            np.array_equal(matrix_values.astype(np.int64), candidates[:, 2])
        )
    else:
        candidate_count_tripwire = True

    count_csc = inclusive_counts.tocsc()
    induced_count_tripwire = True
    for index, (past_value, future_value, stored_count_value) in enumerate(
        candidates
    ):
        past = int(past_value)
        future = int(future_value)
        stored_count = int(stored_count_value)
        if not relation[past, future]:
            candidate_count_tripwire = False
            continue
        carrier = relation[past] & relation[:, future]
        carrier_size = int(np.count_nonzero(carrier))
        carrier_sizes.append(carrier_size)
        induced_count_tripwire &= carrier_size == stored_count - 1
        if index == 0:
            induced_count_tripwire &= sampled_induced_count_tripwire(
                relation,
                inclusive_counts,
                carrier,
            )

        past_counts = np.zeros(event_count, dtype=np.int64)
        row_start = inclusive_counts.indptr[past]
        row_stop = inclusive_counts.indptr[past + 1]
        row_indices = inclusive_counts.indices[row_start:row_stop]
        past_counts[row_indices] = inclusive_counts.data[row_start:row_stop]

        future_counts = np.zeros(event_count, dtype=np.int64)
        col_start = count_csc.indptr[future]
        col_stop = count_csc.indptr[future + 1]
        col_indices = count_csc.indices[col_start:col_stop]
        future_counts[col_indices] = count_csc.data[col_start:col_stop]

        for beta in betas:
            threshold = thresholds[beta]
            core = (
                carrier
                & (past_counts >= threshold)
                & (future_counts >= threshold)
            )
            core_sizes[beta].append(int(np.count_nonzero(core)))
            carrier_containment[beta] &= not bool(np.any(core & ~carrier))
            bulk_containment[beta] &= not bool(np.any(core & ~bulks[beta]))
            all_event_unions[beta] |= core
            bulk_unions[beta] |= core & bulks[beta]

        if (index + 1) % 32 == 0:
            if clock() - start > maximum_seconds:
                return resource_failure_record(
                    "streaming",
                    "per-realization wall time exceeds the frozen ceiling",
                    events,
                    base_buffer_count,
                    len(candidates),
                    phase_peaks,
                )
            if sample_peak("streaming") > maximum_peak_bytes:
                return resource_failure_record(
                    "streaming",
                    "peak working set exceeds the frozen ceiling",
                    events,
                    base_buffer_count,
                    len(candidates),
                    phase_peaks,
                )

    if clock() - start > maximum_seconds:
        return resource_failure_record(
            "streaming",
            "per-realization wall time exceeds the frozen ceiling",
            events,
            base_buffer_count,
            len(candidates),
            phase_peaks,
        )

    rungs: list[dict[str, object]] = []
    for beta in betas:
        peak = sample_peak(f"rung_{beta:.2f}")
        if peak > maximum_peak_bytes:
            return resource_failure_record(
                f"rung_{beta:.2f}",
                "peak working set exceeds the frozen ceiling",
                events,
                base_buffer_count,
                len(candidates),
                phase_peaks,
            )
        bulk_count = int(np.count_nonzero(bulks[beta]))
        all_union_count = int(np.count_nonzero(all_event_unions[beta]))
        bulk_union_count = int(np.count_nonzero(bulk_unions[beta]))
        all_coverage = float(all_union_count / event_count)
        bulk_fraction = float(bulk_count / event_count)
        bulk_coverage = (
            float(bulk_union_count / bulk_count) if bulk_count else None
        )
        f4_prediction = flat_bulk_fraction_prediction(
            buffer_counts[beta], events
        )
        scaled_deficit = (
            math.sqrt(events) * (1.0 - bulk_coverage)
            if bulk_coverage is not None
            else None
        )
        exact_factorization = bool(
            bulk_count > 0
            and all_union_count * bulk_count
            == bulk_union_count * bulk_count
        )
        floating_factorization = bool(
            bulk_coverage is not None
            and math.isclose(
                all_coverage,
                bulk_fraction * bulk_coverage,
                rel_tol=1e-14,
                abs_tol=1e-14,
            )
        )
        admissible = bool(
            len(candidates) >= MINIMUM_COMPLETE_CANDIDATES
            and bulk_count > 0
            and candidate_count_tripwire
            and induced_count_tripwire
            and carrier_containment[beta]
            and bulk_containment[beta]
            and exact_factorization
            and floating_factorization
        )
        rungs.append(
            {
                "buffer_radius_multiplier": beta,
                "buffer_count": buffer_counts[beta],
                "effective_count_threshold": thresholds[beta],
                "bulk_count": bulk_count,
                "bulk_fraction": bulk_fraction,
                "flat_f4_bulk_fraction_prediction": f4_prediction,
                "flat_f4_absolute_error": abs(
                    bulk_fraction - f4_prediction
                ),
                "complete_union_all_event_count": all_union_count,
                "complete_union_bulk_count": bulk_union_count,
                "complete_union_all_event_coverage": all_coverage,
                "complete_union_bulk_coverage": bulk_coverage,
                "scaled_saturation_deficit": scaled_deficit,
                "scaled_deficit_over_design_center": (
                    scaled_deficit / DESIGN_CENTERS[beta]
                    if scaled_deficit is not None
                    else None
                ),
                "core_size_summary": _size_summary(core_sizes[beta]),
                "core_carrier_containment_tripwire": (
                    carrier_containment[beta]
                ),
                "core_bulk_containment_tripwire": bulk_containment[beta],
                "integer_factorization_tripwire": exact_factorization,
                "floating_factorization_tripwire": floating_factorization,
                "nonempty_bulk": bulk_count > 0,
                "admissible": admissible,
            }
        )

    result = {
        "status": "completed",
        "resource_failure": None,
        "complete_candidate_count": len(candidates),
        "candidate_count_tripwire": candidate_count_tripwire,
        "carrier_size_summary": _size_summary(carrier_sizes),
        "induced_count_tripwire": induced_count_tripwire,
        "phase_peak_working_set_bytes": phase_peaks,
        "rungs": rungs,
    }
    if include_union_masks:
        result["all_event_union_masks"] = {
            str(beta): all_event_unions[beta].copy() for beta in betas
        }
        result["bulk_union_masks"] = {
            str(beta): bulk_unions[beta].copy() for beta in betas
        }
    return result


def _median(values: list[float | None]) -> float | None:
    finite = [
        float(value)
        for value in values
        if value is not None and math.isfinite(float(value))
    ]
    return float(np.median(finite)) if finite else None


def summarize_density(
    events: int,
    realizations: list[dict[str, object]],
) -> dict[str, object]:
    """Cluster realizations before forming the scaled-deficit statistic."""

    by_rung: dict[str, object] = {}
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        rows = [
            next(
                row
                for row in realization["rungs"]
                if row["buffer_radius_multiplier"] == beta
            )
            for realization in realizations
        ]
        valid = [row for row in rows if bool(row["admissible"])]
        median_saturation = _median(
            [row["complete_union_bulk_coverage"] for row in valid]
        )
        median_bulk_fraction = _median(
            [row["bulk_fraction"] for row in valid]
        )
        median_f4_prediction = _median(
            [row["flat_f4_bulk_fraction_prediction"] for row in valid]
        )
        clustered_scaled_deficit = (
            math.sqrt(events) * (1.0 - median_saturation)
            if median_saturation is not None
            else None
        )
        by_rung[str(beta)] = {
            "valid_realizations": len(valid),
            "density_cell_admissible": len(valid)
            >= MINIMUM_VALID_REALIZATIONS,
            "median_complete_candidate_count": _median(
                [
                    float(realization["complete_candidate_count"])
                    if realization["complete_candidate_count"] is not None
                    else None
                    for realization in realizations
                ]
            ),
            "median_bulk_fraction": median_bulk_fraction,
            "median_flat_f4_bulk_fraction_prediction": median_f4_prediction,
            "median_f4_absolute_error": (
                abs(median_bulk_fraction - median_f4_prediction)
                if median_bulk_fraction is not None
                and median_f4_prediction is not None
                else None
            ),
            "median_complete_union_all_event_coverage": _median(
                [row["complete_union_all_event_coverage"] for row in valid]
            ),
            "median_complete_union_bulk_coverage": median_saturation,
            "clustered_scaled_saturation_deficit": clustered_scaled_deficit,
            "clustered_scaled_deficit_over_design_center": (
                clustered_scaled_deficit / DESIGN_CENTERS[beta]
                if clustered_scaled_deficit is not None
                else None
            ),
            "realization_scaled_saturation_deficits": [
                row["scaled_saturation_deficit"] for row in rows
            ],
        }
    return {"events": events, "by_rung": by_rung}


def final_gates(
    density_summaries: dict[str, dict[str, object]],
) -> dict[str, object]:
    """Apply the frozen adjacent-rung scaling and capability gates."""

    density_keys = [str(events) for events in FROZEN_DENSITIES]
    if set(density_summaries) != set(density_keys):
        raise ValueError("the scaling gate requires the two frozen densities")
    rung_gates: dict[str, object] = {}
    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
        lower = density_summaries[density_keys[0]]["by_rung"][str(beta)]
        upper = density_summaries[density_keys[1]]["by_rung"][str(beta)]
        lower_deficit = lower["clustered_scaled_saturation_deficit"]
        upper_deficit = upper["clustered_scaled_saturation_deficit"]
        denominator = (
            max(float(lower_deficit), float(upper_deficit))
            if lower_deficit is not None and upper_deficit is not None
            else 0.0
        )
        relative_drift = (
            abs(float(upper_deficit) - float(lower_deficit)) / denominator
            if denominator > 0.0
            else None
        )
        saturation_increases = bool(
            lower["median_complete_union_bulk_coverage"] is not None
            and upper["median_complete_union_bulk_coverage"] is not None
            and upper["median_complete_union_bulk_coverage"]
            > lower["median_complete_union_bulk_coverage"]
        )
        all_event_increases = bool(
            lower["median_complete_union_all_event_coverage"] is not None
            and upper["median_complete_union_all_event_coverage"] is not None
            and upper["median_complete_union_all_event_coverage"]
            > lower["median_complete_union_all_event_coverage"]
        )
        resources_and_tripwires = bool(
            lower["density_cell_admissible"]
            and upper["density_cell_admissible"]
        )
        f4_passes = bool(
            lower["median_f4_absolute_error"] is not None
            and upper["median_f4_absolute_error"] is not None
            and lower["median_f4_absolute_error"]
            <= MAXIMUM_F4_BULK_FRACTION_ERROR
            and upper["median_f4_absolute_error"]
            <= MAXIMUM_F4_BULK_FRACTION_ERROR
        )
        drift_passes = bool(
            relative_drift is not None
            and relative_drift <= MAXIMUM_SCALED_DEFICIT_DRIFT
        )
        rung_gates[str(beta)] = {
            "resources_and_tripwires_pass": resources_and_tripwires,
            "bulk_saturation_strictly_increases": saturation_increases,
            "all_event_coverage_strictly_increases": all_event_increases,
            "relative_scaled_deficit_drift": relative_drift,
            "scaled_deficit_drift_passes": drift_passes,
            "flat_f4_bulk_fraction_passes": f4_passes,
            "passes": bool(
                resources_and_tripwires
                and saturation_increases
                and all_event_increases
                and drift_passes
                and f4_passes
            ),
        }

    adjacent_pair_passes = {
        f"{left}-{right}": bool(
            rung_gates[str(left)]["passes"]
            and rung_gates[str(right)]["passes"]
        )
        for left, right in ((0.8, 1.0), (1.0, 1.25))
    }
    adjacent_pair_resources = {
        f"{left}-{right}": bool(
            rung_gates[str(left)]["resources_and_tripwires_pass"]
            and rung_gates[str(right)]["resources_and_tripwires_pass"]
        )
        for left, right in ((0.8, 1.0), (1.0, 1.25))
    }
    narrow_upper = density_summaries[str(FROZEN_DENSITIES[1])]["by_rung"][
        "0.8"
    ]
    narrow_valid = bool(narrow_upper["density_cell_admissible"])
    narrow_coverage = narrow_upper[
        "median_complete_union_all_event_coverage"
    ]
    capability_passes = bool(
        narrow_valid
        and narrow_coverage is not None
        and narrow_coverage >= MINIMUM_NARROW_ALL_EVENT_COVERAGE
    )
    scaling_pair_passes = any(adjacent_pair_passes.values())
    scaling_evidence_available = any(adjacent_pair_resources.values())
    return {
        "rung_gates": rung_gates,
        "adjacent_pair_passes": adjacent_pair_passes,
        "adjacent_pair_resources_and_tripwires": adjacent_pair_resources,
        "narrowest_rung_capability": {
            "valid_resources_and_abundance": narrow_valid,
            "median_all_event_coverage": narrow_coverage,
            "minimum_required": MINIMUM_NARROW_ALL_EVENT_COVERAGE,
            "passes": capability_passes,
        },
        "stage_passes_scaling_gate": bool(
            scaling_pair_passes and capability_passes
        ),
        "kill_displayed_saturation_law": bool(
            scaling_evidence_available and not scaling_pair_passes
        ),
        "resource_inconclusive_for_saturation_law": not scaling_evidence_available,
        "kill_accessible_balanced_family_route": bool(
            narrow_valid and not capability_passes
        ),
        "resource_inconclusive_for_accessible_route": not narrow_valid,
        "selector_gate_open": False,
        "operator_gate_open": False,
        "g2_closed": True,
    }


def _without_runtime_fields(value: object) -> object:
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
    """Apply the reviewed R2 runtime-normalized canonicalization."""

    canonical = json.dumps(
        _without_runtime_fields(payload),
        sort_keys=True,
        separators=(",", ":"),
    ).encode("utf-8")
    return hashlib.sha256(canonical).hexdigest()


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _phase_resource_failure(
    phase: str,
    reason: str,
    events: int,
    realization: int,
    seed_state: tuple[int, ...],
    replay_probe: tuple[int, ...],
    replay_tripwire: bool,
    schedule: dict[str, object],
    phase_peaks: dict[str, int],
    started_at: float,
    candidates: np.ndarray | None = None,
) -> dict[str, object]:
    failed = resource_failure_record(
        phase,
        reason,
        events,
        float(schedule["buffer_count"]),
        len(candidates) if candidates is not None else None,
        phase_peaks,
    )
    return {
        "events": events,
        "realization": realization,
        "seed_state": seed_state,
        "seed_replay_probe": replay_probe,
        "seed_replay_tripwire": replay_tripwire,
        "schedule": schedule,
        "candidate_band": None,
        "candidate_sha256": (
            candidate_content_sha256(candidates)
            if candidates is not None
            else None
        ),
        "complete_candidates": (
            [tuple(int(value) for value in row) for row in candidates]
            if candidates is not None
            else None
        ),
        **failed,
        "runtime_seconds": time.perf_counter() - started_at,
    }


def run_realization(
    events: int,
    realization: int,
    seed_state: tuple[int, ...],
    duration: float = FROZEN_DURATION,
) -> dict[str, object]:
    """Run one bounded complete-family realization from an archived stream."""

    started = time.perf_counter()
    schedule = asdict(schedule_at_density(float(events)))
    phase_peaks: dict[str, int] = {}
    process = psutil.Process()
    rng = _rng(seed_state)
    replay_probe = tuple(int(value) for value in rng.integers(0, 2**31, 8))
    replay_rng = _rng(seed_state)
    replay_tripwire = replay_probe == tuple(
        int(value) for value in replay_rng.integers(0, 2**31, 8)
    )
    rng = replay_rng

    expected_entries = (events + 1) ** 2
    if expected_entries > MAXIMUM_DENSE_RELATION_ENTRIES:
        return _phase_resource_failure(
            "relation_shape",
            "dense relation entry count exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
        )

    points, _ = sprinkle_minkowski_diamond(rng, events, duration)
    relation = causal_relation_matrix(points)
    del points
    phase_peaks["relation"] = process_peak_working_set_bytes(process)
    if phase_peaks["relation"] > MAXIMUM_PEAK_WORKING_SET_BYTES:
        return _phase_resource_failure(
            "relation",
            "peak working set exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
        )
    if time.perf_counter() - started > MAXIMUM_REALIZATION_SECONDS:
        return _phase_resource_failure(
            "relation",
            "per-realization wall time exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
        )

    inclusive_counts = sparse_inclusive_interval_count_matrix(relation)
    phase_peaks["inclusive_counts"] = process_peak_working_set_bytes(process)
    if phase_peaks["inclusive_counts"] > MAXIMUM_PEAK_WORKING_SET_BYTES:
        return _phase_resource_failure(
            "inclusive_counts",
            "peak working set exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
        )
    if time.perf_counter() - started > MAXIMUM_REALIZATION_SECONDS:
        return _phase_resource_failure(
            "inclusive_counts",
            "per-realization wall time exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
        )

    candidates = complete_outer_candidates(
        inclusive_counts,
        float(schedule["outer_count"]),
        FROZEN_OUTER_BAND,
    )
    phase_peaks["candidate_family"] = process_peak_working_set_bytes(process)
    if len(candidates) > MAXIMUM_COMPLETE_CANDIDATES:
        return _phase_resource_failure(
            "candidate_family",
            "complete candidate family exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
            candidates,
        )
    if phase_peaks["candidate_family"] > MAXIMUM_PEAK_WORKING_SET_BYTES:
        return _phase_resource_failure(
            "candidate_family",
            "peak working set exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
            candidates,
        )
    if time.perf_counter() - started > MAXIMUM_REALIZATION_SECONDS:
        return _phase_resource_failure(
            "candidate_family",
            "per-realization wall time exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
            candidates,
        )

    streamed = stream_complete_family(
        relation,
        inclusive_counts,
        candidates,
        float(schedule["buffer_count"]),
        events,
        started_at=started,
        process=process,
    )
    phase_peaks.update(streamed["phase_peak_working_set_bytes"])
    if not replay_tripwire:
        for rung in streamed["rungs"]:
            rung["admissible"] = False
    lower, upper = integer_candidate_band(
        float(schedule["outer_count"]), FROZEN_OUTER_BAND
    )
    candidate_hash = candidate_content_sha256(candidates)
    candidate_rows = [
        tuple(int(value) for value in row) for row in candidates
    ]
    final_peak = process_peak_working_set_bytes(process)
    phase_peaks["final_record"] = final_peak
    if final_peak > MAXIMUM_PEAK_WORKING_SET_BYTES:
        return _phase_resource_failure(
            "final_record",
            "peak working set exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
            candidates,
        )
    if time.perf_counter() - started > MAXIMUM_REALIZATION_SECONDS:
        return _phase_resource_failure(
            "final_record",
            "per-realization wall time exceeds the frozen ceiling",
            events,
            realization,
            seed_state,
            replay_probe,
            replay_tripwire,
            schedule,
            phase_peaks,
            started,
            candidates,
        )
    return {
        "events": events,
        "realization": realization,
        "seed_state": seed_state,
        "seed_replay_probe": replay_probe,
        "seed_replay_tripwire": replay_tripwire,
        "schedule": schedule,
        "candidate_band": {"minimum": lower, "maximum": upper},
        "candidate_sha256": candidate_hash,
        "complete_candidates": candidate_rows,
        **streamed,
        "phase_peak_working_set_bytes": phase_peaks,
        "runtime_seconds": time.perf_counter() - started,
    }


def run_benchmark(
    seed: int = FROZEN_SEED,
    densities: tuple[int, ...] = FROZEN_DENSITIES,
    realizations: int = FROZEN_REALIZATIONS,
    duration: float = FROZEN_DURATION,
) -> dict[str, object]:
    """Run the once-only frozen A3f-R3 scaling benchmark."""

    if seed != FROZEN_SEED:
        raise ValueError("the frozen seed is exactly 2026071609")
    if densities != FROZEN_DENSITIES:
        raise ValueError("the frozen densities are exactly (6000, 12000)")
    if realizations != FROZEN_REALIZATIONS:
        raise ValueError("the frozen benchmark requires five realizations")
    if duration != FROZEN_DURATION:
        raise ValueError("the frozen duration is exactly one")

    seed_states = spawn_scaling_seed_states(seed, densities, realizations)
    records: list[dict[str, object]] = []
    density_records: dict[str, list[dict[str, object]]] = {
        str(events): [] for events in densities
    }
    root_index = 0
    for events in densities:
        for realization in range(realizations):
            record = run_realization(
                events, realization, seed_states[root_index], duration
            )
            root_index += 1
            records.append(record)
            density_records[str(events)].append(record)

    summaries = {
        key: summarize_density(int(key), rows)
        for key, rows in density_records.items()
    }
    return {
        "stage": "A3f-R3",
        "claim_boundary": (
            "complete-family bulk-saturation scaling only; no selected atlas, "
            "operator locality, G2, tetrad, curvature, or Einstein dynamics"
        ),
        "frozen_protocol": {
            "seed": seed,
            "densities": densities,
            "random_events_plus_top_endpoint": True,
            "realizations": realizations,
            "duration": duration,
            "outer_band": FROZEN_OUTER_BAND,
            "buffer_radius_multipliers": FROZEN_BUFFER_RADIUS_MULTIPLIERS,
            "maximum_complete_candidates": MAXIMUM_COMPLETE_CANDIDATES,
            "maximum_dense_relation_entries": MAXIMUM_DENSE_RELATION_ENTRIES,
            "maximum_peak_working_set_bytes": (
                MAXIMUM_PEAK_WORKING_SET_BYTES
            ),
            "maximum_realization_seconds": MAXIMUM_REALIZATION_SECONDS,
            "minimum_complete_candidates": MINIMUM_COMPLETE_CANDIDATES,
            "minimum_valid_realizations": MINIMUM_VALID_REALIZATIONS,
            "maximum_scaled_deficit_drift": (
                MAXIMUM_SCALED_DEFICIT_DRIFT
            ),
            "maximum_f4_bulk_fraction_error": (
                MAXIMUM_F4_BULK_FRACTION_ERROR
            ),
            "minimum_narrow_all_event_coverage": (
                MINIMUM_NARROW_ALL_EVENT_COVERAGE
            ),
            "design_centers_from_spent_r2": DESIGN_CENTERS,
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
    parser.add_argument("--realizations", type=int, default=FROZEN_REALIZATIONS)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    payload = run_benchmark(seed=args.seed, realizations=args.realizations)
    args.output.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(
        json.dumps(
            {
                "gates": payload["gates"],
                "artifact_hashes": {
                    "raw_sha256": file_sha256(args.output),
                    "scientific_content_sha256": scientific_content_sha256(
                        payload
                    ),
                },
            },
            indent=2,
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
