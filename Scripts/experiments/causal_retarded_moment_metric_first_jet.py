"""Stage A30 differentiated retarded-moment metric and count-volume fusion.

Stage A29 closes a conditional pivot-tensor gate.  This stage differentiates
that same construction exactly: the inverse metric, retarded moment, timelike
norm, temporal projector, determinant normalization, and independent count
scale all contribute to the first jet.  No old uncorrected derivative is
attached after the fact.

The response weight remains selected only from the two A29 flat calibration
ensembles.  Curved first-jet scores are held out until evaluation.  Coordinates,
density, dimension, probes, and schedules remain supplied, so this is a
conditional derivative audit rather than a bare-graph Levi-Civita construction.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_conformal_multirow_metric import reconstruct_multirow_realization
from causal_conformal_operator_metric import validate_background
from causal_count_volume_weyl_metric import reconstruct_count_weyl_realization
from causal_fused_operator_count_metric import fuse_metric_and_first_jet
from causal_operator_metric import (
    finite_statistics,
    matrix_relative_error,
    signature,
    volume_density_from_inverse_metric,
)
from causal_retarded_moment_debiased_metric import (
    retarded_time_response_correction_with_jet,
    select_temporal_response_weight,
)


@dataclass(frozen=True)
class RetardedMomentFirstJetSample:
    hubble: float
    duration: float
    temporal_response_weight: float
    retarded_moment_norm: float
    retarded_moment_first_jet_dimensionless_norm: float
    fused_metric: list[list[float]]
    target_metric: list[list[float]]
    fused_metric_relative_error: float
    fused_signature: tuple[int, int, int]
    fused_volume_density: float | None
    target_volume_density: float
    fused_oracle_volume_relative_error: float | None
    fused_count_volume_relative_mismatch: float | None
    raw_operator_first_jet_dimensionless_error: float
    corrected_operator_first_jet_dimensionless_error: float
    fused_first_jet: list[list[list[float]]]
    target_first_jet: list[list[list[float]]]
    fused_first_jet_dimensionless_error: float
    fused_temporal_first_jet_relative_error: float | None
    fused_spatial_first_jet_dimensionless_noise: float
    operator_row_count: int
    count_center_count: int


def reconstruct_first_jet_realization(
    child_seed: np.random.SeedSequence,
    args: argparse.Namespace,
    hubble: float,
    temporal_response_weight: float,
) -> RetardedMomentFirstJetSample:
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
    count = reconstruct_count_weyl_realization(
        np.random.default_rng(child_seed),
        args.events,
        args.duration,
        hubble,
        [args.count_window_multiplier],
        [args.count_center_multiplier],
        args.maximum_count_centers,
        args.pivot_fraction,
    )[0]
    raw_metric = np.array(operator.metric)
    raw_jet = np.array(operator.metric_first_jet)
    moment = np.array(operator.retarded_moment)
    moment_jet = np.array(operator.retarded_moment_first_jet)
    corrected_metric, corrected_jet, moment_norm = (
        retarded_time_response_correction_with_jet(
            raw_metric,
            raw_jet,
            moment,
            moment_jet,
            temporal_response_weight,
        )
    )
    fused_metric, fused_jet, _, _ = fuse_metric_and_first_jet(
        corrected_metric,
        corrected_jet,
        count.inverse_metric_weyl_factor,
        np.array(count.factor_first_gradient),
    )
    target_metric = np.array(operator.target_metric)
    target_jet = np.array(operator.target_metric_first_jet)
    target_volume = count.target_volume_density
    fused_volume = volume_density_from_inverse_metric(fused_metric)
    metric_norm = np.linalg.norm(target_metric)
    temporal_target_norm = np.linalg.norm(target_jet[0])
    moment_scale = max(np.linalg.norm(moment), np.finfo(float).eps)
    return RetardedMomentFirstJetSample(
        hubble=hubble,
        duration=args.duration,
        temporal_response_weight=temporal_response_weight,
        retarded_moment_norm=moment_norm,
        retarded_moment_first_jet_dimensionless_norm=float(
            args.duration * np.linalg.norm(moment_jet) / moment_scale
        ),
        fused_metric=fused_metric.tolist(),
        target_metric=target_metric.tolist(),
        fused_metric_relative_error=matrix_relative_error(
            fused_metric, target_metric
        ),
        fused_signature=signature(fused_metric),
        fused_volume_density=fused_volume,
        target_volume_density=target_volume,
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
        raw_operator_first_jet_dimensionless_error=(
            operator.first_jet_dimensionless_error
        ),
        corrected_operator_first_jet_dimensionless_error=float(
            args.duration * np.linalg.norm(corrected_jet - target_jet) / metric_norm
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
        operator_row_count=operator.row_count,
        count_center_count=count.center_count,
    )


def summarize_samples(samples: list[RetardedMomentFirstJetSample]) -> dict[str, object]:
    fused_metrics = np.array([sample.fused_metric for sample in samples])
    fused_jets = np.array([sample.fused_first_jet for sample in samples])
    target_metric = np.array(samples[0].target_metric)
    target_jet = np.array(samples[0].target_first_jet)
    mean_metric = np.mean(fused_metrics, axis=0)
    mean_jet = np.mean(fused_jets, axis=0)
    metric_norm = np.linalg.norm(target_metric)
    temporal_target_norm = np.linalg.norm(target_jet[0])
    return {
        "hubble": samples[0].hubble,
        "temporal_response_weight": samples[0].temporal_response_weight,
        "retarded_moment_norm": finite_statistics(
            [sample.retarded_moment_norm for sample in samples]
        ),
        "retarded_moment_first_jet_dimensionless_norm": finite_statistics(
            [sample.retarded_moment_first_jet_dimensionless_norm for sample in samples]
        ),
        "mean_fused_metric": mean_metric.tolist(),
        "target_metric": target_metric.tolist(),
        "ensemble_mean_fused_metric_relative_error": matrix_relative_error(
            mean_metric, target_metric
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
        "raw_operator_first_jet_dimensionless_error": finite_statistics(
            [sample.raw_operator_first_jet_dimensionless_error for sample in samples]
        ),
        "corrected_operator_first_jet_dimensionless_error": finite_statistics(
            [
                sample.corrected_operator_first_jet_dimensionless_error
                for sample in samples
            ]
        ),
        "mean_fused_first_jet": mean_jet.tolist(),
        "target_first_jet": target_jet.tolist(),
        "ensemble_fused_first_jet_dimensionless_error": float(
            samples[0].duration
            * np.linalg.norm(mean_jet - target_jet)
            / metric_norm
        ),
        "ensemble_fused_temporal_first_jet_relative_error": (
            None
            if temporal_target_norm == 0.0
            else float(
                np.linalg.norm(mean_jet[0] - target_jet[0])
                / temporal_target_norm
            )
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
        "operator_row_count": finite_statistics(
            [float(sample.operator_row_count) for sample in samples]
        ),
        "count_center_count": finite_statistics(
            [float(sample.count_center_count) for sample in samples]
        ),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    artifacts = [
        json.loads(path.read_text(encoding="utf-8"))
        for path in args.calibration_inputs
    ]
    weight, calibration_scores = select_temporal_response_weight(
        artifacts, args.temporal_response_weights
    )
    hubble_values = sorted(set(args.hubble_values))
    for hubble in hubble_values:
        validate_background(args.duration, hubble)
    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(hubble_values) * args.realizations
    )
    samples: list[RetardedMomentFirstJetSample] = []
    index = 0
    for hubble in hubble_values:
        for _ in range(args.realizations):
            samples.append(
                reconstruct_first_jet_realization(
                    child_seeds[index], args, hubble, weight
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
        "status": "conditional differentiated retarded-moment metric; not connection",
        "stage": "A30",
        "claim_boundary": {
            "moment_projector_and_determinant_derivatives_are_exact": True,
            "count_scale_gradient_is_independently_fitted": True,
            "curved_first_jet_targets_are_held_out": True,
            "coordinates_density_dimension_and_schedules_are_supplied": True,
            "levi_civita_connection_is_not_computed": True,
        },
        "calibration": {
            "inputs": [str(path) for path in args.calibration_inputs],
            "selected_weight": weight,
            "flat_density_scores": calibration_scores,
        },
        "settings": {
            "events": args.events,
            "realizations_per_background": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "hubble_values": hubble_values,
            "operator_nonlocality_multiplier": args.operator_nonlocality_multiplier,
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
    parser.add_argument("--calibration-inputs", type=Path, nargs="+", required=True)
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
    parser.add_argument("--seed", type=int, default=20261250)
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
