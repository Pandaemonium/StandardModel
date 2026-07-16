"""Stage A18 overlapping frame-constrained metric/coframe atlas audit.

Stage A17 constructs one conditional local Lorentzian metric and coframe.  This
oracle builds several such patches from one causal order, selects three by
intrinsic patch quality and overlap, and fits held-out affine transitions on
their shared events.  It audits metric covariance, induced internal Lorentz
maps, affine and Lorentz cocycles, and whether coframe sign gauges can make all
transitions proper and time oriented.

The result is only a spin-prerequisite audit.  Approximate Lorentz transitions
and approximate cocycles do not define the exact central Z2 face defect needed
by the project's finite spin-lift obstruction modules.  Dimension, density,
scale, endpoints, and the chart-transported Lorentz prior remain supplied.
"""

from __future__ import annotations

import argparse
import itertools
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_frame_constrained_metric import (
    MINKOWSKI_METRIC,
    MetricConstraintSplit,
    align_charts_and_form_consensus,
    build_metric_constraint_split,
    chart_consistency_errors,
    fit_common_metric,
    induced_relation_from_metric,
    oracle_geometry_controls,
)
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_full_embedding import binary_sensitivity_specificity
from causal_johnston_probe_metric import (
    causal_interval_points,
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding_from_intrinsic_data,
    minkowski_interval_coefficient,
)
from causal_operator_metric import finite_statistics, matrix_relative_error
from causal_trilateration_tetrad_selector import (
    common_bracketing_pools,
    nearest_causal_cross,
    select_consensus_frame,
    temporal_shell_candidates,
    validation_pivots,
)
from causal_well_conditioning_audit import choose_deep_intrinsic_pivot


@dataclass(frozen=True)
class LocalFittedPatch:
    pivot_index: int
    center_distance: float
    active_indices: np.ndarray
    anchor_indices: np.ndarray
    carrier_indices: np.ndarray
    consensus_coordinates: np.ndarray
    chart_support: np.ndarray
    metric: np.ndarray
    coframe: np.ndarray
    passes_intrinsic_patch_gate: bool
    chart_leave_one_out_error: float
    chart_dispersion_error: float
    heldout_interval_error: float
    noncausal_violation_fraction: float
    causal_sensitivity: float
    causal_specificity: float
    oracle_coordinate_error: float
    oracle_metric_error: float
    metric_constraint_split: MetricConstraintSplit | None = None
    anchor_time: float | None = None
    metric_prior: np.ndarray | None = None


@dataclass(frozen=True)
class TransitionAudit:
    source_patch: int
    target_patch: int
    overlap_count: int
    training_count: int
    heldout_count: int
    affine_map: np.ndarray
    affine_heldout_relative_error: float
    affine_design_condition: float
    metric_covariance_relative_error: float
    lorentz_defect_relative_error: float
    internal_transition: np.ndarray
    oracle_affine_map_relative_error: float


@dataclass(frozen=True)
class TetradBundleSample:
    patch_radius: float
    center_candidate_count: int
    constructed_patch_count: int
    intrinsic_patch_gate_count: int
    selected_pivot_indices: list[int]
    selected_domain_counts: list[int]
    selected_core_counts: list[int]
    minimum_pair_overlap: int
    triple_overlap_count: int
    maximum_affine_transition_error: float
    maximum_affine_design_condition: float
    maximum_metric_covariance_error: float
    maximum_lorentz_defect: float
    affine_cocycle_relative_error: float
    lorentz_cocycle_relative_error: float
    orientation_time_orientation_gauge_exists: bool
    gauged_minimum_internal_determinant: float
    gauged_minimum_internal_time_component: float
    maximum_oracle_affine_map_error: float
    maximum_selected_patch_oracle_coordinate_error: float
    maximum_selected_patch_oracle_metric_error: float
    passes_overlap_gate: bool
    passes_transition_gate: bool
    passes_metric_bundle_gate: bool
    passes_spin_prerequisite_gate: bool
    exact_spin_obstruction_class_computed: bool


def radius_key(radius: float) -> str:
    """Stable JSON key for one patch-domain radius."""

    return f"patch_radius={radius:.6f}"


