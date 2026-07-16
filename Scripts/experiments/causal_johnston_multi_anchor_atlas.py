"""Local multi-anchor full-interval Johnston atlas.

Stages A10-A12 showed that gauge synchronization and affine consensus cannot
repair the common-event mismatch of single-pivot lightcone charts. This Stage
A13 successor changes the coordinate construction itself. For every eligible
target it selects one count-derived past endpoint and one count-derived future
endpoint at a supplied proper-time scale, restricts the causal order to their
Alexandrov interval, and reruns Johnston's full spatial-distance completion and
MDS inside that local interval.

The resulting charts use many causal anchors rather than one past-by-future SVD
factorization. Their O(3) frames are synchronized only after construction, and
the gate scores chart availability, overlap geometry, synchronization mismatch,
cocycles, local affine controls, and emergent spatial-rank diagnostics before
metric or curvature observables are opened.

Dimension, density, global endpoints, target radius, target cap, spatial rank,
local endpoint scale, and all thresholds remain supplied. This is a conditional
numerical oracle, not a bare-order continuum derivation.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    local_affine_jacobian,
)
from causal_johnston_full_embedding import johnston_full_embedding_from_relation
from causal_johnston_full_multirow_metric import two_sided_averaging_targets
from causal_johnston_probe_metric import (
    JohnstonLightconeEmbedding,
    causal_interval_points,
    choose_intrinsic_pivot,
    intrinsic_time_and_radius_from_relation,
    minkowski_interval_coefficient,
    proper_squared_from_open_counts,
    selected_open_interval_counts,
)
from causal_johnston_synchronized_atlas import (
    chart_transition_geometry_residual,
    pairwise_spatial_registrations,
    registration_graph_connected,
    synchronize_spatial_frames,
    synchronized_transition,
)
from causal_operator_metric import finite_statistics


@dataclass(frozen=True)
class LocalMultiAnchorChart:
    embedding: JohnstonLightconeEmbedding
    lower_endpoint: int
    upper_endpoint: int
    carrier_count: int
    lower_target_proper_time: float
    target_upper_proper_time: float
    endpoint_proper_time: float


@dataclass(frozen=True)
class MultiAnchorAtlasSample:
    anchor_half_time: float
    raw_target_count: int
    depth_eligible_target_count: int
    used_target_count: int
    chart_availability_fraction: float
    carrier_count_minimum: int | None
    carrier_count_median: float | None
    lower_anchor_error_median: float | None
    upper_anchor_error_median: float | None
    pairwise_edge_fraction: float
    pairwise_graph_connected: bool
    independent_o3_residual_median: float | None
    synchronization_mismatch_median: float | None
    synchronized_geometry_residual_median: float | None
    synchronized_geometry_residual_maximum: float | None
    synchronized_cocycle_maximum: float | None
    local_affine_fit_median: float | None
    local_affine_fit_maximum: float | None
    dominant_rank_three_fraction: float | None
    passes_transition_gate: bool
    passes_full_atlas_gate: bool


def anchor_key(anchor_half_time: float) -> str:
    """Stable JSON key for one local endpoint scale."""

    return f"anchor_half_time={anchor_half_time:.6f}"


def _selected_proper_times(
    relation: np.ndarray,
    left_indices: np.ndarray,
    right_indices: np.ndarray,
    density: float,
    dimension: int,
) -> np.ndarray:
    counts = selected_open_interval_counts(
        relation, left_indices, right_indices
    )
    return np.sqrt(proper_squared_from_open_counts(counts, density, dimension))


def select_local_interval_endpoints(
    relation: np.ndarray,
    target_index: int,
    density: float,
    dimension: int,
    anchor_half_time: float,
) -> tuple[int, int, float, float, float]:
    """Select causal endpoints nearest a supplied count-derived proper time."""

    if anchor_half_time <= 0.0:
        raise ValueError("anchor half-time must be positive")
    past_indices = np.flatnonzero(relation[:, target_index])
    future_indices = np.flatnonzero(relation[target_index, :])
    if len(past_indices) == 0 or len(future_indices) == 0:
        raise ValueError("target needs nonempty causal past and future")
    past_times = _selected_proper_times(
        relation,
        past_indices,
        np.array([target_index]),
        density,
        dimension,
    )[:, 0]
    future_times = _selected_proper_times(
        relation,
        np.array([target_index]),
        future_indices,
        density,
        dimension,
    )[0]
    lower_position = int(np.argmin(np.abs(past_times - anchor_half_time)))
    upper_position = int(np.argmin(np.abs(future_times - anchor_half_time)))
    lower = int(past_indices[lower_position])
    upper = int(future_indices[upper_position])
    endpoint_time = float(
        _selected_proper_times(
            relation,
            np.array([lower]),
            np.array([upper]),
            density,
            dimension,
        )[0, 0]
    )
    return (
        lower,
        upper,
        float(past_times[lower_position]),
        float(future_times[upper_position]),
        endpoint_time,
    )


def construct_local_multi_anchor_chart(
    relation: np.ndarray,
    target_index: int,
    density: float,
    dimension: int,
    anchor_half_time: float,
    minimum_chart_events: int,
) -> LocalMultiAnchorChart:
    """Embed one count-derived local Alexandrov interval with full MDS."""

    lower, upper, lower_time, upper_time, endpoint_time = (
        select_local_interval_endpoints(
            relation,
            target_index,
            density,
            dimension,
            anchor_half_time,
        )
    )
    event_indices = np.arange(len(relation))
    carrier_mask = (
        (relation[lower, :] & relation[:, upper])
        | (event_indices == lower)
        | (event_indices == upper)
    )
    carrier = np.flatnonzero(carrier_mask)
    if len(carrier) < minimum_chart_events:
        raise ValueError("local interval is too small for full MDS")
    positions = {int(event): position for position, event in enumerate(carrier)}
    if target_index not in positions:
        raise ValueError("selected local interval does not contain its target")
    local_relation = relation[np.ix_(carrier, carrier)]
    local_embedding = johnston_full_embedding_from_relation(
        local_relation,
        density,
        dimension,
        positions[lower],
        positions[upper],
        endpoint_time,
        spatial_rank=dimension - 1,
    )
    target_local = positions[target_index]
    centered = local_embedding.coordinates - local_embedding.coordinates[target_local]
    probes = np.zeros((len(relation), dimension))
    probes[carrier] = centered
    embedded_mask = np.zeros(len(relation), dtype=bool)
    embedded_mask[carrier] = True
    intrinsic_time = np.zeros(len(relation))
    intrinsic_time[carrier] = local_embedding.intrinsic_time
    intrinsic_radius = np.zeros(len(relation))
    intrinsic_radius[carrier] = np.linalg.norm(centered[:, 1:], axis=1)
    embedding = JohnstonLightconeEmbedding(
        probes=probes,
        embedded_mask=embedded_mask,
        intrinsic_time=intrinsic_time,
        intrinsic_radius=intrinsic_radius,
        spatial_singular_values=local_embedding.spatial_eigenvalues,
        spatial_rank_gap=local_embedding.spatial_rank_gap,
        dominant_spatial_gap_rank=local_embedding.dominant_spatial_gap_rank,
        pivot_index=target_index,
        past_count=int(np.count_nonzero(local_relation[:, target_local])),
        future_count=int(np.count_nonzero(local_relation[target_local, :])),
        scale_balance_residual=local_embedding.gram_reconstruction_relative_error,
    )
    return LocalMultiAnchorChart(
        embedding=embedding,
        lower_endpoint=lower,
        upper_endpoint=upper,
        carrier_count=len(carrier),
        lower_target_proper_time=lower_time,
        target_upper_proper_time=upper_time,
        endpoint_proper_time=endpoint_time,
    )


def _median(values: list[float]) -> float | None:
    return None if not values else float(np.median(values))


def _maximum(values: list[float]) -> float | None:
    return None if not values else float(np.max(values))


def _synchronized_cocycle_maximum(
    nodes: list[int],
    synchronization,
) -> float | None:
    errors: list[float] = []
    for reference_position, reference in enumerate(nodes):
        for middle_position in range(reference_position + 1, len(nodes)):
            middle = nodes[middle_position]
            for moving in nodes[middle_position + 1 :]:
                moving_to_middle = synchronized_transition(
                    synchronization, middle, moving
                )
                middle_to_reference = synchronized_transition(
                    synchronization, reference, middle
                )
                moving_to_reference = synchronized_transition(
                    synchronization, reference, moving
                )
                errors.append(
                    float(
                        np.linalg.norm(
                            moving_to_middle @ middle_to_reference
                            - moving_to_reference,
                            ord="fro",
                        )
                        / math.sqrt(3.0)
                    )
                )
    return _maximum(errors)


def reconstruct_multi_anchor_atlas_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    averaging_radius: float,
    maximum_targets: int,
    registration_radius: float,
    affine_radius: float,
    minimum_lightcone_count: int,
    minimum_chart_events: int,
    anchor_half_times: list[float],
    maximum_geometry_error: float,
    maximum_synchronization_mismatch: float,
    maximum_affine_error: float,
    maximum_cocycle_error: float,
    minimum_edge_fraction: float,
    minimum_rank_three_fraction: float,
) -> list[MultiAnchorAtlasSample]:
    """Construct and score local full-interval charts at each anchor scale."""

    points, bottom_index, top_index = causal_interval_points(rng, events, duration)
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
    selector_chart = johnston_full_embedding_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
        spatial_rank=dimension - 1,
    )
    raw_targets = [
        int(target)
        for target in two_sided_averaging_targets(
            selector_chart.coordinates, pivot_index, averaging_radius
        )
    ]
    past_counts = np.count_nonzero(relation, axis=0)
    future_counts = np.count_nonzero(relation, axis=1)
    eligible_targets = [
        target
        for target in raw_targets
        if target == pivot_index
        or (
            past_counts[target] >= minimum_lightcone_count
            and future_counts[target] >= minimum_lightcone_count
        )
    ]
    recovered_radius = np.linalg.norm(
        selector_chart.coordinates - selector_chart.coordinates[pivot_index], axis=1
    )
    eligible_targets.sort(key=lambda target: (recovered_radius[target], target))
    used_targets = eligible_targets[:maximum_targets]

    samples = []
    for anchor_half_time in anchor_half_times:
        local_charts: dict[int, LocalMultiAnchorChart] = {}
        for target in used_targets:
            try:
                local_charts[target] = construct_local_multi_anchor_chart(
                    relation,
                    target,
                    density,
                    dimension,
                    anchor_half_time,
                    minimum_chart_events,
                )
            except (ValueError, np.linalg.LinAlgError):
                continue
        charts = {
            target: chart.embedding for target, chart in local_charts.items()
        }
        nodes = sorted(charts)
        registrations = pairwise_spatial_registrations(
            charts, registration_radius
        )
        possible_edges = len(used_targets) * (len(used_targets) - 1) // 2
        edge_fraction = (
            1.0 if possible_edges == 0 else len(registrations) / possible_edges
        )
        connected = registration_graph_connected(nodes, registrations)
        synchronization = (
            None
            if pivot_index not in charts or not connected
            else synchronize_spatial_frames(nodes, registrations, pivot_index)
        )
        independent_residuals = [
            registration.relative_residual
            for registration in registrations.values()
        ]
        geometry_residuals: list[float] = []
        if synchronization is not None:
            for reference, moving in registrations:
                residual = chart_transition_geometry_residual(
                    charts[reference],
                    charts[moving],
                    synchronized_transition(
                        synchronization, reference, moving
                    ),
                    registration_radius,
                )
                if residual is not None:
                    geometry_residuals.append(residual)

        affine_errors: list[float] = []
        for target, chart in charts.items():
            radius = np.linalg.norm(chart.probes, axis=1)
            inner_mask = chart.embedded_mask & (radius <= affine_radius)
            if np.count_nonzero(inner_mask) < max(dimension + 1, 6):
                inner_mask = chart.embedded_mask
            _, fit_error, rank, _ = local_affine_jacobian(
                points, target, chart.probes, inner_mask
            )
            if rank == dimension:
                affine_errors.append(fit_error)

        carrier_counts = [chart.carrier_count for chart in local_charts.values()]
        lower_errors = [
            abs(chart.lower_target_proper_time - anchor_half_time)
            for chart in local_charts.values()
        ]
        upper_errors = [
            abs(chart.target_upper_proper_time - anchor_half_time)
            for chart in local_charts.values()
        ]
        dominant_ranks = [
            chart.embedding.dominant_spatial_gap_rank
            for chart in local_charts.values()
        ]
        rank_three_fraction = (
            None
            if not dominant_ranks
            else sum(rank == dimension - 1 for rank in dominant_ranks)
            / len(dominant_ranks)
        )
        sync_mismatch = (
            None
            if synchronization is None
            else synchronization.edge_mismatch_median
        )
        geometry_median = _median(geometry_residuals)
        affine_median = _median(affine_errors)
        cocycle_maximum = (
            None
            if synchronization is None
            else _synchronized_cocycle_maximum(nodes, synchronization)
        )
        availability = (
            0.0 if not used_targets else len(charts) / len(used_targets)
        )
        transition_gate = (
            len(used_targets) > 1
            and availability == 1.0
            and edge_fraction >= minimum_edge_fraction
            and connected
            and synchronization is not None
            and sync_mismatch is not None
            and sync_mismatch <= maximum_synchronization_mismatch
            and geometry_median is not None
            and geometry_median <= maximum_geometry_error
            and affine_median is not None
            and affine_median <= maximum_affine_error
            and (cocycle_maximum is None or cocycle_maximum <= maximum_cocycle_error)
        )
        full_gate = (
            transition_gate
            and rank_three_fraction is not None
            and rank_three_fraction >= minimum_rank_three_fraction
        )
        samples.append(
            MultiAnchorAtlasSample(
                anchor_half_time=anchor_half_time,
                raw_target_count=len(raw_targets),
                depth_eligible_target_count=len(eligible_targets),
                used_target_count=len(used_targets),
                chart_availability_fraction=availability,
                carrier_count_minimum=(
                    None if not carrier_counts else min(carrier_counts)
                ),
                carrier_count_median=_median(
                    [float(value) for value in carrier_counts]
                ),
                lower_anchor_error_median=_median(lower_errors),
                upper_anchor_error_median=_median(upper_errors),
                pairwise_edge_fraction=edge_fraction,
                pairwise_graph_connected=connected,
                independent_o3_residual_median=_median(independent_residuals),
                synchronization_mismatch_median=sync_mismatch,
                synchronized_geometry_residual_median=geometry_median,
                synchronized_geometry_residual_maximum=_maximum(geometry_residuals),
                synchronized_cocycle_maximum=cocycle_maximum,
                local_affine_fit_median=affine_median,
                local_affine_fit_maximum=_maximum(affine_errors),
                dominant_rank_three_fraction=rank_three_fraction,
                passes_transition_gate=transition_gate,
                passes_full_atlas_gate=full_gate,
            )
        )
    return samples


def summarize_samples(
    samples: list[MultiAnchorAtlasSample],
) -> dict[str, dict[str, object]]:
    """Group multi-anchor samples by local endpoint scale."""

    grouped: dict[str, list[MultiAnchorAtlasSample]] = {}
    for sample in samples:
        grouped.setdefault(anchor_key(sample.anchor_half_time), []).append(sample)

    def summarize(group: list[MultiAnchorAtlasSample]) -> dict[str, object]:
        def statistics(attribute: str) -> dict[str, float | int | None]:
            return finite_statistics(
                [getattr(sample, attribute) for sample in group]
            )

        def rate(attribute: str) -> float:
            return sum(bool(getattr(sample, attribute)) for sample in group) / len(
                group
            )

        return {
            "anchor_half_time": group[0].anchor_half_time,
            "samples": len(group),
            "raw_target_count": statistics("raw_target_count"),
            "depth_eligible_target_count": statistics(
                "depth_eligible_target_count"
            ),
            "used_target_count": statistics("used_target_count"),
            "chart_availability_fraction": statistics(
                "chart_availability_fraction"
            ),
            "carrier_count_minimum": statistics("carrier_count_minimum"),
            "carrier_count_median": statistics("carrier_count_median"),
            "lower_anchor_error_median": statistics("lower_anchor_error_median"),
            "upper_anchor_error_median": statistics("upper_anchor_error_median"),
            "pairwise_edge_fraction": statistics("pairwise_edge_fraction"),
            "pairwise_graph_connected_rate": rate("pairwise_graph_connected"),
            "independent_o3_residual_median": statistics(
                "independent_o3_residual_median"
            ),
            "synchronization_mismatch_median": statistics(
                "synchronization_mismatch_median"
            ),
            "synchronized_geometry_residual_median": statistics(
                "synchronized_geometry_residual_median"
            ),
            "synchronized_geometry_residual_maximum": statistics(
                "synchronized_geometry_residual_maximum"
            ),
            "synchronized_cocycle_maximum": statistics(
                "synchronized_cocycle_maximum"
            ),
            "local_affine_fit_median": statistics("local_affine_fit_median"),
            "local_affine_fit_maximum": statistics("local_affine_fit_maximum"),
            "dominant_rank_three_fraction": statistics(
                "dominant_rank_three_fraction"
            ),
            "transition_gate_success_rate": rate("passes_transition_gate"),
            "full_atlas_gate_success_rate": rate("passes_full_atlas_gate"),
        }

    return {key: summarize(group) for key, group in sorted(grouped.items())}


def select_anchor_scale(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select full/transition gates, then geometry and affine controls."""

    def median(summary: dict[str, object], key: str) -> float:
        statistic = summary[key]
        if not isinstance(statistic, dict):
            raise TypeError(f"{key} must contain summary statistics")
        value = statistic["median"]
        return float("inf") if value is None else float(value)

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        return (
            -float(summary["full_atlas_gate_success_rate"]),
            -float(summary["transition_gate_success_rate"]),
            -median(summary, "chart_availability_fraction"),
            median(summary, "synchronized_geometry_residual_median"),
            median(summary, "local_affine_fit_median"),
            float(summary["anchor_half_time"]),
            key,
        )

    if not summaries:
        raise ValueError("at least one multi-anchor summary is required")
    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run multi-anchor development or one frozen held-out evaluation."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    if args.events < 4 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    if args.maximum_targets < 2:
        raise ValueError("maximum targets must permit a nontrivial atlas")
    anchor_half_times = sorted(set(args.anchor_half_times))
    if not anchor_half_times or any(value <= 0.0 for value in anchor_half_times):
        raise ValueError("anchor half-times must be positive")

    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        sample
        for child in seed_sequence.spawn(args.realizations)
        for sample in reconstruct_multi_anchor_atlas_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            args.averaging_radius,
            args.maximum_targets,
            args.registration_radius,
            args.affine_radius,
            args.minimum_lightcone_count,
            args.minimum_chart_events,
            anchor_half_times,
            args.maximum_geometry_error,
            args.maximum_synchronization_mismatch,
            args.maximum_affine_error,
            args.maximum_cocycle_error,
            args.minimum_edge_fraction,
            args.minimum_rank_three_fraction,
        )
    ]
    summaries = summarize_samples(samples)
    if args.frozen_anchor_half_time is None:
        selected_key, selected_summary = select_anchor_scale(summaries)
        status = "closed multi-anchor-atlas development selection"
    else:
        if len(anchor_half_times) != 1 or not np.isclose(
            anchor_half_times[0], args.frozen_anchor_half_time
        ):
            raise ValueError("held-out mode requires one matching anchor scale")
        selected_key = anchor_key(args.frozen_anchor_half_time)
        selected_summary = summaries[selected_key]
        status = "frozen held-out multi-anchor-atlas evaluation"

    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "status": status,
        "selector_uses_full_recovered_chart": True,
        "depth_filter_and_local_endpoints_use_only_causal_order": True,
        "transition_construction_uses_embedding_coordinates": False,
        "coordinate_affine_control_uses_embedding_coordinates": True,
        "metric_scores_opened": False,
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "global_interval_endpoints_are_supplied": True,
        "spatial_rank_is_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "averaging_radius": args.averaging_radius,
            "maximum_targets": args.maximum_targets,
            "registration_radius": args.registration_radius,
            "affine_radius": args.affine_radius,
            "minimum_lightcone_count": args.minimum_lightcone_count,
            "minimum_chart_events": args.minimum_chart_events,
            "anchor_half_times": anchor_half_times,
            "maximum_geometry_error": args.maximum_geometry_error,
            "maximum_synchronization_mismatch": (
                args.maximum_synchronization_mismatch
            ),
            "maximum_affine_error": args.maximum_affine_error,
            "maximum_cocycle_error": args.maximum_cocycle_error,
            "minimum_edge_fraction": args.minimum_edge_fraction,
            "minimum_rank_three_fraction": args.minimum_rank_three_fraction,
            "seed": args.seed,
        },
        "selection_rule": (
            "maximum full and transition gate rates, then chart availability, "
            "common-event geometry, and local affine control"
        ),
        "selected_anchor_key": selected_key,
        "selected_anchor_scale": selected_summary,
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
    parser.add_argument("--averaging-radius", type=float, default=0.075)
    parser.add_argument("--maximum-targets", type=int, default=12)
    parser.add_argument("--registration-radius", type=float, default=0.20)
    parser.add_argument("--affine-radius", type=float, default=0.20)
    parser.add_argument("--minimum-lightcone-count", type=int, default=6)
    parser.add_argument("--minimum-chart-events", type=int, default=12)
    parser.add_argument(
        "--anchor-half-times", type=float, nargs="+", default=[0.15, 0.20, 0.25]
    )
    parser.add_argument("--maximum-geometry-error", type=float, default=0.25)
    parser.add_argument(
        "--maximum-synchronization-mismatch", type=float, default=0.15
    )
    parser.add_argument("--maximum-affine-error", type=float, default=0.25)
    parser.add_argument("--maximum-cocycle-error", type=float, default=1.0e-10)
    parser.add_argument("--minimum-edge-fraction", type=float, default=0.80)
    parser.add_argument("--minimum-rank-three-fraction", type=float, default=0.80)
    parser.add_argument("--seed", type=int, default=20260808)
    parser.add_argument("--frozen-anchor-half-time", type=float)
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
