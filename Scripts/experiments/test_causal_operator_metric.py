"""Unit tests for the causal-operator metric calibration oracle."""

from __future__ import annotations

import unittest

import numpy as np

from causal_operator_metric import (
    LOCAL_LAYER_COEFFICIENTS,
    compact_coordinate_probes,
    corrected_gamma,
    diamond_volume_4d,
    fixed_probe_transform,
    interval_counts_to_target,
    local_bd_row,
    matrix_relative_error,
    project_convention_row,
    smooth_compact_cutoff,
    smeared_bd_row,
)


class CausalOperatorMetricTests(unittest.TestCase):
    def test_diamond_volume_unit_duration(self) -> None:
        self.assertAlmostEqual(diamond_volume_4d(1.0), np.pi / 24.0)

    def test_interval_counts_on_three_event_chain(self) -> None:
        points = np.array(
            [
                [0.0, 0.0, 0.0, 0.0],
                [1.0, 0.0, 0.0, 0.0],
                [2.0, 0.0, 0.0, 0.0],
            ]
        )
        past, counts = interval_counts_to_target(points, 2, block_size=2)
        np.testing.assert_array_equal(past, [True, True, False])
        np.testing.assert_array_equal(counts, [1, 0, 0])

    def test_local_layer_coefficients(self) -> None:
        past = np.array([True, True, True, True, True, False])
        counts = np.array([0, 1, 2, 3, 4, 0])
        ell = 0.5
        row = local_bd_row(past, counts, target_index=5, ell=ell)
        prefactor = 4.0 / (np.sqrt(6.0) * ell**2)
        np.testing.assert_allclose(row[:4], prefactor * LOCAL_LAYER_COEFFICIENTS)
        self.assertEqual(row[4], 0.0)
        self.assertAlmostEqual(row[5], -prefactor)

    def test_smeared_epsilon_one_reduces_to_local(self) -> None:
        past = np.array([True, True, True, True, False])
        counts = np.array([0, 1, 2, 3, 0])
        local = local_bd_row(past, counts, target_index=4, ell=0.3)
        smeared = smeared_bd_row(
            past, counts, target_index=4, ell=0.3, nonlocality_scale=0.3
        )
        np.testing.assert_allclose(smeared, local)

    def test_project_convention_negates_source_operator(self) -> None:
        source = np.array([1.5, -2.0, 0.25])
        np.testing.assert_array_equal(project_convention_row(source), -source)

    def test_compact_probes_preserve_near_coordinates_and_cut_off_far(self) -> None:
        points = np.array(
            [
                [0.0, 0.0, 0.0, 0.0],
                [0.8, 0.1, 0.0, 0.0],
                [1.0, 0.0, 0.0, 0.0],
            ]
        )
        probes = compact_coordinate_probes(points, target_index=2, support_radius=0.6)
        np.testing.assert_array_equal(probes[0], np.zeros(4))
        np.testing.assert_allclose(probes[1], points[1] - points[2])
        np.testing.assert_array_equal(probes[2], np.zeros(4))

    def test_smooth_cutoff_has_fixed_inner_and_outer_values(self) -> None:
        distances = np.array([0.0, 0.25, 0.375, 0.5, 0.75])
        cutoff = smooth_compact_cutoff(distances, support_radius=0.5)
        np.testing.assert_allclose(cutoff[:2], 1.0)
        self.assertAlmostEqual(cutoff[2], 0.5)
        np.testing.assert_allclose(cutoff[3:], 0.0)

    def test_scalar_potential_cancels_from_corrected_gamma(self) -> None:
        rng = np.random.default_rng(11)
        row = rng.normal(size=7)
        probes = rng.normal(size=(7, 4))
        target = 6
        shifted = row.copy()
        shifted[target] += 3.7
        np.testing.assert_allclose(
            corrected_gamma(shifted, probes, target),
            corrected_gamma(row, probes, target),
            atol=1.0e-12,
        )

    def test_affine_probe_covariance_for_linear_operator(self) -> None:
        rng = np.random.default_rng(19)
        row = rng.normal(size=9)
        probes = rng.normal(size=(9, 4))
        target = 8
        linear, offset = fixed_probe_transform()
        transformed = probes @ linear.T + offset
        base_metric = corrected_gamma(row, probes, target)
        transformed_metric = corrected_gamma(row, transformed, target)
        expected = linear @ base_metric @ linear.T
        self.assertLess(matrix_relative_error(transformed_metric, expected), 1.0e-12)


if __name__ == "__main__":
    unittest.main()
