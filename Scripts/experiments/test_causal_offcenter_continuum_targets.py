import numpy as np
import pytest

from causal_continuum_kernel_moments import (
    CutoffProfile,
    continuum_operator_moments,
)
from causal_offcenter_continuum_targets import (
    continuum_depth_ratio,
    offcenter_continuum_operator_moments,
    result_difference,
)


PROFILE = CutoffProfile("primary", 0.02, 0.08)


def test_continuum_depth_is_time_reversal_invariant() -> None:
    points = np.array(
        [
            [0.4, 0.1, 0.0, 0.0],
            [1.0, 0.2, 0.1, 0.0],
            [1.7, 0.1, 0.0, 0.1],
        ]
    )
    reflected = points.copy()
    reflected[:, 0] = 2.0 - reflected[:, 0]
    assert np.allclose(
        continuum_depth_ratio(points), continuum_depth_ratio(reflected)
    )


def test_center_target_matches_symmetric_quadrature() -> None:
    direct = continuum_operator_moments(0.20, PROFILE, quadrature_order=80)
    result = offcenter_continuum_operator_moments(
        np.array([1.0, 0.0, 0.0, 0.0]),
        0.20,
        PROFILE,
        retarded_time_order=32,
        proper_order=40,
        polar_order=8,
        azimuth_order=8,
    )
    assert result.signature == (1, 3, 0)
    values = result.operator_values
    assert values["constant"] == pytest.approx(
        direct.operator_values["constant"], abs=3.0e-3
    )
    assert values["affine_t"] == pytest.approx(
        direct.operator_values["temporal_affine"], abs=2.0e-3
    )
    assert max(abs(values[f"affine_{axis}"]) for axis in "xyz") < 1.0e-12
    assert values["quadratic_t_t"] == pytest.approx(
        direct.operator_values["temporal_quadratic"], abs=2.0e-3
    )
    assert values["quadratic_x_x"] == pytest.approx(
        direct.operator_values["spatial_quadratic"], abs=2.0e-3
    )


def test_higher_orders_stabilize_offcenter_target() -> None:
    pivot = np.array([1.0, 0.08, 0.0, 0.0])
    low = offcenter_continuum_operator_moments(
        pivot, 0.20, PROFILE, retarded_time_order=20, proper_order=28
    )
    high = offcenter_continuum_operator_moments(
        pivot, 0.20, PROFILE, retarded_time_order=30, proper_order=40
    )
    difference = result_difference(low, high)
    assert difference["maximum_operator_absolute"] < 0.02
    assert difference["metric_frobenius"] < 0.02


def test_invalid_pivot_is_rejected() -> None:
    with pytest.raises(ValueError):
        offcenter_continuum_operator_moments(
            np.array([0.0, 0.0, 0.0, 0.0]), 0.20, PROFILE
        )