def homogeneous_affine_matrix(coefficients: np.ndarray) -> np.ndarray:
    """Embed row-coordinate affine coefficients into a 5 by 5 matrix."""

    if coefficients.shape != (5, 4):
        raise ValueError("affine coefficients must have shape 5 by 4")
    matrix = np.zeros((5, 5), dtype=float)
    matrix[:4, :4] = coefficients[:4]
    matrix[4, :4] = coefficients[4]
    matrix[4, 4] = 1.0
    return matrix


def stable_center_candidates(
    relation: np.ndarray,
    root_embedding: object,
    minimum_lightcone_count: int,
    maximum_candidates: int,
) -> np.ndarray:
    """Choose nearby causally deep candidate patch centers intrinsically."""

    embedded_mask = np.asarray(root_embedding.embedded_mask, dtype=bool)
    probes = np.asarray(root_embedding.probes, dtype=float)
    candidates = np.flatnonzero(embedded_mask)
    past = np.count_nonzero(relation, axis=0)
    future = np.count_nonzero(relation, axis=1)
    candidates = candidates[
        (past[candidates] >= minimum_lightcone_count)
        & (future[candidates] >= minimum_lightcone_count)
    ]
    distance = np.linalg.norm(probes, axis=1)
    order = np.lexsort((candidates, distance[candidates]))
    return candidates[order[:maximum_candidates]]


def build_local_patch(
    rng: np.random.Generator,
    relation: np.ndarray,
    points: np.ndarray,
    density: float,
    dimension: int,
    bottom_index: int,
    top_index: int,
    intrinsic_time: np.ndarray,
    intrinsic_radius: np.ndarray,
    pivot_index: int,
    center_distance: float,
    scaffold_scale: float,
    anchor_time_multiplier: float,
    active_count: int,
    relative_time_shell_width: float,
    maximum_lower_candidates: int,
    maximum_upper_candidates: int,
    metric_regularization: float,
    heldout_fraction: float,
    minimum_heldout_open_count: int,
    maximum_noncausal_pairs: int,
    minimum_evaluation_count: int,
    maximum_chart_consistency_error: float,
    maximum_interval_error: float,
    minimum_heldout_causal_sign_fraction: float,
    maximum_noncausal_violation_fraction: float,
    minimum_causal_sensitivity: float,
    minimum_causal_specificity: float,
) -> LocalFittedPatch:
    """Construct one A17 patch at an externally chosen intrinsic center."""

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
    local_pivots = validation_pivots(relation, base, active)
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
        for local_pivot in local_pivots
    ]
    common_lower, common_upper = common_bracketing_pools(relation, pivot_index, active)
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
    consensus, support, observations, _, transported_metrics = (
        align_charts_and_form_consensus(charts, anchors)
    )
    bracketed = relation[anchors[0], :] & np.all(relation[:, anchors[1:]], axis=1)
    carrier = np.flatnonzero(bracketed & (support >= 2))
    local_relation = relation[np.ix_(carrier, carrier)]
    local_counts = relation[carrier, :].astype(np.float32) @ relation[
        :, carrier
    ].astype(np.float32)
    split = build_metric_constraint_split(
        rng,
        local_relation,
        local_counts,
        density,
        dimension,
        np.array([], dtype=int),
        heldout_fraction,
        minimum_heldout_open_count,
        maximum_noncausal_pairs,
    )
    metric_prior = np.mean(transported_metrics, axis=0)
    fit = fit_common_metric(
        consensus[carrier],
        split,
        metric_prior,
        anchor_time,
        metric_regularization,
    )
    if fit.coframe is None or fit.coframe_factorization_error is None:
        raise ValueError("local metric did not admit a Lorentzian coframe")
    leave_one_out, dispersion = chart_consistency_errors(
        observations, consensus, carrier
    )
    evaluation = carrier[~np.isin(carrier, np.concatenate((active, anchors)))]
    coordinate_error, metric_error, _, _ = oracle_geometry_controls(
        points,
        consensus,
        anchors,
        evaluation,
        pivot_index,
        fit.metric,
    )
    induced = induced_relation_from_metric(
        consensus[carrier], intrinsic_time[carrier], fit.metric
    )
    sensitivity, specificity = binary_sensitivity_specificity(local_relation, induced)
    passes = bool(
        len(evaluation) >= minimum_evaluation_count
        and leave_one_out <= maximum_chart_consistency_error
        and dispersion <= maximum_chart_consistency_error
        and fit.signature == (1, 3, 0)
        and fit.coframe_factorization_error <= 1.0e-10
        and fit.heldout_interval_relative_rmse <= maximum_interval_error
        and fit.heldout_causal_sign_fraction >= minimum_heldout_causal_sign_fraction
        and fit.noncausal_violation_fraction <= maximum_noncausal_violation_fraction
        and sensitivity >= minimum_causal_sensitivity
        and specificity >= minimum_causal_specificity
    )
    return LocalFittedPatch(
        pivot_index=pivot_index,
        center_distance=center_distance,
        active_indices=active,
        anchor_indices=anchors,
        carrier_indices=carrier,
        consensus_coordinates=consensus,
        chart_support=support,
        metric=fit.metric,
        coframe=fit.coframe,
        passes_intrinsic_patch_gate=passes,
        chart_leave_one_out_error=leave_one_out,
        chart_dispersion_error=dispersion,
        heldout_interval_error=fit.heldout_interval_relative_rmse,
        noncausal_violation_fraction=fit.noncausal_violation_fraction,
        causal_sensitivity=sensitivity,
        causal_specificity=specificity,
        oracle_coordinate_error=coordinate_error,
        oracle_metric_error=metric_error,
        metric_constraint_split=split,
        anchor_time=anchor_time,
        metric_prior=metric_prior,
    )


