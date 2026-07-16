import numpy as np

from causal_continuum_kernel_moments import CutoffProfile
from causal_discrete_germ_moments import (
    append_marked_events,
    marked_past_statistics,
    marked_row_data,
    oracle_polynomial_fields,
)


def _chain_points() -> tuple[np.ndarray, int, int, int]:
    random_with_top = np.array(
        [
            [0.25, 0.0, 0.0, 0.0],
            [0.75, 0.0, 0.0, 0.0],
            [1.25, 0.0, 0.0, 0.0],
            [2.0, 0.0, 0.0, 0.0],
        ]
    )
    return append_marked_events(random_with_top, 3, 2.0)


def test_marked_past_counts_on_timelike_chain() -> None:
    points, _, pivot, _ = _chain_points()
    indices, past, future, to_pivot = marked_past_statistics(points, pivot, 2)
    assert np.array_equal(indices, np.array([0, 1, 2]))
    assert np.array_equal(past, np.array([0, 1, 2]))
    assert np.array_equal(to_pivot, np.array([2, 1, 0]))
    assert np.array_equal(future, np.array([5, 4, 3]))


def test_marked_cutoff_is_exact_at_endpoints_and_pivot() -> None:
    points, bottom, pivot, top = _chain_points()
    data = marked_row_data(
        points,
        bottom,
        pivot,
        top,
        events=3,
        duration=2.0,
        nonlocality_ratio=0.99,
        profile=CutoffProfile("test", 0.02, 0.08),
        block_size=2,
    )
    assert data.cutoff[bottom] == 0.0
    assert data.cutoff[pivot] == 1.0
    assert data.cutoff[top] == 0.0
    fields = oracle_polynomial_fields(points, pivot, data.cutoff)
    assert fields["constant"][pivot] == 1.0
    assert fields["temporal_affine"][pivot] == 0.0


def test_marked_row_and_cutoff_are_relabeling_covariant() -> None:
    points, bottom, pivot, top = _chain_points()
    profile = CutoffProfile("test", 0.02, 0.08)
    original = marked_row_data(
        points, bottom, pivot, top, 3, 2.0, 0.99, profile, 2
    )
    permutation = np.array([3, 0, 5, 1, 4, 2])
    inverse = np.argsort(permutation)
    relabeled = marked_row_data(
        points[permutation],
        int(inverse[bottom]),
        int(inverse[pivot]),
        int(inverse[top]),
        3,
        2.0,
        0.99,
        profile,
        2,
    )
    assert np.allclose(relabeled.row[inverse], original.row)
    assert np.allclose(relabeled.cutoff[inverse], original.cutoff)


def test_reused_marked_statistics_leave_row_and_cutoff_unchanged() -> None:
    points, bottom, pivot, top = _chain_points()
    profile = CutoffProfile("test", 0.02, 0.08)
    statistics = marked_past_statistics(points, pivot, 2)
    direct = marked_row_data(
        points, bottom, pivot, top, 3, 2.0, 0.99, profile, 2
    )
    reused = marked_row_data(
        points,
        bottom,
        pivot,
        top,
        3,
        2.0,
        0.99,
        profile,
        2,
        statistics,
    )
    assert np.array_equal(reused.row, direct.row)
    assert np.array_equal(reused.cutoff, direct.cutoff)
    assert np.array_equal(reused.depth_ratio, direct.depth_ratio)
