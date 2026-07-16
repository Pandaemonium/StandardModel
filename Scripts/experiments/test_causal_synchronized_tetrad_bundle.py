from types import SimpleNamespace

import numpy as np

from causal_compatible_tetrad_bundle import ThreeWayTransition
from causal_frame_constrained_metric import (
    MINKOWSKI_METRIC,
    MetricConstraintSplit,
    factor_lorentzian_metric,
    metric_signature,
    symmetric_matrix_to_vector,
)
from causal_operator_metric import matrix_relative_error
from causal_synchronized_tetrad_bundle import (
    fit_synchronized_metrics,
    split_local_metric_holdout,
    symmetric_transport_operator,
    synchronization_selector_key,
)
from causal_tetrad_bundle_atlas import (
    LocalFittedPatch,
    homogeneous_affine_matrix,
)


def _synthetic_patch(
    physical_coordinates: np.ndarray,
    coordinate_map: np.ndarray,
    target_scale: float,
) -> LocalFittedPatch:
    coordinates = physical_coordinates @ coordinate_map
    inverse = np.linalg.inv(coordinate_map)
    metric = target_scale * inverse @ MINKOWSKI_METRIC @ inverse.T
    pair_count = len(coordinates) // 2
    left = 2 * np.arange(pair_count)
    right = left + 1
    displacement = coordinates[right] - coordinates[left]
    target = np.einsum("ni,ij,nj->n", displacement, metric, displacement)
    heldout = np.arange(pair_count - 8, pair_count)
    train = np.arange(pair_count - 8)
    noncausal_left = left[:12]
    noncausal_right = np.roll(right[:12], 1)
    split = MetricConstraintSplit(
        causal_left=left,
        causal_right=right,
        causal_target_squared=target,
        causal_weight=np.ones(pair_count),
        causal_train=train,
        causal_heldout=heldout,
        noncausal_left=noncausal_left,
        noncausal_right=noncausal_right,
    )
    coframe, error = factor_lorentzian_metric(metric)
    assert coframe is not None
    assert error is not None and error < 1.0e-10
    event_count = len(coordinates)
    return LocalFittedPatch(
        pivot_index=0,
        center_distance=0.0,
        active_indices=np.array([], dtype=int),
        anchor_indices=np.arange(5),
        carrier_indices=np.arange(event_count),
        consensus_coordinates=coordinates,
        chart_support=np.full(event_count, 3),
        metric=metric,
        coframe=coframe,
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
        metric_prior=metric,
    )


def _transition(
    left: int,
    right: int,
    linear: np.ndarray,
) -> ThreeWayTransition:
    coefficients = np.vstack((linear, np.zeros(4)))
    return ThreeWayTransition(
        source_patch=left,
        target_patch=right,
        overlap_count=50,
        fit_count=30,
        selector_count=10,
        test_count=10,
        affine_map=homogeneous_affine_matrix(coefficients),
        selector_affine_relative_error=0.0,
        test_affine_relative_error=0.0,
        affine_design_condition=1.0,
        metric_covariance_relative_error=0.0,
        lorentz_defect_relative_error=0.0,
        internal_transition=np.eye(4),
        oracle_affine_map_relative_error=0.0,
    )


def test_symmetric_transport_operator_matches_matrix_transport() -> None:
    linear = np.array(
        [
            [1.1, 0.2, 0.0, 0.1],
            [0.0, 0.9, 0.1, 0.0],
            [0.1, 0.0, 1.2, 0.2],
            [0.0, 0.1, 0.0, 0.8],
        ]
    )
    metric = np.array(
        [
            [1.3, 0.2, 0.1, -0.1],
            [0.2, -1.0, 0.3, 0.0],
            [0.1, 0.3, -0.8, 0.2],
            [-0.1, 0.0, 0.2, -1.1],
        ]
    )
    operator = symmetric_transport_operator(linear)
    expected = symmetric_matrix_to_vector(linear @ metric @ linear.T)
    actual = operator @ symmetric_matrix_to_vector(metric)
    assert np.allclose(actual, expected)