def patch_domain(patch: LocalFittedPatch, radius: float) -> np.ndarray:
    """Events with two-chart support inside a recovered Euclidean radius."""

    centered = (
        patch.consensus_coordinates - patch.consensus_coordinates[patch.pivot_index]
    )
    distance = np.linalg.norm(centered, axis=1)
    return np.flatnonzero((patch.chart_support >= 2) & (distance <= radius))


def select_patch_triple(
    patches: list[LocalFittedPatch],
    radius: float,
) -> tuple[tuple[int, int, int], list[np.ndarray]]:
    """Select intrinsic patch gates, then triple and pairwise overlap."""

    if len(patches) < 3:
        raise ValueError("a bundle audit requires at least three patches")
    domains = [patch_domain(patch, radius) for patch in patches]
    best_score: tuple[int, int, int, int, float] | None = None
    best_indices: tuple[int, int, int] | None = None
    for indices in itertools.combinations(range(len(patches)), 3):
        selected_domains = [domains[index] for index in indices]
        pair_counts = [
            len(np.intersect1d(selected_domains[left], selected_domains[right]))
            for left, right in ((0, 1), (0, 2), (1, 2))
        ]
        triple_count = len(
            set(selected_domains[0])
            & set(selected_domains[1])
            & set(selected_domains[2])
        )
        gate_count = sum(
            patches[index].passes_intrinsic_patch_gate for index in indices
        )
        score = (
            gate_count,
            triple_count,
            min(pair_counts),
            sum(pair_counts),
            -sum(patches[index].center_distance for index in indices),
        )
        if best_score is None or score > best_score:
            best_score = score
            best_indices = indices
    if best_indices is None:
        raise ArithmeticError("patch-triple selection produced no candidate")
    return best_indices, [domains[index] for index in best_indices]


def oracle_patch_affine_map(patch: LocalFittedPatch, points: np.ndarray) -> np.ndarray:
    """Post-selection affine map from one patch gauge to known coordinates."""

    design = np.column_stack(
        (
            patch.consensus_coordinates[patch.anchor_indices],
            np.ones(len(patch.anchor_indices)),
        )
    )
    return np.linalg.solve(design, points[patch.anchor_indices])


