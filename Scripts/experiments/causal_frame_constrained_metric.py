"""Stage A17 frame-constrained shared coordinates and local metric regression.

Stage A16 found five-anchor frames that were well conditioned but whose
individual Johnston charts failed local affine reconstruction.  This oracle
uses those anchors to align three nearby lightcone charts into one affine
gauge, assigns every multiply observed event its least-squares consensus
coordinate, and regresses one common symmetric metric against interval-count
proper times.

The ridge prior is the average Minkowski form transported from the same three
order-derived charts.  It therefore stabilizes a supplied 3+1 Lorentzian chart
model; it does not derive signature or dimension from an undecorated order.
Known sprinkling coordinates enter only after selection for coordinate, metric,
and volume controls.  This remains a conditional numerical oracle.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_full_embedding import (
    binary_sensitivity_specificity,
)
from causal_johnston_probe_metric import (
    JohnstonLightconeEmbedding,
    causal_interval_points,
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding_from_intrinsic_data,
    minkowski_interval_coefficient,
    proper_squared_from_open_counts,
)
from causal_operator_metric import finite_statistics, matrix_relative_error
from causal_trilateration_tetrad_selector import (
    common_bracketing_pools,
    nearest_causal_cross,
    select_consensus_frame,
    temporal_shell_candidates,
    validation_pivots,
)
from causal_well_conditioning_audit import choose_deep_intrinsic_pivot


MINKOWSKI_METRIC = np.diag([1.0, -1.0, -1.0, -1.0])
SYMMETRIC_INDICES = np.triu_indices(4)


@dataclass(frozen=True)
class MetricConstraintSplit:
    causal_left: np.ndarray
    causal_right: np.ndarray
    causal_target_squared: np.ndarray
    causal_weight: np.ndarray
    causal_train: np.ndarray
    causal_heldout: np.ndarray
    noncausal_left: np.ndarray
    noncausal_right: np.ndarray


@dataclass(frozen=True)
class MetricRegression:
    regularization: float
    metric: np.ndarray
    eigenvalues: np.ndarray
    signature: tuple[int, int, int]
    condition: float
    coframe: np.ndarray | None
    coframe_factorization_error: float | None
    heldout_interval_relative_rmse: float
    heldout_causal_sign_fraction: float
    noncausal_violation_fraction: float


@dataclass(frozen=True)
class FrameConstrainedMetricSample:
    regularization: float
    carrier_count: int
    evaluation_count: int
    causal_training_pairs: int
    causal_heldout_pairs: int
    noncausal_pairs: int
    active_causal_coverage_fraction: float
    normalized_consensus_frame_minimum_singular_value: float
    consensus_frame_maximum_condition: float
    chart_leave_one_out_relative_error: float
    chart_consensus_dispersion_relative_error: float
    metric_prior_signature: tuple[int, int, int]
    metric_signature: tuple[int, int, int]
    metric_eigenvalues: list[float]
    metric_condition: float
    coframe_factorization_relative_error: float | None
    heldout_interval_relative_rmse: float
    heldout_causal_sign_fraction: float
    noncausal_violation_fraction: float
    causal_sensitivity: float
    causal_specificity: float
    oracle_coordinate_relative_error: float
    oracle_metric_relative_error: float
    oracle_metric_conformal_relative_error: float
    oracle_metric_volume_relative_error: float
    passes_intrinsic_coordinate_gate: bool
    passes_intrinsic_metric_gate: bool
    passes_oracle_coordinate_gate: bool
    passes_oracle_metric_gate: bool
    passes_local_tetrad_gate: bool


def regularization_key(value: float) -> str:
    """Stable JSON key for a metric-ridge coefficient."""

    return f"regularization={value:.6f}"


def metric_signature(
    matrix: np.ndarray, relative_tolerance: float = 1.0e-8
) -> tuple[int, int, int]:
    """Return positive, negative, and zero inertia of a symmetric matrix."""

    eigenvalues = np.linalg.eigvalsh(matrix)
    scale = max(float(np.max(np.abs(eigenvalues))), 1.0)
    tolerance = relative_tolerance * scale
    positive = int(np.count_nonzero(eigenvalues > tolerance))
    negative = int(np.count_nonzero(eigenvalues < -tolerance))
    return positive, negative, len(eigenvalues) - positive - negative


def symmetric_quadratic_features(displacements: np.ndarray) -> np.ndarray:
    """Linear features whose coefficient vector represents ``v^T g v``."""

    if displacements.ndim != 2 or displacements.shape[1] != 4:
        raise ValueError("metric features require an N by 4 displacement matrix")
    features = (
        displacements[:, SYMMETRIC_INDICES[0]]
        * displacements[:, SYMMETRIC_INDICES[1]]
    )
    off_diagonal = SYMMETRIC_INDICES[0] != SYMMETRIC_INDICES[1]
    features[:, off_diagonal] *= 2.0
    return features


def symmetric_matrix_to_vector(matrix: np.ndarray) -> np.ndarray:
    """Pack a symmetric 4 by 4 matrix into the regression convention."""

    if matrix.shape != (4, 4) or not np.allclose(matrix, matrix.T):
        raise ValueError("metric coefficient packing requires a symmetric 4 by 4 matrix")
    return matrix[SYMMETRIC_INDICES]


def symmetric_vector_to_matrix(coefficients: np.ndarray) -> np.ndarray:
    """Unpack ten quadratic coefficients into a symmetric 4 by 4 matrix."""

    if coefficients.shape != (10,):
        raise ValueError("a symmetric 4 by 4 matrix has ten coefficients")
    matrix = np.zeros((4, 4), dtype=float)
    matrix[SYMMETRIC_INDICES] = coefficients
    matrix[(SYMMETRIC_INDICES[1], SYMMETRIC_INDICES[0])] = coefficients
    return matrix


def factor_lorentzian_metric(
    metric: np.ndarray,
) -> tuple[np.ndarray | None, float | None]:
    """Factor ``g = e eta e^T`` when ``g`` has 3+1 Lorentzian inertia."""

    eigenvalues, eigenvectors = np.linalg.eigh(metric)
    positive = np.flatnonzero(eigenvalues > 0.0)
    negative = np.flatnonzero(eigenvalues < 0.0)
    if len(positive) != 1 or len(negative) != 3:
        return None, None
    order = np.concatenate((positive, negative))
    coframe = eigenvectors[:, order] * np.sqrt(
        np.abs(eigenvalues[order])
    )[None, :]
    reconstructed = coframe @ MINKOWSKI_METRIC @ coframe.T
    error = matrix_relative_error(reconstructed, metric)
    return coframe, error


def transported_chart_metric(affine_coefficients: np.ndarray) -> np.ndarray:
    """Transport the chart's Minkowski form into the common affine gauge."""

    if affine_coefficients.shape != (5, 4):
        raise ValueError("an affine chart map must have shape 5 by 4")
    linear = affine_coefficients[:4]
    inverse = np.linalg.inv(linear)
    return inverse @ MINKOWSKI_METRIC @ inverse.T


