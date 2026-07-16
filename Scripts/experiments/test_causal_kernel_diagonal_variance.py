import numpy as np

from causal_continuum_kernel_moments import CutoffProfile
from causal_kernel_diagonal_variance import (
    _field_square_angular_averages,
    continuum_diagonal_variance,
)


def test_field_square_angular_averages_use_three_dimensional_fourth_moment() -> None:
    radius_squared = np.array([0.0, 1.0, 4.0])
    cutoff = np.ones(3)
    values = _field_square_angular_averages(2.0, radius_squared, cutoff)
    assert np.allclose(values["spatial_quadratic"], radius_squared**2 / 5.0)
    assert np.allclose(
        values["temporal_spatial_cubic"],
        4.0 * radius_squared**2 / 5.0,
    )


def test_diagonal_variance_has_exact_scale_lock_and_positive_fields() -> None:
    result = continuum_diagonal_variance(
        events=20_000,
        nonlocality_ratio=0.30,
        profile=CutoffProfile("test", 0.02, 0.08),
        quadrature_order=16,
    )
    assert np.isclose(result.epsilon, result.ell_over_nonlocality**4)
    assert set(result.diagonal_variance) == {
        "constant",
        "temporal_affine",
        "temporal_quadratic",
        "spatial_quadratic",
        "temporal_cubic",
        "temporal_spatial_cubic",
    }
    assert all(value > 0.0 for value in result.diagonal_variance.values())
