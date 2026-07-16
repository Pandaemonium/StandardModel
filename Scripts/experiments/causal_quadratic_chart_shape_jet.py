"""Stage A33 nonlinear-chart controls for the aggregate metric shape jet.

A32 kills nonlinear normalization of individual rows.  The remaining route is
to regularize the first derivative around the stable aggregate A29 tensor.  A
flat zero-jet control alone would make shrinking every derivative to zero look
successful, so A33 introduces exact nonzero controls by changing coordinates
on flat spacetime.

For pivot-centered coordinates ``u`` define

    y^a = u^a + 1/2 Q^a_{mn} u^m u^n,

with ``Q`` symmetric in its lower indices.  The Jacobian is the identity at the
pivot, while the contravariant metric has the exact first jet

    partial_l g_y = Q_l eta + eta Q_l^T.

The corresponding unit-volume shape jet is obtained by the same determinant
projection used in the estimator.  Development selects one scalar tangent
weight on zero, temporal, and shear chart controls at two densities.  No
curved spacetime target participates in selection.

Coordinates, density, dimension, probes, support, and the A29 response weight
remain supplied.  This is a chart-covariance and derivative-resolution audit,
not a bare-graph metric theorem.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_conformal_multirow_metric import (
    append_interior_pivot,
    fit_affine_metric_field,
    fit_affine_vector_field,
    refinement_scales,
    retarded_probe_moment,
    select_local_targets,
    select_spread_local_targets,
)
from causal_conformal_operator_metric import sprinkle_conformal_de_sitter_diamond
from causal_fused_operator_count_metric import fuse_metric_and_first_jet
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_probe_metric import selected_open_interval_counts
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    corrected_gamma,
    diamond_volume_4d,
    finite_statistics,
    matrix_relative_error,
    project_convention_row,
    signature,
    smeared_bd_row,
    smooth_compact_cutoff,
)
from causal_retarded_moment_debiased_metric import (
    retarded_time_response_correction_with_jet,
)


@dataclass(frozen=True)
class QuadraticChartControl:
    name: str
    coefficients: np.ndarray


@dataclass(frozen=True)
class QuadraticChartShapeSample:
    events: int
    duration: float
    chart_name: str
    row_count: int
    design_rank: int
    design_condition: float
    metric_signature: tuple[int, int, int]
    shape: list[list[float]]
    target_shape: list[list[float]]
    shape_relative_error: float
    shape_first_jet: list[list[list[float]]]
    target_shape_first_jet: list[list[list[float]]]
    raw_shape_first_jet_dimensionless_error: float


def quadratic_chart_controls() -> list[QuadraticChartControl]:
    zero = np.zeros((4, 4, 4))
    temporal = np.zeros((4, 4, 4))
    temporal[0, 0, 0] = 0.8
    shear = np.zeros((4, 4, 4))
    shear[0, 1, 1] = 1.5
    return [
        QuadraticChartControl("zero", zero),
        QuadraticChartControl("temporal", temporal),
        QuadraticChartControl("shear", shear),
    ]


def validate_quadratic_coefficients(coefficients: np.ndarray) -> None:
    if coefficients.shape != (4, 4, 4):
        raise ValueError("quadratic coefficients must have shape (4,4,4)")
    if not np.allclose(coefficients, np.swapaxes(coefficients, 1, 2)):
        raise ValueError("the two lower chart indices must be symmetric")


def quadratic_chart_coordinates(
    points: np.ndarray,
    pivot: np.ndarray,
    coefficients: np.ndarray,
) -> np.ndarray:
    """Map embedding points to pivot-centered quadratic coordinates."""

    validate_quadratic_coefficients(coefficients)
    if points.ndim != 2 or points.shape[1] != 4 or pivot.shape != (4,):
        raise ValueError("require points of shape (n,4) and one pivot")
    centered = points - pivot
    quadratic = 0.5 * np.einsum(
        "amn,im,in->ia", coefficients, centered, centered
    )
    return centered + quadratic


def quadratic_chart_jacobian(
    point: np.ndarray,
    pivot: np.ndarray,
    coefficients: np.ndarray,
) -> np.ndarray:
    validate_quadratic_coefficients(coefficients)
    centered = point - pivot
    return np.eye(4) + np.einsum("amn,n->am", coefficients, centered)


def quadratic_chart_target_metric_first_jet(
    coefficients: np.ndarray,
) -> np.ndarray:
    """Exact ``partial/y`` metric jet at the identity-Jacobian pivot."""

    validate_quadratic_coefficients(coefficients)
    jet = np.empty((4, 4, 4))
    for derivative in range(4):
        jacobian_derivative = coefficients[:, :, derivative]
        jet[derivative] = (
            jacobian_derivative @ MINKOWSKI_INVERSE
            + MINKOWSKI_INVERSE @ jacobian_derivative.T
        )
    return jet


def quadratic_chart_target_factor_gradient(
    coefficients: np.ndarray,
) -> np.ndarray:
    """Exact determinant-normalization factor jet at the chart pivot."""

    metric_jet = quadratic_chart_target_metric_first_jet(coefficients)
    return np.array(
        [
            0.25 * np.trace(MINKOWSKI_INVERSE @ metric_jet[derivative])
            for derivative in range(4)
        ]
    )


def quadratic_chart_target_connection(coefficients: np.ndarray) -> np.ndarray:
    """Exact ``Gamma^a_bc`` at the pivot of the flat quadratic chart."""

    validate_quadratic_coefficients(coefficients)
    return -np.array(coefficients, dtype=float)


def target_unit_shape_jet(coefficients: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    metric_jet = quadratic_chart_target_metric_first_jet(coefficients)
    shape, shape_jet, _, _ = fuse_metric_and_first_jet(
        MINKOWSKI_INVERSE,
        metric_jet,
        1.0,
        np.zeros(4),
    )
    return shape, shape_jet


def chart_compact_probes(
    points: np.ndarray,
    mapped_points: np.ndarray,
    target_index: int,
    support_radius: float,
) -> np.ndarray:
    """Compact mapped-coordinate probes with support measured in the base chart."""

    centered = points - points[target_index]
    cutoff = smooth_compact_cutoff(np.linalg.norm(centered, axis=1), support_radius)
    mapped_centered = mapped_points - mapped_points[target_index]
    return mapped_centered * cutoff[:, None]


def reconstruct_chart_control_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    controls: list[QuadraticChartControl],
    temporal_response_weight: float,
    nonlocality_multiplier: float,
    support_multiplier: float,
    averaging_multiplier: float,
    maximum_rows: int,
    block_size: int,
    pivot_fraction: float,
    target_selection: str = "nearest",
) -> list[QuadraticChartShapeSample]:
    """Evaluate all chart controls on one shared flat sprinkling and row set."""

    points, top_index = sprinkle_conformal_de_sitter_diamond(
        rng, events, duration, 0.0
    )
    points, pivot_index, _ = append_interior_pivot(
        points, top_index, duration, pivot_fraction
    )
    relation = causal_relation_matrix(points, block_size)
    ell = (diamond_volume_4d(duration) / events) ** 0.25
    scales = refinement_scales(
        ell,
        duration,
        nonlocality_multiplier,
        support_multiplier,
        averaging_multiplier,
    )
    if target_selection == "nearest":
        targets = select_local_targets(
            points,
            pivot_index,
            scales.averaging_radius,
            maximum_rows,
        )
    elif target_selection == "spread":
        targets = select_spread_local_targets(
            points,
            pivot_index,
            scales.averaging_radius,
            maximum_rows,
        )
    else:
        raise ValueError("target selection must be 'nearest' or 'spread'")
    open_counts = selected_open_interval_counts(
        relation, np.arange(len(relation)), targets
    )
    rows: list[np.ndarray] = []
    for column, target in enumerate(targets):
        target_index = int(target)
        rows.append(
            project_convention_row(
                smeared_bd_row(
                    relation[:, target_index],
                    open_counts[:, column],
                    target_index,
                    ell,
                    scales.nonlocality_scale,
                )
            )
        )

    samples: list[QuadraticChartShapeSample] = []
    pivot = points[pivot_index]
    for control in controls:
        mapped = quadratic_chart_coordinates(points, pivot, control.coefficients)
        pairings: list[np.ndarray] = []
        moments: list[np.ndarray] = []
        for target, row in zip(targets, rows, strict=True):
            target_index = int(target)
            probes = chart_compact_probes(
                points,
                mapped,
                target_index,
                scales.support_radius,
            )
            pairings.append(corrected_gamma(row, probes, target_index))
            moments.append(retarded_probe_moment(row, probes, target_index))
        pairings_array = np.array(pairings)
        moments_array = np.array(moments)
        metric, metric_jet, rank, condition = fit_affine_metric_field(
            mapped,
            pivot_index,
            targets,
            pairings_array,
        )
        moment, moment_jet = fit_affine_vector_field(
            mapped,
            pivot_index,
            targets,
            moments_array,
        )
        corrected_metric, corrected_jet, _ = (
            retarded_time_response_correction_with_jet(
                metric,
                metric_jet,
                moment,
                moment_jet,
                temporal_response_weight,
            )
        )
        shape, shape_jet, _, _ = fuse_metric_and_first_jet(
            corrected_metric,
            corrected_jet,
            1.0,
            np.zeros(4),
        )
        target_shape, target_shape_jet = target_unit_shape_jet(
            control.coefficients
        )
        samples.append(
            QuadraticChartShapeSample(
                events=events,
                duration=duration,
                chart_name=control.name,
                row_count=len(targets),
                design_rank=rank,
                design_condition=condition,
                metric_signature=signature(corrected_metric),
                shape=shape.tolist(),
                target_shape=target_shape.tolist(),
                shape_relative_error=matrix_relative_error(shape, target_shape),
                shape_first_jet=shape_jet.tolist(),
                target_shape_first_jet=target_shape_jet.tolist(),
                raw_shape_first_jet_dimensionless_error=float(
                    duration
                    * np.linalg.norm(shape_jet - target_shape_jet)
                    / np.linalg.norm(target_shape)
                ),
            )
        )
    return samples


def tangent_weight_scores(
    samples: list[QuadraticChartShapeSample],
    weights: list[float],
) -> dict[str, dict[str, object]]:
    if not samples or not weights or any(weight < 0.0 for weight in weights):
        raise ValueError("samples and nonnegative weights are required")
    scores: dict[str, dict[str, object]] = {}
    cells = sorted({(sample.events, sample.chart_name) for sample in samples})
    for weight in sorted(set(weights)):
        cell_summaries: dict[str, dict[str, float]] = {}
        all_errors: list[float] = []
        for events, chart_name in cells:
            matching = [
                sample
                for sample in samples
                if sample.events == events and sample.chart_name == chart_name
            ]
            estimates = np.array([sample.shape_first_jet for sample in matching])
            target = np.array(matching[0].target_shape_first_jet)
            target_shape = np.array(matching[0].target_shape)
            denominator = max(float(np.linalg.norm(target)), np.linalg.norm(target_shape))
            errors = [
                matching[0].duration
                * float(np.linalg.norm(weight * estimate - target) / denominator)
                for estimate in estimates
            ]
            all_errors.extend(errors)
            cell_summaries[f"N={events}|chart={chart_name}"] = {
                "median_normalized_error": float(np.median(errors)),
                "maximum_normalized_error": float(np.max(errors)),
                "ensemble_normalized_error": float(
                    matching[0].duration
                    * np.linalg.norm(weight * np.mean(estimates, axis=0) - target)
                    / denominator
                ),
            }
        scores[f"w={weight:.6f}"] = {
            "weight": weight,
            "error": finite_statistics(all_errors),
            "worst_cell_median_normalized_error": max(
                cell["median_normalized_error"] for cell in cell_summaries.values()
            ),
            "worst_cell_ensemble_normalized_error": max(
                cell["ensemble_normalized_error"] for cell in cell_summaries.values()
            ),
            "cells": cell_summaries,
        }
    return scores


def select_tangent_weight(scores: dict[str, dict[str, object]]) -> float:
    def score(item: tuple[str, dict[str, object]]) -> tuple[float, ...]:
        summary = item[1]
        errors = summary["error"]
        assert isinstance(errors, dict)
        return (
            float(summary["worst_cell_median_normalized_error"]),
            float(summary["worst_cell_ensemble_normalized_error"]),
            float(errors["median"]),
            -float(summary["weight"]),
        )

    return float(min(scores.items(), key=score)[1]["weight"])


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if len(set(args.events_values)) < 2:
        raise ValueError("A33 requires at least two development densities")
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    controls = quadratic_chart_controls()
    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(args.events_values) * args.realizations
    )
    samples: list[QuadraticChartShapeSample] = []
    index = 0
    for events in sorted(set(args.events_values)):
        maximum_rows = max(
            5, int(round(args.maximum_rows_factor * np.sqrt(events)))
        )
        for _ in range(args.realizations):
            samples.extend(
                reconstruct_chart_control_realization(
                    np.random.default_rng(child_seeds[index]),
                    events,
                    args.duration,
                    controls,
                    args.temporal_response_weight,
                    args.operator_nonlocality_multiplier,
                    args.operator_support_multiplier,
                    args.operator_averaging_multiplier,
                    maximum_rows,
                    args.block_size,
                    args.pivot_fraction,
                )
            )
            index += 1
    scores = tangent_weight_scores(samples, args.tangent_weights)
    selected = select_tangent_weight(scores)
    result: dict[str, object] = {
        "status": "flat nonlinear-chart shape-jet calibration; not connection",
        "stage": "A33",
        "mode": "development",
        "claim_boundary": {
            "all_backgrounds_are_flat": True,
            "zero_and_nonzero_exact_shape_jets_are_used": True,
            "two_density_selection_is_required": True,
            "curved_targets_are_not_used": True,
            "quadratic_charts_and_embedding_probes_are_supplied": True,
        },
        "selected_tangent_weight": selected,
        "candidate_scores": scores,
        "controls": {
            control.name: control.coefficients.tolist() for control in controls
        },
        "settings": {
            "events_values": sorted(set(args.events_values)),
            "realizations_per_density": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "temporal_response_weight": args.temporal_response_weight,
            "operator_nonlocality_multiplier": (
                args.operator_nonlocality_multiplier
            ),
            "operator_support_multiplier": args.operator_support_multiplier,
            "operator_averaging_multiplier": args.operator_averaging_multiplier,
            "maximum_rows_factor": args.maximum_rows_factor,
            "seed": args.seed,
        },
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events-values", type=int, nargs="+", default=[4000, 8000])
    parser.add_argument("--realizations", type=int, default=6)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--pivot-fraction", type=float, default=0.7)
    parser.add_argument("--temporal-response-weight", type=float, default=0.6)
    parser.add_argument("--operator-nonlocality-multiplier", type=float, default=0.75)
    parser.add_argument("--operator-support-multiplier", type=float, default=1.8)
    parser.add_argument("--operator-averaging-multiplier", type=float, default=1.1)
    parser.add_argument("--maximum-rows-factor", type=float, default=2.9)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument(
        "--tangent-weights",
        type=float,
        nargs="+",
        default=[0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.8, 1.0],
    )
    parser.add_argument("--seed", type=int, default=20261330)
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