def align_charts_and_form_consensus(
    charts: list[JohnstonLightconeEmbedding],
    anchor_indices: np.ndarray,
) -> tuple[np.ndarray, np.ndarray, np.ndarray, list[np.ndarray], list[np.ndarray]]:
    """Anchor-align charts and average every multiply represented event."""

    if len(charts) < 2:
        raise ValueError("shared coordinates require at least two charts")
    canonical_anchors = charts[0].probes[anchor_indices]
    event_count = len(charts[0].probes)
    observations = np.full((len(charts), event_count, 4), np.nan)
    support = np.zeros(event_count, dtype=int)
    maps: list[np.ndarray] = []
    metrics: list[np.ndarray] = []
    for chart_index, chart in enumerate(charts):
        anchor_design = np.column_stack(
            (chart.probes[anchor_indices], np.ones(len(anchor_indices)))
        )
        coefficients = np.linalg.solve(anchor_design, canonical_anchors)
        maps.append(coefficients)
        metrics.append(transported_chart_metric(coefficients))
        embedded = np.flatnonzero(chart.embedded_mask)
        design = np.column_stack(
            (chart.probes[embedded], np.ones(len(embedded)))
        )
        observations[chart_index, embedded] = design @ coefficients
        support[embedded] += 1
    sums = np.nansum(observations, axis=0)
    consensus = np.full((event_count, 4), np.nan)
    represented = support > 0
    consensus[represented] = sums[represented] / support[represented, None]
    return consensus, support, observations, maps, metrics


