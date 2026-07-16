"""Overlapping Johnston lightcone atlas and transported operator metrics.

Stage A9 showed that a global full-interval MDS chart supplies useful two-sided
neighborhoods but is not locally affine enough for a covariant metric pullback.
This Stage A10 prototype uses the global chart only to select nearby targets.
At every selected target it constructs a fresh Johnston lightcone chart, whose
retarded past fully supports that target's operator row.  Spatial frames are
registered on order-derived chart overlaps by orthogonal Procrustes fits, and
row metrics are transported into the pivot frame before averaging.

The atlas exposes transition residuals and triangle cocycle residuals before
metric scoring.  Known sprinkling coordinates remain closed development
controls unless Johnston metric scores are explicitly opened on a frozen run.
Dimension, density, endpoints, spatial rank, and all mesoscopic scales remain
supplied, so this is a conditional numerical oracle rather than a bare-order
continuum derivation.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np
from scipy.linalg import orthogonal_procrustes

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    coordinate_pulled_metric,
    local_affine_jacobian,
)
from causal_johnston_full_embedding import johnston_full_embedding_from_relation
from causal_johnston_full_multirow_metric import (
    operator_row_from_relation,
    two_sided_averaging_targets,
)
from causal_johnston_multirow_metric import (
    centered_lorentzian_quadratic,
    centered_trace_identity_relative_error,
)
from causal_johnston_operator_control_scan import optimal_positive_rescaling
from causal_johnston_probe_metric import (
    JohnstonLightconeEmbedding,
    causal_interval_points,
    choose_intrinsic_pivot,
    compact_lightcone_probes,
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding_from_intrinsic_data,
    minkowski_interval_coefficient,
)
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    compact_coordinate_probes,
    corrected_gamma,
    finite_statistics,
    matrix_relative_error,
    signature,
)


@dataclass(frozen=True)
class SpatialRegistration:
    moving_to_reference: np.ndarray
    overlap_count: int
    relative_residual: float
    determinant: float


@dataclass(frozen=True)
class LocalAtlasMetricSample:
    averaging_radius: float
    row_count: int
    strict_past_target_count: int
    strict_future_target_count: int
    spacelike_target_count: int
    mean_recovered_time_offset: float
    registration_success_fraction: float
    registration_overlap_minimum: int
    registration_overlap_median: float
    registration_residual_median: float | None
    registration_residual_maximum: float | None
    orientation_reversing_fraction: float | None
    cocycle_success_fraction: float
    cocycle_relative_error_median: float | None
    cocycle_relative_error_maximum: float | None
    passes_atlas_gate: bool
    coordinate_signature: tuple[int, int, int]
    coordinate_metric_relative_error: float
    coordinate_conformal_factor: float | None
    coordinate_conformal_relative_error: float | None
    passes_coordinate_conformal_gate: bool
    mean_johnston_quadratic_response: float
    trace_normalization_factor: float | None
    trace_coordinate_signature: tuple[int, int, int] | None
    trace_coordinate_relative_error: float | None
    passes_trace_coordinate_gate: bool
    centered_trace_identity_relative_error: float
    johnston_signature: tuple[int, int, int] | None
    johnston_direct_relative_error: float | None
    johnston_conformal_factor: float | None
    johnston_conformal_relative_error: float | None
    passes_johnston_conformal_gate: bool
    trace_johnston_direct_relative_error: float | None
    passes_trace_johnston_direct_gate: bool
    pulled_johnston_signature: tuple[int, int, int] | None
    pulled_johnston_relative_error: float | None
    pulled_johnston_conformal_factor: float | None
    pulled_johnston_conformal_relative_error: float | None
    passes_pulled_johnston_conformal_gate: bool
    trace_pulled_johnston_relative_error: float | None
    passes_trace_pulled_johnston_gate: bool
    local_affine_fit_median: float | None
    local_affine_fit_maximum: float | None
    local_jacobian_condition_median: float | None
    passes_conditional_metric_gate: bool


def averaging_key(radius: float) -> str:
    """Stable JSON key for one atlas radius."""

    return f"radius={radius:.6f}"


def spatial_chart_registration(
    reference: JohnstonLightconeEmbedding,
    moving: JohnstonLightconeEmbedding,
    registration_radius: float,
    minimum_overlap: int = 6,
) -> SpatialRegistration | None:
    """Fit the order-derived O(3) transition from moving to reference."""

    if registration_radius <= 0.0:
        raise ValueError("registration radius must be positive")
    if minimum_overlap < 4:
        raise ValueError("registration needs at least four common events")
    if reference.probes.shape != moving.probes.shape:
        raise ValueError("charts must share one event carrier")

    reference_radius = np.linalg.norm(reference.probes, axis=1)
    moving_radius = np.linalg.norm(moving.probes, axis=1)
    common = (
        reference.embedded_mask
        & moving.embedded_mask
        & (reference_radius <= registration_radius)
        & (moving_radius <= registration_radius)
    )
    if np.count_nonzero(common) < minimum_overlap:
        common = reference.embedded_mask & moving.embedded_mask
    overlap_count = int(np.count_nonzero(common))
    if overlap_count < minimum_overlap:
        return None

    reference_spatial = reference.probes[common, 1:]
    moving_spatial = moving.probes[common, 1:]
    reference_centered = reference_spatial - np.mean(reference_spatial, axis=0)
    moving_centered = moving_spatial - np.mean(moving_spatial, axis=0)
    if (
        np.linalg.matrix_rank(reference_centered) < 3
        or np.linalg.matrix_rank(moving_centered) < 3
    ):
        return None
    rotation, _ = orthogonal_procrustes(moving_centered, reference_centered)
    fitted = moving_centered @ rotation
    denominator = max(float(np.linalg.norm(reference_centered)), 1.0e-14)
    residual = float(np.linalg.norm(fitted - reference_centered) / denominator)
    return SpatialRegistration(
        moving_to_reference=rotation,
        overlap_count=overlap_count,
        relative_residual=residual,
        determinant=float(np.linalg.det(rotation)),
    )


def transport_pairing_to_reference(
    pairing: np.ndarray,
    moving_to_reference: np.ndarray,
) -> np.ndarray:
    """Transport a probe pairing through a time-fixed spatial transition."""

    if pairing.shape != (4, 4):
        raise ValueError("pairing must be four-dimensional")
    if moving_to_reference.shape != (3, 3):
        raise ValueError("spatial transition must be 3 by 3")
    transform = np.eye(4)
    transform[1:, 1:] = moving_to_reference
    transported = transform.T @ pairing @ transform
    return 0.5 * (transported + transported.T)


def cocycle_relative_error(
    moving_to_middle: np.ndarray,
    middle_to_reference: np.ndarray,
    moving_to_reference: np.ndarray,
) -> float:
    """Residual of the O(3) transition cocycle on one chart triangle."""

    composed = moving_to_middle @ middle_to_reference
    return float(
        np.linalg.norm(composed - moving_to_reference, ord="fro") / math.sqrt(3.0)
    )


def _optional_error(matrix: np.ndarray | None) -> float | None:
    if matrix is None:
        return None
    return matrix_relative_error(matrix, MINKOWSKI_INVERSE)


def _median(values: list[float]) -> float | None:
    if not values:
        return None
    return float(np.median(values))


def _maximum(values: list[float]) -> float | None:
    if not values:
        return None
    return float(np.max(values))


def reconstruct_local_atlas_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    nonlocality_scale: float,
    support_radius: float,
    averaging_radii: list[float],
    registration_radius: float,
    affine_radius: float,
    maximum_registration_error: float,
    maximum_cocycle_error: float,
    maximum_conformal_error: float,
    maximum_trace_error: float,
    include_johnston_metrics: bool = False,
) -> list[LocalAtlasMetricSample]:
    """Construct one overlapping atlas and score every frozen radius."""

    points, bottom_index, top_index = causal_interval_points(rng, events, duration)
    relation = causal_relation_matrix(points, block_size)
    coefficient = minkowski_interval_coefficient(dimension)
    density = events / (coefficient * duration**dimension)
    ell = density ** (-1.0 / dimension)
    if nonlocality_scale <= ell:
        raise ValueError("nonlocality scale must be strictly greater than ell")
    intrinsic_time, intrinsic_radius = intrinsic_time_and_radius_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
    )
    pivot_index = choose_intrinsic_pivot(
        rng,
        relation,
        intrinsic_time,
        intrinsic_radius,
        bottom_index,
        top_index,
        duration,
        dimension,
    )
    selector_chart = johnston_full_embedding_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
        spatial_rank=dimension - 1,
    )
    targets_by_radius = {
        radius: two_sided_averaging_targets(
            selector_chart.coordinates, pivot_index, radius
        )
        for radius in averaging_radii
    }
    all_targets = np.unique(np.concatenate(list(targets_by_radius.values())))
    charts: dict[int, JohnstonLightconeEmbedding] = {}
    for target in all_targets:
        target_int = int(target)
        try:
            charts[target_int] = johnston_lightcone_embedding_from_intrinsic_data(
                relation,
                density,
                dimension,
                bottom_index,
                top_index,
                target_int,
                intrinsic_time,
                intrinsic_radius,
                spatial_rank=dimension - 1,
            )
        except ValueError:
            # Availability is part of the atlas gate, not a reason to abort the
            # entire realization when one nearby carrier is too small.
            continue
    if pivot_index not in charts:
        raise ValueError("order-selected pivot has no rank-three lightcone chart")
    pivot_chart = charts[pivot_index]

    registrations: dict[int, SpatialRegistration | None] = {}
    for target in all_targets:
        target_int = int(target)
        if target_int not in charts:
            registrations[target_int] = None
            continue
        if target_int == pivot_index:
            registrations[target_int] = SpatialRegistration(
                moving_to_reference=np.eye(3),
                overlap_count=int(np.count_nonzero(pivot_chart.embedded_mask)),
                relative_residual=0.0,
                determinant=1.0,
            )
        else:
            registrations[target_int] = spatial_chart_registration(
                pivot_chart,
                charts[target_int],
                registration_radius,
            )

    coordinate_pairings: dict[int, np.ndarray] = {}
    transported_pairings: dict[int, np.ndarray] = {}
    pulled_pairings: dict[int, np.ndarray] = {}
    responses: dict[int, float] = {}
    identity_errors: dict[int, float] = {}
    affine_fit_errors: dict[int, float] = {}
    jacobian_conditions: dict[int, float] = {}
    for target in all_targets:
        target_int = int(target)
        registration = registrations[target_int]
        if registration is None:
            continue
        chart = charts[target_int]
        probes = compact_lightcone_probes(chart, support_radius)
        row = operator_row_from_relation(relation, target_int, ell, nonlocality_scale)
        local_pairing = corrected_gamma(row, probes, target_int)
        transported_pairings[target_int] = transport_pairing_to_reference(
            local_pairing, registration.moving_to_reference
        )
        coordinate_pairings[target_int] = corrected_gamma(
            row,
            compact_coordinate_probes(points, target_int, support_radius),
            target_int,
        )
        response = float(row @ centered_lorentzian_quadratic(probes, target_int))
        responses[target_int] = response
        identity_errors[target_int] = centered_trace_identity_relative_error(
            response, local_pairing
        )

        if include_johnston_metrics:
            recovered_radius = np.linalg.norm(chart.probes, axis=1)
            inner_mask = chart.embedded_mask & (recovered_radius <= affine_radius)
            if np.count_nonzero(inner_mask) < max(dimension + 1, 6):
                inner_mask = chart.embedded_mask
            jacobian, fit_error, rank, condition = local_affine_jacobian(
                points, target_int, probes, inner_mask
            )
            pulled = coordinate_pulled_metric(local_pairing, jacobian)
            if pulled is not None and rank == dimension:
                pulled_pairings[target_int] = pulled
            affine_fit_errors[target_int] = fit_error
            if condition is not None:
                jacobian_conditions[target_int] = condition

    expected_signature = (1, dimension - 1, 0)
    recovered_time = selector_chart.coordinates[:, 0]
    samples: list[LocalAtlasMetricSample] = []
    for radius in averaging_radii:
        targets = [int(target) for target in targets_by_radius[radius]]
        valid_targets = [
            target
            for target in targets
            if target in coordinate_pairings and target in transported_pairings
        ]
        registration_success = len(valid_targets) / len(targets)
        target_registrations = [
            registrations[target]
            for target in valid_targets
            if registrations[target] is not None
        ]
        overlap_counts = [
            registration.overlap_count for registration in target_registrations
        ]
        registration_residuals = [
            registration.relative_residual for registration in target_registrations
        ]
        determinants = [
            registration.determinant for registration in target_registrations
        ]

        cocycle_errors: list[float] = []
        possible_cocycles = len(valid_targets) * (len(valid_targets) - 1) // 2
        successful_cocycles = 0
        for left_position, middle in enumerate(valid_targets):
            middle_to_pivot = registrations[middle]
            if middle_to_pivot is None:
                continue
            for moving in valid_targets[left_position + 1 :]:
                moving_to_pivot = registrations[moving]
                if moving_to_pivot is None:
                    continue
                moving_to_middle = spatial_chart_registration(
                    charts[middle],
                    charts[moving],
                    registration_radius,
                )
                if moving_to_middle is None:
                    continue
                successful_cocycles += 1
                cocycle_errors.append(
                    cocycle_relative_error(
                        moving_to_middle.moving_to_reference,
                        middle_to_pivot.moving_to_reference,
                        moving_to_pivot.moving_to_reference,
                    )
                )
        cocycle_success = (
            1.0 if possible_cocycles == 0 else successful_cocycles / possible_cocycles
        )
        registration_median = _median(registration_residuals)
        cocycle_median = _median(cocycle_errors)
        atlas_gate = (
            registration_success == 1.0
            and cocycle_success == 1.0
            and registration_median is not None
            and registration_median <= maximum_registration_error
            and (cocycle_median is None or cocycle_median <= maximum_cocycle_error)
        )

        coordinate_average = np.mean(
            [coordinate_pairings[target] for target in valid_targets], axis=0
        )
        johnston_average = np.mean(
            [transported_pairings[target] for target in valid_targets], axis=0
        )
        mean_response = float(np.mean([responses[target] for target in valid_targets]))
        trace_factor = (
            None
            if not np.isfinite(mean_response) or mean_response <= 1.0e-12
            else 2.0 * dimension / mean_response
        )
        trace_coordinate = (
            None if trace_factor is None else trace_factor * coordinate_average
        )
        trace_johnston = (
            None if trace_factor is None else trace_factor * johnston_average
        )
        coordinate_signature = signature(coordinate_average)
        coordinate_factor, coordinate_conformal_error = optimal_positive_rescaling(
            coordinate_average
        )
        trace_coordinate_signature = (
            None if trace_coordinate is None else signature(trace_coordinate)
        )
        trace_coordinate_error = _optional_error(trace_coordinate)

        opened_johnston = johnston_average if include_johnston_metrics else None
        johnston_signature = (
            None if opened_johnston is None else signature(opened_johnston)
        )
        johnston_factor, johnston_conformal_error = (
            (None, None)
            if opened_johnston is None
            else optimal_positive_rescaling(opened_johnston)
        )
        trace_johnston_error = (
            None if not include_johnston_metrics else _optional_error(trace_johnston)
        )

        valid_pulled_targets = [
            target for target in valid_targets if target in pulled_pairings
        ]
        pulled_average = (
            None
            if not include_johnston_metrics or not valid_pulled_targets
            else np.mean(
                [pulled_pairings[target] for target in valid_pulled_targets],
                axis=0,
            )
        )
        pulled_signature = None if pulled_average is None else signature(pulled_average)
        pulled_factor, pulled_conformal_error = (
            (None, None)
            if pulled_average is None
            else optimal_positive_rescaling(pulled_average)
        )
        trace_pulled = (
            None
            if pulled_average is None or trace_factor is None
            else trace_factor * pulled_average
        )
        trace_pulled_error = _optional_error(trace_pulled)

        strict_past_count = int(np.count_nonzero(relation[targets, pivot_index]))
        strict_future_count = int(np.count_nonzero(relation[pivot_index, targets]))
        spacelike_count = len(targets) - strict_past_count - strict_future_count - 1
        fit_values = [
            affine_fit_errors[target]
            for target in valid_targets
            if target in affine_fit_errors
        ]
        condition_values = [
            jacobian_conditions[target]
            for target in valid_targets
            if target in jacobian_conditions
        ]
        conditional_gate = (
            atlas_gate
            and johnston_signature == expected_signature
            and pulled_signature == expected_signature
            and trace_pulled_error is not None
            and trace_pulled_error <= maximum_trace_error
        )
        samples.append(
            LocalAtlasMetricSample(
                averaging_radius=radius,
                row_count=len(targets),
                strict_past_target_count=strict_past_count,
                strict_future_target_count=strict_future_count,
                spacelike_target_count=spacelike_count,
                mean_recovered_time_offset=float(
                    np.mean(recovered_time[targets] - recovered_time[pivot_index])
                ),
                registration_success_fraction=registration_success,
                registration_overlap_minimum=min(overlap_counts),
                registration_overlap_median=float(np.median(overlap_counts)),
                registration_residual_median=registration_median,
                registration_residual_maximum=_maximum(registration_residuals),
                orientation_reversing_fraction=(
                    None
                    if not determinants
                    else sum(value < 0.0 for value in determinants) / len(determinants)
                ),
                cocycle_success_fraction=cocycle_success,
                cocycle_relative_error_median=cocycle_median,
                cocycle_relative_error_maximum=_maximum(cocycle_errors),
                passes_atlas_gate=atlas_gate,
                coordinate_signature=coordinate_signature,
                coordinate_metric_relative_error=matrix_relative_error(
                    coordinate_average, MINKOWSKI_INVERSE
                ),
                coordinate_conformal_factor=coordinate_factor,
                coordinate_conformal_relative_error=(coordinate_conformal_error),
                passes_coordinate_conformal_gate=(
                    coordinate_signature == expected_signature
                    and coordinate_conformal_error is not None
                    and coordinate_conformal_error <= maximum_conformal_error
                ),
                mean_johnston_quadratic_response=mean_response,
                trace_normalization_factor=trace_factor,
                trace_coordinate_signature=trace_coordinate_signature,
                trace_coordinate_relative_error=trace_coordinate_error,
                passes_trace_coordinate_gate=(
                    trace_coordinate_signature == expected_signature
                    and trace_coordinate_error is not None
                    and trace_coordinate_error <= maximum_trace_error
                ),
                centered_trace_identity_relative_error=max(
                    identity_errors[target] for target in valid_targets
                ),
                johnston_signature=johnston_signature,
                johnston_direct_relative_error=_optional_error(opened_johnston),
                johnston_conformal_factor=johnston_factor,
                johnston_conformal_relative_error=(johnston_conformal_error),
                passes_johnston_conformal_gate=(
                    johnston_signature == expected_signature
                    and johnston_conformal_error is not None
                    and johnston_conformal_error <= maximum_conformal_error
                ),
                trace_johnston_direct_relative_error=(trace_johnston_error),
                passes_trace_johnston_direct_gate=(
                    johnston_signature == expected_signature
                    and trace_johnston_error is not None
                    and trace_johnston_error <= maximum_trace_error
                ),
                pulled_johnston_signature=pulled_signature,
                pulled_johnston_relative_error=_optional_error(pulled_average),
                pulled_johnston_conformal_factor=pulled_factor,
                pulled_johnston_conformal_relative_error=(pulled_conformal_error),
                passes_pulled_johnston_conformal_gate=(
                    pulled_signature == expected_signature
                    and pulled_conformal_error is not None
                    and pulled_conformal_error <= maximum_conformal_error
                ),
                trace_pulled_johnston_relative_error=trace_pulled_error,
                passes_trace_pulled_johnston_gate=(
                    pulled_signature == expected_signature
                    and trace_pulled_error is not None
                    and trace_pulled_error <= maximum_trace_error
                ),
                local_affine_fit_median=_median(fit_values),
                local_affine_fit_maximum=_maximum(fit_values),
                local_jacobian_condition_median=_median(condition_values),
                passes_conditional_metric_gate=conditional_gate,
            )
        )
    return samples


def summarize_radius(
    samples: list[LocalAtlasMetricSample],
) -> dict[str, object]:
    """Summarize one atlas radius."""

    def statistics(attribute: str) -> dict[str, float | int | None]:
        return finite_statistics([getattr(sample, attribute) for sample in samples])

    def rate(attribute: str) -> float:
        return sum(bool(getattr(sample, attribute)) for sample in samples) / len(
            samples
        )

    return {
        "averaging_radius": samples[0].averaging_radius,
        "samples": len(samples),
        "row_count": statistics("row_count"),
        "strict_past_target_count": statistics("strict_past_target_count"),
        "strict_future_target_count": statistics("strict_future_target_count"),
        "spacelike_target_count": statistics("spacelike_target_count"),
        "mean_recovered_time_offset": statistics("mean_recovered_time_offset"),
        "registration_success_fraction": statistics("registration_success_fraction"),
        "registration_overlap_minimum": statistics("registration_overlap_minimum"),
        "registration_overlap_median": statistics("registration_overlap_median"),
        "registration_residual_median": statistics("registration_residual_median"),
        "registration_residual_maximum": statistics("registration_residual_maximum"),
        "orientation_reversing_fraction": statistics("orientation_reversing_fraction"),
        "cocycle_success_fraction": statistics("cocycle_success_fraction"),
        "cocycle_relative_error_median": statistics("cocycle_relative_error_median"),
        "cocycle_relative_error_maximum": statistics("cocycle_relative_error_maximum"),
        "atlas_gate_success_rate": rate("passes_atlas_gate"),
        "coordinate_metric_relative_error": statistics(
            "coordinate_metric_relative_error"
        ),
        "coordinate_conformal_factor": statistics("coordinate_conformal_factor"),
        "coordinate_conformal_relative_error": statistics(
            "coordinate_conformal_relative_error"
        ),
        "coordinate_conformal_gate_success_rate": rate(
            "passes_coordinate_conformal_gate"
        ),
        "mean_johnston_quadratic_response": statistics(
            "mean_johnston_quadratic_response"
        ),
        "trace_normalization_factor": statistics("trace_normalization_factor"),
        "trace_coordinate_relative_error": statistics(
            "trace_coordinate_relative_error"
        ),
        "trace_coordinate_gate_success_rate": rate("passes_trace_coordinate_gate"),
        "centered_trace_identity_relative_error": statistics(
            "centered_trace_identity_relative_error"
        ),
        "johnston_direct_relative_error": statistics("johnston_direct_relative_error"),
        "johnston_conformal_factor": statistics("johnston_conformal_factor"),
        "johnston_conformal_relative_error": statistics(
            "johnston_conformal_relative_error"
        ),
        "johnston_conformal_gate_success_rate": rate("passes_johnston_conformal_gate"),
        "trace_johnston_direct_relative_error": statistics(
            "trace_johnston_direct_relative_error"
        ),
        "trace_johnston_direct_gate_success_rate": rate(
            "passes_trace_johnston_direct_gate"
        ),
        "pulled_johnston_relative_error": statistics("pulled_johnston_relative_error"),
        "pulled_johnston_conformal_factor": statistics(
            "pulled_johnston_conformal_factor"
        ),
        "pulled_johnston_conformal_relative_error": statistics(
            "pulled_johnston_conformal_relative_error"
        ),
        "pulled_johnston_conformal_gate_success_rate": rate(
            "passes_pulled_johnston_conformal_gate"
        ),
        "trace_pulled_johnston_relative_error": statistics(
            "trace_pulled_johnston_relative_error"
        ),
        "trace_pulled_johnston_gate_success_rate": rate(
            "passes_trace_pulled_johnston_gate"
        ),
        "local_affine_fit_median": statistics("local_affine_fit_median"),
        "local_affine_fit_maximum": statistics("local_affine_fit_maximum"),
        "local_jacobian_condition_median": statistics(
            "local_jacobian_condition_median"
        ),
        "conditional_metric_gate_success_rate": rate("passes_conditional_metric_gate"),
    }


def summarize_grid(
    samples: list[LocalAtlasMetricSample],
) -> dict[str, dict[str, object]]:
    """Group atlas samples by radius."""

    grouped: dict[str, list[LocalAtlasMetricSample]] = {}
    for sample in samples:
        grouped.setdefault(averaging_key(sample.averaging_radius), []).append(sample)
    return {key: summarize_radius(group) for key, group in sorted(grouped.items())}


def select_atlas_radius(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select atlas validity, coordinate gates, then median errors."""

    if not summaries:
        raise ValueError("at least one atlas summary is required")

    def statistic(summary: dict[str, object], key: str) -> float:
        values = summary[key]
        if not isinstance(values, dict):
            raise TypeError(f"{key} statistics must be a dictionary")
        median = values["median"]
        return float("inf") if median is None else float(median)

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        return (
            -float(summary["atlas_gate_success_rate"]),
            -float(summary["trace_coordinate_gate_success_rate"]),
            -float(summary["coordinate_conformal_gate_success_rate"]),
            statistic(summary, "trace_coordinate_relative_error"),
            statistic(summary, "coordinate_conformal_relative_error"),
            float(summary["averaging_radius"]),
            key,
        )

    nontrivial = [
        item for item in summaries.items() if statistic(item[1], "row_count") > 1.0
    ]
    candidates = nontrivial if nontrivial else list(summaries.items())
    return min(candidates, key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run closed atlas development or one frozen held-out gate."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    if args.events < 4 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    if args.duration <= 0.0 or args.block_size <= 0:
        raise ValueError("duration and block size must be positive")
    positive_scales = (
        args.nonlocality_scale,
        args.support_radius,
        args.registration_radius,
        args.affine_radius,
    )
    if any(scale <= 0.0 for scale in positive_scales):
        raise ValueError("all operator and chart scales must be positive")
    nonnegative_thresholds = (
        args.maximum_registration_error,
        args.maximum_cocycle_error,
        args.maximum_conformal_error,
        args.maximum_trace_error,
    )
    if any(threshold < 0.0 for threshold in nonnegative_thresholds):
        raise ValueError("all gate thresholds must be nonnegative")
    radii = sorted(set(args.averaging_radii))
    if not radii or any(radius < 0.0 for radius in radii):
        raise ValueError("averaging radii must be nonnegative")

    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    ell = density ** (-1.0 / args.dimension)
    if args.nonlocality_scale <= ell:
        raise ValueError("nonlocality scale must be strictly greater than ell")

    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        sample
        for child in seed_sequence.spawn(args.realizations)
        for sample in reconstruct_local_atlas_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            args.nonlocality_scale,
            args.support_radius,
            radii,
            args.registration_radius,
            args.affine_radius,
            args.maximum_registration_error,
            args.maximum_cocycle_error,
            args.maximum_conformal_error,
            args.maximum_trace_error,
            include_johnston_metrics=args.open_johnston_metrics,
        )
    ]
    summaries = summarize_grid(samples)
    if args.frozen_radius is None:
        selected_key, selected_summary = select_atlas_radius(summaries)
        status = "closed atlas development selection"
    else:
        if len(radii) != 1 or not np.isclose(radii[0], args.frozen_radius):
            raise ValueError("held-out mode requires one matching frozen radius")
        selected_key = averaging_key(args.frozen_radius)
        selected_summary = summaries[selected_key]
        status = "frozen held-out atlas metric evaluation"
    result: dict[str, object] = {
        "status": status,
        "selector_uses_full_recovered_chart": True,
        "atlas_transitions_use_embedding_coordinates": False,
        "coordinate_control_scores_use_embedding_coordinates": True,
        "johnston_metric_scores_opened": args.open_johnston_metrics,
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "interval_endpoints_are_supplied": True,
        "spatial_rank_is_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "ell": ell,
            "nonlocality_scale": args.nonlocality_scale,
            "support_radius": args.support_radius,
            "averaging_radii": radii,
            "registration_radius": args.registration_radius,
            "affine_radius": args.affine_radius,
            "maximum_registration_error": args.maximum_registration_error,
            "maximum_cocycle_error": args.maximum_cocycle_error,
            "maximum_conformal_error": args.maximum_conformal_error,
            "maximum_trace_error": args.maximum_trace_error,
            "seed": args.seed,
        },
        "selection_rule": (
            "maximum atlas-gate rate, then trace-coordinate and conformal "
            "gate rates, then minimum median trace and conformal errors"
        ),
        "selected_averaging_key": selected_key,
        "selected_averaging_radius": selected_summary,
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
    parser.add_argument("--nonlocality-scale", type=float, default=0.18)
    parser.add_argument("--support-radius", type=float, default=0.65)
    parser.add_argument(
        "--averaging-radii",
        type=float,
        nargs="+",
        default=[0.0, 0.04, 0.05, 0.06, 0.075],
    )
    parser.add_argument("--registration-radius", type=float, default=0.30)
    parser.add_argument("--affine-radius", type=float, default=0.18)
    parser.add_argument("--maximum-registration-error", type=float, default=0.25)
    parser.add_argument("--maximum-cocycle-error", type=float, default=0.25)
    parser.add_argument("--maximum-conformal-error", type=float, default=0.50)
    parser.add_argument("--maximum-trace-error", type=float, default=0.50)
    parser.add_argument("--seed", type=int, default=20260802)
    parser.add_argument("--open-johnston-metrics", action="store_true")
    parser.add_argument("--frozen-radius", type=float)
    parser.add_argument("--include-samples", action="store_true")
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_experiment(args)
    encoded = json.dumps(result, indent=2, sort_keys=True)
    if args.output is not None:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(encoded + "\n", encoding="utf-8", newline="\n")
    print(encoded)


if __name__ == "__main__":
    main()
