"""Stage A31 Poisson-calibrated count-volume scale gradients.

Stage A30 localizes the differentiated metric failure to the affine gradient
of the count-derived Weyl factor.  This stage keeps the A29 tensor correction
and the A24 pivot factor, but replaces the gradient fit by a penalized Poisson
log-intensity fit.  The slope penalty is formed from the observed center
scatter matrix, so it is covariant under invertible affine changes of the
supplied probe coordinates.

Development selects the penalty using only synthetic zero-gradient and
nonzero-gradient Poisson count controls at two densities.  Held-out de Sitter
targets are never used for selection.  Coordinates, density, dimension,
windows, and probe schedules remain supplied; this is a conditional
first-derivative control, not a bare-graph connection reconstruction.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_conformal_multirow_metric import (
    append_interior_pivot,
    reconstruct_multirow_realization,
    target_inverse_metric_at,
)
from causal_conformal_operator_metric import (
    conformal_diamond_volume,
    sprinkle_conformal_de_sitter_diamond,
    validate_background,
)
from causal_count_volume_weyl_metric import (
    count_window_scales,
    fit_affine_factor_field,
    local_count_volume_factor,
    select_count_centers,
)
from causal_fused_operator_count_metric import fuse_metric_and_first_jet
from causal_operator_metric import (
    diamond_volume_4d,
    finite_statistics,
    matrix_relative_error,
    signature,
    sprinkle_minkowski_diamond,
    volume_density_from_inverse_metric,
)
from causal_retarded_moment_debiased_metric import (
    retarded_time_response_correction_with_jet,
    select_temporal_response_weight,
)


@dataclass(frozen=True)
class PoissonFactorFit:
    factor: float
    factor_gradient: np.ndarray
    log_volume_gradient: np.ndarray
    iterations: int
    information_condition: float


@dataclass(frozen=True)
class CountGradientEstimate:
    factor: float
    raw_gradient: np.ndarray
    calibrated_gradient: np.ndarray
    target_factor: float
    target_gradient: np.ndarray
    independent_count_volume_density: float
    center_count: int
    minimum_window_count: int
    median_window_count: float
    poisson_iterations: int
    poisson_information_condition: float


@dataclass(frozen=True)
class PoissonScaleGradientSample:
    hubble: float
    duration: float
    temporal_response_weight: float
    gradient_penalty: float
    count_weyl_factor: float
    target_count_weyl_factor: float
    count_factor_relative_error: float
    raw_count_gradient: list[float]
    calibrated_count_gradient: list[float]
    target_count_gradient: list[float]
    raw_count_gradient_dimensionless_error: float
    calibrated_count_gradient_dimensionless_error: float
    fused_metric: list[list[float]]
    target_metric: list[list[float]]
    fused_metric_relative_error: float
    fused_signature: tuple[int, int, int]
    fused_oracle_volume_relative_error: float | None
    fused_count_volume_relative_mismatch: float | None
    corrected_operator_first_jet_dimensionless_error: float
    raw_fused_first_jet_dimensionless_error: float
    zero_scale_fused_first_jet_dimensionless_error: float
    oracle_scale_fused_first_jet_dimensionless_error: float
    calibrated_fused_first_jet: list[list[list[float]]]
    target_first_jet: list[list[list[float]]]
    calibrated_fused_first_jet_dimensionless_error: float
    calibrated_fused_temporal_first_jet_relative_error: float | None
    calibrated_fused_spatial_first_jet_dimensionless_noise: float
    operator_row_count: int
    count_center_count: int
    minimum_count_window_count: int
    median_count_window_count: float
    poisson_iterations: int
    poisson_information_condition: float


def fit_penalized_poisson_factor_field(
    offsets: np.ndarray,
    counts: np.ndarray,
    exposure: float,
    penalty: float,
    maximum_iterations: int = 50,
    tolerance: float = 1.0e-11,
) -> PoissonFactorFit:
    """Fit ``log(volume density)`` and return the inverse-metric factor jet.

    The model is ``count_i ~ Poisson(exposure * exp(theta_0 + x_i theta))``.
    Only the slope is penalized.  Its penalty matrix is proportional to
    ``sum_i x_i x_i^T``; this makes the quadratic penalty invariant under an
    invertible linear change of the supplied coordinates.
    """

    offsets = np.asarray(offsets, dtype=float)
    counts = np.asarray(counts, dtype=float)
    if offsets.ndim != 2 or offsets.shape[1] != 4:
        raise ValueError("offsets must have shape (n,4)")
    if counts.shape != (len(offsets),):
        raise ValueError("counts must align with offsets")
    if len(offsets) < 5 or np.any(counts < 0.0):
        raise ValueError("at least five nonnegative counts are required")
    if exposure <= 0.0 or penalty < 0.0:
        raise ValueError("exposure must be positive and penalty nonnegative")

    design = np.column_stack((np.ones(len(offsets)), offsets))
    scatter = offsets.T @ offsets
    mean_count = max(float(np.mean(counts)), np.finfo(float).eps)
    penalty_matrix = np.zeros((5, 5), dtype=float)
    penalty_matrix[1:, 1:] = penalty * mean_count * scatter
    theta = np.zeros(5, dtype=float)
    theta[0] = np.log(max(float(np.mean(counts)) / exposure, 1.0e-12))

    information = design.T @ design
    iterations = 0
    for iterations in range(1, maximum_iterations + 1):
        linear = np.clip(theta[0] + offsets @ theta[1:], -50.0, 50.0)
        means = exposure * np.exp(linear)
        score = design.T @ (counts - means) - penalty_matrix @ theta
        information = design.T @ (means[:, None] * design) + penalty_matrix
        step = np.linalg.solve(information, score)
        theta += step
        if np.linalg.norm(step) <= tolerance * (1.0 + np.linalg.norm(theta)):
            break
    else:
        raise ValueError("penalized Poisson fit did not converge")

    factor = float(np.exp(-0.5 * theta[0]))
    log_volume_gradient = theta[1:].copy()
    factor_gradient = -0.5 * factor * log_volume_gradient
    return PoissonFactorFit(
        factor=factor,
        factor_gradient=factor_gradient,
        log_volume_gradient=log_volume_gradient,
        iterations=iterations,
        information_condition=float(np.linalg.cond(information)),
    )


def control_gradient_vectors() -> list[np.ndarray]:
    """Dimensionless log-volume gradients used only for penalty selection."""

    return [
        np.zeros(4),
        np.array([0.9, 0.0, 0.0, 0.0]),
        np.array([0.0, 0.9, 0.0, 0.0]),
        np.array([0.45, 0.45, -0.45, 0.45]),
    ]


def calibrate_gradient_penalty(
    events_values: list[int],
    penalties: list[float],
    realizations: int,
    duration: float,
    pivot_fraction: float,
    window_multiplier: float,
    center_multiplier: float,
    maximum_centers_factor: float,
    seed: int,
) -> tuple[float, dict[str, object]]:
    """Select one penalty on flat-support synthetic Poisson controls."""

    if len(set(events_values)) < 2:
        raise ValueError("calibration requires at least two distinct densities")
    if not penalties or any(value < 0.0 for value in penalties):
        raise ValueError("penalties must be nonempty and nonnegative")
    if realizations <= 0 or maximum_centers_factor <= 0.0:
        raise ValueError("calibration realization counts must be positive")

    gradients = control_gradient_vectors()
    child_seeds = np.random.SeedSequence(seed).spawn(
        len(events_values) * realizations
    )
    records: dict[str, dict[str, list[float]]] = {
        f"lambda={value:.6f}": {} for value in sorted(set(penalties))
    }
    index = 0
    for events in sorted(set(events_values)):
        coordinate_ell = (diamond_volume_4d(duration) / events) ** 0.25
        scales = count_window_scales(
            coordinate_ell, duration, window_multiplier, center_multiplier
        )
        maximum_centers = max(5, int(round(maximum_centers_factor * np.sqrt(events))))
        exposure = (
            (events // 2)
            / diamond_volume_4d(duration)
            * diamond_volume_4d(2.0 * scales.coordinate_window_half_duration)
        )
        for realization in range(realizations):
            rng = np.random.default_rng(child_seeds[index])
            index += 1
            points, top_index = sprinkle_minkowski_diamond(rng, events, duration)
            points, pivot_index, _ = append_interior_pivot(
                points, top_index, duration, pivot_fraction
            )
            centers = select_count_centers(
                points,
                np.arange(events),
                pivot_index,
                scales.coordinate_center_radius,
                scales.coordinate_window_half_duration,
                duration,
                maximum_centers,
            )
            if len(centers) < 5:
                raise ValueError("calibration support has fewer than five centers")
            offsets = points[centers] - points[pivot_index]
            for control_index, log_gradient in enumerate(gradients):
                means = exposure * np.exp(offsets @ log_gradient)
                counts = rng.poisson(means)
                target = -0.5 * log_gradient
                target_norm = float(np.linalg.norm(target))
                label = (
                    f"N={events}|control={control_index}|"
                    f"zero={target_norm == 0.0}"
                )
                for penalty in sorted(set(penalties)):
                    fit = fit_penalized_poisson_factor_field(
                        offsets, counts, exposure, penalty
                    )
                    error = duration * float(
                        np.linalg.norm(fit.factor_gradient - target)
                    )
                    normalized = error / max(duration * target_norm, 0.45)
                    key = f"lambda={penalty:.6f}"
                    records[key].setdefault(label + "|error", []).append(error)
                    records[key].setdefault(label + "|normalized", []).append(
                        normalized
                    )
                    records[key].setdefault(label + "|response", []).append(
                        float(np.linalg.norm(fit.factor_gradient))
                    )

    summaries: dict[str, object] = {}
    for key, values in records.items():
        error_values = [
            value
            for label, entries in values.items()
            if label.endswith("|error")
            for value in entries
        ]
        normalized_values = [
            value
            for label, entries in values.items()
            if label.endswith("|normalized")
            for value in entries
        ]
        zero_values = [
            value
            for label, entries in values.items()
            if "zero=True" in label and label.endswith("|response")
            for value in entries
        ]
        nonzero_responses = [
            value
            for label, entries in values.items()
            if "zero=False" in label and label.endswith("|response")
            for value in entries
        ]
        summaries[key] = {
            "penalty": float(key.split("=")[1]),
            "error": finite_statistics(error_values),
            "normalized_error": finite_statistics(normalized_values),
            "zero_gradient_response": finite_statistics(zero_values),
            "nonzero_gradient_response": finite_statistics(nonzero_responses),
            "worst_cell_median_normalized_error": max(
                float(np.median(entries))
                for label, entries in values.items()
                if label.endswith("|normalized")
            ),
        }

    def score(item: tuple[str, object]) -> tuple[float, ...]:
        summary = item[1]
        assert isinstance(summary, dict)
        normalized = summary["normalized_error"]
        zero = summary["zero_gradient_response"]
        assert isinstance(normalized, dict) and isinstance(zero, dict)
        return (
            float(summary["worst_cell_median_normalized_error"]),
            float(normalized["median"]),
            float(zero["median"]),
            float(summary["penalty"]),
        )

    selected_key, selected_summary = min(summaries.items(), key=score)
    assert isinstance(selected_summary, dict)
    return float(selected_summary["penalty"]), {
        "selected_key": selected_key,
        "selected_penalty": float(selected_summary["penalty"]),
        "density_values": sorted(set(events_values)),
        "realizations_per_density": realizations,
        "control_log_volume_gradients": [value.tolist() for value in gradients],
        "candidate_summaries": summaries,
    }


def reconstruct_count_gradient_estimate(
    rng: np.random.Generator,
    events: int,
    duration: float,
    hubble: float,
    window_multiplier: float,
    center_multiplier: float,
    maximum_centers: int,
    pivot_fraction: float,
    penalty: float,
) -> CountGradientEstimate:
    """Reconstruct the A24 pivot factor and two competing factor gradients."""

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
    scales = count_window_scales(
        coordinate_ell, duration, window_multiplier, center_multiplier
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
    factor, raw_gradient, _, _ = fit_affine_factor_field(
        points, pivot_index, centers, np.array(factors)
    )
    offsets = points[centers] - points[pivot_index]
    exposure = fit_density * diamond_volume_4d(
        2.0 * scales.coordinate_window_half_duration
    )
    poisson_fit = fit_penalized_poisson_factor_field(
        offsets, np.array(counts), exposure, penalty
    )
    calibrated_gradient = -0.5 * factor * poisson_fit.log_volume_gradient
    _, _, independent_volume = local_count_volume_factor(
        points[validation_indices],
        validation_density,
        points[pivot_index],
        scales.coordinate_window_half_duration,
        duration,
    )
    pivot_time = pivot_fraction * duration
    target_factor = float((1.0 - hubble * pivot_time) ** 2)
    target_gradient = np.zeros(4)
    target_gradient[0] = -2.0 * hubble * (1.0 - hubble * pivot_time)
    return CountGradientEstimate(
        factor=factor,
        raw_gradient=raw_gradient,
        calibrated_gradient=calibrated_gradient,
        target_factor=target_factor,
        target_gradient=target_gradient,
        independent_count_volume_density=independent_volume,
        center_count=len(centers),
        minimum_window_count=min(counts),
        median_window_count=float(np.median(counts)),
        poisson_iterations=poisson_fit.iterations,
        poisson_information_condition=poisson_fit.information_condition,
    )


def reconstruct_scale_gradient_realization(
    child_seed: np.random.SeedSequence,
    args: argparse.Namespace,
    hubble: float,
    temporal_response_weight: float,
    gradient_penalty: float,
) -> PoissonScaleGradientSample:
    operator = reconstruct_multirow_realization(
        np.random.default_rng(child_seed),
        args.events,
        args.duration,
        hubble,
        [args.operator_nonlocality_multiplier],
        [args.operator_support_multiplier],
        [args.operator_averaging_multiplier],
        args.maximum_operator_rows,
        args.block_size,
        args.pivot_fraction,
    )[0]
    count = reconstruct_count_gradient_estimate(
        np.random.default_rng(child_seed),
        args.events,
        args.duration,
        hubble,
        args.count_window_multiplier,
        args.count_center_multiplier,
        args.maximum_count_centers,
        args.pivot_fraction,
        gradient_penalty,
    )
    corrected_metric, corrected_jet, _ = (
        retarded_time_response_correction_with_jet(
            np.array(operator.metric),
            np.array(operator.metric_first_jet),
            np.array(operator.retarded_moment),
            np.array(operator.retarded_moment_first_jet),
            temporal_response_weight,
        )
    )
    fused_metric, raw_fused_jet, _, _ = fuse_metric_and_first_jet(
        corrected_metric,
        corrected_jet,
        count.factor,
        count.raw_gradient,
    )
    _, calibrated_fused_jet, _, _ = fuse_metric_and_first_jet(
        corrected_metric,
        corrected_jet,
        count.factor,
        count.calibrated_gradient,
    )
    _, zero_scale_fused_jet, _, _ = fuse_metric_and_first_jet(
        corrected_metric,
        corrected_jet,
        count.factor,
        np.zeros(4),
    )
    _, oracle_scale_fused_jet, _, _ = fuse_metric_and_first_jet(
        corrected_metric,
        corrected_jet,
        count.factor,
        count.target_gradient,
    )
    target_metric = target_inverse_metric_at(
        args.pivot_fraction * args.duration, hubble
    )
    target_jet = np.array(operator.target_metric_first_jet)
    metric_norm = float(np.linalg.norm(target_metric))
    temporal_target_norm = float(np.linalg.norm(target_jet[0]))
    fused_volume = volume_density_from_inverse_metric(fused_metric)
    target_volume = 1.0 / count.target_factor**2
    return PoissonScaleGradientSample(
        hubble=hubble,
        duration=args.duration,
        temporal_response_weight=temporal_response_weight,
        gradient_penalty=gradient_penalty,
        count_weyl_factor=count.factor,
        target_count_weyl_factor=count.target_factor,
        count_factor_relative_error=abs(count.factor - count.target_factor)
        / count.target_factor,
        raw_count_gradient=count.raw_gradient.tolist(),
        calibrated_count_gradient=count.calibrated_gradient.tolist(),
        target_count_gradient=count.target_gradient.tolist(),
        raw_count_gradient_dimensionless_error=float(
            args.duration * np.linalg.norm(count.raw_gradient - count.target_gradient)
            / count.target_factor
        ),
        calibrated_count_gradient_dimensionless_error=float(
            args.duration
            * np.linalg.norm(count.calibrated_gradient - count.target_gradient)
            / count.target_factor
        ),
        fused_metric=fused_metric.tolist(),
        target_metric=target_metric.tolist(),
        fused_metric_relative_error=matrix_relative_error(
            fused_metric, target_metric
        ),
        fused_signature=signature(fused_metric),
        fused_oracle_volume_relative_error=(
            None
            if fused_volume is None
            else abs(fused_volume - target_volume) / target_volume
        ),
        fused_count_volume_relative_mismatch=(
            None
            if fused_volume is None
            else abs(fused_volume - count.independent_count_volume_density)
            / count.independent_count_volume_density
        ),
        corrected_operator_first_jet_dimensionless_error=float(
            args.duration * np.linalg.norm(corrected_jet - target_jet) / metric_norm
        ),
        raw_fused_first_jet_dimensionless_error=float(
            args.duration * np.linalg.norm(raw_fused_jet - target_jet) / metric_norm
        ),
        zero_scale_fused_first_jet_dimensionless_error=float(
            args.duration
            * np.linalg.norm(zero_scale_fused_jet - target_jet)
            / metric_norm
        ),
        oracle_scale_fused_first_jet_dimensionless_error=float(
            args.duration
            * np.linalg.norm(oracle_scale_fused_jet - target_jet)
            / metric_norm
        ),
        calibrated_fused_first_jet=calibrated_fused_jet.tolist(),
        target_first_jet=target_jet.tolist(),
        calibrated_fused_first_jet_dimensionless_error=float(
            args.duration
            * np.linalg.norm(calibrated_fused_jet - target_jet)
            / metric_norm
        ),
        calibrated_fused_temporal_first_jet_relative_error=(
            None
            if temporal_target_norm == 0.0
            else float(
                np.linalg.norm(calibrated_fused_jet[0] - target_jet[0])
                / temporal_target_norm
            )
        ),
        calibrated_fused_spatial_first_jet_dimensionless_noise=float(
            args.duration * np.linalg.norm(calibrated_fused_jet[1:]) / metric_norm
        ),
        operator_row_count=operator.row_count,
        count_center_count=count.center_count,
        minimum_count_window_count=count.minimum_window_count,
        median_count_window_count=count.median_window_count,
        poisson_iterations=count.poisson_iterations,
        poisson_information_condition=count.poisson_information_condition,
    )


def summarize_samples(samples: list[PoissonScaleGradientSample]) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize empty samples")
    gradients = np.array([sample.calibrated_count_gradient for sample in samples])
    target_gradient = np.array(samples[0].target_count_gradient)
    jets = np.array([sample.calibrated_fused_first_jet for sample in samples])
    target_jet = np.array(samples[0].target_first_jet)
    target_metric = np.array(samples[0].target_metric)
    metric_norm = float(np.linalg.norm(target_metric))
    return {
        "hubble": samples[0].hubble,
        "temporal_response_weight": samples[0].temporal_response_weight,
        "gradient_penalty": samples[0].gradient_penalty,
        "count_factor_relative_error": finite_statistics(
            [sample.count_factor_relative_error for sample in samples]
        ),
        "ensemble_mean_calibrated_count_gradient": np.mean(
            gradients, axis=0
        ).tolist(),
        "target_count_gradient": target_gradient.tolist(),
        "ensemble_calibrated_count_gradient_dimensionless_error": float(
            samples[0].duration
            * np.linalg.norm(np.mean(gradients, axis=0) - target_gradient)
            / samples[0].target_count_weyl_factor
        ),
        "raw_count_gradient_dimensionless_error": finite_statistics(
            [sample.raw_count_gradient_dimensionless_error for sample in samples]
        ),
        "calibrated_count_gradient_dimensionless_error": finite_statistics(
            [
                sample.calibrated_count_gradient_dimensionless_error
                for sample in samples
            ]
        ),
        "fused_metric_relative_error": finite_statistics(
            [sample.fused_metric_relative_error for sample in samples]
        ),
        "fused_signature_success_rate": sum(
            sample.fused_signature == (1, 3, 0) for sample in samples
        )
        / len(samples),
        "fused_oracle_volume_relative_error": finite_statistics(
            [sample.fused_oracle_volume_relative_error for sample in samples]
        ),
        "fused_count_volume_relative_mismatch": finite_statistics(
            [sample.fused_count_volume_relative_mismatch for sample in samples]
        ),
        "corrected_operator_first_jet_dimensionless_error": finite_statistics(
            [
                sample.corrected_operator_first_jet_dimensionless_error
                for sample in samples
            ]
        ),
        "raw_fused_first_jet_dimensionless_error": finite_statistics(
            [sample.raw_fused_first_jet_dimensionless_error for sample in samples]
        ),
        "zero_scale_fused_first_jet_dimensionless_error": finite_statistics(
            [
                sample.zero_scale_fused_first_jet_dimensionless_error
                for sample in samples
            ]
        ),
        "oracle_scale_fused_first_jet_dimensionless_error": finite_statistics(
            [
                sample.oracle_scale_fused_first_jet_dimensionless_error
                for sample in samples
            ]
        ),
        "ensemble_calibrated_fused_first_jet_dimensionless_error": float(
            samples[0].duration
            * np.linalg.norm(np.mean(jets, axis=0) - target_jet)
            / metric_norm
        ),
        "calibrated_fused_first_jet_dimensionless_error": finite_statistics(
            [
                sample.calibrated_fused_first_jet_dimensionless_error
                for sample in samples
            ]
        ),
        "calibrated_fused_temporal_first_jet_relative_error": finite_statistics(
            [
                sample.calibrated_fused_temporal_first_jet_relative_error
                for sample in samples
            ]
        ),
        "calibrated_fused_spatial_first_jet_dimensionless_noise": finite_statistics(
            [
                sample.calibrated_fused_spatial_first_jet_dimensionless_noise
                for sample in samples
            ]
        ),
        "operator_row_count": finite_statistics(
            [float(sample.operator_row_count) for sample in samples]
        ),
        "count_center_count": finite_statistics(
            [float(sample.count_center_count) for sample in samples]
        ),
        "minimum_count_window_count": finite_statistics(
            [float(sample.minimum_count_window_count) for sample in samples]
        ),
        "median_count_window_count": finite_statistics(
            [sample.median_count_window_count for sample in samples]
        ),
        "poisson_information_condition": finite_statistics(
            [sample.poisson_information_condition for sample in samples]
        ),
    }


def run_development(args: argparse.Namespace) -> dict[str, object]:
    selected, calibration = calibrate_gradient_penalty(
        args.calibration_events,
        args.gradient_penalties,
        args.calibration_realizations,
        args.duration,
        args.pivot_fraction,
        args.count_window_multiplier,
        args.count_center_multiplier,
        args.calibration_maximum_centers_factor,
        args.seed,
    )
    return {
        "status": "Poisson count-gradient calibration; not metric reconstruction",
        "stage": "A31",
        "mode": "development",
        "claim_boundary": {
            "selection_uses_only_synthetic_poisson_controls": True,
            "zero_and_nonzero_gradients_are_included": True,
            "two_density_selection_is_required": True,
            "curved_background_targets_are_not_used": True,
            "coordinates_density_dimension_and_windows_are_supplied": True,
        },
        "selected_penalty": selected,
        "calibration": calibration,
        "settings": {
            "calibration_events": sorted(set(args.calibration_events)),
            "calibration_realizations": args.calibration_realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "count_window_multiplier": args.count_window_multiplier,
            "count_center_multiplier": args.count_center_multiplier,
            "calibration_maximum_centers_factor": (
                args.calibration_maximum_centers_factor
            ),
            "seed": args.seed,
        },
    }


def run_held_out(args: argparse.Namespace) -> dict[str, object]:
    if args.gradient_calibration_input is None:
        raise ValueError("held-out mode requires --gradient-calibration-input")
    if not args.response_calibration_inputs:
        raise ValueError("held-out mode requires --response-calibration-inputs")
    gradient_artifact = json.loads(
        args.gradient_calibration_input.read_text(encoding="utf-8")
    )
    gradient_penalty = float(gradient_artifact["selected_penalty"])
    response_artifacts = [
        json.loads(path.read_text(encoding="utf-8"))
        for path in args.response_calibration_inputs
    ]
    response_weight, response_scores = select_temporal_response_weight(
        response_artifacts, args.temporal_response_weights
    )
    hubble_values = sorted(set(args.hubble_values))
    for hubble in hubble_values:
        validate_background(args.duration, hubble)
    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(hubble_values) * args.realizations
    )
    samples: list[PoissonScaleGradientSample] = []
    index = 0
    for hubble in hubble_values:
        for _ in range(args.realizations):
            samples.append(
                reconstruct_scale_gradient_realization(
                    child_seeds[index],
                    args,
                    hubble,
                    response_weight,
                    gradient_penalty,
                )
            )
            index += 1
    summaries = {
        f"H={hubble:.6f}": summarize_samples(
            [sample for sample in samples if sample.hubble == hubble]
        )
        for hubble in hubble_values
    }
    result: dict[str, object] = {
        "status": "conditional Poisson-calibrated scale jet; not connection",
        "stage": "A31",
        "mode": "held-out",
        "claim_boundary": {
            "a29_tensor_and_a24_pivot_factor_are_retained": True,
            "only_the_count_factor_gradient_is_replaced": True,
            "gradient_penalty_is_frozen_before_curved_evaluation": True,
            "coordinates_density_dimension_and_windows_are_supplied": True,
            "levi_civita_connection_is_not_computed": True,
        },
        "calibration": {
            "gradient_input": str(args.gradient_calibration_input),
            "selected_gradient_penalty": gradient_penalty,
            "response_inputs": [
                str(path) for path in args.response_calibration_inputs
            ],
            "selected_temporal_response_weight": response_weight,
            "response_flat_density_scores": response_scores,
        },
        "settings": {
            "events": args.events,
            "realizations_per_background": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "hubble_values": hubble_values,
            "operator_nonlocality_multiplier": (
                args.operator_nonlocality_multiplier
            ),
            "operator_support_multiplier": args.operator_support_multiplier,
            "operator_averaging_multiplier": args.operator_averaging_multiplier,
            "count_window_multiplier": args.count_window_multiplier,
            "count_center_multiplier": args.count_center_multiplier,
            "maximum_operator_rows": args.maximum_operator_rows,
            "maximum_count_centers": args.maximum_count_centers,
            "seed": args.seed,
        },
        "background_summaries": summaries,
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=("development", "held-out"), required=True)
    parser.add_argument(
        "--calibration-events", type=int, nargs="+", default=[4000, 8000]
    )
    parser.add_argument("--calibration-realizations", type=int, default=10)
    parser.add_argument(
        "--gradient-penalties",
        type=float,
        nargs="+",
        default=[0.0, 0.1, 0.3, 1.0, 3.0, 10.0],
    )
    parser.add_argument(
        "--calibration-maximum-centers-factor", type=float, default=2.9
    )
    parser.add_argument("--gradient-calibration-input", type=Path)
    parser.add_argument(
        "--response-calibration-inputs", type=Path, nargs="+", default=[]
    )
    parser.add_argument(
        "--temporal-response-weights",
        type=float,
        nargs="+",
        default=[0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7],
    )
    parser.add_argument("--events", type=int, default=4000)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--pivot-fraction", type=float, default=0.7)
    parser.add_argument(
        "--hubble-values", type=float, nargs="+", default=[0.0, 0.1, 0.2]
    )
    parser.add_argument("--operator-nonlocality-multiplier", type=float, default=0.75)
    parser.add_argument("--operator-support-multiplier", type=float, default=1.8)
    parser.add_argument("--operator-averaging-multiplier", type=float, default=1.1)
    parser.add_argument("--count-window-multiplier", type=float, default=0.65)
    parser.add_argument("--count-center-multiplier", type=float, default=1.2)
    parser.add_argument("--maximum-operator-rows", type=int, default=128)
    parser.add_argument("--maximum-count-centers", type=int, default=128)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20261270)
    parser.add_argument("--include-samples", action="store_true")
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_development(args) if args.mode == "development" else run_held_out(args)
    rendered = json.dumps(result, indent=2, sort_keys=True)
    if args.output is not None:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered + "\n", encoding="utf-8", newline="\n")
    print(rendered)


if __name__ == "__main__":
    main()
