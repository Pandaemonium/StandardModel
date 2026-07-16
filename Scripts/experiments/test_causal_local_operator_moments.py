import numpy as np
import pytest

from causal_local_operator_moments import (
    asymmetric_negative_control,
    audit_stencil,
    ideal_moment_stencil,
    local_responses,
    polynomial_fields,
    run_audit,
)


@pytest.mark.parametrize("spatial_dimension", [1, 2, 3])
def test_ideal_stencil_recovers_project_quadratics(spatial_dimension: int) -> None:
    audit = audit_stencil(
        ideal_moment_stencil(spatial_dimension, 243.0 / 29.0, 0.2)
    )
    assert audit["max_absolute_response_error"] < 1.0e-12
    assert np.allclose(
        audit["metric_diagonal"],
        [1.0] + [-1.0] * spatial_dimension,
        atol=1.0e-12,
    )


def test_source_and_project_signs_are_opposite() -> None:
    stencil = ideal_moment_stencil(3, 243.0 / 29.0, 0.2)
    field = polynomial_fields(3)["temporal_quadratic"]
    _, _, source, project = local_responses(stencil, field)
    assert source == pytest.approx(-2.0)
    assert project == pytest.approx(2.0)


def test_hyperboloid_moments_are_exact() -> None:
    audit = audit_stencil(ideal_moment_stencil(3, 243.0 / 29.0, 0.2))
    diagnostics = audit["moment_diagnostics"]
    assert diagnostics["max_absolute_first_moment"] < 1.0e-12
    assert diagnostics["max_absolute_second_moment_error"] < 1.0e-12
    assert diagnostics["max_absolute_proper_time_squared_error"] < 1.0e-12


def test_asymmetry_exposes_affine_leakage() -> None:
    stencil = ideal_moment_stencil(3, 243.0 / 29.0, 0.2)
    assert abs(asymmetric_negative_control(stencil)) > 1.0e-3


def test_a44a_audit_passes() -> None:
    assert run_audit()["passes"]


@pytest.mark.parametrize(
    ("spatial_dimension", "balance", "scale"),
    [(0, 1.0, 1.0), (1, 0.0, 1.0), (1, 1.0, 0.0)],
)
def test_invalid_stencil_parameters_rejected(
    spatial_dimension: int, balance: float, scale: float
) -> None:
    with pytest.raises(ValueError):
        ideal_moment_stencil(spatial_dimension, balance, scale)
