"""Tests for Stage A24 count-volume Weyl reconstruction."""

from __future__ import annotations

import unittest

import numpy as np

from causal_count_volume_weyl_metric import (
    count_window_scales,
    fit_affine_factor_field,
    local_count_volume_factor,
    window_fits_coordinate_diamond,
)


class CausalCountVolumeWeylMetricTests(unittest.TestCase):
    def test_count_window_schedule_has_required_limits(self) -> None:
        coarse = count_window_scales(0.08, 1.0, 0.65, 0.9)
        fine = count_window_scales(0.02, 1.0, 0.65, 0.9)
        self.assertLess(
            fine.coordinate_window_half_duration,
            coarse.coordinate_window_half_duration,
        )
        self.assertLess(fine.coordinate_center_radius, coarse.coordinate_center_radius)
        self.assertLess(
            fine.coordinate_ell / fine.coordinate_window_half_duration,
            coarse.coordinate_ell / coarse.coordinate_window_half_duration,
        )

    def test_window_boundary_check(self) -> None:
        self.assertTrue(
            window_fits_coordinate_diamond(
                np.array([0.7, 0.02, 0.0, 0.0]), 0.1, 1.0
            )
        )
        self.assertFalse(
            window_fits_coordinate_diamond(
                np.array([0.7, 0.25, 0.0, 0.0]), 0.1, 1.0
            )
        )

    def test_affine_factor_fit_is_exact(self) -> None:
        rng = np.random.default_rng(8)
        points = rng.normal(size=(30, 4))
        pivot = 0
        gradient = np.array([-0.2, 0.04, -0.03, 0.01])
        factors = 0.9 + (points - points[pivot]) @ gradient
        factor, actual_gradient, rank, _ = fit_affine_factor_field(
            points, pivot, np.arange(len(points)), factors
        )
        self.assertEqual(rank, 5)
        self.assertAlmostEqual(factor, 0.9, places=12)
        np.testing.assert_allclose(actual_gradient, gradient, atol=1.0e-12)

    def test_uniform_lattice_count_recovers_flat_factor(self) -> None:
        grid = np.linspace(-0.09, 0.09, 7)
        mesh = np.stack(np.meshgrid(grid, grid, grid, indexing="ij"), axis=-1)
        spatial = mesh.reshape(-1, 3)
        times = np.linspace(0.41, 0.59, 7)
        points = np.concatenate(
            [
                np.column_stack((np.full(len(spatial), time), spatial))
                for time in times
            ]
        )
        center = np.array([0.5, 0.0, 0.0, 0.0])
        radius_squared = np.sum(points[:, 1:] ** 2, axis=1)
        from_lower = points[:, 0] - 0.4
        to_upper = 0.6 - points[:, 0]
        inside = (
            (from_lower > 0.0)
            & (from_lower**2 > radius_squared)
            & (to_upper > 0.0)
            & (to_upper**2 > radius_squared)
        )
        same_as_center = np.all(np.isclose(points, center, atol=0.0), axis=1)
        count = int(np.count_nonzero(inside & ~same_as_center))
        coordinate_volume = np.pi * 0.2**4 / 24.0
        density = count / coordinate_volume
        actual_count, factor, volume = local_count_volume_factor(
            points, density, center, 0.1, 1.0
        )
        self.assertEqual(actual_count, count)
        self.assertAlmostEqual(factor, 1.0)
        self.assertAlmostEqual(volume, 1.0)


if __name__ == "__main__":
    unittest.main()
