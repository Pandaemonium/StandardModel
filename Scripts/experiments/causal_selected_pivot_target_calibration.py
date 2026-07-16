"""Stage A44p one-graph calibration of selected rows against per-pivot targets."""

from __future__ import annotations

import argparse
import json
import tempfile
import time
from dataclasses import asdict
from pathlib import Path

import numpy as np

from causal_continuum_kernel_moments import CutoffProfile
from causal_discrete_germ_moments import append_marked_events
from causal_offcenter_continuum_targets import (
    OffCenterMomentResult,
    continuum_depth_ratio,
    offcenter_continuum_operator_moments,
    result_difference,
)
from causal_offcenter_target_audit import (
    normalized_channel_shift,
    relative_metric_shift,
)
from causal_operator_metric import diamond_volume_4d, sprinkle_minkowski_diamond
from causal_regional_operator_covariance import (
    REGIONAL_FIELD_NAMES,
    regional_pivot_responses,
)
from causal_reusable_relation import (
    build_packed_causal_relation,
    packed_relation_bytes,
)


COORDINATE_NAMES = ("t", "x", "y", "z")


def metric_from_expanded(values: dict[str, float]) -> np.ndarray:
    metric = np.zeros((4, 4), dtype=float)
    for mu, left_name in enumerate(COORDINATE_NAMES):
        for nu in range(mu, 4):
            right_name = COORDINATE_NAMES[nu]
            metric[mu, nu] = 0.5 * values[
                f"quadratic_{left_name}_{right_name}"
            ]
            metric[nu, mu] = metric[mu, nu]
    return metric


def matrix_signature(matrix: np.ndarray) -> tuple[int, int, int]:
    eigenvalues = np.linalg.eigvalsh(matrix)
    tolerance = 1.0e-10
    return (
        int(np.count_nonzero(eigenvalues > tolerance)),
        int(np.count_nonzero(eigenvalues < -tolerance)),
        int(np.count_nonzero(np.abs(eigenvalues) <= tolerance)),
    )


def normalized_expanded_error(
    actual: dict[str, float], target: dict[str, float]
) -> float:
    residual = np.array(
        [
            (actual[name] - target[name]) / max(1.0, abs(target[name]))
            for name in REGIONAL_FIELD_NAMES
        ]
    )
    return float(np.linalg.norm(residual) / np.sqrt(len(residual)))


def residual_mean_ledger(residuals: list[float]) -> dict[str, float | None]:
    values = np.asarray(residuals, dtype=float)
    if values.ndim != 1 or len(values) == 0:
        raise ValueError("residual ledger requires a nonempty vector")
    count = len(values)
    diagonal = float(np.sum(values**2) / count**2)
    total = float(np.mean(values) ** 2)
    off_diagonal = total - diagonal
    single_row = float(np.mean(values**2))
    return {
        "single_row_second_moment": single_row,
        "diagonal_contribution": diagonal,
        "off_diagonal_contribution": off_diagonal,
        "regional_mean_squared": total,
        "decomposition_error": abs(total - diagonal - off_diagonal),
        "effective_pivot_count": (
            single_row / total if total > 1.0e-30 else None
        ),
    }


