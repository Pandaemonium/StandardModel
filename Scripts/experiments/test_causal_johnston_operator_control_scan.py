"""Tests for the Stage A5 coordinate-probe operator control scan."""

from __future__ import annotations

import unittest

import numpy as np

from causal_johnston_operator_control_scan import (
    OperatorControlSample,
    optimal_positive_rescaling,
    reconstruct_control_realization,
    select_count_normalized_control_setting,
    select_control_setting,
    select_johnston_normalized_control_setting,
    setting_key,
    summarize_grid,
)
from causal_operator_metric import MINKOWSKI_INVERSE


def sample(
    scale: float,
    radius: float,
    error: float,
    passes: bool,
    pairing: np.ndarray = MINKOWSKI_INVERSE,
) -> OperatorControlSample:
    return OperatorControlSample(
        nonlocality_scale=scale,
        support_radius=radius,
        signature=(1, 3, 0),
        eigenvalues=np.linalg.eigvalsh(pairing).tolist(),
        pairing=pairing.tolist(),
        metric_relative_error=error,
        passes_gate=passes,
        pivot_intrinsic_time=0.5,
        pivot_intrinsic_radius=0.1,
        pivot_past_count=10,
        pivot_future_count=10,
        intrinsic_quadratic_response=8.0,
        count_normalization_factor=1.0,
        count_normalized_signature=(1, 3, 0),
        count_normalized_eigenvalues=np.linalg.eigvalsh(pairing).tolist(),
        count_normalized_pairing=pairing.tolist(),
        count_normalized_metric_relative_error=error,
        passes_count_normalized_gate=passes,
        johnston_quadratic_response=8.0,
        johnston_quadratic_normalization_factor=1.0,
        johnston_normalized_signature=(1, 3, 0),
        johnston_normalized_eigenvalues=np.linalg.eigvalsh(pairing).tolist(),
        johnston_normalized_pairing=pairing.tolist(),
        johnston_normalized_metric_relative_error=error,
        passes_johnston_normalized_gate=passes,
    )


class JohnstonOperatorControlScanTests(unittest.TestCase):
    def test_setting_key_is_stable(self) -> None:
        self.assertEqual(
            setting_key(0.14, 0.5),
            "L=0.140000|support=0.500000",
        )

    def test_optimal_positive_rescaling_separates_scale(self) -> None:
        factor, error = optimal_positive_rescaling(
            0.4 * MINKOWSKI_INVERSE
        )
        self.assertAlmostEqual(factor, 2.5)
        self.assertAlmostEqual(error, 0.0)

    def test_grid_summary_preserves_exact_mean_metric(self) -> None:
        samples = [
            sample(0.14, 0.5, 0.0, True),
            sample(0.14, 0.5, 0.0, True),
        ]
        summary = summarize_grid(samples, (1, 3, 0))[
            setting_key(0.14, 0.5)
        ]
        self.assertEqual(summary["gate_success_rate"], 1.0)
        self.assertEqual(summary["ensemble_mean_relative_error"], 0.0)
        self.assertEqual(
            summary["ensemble_positive_rescaling_factor"], 1.0
        )
        self.assertEqual(
            summary["ensemble_rescaled_metric_relative_error"], 0.0
        )
        np.testing.assert_allclose(
            summary["ensemble_mean_pairing"], MINKOWSKI_INVERSE
        )

    def test_selection_prioritizes_gate_rate_then_median(self) -> None:
        summaries = {
            "lower_median": {
                "gate_success_rate": 0.5,
                "metric_relative_error": {"median": 0.4},
                "ensemble_mean_relative_error": 0.2,
                "nonlocality_scale": 0.14,
                "support_radius": 0.5,
            },
            "higher_gate": {
                "gate_success_rate": 0.6,
                "metric_relative_error": {"median": 0.8},
                "ensemble_mean_relative_error": 0.7,
                "nonlocality_scale": 0.16,
                "support_radius": 0.5,
            },
        }
        key, _ = select_control_setting(summaries)
        self.assertEqual(key, "higher_gate")

        summaries["lower_median"]["gate_success_rate"] = 0.6
        key, _ = select_control_setting(summaries)
        self.assertEqual(key, "lower_median")

    def test_count_selection_uses_only_count_normalized_scores(self) -> None:
        summaries = {
            "raw_favorite": {
                "count_normalized_gate_success_rate": 0.2,
                "count_normalized_metric_relative_error": {"median": 0.3},
                "aggregate_count_normalized_relative_error": 0.2,
                "nonlocality_scale": 0.14,
                "support_radius": 0.5,
            },
            "count_favorite": {
                "count_normalized_gate_success_rate": 0.7,
                "count_normalized_metric_relative_error": {"median": 0.8},
                "aggregate_count_normalized_relative_error": 0.7,
                "nonlocality_scale": 0.18,
                "support_radius": 0.65,
            },
        }
        key, _ = select_count_normalized_control_setting(summaries)
        self.assertEqual(key, "count_favorite")

    def test_johnston_selection_uses_its_normalized_scores(self) -> None:
        summaries = {
            "low_gate": {
                "johnston_normalized_gate_success_rate": 0.4,
                "johnston_normalized_metric_relative_error": {
                    "median": 0.2
                },
                "aggregate_johnston_normalized_relative_error": 0.1,
                "nonlocality_scale": 0.14,
                "support_radius": 0.65,
            },
            "high_gate": {
                "johnston_normalized_gate_success_rate": 0.8,
                "johnston_normalized_metric_relative_error": {
                    "median": 0.4
                },
                "aggregate_johnston_normalized_relative_error": 0.3,
                "nonlocality_scale": 0.18,
                "support_radius": 0.65,
            },
        }
        key, _ = select_johnston_normalized_control_setting(summaries)
        self.assertEqual(key, "high_gate")

    def test_small_realization_is_finite_on_every_setting(self) -> None:
        samples = reconstruct_control_realization(
            np.random.default_rng(20260720),
            events=120,
            duration=1.0,
            dimension=4,
            block_size=64,
            nonlocality_scales=[0.30, 0.35],
            support_radii=[0.4, 0.5],
            maximum_metric_error=0.5,
        )
        self.assertEqual(len(samples), 4)
        self.assertTrue(
            all(np.isfinite(value) for row in samples for value in row.eigenvalues)
        )
        self.assertTrue(
            all(
                np.isfinite(row.intrinsic_quadratic_response)
                for row in samples
            )
        )
        self.assertEqual(
            {(row.nonlocality_scale, row.support_radius) for row in samples},
            {(0.30, 0.4), (0.30, 0.5), (0.35, 0.4), (0.35, 0.5)},
        )

    def test_small_johnston_normalization_is_computed(self) -> None:
        samples = reconstruct_control_realization(
            np.random.default_rng(20260725),
            events=160,
            duration=1.0,
            dimension=4,
            block_size=64,
            nonlocality_scales=[0.30],
            support_radii=[0.5],
            maximum_metric_error=0.5,
            compute_johnston_quadratic=True,
        )
        self.assertEqual(len(samples), 1)
        self.assertIsNotNone(samples[0].johnston_quadratic_response)


if __name__ == "__main__":
    unittest.main()