def chart_consistency_errors(
    observations: np.ndarray,
    consensus: np.ndarray,
    carrier: np.ndarray,
) -> tuple[float, float]:
    """Leave-one-chart-out and within-consensus relative residuals."""

    if len(carrier) == 0:
        raise ValueError("chart consistency requires a nonempty carrier")
    support = np.count_nonzero(np.isfinite(observations[:, :, 0]), axis=0)
    leave_one_out_residuals: list[np.ndarray] = []
    leave_one_out_targets: list[np.ndarray] = []
    dispersion_residuals: list[np.ndarray] = []
    for event in carrier:
        available = observations[:, event]
        available = available[np.isfinite(available[:, 0])]
        dispersion_residuals.append(available - consensus[event])
    for chart_index in range(len(observations)):
        available = np.isfinite(observations[chart_index, :, 0]) & (support >= 2)
        available &= np.isin(np.arange(len(support)), carrier)
        for event in np.flatnonzero(available):
            other = np.delete(observations[:, event], chart_index, axis=0)
            other = other[np.isfinite(other[:, 0])]
            prediction = np.mean(other, axis=0)
            leave_one_out_residuals.append(
                observations[chart_index, event] - prediction
            )
            leave_one_out_targets.append(observations[chart_index, event])
    residual = np.vstack(leave_one_out_residuals)
    targets = np.vstack(leave_one_out_targets)
    target_scale = max(
        float(np.linalg.norm(targets - np.mean(targets, axis=0))),
        1.0e-12,
    )
    leave_one_out_error = float(np.linalg.norm(residual) / target_scale)
    dispersion = np.vstack(dispersion_residuals)
    centered_consensus = consensus[carrier] - np.mean(consensus[carrier], axis=0)
    consensus_scale = max(float(np.linalg.norm(centered_consensus)), 1.0e-12)
    dispersion_error = float(np.linalg.norm(dispersion) / consensus_scale)
    return leave_one_out_error, dispersion_error


def build_metric_constraint_split(
    rng: np.random.Generator,
    relation: np.ndarray,
    open_counts: np.ndarray,
    density: float,
    dimension: int,
    anchor_positions: np.ndarray,
    heldout_fraction: float,
    minimum_heldout_open_count: int,
    maximum_noncausal_pairs: int,
) -> MetricConstraintSplit:
    """Freeze comparable interval-regression and unrelated-pair controls."""

    if relation.shape != open_counts.shape or relation.ndim != 2:
        raise ValueError("relation and open counts must be equal square matrices")
    if not 0.0 < heldout_fraction < 1.0:
        raise ValueError("held-out fraction must lie strictly between zero and one")
    left, right = np.where(relation)
    targets = proper_squared_from_open_counts(
        open_counts[left, right], density, dimension
    )
    weight = np.sqrt(open_counts[left, right].astype(float) + 2.0)
    weight /= float(np.mean(weight))
    touches_anchor = np.isin(left, anchor_positions) | np.isin(
        right, anchor_positions
    )
    eligible = np.flatnonzero(
        (~touches_anchor)
        & (open_counts[left, right] >= minimum_heldout_open_count)
    )
    if len(eligible) < 2:
        raise ValueError("too few non-anchor comparable intervals to hold out")
    shuffled = rng.permutation(eligible)
    heldout_count = max(1, int(math.floor(heldout_fraction * len(shuffled))))
    heldout = np.sort(shuffled[:heldout_count])
    train_mask = np.ones(len(left), dtype=bool)
    train_mask[heldout] = False
    train = np.flatnonzero(train_mask)

    unrelated = ~(relation | relation.T | np.eye(len(relation), dtype=bool))
    noncausal_left, noncausal_right = np.where(np.triu(unrelated, k=1))
    if len(noncausal_left) > maximum_noncausal_pairs:
        selected = np.sort(
            rng.choice(
                len(noncausal_left),
                size=maximum_noncausal_pairs,
                replace=False,
            )
        )
        noncausal_left = noncausal_left[selected]
        noncausal_right = noncausal_right[selected]
    return MetricConstraintSplit(
        causal_left=left.astype(int),
        causal_right=right.astype(int),
        causal_target_squared=targets,
        causal_weight=weight,
        causal_train=train,
        causal_heldout=heldout,
        noncausal_left=noncausal_left.astype(int),
        noncausal_right=noncausal_right.astype(int),
    )


