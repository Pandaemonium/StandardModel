"""Stage A15 order-volume-chain and intrinsic-scaffold audit.

Madsen's 2026 approximate-isometry theorem separates a well-conditioned
causal-set embedding into exact order preservation (F1), scale-dependent
uniform density (F2), and longest-chain/proper-time correspondence (F3).
This oracle audits sampled flat-spacetime versions of those conditions across
a mesoscopic scale window.  A development run estimates one dimensionless
longest-chain coefficient; held-out runs must use that frozen value.

The known sprinkling embedding is used to evaluate F1-F3, as required by the
definition being audited.  Separately, a Johnston order-derived chart selects
five candidate anchors near Madsen's ideal 3+1 scaffold.  Anchor selection,
frame conditioning, and active-ball causal coverage use no sprinkling
coordinate.  Dimension, density, endpoints, scales, and thresholds remain
supplied.  This is a sampled finite-density surrogate, not a proof of uniform
well-conditioning over every continuum diamond.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np
from scipy.optimize import linear_sum_assignment

from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_full_embedding import (
    binary_sensitivity_specificity,
    induced_causal_relation,
    johnston_full_embedding_from_relation,
)
from causal_johnston_probe_metric import (
    causal_interval_points,
    intrinsic_time_and_radius_from_relation,
    minkowski_interval_coefficient,
    selected_open_interval_counts,
)
from causal_operator_metric import finite_statistics


@dataclass(frozen=True)
class ScaleObservation:
    proper_time_scale: float
    pair_count: int
    count_relative_errors: np.ndarray
    density_standardized_errors: np.ndarray
    chain_coefficients: np.ndarray


@dataclass(frozen=True)
class ScaffoldAudit:
    scaffold_scale: float
    pivot_index: int
    active_count: int
    anchor_indices: list[int]
    normalized_proximity_maximum: float
    normalized_frame_minimum_singular_value: float
    frame_condition: float
    lower_precedes_upper_anchors: bool
    active_causal_coverage_fraction: float
    passes_scaffold_gate: bool


@dataclass(frozen=True)
class RawRealization:
    order_sensitivity: float
    order_specificity: float
    scales: list[ScaleObservation]
    scaffolds: list[ScaffoldAudit]


@dataclass(frozen=True)
class WellConditioningSample:
    scaffold_scale: float
    chain_coefficient: float
    minimum_scale_pair_count: int
    count_relative_error_median: float
    count_relative_error_p90: float
    density_standardized_error_p90: float
    chain_relative_error_median: float
    chain_relative_error_p90: float
    chain_scale_spread: float
    order_sensitivity: float
    order_specificity: float
    active_count: int
    normalized_anchor_proximity_maximum: float
    normalized_frame_minimum_singular_value: float
    scaffold_frame_condition: float
    scaffold_active_causal_coverage_fraction: float
    passes_f1_gate: bool
    passes_f2_gate: bool
    passes_f3_gate: bool
    passes_scaffold_gate: bool
    passes_sampled_well_conditioning_gate: bool


def scaffold_key(scale: float) -> str:
    """Stable JSON key for one anchor-frame scale."""

    return f"scaffold_scale={scale:.6f}"


def longest_chain_edge_length(
    relation: np.ndarray, lower: int, upper: int
) -> int:
    """Longest strict-chain edge count inside one comparable interval."""

    if not relation[lower, upper]:
        raise ValueError("longest-chain endpoints must be strictly comparable")
    event_indices = np.arange(len(relation))
    carrier = np.flatnonzero(
        (relation[lower, :] & relation[:, upper])
        | (event_indices == lower)
        | (event_indices == upper)
    )
    positions = {int(event): position for position, event in enumerate(carrier)}
    local = relation[np.ix_(carrier, carrier)]
    topological = np.argsort(np.count_nonzero(local, axis=0), kind="stable")
    unreachable = -len(carrier) - 1
    distance = np.full(len(carrier), unreachable, dtype=int)
    distance[positions[lower]] = 0
    for vertex in topological:
        predecessors = np.flatnonzero(local[:, vertex] & (distance >= 0))
        if len(predecessors) > 0:
            distance[vertex] = max(
                distance[vertex], int(np.max(distance[predecessors]) + 1)
            )
    result = int(distance[positions[upper]])
    if result <= 0:
        raise ArithmeticError("comparable endpoints produced no positive chain")
    return result


def _sample_scale_observation(
    rng: np.random.Generator,
    points: np.ndarray,
    relation: np.ndarray,
    density: float,
    dimension: int,
    proper_time_scale: float,
    relative_scale_width: float,
    boundary_clearance: float,
    pairs_per_scale: int,
) -> ScaleObservation:
    left, right = np.where(relation)
    displacement = points[right] - points[left]
    proper_squared = displacement[:, 0] ** 2 - np.sum(
        displacement[:, 1:] ** 2, axis=1
    )
    proper_time = np.sqrt(np.maximum(proper_squared, 0.0))
    midpoint = 0.5 * (points[left] + points[right])
    radial = np.linalg.norm(midpoint[:, 1:], axis=1)
    interior_margin = (
        np.minimum(midpoint[:, 0], 1.0 - midpoint[:, 0])
        - radial
        - 0.5 * proper_time
    )
    candidates = np.flatnonzero(
        (np.abs(proper_time - proper_time_scale)
         <= relative_scale_width * proper_time_scale)
        & (interior_margin >= boundary_clearance)
    )
    if len(candidates) < pairs_per_scale:
        raise ValueError("too few deep-interior causal pairs at a probe scale")
    selected = np.sort(
        rng.choice(candidates, size=pairs_per_scale, replace=False)
    )
    selected_left = left[selected]
    selected_right = right[selected]
    selected_time = proper_time[selected]
    open_counts = np.diag(
        selected_open_interval_counts(
            relation, selected_left, selected_right
        )
    ).astype(float)
    coefficient = minkowski_interval_coefficient(dimension)
    expected_count = density * coefficient * selected_time**dimension
    count_relative_error = np.abs(open_counts - expected_count) / np.maximum(
        expected_count, 1.0e-12
    )
    density_standardized_error = np.abs(open_counts - expected_count) / np.sqrt(
        np.maximum(expected_count, 1.0) * math.log(len(relation))
    )
    chain_edges = np.array(
        [
            longest_chain_edge_length(relation, int(lower), int(upper))
            for lower, upper in zip(
                selected_left, selected_right, strict=True
            )
        ],
        dtype=float,
    )
    chain_coefficients = chain_edges / (
        density ** (1.0 / dimension) * selected_time
    )
    return ScaleObservation(
        proper_time_scale=proper_time_scale,
        pair_count=pairs_per_scale,
        count_relative_errors=count_relative_error,
        density_standardized_errors=density_standardized_error,
        chain_coefficients=chain_coefficients,
    )


def ideal_scaffold_offsets(scale: float, dimension: int = 4) -> np.ndarray:
    """Madsen's d+1 anchor configuration in project (+---) coordinates."""

    if scale <= 0.0 or dimension < 2:
        raise ValueError("scaffold scale and dimension must be positive")
    offsets = np.zeros((dimension + 1, dimension))
    offsets[0, 0] = -8.0 * scale
    offsets[dimension, 0] = 8.0 * scale
    for spatial in range(1, dimension):
        offsets[spatial, 0] = 8.0 * scale
        offsets[spatial, spatial] = 2.0 * scale
    return offsets


