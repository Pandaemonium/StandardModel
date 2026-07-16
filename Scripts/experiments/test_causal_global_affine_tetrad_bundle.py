from types import SimpleNamespace

import numpy as np

from causal_compatible_tetrad_bundle import ThreeWayTransition
from causal_frame_constrained_metric import (
    MINKOWSKI_METRIC,
    MetricConstraintSplit,
)
from causal_global_affine_tetrad_bundle import (
    exact_bundle_controls,
    exact_pair_transitions,
    fit_global_affine_gauges,
    fit_pooled_global_metric,
    global_affine_selector_key,
)
from causal_operator_metric import matrix_relative_error
from causal_tetrad_bundle_atlas import (
    LocalFittedPatch,
    homogeneous_affine_matrix,
)


def _synthetic_bundle() -> tuple[
    list[LocalFittedPatch],
    list[np.ndarray],
    dict[tuple[int, int], ThreeWayTransition],
]:
    rng = np.random.default_rng(31)
    pair_count = 40
    origins = rng.normal(scale=0.4, size=(pair_count, 4))
    displacement = rng.normal(size=(pair_count, 4))
    displacement[:, 0] += 1.5
    global_coordinates = np.empty((2 * pair_count, 4))
    global_coordinates[0::2] = origins
    global_coordinates[1::2] = origins + displacement
    linear_maps = [
        np.eye(4),
        np.array(
            [
                [1.0, 0.1, 0.0, 0.0],
                [0.0, 1.1, 0.1, 0.0],
                [0.0, 0.0, 0.9, 0.1],
                [0.0, 0.0, 0.0, 1.0],
            ]
        ),
        np.array(
            [
                [0.9, 0.0, 0.1, 0.0],
                [0.0, 1.0, 0.0, 0.1],
                [0.0, 0.1, 1.2, 0.0],
                [0.0, 0.0, 0.0, 1.1],
            ]
        ),
    ]
    coefficient_maps = [np.vstack((linear, np.zeros(4))) for linear in linear_maps]
    global_maps = [homogeneous_affine_matrix(item) for item in coefficient_maps]
    left = 2 * np.arange(pair_count)
    right = left + 1
    patches = []
    for linear in linear_maps:
        local_coordinates = global_coordinates @ np.linalg.inv(linear)
        local_metric = linear @ MINKOWSKI_METRIC @ linear.T
        local_displacement = local_coordinates[right] - local_coordinates[left]
        target = np.einsum(
            "ni,ij,nj->n", local_displacement, local_metric, local_displacement
        )
        split = MetricConstraintSplit(
            causal_left=left,
            causal_right=right,
            causal_target_squared=target,
            causal_weight=np.ones(pair_count),
            causal_train=np.arange(30),
            causal_heldout=np.arange(30, 40),
            noncausal_left=left[:12],
            noncausal_right=np.roll(right[:12], 1),
        )
        patches.append(
            LocalFittedPatch(
                pivot_index=0,
                center_distance=0.0,
                active_indices=np.array([], dtype=int),
                anchor_indices=np.arange(5),
                carrier_indices=np.arange(2 * pair_count),
                consensus_coordinates=local_coordinates,
                chart_support=np.full(2 * pair_count, 3),
                metric=local_metric,
                coframe=linear,
                passes_intrinsic_patch_gate=True,
                chart_leave_one_out_error=0.0,
                chart_dispersion_error=0.0,
                heldout_interval_error=0.0,
                noncausal_violation_fraction=0.0,
                causal_sensitivity=1.0,
                causal_specificity=1.0,
                oracle_coordinate_error=0.0,
                oracle_metric_error=0.0,
                metric_constraint_split=split,
                anchor_time=1.0,
                metric_prior=local_metric,
            )
        )
    transition_matrices = exact_pair_transitions(global_maps)
    transitions = {}
    fit_events = np.arange(48)
    selector_events = np.arange(48, 64)
    test_events = np.arange(64, 80)
    for left_index, right_index in ((0, 1), (0, 2), (1, 2)):
        matrix = transition_matrices[(left_index, right_index)]
        transitions[(left_index, right_index)] = ThreeWayTransition(
            source_patch=left_index,
            target_patch=right_index,
            overlap_count=80,
            fit_count=len(fit_events),
            selector_count=len(selector_events),
            test_count=len(test_events),
            affine_map=matrix,
            selector_affine_relative_error=0.0,
            test_affine_relative_error=0.0,
            affine_design_condition=1.0,
            metric_covariance_relative_error=0.0,
            lorentz_defect_relative_error=0.0,
            internal_transition=np.eye(4),
            oracle_affine_map_relative_error=0.0,
            fit_event_indices=fit_events,
            selector_event_indices=selector_events,
            test_event_indices=test_events,
        )
    return patches, global_maps, transitions


def test_global_affine_fit_recovers_known_patch_gauges() -> None:
    patches, expected_maps, transitions = _synthetic_bundle()
    actual_maps, design_condition, map_condition = fit_global_affine_gauges(
        patches, transitions
    )
    assert design_condition < 100.0
    assert map_condition < 2.0
    for actual, expected in zip(actual_maps, expected_maps, strict=True):
        assert np.allclose(actual, expected, atol=1.0e-10)


def test_pooled_metric_recovers_global_minkowski_form() -> None:
    patches, global_maps, _ = _synthetic_bundle()
    metric, condition = fit_pooled_global_metric(
        patches, global_maps, metric_regularization=0.1
    )
    assert condition < 100.0
    assert matrix_relative_error(metric, MINKOWSKI_METRIC) < 1.0e-10


def test_exact_global_pullbacks_have_exact_bundle_controls() -> None:
    patches, global_maps, _ = _synthetic_bundle()
    transitions = exact_pair_transitions(global_maps)
    metrics = [patch.metric for patch in patches]
    coframes = [patch.coframe for patch in patches]
    controls = exact_bundle_controls(transitions, metrics, coframes)
    assert all(value is not None and value < 1.0e-10 for value in controls[:5])
    assert controls[5]


def test_global_affine_selector_key_ignores_test_and_oracle_scores() -> None:
    common = dict(
        passes_selector_gate=True,
        maximum_selector_interval_error=0.1,
        maximum_selector_transition_error=0.1,
        maximum_metric_adjustment=0.1,
        global_gauge_design_condition=10.0,
        triple_overlap_count=50,
        indices=(0, 1, 2),
    )
    first = SimpleNamespace(
        **common,
        maximum_test_interval_error=0.01,
        maximum_test_transition_error=0.01,
        maximum_oracle_affine_map_error=0.01,
    )
    second = SimpleNamespace(
        **common,
        maximum_test_interval_error=100.0,
        maximum_test_transition_error=100.0,
        maximum_oracle_affine_map_error=100.0,
    )
    assert global_affine_selector_key(first) == global_affine_selector_key(second)