def fit_transition(
    rng: np.random.Generator,
    source_index: int,
    target_index: int,
    source: LocalFittedPatch,
    target: LocalFittedPatch,
    source_domain: np.ndarray,
    target_domain: np.ndarray,
    points: np.ndarray,
    training_fraction: float,
) -> TransitionAudit:
    """Fit one affine transition and score untouched common events."""

    overlap = np.intersect1d(source_domain, target_domain)
    if len(overlap) < 8:
        raise ValueError("patch overlap is too small for an affine holdout")
    order = rng.permutation(len(overlap))
    training_count = max(5, int(np.floor(training_fraction * len(order))))
    training_count = min(training_count, len(order) - 1)
    train = order[:training_count]
    heldout = order[training_count:]
    design = np.column_stack(
        (source.consensus_coordinates[overlap[train]], np.ones(len(train)))
    )
    coefficients = np.linalg.lstsq(
        design,
        target.consensus_coordinates[overlap[train]],
        rcond=None,
    )[0]
    if np.linalg.matrix_rank(design) < 5:
        raise ValueError("overlap transition design is not affinely full rank")
    prediction = (
        np.column_stack(
            (
                source.consensus_coordinates[overlap[heldout]],
                np.ones(len(heldout)),
            )
        )
        @ coefficients
    )
    expected = target.consensus_coordinates[overlap[heldout]]
    denominator = max(
        float(np.linalg.norm(expected - np.mean(expected, axis=0))),
        1.0e-12,
    )
    affine_error = float(np.linalg.norm(prediction - expected) / denominator)
    linear = coefficients[:4]
    pulled_metric = linear @ target.metric @ linear.T
    metric_error = matrix_relative_error(pulled_metric, source.metric)
    internal = np.linalg.solve(source.coframe, linear @ target.coframe)
    lorentz_error = matrix_relative_error(
        internal @ MINKOWSKI_METRIC @ internal.T,
        MINKOWSKI_METRIC,
    )

    source_oracle = oracle_patch_affine_map(source, points)
    target_oracle = oracle_patch_affine_map(target, points)
    target_inverse = np.linalg.inv(target_oracle[:4])
    oracle_coefficients = np.empty((5, 4), dtype=float)
    oracle_coefficients[:4] = source_oracle[:4] @ target_inverse
    oracle_coefficients[4] = (source_oracle[4] - target_oracle[4]) @ target_inverse
    oracle_error = matrix_relative_error(coefficients, oracle_coefficients)
    return TransitionAudit(
        source_patch=source_index,
        target_patch=target_index,
        overlap_count=len(overlap),
        training_count=len(train),
        heldout_count=len(heldout),
        affine_map=homogeneous_affine_matrix(coefficients),
        affine_heldout_relative_error=affine_error,
        affine_design_condition=float(np.linalg.cond(design)),
        metric_covariance_relative_error=metric_error,
        lorentz_defect_relative_error=lorentz_error,
        internal_transition=internal,
        oracle_affine_map_relative_error=oracle_error,
    )


def diagonal_sign_matrices() -> list[np.ndarray]:
    """The 16 diagonal sign gauges preserving the internal Minkowski form."""

    return [
        np.diag(np.array(signs, dtype=float))
        for signs in itertools.product((-1.0, 1.0), repeat=4)
    ]


def orient_coframe_transitions(
    transitions: dict[tuple[int, int], TransitionAudit],
) -> tuple[bool, float, float, list[list[float]]]:
    """Search patch sign gauges for proper, time-oriented transitions."""

    signs = diagonal_sign_matrices()
    identity = np.eye(4)
    best_score: tuple[int, float, float, float] | None = None
    best_result: tuple[bool, float, float, list[list[float]]] | None = None
    for second in signs:
        for third in signs:
            gauges = [identity, second, third]
            determinants: list[float] = []
            time_components: list[float] = []
            closeness = 0.0
            proper_count = 0
            for (left, right), transition in transitions.items():
                moved = gauges[left] @ transition.internal_transition @ gauges[right]
                determinant = float(np.linalg.det(moved))
                time_component = float(moved[0, 0])
                determinants.append(determinant)
                time_components.append(time_component)
                proper_count += int(determinant > 0.0 and time_component > 0.0)
                closeness += float(np.linalg.norm(moved - identity))
            score = (
                proper_count,
                min(determinants),
                min(time_components),
                -closeness,
            )
            if best_score is None or score > best_score:
                best_score = score
                success = proper_count == len(transitions)
                best_result = (
                    success,
                    min(determinants),
                    min(time_components),
                    [np.diag(gauge).tolist() for gauge in gauges],
                )
    if best_result is None:
        raise ArithmeticError("coframe sign-gauge search produced no result")
    return best_result


