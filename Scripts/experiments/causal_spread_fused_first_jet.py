"""Stage A35 fresh curved evaluation of the A34 spread-row tangent fit.

A34 selects a wider, spread-row affine baseline and a nonzero aggregate tangent
weight using only exact flat zero/temporal/shear chart controls at two
densities.  A35 freezes that setting and evaluates it on untouched conformal
de Sitter sprinklings.  The A29 response correction, A24 pivot factor, and A31
Poisson scale gradient are unchanged.

The script records zero-tangent, selected-tangent, unweighted-tangent, and
oracle-scale controls.  Connection fitting remains closed unless the selected
first jet improves under density refinement while preserving the A29 pivot
tensor and its demonstrated nonlinear-chart response.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_conformal_multirow_metric import (
    fit_affine_metric_field,
    fit_affine_vector_field,
    target_inverse_metric_at,
    target_inverse_metric_first_jet,
)
from causal_fused_operator_count_metric import fuse_metric_and_first_jet
from causal_operator_metric import (
    finite_statistics,
    matrix_relative_error,
    signature,
    volume_density_from_inverse_metric,
)
from causal_poisson_scale_gradient import reconstruct_count_gradient_estimate
from causal_retarded_moment_debiased_metric import (
    retarded_time_response_correction_with_jet,
)
from causal_rowwise_shape_first_jet import reconstruct_row_observations


@dataclass(frozen=True)
class SpreadFusedFirstJetSample:
    hubble: float
    duration: float
    averaging_multiplier: float
    tangent_weight: float
    operator_row_count: int
    operator_design_condition: float
    shape: list[list[float]]
    target_shape: list[list[float]]
    shape_relative_error: float
    raw_shape_first_jet_dimensionless_error: float
    selected_shape_first_jet_dimensionless_error: float
    fused_metric: list[list[float]]
    target_metric: list[list[float]]
    fused_metric_relative_error: float
    fused_signature: tuple[int, int, int]
    fused_oracle_volume_relative_error: float | None
    fused_count_volume_relative_mismatch: float | None
    zero_tangent_first_jet_dimensionless_error: float
    selected_first_jet: list[list[list[float]]]
    target_first_jet: list[list[list[float]]]
    selected_first_jet_dimensionless_error: float
    unweighted_first_jet_dimensionless_error: float
    oracle_scale_first_jet_dimensionless_error: float
    selected_temporal_first_jet_relative_error: float | None
    selected_spatial_first_jet_dimensionless_noise: float
    count_gradient_dimensionless_error: float


def compose_fused_first_jet(
    shape: np.ndarray,
    shape_first_jet: np.ndarray,
    factor: float,
    factor_gradient: np.ndarray,
    tangent_weight: float,
) -> tuple[np.ndarray, np.ndarray]:
    if tangent_weight < 0.0:
        raise ValueError("tangent weight must be nonnegative")
    fused_metric = factor * shape
    fused_jet = np.array(
        [
            factor_gradient[mu] * shape
            + factor * tangent_weight * shape_first_jet[mu]
            for mu in range(4)
        ]
    )
    return fused_metric, fused_jet


def reconstruct_spread_fused_realization(
    child_seed: np.random.SeedSequence,
    args: argparse.Namespace,
    hubble: float,
    averaging_multiplier: float,
    tangent_weight: float,
    gradient_penalty: float,
) -> SpreadFusedFirstJetSample:
    maximum_rows = max(
        5, int(round(args.maximum_operator_rows_factor * np.sqrt(args.events)))
    )
    points, pivot_index, targets, pairings, moments = reconstruct_row_observations(
        np.random.default_rng(child_seed),
        args.events,
        args.duration,
        hubble,
        args.operator_nonlocality_multiplier,
        args.operator_support_multiplier,
        averaging_multiplier,
        maximum_rows,
        args.block_size,
        args.pivot_fraction,
        target_selection="spread",
    )
    raw_metric, raw_jet, _, condition = fit_affine_metric_field(
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
            args.temporal_response_weight,
        )
    )
    shape, shape_jet, _, _ = fuse_metric_and_first_jet(
        corrected_metric,
        corrected_jet,
        1.0,
        np.zeros(4),
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
    fused_metric, selected_jet = compose_fused_first_jet(
        shape,
        shape_jet,
        count.factor,
        count.calibrated_gradient,
        tangent_weight,
    )
    _, zero_jet = compose_fused_first_jet(
        shape,
        shape_jet,
        count.factor,
        count.calibrated_gradient,
        0.0,
    )
    _, unweighted_jet = compose_fused_first_jet(
        shape,
        shape_jet,
        count.factor,
        count.calibrated_gradient,
        1.0,
    )
    _, oracle_scale_jet = compose_fused_first_jet(
        shape,
        shape_jet,
        count.factor,
        count.target_gradient,
        tangent_weight,
    )
    metric_norm = float(np.linalg.norm(target_metric))
    shape_norm = float(np.linalg.norm(target_shape))
    temporal_target_norm = float(np.linalg.norm(target_jet[0]))
    fused_volume = volume_density_from_inverse_metric(fused_metric)
    target_volume = 1.0 / count.target_factor**2
    return SpreadFusedFirstJetSample(
        hubble=hubble,
        duration=args.duration,
        averaging_multiplier=averaging_multiplier,
        tangent_weight=tangent_weight,
        operator_row_count=len(targets),
        operator_design_condition=condition,
        shape=shape.tolist(),
        target_shape=target_shape.tolist(),
        shape_relative_error=matrix_relative_error(shape, target_shape),
        raw_shape_first_jet_dimensionless_error=float(
            args.duration * np.linalg.norm(shape_jet - target_shape_jet) / shape_norm
        ),
        selected_shape_first_jet_dimensionless_error=float(
            args.duration
            * np.linalg.norm(tangent_weight * shape_jet - target_shape_jet)
            / shape_norm
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
        zero_tangent_first_jet_dimensionless_error=float(
            args.duration * np.linalg.norm(zero_jet - target_jet) / metric_norm
        ),
        selected_first_jet=selected_jet.tolist(),
        target_first_jet=target_jet.tolist(),
        selected_first_jet_dimensionless_error=float(
            args.duration * np.linalg.norm(selected_jet - target_jet) / metric_norm
        ),
        unweighted_first_jet_dimensionless_error=float(
            args.duration
            * np.linalg.norm(unweighted_jet - target_jet)
            / metric_norm
        ),
        oracle_scale_first_jet_dimensionless_error=float(
            args.duration
            * np.linalg.norm(oracle_scale_jet - target_jet)
            / metric_norm
        ),
        selected_temporal_first_jet_relative_error=(
            None
            if temporal_target_norm == 0.0
            else float(
                np.linalg.norm(selected_jet[0] - target_jet[0])
                / temporal_target_norm
            )
        ),
        selected_spatial_first_jet_dimensionless_noise=float(
            args.duration * np.linalg.norm(selected_jet[1:]) / metric_norm
        ),
        count_gradient_dimensionless_error=float(
            args.duration
            * np.linalg.norm(count.calibrated_gradient - count.target_gradient)
            / count.target_factor
        ),
    )


def summarize_samples(samples: list[SpreadFusedFirstJetSample]) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize empty samples")
    jets = np.array([sample.selected_first_jet for sample in samples])
    target_jet = np.array(samples[0].target_first_jet)
    target_metric = np.array(samples[0].target_metric)
    return {
        "hubble": samples[0].hubble,
        "operator_row_count": finite_statistics(
            [float(sample.operator_row_count) for sample in samples]
        ),
        "operator_design_condition": finite_statistics(
            [sample.operator_design_condition for sample in samples]
        ),
        "shape_relative_error": finite_statistics(
            [sample.shape_relative_error for sample in samples]
        ),
        "raw_shape_first_jet_dimensionless_error": finite_statistics(
            [
                sample.raw_shape_first_jet_dimensionless_error
                for sample in samples
            ]
        ),
        "selected_shape_first_jet_dimensionless_error": finite_statistics(
            [
                sample.selected_shape_first_jet_dimensionless_error
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
        "count_gradient_dimensionless_error": finite_statistics(
            [sample.count_gradient_dimensionless_error for sample in samples]
        ),
        "zero_tangent_first_jet_dimensionless_error": finite_statistics(
            [sample.zero_tangent_first_jet_dimensionless_error for sample in samples]
        ),
        "selected_first_jet_dimensionless_error": finite_statistics(
            [sample.selected_first_jet_dimensionless_error for sample in samples]
        ),
        "unweighted_first_jet_dimensionless_error": finite_statistics(
            [sample.unweighted_first_jet_dimensionless_error for sample in samples]
        ),
        "oracle_scale_first_jet_dimensionless_error": finite_statistics(
            [sample.oracle_scale_first_jet_dimensionless_error for sample in samples]
        ),
        "ensemble_selected_first_jet_dimensionless_error": float(
            samples[0].duration
            * np.linalg.norm(np.mean(jets, axis=0) - target_jet)
            / np.linalg.norm(target_metric)
        ),
        "selected_temporal_first_jet_relative_error": finite_statistics(
            [sample.selected_temporal_first_jet_relative_error for sample in samples]
        ),
        "selected_spatial_first_jet_dimensionless_noise": finite_statistics(
            [
                sample.selected_spatial_first_jet_dimensionless_noise
                for sample in samples
            ]
        ),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    spread_artifact = json.loads(args.spread_selection_input.read_text(encoding="utf-8"))
    gradient_artifact = json.loads(
        args.gradient_calibration_input.read_text(encoding="utf-8")
    )
    selected = spread_artifact["selected_setting"]
    if not bool(selected["beats_zero_baseline"]):
        raise ValueError("the spread setting does not beat the zero baseline")
    if not bool(selected["pivot_tensor_pass"]):
        raise ValueError("the spread setting does not preserve the pivot gate")
    averaging_multiplier = float(selected["averaging_multiplier"])
    tangent_weight = float(selected["tangent_weight"])
    gradient_penalty = float(gradient_artifact["selected_penalty"])
    hubble_values = sorted(set(args.hubble_values))
    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(hubble_values) * args.realizations
    )
    samples: list[SpreadFusedFirstJetSample] = []
    index = 0
    for hubble in hubble_values:
        for _ in range(args.realizations):
            samples.append(
                reconstruct_spread_fused_realization(
                    child_seeds[index],
                    args,
                    hubble,
                    averaging_multiplier,
                    tangent_weight,
                    gradient_penalty,
                )
            )
            index += 1
    result: dict[str, object] = {
        "status": "conditional spread-row fused first jet; not connection",
        "stage": "A35",
        "mode": "held-out",
        "claim_boundary": {
            "averaging_and_tangent_weights_are_frozen_on_flat_charts": True,
            "curved_targets_are_used_only_after_selection": True,
            "nonzero_chart_response_was_required": True,
            "a29_tensor_a24_scale_and_a31_gradient_are_retained": True,
            "coordinates_density_dimension_probes_and_windows_are_supplied": True,
            "levi_civita_connection_is_not_computed": True,
        },
        "calibration": {
            "spread_selection_input": str(args.spread_selection_input),
            "gradient_calibration_input": str(args.gradient_calibration_input),
            "averaging_multiplier": averaging_multiplier,
            "tangent_weight": tangent_weight,
            "gradient_penalty": gradient_penalty,
        },
        "settings": {
            "events": args.events,
            "realizations_per_background": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "hubble_values": hubble_values,
            "temporal_response_weight": args.temporal_response_weight,
            "operator_nonlocality_multiplier": (
                args.operator_nonlocality_multiplier
            ),
            "operator_support_multiplier": args.operator_support_multiplier,
            "maximum_operator_rows_factor": args.maximum_operator_rows_factor,
            "count_window_multiplier": args.count_window_multiplier,
            "count_center_multiplier": args.count_center_multiplier,
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
    parser.add_argument("--spread-selection-input", type=Path, required=True)
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
    parser.add_argument("--maximum-operator-rows-factor", type=float, default=4.0)
    parser.add_argument("--count-window-multiplier", type=float, default=0.65)
    parser.add_argument("--count-center-multiplier", type=float, default=1.2)
    parser.add_argument("--maximum-count-centers", type=int, default=128)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20261350)
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
