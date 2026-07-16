"""Stage A16 chart-consensus trilateration-frame selector.

Stage A15 showed that choosing anchors by proximity to an ideal scaffold in a
distorted global Johnston chart does not recover a stable frame.  This oracle
instead builds a small causal cross around an order-derived pivot, requires a
common lower anchor and four common upper anchors, and maximizes the worst
smallest singular value of the resulting frame across three nearby Johnston
lightcone charts.

Anchor construction uses only the causal relation, interval counts, supplied
dimension and density, supplied global endpoints, and a supplied anchor scale.
Known sprinkling coordinates enter only after selection, to audit the true
frame and an anchor-fitted reconstruction of held-out cross events.  This is an
external numerical oracle, not a proof or a derived tetrad theorem.
"""

from __future__ import annotations

import argparse
import itertools
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_probe_metric import (
    JohnstonLightconeEmbedding,
    causal_interval_points,
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding_from_intrinsic_data,
    minkowski_interval_coefficient,
)
from causal_operator_metric import finite_statistics
from causal_well_conditioning_audit import choose_deep_intrinsic_pivot


@dataclass(frozen=True)
class ConsensusFrame:
    anchor_indices: list[int]
    normalized_minimum_singular_value: float
    maximum_frame_condition: float
    normalized_minimum_volume: float
    maximum_relative_time_mismatch: float


@dataclass(frozen=True)
class TetradSelectorSample:
    pivot_index: int
    validation_pivot_indices: list[int]
    active_indices: list[int]
    anchor_indices: list[int]
    active_count: int
    active_chart_radius: float
    common_lower_candidate_count: int
    common_upper_candidate_count: int
    shell_lower_candidate_count: int
    shell_upper_candidate_count: int
    normalized_consensus_minimum_singular_value: float
    consensus_maximum_frame_condition: float
    normalized_consensus_minimum_volume: float
    maximum_anchor_relative_time_mismatch: float
    active_causal_coverage_fraction: float
    chart_transition_relative_error: float
    oracle_normalized_minimum_singular_value: float
    oracle_frame_condition: float
    oracle_active_reconstruction_relative_error: float
    passes_intrinsic_frame_gate: bool
    passes_oracle_frame_gate: bool
    passes_oracle_reconstruction_gate: bool
    passes_derived_tetrad_gate: bool


def _stable_nearest(indices: np.ndarray, distances: np.ndarray, count: int) -> np.ndarray:
    """Return at most ``count`` indices ordered by distance, then index."""

    if count <= 0:
        raise ValueError("candidate count must be positive")
    order = np.lexsort((indices, distances[indices]))
    return indices[order[:count]]


def nearest_causal_cross(
    relation: np.ndarray,
    embedding: JohnstonLightconeEmbedding,
    active_count: int,
) -> np.ndarray:
    """Choose the nearest order-derived lightcone events around the pivot."""

    if active_count < 3:
        raise ValueError("the causal cross requires at least three events")
    indices = np.flatnonzero(embedding.embedded_mask)
    distances = np.linalg.norm(embedding.probes, axis=1)
    active = _stable_nearest(indices, distances, active_count)
    pivot = embedding.pivot_index
    has_past = bool(np.any(relation[active, pivot]))
    has_future = bool(np.any(relation[pivot, active]))
    if pivot not in active or not has_past or not has_future:
        raise ValueError("nearest causal cross lacks a pivot, past, or future")
    return active


def validation_pivots(
    relation: np.ndarray,
    embedding: JohnstonLightconeEmbedding,
    active: np.ndarray,
) -> np.ndarray:
    """Use the center and nearest active event on each side of its cone."""

    pivot = embedding.pivot_index
    distances = np.linalg.norm(embedding.probes, axis=1)
    past = active[relation[active, pivot]]
    future = active[relation[pivot, active]]
    if len(past) == 0 or len(future) == 0:
        raise ValueError("validation pivots require both sides of the cone")
    nearest_past = _stable_nearest(past, distances, 1)[0]
    nearest_future = _stable_nearest(future, distances, 1)[0]
    return np.array([pivot, nearest_past, nearest_future], dtype=int)