def fit_common_metric(
    coordinates: np.ndarray,
    split: MetricConstraintSplit,
    prior_metric: np.ndarray,
    anchor_time: float,
    regularization: float,
) -> MetricRegression:
    """Fit one symmetric metric to count-derived interval lengths."""

    if coordinates.ndim != 2 or coordinates.shape[1] != 4:
        raise ValueError("metric regression requires N by 4 coordinates")
    if anchor_time <= 0.0 or regularization < 0.0:
        raise ValueError("anchor time must be positive and ridge nonnegative")
    displacement = (
        coordinates[split.causal_right] - coordinates[split.causal_left]
    ) / anchor_time
    features = symmetric_quadratic_features(displacement)
    target = split.causal_target_squared / anchor_time**2
    train = split.causal_train
    weight = split.causal_weight[train]
    normal = (features[train].T * weight) @ features[train] / np.sum(weight)
    response = (
        features[train].T @ (weight * target[train]) / np.sum(weight)
    )
    penalty_scale = max(float(np.trace(normal) / len(normal)), 1.0e-12)
    prior = symmetric_matrix_to_vector(prior_metric)
    coefficients = np.linalg.solve(
        normal + regularization * penalty_scale * np.eye(len(normal)),
        response + regularization * penalty_scale * prior,
    )
    metric = symmetric_vector_to_matrix(coefficients)
    eigenvalues = np.linalg.eigvalsh(metric)
    inertia = metric_signature(metric)
    absolute_eigenvalues = np.abs(eigenvalues)
    condition = float(
        np.max(absolute_eigenvalues) / np.min(absolute_eigenvalues)
    )
    coframe, coframe_error = factor_lorentzian_metric(metric)

    heldout = split.causal_heldout
    prediction = features[heldout] @ coefficients
    heldout_weight = split.causal_weight[heldout]
    error_scale = max(
        float(np.average(target[heldout] ** 2, weights=heldout_weight)),
        1.0e-12,
    )
    relative_rmse = math.sqrt(
        float(
            np.average(
                (prediction - target[heldout]) ** 2,
                weights=heldout_weight,
            )
            / error_scale
        )
    )
    heldout_sign_fraction = float(np.mean(prediction > 0.0))
    noncausal_displacement = (
        coordinates[split.noncausal_right]
        - coordinates[split.noncausal_left]
    ) / anchor_time
    noncausal_quadratic = (
        symmetric_quadratic_features(noncausal_displacement) @ coefficients
    )
    violation_fraction = (
        0.0
        if len(noncausal_quadratic) == 0
        else float(np.mean(noncausal_quadratic > 0.0))
    )
    return MetricRegression(
        regularization=regularization,
        metric=metric,
        eigenvalues=eigenvalues,
        signature=inertia,
        condition=condition,
        coframe=coframe,
        coframe_factorization_error=coframe_error,
        heldout_interval_relative_rmse=relative_rmse,
        heldout_causal_sign_fraction=heldout_sign_fraction,
        noncausal_violation_fraction=violation_fraction,
    )


def induced_relation_from_metric(
    coordinates: np.ndarray,
    intrinsic_time: np.ndarray,
    metric: np.ndarray,
) -> np.ndarray:
    """Orient the fitted metric cones with the order-derived intrinsic time."""

    delta = coordinates[None, :, :] - coordinates[:, None, :]
    quadratic = np.einsum("...i,ij,...j->...", delta, metric, delta)
    future = intrinsic_time[None, :] > intrinsic_time[:, None]
    return future & (quadratic >= 0.0)


def oracle_geometry_controls(
    points: np.ndarray,
    consensus: np.ndarray,
    anchor_indices: np.ndarray,
    evaluation_indices: np.ndarray,
    pivot_index: int,
    fitted_metric: np.ndarray,
) -> tuple[float, float, float, float]:
    """Score coordinates, tensor components, conformal shape, and volume."""

    anchor_design = np.column_stack(
        (consensus[anchor_indices], np.ones(len(anchor_indices)))
    )
    affine = np.linalg.solve(anchor_design, points[anchor_indices])
    evaluation_design = np.column_stack(
        (consensus[evaluation_indices], np.ones(len(evaluation_indices)))
    )
    predicted = evaluation_design @ affine
    numerator = np.sqrt(
        np.mean(np.sum((predicted - points[evaluation_indices]) ** 2, axis=1))
    )
    denominator = max(
        float(
            np.sqrt(
                np.mean(
                    np.sum(
                        (points[evaluation_indices] - points[pivot_index]) ** 2,
                        axis=1,
                    )
                )
            )
        ),
        1.0e-12,
    )
    coordinate_error = float(numerator / denominator)
    jacobian = affine[:4]
    oracle_metric = jacobian @ MINKOWSKI_METRIC @ jacobian.T
    metric_error = matrix_relative_error(fitted_metric, oracle_metric)
    conformal_scale = float(
        np.sum(fitted_metric * oracle_metric) / np.sum(fitted_metric**2)
    )
    conformal_error = matrix_relative_error(
        conformal_scale * fitted_metric, oracle_metric
    )
    fitted_volume = math.sqrt(abs(float(np.linalg.det(fitted_metric))))
    oracle_volume = math.sqrt(abs(float(np.linalg.det(oracle_metric))))
    volume_error = abs(fitted_volume / oracle_volume - 1.0)
    return coordinate_error, metric_error, conformal_error, volume_error