def reconstruct_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    scaffold_scale: float,
    anchor_time_multiplier: float,
    active_count: int,
    minimum_lightcone_count: int,
    maximum_center_candidates: int,
    relative_time_shell_width: float,
    maximum_lower_candidates: int,
    maximum_upper_candidates: int,
    metric_regularization: float,
    heldout_fraction: float,
    minimum_heldout_open_count: int,
    maximum_noncausal_pairs: int,
    minimum_evaluation_count: int,
    maximum_chart_consistency_error: float,
    maximum_interval_error: float,
    minimum_heldout_causal_sign_fraction: float,
    maximum_noncausal_violation_fraction: float,
    minimum_causal_sensitivity: float,
    minimum_causal_specificity: float,
    patch_radii: list[float],
    transition_training_fraction: float,
    minimum_pair_overlap: int,
    minimum_triple_overlap: int,
    maximum_transition_error: float,
    maximum_transition_design_condition: float,
    maximum_metric_covariance_error: float,
    maximum_lorentz_defect: float,
    maximum_cocycle_error: float,
) -> list[TetradBundleSample]:
    """Build candidate patches once and audit every domain radius."""

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
    root_pivot = choose_deep_intrinsic_pivot(
        relation,
        intrinsic_time,
        intrinsic_radius,
        duration,
        minimum_lightcone_count,
    )
    root = johnston_lightcone_embedding_from_intrinsic_data(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        root_pivot,
        intrinsic_time,
        intrinsic_radius,
        spatial_rank=dimension - 1,
    )
    center_candidates = stable_center_candidates(
        relation, root, minimum_lightcone_count, maximum_center_candidates
    )
    center_distance = np.linalg.norm(root.probes, axis=1)
    patches: list[LocalFittedPatch] = []
    patch_seeds = rng.integers(0, 2**63 - 1, size=len(center_candidates))
    for candidate, seed in zip(center_candidates, patch_seeds, strict=True):
        try:
            patches.append(
                build_local_patch(
                    np.random.default_rng(int(seed)),
                    relation,
                    points,
                    density,
                    dimension,
                    bottom_index,
                    top_index,
                    intrinsic_time,
                    intrinsic_radius,
                    int(candidate),
                    float(center_distance[candidate]),
                    scaffold_scale,
                    anchor_time_multiplier,
                    active_count,
                    relative_time_shell_width,
                    maximum_lower_candidates,
                    maximum_upper_candidates,
                    metric_regularization,
                    heldout_fraction,
                    minimum_heldout_open_count,
                    maximum_noncausal_pairs,
                    minimum_evaluation_count,
                    maximum_chart_consistency_error,
                    maximum_interval_error,
                    minimum_heldout_causal_sign_fraction,
                    maximum_noncausal_violation_fraction,
                    minimum_causal_sensitivity,
                    minimum_causal_specificity,
                )
            )
        except (ArithmeticError, KeyError, np.linalg.LinAlgError, ValueError):
            continue
    if len(patches) < 3:
        raise ValueError("fewer than three candidate centers construct patches")

    samples: list[TetradBundleSample] = []
    for radius in patch_radii:
        indices, domains = select_patch_triple(patches, radius)
        selected = [patches[index] for index in indices]
        transitions: dict[tuple[int, int], TransitionAudit] = {}
        transition_seeds = rng.integers(0, 2**63 - 1, size=3)
        for pair_index, (left, right) in enumerate(((0, 1), (0, 2), (1, 2))):
            transitions[(left, right)] = fit_transition(
                np.random.default_rng(int(transition_seeds[pair_index])),
                left,
                right,
                selected[left],
                selected[right],
                domains[left],
                domains[right],
                points,
                transition_training_fraction,
            )
        pair_overlap = [transition.overlap_count for transition in transitions.values()]
        triple_overlap = len(set(domains[0]) & set(domains[1]) & set(domains[2]))
        affine_cocycle = matrix_relative_error(
            transitions[(0, 1)].affine_map @ transitions[(1, 2)].affine_map,
            transitions[(0, 2)].affine_map,
        )
        lorentz_cocycle = matrix_relative_error(
            transitions[(0, 1)].internal_transition
            @ transitions[(1, 2)].internal_transition,
            transitions[(0, 2)].internal_transition,
        )
        orientation, minimum_det, minimum_time, _ = orient_coframe_transitions(
            transitions
        )
        max_transition = max(
            item.affine_heldout_relative_error for item in transitions.values()
        )
        max_design_condition = max(
            item.affine_design_condition for item in transitions.values()
        )
        max_metric = max(
            item.metric_covariance_relative_error for item in transitions.values()
        )
        max_lorentz = max(
            item.lorentz_defect_relative_error for item in transitions.values()
        )
        overlap_gate = bool(
            all(patch.passes_intrinsic_patch_gate for patch in selected)
            and min(pair_overlap) >= minimum_pair_overlap
            and triple_overlap >= minimum_triple_overlap
        )
        transition_gate = bool(
            overlap_gate
            and max_transition <= maximum_transition_error
            and max_design_condition <= maximum_transition_design_condition
            and affine_cocycle <= maximum_cocycle_error
        )
        metric_bundle_gate = bool(
            transition_gate
            and max_metric <= maximum_metric_covariance_error
            and max_lorentz <= maximum_lorentz_defect
            and lorentz_cocycle <= maximum_cocycle_error
        )
        spin_prerequisite = bool(metric_bundle_gate and orientation)
        samples.append(
            TetradBundleSample(
                patch_radius=radius,
                center_candidate_count=len(center_candidates),
                constructed_patch_count=len(patches),
                intrinsic_patch_gate_count=sum(
                    patch.passes_intrinsic_patch_gate for patch in patches
                ),
                selected_pivot_indices=[patch.pivot_index for patch in selected],
                selected_domain_counts=[len(domain) for domain in domains],
                selected_core_counts=[len(patch.carrier_indices) for patch in selected],
                minimum_pair_overlap=min(pair_overlap),
                triple_overlap_count=triple_overlap,
                maximum_affine_transition_error=max_transition,
                maximum_affine_design_condition=max_design_condition,
                maximum_metric_covariance_error=max_metric,
                maximum_lorentz_defect=max_lorentz,
                affine_cocycle_relative_error=affine_cocycle,
                lorentz_cocycle_relative_error=lorentz_cocycle,
                orientation_time_orientation_gauge_exists=orientation,
                gauged_minimum_internal_determinant=minimum_det,
                gauged_minimum_internal_time_component=minimum_time,
                maximum_oracle_affine_map_error=max(
                    item.oracle_affine_map_relative_error
                    for item in transitions.values()
                ),
                maximum_selected_patch_oracle_coordinate_error=max(
                    patch.oracle_coordinate_error for patch in selected
                ),
                maximum_selected_patch_oracle_metric_error=max(
                    patch.oracle_metric_error for patch in selected
                ),
                passes_overlap_gate=overlap_gate,
                passes_transition_gate=transition_gate,
                passes_metric_bundle_gate=metric_bundle_gate,
                passes_spin_prerequisite_gate=spin_prerequisite,
                exact_spin_obstruction_class_computed=False,
            )
        )
    return samples


