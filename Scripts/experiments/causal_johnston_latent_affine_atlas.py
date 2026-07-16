"""Depth-filtered shared affine atlas for local Johnston lightcone charts.

Stage A11 showed that simultaneous O(3) synchronization makes chart cycles
consistent but does not repair their common-event geometry. It also exposed a
separate selector defect: a distorted global MDS neighborhood can include
causal-boundary events whose past and future lightcones are too small to support
rank three.

This Stage A12 successor applies an order-only causal-depth eligibility filter,
then fits all available local charts into one latent affine geometry. One pivot
chart fixes the global gauge. Every other affine chart map is updated against a
leave-one-chart-out consensus, with a tunable penalty toward the synchronized
O(3) initialization. The atlas gate scores actual common-event geometry,
conditioning, singular values, graph coverage, and affine cocycles before any
metric or curvature observable is opened.

Dimension, density, endpoints, rank, target radius, causal-depth threshold, and
regularization remain supplied. This is a conditional numerical oracle, not a
bare-order continuum derivation.
"""

from __future__ import annotations

import argparse
import json
import math
from collections import Counter
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_full_embedding import johnston_full_embedding_from_relation
from causal_johnston_full_multirow_metric import two_sided_averaging_targets
from causal_johnston_synchronized_atlas import (
    chart_transition_geometry_residual,
    pairwise_spatial_registrations,
    registration_graph_connected,
    synchronize_spatial_frames,
    synchronized_transition,
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
class SharedAffineLatentFit:
    linear_maps: dict[int, np.ndarray]
    translations: dict[int, np.ndarray]
    iterations: int
    converged: bool
    o3_geometry_residual_median: float
    joint_geometry_residual_median: float
    joint_geometry_residual_maximum: float
    independent_affine_residual_median: float
    affine_cocycle_maximum: float
    transform_condition_median: float
    transform_condition_maximum: float
    transform_singular_minimum: float
    transform_singular_maximum: float
    consensus_event_count: int


@dataclass(frozen=True)
class LatentAffineAtlasSample:
    regularization: float
    raw_target_count: int
    depth_eligible_target_count: int
    depth_excluded_target_count: int
    depth_retention_fraction: float
    chart_availability_fraction: float
    lightcone_too_small_count: int
    other_chart_failure_count: int
    pairwise_edge_fraction: float
    pairwise_graph_connected: bool
    fit_converged: bool
    fit_iterations: int | None
    consensus_event_count: int | None
    o3_geometry_residual_median: float | None
    independent_affine_residual_median: float | None
    joint_geometry_residual_median: float | None
    joint_geometry_residual_maximum: float | None
    transform_condition_median: float | None
    transform_condition_maximum: float | None
    transform_singular_minimum: float | None
    transform_singular_maximum: float | None
    affine_cocycle_maximum: float | None
    passes_latent_affine_atlas_gate: bool


def regularization_key(value: float) -> str:
    """Stable JSON key for one affine regularization strength."""

    return f"regularization={value:.6f}"


def chart_overlap_mask(
    reference: JohnstonLightconeEmbedding,
    moving: JohnstonLightconeEmbedding,
    registration_radius: float,
    minimum_overlap: int = 6,
) -> np.ndarray | None:
    """Return the same radius-filtered overlap used by chart registration."""

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
    return common


def initialize_affine_translations(
    charts: dict[int, JohnstonLightconeEmbedding],
    linear_maps: dict[int, np.ndarray],
    registration_radius: float,
    pivot_index: int,
) -> dict[int, np.ndarray]:
    """Solve the graph translation constraints with the pivot fixed at zero."""

    nodes = sorted(charts)
    free_nodes = [node for node in nodes if node != pivot_index]
    free_positions = {node: position for position, node in enumerate(free_nodes)}
    rows: list[np.ndarray] = []
    right_sides: list[np.ndarray] = []
    for reference_position, reference in enumerate(nodes):
        for moving in nodes[reference_position + 1 :]:
            common = chart_overlap_mask(
                charts[reference], charts[moving], registration_radius
            )
            if common is None:
                continue
            reference_global = (
                charts[reference].probes[common, 1:] @ linear_maps[reference]
            )
            moving_global = charts[moving].probes[common, 1:] @ linear_maps[moving]
            displacement = np.mean(reference_global - moving_global, axis=0)
            weight = math.sqrt(float(np.count_nonzero(common)))
            row = np.zeros(len(free_nodes))
            if moving != pivot_index:
                row[free_positions[moving]] += weight
            if reference != pivot_index:
                row[free_positions[reference]] -= weight
            rows.append(row)
            right_sides.append(weight * displacement)
    translations = {node: np.zeros(3) for node in nodes}
    if rows and free_nodes:
        design = np.stack(rows)
        targets = np.stack(right_sides)
        solution, _, _, _ = np.linalg.lstsq(design, targets, rcond=None)
        for node, position in free_positions.items():
            translations[node] = solution[position]
    return translations


def _transformed_chart(
    chart: JohnstonLightconeEmbedding,
    linear_map: np.ndarray,
    translation: np.ndarray,
) -> np.ndarray:
    return chart.probes[:, 1:] @ linear_map + translation


def _independent_affine_residual(
    reference: JohnstonLightconeEmbedding,
    moving: JohnstonLightconeEmbedding,
    common: np.ndarray,
) -> float:
    reference_spatial = reference.probes[common, 1:]
    moving_spatial = moving.probes[common, 1:]
    design = np.column_stack((moving_spatial, np.ones(np.count_nonzero(common))))
    coefficient, _, _, _ = np.linalg.lstsq(design, reference_spatial, rcond=None)
    fitted = design @ coefficient
    denominator = max(
        float(np.linalg.norm(reference_spatial - np.mean(reference_spatial, axis=0))),
        1.0e-14,
    )
    return float(np.linalg.norm(fitted - reference_spatial) / denominator)


def _joint_geometry_residual(
    reference_global: np.ndarray,
    moving_global: np.ndarray,
    common: np.ndarray,
) -> float:
    reference_overlap = reference_global[common]
    moving_overlap = moving_global[common]
    denominator = max(
        float(
            np.linalg.norm(
                reference_overlap - np.mean(reference_overlap, axis=0)
            )
        ),
        1.0e-14,
    )
    return float(np.linalg.norm(moving_overlap - reference_overlap) / denominator)


def _homogeneous_affine(
    linear_map: np.ndarray, translation: np.ndarray
) -> np.ndarray:
    transform = np.eye(4)
    transform[:3, :3] = linear_map
    transform[3, :3] = translation
    return transform


def fit_shared_affine_latent_geometry(
    charts: dict[int, JohnstonLightconeEmbedding],
    pivot_index: int,
    registration_radius: float,
    regularization: float,
    maximum_iterations: int = 50,
    tolerance: float = 1.0e-8,
) -> SharedAffineLatentFit | None:
    """Fit one pivot-anchored affine latent geometry by consensus iteration."""

    if regularization < 0.0:
        raise ValueError("regularization must be nonnegative")
    nodes = sorted(charts)
    registrations = pairwise_spatial_registrations(charts, registration_radius)
    synchronization = synchronize_spatial_frames(nodes, registrations, pivot_index)
    if synchronization is None:
        return None

    initial_linear = {
        node: synchronization.chart_to_reference[node].copy() for node in nodes
    }
    initial_translation = initialize_affine_translations(
        charts,
        initial_linear,
        registration_radius,
        pivot_index,
    )
    linear_maps = {node: value.copy() for node, value in initial_linear.items()}
    translations = {
        node: value.copy() for node, value in initial_translation.items()
    }
    converged = False
    iterations = 0
    event_count = len(next(iter(charts.values())).probes)

    for iteration in range(1, maximum_iterations + 1):
        iterations = iteration
        transformed = {
            node: _transformed_chart(
                charts[node], linear_maps[node], translations[node]
            )
            for node in nodes
        }
        consensus_sum = np.zeros((event_count, 3))
        consensus_count = np.zeros(event_count, dtype=np.int64)
        for node in nodes:
            mask = charts[node].embedded_mask
            consensus_sum[mask] += transformed[node][mask]
            consensus_count[mask] += 1

        new_linear = {node: value.copy() for node, value in linear_maps.items()}
        new_translation = {
            node: value.copy() for node, value in translations.items()
        }
        maximum_change = 0.0
        for node in nodes:
            if node == pivot_index:
                new_linear[node] = np.eye(3)
                new_translation[node] = np.zeros(3)
                continue
            mask = charts[node].embedded_mask & (consensus_count >= 2)
            if np.count_nonzero(mask) < 4:
                continue
            other_count = consensus_count[mask] - 1
            other_consensus = (
                consensus_sum[mask] - transformed[node][mask]
            ) / other_count[:, None]
            local = charts[node].probes[mask, 1:]
            design = np.column_stack((local, np.ones(len(local))))
            prior = np.vstack((initial_linear[node], initial_translation[node]))
            penalty = regularization * len(local)
            if penalty > 0.0:
                root_penalty = math.sqrt(penalty)
                augmented_design = np.vstack(
                    (design, root_penalty * np.eye(4))
                )
                augmented_target = np.vstack(
                    (other_consensus, root_penalty * prior)
                )
            else:
                augmented_design = design
                augmented_target = other_consensus
            coefficient, _, _, _ = np.linalg.lstsq(
                augmented_design, augmented_target, rcond=None
            )
            candidate_linear = coefficient[:3]
            candidate_translation = coefficient[3]
            change = max(
                float(np.linalg.norm(candidate_linear - linear_maps[node])),
                float(np.linalg.norm(candidate_translation - translations[node])),
            )
            maximum_change = max(maximum_change, change)
            new_linear[node] = candidate_linear
            new_translation[node] = candidate_translation
        linear_maps = new_linear
        translations = new_translation
        if maximum_change <= tolerance:
            converged = True
            break

    transformed = {
        node: _transformed_chart(charts[node], linear_maps[node], translations[node])
        for node in nodes
    }
    o3_residuals: list[float] = []
    joint_residuals: list[float] = []
    independent_residuals: list[float] = []
    for reference, moving in registrations:
        common = chart_overlap_mask(
            charts[reference], charts[moving], registration_radius
        )
        if common is None:
            continue
        o3_residual = chart_transition_geometry_residual(
            charts[reference],
            charts[moving],
            synchronized_transition(synchronization, reference, moving),
            registration_radius,
        )
        if o3_residual is not None:
            o3_residuals.append(o3_residual)
        joint_residuals.append(
            _joint_geometry_residual(
                transformed[reference], transformed[moving], common
            )
        )
        independent_residuals.append(
            _independent_affine_residual(
                charts[reference], charts[moving], common
            )
        )

    homogeneous = {
        node: _homogeneous_affine(linear_maps[node], translations[node])
        for node in nodes
    }
    inverses = {node: np.linalg.inv(homogeneous[node]) for node in nodes}
    cocycle_errors: list[float] = []
    for reference_position, reference in enumerate(nodes):
        for middle_position in range(reference_position + 1, len(nodes)):
            middle = nodes[middle_position]
            for moving in nodes[middle_position + 1 :]:
                moving_to_middle = homogeneous[moving] @ inverses[middle]
                middle_to_reference = homogeneous[middle] @ inverses[reference]
                moving_to_reference = homogeneous[moving] @ inverses[reference]
                cocycle_errors.append(
                    float(
                        np.linalg.norm(
                            moving_to_middle @ middle_to_reference
                            - moving_to_reference,
                            ord="fro",
                        )
                        / 2.0
                    )
                )

    singular_values = [
        np.linalg.svd(linear_maps[node], compute_uv=False) for node in nodes
    ]
    conditions = [
        float(values[0] / max(values[-1], 1.0e-14))
        for values in singular_values
    ]
    coverage = np.zeros(event_count, dtype=np.int64)
    for chart in charts.values():
        coverage[chart.embedded_mask] += 1
    return SharedAffineLatentFit(
        linear_maps=linear_maps,
        translations=translations,
        iterations=iterations,
        converged=converged,
        o3_geometry_residual_median=float(np.median(o3_residuals)),
        joint_geometry_residual_median=float(np.median(joint_residuals)),
        joint_geometry_residual_maximum=float(np.max(joint_residuals)),
        independent_affine_residual_median=float(
            np.median(independent_residuals)
        ),
        affine_cocycle_maximum=(
            0.0 if not cocycle_errors else float(np.max(cocycle_errors))
        ),
        transform_condition_median=float(np.median(conditions)),
        transform_condition_maximum=float(np.max(conditions)),
        transform_singular_minimum=float(
            min(values[-1] for values in singular_values)
        ),
        transform_singular_maximum=float(
            max(values[0] for values in singular_values)
        ),
        consensus_event_count=int(np.count_nonzero(coverage >= 2)),
    )


def reconstruct_latent_affine_atlas_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    averaging_radius: float,
    registration_radius: float,
    minimum_lightcone_count: int,
    regularizations: list[float],
    maximum_geometry_error: float,
    maximum_transform_condition: float,
    minimum_transform_singular_value: float,
    maximum_transform_singular_value: float,
    maximum_cocycle_error: float,
    minimum_edge_fraction: float,
) -> list[LatentAffineAtlasSample]:
    """Construct one depth-filtered chart carrier and scan latent fits."""

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
    charts: dict[int, JohnstonLightconeEmbedding] = {}
    failures: Counter[str] = Counter()
    for target in eligible_targets:
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
        except ValueError as error:
            failures[str(error)] += 1
    available_nodes = sorted(charts)
    registrations = pairwise_spatial_registrations(charts, registration_radius)
    possible_edges = len(eligible_targets) * (len(eligible_targets) - 1) // 2
    edge_fraction = (
        1.0 if possible_edges == 0 else len(registrations) / possible_edges
    )
    connected = registration_graph_connected(available_nodes, registrations)
    availability = (
        0.0 if not eligible_targets else len(charts) / len(eligible_targets)
    )

    samples = []
    for regularization in regularizations:
        fit = (
            None
            if pivot_index not in charts or not connected
            else fit_shared_affine_latent_geometry(
                charts,
                pivot_index,
                registration_radius,
                regularization,
            )
        )
        passes = (
            len(eligible_targets) > 1
            and availability == 1.0
            and edge_fraction >= minimum_edge_fraction
            and connected
            and fit is not None
            and fit.converged
            and fit.joint_geometry_residual_median <= maximum_geometry_error
            and fit.transform_condition_maximum <= maximum_transform_condition
            and fit.transform_singular_minimum
            >= minimum_transform_singular_value
            and fit.transform_singular_maximum
            <= maximum_transform_singular_value
            and fit.affine_cocycle_maximum <= maximum_cocycle_error
        )
        too_small = failures["pivot lightcone is too small for the spatial rank"]
        samples.append(
            LatentAffineAtlasSample(
                regularization=regularization,
                raw_target_count=len(raw_targets),
                depth_eligible_target_count=len(eligible_targets),
                depth_excluded_target_count=(
                    len(raw_targets) - len(eligible_targets)
                ),
                depth_retention_fraction=len(eligible_targets) / len(raw_targets),
                chart_availability_fraction=availability,
                lightcone_too_small_count=too_small,
                other_chart_failure_count=sum(failures.values()) - too_small,
                pairwise_edge_fraction=edge_fraction,
                pairwise_graph_connected=connected,
                fit_converged=False if fit is None else fit.converged,
                fit_iterations=None if fit is None else fit.iterations,
                consensus_event_count=(
                    None if fit is None else fit.consensus_event_count
                ),
                o3_geometry_residual_median=(
                    None if fit is None else fit.o3_geometry_residual_median
                ),
                independent_affine_residual_median=(
                    None
                    if fit is None
                    else fit.independent_affine_residual_median
                ),
                joint_geometry_residual_median=(
                    None if fit is None else fit.joint_geometry_residual_median
                ),
                joint_geometry_residual_maximum=(
                    None if fit is None else fit.joint_geometry_residual_maximum
                ),
                transform_condition_median=(
                    None if fit is None else fit.transform_condition_median
                ),
                transform_condition_maximum=(
                    None if fit is None else fit.transform_condition_maximum
                ),
                transform_singular_minimum=(
                    None if fit is None else fit.transform_singular_minimum
                ),
                transform_singular_maximum=(
                    None if fit is None else fit.transform_singular_maximum
                ),
                affine_cocycle_maximum=(
                    None if fit is None else fit.affine_cocycle_maximum
                ),
                passes_latent_affine_atlas_gate=passes,
            )
        )
    return samples


