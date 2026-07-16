"""Tests for Stage A36 Levi-Civita reconstruction from inverse-metric jets."""

from __future__ import annotations

import numpy as np

from causal_spread_levi_civita_connection import (
    connection_metric_compatibility_residual,
    connection_torsion_residual,
    covariant_metric_and_first_jet,
    levi_civita_connection_from_inverse_metric,
)


def test_inverse_metric_first_jet_matches_finite_difference() -> None:
    inverse_metric = np.diag([1.2, -0.8, -0.9, -1.1])
    derivative = np.diag([0.2, -0.1, 0.03, -0.05])
    inverse_jet = np.zeros((4, 4, 4))
    inverse_jet[0] = derivative
    metric, metric_jet = covariant_metric_and_first_jet(
        inverse_metric, inverse_jet
    )
    step = 1.0e-6
    finite_difference = (
        np.linalg.inv(inverse_metric + step * derivative)
        - np.linalg.inv(inverse_metric - step * derivative)
    ) / (2.0 * step)
    np.testing.assert_allclose(metric, np.linalg.inv(inverse_metric))
    np.testing.assert_allclose(metric_jet[0], finite_difference, atol=1.0e-9)


def test_constructed_connection_is_torsion_free_and_metric_compatible() -> None:
    inverse_metric = np.diag([1.2, -0.8, -0.9, -1.1])
    rng = np.random.default_rng(36)
    inverse_jet = rng.normal(scale=0.05, size=(4, 4, 4))
    inverse_jet = 0.5 * (inverse_jet + np.swapaxes(inverse_jet, 1, 2))
    connection, metric, metric_jet = levi_civita_connection_from_inverse_metric(
        inverse_metric, inverse_jet
    )
    assert connection_torsion_residual(connection) < 1.0e-12
    assert (
        connection_metric_compatibility_residual(connection, metric, metric_jet)
        < 1.0e-12
    )


def test_connection_transforms_under_constant_affine_chart_change() -> None:
    inverse_metric = np.diag([1.2, -0.8, -0.9, -1.1])
    rng = np.random.default_rng(37)
    inverse_jet = rng.normal(scale=0.03, size=(4, 4, 4))
    inverse_jet = 0.5 * (inverse_jet + np.swapaxes(inverse_jet, 1, 2))
    linear = np.array(
        [
            [1.1, 0.1, 0.0, 0.0],
            [0.2, 0.9, 0.1, 0.0],
            [0.0, 0.1, 1.2, 0.1],
            [0.0, 0.0, 0.1, 0.8],
        ]
    )
    inverse_linear = np.linalg.inv(linear)
    connection, _, _ = levi_civita_connection_from_inverse_metric(
        inverse_metric, inverse_jet
    )
    transformed_metric = linear @ inverse_metric @ linear.T
    transformed_jet = np.array(
        [
            sum(
                inverse_linear[old, derivative]
                * (linear @ inverse_jet[old] @ linear.T)
                for old in range(4)
            )
            for derivative in range(4)
        ]
    )
    transformed, _, _ = levi_civita_connection_from_inverse_metric(
        transformed_metric, transformed_jet
    )
    expected = np.einsum(
        "ar,mb,nc,rmn->abc",
        linear,
        inverse_linear,
        inverse_linear,
        connection,
    )
    np.testing.assert_allclose(transformed, expected, atol=1.0e-10)
