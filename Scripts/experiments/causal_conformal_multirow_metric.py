"""Stage A23 shrinking-scale multirow metric and first-jet calibration.

This experiment extends the Stage A22 conformal de Sitter control from one
retarded causal-operator row to a local field fit around an interior pivot.
The mesoscopic schedule is

    L = c_L sqrt(ell T),
    S = c_S sqrt(L T),
    A = c_A L,

where ``ell`` is the supplied discreteness scale, ``L`` is the operator
nonlocality scale, ``S`` is the compact-probe support, and ``A`` is the
multirow averaging radius.  Under density refinement, ``ell/L -> 0``,
``L/S -> 0``, and all three mesoscopic scales tend to zero.

Pairings from nearby rows are regressed against affine coordinate offsets.
The intercept estimates the inverse metric at the pivot and the four slopes
estimate its first jet.  Development selects schedule multipliers using flat
controls only.  Curved metric and first-jet targets remain unopened during
selection.

Coordinates are still used to select rows, construct probes, and score the
known target.  This is therefore a curved operator and first-jet calibration,
not intrinsic reconstruction from a bare graph.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_conformal_operator_metric import (
    conformal_diamond_volume,
    conformal_factor_squared_from_inverse_metric,
    de_sitter_conformal_scale,
    sprinkle_conformal_de_sitter_diamond,
    target_volume_density,
    validate_background,
)
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_probe_metric import selected_open_interval_counts
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    compact_coordinate_probes,
    corrected_gamma,
    finite_statistics,
    fixed_probe_transform,
    matrix_relative_error,
    project_convention_row,
    signature,
    smeared_bd_row,
    volume_density_from_inverse_metric,
)


@dataclass(frozen=True)
class ScheduledScales:
    ell: float
    nonlocality_scale: float
    support_radius: float
    averaging_radius: float


@dataclass(frozen=True)
class ConformalMultirowSample:
    hubble: float
    duration: float
    nonlocality_multiplier: float
    support_multiplier: float
    averaging_multiplier: float
    ell: float
    nonlocality_scale: float
    physical_support_radius: float
    physical_averaging_radius: float
    row_count: int
    design_rank: int
    design_condition: float
    mean_coordinate_time_offset: float
    retarded_moment: list[float]
    retarded_moment_first_jet: list[list[float]]
    metric: list[list[float]]
    target_metric: list[list[float]]
    metric_relative_error: float
    signature: tuple[int, int, int]
    volume_density: float | None
    target_volume_density: float
    volume_relative_error: float | None
    conformal_factor_squared_estimate: float
    conformal_factor_squared_target: float
    conformal_factor_squared_relative_error: float
    metric_first_jet: list[list[list[float]]]
    target_metric_first_jet: list[list[list[float]]]
    first_jet_dimensionless_error: float
    temporal_first_jet_relative_error: float | None
    spatial_first_jet_dimensionless_noise: float
    projected_conformal_first_gradient: list[float]
    target_projected_conformal_first_gradient: list[float]
    projected_conformal_gradient_dimensionless_error: float
    projected_temporal_gradient_relative_error: float | None
    projected_spatial_gradient_dimensionless_noise: float
    affine_metric_covariance_relative_error: float
    affine_first_jet_covariance_relative_error: float


def refinement_scales(
    ell: float,
    duration: float,
    nonlocality_multiplier: float,
    support_multiplier: float,
    averaging_multiplier: float,
) -> ScheduledScales:
    """Construct a three-scale schedule with the required asymptotics."""

    if ell <= 0.0 or duration <= 0.0:
        raise ValueError("ell and duration must be positive")
    if min(nonlocality_multiplier, support_multiplier, averaging_multiplier) <= 0.0:
        raise ValueError("all schedule multipliers must be positive")
    nonlocality_scale = nonlocality_multiplier * np.sqrt(ell * duration)
    support_radius = support_multiplier * np.sqrt(
        nonlocality_scale * duration
    )
    averaging_radius = averaging_multiplier * nonlocality_scale
    if nonlocality_scale <= ell:
        raise ValueError("the nonlocality scale must exceed ell")
    if averaging_radius >= support_radius / 2.0:
        raise ValueError("the averaging ball must lie inside the probe germ")
    return ScheduledScales(
        ell=ell,
        nonlocality_scale=float(nonlocality_scale),
        support_radius=float(support_radius),
        averaging_radius=float(averaging_radius),
    )


def append_interior_pivot(
    points: np.ndarray,
    top_index: int,
    duration: float,
    pivot_fraction: float = 0.7,
) -> tuple[np.ndarray, int, int]:
    """Insert the deterministic central calibration event before the top."""

    if top_index != len(points) - 1:
        raise ValueError("the conformal sampler must place the top event last")
    if not 0.0 < pivot_fraction < 1.0:
        raise ValueError("pivot fraction must lie strictly between zero and one")
    pivot = np.array([[pivot_fraction * duration, 0.0, 0.0, 0.0]])
    extended = np.concatenate((points[:top_index], pivot, points[top_index:]))
    return extended, top_index, top_index + 1


def target_inverse_metric_at(time: float, hubble: float) -> np.ndarray:
    scale = float(de_sitter_conformal_scale(time, hubble))
    return MINKOWSKI_INVERSE / scale**2


def target_inverse_metric_first_jet(time: float, hubble: float) -> np.ndarray:
    """Coordinate first jet ``partial_mu g^{ab}`` in project signature."""

    jet = np.zeros((4, 4, 4), dtype=float)
    scalar_derivative = -2.0 * hubble * (1.0 - hubble * time)
    jet[0] = scalar_derivative * MINKOWSKI_INVERSE
    return jet


def select_local_targets(
    points: np.ndarray,
    pivot_index: int,
    coordinate_radius: float,
    maximum_rows: int,
) -> np.ndarray:
    if coordinate_radius <= 0.0 or maximum_rows < 5:
        raise ValueError("require a positive radius and at least five rows")
    distance = np.linalg.norm(points - points[pivot_index], axis=1)
    targets = np.flatnonzero(distance <= coordinate_radius)
    if len(targets) > maximum_rows:
        order = np.argsort(distance[targets], kind="stable")
        targets = targets[order[:maximum_rows]]
    if pivot_index not in targets:
        targets = np.append(targets, pivot_index)
    return np.sort(targets)


def select_spread_local_targets(
    points: np.ndarray,
    pivot_index: int,
    coordinate_radius: float,
    maximum_rows: int,
) -> np.ndarray:
    """Select a deterministic farthest-point scaffold across the whole ball."""

    if coordinate_radius <= 0.0 or maximum_rows < 5:
        raise ValueError("require a positive radius and at least five rows")
    offsets = points - points[pivot_index]
    distances = np.linalg.norm(offsets, axis=1)
    candidates = np.flatnonzero(distances <= coordinate_radius)
    if pivot_index not in candidates:
        candidates = np.append(candidates, pivot_index)
    if len(candidates) <= maximum_rows:
        return np.sort(candidates)

    candidate_points = offsets[candidates]
    pivot_position = int(np.flatnonzero(candidates == pivot_index)[0])
    selected_positions = [pivot_position]
    minimum_distance_squared = np.sum(
        (candidate_points - candidate_points[pivot_position]) ** 2, axis=1
    )
    minimum_distance_squared[pivot_position] = -1.0
    while len(selected_positions) < maximum_rows:
        next_position = int(np.argmax(minimum_distance_squared))
        selected_positions.append(next_position)
        distance_squared = np.sum(
            (candidate_points - candidate_points[next_position]) ** 2, axis=1
        )
        minimum_distance_squared = np.minimum(
            minimum_distance_squared, distance_squared
        )
        minimum_distance_squared[selected_positions] = -1.0
    return np.sort(candidates[np.array(selected_positions, dtype=int)])


def fit_affine_metric_field(
    points: np.ndarray,
    pivot_index: int,
    targets: np.ndarray,
    pairings: np.ndarray,
) -> tuple[np.ndarray, np.ndarray, int, float]:
    """Fit a symmetric metric intercept and first jet in one chart."""

    if pairings.shape != (len(targets), 4, 4):
        raise ValueError("pairings must have shape (row_count, 4, 4)")
    offsets = points[targets] - points[pivot_index]
    design = np.column_stack((np.ones(len(targets)), offsets))
    coefficients, _, rank, singular_values = np.linalg.lstsq(
        design, pairings.reshape(len(targets), 16), rcond=None
    )
    intercept = coefficients[0].reshape(4, 4)
    first_jet = coefficients[1:].reshape(4, 4, 4)
    intercept = 0.5 * (intercept + intercept.T)
    first_jet = 0.5 * (first_jet + np.swapaxes(first_jet, 1, 2))
    condition = (
        float("inf")
        if len(singular_values) < 5 or singular_values[-1] <= 0.0
        else float(singular_values[0] / singular_values[-1])
    )
    return intercept, first_jet, int(rank), condition


def retarded_probe_moment(
    row: np.ndarray,
    probes: np.ndarray,
    target_index: int,
) -> np.ndarray:
    """Return the positive-kernel first moment in the supplied probe sector."""

    if row.ndim != 1 or probes.shape[0] != len(row):
        raise ValueError("row and probes must share their event dimension")
    weights = np.abs(row).copy()
    weights[target_index] = 0.0
    total = float(np.sum(weights))
    if total <= 0.0:
        raise ValueError("the retarded row must have nonzero off-target support")
    centered = probes - probes[target_index]
    return np.asarray(weights @ centered / total, dtype=float)


def fit_affine_vector_field(
    points: np.ndarray,
    pivot_index: int,
    targets: np.ndarray,
    values: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    """Fit a local affine vector field and return its intercept and first jet."""

    if values.shape != (len(targets), 4):
        raise ValueError("values must have shape (row_count, 4)")
    offsets = points[targets] - points[pivot_index]
    design = np.column_stack((np.ones(len(targets)), offsets))
    coefficients, _, _, _ = np.linalg.lstsq(design, values, rcond=None)
    return (
        np.asarray(coefficients[0], dtype=float),
        np.asarray(coefficients[1:], dtype=float),
    )


def fit_affine_vector_intercept(
    points: np.ndarray,
    pivot_index: int,
    targets: np.ndarray,
    values: np.ndarray,
) -> np.ndarray:
    """Fit a local affine vector field and return only its pivot intercept."""

    return fit_affine_vector_field(points, pivot_index, targets, values)[0]


def affine_first_jet_covariance_error(
    actual: np.ndarray,
    expected: np.ndarray,
) -> float:
    denominator = np.linalg.norm(expected)
    if denominator == 0.0:
        return float(np.linalg.norm(actual - expected))
    return float(np.linalg.norm(actual - expected) / denominator)


def setting_key(
    nonlocality_multiplier: float,
    support_multiplier: float,
    averaging_multiplier: float,
) -> str:
    return (
        f"cL={nonlocality_multiplier:.6f}|"
        f"cS={support_multiplier:.6f}|"
        f"cA={averaging_multiplier:.6f}"
    )


def reconstruct_multirow_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    hubble: float,
    nonlocality_multipliers: list[float],
    support_multipliers: list[float],
    averaging_multipliers: list[float],
    maximum_rows: int,
    block_size: int,
    pivot_fraction: float = 0.7,
) -> list[ConformalMultirowSample]:
    points, top_index = sprinkle_conformal_de_sitter_diamond(
        rng, events, duration, hubble
    )
    points, pivot_index, _ = append_interior_pivot(
        points, top_index, duration, pivot_fraction
    )
    relation = causal_relation_matrix(points, block_size)
    physical_volume = conformal_diamond_volume(duration, hubble)
    ell = (physical_volume / events) ** 0.25
    pivot_time = pivot_fraction * duration
    pivot_scale = float(de_sitter_conformal_scale(pivot_time, hubble))

    configurations: dict[str, tuple[ScheduledScales, np.ndarray]] = {}
    for c_l in nonlocality_multipliers:
        for c_s in support_multipliers:
            for c_a in averaging_multipliers:
                scales = refinement_scales(ell, duration, c_l, c_s, c_a)
                targets = select_local_targets(
                    points,
                    pivot_index,
                    scales.averaging_radius / pivot_scale,
                    maximum_rows,
                )
                configurations[setting_key(c_l, c_s, c_a)] = (scales, targets)

    all_targets = np.unique(
        np.concatenate([targets for _, targets in configurations.values()])
    )
    open_counts = selected_open_interval_counts(
        relation, np.arange(len(relation)), all_targets
    )
    target_column = {int(target): column for column, target in enumerate(all_targets)}
    unique_scales = sorted(
        {scales.nonlocality_scale for scales, _ in configurations.values()}
    )
    rows: dict[tuple[float, int], np.ndarray] = {}
    for nonlocality_scale in unique_scales:
        for target in all_targets:
            target_int = int(target)
            past = relation[:, target_int]
            counts = open_counts[:, target_column[target_int]]
            rows[(nonlocality_scale, target_int)] = project_convention_row(
                smeared_bd_row(
                    past,
                    counts,
                    target_int,
                    ell,
                    nonlocality_scale,
                )
            )

    target_metric = target_inverse_metric_at(pivot_time, hubble)
    target_jet = target_inverse_metric_first_jet(pivot_time, hubble)
    target_density = target_volume_density(pivot_time, hubble)
    target_factor = conformal_factor_squared_from_inverse_metric(target_metric)
    metric_norm = np.linalg.norm(target_metric)
    linear, offset = fixed_probe_transform()
    samples: list[ConformalMultirowSample] = []

    for key, (scales, targets) in configurations.items():
        c_l_text, c_s_text, c_a_text = key.split("|")
        c_l = float(c_l_text.split("=")[1])
        c_s = float(c_s_text.split("=")[1])
        c_a = float(c_a_text.split("=")[1])
        pairings_list: list[np.ndarray] = []
        transformed_pairings_list: list[np.ndarray] = []
        moments_list: list[np.ndarray] = []
        for target in targets:
            target_int = int(target)
            target_scale = float(
                de_sitter_conformal_scale(points[target_int, 0], hubble)
            )
            probes = compact_coordinate_probes(
                points, target_int, scales.support_radius / target_scale
            )
            transformed_probes = probes @ linear.T + offset
            row = rows[(scales.nonlocality_scale, target_int)]
            pairings_list.append(corrected_gamma(row, probes, target_int))
            moments_list.append(retarded_probe_moment(row, probes, target_int))
            transformed_pairings_list.append(
                corrected_gamma(row, transformed_probes, target_int)
            )
        pairings = np.array(pairings_list)
        transformed_pairings = np.array(transformed_pairings_list)
        retarded_moment, retarded_moment_first_jet = fit_affine_vector_field(
            points, pivot_index, targets, np.array(moments_list)
        )
        metric, first_jet, design_rank, design_condition = fit_affine_metric_field(
            points, pivot_index, targets, pairings
        )
        transformed_metric, transformed_jet, _, _ = fit_affine_metric_field(
            points, pivot_index, targets, transformed_pairings
        )
        covariance_metric_target = linear @ metric @ linear.T
        covariance_jet_target = np.array(
            [linear @ derivative @ linear.T for derivative in first_jet]
        )
        volume_density = volume_density_from_inverse_metric(metric)
        volume_error = (
            None
            if volume_density is None
            else abs(volume_density - target_density) / target_density
        )
        factor_estimate = conformal_factor_squared_from_inverse_metric(metric)
        temporal_target_norm = np.linalg.norm(target_jet[0])
        temporal_error = (
            None
            if temporal_target_norm == 0.0
            else float(
                np.linalg.norm(first_jet[0] - target_jet[0])
                / temporal_target_norm
            )
        )
        offsets = points[targets, 0] - pivot_time
        projected_gradient = np.array(
            [
                conformal_factor_squared_from_inverse_metric(derivative)
                for derivative in first_jet
            ]
        )
        target_projected_gradient = np.array(
            [
                conformal_factor_squared_from_inverse_metric(derivative)
                for derivative in target_jet
            ]
        )
        projected_temporal_target = target_projected_gradient[0]
        samples.append(
            ConformalMultirowSample(
                hubble=hubble,
                duration=duration,
                nonlocality_multiplier=c_l,
                support_multiplier=c_s,
                averaging_multiplier=c_a,
                ell=ell,
                nonlocality_scale=scales.nonlocality_scale,
                physical_support_radius=scales.support_radius,
                physical_averaging_radius=scales.averaging_radius,
                row_count=len(targets),
                design_rank=design_rank,
                design_condition=design_condition,
                mean_coordinate_time_offset=float(np.mean(offsets)),
                retarded_moment=retarded_moment.tolist(),
                retarded_moment_first_jet=retarded_moment_first_jet.tolist(),
                metric=metric.tolist(),
                target_metric=target_metric.tolist(),
                metric_relative_error=matrix_relative_error(metric, target_metric),
                signature=signature(metric),
                volume_density=volume_density,
                target_volume_density=target_density,
                volume_relative_error=volume_error,
                conformal_factor_squared_estimate=factor_estimate,
                conformal_factor_squared_target=target_factor,
                conformal_factor_squared_relative_error=(
                    abs(factor_estimate - target_factor) / target_factor
                ),
                metric_first_jet=first_jet.tolist(),
                target_metric_first_jet=target_jet.tolist(),
                first_jet_dimensionless_error=float(
                    duration * np.linalg.norm(first_jet - target_jet) / metric_norm
                ),
                temporal_first_jet_relative_error=temporal_error,
                spatial_first_jet_dimensionless_noise=float(
                    duration * np.linalg.norm(first_jet[1:]) / metric_norm
                ),
                projected_conformal_first_gradient=projected_gradient.tolist(),
                target_projected_conformal_first_gradient=(
                    target_projected_gradient.tolist()
                ),
                projected_conformal_gradient_dimensionless_error=float(
                    duration
                    * np.linalg.norm(projected_gradient - target_projected_gradient)
                    / target_factor
                ),
                projected_temporal_gradient_relative_error=(
                    None
                    if projected_temporal_target == 0.0
                    else abs(projected_gradient[0] - projected_temporal_target)
                    / abs(projected_temporal_target)
                ),
                projected_spatial_gradient_dimensionless_noise=float(
                    duration * np.linalg.norm(projected_gradient[1:]) / target_factor
                ),
                affine_metric_covariance_relative_error=matrix_relative_error(
                    transformed_metric, covariance_metric_target
                ),
                affine_first_jet_covariance_relative_error=(
                    affine_first_jet_covariance_error(
                        transformed_jet, covariance_jet_target
                    )
                ),
            )
        )
    return samples


def summarize_samples(samples: list[ConformalMultirowSample]) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize an empty sample list")
    metrics = np.array([sample.metric for sample in samples])
    jets = np.array([sample.metric_first_jet for sample in samples])
    mean_metric = np.mean(metrics, axis=0)
    mean_jet = np.mean(jets, axis=0)
    target_metric = np.array(samples[0].target_metric)
    target_jet = np.array(samples[0].target_metric_first_jet)
    duration = samples[0].duration
    metric_norm = np.linalg.norm(target_metric)
    signature_successes = sum(sample.signature == (1, 3, 0) for sample in samples)
    factor_estimates = np.array(
        [sample.conformal_factor_squared_estimate for sample in samples]
    )
    factor_target = samples[0].conformal_factor_squared_target
    temporal_target_norm = np.linalg.norm(target_jet[0])
    projected_gradients = np.array(
        [sample.projected_conformal_first_gradient for sample in samples]
    )
    mean_projected_gradient = np.mean(projected_gradients, axis=0)
    target_projected_gradient = np.array(
        samples[0].target_projected_conformal_first_gradient
    )
    projected_temporal_target = target_projected_gradient[0]
    return {
        "hubble": samples[0].hubble,
        "duration": duration,
        "nonlocality_multiplier": samples[0].nonlocality_multiplier,
        "support_multiplier": samples[0].support_multiplier,
        "averaging_multiplier": samples[0].averaging_multiplier,
        "nonlocality_scale": samples[0].nonlocality_scale,
        "physical_support_radius": samples[0].physical_support_radius,
        "physical_averaging_radius": samples[0].physical_averaging_radius,
        "row_count": finite_statistics([float(sample.row_count) for sample in samples]),
        "design_rank": finite_statistics(
            [float(sample.design_rank) for sample in samples]
        ),
        "design_condition": finite_statistics(
            [sample.design_condition for sample in samples]
        ),
        "mean_coordinate_time_offset": finite_statistics(
            [sample.mean_coordinate_time_offset for sample in samples]
        ),
        "mean_metric": mean_metric.tolist(),
        "target_metric": target_metric.tolist(),
        "ensemble_mean_signature": signature(mean_metric),
        "ensemble_mean_metric_relative_error": matrix_relative_error(
            mean_metric, target_metric
        ),
        "signature_successes": signature_successes,
        "signature_success_rate": signature_successes / len(samples),
        "metric_relative_error": finite_statistics(
            [sample.metric_relative_error for sample in samples]
        ),
        "volume_relative_error": finite_statistics(
            [sample.volume_relative_error for sample in samples]
        ),
        "ensemble_conformal_factor_squared_estimate": float(
            np.mean(factor_estimates)
        ),
        "ensemble_conformal_factor_squared_target": factor_target,
        "ensemble_conformal_factor_squared_relative_error": float(
            abs(np.mean(factor_estimates) - factor_target) / factor_target
        ),
        "mean_metric_first_jet": mean_jet.tolist(),
        "target_metric_first_jet": target_jet.tolist(),
        "ensemble_first_jet_dimensionless_error": float(
            duration * np.linalg.norm(mean_jet - target_jet) / metric_norm
        ),
        "ensemble_temporal_first_jet_relative_error": (
            None
            if temporal_target_norm == 0.0
            else float(
                np.linalg.norm(mean_jet[0] - target_jet[0])
                / temporal_target_norm
            )
        ),
        "first_jet_dimensionless_error": finite_statistics(
            [sample.first_jet_dimensionless_error for sample in samples]
        ),
        "temporal_first_jet_relative_error": finite_statistics(
            [sample.temporal_first_jet_relative_error for sample in samples]
        ),
        "spatial_first_jet_dimensionless_noise": finite_statistics(
            [sample.spatial_first_jet_dimensionless_noise for sample in samples]
        ),
        "mean_projected_conformal_first_gradient": (
            mean_projected_gradient.tolist()
        ),
        "target_projected_conformal_first_gradient": (
            target_projected_gradient.tolist()
        ),
        "ensemble_projected_conformal_gradient_dimensionless_error": float(
            duration
            * np.linalg.norm(mean_projected_gradient - target_projected_gradient)
            / factor_target
        ),
        "ensemble_projected_temporal_gradient_relative_error": (
            None
            if projected_temporal_target == 0.0
            else abs(mean_projected_gradient[0] - projected_temporal_target)
            / abs(projected_temporal_target)
        ),
        "projected_conformal_gradient_dimensionless_error": finite_statistics(
            [
                sample.projected_conformal_gradient_dimensionless_error
                for sample in samples
            ]
        ),
        "projected_temporal_gradient_relative_error": finite_statistics(
            [
                sample.projected_temporal_gradient_relative_error
                for sample in samples
            ]
        ),
        "projected_spatial_gradient_dimensionless_noise": finite_statistics(
            [
                sample.projected_spatial_gradient_dimensionless_noise
                for sample in samples
            ]
        ),
        "affine_metric_covariance_relative_error": finite_statistics(
            [sample.affine_metric_covariance_relative_error for sample in samples]
        ),
        "affine_first_jet_covariance_relative_error": finite_statistics(
            [
                sample.affine_first_jet_covariance_relative_error
                for sample in samples
            ]
        ),
    }


def select_flat_setting(
    summaries: dict[str, dict[str, object]],
    metric_tolerance: float = 0.05,
) -> tuple[str, dict[str, object]]:
    """Choose a low-noise jet among near-best flat metric estimators."""

    if metric_tolerance < 0.0:
        raise ValueError("metric tolerance must be nonnegative")
    maximum_signature_rate = max(
        float(summary["signature_success_rate"])
        for summary in summaries.values()
    )
    signature_candidates = {
        key: summary
        for key, summary in summaries.items()
        if float(summary["signature_success_rate"]) == maximum_signature_rate
    }
    best_metric_error = min(
        float(summary["ensemble_mean_metric_relative_error"])
        for summary in signature_candidates.values()
    )
    candidates = {
        key: summary
        for key, summary in signature_candidates.items()
        if float(summary["ensemble_mean_metric_relative_error"])
        <= best_metric_error + metric_tolerance
    }

    def score(item: tuple[str, dict[str, object]]) -> tuple[float, ...]:
        summary = item[1]
        volume_stats = summary["volume_relative_error"]
        jet_stats = summary["first_jet_dimensionless_error"]
        metric_stats = summary["metric_relative_error"]
        assert isinstance(volume_stats, dict)
        assert isinstance(jet_stats, dict)
        assert isinstance(metric_stats, dict)
        return (
            float(summary["ensemble_first_jet_dimensionless_error"]),
            float(jet_stats["median"]),
            float(volume_stats["median"]),
            float(summary["ensemble_mean_metric_relative_error"]),
            float(metric_stats["median"]),
            float(summary["nonlocality_multiplier"]),
            float(summary["support_multiplier"]),
            float(summary["averaging_multiplier"]),
        )

    return min(candidates.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.events <= 0 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    hubble_values = sorted(set(args.hubble_values))
    if not hubble_values or 0.0 not in hubble_values:
        raise ValueError("the background list must include H = 0")
    for hubble in hubble_values:
        validate_background(args.duration, hubble)

    if args.mode == "development":
        c_l_values = sorted(set(args.nonlocality_multipliers))
        c_s_values = sorted(set(args.support_multipliers))
        c_a_values = sorted(set(args.averaging_multipliers))
    else:
        selected = (
            args.selected_nonlocality_multiplier,
            args.selected_support_multiplier,
            args.selected_averaging_multiplier,
        )
        if any(value is None for value in selected):
            raise ValueError("held-out mode requires all three selected multipliers")
        c_l_values = [float(selected[0])]
        c_s_values = [float(selected[1])]
        c_a_values = [float(selected[2])]

    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(hubble_values) * args.realizations
    )
    samples: list[ConformalMultirowSample] = []
    seed_index = 0
    for hubble in hubble_values:
        for _ in range(args.realizations):
            samples.extend(
                reconstruct_multirow_realization(
                    np.random.default_rng(child_seeds[seed_index]),
                    args.events,
                    args.duration,
                    hubble,
                    c_l_values,
                    c_s_values,
                    c_a_values,
                    args.maximum_rows,
                    args.block_size,
                    args.pivot_fraction,
                )
            )
            seed_index += 1

    summaries: dict[str, dict[str, dict[str, object]]] = {}
    for hubble in hubble_values:
        background_samples = [sample for sample in samples if sample.hubble == hubble]
        setting_summaries: dict[str, dict[str, object]] = {}
        for c_l in c_l_values:
            for c_s in c_s_values:
                for c_a in c_a_values:
                    selected_samples = [
                        sample
                        for sample in background_samples
                        if sample.nonlocality_multiplier == c_l
                        and sample.support_multiplier == c_s
                        and sample.averaging_multiplier == c_a
                    ]
                    setting_summaries[setting_key(c_l, c_s, c_a)] = (
                        summarize_samples(selected_samples)
                    )
        summaries[f"H={hubble:.6f}"] = setting_summaries

    if args.mode == "development":
        selected_key, selected_summary = select_flat_setting(
            summaries["H=0.000000"], args.metric_selection_tolerance
        )
        selected_setting = {
            "key": selected_key,
            "nonlocality_multiplier": selected_summary[
                "nonlocality_multiplier"
            ],
            "support_multiplier": selected_summary["support_multiplier"],
            "averaging_multiplier": selected_summary["averaging_multiplier"],
            "selection_data": "flat H = 0 controls only",
            "metric_selection_tolerance": args.metric_selection_tolerance,
        }
    else:
        selected_key = setting_key(c_l_values[0], c_s_values[0], c_a_values[0])
        selected_setting = {
            "key": selected_key,
            "nonlocality_multiplier": c_l_values[0],
            "support_multiplier": c_s_values[0],
            "averaging_multiplier": c_a_values[0],
            "selection_data": "frozen before held-out seeds",
        }

    selected_backgrounds = {
        background: dict(setting_summaries[selected_key])
        for background, setting_summaries in summaries.items()
    }
    flat_summary = selected_backgrounds["H=0.000000"]
    flat_factor = float(flat_summary["ensemble_conformal_factor_squared_estimate"])
    flat_target = float(flat_summary["ensemble_conformal_factor_squared_target"])
    for summary in selected_backgrounds.values():
        response_estimate = float(
            summary["ensemble_conformal_factor_squared_estimate"]
        ) / flat_factor
        response_target = float(
            summary["ensemble_conformal_factor_squared_target"]
        ) / flat_target
        summary["conformal_response_relative_to_flat"] = {
            "estimate": response_estimate,
            "target": response_target,
            "relative_error": abs(response_estimate - response_target)
            / response_target,
        }

    result: dict[str, object] = {
        "status": "curved multirow operator first-jet calibration; not reconstruction",
        "mode": args.mode,
        "claim_boundary": {
            "operator_rows_use_order_counts_and_supplied_density": True,
            "row_selection_and_probes_use_embedding_coordinates": True,
            "dimension_and_de_sitter_family_are_supplied": True,
            "metric_first_jet_is_operator_fitted": True,
            "connection_or_curvature_is_computed": False,
        },
        "schedule": {
            "nonlocality": "L = cL * sqrt(ell * T)",
            "support": "S = cS * sqrt(L * T)",
            "averaging": "A = cA * L",
            "asymptotics": ["ell/L -> 0", "L/S -> 0", "L,S,A -> 0"],
        },
        "settings": {
            "events": args.events,
            "realizations_per_background": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "hubble_values": hubble_values,
            "nonlocality_multipliers": c_l_values,
            "support_multipliers": c_s_values,
            "averaging_multipliers": c_a_values,
            "maximum_rows": args.maximum_rows,
            "metric_selection_tolerance": args.metric_selection_tolerance,
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
    parser.add_argument("--realizations", type=int, default=4)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument(
        "--hubble-values", type=float, nargs="+", default=[0.0, 0.1, 0.2]
    )
    parser.add_argument(
        "--nonlocality-multipliers", type=float, nargs="+", default=[0.45, 0.55, 0.65]
    )
    parser.add_argument(
        "--support-multipliers", type=float, nargs="+", default=[1.2, 1.4]
    )
    parser.add_argument(
        "--averaging-multipliers", type=float, nargs="+", default=[0.7, 0.9]
    )
    parser.add_argument("--selected-nonlocality-multiplier", type=float)
    parser.add_argument("--selected-support-multiplier", type=float)
    parser.add_argument("--selected-averaging-multiplier", type=float)
    parser.add_argument("--maximum-rows", type=int, default=96)
    parser.add_argument("--metric-selection-tolerance", type=float, default=0.05)
    parser.add_argument("--pivot-fraction", type=float, default=0.7)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20260930)
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
