"""Stage A44t deterministic audit of off-center finite continuum targets."""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict
from pathlib import Path

import numpy as np

from causal_continuum_kernel_moments import CutoffProfile
from causal_offcenter_continuum_targets import (
    OffCenterMomentResult,
    offcenter_continuum_operator_moments,
    result_difference,
)


PIVOTS = {
    "center": [1.0, 0.0, 0.0, 0.0],
    "time-0.05": [0.95, 0.0, 0.0, 0.0],
    "time+0.05": [1.05, 0.0, 0.0, 0.0],
    "space-0.05": [1.0, 0.05, 0.0, 0.0],
    "space-0.10": [1.0, 0.10, 0.0, 0.0],
    "space-0.15": [1.0, 0.15, 0.0, 0.0],
    "mixed-0.05+0.10": [0.95, 0.10, 0.0, 0.0],
    "mixed+0.05+0.10": [1.05, 0.10, 0.0, 0.0],
}


def six_channels(result: OffCenterMomentResult) -> dict[str, float]:
    values = result.operator_values
    return {
        "constant": values["constant"],
        "temporal_affine": values["affine_t"],
        "temporal_quadratic": values["quadratic_t_t"],
        "spatial_quadratic": values["quadratic_x_x"],
        "temporal_cubic": values["cubic_t_t_t"],
        "temporal_spatial_cubic": values["cubic_t_x_x"],
    }


def normalized_channel_shift(
    actual: OffCenterMomentResult, center: OffCenterMomentResult
) -> float:
    actual_values = six_channels(actual)
    center_values = six_channels(center)
    residuals = np.array(
        [
            (actual_values[name] - center_values[name])
            / max(1.0, abs(center_values[name]))
            for name in center_values
        ]
    )
    return float(np.linalg.norm(residuals) / np.sqrt(len(residuals)))


def relative_metric_shift(
    actual: OffCenterMomentResult, center: OffCenterMomentResult
) -> float:
    actual_metric = np.asarray(actual.metric)
    center_metric = np.asarray(center.metric)
    return float(
        np.linalg.norm(actual_metric - center_metric)
        / np.linalg.norm(center_metric)
    )


def evaluate_audit(
    low: dict[str, OffCenterMomentResult],
    high: dict[str, OffCenterMomentResult],
) -> dict[str, object]:
    center = high["center"]
    settings: dict[str, object] = {}
    for name in PIVOTS:
        difference = result_difference(low[name], high[name])
        settings[name] = {
            "low": asdict(low[name]),
            "high": asdict(high[name]),
            "quadrature_difference": difference,
            "normalized_six_channel_shift_from_center": (
                normalized_channel_shift(high[name], center)
            ),
            "relative_metric_shift_from_center": (
                relative_metric_shift(high[name], center)
            ),
        }
    quadrature_passes = all(
        item["quadrature_difference"]["maximum_operator_absolute"] < 0.02
        and item["quadrature_difference"]["metric_frobenius"] < 0.02
        for item in settings.values()
    )
    signature_passes = all(
        tuple(item["high"]["signature"]) == (1, 3, 0)
        for item in settings.values()
    )
    reuse_names = ("time-0.05", "time+0.05", "space-0.05")
    center_reusable_through_005 = all(
        settings[name]["normalized_six_channel_shift_from_center"] < 0.05
        and settings[name]["relative_metric_shift_from_center"] < 0.05
        for name in reuse_names
    )
    return {
        "settings": settings,
        "gate": {
            "quadrature_passes": quadrature_passes,
            "signature_passes": signature_passes,
            "center_reusable_through_0.05": center_reusable_through_005,
            "passes": quadrature_passes and signature_passes,
            "per_pivot_target_required": not center_reusable_through_005,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(
            "AgentTasks/causal-offcenter-target-stage-a44t-2026-07-15.json"
        ),
    )
    args = parser.parse_args()
    profile = CutoffProfile("primary", 0.02, 0.08)
    low = {
        name: offcenter_continuum_operator_moments(
            np.asarray(pivot),
            0.20,
            profile,
            retarded_time_order=28,
            proper_order=36,
            polar_order=10,
            azimuth_order=12,
        )
        for name, pivot in PIVOTS.items()
    }
    high = {
        name: offcenter_continuum_operator_moments(
            np.asarray(pivot),
            0.20,
            profile,
            retarded_time_order=40,
            proper_order=52,
            polar_order=14,
            azimuth_order=16,
        )
        for name, pivot in PIVOTS.items()
    }
    audit = evaluate_audit(low, high)
    artifact = {
        "stage": "A44t",
        "claim_boundary": "deterministic finite-target audit; not graph data",
        "profile": {"name": "primary", "depth_zero": 0.02, "depth_one": 0.08},
        "nonlocality_ratio": 0.20,
        **audit,
    }
    args.output.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "output": str(args.output),
                **artifact["gate"],
            }
        )
    )


if __name__ == "__main__":
    main()
