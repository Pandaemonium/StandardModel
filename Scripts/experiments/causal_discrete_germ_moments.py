"""Stage A42 discrete moments on flat marked Alexandrov germs.

One project-sign smeared causal-set operator row is evaluated at the center of
a flat four-dimensional marked diamond.  Order-only endpoint counts define the
same two cutoff profiles controlled in A41c.  Oracle polynomial fields are
compared with the frozen finite-scale continuum moments; no intrinsic
generator or curvature estimator is opened.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_continuum_kernel_moments import (
    C4,
    FIELD_NAMES,
    CutoffProfile,
    live_project_coefficient_error,
    smooth_depth_cutoff,
)
from causal_operator_metric import (
    diamond_volume_4d,
    project_convention_row,
    smeared_bd_row,
    sprinkle_minkowski_diamond,
    strictly_precedes,
)


@dataclass(frozen=True)
class MarkedRowData:
    row: np.ndarray
    cutoff: np.ndarray
    depth_ratio: np.ndarray
    past_count: int
    ell: float
    ell_over_nonlocality: float


@dataclass(frozen=True)
class DiscreteMomentSample:
    events: int
    realization: int
    spawn_key: list[int]
    cutoff: str
    nonlocality_ratio: float
    ell: float
    ell_over_nonlocality: float
    past_count: int
    operator_values: dict[str, float]
    target_values: dict[str, float]
    normalized_field_error: float
    metric_diagonal: list[float]
    target_metric_diagonal: list[float]
    metric_relative_error: float
    signature: tuple[int, int, int]
    target_signature: tuple[int, int, int]
    principal_symbol_mismatch: float
    target_principal_symbol_mismatch: float
    cutoff_at_bottom: float
    cutoff_at_pivot: float
    cutoff_at_top: float


def append_marked_events(
    random_points_with_top: np.ndarray,
    random_top_index: int,
    duration: float,
) -> tuple[np.ndarray, int, int, int]:
    """Add the bottom and center while retaining the sampler's top endpoint."""

    if random_top_index != len(random_points_with_top) - 1:
        raise ValueError("sampler top endpoint must be last")
    interior = random_points_with_top[:random_top_index]
    bottom = np.array([[0.0, 0.0, 0.0, 0.0]])
    pivot = np.array([[duration / 2.0, 0.0, 0.0, 0.0]])
    top = random_points_with_top[random_top_index:]
    points = np.concatenate((bottom, interior, pivot, top), axis=0)
    return points, 0, len(interior) + 1, len(interior) + 2


