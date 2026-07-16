"""Stage A44r resource gate for reusable exact regional relation counts.

This development-only benchmark times one bit-packed strict-order construction
and several order-selected compact rows. It does not score physical
concentration or authorize the extrapolated large run.
"""

from __future__ import annotations

import argparse
import json
import platform
import shutil
import tempfile
import time
from pathlib import Path

import numpy as np

from causal_continuum_kernel_moments import CutoffProfile
from causal_discrete_germ_moments import (
    append_marked_events,
    marked_past_statistics,
)
from causal_operator_metric import sprinkle_minkowski_diamond
from causal_regional_operator_covariance import regional_pivot_responses
from causal_reusable_relation import (
    build_packed_causal_relation,
    packed_relation_bytes,
    relation_scratch_upper_bound_bytes,
)


def quadratic_extrapolation(
    measured: dict[str, object], target_events: int, target_pivots: int
) -> dict[str, float | int]:
    """Return an explicit quadratic scaling estimate, not a performance proof."""

    measured_events = int(measured["total_points"])
    measured_pivots = int(measured["selected_pivots"])
    target_points = target_events + 3
    size_factor = (target_points / measured_events) ** 2
    pivot_factor = target_pivots / measured_pivots
    build_seconds = float(measured["build_seconds"]) * size_factor
    response_seconds = (
        float(measured["response_seconds"]) * size_factor * pivot_factor
    )
    return {
        "target_random_events": target_events,
        "target_total_points": target_points,
        "target_pivots": target_pivots,
        "packed_relation_bytes": packed_relation_bytes(target_points),
        "projected_build_seconds": build_seconds,
        "projected_response_seconds": response_seconds,
        "projected_total_seconds": build_seconds + response_seconds,
    }


def benchmark_density(
    child_seed: np.random.SeedSequence,
    random_events: int,
    duration: float,
    minimum_pivots: int,
    row_block_size: int,
    column_block_size: int,
    popcount_block_size: int,
    cache_path: Path,
) -> dict[str, object]:
    """Build one cache and time the unchanged regional response pipeline."""

    random_points, random_top = sprinkle_minkowski_diamond(
        np.random.default_rng(child_seed), random_events, duration
    )
    points, bottom, _, top = append_marked_events(
        random_points, random_top, duration
    )

    build_start = time.perf_counter()
    cache = build_packed_causal_relation(
        points,
        row_block_size,
        column_block_size,
        cache_path,
    )
    build_seconds = time.perf_counter() - build_start

    response_start = time.perf_counter()
    regional = regional_pivot_responses(
        points,
        bottom,
        top,
        random_events,
        duration,
        0.20,
        CutoffProfile("primary", 0.02, 0.08),
        minimum_pivots,
        popcount_block_size,
        cache,
    )
    response_seconds = time.perf_counter() - response_start

    direct_count_match: bool | None = None
    if random_events == 5000:
        pivot = regional.pivot_indices[0]
        direct = marked_past_statistics(points, pivot, popcount_block_size)
        reused = cache.marked_past_statistics(pivot, popcount_block_size)
        direct_count_match = all(
            np.array_equal(actual, expected)
            for actual, expected in zip(reused, direct)
        )

    all_responses_finite = all(
        np.all(np.isfinite(values)) for values in regional.responses.values()
    )
    cache_file_bytes = cache_path.stat().st_size
    cache_storage_bytes = cache.storage_bytes
    cache.close()
    cache_path.unlink()
    total_points = len(points)
    return {
        "random_events": random_events,
        "total_points": total_points,
        "spawn_key": list(child_seed.spawn_key),
        "build_seconds": build_seconds,
        "response_seconds": response_seconds,
        "selected_pivots": len(regional.pivot_indices),
        "depth_threshold": regional.depth_threshold,
        "minimum_selected_depth": min(regional.pivot_depths),
        "cache_storage_bytes": cache_storage_bytes,
        "cache_file_bytes": cache_file_bytes,
        "expected_cache_bytes": packed_relation_bytes(total_points),
        "dense_boolean_bytes": total_points**2,
        "compression_ratio_vs_dense_boolean": (
            total_points**2 / cache_storage_bytes
        ),
        "direct_count_match": direct_count_match,
        "all_responses_finite": bool(all_responses_finite),
    }


