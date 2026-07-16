"""Simultaneous synchronization of overlapping Johnston spatial frames.

Stage A10 registered every local lightcone chart independently to one pivot.
This Stage A11 transition-only successor first fits all available pairwise O(3)
overlaps, then solves for one globally synchronized spatial frame per chart with
an overlap-weighted connection Laplacian.  The resulting transitions satisfy
the cocycle algebra by construction, but they pass the atlas gate only if they
also fit the original order-derived overlap coordinates.

Known sprinkling coordinates are used only to generate the causal order and to
classify the already order-selected targets in the output.  Dimension, density,
interval endpoints, spatial rank, and mesoscopic radii remain supplied.  This
is therefore a conditional transition benchmark, not a bare-order derivation.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_full_embedding import johnston_full_embedding_from_relation
from causal_johnston_full_multirow_metric import two_sided_averaging_targets
from causal_johnston_local_atlas_metric import (
    SpatialRegistration,
    cocycle_relative_error,
    spatial_chart_registration,
)
from causal_johnston_probe_metric import (
    JohnstonLightconeEmbedding,
    causal_interval_points,
    choose_intrinsic_pivot,
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding_from_intrinsic_data,
    minkowski_interval_coefficient,
)
from causal_operator_metric import finite_statistics


@dataclass(frozen=True)
class SpatialSynchronization:
    chart_to_reference: dict[int, np.ndarray]
    edge_mismatch_median: float
    edge_mismatch_maximum: float


@dataclass(frozen=True)
class SynchronizedAtlasSample:
    registration_radius: float
    target_count: int
    strict_past_target_count: int
    strict_future_target_count: int
    spacelike_target_count: int
    chart_availability_fraction: float
    pairwise_edge_fraction: float
    pairwise_graph_connected: bool
    overlap_minimum: int | None
    overlap_median: float | None
    independent_residual_median: float | None
    independent_residual_maximum: float | None
    synchronization_mismatch_median: float | None
    synchronization_mismatch_maximum: float | None
    synchronized_geometry_residual_median: float | None
    synchronized_geometry_residual_maximum: float | None
    synchronized_cocycle_median: float | None
    synchronized_cocycle_maximum: float | None
    passes_synchronized_atlas_gate: bool


def registration_key(radius: float) -> str:
    """Stable JSON key for one overlap registration radius."""

    return f"registration_radius={radius:.6f}"


def pairwise_spatial_registrations(
    charts: dict[int, JohnstonLightconeEmbedding],
    registration_radius: float,
    minimum_overlap: int = 6,
) -> dict[tuple[int, int], SpatialRegistration]:
    """Fit every available moving-to-reference chart transition."""

    nodes = sorted(charts)
    registrations: dict[tuple[int, int], SpatialRegistration] = {}
    for reference_position, reference in enumerate(nodes):
        for moving in nodes[reference_position + 1 :]:
            registration = spatial_chart_registration(
                charts[reference],
                charts[moving],
                registration_radius,
                minimum_overlap,
            )
            if registration is not None:
                registrations[(reference, moving)] = registration
    return registrations


def registration_graph_connected(
    nodes: list[int],
    registrations: dict[tuple[int, int], SpatialRegistration],
) -> bool:
    """Whether the undirected pairwise-registration graph is connected."""

    if not nodes:
        return False
    adjacency = {node: set() for node in nodes}
    for reference, moving in registrations:
        adjacency[reference].add(moving)
        adjacency[moving].add(reference)
    seen = {nodes[0]}
    frontier = [nodes[0]]
    while frontier:
        node = frontier.pop()
        for neighbor in adjacency[node] - seen:
            seen.add(neighbor)
            frontier.append(neighbor)
    return len(seen) == len(nodes)


def synchronize_spatial_frames(
    nodes: list[int],
    registrations: dict[tuple[int, int], SpatialRegistration],
    reference_node: int,
) -> SpatialSynchronization | None:
    """Solve the overlap-weighted O(3) synchronization problem spectrally."""

    if reference_node not in nodes:
        raise ValueError("reference node must belong to the chart carrier")
    if not registration_graph_connected(nodes, registrations):
        return None
    if len(nodes) == 1:
        return SpatialSynchronization(
            chart_to_reference={reference_node: np.eye(3)},
            edge_mismatch_median=0.0,
            edge_mismatch_maximum=0.0,
        )

    positions = {node: position for position, node in enumerate(nodes)}
    laplacian = np.zeros((3 * len(nodes), 3 * len(nodes)))
    identity = np.eye(3)
    for (reference, moving), registration in registrations.items():
        reference_slice = slice(3 * positions[reference], 3 * positions[reference] + 3)
        moving_slice = slice(3 * positions[moving], 3 * positions[moving] + 3)
        weight = math.sqrt(float(registration.overlap_count))
        transition = registration.moving_to_reference
        laplacian[reference_slice, reference_slice] += weight * identity
        laplacian[moving_slice, moving_slice] += weight * identity
        laplacian[moving_slice, reference_slice] -= weight * transition
        laplacian[reference_slice, moving_slice] -= weight * transition.T

    _, eigenvectors = np.linalg.eigh(laplacian)
    relaxed = eigenvectors[:, :3]
    projected: dict[int, np.ndarray] = {}
    for node in nodes:
        position = positions[node]
        block = relaxed[3 * position : 3 * position + 3]
        left, _, right_t = np.linalg.svd(block)
        projected[node] = left @ right_t

    reference_gauge = projected[reference_node].T
    chart_to_reference = {
        node: projected[node] @ reference_gauge for node in nodes
    }
    mismatches = []
    for (reference, moving), registration in registrations.items():
        predicted = (
            chart_to_reference[moving] @ chart_to_reference[reference].T
        )
        mismatches.append(
            float(
                np.linalg.norm(
                    predicted - registration.moving_to_reference,
                    ord="fro",
                )
                / math.sqrt(3.0)
            )
        )
    return SpatialSynchronization(
        chart_to_reference=chart_to_reference,
        edge_mismatch_median=float(np.median(mismatches)),
        edge_mismatch_maximum=float(np.max(mismatches)),
    )


def synchronized_transition(
    synchronization: SpatialSynchronization,
    reference: int,
    moving: int,
) -> np.ndarray:
    """Return the synchronized transition from moving to reference."""

    return (
        synchronization.chart_to_reference[moving]
        @ synchronization.chart_to_reference[reference].T
    )


def chart_transition_geometry_residual(
    reference: JohnstonLightconeEmbedding,
    moving: JohnstonLightconeEmbedding,
    moving_to_reference: np.ndarray,
    registration_radius: float,
    minimum_overlap: int = 6,
) -> float | None:
    """Score a supplied transition on the same order-derived overlap geometry."""

    reference_radius = np.linalg.norm(reference.probes, axis=1)
    moving_radius = np.linalg.norm(moving.probes, axis=1)
    common = (
        reference.embedded_mask
        & moving.embedded_mask
        & (reference_radius <= registration_radius)
        & (moving_radius <= registration_radius)
    )
    if np.count_nonzero(common) < minimum_overlap:
        common = reference.embedded_mask & moving.embedded_mask
    if np.count_nonzero(common) < minimum_overlap:
        return None
    reference_spatial = reference.probes[common, 1:]
    moving_spatial = moving.probes[common, 1:]
    reference_centered = reference_spatial - np.mean(reference_spatial, axis=0)
    moving_centered = moving_spatial - np.mean(moving_spatial, axis=0)
    denominator = max(float(np.linalg.norm(reference_centered)), 1.0e-14)
    return float(
        np.linalg.norm(
            moving_centered @ moving_to_reference - reference_centered
        )
        / denominator
    )


def _median(values: list[float]) -> float | None:
    return None if not values else float(np.median(values))


def _maximum(values: list[float]) -> float | None:
    return None if not values else float(np.max(values))


def reconstruct_synchronized_atlas_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    averaging_radius: float,
    registration_radii: list[float],
    maximum_geometry_error: float,
    maximum_synchronization_mismatch: float,
    maximum_cocycle_error: float,
    minimum_edge_fraction: float,
) -> list[SynchronizedAtlasSample]:
    """Construct one local chart carrier and score synchronized transitions."""

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
    targets = [
        int(target)
        for target in two_sided_averaging_targets(
            selector_chart.coordinates, pivot_index, averaging_radius
        )
    ]
    charts: dict[int, JohnstonLightconeEmbedding] = {}
    for target in targets:
        try:
            charts[target] = johnston_lightcone_embedding_from_intrinsic_data(
                relation,
                density,
                dimension,
                bottom_index,
                top_index,
                target,
                intrinsic_time,
                intrinsic_radius,
                spatial_rank=dimension - 1,
            )
        except ValueError:
            continue
    available_nodes = sorted(charts)
    availability = len(available_nodes) / len(targets)
    strict_past_count = int(np.count_nonzero(relation[targets, pivot_index]))
    strict_future_count = int(np.count_nonzero(relation[pivot_index, targets]))
    spacelike_count = len(targets) - strict_past_count - strict_future_count - 1

    samples = []
    for registration_radius in registration_radii:
        registrations = pairwise_spatial_registrations(
            charts, registration_radius
        )
        possible_edges = len(targets) * (len(targets) - 1) // 2
        edge_fraction = (
            1.0 if possible_edges == 0 else len(registrations) / possible_edges
        )
        connected = registration_graph_connected(available_nodes, registrations)
        synchronization = (
            None
            if pivot_index not in charts
            else synchronize_spatial_frames(
                available_nodes, registrations, pivot_index
            )
        )
        overlap_counts = [
            registration.overlap_count for registration in registrations.values()
        ]
        independent_residuals = [
            registration.relative_residual
            for registration in registrations.values()
        ]
        geometry_residuals: list[float] = []
        cocycle_errors: list[float] = []
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
            for reference_position, reference in enumerate(available_nodes):
                for middle_position in range(
                    reference_position + 1, len(available_nodes)
                ):
                    middle = available_nodes[middle_position]
                    for moving in available_nodes[middle_position + 1 :]:
                        cocycle_errors.append(
                            cocycle_relative_error(
                                synchronized_transition(
                                    synchronization, middle, moving
                                ),
                                synchronized_transition(
                                    synchronization, reference, middle
                                ),
                                synchronized_transition(
                                    synchronization, reference, moving
                                ),
                            )
                        )
        geometry_median = _median(geometry_residuals)
        cocycle_maximum = _maximum(cocycle_errors)
        passes = (
            availability == 1.0
            and connected
            and edge_fraction >= minimum_edge_fraction
            and synchronization is not None
            and geometry_median is not None
            and geometry_median <= maximum_geometry_error
            and synchronization.edge_mismatch_median
            <= maximum_synchronization_mismatch
            and (cocycle_maximum is None or cocycle_maximum <= maximum_cocycle_error)
        )
        samples.append(
            SynchronizedAtlasSample(
                registration_radius=registration_radius,
                target_count=len(targets),
                strict_past_target_count=strict_past_count,
                strict_future_target_count=strict_future_count,
                spacelike_target_count=spacelike_count,
                chart_availability_fraction=availability,
                pairwise_edge_fraction=edge_fraction,
                pairwise_graph_connected=connected,
                overlap_minimum=(min(overlap_counts) if overlap_counts else None),
                overlap_median=_median([float(value) for value in overlap_counts]),
                independent_residual_median=_median(independent_residuals),
                independent_residual_maximum=_maximum(independent_residuals),
                synchronization_mismatch_median=(
                    None
                    if synchronization is None
                    else synchronization.edge_mismatch_median
                ),
                synchronization_mismatch_maximum=(
                    None
                    if synchronization is None
                    else synchronization.edge_mismatch_maximum
                ),
                synchronized_geometry_residual_median=geometry_median,
                synchronized_geometry_residual_maximum=_maximum(geometry_residuals),
                synchronized_cocycle_median=_median(cocycle_errors),
                synchronized_cocycle_maximum=cocycle_maximum,
                passes_synchronized_atlas_gate=passes,
            )
        )
    return samples


def summarize_samples(
    samples: list[SynchronizedAtlasSample],
) -> dict[str, dict[str, object]]:
    """Group transition samples by registration radius."""

    grouped: dict[str, list[SynchronizedAtlasSample]] = {}
    for sample in samples:
        grouped.setdefault(registration_key(sample.registration_radius), []).append(
            sample
        )

    def summarize(group: list[SynchronizedAtlasSample]) -> dict[str, object]:
        def statistics(attribute: str) -> dict[str, float | int | None]:
            return finite_statistics(
                [getattr(sample, attribute) for sample in group]
            )

        return {
            "registration_radius": group[0].registration_radius,
            "samples": len(group),
            "target_count": statistics("target_count"),
            "strict_past_target_count": statistics("strict_past_target_count"),
            "strict_future_target_count": statistics("strict_future_target_count"),
            "spacelike_target_count": statistics("spacelike_target_count"),
            "chart_availability_fraction": statistics(
                "chart_availability_fraction"
            ),
            "pairwise_edge_fraction": statistics("pairwise_edge_fraction"),
            "pairwise_graph_connected_rate": sum(
                sample.pairwise_graph_connected for sample in group
            )
            / len(group),
            "overlap_minimum": statistics("overlap_minimum"),
            "overlap_median": statistics("overlap_median"),
            "independent_residual_median": statistics(
                "independent_residual_median"
            ),
            "independent_residual_maximum": statistics(
                "independent_residual_maximum"
            ),
            "synchronization_mismatch_median": statistics(
                "synchronization_mismatch_median"
            ),
            "synchronization_mismatch_maximum": statistics(
                "synchronization_mismatch_maximum"
            ),
            "synchronized_geometry_residual_median": statistics(
                "synchronized_geometry_residual_median"
            ),
            "synchronized_geometry_residual_maximum": statistics(
                "synchronized_geometry_residual_maximum"
            ),
            "synchronized_cocycle_median": statistics(
                "synchronized_cocycle_median"
            ),
            "synchronized_cocycle_maximum": statistics(
                "synchronized_cocycle_maximum"
            ),
            "synchronized_atlas_gate_success_rate": sum(
                sample.passes_synchronized_atlas_gate for sample in group
            )
            / len(group),
        }

    return {key: summarize(group) for key, group in sorted(grouped.items())}


def select_registration_radius(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select gate rate, then synchronized geometry and mismatch medians."""

    def median(summary: dict[str, object], key: str) -> float:
        statistic = summary[key]
        if not isinstance(statistic, dict):
            raise TypeError(f"{key} must contain summary statistics")
        value = statistic["median"]
        return float("inf") if value is None else float(value)

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        return (
            -float(summary["synchronized_atlas_gate_success_rate"]),
            median(summary, "synchronized_geometry_residual_median"),
            median(summary, "synchronization_mismatch_median"),
            -median(summary, "chart_availability_fraction"),
            float(summary["registration_radius"]),
            key,
        )

    if not summaries:
        raise ValueError("at least one synchronization summary is required")
    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run synchronized-atlas development or a frozen held-out test."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    if args.events < 4 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    if args.duration <= 0.0 or args.block_size <= 0:
        raise ValueError("duration and block size must be positive")
    radii = sorted(set(args.registration_radii))
    if not radii or any(radius <= 0.0 for radius in radii):
        raise ValueError("registration radii must be positive")
    if args.averaging_radius < 0.0:
        raise ValueError("averaging radius must be nonnegative")
    thresholds = (
        args.maximum_geometry_error,
        args.maximum_synchronization_mismatch,
        args.maximum_cocycle_error,
    )
    if any(value < 0.0 for value in thresholds):
        raise ValueError("gate thresholds must be nonnegative")
    if not 0.0 <= args.minimum_edge_fraction <= 1.0:
        raise ValueError("minimum edge fraction must lie in [0,1]")

    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        sample
        for child in seed_sequence.spawn(args.realizations)
        for sample in reconstruct_synchronized_atlas_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            args.averaging_radius,
            radii,
            args.maximum_geometry_error,
            args.maximum_synchronization_mismatch,
            args.maximum_cocycle_error,
            args.minimum_edge_fraction,
        )
    ]
    summaries = summarize_samples(samples)
    if args.frozen_registration_radius is None:
        selected_key, selected_summary = select_registration_radius(summaries)
        status = "closed synchronized-atlas development selection"
    else:
        if len(radii) != 1 or not np.isclose(
            radii[0], args.frozen_registration_radius
        ):
            raise ValueError("held-out mode requires one matching frozen radius")
        selected_key = registration_key(args.frozen_registration_radius)
        selected_summary = summaries[selected_key]
        status = "frozen held-out synchronized-atlas transition evaluation"

    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "status": status,
        "selector_uses_full_recovered_chart": True,
        "transitions_use_embedding_coordinates": False,
        "metric_scores_opened": False,
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "interval_endpoints_are_supplied": True,
        "spatial_rank_is_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "averaging_radius": args.averaging_radius,
            "registration_radii": radii,
            "maximum_geometry_error": args.maximum_geometry_error,
            "maximum_synchronization_mismatch": (
                args.maximum_synchronization_mismatch
            ),
            "maximum_cocycle_error": args.maximum_cocycle_error,
            "minimum_edge_fraction": args.minimum_edge_fraction,
            "seed": args.seed,
        },
        "selection_rule": (
            "maximum synchronized-atlas gate rate, then minimum median "
            "overlap-geometry residual and synchronization mismatch"
        ),
        "selected_registration_key": selected_key,
        "selected_registration_radius": selected_summary,
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
    parser.add_argument(
        "--registration-radii",
        type=float,
        nargs="+",
        default=[0.10, 0.15, 0.20, 0.30],
    )
    parser.add_argument("--maximum-geometry-error", type=float, default=0.25)
    parser.add_argument(
        "--maximum-synchronization-mismatch", type=float, default=0.15
    )
    parser.add_argument("--maximum-cocycle-error", type=float, default=1.0e-10)
    parser.add_argument("--minimum-edge-fraction", type=float, default=0.80)
    parser.add_argument("--seed", type=int, default=20260804)
    parser.add_argument("--frozen-registration-radius", type=float)
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