def reconstruct_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    scaffold_scale: float,
    anchor_time_multiplier: float,
    active_count: int,
    minimum_chart_support: int,
    minimum_lightcone_count: int,
    relative_time_shell_width: float,
    maximum_lower_candidates: int,
    maximum_upper_candidates: int,
    regularizations: list[float],
    heldout_fraction: float,
    minimum_heldout_open_count: int,
    maximum_noncausal_pairs: int,
    minimum_evaluation_count: int,
    maximum_chart_consistency_error: float,
    maximum_interval_error: float,
    minimum_heldout_causal_sign_fraction: float,
    maximum_noncausal_violation_fraction: float,
    minimum_causal_sensitivity: float,
    minimum_causal_specificity: float,
    maximum_coordinate_error: float,
    maximum_metric_error: float,
    maximum_conformal_metric_error: float,
) -> list[FrameConstrainedMetricSample]:
    """Construct one common patch and score every metric regularization."""

    points, bottom_index, top_index = causal_interval_points(
        rng, events, duration
    )
    relation = causal_relation_matrix(points, block_size)
    coefficient = minkowski_interval_coefficient(dimension)
    density = events / (coefficient * duration**dimension)
    intrinsic_time, intrinsic_radius = intrinsic_time_and_radius_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
    )
    pivot_index = choose_deep_intrinsic_pivot(
        relation,
        intrinsic_time,
        intrinsic_radius,
        duration,
        minimum_lightcone_count,
    )
    base = johnston_lightcone_embedding_from_intrinsic_data(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        pivot_index,
        intrinsic_time,
        intrinsic_radius,
        spatial_rank=dimension - 1,
    )
    active = nearest_causal_cross(relation, base, active_count)
    local_pivots = validation_pivots(relation, base, active)
    charts = [
        johnston_lightcone_embedding_from_intrinsic_data(
            relation,
            density,
            dimension,
            bottom_index,
            top_index,
            int(local_pivot),
            intrinsic_time,
            intrinsic_radius,
            spatial_rank=dimension - 1,
        )
        for local_pivot in local_pivots
    ]
    common_lower, common_upper = common_bracketing_pools(
        relation, pivot_index, active
    )
    anchor_time = anchor_time_multiplier * scaffold_scale
    lower = temporal_shell_candidates(
        base.probes,
        common_lower,
        -anchor_time,
        relative_time_shell_width,
        maximum_lower_candidates,
    )
    upper = temporal_shell_candidates(
        base.probes,
        common_upper,
        anchor_time,
        relative_time_shell_width,
        maximum_upper_candidates,
    )
    selected = select_consensus_frame(charts, lower, upper, anchor_time)
    anchors = np.array(selected.anchor_indices, dtype=int)
    consensus, support, observations, _, transported_metrics = (
        align_charts_and_form_consensus(charts, anchors)
    )
    bracketed = relation[anchors[0], :] & np.all(
        relation[:, anchors[1:]], axis=1
    )
    # The boundary anchors fix the common affine gauge.  Metric regression uses
    # only the strict bracket interior, where interval-count asymptotics apply.
    carrier = np.flatnonzero(bracketed & (support >= minimum_chart_support))
    anchor_positions = np.array([], dtype=int)
    local_relation = relation[np.ix_(carrier, carrier)]
    local_open_counts = (
        relation[carrier, :].astype(np.float32)
        @ relation[:, carrier].astype(np.float32)
    )
    split = build_metric_constraint_split(
        rng,
        local_relation,
        local_open_counts,
        density,
        dimension,
        anchor_positions,
        heldout_fraction,
        minimum_heldout_open_count,
        maximum_noncausal_pairs,
    )
    leave_one_out, dispersion = chart_consistency_errors(
        observations, consensus, carrier
    )
    excluded = np.concatenate((active, anchors))
    evaluation = carrier[~np.isin(carrier, excluded)]
    if len(evaluation) == 0:
        raise ValueError("the consensus patch has no out-of-sample events")
    coverage = float(
        np.mean(
            relation[anchors[0], active]
            & np.all(relation[np.ix_(active, anchors[1:])], axis=1)
        )
    )
    prior_metric = np.mean(transported_metrics, axis=0)
    prior_signature = metric_signature(prior_metric)
    coordinate_gate = bool(
        len(evaluation) >= minimum_evaluation_count
        and coverage == 1.0
        and leave_one_out <= maximum_chart_consistency_error
        and dispersion <= maximum_chart_consistency_error
    )

    samples: list[FrameConstrainedMetricSample] = []
    for regularization in regularizations:
        fit = fit_common_metric(
            consensus[carrier],
            split,
            prior_metric,
            anchor_time,
            regularization,
        )
        induced = induced_relation_from_metric(
            consensus[carrier], intrinsic_time[carrier], fit.metric
        )
        sensitivity, specificity = binary_sensitivity_specificity(
            local_relation, induced
        )
        coordinate_error, metric_error, conformal_error, volume_error = (
            oracle_geometry_controls(
                points,
                consensus,
                anchors,
                evaluation,
                pivot_index,
                fit.metric,
            )
        )
        intrinsic_metric_gate = bool(
            fit.signature == (1, 3, 0)
            and fit.coframe_factorization_error is not None
            and fit.coframe_factorization_error <= 1.0e-10
            and fit.heldout_interval_relative_rmse <= maximum_interval_error
            and fit.heldout_causal_sign_fraction
            >= minimum_heldout_causal_sign_fraction
            and fit.noncausal_violation_fraction
            <= maximum_noncausal_violation_fraction
            and sensitivity >= minimum_causal_sensitivity
            and specificity >= minimum_causal_specificity
        )
        oracle_coordinate_gate = coordinate_error <= maximum_coordinate_error
        oracle_metric_gate = bool(
            metric_error <= maximum_metric_error
            and conformal_error <= maximum_conformal_metric_error
        )
        samples.append(
            FrameConstrainedMetricSample(
                regularization=regularization,
                carrier_count=len(carrier),
                evaluation_count=len(evaluation),
                causal_training_pairs=len(split.causal_train),
                causal_heldout_pairs=len(split.causal_heldout),
                noncausal_pairs=len(split.noncausal_left),
                active_causal_coverage_fraction=coverage,
                normalized_consensus_frame_minimum_singular_value=(
                    selected.normalized_minimum_singular_value
                ),
                consensus_frame_maximum_condition=(
                    selected.maximum_frame_condition
                ),
                chart_leave_one_out_relative_error=leave_one_out,
                chart_consensus_dispersion_relative_error=dispersion,
                metric_prior_signature=prior_signature,
                metric_signature=fit.signature,
                metric_eigenvalues=[float(value) for value in fit.eigenvalues],
                metric_condition=fit.condition,
                coframe_factorization_relative_error=(
                    fit.coframe_factorization_error
                ),
                heldout_interval_relative_rmse=(
                    fit.heldout_interval_relative_rmse
                ),
                heldout_causal_sign_fraction=(
                    fit.heldout_causal_sign_fraction
                ),
                noncausal_violation_fraction=(
                    fit.noncausal_violation_fraction
                ),
                causal_sensitivity=sensitivity,
                causal_specificity=specificity,
                oracle_coordinate_relative_error=coordinate_error,
                oracle_metric_relative_error=metric_error,
                oracle_metric_conformal_relative_error=conformal_error,
                oracle_metric_volume_relative_error=volume_error,
                passes_intrinsic_coordinate_gate=coordinate_gate,
                passes_intrinsic_metric_gate=intrinsic_metric_gate,
                passes_oracle_coordinate_gate=oracle_coordinate_gate,
                passes_oracle_metric_gate=oracle_metric_gate,
                passes_local_tetrad_gate=bool(
                    coordinate_gate
                    and intrinsic_metric_gate
                    and oracle_coordinate_gate
                    and oracle_metric_gate
                ),
            )
        )
    return samples