def evaluate_gate(
    results: list[dict[str, object]],
    extrapolation: dict[str, float | int],
    scratch_bytes: int,
) -> dict[str, object]:
    gib = 1024**3
    checks = {
        "small_direct_count_match": results[0]["direct_count_match"] is True,
        "exact_raw_storage": all(
            item["cache_storage_bytes"] == item["expected_cache_bytes"]
            and item["cache_file_bytes"] == item["expected_cache_bytes"]
            for item in results
        ),
        "minimum_pivots": all(item["selected_pivots"] >= 8 for item in results),
        "finite_responses": all(item["all_responses_finite"] for item in results),
        "target_storage_at_most_24_gib": (
            extrapolation["packed_relation_bytes"] <= 24 * gib
        ),
        "scratch_at_most_512_mib": scratch_bytes <= 512 * 1024**2,
        "projected_total_at_most_12_hours": (
            extrapolation["projected_total_seconds"] <= 12 * 3600
        ),
    }
    return {
        "checks": checks,
        "prototype_passes": all(checks.values()),
        "large_run_authorized": False,
        "authorization_blockers": [
            "no measured N=100000 scaling point",
            "physical density and pivot schedule not frozen",
            "full same-graph covariance concentration not tested",
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--seed", type=int, default=20261520)
    parser.add_argument("--events", type=int, nargs="+", default=[5000, 10000, 20000])
    parser.add_argument("--duration", type=float, default=2.0)
    parser.add_argument("--minimum-pivots", type=int, default=8)
    parser.add_argument("--row-block-size", type=int, default=32)
    parser.add_argument("--column-block-size", type=int, default=4096)
    parser.add_argument("--popcount-block-size", type=int, default=128)
    parser.add_argument("--target-events", type=int, default=400000)
    parser.add_argument("--target-pivots", type=int, default=256)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(
            "AgentTasks/causal-reusable-relation-stage-a44r-2026-07-15.json"
        ),
    )
    args = parser.parse_args()
    if args.events != [5000, 10000, 20000]:
        raise ValueError("A44r event settings are frozen")

    children = np.random.SeedSequence(args.seed).spawn(len(args.events))
    with tempfile.TemporaryDirectory(prefix="a44r-") as temp_dir:
        temp_path = Path(temp_dir)
        disk_before = shutil.disk_usage(temp_path)
        results = [
            benchmark_density(
                child,
                events,
                args.duration,
                args.minimum_pivots,
                args.row_block_size,
                args.column_block_size,
                args.popcount_block_size,
                temp_path / f"relation-{events}.bin",
            )
            for child, events in zip(children, args.events)
        ]

    extrapolation = quadratic_extrapolation(
        results[-1], args.target_events, args.target_pivots
    )
    scratch_bytes = relation_scratch_upper_bound_bytes(
        args.row_block_size, args.column_block_size
    )
    gate = evaluate_gate(results, extrapolation, scratch_bytes)
    artifact = {
        "stage": "A44r",
        "claim_boundary": (
            "development-only exactness/resource gate; not concentration or GR"
        ),
        "settings": {
            "seed": args.seed,
            "events": args.events,
            "duration": args.duration,
            "minimum_pivots": args.minimum_pivots,
            "row_block_size": args.row_block_size,
            "column_block_size": args.column_block_size,
            "popcount_block_size": args.popcount_block_size,
            "target_events_extrapolation_only": args.target_events,
            "target_pivots_extrapolation_only": args.target_pivots,
        },
        "environment": {
            "python": platform.python_version(),
            "platform": platform.platform(),
            "numpy": np.__version__,
            "temporary_volume_free_bytes_before": disk_before.free,
        },
        "scratch_upper_bound_bytes": scratch_bytes,
        "results": results,
        "quadratic_extrapolation": extrapolation,
        "gate": gate,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "output": str(args.output),
                "prototype_passes": gate["prototype_passes"],
                "large_run_authorized": gate["large_run_authorized"],
            }
        )
    )


if __name__ == "__main__":
    main()