def choose_deep_intrinsic_pivot(
    relation: np.ndarray,
    intrinsic_time: np.ndarray,
    intrinsic_radius: np.ndarray,
    duration: float,
    minimum_lightcone_count: int,
) -> int:
    """Choose an order-derived event nearest the interval's deep center."""

    past = np.count_nonzero(relation, axis=0)
    future = np.count_nonzero(relation, axis=1)
    eligible = (
        (past >= minimum_lightcone_count)
        & (future >= minimum_lightcone_count)
    )
    if not np.any(eligible):
        raise ValueError("no event satisfies the deep-pivot lightcone count")
    score = (
        np.abs(intrinsic_time - 0.5 * duration) + intrinsic_radius
    ) / duration
    score[~eligible] = np.inf
    return int(np.argmin(score))


def audit_recovered_scaffold(
    relation: np.ndarray,
    recovered_coordinates: np.ndarray,
    pivot_index: int,
    scaffold_scale: float,
    maximum_normalized_proximity: float,
    minimum_normalized_singular_value: float,
    maximum_frame_condition: float,
    minimum_active_count: int,
    minimum_active_coverage: float,
) -> ScaffoldAudit:
    """Select five intrinsic anchors and audit conditioning and cone coverage."""

    dimension = recovered_coordinates.shape[1]
    if dimension != 4:
        raise ValueError("the scaffold audit is frozen in 3+1 dimensions")
    centered = recovered_coordinates - recovered_coordinates[pivot_index]
    ideal = ideal_scaffold_offsets(scaffold_scale, dimension)
    cost = np.linalg.norm(
        ideal[:, None, :] - centered[None, :, :], axis=2
    )
    forbidden_cost = 1.0e6
    cost[0, ~relation[:, pivot_index]] = forbidden_cost
    not_future = ~relation[pivot_index, :]
    cost[1:, not_future] = forbidden_cost
    rows, columns = linear_sum_assignment(cost)
    anchors = columns[np.argsort(rows)]
    assigned_cost = cost[np.arange(dimension + 1), anchors]
    if np.any(assigned_cost >= 0.5 * forbidden_cost):
        raise ValueError("no temporally admissible recovered scaffold exists")

    normalized_proximity = float(np.max(assigned_cost) / scaffold_scale)
    frame = centered[anchors[1:]] - centered[anchors[0]]
    singular_values = np.linalg.svd(frame, compute_uv=False)
    normalized_minimum = float(np.min(singular_values) / scaffold_scale)
    frame_condition = float(np.max(singular_values) / np.min(singular_values))
    active = np.flatnonzero(
        np.linalg.norm(centered, axis=1) <= 2.0 * scaffold_scale
    )
    lower_precedes_upper = bool(
        all(relation[anchors[0], anchor] for anchor in anchors[1:])
    )
    covered = [
        bool(
            relation[anchors[0], event]
            and all(relation[event, anchor] for anchor in anchors[1:])
        )
        for event in active
    ]
    coverage = 0.0 if not covered else float(np.mean(covered))
    passes = (
        len(active) >= minimum_active_count
        and normalized_proximity <= maximum_normalized_proximity
        and normalized_minimum >= minimum_normalized_singular_value
        and frame_condition <= maximum_frame_condition
        and lower_precedes_upper
        and coverage >= minimum_active_coverage
    )
    return ScaffoldAudit(
        scaffold_scale=scaffold_scale,
        pivot_index=pivot_index,
        active_count=len(active),
        anchor_indices=[int(anchor) for anchor in anchors],
        normalized_proximity_maximum=normalized_proximity,
        normalized_frame_minimum_singular_value=normalized_minimum,
        frame_condition=frame_condition,
        lower_precedes_upper_anchors=lower_precedes_upper,
        active_causal_coverage_fraction=coverage,
        passes_scaffold_gate=passes,
    )


