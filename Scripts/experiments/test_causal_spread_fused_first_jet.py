"""Tests for Stage A35 spread-row fused first jets."""

from __future__ import annotations

import numpy as np

from causal_operator_metric import MINKOWSKI_INVERSE
from causal_spread_fused_first_jet import compose_fused_first_jet


def test_zero_shape_jet_leaves_only_scale_derivative() -> None:
    factor = 0.8
    gradient = np.array([-0.2, 0.03, 0.0, -0.01])
    metric, jet = compose_fused_first_jet(
        MINKOWSKI_INVERSE,
        np.zeros((4, 4, 4)),
        factor,
        gradient,
        0.2,
    )
    np.testing.assert_allclose(metric, factor * MINKOWSKI_INVERSE)
    np.testing.assert_allclose(
        jet,
        np.array([value * MINKOWSKI_INVERSE for value in gradient]),
    )


def test_tangent_weight_scales_only_shape_derivative() -> None:
    shape_jet = np.arange(64, dtype=float).reshape(4, 4, 4) / 100.0
    _, raw = compose_fused_first_jet(
        MINKOWSKI_INVERSE, shape_jet, 0.9, np.zeros(4), 1.0
    )
    _, weighted = compose_fused_first_jet(
        MINKOWSKI_INVERSE, shape_jet, 0.9, np.zeros(4), 0.2
    )
    np.testing.assert_allclose(weighted, 0.2 * raw)
