"""Stage A21 exact global-affine flat tetrad-bundle control.

Stage A20 synchronized three independently represented local metrics but left
nonzero affine and internal cocycle residuals. This flat-space successor fits
three chart-to-global affine maps from overlap fit events. Pair transitions are
then defined as exact ratios of those maps, one pooled constant metric is fitted
in the global gauge, and every local metric/coframe is its exact pullback.

Selector and untouched test slices independently audit whether this algebraic
exactness still represents overlap coordinates and count-derived intervals.
The construction is intentionally a Minkowski control: one constant global
metric cannot represent curvature. Dimension, density, endpoints, scale, and a
transported Lorentz prior remain supplied. Floating-point cocycles do not define
an exact graph spin-obstruction class.
"""

from __future__ import annotations

import argparse
import itertools
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path
from types import SimpleNamespace

import numpy as np

from causal_compatible_tetrad_bundle import (
    ThreeWayTransition,
    fit_three_way_transition,
)
from causal_frame_constrained_metric import (
    MINKOWSKI_METRIC,
    factor_lorentzian_metric,
    metric_signature,
    symmetric_matrix_to_vector,
    symmetric_quadratic_features,
    symmetric_vector_to_matrix,
)
from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_probe_metric import (
    causal_interval_points,
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding_from_intrinsic_data,
    minkowski_interval_coefficient,
)
from causal_operator_metric import finite_statistics, matrix_relative_error
from causal_synchronized_tetrad_bundle import (
    LocalMetricHoldoutSplit,
    coordinate_eligible_patch,
    evaluate_local_metric,
    split_local_metric_holdout,
)
from causal_tetrad_bundle_atlas import (
    LocalFittedPatch,
    TransitionAudit,
    build_local_patch,
    homogeneous_affine_matrix,
    oracle_patch_affine_map,
    orient_coframe_transitions,
    patch_domain,
    stable_center_candidates,
)
from causal_well_conditioning_audit import choose_deep_intrinsic_pivot


@dataclass(frozen=True)
class GlobalAffineTripleAudit:
    indices: tuple[int, int, int]
    global_maps: list[np.ndarray]
    exact_transitions: dict[tuple[int, int], np.ndarray]
    global_metric: np.ndarray
    local_metrics: list[np.ndarray]
    local_coframes: list[np.ndarray | None]
    minimum_pair_overlap: int
    triple_overlap_count: int
    maximum_selector_transition_error: float
    global_gauge_design_condition: float
    maximum_global_map_linear_condition: float
    global_metric_signature: tuple[int, int, int]
    global_metric_condition: float
    maximum_selector_interval_error: float
    minimum_selector_causal_sign_fraction: float
    maximum_selector_noncausal_violation_fraction: float
    maximum_metric_adjustment: float
    maximum_exact_affine_cocycle_error: float
    maximum_exact_metric_covariance_error: float
    maximum_exact_lorentz_defect: float | None
    maximum_exact_internal_cocycle_error: float | None
    maximum_internal_identity_error: float | None
    maximum_coframe_factorization_error: float | None
    orientation_time_orientation_gauge_exists: bool
    passes_selector_gate: bool


@dataclass(frozen=True)
class GlobalAffineBundleSample:
    constructed_patch_count: int
    coordinate_eligible_patch_count: int
    selected_pivot_indices: list[int]
    selected_domain_counts: list[int]
    selected_core_counts: list[int]
    minimum_pair_overlap: int
    triple_overlap_count: int
    maximum_selector_transition_error: float | None
    maximum_test_transition_error: float | None
    global_gauge_design_condition: float | None
    maximum_global_map_linear_condition: float | None
    global_metric_signature: tuple[int, int, int] | None
    global_metric_condition: float | None
    maximum_selector_interval_error: float | None
    maximum_test_interval_error: float | None
    minimum_selector_causal_sign_fraction: float | None
    minimum_test_causal_sign_fraction: float | None
    maximum_selector_noncausal_violation_fraction: float | None
    maximum_test_noncausal_violation_fraction: float | None
    maximum_metric_adjustment: float | None
    maximum_exact_affine_cocycle_error: float | None
    maximum_exact_metric_covariance_error: float | None
    maximum_exact_lorentz_defect: float | None
    maximum_exact_internal_cocycle_error: float | None
    maximum_internal_identity_error: float | None
    maximum_coframe_factorization_error: float | None
    orientation_time_orientation_gauge_exists: bool
    maximum_oracle_affine_map_error: float | None
    maximum_selected_patch_oracle_coordinate_error: float | None
    maximum_pulledback_oracle_metric_error: float | None
    passes_selector_gate: bool
    passes_heldout_local_metric_gate: bool
    passes_heldout_transition_gate: bool
    passes_exact_flat_bundle_gate: bool
    passes_trivial_flat_spin_control_gate: bool
    exact_spin_obstruction_class_computed: bool


