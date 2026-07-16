"""Tests for Stage A17 frame-constrained local metric regression."""

from __future__ import annotations

import unittest

import numpy as np

from causal_frame_constrained_metric import (
    MINKOWSKI_METRIC,
    MetricConstraintSplit,
    align_charts_and_form_consensus,
    factor_lorentzian_metric,
    fit_common_metric,
    select_regularization,
    symmetric_matrix_to_vector,
    symmetric_quadratic_features,
    transported_chart_metric,
)
from causal_johnston_probe_metric import JohnstonLightconeEmbedding


def synthetic_chart(probes: np.ndarray) -> JohnstonLightconeEmbedding:
    """Build the lightcone-chart fields used by alignment tests."""

    return JohnstonLightconeEmbedding(
        probes=probes,
        embedded_mask=np.ones(len(probes), dtype=bool),
        intrinsic_time=probes[:, 0],
        intrinsic_radius=np.zeros(len(probes)),
        spatial_singular_values=np.ones(4),
        spatial_rank_gap=1.0,
        dominant_spatial_gap_rank=3,
        pivot_index=5,
        past_count=1,
        future_count=4,
        scale_balance_residual=0.0,
    )


class CausalFrameConstrainedMetricTests(unittest.TestCase):
    def test_quadratic_features_match_symmetric_form(self) -> None:
        rng = np.random.default_rng(4)
        displacement = rng.normal(size=(20, 4))
        raw = rng.normal(size=(4, 4))
        metric = 0.5 * (raw + raw.T)
        actual = symmetric_quadratic_features(displacement) @ (
            symmetric_matrix_to_vector(metric)
        )
        expected = np.einsum(
            "...i,ij,...j->...", displacement, metric, displacement
        )
        np.testing.assert_allclose(actual, expected, atol=1.0e-12)

    def test_lorentzian_factorization_is_exact(self) -> None:
        transform = np.array(
            [
                [1.2, 0.1, 0.0, 0.0],
                [0.0, 0.9, 0.2, 0.0],
                [0.1, 0.0, 1.1, 0.1],
                [0.0, 0.1, 0.0, 0.8],
            ]
        )
        metric = transform @ MINKOWSKI_METRIC @ transform.T
        coframe, error = factor_lorentzian_metric(metric)
        self.assertIsNotNone(coframe)
        self.assertIsNotNone(error)
        assert coframe is not None and error is not None
        np.testing.assert_allclose(
            coframe @ MINKOWSKI_METRIC @ coframe.T,
            metric,
            atol=1.0e-12,
        )
        self.assertLess(error, 1.0e-12)

    def test_transported_metric_preserves_quadratic_form(self) -> None:
        linear = np.array(
            [
                [1.1, 0.2, 0.0, 0.0],
                [0.0, 0.9, 0.1, 0.0],
                [0.1, 0.0, 1.2, 0.2],
                [0.0, 0.1, 0.0, 0.8],
            ]
        )
        affine = np.vstack((linear, np.array([0.2, -0.1, 0.3, 0.4])))
        metric = transported_chart_metric(affine)
        source = np.array([0.3, -0.2, 0.4, 0.1])
        target = source @ linear
        self.assertAlmostEqual(
            float(source @ MINKOWSKI_METRIC @ source),
            float(target @ metric @ target),
        )

    def test_anchor_alignment_recovers_one_common_chart(self) -> None:
        canonical = np.array(
            [
                [-0.4, 0.0, 0.0, 0.0],
                [0.4, 0.0, 0.0, 0.0],
                [0.4, 0.1, 0.0, 0.0],
                [0.4, 0.0, 0.1, 0.0],
                [0.4, 0.0, 0.0, 0.1],
                [0.0, 0.02, 0.03, -0.01],
                [0.1, -0.03, 0.02, 0.01],
            ]
        )
        linear = np.array(
            [
                [1.0, 0.1, 0.0, 0.0],
                [0.0, 0.9, 0.1, 0.0],
                [0.0, 0.0, 1.1, 0.1],
                [0.1, 0.0, 0.0, 0.8],
            ]
        )
        shift = np.array([0.2, -0.3, 0.1, 0.4])
        moved = (canonical - shift) @ np.linalg.inv(linear)
        consensus, support, observations, _, _ = align_charts_and_form_consensus(
            [synthetic_chart(canonical), synthetic_chart(moved)],
            np.arange(5),
        )
        np.testing.assert_allclose(consensus, canonical, atol=1.0e-12)
        np.testing.assert_allclose(observations[0], observations[1], atol=1.0e-12)
        np.testing.assert_array_equal(support, 2 * np.ones(len(canonical), dtype=int))

    def test_exact_quadratic_data_recover_metric(self) -> None:
        rng = np.random.default_rng(15)
        coordinates = rng.normal(size=(14, 4))
        left, right = np.triu_indices(len(coordinates), k=1)
        displacement = coordinates[right] - coordinates[left]
        target = np.einsum(
            "...i,ij,...j->...",
            displacement,
            MINKOWSKI_METRIC,
            displacement,
        )
        heldout = np.arange(0, len(left), 7)
        train = np.setdiff1d(np.arange(len(left)), heldout)
        split = MetricConstraintSplit(
            causal_left=left,
            causal_right=right,
            causal_target_squared=target,
            causal_weight=np.ones(len(left)),
            causal_train=train,
            causal_heldout=heldout,
            noncausal_left=np.array([], dtype=int),
            noncausal_right=np.array([], dtype=int),
        )
        fit = fit_common_metric(
            coordinates,
            split,
            MINKOWSKI_METRIC,
            anchor_time=1.0,
            regularization=0.0,
        )
        np.testing.assert_allclose(fit.metric, MINKOWSKI_METRIC, atol=1.0e-11)
        self.assertLess(fit.heldout_interval_relative_rmse, 1.0e-11)
        self.assertEqual(fit.signature, (1, 3, 0))

    def test_regularization_selection_uses_only_intrinsic_gates(self) -> None:
        summaries = {
            "oracle_good": {
                "intrinsic_metric_gate_success_rate": 0.0,
                "intrinsic_coordinate_gate_success_rate": 1.0,
                "heldout_interval_relative_rmse": {"median": 0.05},
                "noncausal_violation_fraction": {"median": 0.01},
                "regularization": 0.01,
            },
            "intrinsic_good": {
                "intrinsic_metric_gate_success_rate": 1.0,
                "intrinsic_coordinate_gate_success_rate": 1.0,
                "heldout_interval_relative_rmse": {"median": 0.15},
                "noncausal_violation_fraction": {"median": 0.05},
                "regularization": 0.1,
            },
        }
        key, _ = select_regularization(summaries)
        self.assertEqual(key, "intrinsic_good")


if __name__ == "__main__":
    unittest.main()
