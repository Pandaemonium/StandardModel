"""Tests for the order-only causal metric probe prototypes."""

from __future__ import annotations

import unittest

import numpy as np

from causal_intrinsic_probe_metric import (
    affine_covariance_error,
    causal_relation_matrix,
    full_project_smeared_operator,
    open_interval_count_matrix,
    probe_coverage_diagnostics,
    profile_pca_probes,
    profile_window,
    retarded_support_shell,
    relabeling_subspace_error,
    two_sided_interior,
)
from causal_interior_support_scan import shell_counts_for_all_marks
from causal_operator_metric import (
    diamond_volume_4d,
    interval_counts_to_target,
    project_convention_row,
    smeared_bd_row,
    sprinkle_minkowski_diamond,
)


class CausalIntrinsicProbeMetricTests(unittest.TestCase):
    def setUp(self) -> None:
        self.points, self.top = sprinkle_minkowski_diamond(
            np.random.default_rng(31), 80, 1.0
        )
        self.relation = causal_relation_matrix(self.points, block_size=32)

    def test_full_operator_target_row_matches_row_oracle(self) -> None:
        ell = (diamond_volume_4d(1.0) / 80.0) ** 0.25
        scale = 0.25
        full = full_project_smeared_operator(self.relation, ell, scale)
        past, counts = interval_counts_to_target(self.points, self.top, 32)
        expected = project_convention_row(
            smeared_bd_row(past, counts, self.top, ell, scale)
        )
        np.testing.assert_allclose(full[self.top], expected)

    def test_profile_window_is_relabeling_equivariant(self) -> None:
        permutation = np.random.default_rng(7).permutation(len(self.points))
        inverse = np.argsort(permutation)
        relabeled = self.relation[np.ix_(permutation, permutation)]
        relabeled_target = int(inverse[self.top])
        weight, distance = profile_window(self.relation, self.top, 0.1, 0.4)
        new_weight, new_distance = profile_window(
            relabeled, relabeled_target, 0.1, 0.4
        )
        np.testing.assert_array_equal(new_distance[inverse], distance)
        np.testing.assert_allclose(new_weight[inverse], weight)

    def test_profile_pca_subspace_is_relabeling_equivariant(self) -> None:
        permutation = np.random.default_rng(13).permutation(len(self.points))
        inverse = np.argsort(permutation)
        relabeled = self.relation[np.ix_(permutation, permutation)]
        original = profile_pca_probes(
            self.relation, self.top, 4, 0.1, 0.5
        )
        moved = profile_pca_probes(
            relabeled, int(inverse[self.top]), 4, 0.1, 0.5
        )
        self.assertLess(
            relabeling_subspace_error(
                original.probes, moved.probes, permutation
            ),
            1.0e-8,
        )

    def test_full_operator_relabels_by_matrix_conjugation(self) -> None:
        ell = (diamond_volume_4d(1.0) / 80.0) ** 0.25
        permutation = np.random.default_rng(17).permutation(len(self.points))
        relabeled = self.relation[np.ix_(permutation, permutation)]
        original = full_project_smeared_operator(self.relation, ell, 0.25)
        moved = full_project_smeared_operator(relabeled, ell, 0.25)
        np.testing.assert_allclose(
            moved, original[np.ix_(permutation, permutation)]
        )

    def test_corrected_pairing_affine_covariance(self) -> None:
        ell = (diamond_volume_4d(1.0) / 80.0) ** 0.25
        operator = full_project_smeared_operator(self.relation, ell, 0.25)
        selection = profile_pca_probes(
            self.relation, self.top, 4, 0.1, 0.5
        )
        self.assertLess(
            affine_covariance_error(
                operator[self.top], selection.probes, self.top
            ),
            1.0e-10,
        )

    def test_two_sided_interior_and_shell_relabel(self) -> None:
        ell = (diamond_volume_4d(1.0) / 80.0) ** 0.25
        counts = open_interval_count_matrix(self.relation)
        interior = two_sided_interior(
            self.relation, counts, ell, 0.25, 0.5, 2.0, 0.25
        )
        shell = retarded_support_shell(
            self.relation,
            counts,
            interior,
            self.top,
            ell,
            0.25,
            0.5,
            4.0,
        )
        permutation = np.random.default_rng(23).permutation(len(self.points))
        inverse = np.argsort(permutation)
        moved_relation = self.relation[np.ix_(permutation, permutation)]
        moved_counts = open_interval_count_matrix(moved_relation)
        moved_interior = two_sided_interior(
            moved_relation, moved_counts, ell, 0.25, 0.5, 2.0, 0.25
        )
        moved_shell = retarded_support_shell(
            moved_relation,
            moved_counts,
            moved_interior,
            int(inverse[self.top]),
            ell,
            0.25,
            0.5,
            4.0,
        )
        np.testing.assert_array_equal(moved_interior[inverse], interior)
        np.testing.assert_array_equal(moved_shell[inverse], shell)

    def test_probe_coverage_is_bounded(self) -> None:
        ell = (diamond_volume_4d(1.0) / 80.0) ** 0.25
        counts = open_interval_count_matrix(self.relation)
        interior = two_sided_interior(
            self.relation, counts, ell, 0.25, 0.5, 2.0, 0.25
        )
        shell = retarded_support_shell(
            self.relation,
            counts,
            interior,
            self.top,
            ell,
            0.25,
            0.5,
            4.0,
        )
        operator = full_project_smeared_operator(
            self.relation, ell, 0.25, counts
        )
        probes = profile_pca_probes(
            self.relation, self.top, 4, 0.1, 0.5
        ).probes
        support, row = probe_coverage_diagnostics(
            probes,
            operator[self.top],
            self.top,
            self.relation,
            interior,
            shell,
        )
        self.assertTrue(0.0 <= support <= 1.0)
        self.assertTrue(0.0 <= row <= 1.0)

    def test_all_mark_shell_counts_match_single_mark_definition(self) -> None:
        ell = (diamond_volume_4d(1.0) / 80.0) ** 0.25
        counts = open_interval_count_matrix(self.relation)
        interior = two_sided_interior(
            self.relation, counts, ell, 0.25, 0.5, 2.0, 0.25
        )
        all_counts = shell_counts_for_all_marks(
            self.relation, counts, interior, ell, 0.25, 0.5, 4.0
        )
        expected = [
            np.count_nonzero(
                retarded_support_shell(
                    self.relation,
                    counts,
                    interior,
                    int(mark),
                    ell,
                    0.25,
                    0.5,
                    4.0,
                )
            )
            for mark in np.flatnonzero(interior)
        ]
        np.testing.assert_array_equal(all_counts, expected)


if __name__ == "__main__":
    unittest.main()