def _transition_event_indices(
    transition: ThreeWayTransition,
    subset: str,
) -> np.ndarray:
    value = getattr(transition, f"{subset}_event_indices")
    if value is None:
        raise ValueError(f"transition does not retain {subset} event indices")
    return np.asarray(value, dtype=int)


def fit_global_affine_gauges(
    patches: list[LocalFittedPatch],
    transitions: dict[tuple[int, int], ThreeWayTransition],
) -> tuple[list[np.ndarray], float, float]:
    """Fit patch-to-global maps with patch zero fixed as the affine gauge."""

    if len(patches) != 3:
        raise ValueError("global affine synchronization requires three patches")
    required = ((0, 1), (0, 2), (1, 2))
    if not all(pair in transitions for pair in required):
        raise ValueError("all pairwise transition splits are required")
    identity_coefficients = np.vstack((np.eye(4), np.zeros(4)))
    design_blocks: list[np.ndarray] = []
    target_blocks: list[np.ndarray] = []
    for left, right in required:
        events = _transition_event_indices(transitions[(left, right)], "fit")
        left_design = np.column_stack(
            (patches[left].consensus_coordinates[events], np.ones(len(events)))
        )
        right_design = np.column_stack(
            (patches[right].consensus_coordinates[events], np.ones(len(events)))
        )
        block = np.zeros((len(events), 10))
        fixed = np.zeros((len(events), 4))
        if left == 0:
            fixed += left_design @ identity_coefficients
        else:
            block[:, 5 * (left - 1) : 5 * left] += left_design
        if right == 0:
            fixed -= right_design @ identity_coefficients
        else:
            block[:, 5 * (right - 1) : 5 * right] -= right_design
        scale = math.sqrt(len(events))
        design_blocks.append(block / scale)
        target_blocks.append(-fixed / scale)
    design = np.vstack(design_blocks)
    target = np.vstack(target_blocks)
    if np.linalg.matrix_rank(design) < 10:
        raise ValueError("global affine synchronization design is rank deficient")
    coefficients = np.linalg.lstsq(design, target, rcond=None)[0]
    coefficient_maps = [
        identity_coefficients,
        coefficients[:5],
        coefficients[5:],
    ]
    maps = [homogeneous_affine_matrix(item) for item in coefficient_maps]
    linear_conditions = [float(np.linalg.cond(item[:4, :4])) for item in maps]
    if not all(np.isfinite(value) for value in linear_conditions):
        raise ValueError("a synchronized global map is singular")
    return maps, float(np.linalg.cond(design)), max(linear_conditions)


def exact_pair_transitions(
    global_maps: list[np.ndarray],
) -> dict[tuple[int, int], np.ndarray]:
    """Derive pair transitions as exact ratios of patch-to-global maps."""

    return {
        (left, right): global_maps[left] @ np.linalg.inv(global_maps[right])
        for left, right in ((0, 1), (0, 2), (1, 2))
    }


def transition_prediction_error(
    source: LocalFittedPatch,
    target: LocalFittedPatch,
    transition: np.ndarray,
    events: np.ndarray,
) -> float:
    """Relative coordinate error of one exact-gauge transition on events."""

    source_design = np.column_stack(
        (source.consensus_coordinates[events], np.ones(len(events)))
    )
    prediction = (source_design @ transition)[:, :4]
    expected = target.consensus_coordinates[events]
    scale = max(
        float(np.linalg.norm(expected - np.mean(expected, axis=0))),
        1.0e-12,
    )
    return float(np.linalg.norm(prediction - expected) / scale)


