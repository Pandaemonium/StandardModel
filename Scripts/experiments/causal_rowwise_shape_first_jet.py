"""Stage A32 rowwise response correction before shape-jet regression.

A31 shows that the fused first-jet error survives even an oracle scale
gradient.  The remaining suspect is the derivative of the unit-volume
operator shape.  The predecessor pipeline first fits noisy raw metric and
moment fields and only then applies the nonlinear retarded correction and
determinant normalization.  A32 reverses those operations: each admissible
local row is corrected and normalized first, and the affine shape field is fit
only afterward.

No new selector is introduced.  The response weight, operator schedule, count
schedule, and Poisson gradient penalty are frozen by A28-A31.  The rowwise
admissibility test is affine invariant: the raw pairing must be Lorentzian and
the retarded moment timelike.  Coordinates, density, dimension, probes, and
windows remain supplied, so this is a conditional shape-jet audit rather than
a bare-graph connection reconstruction.
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
    target_inverse_metric_at,
    target_inverse_metric_first_jet,
)
from causal_conformal_operator_metric import (
    conformal_diamond_volume,
    de_sitter_conformal_scale,
    sprinkle_conformal_de_sitter_diamond,
    validate_background,
)
from causal_fused_operator_count_metric import fuse_metric_and_first_jet
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_probe_metric import selected_open_interval_counts
from causal_operator_metric import (
    compact_coordinate_probes,
    corrected_gamma,
    finite_statistics,
    matrix_relative_error,
    project_convention_row,
    signature,
    smeared_bd_row,
    volume_density_from_inverse_metric,
)
from causal_poisson_scale_gradient import reconstruct_count_gradient_estimate
from causal_retarded_moment_debiased_metric import (
    retarded_time_response_correction,
    retarded_time_response_correction_with_jet,
)
from causal_shape_selected_fused_metric import unit_volume_shape


@dataclass(frozen=True)
class RowwiseShapeFirstJetSample:
    hubble: float
    duration: float
    temporal_response_weight: float
    gradient_penalty: float
    total_row_count: int
    admissible_row_count: int
    admissible_row_fraction: float
    rowwise_design_rank: int
    rowwise_design_condition: float
    postfit_shape: list[list[float]]
    rowwise_shape: list[list[float]]
    target_shape: list[list[float]]
    postfit_shape_relative_error: float
    rowwise_shape_relative_error: float
    postfit_shape_first_jet_dimensionless_error: float
    rowwise_shape_first_jet_dimensionless_error: float
    postfit_shape_spatial_jet_dimensionless_noise: float
    rowwise_shape_spatial_jet_dimensionless_noise: float
    rowwise_shape_first_jet: list[list[list[float]]]
    target_shape_first_jet: list[list[list[float]]]
    fused_metric: list[list[float]]
    target_metric: list[list[float]]
    fused_metric_relative_error: float
    fused_signature: tuple[int, int, int]
    fused_oracle_volume_relative_error: float | None
    fused_count_volume_relative_mismatch: float | None
    fused_first_jet: list[list[list[float]]]
    target_first_jet: list[list[list[float]]]
    fused_first_jet_dimensionless_error: float
    fused_temporal_first_jet_relative_error: float | None
    fused_spatial_first_jet_dimensionless_noise: float


def corrected_unit_volume_shapes(
    pairings: np.ndarray,
    moments: np.ndarray,
    temporal_response_weight: float,
) -> tuple[np.ndarray, np.ndarray]:
    """Correct and normalize each admissible row independently."""

    if pairings.ndim != 3 or pairings.shape[1:] != (4, 4):
        raise ValueError("pairings must have shape (n,4,4)")
    if moments.shape != (len(pairings), 4):
        raise ValueError("moments must have shape (n,4)")
    shapes: list[np.ndarray] = []
    retained: list[int] = []
    for index, (metric, moment) in enumerate(zip(pairings, moments, strict=True)):
        try:
            corrected, _ = retarded_time_response_correction(
                metric, moment, temporal_response_weight
            )
            shape = unit_volume_shape(corrected)
        except (ValueError, np.linalg.LinAlgError):
            continue
        if np.all(np.isfinite(shape)):
            shapes.append(shape)
            retained.append(index)
    if not shapes:
        return np.empty((0, 4, 4)), np.empty(0, dtype=int)
    return np.array(shapes), np.array(retained, dtype=int)


def reconstruct_row_observations(
    rng: np.random.Generator,
    events: int,
    duration: float,
    hubble: float,
    nonlocality_multiplier: float,
    support_multiplier: float,
    averaging_multiplier: float,
    maximum_rows: int,
    block_size: int,
    pivot_fraction: float,
    target_selection: str = "nearest",
) -> tuple[np.ndarray, int, np.ndarray, np.ndarray, np.ndarray]:
    """Build the selected local operator rows once for both A30 and A32 fits."""

    points, top_index = sprinkle_conformal_de_sitter_diamond(
        rng, events, duration, hubble
    )
    points, pivot_index, _ = append_interior_pivot(
        points, top_index, duration, pivot_fraction
    )
    relation = causal_relation_matrix(points, block_size)
    physical_volume = conformal_diamond_volume(duration, hubble)
    ell = (physical_volume / events) ** 0.25
    pivot_scale = float(
        de_sitter_conformal_scale(pivot_fraction * duration, hubble)
    )
    scales = refinement_scales(
        ell,
        duration,
        nonlocality_multiplier,
        support_multiplier,
        averaging_multiplier,
    )
    coordinate_radius = scales.averaging_radius / pivot_scale
    if target_selection == "nearest":
        targets = select_local_targets(
            points,
            pivot_index,
            coordinate_radius,
            maximum_rows,
        )
    elif target_selection == "spread":
        targets = select_spread_local_targets(
            points,
            pivot_index,
            coordinate_radius,
            maximum_rows,
        )
    else:
        raise ValueError("target selection must be 'nearest' or 'spread'")
    open_counts = selected_open_interval_counts(
        relation, np.arange(len(relation)), targets
    )
    pairings: list[np.ndarray] = []
    moments: list[np.ndarray] = []
    for column, target in enumerate(targets):
        target_index = int(target)
        target_scale = float(
            de_sitter_conformal_scale(points[target_index, 0], hubble)
        )
        probes = compact_coordinate_probes(
            points, target_index, scales.support_radius / target_scale
        )
        row = project_convention_row(
            smeared_bd_row(
                relation[:, target_index],
                open_counts[:, column],
                target_index,
                ell,
                scales.nonlocality_scale,
            )
        )
        pairings.append(corrected_gamma(row, probes, target_index))
        moments.append(retarded_probe_moment(row, probes, target_index))
    return points, pivot_index, targets, np.array(pairings), np.array(moments)


def reconstruct_rowwise_shape_realization(
    child_seed: np.random.SeedSequence,
    args: argparse.Namespace,
    hubble: float,
    temporal_response_weight: float,
    gradient_penalty: float,
) -> RowwiseShapeFirstJetSample:
    points, pivot_index, targets, pairings, moments = reconstruct_row_observations(
        np.random.default_rng(child_seed),
        args.events,
        args.duration,
        hubble,
        args.operator_nonlocality_multiplier,
        args.operator_support_multiplier,
        args.operator_averaging_multiplier,
        args.maximum_operator_rows,
        args.block_size,
        args.pivot_fraction,
    )
    raw_metric, raw_jet, _, _ = fit_affine_metric_field(
        points, pivot_index, targets, pairings
    )
    moment, moment_jet = fit_affine_vector_field(
        points, pivot_index, targets, moments
    )
    corrected_metric, corrected_jet, _ = (
        retarded_time_response_correction_with_jet(
            raw_metric,
            raw_jet,
            moment,
            moment_jet,
            temporal_response_weight,
        )
    )
    postfit_shape, postfit_shape_jet, _, _ = fuse_metric_and_first_jet(
        corrected_metric,
        corrected_jet,
        1.0,
        np.zeros(4),
    )

    row_shapes, retained = corrected_unit_volume_shapes(
        pairings, moments, temporal_response_weight
    )
    if len(retained) < 5:
        raise ValueError("fewer than five rows survive invariant shape filtering")
    retained_targets = targets[retained]
    rowwise_shape, rowwise_shape_jet, rank, condition = fit_affine_metric_field(
        points,
        pivot_index,
        retained_targets,
        row_shapes,
    )

    pivot_time = args.pivot_fraction * args.duration
    target_metric = target_inverse_metric_at(pivot_time, hubble)
    target_jet = target_inverse_metric_first_jet(pivot_time, hubble)
    target_shape, target_shape_jet, _, _ = fuse_metric_and_first_jet(
        target_metric,
        target_jet,
        1.0,
        np.zeros(4),
    )
    shape_norm = float(np.linalg.norm(target_shape))

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
    fused_metric = count.factor * rowwise_shape
    fused_jet = np.array(
        [
            count.calibrated_gradient[mu] * rowwise_shape
            + count.factor * rowwise_shape_jet[mu]
            for mu in range(4)
        ]
    )
    metric_norm = float(np.linalg.norm(target_metric))
    temporal_target_norm = float(np.linalg.norm(target_jet[0]))
    fused_volume = volume_density_from_inverse_metric(fused_metric)
    target_volume = 1.0 / count.target_factor**2
    return RowwiseShapeFirstJetSample(
        hubble=hubble,
        duration=args.duration,
        temporal_response_weight=temporal_response_weight,
        gradient_penalty=gradient_penalty,
        total_row_count=len(targets),
        admissible_row_count=len(retained),
        admissible_row_fraction=len(retained) / len(targets),
        rowwise_design_rank=rank,
        rowwise_design_condition=condition,
        postfit_shape=postfit_shape.tolist(),
        rowwise_shape=rowwise_shape.tolist(),
        target_shape=target_shape.tolist(),
        postfit_shape_relative_error=matrix_relative_error(
            postfit_shape, target_shape
        ),
        rowwise_shape_relative_error=matrix_relative_error(
            rowwise_shape, target_shape
        ),
        postfit_shape_first_jet_dimensionless_error=float(
            args.duration
            * np.linalg.norm(postfit_shape_jet - target_shape_jet)
            / shape_norm
        ),
        rowwise_shape_first_jet_dimensionless_error=float(
            args.duration
            * np.linalg.norm(rowwise_shape_jet - target_shape_jet)
            / shape_norm
        ),
        postfit_shape_spatial_jet_dimensionless_noise=float(
            args.duration * np.linalg.norm(postfit_shape_jet[1:]) / shape_norm
        ),
        rowwise_shape_spatial_jet_dimensionless_noise=float(
            args.duration * np.linalg.norm(rowwise_shape_jet[1:]) / shape_norm
        ),
        rowwise_shape_first_jet=rowwise_shape_jet.tolist(),
        target_shape_first_jet=target_shape_jet.tolist(),
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
        fused_first_jet=fused_jet.tolist(),
        target_first_jet=target_jet.tolist(),
        fused_first_jet_dimensionless_error=float(
            args.duration * np.linalg.norm(fused_jet - target_jet) / metric_norm
        ),
        fused_temporal_first_jet_relative_error=(
            None
            if temporal_target_norm == 0.0
            else float(
                np.linalg.norm(fused_jet[0] - target_jet[0])
                / temporal_target_norm
            )
        ),
        fused_spatial_first_jet_dimensionless_noise=float(
            args.duration * np.linalg.norm(fused_jet[1:]) / metric_norm
        ),
    )


def summarize_samples(samples: list[RowwiseShapeFirstJetSample]) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize empty samples")
    shape_jets = np.array([sample.rowwise_shape_first_jet for sample in samples])
    target_shape_jet = np.array(samples[0].target_shape_first_jet)
    target_shape = np.array(samples[0].target_shape)
    fused_jets = np.array([sample.fused_first_jet for sample in samples])
    target_jet = np.array(samples[0].target_first_jet)
    target_metric = np.array(samples[0].target_metric)
    return {
        "hubble": samples[0].hubble,
        "admissible_row_fraction": finite_statistics(
            [sample.admissible_row_fraction for sample in samples]
        ),
        "admissible_row_count": finite_statistics(
            [float(sample.admissible_row_count) for sample in samples]
        ),
        "rowwise_design_condition": finite_statistics(
            [sample.rowwise_design_condition for sample in samples]
        ),
        "postfit_shape_relative_error": finite_statistics(
            [sample.postfit_shape_relative_error for sample in samples]
        ),
        "rowwise_shape_relative_error": finite_statistics(
            [sample.rowwise_shape_relative_error for sample in samples]
        ),
        "postfit_shape_first_jet_dimensionless_error": finite_statistics(
            [
                sample.postfit_shape_first_jet_dimensionless_error
                for sample in samples
            ]
        ),
        "rowwise_shape_first_jet_dimensionless_error": finite_statistics(
            [
                sample.rowwise_shape_first_jet_dimensionless_error
                for sample in samples
            ]
        ),
        "ensemble_rowwise_shape_first_jet_dimensionless_error": float(
            samples[0].duration
            * np.linalg.norm(np.mean(shape_jets, axis=0) - target_shape_jet)
            / np.linalg.norm(target_shape)
        ),
        "postfit_shape_spatial_jet_dimensionless_noise": finite_statistics(
            [
                sample.postfit_shape_spatial_jet_dimensionless_noise
                for sample in samples
            ]
        ),
        "rowwise_shape_spatial_jet_dimensionless_noise": finite_statistics(
            [
                sample.rowwise_shape_spatial_jet_dimensionless_noise
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
        "ensemble_fused_first_jet_dimensionless_error": float(
            samples[0].duration
            * np.linalg.norm(np.mean(fused_jets, axis=0) - target_jet)
            / np.linalg.norm(target_metric)
        ),
        "fused_first_jet_dimensionless_error": finite_statistics(
            [sample.fused_first_jet_dimensionless_error for sample in samples]
        ),
        "fused_temporal_first_jet_relative_error": finite_statistics(
            [sample.fused_temporal_first_jet_relative_error for sample in samples]
        ),
        "fused_spatial_first_jet_dimensionless_noise": finite_statistics(
            [sample.fused_spatial_first_jet_dimensionless_noise for sample in samples]
        ),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.gradient_calibration_input is None:
        raise ValueError("--gradient-calibration-input is required")
    gradient_artifact = json.loads(
        args.gradient_calibration_input.read_text(encoding="utf-8")
    )
    gradient_penalty = float(gradient_artifact["selected_penalty"])
    hubble_values = sorted(set(args.hubble_values))
    for hubble in hubble_values:
        validate_background(args.duration, hubble)
    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(hubble_values) * args.realizations
    )
    samples: list[RowwiseShapeFirstJetSample] = []
    index = 0
    for hubble in hubble_values:
        for _ in range(args.realizations):
            samples.append(
                reconstruct_rowwise_shape_realization(
                    child_seeds[index],
                    args,
                    hubble,
                    args.temporal_response_weight,
                    gradient_penalty,
                )
            )
            index += 1
    result: dict[str, object] = {
        "status": "conditional rowwise shape-jet audit; not connection",
        "stage": "A32",
        "claim_boundary": {
            "a29_response_weight_is_frozen": True,
            "a31_scale_gradient_penalty_is_frozen": True,
            "row_filter_is_affine_invariant": True,
            "no_curved_target_is_used_for_selection": True,
            "coordinates_density_dimension_probes_and_windows_are_supplied": True,
            "levi_civita_connection_is_not_computed": True,
        },
        "settings": {
            "events": args.events,
            "realizations_per_background": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "hubble_values": hubble_values,
            "temporal_response_weight": args.temporal_response_weight,
            "gradient_penalty": gradient_penalty,
            "gradient_calibration_input": str(args.gradient_calibration_input),
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
        "background_summaries": {
            f"H={hubble:.6f}": summarize_samples(
                [sample for sample in samples if sample.hubble == hubble]
            )
            for hubble in hubble_values
        },
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--gradient-calibration-input", type=Path, required=True)
    parser.add_argument("--events", type=int, default=4000)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--pivot-fraction", type=float, default=0.7)
    parser.add_argument(
        "--hubble-values", type=float, nargs="+", default=[0.0, 0.1, 0.2]
    )
    parser.add_argument("--temporal-response-weight", type=float, default=0.6)
    parser.add_argument("--operator-nonlocality-multiplier", type=float, default=0.75)
    parser.add_argument("--operator-support-multiplier", type=float, default=1.8)
    parser.add_argument("--operator-averaging-multiplier", type=float, default=1.1)
    parser.add_argument("--count-window-multiplier", type=float, default=0.65)
    parser.add_argument("--count-center-multiplier", type=float, default=1.2)
    parser.add_argument("--maximum-operator-rows", type=int, default=128)
    parser.add_argument("--maximum-count-centers", type=int, default=128)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20261300)
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
