"""Stage A37 flat-selected scale-jet and connection convergence gate.

A36 constructs a finite Levi-Civita connection from the A35 metric first jet,
but its strongest curved cell worsens when density doubles.  A37 isolates the
count-scale derivative by selecting its mesoscopic window and Poisson penalty
only on flat affine, temporal-quadratic, and shear-quadratic charts.

The quadratic charts have exact nonzero Christoffel symbols but zero physical
curvature.  They prevent a zero-connection estimator from passing.  After
selection, fresh flat charts and conformally curved backgrounds are evaluated
at two densities.  Curvature remains closed regardless of this stage's result.

Coordinates, density, dimension, probes, chart maps, and windows are supplied.
The mapped-coordinate count windows are a conditional volume oracle, not a
bare-order construction.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_conformal_multirow_metric import append_interior_pivot
from causal_conformal_operator_metric import (
    sprinkle_conformal_de_sitter_diamond,
)
from causal_count_volume_weyl_metric import (
    count_window_scales,
    fit_affine_factor_field,
    window_fits_coordinate_diamond,
)
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    diamond_volume_4d,
    finite_statistics,
    matrix_relative_error,
    signature,
    strictly_precedes,
)
from causal_poisson_scale_gradient import (
    fit_penalized_poisson_factor_field,
)
from causal_quadratic_chart_shape_jet import (
    QuadraticChartControl,
    QuadraticChartShapeSample,
    quadratic_chart_controls,
    quadratic_chart_coordinates,
    quadratic_chart_target_connection,
    quadratic_chart_target_factor_gradient,
    reconstruct_chart_control_realization,
)
from causal_spread_fused_first_jet import (
    compose_fused_first_jet,
    reconstruct_spread_fused_realization,
)
from causal_spread_levi_civita_connection import (
    LeviCivitaConnectionSample,
    levi_civita_connection_from_inverse_metric,
    reconstruct_connection_sample,
    summarize_samples as summarize_curved_connections,
)


@dataclass(frozen=True)
class MappedCountWindowData:
    factor: float
    raw_gradient: np.ndarray
    offsets: np.ndarray
    counts: np.ndarray
    exposure: float
    independent_volume_density: float
    center_count: int
    minimum_window_count: int
    median_window_count: float


@dataclass(frozen=True)
class MappedCountGradientEstimate:
    factor: float
    factor_gradient: np.ndarray
    target_factor: float
    target_factor_gradient: np.ndarray
    independent_volume_density: float
    center_count: int
    minimum_window_count: int
    median_window_count: float
    poisson_iterations: int
    poisson_information_condition: float


@dataclass(frozen=True)
class FlatChartConnectionSample:
    events: int
    chart_name: str
    duration: float
    window_multiplier: float
    center_multiplier: float
    gradient_penalty: float
    tangent_weight: float
    row_count: int
    count_center_count: int
    minimum_count_window_count: int
    median_count_window_count: float
    metric_signature: tuple[int, int, int]
    metric_relative_error: float
    shape_relative_error: float
    count_factor_relative_error: float
    count_gradient_dimensionless_error: float
    factor_gradient: list[float]
    target_factor_gradient: list[float]
    connection: list[list[list[float]]]
    target_connection: list[list[list[float]]]
    connection_dimensionless_error: float
    zero_connection_baseline_error: float
    zero_scale_connection_error: float
    target_scale_connection_error: float
    oracle_shape_connection_error: float
    target_connection_dimensionless_norm: float
    connection_response_amplitude: float | None
    connection_orthogonal_noise: float | None


def setting_key(
    window_multiplier: float,
    center_multiplier: float,
    gradient_penalty: float,
) -> str:
    return (
        f"cW={window_multiplier:.6f}|cC={center_multiplier:.6f}|"
        f"lambda={gradient_penalty:.6f}"
    )


def select_spread_indices(
    coordinates: np.ndarray,
    candidates: np.ndarray,
    pivot: np.ndarray,
    maximum_count: int,
) -> np.ndarray:
    """Deterministic farthest-point selection from an admissible index set."""

    if maximum_count < 5 or len(candidates) < 5:
        raise ValueError("at least five candidates and slots are required")
    candidates = np.array(sorted(set(int(value) for value in candidates)), dtype=int)
    if len(candidates) <= maximum_count:
        return candidates
    candidate_points = coordinates[candidates]
    pivot_distance = np.sum((candidate_points - pivot) ** 2, axis=1)
    first = int(np.argmin(pivot_distance))
    selected_positions = [first]
    minimum_distance = np.sum(
        (candidate_points - candidate_points[first]) ** 2, axis=1
    )
    minimum_distance[first] = -1.0
    while len(selected_positions) < maximum_count:
        next_position = int(np.argmax(minimum_distance))
        selected_positions.append(next_position)
        distance = np.sum(
            (candidate_points - candidate_points[next_position]) ** 2, axis=1
        )
        minimum_distance = np.minimum(minimum_distance, distance)
        minimum_distance[selected_positions] = -1.0
    return np.sort(candidates[np.array(selected_positions, dtype=int)])


def select_mapped_count_centers(
    base_points: np.ndarray,
    mapped_points: np.ndarray,
    pivot_index: int,
    center_radius: float,
    window_half_duration: float,
    duration: float,
    maximum_centers: int,
    candidate_indices: np.ndarray,
) -> np.ndarray:
    """Select spread centers with a conservative base-diamond boundary check."""

    pivot = mapped_points[pivot_index]
    distances = np.linalg.norm(mapped_points[candidate_indices] - pivot, axis=1)
    nearby = candidate_indices[distances <= center_radius]
    admissible = np.array(
        [
            int(index)
            for index in nearby
            if window_fits_coordinate_diamond(
                base_points[int(index)], window_half_duration, duration
            )
        ],
        dtype=int,
    )
    if len(admissible) < 5:
        raise ValueError("fewer than five mapped count centers are admissible")
    return select_spread_indices(
        mapped_points, admissible, pivot, maximum_centers
    )


def mapped_coordinate_window_count(
    mapped_count_points: np.ndarray,
    center: np.ndarray,
    window_half_duration: float,
) -> int:
    """Count points in a local Minkowski-shaped mapped-coordinate window."""

    lower = np.array(center, dtype=float)
    upper = np.array(center, dtype=float)
    lower[0] -= window_half_duration
    upper[0] += window_half_duration
    inside = strictly_precedes(lower, mapped_count_points) & strictly_precedes(
        mapped_count_points, upper
    )
    same_as_center = np.all(
        np.isclose(mapped_count_points, center, atol=0.0), axis=1
    )
    return int(np.count_nonzero(inside & ~same_as_center))


def prepare_mapped_count_window_data(
    base_points: np.ndarray,
    mapped_points: np.ndarray,
    pivot_index: int,
    fit_indices: np.ndarray,
    validation_indices: np.ndarray,
    duration: float,
    window_multiplier: float,
    center_multiplier: float,
    maximum_centers: int,
) -> MappedCountWindowData:
    events = len(fit_indices) + len(validation_indices)
    coordinate_ell = (diamond_volume_4d(duration) / events) ** 0.25
    scales = count_window_scales(
        coordinate_ell, duration, window_multiplier, center_multiplier
    )
    candidate_indices = np.concatenate((fit_indices, validation_indices))
    centers = select_mapped_count_centers(
        base_points,
        mapped_points,
        pivot_index,
        scales.coordinate_center_radius,
        scales.coordinate_window_half_duration,
        duration,
        maximum_centers,
        candidate_indices,
    )
    physical_volume = diamond_volume_4d(duration)
    fit_density = len(fit_indices) / physical_volume
    validation_density = len(validation_indices) / physical_volume
    coordinate_volume = diamond_volume_4d(
        2.0 * scales.coordinate_window_half_duration
    )
    counts = np.array(
        [
            mapped_coordinate_window_count(
                mapped_points[fit_indices],
                mapped_points[int(center_index)],
                scales.coordinate_window_half_duration,
            )
            for center_index in centers
        ],
        dtype=float,
    )
    if np.any(counts <= 0.0):
        raise ValueError("a mapped count window is empty")
    factors = 1.0 / np.sqrt(counts / (fit_density * coordinate_volume))
    factor, raw_gradient, _, _ = fit_affine_factor_field(
        mapped_points, pivot_index, centers, factors
    )
    offsets = mapped_points[centers] - mapped_points[pivot_index]
    pivot_count = mapped_coordinate_window_count(
        mapped_points[validation_indices],
        mapped_points[pivot_index],
        scales.coordinate_window_half_duration,
    )
    if pivot_count <= 0:
        raise ValueError("the mapped validation window is empty")
    independent_volume = pivot_count / (validation_density * coordinate_volume)
    return MappedCountWindowData(
        factor=factor,
        raw_gradient=raw_gradient,
        offsets=offsets,
        counts=counts,
        exposure=fit_density * coordinate_volume,
        independent_volume_density=float(independent_volume),
        center_count=len(centers),
        minimum_window_count=int(np.min(counts)),
        median_window_count=float(np.median(counts)),
    )


def fit_mapped_count_gradient(
    data: MappedCountWindowData,
    control: QuadraticChartControl,
    penalty: float,
) -> MappedCountGradientEstimate:
    poisson_fit = fit_penalized_poisson_factor_field(
        data.offsets, data.counts, data.exposure, penalty
    )
    gradient = -0.5 * data.factor * poisson_fit.log_volume_gradient
    return MappedCountGradientEstimate(
        factor=data.factor,
        factor_gradient=gradient,
        target_factor=1.0,
        target_factor_gradient=quadratic_chart_target_factor_gradient(
            control.coefficients
        ),
        independent_volume_density=data.independent_volume_density,
        center_count=data.center_count,
        minimum_window_count=data.minimum_window_count,
        median_window_count=data.median_window_count,
        poisson_iterations=poisson_fit.iterations,
        poisson_information_condition=poisson_fit.information_condition,
    )


def normalized_connection_error(
    connection: np.ndarray,
    target: np.ndarray,
    duration: float,
) -> float:
    target_norm = duration * float(np.linalg.norm(target))
    return duration * float(np.linalg.norm(connection - target)) / max(
        1.0, target_norm
    )


def connection_response_decomposition(
    connection: np.ndarray,
    target: np.ndarray,
) -> tuple[float | None, float | None]:
    target_norm_squared = float(np.sum(target * target))
    if target_norm_squared == 0.0:
        return None, None
    amplitude = float(np.sum(connection * target) / target_norm_squared)
    orthogonal = connection - amplitude * target
    return amplitude, float(np.linalg.norm(orthogonal) / np.linalg.norm(target))


def compose_flat_connection_sample(
    shape_sample: QuadraticChartShapeSample,
    count: MappedCountGradientEstimate,
    control: QuadraticChartControl,
    tangent_weight: float,
    window_multiplier: float,
    center_multiplier: float,
    gradient_penalty: float,
) -> FlatChartConnectionSample:
    shape = np.array(shape_sample.shape, dtype=float)
    raw_shape_jet = np.array(shape_sample.shape_first_jet, dtype=float)
    target_shape_jet = np.array(
        shape_sample.target_shape_first_jet, dtype=float
    )
    inverse_metric, inverse_jet = compose_fused_first_jet(
        shape,
        raw_shape_jet,
        count.factor,
        count.factor_gradient,
        tangent_weight,
    )
    _, zero_scale_jet = compose_fused_first_jet(
        shape, raw_shape_jet, count.factor, np.zeros(4), tangent_weight
    )
    _, target_scale_jet = compose_fused_first_jet(
        shape,
        raw_shape_jet,
        count.factor,
        count.target_factor_gradient,
        tangent_weight,
    )
    _, oracle_shape_jet = compose_fused_first_jet(
        shape,
        target_shape_jet,
        count.factor,
        count.factor_gradient,
        1.0,
    )
    connection, _, _ = levi_civita_connection_from_inverse_metric(
        inverse_metric, inverse_jet
    )
    zero_scale_connection, _, _ = levi_civita_connection_from_inverse_metric(
        inverse_metric, zero_scale_jet
    )
    target_scale_connection, _, _ = levi_civita_connection_from_inverse_metric(
        inverse_metric, target_scale_jet
    )
    oracle_shape_connection, _, _ = levi_civita_connection_from_inverse_metric(
        inverse_metric, oracle_shape_jet
    )
    target_metric = MINKOWSKI_INVERSE
    target_connection = quadratic_chart_target_connection(control.coefficients)
    target_norm = shape_sample.duration * float(np.linalg.norm(target_connection))
    amplitude, orthogonal_noise = connection_response_decomposition(
        connection, target_connection
    )
    return FlatChartConnectionSample(
        events=shape_sample.events,
        chart_name=shape_sample.chart_name,
        duration=shape_sample.duration,
        window_multiplier=window_multiplier,
        center_multiplier=center_multiplier,
        gradient_penalty=gradient_penalty,
        tangent_weight=tangent_weight,
        row_count=shape_sample.row_count,
        count_center_count=count.center_count,
        minimum_count_window_count=count.minimum_window_count,
        median_count_window_count=count.median_window_count,
        metric_signature=signature(inverse_metric),
        metric_relative_error=matrix_relative_error(inverse_metric, target_metric),
        shape_relative_error=shape_sample.shape_relative_error,
        count_factor_relative_error=abs(count.factor - count.target_factor),
        count_gradient_dimensionless_error=float(
            shape_sample.duration
            * np.linalg.norm(
                count.factor_gradient - count.target_factor_gradient
            )
        ),
        factor_gradient=count.factor_gradient.tolist(),
        target_factor_gradient=count.target_factor_gradient.tolist(),
        connection=connection.tolist(),
        target_connection=target_connection.tolist(),
        connection_dimensionless_error=normalized_connection_error(
            connection, target_connection, shape_sample.duration
        ),
        zero_connection_baseline_error=normalized_connection_error(
            np.zeros((4, 4, 4)), target_connection, shape_sample.duration
        ),
        zero_scale_connection_error=normalized_connection_error(
            zero_scale_connection, target_connection, shape_sample.duration
        ),
        target_scale_connection_error=normalized_connection_error(
            target_scale_connection, target_connection, shape_sample.duration
        ),
        oracle_shape_connection_error=normalized_connection_error(
            oracle_shape_connection, target_connection, shape_sample.duration
        ),
        target_connection_dimensionless_norm=target_norm,
        connection_response_amplitude=amplitude,
        connection_orthogonal_noise=orthogonal_noise,
    )


def reconstruct_flat_setting_samples(
    child_seed: np.random.SeedSequence,
    args: argparse.Namespace,
    controls: list[QuadraticChartControl],
    settings: list[tuple[float, float, float]],
    averaging_multiplier: float,
    tangent_weight: float,
) -> dict[str, list[FlatChartConnectionSample]]:
    maximum_rows = max(
        5, int(round(args.maximum_operator_rows_factor * np.sqrt(args.events)))
    )
    shape_samples = reconstruct_chart_control_realization(
        np.random.default_rng(child_seed),
        args.events,
        args.duration,
        controls,
        args.temporal_response_weight,
        args.operator_nonlocality_multiplier,
        args.operator_support_multiplier,
        averaging_multiplier,
        maximum_rows,
        args.block_size,
        args.pivot_fraction,
        target_selection="spread",
    )
    count_rng = np.random.default_rng(child_seed)
    points, top_index = sprinkle_conformal_de_sitter_diamond(
        count_rng, args.events, args.duration, 0.0
    )
    points, pivot_index, _ = append_interior_pivot(
        points, top_index, args.duration, args.pivot_fraction
    )
    shuffled = count_rng.permutation(np.arange(args.events))
    split = args.events // 2
    fit_indices = np.sort(shuffled[:split])
    validation_indices = np.sort(shuffled[split:])
    maximum_centers = max(
        5, int(round(args.maximum_count_centers_factor * np.sqrt(args.events)))
    )
    unique_windows = sorted({(window, center) for window, center, _ in settings})
    output = {setting_key(*setting): [] for setting in settings}
    pivot = points[pivot_index]
    for control, shape_sample in zip(controls, shape_samples, strict=True):
        mapped = quadratic_chart_coordinates(points, pivot, control.coefficients)
        window_data = {
            (window, center): prepare_mapped_count_window_data(
                points,
                mapped,
                pivot_index,
                fit_indices,
                validation_indices,
                args.duration,
                window,
                center,
                maximum_centers,
            )
            for window, center in unique_windows
        }
        for window, center, penalty in settings:
            count = fit_mapped_count_gradient(
                window_data[(window, center)], control, penalty
            )
            output[setting_key(window, center, penalty)].append(
                compose_flat_connection_sample(
                    shape_sample,
                    count,
                    control,
                    tangent_weight,
                    window,
                    center,
                    penalty,
                )
            )
    return output


def summarize_flat_samples(
    samples: list[FlatChartConnectionSample],
) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize empty flat-chart samples")
    connections = np.array([sample.connection for sample in samples])
    target = np.array(samples[0].target_connection)
    factor_gradients = np.array([sample.factor_gradient for sample in samples])
    target_factor_gradient = np.array(samples[0].target_factor_gradient)
    duration = samples[0].duration
    target_norm = samples[0].target_connection_dimensionless_norm
    target_factor_norm_squared = float(
        np.sum(target_factor_gradient * target_factor_gradient)
    )
    scale_amplitude = (
        None
        if target_factor_norm_squared == 0.0
        else float(
            np.sum(np.mean(factor_gradients, axis=0) * target_factor_gradient)
            / target_factor_norm_squared
        )
    )
    return {
        "events": samples[0].events,
        "chart_name": samples[0].chart_name,
        "metric_signature_success_rate": sum(
            sample.metric_signature == (1, 3, 0) for sample in samples
        )
        / len(samples),
        "metric_relative_error": finite_statistics(
            [sample.metric_relative_error for sample in samples]
        ),
        "shape_relative_error": finite_statistics(
            [sample.shape_relative_error for sample in samples]
        ),
        "count_factor_relative_error": finite_statistics(
            [sample.count_factor_relative_error for sample in samples]
        ),
        "count_gradient_dimensionless_error": finite_statistics(
            [sample.count_gradient_dimensionless_error for sample in samples]
        ),
        "ensemble_count_gradient_dimensionless_error": float(
            duration
            * np.linalg.norm(
                np.mean(factor_gradients, axis=0) - target_factor_gradient
            )
        ),
        "ensemble_scale_response_amplitude": scale_amplitude,
        "connection_dimensionless_error": finite_statistics(
            [sample.connection_dimensionless_error for sample in samples]
        ),
        "ensemble_connection_dimensionless_error": float(
            duration * np.linalg.norm(np.mean(connections, axis=0) - target)
            / max(1.0, target_norm)
        ),
        "zero_connection_baseline_error": samples[0].zero_connection_baseline_error,
        "zero_scale_connection_error": finite_statistics(
            [sample.zero_scale_connection_error for sample in samples]
        ),
        "target_scale_connection_error": finite_statistics(
            [sample.target_scale_connection_error for sample in samples]
        ),
        "oracle_shape_connection_error": finite_statistics(
            [sample.oracle_shape_connection_error for sample in samples]
        ),
        "connection_response_amplitude": finite_statistics(
            [sample.connection_response_amplitude for sample in samples]
        ),
        "connection_orthogonal_noise": finite_statistics(
            [sample.connection_orthogonal_noise for sample in samples]
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
    }


def summarize_flat_setting(
    samples: list[FlatChartConnectionSample],
    metric_error_threshold: float,
) -> dict[str, object]:
    cells = sorted({(sample.events, sample.chart_name) for sample in samples})
    cell_summaries = {
        f"N={events}|chart={chart_name}": summarize_flat_samples(
            [
                sample
                for sample in samples
                if sample.events == events and sample.chart_name == chart_name
            ]
        )
        for events, chart_name in cells
    }
    signature_pass = all(
        float(cell["metric_signature_success_rate"]) == 1.0
        for cell in cell_summaries.values()
    )
    metric_pass = all(
        float(cell["metric_relative_error"]["median"])
        < metric_error_threshold
        for cell in cell_summaries.values()
    )
    nonzero_cells = [
        cell
        for cell in cell_summaries.values()
        if float(cell["zero_connection_baseline_error"]) > 0.0
    ]
    nonzero_connection_pass = all(
        float(cell["connection_dimensionless_error"]["median"])
        < float(cell["zero_connection_baseline_error"])
        and float(cell["ensemble_connection_dimensionless_error"])
        < float(cell["zero_connection_baseline_error"])
        for cell in nonzero_cells
    )
    scale_cells = [
        cell
        for cell in cell_summaries.values()
        if cell["ensemble_scale_response_amplitude"] is not None
    ]
    nonzero_scale_pass = all(
        float(cell["ensemble_scale_response_amplitude"]) > 0.0
        for cell in scale_cells
    )
    return {
        "cells": cell_summaries,
        "signature_pass": signature_pass,
        "metric_pass": metric_pass,
        "nonzero_connection_pass": nonzero_connection_pass,
        "nonzero_scale_pass": nonzero_scale_pass,
        "flat_gate_pass": (
            signature_pass
            and metric_pass
            and nonzero_connection_pass
            and nonzero_scale_pass
        ),
        "worst_cell_median_connection_error": max(
            float(cell["connection_dimensionless_error"]["median"])
            for cell in cell_summaries.values()
        ),
        "worst_cell_ensemble_connection_error": max(
            float(cell["ensemble_connection_dimensionless_error"])
            for cell in cell_summaries.values()
        ),
        "worst_cell_median_count_gradient_error": max(
            float(cell["count_gradient_dimensionless_error"]["median"])
            for cell in cell_summaries.values()
        ),
        "worst_cell_ensemble_count_gradient_error": max(
            float(cell["ensemble_count_gradient_dimensionless_error"])
            for cell in cell_summaries.values()
        ),
    }


def select_flat_setting(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    def score(item: tuple[str, dict[str, object]]) -> tuple[float, ...]:
        summary = item[1]
        return (
            -float(bool(summary["flat_gate_pass"])),
            -float(bool(summary["signature_pass"])),
            -float(bool(summary["metric_pass"])),
            -float(bool(summary["nonzero_connection_pass"])),
            -float(bool(summary["nonzero_scale_pass"])),
            float(summary["worst_cell_median_connection_error"]),
            float(summary["worst_cell_ensemble_connection_error"]),
            float(summary["worst_cell_median_count_gradient_error"]),
            float(summary["worst_cell_ensemble_count_gradient_error"]),
        )

    return min(summaries.items(), key=score)


def load_spread_setting(path: Path) -> tuple[float, float]:
    artifact = json.loads(path.read_text(encoding="utf-8"))
    if artifact.get("stage") != "A34":
        raise ValueError("spread selection input must be an A34 artifact")
    selected = artifact["selected_setting"]
    if not bool(selected["beats_zero_baseline"]):
        raise ValueError("the A34 setting does not beat the zero baseline")
    if not bool(selected["pivot_tensor_pass"]):
        raise ValueError("the A34 setting does not preserve the pivot gate")
    return float(selected["averaging_multiplier"]), float(
        selected["tangent_weight"]
    )


def run_development(args: argparse.Namespace) -> dict[str, object]:
    if len(set(args.events_values)) < 2:
        raise ValueError("A37 development requires at least two densities")
    averaging_multiplier, tangent_weight = load_spread_setting(
        args.spread_selection_input
    )
    controls = quadratic_chart_controls()
    settings = [
        (window, center, penalty)
        for window in sorted(set(args.count_window_multipliers))
        for center in sorted(set(args.count_center_multipliers))
        for penalty in sorted(set(args.gradient_penalties))
    ]
    density_realizations = [
        (events, realization)
        for events in sorted(set(args.events_values))
        for realization in range(args.realizations)
    ]
    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(density_realizations)
    )
    setting_samples = {setting_key(*setting): [] for setting in settings}
    for index, (events, _) in enumerate(density_realizations):
        local_args = argparse.Namespace(**vars(args))
        local_args.events = events
        reconstructed = reconstruct_flat_setting_samples(
            child_seeds[index],
            local_args,
            controls,
            settings,
            averaging_multiplier,
            tangent_weight,
        )
        for key, samples in reconstructed.items():
            setting_samples[key].extend(samples)
    summaries = {
        key: summarize_flat_setting(samples, args.metric_error_threshold)
        for key, samples in setting_samples.items()
    }
    selected_key, selected_summary = select_flat_setting(summaries)
    selected_sample = setting_samples[selected_key][0]
    selected_setting = {
        "key": selected_key,
        "window_multiplier": selected_sample.window_multiplier,
        "center_multiplier": selected_sample.center_multiplier,
        "gradient_penalty": selected_sample.gradient_penalty,
        "flat_gate_pass": selected_summary["flat_gate_pass"],
    }
    result: dict[str, object] = {
        "status": "flat-only connection-scale selection; not convergence",
        "stage": "A37",
        "mode": "development",
        "claim_boundary": {
            "all_selection_backgrounds_are_flat": True,
            "nonzero_connection_and_scale_responses_are_required": True,
            "quadratic_flat_charts_have_zero_physical_curvature": True,
            "mapped_coordinate_count_windows_are_supplied": True,
            "curved_targets_are_not_used": True,
            "curvature_is_not_computed": True,
        },
        "selected_setting": selected_setting,
        "setting_summaries": summaries,
        "calibration": {
            "spread_selection_input": str(args.spread_selection_input),
            "averaging_multiplier": averaging_multiplier,
            "tangent_weight": tangent_weight,
        },
        "settings": {
            "events_values": sorted(set(args.events_values)),
            "realizations_per_density": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "count_window_multipliers": sorted(
                set(args.count_window_multipliers)
            ),
            "count_center_multipliers": sorted(
                set(args.count_center_multipliers)
            ),
            "gradient_penalties": sorted(set(args.gradient_penalties)),
            "metric_error_threshold": args.metric_error_threshold,
            "seed": args.seed,
        },
    }
    if args.include_samples:
        result["selected_samples"] = [
            asdict(sample) for sample in setting_samples[selected_key]
        ]
    return result


def summarize_heldout_pass(
    flat_summary: dict[str, object],
    curved_summaries: dict[str, dict[str, object]],
) -> dict[str, object]:
    flat_cells = flat_summary["cells"]
    assert isinstance(flat_cells, dict)
    high_density = max(int(key.split("|")[0].split("=")[1]) for key in flat_cells)
    low_density = min(int(key.split("|")[0].split("=")[1]) for key in flat_cells)
    high_flat = [
        cell
        for key, cell in flat_cells.items()
        if key.startswith(f"N={high_density}|")
    ]
    low_flat = [
        cell
        for key, cell in flat_cells.items()
        if key.startswith(f"N={low_density}|")
    ]
    high_curved = [
        cell
        for key, cell in curved_summaries.items()
        if key.startswith(f"N={high_density}|")
    ]
    low_curved = [
        cell
        for key, cell in curved_summaries.items()
        if key.startswith(f"N={low_density}|")
    ]
    high_medians = [
        float(cell["connection_dimensionless_error"]["median"])
        for cell in high_flat + high_curved
    ]
    high_ensembles = [
        float(cell["ensemble_connection_dimensionless_error"])
        for cell in high_flat + high_curved
    ]
    low_medians = [
        float(cell["connection_dimensionless_error"]["median"])
        for cell in low_flat + low_curved
    ]
    low_ensembles = [
        float(cell["ensemble_connection_dimensionless_error"])
        for cell in low_flat + low_curved
    ]
    h2_low = curved_summaries[f"N={low_density}|H=0.200000"]
    h2_high = curved_summaries[f"N={high_density}|H=0.200000"]
    high_density_subunit = max(high_medians + high_ensembles) < 1.0
    worst_refinement_pass = (
        max(high_medians) < max(low_medians)
        and max(high_ensembles) < max(low_ensembles)
    )
    h2_regression_removed = (
        float(h2_high["connection_dimensionless_error"]["median"])
        < float(h2_low["connection_dimensionless_error"]["median"])
        and float(h2_high["ensemble_connection_dimensionless_error"])
        < float(h2_low["ensemble_connection_dimensionless_error"])
    )
    return {
        "pivot_and_flat_response_pass": bool(flat_summary["flat_gate_pass"]),
        "high_density_subunit_pass": high_density_subunit,
        "worst_cell_refinement_pass": worst_refinement_pass,
        "h2_regression_removed": h2_regression_removed,
        "heldout_pass": (
            bool(flat_summary["flat_gate_pass"])
            and high_density_subunit
            and worst_refinement_pass
            and h2_regression_removed
        ),
        "low_density_worst_median": max(low_medians),
        "high_density_worst_median": max(high_medians),
        "low_density_worst_ensemble": max(low_ensembles),
        "high_density_worst_ensemble": max(high_ensembles),
        "h2_low_density_median": float(
            h2_low["connection_dimensionless_error"]["median"]
        ),
        "h2_high_density_median": float(
            h2_high["connection_dimensionless_error"]["median"]
        ),
    }


def run_heldout(args: argparse.Namespace) -> dict[str, object]:
    if args.selection_input is None:
        raise ValueError("held-out mode requires --selection-input")
    selection = json.loads(args.selection_input.read_text(encoding="utf-8"))
    if selection.get("stage") != "A37" or selection.get("mode") != "development":
        raise ValueError("selection input must be an A37 development artifact")
    development_seed = int(selection["settings"]["seed"])
    if args.seed == development_seed:
        raise ValueError("held-out seed must differ from the development seed")
    selected = selection["selected_setting"]
    averaging_multiplier = float(selection["calibration"]["averaging_multiplier"])
    tangent_weight = float(selection["calibration"]["tangent_weight"])
    window_multiplier = float(selected["window_multiplier"])
    center_multiplier = float(selected["center_multiplier"])
    gradient_penalty = float(selected["gradient_penalty"])
    controls = quadratic_chart_controls()
    settings = [(window_multiplier, center_multiplier, gradient_penalty)]
    density_realizations = [
        (events, realization)
        for events in sorted(set(args.events_values))
        for realization in range(args.realizations)
    ]
    flat_seeds = np.random.SeedSequence(args.seed).spawn(
        len(density_realizations)
    )
    flat_samples: list[FlatChartConnectionSample] = []
    for index, (events, _) in enumerate(density_realizations):
        local_args = argparse.Namespace(**vars(args))
        local_args.events = events
        reconstructed = reconstruct_flat_setting_samples(
            flat_seeds[index],
            local_args,
            controls,
            settings,
            averaging_multiplier,
            tangent_weight,
        )
        flat_samples.extend(next(iter(reconstructed.values())))
    flat_summary = summarize_flat_setting(
        flat_samples, args.metric_error_threshold
    )

    curved_cells = [
        (events, hubble, realization)
        for events in sorted(set(args.events_values))
        for hubble in sorted(set(args.hubble_values))
        for realization in range(args.realizations)
    ]
    curved_seeds = np.random.SeedSequence(args.seed + 1).spawn(
        len(curved_cells)
    )
    curved_samples: list[LeviCivitaConnectionSample] = []
    for index, (events, hubble, _) in enumerate(curved_cells):
        local_args = argparse.Namespace(**vars(args))
        local_args.events = events
        local_args.count_window_multiplier = window_multiplier
        local_args.count_center_multiplier = center_multiplier
        local_args.maximum_count_centers = max(
            5,
            int(round(args.maximum_count_centers_factor * np.sqrt(events))),
        )
        fused = reconstruct_spread_fused_realization(
            curved_seeds[index],
            local_args,
            hubble,
            averaging_multiplier,
            tangent_weight,
            gradient_penalty,
        )
        curved_samples.append(
            reconstruct_connection_sample(asdict(fused), events)
        )
    curved_cell_keys = sorted(
        {(sample.events, sample.hubble) for sample in curved_samples}
    )
    curved_summaries = {
        f"N={events}|H={hubble:.6f}": summarize_curved_connections(
            [
                sample
                for sample in curved_samples
                if sample.events == events and sample.hubble == hubble
            ]
        )
        for events, hubble in curved_cell_keys
    }
    pass_summary = summarize_heldout_pass(flat_summary, curved_summaries)
    result: dict[str, object] = {
        "status": (
            "A37 held-out connection gate passed"
            if pass_summary["heldout_pass"]
            else "A37 held-out connection gate failed; curvature remains closed"
        ),
        "stage": "A37",
        "mode": "held-out",
        "claim_boundary": {
            "selection_is_frozen_on_flat_charts": True,
            "curved_targets_are_held_out": True,
            "mapped_coordinate_count_windows_are_supplied": True,
            "coordinates_density_dimension_probes_and_windows_are_supplied": True,
            "connection_convergence_requires_all_preregistered_gates": True,
            "curvature_is_not_computed": True,
        },
        "calibration": {
            "selection_input": str(args.selection_input),
            "development_seed": development_seed,
            "averaging_multiplier": averaging_multiplier,
            "tangent_weight": tangent_weight,
            "window_multiplier": window_multiplier,
            "center_multiplier": center_multiplier,
            "gradient_penalty": gradient_penalty,
        },
        "flat_summary": flat_summary,
        "curved_summaries": curved_summaries,
        "pass_summary": pass_summary,
        "settings": {
            "events_values": sorted(set(args.events_values)),
            "realizations_per_cell": args.realizations,
            "hubble_values": sorted(set(args.hubble_values)),
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "seed": args.seed,
        },
    }
    if args.include_samples:
        result["flat_samples"] = [asdict(sample) for sample in flat_samples]
        result["curved_samples"] = [asdict(sample) for sample in curved_samples]
    return result


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    if args.mode == "development":
        return run_development(args)
    return run_heldout(args)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=["development", "held-out"], required=True)
    parser.add_argument("--spread-selection-input", type=Path, required=True)
    parser.add_argument("--selection-input", type=Path)
    parser.add_argument("--events-values", type=int, nargs="+", default=[4000, 8000])
    parser.add_argument("--realizations", type=int, default=4)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--pivot-fraction", type=float, default=0.7)
    parser.add_argument("--temporal-response-weight", type=float, default=0.6)
    parser.add_argument("--operator-nonlocality-multiplier", type=float, default=0.75)
    parser.add_argument("--operator-support-multiplier", type=float, default=1.8)
    parser.add_argument("--maximum-operator-rows-factor", type=float, default=4.0)
    parser.add_argument("--maximum-count-centers-factor", type=float, default=1.8)
    parser.add_argument(
        "--count-window-multipliers", type=float, nargs="+", default=[0.5, 0.65, 0.8]
    )
    parser.add_argument(
        "--count-center-multipliers", type=float, nargs="+", default=[1.2, 1.5, 1.8]
    )
    parser.add_argument(
        "--gradient-penalties", type=float, nargs="+", default=[0.0, 0.03, 0.1, 0.3, 0.8]
    )
    parser.add_argument("--metric-error-threshold", type=float, default=0.3)
    parser.add_argument("--hubble-values", type=float, nargs="+", default=[0.1, 0.2])
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20261370)
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