def fit_pooled_global_metric(
    patches: list[LocalFittedPatch],
    global_maps: list[np.ndarray],
    metric_regularization: float,
) -> tuple[np.ndarray, float]:
    """Fit one constant metric to all local training intervals in global gauge."""

    if metric_regularization < 0.0:
        raise ValueError("metric regularization must be nonnegative")
    normals: list[np.ndarray] = []
    responses: list[np.ndarray] = []
    priors: list[np.ndarray] = []
    for patch, global_map in zip(patches, global_maps, strict=True):
        split = patch.metric_constraint_split
        anchor_time = patch.anchor_time
        prior_metric = patch.metric_prior
        if split is None or anchor_time is None or prior_metric is None:
            raise ValueError("patch is missing retained A17 metric evidence")
        local_coordinates = patch.consensus_coordinates[patch.carrier_indices]
        global_coordinates = (
            np.column_stack((local_coordinates, np.ones(len(local_coordinates))))
            @ global_map
        )[:, :4]
        displacement = (
            global_coordinates[split.causal_right]
            - global_coordinates[split.causal_left]
        ) / anchor_time
        features = symmetric_quadratic_features(displacement)
        target = split.causal_target_squared / anchor_time**2
        train = split.causal_train
        weight = split.causal_weight[train]
        normal = (features[train].T * weight) @ features[train] / np.sum(weight)
        response = features[train].T @ (weight * target[train]) / np.sum(weight)
        scale = max(float(np.trace(normal) / len(normal)), 1.0e-12)
        normals.append(normal / scale)
        responses.append(response / scale)
        linear = global_map[:4, :4]
        inverse = np.linalg.inv(linear)
        global_prior = inverse @ prior_metric @ inverse.T
        priors.append(symmetric_matrix_to_vector(global_prior))
    normal = np.mean(normals, axis=0) + metric_regularization * np.eye(10)
    response = np.mean(responses, axis=0) + metric_regularization * np.mean(
        priors, axis=0
    )
    coefficients = np.linalg.solve(normal, response)
    return symmetric_vector_to_matrix(coefficients), float(np.linalg.cond(normal))


def exact_bundle_controls(
    exact_transitions: dict[tuple[int, int], np.ndarray],
    local_metrics: list[np.ndarray],
    local_coframes: list[np.ndarray | None],
) -> tuple[float, float, float | None, float | None, float | None, bool]:
    """Measure roundoff in exact affine, metric, Lorentz, and internal cocycles."""

    affine_cocycle = matrix_relative_error(
        exact_transitions[(0, 1)] @ exact_transitions[(1, 2)],
        exact_transitions[(0, 2)],
    )
    metric_errors: dict[tuple[int, int], float] = {}
    internal: dict[tuple[int, int], np.ndarray] = {}
    lorentz_errors: dict[tuple[int, int], float] = {}
    identity_errors: dict[tuple[int, int], float] = {}
    for pair, transition in exact_transitions.items():
        left, right = pair
        linear = transition[:4, :4]
        metric_errors[pair] = matrix_relative_error(
            linear @ local_metrics[right] @ linear.T,
            local_metrics[left],
        )
        if local_coframes[left] is None or local_coframes[right] is None:
            continue
        internal[pair] = np.linalg.solve(
            local_coframes[left], linear @ local_coframes[right]
        )
        lorentz_errors[pair] = matrix_relative_error(
            internal[pair] @ MINKOWSKI_METRIC @ internal[pair].T,
            MINKOWSKI_METRIC,
        )
        identity_errors[pair] = matrix_relative_error(internal[pair], np.eye(4))
    if len(internal) != 3:
        return (
            affine_cocycle,
            max(metric_errors.values()),
            None,
            None,
            None,
            False,
        )
    internal_cocycle = matrix_relative_error(
        internal[(0, 1)] @ internal[(1, 2)], internal[(0, 2)]
    )
    orientation_transitions = {
        pair: TransitionAudit(
            source_patch=pair[0],
            target_patch=pair[1],
            overlap_count=0,
            training_count=0,
            heldout_count=0,
            affine_map=exact_transitions[pair],
            affine_heldout_relative_error=0.0,
            affine_design_condition=1.0,
            metric_covariance_relative_error=metric_errors[pair],
            lorentz_defect_relative_error=lorentz_errors[pair],
            internal_transition=internal[pair],
            oracle_affine_map_relative_error=0.0,
        )
        for pair in ((0, 1), (0, 2), (1, 2))
    }
    orientation, _, _, _ = orient_coframe_transitions(orientation_transitions)
    return (
        affine_cocycle,
        max(metric_errors.values()),
        max(lorentz_errors.values()),
        internal_cocycle,
        max(identity_errors.values()),
        orientation,
    )


