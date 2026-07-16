"""Tests for the Stage A23 shrinking-scale multirow calibration."""

from __future__ import annotations

import unittest

import numpy as np

from causal_conformal_multirow_metric import (
    append_interior_pivot,
    fit_affine_metric_field,
    fit_affine_vector_field,
    fit_affine_vector_intercept,
    reconstruct_multirow_realization,
    refinement_scales,
    retarded_probe_moment,
    target_inverse_metric_at,
    target_inverse_metric_first_jet,
    select_spread_local_targets,
)
from causal_conformal_operator_metric import sprinkle_conformal_de_sitter_diamond


class CausalConformalMultirowMetricTests(unittest.TestCase):
    def test_retarded_probe_moment_is_affine_covariant(self) -> None:
        row = np.array([2.0, -1.0, 0.5])
        probes = np.array([[1.0, 2.0], [0.0, 0.0], [-1.0, 3.0]])
        linear = np.array([[2.0, 1.0], [-1.0, 1.0]])
        offset = np.array([4.0, -2.0])
        moment = retarded_probe_moment(row, probes, 1)
        transformed = retarded_probe_moment(
            row, probes @ linear.T + offset, 1
        )
        np.testing.assert_allclose(transformed, linear @ moment)

    def test_affine_vector_intercept_recovers_pivot_value(self) -> None:
        points = np.array(
            [
                [0.0, 0.0, 0.0, 0.0],
                [1.0, 0.0, 0.0, 0.0],
                [0.0, 1.0, 0.0, 0.0],
                [0.0, 0.0, 1.0, 0.0],
                [0.0, 0.0, 0.0, 1.0],
            ]
        )
        intercept = np.array([2.0, -1.0, 0.5, 3.0])
        linear = np.arange(16, dtype=float).reshape(4, 4) / 10.0
        values = intercept + points @ linear.T
        actual = fit_affine_vector_intercept(
            points, 0, np.arange(5), values
        )
        np.testing.assert_allclose(actual, intercept)
        actual_intercept, actual_jet = fit_affine_vector_field(
            points, 0, np.arange(5), values
        )
        np.testing.assert_allclose(actual_intercept, intercept)
        np.testing.assert_allclose(actual_jet, linear.T, atol=1.0e-12)

    def test_refinement_schedule_has_required_scale_limits(self) -> None:
        ell_values = [0.08, 0.04, 0.02]
        scales = [refinement_scales(ell, 1.0, 0.55, 1.4, 0.9) for ell in ell_values]
        self.assertTrue(
            all(
                scales[index + 1].nonlocality_scale
                < scales[index].nonlocality_scale
                for index in range(2)
            )
        )
        self.assertTrue(
            all(
                scales[index + 1].support_radius < scales[index].support_radius
                for index in range(2)
            )
        )
        self.assertLess(
            scales[-1].ell / scales[-1].nonlocality_scale,
            scales[0].ell / scales[0].nonlocality_scale,
        )
        self.assertLess(
            scales[-1].nonlocality_scale / scales[-1].support_radius,
            scales[0].nonlocality_scale / scales[0].support_radius,
        )

    def test_append_interior_pivot_preserves_top(self) -> None:
        points, top = sprinkle_conformal_de_sitter_diamond(
            np.random.default_rng(11), 20, 1.0, 0.1
        )
        extended, pivot, new_top = append_interior_pivot(points, top, 1.0)
        np.testing.assert_allclose(extended[pivot], [0.7, 0.0, 0.0, 0.0])
        np.testing.assert_allclose(extended[new_top], points[top])

    def test_spread_selector_reaches_beyond_nearest_cap(self) -> None:
        points = np.array(
            [[0.0, 0.0, 0.0, 0.0]]
            + [[value, 0.0, 0.0, 0.0] for value in np.linspace(0.01, 1.0, 100)]
        )
        selected = select_spread_local_targets(points, 0, 1.0, 8)
        self.assertIn(0, selected)
        self.assertGreater(np.max(points[selected, 0]), np.max(points[:8, 0]))

    def test_affine_field_fit_recovers_metric_and_first_jet(self) -> None:
        rng = np.random.default_rng(5)
        points = rng.normal(size=(40, 4))
        pivot = 0
        intercept = np.diag([1.2, -0.8, -0.9, -1.1])
        jet = rng.normal(scale=0.1, size=(4, 4, 4))
        jet = 0.5 * (jet + np.swapaxes(jet, 1, 2))
        offsets = points - points[pivot]
        pairings = intercept + np.einsum("km,mij->kij", offsets, jet)
        actual_metric, actual_jet, rank, _ = fit_affine_metric_field(
            points, pivot, np.arange(len(points)), pairings
        )
        self.assertEqual(rank, 5)
        np.testing.assert_allclose(actual_metric, intercept, atol=1.0e-12)
        np.testing.assert_allclose(actual_jet, jet, atol=1.0e-12)

    def test_target_first_jet_matches_finite_difference(self) -> None:
        time = 0.5
        hubble = 0.2
        step = 1.0e-6
        finite_difference = (
            target_inverse_metric_at(time + step, hubble)
            - target_inverse_metric_at(time - step, hubble)
        ) / (2.0 * step)
        np.testing.assert_allclose(
            target_inverse_metric_first_jet(time, hubble)[0],
            finite_difference,
            rtol=1.0e-9,
            atol=1.0e-10,
        )

    def test_small_end_to_end_realization_is_finite(self) -> None:
        samples = reconstruct_multirow_realization(
            np.random.default_rng(19),
            events=600,
            duration=1.0,
            hubble=0.1,
            nonlocality_multipliers=[0.65],
            support_multipliers=[1.4],
            averaging_multipliers=[0.9],
            maximum_rows=48,
            block_size=128,
        )
        self.assertEqual(len(samples), 1)
        sample = samples[0]
        self.assertGreaterEqual(sample.row_count, 5)
        self.assertEqual(sample.design_rank, 5)
        self.assertTrue(np.isfinite(sample.metric_relative_error))
        self.assertTrue(np.isfinite(sample.first_jet_dimensionless_error))


if __name__ == "__main__":
    unittest.main()
