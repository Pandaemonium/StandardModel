"""Tests for the order-only adjacent-scale availability benchmark."""

from __future__ import annotations

import unittest

import numpy as np

from causal_adjacent_scale_availability import (
    adjacent_scale_schedule,
    adjacent_scale_support,
    hierarchy_event_threshold,
    sparse_adjacent_scale_support,
    sparse_inclusive_interval_count_matrix,
)
from causal_intrinsic_probe_metric import (
    open_interval_count_matrix,
    retarded_support_shell,
)
from causal_operator_metric import diamond_volume_4d


def total_order(size: int) -> np.ndarray:
    indices = np.arange(size)
    return indices[:, None] < indices[None, :]


class CausalAdjacentScaleAvailabilityTests(unittest.TestCase):
    def setUp(self) -> None:
        self.relation = total_order(40)
        self.counts = open_interval_count_matrix(self.relation)
        self.ell = 1.0
        self.operator_scale = 2.0
        self.adjacent_ratio = 1.2

    def test_geometric_schedule_maximizes_symmetric_clearance(self) -> None:
        scales, valid = adjacent_scale_schedule(
            self.ell, self.operator_scale, self.adjacent_ratio
        )
        self.assertTrue(valid)
        self.assertAlmostEqual(scales[1] ** 2, 2.0)
        self.assertAlmostEqual(scales[1] / scales[0], self.adjacent_ratio)
        self.assertAlmostEqual(scales[2] / scales[1], self.adjacent_ratio)
        self.assertAlmostEqual(
            scales[0] / self.ell,
            self.operator_scale / scales[2],
        )

    def test_hierarchy_threshold_matches_low_density_boundary(self) -> None:
        duration = 1.0
        operator_scale = 0.18
        ratio = 1.25
        threshold = hierarchy_event_threshold(duration, operator_scale, ratio)
        self.assertLess(400, threshold)
        self.assertGreater(800, threshold)
        for events in (400, 800):
            ell = (diamond_volume_4d(duration) / events) ** 0.25
            _, valid = adjacent_scale_schedule(ell, operator_scale, ratio)
            self.assertEqual(valid, events > threshold)

    def test_common_mark_shell_counts_match_single_mark_definition(self) -> None:
        scales, interiors, common, marks, shell_counts = adjacent_scale_support(
            self.relation,
            self.counts,
            self.ell,
            self.operator_scale,
            self.adjacent_ratio,
        )
        self.assertGreater(len(marks), 0)
        np.testing.assert_array_equal(marks, np.flatnonzero(common))
        for scale_index, (scale, interior) in enumerate(
            zip(scales, interiors, strict=True)
        ):
            expected = [
                np.count_nonzero(
                    retarded_support_shell(
                        self.relation,
                        self.counts,
                        interior,
                        int(mark),
                        self.ell,
                        scale,
                        0.5,
                        4.0,
                    )
                )
                for mark in marks
            ]
            np.testing.assert_array_equal(
                shell_counts[:, scale_index], expected
            )

    def test_sparse_inclusive_counts_match_dense_reference(self) -> None:
        inclusive = sparse_inclusive_interval_count_matrix(self.relation)
        expected = np.where(self.relation, self.counts + 1, 0)
        np.testing.assert_array_equal(inclusive.toarray(), expected)

    def test_sparse_adjacent_support_matches_dense_reference(self) -> None:
        dense = adjacent_scale_support(
            self.relation,
            self.counts,
            self.ell,
            self.operator_scale,
            self.adjacent_ratio,
        )
        sparse_result = sparse_adjacent_scale_support(
            sparse_inclusive_interval_count_matrix(self.relation),
            self.ell,
            self.operator_scale,
            self.adjacent_ratio,
        )
        np.testing.assert_allclose(sparse_result[0], dense[0])
        for sparse_interior, dense_interior in zip(
            sparse_result[1], dense[1], strict=True
        ):
            np.testing.assert_array_equal(sparse_interior, dense_interior)
        for sparse_value, dense_value in zip(
            sparse_result[2:], dense[2:], strict=True
        ):
            np.testing.assert_array_equal(sparse_value, dense_value)

    def test_adjacent_support_is_relabeling_invariant(self) -> None:
        _, _, common, marks, shell_counts = adjacent_scale_support(
            self.relation,
            self.counts,
            self.ell,
            self.operator_scale,
            self.adjacent_ratio,
        )
        permutation = np.random.default_rng(91).permutation(len(self.relation))
        inverse = np.argsort(permutation)
        moved_relation = self.relation[np.ix_(permutation, permutation)]
        moved_counts = open_interval_count_matrix(moved_relation)
        _, _, moved_common, moved_marks, moved_shell_counts = (
            adjacent_scale_support(
                moved_relation,
                moved_counts,
                self.ell,
                self.operator_scale,
                self.adjacent_ratio,
            )
        )

        np.testing.assert_array_equal(moved_common[inverse], common)
        original_by_mark = {
            int(mark): shell_counts[index]
            for index, mark in enumerate(marks)
        }
        moved_by_original_mark = {
            int(permutation[mark]): moved_shell_counts[index]
            for index, mark in enumerate(moved_marks)
        }
        self.assertEqual(original_by_mark.keys(), moved_by_original_mark.keys())
        for mark in original_by_mark:
            np.testing.assert_array_equal(
                original_by_mark[mark], moved_by_original_mark[mark]
            )

    def test_invalid_hierarchy_is_rejected_before_order_scan(self) -> None:
        with self.assertRaisesRegex(ValueError, "outside"):
            adjacent_scale_support(
                self.relation,
                self.counts,
                ell=1.0,
                operator_scale=1.3,
                adjacent_ratio=1.2,
            )


if __name__ == "__main__":
    unittest.main()
