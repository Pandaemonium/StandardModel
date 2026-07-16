"""Tests for Stage A32 rowwise corrected shape regression."""

from __future__ import annotations

import numpy as np

from causal_operator_metric import MINKOWSKI_INVERSE
from causal_rowwise_shape_first_jet import corrected_unit_volume_shapes


def test_conformal_rows_normalize_to_one_constant_shape() -> None:
    factors = np.array([0.7, 0.9, 1.1, 1.4, 1.8])
    pairings = np.array([factor * MINKOWSKI_INVERSE for factor in factors])
    moments = np.tile(np.array([-0.3, 0.0, 0.0, 0.0]), (len(factors), 1))
    shapes, retained = corrected_unit_volume_shapes(pairings, moments, 1.0)
    np.testing.assert_array_equal(retained, np.arange(len(factors)))
    np.testing.assert_allclose(
        shapes,
        np.tile(MINKOWSKI_INVERSE, (len(factors), 1, 1)),
        atol=1.0e-12,
    )


def test_row_filter_rejects_non_lorentzian_pairing() -> None:
    pairings = np.array([MINKOWSKI_INVERSE, np.eye(4)])
    moments = np.array(
        [[-0.3, 0.0, 0.0, 0.0], [-0.3, 0.0, 0.0, 0.0]]
    )
    shapes, retained = corrected_unit_volume_shapes(pairings, moments, 0.6)
    assert len(shapes) == 1
    np.testing.assert_array_equal(retained, np.array([0]))


def test_rowwise_shape_is_covariant_for_unit_determinant_probe_change() -> None:
    pairings = np.array(
        [
            np.diag([1.8, -0.8, -0.9, -1.1]),
            np.diag([2.0, -0.9, -1.0, -1.2]),
        ]
    )
    moments = np.array(
        [[-0.3, 0.02, -0.01, 0.0], [-0.35, 0.01, 0.0, -0.01]]
    )
    linear = np.array(
        [
            [1.0, 0.2, 0.0, 0.0],
            [0.0, 1.0, 0.1, 0.0],
            [0.0, 0.0, 1.0, 0.1],
            [0.0, 0.0, 0.0, 1.0],
        ]
    )
    shapes, retained = corrected_unit_volume_shapes(pairings, moments, 0.6)
    transformed_shapes, transformed_retained = corrected_unit_volume_shapes(
        np.array([linear @ metric @ linear.T for metric in pairings]),
        np.array([linear @ moment for moment in moments]),
        0.6,
    )
    np.testing.assert_array_equal(transformed_retained, retained)
    np.testing.assert_allclose(
        transformed_shapes,
        np.array([linear @ shape @ linear.T for shape in shapes]),
        atol=1.0e-10,
    )