def marked_past_statistics(
    points: np.ndarray,
    pivot_index: int,
    block_size: int,
) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Compute only the order counts needed by one marked retarded row."""

    if block_size <= 0:
        raise ValueError("block size must be positive")
    pivot_past = strictly_precedes(points, points[pivot_index])
    past_indices = np.flatnonzero(pivot_past)
    past_size = len(past_indices)
    past_count = np.zeros(past_size, dtype=np.int64)
    future_count = np.zeros(past_size, dtype=np.int64)
    pivot_interval_count = np.zeros(past_size, dtype=np.int64)

    for start in range(0, past_size, block_size):
        stop = min(start + block_size, past_size)
        rows = past_indices[start:stop]
        relation = strictly_precedes(
            points[rows, None, :], points[None, :, :]
        )
        future_count[start:stop] = np.count_nonzero(relation, axis=1)
        pivot_interval_count[start:stop] = np.count_nonzero(
            relation[:, pivot_past], axis=1
        )
        past_count += np.count_nonzero(
            relation[:, past_indices], axis=0
        )
    return past_indices, past_count, future_count, pivot_interval_count


def marked_row_data(
    points: np.ndarray,
    bottom_index: int,
    pivot_index: int,
    top_index: int,
    events: int,
    duration: float,
    nonlocality_ratio: float,
    profile: CutoffProfile,
    block_size: int,
    statistics: tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray] | None = None,
) -> MarkedRowData:
    """Construct the project row and order-count cutoff for one marked germ."""

    radius = duration / 2.0
    physical_volume = diamond_volume_4d(duration)
    ell = (physical_volume / events) ** 0.25
    nonlocality_scale = nonlocality_ratio * radius
    if nonlocality_scale <= ell:
        raise ValueError("discrete setting requires ell < nonlocality scale")

    (
        past_indices,
        past_count,
        future_count,
        pivot_interval_count,
    ) = (
        marked_past_statistics(points, pivot_index, block_size)
        if statistics is None
        else statistics
    )
    interval_counts = np.zeros(len(points), dtype=np.int64)
    interval_counts[past_indices] = pivot_interval_count
    pivot_past = np.zeros(len(points), dtype=bool)
    pivot_past[past_indices] = True
    row = project_convention_row(
        smeared_bd_row(
            pivot_past,
            interval_counts,
            pivot_index,
            ell,
            nonlocality_scale,
        )
    )

    # For a strict interior event y, past_count includes p and future_count
    # includes q.  They therefore equal openCount+1 on the two endpoint sides.
    center_expected_count = C4 * radius**4 / ell**4
    depth_ratio = np.zeros(len(points), dtype=float)
    interior_past = past_indices != bottom_index
    depth_ratio[past_indices[interior_past]] = np.minimum(
        past_count[interior_past], future_count[interior_past]
    ) / center_expected_count
    cutoff = np.zeros(len(points), dtype=float)
    cutoff[past_indices] = smooth_depth_cutoff(
        depth_ratio[past_indices], profile
    )
    cutoff[bottom_index] = 0.0
    cutoff[pivot_index] = 1.0
    cutoff[top_index] = 0.0
    return MarkedRowData(
        row=row,
        cutoff=cutoff,
        depth_ratio=depth_ratio,
        past_count=len(past_indices),
        ell=float(ell),
        ell_over_nonlocality=float(ell / nonlocality_scale),
    )


def oracle_polynomial_fields(
    points: np.ndarray,
    pivot_index: int,
    cutoff: np.ndarray,
) -> dict[str, np.ndarray]:
    """Return the six A41c polynomial classes with exact zero extension."""

    centered = points - points[pivot_index]
    time = centered[:, 0]
    space = centered[:, 1]
    return {
        "constant": cutoff,
        "temporal_affine": cutoff * time,
        "temporal_quadratic": cutoff * time**2,
        "spatial_quadratic": cutoff * space**2,
        "temporal_cubic": cutoff * time**3,
        "temporal_spatial_cubic": cutoff * time * space**2,
    }


def metric_from_values(values: dict[str, float]) -> np.ndarray:
    return np.array(
        [
            0.5 * values["temporal_quadratic"],
            0.5 * values["spatial_quadratic"],
            0.5 * values["spatial_quadratic"],
            0.5 * values["spatial_quadratic"],
        ]
    )


def diagonal_signature(diagonal: np.ndarray) -> tuple[int, int, int]:
    tolerance = 1.0e-10
    return (
        int(np.count_nonzero(diagonal > tolerance)),
        int(np.count_nonzero(diagonal < -tolerance)),
        int(np.count_nonzero(np.abs(diagonal) <= tolerance)),
    )


def principal_symbol_mismatch(values: dict[str, float]) -> float:
    temporal = values["temporal_quadratic"]
    spatial = values["spatial_quadratic"]
    denominator = abs(temporal) + abs(spatial)
    if denominator <= 1.0e-14:
        return float("inf")
    return float(abs(temporal + spatial) / denominator)


def normalized_field_error(
    actual: dict[str, float], target: dict[str, float]
) -> float:
    residuals = np.array(
        [
            (actual[name] - target[name]) / max(1.0, abs(target[name]))
            for name in FIELD_NAMES
        ]
    )
    return float(np.linalg.norm(residuals) / np.sqrt(len(FIELD_NAMES)))


def metric_relative_error(actual: np.ndarray, target: np.ndarray) -> float:
    denominator = max(1.0e-14, float(np.linalg.norm(target)))
    return float(np.linalg.norm(actual - target) / denominator)


def load_continuum_targets(path: Path) -> dict[tuple[str, float], dict[str, float]]:
    artifact = json.loads(path.read_text(encoding="utf-8"))
    if artifact.get("stage") != "A41d" or not artifact.get("passes"):
        raise ValueError("A42 requires the passing A41d target artifact")
    if not artifact.get("conventions", {}).get("target_only"):
        raise ValueError("A42 target artifact must be marked target-only")
    targets: dict[tuple[str, float], dict[str, float]] = {}
    for setting in artifact["settings"]:
        cutoff = str(setting["cutoff"])
        ratio = float(setting["nonlocality_ratio"])
        if cutoff in {"primary", "robustness"} and ratio in {0.20, 0.16}:
            targets[(cutoff, ratio)] = {
                name: float(setting["high"]["operator_values"][name])
                for name in FIELD_NAMES
            }
    expected = {
        (cutoff, ratio)
        for cutoff in ("primary", "robustness")
        for ratio in (0.20, 0.16)
    }
    if set(targets) != expected:
        raise ValueError("A41d artifact lacks a required A42 target stratum")
    return targets


def reconstruct_realization(
    child_seed: np.random.SeedSequence,
    events: int,
    realization: int,
    duration: float,
    profiles: list[CutoffProfile],
    nonlocality_ratios: list[float],
    targets: dict[tuple[str, float], dict[str, float]],
    block_size: int,
) -> list[DiscreteMomentSample]:
    random_points, random_top = sprinkle_minkowski_diamond(
        np.random.default_rng(child_seed), events, duration
    )
    points, bottom, pivot, top = append_marked_events(
        random_points, random_top, duration
    )
    statistics = marked_past_statistics(points, pivot, block_size)
    samples: list[DiscreteMomentSample] = []
    for profile in profiles:
        for ratio in nonlocality_ratios:
            data = marked_row_data(
                points,
                bottom,
                pivot,
                top,
                events,
                duration,
                ratio,
                profile,
                block_size,
                statistics,
            )
            fields = oracle_polynomial_fields(points, pivot, data.cutoff)
            values = {
                name: float(data.row @ fields[name]) for name in FIELD_NAMES
            }
            target = targets[(profile.name, ratio)]
            metric = metric_from_values(values)
            target_metric = metric_from_values(target)
            samples.append(
                DiscreteMomentSample(
                    events=events,
                    realization=realization,
                    spawn_key=list(child_seed.spawn_key),
                    cutoff=profile.name,
                    nonlocality_ratio=ratio,
                    ell=data.ell,
                    ell_over_nonlocality=data.ell_over_nonlocality,
                    past_count=data.past_count,
                    operator_values=values,
                    target_values=target,
                    normalized_field_error=normalized_field_error(values, target),
                    metric_diagonal=metric.tolist(),
                    target_metric_diagonal=target_metric.tolist(),
                    metric_relative_error=metric_relative_error(
                        metric, target_metric
                    ),
                    signature=diagonal_signature(metric),
                    target_signature=diagonal_signature(target_metric),
                    principal_symbol_mismatch=principal_symbol_mismatch(values),
                    target_principal_symbol_mismatch=(
                        principal_symbol_mismatch(target)
                    ),
                    cutoff_at_bottom=float(data.cutoff[bottom]),
                    cutoff_at_pivot=float(data.cutoff[pivot]),
                    cutoff_at_top=float(data.cutoff[top]),
                )
            )
    return samples


def summarize_samples(samples: list[DiscreteMomentSample]) -> dict[str, object]:
    values = {
        name: np.array([sample.operator_values[name] for sample in samples])
        for name in FIELD_NAMES
    }
    mean_values = {name: float(np.mean(array)) for name, array in values.items()}
    standard_deviations = {
        name: float(np.std(array, ddof=1)) if len(array) > 1 else 0.0
        for name, array in values.items()
    }
    target = samples[0].target_values
    mean_metric = metric_from_values(mean_values)
    target_metric = metric_from_values(target)
    return {
        "events": samples[0].events,
        "cutoff": samples[0].cutoff,
        "nonlocality_ratio": samples[0].nonlocality_ratio,
        "realizations": len(samples),
        "ell_over_nonlocality": samples[0].ell_over_nonlocality,
        "mean_past_count": float(np.mean([sample.past_count for sample in samples])),
        "mean_operator_values": mean_values,
        "standard_deviations": standard_deviations,
        "target_values": target,
        "ensemble_mean_field_error": normalized_field_error(mean_values, target),
        "median_individual_field_error": float(
            np.median([sample.normalized_field_error for sample in samples])
        ),
        "ensemble_mean_metric_diagonal": mean_metric.tolist(),
        "target_metric_diagonal": target_metric.tolist(),
        "ensemble_mean_metric_error": metric_relative_error(
            mean_metric, target_metric
        ),
        "median_individual_metric_error": float(
            np.median([sample.metric_relative_error for sample in samples])
        ),
        "ensemble_mean_principal_symbol_mismatch": (
            principal_symbol_mismatch(mean_values)
        ),
        "target_principal_symbol_mismatch": (
            principal_symbol_mismatch(target)
        ),
        "signature_match_rate": float(
            np.mean(
                [sample.signature == sample.target_signature for sample in samples]
            )
        ),
        "all_scale_admissible": all(
            sample.ell_over_nonlocality < 1.0 for sample in samples
        ),
        "all_endpoint_cutoffs_exact": all(
            sample.cutoff_at_bottom == 0.0
            and sample.cutoff_at_pivot == 1.0
            and sample.cutoff_at_top == 0.0
            for sample in samples
        ),
    }


def run_split(
    seed: int,
    events_list: list[int],
    realizations: int,
    duration: float,
    profiles: list[CutoffProfile],
    nonlocality_ratios: list[float],
    targets: dict[tuple[str, float], dict[str, float]],
    block_size: int,
) -> tuple[list[DiscreteMomentSample], list[dict[str, object]]]:
    children = np.random.SeedSequence(seed).spawn(len(events_list) * realizations)
    samples: list[DiscreteMomentSample] = []
    child_index = 0
    for events in events_list:
        for realization in range(realizations):
            samples.extend(
                reconstruct_realization(
                    children[child_index],
                    events,
                    realization,
                    duration,
                    profiles,
                    nonlocality_ratios,
                    targets,
                    block_size,
                )
            )
            child_index += 1
    summaries: list[dict[str, object]] = []
    for events in events_list:
        for profile in profiles:
            for ratio in nonlocality_ratios:
                selected = [
                    sample
                    for sample in samples
                    if sample.events == events
                    and sample.cutoff == profile.name
                    and sample.nonlocality_ratio == ratio
                ]
                summaries.append(summarize_samples(selected))
    return samples, summaries


def heldout_gate(summaries: list[dict[str, object]]) -> dict[str, object]:
    checks: dict[str, dict[str, bool | float]] = {}
    for cutoff in ("primary", "robustness"):
        for ratio in (0.20, 0.16):
            key = f"{cutoff}|L={ratio:.2f}"
            low = next(
                item
                for item in summaries
                if item["events"] == 5000
                and item["cutoff"] == cutoff
                and item["nonlocality_ratio"] == ratio
            )
            high = next(
                item
                for item in summaries
                if item["events"] == 20000
                and item["cutoff"] == cutoff
                and item["nonlocality_ratio"] == ratio
            )
            field_improvement = 1.0 - (
                float(high["ensemble_mean_field_error"])
                / float(low["ensemble_mean_field_error"])
            )
            metric_improvement = 1.0 - (
                float(high["ensemble_mean_metric_error"])
                / float(low["ensemble_mean_metric_error"])
            )
            delta_difference = abs(
                float(high["ensemble_mean_principal_symbol_mismatch"])
                - float(high["target_principal_symbol_mismatch"])
            )
            stratum_checks = {
                "scale_and_cutoff": bool(
                    high["all_scale_admissible"]
                    and high["all_endpoint_cutoffs_exact"]
                ),
                "field_error": float(high["ensemble_mean_field_error"]) < 0.20,
                "metric_error": float(high["ensemble_mean_metric_error"]) < 0.15,
                "field_improvement": field_improvement >= 0.20,
                "metric_improvement": metric_improvement >= 0.20,
                "principal_symbol": delta_difference < 0.08,
                "signature": float(high["signature_match_rate"]) >= 0.75,
            }
            checks[key] = {
                "passes": all(stratum_checks.values()),
                "field_error_reduction": field_improvement,
                "metric_error_reduction": metric_improvement,
                "principal_symbol_difference": delta_difference,
                **stratum_checks,
            }
    return {
        "coefficient_convention": live_project_coefficient_error() < 1.0e-12,
        "strata": checks,
        "passes": (
            live_project_coefficient_error() < 1.0e-12
            and all(bool(item["passes"]) for item in checks.values())
        ),
    }


def write_artifact(
    output: Path,
    split: str,
    seed: int,
    events: list[int],
    realizations: int,
    samples: list[DiscreteMomentSample],
    summaries: list[dict[str, object]],
    gate: dict[str, object] | None,
    args: argparse.Namespace,
) -> None:
    artifact = {
        "stage": "A42",
        "split": split,
        "claim_boundary": "flat oracle discrete-moment control; not intrinsic GR",
        "settings": {
            "seed": seed,
            "events": events,
            "realizations_per_density": realizations,
            "duration": args.duration,
            "nonlocality_ratios": args.nonlocality_ratios,
            "profiles": [
                asdict(CutoffProfile("primary", 0.02, 0.08)),
                asdict(CutoffProfile("robustness", 0.04, 0.12)),
            ],
            "block_size": args.block_size,
            "continuum_target": str(args.continuum_target),
            "live_project_coefficient_relative_error": (
                live_project_coefficient_error()
            ),
        },
        "gate": gate,
        "summaries": summaries,
        "samples": [asdict(sample) for sample in samples],
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--split", choices=("development", "heldout"), required=True)
    parser.add_argument("--duration", type=float, default=2.0)
    parser.add_argument(
        "--nonlocality-ratios", type=float, nargs="+", default=[0.20, 0.16]
    )
    parser.add_argument("--block-size", type=int, default=64)
    parser.add_argument(
        "--continuum-target",
        type=Path,
        default=Path(
            "AgentTasks/causal-continuum-kernel-moments-stage-a41d-2026-07-15.json"
        ),
    )
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    profiles = [
        CutoffProfile("primary", 0.02, 0.08),
        CutoffProfile("robustness", 0.04, 0.12),
    ]
    targets = load_continuum_targets(args.continuum_target)
    if args.split == "development":
        seed = 20261460
        events = [5000, 10000]
        realizations = 2
    else:
        seed = 20261470
        events = [5000, 10000, 20000]
        realizations = 4
    samples, summaries = run_split(
        seed,
        events,
        realizations,
        args.duration,
        profiles,
        args.nonlocality_ratios,
        targets,
        args.block_size,
    )
    gate = heldout_gate(summaries) if args.split == "heldout" else None
    output = args.output or Path(
        f"AgentTasks/causal-discrete-germ-moments-stage-a42-{args.split}-2026-07-15.json"
    )
    write_artifact(
        output,
        args.split,
        seed,
        events,
        realizations,
        samples,
        summaries,
        gate,
        args,
    )
    print(
        json.dumps(
            {
                "output": str(output),
                "passes": None if gate is None else gate["passes"],
            }
        )
    )


if __name__ == "__main__":
    main()
