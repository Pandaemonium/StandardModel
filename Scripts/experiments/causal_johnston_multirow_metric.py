"""Common-chart multi-row causal-operator metric averaging.

This Stage A8 experiment tests whether local averaging suppresses the large
anisotropic fluctuations seen in one Benincasa-Dowker operator row.  A supplied
four-dimensional density and interval endpoints produce a Johnston lightcone
chart about an order-selected pivot.  Nearby target rows are then selected only
from the strict order, the recovered chart radius, and the chart carrier.  All
selected rows act on one common compact probe chart before their metric
pairings are averaged.

The development mode scores only compact oracle-coordinate controls.  It does
construct the independently validated Johnston quadratic in order to test the
centered trace identity and, after the scale-free conformal-shape gate, to set
the averaged trace.  Johnston metric scores are opened only when explicitly
requested for a fresh held-out run.  Dimension, density, endpoints, and spatial
rank remain supplied, so this is an external numerical oracle rather than a
bare-graph reconstruction or proof.
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
from causal_johnston_operator_control_scan import optimal_positive_rescaling
from causal_johnston_probe_metric import (
    causal_interval_points,
    choose_intrinsic_pivot,
    compact_lightcone_probes,
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding_from_relation,
    lorentzian_quadratic_probe,
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


@dataclass(frozen=True)
class MultirowMetricSample:
    averaging_radius: float
    row_count: int
    coordinate_pairing: list[list[float]]
    coordinate_signature: tuple[int, int, int]
    coordinate_metric_relative_error: float
    coordinate_conformal_factor: float | None
    coordinate_conformal_relative_error: float | None
    passes_coordinate_conformal_gate: bool
    mean_johnston_quadratic_response: float
    trace_normalization_factor: float | None
    centered_trace_identity_relative_error: float
    trace_normalized_coordinate_pairing: list[list[float]] | None
    trace_normalized_coordinate_signature: tuple[int, int, int] | None
    trace_normalized_coordinate_relative_error: float | None
    passes_trace_normalized_coordinate_gate: bool
    johnston_pairing: list[list[float]] | None
    johnston_signature: tuple[int, int, int] | None
    johnston_direct_relative_error: float | None
    johnston_pulled_relative_error: float | None
    johnston_conformal_factor: float | None
    johnston_conformal_pulled_relative_error: float | None
    passes_johnston_conformal_gate: bool
    trace_normalized_johnston_direct_relative_error: float | None
    trace_normalized_johnston_pulled_relative_error: float | None
    passes_trace_normalized_johnston_gate: bool
    local_affine_fit_relative_error: float | None
    local_jacobian_rank: int | None
    local_jacobian_condition: float | None
    pivot_intrinsic_time: float
    pivot_intrinsic_radius: float
    pivot_past_count: int
    pivot_future_count: int


def averaging_key(radius: float) -> str:
    """Stable JSON key for one averaging radius."""

    return f"radius={radius:.6f}"


def averaging_targets(
    relation: np.ndarray,
    pivot_index: int,
    recovered_radius: np.ndarray,
    embedded_mask: np.ndarray,
    averaging_radius: float,
) -> np.ndarray:
    """Select all chart-visible strict-past targets within one radius."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if recovered_radius.shape != (len(relation),):
        raise ValueError("recovered radii must match the relation")
    if embedded_mask.shape != (len(relation),):
        raise ValueError("embedded mask must match the relation")
    if not 0 <= pivot_index < len(relation):
        raise IndexError("pivot index is outside the relation")
    if averaging_radius < 0.0:
        raise ValueError("averaging radius must be nonnegative")

    selected = (
        relation[:, pivot_index]
        & embedded_mask
        & (recovered_radius <= averaging_radius)
    )
    selected = selected.copy()
    selected[pivot_index] = True
    return np.flatnonzero(selected)


def centered_lorentzian_quadratic(probes: np.ndarray, target_index: int) -> np.ndarray:
    """Lorentzian quadratic of common probes centered at one target."""

    if not 0 <= target_index < len(probes):
        raise IndexError("target index is outside the probe carrier")
    return lorentzian_quadratic_probe(probes - probes[target_index])