def calibrate_selected_graph(
    seed: int,
    events: int = 100000,
    minimum_pivots: int = 16,
    stage: str = "A44p",
    claim_boundary: str = "one-graph target calibration; not concentration",
) -> dict[str, object]:
    """Run one complete selected-pivot graph and return its checkpoint."""

    random_points, random_top = sprinkle_minkowski_diamond(
        np.random.default_rng(seed), events, 2.0
    )
    points, bottom, _, top = append_marked_events(
        random_points, random_top, 2.0
    )
    profile = CutoffProfile("primary", 0.02, 0.08)
    with tempfile.TemporaryDirectory(prefix=f"{stage.lower()}-") as temp_dir:
        cache_path = Path(temp_dir) / "relation-100000.bin"
        build_start = time.perf_counter()
        cache = build_packed_causal_relation(points, 32, 4096, cache_path)
        build_seconds = time.perf_counter() - build_start
        response_start = time.perf_counter()
        regional = regional_pivot_responses(
            points,
            bottom,
            top,
            events,
            2.0,
            0.20,
            profile,
            minimum_pivots,
            128,
            cache,
            expanded_fields=True,
        )
        response_seconds = time.perf_counter() - response_start
        cache_bytes = cache.storage_bytes
        file_bytes = cache_path.stat().st_size
        cache.close()

    center_target = offcenter_continuum_operator_moments(
        np.array([1.0, 0.0, 0.0, 0.0]),
        0.20,
        profile,
        retarded_time_order=40,
        proper_order=52,
        polar_order=14,
        azimuth_order=16,
    )
    pivot_records: list[dict[str, object]] = []
    residuals = {name: [] for name in REGIONAL_FIELD_NAMES}
    quadrature_passes = True
    target_signatures_pass = True
    for offset, pivot_index in enumerate(regional.pivot_indices):
        pivot = points[pivot_index]
        low = offcenter_continuum_operator_moments(
            pivot,
            0.20,
            profile,
            retarded_time_order=28,
            proper_order=36,
            polar_order=10,
            azimuth_order=12,
        )
        high = offcenter_continuum_operator_moments(
            pivot,
            0.20,
            profile,
            retarded_time_order=40,
            proper_order=52,
            polar_order=14,
            azimuth_order=16,
        )
        difference = result_difference(low, high)
        quadrature_passes &= (
            difference["maximum_operator_absolute"] < 0.02
            and difference["metric_frobenius"] < 0.02
        )
        target_signatures_pass &= high.signature == (1, 3, 0)
        actual = {
            name: regional.responses[name][offset]
            for name in REGIONAL_FIELD_NAMES
        }
        target = high.operator_values
        for name in REGIONAL_FIELD_NAMES:
            residuals[name].append(actual[name] - target[name])
        actual_metric = metric_from_expanded(actual)
        target_metric = np.asarray(high.metric)
        metric_error = float(
            np.linalg.norm(actual_metric - target_metric)
            / np.linalg.norm(target_metric)
        )
        depth = float(continuum_depth_ratio(pivot[None, :])[0])
        pivot_records.append(
            {
                "pivot_index": pivot_index,
                "count_depth": regional.pivot_depths[offset],
                "coordinate": pivot.tolist(),
                "time_displacement": float(pivot[0] - 1.0),
                "spatial_displacement": float(np.linalg.norm(pivot[1:])),
                "continuum_depth_ratio": depth,
                "actual_operator_values": actual,
                "target": asdict(high),
                "quadrature_difference": difference,
                "center_target_six_channel_shift": normalized_channel_shift(
                    high, center_target
                ),
                "center_target_metric_shift": relative_metric_shift(
                    high, center_target
                ),
                "expanded_operator_error": normalized_expanded_error(
                    actual, target
                ),
                "actual_metric": actual_metric.tolist(),
                "actual_signature": matrix_signature(actual_metric),
                "target_metric_error": metric_error,
            }
        )

    ledger = {
        name: residual_mean_ledger(values) for name, values in residuals.items()
    }
    actual_mean = {
        name: float(np.mean(regional.responses[name]))
        for name in REGIONAL_FIELD_NAMES
    }
    target_mean = {
        name: float(
            np.mean([record["target"]["operator_values"][name] for record in pivot_records])
        )
        for name in REGIONAL_FIELD_NAMES
    }
    mean_metric = metric_from_expanded(actual_mean)
    mean_target_metric = metric_from_expanded(target_mean)
    artifact = {
        "stage": stage,
        "claim_boundary": claim_boundary,
        "settings": {
            "seed": seed,
            "events": events,
            "minimum_pivots": minimum_pivots,
            "nonlocality_ratio": 0.20,
            "profile": {"name": "primary", "depth_zero": 0.02, "depth_one": 0.08},
        },
        "resource": {
            "build_seconds": build_seconds,
            "response_seconds": response_seconds,
            "cache_bytes": cache_bytes,
            "file_bytes": file_bytes,
            "expected_cache_bytes": packed_relation_bytes(len(points)),
        },
        "selection": {
            "pivot_count": len(regional.pivot_indices),
            "depth_threshold": regional.depth_threshold,
        },
        "target_gate": {
            "quadrature_passes": quadrature_passes,
            "target_signatures_pass": target_signatures_pass,
            "expanded_rows_finite": all(
                np.all(np.isfinite(values))
                for values in regional.responses.values()
            ),
            "exact_cache_size": cache_bytes == packed_relation_bytes(len(points)),
            "passes": (
                quadrature_passes
                and target_signatures_pass
                and cache_bytes == packed_relation_bytes(len(points))
            ),
        },
        "pivot_records": pivot_records,
        "within_graph_target_residual_ledger": ledger,
        "regional_mean": {
            "actual_operator_values": actual_mean,
            "target_operator_values": target_mean,
            "expanded_operator_error": normalized_expanded_error(
                actual_mean, target_mean
            ),
            "actual_metric": mean_metric.tolist(),
            "target_metric": mean_target_metric.tolist(),
            "metric_error": float(
                np.linalg.norm(mean_metric - mean_target_metric)
                / np.linalg.norm(mean_target_metric)
            ),
            "actual_signature": matrix_signature(mean_metric),
            "target_signature": matrix_signature(mean_target_metric),
        },
        "physical_pass_claimed": False,
    }
    return artifact


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--seed", type=int, default=20261550)
    parser.add_argument("--events", type=int, default=100000)
    parser.add_argument("--minimum-pivots", type=int, default=16)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(
            "AgentTasks/causal-selected-pivot-target-stage-a44p-2026-07-15.json"
        ),
    )
    args = parser.parse_args()
    if args.seed != 20261550 or args.events != 100000 or args.minimum_pivots != 16:
        raise ValueError("A44p settings are frozen")
    artifact = calibrate_selected_graph(
        args.seed, args.events, args.minimum_pivots
    )
    args.output.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "output": str(args.output),
                "target_gate_passes": artifact["target_gate"]["passes"],
                "regional_mean_metric_error": artifact["regional_mean"][
                    "metric_error"
                ],
                "physical_pass_claimed": False,
            }
        )
    )


if __name__ == "__main__":
    main()
