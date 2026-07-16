"""Stage A22 causal-operator metric control on conformal de Sitter diamonds.

The metric is

    ds^2 = a(t)^2 (dt^2 - dx^2 - dy^2 - dz^2),
    a(t) = 1 / (1 - H t),

on a conformal-coordinate Alexandrov diamond with ``0 <= t <= duration`` and
``H * duration < 1``.  This is a translated conformal-time patch of spatially
flat de Sitter spacetime.  Its causal order is the Minkowski order, while its
physical volume element is ``a(t)^4 dt dx dy dz``.

Points are sampled conditionally at constant physical density.  The causal
operator uses only precedence, interval cardinalities, the supplied physical
density scale, and a supplied mesoscopic nonlocality scale.  Embedding
coordinates enter only as calibration probes and as the known curved target.

Development selects the operator scale and compact-probe support using only
the flat ``H = 0`` controls.  Curved controls and held-out seeds do not affect
selection.  The experiment is a numerical oracle, not an intrinsic bare-order
reconstruction or a curvature-convergence result.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    compact_coordinate_probes,
    corrected_gamma,
    finite_statistics,
    fixed_probe_transform,
    interval_counts_to_target,
    matrix_relative_error,
    project_convention_row,
    signature,
    smeared_bd_row,
    volume_density_from_inverse_metric,
)


@dataclass(frozen=True)
class ConformalOperatorSample:
    hubble: float
    nonlocality_scale: float
    physical_support_radius: float
    metric: list[list[float]]
    target_metric: list[list[float]]
    eigenvalues: list[float]
    signature: tuple[int, int, int]
    metric_relative_error: float
    affine_covariance_relative_error: float
    volume_density: float | None
    target_volume_density: float
    volume_relative_error: float | None
    conformal_factor_squared_estimate: float
    conformal_factor_squared_target: float
    conformal_factor_squared_relative_error: float
    operator_on_one: float


def validate_background(duration: float, hubble: float) -> None:
    if duration <= 0.0:
        raise ValueError("duration must be positive")
    if hubble < 0.0:
        raise ValueError("H must be nonnegative")
    if hubble * duration >= 1.0:
        raise ValueError("the conformal patch requires H * duration < 1")


def de_sitter_conformal_scale(time: np.ndarray | float, hubble: float) -> np.ndarray:
    """Return ``a(t) = 1 / (1 - H t)`` on the selected patch."""

    values = np.asarray(time, dtype=float)
    denominator = 1.0 - hubble * values
    if np.any(denominator <= 0.0):
        raise ValueError("time lies outside the conformal de Sitter patch")
    return 1.0 / denominator


def conformal_diamond_volume(
    duration: float,
    hubble: float,
    quadrature_order: int = 128,
) -> float:
    """Integrate the physical four-volume of the coordinate diamond."""

    validate_background(duration, hubble)
    if quadrature_order <= 0:
        raise ValueError("quadrature order must be positive")
    nodes, weights = np.polynomial.legendre.leggauss(quadrature_order)
    total = 0.0
    for lower, upper in ((0.0, duration / 2.0), (duration / 2.0, duration)):
        time = lower + 0.5 * (upper - lower) * (nodes + 1.0)
        radius = np.minimum(time, duration - time)
        scale = de_sitter_conformal_scale(time, hubble)
        spatial_volume = (4.0 * np.pi / 3.0) * radius**3
        total += 0.5 * (upper - lower) * np.sum(
            weights * spatial_volume * scale**4
        )
    return float(total)


def sprinkle_conformal_de_sitter_diamond(
    rng: np.random.Generator,
    events: int,
    duration: float,
    hubble: float,
) -> tuple[np.ndarray, int]:
    """Conditionally sample constant-physical-density interior events."""

    validate_background(duration, hubble)
    if events <= 0:
        raise ValueError("events must be positive")

    accepted: list[np.ndarray] = []
    accepted_count = 0
    half = duration / 2.0
    maximum_scale = float(de_sitter_conformal_scale(duration, hubble))
    while accepted_count < events:
        remaining = events - accepted_count
        batch_size = max(512, 12 * remaining)
        time = rng.uniform(0.0, duration, size=batch_size)
        space = rng.uniform(-half, half, size=(batch_size, 3))
        radius_bound = np.minimum(time, duration - time)
        inside = np.sum(space**2, axis=1) < radius_bound**2
        physical_weight = (
            de_sitter_conformal_scale(time, hubble) / maximum_scale
        ) ** 4
        retained = inside & (rng.random(batch_size) < physical_weight)
        batch = np.column_stack((time[retained], space[retained]))
        if len(batch):
            take = batch[:remaining]
            accepted.append(take)
            accepted_count += len(take)

    interior = np.concatenate(accepted, axis=0)
    top = np.array([[duration, 0.0, 0.0, 0.0]])
    points = np.concatenate((interior, top), axis=0)
    return points, len(points) - 1


def target_inverse_metric(duration: float, hubble: float) -> np.ndarray:
    scale = float(de_sitter_conformal_scale(duration, hubble))
    return MINKOWSKI_INVERSE / scale**2


def target_volume_density(duration: float, hubble: float) -> float:
    scale = float(de_sitter_conformal_scale(duration, hubble))
    return scale**4


def conformal_factor_squared_from_inverse_metric(metric: np.ndarray) -> float:
    """Estimate ``a^-2`` by the Minkowski Frobenius projection."""

    return float(np.sum(metric * MINKOWSKI_INVERSE) / 4.0)


def reconstruct_settings_for_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    hubble: float,
    nonlocality_scales: list[float],
    physical_support_radii: list[float],
    block_size: int,
) -> list[ConformalOperatorSample]:
    points, target_index = sprinkle_conformal_de_sitter_diamond(
        rng, events, duration, hubble
    )
    past, counts = interval_counts_to_target(points, target_index, block_size)
    physical_volume = conformal_diamond_volume(duration, hubble)
    ell = (physical_volume / events) ** 0.25
    target_metric = target_inverse_metric(duration, hubble)
    target_density = target_volume_density(duration, hubble)
    target_factor = conformal_factor_squared_from_inverse_metric(target_metric)
    target_scale = float(de_sitter_conformal_scale(duration, hubble))
    linear, offset = fixed_probe_transform()

    samples: list[ConformalOperatorSample] = []
    for support_radius in physical_support_radii:
        coordinate_support_radius = support_radius / target_scale
        probes = compact_coordinate_probes(
            points, target_index, coordinate_support_radius
        )
        transformed_probes = probes @ linear.T + offset
        for nonlocality_scale in nonlocality_scales:
            if nonlocality_scale <= ell:
                raise ValueError(
                    "every nonlocality scale must exceed the discreteness scale"
                )
            row = project_convention_row(
                smeared_bd_row(
                    past,
                    counts,
                    target_index,
                    ell,
                    nonlocality_scale,
                )
            )
            metric = corrected_gamma(row, probes, target_index)
            transformed_metric = corrected_gamma(
                row, transformed_probes, target_index
            )
            covariance_target = linear @ metric @ linear.T
            volume_density = volume_density_from_inverse_metric(metric)
            volume_error = (
                None
                if volume_density is None
                else abs(volume_density - target_density) / target_density
            )
            factor_estimate = conformal_factor_squared_from_inverse_metric(metric)
            factor_error = abs(factor_estimate - target_factor) / target_factor
            samples.append(
                ConformalOperatorSample(
                    hubble=hubble,
                    nonlocality_scale=nonlocality_scale,
                    physical_support_radius=support_radius,
                    metric=metric.tolist(),
                    target_metric=target_metric.tolist(),
                    eigenvalues=np.linalg.eigvalsh(metric).tolist(),
                    signature=signature(metric),
                    metric_relative_error=matrix_relative_error(
                        metric, target_metric
                    ),
                    affine_covariance_relative_error=matrix_relative_error(
                        transformed_metric, covariance_target
                    ),
                    volume_density=volume_density,
                    target_volume_density=target_density,
                    volume_relative_error=volume_error,
                    conformal_factor_squared_estimate=factor_estimate,
                    conformal_factor_squared_target=target_factor,
                    conformal_factor_squared_relative_error=factor_error,
                    operator_on_one=float(np.sum(row)),
                )
            )
    return samples


def setting_key(nonlocality_scale: float, physical_support_radius: float) -> str:
    return f"L={nonlocality_scale:.6f}|R={physical_support_radius:.6f}"


def summarize_samples(samples: list[ConformalOperatorSample]) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize an empty sample list")
    metrics = np.array([sample.metric for sample in samples])
    target = np.array(samples[0].target_metric)
    mean_metric = np.mean(metrics, axis=0)
    factor_estimates = np.array(
        [sample.conformal_factor_squared_estimate for sample in samples]
    )
    factor_target = samples[0].conformal_factor_squared_target
    signature_successes = sum(sample.signature == (1, 3, 0) for sample in samples)
    return {
        "hubble": samples[0].hubble,
        "nonlocality_scale": samples[0].nonlocality_scale,
        "physical_support_radius": samples[0].physical_support_radius,
        "mean_metric": mean_metric.tolist(),
        "target_metric": target.tolist(),
        "ensemble_mean_signature": signature(mean_metric),
        "ensemble_mean_metric_relative_error": matrix_relative_error(
            mean_metric, target
        ),
        "ensemble_conformal_factor_squared_estimate": float(
            np.mean(factor_estimates)
        ),
        "ensemble_conformal_factor_squared_target": factor_target,
        "ensemble_conformal_factor_squared_relative_error": float(
            abs(np.mean(factor_estimates) - factor_target) / factor_target
        ),
        "signature_successes": signature_successes,
        "signature_success_rate": signature_successes / len(samples),
        "metric_relative_error": finite_statistics(
            [sample.metric_relative_error for sample in samples]
        ),
        "volume_relative_error": finite_statistics(
            [sample.volume_relative_error for sample in samples]
        ),
        "conformal_factor_squared_relative_error": finite_statistics(
            [
                sample.conformal_factor_squared_relative_error
                for sample in samples
            ]
        ),
        "affine_covariance_relative_error": finite_statistics(
            [sample.affine_covariance_relative_error for sample in samples]
        ),
        "operator_on_one": finite_statistics(
            [sample.operator_on_one for sample in samples]
        ),
    }


def select_flat_setting(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select on flat controls only; curved targets remain unopened."""

    def score(item: tuple[str, dict[str, object]]) -> tuple[float, ...]:
        summary = item[1]
        metric_stats = summary["metric_relative_error"]
        volume_stats = summary["volume_relative_error"]
        assert isinstance(metric_stats, dict)
        assert isinstance(volume_stats, dict)
        return (
            -float(summary["signature_success_rate"]),
            float(summary["ensemble_mean_metric_relative_error"]),
            float(metric_stats["median"]),
            float(volume_stats["median"]),
            float(summary["nonlocality_scale"]),
            float(summary["physical_support_radius"]),
        )

    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.events <= 0 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    hubble_values = sorted(set(args.hubble_values))
    if not hubble_values or 0.0 not in hubble_values:
        raise ValueError("the background list must include the H = 0 control")
    for hubble in hubble_values:
        validate_background(args.duration, hubble)

    if args.mode == "development":
        scales = sorted(set(args.nonlocality_scales))
        supports = sorted(set(args.physical_support_radii))
    else:
        if args.selected_nonlocality_scale is None:
            raise ValueError("held-out mode requires --selected-nonlocality-scale")
        if args.selected_physical_support_radius is None:
            raise ValueError(
                "held-out mode requires --selected-physical-support-radius"
            )
        scales = [args.selected_nonlocality_scale]
        supports = [args.selected_physical_support_radius]
    if not scales or not supports:
        raise ValueError("operator-scale and support grids must be nonempty")

    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(hubble_values) * args.realizations
    )
    samples: list[ConformalOperatorSample] = []
    seed_index = 0
    for hubble in hubble_values:
        for _ in range(args.realizations):
            samples.extend(
                reconstruct_settings_for_realization(
                    np.random.default_rng(child_seeds[seed_index]),
                    args.events,
                    args.duration,
                    hubble,
                    scales,
                    supports,
                    args.block_size,
                )
            )
            seed_index += 1

    summaries: dict[str, dict[str, dict[str, object]]] = {}
    for hubble in hubble_values:
        background_samples = [sample for sample in samples if sample.hubble == hubble]
        setting_summaries: dict[str, dict[str, object]] = {}
        for scale in scales:
            for support in supports:
                selected = [
                    sample
                    for sample in background_samples
                    if sample.nonlocality_scale == scale
                    and sample.physical_support_radius == support
                ]
                setting_summaries[setting_key(scale, support)] = summarize_samples(
                    selected
                )
        summaries[f"H={hubble:.6f}"] = setting_summaries

    if args.mode == "development":
        selected_key, selected_summary = select_flat_setting(summaries["H=0.000000"])
        selected_setting = {
            "key": selected_key,
            "nonlocality_scale": selected_summary["nonlocality_scale"],
            "physical_support_radius": selected_summary[
                "physical_support_radius"
            ],
            "selection_data": "flat H = 0 controls only",
        }
    else:
        selected_key = setting_key(scales[0], supports[0])
        selected_setting = {
            "key": selected_key,
            "nonlocality_scale": scales[0],
            "physical_support_radius": supports[0],
            "selection_data": "frozen before held-out seeds",
        }

    selected_backgrounds = {
        background: dict(setting_summaries[selected_key])
        for background, setting_summaries in summaries.items()
    }
    flat_selected = selected_backgrounds["H=0.000000"]
    flat_factor_estimate = float(
        flat_selected["ensemble_conformal_factor_squared_estimate"]
    )
    flat_factor_target = float(
        flat_selected["ensemble_conformal_factor_squared_target"]
    )
    for background_summary in selected_backgrounds.values():
        response_estimate = float(
            background_summary["ensemble_conformal_factor_squared_estimate"]
        ) / flat_factor_estimate
        response_target = float(
            background_summary["ensemble_conformal_factor_squared_target"]
        ) / flat_factor_target
        background_summary["conformal_response_relative_to_flat"] = {
            "estimate": response_estimate,
            "target": response_target,
            "relative_error": abs(response_estimate - response_target)
            / response_target,
        }
    result: dict[str, object] = {
        "status": "curved coordinate-probe operator calibration; not reconstruction",
        "mode": args.mode,
        "claim_boundary": {
            "causal_operator_uses_order_counts_and_supplied_scales": True,
            "probe_construction_uses_embedding_coordinates": True,
            "physical_density_scale_is_supplied": True,
            "curvature_estimator_is_computed": False,
            "tetrad_or_spin_structure_is_computed": False,
        },
        "settings": {
            "events": args.events,
            "realizations_per_background": args.realizations,
            "duration": args.duration,
            "hubble_values": hubble_values,
            "nonlocality_scales": scales,
            "physical_support_radii": supports,
            "seed": args.seed,
            "source_signature": "(-+++)",
            "project_signature": "(+---)",
        },
        "backgrounds": {
            f"H={hubble:.6f}": {
                "physical_volume": conformal_diamond_volume(
                    args.duration, hubble
                ),
                "ell": (
                    conformal_diamond_volume(args.duration, hubble) / args.events
                )
                ** 0.25,
                "target_inverse_metric": target_inverse_metric(
                    args.duration, hubble
                ).tolist(),
                "target_volume_density": target_volume_density(
                    args.duration, hubble
                ),
            }
            for hubble in hubble_values
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
    parser.add_argument(
        "--hubble-values", type=float, nargs="+", default=[0.0, 0.1, 0.2]
    )
    parser.add_argument(
        "--nonlocality-scales", type=float, nargs="+", default=[0.14, 0.16, 0.18]
    )
    parser.add_argument(
        "--physical-support-radii", type=float, nargs="+", default=[0.45, 0.55]
    )
    parser.add_argument("--selected-nonlocality-scale", type=float)
    parser.add_argument("--selected-physical-support-radius", type=float)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20260900)
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