def centered_trace_identity_relative_error(
    response: float,
    pairing: np.ndarray,
) -> float:
    """Relative residual in B(q_y) = 2 eta_ab Gamma_y(P^a,P^b)."""

    expected = 2.0 * float(np.sum(MINKOWSKI_INVERSE * pairing))
    scale = max(1.0, abs(response), abs(expected))
    return abs(response - expected) / scale


def _operator_row(
    relation: np.ndarray,
    target_index: int,
    ell: float,
    nonlocality_scale: float,
) -> np.ndarray:
    """Build one project-sign operator row and its selected counts."""

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


def _optional_error(matrix: np.ndarray | None) -> float | None:
    if matrix is None:
        return None
    return matrix_relative_error(matrix, MINKOWSKI_INVERSE)


def reconstruct_multirow_realization(
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
) -> list[MultirowMetricSample]:
    """Average all common-chart rows for every frozen averaging radius."""

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
    embedding = johnston_lightcone_embedding_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        pivot_index,
        duration,
        spatial_rank=dimension - 1,
    )
    johnston_probes = compact_lightcone_probes(embedding, support_radius)
    coordinate_probes = compact_coordinate_probes(points, pivot_index, support_radius)
    recovered_radius = np.linalg.norm(embedding.probes, axis=1)
    targets_by_radius = {
        radius: averaging_targets(
            relation,
            pivot_index,
            recovered_radius,
            embedding.embedded_mask,
            radius,
        )
        for radius in averaging_radii
    }
    all_targets = np.unique(np.concatenate(list(targets_by_radius.values())))

    coordinate_pairings: dict[int, np.ndarray] = {}
    johnston_pairings: dict[int, np.ndarray] = {}
    quadratic_responses: dict[int, float] = {}
    identity_errors: dict[int, float] = {}
    for target_index in all_targets:
        target = int(target_index)
        row = _operator_row(relation, target, ell, nonlocality_scale)
        coordinate_pairing = corrected_gamma(row, coordinate_probes, target)
        johnston_pairing = corrected_gamma(row, johnston_probes, target)
        quadratic = centered_lorentzian_quadratic(johnston_probes, target)
        response = float(row @ quadratic)
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
        inner_mask = embedding.embedded_mask & (recovered_radius <= nonlocality_scale)
        if np.count_nonzero(inner_mask) < max(dimension + 1, 6):
            inner_mask = embedding.embedded_mask
        (
            jacobian,
            fit_error,
            jacobian_rank,
            jacobian_condition,
        ) = local_affine_jacobian(points, pivot_index, johnston_probes, inner_mask)

    expected_signature = (1, dimension - 1, 0)
    samples: list[MultirowMetricSample] = []
    for radius in averaging_radii:
        targets = targets_by_radius[radius]
        coordinate_average = np.mean(
            [coordinate_pairings[int(target)] for target in targets], axis=0
        )
        johnston_average = np.mean(
            [johnston_pairings[int(target)] for target in targets], axis=0
        )
        coordinate_signature = signature(coordinate_average)
        coordinate_factor, coordinate_conformal_error = optimal_positive_rescaling(
            coordinate_average
        )
        mean_response = float(
            np.mean([quadratic_responses[int(target)] for target in targets])
        )
        trace_factor = (
            None
            if not np.isfinite(mean_response) or mean_response <= 1.0e-12
            else 2.0 * dimension / mean_response
        )
        trace_coordinate = (
            None if trace_factor is None else trace_factor * coordinate_average
        )
        trace_coordinate_signature = (
            None if trace_coordinate is None else signature(trace_coordinate)
        )
        trace_coordinate_error = _optional_error(trace_coordinate)

        opened_johnston = johnston_average if include_johnston_metrics else None
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
        trace_johnston = (
            None
            if opened_johnston is None or trace_factor is None
            else trace_factor * opened_johnston
        )
        trace_pulled_johnston = (
            None
            if trace_johnston is None or jacobian is None
            else coordinate_pulled_metric(trace_johnston, jacobian)
        )
        johnston_signature = (
            None if opened_johnston is None else signature(opened_johnston)
        )
        samples.append(
            MultirowMetricSample(
                averaging_radius=radius,
                row_count=len(targets),
                coordinate_pairing=coordinate_average.tolist(),
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
                centered_trace_identity_relative_error=max(
                    identity_errors[int(target)] for target in targets
                ),
                trace_normalized_coordinate_pairing=(
                    None if trace_coordinate is None else trace_coordinate.tolist()
                ),
                trace_normalized_coordinate_signature=(trace_coordinate_signature),
                trace_normalized_coordinate_relative_error=(trace_coordinate_error),
                passes_trace_normalized_coordinate_gate=(
                    trace_coordinate_signature == expected_signature
                    and trace_coordinate_error is not None
                    and trace_coordinate_error <= maximum_trace_error
                ),
                johnston_pairing=(
                    None if opened_johnston is None else opened_johnston.tolist()
                ),
                johnston_signature=johnston_signature,
                johnston_direct_relative_error=(_optional_error(opened_johnston)),
                johnston_pulled_relative_error=(_optional_error(pulled_johnston)),
                johnston_conformal_factor=johnston_factor,
                johnston_conformal_pulled_relative_error=(johnston_conformal_error),
                passes_johnston_conformal_gate=(
                    johnston_signature == expected_signature
                    and johnston_conformal_error is not None
                    and johnston_conformal_error <= maximum_conformal_error
                ),
                trace_normalized_johnston_direct_relative_error=(
                    _optional_error(trace_johnston)
                ),
                trace_normalized_johnston_pulled_relative_error=(
                    _optional_error(trace_pulled_johnston)
                ),
                passes_trace_normalized_johnston_gate=(
                    johnston_signature == expected_signature
                    and trace_pulled_johnston is not None
                    and matrix_relative_error(trace_pulled_johnston, MINKOWSKI_INVERSE)
                    <= maximum_trace_error
                ),
                local_affine_fit_relative_error=fit_error,
                local_jacobian_rank=jacobian_rank,
                local_jacobian_condition=jacobian_condition,
                pivot_intrinsic_time=float(intrinsic_time[pivot_index]),
                pivot_intrinsic_radius=float(intrinsic_radius[pivot_index]),
                pivot_past_count=int(np.count_nonzero(relation[:, pivot_index])),
                pivot_future_count=int(np.count_nonzero(relation[pivot_index, :])),
            )
        )
    return samples


