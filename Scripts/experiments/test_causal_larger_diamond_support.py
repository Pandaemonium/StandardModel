"""Tests for the fixed-density larger-diamond support control."""

from __future__ import annotations

import argparse
import unittest

import numpy as np

from causal_adjacent_scale_availability import (
    adjacent_scale_support,
    sparse_adjacent_scale_support,
    sparse_inclusive_interval_count_matrix,
)
from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    open_interval_count_matrix,
)
from causal_larger_diamond_support import fixed_density_geometry, run_scan
from causal_operator_metric import (
    diamond_volume_4d,
    sprinkle_minkowski_diamond,
)


class CausalLargerDiamondSupportTests(unittest.TestCase):
    def test_integer_volume_ladder_preserves_ell(self) -> None:
        geometries = [
            fixed_density_geometry(1200, 1.0, multiplier)
            for multiplier in (1, 2, 4)
        ]
        self.assertEqual([value[0] for value in geometries], [1200, 2400, 4800])
        reference_ell = geometries[0][2]
        for _, _, ell in geometries:
            self.assertAlmostEqual(ell, reference_ell, places=14)

    def test_nonpositive_volume_multiplier_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "positive integer"):
            fixed_density_geometry(1200, 1.0, 0)

    def test_sparse_support_matches_dense_sprinkled_partial_order(self) -> None:
        random_events = 80
        points, _ = sprinkle_minkowski_diamond(
            np.random.default_rng(107), random_events, 1.0
        )
        relation = causal_relation_matrix(points, block_size=32)
        dense_counts = open_interval_count_matrix(relation)
        ell = (diamond_volume_4d(1.0) / random_events) ** 0.25
        dense_result = adjacent_scale_support(
            relation,
            dense_counts,
            ell,
            operator_scale=0.4,
            adjacent_ratio=1.2,
        )
        sparse_result = sparse_adjacent_scale_support(
            sparse_inclusive_interval_count_matrix(relation),
            ell,
            operator_scale=0.4,
            adjacent_ratio=1.2,
        )
        for sparse_interior, dense_interior in zip(
            sparse_result[1], dense_result[1], strict=True
        ):
            np.testing.assert_array_equal(sparse_interior, dense_interior)
        for sparse_value, dense_value in zip(
            sparse_result[2:], dense_result[2:], strict=True
        ):
            np.testing.assert_array_equal(sparse_value, dense_value)

    def test_small_scan_records_order_only_fixed_scale_contract(self) -> None:
        args = argparse.Namespace(
            reference_events=40,
            reference_duration=1.0,
            volume_multipliers=[1],
            realizations=1,
            nonlocality_scale=0.5,
            adjacent_ratio=1.2,
            minimum_shell_count=4,
            minimum_availability_rate=0.8,
            block_size=32,
            seed=191,
        )
        result = run_scan(args)
        self.assertFalse(result["embedding_coordinates_used_after_sprinkling"])
        self.assertTrue(result["frozen_local_scales_across_volume_ladder"])
        self.assertEqual(result["results"][0]["events"], 40)
        self.assertEqual(result["results"][0]["realizations_evaluated"], 1)


if __name__ == "__main__":
    unittest.main()