def audit_global_affine_triple(
    indices: tuple[int, int, int],
    patches: list[LocalFittedPatch],
    domains: list[np.ndarray],
    local_splits: list[LocalMetricHoldoutSplit],
    pair_transitions: dict[tuple[int, int], ThreeWayTransition],
    args: argparse.Namespace,
) -> GlobalAffineTripleAudit:
    """Fit one exact global affine flat bundle and score selector slices."""

    global_pairs = (
        (indices[0], indices[1]),
        (indices[0], indices[2]),
        (indices[1], indices[2]),
    )
    transitions = {
        local_pair: pair_transitions[global_pair]
        for local_pair, global_pair in zip(
            ((0, 1), (0, 2), (1, 2)), global_pairs, strict=True
        )
    }
    selected_patches = [patches[index] for index in indices]
    selected_splits = [local_splits[index] for index in indices]
    global_maps, gauge_condition, map_condition = fit_global_affine_gauges(
        selected_patches, transitions
    )
    exact_transitions = exact_pair_transitions(global_maps)
    global_metric, global_metric_condition = fit_pooled_global_metric(
        selected_patches,
        global_maps,
        args.metric_regularization,
    )
    global_coframe, global_factor_error = factor_lorentzian_metric(global_metric)
    local_metrics = [
        global_map[:4, :4] @ global_metric @ global_map[:4, :4].T
        for global_map in global_maps
    ]
    local_coframes = [
        None if global_coframe is None else global_map[:4, :4] @ global_coframe
        for global_map in global_maps
    ]
    selector_scores = [
        evaluate_local_metric(
            patch,
            metric,
            split.selector_causal,
            split.selector_noncausal,
        )
        for patch, metric, split in zip(
            selected_patches, local_metrics, selected_splits, strict=True
        )
    ]
    selector_transition_error = max(
        transition_prediction_error(
            selected_patches[left],
            selected_patches[right],
            exact_transitions[(left, right)],
            _transition_event_indices(transitions[(left, right)], "selector"),
        )
        for left, right in ((0, 1), (0, 2), (1, 2))
    )
    exact_controls = exact_bundle_controls(
        exact_transitions, local_metrics, local_coframes
    )
    (
        affine_cocycle,
        metric_covariance,
        lorentz_defect,
        internal_cocycle,
        internal_identity,
        orientation,
    ) = exact_controls
    selected_domains = [domains[index] for index in indices]
    pair_overlap = [item.overlap_count for item in transitions.values()]
    triple_overlap = len(
        set(selected_domains[0]) & set(selected_domains[1]) & set(selected_domains[2])
    )
    maximum_selector_interval = max(
        score.interval_relative_rmse for score in selector_scores
    )
    minimum_selector_sign = min(score.causal_sign_fraction for score in selector_scores)
    maximum_selector_noncausal = max(
        score.noncausal_violation_fraction for score in selector_scores
    )
    exact_values = (
        affine_cocycle,
        metric_covariance,
        lorentz_defect,
        internal_cocycle,
        internal_identity,
    )
    exact_gate = all(
        value is not None and value <= args.maximum_exact_residual
        for value in exact_values
    )
    selector_gate = bool(
        min(pair_overlap) >= args.minimum_pair_overlap
        and triple_overlap >= args.minimum_triple_overlap
        and selector_transition_error <= args.maximum_selector_transition_error
        and gauge_condition <= args.maximum_global_gauge_design_condition
        and map_condition <= args.maximum_global_map_linear_condition
        and metric_signature(global_metric) == (1, 3, 0)
        and global_factor_error is not None
        and global_factor_error <= args.maximum_exact_residual
        and global_metric_condition <= args.maximum_global_metric_condition
        and maximum_selector_interval <= args.maximum_interval_error
        and minimum_selector_sign >= args.minimum_heldout_causal_sign_fraction
        and maximum_selector_noncausal <= args.maximum_noncausal_violation_fraction
        and exact_gate
        and orientation
    )
    return GlobalAffineTripleAudit(
        indices=indices,
        global_maps=global_maps,
        exact_transitions=exact_transitions,
        global_metric=global_metric,
        local_metrics=local_metrics,
        local_coframes=local_coframes,
        minimum_pair_overlap=min(pair_overlap),
        triple_overlap_count=triple_overlap,
        maximum_selector_transition_error=selector_transition_error,
        global_gauge_design_condition=gauge_condition,
        maximum_global_map_linear_condition=map_condition,
        global_metric_signature=metric_signature(global_metric),
        global_metric_condition=global_metric_condition,
        maximum_selector_interval_error=maximum_selector_interval,
        minimum_selector_causal_sign_fraction=minimum_selector_sign,
        maximum_selector_noncausal_violation_fraction=(maximum_selector_noncausal),
        maximum_metric_adjustment=max(
            matrix_relative_error(metric, patch.metric)
            for metric, patch in zip(local_metrics, selected_patches, strict=True)
        ),
        maximum_exact_affine_cocycle_error=affine_cocycle,
        maximum_exact_metric_covariance_error=metric_covariance,
        maximum_exact_lorentz_defect=lorentz_defect,
        maximum_exact_internal_cocycle_error=internal_cocycle,
        maximum_internal_identity_error=internal_identity,
        maximum_coframe_factorization_error=global_factor_error,
        orientation_time_orientation_gauge_exists=orientation,
        passes_selector_gate=selector_gate,
    )


def global_affine_selector_key(
    audit: GlobalAffineTripleAudit | SimpleNamespace,
) -> tuple[object, ...]:
    """Select exact flat bundles without consulting test or oracle scores."""

    return (
        -int(audit.passes_selector_gate),
        audit.maximum_selector_interval_error,
        audit.maximum_selector_transition_error,
        audit.maximum_metric_adjustment,
        audit.global_gauge_design_condition,
        -audit.triple_overlap_count,
        audit.indices,
    )


