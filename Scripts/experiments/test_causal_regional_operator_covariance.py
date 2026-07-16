import numpy as np
import pytest

from causal_continuum_kernel_moments import CutoffProfile
from causal_discrete_germ_moments import append_marked_events
from causal_operator_metric import sprinkle_minkowski_diamond
from causal_regional_operator_covariance import (
    REGIONAL_FIELD_NAMES,
    RegionalRealization,
    covariance_ledger,
    global_order_counts,
    regional_pivot_responses,
    select_deep_pivots,
)
from causal_reusable_relation import build_packed_causal_relation


def make_realization(values: list[float]) -> RegionalRealization:
    responses = {
        name: list(values)
        for name in (
            "constant",
            "temporal_affine",
            "temporal_quadratic",
            "spatial_quadratic",
            "temporal_cubic",
            "temporal_spatial_cubic",
        )
    }
    return RegionalRealization(
        pivot_indices=list(range(len(values))),
        pivot_depths=[10] * len(values),
        depth_threshold=10,
        responses=responses,
    )


def test_selector_retains_threshold_ties() -> None:
    past = np.array([0, 3, 4, 4, 4, 2])
    future = np.array([5, 3, 4, 4, 4, 2])
    selected, depths, threshold = select_deep_pivots(
        past, future, minimum_pivots=2, excluded_indices=(0,)
    )
    assert threshold == 4
    assert selected.tolist() == [2, 3, 4]
    assert depths.tolist() == [4, 4, 4]


def test_global_counts_and_selector_are_relabeling_covariant() -> None:
    random_points, random_top = sprinkle_minkowski_diamond(
        np.random.default_rng(20261500), 100, 2.0
    )
    points, bottom, _, top = append_marked_events(random_points, random_top, 2.0)
    past, future = global_order_counts(points, 32)
    selected, _, threshold = select_deep_pivots(
        past, future, 5, excluded_indices=(bottom, top)
    )

    permutation = np.random.default_rng(20261501).permutation(len(points))
    inverse = np.empty_like(permutation)
    inverse[permutation] = np.arange(len(permutation))
    permuted_points = points[permutation]
    permuted_past, permuted_future = global_order_counts(permuted_points, 32)
    permuted_selected, _, permuted_threshold = select_deep_pivots(
        permuted_past,
        permuted_future,
        5,
        excluded_indices=(int(inverse[bottom]), int(inverse[top])),
    )
    original_labels = np.sort(permutation[permuted_selected])
    assert permuted_threshold == threshold
    assert np.array_equal(original_labels, np.sort(selected))


def test_covariance_ledger_keeps_positive_shared_covariance() -> None:
    ledger = covariance_ledger(
        [make_realization([1.0, 1.0]), make_realization([-1.0, -1.0])]
    )
    field = ledger["fields"]["temporal_quadratic"]
    assert field["diagonal_contribution"] == pytest.approx(0.5)
    assert field["off_diagonal_contribution"] == pytest.approx(0.5)
    assert field["regional_mean_second_moment"] == pytest.approx(1.0)
    assert field["effective_pivot_count"] == pytest.approx(1.0)
    assert field["decomposition_error"] < 1.0e-15


def test_covariance_ledger_keeps_negative_shared_covariance() -> None:
    ledger = covariance_ledger(
        [make_realization([1.0, -1.0]), make_realization([-1.0, 1.0])]
    )
    field = ledger["fields"]["temporal_quadratic"]
    assert field["diagonal_contribution"] == pytest.approx(0.5)
    assert field["off_diagonal_contribution"] == pytest.approx(-0.5)
    assert field["regional_mean_second_moment"] == pytest.approx(0.0)
    assert field["effective_pivot_count"] is None
    assert field["decomposition_error"] < 1.0e-15