def summarize_samples(
    samples: list[TetradBundleSample],
) -> dict[str, dict[str, object]]:
    """Group bundle samples by patch-domain radius."""

    grouped: dict[str, list[TetradBundleSample]] = {}
    for sample in samples:
        grouped.setdefault(radius_key(sample.patch_radius), []).append(sample)

    def summarize(group: list[TetradBundleSample]) -> dict[str, object]:
        def statistics(attribute: str) -> dict[str, float | int | None]:
            return finite_statistics(
                [float(getattr(sample, attribute)) for sample in group]
            )

        def rate(attribute: str) -> float:
            return sum(bool(getattr(sample, attribute)) for sample in group) / len(
                group
            )

        return {
            "patch_radius": group[0].patch_radius,
            "samples": len(group),
            "constructed_patch_count": statistics("constructed_patch_count"),
            "intrinsic_patch_gate_count": statistics("intrinsic_patch_gate_count"),
            "minimum_pair_overlap": statistics("minimum_pair_overlap"),
            "triple_overlap_count": statistics("triple_overlap_count"),
            "maximum_affine_transition_error": statistics(
                "maximum_affine_transition_error"
            ),
            "maximum_affine_design_condition": statistics(
                "maximum_affine_design_condition"
            ),
            "maximum_metric_covariance_error": statistics(
                "maximum_metric_covariance_error"
            ),
            "maximum_lorentz_defect": statistics("maximum_lorentz_defect"),
            "affine_cocycle_relative_error": statistics(
                "affine_cocycle_relative_error"
            ),
            "lorentz_cocycle_relative_error": statistics(
                "lorentz_cocycle_relative_error"
            ),
            "maximum_oracle_affine_map_error": statistics(
                "maximum_oracle_affine_map_error"
            ),
            "maximum_selected_patch_oracle_coordinate_error": statistics(
                "maximum_selected_patch_oracle_coordinate_error"
            ),
            "maximum_selected_patch_oracle_metric_error": statistics(
                "maximum_selected_patch_oracle_metric_error"
            ),
            "orientation_time_orientation_success_rate": rate(
                "orientation_time_orientation_gauge_exists"
            ),
            "overlap_gate_success_rate": rate("passes_overlap_gate"),
            "transition_gate_success_rate": rate("passes_transition_gate"),
            "metric_bundle_gate_success_rate": rate("passes_metric_bundle_gate"),
            "spin_prerequisite_gate_success_rate": rate(
                "passes_spin_prerequisite_gate"
            ),
        }

    return {key: summarize(group) for key, group in sorted(grouped.items())}


