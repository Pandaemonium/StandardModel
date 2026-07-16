"""Tests for the Stage A3d compact bracket carrier gate."""

from __future__ import annotations

import inspect
import unittest

import numpy as np
from scipy import sparse

from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_compact_bracket_carrier import (
    CountBalancedBracket,
    _score_stratified_mask,
    count_rapidity_excess,
    induced_counts_match_global,
    open_bracket_carrier,
    select_count_balanced_brackets,
)


def transitive_closure(size: int, edges: list[tuple[int, int]]) -> np.ndarray:
    relation = np.zeros((size, size), dtype=bool)
    for left, right in edges:
        relation[left, right] = True
    for pivot in range(size):
        relation |= relation[:, pivot, None] & relation[None, pivot, :]
    return relation


class CompactBracketCarrierTests(unittest.TestCase):
    def test_collinear_count_composition_has_unit_excess(self) -> None:
        self.assertAlmostEqual(count_rapidity_excess(16, 16, 256), 1.0)

    def test_score_strata_retain_both_edges_and_all_ties(self) -> None:
        scores = np.array([1.0, 1.0, 1.1, 1.2, 1.3, 1.4, 2.0, 2.0])
        retained = _score_stratified_mask(scores, 4)
        np.testing.assert_array_equal(
            retained,
            np.array([True, True, False, False, False, False, True, True]),
        )

    def test_selector_retains_complete_tie_orbit(self) -> None:
        counts = np.zeros((7, 7), dtype=np.int32)
        mark = 3
        for past in (0, 1, 2):
            counts[past, mark] = 10
            for future in (4, 5, 6):
                counts[past, future] = 160
        for future in (4, 5, 6):
            counts[mark, future] = 10
        selected = select_count_balanced_brackets(
            sparse.csr_matrix(counts),
            mark,
            half_count_target=10.0,
            endpoint_count_band=(0.9, 1.1),
            excess_cap=2.0,
            maximum_brackets=2,
        )
        self.assertEqual(len(selected), 9)

    def test_selector_is_exactly_relabeling_equivariant(self) -> None:
        counts = np.zeros((8, 8), dtype=np.int32)
        mark = 3
        for past, half in zip((0, 1, 2), (9, 10, 11), strict=True):
            counts[past, mark] = half
            for future in (4, 5, 6, 7):
                counts[past, future] = 145 + 3 * past + future
        for future, half in zip((4, 5, 6, 7), (9, 10, 11, 10), strict=True):
            counts[mark, future] = half
        original = select_count_balanced_brackets(
            sparse.csr_matrix(counts), mark, 10.0, (0.8, 1.2), 2.0, 4
        )

        permutation = np.array([5, 0, 7, 2, 6, 3, 1, 4])
        inverse = np.argsort(permutation)
        relabeled_counts = counts[np.ix_(permutation, permutation)]
        relabeled = select_count_balanced_brackets(
            sparse.csr_matrix(relabeled_counts),
            int(inverse[mark]),
            10.0,
            (0.8, 1.2),
            2.0,
            4,
        )
        pulled = {
            (permutation[item.past_endpoint], permutation[item.future_endpoint])
            for item in relabeled
        }
        expected = {
            (item.past_endpoint, item.future_endpoint) for item in original
        }
        self.assertEqual(pulled, expected)

    def test_open_bracket_is_interval_convex_for_partial_order(self) -> None:
        relation = transitive_closure(
            9,
            [
                (0, 1),
                (0, 2),
                (1, 3),
                (2, 3),
                (3, 4),
                (4, 5),
                (4, 6),
                (5, 7),
                (6, 7),
                (7, 8),
            ],
        )
        counts = sparse_inclusive_interval_count_matrix(relation)
        bracket = CountBalancedBracket(0, 8, 1, 1, 8, 1.0)
        carrier = open_bracket_carrier(relation, bracket)
        self.assertTrue(carrier[4])
        self.assertFalse(carrier[0])
        self.assertFalse(carrier[8])
        self.assertTrue(induced_counts_match_global(relation, counts, carrier))

    def test_selector_api_has_no_coordinate_argument(self) -> None:
        parameters = inspect.signature(select_count_balanced_brackets).parameters
        self.assertNotIn("points", parameters)
        self.assertNotIn("coordinates", parameters)


if __name__ == "__main__":
    unittest.main()
