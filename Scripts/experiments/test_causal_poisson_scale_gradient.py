"""Tests for Stage A31 Poisson-calibrated count-volume gradients."""

from __future__ import annotations

import numpy as np

from causal_poisson_scale_gradient import fit_penalized_poisson_factor_field


def test_unpenalized_poisson_fit_recovers_exact_log_linear_field() -> None:
    rng = np.random.default_rng(31)
    offsets = rng.normal(scale=0.15, size=(180, 4))
    log_gradient = np.array([0.7, -0.2, 0.1, 0.3])
    log_density_at_pivot = 0.18
    exposure = 60.0
    counts = exposure * np.exp(log_density_at_pivot + offsets @ log_gradient)
    fit = fit_penalized_poisson_factor_field(offsets, counts, exposure, 0.0)
    expected_factor = np.exp(-0.5 * log_density_at_pivot)
    np.testing.assert_allclose(fit.factor, expected_factor, atol=1.0e-10)
    np.testing.assert_allclose(
        fit.factor_gradient,
        -0.5 * expected_factor * log_gradient,
        atol=1.0e-10,
    )


def test_scatter_penalty_is_affine_coordinate_covariant() -> None:
    rng = np.random.default_rng(32)
    offsets = rng.normal(scale=0.12, size=(220, 4))
    counts = rng.poisson(45.0 * np.exp(offsets @ np.array([0.8, 0.2, -0.3, 0.1])))
    linear = np.array(
        [
            [1.1, 0.2, 0.0, 0.0],
            [0.1, 0.9, 0.1, 0.0],
            [0.0, 0.2, 1.2, 0.1],
            [0.0, 0.0, 0.1, 0.8],
        ]
    )
    fit = fit_penalized_poisson_factor_field(offsets, counts, 45.0, 1.0)
    transformed = fit_penalized_poisson_factor_field(
        offsets @ linear.T, counts, 45.0, 1.0
    )
    np.testing.assert_allclose(transformed.factor, fit.factor, atol=1.0e-10)
    np.testing.assert_allclose(
        transformed.factor_gradient,
        np.linalg.inv(linear).T @ fit.factor_gradient,
        atol=1.0e-9,
    )


def test_penalty_suppresses_zero_gradient_poisson_noise() -> None:
    rng = np.random.default_rng(33)
    offsets = rng.normal(scale=0.14, size=(128, 4))
    counts = rng.poisson(35.0, size=len(offsets))
    raw = fit_penalized_poisson_factor_field(offsets, counts, 35.0, 0.0)
    regularized = fit_penalized_poisson_factor_field(
        offsets, counts, 35.0, 3.0
    )
    assert np.linalg.norm(regularized.factor_gradient) < np.linalg.norm(
        raw.factor_gradient
    )
