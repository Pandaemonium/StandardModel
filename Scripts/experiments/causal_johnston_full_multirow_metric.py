"""Two-sided common-chart causal-operator metric averaging.

Stage A8 could average only rows in a pivot's strict past because its Johnston
lightcone chart did not embed spacelike events.  This Stage A9 experiment uses
the simultaneous full-interval embedding of ``causal_johnston_full_embedding``
to select and evaluate every row in a recovered Euclidean ball around the
pivot.  The neighborhood is therefore genuinely two-sided in recovered time
and includes spacelike-separated targets.

Two target-independent trace estimators are compared during development:

* average the row pairings, then impose the mean Johnston quadratic trace;
* positively trace-normalize each admissible row, then average those rows.

Scale-free conformal shape is always scored before either trace estimator.
Known sprinkling coordinates are development controls only.  Full Johnston
metric scores remain closed unless explicitly opened on a frozen held-out run.
Dimension, density, endpoints, and spatial rank are still supplied.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    coordinate_pulled_metric,
    local_affine_jacobian,
)
from causal_johnston_full_embedding import (
    compact_full_embedding_probes,
    johnston_full_embedding_from_relation,
)
from causal_johnston_multirow_metric import (
    centered_lorentzian_quadratic,
    centered_trace_identity_relative_error,
)
from causal_johnston_operator_control_scan import optimal_positive_rescaling
from causal_johnston_probe_metric import (
    causal_interval_points,
    choose_intrinsic_pivot,
    intrinsic_time_and_radius_from_relation,
    minkowski_interval_coefficient,
    selected_open_interval_counts,
)
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    compact_coordinate_probes,
    corrected_gamma,
    finite_statistics,
    matrix_relative_error,
    project_convention_row,
    signature,
    smeared_bd_row,
)


AVERAGE_TRACE = "average_trace"
ROWWISE_TRACE = "rowwise_trace"


@dataclass(frozen=True)
class FullMultirowMetricSample:
    averaging_radius: float
    row_count: int
    strict_past_target_count: int
    strict_future_target_count: int
    spacelike_target_count: int
    mean_recovered_time_offset: float
    coordinate_signature: tuple[int, int, int]
    coordinate_pairing: list[list[float]]
    coordinate_metric_relative_error: float
    coordinate_conformal_factor: float | None
    coordinate_conformal_relative_error: float | None
    passes_coordinate_conformal_gate: bool
    mean_johnston_quadratic_response: float
    average_trace_normalization_factor: float | None
    average_trace_coordinate_signature: tuple[int, int, int] | None
    average_trace_coordinate_pairing: list[list[float]] | None
    average_trace_coordinate_relative_error: float | None
    passes_average_trace_coordinate_gate: bool
    positive_trace_row_fraction: float
    rowwise_trace_coordinate_signature: tuple[int, int, int] | None
    rowwise_trace_coordinate_pairing: list[list[float]] | None
    rowwise_trace_coordinate_relative_error: float | None
    passes_rowwise_trace_coordinate_gate: bool
    centered_trace_identity_relative_error: float
    johnston_signature: tuple[int, int, int] | None
    johnston_pairing: list[list[float]] | None
    johnston_direct_relative_error: float | None
    johnston_direct_conformal_factor: float | None
    johnston_direct_conformal_relative_error: float | None
    passes_johnston_direct_conformal_gate: bool
    johnston_pulled_relative_error: float | None
    johnston_conformal_factor: float | None
    johnston_conformal_pulled_relative_error: float | None
    passes_johnston_conformal_gate: bool
    average_trace_johnston_direct_relative_error: float | None
    passes_average_trace_johnston_direct_gate: bool
    average_trace_johnston_pulled_relative_error: float | None
    passes_average_trace_johnston_gate: bool
    rowwise_trace_johnston_direct_relative_error: float | None
    passes_rowwise_trace_johnston_direct_gate: bool
    rowwise_trace_johnston_pulled_relative_error: float | None
    passes_rowwise_trace_johnston_gate: bool
    local_affine_fit_relative_error: float | None
    local_jacobian_rank: int | None
    local_jacobian_condition: float | None
    pivot_intrinsic_time: float
    pivot_intrinsic_radius: float


def averaging_key(radius: float) -> str:
    """Stable JSON key for one full-chart radius."""

    return f"radius={radius:.6f}"


def two_sided_averaging_targets(
    coordinates: np.ndarray,
    pivot_index: int,
    averaging_radius: float,
) -> np.ndarray:
    """Select every recovered-chart target in a Euclidean pivot ball."""

    if coordinates.ndim != 2:
        raise ValueError("coordinates must be a matrix")
    if not 0 <= pivot_index < len(coordinates):
        raise IndexError("pivot is outside the coordinate carrier")
    if averaging_radius < 0.0:
        raise ValueError("averaging radius must be nonnegative")
    centered = coordinates - coordinates[pivot_index]
    recovered_radius = np.linalg.norm(centered, axis=1)
    selected = recovered_radius <= averaging_radius
    selected[pivot_index] = True
    return np.flatnonzero(selected)


def operator_row_from_relation(
    relation: np.ndarray,
    target_index: int,
    ell: float,
    nonlocality_scale: float,
) -> np.ndarray:
    """Construct one project-sign smeared operator row from order counts."""

    past = relation[:, target_index]
    past_indices = np.flatnonzero(past)
    counts = np.zeros(len(relation), dtype=np.int64)
    if len(past_indices) > 0:
        counts[past_indices] = selected_open_interval_counts(
            relation, past_indices, np.array([target_index])
        )[:, 0]
    return project_convention_row(
        smeared_bd_row(
            past,
            counts,
            target_index,
            ell,
            nonlocality_scale,
        )
    )


def rowwise_trace_normalized_average(
    pairings: list[np.ndarray],
    responses: list[float],
    dimension: int,
    floor: float = 1.0e-12,
) -> tuple[np.ndarray | None, float]:
    """Average rows after each positive response is normalized to ``2d``."""

    if len(pairings) != len(responses) or not pairings:
        raise ValueError("pairings and responses must be nonempty and aligned")
    normalized = [
        (2.0 * dimension / response) * pairing
        for pairing, response in zip(pairings, responses, strict=True)
        if np.isfinite(response) and response > floor
    ]
    fraction = len(normalized) / len(pairings)
    if not normalized:
        return None, fraction
    return np.mean(normalized, axis=0), fraction


def _optional_error(matrix: np.ndarray | None) -> float | None:
    if matrix is None:
        return None
    return matrix_relative_error(matrix, MINKOWSKI_INVERSE)


def reconstruct_full_multirow_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    nonlocality_scale: float,
    support_radius: float,
    averaging_radii: list[float],
    maximum_conformal_error: float,
    maximum_trace_error: float,
    include_johnston_metrics: bool = False,
) -> list[FullMultirowMetricSample]:
    """Build and score every frozen two-sided averaging radius."""

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
    embedding = johnston_full_embedding_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
        spatial_rank=dimension - 1,
    )
    johnston_probes = compact_full_embedding_probes(
        embedding, pivot_index, support_radius
    )
    coordinate_probes = compact_coordinate_probes(points, pivot_index, support_radius)
    targets_by_radius = {
        radius: two_sided_averaging_targets(embedding.coordinates, pivot_index, radius)
        for radius in averaging_radii
    }
    all_targets = np.unique(np.concatenate(list(targets_by_radius.values())))

    coordinate_pairings: dict[int, np.ndarray] = {}
    johnston_pairings: dict[int, np.ndarray] = {}
    quadratic_responses: dict[int, float] = {}
    identity_errors: dict[int, float] = {}
    for target_index in all_targets:
        target = int(target_index)
        row = operator_row_from_relation(relation, target, ell, nonlocality_scale)
        coordinate_pairing = corrected_gamma(row, coordinate_probes, target)
        johnston_pairing = corrected_gamma(row, johnston_probes, target)
        response = float(row @ centered_lorentzian_quadratic(johnston_probes, target))
        coordinate_pairings[target] = coordinate_pairing
        johnston_pairings[target] = johnston_pairing
        quadratic_responses[target] = response
        identity_errors[target] = centered_trace_identity_relative_error(
            response, johnston_pairing
        )

    jacobian: np.ndarray | None = None
    fit_error: float | None = None
    jacobian_rank: int | None = None
    jacobian_condition: float | None = None
    if include_johnston_metrics:
        centered = embedding.coordinates - embedding.coordinates[pivot_index]
        inner_mask = np.linalg.norm(centered, axis=1) <= nonlocality_scale
        if np.count_nonzero(inner_mask) < max(dimension + 1, 6):
            inner_mask = np.linalg.norm(centered, axis=1) <= support_radius / 2
        jacobian, fit_error, jacobian_rank, jacobian_condition = local_affine_jacobian(
            points, pivot_index, johnston_probes, inner_mask
        )

    expected_signature = (1, dimension - 1, 0)
    samples: list[FullMultirowMetricSample] = []
    recovered_time = embedding.coordinates[:, 0]
    for radius in averaging_radii:
        targets = targets_by_radius[radius]
        target_coordinate_pairings = [
            coordinate_pairings[int(target)] for target in targets
        ]
        target_johnston_pairings = [
            johnston_pairings[int(target)] for target in targets
        ]
        responses = [quadratic_responses[int(target)] for target in targets]
        coordinate_average = np.mean(target_coordinate_pairings, axis=0)
        johnston_average = np.mean(target_johnston_pairings, axis=0)
        coordinate_signature = signature(coordinate_average)
        coordinate_factor, coordinate_conformal_error = optimal_positive_rescaling(
            coordinate_average
        )
        mean_response = float(np.mean(responses))
        average_trace_factor = (
            None
            if not np.isfinite(mean_response) or mean_response <= 1.0e-12
            else 2.0 * dimension / mean_response
        )
        average_trace_coordinate = (
            None
            if average_trace_factor is None
            else average_trace_factor * coordinate_average
        )
        average_trace_johnston = (
            None
            if average_trace_factor is None
            else average_trace_factor * johnston_average
        )
        rowwise_coordinate, positive_fraction = rowwise_trace_normalized_average(
            target_coordinate_pairings, responses, dimension
        )
        rowwise_johnston, _ = rowwise_trace_normalized_average(
            target_johnston_pairings, responses, dimension
        )
        average_trace_coordinate_signature = (
            None
            if average_trace_coordinate is None
            else signature(average_trace_coordinate)
        )
        rowwise_coordinate_signature = (
            None if rowwise_coordinate is None else signature(rowwise_coordinate)
        )
        average_trace_coordinate_error = _optional_error(average_trace_coordinate)
        rowwise_coordinate_error = _optional_error(rowwise_coordinate)

        opened_johnston = johnston_average if include_johnston_metrics else None
        johnston_direct_factor, johnston_direct_conformal_error = (
            (None, None)
            if opened_johnston is None
            else optimal_positive_rescaling(opened_johnston)
        )
        pulled_johnston = (
            None
            if opened_johnston is None or jacobian is None
            else coordinate_pulled_metric(opened_johnston, jacobian)
        )
        johnston_factor, johnston_conformal_error = (
            (None, None)
            if pulled_johnston is None
            else optimal_positive_rescaling(pulled_johnston)
        )
        pulled_average_trace_johnston = (
            None
            if average_trace_johnston is None
            or jacobian is None
            or not include_johnston_metrics
            else coordinate_pulled_metric(average_trace_johnston, jacobian)
        )
        pulled_rowwise_johnston = (
            None
            if rowwise_johnston is None
            or jacobian is None
            or not include_johnston_metrics
            else coordinate_pulled_metric(rowwise_johnston, jacobian)
        )
        average_trace_johnston_error = _optional_error(pulled_average_trace_johnston)
        rowwise_johnston_error = _optional_error(pulled_rowwise_johnston)
        average_trace_johnston_direct_error = (
            None
            if not include_johnston_metrics
            else _optional_error(average_trace_johnston)
        )
        rowwise_johnston_direct_error = (
            None if not include_johnston_metrics else _optional_error(rowwise_johnston)
        )
        johnston_signature = (
            None if opened_johnston is None else signature(opened_johnston)
        )

        strict_past_count = int(np.count_nonzero(relation[targets, pivot_index]))
        strict_future_count = int(np.count_nonzero(relation[pivot_index, targets]))
        spacelike_count = len(targets) - strict_past_count - strict_future_count - 1
        samples.append(
            FullMultirowMetricSample(
                averaging_radius=radius,
                row_count=len(targets),
                strict_past_target_count=strict_past_count,
                strict_future_target_count=strict_future_count,
                spacelike_target_count=spacelike_count,
                mean_recovered_time_offset=float(
                    np.mean(recovered_time[targets] - recovered_time[pivot_index])
                ),
                coordinate_signature=coordinate_signature,
                coordinate_pairing=coordinate_average.tolist(),
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
                average_trace_normalization_factor=average_trace_factor,
                average_trace_coordinate_signature=(average_trace_coordinate_signature),
                average_trace_coordinate_pairing=(
                    None
                    if average_trace_coordinate is None
                    else average_trace_coordinate.tolist()
                ),
                average_trace_coordinate_relative_error=(
                    average_trace_coordinate_error
                ),
                passes_average_trace_coordinate_gate=(
                    average_trace_coordinate_signature == expected_signature
                    and average_trace_coordinate_error is not None
                    and average_trace_coordinate_error <= maximum_trace_error
                ),
                positive_trace_row_fraction=positive_fraction,
                rowwise_trace_coordinate_signature=(rowwise_coordinate_signature),
                rowwise_trace_coordinate_pairing=(
                    None if rowwise_coordinate is None else rowwise_coordinate.tolist()
                ),
                rowwise_trace_coordinate_relative_error=(rowwise_coordinate_error),
                passes_rowwise_trace_coordinate_gate=(
                    rowwise_coordinate_signature == expected_signature
                    and rowwise_coordinate_error is not None
                    and rowwise_coordinate_error <= maximum_trace_error
                ),
                centered_trace_identity_relative_error=max(
                    identity_errors[int(target)] for target in targets
                ),
                johnston_signature=johnston_signature,
                johnston_pairing=(
                    None if opened_johnston is None else opened_johnston.tolist()
                ),
                johnston_direct_relative_error=_optional_error(opened_johnston),
                johnston_direct_conformal_factor=johnston_direct_factor,
                johnston_direct_conformal_relative_error=(
                    johnston_direct_conformal_error
                ),
                passes_johnston_direct_conformal_gate=(
                    johnston_signature == expected_signature
                    and johnston_direct_conformal_error is not None
                    and johnston_direct_conformal_error <= maximum_conformal_error
                ),
                johnston_pulled_relative_error=_optional_error(pulled_johnston),
                johnston_conformal_factor=johnston_factor,
                johnston_conformal_pulled_relative_error=(johnston_conformal_error),
                passes_johnston_conformal_gate=(
                    johnston_signature == expected_signature
                    and johnston_conformal_error is not None
                    and johnston_conformal_error <= maximum_conformal_error
                ),
                average_trace_johnston_direct_relative_error=(
                    average_trace_johnston_direct_error
                ),
                passes_average_trace_johnston_direct_gate=(
                    johnston_signature == expected_signature
                    and average_trace_johnston_direct_error is not None
                    and average_trace_johnston_direct_error <= maximum_trace_error
                ),
                average_trace_johnston_pulled_relative_error=(
                    average_trace_johnston_error
                ),
                passes_average_trace_johnston_gate=(
                    johnston_signature == expected_signature
                    and average_trace_johnston_error is not None
                    and average_trace_johnston_error <= maximum_trace_error
                ),
                rowwise_trace_johnston_direct_relative_error=(
                    rowwise_johnston_direct_error
                ),
                passes_rowwise_trace_johnston_direct_gate=(
                    johnston_signature == expected_signature
                    and rowwise_johnston_direct_error is not None
                    and rowwise_johnston_direct_error <= maximum_trace_error
                ),
                rowwise_trace_johnston_pulled_relative_error=(rowwise_johnston_error),
                passes_rowwise_trace_johnston_gate=(
                    johnston_signature == expected_signature
                    and rowwise_johnston_error is not None
                    and rowwise_johnston_error <= maximum_trace_error
                ),
                local_affine_fit_relative_error=fit_error,
                local_jacobian_rank=jacobian_rank,
                local_jacobian_condition=jacobian_condition,
                pivot_intrinsic_time=float(intrinsic_time[pivot_index]),
                pivot_intrinsic_radius=float(intrinsic_radius[pivot_index]),
            )
        )
    return samples


def summarize_radius(
    samples: list[FullMultirowMetricSample],
) -> dict[str, object]:
    """Summarize one full-chart radius across realizations."""

    def statistics(attribute: str) -> dict[str, float | int | None]:
        return finite_statistics([getattr(sample, attribute) for sample in samples])

    return {
        "averaging_radius": samples[0].averaging_radius,
        "samples": len(samples),
        "row_count": statistics("row_count"),
        "strict_past_target_count": statistics("strict_past_target_count"),
        "strict_future_target_count": statistics("strict_future_target_count"),
        "spacelike_target_count": statistics("spacelike_target_count"),
        "mean_recovered_time_offset": statistics("mean_recovered_time_offset"),
        "coordinate_metric_relative_error": statistics(
            "coordinate_metric_relative_error"
        ),
        "coordinate_conformal_factor": statistics("coordinate_conformal_factor"),
        "coordinate_conformal_relative_error": statistics(
            "coordinate_conformal_relative_error"
        ),
        "coordinate_conformal_gate_success_rate": sum(
            sample.passes_coordinate_conformal_gate for sample in samples
        )
        / len(samples),
        "mean_johnston_quadratic_response": statistics(
            "mean_johnston_quadratic_response"
        ),
        "average_trace_normalization_factor": statistics(
            "average_trace_normalization_factor"
        ),
        "average_trace_coordinate_relative_error": statistics(
            "average_trace_coordinate_relative_error"
        ),
        "average_trace_coordinate_gate_success_rate": sum(
            sample.passes_average_trace_coordinate_gate for sample in samples
        )
        / len(samples),
        "positive_trace_row_fraction": statistics("positive_trace_row_fraction"),
        "rowwise_trace_coordinate_relative_error": statistics(
            "rowwise_trace_coordinate_relative_error"
        ),
        "rowwise_trace_coordinate_gate_success_rate": sum(
            sample.passes_rowwise_trace_coordinate_gate for sample in samples
        )
        / len(samples),
        "centered_trace_identity_relative_error": statistics(
            "centered_trace_identity_relative_error"
        ),
        "johnston_direct_relative_error": statistics("johnston_direct_relative_error"),
        "johnston_direct_conformal_factor": statistics(
            "johnston_direct_conformal_factor"
        ),
        "johnston_direct_conformal_relative_error": statistics(
            "johnston_direct_conformal_relative_error"
        ),
        "johnston_direct_conformal_gate_success_rate": sum(
            sample.passes_johnston_direct_conformal_gate for sample in samples
        )
        / len(samples),
        "johnston_pulled_relative_error": statistics("johnston_pulled_relative_error"),
        "johnston_conformal_factor": statistics("johnston_conformal_factor"),
        "johnston_conformal_pulled_relative_error": statistics(
            "johnston_conformal_pulled_relative_error"
        ),
        "johnston_conformal_gate_success_rate": sum(
            sample.passes_johnston_conformal_gate for sample in samples
        )
        / len(samples),
        "average_trace_johnston_direct_relative_error": statistics(
            "average_trace_johnston_direct_relative_error"
        ),
        "average_trace_johnston_direct_gate_success_rate": sum(
            sample.passes_average_trace_johnston_direct_gate for sample in samples
        )
        / len(samples),
        "average_trace_johnston_pulled_relative_error": statistics(
            "average_trace_johnston_pulled_relative_error"
        ),
        "average_trace_johnston_gate_success_rate": sum(
            sample.passes_average_trace_johnston_gate for sample in samples
        )
        / len(samples),
        "rowwise_trace_johnston_direct_relative_error": statistics(
            "rowwise_trace_johnston_direct_relative_error"
        ),
        "rowwise_trace_johnston_direct_gate_success_rate": sum(
            sample.passes_rowwise_trace_johnston_direct_gate for sample in samples
        )
        / len(samples),
        "rowwise_trace_johnston_pulled_relative_error": statistics(
            "rowwise_trace_johnston_pulled_relative_error"
        ),
        "rowwise_trace_johnston_gate_success_rate": sum(
            sample.passes_rowwise_trace_johnston_gate for sample in samples
        )
        / len(samples),
        "local_affine_fit_relative_error": statistics(
            "local_affine_fit_relative_error"
        ),
        "local_jacobian_condition": statistics("local_jacobian_condition"),
    }


def summarize_grid(
    samples: list[FullMultirowMetricSample],
) -> dict[str, dict[str, object]]:
    """Group samples by full-chart radius."""

    grouped: dict[str, list[FullMultirowMetricSample]] = {}
    for sample in samples:
        grouped.setdefault(averaging_key(sample.averaging_radius), []).append(sample)
    return {key: summarize_radius(group) for key, group in sorted(grouped.items())}


def select_radius_and_estimator(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, str, dict[str, object]]:
    """Select trace estimator/radius by closed coordinate-control gates."""

    if not summaries:
        raise ValueError("at least one radius summary is required")

    candidates: list[tuple[str, str, dict[str, object]]] = []
    for key, summary in summaries.items():
        candidates.append((key, AVERAGE_TRACE, summary))
        candidates.append((key, ROWWISE_TRACE, summary))

    def statistic(summary: dict[str, object], key: str) -> float:
        values = summary[key]
        if not isinstance(values, dict):
            raise TypeError(f"{key} statistics must be a dictionary")
        median = values["median"]
        return float("inf") if median is None else float(median)

    def score(
        candidate: tuple[str, str, dict[str, object]],
    ) -> tuple[object, ...]:
        key, estimator, summary = candidate
        prefix = "average_trace" if estimator == AVERAGE_TRACE else "rowwise_trace"
        return (
            -float(summary[f"{prefix}_coordinate_gate_success_rate"]),
            -float(summary["coordinate_conformal_gate_success_rate"]),
            statistic(summary, f"{prefix}_coordinate_relative_error"),
            statistic(summary, "coordinate_conformal_relative_error"),
            float(summary["averaging_radius"]),
            0 if estimator == AVERAGE_TRACE else 1,
            key,
        )

    return min(candidates, key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run closed development or an explicitly frozen held-out gate."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    if args.events < 4 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    if args.duration <= 0.0 or args.block_size <= 0:
        raise ValueError("duration and block size must be positive")
    if args.nonlocality_scale <= 0.0 or args.support_radius <= 0.0:
        raise ValueError("operator and probe scales must be positive")
    if args.maximum_conformal_error < 0.0 or args.maximum_trace_error < 0.0:
        raise ValueError("metric-error thresholds must be nonnegative")
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
        for sample in reconstruct_full_multirow_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            args.nonlocality_scale,
            args.support_radius,
            radii,
            args.maximum_conformal_error,
            args.maximum_trace_error,
            include_johnston_metrics=args.open_johnston_metrics,
        )
    ]
    summaries = summarize_grid(samples)
    if args.frozen_estimator is None:
        selected_key, selected_estimator, selected_summary = (
            select_radius_and_estimator(summaries)
        )
        selection_status = "development selection"
    else:
        if len(radii) != 1:
            raise ValueError("held-out mode requires one frozen radius")
        selected_key = averaging_key(radii[0])
        selected_estimator = args.frozen_estimator
        selected_summary = summaries[selected_key]
        selection_status = "frozen held-out evaluation"
    result: dict[str, object] = {
        "status": selection_status,
        "row_selection_uses_embedding_coordinates": False,
        "row_selection_uses_full_recovered_chart": True,
        "coordinate_control_scores_use_embedding_coordinates": True,
        "johnston_metric_scores_opened": args.open_johnston_metrics,
        "johnston_quadratic_constructed": True,
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
            "maximum_conformal_error": args.maximum_conformal_error,
            "maximum_trace_error": args.maximum_trace_error,
            "seed": args.seed,
        },
        "selection_rule": (
            "maximum estimator-specific trace gate rate, then maximum "
            "conformal-shape gate rate, then minimum median trace and "
            "conformal errors"
        ),
        "selected_averaging_key": selected_key,
        "selected_estimator": selected_estimator,
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
        default=[0.0, 0.04, 0.05, 0.06, 0.075, 0.09, 0.10],
    )
    parser.add_argument("--maximum-conformal-error", type=float, default=0.50)
    parser.add_argument("--maximum-trace-error", type=float, default=0.50)
    parser.add_argument("--seed", type=int, default=20260731)
    parser.add_argument("--open-johnston-metrics", action="store_true")
    parser.add_argument(
        "--frozen-estimator",
        choices=(AVERAGE_TRACE, ROWWISE_TRACE),
    )
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