def summarize_radius(samples: list[MultirowMetricSample]) -> dict[str, object]:
    """Summarize one common averaging radius across realizations."""

    return {
        "averaging_radius": samples[0].averaging_radius,
        "samples": len(samples),
        "row_count": finite_statistics([float(sample.row_count) for sample in samples]),
        "coordinate_metric_relative_error": finite_statistics(
            [sample.coordinate_metric_relative_error for sample in samples]
        ),
        "coordinate_conformal_factor": finite_statistics(
            [sample.coordinate_conformal_factor for sample in samples]
        ),
        "coordinate_conformal_relative_error": finite_statistics(
            [sample.coordinate_conformal_relative_error for sample in samples]
        ),
        "coordinate_conformal_gate_success_rate": (
            sum(sample.passes_coordinate_conformal_gate for sample in samples)
            / len(samples)
        ),
        "mean_johnston_quadratic_response": finite_statistics(
            [sample.mean_johnston_quadratic_response for sample in samples]
        ),
        "trace_normalization_factor": finite_statistics(
            [sample.trace_normalization_factor for sample in samples]
        ),
        "centered_trace_identity_relative_error": finite_statistics(
            [sample.centered_trace_identity_relative_error for sample in samples]
        ),
        "trace_normalized_coordinate_relative_error": finite_statistics(
            [sample.trace_normalized_coordinate_relative_error for sample in samples]
        ),
        "trace_normalized_coordinate_gate_success_rate": (
            sum(sample.passes_trace_normalized_coordinate_gate for sample in samples)
            / len(samples)
        ),
        "johnston_direct_relative_error": finite_statistics(
            [sample.johnston_direct_relative_error for sample in samples]
        ),
        "johnston_pulled_relative_error": finite_statistics(
            [sample.johnston_pulled_relative_error for sample in samples]
        ),
        "johnston_conformal_factor": finite_statistics(
            [sample.johnston_conformal_factor for sample in samples]
        ),
        "johnston_conformal_pulled_relative_error": finite_statistics(
            [sample.johnston_conformal_pulled_relative_error for sample in samples]
        ),
        "johnston_conformal_gate_success_rate": (
            sum(sample.passes_johnston_conformal_gate for sample in samples)
            / len(samples)
        ),
        "trace_normalized_johnston_direct_relative_error": finite_statistics(
            [
                sample.trace_normalized_johnston_direct_relative_error
                for sample in samples
            ]
        ),
        "trace_normalized_johnston_pulled_relative_error": finite_statistics(
            [
                sample.trace_normalized_johnston_pulled_relative_error
                for sample in samples
            ]
        ),
        "trace_normalized_johnston_gate_success_rate": (
            sum(sample.passes_trace_normalized_johnston_gate for sample in samples)
            / len(samples)
        ),
        "local_affine_fit_relative_error": finite_statistics(
            [sample.local_affine_fit_relative_error for sample in samples]
        ),
        "local_jacobian_condition": finite_statistics(
            [sample.local_jacobian_condition for sample in samples]
        ),
    }