def select_global_affine_triple(
    audits: list[GlobalAffineTripleAudit],
) -> GlobalAffineTripleAudit:
    """Choose a globally synchronized triple before opening test slices."""

    if not audits:
        raise ValueError("at least one global affine audit is required")
    return min(audits, key=global_affine_selector_key)


def unavailable_sample(
    constructed_patch_count: int,
    coordinate_eligible_patch_count: int,
) -> GlobalAffineBundleSample:
    """Record unavailable exact-atlas geometry without fabricated residuals."""

    return GlobalAffineBundleSample(
        constructed_patch_count=constructed_patch_count,
        coordinate_eligible_patch_count=coordinate_eligible_patch_count,
        selected_pivot_indices=[],
        selected_domain_counts=[],
        selected_core_counts=[],
        minimum_pair_overlap=0,
        triple_overlap_count=0,
        maximum_selector_transition_error=None,
        maximum_test_transition_error=None,
        global_gauge_design_condition=None,
        maximum_global_map_linear_condition=None,
        global_metric_signature=None,
        global_metric_condition=None,
        maximum_selector_interval_error=None,
        maximum_test_interval_error=None,
        minimum_selector_causal_sign_fraction=None,
        minimum_test_causal_sign_fraction=None,
        maximum_selector_noncausal_violation_fraction=None,
        maximum_test_noncausal_violation_fraction=None,
        maximum_metric_adjustment=None,
        maximum_exact_affine_cocycle_error=None,
        maximum_exact_metric_covariance_error=None,
        maximum_exact_lorentz_defect=None,
        maximum_exact_internal_cocycle_error=None,
        maximum_internal_identity_error=None,
        maximum_coframe_factorization_error=None,
        orientation_time_orientation_gauge_exists=False,
        maximum_oracle_affine_map_error=None,
        maximum_selected_patch_oracle_coordinate_error=None,
        maximum_pulledback_oracle_metric_error=None,
        passes_selector_gate=False,
        passes_heldout_local_metric_gate=False,
        passes_heldout_transition_gate=False,
        passes_exact_flat_bundle_gate=False,
        passes_trivial_flat_spin_control_gate=False,
        exact_spin_obstruction_class_computed=False,
    )


def oracle_transition_coefficients(
    source: LocalFittedPatch,
    target: LocalFittedPatch,
    points: np.ndarray,
) -> np.ndarray:
    """Post-selection oracle affine transition between two patch gauges."""

    source_oracle = oracle_patch_affine_map(source, points)
    target_oracle = oracle_patch_affine_map(target, points)
    target_inverse = np.linalg.inv(target_oracle[:4])
    coefficients = np.empty((5, 4))
    coefficients[:4] = source_oracle[:4] @ target_inverse
    coefficients[4] = (source_oracle[4] - target_oracle[4]) @ target_inverse
    return coefficients


