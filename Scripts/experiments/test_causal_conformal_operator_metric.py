"""Unit tests for the Stage A22 conformal operator calibration."""

from __future__ import annotations

import argparse
import unittest

import numpy as np

from causal_conformal_operator_metric import (
    conformal_diamond_volume,
    conformal_factor_squared_from_inverse_metric,
    de_sitter_conformal_scale,
    run_experiment,
    sprinkle_conformal_de_sitter_diamond,
    target_inverse_metric,
    target_volume_density,
)
from causal_operator_metric import MINKOWSKI_INVERSE, diamond_volume_4d


class CausalConformalOperatorMetricTests(unittest.TestCase):
    def test_flat_volume_reduces_to_minkowski_diamond(self) -> None:
        self.assertAlmostEqual(
            conformal_diamond_volume(1.0, 0.0),
            diamond_volume_4d(1.0),
            places=12,
        )

    def test_target_metric_and_volume_are_consistent(self) -> None:
        duration = 1.0
        hubble = 0.2
        scale = float(de_sitter_conformal_scale(duration, hubble))
        np.testing.assert_allclose(
            target_inverse_metric(duration, hubble),
            MINKOWSKI_INVERSE / scale**2,
        )
        self.assertAlmostEqual(target_volume_density(duration, hubble), scale**4)
        self.assertAlmostEqual(
            conformal_factor_squared_from_inverse_metric(
                target_inverse_metric(duration, hubble)
            ),
            scale**-2,
        )

    def test_physical_volume_sampling_shifts_events_to_later_time(self) -> None:
        flat_points, _ = sprinkle_conformal_de_sitter_diamond(
            np.random.default_rng(1234), 6000, 1.0, 0.0
        )
        curved_points, _ = sprinkle_conformal_de_sitter_diamond(
            np.random.default_rng(1234), 6000, 1.0, 0.35
        )
        self.assertGreater(
            float(np.mean(curved_points[:-1, 0])),
            float(np.mean(flat_points[:-1, 0])) + 0.02,
        )

    def test_development_selection_reads_flat_controls_only(self) -> None:
        base = argparse.Namespace(
            mode="development",
            events=240,
            realizations=2,
            duration=1.0,
            hubble_values=[0.0, 0.15],
            nonlocality_scales=[0.22, 0.28],
            physical_support_radii=[0.45],
            selected_nonlocality_scale=None,
            selected_physical_support_radius=None,
            block_size=128,
            seed=997,
            include_samples=False,
            output=None,
        )
        result = run_experiment(base)
        self.assertEqual(
            result["selected_setting"]["selection_data"],
            "flat H = 0 controls only",
        )
        selected_key = result["selected_setting"]["key"]

        curved_changed = argparse.Namespace(**vars(base))
        curved_changed.hubble_values = [0.0, 0.3]
        changed_result = run_experiment(curved_changed)
        self.assertEqual(changed_result["selected_setting"]["key"], selected_key)

    def test_held_out_mode_requires_frozen_setting(self) -> None:
        args = argparse.Namespace(
            mode="held-out",
            events=100,
            realizations=1,
            duration=1.0,
            hubble_values=[0.0, 0.1],
            nonlocality_scales=[0.2],
            physical_support_radii=[0.4],
            selected_nonlocality_scale=None,
            selected_physical_support_radius=None,
            block_size=64,
            seed=12,
            include_samples=False,
            output=None,
        )
        with self.assertRaisesRegex(ValueError, "selected-nonlocality-scale"):
            run_experiment(args)


if __name__ == "__main__":
    unittest.main()