def reconstruct_raw_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    proper_time_scales: list[float],
    relative_scale_width: float,
    boundary_clearance: float,
    pairs_per_scale: int,
    scaffold_scales: list[float],
    minimum_lightcone_count: int,
    maximum_normalized_proximity: float,
    minimum_normalized_singular_value: float,
    maximum_frame_condition: float,
    minimum_active_count: int,
    minimum_active_coverage: float,
) -> RawRealization:
    """Generate one embedding audit and all intrinsic scaffold candidates."""

    points, bottom_index, top_index = causal_interval_points(
        rng, events, duration
    )
    relation = causal_relation_matrix(points, block_size)
    induced = induced_causal_relation(points)
    order_sensitivity, order_specificity = binary_sensitivity_specificity(
        relation, induced
    )
    coefficient = minkowski_interval_coefficient(dimension)
    density = events / (coefficient * duration**dimension)
    scales = [
        _sample_scale_observation(
            rng,
            points,
            relation,
            density,
            dimension,
            scale,
            relative_scale_width,
            boundary_clearance,
            pairs_per_scale,
        )
        for scale in proper_time_scales
    ]

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
    embedding = johnston_full_embedding_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
        spatial_rank=dimension - 1,
    )
    scaffolds = [
        audit_recovered_scaffold(
            relation,
            embedding.coordinates,
            pivot_index,
            scale,
            maximum_normalized_proximity,
            minimum_normalized_singular_value,
            maximum_frame_condition,
            minimum_active_count,
            minimum_active_coverage,
        )
        for scale in scaffold_scales
    ]
    return RawRealization(
        order_sensitivity=order_sensitivity,
        order_specificity=order_specificity,
        scales=scales,
        scaffolds=scaffolds,
    )


