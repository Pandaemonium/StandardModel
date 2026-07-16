"""Tests for Stage A14 shared-event causal-distance factorization."""

from __future__ import annotations

import unittest

import numpy as np

from causal_johnston_shared_factorization import (
    ConstraintSplit,
    RankFactorization,
    build_constraint_split,
    fit_shared_spatial_coordinates,
    select_noncausal_penalty,
    select_rank_one_standard_error,
    spatial_stress_value_and_gradient,
)


class JohnstonSharedFactorizationTests(unittest.TestCase):
    def test_constraint_split_keeps_endpoints_in_training(self) -> None:
        relation = np.array(
            [
                [False, True, True, True, True],
                [False, False, False, True, True],
                [False, False, False, True, True],
                [False, False, False, False, True],
                [False, False, False, False, False],
            ]
        )
        counts = np.zeros((5, 5), dtype=np.int32)
        counts[relation] = 3
        split = build_constraint_split(
            np.random.default_rng(12),
            relation,
            counts,
            np.linspace(0.0, 1.0, 5),
            density=100.0,
            dimension=4,
            endpoint_positions=(0, 4),
            heldout_fraction=0.5,
            minimum_heldout_open_count=2,
            maximum_noncausal_pairs=10,
        )
        heldout_pairs = set(
            zip(
                split.causal_left[split.causal_heldout],
                split.causal_right[split.causal_heldout],
                strict=True,
            )
        )
        self.assertTrue(heldout_pairs)
        self.assertTrue(all(0 not in pair and 4 not in pair for pair in heldout_pairs))

    def test_analytic_stress_gradient_matches_finite_difference(self) -> None:
        split = ConstraintSplit(
            causal_left=np.array([0, 0, 1]),
            causal_right=np.array([1, 2, 2]),
            causal_distance=np.array([0.4, 0.8, 0.5]),
            causal_weight=np.array([1.0, 2.0, 1.5]),
            causal_train=np.array([0, 1, 2]),
            causal_heldout=np.array([1]),
            noncausal_left=np.array([0]),
            noncausal_right=np.array([2]),
            noncausal_train=np.array([0]),
            noncausal_heldout=np.array([0]),
        )
        coordinates = np.array([[0.0, 0.0], [0.3, 0.1], [0.9, -0.2]])
        time = np.array([0.0, 0.4, 0.9])
        value, gradient = spatial_stress_value_and_gradient(
            coordinates.ravel(), 3, 2, time, split, 0.3
        )
        step = 1.0e-6
        numerical = np.zeros_like(gradient)
        for index in range(len(gradient)):
            plus = coordinates.ravel().copy()
            minus = coordinates.ravel().copy()
            plus[index] += step
            minus[index] -= step
            plus_value, _ = spatial_stress_value_and_gradient(
                plus, 3, 2, time, split, 0.3
            )
            minus_value, _ = spatial_stress_value_and_gradient(
                minus, 3, 2, time, split, 0.3
            )
            numerical[index] = (plus_value - minus_value) / (2.0 * step)
        self.assertTrue(np.isfinite(value))
        np.testing.assert_allclose(gradient, numerical, rtol=1.0e-5, atol=1.0e-6)

    def test_one_standard_error_prefers_smallest_admissible_rank(self) -> None:
        def fit(rank: int, mse: float, error: float) -> RankFactorization:
            return RankFactorization(
                spatial_rank=rank,
                coordinates=np.zeros((3, rank)),
                converged=True,
                iterations=1,
                objective=mse,
                heldout_causal_mse=mse,
                heldout_causal_standard_error=error,
                heldout_causal_relative_rmse=np.sqrt(mse),
                heldout_noncausal_violation_fraction=0.0,
                heldout_noncausal_margin_relative_rmse=0.0,
            )

        selected, threshold, best = select_rank_one_standard_error(
            [fit(2, 0.12, 0.01), fit(3, 0.10, 0.03), fit(4, 0.09, 0.02)]
        )
        self.assertEqual(selected.spatial_rank, 3)
        self.assertAlmostEqual(best, 0.09)
        self.assertAlmostEqual(threshold, 0.11)

    def test_exact_partial_distances_have_small_heldout_error(self) -> None:
        coordinates = np.array(
            [[0.0, 0.0], [0.5, 0.0], [0.0, 0.5], [0.5, 0.5]]
        )
        pairs = np.array([(0, 1), (0, 2), (1, 3), (2, 3), (0, 3)])
        distances = np.linalg.norm(
            coordinates[pairs[:, 0]] - coordinates[pairs[:, 1]], axis=1
        )
        split = ConstraintSplit(
            causal_left=pairs[:, 0],
            causal_right=pairs[:, 1],
            causal_distance=distances,
            causal_weight=np.ones(len(pairs)),
            causal_train=np.array([0, 1, 2, 3]),
            causal_heldout=np.array([4]),
            noncausal_left=np.array([1]),
            noncausal_right=np.array([2]),
            noncausal_train=np.array([0]),
            noncausal_heldout=np.array([0]),
        )
        fit = fit_shared_spatial_coordinates(
            coordinates,
            np.zeros(4),
            split,
            noncausal_penalty=0.0,
            maximum_iterations=100,
        )
        self.assertLess(fit.heldout_causal_relative_rmse, 1.0e-8)

    def test_penalty_selection_prioritizes_gate_rates(self) -> None:
        summaries = {
            "low_error": {
                "geometry_gate_success_rate": 0.0,
                "factorization_gate_success_rate": 0.0,
                "selected_heldout_causal_relative_rmse": {"median": 0.1},
                "selected_heldout_noncausal_violation_fraction": {"median": 0.1},
                "noncausal_penalty": 0.0,
            },
            "gated": {
                "geometry_gate_success_rate": 0.0,
                "factorization_gate_success_rate": 1.0,
                "selected_heldout_causal_relative_rmse": {"median": 0.2},
                "selected_heldout_noncausal_violation_fraction": {"median": 0.0},
                "noncausal_penalty": 1.0,
            },
        }
        key, _ = select_noncausal_penalty(summaries)
        self.assertEqual(key, "gated")


if __name__ == "__main__":
    unittest.main()