def test_joint_fit_reduces_metric_covariance_without_changing_inertia() -> None:
    rng = np.random.default_rng(17)
    pair_count = 30
    origins = rng.normal(scale=0.2, size=(pair_count, 4))
    displacement = np.column_stack(
        (
            np.full(pair_count, 2.0),
            rng.normal(scale=0.25, size=(pair_count, 3)),
        )
    )
    physical = np.empty((2 * pair_count, 4))
    physical[0::2] = origins
    physical[1::2] = origins + displacement
    coordinate_maps = [
        np.eye(4),
        np.array(
            [
                [1.0, 0.1, 0.0, 0.0],
                [0.0, 1.1, 0.0, 0.0],
                [0.0, 0.0, 0.9, 0.1],
                [0.0, 0.0, 0.0, 1.0],
            ]
        ),
        np.array(
            [
                [0.9, 0.0, 0.1, 0.0],
                [0.0, 1.0, 0.0, 0.1],
                [0.0, 0.0, 1.2, 0.0],
                [0.0, 0.0, 0.0, 1.1],
            ]
        ),
    ]
    patches = [
        _synthetic_patch(physical, coordinate_map, target_scale)
        for coordinate_map, target_scale in zip(
            coordinate_maps, (1.0, 1.25, 0.75), strict=True
        )
    ]
    transitions = {}
    for left, right in ((0, 1), (0, 2), (1, 2)):
        linear = np.linalg.solve(coordinate_maps[left], coordinate_maps[right])
        transitions[(left, right)] = _transition(left, right, linear)

    independent, _ = fit_synchronized_metrics(
        patches, transitions, metric_regularization=0.1, synchronization_weight=0.0
    )
    synchronized, _ = fit_synchronized_metrics(
        patches,
        transitions,
        metric_regularization=0.1,
        synchronization_weight=1.0e6,
    )

    def maximum_covariance_error(metrics: list[np.ndarray]) -> float:
        return max(
            matrix_relative_error(
                transition.affine_map[:4, :4]
                @ metrics[right]
                @ transition.affine_map[:4, :4].T,
                metrics[left],
            )
            for (left, right), transition in transitions.items()
        )

    assert maximum_covariance_error(synchronized) < (
        0.05 * maximum_covariance_error(independent)
    )
    assert [metric_signature(metric) for metric in synchronized] == [(1, 3, 0)] * 3


def test_local_metric_selector_and_test_slices_are_disjoint() -> None:
    rng = np.random.default_rng(23)
    physical = rng.normal(size=(60, 4))
    patch = _synthetic_patch(physical, np.eye(4), 1.0)
    split = split_local_metric_holdout(
        np.random.default_rng(29), patch, selector_fraction=0.5
    )
    retained = patch.metric_constraint_split
    assert retained is not None
    assert set(split.selector_causal).isdisjoint(split.test_causal)
    assert set(split.selector_causal) | set(split.test_causal) == set(
        retained.causal_heldout
    )
    assert set(split.selector_noncausal).isdisjoint(split.test_noncausal)
    assert set(split.selector_noncausal) | set(split.test_noncausal) == set(
        range(len(retained.noncausal_left))
    )


def test_selector_key_does_not_consult_untouched_scores() -> None:
    common = dict(
        passes_selector_gate=True,
        maximum_selector_interval_error=0.1,
        maximum_metric_covariance_error=0.2,
        maximum_lorentz_defect=0.2,
        maximum_selector_transition_error=0.1,
        affine_cocycle_relative_error=0.1,
        lorentz_cocycle_relative_error=0.1,
        maximum_metric_adjustment=0.2,
        triple_overlap_count=50,
        indices=(0, 1, 2),
    )
    first = SimpleNamespace(
        **common,
        maximum_test_interval_error=0.01,
        maximum_test_transition_error=0.01,
    )
    second = SimpleNamespace(
        **common,
        maximum_test_interval_error=100.0,
        maximum_test_transition_error=100.0,
    )
    assert synchronization_selector_key(first) == synchronization_selector_key(second)
