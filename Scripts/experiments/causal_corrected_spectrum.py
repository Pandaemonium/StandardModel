"""Stage S1: corrected-pairing spectroscopy on protected-core carriers.

Diagnostic stage (R4-D pattern): implementation tripwires only, no gate on
the four-mode hypothesis.  Per carrier, the corrected pairing of the
project-local operator is assembled as the canonical ambient symmetric
matrix of the zero-sum weighted-difference operator (kernel modules
CorrectedPairingDifferenceOperator / DifferenceCoordinates, 2026-07-16),
eigendecomposed, and summarized.  Sylvester inertia versus strict-past
layer counts is an exact tripwire because the form is kernel-proved
congruent to diag(w)/2.

Coordinates generate only the oracle causal relation and are deleted
before any spectral computation.  This is finite numerical spectroscopy on
flat manifold-generated controls; it claims nothing about positivity,
gaps, tetrads, or continua.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import time
from dataclasses import asdict
from pathlib import Path

import numpy as np
import psutil

from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_atlas_coverage import (
    FROZEN_OUTER_BAND,
    complete_outer_candidates,
)
from causal_atlas_scaling import process_peak_working_set_bytes
from causal_buffered_core_feasibility import schedule_at_density
from causal_growing_atlas import materialize_candidate_carriers
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_operator_metric import sprinkle_minkowski_diamond
from frozen_run_guard import frozen_run_set_reservation


CONFIRMATORY_SEED = 2026071612
FROZEN_DENSITIES = (2000, 4000)
REALIZATIONS = 3
FROZEN_BUFFER_RADIUS_MULTIPLIERS = (0.8, 1.0)
SPECTRAL_CARRIERS = 8
FROZEN_DURATION = 1.0
FROZEN_ELL = 1.0
MAXIMUM_COMPLETE_CANDIDATES = 4000
MAXIMUM_DENSE_RELATION_ENTRIES = 4001**2
MAXIMUM_PEAK_WORKING_SET_BYTES = 4 * 1024**3
MAXIMUM_REALIZATION_SECONDS = 300.0
MAXIMUM_EIG_DIMENSION = 3000
ZERO_TOLERANCE = 1e-9
GAP_CONTROL_KS = (2, 3, 4, 5, 6)


def source_local_4d_prefactor(ell: float) -> float:
    """Mirror of the kernel `sourceLocal4DPrefactor` (positive for ell != 0)."""

    return 4.0 / (np.sqrt(6.0) * ell**2)


def source_local_4d_coefficient(n: int) -> float:
    """Mirror of the kernel `sourceLocal4DCoefficient` (1, -9, 16, -8, 0...)."""

    return {0: 1.0, 1: -9.0, 2: 16.0, 3: -8.0}.get(n, 0.0)


def carrier_weight_row(
    relation: np.ndarray,
    open_counts,
    members: np.ndarray,
    top: int,
    ell: float,
) -> np.ndarray:
    """Project-local weight row on carrier members, marked at the top.

    w(y) = -prefactor(ell) * coefficient(openIntervalCount(y, top)) for
    y strictly below the top; 0 at the top itself.  ``open_counts`` stores
    INCLUSIVE counts (open + 1) per the repo convention.
    """

    prefactor = source_local_4d_prefactor(ell)
    weights = np.zeros(len(members), dtype=float)
    for index, event in enumerate(members):
        if event == top:
            continue
        if not relation[event, top]:
            raise ValueError("carrier member not below the top endpoint")
        inclusive = int(open_counts[event, top])
        weights[index] = -prefactor * source_local_4d_coefficient(inclusive - 1)
    return weights


def corrected_operator_matrix(weights: np.ndarray, top_index: int) -> np.ndarray:
    """Ambient matrix of the canonical zero-sum weighted-difference operator.

    (M h)_z = (1/2) * (w_z (h_z - h_x) - delta_{z,x} sum_y w_y (h_y - h_x))
    with x the marked top index.  Symmetric by construction; annihilates
    constants; range inside the zero-sum subspace.
    """

    m = len(weights)
    matrix = np.zeros((m, m), dtype=float)
    for z in range(m):
        if z == top_index:
            continue
        matrix[z, z] += 0.5 * weights[z]
        matrix[z, top_index] -= 0.5 * weights[z]
        matrix[top_index, z] -= 0.5 * weights[z]
        matrix[top_index, top_index] += 0.5 * weights[z]
    return matrix


def expected_inertia(weights: np.ndarray, top_index: int) -> tuple[int, int, int]:
    """Sylvester prediction for the zero-sum restriction from the weight signs."""

    strict_past = np.delete(weights, top_index)
    positive = int(np.sum(strict_past > 0.0))
    negative = int(np.sum(strict_past < 0.0))
    zero = int(np.sum(strict_past == 0.0))
    return positive, zero, negative


def spectrum_summary(matrix: np.ndarray, weights: np.ndarray, top_index: int) -> dict:
    """Eigendecompose ambient matrix; strip the structural constants zero."""

    if not np.array_equal(matrix, matrix.T):
        raise ValueError("corrected operator matrix must be exactly symmetric")
    eigenvalues, eigenvectors = np.linalg.eigh(matrix)
    scale = float(np.max(np.abs(eigenvalues))) or 1.0
    near_zero = np.abs(eigenvalues) <= ZERO_TOLERANCE * scale
    predicted_positive, predicted_zero, predicted_negative = expected_inertia(
        weights, top_index
    )
    # ambient spectrum = {structural 0 from constants} u zero-sum spectrum;
    # the zero-sum restriction contributes predicted_zero further zeros.
    expected_ambient_zeros = predicted_zero + 1
    observed_positive = int(np.sum(eigenvalues > ZERO_TOLERANCE * scale))
    observed_negative = int(np.sum(eigenvalues < -ZERO_TOLERANCE * scale))
    observed_zero = int(np.sum(near_zero))
    restricted = np.sort(eigenvalues[~near_zero])
    by_magnitude = restricted[np.argsort(-np.abs(restricted))]
    gaps: dict[str, float] = {}
    for k in GAP_CONTROL_KS:
        if len(by_magnitude) > k and abs(by_magnitude[k - 1]) > 0:
            gaps[f"g{k}"] = float(
                (abs(by_magnitude[k - 1]) - abs(by_magnitude[k]))
                / abs(by_magnitude[k - 1])
            )
        else:
            gaps[f"g{k}"] = 0.0
    cluster4 = bool(
        gaps["g4"] >= 0.5
        and all(gaps["g4"] > gaps[f"g{k}"] for k in GAP_CONTROL_KS if k != 4)
    )
    top4 = eigenvectors[:, np.argsort(-np.abs(eigenvalues))[:4]]
    participation = [
        float((np.sum(v**2) ** 2) / np.sum(v**4)) if np.any(v) else 0.0
        for v in top4.T
    ]
    return {
        "dimension_ambient": int(len(weights)),
        "eigenvalues_restricted": [float(v) for v in restricted],
        "observed_inertia": [observed_positive, observed_zero, observed_negative],
        "predicted_inertia_with_constant": [
            predicted_positive,
            expected_ambient_zeros,
            predicted_negative,
        ],
        "inertia_tripwire": bool(
            observed_positive == predicted_positive
            and observed_negative == predicted_negative
            and observed_zero == expected_ambient_zeros
        ),
        "gap_statistics": gaps,
        "cluster_of_four_indicator": cluster4,
        "top_mode_participation": participation,
    }


def analyze_carrier(
    relation: np.ndarray,
    open_counts,
    candidate: np.ndarray,
    rng: np.random.Generator,
    ell: float,
) -> dict:
    """Full per-carrier record: spectrum, tripwires, relabeling, null control."""

    past, future = int(candidate[0]), int(candidate[1])
    open_members = np.flatnonzero(
        relation[past] & relation[:, future]
    )
    members = np.concatenate(([past], open_members, [future]))
    if len(members) > MAXIMUM_EIG_DIMENSION:
        raise MemoryError("carrier exceeds the eigendecomposition ceiling")
    top_index = len(members) - 1
    weights = carrier_weight_row(relation, open_counts, members, future, ell)
    matrix = corrected_operator_matrix(weights, top_index)
    summary = spectrum_summary(matrix, weights, top_index)

    permutation = rng.permutation(len(members))
    permuted_weights = weights[permutation]
    permuted_top = int(np.flatnonzero(permutation == top_index)[0])
    permuted = corrected_operator_matrix(permuted_weights, permuted_top)
    permuted_summary = spectrum_summary(permuted, permuted_weights, permuted_top)
    reference = np.asarray(summary["eigenvalues_restricted"])
    relabeled = np.asarray(permuted_summary["eigenvalues_restricted"])
    scale = float(np.max(np.abs(reference))) or 1.0
    relabeling_tripwire = bool(
        len(reference) == len(relabeled)
        and np.allclose(reference, relabeled, atol=ZERO_TOLERANCE * scale)
    )

    strict_past_indices = [i for i in range(len(members)) if i != top_index]
    shuffled = weights.copy()
    shuffled_values = shuffled[strict_past_indices]
    rng.shuffle(shuffled_values)
    shuffled[strict_past_indices] = shuffled_values
    null_matrix = corrected_operator_matrix(shuffled, top_index)
    null_summary = spectrum_summary(null_matrix, shuffled, top_index)

    return {
        "candidate": [int(v) for v in candidate],
        "spectrum": summary,
        "relabeling_tripwire": relabeling_tripwire,
        "null_control": {
            "gap_statistics": null_summary["gap_statistics"],
            "cluster_of_four_indicator": null_summary["cluster_of_four_indicator"],
        },
    }


def evaluate_realization(
    events: int,
    realization: int,
    sprinkling_state: tuple[int, ...],
    carrier_state: tuple[int, ...],
    *,
    process: psutil.Process | None = None,
) -> dict:
    """One sprinkling: candidates, largest-core carriers, spectra."""

    started = time.perf_counter()
    active = process or psutil.Process()
    if (events + 1) ** 2 > MAXIMUM_DENSE_RELATION_ENTRIES:
        raise ValueError("dense relation ceiling would be exceeded")
    points, _ = sprinkle_minkowski_diamond(
        np.random.default_rng(np.asarray(sprinkling_state, dtype=np.uint32)),
        events,
        FROZEN_DURATION,
    )
    relation = causal_relation_matrix(points)
    del points
    open_counts = sparse_inclusive_interval_count_matrix(relation)
    schedule = schedule_at_density(float(events))
    candidates = complete_outer_candidates(
        open_counts, schedule.outer_count, FROZEN_OUTER_BAND
    )
    record: dict = {
        "events": events,
        "realization": realization,
        "seed_states": {
            "sprinkling": list(sprinkling_state),
            "carrier": list(carrier_state),
        },
        "schedule": asdict(schedule),
        "complete_candidate_count": int(len(candidates)),
        "ell": FROZEN_ELL,
    }
    if len(candidates) > MAXIMUM_COMPLETE_CANDIDATES:
        record["outcome"] = "INADMISSIBLE"
        record["inadmissible_reasons"] = ["candidate family exceeds ceiling"]
        return record
    if len(candidates) < SPECTRAL_CARRIERS:
        record["outcome"] = "INADMISSIBLE"
        record["inadmissible_reasons"] = [
            "candidate family smaller than SPECTRAL_CARRIERS"
        ]
        return record
    order = np.argsort(-candidates[:, 2], kind="stable")
    chosen = candidates[order[:SPECTRAL_CARRIERS]]
    # carrier materialization is validated upstream; here we only need the
    # tripwire that endpoints are comparable, which analyze_carrier rechecks.
    materialize_candidate_carriers(relation, chosen)
    rng = np.random.default_rng(np.asarray(carrier_state, dtype=np.uint32))
    carriers = [
        analyze_carrier(relation, open_counts, candidate, rng, FROZEN_ELL)
        for candidate in chosen
    ]
    peak = process_peak_working_set_bytes(active)
    elapsed = time.perf_counter() - started
    tripwires_clean = all(
        c["spectrum"]["inertia_tripwire"] and c["relabeling_tripwire"]
        for c in carriers
    )
    reasons: list[str] = []
    if peak > MAXIMUM_PEAK_WORKING_SET_BYTES:
        reasons.append("peak working set exceeds ceiling")
    if elapsed > MAXIMUM_REALIZATION_SECONDS:
        reasons.append("wall time exceeds ceiling")
    if not tripwires_clean:
        reasons.append("spectral tripwire mismatch")
    record.update(
        {
            "carriers": carriers,
            "phase_peak_working_set_bytes": int(peak),
            "runtime_seconds": float(elapsed),
            "outcome": "INADMISSIBLE" if reasons else "PASS",
            "inadmissible_reasons": reasons,
            "cluster_of_four_count": int(
                sum(c["spectrum"]["cluster_of_four_indicator"] for c in carriers)
            ),
            "null_cluster_of_four_count": int(
                sum(c["null_control"]["cluster_of_four_indicator"] for c in carriers)
            ),
        }
    )
    return record


def run_stage(seed: int) -> dict:
    """Run every density/realization cell from one master seed."""

    roots = np.random.SeedSequence(seed).spawn(
        len(FROZEN_DENSITIES) * REALIZATIONS
    )
    records = []
    index = 0
    for events in FROZEN_DENSITIES:
        for realization in range(REALIZATIONS):
            spawned = roots[index].spawn(2)
            records.append(
                evaluate_realization(
                    events,
                    realization,
                    tuple(int(v) for v in spawned[0].generate_state(4)),
                    tuple(int(v) for v in spawned[1].generate_state(4)),
                )
            )
            index += 1
    return {
        "stage": "S1-corrected-spectrum",
        "claim_boundary": (
            "finite numerical spectroscopy with supplied coefficients on flat "
            "manifold-generated controls; diagnostic only - no gate on the "
            "four-mode hypothesis; tripwires are implementation checks"
        ),
        "seed": seed,
        "densities": FROZEN_DENSITIES,
        "realizations": REALIZATIONS,
        "spectral_carriers": SPECTRAL_CARRIERS,
        "records": records,
    }


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--sentinel", type=Path)
    parser.add_argument("--seed", type=int, required=True)
    parser.add_argument("--exploratory", action="store_true")
    parser.add_argument("--expected-plan-sha256")
    parser.add_argument("--plan", type=Path)
    args = parser.parse_args()

    if args.seed == CONFIRMATORY_SEED and args.exploratory:
        raise SystemExit("the confirmatory seed cannot be run as exploratory")
    if args.seed == CONFIRMATORY_SEED:
        if not (args.sentinel and args.plan and args.expected_plan_sha256):
            raise SystemExit(
                "confirmatory runs require --sentinel, --plan, and the plan hash"
            )
        actual = file_sha256(args.plan)
        if actual.lower() != args.expected_plan_sha256.lower():
            raise SystemExit(f"plan hash mismatch: {actual}")
        metadata = {
            "work_item": "GRAV-ORDER-OPERATOR-001",
            "protocol_sha256": actual,
            "seed": args.seed,
        }
        with frozen_run_set_reservation([args.output], args.sentinel, metadata):
            payload = run_stage(args.seed)
            args.output.write_text(
                json.dumps(payload, indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
                newline="\n",
            )
    else:
        if not args.exploratory:
            raise SystemExit(
                "non-confirmatory seeds must be explicitly --exploratory"
            )
        payload = run_stage(args.seed)
        payload["EXPLORATORY"] = (
            "non-frozen scoping run; excluded from all claims and gates"
        )
        args.output.write_text(
            json.dumps(payload, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
            newline="\n",
        )
    print(
        json.dumps(
            {
                "outcomes": [r["outcome"] for r in payload["records"]],
                "cluster_of_four_counts": [
                    r.get("cluster_of_four_count") for r in payload["records"]
                ],
                "null_cluster_counts": [
                    r.get("null_cluster_of_four_count")
                    for r in payload["records"]
                ],
                "output_raw_sha256": file_sha256(args.output),
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