def sample_from_selected_audit(
    audit: GlobalAffineTripleAudit,
    patches: list[LocalFittedPatch],
    domains: list[np.ndarray],
    local_splits: list[LocalMetricHoldoutSplit],
    pair_transitions: dict[tuple[int, int], ThreeWayTransition],
    points: np.ndarray,
    args: argparse.Namespace,
    constructed_patch_count: int,
) -> GlobalAffineBundleSample:
    """Evaluate untouched local, overlap, and oracle data after selection."""

    selected_patches = [patches[index] for index in audit.indices]
    selected_domains = [domains[index] for index in audit.indices]
    selected_splits = [local_splits[index] for index in audit.indices]
    global_pairs = (
        (audit.indices[0], audit.indices[1]),
        (audit.indices[0], audit.indices[2]),
        (audit.indices[1], audit.indices[2]),
    )
    transitions = {
        local_pair: pair_transitions[global_pair]
        for local_pair, global_pair in zip(
            ((0, 1), (0, 2), (1, 2)), global_pairs, strict=True
        )
    }
    test_scores = [
        evaluate_local_metric(
            patch,
            metric,
            split.test_causal,
            split.test_noncausal,
        )
        for patch, metric, split in zip(
            selected_patches,
            audit.local_metrics,
            selected_splits,
            strict=True,
        )
    ]
    maximum_test_interval = max(score.interval_relative_rmse for score in test_scores)
    minimum_test_sign = min(score.causal_sign_fraction for score in test_scores)
    maximum_test_noncausal = max(
        score.noncausal_violation_fraction for score in test_scores
    )
    maximum_test_transition = max(
        transition_prediction_error(
            selected_patches[left],
            selected_patches[right],
            audit.exact_transitions[(left, right)],
            _transition_event_indices(transitions[(left, right)], "test"),
        )
        for left, right in ((0, 1), (0, 2), (1, 2))
    )
    heldout_local = bool(
        maximum_test_interval <= args.maximum_interval_error
        and minimum_test_sign >= args.minimum_heldout_causal_sign_fraction
        and maximum_test_noncausal <= args.maximum_noncausal_violation_fraction
    )
    heldout_transition = bool(
        maximum_test_transition <= args.maximum_test_transition_error
    )
    exact_bundle = bool(
        audit.passes_selector_gate and heldout_local and heldout_transition
    )
    oracle_transition_errors = []
    for (left, right), transition in audit.exact_transitions.items():
        oracle = oracle_transition_coefficients(
            selected_patches[left], selected_patches[right], points
        )
        oracle_transition_errors.append(
            matrix_relative_error(transition[:5, :4], oracle)
        )
    oracle_metric_errors = []
    for patch, metric in zip(selected_patches, audit.local_metrics, strict=True):
        affine = oracle_patch_affine_map(patch, points)
        oracle_metric = affine[:4] @ MINKOWSKI_METRIC @ affine[:4].T
        oracle_metric_errors.append(matrix_relative_error(metric, oracle_metric))
    return GlobalAffineBundleSample(
        constructed_patch_count=constructed_patch_count,
        coordinate_eligible_patch_count=len(patches),
        selected_pivot_indices=[patch.pivot_index for patch in selected_patches],
        selected_domain_counts=[len(domain) for domain in selected_domains],
        selected_core_counts=[len(patch.carrier_indices) for patch in selected_patches],
        minimum_pair_overlap=audit.minimum_pair_overlap,
        triple_overlap_count=audit.triple_overlap_count,
        maximum_selector_transition_error=(audit.maximum_selector_transition_error),
        maximum_test_transition_error=maximum_test_transition,
        global_gauge_design_condition=audit.global_gauge_design_condition,
        maximum_global_map_linear_condition=(audit.maximum_global_map_linear_condition),
        global_metric_signature=audit.global_metric_signature,
        global_metric_condition=audit.global_metric_condition,
        maximum_selector_interval_error=audit.maximum_selector_interval_error,
        maximum_test_interval_error=maximum_test_interval,
        minimum_selector_causal_sign_fraction=(
            audit.minimum_selector_causal_sign_fraction
        ),
        minimum_test_causal_sign_fraction=minimum_test_sign,
        maximum_selector_noncausal_violation_fraction=(
            audit.maximum_selector_noncausal_violation_fraction
        ),
        maximum_test_noncausal_violation_fraction=maximum_test_noncausal,
        maximum_metric_adjustment=audit.maximum_metric_adjustment,
        maximum_exact_affine_cocycle_error=(audit.maximum_exact_affine_cocycle_error),
        maximum_exact_metric_covariance_error=(
            audit.maximum_exact_metric_covariance_error
        ),
        maximum_exact_lorentz_defect=audit.maximum_exact_lorentz_defect,
        maximum_exact_internal_cocycle_error=(
            audit.maximum_exact_internal_cocycle_error
        ),
        maximum_internal_identity_error=audit.maximum_internal_identity_error,
        maximum_coframe_factorization_error=(audit.maximum_coframe_factorization_error),
        orientation_time_orientation_gauge_exists=(
            audit.orientation_time_orientation_gauge_exists
        ),
        maximum_oracle_affine_map_error=max(oracle_transition_errors),
        maximum_selected_patch_oracle_coordinate_error=max(
            patch.oracle_coordinate_error for patch in selected_patches
        ),
        maximum_pulledback_oracle_metric_error=max(oracle_metric_errors),
        passes_selector_gate=audit.passes_selector_gate,
        passes_heldout_local_metric_gate=heldout_local,
        passes_heldout_transition_gate=heldout_transition,
        passes_exact_flat_bundle_gate=exact_bundle,
        passes_trivial_flat_spin_control_gate=bool(
            exact_bundle
            and audit.orientation_time_orientation_gauge_exists
            and audit.maximum_internal_identity_error is not None
            and audit.maximum_internal_identity_error <= args.maximum_exact_residual
        ),
        exact_spin_obstruction_class_computed=False,
    )


