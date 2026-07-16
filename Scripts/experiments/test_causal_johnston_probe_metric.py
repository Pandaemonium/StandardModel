"""Tests for the Johnston interval-volume causal metric probes."""

from __future__ import annotations

import unittest

import numpy as np

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    open_interval_count_matrix,
    subspace_projector,
)
from causal_johnston_probe_metric import (
    causal_interval_points,
    choose_intrinsic_pivot,
    compact_lightcone_probes,
    intrinsic_compact_quadratic_probe,
    intrinsic_pivot_candidates,
    intrinsic_quadratic_normalization,
    intrinsic_time_and_radius,
    intrinsic_time_and_radius_from_relation,
    johnston_lightcone_embedding,
    johnston_lightcone_embedding_from_relation,
    lorentzian_quadratic_probe,
    minkowski_interval_coefficient,
    proper_time_squared_matrix,
    relabeling_errors,
    selected_open_interval_counts,
)
from causal_operator_metric import matrix_relative_error, smooth_compact_cutoff


class CausalJohnstonProbeMetricTests(unittest.TestCase):
    def setUp(self) -> None:
        self.points, self.bottom, self.top = causal_interval_points(
            np.random.default_rng(41), 160, 1.0
        )
        self.relation = causal_relation_matrix(self.points, block_size=64)
        self.counts = open_interval_count_matrix(self.relation)
        self.density = 160.0 / minkowski_interval_coefficient(4)
        self.proper_squared = proper_time_squared_matrix(
            self.relation, self.counts, self.density, 4
        )
        self.time, self.radius = intrinsic_time_and_radius(
            self.proper_squared, self.bottom, self.top, 1.0
        )
        self.pivot = choose_intrinsic_pivot(
            np.random.default_rng(43),
            self.relation,
            self.time,
            self.radius,
            self.bottom,
            self.top,
            1.0,
            4,
        )

    def test_four_dimensional_interval_coefficient(self) -> None:
        self.assertAlmostEqual(
            minkowski_interval_coefficient(4), np.pi / 24.0
        )

    def test_selected_interval_counts_match_full_matrix(self) -> None:
        left = np.array([self.bottom, self.pivot, 7])
        right = np.array([self.pivot, self.top, 91])
        selected = selected_open_interval_counts(
            self.relation, left, right
        )
        np.testing.assert_array_equal(selected, self.counts[np.ix_(left, right)])

    def test_endpoint_time_normalization(self) -> None:
        self.assertAlmostEqual(self.time[self.bottom], 0.0)
        self.assertAlmostEqual(self.time[self.top], 1.0)
        self.assertAlmostEqual(
            self.proper_squared[self.bottom, self.top], 1.0
        )

    def test_targeted_time_matches_all_pairs_time(self) -> None:
        targeted_time, targeted_radius = (
            intrinsic_time_and_radius_from_relation(
                self.relation,
                self.density,
                4,
                self.bottom,
                self.top,
                1.0,
            )
        )
        np.testing.assert_allclose(targeted_time, self.time)
        np.testing.assert_allclose(targeted_radius, self.radius)

    def test_targeted_embedding_matches_all_pairs_embedding(self) -> None:
        full = johnston_lightcone_embedding(
            self.relation,
            self.proper_squared,
            self.bottom,
            self.top,
            self.pivot,
            1.0,
            3,
        )
        targeted = johnston_lightcone_embedding_from_relation(
            self.relation,
            self.density,
            4,
            self.bottom,
            self.top,
            self.pivot,
            1.0,
            3,
        )
        np.testing.assert_allclose(targeted.probes[:, 0], full.probes[:, 0])
        np.testing.assert_allclose(
            subspace_projector(targeted.probes[:, 1:]),
            subspace_projector(full.probes[:, 1:]),
        )
        np.testing.assert_allclose(
            targeted.spatial_singular_values,
            full.spatial_singular_values,
        )

    def test_pivot_candidate_set_is_relabeling_equivariant(self) -> None:
        original = intrinsic_pivot_candidates(
            self.relation,
            self.time,
            self.radius,
            self.bottom,
            self.top,
            1.0,
            4,
        )
        permutation = np.random.default_rng(47).permutation(len(self.points))
        inverse = np.argsort(permutation)
        moved_relation = self.relation[np.ix_(permutation, permutation)]
        moved_time, moved_radius = intrinsic_time_and_radius_from_relation(
            moved_relation,
            self.density,
            4,
            int(inverse[self.bottom]),
            int(inverse[self.top]),
            1.0,
        )
        moved = intrinsic_pivot_candidates(
            moved_relation,
            moved_time,
            moved_radius,
            int(inverse[self.bottom]),
            int(inverse[self.top]),
            1.0,
            4,
        )
        np.testing.assert_array_equal(np.sort(permutation[moved]), original)

    def test_compact_lightcone_probes_relabel_as_a_subspace(self) -> None:
        embedding = johnston_lightcone_embedding_from_relation(
            self.relation,
            self.density,
            4,
            self.bottom,
            self.top,
            self.pivot,
            1.0,
            3,
        )
        probes = compact_lightcone_probes(embedding, 0.5)
        time_error, spatial_error = relabeling_errors(
            self.relation,
            self.density,
            4,
            1.0,
            self.bottom,
            self.top,
            self.pivot,
            0.5,
            probes,
            np.random.default_rng(53).permutation(len(self.points)),
        )
        self.assertLess(time_error, 1.0e-10)
        self.assertLess(spatial_error, 1.0e-10)
        np.testing.assert_allclose(probes[self.pivot], 0.0)
        self.assertTrue(np.all(np.isfinite(probes)))

    def test_lorentzian_quadratic_is_spatial_gauge_invariant(self) -> None:
        probes = np.random.default_rng(61).normal(size=(20, 4))
        raw = np.random.default_rng(67).normal(size=(3, 3))
        orthogonal, _ = np.linalg.qr(raw)
        moved = probes.copy()
        moved[:, 1:] = probes[:, 1:] @ orthogonal
        np.testing.assert_allclose(
            lorentzian_quadratic_probe(moved),
            lorentzian_quadratic_probe(probes),
        )

    def test_targeted_embedding_spatial_projector_is_finite(self) -> None:
        embedding = johnston_lightcone_embedding_from_relation(
            self.relation,
            self.density,
            4,
            self.bottom,
            self.top,
            self.pivot,
            1.0,
            3,
        )
        projector = subspace_projector(embedding.probes[:, 1:])
        self.assertTrue(np.all(np.isfinite(projector)))
        self.assertLess(
            matrix_relative_error(projector @ projector, projector),
            1.0e-10,
        )

    def test_intrinsic_quadratic_probe_matches_interval_proper_time(self) -> None:
        probe = intrinsic_compact_quadratic_probe(
            self.relation,
            self.counts[:, self.pivot],
            self.density,
            4,
            self.time,
            self.pivot,
            support_radius=10.0,
        )
        past = self.relation[:, self.pivot]
        np.testing.assert_allclose(
            probe[past], self.proper_squared[past, self.pivot]
        )
        np.testing.assert_array_equal(probe[~past], 0.0)

    def test_intrinsic_quadratic_probe_uses_squared_compact_cutoff(self) -> None:
        support_radius = 0.5
        probe = intrinsic_compact_quadratic_probe(
            self.relation,
            self.counts[:, self.pivot],
            self.density,
            4,
            self.time,
            self.pivot,
            support_radius,
        )
        past = self.relation[:, self.pivot]
        proper_squared = self.proper_squared[:, self.pivot]
        time_separation = self.time[self.pivot] - self.time
        spatial_squared = np.maximum(
            time_separation**2 - proper_squared, 0.0
        )
        radial_distance = np.sqrt(
            time_separation**2 + spatial_squared
        )
        cutoff = smooth_compact_cutoff(radial_distance, support_radius)
        np.testing.assert_allclose(
            probe[past], proper_squared[past] * cutoff[past] ** 2
        )

    def test_intrinsic_quadratic_probe_is_relabeling_equivariant(self) -> None:
        original = intrinsic_compact_quadratic_probe(
            self.relation,
            self.counts[:, self.pivot],
            self.density,
            4,
            self.time,
            self.pivot,
            0.5,
        )
        permutation = np.random.default_rng(59).permutation(len(self.points))
        inverse = np.argsort(permutation)
        moved_relation = self.relation[np.ix_(permutation, permutation)]
        moved_counts = open_interval_count_matrix(moved_relation)
        moved_time, _ = intrinsic_time_and_radius_from_relation(
            moved_relation,
            self.density,
            4,
            int(inverse[self.bottom]),
            int(inverse[self.top]),
            1.0,
        )
        moved_pivot = int(inverse[self.pivot])
        moved = intrinsic_compact_quadratic_probe(
            moved_relation,
            moved_counts[:, moved_pivot],
            self.density,
            4,
            moved_time,
            moved_pivot,
            0.5,
        )
        np.testing.assert_allclose(moved[inverse], original)

    def test_intrinsic_quadratic_normalization_targets_two_dimensions(self) -> None:
        row = np.array([1.0, 2.0, 0.0])
        probe = np.array([2.0, 1.0, 0.0])
        response, factor = intrinsic_quadratic_normalization(
            row, probe, dimension=4
        )
        self.assertEqual(response, 4.0)
        self.assertEqual(factor, 2.0)

    def test_nonpositive_quadratic_response_is_a_failed_normalization(self) -> None:
        response, factor = intrinsic_quadratic_normalization(
            np.array([-1.0, 0.0]),
            np.array([1.0, 0.0]),
            dimension=4,
        )
        self.assertEqual(response, -1.0)
        self.assertIsNone(factor)


if __name__ == "__main__":
    unittest.main()
