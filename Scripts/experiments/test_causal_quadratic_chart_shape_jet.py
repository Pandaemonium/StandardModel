"""Tests for Stage A33 exact nonlinear-chart shape-jet controls."""

from __future__ import annotations

import numpy as np

from causal_operator_metric import MINKOWSKI_INVERSE
from causal_quadratic_chart_shape_jet import (
    quadratic_chart_coordinates,
    quadratic_chart_jacobian,
    quadratic_chart_target_connection,
    quadratic_chart_target_factor_gradient,
    quadratic_chart_target_metric_first_jet,
    select_spread_local_targets,
    target_unit_shape_jet,
)
from causal_spread_levi_civita_connection import (
    levi_civita_connection_from_inverse_metric,
)


def test_quadratic_chart_has_identity_pivot_jacobian() -> None:
    pivot = np.array([0.7, 0.0, 0.0, 0.0])
    coefficients = np.zeros((4, 4, 4))
    coefficients[0, 1, 1] = 1.5
    np.testing.assert_allclose(
        quadratic_chart_jacobian(pivot, pivot, coefficients), np.eye(4)
    )
    mapped = quadratic_chart_coordinates(
        np.array([pivot, pivot + np.array([0.0, 0.2, 0.0, 0.0])]),
        pivot,
        coefficients,
    )
    np.testing.assert_allclose(mapped[0], np.zeros(4))
    np.testing.assert_allclose(mapped[1], [0.03, 0.2, 0.0, 0.0])


def test_exact_metric_jet_matches_jacobian_finite_difference() -> None:
    pivot = np.array([0.7, 0.0, 0.0, 0.0])
    coefficients = np.zeros((4, 4, 4))
    coefficients[0, 0, 0] = 0.8
    expected = quadratic_chart_target_metric_first_jet(coefficients)[0]
    step = 1.0e-6
    plus = pivot + np.array([step, 0.0, 0.0, 0.0])
    minus = pivot - np.array([step, 0.0, 0.0, 0.0])
    j_plus = quadratic_chart_jacobian(plus, pivot, coefficients)
    j_minus = quadratic_chart_jacobian(minus, pivot, coefficients)
    finite_difference = (
        j_plus @ MINKOWSKI_INVERSE @ j_plus.T
        - j_minus @ MINKOWSKI_INVERSE @ j_minus.T
    ) / (2.0 * step)
    np.testing.assert_allclose(finite_difference, expected, atol=1.0e-9)


def test_zero_chart_has_zero_shape_jet_and_shear_is_nonzero() -> None:
    zero_shape, zero_jet = target_unit_shape_jet(np.zeros((4, 4, 4)))
    np.testing.assert_allclose(zero_shape, MINKOWSKI_INVERSE)
    np.testing.assert_allclose(zero_jet, np.zeros((4, 4, 4)))
    shear = np.zeros((4, 4, 4))
    shear[0, 1, 1] = 1.5
    _, shear_jet = target_unit_shape_jet(shear)
    assert np.linalg.norm(shear_jet) > 0.0


def test_exact_factor_jet_and_connection_complete_metric_decomposition() -> None:
    coefficients = np.zeros((4, 4, 4))
    coefficients[0, 0, 0] = 0.8
    metric_jet = quadratic_chart_target_metric_first_jet(coefficients)
    shape, shape_jet = target_unit_shape_jet(coefficients)
    factor_jet = quadratic_chart_target_factor_gradient(coefficients)
    reconstructed_jet = np.array(
        [
            factor_jet[derivative] * shape + shape_jet[derivative]
            for derivative in range(4)
        ]
    )
    np.testing.assert_allclose(factor_jet, [0.4, 0.0, 0.0, 0.0])
    np.testing.assert_allclose(reconstructed_jet, metric_jet)
    connection, _, _ = levi_civita_connection_from_inverse_metric(
        MINKOWSKI_INVERSE, metric_jet
    )
    np.testing.assert_allclose(
        connection, quadratic_chart_target_connection(coefficients)
    )


def test_shear_chart_has_nonzero_connection_and_zero_factor_jet() -> None:
    coefficients = np.zeros((4, 4, 4))
    coefficients[0, 1, 1] = 1.5
    np.testing.assert_allclose(
        quadratic_chart_target_factor_gradient(coefficients), np.zeros(4)
    )
    target = quadratic_chart_target_connection(coefficients)
    assert target[0, 1, 1] == -1.5


def test_spread_selector_uses_the_available_radius() -> None:
    points = np.array(
        [[0.0, 0.0, 0.0, 0.0]]
        + [[value, 0.0, 0.0, 0.0] for value in np.linspace(0.01, 1.0, 100)]
    )
    selected = select_spread_local_targets(points, 0, 1.0, 8)
    nearest = np.arange(8)
    assert 0 in selected
    assert np.max(points[selected, 0]) > np.max(points[nearest, 0])
