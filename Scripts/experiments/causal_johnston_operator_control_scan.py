"""Coordinate-probe operator control at order-selected causal-set pivots.

This Stage A5 development scan isolates the finite Benincasa-Dowker operator
from the Johnston interval-volume probe reconstruction. Causal order, supplied
dimension, and supplied density select the marked event. Embedding coordinates
enter only through the compact coordinate probes used as a calibration oracle.

The scan ranks a frozen nonlocality-scale/support-radius grid without computing
or scoring Johnston spatial probes. It is an external numerical oracle, not a
proof or a bare-graph metric reconstruction.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_probe_metric import (
    causal_interval_points,
    choose_intrinsic_pivot,
    compact_lightcone_probes,
    intrinsic_compact_quadratic_probe,
    intrinsic_quadratic_normalization,
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
class OperatorControlSample:
    nonlocality_scale: float
    support_radius: float
    signature: tuple[int, int, int]
    eigenvalues: list[float]
    pairing: list[list[float]]
    metric_relative_error: float
    passes_gate: bool
    pivot_intrinsic_time: float
    pivot_intrinsic_radius: float
    pivot_past_count: int
    pivot_future_count: int
    intrinsic_quadratic_response: float
    count_normalization_factor: float | None
    count_normalized_signature: tuple[int, int, int] | None
    count_normalized_eigenvalues: list[float] | None
    count_normalized_pairing: list[list[float]] | None
    count_normalized_metric_relative_error: float | None
    passes_count_normalized_gate: bool
    johnston_quadratic_response: float | None
    johnston_quadratic_normalization_factor: float | None
    johnston_normalized_signature: tuple[int, int, int] | None
    johnston_normalized_eigenvalues: list[float] | None
    johnston_normalized_pairing: list[list[float]] | None
    johnston_normalized_metric_relative_error: float | None
    passes_johnston_normalized_gate: bool


def setting_key(nonlocality_scale: float, support_radius: float) -> str:
    """Stable JSON key for one scan setting."""

    return (
        f"L={nonlocality_scale:.6f}|"
        f"support={support_radius:.6f}"
    )


def optimal_positive_rescaling(
    matrix: np.ndarray,
    target: np.ndarray = MINKOWSKI_INVERSE,
) -> tuple[float | None, float | None]:
    """Best positive scalar multiple and its target-relative error."""

    denominator = float(np.sum(matrix * matrix))
    if denominator <= 0.0:
        return None, None
    factor = float(np.sum(matrix * target) / denominator)
    if factor <= 0.0:
        return None, None
    return factor, matrix_relative_error(factor * matrix, target)


def reconstruct_control_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    nonlocality_scales: list[float],
    support_radii: list[float],
    maximum_metric_error: float,
    compute_johnston_quadratic: bool = False,
) -> list[OperatorControlSample]:
    """Evaluate every frozen setting on one common order-selected pivot."""

    points, bottom_index, top_index = causal_interval_points(
        rng, events, duration
    )
    relation = causal_relation_matrix(points, block_size)
    coefficient = minkowski_interval_coefficient(dimension)
    density = events / (coefficient * duration**dimension)
    ell = density ** (-1.0 / dimension)
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

    past = relation[:, pivot_index]
    past_indices = np.flatnonzero(past)
    counts_to_pivot = np.zeros(events, dtype=np.int64)
    counts_to_pivot[past_indices] = selected_open_interval_counts(
        relation, past_indices, np.array([pivot_index])
    )[:, 0]
    probes_by_support = {
        radius: compact_coordinate_probes(points, pivot_index, radius)
        for radius in support_radii
    }
    quadratic_probes_by_support = {
        radius: intrinsic_compact_quadratic_probe(
            relation,
            counts_to_pivot,
            density,
            dimension,
            intrinsic_time,
            pivot_index,
            radius,
        )
        for radius in support_radii
    }
    johnston_quadratics_by_support: dict[float, np.ndarray] = {}
    if compute_johnston_quadratic:
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
        johnston_quadratics_by_support = {
            radius: lorentzian_quadratic_probe(
                compact_lightcone_probes(embedding, radius)
            )
            for radius in support_radii
        }
    expected_signature = (1, dimension - 1, 0)
    samples: list[OperatorControlSample] = []
    for scale in nonlocality_scales:
        if scale <= ell:
            raise ValueError(
                "every nonlocality scale must be strictly greater than ell"
            )
        row = project_convention_row(
            smeared_bd_row(
                past,
                counts_to_pivot,
                pivot_index,
                ell,
                scale,
            )
        )
        for radius, probes in probes_by_support.items():
            pairing = corrected_gamma(row, probes, pivot_index)
            sample_signature = signature(pairing)
            error = matrix_relative_error(pairing, MINKOWSKI_INVERSE)
            quadratic_response, count_factor = (
                intrinsic_quadratic_normalization(
                    row,
                    quadratic_probes_by_support[radius],
                    dimension,
                )
            )
            count_pairing = (
                None if count_factor is None else count_factor * pairing
            )
            count_signature = (
                None if count_pairing is None else signature(count_pairing)
            )
            count_error = (
                None
                if count_pairing is None
                else matrix_relative_error(
                    count_pairing, MINKOWSKI_INVERSE
                )
            )
            johnston_response: float | None = None
            johnston_factor: float | None = None
            johnston_pairing: np.ndarray | None = None
            johnston_signature: tuple[int, int, int] | None = None
            johnston_error: float | None = None
            if compute_johnston_quadratic:
                johnston_response, johnston_factor = (
                    intrinsic_quadratic_normalization(
                        row,
                        johnston_quadratics_by_support[radius],
                        dimension,
                    )
                )
                if johnston_factor is not None:
                    johnston_pairing = johnston_factor * pairing
                    johnston_signature = signature(johnston_pairing)
                    johnston_error = matrix_relative_error(
                        johnston_pairing, MINKOWSKI_INVERSE
                    )
            samples.append(
                OperatorControlSample(
                    nonlocality_scale=scale,
                    support_radius=radius,
                    signature=sample_signature,
                    eigenvalues=np.linalg.eigvalsh(pairing).tolist(),
                    pairing=pairing.tolist(),
                    metric_relative_error=error,
                    passes_gate=(
                        sample_signature == expected_signature
                        and error <= maximum_metric_error
                    ),
                    pivot_intrinsic_time=float(intrinsic_time[pivot_index]),
                    pivot_intrinsic_radius=float(
                        intrinsic_radius[pivot_index]
                    ),
                    pivot_past_count=int(np.count_nonzero(past)),
                    pivot_future_count=int(
                        np.count_nonzero(relation[pivot_index, :])
                    ),
                    intrinsic_quadratic_response=quadratic_response,
                    count_normalization_factor=count_factor,
                    count_normalized_signature=count_signature,
                    count_normalized_eigenvalues=(
                        None
                        if count_pairing is None
                        else np.linalg.eigvalsh(count_pairing).tolist()
                    ),
                    count_normalized_pairing=(
                        None
                        if count_pairing is None
                        else count_pairing.tolist()
                    ),
                    count_normalized_metric_relative_error=count_error,
                    passes_count_normalized_gate=(
                        count_signature == expected_signature
                        and count_error is not None
                        and count_error <= maximum_metric_error
                    ),
                    johnston_quadratic_response=johnston_response,
                    johnston_quadratic_normalization_factor=johnston_factor,
                    johnston_normalized_signature=johnston_signature,
                    johnston_normalized_eigenvalues=(
                        None
                        if johnston_pairing is None
                        else np.linalg.eigvalsh(johnston_pairing).tolist()
                    ),
                    johnston_normalized_pairing=(
                        None
                        if johnston_pairing is None
                        else johnston_pairing.tolist()
                    ),
                    johnston_normalized_metric_relative_error=(
                        johnston_error
                    ),
                    passes_johnston_normalized_gate=(
                        johnston_signature == expected_signature
                        and johnston_error is not None
                        and johnston_error <= maximum_metric_error
                    ),
                )
            )
    return samples


def summarize_setting(
    samples: list[OperatorControlSample],
    expected_signature: tuple[int, int, int],
) -> dict[str, object]:
    """Summarize one common grid setting across realizations."""

    pairings = np.array([sample.pairing for sample in samples], dtype=float)
    ensemble_pairing = np.mean(pairings, axis=0)
    rescalings = [optimal_positive_rescaling(pairing) for pairing in pairings]
    finite_factors = [
        factor for factor, _ in rescalings if factor is not None
    ]
    finite_errors = [
        error for _, error in rescalings if error is not None
    ]
    ensemble_factor, ensemble_rescaled_error = optimal_positive_rescaling(
        ensemble_pairing
    )
    count_pairings = np.array(
        [
            sample.count_normalized_pairing
            for sample in samples
            if sample.count_normalized_pairing is not None
        ],
        dtype=float,
    )
    count_ensemble_pairing = (
        None if len(count_pairings) == 0 else np.mean(count_pairings, axis=0)
    )
    count_signature_successes = sum(
        sample.count_normalized_signature == expected_signature
        for sample in samples
    )
    count_gate_successes = sum(
        sample.passes_count_normalized_gate for sample in samples
    )
    mean_quadratic_response = float(
        np.mean([sample.intrinsic_quadratic_response for sample in samples])
    )
    aggregate_count_factor = (
        None
        if not np.isfinite(mean_quadratic_response)
        or mean_quadratic_response <= 1.0e-12
        else 2.0 * pairings.shape[-1] / mean_quadratic_response
    )
    aggregate_count_pairing = (
        None
        if aggregate_count_factor is None
        else aggregate_count_factor * ensemble_pairing
    )
    johnston_pairings = np.array(
        [
            sample.johnston_normalized_pairing
            for sample in samples
            if sample.johnston_normalized_pairing is not None
        ],
        dtype=float,
    )
    johnston_ensemble_pairing = (
        None
        if len(johnston_pairings) == 0
        else np.mean(johnston_pairings, axis=0)
    )
    johnston_signature_successes = sum(
        sample.johnston_normalized_signature == expected_signature
        for sample in samples
    )
    johnston_gate_successes = sum(
        sample.passes_johnston_normalized_gate for sample in samples
    )
    finite_johnston_responses = [
        sample.johnston_quadratic_response
        for sample in samples
        if sample.johnston_quadratic_response is not None
        and np.isfinite(sample.johnston_quadratic_response)
    ]
    mean_johnston_response = (
        None
        if not finite_johnston_responses
        else float(np.mean(finite_johnston_responses))
    )
    aggregate_johnston_factor = (
        None
        if mean_johnston_response is None
        or mean_johnston_response <= 1.0e-12
        else 2.0 * pairings.shape[-1] / mean_johnston_response
    )
    aggregate_johnston_pairing = (
        None
        if aggregate_johnston_factor is None
        else aggregate_johnston_factor * ensemble_pairing
    )
    signature_successes = sum(
        sample.signature == expected_signature for sample in samples
    )
    gate_successes = sum(sample.passes_gate for sample in samples)
    return {
        "nonlocality_scale": samples[0].nonlocality_scale,
        "support_radius": samples[0].support_radius,
        "samples": len(samples),
        "signature_success_rate": signature_successes / len(samples),
        "gate_success_rate": gate_successes / len(samples),
        "metric_relative_error": finite_statistics(
            [sample.metric_relative_error for sample in samples]
        ),
        "ensemble_mean_pairing": ensemble_pairing.tolist(),
        "ensemble_mean_relative_error": matrix_relative_error(
            ensemble_pairing, MINKOWSKI_INVERSE
        ),
        "ensemble_mean_signature": signature(ensemble_pairing),
        "positive_rescaling_factor": finite_statistics(finite_factors),
        "rescaled_metric_relative_error": finite_statistics(finite_errors),
        "ensemble_positive_rescaling_factor": ensemble_factor,
        "ensemble_rescaled_metric_relative_error": ensemble_rescaled_error,
        "intrinsic_quadratic_response": finite_statistics(
            [sample.intrinsic_quadratic_response for sample in samples]
        ),
        "count_normalization_success_rate": (
            len(count_pairings) / len(samples)
        ),
        "count_normalization_factor": finite_statistics(
            [sample.count_normalization_factor for sample in samples]
        ),
        "count_normalized_signature_success_rate": (
            count_signature_successes / len(samples)
        ),
        "count_normalized_gate_success_rate": (
            count_gate_successes / len(samples)
        ),
        "count_normalized_metric_relative_error": finite_statistics(
            [
                sample.count_normalized_metric_relative_error
                for sample in samples
            ]
        ),
        "count_normalized_ensemble_mean_pairing": (
            None
            if count_ensemble_pairing is None
            else count_ensemble_pairing.tolist()
        ),
        "count_normalized_ensemble_mean_relative_error": (
            None
            if count_ensemble_pairing is None
            else matrix_relative_error(
                count_ensemble_pairing, MINKOWSKI_INVERSE
            )
        ),
        "aggregate_count_normalization_factor": aggregate_count_factor,
        "aggregate_count_normalized_pairing": (
            None
            if aggregate_count_pairing is None
            else aggregate_count_pairing.tolist()
        ),
        "aggregate_count_normalized_relative_error": (
            None
            if aggregate_count_pairing is None
            else matrix_relative_error(
                aggregate_count_pairing, MINKOWSKI_INVERSE
            )
        ),
        "johnston_quadratic_response": finite_statistics(
            [sample.johnston_quadratic_response for sample in samples]
        ),
        "johnston_quadratic_normalization_success_rate": (
            len(johnston_pairings) / len(samples)
        ),
        "johnston_quadratic_normalization_factor": finite_statistics(
            [
                sample.johnston_quadratic_normalization_factor
                for sample in samples
            ]
        ),
        "johnston_normalized_signature_success_rate": (
            johnston_signature_successes / len(samples)
        ),
        "johnston_normalized_gate_success_rate": (
            johnston_gate_successes / len(samples)
        ),
        "johnston_normalized_metric_relative_error": finite_statistics(
            [
                sample.johnston_normalized_metric_relative_error
                for sample in samples
            ]
        ),
        "johnston_normalized_ensemble_mean_pairing": (
            None
            if johnston_ensemble_pairing is None
            else johnston_ensemble_pairing.tolist()
        ),
        "johnston_normalized_ensemble_mean_relative_error": (
            None
            if johnston_ensemble_pairing is None
            else matrix_relative_error(
                johnston_ensemble_pairing, MINKOWSKI_INVERSE
            )
        ),
        "aggregate_johnston_normalization_factor": (
            aggregate_johnston_factor
        ),
        "aggregate_johnston_normalized_pairing": (
            None
            if aggregate_johnston_pairing is None
            else aggregate_johnston_pairing.tolist()
        ),
        "aggregate_johnston_normalized_relative_error": (
            None
            if aggregate_johnston_pairing is None
            else matrix_relative_error(
                aggregate_johnston_pairing, MINKOWSKI_INVERSE
            )
        ),
    }


def summarize_grid(
    samples: list[OperatorControlSample],
    expected_signature: tuple[int, int, int],
) -> dict[str, dict[str, object]]:
    """Group common-setting samples and summarize each group."""

    grouped: dict[str, list[OperatorControlSample]] = {}
    for sample in samples:
        key = setting_key(
            sample.nonlocality_scale, sample.support_radius
        )
        grouped.setdefault(key, []).append(sample)
    return {
        key: summarize_setting(group, expected_signature)
        for key, group in sorted(grouped.items())
    }


def select_control_setting(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select by frozen gate-rate, median-error, ensemble-error priority."""

    if not summaries:
        raise ValueError("at least one control summary is required")

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        statistics = summary["metric_relative_error"]
        if not isinstance(statistics, dict):
            raise TypeError("metric statistics must be a dictionary")
        return (
            -float(summary["gate_success_rate"]),
            float(statistics["median"]),
            float(summary["ensemble_mean_relative_error"]),
            float(summary["nonlocality_scale"]),
            float(summary["support_radius"]),
            key,
        )

    return min(summaries.items(), key=score)