def summarize_grid(
    samples: list[MultirowMetricSample],
) -> dict[str, dict[str, object]]:
    """Group common-radius samples and summarize each group."""

    grouped: dict[str, list[MultirowMetricSample]] = {}
    for sample in samples:
        grouped.setdefault(averaging_key(sample.averaging_radius), []).append(sample)
    return {key: summarize_radius(group) for key, group in sorted(grouped.items())}


def select_averaging_radius(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select trace gate, conformal gate, then their median errors."""

    if not summaries:
        raise ValueError("at least one averaging summary is required")

    def median(summary: dict[str, object], key: str) -> float:
        statistics = summary[key]
        if not isinstance(statistics, dict):
            raise TypeError(f"{key} statistics must be a dictionary")
        value = statistics["median"]
        return float("inf") if value is None else float(value)

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        return (
            -float(summary["trace_normalized_coordinate_gate_success_rate"]),
            -float(summary["coordinate_conformal_gate_success_rate"]),
            median(summary, "trace_normalized_coordinate_relative_error"),
            median(summary, "coordinate_conformal_relative_error"),
            float(summary["averaging_radius"]),
            key,
        )

    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run a development selection or an explicitly opened held-out gate."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    if args.events < 3 or args.realizations <= 0:
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
        for sample in reconstruct_multirow_realization(
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
    selected_key, selected_summary = select_averaging_radius(summaries)
    result: dict[str, object] = {
        "status": (
            "held-out Johnston metric gate"
            if args.open_johnston_metrics
            else "coordinate-control development selection"
        ),
        "row_selection_uses_embedding_coordinates": False,
        "row_selection_uses_recovered_chart_radius": True,
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
            "maximum trace-normalized coordinate gate rate, then maximum "
            "coordinate conformal-shape gate rate, then minimum median "
            "trace-normalized and conformal-shape errors"
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
    parser.add_argument("--events", type=int, default=10000)
    parser.add_argument("--realizations", type=int, default=10)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--nonlocality-scale", type=float, default=0.18)
    parser.add_argument("--support-radius", type=float, default=0.65)
    parser.add_argument(
        "--averaging-radii",
        type=float,
        nargs="+",
        default=[0.0, 0.125, 0.15, 0.175, 0.20],
    )
    parser.add_argument("--maximum-conformal-error", type=float, default=0.50)
    parser.add_argument("--maximum-trace-error", type=float, default=0.50)
    parser.add_argument("--seed", type=int, default=20260727)
    parser.add_argument("--open-johnston-metrics", action="store_true")
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
