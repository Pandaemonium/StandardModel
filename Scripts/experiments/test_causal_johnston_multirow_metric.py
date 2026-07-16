"""Tests for Stage A8 common-chart multi-row metric averaging."""

from __future__ import annotations

import unittest

import numpy as np

from causal_johnston_multirow_metric import (
    averaging_targets,
    centered_lorentzian_quadratic,
    centered_trace_identity_relative_error,
    reconstruct_multirow_realization,
    select_averaging_radius,
)
from causal_operator_metric import corrected_gamma


class JohnstonMultirowMetricTests(unittest.TestCase):
    def test_centered_quadratic_vanishes_and_satisfies_trace_identity(
        self,
    ) -> None:
        rng = np.random.default_rng(20260727)
        probes = rng.normal(size=(12, 4))
        row = rng.normal(size=12)
        target = 4
        quadratic = centered_lorentzian_quadratic(probes, target)
        pairing = corrected_gamma(row, probes, target)
        response = float(row @ quadratic)
        self.assertEqual(quadratic[target], 0.0)
        self.assertLess(
            centered_trace_identity_relative_error(response, pairing),
            1.0e-12,
        )

    def test_target_sets_are_nested_and_relabeling_equivariant(self) -> None:
        relation = np.zeros((6, 6), dtype=bool)
        relation[0, 5] = True
        relation[1, 5] = True
        relation[2, 5] = True
        relation[3, 5] = True
        recovered = np.array([0.05, 0.10, 0.15, 0.30, 0.40, 0.0])
        embedded = np.array([True, True, True, True, False, True])
        inner = averaging_targets(relation, 5, recovered, embedded, 0.10)
        outer = averaging_targets(relation, 5, recovered, embedded, 0.20)
        self.assertTrue(set(inner).issubset(set(outer)))
        np.testing.assert_array_equal(inner, np.array([0, 1, 5]))
        np.testing.assert_array_equal(outer, np.array([0, 1, 2, 5]))

        permutation = np.array([3, 5, 1, 4, 0, 2])
        moved_relation = relation[np.ix_(permutation, permutation)]
        moved_pivot = int(np.flatnonzero(permutation == 5)[0])
        moved = averaging_targets(
            moved_relation,
            moved_pivot,
            recovered[permutation],
            embedded[permutation],
            0.20,
        )
        np.testing.assert_array_equal(np.sort(permutation[moved]), np.sort(outer))

    def test_selection_prioritizes_trace_then_conformal_gate(self) -> None:
        summaries = {
            "conformal_favorite": {
                "trace_normalized_coordinate_gate_success_rate": 0.4,
                "coordinate_conformal_gate_success_rate": 0.9,
                "trace_normalized_coordinate_relative_error": {"median": 0.2},
                "coordinate_conformal_relative_error": {"median": 0.1},
                "averaging_radius": 0.15,
            },
            "trace_favorite": {
                "trace_normalized_coordinate_gate_success_rate": 0.8,
                "coordinate_conformal_gate_success_rate": 0.5,
                "trace_normalized_coordinate_relative_error": {"median": 0.4},
                "coordinate_conformal_relative_error": {"median": 0.3},
                "averaging_radius": 0.175,
            },
        }
        key, _ = select_averaging_radius(summaries)
        self.assertEqual(key, "trace_favorite")

        summaries["conformal_favorite"][
            "trace_normalized_coordinate_gate_success_rate"
        ] = 0.8
        key, _ = select_averaging_radius(summaries)
        self.assertEqual(key, "conformal_favorite")

    def test_small_realization_is_finite_with_closed_johnston_scores(
        self,
    ) -> None:
        samples = reconstruct_multirow_realization(
            np.random.default_rng(20260727),
            events=160,
            duration=1.0,
            dimension=4,
            block_size=64,
            nonlocality_scale=0.35,
            support_radius=0.65,
            averaging_radii=[0.0, 0.2],
            maximum_conformal_error=1.0,
            maximum_trace_error=1.0,
            include_johnston_metrics=False,
        )
        self.assertEqual(len(samples), 2)
        self.assertTrue(all(sample.row_count >= 1 for sample in samples))
        self.assertTrue(
            all(
                np.isfinite(sample.coordinate_metric_relative_error)
                for sample in samples
            )
        )
        self.assertTrue(
            all(
                sample.centered_trace_identity_relative_error < 1.0e-12
                for sample in samples
            )
        )
        self.assertTrue(all(sample.johnston_pairing is None for sample in samples))


if __name__ == "__main__":
    unittest.main()
