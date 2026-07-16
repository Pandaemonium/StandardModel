from pathlib import Path

import numpy as np
import pytest

from causal_discrete_germ_moments import (
    append_marked_events,
    marked_past_statistics,
)
from causal_operator_metric import sprinkle_minkowski_diamond, strictly_precedes
from causal_reusable_relation import (
    build_packed_causal_relation,
    packed_relation_bytes,
    relation_scratch_upper_bound_bytes,
)


def random_fixture(events: int = 120) -> np.ndarray:
    random_points, random_top = sprinkle_minkowski_diamond(
        np.random.default_rng(20261510), events, 2.0
    )
    points, _, _, _ = append_marked_events(random_points, random_top, 2.0)
    return points


def test_packed_relation_matches_dense_strict_order() -> None:
    points = random_fixture()
    cache = build_packed_causal_relation(points, 17, 64)
    dense = strictly_precedes(points[:, None, :], points[None, :, :])
    assert np.array_equal(cache.dense_relation(), dense)
    assert np.array_equal(cache.future_count, np.count_nonzero(dense, axis=1))
    assert np.array_equal(cache.past_count, np.count_nonzero(dense, axis=0))


@pytest.mark.parametrize("pivot_index", [0, 7, 60, 121])
def test_reusable_pivot_statistics_match_direct(pivot_index: int) -> None:
    points = random_fixture()
    cache = build_packed_causal_relation(points, 17, 64)
    direct = marked_past_statistics(points, pivot_index, 19)
    reused = cache.marked_past_statistics(pivot_index, 19)
    for actual, expected in zip(reused, direct):
        assert np.array_equal(actual, expected)


def test_disk_backed_cache_has_exact_raw_size(tmp_path: Path) -> None:
    points = random_fixture(33)
    path = tmp_path / "relation.bin"
    cache = build_packed_causal_relation(points, 7, 16, path)
    expected = packed_relation_bytes(len(points))
    assert cache.storage_bytes == expected
    assert path.stat().st_size == expected
    assert isinstance(cache.packed_rows, np.memmap)
    cache.close()


def test_resource_formulas_reject_invalid_inputs() -> None:
    with pytest.raises(ValueError):
        packed_relation_bytes(-1)
    with pytest.raises(ValueError):
        relation_scratch_upper_bound_bytes(0, 8)
    with pytest.raises(ValueError):
        build_packed_causal_relation(np.zeros((4, 4)), 2, 7)


def test_padding_bits_do_not_create_interval_events() -> None:
    points = random_fixture(12)
    assert len(points) % 8 != 0
    cache = build_packed_causal_relation(points, 5, 16)
    dense = cache.dense_relation()
    for pivot in range(len(points)):
        past_indices, counts = cache.interval_counts_to_pivot(pivot, 5)
        expected = np.count_nonzero(
            dense[past_indices] & dense[:, pivot][None, :], axis=1
        )
        assert np.array_equal(counts, expected)