def select_patch_radius(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select bundle gates before overlap and transition residuals."""

    def median(summary: dict[str, object], key: str) -> float:
        statistic = summary[key]
        if not isinstance(statistic, dict):
            raise TypeError(f"{key} must contain summary statistics")
        value = statistic["median"]
        return float("inf") if value is None else float(value)

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        return (
            -float(summary["spin_prerequisite_gate_success_rate"]),
            -float(summary["metric_bundle_gate_success_rate"]),
            -float(summary["transition_gate_success_rate"]),
            -float(summary["overlap_gate_success_rate"]),
            -median(summary, "triple_overlap_count"),
            median(summary, "maximum_affine_transition_error"),
            float(summary["patch_radius"]),
            key,
        )

    if not summaries:
        raise ValueError("at least one patch-radius summary is required")
    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run development radius selection or a frozen held-out audit."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in 3+1 dimensions")
    radii = sorted(set(args.patch_radii))
    if not radii or radii[0] <= 0.0:
        raise ValueError("patch radii must be positive")
    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        sample
        for child in seed_sequence.spawn(args.realizations)
        for sample in reconstruct_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            args.scaffold_scale,
            args.anchor_time_multiplier,
            args.active_count,
            args.minimum_lightcone_count,
            args.maximum_center_candidates,
            args.relative_time_shell_width,
            args.maximum_lower_candidates,
            args.maximum_upper_candidates,
            args.metric_regularization,
            args.heldout_fraction,
            args.minimum_heldout_open_count,
            args.maximum_noncausal_pairs,
            args.minimum_evaluation_count,
            args.maximum_chart_consistency_error,
            args.maximum_interval_error,
            args.minimum_heldout_causal_sign_fraction,
            args.maximum_noncausal_violation_fraction,
            args.minimum_causal_sensitivity,
            args.minimum_causal_specificity,
            radii,
            args.transition_training_fraction,
            args.minimum_pair_overlap,
            args.minimum_triple_overlap,
            args.maximum_transition_error,
            args.maximum_transition_design_condition,
            args.maximum_metric_covariance_error,
            args.maximum_lorentz_defect,
            args.maximum_cocycle_error,
        )
    ]
    summaries = summarize_samples(samples)
    if args.frozen_patch_radius is None:
        selected_key, selected_summary = select_patch_radius(summaries)
        status = "closed tetrad-bundle atlas development selection"
    else:
        if len(radii) != 1 or not np.isclose(radii[0], args.frozen_patch_radius):
            raise ValueError("held-out mode requires one matching frozen radius")
        selected_key = radius_key(args.frozen_patch_radius)
        selected_summary = summaries[selected_key]
        status = "frozen held-out tetrad-bundle atlas audit"
    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "status": status,
        "construction_uses_known_embedding": False,
        "oracle_scores_use_known_embedding": True,
        "local_metric_prior_uses_chart_transported_minkowski_forms": True,
        "orientation_and_time_orientation_use_only_coframe_sign_gauges": True,
        "exact_spin_obstruction_class_computed": False,
        "spin_prerequisite_only": True,
        "connection_and_curvature_scores_opened": False,
        "dimension_density_endpoints_and_scale_are_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "scaffold_scale": args.scaffold_scale,
            "anchor_time_multiplier": args.anchor_time_multiplier,
            "active_count": args.active_count,
            "minimum_lightcone_count": args.minimum_lightcone_count,
            "maximum_center_candidates": args.maximum_center_candidates,
            "relative_time_shell_width": args.relative_time_shell_width,
            "maximum_lower_candidates": args.maximum_lower_candidates,
            "maximum_upper_candidates": args.maximum_upper_candidates,
            "metric_regularization": args.metric_regularization,
            "heldout_fraction": args.heldout_fraction,
            "minimum_heldout_open_count": args.minimum_heldout_open_count,
            "maximum_noncausal_pairs": args.maximum_noncausal_pairs,
            "minimum_evaluation_count": args.minimum_evaluation_count,
            "maximum_chart_consistency_error": (args.maximum_chart_consistency_error),
            "maximum_interval_error": args.maximum_interval_error,
            "minimum_heldout_causal_sign_fraction": (
                args.minimum_heldout_causal_sign_fraction
            ),
            "maximum_noncausal_violation_fraction": (
                args.maximum_noncausal_violation_fraction
            ),
            "minimum_causal_sensitivity": args.minimum_causal_sensitivity,
            "minimum_causal_specificity": args.minimum_causal_specificity,
            "patch_radii": radii,
            "transition_training_fraction": args.transition_training_fraction,
            "minimum_pair_overlap": args.minimum_pair_overlap,
            "minimum_triple_overlap": args.minimum_triple_overlap,
            "maximum_transition_error": args.maximum_transition_error,
            "maximum_transition_design_condition": (
                args.maximum_transition_design_condition
            ),
            "maximum_metric_covariance_error": (args.maximum_metric_covariance_error),
            "maximum_lorentz_defect": args.maximum_lorentz_defect,
            "maximum_cocycle_error": args.maximum_cocycle_error,
            "seed": args.seed,
        },
        "selection_rule": (
            "maximize spin-prerequisite, metric-bundle, transition, and overlap "
            "gate rates, then triple overlap, transition error, and smaller radius"
        ),
        "selected_patch_radius_key": selected_key,
        "selected_patch_radius_summary": selected_summary,
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
    parser.add_argument("--scaffold-scale", type=float, default=0.05)
    parser.add_argument("--anchor-time-multiplier", type=float, default=8.0)
    parser.add_argument("--active-count", type=int, default=12)
    parser.add_argument("--minimum-lightcone-count", type=int, default=20)
    parser.add_argument("--maximum-center-candidates", type=int, default=12)
    parser.add_argument("--relative-time-shell-width", type=float, default=0.35)
    parser.add_argument("--maximum-lower-candidates", type=int, default=10)
    parser.add_argument("--maximum-upper-candidates", type=int, default=18)
    parser.add_argument("--metric-regularization", type=float, default=0.1)
    parser.add_argument("--heldout-fraction", type=float, default=0.20)
    parser.add_argument("--minimum-heldout-open-count", type=int, default=2)
    parser.add_argument("--maximum-noncausal-pairs", type=int, default=6000)
    parser.add_argument("--minimum-evaluation-count", type=int, default=24)
    parser.add_argument("--maximum-chart-consistency-error", type=float, default=0.85)
    parser.add_argument("--maximum-interval-error", type=float, default=0.20)
    parser.add_argument(
        "--minimum-heldout-causal-sign-fraction", type=float, default=0.95
    )
    parser.add_argument(
        "--maximum-noncausal-violation-fraction", type=float, default=0.10
    )
    parser.add_argument("--minimum-causal-sensitivity", type=float, default=0.80)
    parser.add_argument("--minimum-causal-specificity", type=float, default=0.95)
    parser.add_argument(
        "--patch-radii", type=float, nargs="+", default=[0.30, 0.35, 0.40]
    )
    parser.add_argument("--transition-training-fraction", type=float, default=0.70)
    parser.add_argument("--minimum-pair-overlap", type=int, default=30)
    parser.add_argument("--minimum-triple-overlap", type=int, default=15)
    parser.add_argument("--maximum-transition-error", type=float, default=0.25)
    parser.add_argument(
        "--maximum-transition-design-condition", type=float, default=50.0
    )
    parser.add_argument("--maximum-metric-covariance-error", type=float, default=0.35)
    parser.add_argument("--maximum-lorentz-defect", type=float, default=0.35)
    parser.add_argument("--maximum-cocycle-error", type=float, default=0.25)
    parser.add_argument("--seed", type=int, default=20260830)
    parser.add_argument("--frozen-patch-radius", type=float)
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
