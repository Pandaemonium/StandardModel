"""Tests for Johnston's simultaneous full-interval embedding."""

from __future__ import annotations

import unittest

import numpy as np

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    subspace_projector,
)
from causal_johnston_full_embedding import (
    all_open_interval_counts,
    causal_pair_spatial_distances,
    induced_causal_relation,
    johnston_full_embedding_from_relation,
    min_plus_spatial_distance_completion,
    reconstruct_full_embedding_sample,
    spatial_gram_from_distances,
    truncated_mds_coordinates,
)
from causal_johnston_probe_metric import (
    causal_interval_points,
    minkowski_interval_coefficient,
)


class JohnstonFullEmbeddingTests(unittest.TestCase):
    def test_causal_pair_distance_uses_inclusive_interval_count(self) -> None:
        relation = np.array(
            [
                [False, True, True],
                [False, False, True],
                [False, False, False],
            ]
        )
        counts = all_open_interval_counts(relation)
        self.assertEqual(counts[0, 2], 1)
        time = np.array([0.0, 1.0, 3.0])
        distances, tau_squared = causal_pair_spatial_distances(
            relation,
            counts,
            time,
            density=2.0,
            dimension=2,
        )
        # c_2 * density = 1, so the inclusive count 1 + 2 gives tau^2=3.
        self.assertAlmostEqual(tau_squared[0, 2], 3.0)
        self.assertAlmostEqual(distances[0, 2], np.sqrt(9.0 - 3.0))
        self.assertFalse(np.isinf(distances[0, 0]))

    def test_min_plus_completion_uses_best_common_anchor(self) -> None:
        relation = np.array(
            [
                [False, True, True, True],
                [False, False, False, True],
                [False, False, False, True],
                [False, False, False, False],
            ]
        )
        direct = np.full((4, 4), np.inf)
        np.fill_diagonal(direct, 0.0)
        for left, right, distance in (
            (0, 1, 1.0),
            (0, 2, 4.0),
            (1, 3, 2.0),
            (2, 3, 2.0),
            (0, 3, 10.0),
        ):
            direct[left, right] = distance
            direct[right, left] = distance
        completed = min_plus_spatial_distance_completion(relation, direct)
        self.assertEqual(completed[1, 2], 4.0)
        # Comparable pairs retain equation (8), even if a two-leg path is less.
        self.assertEqual(completed[0, 3], 10.0)

    def test_mds_recovers_exact_euclidean_gram(self) -> None:
        points = np.array(
            [
                [0.0, 0.0],
                [1.0, 0.0],
                [0.0, 2.0],
                [1.0, 2.0],
            ]
        )
        distances = np.linalg.norm(points[:, None, :] - points[None, :, :], axis=2)
        gram = spatial_gram_from_distances(distances, origin_index=0)
        coordinates, _, _, _, residual = truncated_mds_coordinates(
            gram, spatial_rank=2, eigenvalue_count=3
        )
        np.testing.assert_allclose(
            coordinates @ coordinates.T,
            points @ points.T,
            atol=1.0e-12,
        )
        self.assertLess(residual, 1.0e-12)

    def test_embedding_is_relabeling_equivariant_up_to_spatial_gauge(
        self,
    ) -> None:
        rng = np.random.default_rng(20260729)
        points, bottom, top = causal_interval_points(rng, 48, 1.0)
        relation = causal_relation_matrix(points, block_size=32)
        density = 48 / minkowski_interval_coefficient(4)
        original = johnston_full_embedding_from_relation(
            relation, density, 4, bottom, top, 1.0
        )

        permutation = rng.permutation(len(points))
        moved_relation = relation[np.ix_(permutation, permutation)]
        moved_bottom = int(np.flatnonzero(permutation == bottom)[0])
        moved_top = int(np.flatnonzero(permutation == top)[0])
        moved = johnston_full_embedding_from_relation(
            moved_relation,
            density,
            4,
            moved_bottom,
            moved_top,
            1.0,
        )
        inverse = np.argsort(permutation)
        pulled = moved.coordinates[inverse]
        np.testing.assert_allclose(
            pulled[:, 0], original.coordinates[:, 0], atol=1.0e-12
        )
        np.testing.assert_allclose(
            moved.spatial_distances[np.ix_(inverse, inverse)],
            original.spatial_distances,
            atol=1.0e-12,
        )
        self.assertLess(
            np.linalg.norm(
                subspace_projector(pulled[:, 1:])
                - subspace_projector(original.coordinates[:, 1:])
            ),
            1.0e-9,
        )

    def test_induced_relation_matches_simple_coordinates(self) -> None:
        coordinates = np.array(
            [
                [0.0, 0.0, 0.0, 0.0],
                [1.0, 0.0, 0.0, 0.0],
                [1.0, 2.0, 0.0, 0.0],
            ]
        )
        relation = induced_causal_relation(coordinates)
        self.assertTrue(relation[0, 1])
        self.assertFalse(relation[0, 2])
        self.assertFalse(np.any(np.diag(relation)))

    def test_small_full_embedding_sample_is_finite(self) -> None:
        sample = reconstruct_full_embedding_sample(
            np.random.default_rng(20260730),
            events=80,
            duration=1.0,
            dimension=4,
            block_size=64,
            support_radius=0.65,
            affine_radius=0.3,
            distance_pair_samples=1000,
        )
        self.assertEqual(sample.local_jacobian_rank, 4)
        self.assertTrue(np.isfinite(sample.quadratic_relative_error))
        self.assertTrue(np.isfinite(sample.causal_sensitivity))
        self.assertTrue(np.isfinite(sample.causal_specificity))
        self.assertGreater(sample.causal_sensitivity, 0.0)
        self.assertGreater(sample.causal_specificity, 0.0)


if __name__ == "__main__":
    unittest.main()