def summarize_samples(
    samples: list[FrameConstrainedMetricSample],
) -> dict[str, dict[str, object]]:
    """Group local metric samples by ridge regularization."""

    grouped: dict[str, list[FrameConstrainedMetricSample]] = {}
    for sample in samples:
        grouped.setdefault(regularization_key(sample.regularization), []).append(
            sample
        )

    def summarize(group: list[FrameConstrainedMetricSample]) -> dict[str, object]:
        def statistics(attribute: str) -> dict[str, float | int | None]:
            return finite_statistics(
                [float(getattr(sample, attribute)) for sample in group]
            )

        def rate(attribute: str) -> float:
            return sum(bool(getattr(sample, attribute)) for sample in group) / len(
                group
            )

        signature_counts: dict[str, int] = {}
        for sample in group:
            key = str(sample.metric_signature)
            signature_counts[key] = signature_counts.get(key, 0) + 1
        return {
            "regularization": group[0].regularization,
            "samples": len(group),
            "carrier_count": statistics("carrier_count"),
            "evaluation_count": statistics("evaluation_count"),
            "causal_training_pairs": statistics("causal_training_pairs"),
            "causal_heldout_pairs": statistics("causal_heldout_pairs"),
            "chart_leave_one_out_relative_error": statistics(
                "chart_leave_one_out_relative_error"
            ),
            "chart_consensus_dispersion_relative_error": statistics(
                "chart_consensus_dispersion_relative_error"
            ),
            "metric_signature_counts": signature_counts,
            "metric_condition": statistics("metric_condition"),
            "heldout_interval_relative_rmse": statistics(
                "heldout_interval_relative_rmse"
            ),
            "heldout_causal_sign_fraction": statistics(
                "heldout_causal_sign_fraction"
            ),
            "noncausal_violation_fraction": statistics(
                "noncausal_violation_fraction"
            ),
            "causal_sensitivity": statistics("causal_sensitivity"),
            "causal_specificity": statistics("causal_specificity"),
            "oracle_coordinate_relative_error": statistics(
                "oracle_coordinate_relative_error"
            ),
            "oracle_metric_relative_error": statistics(
                "oracle_metric_relative_error"
            ),
            "oracle_metric_conformal_relative_error": statistics(
                "oracle_metric_conformal_relative_error"
            ),
            "oracle_metric_volume_relative_error": statistics(
                "oracle_metric_volume_relative_error"
            ),
            "intrinsic_coordinate_gate_success_rate": rate(
                "passes_intrinsic_coordinate_gate"
            ),
            "intrinsic_metric_gate_success_rate": rate(
                "passes_intrinsic_metric_gate"
            ),
            "oracle_coordinate_gate_success_rate": rate(
                "passes_oracle_coordinate_gate"
            ),
            "oracle_metric_gate_success_rate": rate("passes_oracle_metric_gate"),
            "local_tetrad_gate_success_rate": rate("passes_local_tetrad_gate"),
        }

    return {key: summarize(group) for key, group in sorted(grouped.items())}


