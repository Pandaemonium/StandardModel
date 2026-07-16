"""Stage A20 jointly synchronized conditional metric/coframe bundle audit.

Stage A19 showed that selecting among independently fitted A17 metrics does not
produce a stable held-out tetrad bundle.  This successor retains the frozen
local coordinate construction but fits the three patch metrics jointly.  The
objective combines each patch's count-derived interval regression with affine
overlap covariance penalties.

Local interval holdouts and overlap events are each split into selector and
untouched test slices.  Synchronization weight and patch triple are selected
without test or sprinkling-coordinate oracle data.  Dimension, density, scale,
endpoints, and the chart-transported Lorentz prior remain supplied, so this is
still a conditional atlas experiment rather than bare-graph metric emergence.
Approximate transitions do not define an exact central Z2 spin class.
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
from causal_tetrad_bundle_atlas import (
    LocalFittedPatch,
    TransitionAudit,
    build_local_patch,
    oracle_patch_affine_map,
    orient_coframe_transitions,
    patch_domain,
    stable_center_candidates,
)
from causal_well_conditioning_audit import choose_deep_intrinsic_pivot


@dataclass(frozen=True)
class LocalMetricHoldoutSplit:
    """Disjoint selector and test positions inside one A17 holdout."""

    selector_causal: np.ndarray
    test_causal: np.ndarray
    selector_noncausal: np.ndarray
    test_noncausal: np.ndarray


@dataclass(frozen=True)
class LocalMetricScore:
    interval_relative_rmse: float
    causal_sign_fraction: float
    noncausal_violation_fraction: float


@dataclass(frozen=True)
class SynchronizedTripleAudit:
    indices: tuple[int, int, int]
    metrics: list[np.ndarray]
    coframes: list[np.ndarray | None]
    metric_signatures: list[tuple[int, int, int]]
    minimum_pair_overlap: int
    triple_overlap_count: int
    maximum_selector_transition_error: float
    maximum_transition_design_condition: float
    maximum_selector_interval_error: float
    minimum_selector_causal_sign_fraction: float
    maximum_selector_noncausal_violation_fraction: float
    maximum_presynchronization_metric_covariance_error: float
    maximum_metric_covariance_error: float
    maximum_lorentz_defect: float | None
    maximum_metric_adjustment: float
    maximum_coframe_factorization_error: float | None
    affine_cocycle_relative_error: float
    lorentz_cocycle_relative_error: float | None
    orientation_time_orientation_gauge_exists: bool
    joint_normal_condition: float
    passes_selector_gate: bool


@dataclass(frozen=True)
class SynchronizedBundleSample:
    synchronization_weight: float
    constructed_patch_count: int
    coordinate_eligible_patch_count: int
    selected_pivot_indices: list[int]
    selected_domain_counts: list[int]
    selected_core_counts: list[int]
    minimum_pair_overlap: int
    triple_overlap_count: int
    maximum_selector_transition_error: float | None
    maximum_test_transition_error: float | None
    maximum_transition_design_condition: float | None
    maximum_selector_interval_error: float | None
    maximum_test_interval_error: float | None
    minimum_selector_causal_sign_fraction: float | None
    minimum_test_causal_sign_fraction: float | None
    maximum_selector_noncausal_violation_fraction: float | None
    maximum_test_noncausal_violation_fraction: float | None
    maximum_presynchronization_metric_covariance_error: float | None
    maximum_metric_covariance_error: float | None
    maximum_lorentz_defect: float | None
    maximum_metric_adjustment: float | None
    maximum_coframe_factorization_error: float | None
    affine_cocycle_relative_error: float | None
    lorentz_cocycle_relative_error: float | None
    orientation_time_orientation_gauge_exists: bool
    joint_normal_condition: float | None
    metric_signatures: list[tuple[int, int, int]]
    maximum_oracle_affine_map_error: float | None
    maximum_selected_patch_oracle_coordinate_error: float | None
    maximum_synchronized_oracle_metric_error: float | None
    passes_selector_gate: bool
    passes_heldout_local_metric_gate: bool
    passes_heldout_transition_gate: bool
    passes_metric_bundle_gate: bool
    passes_spin_prerequisite_gate: bool
    exact_spin_obstruction_class_computed: bool


def synchronization_weight_key(value: float) -> str:
    """Stable JSON key for one nonnegative synchronization coefficient."""

    return f"synchronization_weight={value:.6f}"


def symmetric_transport_operator(linear: np.ndarray) -> np.ndarray:
    """Represent ``g -> A g A^T`` on packed symmetric coefficients."""

    if linear.shape != (4, 4):
        raise ValueError("metric transport requires a 4 by 4 linear map")
    columns = []
    for index in range(10):
        basis_vector = np.zeros(10)
        basis_vector[index] = 1.0
        basis = symmetric_vector_to_matrix(basis_vector)
        columns.append(symmetric_matrix_to_vector(linear @ basis @ linear.T))
    return np.column_stack(columns)


def split_local_metric_holdout(
    rng: np.random.Generator,
    patch: LocalFittedPatch,
    selector_fraction: float,
) -> LocalMetricHoldoutSplit:
    """Split frozen A17 holdouts without returning any event to training."""

    split = patch.metric_constraint_split
    if split is None:
        raise ValueError("patch does not retain its metric constraint split")
    if not 0.0 < selector_fraction < 1.0:
        raise ValueError("selector fraction must lie strictly between zero and one")

    def divide(positions: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
        if len(positions) < 2:
            raise ValueError("selector/test separation needs at least two positions")
        shuffled = rng.permutation(positions)
        count = max(1, int(math.floor(selector_fraction * len(shuffled))))
        count = min(count, len(shuffled) - 1)
        return np.sort(shuffled[:count]), np.sort(shuffled[count:])

    selector_causal, test_causal = divide(split.causal_heldout)
    selector_noncausal, test_noncausal = divide(
        np.arange(len(split.noncausal_left), dtype=int)
    )
    return LocalMetricHoldoutSplit(
        selector_causal=selector_causal,
        test_causal=test_causal,
        selector_noncausal=selector_noncausal,
        test_noncausal=test_noncausal,
    )


def local_metric_normal_equations(
    patch: LocalFittedPatch,
    metric_regularization: float,
) -> tuple[np.ndarray, np.ndarray]:
    """Return the dimensionless A17 training objective for one metric."""

    split = patch.metric_constraint_split
    anchor_time = patch.anchor_time
    prior_metric = patch.metric_prior
    if split is None or anchor_time is None or prior_metric is None:
        raise ValueError("patch is missing retained A17 regression evidence")
    if metric_regularization < 0.0 or anchor_time <= 0.0:
        raise ValueError("metric ridge must be nonnegative and scale positive")
    coordinates = patch.consensus_coordinates[patch.carrier_indices]
    displacement = (
        coordinates[split.causal_right] - coordinates[split.causal_left]
    ) / anchor_time
    features = symmetric_quadratic_features(displacement)
    target = split.causal_target_squared / anchor_time**2
    train = split.causal_train
    weight = split.causal_weight[train]
    normal = (features[train].T * weight) @ features[train] / np.sum(weight)
    response = features[train].T @ (weight * target[train]) / np.sum(weight)
    scale = max(float(np.trace(normal) / len(normal)), 1.0e-12)
    normalized_normal = normal / scale
    normalized_response = response / scale
    prior = symmetric_matrix_to_vector(prior_metric)
    return (
        normalized_normal + metric_regularization * np.eye(10),
        normalized_response + metric_regularization * prior,
    )


def fit_synchronized_metrics(
    patches: list[LocalFittedPatch],
    transitions: dict[tuple[int, int], ThreeWayTransition],
    metric_regularization: float,
    synchronization_weight: float,
) -> tuple[list[np.ndarray], float]:
    """Jointly fit three local metrics with overlap-covariance penalties."""

    if len(patches) != 3:
        raise ValueError("the synchronized audit currently requires three patches")
    if synchronization_weight < 0.0:
        raise ValueError("synchronization weight must be nonnegative")
    required = ((0, 1), (0, 2), (1, 2))
    if not all(pair in transitions for pair in required):
        raise ValueError("all three pair transitions are required")

    normal = np.zeros((30, 30))
    response = np.zeros(30)
    for index, patch in enumerate(patches):
        block, block_response = local_metric_normal_equations(
            patch, metric_regularization
        )
        section = slice(10 * index, 10 * (index + 1))
        normal[section, section] = block
        response[section] = block_response

    for left, right in required:
        linear = transitions[(left, right)].affine_map[:4, :4]
        transport = symmetric_transport_operator(linear)
        constraint = np.zeros((10, 30))
        constraint[:, 10 * left : 10 * (left + 1)] = np.eye(10)
        constraint[:, 10 * right : 10 * (right + 1)] = -transport
        left_metric = symmetric_matrix_to_vector(patches[left].metric)
        transported_right = transport @ symmetric_matrix_to_vector(
            patches[right].metric
        )
        scale = max(
            float(np.linalg.norm(left_metric)),
            float(np.linalg.norm(transported_right)),
            1.0e-12,
        )
        normalized_constraint = constraint / scale
        normal += (
            synchronization_weight * normalized_constraint.T @ normalized_constraint
        )

    coefficients = np.linalg.solve(normal, response)
    metrics = [
        symmetric_vector_to_matrix(coefficients[10 * index : 10 * (index + 1)])
        for index in range(3)
    ]
    return metrics, float(np.linalg.cond(normal))


def evaluate_local_metric(
    patch: LocalFittedPatch,
    metric: np.ndarray,
    causal_positions: np.ndarray,
    noncausal_positions: np.ndarray,
) -> LocalMetricScore:
    """Score a synchronized metric on specified untouched local constraints."""

    split = patch.metric_constraint_split
    anchor_time = patch.anchor_time
    if split is None or anchor_time is None:
        raise ValueError("patch is missing retained A17 regression evidence")
    coefficients = symmetric_matrix_to_vector(metric)
    coordinates = patch.consensus_coordinates[patch.carrier_indices]
    displacement = (
        coordinates[split.causal_right] - coordinates[split.causal_left]
    ) / anchor_time
    features = symmetric_quadratic_features(displacement)
    target = split.causal_target_squared / anchor_time**2
    prediction = features[causal_positions] @ coefficients
    weight = split.causal_weight[causal_positions]
    error_scale = max(
        float(np.average(target[causal_positions] ** 2, weights=weight)),
        1.0e-12,
    )
    relative_rmse = math.sqrt(
        float(
            np.average(
                (prediction - target[causal_positions]) ** 2,
                weights=weight,
            )
            / error_scale
        )
    )
    noncausal_displacement = (
        coordinates[split.noncausal_right[noncausal_positions]]
        - coordinates[split.noncausal_left[noncausal_positions]]
    ) / anchor_time
    noncausal_prediction = (
        symmetric_quadratic_features(noncausal_displacement) @ coefficients
    )
    return LocalMetricScore(
        interval_relative_rmse=relative_rmse,
        causal_sign_fraction=float(np.mean(prediction > 0.0)),
        noncausal_violation_fraction=float(np.mean(noncausal_prediction > 0.0)),
    )


def affine_cocycle_error(
    transitions: dict[tuple[int, int], ThreeWayTransition],
) -> float:
    """Relative homogeneous affine cocycle residual on one patch triangle."""

    return matrix_relative_error(
        transitions[(0, 1)].affine_map @ transitions[(1, 2)].affine_map,
        transitions[(0, 2)].affine_map,
    )


def synchronized_bundle_controls(
    transitions: dict[tuple[int, int], ThreeWayTransition],
    metrics: list[np.ndarray],
    coframes: list[np.ndarray | None],
) -> tuple[float, float | None, float | None, bool]:
    """Audit tensor covariance, internal Lorentz maps, and orientation."""

    metric_errors: dict[tuple[int, int], float] = {}
    internal: dict[tuple[int, int], np.ndarray] = {}
    lorentz_errors: dict[tuple[int, int], float] = {}
    for pair, transition in transitions.items():
        left, right = pair
        linear = transition.affine_map[:4, :4]
        metric_errors[pair] = matrix_relative_error(
            linear @ metrics[right] @ linear.T,
            metrics[left],
        )
        if coframes[left] is None or coframes[right] is None:
            continue
        internal[pair] = np.linalg.solve(coframes[left], linear @ coframes[right])
        lorentz_errors[pair] = matrix_relative_error(
            internal[pair] @ MINKOWSKI_METRIC @ internal[pair].T,
            MINKOWSKI_METRIC,
        )
    if len(internal) != 3:
        return max(metric_errors.values()), None, None, False
    lorentz_cocycle = matrix_relative_error(
        internal[(0, 1)] @ internal[(1, 2)], internal[(0, 2)]
    )
    orientation_transitions = {
        pair: TransitionAudit(
            source_patch=pair[0],
            target_patch=pair[1],
            overlap_count=transitions[pair].overlap_count,
            training_count=transitions[pair].fit_count,
            heldout_count=transitions[pair].test_count,
            affine_map=transitions[pair].affine_map,
            affine_heldout_relative_error=(
                transitions[pair].test_affine_relative_error
            ),
            affine_design_condition=transitions[pair].affine_design_condition,
            metric_covariance_relative_error=metric_errors[pair],
            lorentz_defect_relative_error=lorentz_errors[pair],
            internal_transition=internal[pair],
            oracle_affine_map_relative_error=(
                transitions[pair].oracle_affine_map_relative_error
            ),
        )
        for pair in ((0, 1), (0, 2), (1, 2))
    }
    orientation, _, _, _ = orient_coframe_transitions(orientation_transitions)
    return (
        max(metric_errors.values()),
        max(lorentz_errors.values()),
        lorentz_cocycle,
        orientation,
    )


def audit_synchronized_triple(
    indices: tuple[int, int, int],
    patches: list[LocalFittedPatch],
    domains: list[np.ndarray],
    local_splits: list[LocalMetricHoldoutSplit],
    pair_transitions: dict[tuple[int, int], ThreeWayTransition],
    synchronization_weight: float,
    args: argparse.Namespace,
) -> SynchronizedTripleAudit:
    """Fit and selector-audit one candidate synchronized metric triangle."""

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
    metrics, joint_condition = fit_synchronized_metrics(
        selected_patches,
        transitions,
        args.metric_regularization,
        synchronization_weight,
    )
    factorizations = [factor_lorentzian_metric(metric) for metric in metrics]
    coframes = [item[0] for item in factorizations]
    factor_errors = [item[1] for item in factorizations]
    signatures = [metric_signature(metric) for metric in metrics]
    selector_scores = [
        evaluate_local_metric(
            patch,
            metric,
            split.selector_causal,
            split.selector_noncausal,
        )
        for patch, metric, split in zip(
            selected_patches, metrics, selected_splits, strict=True
        )
    ]
    pair_overlap = [item.overlap_count for item in transitions.values()]
    selected_domains = [domains[index] for index in indices]
    triple_overlap = len(
        set(selected_domains[0]) & set(selected_domains[1]) & set(selected_domains[2])
    )
    presync_metric_error = max(
        matrix_relative_error(
            transition.affine_map[:4, :4]
            @ selected_patches[right].metric
            @ transition.affine_map[:4, :4].T,
            selected_patches[left].metric,
        )
        for (left, right), transition in transitions.items()
    )
    metric_error, lorentz_error, lorentz_cocycle, orientation = (
        synchronized_bundle_controls(transitions, metrics, coframes)
    )
    affine_cocycle = affine_cocycle_error(transitions)
    maximum_factor_error = (
        None
        if any(error is None for error in factor_errors)
        else max(float(error) for error in factor_errors if error is not None)
    )
    maximum_selector_interval = max(
        score.interval_relative_rmse for score in selector_scores
    )
    minimum_selector_sign = min(score.causal_sign_fraction for score in selector_scores)
    maximum_selector_noncausal = max(
        score.noncausal_violation_fraction for score in selector_scores
    )
    selector_gate = bool(
        min(pair_overlap) >= args.minimum_pair_overlap
        and triple_overlap >= args.minimum_triple_overlap
        and max(item.selector_affine_relative_error for item in transitions.values())
        <= args.maximum_selector_transition_error
        and max(item.affine_design_condition for item in transitions.values())
        <= args.maximum_transition_design_condition
        and maximum_selector_interval <= args.maximum_interval_error
        and minimum_selector_sign >= args.minimum_heldout_causal_sign_fraction
        and maximum_selector_noncausal <= args.maximum_noncausal_violation_fraction
        and signatures == [(1, 3, 0)] * 3
        and maximum_factor_error is not None
        and maximum_factor_error <= args.maximum_coframe_factorization_error
        and metric_error <= args.maximum_metric_covariance_error
        and lorentz_error is not None
        and lorentz_error <= args.maximum_lorentz_defect
        and affine_cocycle <= args.maximum_cocycle_error
        and lorentz_cocycle is not None
        and lorentz_cocycle <= args.maximum_cocycle_error
        and orientation
        and joint_condition <= args.maximum_joint_normal_condition
    )
    return SynchronizedTripleAudit(
        indices=indices,
        metrics=metrics,
        coframes=coframes,
        metric_signatures=signatures,
        minimum_pair_overlap=min(pair_overlap),
        triple_overlap_count=triple_overlap,
        maximum_selector_transition_error=max(
            item.selector_affine_relative_error for item in transitions.values()
        ),
        maximum_transition_design_condition=max(
            item.affine_design_condition for item in transitions.values()
        ),
        maximum_selector_interval_error=maximum_selector_interval,
        minimum_selector_causal_sign_fraction=minimum_selector_sign,
        maximum_selector_noncausal_violation_fraction=(maximum_selector_noncausal),
        maximum_presynchronization_metric_covariance_error=(presync_metric_error),
        maximum_metric_covariance_error=metric_error,
        maximum_lorentz_defect=lorentz_error,
        maximum_metric_adjustment=max(
            matrix_relative_error(metric, patch.metric)
            for metric, patch in zip(metrics, selected_patches, strict=True)
        ),
        maximum_coframe_factorization_error=maximum_factor_error,
        affine_cocycle_relative_error=affine_cocycle,
        lorentz_cocycle_relative_error=lorentz_cocycle,
        orientation_time_orientation_gauge_exists=orientation,
        joint_normal_condition=joint_condition,
        passes_selector_gate=selector_gate,
    )


def _none_as_infinity(value: float | None) -> float:
    return math.inf if value is None else value


def synchronization_selector_key(
    audit: SynchronizedTripleAudit | SimpleNamespace,
) -> tuple[object, ...]:
    """Order triples without consulting local or transition test scores."""

    return (
        -int(audit.passes_selector_gate),
        audit.maximum_selector_interval_error,
        audit.maximum_metric_covariance_error,
        _none_as_infinity(audit.maximum_lorentz_defect),
        audit.maximum_selector_transition_error,
        max(
            audit.affine_cocycle_relative_error,
            _none_as_infinity(audit.lorentz_cocycle_relative_error),
        ),
        audit.maximum_metric_adjustment,
        -audit.triple_overlap_count,
        audit.indices,
    )


def select_synchronized_triple(
    audits: list[SynchronizedTripleAudit],
) -> SynchronizedTripleAudit:
    """Select a synchronized triple before opening either test slice."""

    if not audits:
        raise ValueError("at least one synchronized triple audit is required")
    return min(audits, key=synchronization_selector_key)


def coordinate_eligible_patch(
    patch: LocalFittedPatch,
    args: argparse.Namespace,
) -> bool:
    """Require coordinate quality and retained evidence, not the old metric fit."""

    excluded = np.concatenate((patch.active_indices, patch.anchor_indices))
    evaluation_count = int(np.count_nonzero(~np.isin(patch.carrier_indices, excluded)))
    return bool(
        patch.metric_constraint_split is not None
        and patch.anchor_time is not None
        and patch.metric_prior is not None
        and evaluation_count >= args.minimum_evaluation_count
        and patch.chart_leave_one_out_error <= args.maximum_chart_consistency_error
        and patch.chart_dispersion_error <= args.maximum_chart_consistency_error
    )


def unavailable_sample(
    synchronization_weight: float,
    constructed_patch_count: int,
    coordinate_eligible_patch_count: int,
) -> SynchronizedBundleSample:
    """Record an unavailable triangle without fabricating geometric scores."""

    return SynchronizedBundleSample(
        synchronization_weight=synchronization_weight,
        constructed_patch_count=constructed_patch_count,
        coordinate_eligible_patch_count=coordinate_eligible_patch_count,
        selected_pivot_indices=[],
        selected_domain_counts=[],
        selected_core_counts=[],
        minimum_pair_overlap=0,
        triple_overlap_count=0,
        maximum_selector_transition_error=None,
        maximum_test_transition_error=None,
        maximum_transition_design_condition=None,
        maximum_selector_interval_error=None,
        maximum_test_interval_error=None,
        minimum_selector_causal_sign_fraction=None,
        minimum_test_causal_sign_fraction=None,
        maximum_selector_noncausal_violation_fraction=None,
        maximum_test_noncausal_violation_fraction=None,
        maximum_presynchronization_metric_covariance_error=None,
        maximum_metric_covariance_error=None,
        maximum_lorentz_defect=None,
        maximum_metric_adjustment=None,
        maximum_coframe_factorization_error=None,
        affine_cocycle_relative_error=None,
        lorentz_cocycle_relative_error=None,
        orientation_time_orientation_gauge_exists=False,
        joint_normal_condition=None,
        metric_signatures=[],
        maximum_oracle_affine_map_error=None,
        maximum_selected_patch_oracle_coordinate_error=None,
        maximum_synchronized_oracle_metric_error=None,
        passes_selector_gate=False,
        passes_heldout_local_metric_gate=False,
        passes_heldout_transition_gate=False,
        passes_metric_bundle_gate=False,
        passes_spin_prerequisite_gate=False,
        exact_spin_obstruction_class_computed=False,
    )


def sample_from_selected_audit(
    audit: SynchronizedTripleAudit,
    synchronization_weight: float,
    patches: list[LocalFittedPatch],
    domains: list[np.ndarray],
    local_splits: list[LocalMetricHoldoutSplit],
    pair_transitions: dict[tuple[int, int], ThreeWayTransition],
    points: np.ndarray,
    args: argparse.Namespace,
    constructed_patch_count: int,
) -> SynchronizedBundleSample:
    """Open test and oracle controls only after selector-side triple choice."""

    selected_patches = [patches[index] for index in audit.indices]
    selected_domains = [domains[index] for index in audit.indices]
    selected_splits = [local_splits[index] for index in audit.indices]
    test_scores = [
        evaluate_local_metric(
            patch,
            metric,
            split.test_causal,
            split.test_noncausal,
        )
        for patch, metric, split in zip(
            selected_patches, audit.metrics, selected_splits, strict=True
        )
    ]
    maximum_test_interval_error = max(
        score.interval_relative_rmse for score in test_scores
    )
    minimum_test_causal_sign_fraction = min(
        score.causal_sign_fraction for score in test_scores
    )
    maximum_test_noncausal_violation_fraction = max(
        score.noncausal_violation_fraction for score in test_scores
    )
    heldout_local = bool(
        maximum_test_interval_error <= args.maximum_interval_error
        and minimum_test_causal_sign_fraction
        >= args.minimum_heldout_causal_sign_fraction
        and maximum_test_noncausal_violation_fraction
        <= args.maximum_noncausal_violation_fraction
    )
    global_pairs = (
        (audit.indices[0], audit.indices[1]),
        (audit.indices[0], audit.indices[2]),
        (audit.indices[1], audit.indices[2]),
    )
    transitions = [pair_transitions[pair] for pair in global_pairs]
    maximum_test_transition_error = max(
        transition.test_affine_relative_error for transition in transitions
    )
    heldout_transition = bool(
        maximum_test_transition_error <= args.maximum_test_transition_error
    )
    metric_bundle = bool(
        audit.passes_selector_gate and heldout_local and heldout_transition
    )
    oracle_metric_errors = []
    for patch, metric in zip(selected_patches, audit.metrics, strict=True):
        affine = oracle_patch_affine_map(patch, points)
        oracle_metric = affine[:4] @ MINKOWSKI_METRIC @ affine[:4].T
        oracle_metric_errors.append(matrix_relative_error(metric, oracle_metric))
    return SynchronizedBundleSample(
        synchronization_weight=synchronization_weight,
        constructed_patch_count=constructed_patch_count,
        coordinate_eligible_patch_count=len(patches),
        selected_pivot_indices=[patch.pivot_index for patch in selected_patches],
        selected_domain_counts=[len(domain) for domain in selected_domains],
        selected_core_counts=[len(patch.carrier_indices) for patch in selected_patches],
        minimum_pair_overlap=audit.minimum_pair_overlap,
        triple_overlap_count=audit.triple_overlap_count,
        maximum_selector_transition_error=(audit.maximum_selector_transition_error),
        maximum_test_transition_error=maximum_test_transition_error,
        maximum_transition_design_condition=(audit.maximum_transition_design_condition),
        maximum_selector_interval_error=audit.maximum_selector_interval_error,
        maximum_test_interval_error=maximum_test_interval_error,
        minimum_selector_causal_sign_fraction=(
            audit.minimum_selector_causal_sign_fraction
        ),
        minimum_test_causal_sign_fraction=minimum_test_causal_sign_fraction,
        maximum_selector_noncausal_violation_fraction=(
            audit.maximum_selector_noncausal_violation_fraction
        ),
        maximum_test_noncausal_violation_fraction=(
            maximum_test_noncausal_violation_fraction
        ),
        maximum_presynchronization_metric_covariance_error=(
            audit.maximum_presynchronization_metric_covariance_error
        ),
        maximum_metric_covariance_error=audit.maximum_metric_covariance_error,
        maximum_lorentz_defect=audit.maximum_lorentz_defect,
        maximum_metric_adjustment=audit.maximum_metric_adjustment,
        maximum_coframe_factorization_error=(audit.maximum_coframe_factorization_error),
        affine_cocycle_relative_error=audit.affine_cocycle_relative_error,
        lorentz_cocycle_relative_error=audit.lorentz_cocycle_relative_error,
        orientation_time_orientation_gauge_exists=(
            audit.orientation_time_orientation_gauge_exists
        ),
        joint_normal_condition=audit.joint_normal_condition,
        metric_signatures=audit.metric_signatures,
        maximum_oracle_affine_map_error=max(
            transition.oracle_affine_map_relative_error for transition in transitions
        ),
        maximum_selected_patch_oracle_coordinate_error=max(
            patch.oracle_coordinate_error for patch in selected_patches
        ),
        maximum_synchronized_oracle_metric_error=max(oracle_metric_errors),
        passes_selector_gate=audit.passes_selector_gate,
        passes_heldout_local_metric_gate=heldout_local,
        passes_heldout_transition_gate=heldout_transition,
        passes_metric_bundle_gate=metric_bundle,
        passes_spin_prerequisite_gate=bool(
            metric_bundle and audit.orientation_time_orientation_gauge_exists
        ),
        exact_spin_obstruction_class_computed=False,
    )


def reconstruct_realization(
    rng: np.random.Generator,
    args: argparse.Namespace,
) -> dict[str, SynchronizedBundleSample]:
    """Build patches once, then audit every development synchronization weight."""

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
            local_split = split_local_metric_holdout(
                np.random.default_rng(int(seed)),
                patch,
                args.local_selector_fraction,
            )
        except ValueError:
            continue
        eligible.append(patch)
        local_splits.append(local_split)
    unavailable = {
        synchronization_weight_key(weight): unavailable_sample(
            weight, len(constructed), len(eligible)
        )
        for weight in args.synchronization_weights
    }
    if len(eligible) < 3:
        return unavailable

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

    results: dict[str, SynchronizedBundleSample] = {}
    for weight in args.synchronization_weights:
        audits: list[SynchronizedTripleAudit] = []
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
                    audit_synchronized_triple(
                        indices,
                        eligible,
                        domains,
                        local_splits,
                        pair_transitions,
                        weight,
                        args,
                    )
                )
            except (np.linalg.LinAlgError, ValueError):
                continue
        key = synchronization_weight_key(weight)
        if not audits:
            results[key] = unavailable[key]
            continue
        selected = select_synchronized_triple(audits)
        results[key] = sample_from_selected_audit(
            selected,
            weight,
            eligible,
            domains,
            local_splits,
            pair_transitions,
            points,
            args,
            len(constructed),
        )
    return results


def summarize_samples(
    samples: list[SynchronizedBundleSample],
) -> dict[str, object]:
    """Aggregate A20 availability, fidelity, covariance, and gate controls."""

    def statistics(name: str) -> dict[str, float | int]:
        values = [
            float(value)
            for sample in samples
            if (value := getattr(sample, name)) is not None
        ]
        return finite_statistics(values)

    def rate(name: str) -> float:
        return float(np.mean([bool(getattr(sample, name)) for sample in samples]))

    return {
        "samples": len(samples),
        "constructed_patch_count": statistics("constructed_patch_count"),
        "coordinate_eligible_patch_count": statistics(
            "coordinate_eligible_patch_count"
        ),
        "minimum_pair_overlap": statistics("minimum_pair_overlap"),
        "triple_overlap_count": statistics("triple_overlap_count"),
        "maximum_selector_transition_error": statistics(
            "maximum_selector_transition_error"
        ),
        "maximum_test_transition_error": statistics("maximum_test_transition_error"),
        "maximum_selector_interval_error": statistics(
            "maximum_selector_interval_error"
        ),
        "maximum_test_interval_error": statistics("maximum_test_interval_error"),
        "minimum_selector_causal_sign_fraction": statistics(
            "minimum_selector_causal_sign_fraction"
        ),
        "minimum_test_causal_sign_fraction": statistics(
            "minimum_test_causal_sign_fraction"
        ),
        "maximum_selector_noncausal_violation_fraction": statistics(
            "maximum_selector_noncausal_violation_fraction"
        ),
        "maximum_test_noncausal_violation_fraction": statistics(
            "maximum_test_noncausal_violation_fraction"
        ),
        "maximum_presynchronization_metric_covariance_error": statistics(
            "maximum_presynchronization_metric_covariance_error"
        ),
        "maximum_metric_covariance_error": statistics(
            "maximum_metric_covariance_error"
        ),
        "maximum_lorentz_defect": statistics("maximum_lorentz_defect"),
        "maximum_metric_adjustment": statistics("maximum_metric_adjustment"),
        "affine_cocycle_relative_error": statistics("affine_cocycle_relative_error"),
        "lorentz_cocycle_relative_error": statistics("lorentz_cocycle_relative_error"),
        "joint_normal_condition": statistics("joint_normal_condition"),
        "maximum_oracle_affine_map_error": statistics(
            "maximum_oracle_affine_map_error"
        ),
        "maximum_selected_patch_oracle_coordinate_error": statistics(
            "maximum_selected_patch_oracle_coordinate_error"
        ),
        "maximum_synchronized_oracle_metric_error": statistics(
            "maximum_synchronized_oracle_metric_error"
        ),
        "orientation_time_orientation_success_rate": rate(
            "orientation_time_orientation_gauge_exists"
        ),
        "selector_gate_success_rate": rate("passes_selector_gate"),
        "heldout_local_metric_gate_success_rate": rate(
            "passes_heldout_local_metric_gate"
        ),
        "heldout_transition_gate_success_rate": rate("passes_heldout_transition_gate"),
        "metric_bundle_gate_success_rate": rate("passes_metric_bundle_gate"),
        "spin_prerequisite_gate_success_rate": rate("passes_spin_prerequisite_gate"),
    }


def select_development_weight(
    summaries: dict[str, dict[str, object]],
    weights: list[float],
) -> float:
    """Freeze the weight by development gates before any held-out run."""

    def median(summary: dict[str, object], name: str) -> float:
        value = summary[name]
        if not isinstance(value, dict) or value.get("count", 0) == 0:
            return math.inf
        return float(value["median"])

    def score(weight: float) -> tuple[float, ...]:
        summary = summaries[synchronization_weight_key(weight)]
        return (
            -float(summary["spin_prerequisite_gate_success_rate"]),
            -float(summary["metric_bundle_gate_success_rate"]),
            -float(summary["selector_gate_success_rate"]),
            median(summary, "maximum_test_interval_error"),
            median(summary, "maximum_metric_covariance_error"),
            median(summary, "maximum_test_transition_error"),
            weight,
        )

    return min(weights, key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run development weight selection or one frozen held-out A20 audit."""

    if args.mode == "held-out" and len(args.synchronization_weights) != 1:
        raise ValueError("held-out mode requires one frozen synchronization weight")
    master = np.random.default_rng(args.seed)
    realization_seeds = master.integers(0, 2**63 - 1, size=args.realizations)
    by_weight = {
        synchronization_weight_key(weight): []
        for weight in args.synchronization_weights
    }
    for seed in realization_seeds:
        realization = reconstruct_realization(np.random.default_rng(int(seed)), args)
        for key, sample in realization.items():
            by_weight[key].append(sample)
    summaries = {key: summarize_samples(samples) for key, samples in by_weight.items()}
    selected_weight = (
        select_development_weight(summaries, args.synchronization_weights)
        if args.mode == "development"
        else args.synchronization_weights[0]
    )
    selected_key = synchronization_weight_key(selected_weight)
    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "stage": "A20 synchronized conditional metric/coframe bundle",
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
            "synchronization_weights": args.synchronization_weights,
            "local_selector_fraction": args.local_selector_fraction,
            "transition_fit_fraction": args.transition_fit_fraction,
            "transition_selector_fraction": args.transition_selector_fraction,
            "minimum_pair_overlap": args.minimum_pair_overlap,
            "minimum_triple_overlap": args.minimum_triple_overlap,
            "maximum_interval_error": args.maximum_interval_error,
            "maximum_metric_covariance_error": (args.maximum_metric_covariance_error),
            "maximum_lorentz_defect": args.maximum_lorentz_defect,
            "maximum_cocycle_error": args.maximum_cocycle_error,
        },
        "selected_synchronization_weight": selected_weight,
        "weight_selection_rule": (
            "maximize development spin, bundle, and selector pass counts; "
            "then minimize untouched local interval, covariance, and untouched "
            "transition medians"
        ),
        "selection_blinding": (
            "triple selection excludes local test constraints, overlap test "
            "errors, and all sprinkling-coordinate oracle controls"
        ),
        "summaries": summaries,
        "selected_summary": summaries[selected_key],
        "caveat": (
            "dimension, density, endpoints, scale, and a transported Lorentz "
            "prior remain supplied; this does not derive a tetrad from a bare graph"
        ),
    }
    if args.include_samples:
        result["samples"] = {
            key: [asdict(sample) for sample in samples]
            for key, samples in by_weight.items()
        }
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
        "--maximum-transition-design-condition", type=float, default=50.0
    )
    parser.add_argument("--maximum-metric-covariance-error", type=float, default=0.35)
    parser.add_argument("--maximum-lorentz-defect", type=float, default=0.35)
    parser.add_argument("--maximum-cocycle-error", type=float, default=0.25)
    parser.add_argument(
        "--maximum-coframe-factorization-error", type=float, default=1.0e-10
    )
    parser.add_argument("--maximum-joint-normal-condition", type=float, default=1.0e8)
    parser.add_argument(
        "--synchronization-weights",
        type=float,
        nargs="+",
        default=[0.0, 0.01, 0.1, 1.0, 10.0, 100.0],
    )
    parser.add_argument("--seed", type=int, default=20260860)
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