def select_count_normalized_control_setting(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select by count-normalized gate rate and errors."""

    if not summaries:
        raise ValueError("at least one control summary is required")

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        statistics = summary["count_normalized_metric_relative_error"]
        if not isinstance(statistics, dict):
            raise TypeError("metric statistics must be a dictionary")
        median = statistics["median"]
        aggregate_error = summary[
            "aggregate_count_normalized_relative_error"
        ]
        return (
            -float(summary["count_normalized_gate_success_rate"]),
            float("inf") if median is None else float(median),
            (
                float("inf")
                if aggregate_error is None
                else float(aggregate_error)
            ),
            float(summary["nonlocality_scale"]),
            float(summary["support_radius"]),
            key,
        )

    return min(summaries.items(), key=score)


def select_johnston_normalized_control_setting(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select by Johnston-quadratic-normalized gate rate and errors."""

    if not summaries:
        raise ValueError("at least one control summary is required")

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        statistics = summary["johnston_normalized_metric_relative_error"]
        if not isinstance(statistics, dict):
            raise TypeError("metric statistics must be a dictionary")
        median = statistics["median"]
        aggregate_error = summary[
            "aggregate_johnston_normalized_relative_error"
        ]
        return (
            -float(summary["johnston_normalized_gate_success_rate"]),
            float("inf") if median is None else float(median),
            (
                float("inf")
                if aggregate_error is None
                else float(aggregate_error)
            ),
            float(summary["nonlocality_scale"]),
            float(summary["support_radius"]),
            key,
        )

    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run the frozen development grid."""

    if args.dimension != 4:
        raise ValueError("this benchmark's operator and target metric are 4D")
    if args.events < 3:
        raise ValueError("an interval requires at least three events")
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    if args.duration <= 0.0:
        raise ValueError("duration must be positive")
    if args.block_size <= 0:
        raise ValueError("block size must be positive")
    if args.maximum_metric_error < 0.0:
        raise ValueError("maximum metric error must be nonnegative")
    scales = sorted(set(args.nonlocality_scales))
    radii = sorted(set(args.support_radii))
    if not scales or any(scale <= 0.0 for scale in scales):
        raise ValueError("nonlocality scales must be positive")
    if not radii or any(radius <= 0.0 for radius in radii):
        raise ValueError("support radii must be positive")

    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (
        coefficient * args.duration**args.dimension
    )
    ell = density ** (-1.0 / args.dimension)
    if min(scales) <= ell:
        raise ValueError(
            "every nonlocality scale must be strictly greater than ell"
        )

    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        sample
        for child in seed_sequence.spawn(args.realizations)
        for sample in reconstruct_control_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            scales,
            radii,
            args.maximum_metric_error,
            compute_johnston_quadratic=(
                args.selection_mode == "johnston_quadratic"
            ),
        )
    ]
    summaries = summarize_grid(
        samples, (1, args.dimension - 1, 0)
    )
    if args.selection_mode == "raw":
        selected_key, selected_summary = select_control_setting(summaries)
        selection_rule = (
            "maximum raw gate rate, then minimum raw median error, "
            "then minimum raw ensemble-mean error"
        )
    elif args.selection_mode == "count_normalized":
        selected_key, selected_summary = (
            select_count_normalized_control_setting(summaries)
        )
        selection_rule = (
            "maximum count-normalized gate rate, then minimum "
            "count-normalized median error, then minimum aggregate "
            "count-normalized error"
        )
    else:
        selected_key, selected_summary = (
            select_johnston_normalized_control_setting(summaries)
        )
        selection_rule = (
            "maximum Johnston-quadratic-normalized gate rate, then minimum "
            "normalized median error, then minimum aggregate normalized "
            "error"
        )
    result: dict[str, object] = {
        "status": "coordinate-probe operator control; not reconstruction",
        "pivot_selection_uses_embedding_coordinates": False,
        "probe_construction_uses_embedding_coordinates": True,
        "johnston_probe_scores_opened": False,
        "johnston_quadratic_constructed": (
            args.selection_mode == "johnston_quadratic"
        ),
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "ell": ell,
            "nonlocality_scales": scales,
            "support_radii": radii,
            "maximum_metric_error": args.maximum_metric_error,
            "seed": args.seed,
        },
        "selection_mode": args.selection_mode,
        "selection_rule": selection_rule,
        "selected_setting_key": selected_key,
        "selected_setting": selected_summary,
        "summaries": summaries,
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=int, default=5000)
    parser.add_argument("--realizations", type=int, default=20)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument(
        "--nonlocality-scales",
        type=float,
        nargs="+",
        default=[0.12, 0.14, 0.16, 0.18, 0.20],
    )
    parser.add_argument(
        "--support-radii",
        type=float,
        nargs="+",
        default=[0.36, 0.50, 0.65],
    )
    parser.add_argument("--maximum-metric-error", type=float, default=0.50)
    parser.add_argument(
        "--selection-mode",
        choices=("raw", "count_normalized", "johnston_quadratic"),
        default="raw",
    )
    parser.add_argument("--seed", type=int, default=20260720)
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
