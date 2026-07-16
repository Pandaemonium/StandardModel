"""Stage A24 count-volume reconstruction of the local conformal Weyl factor.

For the conformal de Sitter controls

    g = a(t)^2 eta,   a(t) = 1 / (1 - H t),

causal order fixes the supplied conformal class while physical event counts
carry the volume form.  This experiment estimates ``a^4`` from counts in local
coordinate Alexandrov windows and hence reconstructs the inverse-metric Weyl
factor ``a^-2``.

The coordinate-window half-duration and center radius obey

    W = c_W sqrt(ell_coord T),   C = c_C W.

Thus both scales shrink while each window's expected event count grows under
density refinement.  A random Poisson thinning supplies disjoint fit-count and
pivot-validation subsets.  Development chooses multipliers using flat controls
only; curved scale and first-gradient targets remain unopened during selection.

Coordinates are used to place the synthetic windows and centers, and the
conformal class ``eta`` is supplied.  This is a scale-reconstruction oracle,
not an intrinsic bare-order construction.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_conformal_multirow_metric import (
    append_interior_pivot,
    target_inverse_metric_at,
)
from causal_conformal_operator_metric import (
    conformal_diamond_volume,
    sprinkle_conformal_de_sitter_diamond,
    validate_background,
)
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    diamond_volume_4d,
    finite_statistics,
    matrix_relative_error,
    signature,
    strictly_precedes,
)


@dataclass(frozen=True)
class CountWindowScales:
    coordinate_ell: float
    coordinate_window_half_duration: float
    coordinate_center_radius: float


@dataclass(frozen=True)
class CountWeylSample:
    hubble: float
    duration: float
    window_multiplier: float
    center_multiplier: float
    coordinate_ell: float
    coordinate_window_half_duration: float
    coordinate_center_radius: float
    center_count: int
    minimum_fit_window_count: int
    median_fit_window_count: float
    pivot_validation_count: int
    design_rank: int
    design_condition: float
    inverse_metric_weyl_factor: float
    target_inverse_metric_weyl_factor: float
    factor_relative_error: float
    inverse_metric: list[list[float]]
    target_inverse_metric: list[list[float]]
    metric_relative_error: float
    metric_signature: tuple[int, int, int]
    metric_volume_density: float
    target_volume_density: float
    oracle_volume_relative_error: float
    independent_count_volume_density: float
    count_metric_volume_relative_mismatch: float
    factor_first_gradient: list[float]
    target_factor_first_gradient: list[float]
    first_gradient_dimensionless_error: float
    temporal_gradient_relative_error: float | None
    spatial_gradient_dimensionless_noise: float


def count_window_scales(
    coordinate_ell: float,
    duration: float,
    window_multiplier: float,
    center_multiplier: float,
) -> CountWindowScales:
    if coordinate_ell <= 0.0 or duration <= 0.0:
        raise ValueError("coordinate ell and duration must be positive")
    if window_multiplier <= 0.0 or center_multiplier <= 0.0:
        raise ValueError("count-window multipliers must be positive")
    window = window_multiplier * np.sqrt(coordinate_ell * duration)
    center_radius = center_multiplier * window
    return CountWindowScales(
        coordinate_ell=coordinate_ell,
        coordinate_window_half_duration=float(window),
        coordinate_center_radius=float(center_radius),
    )


def window_fits_coordinate_diamond(
    center: np.ndarray,
    coordinate_half_duration: float,
    duration: float,
) -> bool:
    if coordinate_half_duration <= 0.0:
        return False
    lower_time = center[0] - coordinate_half_duration
    upper_time = center[0] + coordinate_half_duration
    if lower_time <= 0.0 or upper_time >= duration:
        return False
    spatial_radius = float(np.linalg.norm(center[1:]))
    return spatial_radius < min(lower_time, duration - upper_time)


def local_count_volume_factor(
    count_points: np.ndarray,
    count_density: float,
    center: np.ndarray,
    coordinate_half_duration: float,
    duration: float,
) -> tuple[int, float, float]:
    """Estimate ``a^-2`` and ``a^4`` from one local count window."""

    if count_density <= 0.0:
        raise ValueError("count density must be positive")
    if not window_fits_coordinate_diamond(
        center, coordinate_half_duration, duration
    ):
        raise ValueError("local count window leaves the sampled diamond")
    lower = center.copy()
    upper = center.copy()
    lower[0] -= coordinate_half_duration
    upper[0] += coordinate_half_duration
    inside = strictly_precedes(lower, count_points) & strictly_precedes(
        count_points, upper
    )
    same_as_center = np.all(np.isclose(count_points, center, atol=0.0), axis=1)
    count = int(np.count_nonzero(inside & ~same_as_center))
    if count <= 0:
        raise ValueError("local count window is empty")
    coordinate_volume = diamond_volume_4d(2.0 * coordinate_half_duration)
    volume_density = count / (count_density * coordinate_volume)
    factor = 1.0 / np.sqrt(volume_density)
    return count, float(factor), float(volume_density)


def select_count_centers(
    points: np.ndarray,
    candidate_indices: np.ndarray,
    pivot_index: int,
    coordinate_center_radius: float,
    coordinate_window_half_duration: float,
    duration: float,
    maximum_centers: int,
) -> np.ndarray:
    pivot = points[pivot_index]
    distances = np.linalg.norm(points[candidate_indices] - pivot, axis=1)
    nearby = candidate_indices[distances <= coordinate_center_radius]
    retained: list[int] = []
    for index in nearby:
        center = points[int(index)]
        if window_fits_coordinate_diamond(
            center, coordinate_window_half_duration, duration
        ):
            retained.append(int(index))
    if len(retained) > maximum_centers:
        retained_array = np.array(retained, dtype=int)
        retained_distance = np.linalg.norm(points[retained_array] - pivot, axis=1)
        order = np.argsort(retained_distance, kind="stable")
        retained = retained_array[order[:maximum_centers]].tolist()
    return np.array(sorted(retained), dtype=int)


def fit_affine_factor_field(
    points: np.ndarray,
    pivot_index: int,
    centers: np.ndarray,
    factors: np.ndarray,
) -> tuple[float, np.ndarray, int, float]:
    if factors.shape != (len(centers),):
        raise ValueError("factor values must align with centers")
    offsets = points[centers] - points[pivot_index]
    design = np.column_stack((np.ones(len(centers)), offsets))
    coefficients, _, rank, singular_values = np.linalg.lstsq(
        design, factors, rcond=None
    )
    condition = (
        float("inf")
        if len(singular_values) < 5 or singular_values[-1] <= 0.0
        else float(singular_values[0] / singular_values[-1])
    )
    return float(coefficients[0]), coefficients[1:], int(rank), condition


def setting_key(window_multiplier: float, center_multiplier: float) -> str:
    return f"cW={window_multiplier:.6f}|cC={center_multiplier:.6f}"


def reconstruct_count_weyl_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    hubble: float,
    window_multipliers: list[float],
    center_multipliers: list[float],
    maximum_centers: int,
    pivot_fraction: float,
) -> list[CountWeylSample]:
    points, top_index = sprinkle_conformal_de_sitter_diamond(
        rng, events, duration, hubble
    )
    points, pivot_index, _ = append_interior_pivot(
        points, top_index, duration, pivot_fraction
    )
    random_indices = np.arange(events)
    shuffled = rng.permutation(random_indices)
    split = events // 2
    fit_indices = np.sort(shuffled[:split])
    validation_indices = np.sort(shuffled[split:])
    physical_volume = conformal_diamond_volume(duration, hubble)
    coordinate_ell = (diamond_volume_4d(duration) / events) ** 0.25
    fit_density = len(fit_indices) / physical_volume
    validation_density = len(validation_indices) / physical_volume
    pivot_time = pivot_fraction * duration
    target_metric = target_inverse_metric_at(pivot_time, hubble)
    target_factor = float((1.0 - hubble * pivot_time) ** 2)
    target_gradient = np.zeros(4, dtype=float)
    target_gradient[0] = -2.0 * hubble * (1.0 - hubble * pivot_time)
    target_volume = 1.0 / target_factor**2

    samples: list[CountWeylSample] = []
    for c_w in window_multipliers:
        for c_c in center_multipliers:
            scales = count_window_scales(
                coordinate_ell, duration, c_w, c_c
            )
            centers = select_count_centers(
                points,
                random_indices,
                pivot_index,
                scales.coordinate_center_radius,
                scales.coordinate_window_half_duration,
                duration,
                maximum_centers,
            )
            if len(centers) < 5:
                raise ValueError("fewer than five admissible count centers")
            counts: list[int] = []
            factors: list[float] = []
            for center_index in centers:
                count, factor, _ = local_count_volume_factor(
                    points[fit_indices],
                    fit_density,
                    points[int(center_index)],
                    scales.coordinate_window_half_duration,
                    duration,
                )
                counts.append(count)
                factors.append(factor)
            factor, gradient, rank, condition = fit_affine_factor_field(
                points,
                pivot_index,
                centers,
                np.array(factors),
            )
            pivot_count, _, pivot_count_volume = local_count_volume_factor(
                points[validation_indices],
                validation_density,
                points[pivot_index],
                scales.coordinate_window_half_duration,
                duration,
            )
            if factor <= 0.0:
                raise ValueError("affine count fit produced a nonpositive Weyl factor")
            inverse_metric = factor * MINKOWSKI_INVERSE
            metric_volume = 1.0 / factor**2
            temporal_target = target_gradient[0]
            samples.append(
                CountWeylSample(
                    hubble=hubble,
                    duration=duration,
                    window_multiplier=c_w,
                    center_multiplier=c_c,
                    coordinate_ell=coordinate_ell,
                    coordinate_window_half_duration=(
                        scales.coordinate_window_half_duration
                    ),
                    coordinate_center_radius=scales.coordinate_center_radius,
                    center_count=len(centers),
                    minimum_fit_window_count=min(counts),
                    median_fit_window_count=float(np.median(counts)),
                    pivot_validation_count=pivot_count,
                    design_rank=rank,
                    design_condition=condition,
                    inverse_metric_weyl_factor=factor,
                    target_inverse_metric_weyl_factor=target_factor,
                    factor_relative_error=abs(factor - target_factor) / target_factor,
                    inverse_metric=inverse_metric.tolist(),
                    target_inverse_metric=target_metric.tolist(),
                    metric_relative_error=matrix_relative_error(
                        inverse_metric, target_metric
                    ),
                    metric_signature=signature(inverse_metric),
                    metric_volume_density=metric_volume,
                    target_volume_density=target_volume,
                    oracle_volume_relative_error=abs(metric_volume - target_volume)
                    / target_volume,
                    independent_count_volume_density=pivot_count_volume,
                    count_metric_volume_relative_mismatch=(
                        abs(metric_volume - pivot_count_volume) / pivot_count_volume
                    ),
                    factor_first_gradient=gradient.tolist(),
                    target_factor_first_gradient=target_gradient.tolist(),
                    first_gradient_dimensionless_error=float(
                        duration * np.linalg.norm(gradient - target_gradient)
                        / target_factor
                    ),
                    temporal_gradient_relative_error=(
                        None
                        if temporal_target == 0.0
                        else abs(gradient[0] - temporal_target)
                        / abs(temporal_target)
                    ),
                    spatial_gradient_dimensionless_noise=float(
                        duration * np.linalg.norm(gradient[1:]) / target_factor
                    ),
                )
            )
    return samples


def summarize_samples(samples: list[CountWeylSample]) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize an empty count-Weyl sample")
    factors = np.array([sample.inverse_metric_weyl_factor for sample in samples])
    gradients = np.array([sample.factor_first_gradient for sample in samples])
    target_factor = samples[0].target_inverse_metric_weyl_factor
    target_gradient = np.array(samples[0].target_factor_first_gradient)
    duration = samples[0].duration
    temporal_target = target_gradient[0]
    return {
        "hubble": samples[0].hubble,
        "duration": duration,
        "window_multiplier": samples[0].window_multiplier,
        "center_multiplier": samples[0].center_multiplier,
        "coordinate_window_half_duration": (
            samples[0].coordinate_window_half_duration
        ),
        "coordinate_center_radius": samples[0].coordinate_center_radius,
        "center_count": finite_statistics(
            [float(sample.center_count) for sample in samples]
        ),
        "minimum_fit_window_count": finite_statistics(
            [float(sample.minimum_fit_window_count) for sample in samples]
        ),
        "median_fit_window_count": finite_statistics(
            [sample.median_fit_window_count for sample in samples]
        ),
        "pivot_validation_count": finite_statistics(
            [float(sample.pivot_validation_count) for sample in samples]
        ),
        "design_condition": finite_statistics(
            [sample.design_condition for sample in samples]
        ),
        "ensemble_mean_factor": float(np.mean(factors)),
        "target_factor": target_factor,
        "ensemble_factor_relative_error": float(
            abs(np.mean(factors) - target_factor) / target_factor
        ),
        "factor_relative_error": finite_statistics(
            [sample.factor_relative_error for sample in samples]
        ),
        "metric_relative_error": finite_statistics(
            [sample.metric_relative_error for sample in samples]
        ),
        "signature_success_rate": sum(
            sample.metric_signature == (1, 3, 0) for sample in samples
        )
        / len(samples),
        "oracle_volume_relative_error": finite_statistics(
            [sample.oracle_volume_relative_error for sample in samples]
        ),
        "count_metric_volume_relative_mismatch": finite_statistics(
            [sample.count_metric_volume_relative_mismatch for sample in samples]
        ),
        "ensemble_mean_gradient": np.mean(gradients, axis=0).tolist(),
        "target_gradient": target_gradient.tolist(),
        "ensemble_gradient_dimensionless_error": float(
            duration * np.linalg.norm(np.mean(gradients, axis=0) - target_gradient)
            / target_factor
        ),
        "ensemble_temporal_gradient_relative_error": (
            None
            if temporal_target == 0.0
            else abs(np.mean(gradients, axis=0)[0] - temporal_target)
            / abs(temporal_target)
        ),
        "first_gradient_dimensionless_error": finite_statistics(
            [sample.first_gradient_dimensionless_error for sample in samples]
        ),
        "temporal_gradient_relative_error": finite_statistics(
            [sample.temporal_gradient_relative_error for sample in samples]
        ),
        "spatial_gradient_dimensionless_noise": finite_statistics(
            [sample.spatial_gradient_dimensionless_noise for sample in samples]
        ),
    }


def select_flat_setting(
    summaries: dict[str, dict[str, object]],
    factor_tolerance: float,
) -> tuple[str, dict[str, object]]:
    if factor_tolerance < 0.0:
        raise ValueError("factor tolerance must be nonnegative")
    best_factor_error = min(
        float(summary["ensemble_factor_relative_error"])
        for summary in summaries.values()
    )
    candidates = {
        key: summary
        for key, summary in summaries.items()
        if float(summary["ensemble_factor_relative_error"])
        <= best_factor_error + factor_tolerance
    }

    def score(item: tuple[str, dict[str, object]]) -> tuple[float, ...]:
        summary = item[1]
        mismatch = summary["count_metric_volume_relative_mismatch"]
        gradient = summary["first_gradient_dimensionless_error"]
        factor = summary["factor_relative_error"]
        assert isinstance(mismatch, dict)
        assert isinstance(gradient, dict)
        assert isinstance(factor, dict)
        return (
            float(mismatch["median"]),
            float(summary["ensemble_gradient_dimensionless_error"]),
            float(gradient["median"]),
            float(summary["ensemble_factor_relative_error"]),
            float(factor["median"]),
            float(summary["window_multiplier"]),
            float(summary["center_multiplier"]),
        )

    return min(candidates.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.events <= 0 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    hubble_values = sorted(set(args.hubble_values))
    if not hubble_values or 0.0 not in hubble_values:
        raise ValueError("backgrounds must include H = 0")
    for hubble in hubble_values:
        validate_background(args.duration, hubble)

    if args.mode == "development":
        window_values = sorted(set(args.window_multipliers))
        center_values = sorted(set(args.center_multipliers))
    else:
        if args.selected_window_multiplier is None:
            raise ValueError("held-out mode requires --selected-window-multiplier")
        if args.selected_center_multiplier is None:
            raise ValueError("held-out mode requires --selected-center-multiplier")
        window_values = [args.selected_window_multiplier]
        center_values = [args.selected_center_multiplier]

    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(hubble_values) * args.realizations
    )
    samples: list[CountWeylSample] = []
    seed_index = 0
    for hubble in hubble_values:
        for _ in range(args.realizations):
            samples.extend(
                reconstruct_count_weyl_realization(
                    np.random.default_rng(child_seeds[seed_index]),
                    args.events,
                    args.duration,
                    hubble,
                    window_values,
                    center_values,
                    args.maximum_centers,
                    args.pivot_fraction,
                )
            )
            seed_index += 1

    summaries: dict[str, dict[str, dict[str, object]]] = {}
    for hubble in hubble_values:
        background_samples = [sample for sample in samples if sample.hubble == hubble]
        setting_summaries: dict[str, dict[str, object]] = {}
        for c_w in window_values:
            for c_c in center_values:
                matching = [
                    sample
                    for sample in background_samples
                    if sample.window_multiplier == c_w
                    and sample.center_multiplier == c_c
                ]
                setting_summaries[setting_key(c_w, c_c)] = summarize_samples(matching)
        summaries[f"H={hubble:.6f}"] = setting_summaries

    if args.mode == "development":
        selected_key, selected_summary = select_flat_setting(
            summaries["H=0.000000"], args.factor_selection_tolerance
        )
        selected_setting = {
            "key": selected_key,
            "window_multiplier": selected_summary["window_multiplier"],
            "center_multiplier": selected_summary["center_multiplier"],
            "factor_selection_tolerance": args.factor_selection_tolerance,
            "selection_data": "flat H = 0 controls only",
        }
    else:
        selected_key = setting_key(window_values[0], center_values[0])
        selected_setting = {
            "key": selected_key,
            "window_multiplier": window_values[0],
            "center_multiplier": center_values[0],
            "factor_selection_tolerance": args.factor_selection_tolerance,
            "selection_data": "frozen before held-out seeds",
        }

    selected_backgrounds = {
        background: dict(setting_summaries[selected_key])
        for background, setting_summaries in summaries.items()
    }
    flat = selected_backgrounds["H=0.000000"]
    flat_estimate = float(flat["ensemble_mean_factor"])
    flat_target = float(flat["target_factor"])
    for summary in selected_backgrounds.values():
        response_estimate = float(summary["ensemble_mean_factor"]) / flat_estimate
        response_target = float(summary["target_factor"]) / flat_target
        summary["factor_response_relative_to_flat"] = {
            "estimate": response_estimate,
            "target": response_target,
            "relative_error": abs(response_estimate - response_target)
            / response_target,
        }

    result: dict[str, object] = {
        "status": "count-volume Weyl-scale calibration; not bare-order reconstruction",
        "mode": args.mode,
        "claim_boundary": {
            "event_counts_supply_scale": True,
            "fit_and_validation_counts_are_disjoint_poisson_thinnings": True,
            "conformal_class_is_supplied": True,
            "window_placement_uses_embedding_coordinates": True,
            "operator_metric_is_not_used": True,
        },
        "schedule": {
            "window": "W_coord = cW * sqrt(ell_coord * T_coord)",
            "centers": "C = cC * W",
            "asymptotics": ["ell_coord/W_coord -> 0", "W_coord,C -> 0"],
        },
        "settings": {
            "events": args.events,
            "realizations_per_background": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "hubble_values": hubble_values,
            "window_multipliers": window_values,
            "center_multipliers": center_values,
            "maximum_centers": args.maximum_centers,
            "factor_selection_tolerance": args.factor_selection_tolerance,
            "seed": args.seed,
        },
        "selected_setting": selected_setting,
        "selected_background_summaries": selected_backgrounds,
    }
    if args.mode == "development":
        result["development_grid"] = summaries
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=("development", "held-out"), required=True)
    parser.add_argument("--events", type=int, default=4000)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--pivot-fraction", type=float, default=0.5)
    parser.add_argument(
        "--hubble-values", type=float, nargs="+", default=[0.0, 0.1, 0.2]
    )
    parser.add_argument(
        "--window-multipliers", type=float, nargs="+", default=[0.45, 0.55, 0.65]
    )
    parser.add_argument(
        "--center-multipliers", type=float, nargs="+", default=[1.2, 1.5]
    )
    parser.add_argument("--selected-window-multiplier", type=float)
    parser.add_argument("--selected-center-multiplier", type=float)
    parser.add_argument("--maximum-centers", type=int, default=96)
    parser.add_argument("--factor-selection-tolerance", type=float, default=0.03)
    parser.add_argument("--seed", type=int, default=20260960)
    parser.add_argument("--include-samples", action="store_true")
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_experiment(args)
    rendered = json.dumps(result, indent=2, sort_keys=True)
    if args.output is not None:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered + "\n", encoding="utf-8", newline="\n")
    print(rendered)


if __name__ == "__main__":
    main()
