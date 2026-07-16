"""Stage A44r2 measured N=100000 scaling gate for the packed relation cache."""

from __future__ import annotations

import argparse
import json
import shutil
import tempfile
from pathlib import Path

import numpy as np

from causal_regional_resource_gate import (
    benchmark_density,
    quadratic_extrapolation,
)
from causal_reusable_relation import packed_relation_bytes


def predicted_from_baseline(
    baseline: dict[str, object], target_total_points: int, target_pivots: int
) -> dict[str, float]:
    size_factor = (target_total_points / int(baseline["total_points"])) ** 2
    pivot_factor = target_pivots / int(baseline["selected_pivots"])
    return {
        "build_seconds": float(baseline["build_seconds"]) * size_factor,
        "response_seconds": (
            float(baseline["response_seconds"]) * size_factor * pivot_factor
        ),
    }


def evaluate_scaling_gate(
    result: dict[str, object],
    prediction: dict[str, float],
    extrapolation: dict[str, float | int],
    free_bytes_before: int,
) -> dict[str, object]:
    checks = {
        "exact_raw_storage": (
            result["cache_storage_bytes"] == result["expected_cache_bytes"]
            and result["cache_file_bytes"] == result["expected_cache_bytes"]
        ),
        "temporary_volume_margin": (
            free_bytes_before >= 2 * int(result["expected_cache_bytes"])
        ),
        "minimum_pivots": int(result["selected_pivots"]) >= 16,
        "finite_responses": bool(result["all_responses_finite"]),
        "build_within_factor_three": (
            float(result["build_seconds"]) <= 3 * prediction["build_seconds"]
        ),
        "response_within_factor_three": (
            float(result["response_seconds"])
            <= 3 * prediction["response_seconds"]
        ),
        "large_storage_at_most_24_gib": (
            int(extrapolation["packed_relation_bytes"]) <= 24 * 1024**3
        ),
        "large_projection_at_most_12_hours": (
            float(extrapolation["projected_total_seconds"]) <= 12 * 3600
        ),
    }
    return {
        "checks": checks,
        "resource_precondition_passes": all(checks.values()),
        "large_run_authorized": False,
        "physical_stage_authorized": False,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--seed", type=int, default=20261530)
    parser.add_argument("--events", type=int, default=100000)
    parser.add_argument("--minimum-pivots", type=int, default=16)
    parser.add_argument(
        "--baseline",
        type=Path,
        default=Path(
            "AgentTasks/causal-reusable-relation-stage-a44r-2026-07-15.json"
        ),
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(
            "AgentTasks/causal-reusable-relation-stage-a44r2-2026-07-15.json"
        ),
    )
    args = parser.parse_args()
    if args.seed != 20261530 or args.events != 100000 or args.minimum_pivots != 16:
        raise ValueError("A44r2 settings are frozen")

    baseline_artifact = json.loads(args.baseline.read_text(encoding="utf-8"))
    if baseline_artifact.get("stage") != "A44r":
        raise ValueError("A44r2 requires the A44r baseline artifact")
    if not baseline_artifact["gate"]["prototype_passes"]:
        raise ValueError("A44r baseline did not pass")
    baseline = baseline_artifact["results"][-1]
    target_total_points = args.events + 3
    prediction = predicted_from_baseline(
        baseline, target_total_points, args.minimum_pivots
    )

    child = np.random.SeedSequence(args.seed).spawn(1)[0]
    with tempfile.TemporaryDirectory(prefix="a44r2-") as temp_dir:
        temp_path = Path(temp_dir)
        free_bytes_before = shutil.disk_usage(temp_path).free
        expected = packed_relation_bytes(target_total_points)
        if free_bytes_before < 2 * expected:
            raise RuntimeError("temporary volume lacks the frozen two-cache margin")
        result = benchmark_density(
            child,
            args.events,
            2.0,
            args.minimum_pivots,
            32,
            4096,
            128,
            temp_path / "relation-100000.bin",
        )

    extrapolation = quadratic_extrapolation(result, 400000, 256)
    gate = evaluate_scaling_gate(
        result, prediction, extrapolation, free_bytes_before
    )
    artifact = {
        "stage": "A44r2",
        "claim_boundary": "measured resource scaling; not physical concentration",
        "settings": {
            "seed": args.seed,
            "events": args.events,
            "minimum_pivots": args.minimum_pivots,
            "duration": 2.0,
            "row_block_size": 32,
            "column_block_size": 4096,
            "popcount_block_size": 128,
        },
        "free_bytes_before": free_bytes_before,
        "prediction_from_a44r": prediction,
        "result": result,
        "quadratic_extrapolation": extrapolation,
        "gate": gate,
    }
    args.output.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "output": str(args.output),
                "resource_precondition_passes": gate[
                    "resource_precondition_passes"
                ],
                "large_run_authorized": gate["large_run_authorized"],
            }
        )
    )


if __name__ == "__main__":
    main()
