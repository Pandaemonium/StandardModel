"""Tests for Stage A11 simultaneous Johnston chart synchronization."""

from __future__ import annotations

import unittest

import numpy as np

from causal_johnston_local_atlas_metric import SpatialRegistration
from causal_johnston_synchronized_atlas import (
    reconstruct_synchronized_atlas_realization,
    registration_graph_connected,
    select_registration_radius,
    synchronize_spatial_frames,
    synchronized_transition,
)


def registration(transition: np.ndarray) -> SpatialRegistration:
    return SpatialRegistration(
        moving_to_reference=transition,
        overlap_count=25,
        relative_residual=0.0,
        determinant=float(np.linalg.det(transition)),
    )


class JohnstonSynchronizedAtlasTests(unittest.TestCase):
    def test_exact_pairwise_frames_are_recovered_up_to_reference_gauge(self) -> None:
        angle = 0.4
        chart_to_reference = {
            0: np.eye(3),
            1: np.array(
                [
                    [np.cos(angle), -np.sin(angle), 0.0],
                    [np.sin(angle), np.cos(angle), 0.0],
                    [0.0, 0.0, 1.0],
                ]
            ),
            2: np.diag([1.0, -1.0, 1.0]),
        }
        edges = {
            (reference, moving): registration(
                chart_to_reference[moving] @ chart_to_reference[reference].T
            )
            for reference in chart_to_reference
            for moving in chart_to_reference
            if reference < moving
        }
        synchronized = synchronize_spatial_frames([0, 1, 2], edges, 0)
        self.assertIsNotNone(synchronized)
        assert synchronized is not None
        for (reference, moving), edge in edges.items():
            np.testing.assert_allclose(
                synchronized_transition(synchronized, reference, moving),
                edge.moving_to_reference,
                atol=1.0e-12,
            )
        self.assertLess(synchronized.edge_mismatch_maximum, 1.0e-12)

    def test_disconnected_registration_graph_is_rejected(self) -> None:
        edges = {(0, 1): registration(np.eye(3))}
        self.assertFalse(registration_graph_connected([0, 1, 2], edges))
        self.assertIsNone(synchronize_spatial_frames([0, 1, 2], edges, 0))

    def test_single_chart_has_identity_synchronization(self) -> None:
        synchronized = synchronize_spatial_frames([7], {}, 7)
        self.assertIsNotNone(synchronized)
        assert synchronized is not None
        np.testing.assert_array_equal(
            synchronized.chart_to_reference[7], np.eye(3)
        )
        self.assertEqual(synchronized.edge_mismatch_maximum, 0.0)

    def test_selection_prioritizes_gate_then_geometry(self) -> None:
        summaries = {
            "larger_error": {
                "synchronized_atlas_gate_success_rate": 0.5,
                "synchronized_geometry_residual_median": {"median": 0.4},
                "synchronization_mismatch_median": {"median": 0.1},
                "chart_availability_fraction": {"median": 1.0},
                "registration_radius": 0.1,
            },
            "smaller_error": {
                "synchronized_atlas_gate_success_rate": 0.5,
                "synchronized_geometry_residual_median": {"median": 0.2},
                "synchronization_mismatch_median": {"median": 0.2},
                "chart_availability_fraction": {"median": 1.0},
                "registration_radius": 0.2,
            },
        }
        key, _ = select_registration_radius(summaries)
        self.assertEqual(key, "smaller_error")

    def test_small_closed_realization_is_finite(self) -> None:
        samples = reconstruct_synchronized_atlas_realization(
            np.random.default_rng(20260804),
            events=120,
            duration=1.0,
            dimension=4,
            block_size=64,
            averaging_radius=0.04,
            registration_radii=[0.20],
            maximum_geometry_error=1.0,
            maximum_synchronization_mismatch=1.0,
            maximum_cocycle_error=1.0e-10,
            minimum_edge_fraction=0.0,
        )
        self.assertEqual(len(samples), 1)
        sample = samples[0]
        self.assertGreaterEqual(sample.target_count, 1)
        self.assertTrue(np.isfinite(sample.chart_availability_fraction))
        if sample.synchronized_cocycle_maximum is not None:
            self.assertLess(sample.synchronized_cocycle_maximum, 1.0e-12)


if __name__ == "__main__":
    unittest.main()