def reconstruct_realization(
    rng: np.random.Generator,
    args: argparse.Namespace,
) -> GlobalAffineBundleSample:
    """Construct one globally synchronized exact-affine flat bundle control."""

    points, bottom_index, top_index = causal_interval_points(
        rng, args.events, args.duration
    )
    relation = causal_relation_matrix(points, args.block_size)
    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    intrinsic_time, intrinsic_radius = intrinsic_time_and_radius_from_relation(
        relation,
        density,
        args.dimension,
        bottom_index,
        top_index,
        args.duration,
    )
    root_pivot = choose_deep_intrinsic_pivot(
        relation,
        intrinsic_time,
        intrinsic_radius,
        args.duration,
        args.minimum_lightcone_count,
    )
    root = johnston_lightcone_embedding_from_intrinsic_data(
        relation,
        density,
        args.dimension,
        bottom_index,
        top_index,
        root_pivot,
        intrinsic_time,
        intrinsic_radius,
        spatial_rank=args.dimension - 1,
    )
    candidates = stable_center_candidates(
        relation,
        root,
        args.minimum_lightcone_count,
        args.maximum_center_candidates,
    )
    center_distance = np.linalg.norm(root.probes, axis=1)
    patch_seeds = rng.integers(0, 2**63 - 1, size=len(candidates))
    constructed: list[LocalFittedPatch] = []
    for candidate, seed in zip(candidates, patch_seeds, strict=True):
        try:
            constructed.append(
                build_local_patch(
                    np.random.default_rng(int(seed)),
                    relation,
                    points,
                    density,
                    args.dimension,
                    bottom_index,
                    top_index,
                    intrinsic_time,
                    intrinsic_radius,
                    int(candidate),
                    float(center_distance[candidate]),
                    args.scaffold_scale,
                    args.anchor_time_multiplier,
                    args.active_count,
                    args.relative_time_shell_width,
                    args.maximum_lower_candidates,
                    args.maximum_upper_candidates,
                    args.metric_regularization,
                    args.local_heldout_fraction,
                    args.minimum_heldout_open_count,
                    args.maximum_noncausal_pairs,
                    args.minimum_evaluation_count,
                    args.maximum_chart_consistency_error,
                    args.maximum_interval_error,
                    args.minimum_heldout_causal_sign_fraction,
                    args.maximum_noncausal_violation_fraction,
                    args.minimum_causal_sensitivity,
                    args.minimum_causal_specificity,
                )
            )
        except (ArithmeticError, KeyError, np.linalg.LinAlgError, ValueError):
            continue
    eligible: list[LocalFittedPatch] = []
    local_splits: list[LocalMetricHoldoutSplit] = []
    split_seeds = rng.integers(0, 2**63 - 1, size=len(constructed))
    for patch, seed in zip(constructed, split_seeds, strict=True):
        if not coordinate_eligible_patch(patch, args):
            continue
        try:
            split = split_local_metric_holdout(
                np.random.default_rng(int(seed)),
                patch,
                args.local_selector_fraction,
            )
        except ValueError:
            continue
        eligible.append(patch)
        local_splits.append(split)
    if len(eligible) < 3:
        return unavailable_sample(len(constructed), len(eligible))
    domains = [patch_domain(patch, args.patch_radius) for patch in eligible]
    pair_transitions: dict[tuple[int, int], ThreeWayTransition] = {}
    pair_seeds = rng.integers(
        0, 2**63 - 1, size=len(eligible) * (len(eligible) - 1) // 2
    )
    for pair_index, (left, right) in enumerate(
        itertools.combinations(range(len(eligible)), 2)
    ):
        if len(np.intersect1d(domains[left], domains[right])) < (
            args.minimum_pair_overlap
        ):
            continue
        try:
            pair_transitions[(left, right)] = fit_three_way_transition(
                np.random.default_rng(int(pair_seeds[pair_index])),
                left,
                right,
                eligible[left],
                eligible[right],
                domains[left],
                domains[right],
                points,
                args.transition_fit_fraction,
                args.transition_selector_fraction,
            )
        except (np.linalg.LinAlgError, ValueError):
            continue
    audits: list[GlobalAffineTripleAudit] = []
    for indices in itertools.combinations(range(len(eligible)), 3):
        required = (
            (indices[0], indices[1]),
            (indices[0], indices[2]),
            (indices[1], indices[2]),
        )
        if not all(pair in pair_transitions for pair in required):
            continue
        if (
            len(
                set(domains[indices[0]])
                & set(domains[indices[1]])
                & set(domains[indices[2]])
            )
            < args.minimum_triple_overlap
        ):
            continue
        try:
            audits.append(
                audit_global_affine_triple(
                    indices,
                    eligible,
                    domains,
                    local_splits,
                    pair_transitions,
                    args,
                )
            )
        except (np.linalg.LinAlgError, ValueError):
            continue
    if not audits:
        return unavailable_sample(len(constructed), len(eligible))
    selected = select_global_affine_triple(audits)
    return sample_from_selected_audit(
        selected,
        eligible,
        domains,
        local_splits,
        pair_transitions,
        points,
        args,
        len(constructed),
    )


