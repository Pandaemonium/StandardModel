"""Tests for independent Johnston quadratic-probe validation."""

from __future__ import annotations

import unittest

import numpy as np

from causal_johnston_quadratic_probe import (
    reconstruct_quadratic_realization,
    select_support,
    vector_relative_error,
)


class JohnstonQuadraticProbeTests(unittest.TestCase):
    def test_vector_relative_error_respects_mask(self) -> None:
        actual = np.array([1.0, 4.0, 3.0])
        expected = np.array([1.0, 2.0, 3.0])
        mask = np.array([True, False, True])
        self.assertEqual(
            vector_relative_error(actual, expected, mask), 0.0
        )

    def test_support_selection_prioritizes_gate_rate(self) -> None:
        summaries = {
            "low_error": {
                "probe_gate_success_rate": 0.4,
                "johnston_quadratic_relative_error": {"median": 0.1},
                "johnston_inner_relative_error": {"median": 0.1},
                "support_radius": 0.36,
            },
            "high_gate": {
                "probe_gate_success_rate": 0.8,
                "johnston_quadratic_relative_error": {"median": 0.3},
                "johnston_inner_relative_error": {"median": 0.3},
                "support_radius": 0.5,
            },
        }
        key, _ = select_support(summaries)
        self.assertEqual(key, "high_gate")

    def test_small_realization_is_finite_without_operator(self) -> None:
        samples = reconstruct_quadratic_realization(
            np.random.default_rng(20260723),
            events=160,
            duration=1.0,
            dimension=4,
            block_size=64,
            support_radii=[0.5],
            maximum_probe_error=1.0,
        )
        self.assertEqual(len(samples), 1)
        sample = samples[0]
        self.assertTrue(
            np.isfinite(sample.johnston_quadratic_relative_error)
        )
        self.assertTrue(np.isfinite(sample.johnston_inner_relative_error))
        self.assertGreater(sample.pivot_past_count, 0)
        self.assertGreater(sample.pivot_future_count, 0)


if __name__ == "__main__":
    unittest.main()