def select_regularization(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select intrinsic gates before interval and noncausal errors."""

    def median(summary: dict[str, object], key: str) -> float:
        statistic = summary[key]
        if not isinstance(statistic, dict):
            raise TypeError(f"{key} must contain summary statistics")
        value = statistic["median"]
        return float("inf") if value is None else float(value)

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        return (
            -float(summary["intrinsic_metric_gate_success_rate"]),
            -float(summary["intrinsic_coordinate_gate_success_rate"]),
            median(summary, "heldout_interval_relative_rmse"),
            median(summary, "noncausal_violation_fraction"),
            float(summary["regularization"]),
            key,
        )

    if not summaries:
        raise ValueError("at least one regularization summary is required")
    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run development selection or one frozen held-out metric audit."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in 3+1 dimensions")
    regularizations = sorted(set(args.regularizations))
    if not regularizations or regularizations[0] < 0.0:
        raise ValueError("metric regularizations must be nonnegative")
    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        sample
        for child in seed_sequence.spawn(args.realizations)
        for sample in reconstruct_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            args.scaffold_scale,
            args.anchor_time_multiplier,
            args.active_count,
            args.minimum_chart_support,
            args.minimum_lightcone_count,
            args.relative_time_shell_width,
            args.maximum_lower_candidates,
            args.maximum_upper_candidates,
            regularizations,
            args.heldout_fraction,
            args.minimum_heldout_open_count,
            args.maximum_noncausal_pairs,
            args.minimum_evaluation_count,
            args.maximum_chart_consistency_error,
            args.maximum_interval_error,
            args.minimum_heldout_causal_sign_fraction,
            args.maximum_noncausal_violation_fraction,
            args.minimum_causal_sensitivity,
            args.minimum_causal_specificity,
            args.maximum_coordinate_error,
            args.maximum_metric_error,
            args.maximum_conformal_metric_error,
        )
    ]
    summaries = summarize_samples(samples)
    if args.frozen_regularization is None:
        selected_key, selected_summary = select_regularization(summaries)
        status = "closed frame-constrained metric development selection"
    else:
        if len(regularizations) != 1 or not np.isclose(
            regularizations[0], args.frozen_regularization
        ):
            raise ValueError("held-out mode requires one matching frozen ridge")
        selected_key = regularization_key(args.frozen_regularization)
        selected_summary = summaries[selected_key]
        status = "frozen held-out frame-constrained metric audit"
    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "status": status,
        "construction_uses_known_embedding": False,
        "oracle_scores_use_known_embedding": True,
        "metric_prior_uses_chart_transported_minkowski_forms": True,
        "boundary_anchors_fix_gauge_but_are_excluded_from_metric_regression": True,
        "signature_and_dimension_are_not_derived_from_bare_order": True,
        "coframe_is_factored_from_the_fitted_local_metric": True,
        "spin_structure_is_not_derived": True,
        "connection_and_curvature_scores_opened": False,
        "density_is_supplied": True,
        "global_interval_endpoints_are_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "scaffold_scale": args.scaffold_scale,
            "anchor_time_multiplier": args.anchor_time_multiplier,
            "active_count": args.active_count,
            "minimum_chart_support": args.minimum_chart_support,
            "minimum_lightcone_count": args.minimum_lightcone_count,
            "relative_time_shell_width": args.relative_time_shell_width,
            "maximum_lower_candidates": args.maximum_lower_candidates,
            "maximum_upper_candidates": args.maximum_upper_candidates,
            "regularizations": regularizations,
            "heldout_fraction": args.heldout_fraction,
            "minimum_heldout_open_count": args.minimum_heldout_open_count,
            "maximum_noncausal_pairs": args.maximum_noncausal_pairs,
            "minimum_evaluation_count": args.minimum_evaluation_count,
            "maximum_chart_consistency_error": (
                args.maximum_chart_consistency_error
            ),
            "maximum_interval_error": args.maximum_interval_error,
            "minimum_heldout_causal_sign_fraction": (
                args.minimum_heldout_causal_sign_fraction
            ),
            "maximum_noncausal_violation_fraction": (
                args.maximum_noncausal_violation_fraction
            ),
            "minimum_causal_sensitivity": args.minimum_causal_sensitivity,
            "minimum_causal_specificity": args.minimum_causal_specificity,
            "maximum_coordinate_error": args.maximum_coordinate_error,
            "maximum_metric_error": args.maximum_metric_error,
            "maximum_conformal_metric_error": (
                args.maximum_conformal_metric_error
            ),
            "seed": args.seed,
        },
        "selection_rule": (
            "maximize intrinsic metric and coordinate gate rates, then minimize "
            "held-out interval error, noncausal violation, and ridge"
        ),
        "selected_regularization_key": selected_key,
        "selected_regularization_summary": selected_summary,
        "summaries": summaries,
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=int, default=2500)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--scaffold-scale", type=float, default=0.05)
    parser.add_argument("--anchor-time-multiplier", type=float, default=8.0)
    parser.add_argument("--active-count", type=int, default=12)
    parser.add_argument("--minimum-chart-support", type=int, default=2)
    parser.add_argument("--minimum-lightcone-count", type=int, default=20)
    parser.add_argument("--relative-time-shell-width", type=float, default=0.35)
    parser.add_argument("--maximum-lower-candidates", type=int, default=10)
    parser.add_argument("--maximum-upper-candidates", type=int, default=18)
    parser.add_argument(
        "--regularizations", type=float, nargs="+", default=[0.0, 0.01, 0.1, 1.0]
    )
    parser.add_argument("--heldout-fraction", type=float, default=0.20)
    parser.add_argument("--minimum-heldout-open-count", type=int, default=2)
    parser.add_argument("--maximum-noncausal-pairs", type=int, default=6000)
    parser.add_argument("--minimum-evaluation-count", type=int, default=24)
    parser.add_argument("--maximum-chart-consistency-error", type=float, default=0.85)
    parser.add_argument("--maximum-interval-error", type=float, default=0.20)
    parser.add_argument(
        "--minimum-heldout-causal-sign-fraction", type=float, default=0.95
    )
    parser.add_argument(
        "--maximum-noncausal-violation-fraction", type=float, default=0.10
    )
    parser.add_argument("--minimum-causal-sensitivity", type=float, default=0.80)
    parser.add_argument("--minimum-causal-specificity", type=float, default=0.95)
    parser.add_argument("--maximum-coordinate-error", type=float, default=0.75)
    parser.add_argument("--maximum-metric-error", type=float, default=0.75)
    parser.add_argument(
        "--maximum-conformal-metric-error", type=float, default=0.60
    )
    parser.add_argument("--seed", type=int, default=20260820)
    parser.add_argument("--frozen-regularization", type=float)
    parser.add_argument("--include-samples", action="store_true")
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_experiment(args)
    payload = json.dumps(result, indent=2, sort_keys=True)
    if args.output is None:
        print(payload)
    else:
        args.output.write_text(payload + "\n", encoding="utf-8", newline="\n")


if __name__ == "__main__":
    main()