def estimate_chain_coefficient(raw: list[RawRealization]) -> float:
    """Development-only robust coefficient for longest-chain proper time."""

    values = np.concatenate(
        [scale.chain_coefficients for item in raw for scale in item.scales]
    )
    if len(values) == 0 or np.any(values <= 0.0):
        raise ValueError("chain calibration requires positive observations")
    return float(np.median(values))


def score_raw_realization(
    raw: RawRealization,
    chain_coefficient: float,
    maximum_count_relative_p90: float,
    maximum_density_standardized_p90: float,
    maximum_chain_relative_p90: float,
    maximum_chain_scale_spread: float,
) -> list[WellConditioningSample]:
    """Apply frozen F1-F3 thresholds to every scaffold candidate."""

    count_errors = np.concatenate(
        [scale.count_relative_errors for scale in raw.scales]
    )
    density_errors = np.concatenate(
        [scale.density_standardized_errors for scale in raw.scales]
    )
    chain_errors = np.concatenate(
        [
            np.abs(scale.chain_coefficients / chain_coefficient - 1.0)
            for scale in raw.scales
        ]
    )
    scale_medians = np.array(
        [np.median(scale.chain_coefficients) for scale in raw.scales]
    )
    chain_scale_spread = float(
        np.max(np.abs(scale_medians / chain_coefficient - 1.0))
    )
    count_p90 = float(np.quantile(count_errors, 0.90))
    density_p90 = float(np.quantile(density_errors, 0.90))
    chain_p90 = float(np.quantile(chain_errors, 0.90))
    passes_f1 = bool(
        np.isclose(raw.order_sensitivity, 1.0)
        and np.isclose(raw.order_specificity, 1.0)
    )
    passes_f2 = bool(
        count_p90 <= maximum_count_relative_p90
        and density_p90 <= maximum_density_standardized_p90
    )
    passes_f3 = bool(
        chain_p90 <= maximum_chain_relative_p90
        and chain_scale_spread <= maximum_chain_scale_spread
    )
    return [
        WellConditioningSample(
            scaffold_scale=scaffold.scaffold_scale,
            chain_coefficient=chain_coefficient,
            minimum_scale_pair_count=min(
                scale.pair_count for scale in raw.scales
            ),
            count_relative_error_median=float(np.median(count_errors)),
            count_relative_error_p90=count_p90,
            density_standardized_error_p90=density_p90,
            chain_relative_error_median=float(np.median(chain_errors)),
            chain_relative_error_p90=chain_p90,
            chain_scale_spread=chain_scale_spread,
            order_sensitivity=raw.order_sensitivity,
            order_specificity=raw.order_specificity,
            active_count=scaffold.active_count,
            normalized_anchor_proximity_maximum=(
                scaffold.normalized_proximity_maximum
            ),
            normalized_frame_minimum_singular_value=(
                scaffold.normalized_frame_minimum_singular_value
            ),
            scaffold_frame_condition=scaffold.frame_condition,
            scaffold_active_causal_coverage_fraction=(
                scaffold.active_causal_coverage_fraction
            ),
            passes_f1_gate=passes_f1,
            passes_f2_gate=passes_f2,
            passes_f3_gate=passes_f3,
            passes_scaffold_gate=scaffold.passes_scaffold_gate,
            passes_sampled_well_conditioning_gate=bool(
                passes_f1
                and passes_f2
                and passes_f3
                and scaffold.passes_scaffold_gate
            ),
        )
        for scaffold in raw.scaffolds
    ]


