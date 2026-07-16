"""Tests for Stage A13 local multi-anchor Johnston atlases."""

from __future__ import annotations

import unittest

import numpy as np

from causal_intrinsic_probe_metric import causal_relation_matrix
from causal_johnston_multi_anchor_atlas import (
    construct_local_multi_anchor_chart,
    reconstruct_multi_anchor_atlas_realization,
    select_anchor_scale,
    select_local_interval_endpoints,
)
from causal_johnston_probe_metric import (
    causal_interval_points,
    minkowski_interval_coefficient,
)


class JohnstonMultiAnchorAtlasTests(unittest.TestCase):
    def test_count_derived_endpoints_bracket_target(self) -> None:
        rng = np.random.default_rng(20260808)
        points, bottom, top = causal_interval_points(rng, 160, 1.0)
        relation = causal_relation_matrix(points, 64)
        density = 160 / minkowski_interval_coefficient(4)
        target = int(np.argmax(np.count_nonzero(relation, axis=0) * np.count_nonzero(relation, axis=1)))
        lower, upper, _, _, endpoint_time = select_local_interval_endpoints(
            relation, target, density, 4, 0.2
        )
        self.assertTrue(relation[lower, target])
        self.assertTrue(relation[target, upper])
        self.assertGreater(endpoint_time, 0.0)
        self.assertNotEqual(lower, bottom if target != bottom else top)

    def test_local_full_chart_contains_and_centers_target(self) -> None:
        rng = np.random.default_rng(20260809)
        points, _, _ = causal_interval_points(rng, 180, 1.0)
        relation = causal_relation_matrix(points, 64)
        density = 180 / minkowski_interval_coefficient(4)
        target = int(np.argmax(np.count_nonzero(relation, axis=0) * np.count_nonzero(relation, axis=1)))
        chart = construct_local_multi_anchor_chart(
            relation,
            target,
            density,
            dimension=4,
            anchor_half_time=0.5,
            minimum_chart_events=8,
        )
        self.assertTrue(chart.embedding.embedded_mask[target])
        np.testing.assert_allclose(chart.embedding.probes[target], 0.0, atol=1.0e-12)
        self.assertGreaterEqual(chart.carrier_count, 8)

    def test_selection_prioritizes_full_then_transition_gate(self) -> None:
        summaries = {
            "transition_only": {
                "full_atlas_gate_success_rate": 0.0,
                "transition_gate_success_rate": 1.0,
                "chart_availability_fraction": {"median": 1.0},
                "synchronized_geometry_residual_median": {"median": 0.2},
                "local_affine_fit_median": {"median": 0.2},
                "anchor_half_time": 0.2,
            },
            "full": {
                "full_atlas_gate_success_rate": 1.0,
                "transition_gate_success_rate": 1.0,
                "chart_availability_fraction": {"median": 0.9},
                "synchronized_geometry_residual_median": {"median": 0.3},
                "local_affine_fit_median": {"median": 0.3},
                "anchor_half_time": 0.25,
            },
        }
        key, _ = select_anchor_scale(summaries)
        self.assertEqual(key, "full")

    def test_small_closed_realization_is_finite(self) -> None:
        samples = reconstruct_multi_anchor_atlas_realization(
            np.random.default_rng(20260810),
            events=140,
            duration=1.0,
            dimension=4,
            block_size=64,
            averaging_radius=0.05,
            maximum_targets=4,
            registration_radius=0.30,
            affine_radius=0.30,
            minimum_lightcone_count=3,
            minimum_chart_events=8,
            anchor_half_times=[0.20],
            maximum_geometry_error=1.0,
            maximum_synchronization_mismatch=1.0,
            maximum_affine_error=1.0,
            maximum_cocycle_error=1.0e-10,
            minimum_edge_fraction=0.0,
            minimum_rank_three_fraction=0.0,
        )
        self.assertEqual(len(samples), 1)
        self.assertGreaterEqual(samples[0].raw_target_count, 1)
        self.assertLessEqual(samples[0].used_target_count, 4)


if __name__ == "__main__":
    unittest.main()
