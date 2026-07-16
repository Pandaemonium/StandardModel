"""Independent validation of order-derived compact quadratic probes.

This Stage A7 experiment compares two causal-order constructions of the
Lorentzian quadratic field about an order-selected pivot:

* a pointwise interval-volume proper-time estimate;
* the basis-gauge-invariant quadratic of Johnston lightcone probes.

Known embedding coordinates score the probes only after construction. No
causal-operator row, metric pairing, or normalization factor is computed here.
Dimension, density, interval endpoints, and spatial rank remain supplied. This
is an external numerical oracle, not a bare-graph reconstruction or proof.
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
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding_from_relation,
    lorentzian_quadratic_probe,
    minkowski_interval_coefficient,
    selected_open_interval_counts,
)
from causal_operator_metric import (
    compact_coordinate_probes,
    finite_statistics,
)


@dataclass(frozen=True)
class QuadraticProbeSample:
    support_radius: float
    interval_quadratic_relative_error: float
    johnston_quadratic_relative_error: float
    interval_inner_relative_error: float
    johnston_inner_relative_error: float
    johnston_quadratic_correlation: float | None
    johnston_to_oracle_norm_ratio: float
    pivot_intrinsic_time: float
    pivot_intrinsic_radius: float
    pivot_past_count: int
    pivot_future_count: int
    spatial_rank_gap: float
    dominant_spatial_gap_rank: int | None
    passes_probe_gate: bool


def vector_relative_error(
    actual: np.ndarray,
    expected: np.ndarray,
    mask: np.ndarray,
) -> float:
    """Relative Euclidean error on a selected vector carrier."""

    if actual.shape != expected.shape or actual.shape != mask.shape:
        raise ValueError("vectors and mask must have identical shapes")
    selected_actual = actual[mask]
    selected_expected = expected[mask]
    denominator = float(np.linalg.norm(selected_expected))
    if denominator <= 1.0e-14:
        return float("inf")
    return float(
        np.linalg.norm(selected_actual - selected_expected) / denominator
    )


def selected_correlation(
    actual: np.ndarray,
    expected: np.ndarray,
    mask: np.ndarray,
) -> float | None:
    """Pearson correlation on a mask, or none for a degenerate vector."""

    left = actual[mask]
    right = expected[mask]
    if len(left) < 2 or np.std(left) <= 1.0e-14 or np.std(right) <= 1.0e-14:
        return None
    return float(np.corrcoef(left, right)[0, 1])


def reconstruct_quadratic_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    support_radii: list[float],
    maximum_probe_error: float,
) -> list[QuadraticProbeSample]:
    """Construct and score both quadratic probes on one sprinkling."""

    points, bottom_index, top_index = causal_interval_points(
        rng, events, duration
    )
    relation = causal_relation_matrix(points, block_size)
    coefficient = minkowski_interval_coefficient(dimension)
    density = events / (coefficient * duration**dimension)
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
    past = relation[:, pivot_index]
    past_indices = np.flatnonzero(past)
    counts_to_pivot = np.zeros(events, dtype=np.int64)
    counts_to_pivot[past_indices] = selected_open_interval_counts(
        relation, past_indices, np.array([pivot_index])
    )[:, 0]
    oracle_centered = points - points[pivot_index]
    oracle_radius = np.linalg.norm(oracle_centered, axis=1)

    samples: list[QuadraticProbeSample] = []
    for support_radius in support_radii:
        johnston_probes = compact_lightcone_probes(
            embedding, support_radius
        )
        oracle_probes = compact_coordinate_probes(
            points, pivot_index, support_radius
        )
        johnston_quadratic = lorentzian_quadratic_probe(johnston_probes)
        oracle_quadratic = lorentzian_quadratic_probe(oracle_probes)
        interval_quadratic = intrinsic_compact_quadratic_probe(
            relation,
            counts_to_pivot,
            density,
            dimension,
            intrinsic_time,
            pivot_index,
            support_radius,
        )
        support_mask = past & (oracle_radius < support_radius)
        inner_mask = past & (oracle_radius <= support_radius / 2.0)
        interval_error = vector_relative_error(
            interval_quadratic, oracle_quadratic, support_mask
        )
        johnston_error = vector_relative_error(
            johnston_quadratic, oracle_quadratic, support_mask
        )
        interval_inner_error = vector_relative_error(
            interval_quadratic, oracle_quadratic, inner_mask
        )
        johnston_inner_error = vector_relative_error(
            johnston_quadratic, oracle_quadratic, inner_mask
        )
        oracle_norm = float(np.linalg.norm(oracle_quadratic[support_mask]))
        johnston_norm = float(
            np.linalg.norm(johnston_quadratic[support_mask])
        )
        norm_ratio = (
            float("inf")
            if oracle_norm <= 1.0e-14
            else johnston_norm / oracle_norm
        )
        samples.append(
            QuadraticProbeSample(
                support_radius=support_radius,
                interval_quadratic_relative_error=interval_error,
                johnston_quadratic_relative_error=johnston_error,
                interval_inner_relative_error=interval_inner_error,
                johnston_inner_relative_error=johnston_inner_error,
                johnston_quadratic_correlation=selected_correlation(
                    johnston_quadratic, oracle_quadratic, support_mask
                ),
                johnston_to_oracle_norm_ratio=norm_ratio,
                pivot_intrinsic_time=float(intrinsic_time[pivot_index]),
                pivot_intrinsic_radius=float(intrinsic_radius[pivot_index]),
                pivot_past_count=int(np.count_nonzero(past)),
                pivot_future_count=int(
                    np.count_nonzero(relation[pivot_index, :])
                ),
                spatial_rank_gap=embedding.spatial_rank_gap,
                dominant_spatial_gap_rank=(
                    embedding.dominant_spatial_gap_rank
                ),
                passes_probe_gate=(
                    johnston_error <= maximum_probe_error
                    and johnston_inner_error <= maximum_probe_error
                ),
            )
        )
    return samples


def support_key(support_radius: float) -> str:
    return f"support={support_radius:.6f}"


def summarize_support(
    samples: list[QuadraticProbeSample],
) -> dict[str, object]:
    """Summarize one support radius across realizations."""

    return {
        "support_radius": samples[0].support_radius,
        "samples": len(samples),
        "probe_gate_success_rate": (
            sum(sample.passes_probe_gate for sample in samples) / len(samples)
        ),
        "interval_quadratic_relative_error": finite_statistics(
            [sample.interval_quadratic_relative_error for sample in samples]
        ),
        "johnston_quadratic_relative_error": finite_statistics(
            [sample.johnston_quadratic_relative_error for sample in samples]
        ),
        "interval_inner_relative_error": finite_statistics(
            [sample.interval_inner_relative_error for sample in samples]
        ),
        "johnston_inner_relative_error": finite_statistics(
            [sample.johnston_inner_relative_error for sample in samples]
        ),
        "johnston_quadratic_correlation": finite_statistics(
            [sample.johnston_quadratic_correlation for sample in samples]
        ),
        "johnston_to_oracle_norm_ratio": finite_statistics(
            [sample.johnston_to_oracle_norm_ratio for sample in samples]
        ),
    }


def summarize_grid(
    samples: list[QuadraticProbeSample],
) -> dict[str, dict[str, object]]:
    grouped: dict[str, list[QuadraticProbeSample]] = {}
    for sample in samples:
        grouped.setdefault(
            support_key(sample.support_radius), []
        ).append(sample)
    return {
        key: summarize_support(group)
        for key, group in sorted(grouped.items())
    }


def select_support(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select by probe-pass rate, then Johnston overall and inner errors."""

    if not summaries:
        raise ValueError("at least one support summary is required")

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        overall = summary["johnston_quadratic_relative_error"]
        inner = summary["johnston_inner_relative_error"]
        if not isinstance(overall, dict) or not isinstance(inner, dict):
            raise TypeError("quadratic error summaries must be dictionaries")
        return (
            -float(summary["probe_gate_success_rate"]),
            float(overall["median"]),
            float(inner["median"]),
            float(summary["support_radius"]),
            key,
        )

    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    if args.events < 3 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    if args.duration <= 0.0 or args.block_size <= 0:
        raise ValueError("duration and block size must be positive")
    radii = sorted(set(args.support_radii))
    if not radii or any(radius <= 0.0 for radius in radii):
        raise ValueError("support radii must be positive")
    if args.maximum_probe_error < 0.0:
        raise ValueError("maximum probe error must be nonnegative")

    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (
        coefficient * args.duration**args.dimension
    )
    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        sample
        for child in seed_sequence.spawn(args.realizations)
        for sample in reconstruct_quadratic_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            radii,
            args.maximum_probe_error,
        )
    ]
    summaries = summarize_grid(samples)
    selected_key, selected_summary = select_support(summaries)
    result: dict[str, object] = {
        "status": "quadratic-probe validation only; not metric reconstruction",
        "operator_scores_opened": False,
        "probe_construction_uses_embedding_coordinates": False,
        "pivot_selection_uses_embedding_coordinates": False,
        "scoring_uses_embedding_coordinates": True,
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "spatial_rank_is_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "support_radii": radii,
            "maximum_probe_error": args.maximum_probe_error,
            "seed": args.seed,
        },
        "selection_rule": (
            "maximum probe-gate rate, then minimum Johnston median overall "
            "error, then minimum Johnston median inner error"
        ),
        "selected_support_key": selected_key,
        "selected_support": selected_summary,
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
        "--support-radii",
        type=float,
        nargs="+",
        default=[0.36, 0.50, 0.65],
    )
    parser.add_argument("--maximum-probe-error", type=float, default=0.25)
    parser.add_argument("--seed", type=int, default=20260723)
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