def summarize_samples(
    samples: list[WellConditioningSample],
) -> dict[str, dict[str, object]]:
    """Group well-conditioning samples by intrinsic scaffold scale."""

    grouped: dict[str, list[WellConditioningSample]] = {}
    for sample in samples:
        grouped.setdefault(scaffold_key(sample.scaffold_scale), []).append(sample)

    def summarize(group: list[WellConditioningSample]) -> dict[str, object]:
        def statistics(attribute: str) -> dict[str, float | int | None]:
            return finite_statistics(
                [getattr(sample, attribute) for sample in group]
            )

        def rate(attribute: str) -> float:
            return sum(bool(getattr(sample, attribute)) for sample in group) / len(
                group
            )

        return {
            "scaffold_scale": group[0].scaffold_scale,
            "samples": len(group),
            "minimum_scale_pair_count": statistics("minimum_scale_pair_count"),
            "count_relative_error_median": statistics(
                "count_relative_error_median"
            ),
            "count_relative_error_p90": statistics("count_relative_error_p90"),
            "density_standardized_error_p90": statistics(
                "density_standardized_error_p90"
            ),
            "chain_relative_error_median": statistics(
                "chain_relative_error_median"
            ),
            "chain_relative_error_p90": statistics("chain_relative_error_p90"),
            "chain_scale_spread": statistics("chain_scale_spread"),
            "active_count": statistics("active_count"),
            "normalized_anchor_proximity_maximum": statistics(
                "normalized_anchor_proximity_maximum"
            ),
            "normalized_frame_minimum_singular_value": statistics(
                "normalized_frame_minimum_singular_value"
            ),
            "scaffold_frame_condition": statistics("scaffold_frame_condition"),
            "scaffold_active_causal_coverage_fraction": statistics(
                "scaffold_active_causal_coverage_fraction"
            ),
            "f1_gate_success_rate": rate("passes_f1_gate"),
            "f2_gate_success_rate": rate("passes_f2_gate"),
            "f3_gate_success_rate": rate("passes_f3_gate"),
            "scaffold_gate_success_rate": rate("passes_scaffold_gate"),
            "sampled_well_conditioning_gate_success_rate": rate(
                "passes_sampled_well_conditioning_gate"
            ),
        }

    return {key: summarize(group) for key, group in sorted(grouped.items())}


