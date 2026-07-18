"""Hostile exact controls for Stage S1 corrected-pairing spectroscopy."""

from __future__ import annotations

import unittest

import numpy as np

from causal_corrected_spectrum import (
    carrier_weight_row,
    corrected_operator_matrix,
    expected_inertia,
    source_local_4d_coefficient,
    source_local_4d_prefactor,
    spectrum_summary,
)


def three_arm_diamond() -> np.ndarray:
    """Today's kernel witness order: 0 < {1,2,3} < 4 (and 0 < 4)."""

    relation = np.zeros((5, 5), dtype=bool)
    relation[0, 1] = relation[0, 2] = relation[0, 3] = relation[0, 4] = True
    relation[1, 4] = relation[2, 4] = relation[3, 4] = True
    return relation


def inclusive_counts(relation: np.ndarray) -> np.ndarray:
    counts = np.zeros(relation.shape, dtype=int)
    n = len(relation)
    for a in range(n):
        for b in range(n):
            if relation[a, b]:
                counts[a, b] = int(np.sum(relation[a] & relation[:, b])) + 1
    return counts


class CorrectedSpectrumTests(unittest.TestCase):
    def test_operator_matrix_is_symmetric_kills_constants_zero_sums(self) -> None:
        rng = np.random.default_rng(5)
        weights = rng.normal(size=7)
        weights[3] = 0.0
        matrix = corrected_operator_matrix(weights, 3)
        np.testing.assert_array_equal(matrix, matrix.T)
        constants = np.ones(7)
        np.testing.assert_allclose(matrix @ constants, 0.0, atol=1e-12)
        probe = rng.normal(size=7)
        self.assertAlmostEqual(float(np.sum(matrix @ probe)), 0.0, places=12)

    def test_matrix_represents_the_weighted_difference_form(self) -> None:
        rng = np.random.default_rng(11)
        weights = rng.normal(size=6)
        weights[2] = 0.0
        matrix = corrected_operator_matrix(weights, 2)
        f, h = rng.normal(size=6), rng.normal(size=6)
        form = 0.5 * float(
            np.sum(weights * (f - f[2]) * (h - h[2]))
        )
        self.assertAlmostEqual(float(f @ matrix @ h), form, places=10)

    def test_kernel_witness_diamond_weights_and_inertia(self) -> None:
        relation = three_arm_diamond()
        counts = inclusive_counts(relation)
        members = np.array([0, 1, 2, 3, 4])
        weights = carrier_weight_row(relation, counts, members, 4, 1.0)
        p = source_local_4d_prefactor(1.0)
        np.testing.assert_allclose(
            weights, [8 * p, -p, -p, -p, 0.0], rtol=1e-12
        )
        self.assertEqual(expected_inertia(weights, 4), (1, 0, 3))
        summary = spectrum_summary(
            corrected_operator_matrix(weights, 4), weights, 4
        )
        self.assertTrue(summary["inertia_tripwire"])
        self.assertEqual(summary["observed_inertia"][0], 1)
        self.assertEqual(summary["observed_inertia"][2], 3)

    def test_coefficient_and_prefactor_mirror_kernel_values(self) -> None:
        self.assertEqual(
            [source_local_4d_coefficient(n) for n in range(6)],
            [1.0, -9.0, 16.0, -8.0, 0.0, 0.0],
        )
        self.assertGreater(source_local_4d_prefactor(1.0), 0.0)

    def test_sylvester_tripwire_holds_on_random_weights(self) -> None:
        rng = np.random.default_rng(23)
        for trial in range(25):
            size = int(rng.integers(3, 12))
            top = int(rng.integers(size))
            weights = rng.normal(size=size)
            weights[top] = 0.0
            if trial % 3 == 0:
                weights[int(rng.integers(size))] = 0.0
            summary = spectrum_summary(
                corrected_operator_matrix(weights, top), weights, top
            )
            self.assertTrue(summary["inertia_tripwire"], f"trial {trial}")

    def test_gap_statistics_flag_a_planted_four_cluster(self) -> None:
        weights = np.array([100.0, -101.0, 99.5, -100.5, 0.001, -0.002, 0.0015, 0.0])
        summary = spectrum_summary(
            corrected_operator_matrix(weights, 7), weights, 7
        )
        self.assertTrue(summary["cluster_of_four_indicator"])
        flat = np.array([1.0, -1.1, 0.9, -1.05, 0.95, -0.98, 1.02, 0.0])
        flat_summary = spectrum_summary(
            corrected_operator_matrix(flat, 7), flat, 7
        )
        self.assertFalse(flat_summary["cluster_of_four_indicator"])

    def test_weight_row_rejects_noncomparable_members(self) -> None:
        relation = three_arm_diamond()
        counts = inclusive_counts(relation)
        with self.assertRaises(ValueError):
            carrier_weight_row(
                relation, counts, np.array([1, 2, 4]), 2, 1.0
            )


if __name__ == "__main__":
    unittest.main()
