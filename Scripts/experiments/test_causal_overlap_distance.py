import numpy as np
import pytest

from causal_overlap_distance import (
    asymptotic_overlap_distance_proxy,
    causal_overlap_counts,
    overlap_distance_1p1,
    validate_strict_order,
)


def rank_order(ranks: list[int]) -> np.ndarray:
    values = np.asarray(ranks)
    return values[:, None] < values[None, :]


def test_four_event_fork_has_unit_overlap_and_unrelated_tips() -> None:
    relation = rank_order([0, 1, 2, 2])
    assert not relation[2, 3] and not relation[3, 2]
    result = causal_overlap_counts(relation, 0, 2, 3)
    assert result.common_count == 1
    assert result.left_interval_count == 1
    assert result.right_interval_count == 1
    assert result.overlap == pytest.approx(1.0)


def test_partial_overlap_uses_smaller_full_interval() -> None:
    relation = np.zeros((6, 6), dtype=bool)
    edges = [(0, 1), (1, 4), (1, 5), (0, 2), (2, 4), (0, 3), (3, 5)]
    for source, target in edges:
        relation[source, target] = True
    relation[0, 4] = True
    relation[0, 5] = True
    result = causal_overlap_counts(relation, 0, 4, 5)
    assert result.common_count == 1
    assert result.left_interval_count == 2
    assert result.right_interval_count == 2
    assert result.overlap == pytest.approx(0.5)


def test_overlap_is_symmetric_and_relabeling_invariant() -> None:
    relation = rank_order([0, 1, 2, 2, 1])
    original = causal_overlap_counts(relation, 0, 2, 3)
    swapped = causal_overlap_counts(relation, 0, 3, 2)
    assert swapped.overlap == pytest.approx(original.overlap)

    permutation = np.array([3, 0, 4, 2, 1])
    inverse = np.empty_like(permutation)
    inverse[permutation] = np.arange(len(permutation))
    permuted_relation = relation[np.ix_(permutation, permutation)]
    permuted = causal_overlap_counts(
        permuted_relation,
        int(inverse[0]),
        int(inverse[2]),
        int(inverse[3]),
    )
    assert permuted == original


def test_overlap_distance_is_positive_and_scale_homogeneous() -> None:
    base = overlap_distance_1p1(2.0, 0.25)
    scaled = overlap_distance_1p1(6.0, 0.25)
    assert base == pytest.approx(3.0)
    assert scaled == pytest.approx(3.0 * base)


def test_asymptotic_proxy_is_scale_homogeneous() -> None:
    base = asymptotic_overlap_distance_proxy(2.5, 3.0, 0.8)
    scaled = asymptotic_overlap_distance_proxy(2.5, 12.0, 0.8)
    assert scaled == pytest.approx(4.0 * base)


def test_invalid_order_is_rejected() -> None:
    nontransitive = np.array(
        [[False, True, False], [False, False, True], [False, False, False]]
    )
    with pytest.raises(ValueError, match="transitive"):
        validate_strict_order(nontransitive)


@pytest.mark.parametrize(
    ("proper_time", "overlap"), [(-1.0, 0.5), (1.0, 0.0), (1.0, 1.1)]
)
def test_invalid_1p1_distance_inputs_rejected(
    proper_time: float, overlap: float
) -> None:
    with pytest.raises(ValueError):
        overlap_distance_1p1(proper_time, overlap)