def test_small_regional_operator_fixture_is_finite_and_deep() -> None:
    events = 200
    random_points, random_top = sprinkle_minkowski_diamond(
        np.random.default_rng(20261502), events, 2.0
    )
    points, bottom, _, top = append_marked_events(random_points, random_top, 2.0)
    result = regional_pivot_responses(
        points=points,
        bottom_index=bottom,
        top_index=top,
        random_events=events,
        duration=2.0,
        nonlocality_ratio=0.50,
        profile=CutoffProfile("primary", 0.02, 0.08),
        minimum_pivots=3,
        block_size=32,
    )
    assert len(result.pivot_indices) >= 3
    assert all(depth >= result.depth_threshold for depth in result.pivot_depths)
    assert all(
        np.all(np.isfinite(values)) and len(values) == len(result.pivot_indices)
        for values in result.responses.values()
    )


def test_reusable_relation_preserves_regional_outputs() -> None:
    events = 200
    random_points, random_top = sprinkle_minkowski_diamond(
        np.random.default_rng(20261505), events, 2.0
    )
    points, bottom, _, top = append_marked_events(random_points, random_top, 2.0)
    profile = CutoffProfile("primary", 0.02, 0.08)
    direct = regional_pivot_responses(
        points, bottom, top, events, 2.0, 0.50, profile, 3, 32
    )
    cache = build_packed_causal_relation(points, 17, 64)
    reused = regional_pivot_responses(
        points,
        bottom,
        top,
        events,
        2.0,
        0.50,
        profile,
        3,
        32,
        cache,
    )
    assert reused.pivot_indices == direct.pivot_indices
    assert reused.pivot_depths == direct.pivot_depths
    assert reused.depth_threshold == direct.depth_threshold
    for name in direct.responses:
        assert reused.responses[name] == pytest.approx(
            direct.responses[name], abs=1.0e-12
        )


def test_expanded_regional_fields_cover_full_symmetric_metric() -> None:
    events = 200
    random_points, random_top = sprinkle_minkowski_diamond(
        np.random.default_rng(20261506), events, 2.0
    )
    points, bottom, _, top = append_marked_events(random_points, random_top, 2.0)
    cache = build_packed_causal_relation(points, 17, 64)
    result = regional_pivot_responses(
        points,
        bottom,
        top,
        events,
        2.0,
        0.50,
        CutoffProfile("primary", 0.02, 0.08),
        3,
        32,
        cache,
        expanded_fields=True,
    )
    assert tuple(result.responses) == REGIONAL_FIELD_NAMES
    assert all(
        len(values) == len(result.pivot_indices)
        and np.all(np.isfinite(values))
        for values in result.responses.values()
    )


def test_regional_operator_pipeline_is_relabeling_covariant() -> None:
    events = 200
    random_points, random_top = sprinkle_minkowski_diamond(
        np.random.default_rng(20261503), events, 2.0
    )
    points, bottom, _, top = append_marked_events(random_points, random_top, 2.0)
    profile = CutoffProfile("primary", 0.02, 0.08)
    original = regional_pivot_responses(
        points,
        bottom,
        top,
        events,
        2.0,
        0.50,
        profile,
        3,
        32,
    )

    permutation = np.random.default_rng(20261504).permutation(len(points))
    inverse = np.empty_like(permutation)
    inverse[permutation] = np.arange(len(permutation))
    permuted = regional_pivot_responses(
        points[permutation],
        int(inverse[bottom]),
        int(inverse[top]),
        events,
        2.0,
        0.50,
        profile,
        3,
        32,
    )
    mapped_permuted_pivots = [
        int(permutation[index]) for index in permuted.pivot_indices
    ]
    assert sorted(mapped_permuted_pivots) == sorted(original.pivot_indices)
    for name in original.responses:
        original_by_pivot = dict(zip(original.pivot_indices, original.responses[name]))
        permuted_by_pivot = dict(
            zip(mapped_permuted_pivots, permuted.responses[name])
        )
        assert original_by_pivot.keys() == permuted_by_pivot.keys()
        for pivot in original_by_pivot:
            assert permuted_by_pivot[pivot] == pytest.approx(
                original_by_pivot[pivot], abs=1.0e-12
            )


@pytest.mark.parametrize("minimum_pivots", [0, -1])
def test_selector_rejects_nonpositive_pivot_count(minimum_pivots: int) -> None:
    with pytest.raises(ValueError):
        select_deep_pivots(
            np.array([1, 2]), np.array([1, 2]), minimum_pivots
        )