def common_bracketing_pools(
    relation: np.ndarray,
    pivot_index: int,
    active: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    """Events that respectively precede or follow every active event."""

    lower = np.flatnonzero(
        np.all(relation[:, active], axis=1) & relation[:, pivot_index]
    )
    upper = np.flatnonzero(
        np.all(relation[active, :], axis=0) & relation[pivot_index, :]
    )
    return lower, upper


def temporal_shell_candidates(
    probes: np.ndarray,
    candidates: np.ndarray,
    target_time: float,
    relative_width: float,
    maximum_count: int,
) -> np.ndarray:
    """Restrict candidates to an intrinsic-time shell with stable capping."""

    if target_time == 0.0 or relative_width < 0.0:
        raise ValueError("the target time must be nonzero and width nonnegative")
    mismatch = np.abs(probes[candidates, 0] - target_time) / abs(target_time)
    shell = candidates[mismatch <= relative_width]
    shell_mismatch = np.abs(probes[shell, 0] - target_time)
    order = np.lexsort((shell, shell_mismatch))
    return shell[order[:maximum_count]]


def _frame_statistics(
    probes: np.ndarray,
    anchor_indices: np.ndarray,
) -> tuple[np.ndarray, float]:
    frame = probes[anchor_indices[1:]] - probes[anchor_indices[0]]
    singular_values = np.linalg.svd(frame, compute_uv=False)
    condition = float(singular_values[0] / singular_values[-1])
    return singular_values, condition


def select_consensus_frame(
    charts: list[JohnstonLightconeEmbedding],
    lower_candidates: np.ndarray,
    upper_candidates: np.ndarray,
    anchor_time: float,
) -> ConsensusFrame:
    """Maximize worst-chart frame rank, volume, and conditioning in order."""

    if len(charts) < 2:
        raise ValueError("chart consensus requires at least two charts")
    if len(lower_candidates) == 0 or len(upper_candidates) < 4:
        raise ValueError("a consensus frame requires one lower and four uppers")
    best_score: tuple[float, float, float, float] | None = None
    best: ConsensusFrame | None = None
    base_probes = charts[0].probes
    for lower in lower_candidates:
        for uppers in itertools.combinations(upper_candidates, 4):
            anchors = np.array((lower, *uppers), dtype=int)
            statistics = [
                _frame_statistics(chart.probes, anchors) for chart in charts
            ]
            singular_values = [item[0] for item in statistics]
            conditions = [item[1] for item in statistics]
            normalized_minimum = min(
                values[-1] for values in singular_values
            ) / anchor_time
            normalized_volume = min(
                float(np.prod(values)) for values in singular_values
            ) / anchor_time**4
            maximum_condition = max(conditions)
            target_times = np.array(
                [-anchor_time, anchor_time, anchor_time, anchor_time, anchor_time]
            )
            time_mismatch = float(
                np.max(
                    np.abs(base_probes[anchors, 0] - target_times)
                    / anchor_time
                )
            )
            score = (
                normalized_minimum,
                normalized_volume,
                -maximum_condition,
                -time_mismatch,
            )
            if best_score is None or score > best_score:
                best_score = score
                best = ConsensusFrame(
                    anchor_indices=[int(index) for index in anchors],
                    normalized_minimum_singular_value=float(normalized_minimum),
                    maximum_frame_condition=float(maximum_condition),
                    normalized_minimum_volume=float(normalized_volume),
                    maximum_relative_time_mismatch=time_mismatch,
                )
    if best is None:
        raise ArithmeticError("consensus-frame search produced no candidate")
    return best


def chart_transition_error(
    charts: list[JohnstonLightconeEmbedding],
    anchors: np.ndarray,
    evaluation: np.ndarray,
) -> float:
    """Worst anchor-fitted affine transition residual on cross events."""

    worst = 0.0
    for source_index, source in enumerate(charts):
        source_design = np.column_stack(
            (source.probes[anchors], np.ones(len(anchors)))
        )
        for target in charts[source_index + 1 :]:
            coefficients = np.linalg.solve(
                source_design, target.probes[anchors]
            )
            evaluation_design = np.column_stack(
                (source.probes[evaluation], np.ones(len(evaluation)))
            )
            predicted = evaluation_design @ coefficients
            expected = target.probes[evaluation]
            centered = expected - np.mean(expected, axis=0)
            denominator = max(float(np.linalg.norm(centered)), 1.0e-12)
            worst = max(
                worst,
                float(np.linalg.norm(predicted - expected) / denominator),
            )
    return worst


def oracle_active_reconstruction_error(
    points: np.ndarray,
    charts: list[JohnstonLightconeEmbedding],
    anchors: np.ndarray,
    evaluation: np.ndarray,
    pivot_index: int,
) -> float:
    """Worst chart-to-coordinate anchor interpolation error on held-out events."""

    true_radius = np.sqrt(
        np.mean(np.sum((points[evaluation] - points[pivot_index]) ** 2, axis=1))
    )
    denominator = max(float(true_radius), 1.0e-12)
    worst = 0.0
    for chart in charts:
        anchor_design = np.column_stack(
            (chart.probes[anchors], np.ones(len(anchors)))
        )
        coefficients = np.linalg.solve(anchor_design, points[anchors])
        evaluation_design = np.column_stack(
            (chart.probes[evaluation], np.ones(len(evaluation)))
        )
        predicted = evaluation_design @ coefficients
        root_mean_squared = np.sqrt(
            np.mean(np.sum((predicted - points[evaluation]) ** 2, axis=1))
        )
        worst = max(worst, float(root_mean_squared / denominator))
    return worst


def reconstruct_one(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    scaffold_scale: float,
    anchor_time_multiplier: float,
    active_count: int,
    minimum_lightcone_count: int,
    relative_time_shell_width: float,
    maximum_lower_candidates: int,
    maximum_upper_candidates: int,
    minimum_consensus_singular_value: float,
    maximum_consensus_condition: float,
    minimum_oracle_singular_value: float,
    maximum_oracle_condition: float,
    maximum_reconstruction_error: float,
) -> TetradSelectorSample:
    """Generate, select, and score one chart-consensus anchor frame."""

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
    pivot_index = choose_deep_intrinsic_pivot(
        relation,
        intrinsic_time,
        intrinsic_radius,
        duration,
        minimum_lightcone_count,
    )
    base = johnston_lightcone_embedding_from_intrinsic_data(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        pivot_index,
        intrinsic_time,
        intrinsic_radius,
        spatial_rank=dimension - 1,
    )
    active = nearest_causal_cross(relation, base, active_count)
    pivot_indices = validation_pivots(relation, base, active)
    charts = [
        johnston_lightcone_embedding_from_intrinsic_data(
            relation,
            density,
            dimension,
            bottom_index,
            top_index,
            int(local_pivot),
            intrinsic_time,
            intrinsic_radius,
            spatial_rank=dimension - 1,
        )
        for local_pivot in pivot_indices
    ]

    common_lower, common_upper = common_bracketing_pools(
        relation, pivot_index, active
    )
    anchor_time = anchor_time_multiplier * scaffold_scale
    lower = temporal_shell_candidates(
        base.probes,
        common_lower,
        -anchor_time,
        relative_time_shell_width,
        maximum_lower_candidates,
    )
    upper = temporal_shell_candidates(
        base.probes,
        common_upper,
        anchor_time,
        relative_time_shell_width,
        maximum_upper_candidates,
    )
    selected = select_consensus_frame(charts, lower, upper, anchor_time)
    anchors = np.array(selected.anchor_indices, dtype=int)
    coverage = float(
        np.mean(
            relation[anchors[0], active]
            & np.all(relation[np.ix_(active, anchors[1:])], axis=1)
        )
    )
    evaluation = active[~np.isin(active, pivot_indices)]
    if len(evaluation) < 4:
        raise ValueError("causal cross has too few held-out evaluation events")
    transition_error = chart_transition_error(
        charts, anchors, evaluation
    )

    true_frame = points[anchors[1:]] - points[anchors[0]]
    true_singular_values = np.linalg.svd(true_frame, compute_uv=False)
    oracle_normalized_minimum = float(
        true_singular_values[-1] / anchor_time
    )
    oracle_condition = float(
        true_singular_values[0] / true_singular_values[-1]
    )
    reconstruction_error = oracle_active_reconstruction_error(
        points, charts, anchors, evaluation, pivot_index
    )
    passes_intrinsic = bool(
        coverage == 1.0
        and selected.normalized_minimum_singular_value
        >= minimum_consensus_singular_value
        and selected.maximum_frame_condition <= maximum_consensus_condition
        and selected.maximum_relative_time_mismatch
        <= relative_time_shell_width
    )
    passes_oracle_frame = bool(
        oracle_normalized_minimum >= minimum_oracle_singular_value
        and oracle_condition <= maximum_oracle_condition
    )
    passes_reconstruction = bool(
        reconstruction_error <= maximum_reconstruction_error
    )
    return TetradSelectorSample(
        pivot_index=int(pivot_index),
        validation_pivot_indices=[int(index) for index in pivot_indices],
        active_indices=[int(index) for index in active],
        anchor_indices=selected.anchor_indices,
        active_count=len(active),
        active_chart_radius=float(
            np.max(np.linalg.norm(base.probes[active], axis=1))
        ),
        common_lower_candidate_count=len(common_lower),
        common_upper_candidate_count=len(common_upper),
        shell_lower_candidate_count=len(lower),
        shell_upper_candidate_count=len(upper),
        normalized_consensus_minimum_singular_value=(
            selected.normalized_minimum_singular_value
        ),
        consensus_maximum_frame_condition=(
            selected.maximum_frame_condition
        ),
        normalized_consensus_minimum_volume=(
            selected.normalized_minimum_volume
        ),
        maximum_anchor_relative_time_mismatch=(
            selected.maximum_relative_time_mismatch
        ),
        active_causal_coverage_fraction=coverage,
        chart_transition_relative_error=transition_error,
        oracle_normalized_minimum_singular_value=oracle_normalized_minimum,
        oracle_frame_condition=oracle_condition,
        oracle_active_reconstruction_relative_error=reconstruction_error,
        passes_intrinsic_frame_gate=passes_intrinsic,
        passes_oracle_frame_gate=passes_oracle_frame,
        passes_oracle_reconstruction_gate=passes_reconstruction,
        passes_derived_tetrad_gate=bool(
            passes_intrinsic and passes_oracle_frame and passes_reconstruction
        ),
    )


def summarize_samples(
    samples: list[TetradSelectorSample],
) -> dict[str, object]:
    """Aggregate selector, oracle-frame, and reconstruction controls."""

    def statistics(attribute: str) -> dict[str, float | int | None]:
        return finite_statistics(
            [float(getattr(sample, attribute)) for sample in samples]
        )

    def rate(attribute: str) -> float:
        return sum(bool(getattr(sample, attribute)) for sample in samples) / len(
            samples
        )

    return {
        "samples": len(samples),
        "active_count": statistics("active_count"),
        "active_chart_radius": statistics("active_chart_radius"),
        "common_lower_candidate_count": statistics(
            "common_lower_candidate_count"
        ),
        "common_upper_candidate_count": statistics(
            "common_upper_candidate_count"
        ),
        "shell_lower_candidate_count": statistics("shell_lower_candidate_count"),
        "shell_upper_candidate_count": statistics("shell_upper_candidate_count"),
        "normalized_consensus_minimum_singular_value": statistics(
            "normalized_consensus_minimum_singular_value"
        ),
        "consensus_maximum_frame_condition": statistics(
            "consensus_maximum_frame_condition"
        ),
        "maximum_anchor_relative_time_mismatch": statistics(
            "maximum_anchor_relative_time_mismatch"
        ),
        "active_causal_coverage_fraction": statistics(
            "active_causal_coverage_fraction"
        ),
        "chart_transition_relative_error": statistics(
            "chart_transition_relative_error"
        ),
        "oracle_normalized_minimum_singular_value": statistics(
            "oracle_normalized_minimum_singular_value"
        ),
        "oracle_frame_condition": statistics("oracle_frame_condition"),
        "oracle_active_reconstruction_relative_error": statistics(
            "oracle_active_reconstruction_relative_error"
        ),
        "intrinsic_frame_gate_success_rate": rate("passes_intrinsic_frame_gate"),
        "oracle_frame_gate_success_rate": rate("passes_oracle_frame_gate"),
        "oracle_reconstruction_gate_success_rate": rate(
            "passes_oracle_reconstruction_gate"
        ),
        "derived_tetrad_gate_success_rate": rate("passes_derived_tetrad_gate"),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run one development or held-out selector benchmark."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in 3+1 dimensions")
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        reconstruct_one(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            args.scaffold_scale,
            args.anchor_time_multiplier,
            args.active_count,
            args.minimum_lightcone_count,
            args.relative_time_shell_width,
            args.maximum_lower_candidates,
            args.maximum_upper_candidates,
            args.minimum_consensus_singular_value,
            args.maximum_consensus_condition,
            args.minimum_oracle_singular_value,
            args.maximum_oracle_condition,
            args.maximum_reconstruction_error,
        )
        for child in seed_sequence.spawn(args.realizations)
    ]
    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "status": f"closed {args.mode} chart-consensus tetrad-selector audit",
        "selection_uses_known_embedding": False,
        "oracle_scores_use_known_embedding": True,
        "selection_uses_order_counts_and_johnston_lightcone_charts": True,
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "global_interval_endpoints_are_supplied": True,
        "derived_tetrad_claimed": False,
        "metric_and_curvature_scores_opened": False,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "scaffold_scale": args.scaffold_scale,
            "anchor_time_multiplier": args.anchor_time_multiplier,
            "anchor_time": args.anchor_time_multiplier * args.scaffold_scale,
            "active_count": args.active_count,
            "minimum_lightcone_count": args.minimum_lightcone_count,
            "relative_time_shell_width": args.relative_time_shell_width,
            "maximum_lower_candidates": args.maximum_lower_candidates,
            "maximum_upper_candidates": args.maximum_upper_candidates,
            "minimum_consensus_singular_value": (
                args.minimum_consensus_singular_value
            ),
            "maximum_consensus_condition": args.maximum_consensus_condition,
            "minimum_oracle_singular_value": args.minimum_oracle_singular_value,
            "maximum_oracle_condition": args.maximum_oracle_condition,
            "maximum_reconstruction_error": args.maximum_reconstruction_error,
            "seed": args.seed,
        },
        "selection_rule": (
            "maximize worst-chart normalized minimum singular value, then "
            "worst-chart normalized volume, maximum condition, and intrinsic "
            "time-shell mismatch"
        ),
        "summary": summarize_samples(samples),
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=("development", "held-out"), default="development")
    parser.add_argument("--events", type=int, default=2500)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--scaffold-scale", type=float, default=0.05)
    parser.add_argument("--anchor-time-multiplier", type=float, default=8.0)
    parser.add_argument("--active-count", type=int, default=12)
    parser.add_argument("--minimum-lightcone-count", type=int, default=20)
    parser.add_argument("--relative-time-shell-width", type=float, default=0.35)
    parser.add_argument("--maximum-lower-candidates", type=int, default=10)
    parser.add_argument("--maximum-upper-candidates", type=int, default=18)
    parser.add_argument(
        "--minimum-consensus-singular-value", type=float, default=0.09
    )
    parser.add_argument("--maximum-consensus-condition", type=float, default=50.0)
    parser.add_argument(
        "--minimum-oracle-singular-value", type=float, default=0.08
    )
    parser.add_argument("--maximum-oracle-condition", type=float, default=50.0)
    parser.add_argument("--maximum-reconstruction-error", type=float, default=0.75)
    parser.add_argument("--seed", type=int, default=20260820)
    parser.add_argument("--include-samples", action="store_true")
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_experiment(args)
    payload = json.dumps(result, indent=2, sort_keys=True)
    if args.output is None:
        print(payload)
    else:
        args.output.write_text(payload + "\n", encoding="utf-8", newline="\n")


if __name__ == "__main__":
    main()
