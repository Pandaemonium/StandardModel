"""Tests for Stage A10 overlapping Johnston lightcone atlas metrics."""

from __future__ import annotations

import unittest

import numpy as np

from causal_johnston_local_atlas_metric import (
    cocycle_relative_error,
    reconstruct_local_atlas_realization,
    select_atlas_radius,
    spatial_chart_registration,
    transport_pairing_to_reference,
)
from causal_johnston_probe_metric import JohnstonLightconeEmbedding


def chart(probes: np.ndarray, pivot: int) -> JohnstonLightconeEmbedding:
    return JohnstonLightconeEmbedding(
        probes=probes,
        embedded_mask=np.ones(len(probes), dtype=bool),
        intrinsic_time=probes[:, 0],
        intrinsic_radius=np.linalg.norm(probes[:, 1:], axis=1),
        spatial_singular_values=np.array([3.0, 2.0, 1.0, 0.1]),
        spatial_rank_gap=0.9,
        dominant_spatial_gap_rank=3,
        pivot_index=pivot,
        past_count=4,
        future_count=4,
        scale_balance_residual=0.0,
    )


class JohnstonLocalAtlasMetricTests(unittest.TestCase):
    def test_registration_recovers_spatial_gauge_and_transports_pairing(
        self,
    ) -> None:
        rng = np.random.default_rng(20260802)
        reference_probes = rng.normal(scale=0.05, size=(12, 4))
        angle = 0.4
        rotation = np.array(
            [
                [np.cos(angle), -np.sin(angle), 0.0],
                [np.sin(angle), np.cos(angle), 0.0],
                [0.0, 0.0, -1.0],
            ]
        )
        moving_probes = reference_probes.copy()
        moving_probes[:, 1:] = reference_probes[:, 1:] @ rotation.T + np.array(
            [0.2, -0.1, 0.3]
        )
        registration = spatial_chart_registration(
            chart(reference_probes, 0),
            chart(moving_probes, 1),
            registration_radius=1.0,
        )
        self.assertIsNotNone(registration)
        assert registration is not None
        np.testing.assert_allclose(
            registration.moving_to_reference, rotation, atol=1.0e-12
        )
        self.assertLess(registration.relative_residual, 1.0e-12)

        reference_pairing = np.array(
            [
                [1.0, 0.2, -0.1, 0.05],
                [0.2, -0.7, 0.1, 0.0],
                [-0.1, 0.1, -1.2, 0.2],
                [0.05, 0.0, 0.2, -0.9],
            ]
        )
        transform = np.eye(4)
        transform[1:, 1:] = rotation
        moving_pairing = transform @ reference_pairing @ transform.T
        transported = transport_pairing_to_reference(
            moving_pairing, registration.moving_to_reference
        )
        np.testing.assert_allclose(transported, reference_pairing, atol=1.0e-12)

    def test_exact_rotations_satisfy_cocycle(self) -> None:
        theta = 0.3
        first = np.array(
            [
                [np.cos(theta), -np.sin(theta), 0.0],
                [np.sin(theta), np.cos(theta), 0.0],
                [0.0, 0.0, 1.0],
            ]
        )
        second = np.diag([1.0, -1.0, 1.0])
        direct = first @ second
        self.assertLess(cocycle_relative_error(first, second, direct), 1.0e-14)

    def test_selection_prioritizes_atlas_then_metric_gates(self) -> None:
        summaries = {
            "pivot_baseline": {
                "row_count": {"median": 1.0},
                "atlas_gate_success_rate": 1.0,
                "trace_coordinate_gate_success_rate": 0.0,
                "coordinate_conformal_gate_success_rate": 0.0,
                "trace_coordinate_relative_error": {"median": 2.0},
                "coordinate_conformal_relative_error": {"median": 1.0},
                "averaging_radius": 0.0,
            },
            "low_atlas": {
                "row_count": {"median": 2.0},
                "atlas_gate_success_rate": 0.4,
                "trace_coordinate_gate_success_rate": 1.0,
                "coordinate_conformal_gate_success_rate": 1.0,
                "trace_coordinate_relative_error": {"median": 0.1},
                "coordinate_conformal_relative_error": {"median": 0.1},
                "averaging_radius": 0.04,
            },
            "high_atlas": {
                "row_count": {"median": 4.0},
                "atlas_gate_success_rate": 0.8,
                "trace_coordinate_gate_success_rate": 0.5,
                "coordinate_conformal_gate_success_rate": 0.5,
                "trace_coordinate_relative_error": {"median": 0.4},
                "coordinate_conformal_relative_error": {"median": 0.4},
                "averaging_radius": 0.06,
            },
        }
        key, _ = select_atlas_radius(summaries)
        self.assertEqual(key, "high_atlas")

    def test_small_closed_realization_is_finite(self) -> None:
        samples = reconstruct_local_atlas_realization(
            np.random.default_rng(20260802),
            events=120,
            duration=1.0,
            dimension=4,
            block_size=64,
            nonlocality_scale=0.35,
            support_radius=0.65,
            averaging_radii=[0.0, 0.04],
            registration_radius=0.3,
            affine_radius=0.3,
            maximum_registration_error=1.0,
            maximum_cocycle_error=1.0,
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
        self.assertTrue(all(sample.johnston_signature is None for sample in samples))


if __name__ == "__main__":
    unittest.main()
