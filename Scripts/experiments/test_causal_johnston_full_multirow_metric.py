"""Tests for Stage A9 two-sided full-chart metric averaging."""

from __future__ import annotations

import unittest

import numpy as np

from causal_johnston_full_multirow_metric import (
    AVERAGE_TRACE,
    ROWWISE_TRACE,
    reconstruct_full_multirow_realization,
    rowwise_trace_normalized_average,
    select_radius_and_estimator,
    two_sided_averaging_targets,
)
from causal_operator_metric import MINKOWSKI_INVERSE


class JohnstonFullMultirowMetricTests(unittest.TestCase):
    def test_two_sided_targets_are_nested_and_relabeling_equivariant(
        self,
    ) -> None:
        coordinates = np.array(
            [
                [-0.2, 0.0, 0.0, 0.0],
                [-0.05, 0.0, 0.0, 0.0],
                [0.0, 0.0, 0.0, 0.0],
                [0.04, 0.03, 0.0, 0.0],
                [0.2, 0.0, 0.0, 0.0],
            ]
        )
        inner = two_sided_averaging_targets(coordinates, 2, 0.05)
        outer = two_sided_averaging_targets(coordinates, 2, 0.10)
        np.testing.assert_array_equal(inner, np.array([1, 2, 3]))
        self.assertTrue(set(inner).issubset(set(outer)))
        self.assertTrue(coordinates[inner[0], 0] < 0.0)
        self.assertTrue(coordinates[inner[-1], 0] > 0.0)

        permutation = np.array([3, 0, 4, 2, 1])
        moved_pivot = int(np.flatnonzero(permutation == 2)[0])
        moved = two_sided_averaging_targets(coordinates[permutation], moved_pivot, 0.05)
        np.testing.assert_array_equal(np.sort(permutation[moved]), np.sort(inner))

    def test_rowwise_trace_normalization_uses_only_positive_rows(self) -> None:
        pairings = [
            0.5 * MINKOWSKI_INVERSE,
            2.0 * MINKOWSKI_INVERSE,
            -MINKOWSKI_INVERSE,
        ]
        average, fraction = rowwise_trace_normalized_average(
            pairings, [4.0, 16.0, -8.0], dimension=4
        )
        self.assertIsNotNone(average)
        np.testing.assert_allclose(average, MINKOWSKI_INVERSE)
        self.assertAlmostEqual(fraction, 2.0 / 3.0)

    def test_selection_compares_both_trace_estimators(self) -> None:
        summaries = {
            "radius=0.050000": {
                "averaging_radius": 0.05,
                "coordinate_conformal_gate_success_rate": 0.5,
                "coordinate_conformal_relative_error": {"median": 0.4},
                "average_trace_coordinate_gate_success_rate": 0.4,
                "average_trace_coordinate_relative_error": {"median": 0.3},
                "rowwise_trace_coordinate_gate_success_rate": 0.8,
                "rowwise_trace_coordinate_relative_error": {"median": 0.5},
            },
            "radius=0.075000": {
                "averaging_radius": 0.075,
                "coordinate_conformal_gate_success_rate": 0.9,
                "coordinate_conformal_relative_error": {"median": 0.2},
                "average_trace_coordinate_gate_success_rate": 0.7,
                "average_trace_coordinate_relative_error": {"median": 0.2},
                "rowwise_trace_coordinate_gate_success_rate": 0.6,
                "rowwise_trace_coordinate_relative_error": {"median": 0.2},
            },
        }
        key, estimator, _ = select_radius_and_estimator(summaries)
        self.assertEqual(key, "radius=0.050000")
        self.assertEqual(estimator, ROWWISE_TRACE)

        summaries["radius=0.050000"]["rowwise_trace_coordinate_gate_success_rate"] = 0.7
        key, estimator, _ = select_radius_and_estimator(summaries)
        self.assertEqual(key, "radius=0.075000")
        self.assertEqual(estimator, AVERAGE_TRACE)

    def test_small_realization_keeps_johnston_metric_scores_closed(
        self,
    ) -> None:
        samples = reconstruct_full_multirow_realization(
            np.random.default_rng(20260731),
            events=120,
            duration=1.0,
            dimension=4,
            block_size=64,
            nonlocality_scale=0.35,
            support_radius=0.65,
            averaging_radii=[0.0, 0.1],
            maximum_conformal_error=1.0,
            maximum_trace_error=1.0,
            include_johnston_metrics=False,
        )
        self.assertEqual(len(samples), 2)
        self.assertTrue(all(sample.row_count >= 1 for sample in samples))
        self.assertTrue(
            all(
                sample.centered_trace_identity_relative_error < 1.0e-12
                for sample in samples
            )
        )
        self.assertTrue(all(sample.johnston_pairing is None for sample in samples))
        self.assertTrue(
            all(
                np.isfinite(sample.coordinate_metric_relative_error)
                for sample in samples
            )
        )


if __name__ == "__main__":
    unittest.main()
