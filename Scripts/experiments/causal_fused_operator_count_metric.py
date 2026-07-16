"""Stage A25 fusion of operator conformal shape and count-volume scale.

Stage A23 supplies a concentrated but scale-biased causal-operator metric.
Stage A24 independently supplies the inverse-metric Weyl factor from event
counts.  This experiment evaluates both estimators on the same deterministic
sprinkling and pivot, normalizes the operator metric to unit determinant
volume, and restores its scale with the count estimate.

No target metric is used in the fusion.  All schedule multipliers were frozen
by the predecessor flat-control stages.  Coordinates still construct both
probe germs and count windows, and physical density remains supplied, so this
is a conditional metric fusion rather than bare-graph reconstruction.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_conformal_multirow_metric import (
    ConformalMultirowSample,
    reconstruct_multirow_realization,
)
from causal_conformal_operator_metric import validate_background
from causal_count_volume_weyl_metric import (
    CountWeylSample,
    reconstruct_count_weyl_realization,
)
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    finite_statistics,
    matrix_relative_error,
    signature,
    volume_density_from_inverse_metric,
)


@dataclass(frozen=True)
class FusedMetricSample:
    hubble: float
    duration: float
    operator_metric: list[list[float]]
    operator_metric_relative_error: float
    operator_volume_relative_error: float | None
    operator_volume_scale: float
    operator_shape: list[list[float]]
    operator_shape_relative_error: float
    count_weyl_factor: float
    count_weyl_factor_relative_error: float
    fused_metric: list[list[float]]
    target_metric: list[list[float]]
    fused_metric_relative_error: float
    fused_signature: tuple[int, int, int]
    fused_volume_density: float | None
    target_volume_density: float
    fused_oracle_volume_relative_error: float | None
    independent_count_volume_density: float
    fused_count_volume_relative_mismatch: float | None
    operator_first_jet_dimensionless_error: float
    fused_first_jet: list[list[list[float]]]
    target_first_jet: list[list[list[float]]]
    fused_first_jet_dimensionless_error: float
    fused_temporal_first_jet_relative_error: float | None
    fused_spatial_first_jet_dimensionless_noise: float
    operator_row_count: int
    count_center_count: int


def fuse_metric_and_first_jet(
    operator_metric: np.ndarray,
    operator_first_jet: np.ndarray,
    count_weyl_factor: float,
    count_factor_gradient: np.ndarray,
    require_lorentzian: bool = True,
) -> tuple[np.ndarray, np.ndarray, np.ndarray, float]:
    """Fuse an operator conformal shape with an independent Weyl factor."""

    if operator_metric.shape != (4, 4):
        raise ValueError("operator metric must be 4 by 4")
    if operator_first_jet.shape != (4, 4, 4):
        raise ValueError("operator first jet must have shape (4,4,4)")
    if count_factor_gradient.shape != (4,):
        raise ValueError("count factor gradient must have length four")
    if count_weyl_factor <= 0.0:
        raise ValueError("count Weyl factor must be positive")
    if require_lorentzian and signature(operator_metric) != (1, 3, 0):
        raise ValueError("operator metric must have signature (1,3,0)")
    determinant = float(np.linalg.det(operator_metric))
    if determinant == 0.0:
        raise ValueError("operator metric must be nondegenerate")
    volume_scale = abs(determinant) ** 0.25
    inverse = np.linalg.inv(operator_metric)
    volume_scale_gradient = np.array(
        [
            (volume_scale / 4.0)
            * np.trace(inverse @ operator_first_jet[mu])
            for mu in range(4)
        ]
    )
    shape = operator_metric / volume_scale
    shape_first_jet = np.array(
        [
            operator_first_jet[mu] / volume_scale
            - operator_metric * volume_scale_gradient[mu] / volume_scale**2
            for mu in range(4)
        ]
    )
    fused_metric = count_weyl_factor * shape
    fused_first_jet = np.array(
        [
            count_factor_gradient[mu] * shape
            + count_weyl_factor * shape_first_jet[mu]
            for mu in range(4)
        ]
    )
    return fused_metric, fused_first_jet, shape, volume_scale


def fuse_samples(
    operator: ConformalMultirowSample,
    count: CountWeylSample,
    require_lorentzian: bool = True,
) -> FusedMetricSample:
    if operator.hubble != count.hubble or operator.duration != count.duration:
        raise ValueError("operator and count samples have different backgrounds")
    operator_metric = np.array(operator.metric)
    operator_jet = np.array(operator.metric_first_jet)
    count_gradient = np.array(count.factor_first_gradient)
    fused_metric, fused_jet, shape, volume_scale = fuse_metric_and_first_jet(
        operator_metric,
        operator_jet,
        count.inverse_metric_weyl_factor,
        count_gradient,
        require_lorentzian,
    )
    target_metric = np.array(operator.target_metric)
    target_jet = np.array(operator.target_metric_first_jet)
    target_volume = count.target_volume_density
    operator_volume = volume_density_from_inverse_metric(operator_metric)
    fused_volume = volume_density_from_inverse_metric(fused_metric)
    metric_norm = np.linalg.norm(target_metric)
    temporal_target_norm = np.linalg.norm(target_jet[0])
    return FusedMetricSample(
        hubble=operator.hubble,
        duration=operator.duration,
        operator_metric=operator_metric.tolist(),
        operator_metric_relative_error=operator.metric_relative_error,
        operator_volume_relative_error=(
            None
            if operator_volume is None
            else abs(operator_volume - target_volume) / target_volume
        ),
        operator_volume_scale=volume_scale,
        operator_shape=shape.tolist(),
        operator_shape_relative_error=matrix_relative_error(
            shape, MINKOWSKI_INVERSE
        ),
        count_weyl_factor=count.inverse_metric_weyl_factor,
        count_weyl_factor_relative_error=count.factor_relative_error,
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
        independent_count_volume_density=count.independent_count_volume_density,
        fused_count_volume_relative_mismatch=(
            None
            if fused_volume is None
            else abs(fused_volume - count.independent_count_volume_density)
            / count.independent_count_volume_density
        ),
        operator_first_jet_dimensionless_error=(
            operator.first_jet_dimensionless_error
        ),
        fused_first_jet=fused_jet.tolist(),
        target_first_jet=target_jet.tolist(),
        fused_first_jet_dimensionless_error=float(
            operator.duration * np.linalg.norm(fused_jet - target_jet) / metric_norm
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
            operator.duration * np.linalg.norm(fused_jet[1:]) / metric_norm
        ),
        operator_row_count=operator.row_count,
        count_center_count=count.center_count,
    )


def summarize_samples(samples: list[FusedMetricSample]) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize empty fused samples")
    fused_metrics = np.array([sample.fused_metric for sample in samples])
    target_metric = np.array(samples[0].target_metric)
    fused_jets = np.array([sample.fused_first_jet for sample in samples])
    target_jet = np.array(samples[0].target_first_jet)
    metric_norm = np.linalg.norm(target_metric)
    temporal_target_norm = np.linalg.norm(target_jet[0])
    mean_metric = np.mean(fused_metrics, axis=0)
    mean_jet = np.mean(fused_jets, axis=0)
    return {
        "hubble": samples[0].hubble,
        "operator_row_count": finite_statistics(
            [float(sample.operator_row_count) for sample in samples]
        ),
        "count_center_count": finite_statistics(
            [float(sample.count_center_count) for sample in samples]
        ),
        "operator_metric_relative_error": finite_statistics(
            [sample.operator_metric_relative_error for sample in samples]
        ),
        "operator_volume_relative_error": finite_statistics(
            [sample.operator_volume_relative_error for sample in samples]
        ),
        "operator_shape_relative_error": finite_statistics(
            [sample.operator_shape_relative_error for sample in samples]
        ),
        "count_weyl_factor_relative_error": finite_statistics(
            [sample.count_weyl_factor_relative_error for sample in samples]
        ),
        "mean_fused_metric": mean_metric.tolist(),
        "target_metric": target_metric.tolist(),
        "ensemble_mean_fused_metric_relative_error": matrix_relative_error(
            mean_metric, target_metric
        ),
        "ensemble_mean_fused_signature": signature(mean_metric),
        "fused_signature_success_rate": sum(
            sample.fused_signature == (1, 3, 0) for sample in samples
        )
        / len(samples),
        "fused_metric_relative_error": finite_statistics(
            [sample.fused_metric_relative_error for sample in samples]
        ),
        "fused_oracle_volume_relative_error": finite_statistics(
            [sample.fused_oracle_volume_relative_error for sample in samples]
        ),
        "fused_count_volume_relative_mismatch": finite_statistics(
            [sample.fused_count_volume_relative_mismatch for sample in samples]
        ),
        "operator_first_jet_dimensionless_error": finite_statistics(
            [sample.operator_first_jet_dimensionless_error for sample in samples]
        ),
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
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.events <= 0 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    hubble_values = sorted(set(args.hubble_values))
    if not hubble_values or 0.0 not in hubble_values:
        raise ValueError("backgrounds must include H = 0")
    for hubble in hubble_values:
        validate_background(args.duration, hubble)

    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(hubble_values) * args.realizations
    )
    samples: list[FusedMetricSample] = []
    sample_index = 0
    for hubble in hubble_values:
        for _ in range(args.realizations):
            child_seed = child_seeds[sample_index]
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
            samples.append(
                fuse_samples(
                    operator,
                    count,
                    getattr(args, "require_lorentzian", True),
                )
            )
            sample_index += 1

    summaries = {
        f"H={hubble:.6f}": summarize_samples(
            [sample for sample in samples if sample.hubble == hubble]
        )
        for hubble in hubble_values
    }
    result: dict[str, object] = {
        "status": "conditional operator-shape/count-scale fusion; not reconstruction",
        "mode": args.mode,
        "claim_boundary": {
            "operator_shape_uses_order_count_rows": True,
            "weyl_factor_uses_disjoint_count_volume_fit": True,
            "fusion_uses_no_target_metric": True,
            "coordinates_density_dimension_and_schedules_are_supplied": True,
            "intrinsic_windows_are_not_constructed": True,
        },
        "settings": {
            "events": args.events,
            "realizations_per_background": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "hubble_values": hubble_values,
            "operator_nonlocality_multiplier": (
                args.operator_nonlocality_multiplier
            ),
            "operator_support_multiplier": args.operator_support_multiplier,
            "operator_averaging_multiplier": args.operator_averaging_multiplier,
            "count_window_multiplier": args.count_window_multiplier,
            "count_center_multiplier": args.count_center_multiplier,
            "maximum_operator_rows": args.maximum_operator_rows,
            "maximum_count_centers": args.maximum_count_centers,
            "synchronized_sampler_seed": True,
            "seed": args.seed,
        },
        "background_summaries": summaries,
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=("development", "held-out"), required=True)
    parser.add_argument("--events", type=int, default=4000)
    parser.add_argument("--realizations", type=int, default=4)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--pivot-fraction", type=float, default=0.7)
    parser.add_argument(
        "--hubble-values", type=float, nargs="+", default=[0.0, 0.1, 0.2]
    )
    parser.add_argument("--operator-nonlocality-multiplier", type=float, default=0.65)
    parser.add_argument("--operator-support-multiplier", type=float, default=1.4)
    parser.add_argument("--operator-averaging-multiplier", type=float, default=0.9)
    parser.add_argument("--count-window-multiplier", type=float, default=0.65)
    parser.add_argument("--count-center-multiplier", type=float, default=1.2)
    parser.add_argument("--maximum-operator-rows", type=int, default=96)
    parser.add_argument("--maximum-count-centers", type=int, default=96)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20261000)
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
