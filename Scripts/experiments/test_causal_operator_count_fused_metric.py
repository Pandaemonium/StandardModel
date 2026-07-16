"""Tests for Stage A25 operator-shape/count-scale fusion."""

from __future__ import annotations

import unittest

import numpy as np

from causal_fused_operator_count_metric import fuse_metric_and_first_jet
from causal_operator_metric import MINKOWSKI_INVERSE


class CausalOperatorCountFusedMetricTests(unittest.TestCase):
    def test_constant_operator_bias_is_removed_from_metric_and_jet(self) -> None:
        factor = 0.81
        gradient = np.array([-0.18, 0.0, 0.0, 0.0])
        bias = 0.6
        operator_metric = bias * factor * MINKOWSKI_INVERSE
        operator_jet = np.array(
            [bias * derivative * MINKOWSKI_INVERSE for derivative in gradient]
        )
        fused, fused_jet, shape, volume_scale = fuse_metric_and_first_jet(
            operator_metric, operator_jet, factor, gradient
        )
        self.assertAlmostEqual(volume_scale, bias * factor)
        np.testing.assert_allclose(shape, MINKOWSKI_INVERSE)
        np.testing.assert_allclose(fused, factor * MINKOWSKI_INVERSE)
        np.testing.assert_allclose(
            fused_jet,
            np.array(
                [derivative * MINKOWSKI_INVERSE for derivative in gradient]
            ),
            atol=1.0e-12,
        )

    def test_nonpositive_operator_projection_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "signature"):
            fuse_metric_and_first_jet(
                -MINKOWSKI_INVERSE,
                np.zeros((4, 4, 4)),
                1.0,
                np.zeros(4),
            )

    def test_audit_fusion_can_retain_non_lorentzian_failure(self) -> None:
        fused, _, _, _ = fuse_metric_and_first_jet(
            np.eye(4),
            np.zeros((4, 4, 4)),
            1.0,
            np.zeros(4),
            require_lorentzian=False,
        )
        np.testing.assert_allclose(fused, np.eye(4))


if __name__ == "__main__":
    unittest.main()