def summarize_samples(samples: list[GlobalAffineBundleSample]) -> dict[str, object]:
    """Aggregate exact-flat-atlas fidelity, residual, and gate controls."""

    def statistics(name: str) -> dict[str, float | int]:
        values = [
            float(value)
            for sample in samples
            if (value := getattr(sample, name)) is not None
        ]
        return finite_statistics(values)

    def rate(name: str) -> float:
        return float(np.mean([bool(getattr(sample, name)) for sample in samples]))

    statistic_names = (
        "constructed_patch_count",
        "coordinate_eligible_patch_count",
        "minimum_pair_overlap",
        "triple_overlap_count",
        "maximum_selector_transition_error",
        "maximum_test_transition_error",
        "global_gauge_design_condition",
        "maximum_global_map_linear_condition",
        "global_metric_condition",
        "maximum_selector_interval_error",
        "maximum_test_interval_error",
        "minimum_selector_causal_sign_fraction",
        "minimum_test_causal_sign_fraction",
        "maximum_selector_noncausal_violation_fraction",
        "maximum_test_noncausal_violation_fraction",
        "maximum_metric_adjustment",
        "maximum_exact_affine_cocycle_error",
        "maximum_exact_metric_covariance_error",
        "maximum_exact_lorentz_defect",
        "maximum_exact_internal_cocycle_error",
        "maximum_internal_identity_error",
        "maximum_oracle_affine_map_error",
        "maximum_selected_patch_oracle_coordinate_error",
        "maximum_pulledback_oracle_metric_error",
    )
    result: dict[str, object] = {
        "samples": len(samples),
        **{name: statistics(name) for name in statistic_names},
    }
    for name in (
        "orientation_time_orientation_gauge_exists",
        "passes_selector_gate",
        "passes_heldout_local_metric_gate",
        "passes_heldout_transition_gate",
        "passes_exact_flat_bundle_gate",
        "passes_trivial_flat_spin_control_gate",
    ):
        result[f"{name}_rate"] = rate(name)
    return result


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run development or frozen held-out exact global-affine flat controls."""

    master = np.random.default_rng(args.seed)
    realization_seeds = master.integers(0, 2**63 - 1, size=args.realizations)
    samples = [
        reconstruct_realization(np.random.default_rng(int(seed)), args)
        for seed in realization_seeds
    ]
    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "stage": "A21 exact global-affine flat tetrad-bundle control",
        "mode": args.mode,
        "events": args.events,
        "realizations": args.realizations,
        "seed": args.seed,
        "realization_seeds": [int(seed) for seed in realization_seeds],
        "parameters": {
            "dimension": args.dimension,
            "density": density,
            "patch_radius": args.patch_radius,
            "metric_regularization": args.metric_regularization,
            "local_selector_fraction": args.local_selector_fraction,
            "transition_fit_fraction": args.transition_fit_fraction,
            "transition_selector_fraction": args.transition_selector_fraction,
            "maximum_exact_residual": args.maximum_exact_residual,
        },
        "selection_blinding": (
            "triple selection excludes local test constraints, overlap test "
            "events, and all sprinkling-coordinate oracle controls"
        ),
        "summary": summarize_samples(samples),
        "caveat": (
            "this is a constant-metric Minkowski control with supplied dimension, "
            "density, endpoints, scale, and Lorentz prior; curvature requires "
            "position-dependent metric jets"
        ),
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--mode", choices=("development", "held-out"), default="development"
    )
    parser.add_argument("--events", type=int, default=4000)
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
    parser.add_argument("--local-heldout-fraction", type=float, default=0.20)
    parser.add_argument("--local-selector-fraction", type=float, default=0.50)
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
    parser.add_argument("--patch-radius", type=float, default=0.40)
    parser.add_argument("--transition-fit-fraction", type=float, default=0.60)
    parser.add_argument("--transition-selector-fraction", type=float, default=0.20)
    parser.add_argument("--minimum-pair-overlap", type=int, default=30)
    parser.add_argument("--minimum-triple-overlap", type=int, default=15)
    parser.add_argument("--maximum-selector-transition-error", type=float, default=0.25)
    parser.add_argument("--maximum-test-transition-error", type=float, default=0.25)
    parser.add_argument(
        "--maximum-global-gauge-design-condition", type=float, default=100.0
    )
    parser.add_argument(
        "--maximum-global-map-linear-condition", type=float, default=50.0
    )
    parser.add_argument("--maximum-global-metric-condition", type=float, default=1.0e8)
    parser.add_argument("--maximum-exact-residual", type=float, default=1.0e-10)
    parser.add_argument("--seed", type=int, default=20260880)
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