def summarize_samples(
    samples: list[LatentAffineAtlasSample],
) -> dict[str, dict[str, object]]:
    """Group latent-atlas samples by regularization strength."""

    grouped: dict[str, list[LatentAffineAtlasSample]] = {}
    for sample in samples:
        grouped.setdefault(regularization_key(sample.regularization), []).append(
            sample
        )

    def summarize(group: list[LatentAffineAtlasSample]) -> dict[str, object]:
        def statistics(attribute: str) -> dict[str, float | int | None]:
            return finite_statistics(
                [getattr(sample, attribute) for sample in group]
            )

        return {
            "regularization": group[0].regularization,
            "samples": len(group),
            "raw_target_count": statistics("raw_target_count"),
            "depth_eligible_target_count": statistics(
                "depth_eligible_target_count"
            ),
            "depth_excluded_target_count": statistics(
                "depth_excluded_target_count"
            ),
            "depth_retention_fraction": statistics("depth_retention_fraction"),
            "chart_availability_fraction": statistics(
                "chart_availability_fraction"
            ),
            "lightcone_too_small_count": statistics("lightcone_too_small_count"),
            "other_chart_failure_count": statistics("other_chart_failure_count"),
            "pairwise_edge_fraction": statistics("pairwise_edge_fraction"),
            "pairwise_graph_connected_rate": sum(
                sample.pairwise_graph_connected for sample in group
            )
            / len(group),
            "fit_convergence_rate": sum(sample.fit_converged for sample in group)
            / len(group),
            "fit_iterations": statistics("fit_iterations"),
            "consensus_event_count": statistics("consensus_event_count"),
            "o3_geometry_residual_median": statistics(
                "o3_geometry_residual_median"
            ),
            "independent_affine_residual_median": statistics(
                "independent_affine_residual_median"
            ),
            "joint_geometry_residual_median": statistics(
                "joint_geometry_residual_median"
            ),
            "joint_geometry_residual_maximum": statistics(
                "joint_geometry_residual_maximum"
            ),
            "transform_condition_median": statistics(
                "transform_condition_median"
            ),
            "transform_condition_maximum": statistics(
                "transform_condition_maximum"
            ),
            "transform_singular_minimum": statistics(
                "transform_singular_minimum"
            ),
            "transform_singular_maximum": statistics(
                "transform_singular_maximum"
            ),
            "affine_cocycle_maximum": statistics("affine_cocycle_maximum"),
            "latent_affine_atlas_gate_success_rate": sum(
                sample.passes_latent_affine_atlas_gate for sample in group
            )
            / len(group),
        }

    return {key: summarize(group) for key, group in sorted(grouped.items())}