def select_scaffold_scale(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select full/scaffold gates, then coverage, conditioning, and proximity."""

    def median(summary: dict[str, object], key: str) -> float:
        statistic = summary[key]
        if not isinstance(statistic, dict):
            raise TypeError(f"{key} must contain summary statistics")
        value = statistic["median"]
        return float("inf") if value is None else float(value)

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        return (
            -float(summary["sampled_well_conditioning_gate_success_rate"]),
            -float(summary["scaffold_gate_success_rate"]),
            -median(summary, "scaffold_active_causal_coverage_fraction"),
            median(summary, "scaffold_frame_condition"),
            median(summary, "normalized_anchor_proximity_maximum"),
            float(summary["scaffold_scale"]),
            key,
        )

    if not summaries:
        raise ValueError("at least one scaffold summary is required")
    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run development calibration or a fully frozen held-out audit."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    proper_time_scales = sorted(set(args.proper_time_scales))
    scaffold_scales = sorted(set(args.scaffold_scales))
    if not proper_time_scales or not scaffold_scales:
        raise ValueError("probe and scaffold scale lists must be nonempty")
    if any(scale <= 0.0 for scale in proper_time_scales + scaffold_scales):
        raise ValueError("all scales must be positive")

    seed_sequence = np.random.SeedSequence(args.seed)
    raw = [
        reconstruct_raw_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            proper_time_scales,
            args.relative_scale_width,
            args.boundary_clearance,
            args.pairs_per_scale,
            scaffold_scales,
            args.minimum_lightcone_count,
            args.maximum_normalized_proximity,
            args.minimum_normalized_singular_value,
            args.maximum_frame_condition,
            args.minimum_active_count,
            args.minimum_active_coverage,
        )
        for child in seed_sequence.spawn(args.realizations)
    ]
    if args.frozen_chain_coefficient is None:
        chain_coefficient = estimate_chain_coefficient(raw)
        status = "closed well-conditioning development calibration"
    else:
        chain_coefficient = args.frozen_chain_coefficient
        status = "frozen held-out well-conditioning audit"
    samples = [
        sample
        for item in raw
        for sample in score_raw_realization(
            item,
            chain_coefficient,
            args.maximum_count_relative_p90,
            args.maximum_density_standardized_p90,
            args.maximum_chain_relative_p90,
            args.maximum_chain_scale_spread,
        )
    ]
    summaries = summarize_samples(samples)
    if args.frozen_scaffold_scale is None:
        selected_key, selected_summary = select_scaffold_scale(summaries)
    else:
        if len(scaffold_scales) != 1 or not np.isclose(
            scaffold_scales[0], args.frozen_scaffold_scale
        ):
            raise ValueError("held-out mode requires one frozen scaffold scale")
        selected_key = scaffold_key(args.frozen_scaffold_scale)
        selected_summary = summaries[selected_key]

    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "status": status,
        "f1_f2_f3_audit_uses_known_embedding": True,
        "scaffold_selection_uses_known_embedding": False,
        "scaffold_selection_uses_order_derived_johnston_chart": True,
        "uniform_all_diamonds_claimed": False,
        "metric_and_curvature_scores_opened": False,
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "global_interval_endpoints_are_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "proper_time_scales": proper_time_scales,
            "relative_scale_width": args.relative_scale_width,
            "boundary_clearance": args.boundary_clearance,
            "pairs_per_scale": args.pairs_per_scale,
            "scaffold_scales": scaffold_scales,
            "minimum_lightcone_count": args.minimum_lightcone_count,
            "maximum_count_relative_p90": args.maximum_count_relative_p90,
            "maximum_density_standardized_p90": (
                args.maximum_density_standardized_p90
            ),
            "maximum_chain_relative_p90": args.maximum_chain_relative_p90,
            "maximum_chain_scale_spread": args.maximum_chain_scale_spread,
            "maximum_normalized_proximity": args.maximum_normalized_proximity,
            "minimum_normalized_singular_value": (
                args.minimum_normalized_singular_value
            ),
            "maximum_frame_condition": args.maximum_frame_condition,
            "minimum_active_count": args.minimum_active_count,
            "minimum_active_coverage": args.minimum_active_coverage,
            "seed": args.seed,
        },
        "chain_coefficient": chain_coefficient,
        "chain_coefficient_was_frozen": args.frozen_chain_coefficient is not None,
        "selection_rule": (
            "maximum full and scaffold gate rates, then active causal coverage, "
            "frame condition, anchor proximity, and smaller scaffold scale"
        ),
        "selected_scaffold_key": selected_key,
        "selected_scaffold_summary": selected_summary,
        "summaries": summaries,
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=int, default=2500)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument(
        "--proper-time-scales", type=float, nargs="+", default=[0.25, 0.30, 0.35, 0.40]
    )
    parser.add_argument("--relative-scale-width", type=float, default=0.075)
    parser.add_argument("--boundary-clearance", type=float, default=0.02)
    parser.add_argument("--pairs-per-scale", type=int, default=24)
    parser.add_argument(
        "--scaffold-scales", type=float, nargs="+", default=[0.03, 0.04, 0.05]
    )
    parser.add_argument("--minimum-lightcone-count", type=int, default=20)
    parser.add_argument("--maximum-count-relative-p90", type=float, default=0.60)
    parser.add_argument(
        "--maximum-density-standardized-p90", type=float, default=1.0
    )
    parser.add_argument("--maximum-chain-relative-p90", type=float, default=0.35)
    parser.add_argument("--maximum-chain-scale-spread", type=float, default=0.20)
    parser.add_argument("--maximum-normalized-proximity", type=float, default=1.50)
    parser.add_argument(
        "--minimum-normalized-singular-value", type=float, default=0.25
    )
    parser.add_argument("--maximum-frame-condition", type=float, default=50.0)
    parser.add_argument("--minimum-active-count", type=int, default=8)
    parser.add_argument("--minimum-active-coverage", type=float, default=0.95)
    parser.add_argument("--seed", type=int, default=20260820)
    parser.add_argument("--frozen-chain-coefficient", type=float)
    parser.add_argument("--frozen-scaffold-scale", type=float)
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
    else:
        print(encoded)


if __name__ == "__main__":
    main()
