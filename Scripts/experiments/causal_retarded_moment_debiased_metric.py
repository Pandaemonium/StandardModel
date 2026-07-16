"""Stage A29 covariant retarded-moment debiasing of the operator metric.

The stabilized A28 operator metric retains a nearly one-dimensional response
bias: its temporal coefficient is too large while off-diagonal noise is small.
This stage derives a timelike vector from the positive first moment of the same
retarded operator kernel.  Given an inverse metric ``G`` and moment ``m``, set

    q = m^T G^-1 m,
    T = m m^T / q,
    S = G - T,
    G_r = r T + S.

The construction is covariant under every invertible affine probe change.  A
single positive response weight ``r`` is selected on two flat development
densities by signature rate and worst individual unit-volume shape error.  The
corrected conformal shape is then fused with independent count volume on fresh
curved samples.  First derivatives are deliberately not inferred in this
stage.

Coordinates, density, dimension, probes, and schedules remain supplied.  This
is a conditional finite-density response calibration, not bare-graph metric
reconstruction.
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
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    finite_statistics,
    matrix_relative_error,
    signature,
    volume_density_from_inverse_metric,
)
from causal_shape_selected_fused_metric import unit_volume_shape


@dataclass(frozen=True)
class RetardedMomentDebiasedSample:
    hubble: float
    duration: float
    temporal_response_weight: float
    retarded_moment: list[float]
    retarded_moment_norm: float
    raw_metric: list[list[float]]
    raw_shape_relative_error: float
    corrected_metric: list[list[float]]
    corrected_shape: list[list[float]]
    corrected_shape_relative_error: float
    corrected_signature: tuple[int, int, int]
    fused_metric: list[list[float]]
    target_metric: list[list[float]]
    fused_metric_relative_error: float
    fused_signature: tuple[int, int, int]
    fused_volume_density: float | None
    target_volume_density: float
    fused_oracle_volume_relative_error: float | None
    independent_count_volume_density: float
    fused_count_volume_relative_mismatch: float | None
    operator_row_count: int
    count_center_count: int


def retarded_time_response_correction(
    metric: np.ndarray,
    moment: np.ndarray,
    temporal_response_weight: float,
) -> tuple[np.ndarray, float]:
    """Rescale the moment-derived temporal projector covariantly."""

    if metric.shape != (4, 4) or moment.shape != (4,):
        raise ValueError("require a 4 by 4 metric and a length-four moment")
    if temporal_response_weight <= 0.0:
        raise ValueError("the temporal response weight must be positive")
    if signature(metric) != (1, 3, 0):
        raise ValueError("the raw operator metric must be Lorentzian")
    inverse = np.linalg.inv(metric)
    moment_norm = float(moment @ inverse @ moment)
    if moment_norm <= 0.0:
        raise ValueError("the retarded moment must be timelike")
    temporal_projector = np.outer(moment, moment) / moment_norm
    corrected = metric + (temporal_response_weight - 1.0) * temporal_projector
    return 0.5 * (corrected + corrected.T), moment_norm


def retarded_time_response_correction_with_jet(
    metric: np.ndarray,
    metric_first_jet: np.ndarray,
    moment: np.ndarray,
    moment_first_jet: np.ndarray,
    temporal_response_weight: float,
) -> tuple[np.ndarray, np.ndarray, float]:
    """Differentiate the covariant retarded-moment response correction."""

    if metric_first_jet.shape != (4, 4, 4):
        raise ValueError("metric first jet must have shape (4,4,4)")
    if moment_first_jet.shape != (4, 4):
        raise ValueError("moment first jet must have shape (4,4)")
    corrected, moment_norm = retarded_time_response_correction(
        metric, moment, temporal_response_weight
    )
    inverse = np.linalg.inv(metric)
    temporal_numerator = np.outer(moment, moment)
    corrected_jet: list[np.ndarray] = []
    for derivative in range(4):
        d_metric = metric_first_jet[derivative]
        d_moment = moment_first_jet[derivative]
        d_inverse = -inverse @ d_metric @ inverse
        d_norm = float(
            d_moment @ inverse @ moment
            + moment @ inverse @ d_moment
            + moment @ d_inverse @ moment
        )
        d_numerator = np.outer(d_moment, moment) + np.outer(moment, d_moment)
        d_projector = (
            d_numerator / moment_norm
            - temporal_numerator * d_norm / moment_norm**2
        )
        corrected_derivative = d_metric + (
            temporal_response_weight - 1.0
        ) * d_projector
        corrected_jet.append(
            0.5 * (corrected_derivative + corrected_derivative.T)
        )
    return corrected, np.array(corrected_jet), moment_norm


def select_temporal_response_weight(
    development_artifacts: list[dict[str, object]],
    candidate_weights: list[float],
) -> tuple[float, dict[str, dict[str, dict[str, float]]]]:
    """Select one weight by flat signature and shape tails across densities."""

    if len(development_artifacts) < 2:
        raise ValueError("weight selection requires at least two densities")
    if not candidate_weights or any(weight <= 0.0 for weight in candidate_weights):
        raise ValueError("candidate weights must be positive")
    density_scores: dict[str, dict[str, dict[str, float]]] = {}
    for artifact in development_artifacts:
        events = int(artifact["settings"]["events"])
        label = f"N={events}"
        if label in density_scores:
            raise ValueError("development densities must be distinct")
        flat_samples = [
            sample
            for sample in artifact["samples"]
            if float(sample["hubble"]) == 0.0
        ]
        scores: dict[str, dict[str, float]] = {}
        for weight in candidate_weights:
            errors: list[float] = []
            valid = 0
            for sample in flat_samples:
                try:
                    corrected, _ = retarded_time_response_correction(
                        np.array(sample["metric"], dtype=float),
                        np.array(sample["retarded_moment"], dtype=float),
                        weight,
                    )
                except (ValueError, np.linalg.LinAlgError):
                    continue
                if signature(corrected) == (1, 3, 0):
                    valid += 1
                    errors.append(
                        matrix_relative_error(
                            unit_volume_shape(corrected), MINKOWSKI_INVERSE
                        )
                    )
            key = f"r={weight:.6f}"
            scores[key] = {
                "weight": weight,
                "valid_signature_rate": valid / len(flat_samples),
                "maximum_unit_volume_shape_error": (
                    float(np.max(errors)) if errors else float("inf")
                ),
                "median_unit_volume_shape_error": (
                    float(np.median(errors)) if errors else float("inf")
                ),
                "mean_unit_volume_shape_error": (
                    float(np.mean(errors)) if errors else float("inf")
                ),
            }
        density_scores[label] = scores

    def score(weight: float) -> tuple[float, ...]:
        key = f"r={weight:.6f}"
        per_density = [
            density_scores[label][key] for label in sorted(density_scores)
        ]
        return (
            -min(item["valid_signature_rate"] for item in per_density),
            max(item["maximum_unit_volume_shape_error"] for item in per_density),
            max(item["median_unit_volume_shape_error"] for item in per_density),
            max(item["mean_unit_volume_shape_error"] for item in per_density),
            weight,
        )

    selected = min(sorted(set(candidate_weights)), key=score)
    return selected, density_scores


def reconstruct_debiased_realization(
    child_seed: np.random.SeedSequence,
    args: argparse.Namespace,
    hubble: float,
    temporal_response_weight: float,
) -> RetardedMomentDebiasedSample:
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
    corrected_metric, moment_norm = retarded_time_response_correction(
        raw_metric,
        np.array(operator.retarded_moment),
        temporal_response_weight,
    )
    raw_shape = unit_volume_shape(raw_metric)
    corrected_shape = unit_volume_shape(corrected_metric)
    fused_metric = count.inverse_metric_weyl_factor * corrected_shape
    fused_volume = volume_density_from_inverse_metric(fused_metric)
    target_metric = np.array(operator.target_metric)
    target_volume = count.target_volume_density
    return RetardedMomentDebiasedSample(
        hubble=hubble,
        duration=args.duration,
        temporal_response_weight=temporal_response_weight,
        retarded_moment=operator.retarded_moment,
        retarded_moment_norm=moment_norm,
        raw_metric=raw_metric.tolist(),
        raw_shape_relative_error=matrix_relative_error(
            raw_shape, MINKOWSKI_INVERSE
        ),
        corrected_metric=corrected_metric.tolist(),
        corrected_shape=corrected_shape.tolist(),
        corrected_shape_relative_error=matrix_relative_error(
            corrected_shape, MINKOWSKI_INVERSE
        ),
        corrected_signature=signature(corrected_metric),
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
        operator_row_count=operator.row_count,
        count_center_count=count.center_count,
    )


def summarize_samples(
    samples: list[RetardedMomentDebiasedSample],
) -> dict[str, object]:
    fused_metrics = np.array([sample.fused_metric for sample in samples])
    target_metric = np.array(samples[0].target_metric)
    mean_metric = np.mean(fused_metrics, axis=0)
    return {
        "hubble": samples[0].hubble,
        "temporal_response_weight": samples[0].temporal_response_weight,
        "retarded_moment_norm": finite_statistics(
            [sample.retarded_moment_norm for sample in samples]
        ),
        "raw_shape_relative_error": finite_statistics(
            [sample.raw_shape_relative_error for sample in samples]
        ),
        "corrected_shape_relative_error": finite_statistics(
            [sample.corrected_shape_relative_error for sample in samples]
        ),
        "corrected_signature_success_rate": sum(
            sample.corrected_signature == (1, 3, 0) for sample in samples
        )
        / len(samples),
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
    samples: list[RetardedMomentDebiasedSample] = []
    index = 0
    for hubble in hubble_values:
        for _ in range(args.realizations):
            samples.append(
                reconstruct_debiased_realization(
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
        "status": "conditional retarded-moment response debiasing; not reconstruction",
        "stage": "A29",
        "claim_boundary": {
            "retarded_moment_uses_operator_weights_and_supplied_probes": True,
            "temporal_split_is_affine_probe_covariant": True,
            "calibration_uses_flat_targets_only": True,
            "count_volume_is_independently_fitted": True,
            "coordinates_density_dimension_and_schedules_are_supplied": True,
            "metric_first_jet_is_not_claimed": True,
        },
        "calibration": {
            "inputs": [str(path) for path in args.calibration_inputs],
            "candidate_weights": sorted(set(args.temporal_response_weights)),
            "selected_weight": weight,
            "flat_density_scores": calibration_scores,
            "curved_samples_used_for_selection": False,
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
    parser.add_argument("--seed", type=int, default=20261230)
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