def select_regularization(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select gate rate, then convergence, geometry, and conditioning."""

    def median(summary: dict[str, object], key: str) -> float:
        statistic = summary[key]
        if not isinstance(statistic, dict):
            raise TypeError(f"{key} must contain summary statistics")
        value = statistic["median"]
        return float("inf") if value is None else float(value)

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        return (
            -float(summary["latent_affine_atlas_gate_success_rate"]),
            -float(summary["fit_convergence_rate"]),
            median(summary, "joint_geometry_residual_median"),
            median(summary, "transform_condition_maximum"),
            float(summary["regularization"]),
            key,
        )

    if not summaries:
        raise ValueError("at least one latent-atlas summary is required")
    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run latent-atlas development or a frozen held-out evaluation."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    if args.events < 4 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    if args.duration <= 0.0 or args.block_size <= 0:
        raise ValueError("duration and block size must be positive")
    if args.averaging_radius < 0.0 or args.registration_radius <= 0.0:
        raise ValueError("chart radii must be nonnegative and positive")
    if args.minimum_lightcone_count < args.dimension - 1:
        raise ValueError("lightcone count must support the supplied spatial rank")
    regularizations = sorted(set(args.regularizations))
    if not regularizations or any(value < 0.0 for value in regularizations):
        raise ValueError("regularizations must be nonnegative")
    if not 0.0 <= args.minimum_edge_fraction <= 1.0:
        raise ValueError("minimum edge fraction must lie in [0,1]")

    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        sample
        for child in seed_sequence.spawn(args.realizations)
        for sample in reconstruct_latent_affine_atlas_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            args.averaging_radius,
            args.registration_radius,
            args.minimum_lightcone_count,
            regularizations,
            args.maximum_geometry_error,
            args.maximum_transform_condition,
            args.minimum_transform_singular_value,
            args.maximum_transform_singular_value,
            args.maximum_cocycle_error,
            args.minimum_edge_fraction,
        )
    ]
    summaries = summarize_samples(samples)
    if args.frozen_regularization is None:
        selected_key, selected_summary = select_regularization(summaries)
        status = "closed latent-affine-atlas development selection"
    else:
        if len(regularizations) != 1 or not np.isclose(
            regularizations[0], args.frozen_regularization
        ):
            raise ValueError("held-out mode requires one matching regularization")
        selected_key = regularization_key(args.frozen_regularization)
        selected_summary = summaries[selected_key]
        status = "frozen held-out latent-affine-atlas evaluation"

    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "status": status,
        "selector_uses_full_recovered_chart": True,
        "depth_filter_uses_only_causal_order": True,
        "latent_fit_uses_embedding_coordinates": False,
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
            "registration_radius": args.registration_radius,
            "minimum_lightcone_count": args.minimum_lightcone_count,
            "regularizations": regularizations,
            "maximum_geometry_error": args.maximum_geometry_error,
            "maximum_transform_condition": args.maximum_transform_condition,
            "minimum_transform_singular_value": (
                args.minimum_transform_singular_value
            ),
            "maximum_transform_singular_value": (
                args.maximum_transform_singular_value
            ),
            "maximum_cocycle_error": args.maximum_cocycle_error,
            "minimum_edge_fraction": args.minimum_edge_fraction,
            "seed": args.seed,
        },
        "selection_rule": (
            "maximum latent-atlas gate rate and convergence rate, then minimum "
            "median common-event geometry residual and transform condition"
        ),
        "selected_regularization_key": selected_key,
        "selected_regularization": selected_summary,
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
    parser.add_argument("--registration-radius", type=float, default=0.10)
    parser.add_argument("--minimum-lightcone-count", type=int, default=6)
    parser.add_argument(
        "--regularizations", type=float, nargs="+", default=[0.0, 0.01, 0.1, 1.0]
    )
    parser.add_argument("--maximum-geometry-error", type=float, default=0.25)
    parser.add_argument("--maximum-transform-condition", type=float, default=10.0)
    parser.add_argument(
        "--minimum-transform-singular-value", type=float, default=0.10
    )
    parser.add_argument(
        "--maximum-transform-singular-value", type=float, default=10.0
    )
    parser.add_argument("--maximum-cocycle-error", type=float, default=1.0e-10)
    parser.add_argument("--minimum-edge-fraction", type=float, default=0.80)
    parser.add_argument("--seed", type=int, default=20260806)
    parser.add_argument("--frozen-regularization", type=float)
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
