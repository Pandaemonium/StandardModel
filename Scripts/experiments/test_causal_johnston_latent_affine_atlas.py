"""Tests for Stage A12 depth-filtered shared affine Johnston atlases."""

from __future__ import annotations

import unittest

import numpy as np

from causal_johnston_latent_affine_atlas import (
    fit_shared_affine_latent_geometry,
    reconstruct_latent_affine_atlas_realization,
    select_regularization,
)
from causal_johnston_probe_metric import JohnstonLightconeEmbedding


def chart(spatial: np.ndarray, pivot: int) -> JohnstonLightconeEmbedding:
    probes = np.column_stack((np.zeros(len(spatial)), spatial))
    return JohnstonLightconeEmbedding(
        probes=probes,
        embedded_mask=np.ones(len(spatial), dtype=bool),
        intrinsic_time=np.zeros(len(spatial)),
        intrinsic_radius=np.linalg.norm(spatial, axis=1),
        spatial_singular_values=np.array([3.0, 2.0, 1.0, 0.1]),
        spatial_rank_gap=0.9,
        dominant_spatial_gap_rank=3,
        pivot_index=pivot,
        past_count=6,
        future_count=6,
        scale_balance_residual=0.0,
    )


class JohnstonLatentAffineAtlasTests(unittest.TestCase):
    def test_shared_affine_fit_recovers_exact_common_geometry(self) -> None:
        rng = np.random.default_rng(20260806)
        latent = rng.normal(scale=0.04, size=(20, 3))
        first_linear = np.array(
            [[1.2, 0.1, 0.0], [0.0, 0.8, 0.1], [0.0, 0.0, 1.1]]
        )
        second_linear = np.array(
            [[0.9, 0.0, 0.1], [0.1, 1.1, 0.0], [0.0, 0.1, 0.7]]
        )
        first_translation = np.array([0.02, -0.01, 0.03])
        second_translation = np.array([-0.01, 0.04, -0.02])
        charts = {
            0: chart(latent, 0),
            1: chart(
                (latent - first_translation) @ np.linalg.inv(first_linear), 1
            ),
            2: chart(
                (latent - second_translation) @ np.linalg.inv(second_linear), 2
            ),
        }
        fit = fit_shared_affine_latent_geometry(
            charts,
            pivot_index=0,
            registration_radius=1.0,
            regularization=0.0,
        )
        self.assertIsNotNone(fit)
        assert fit is not None
        self.assertTrue(fit.converged)
        self.assertLess(fit.joint_geometry_residual_maximum, 1.0e-8)
        self.assertLess(fit.affine_cocycle_maximum, 1.0e-12)

    def test_selection_prioritizes_gate_then_convergence(self) -> None:
        summaries = {
            "unconverged": {
                "latent_affine_atlas_gate_success_rate": 0.0,
                "fit_convergence_rate": 0.0,
                "joint_geometry_residual_median": {"median": 0.1},
                "transform_condition_maximum": {"median": 1.0},
                "regularization": 0.0,
            },
            "converged": {
                "latent_affine_atlas_gate_success_rate": 0.0,
                "fit_convergence_rate": 1.0,
                "joint_geometry_residual_median": {"median": 0.2},
                "transform_condition_maximum": {"median": 2.0},
                "regularization": 0.1,
            },
        }
        key, _ = select_regularization(summaries)
        self.assertEqual(key, "converged")

    def test_small_closed_realization_is_finite(self) -> None:
        samples = reconstruct_latent_affine_atlas_realization(
            np.random.default_rng(20260806),
            events=120,
            duration=1.0,
            dimension=4,
            block_size=64,
            averaging_radius=0.04,
            registration_radius=0.30,
            minimum_lightcone_count=3,
            regularizations=[0.1],
            maximum_geometry_error=1.0,
            maximum_transform_condition=100.0,
            minimum_transform_singular_value=0.001,
            maximum_transform_singular_value=100.0,
            maximum_cocycle_error=1.0e-10,
            minimum_edge_fraction=0.0,
        )
        self.assertEqual(len(samples), 1)
        sample = samples[0]
        self.assertGreaterEqual(sample.raw_target_count, 1)
        self.assertLessEqual(
            sample.depth_eligible_target_count, sample.raw_target_count
        )
        self.assertTrue(np.isfinite(sample.depth_retention_fraction))


if __name__ == "__main__":
    unittest.main()
