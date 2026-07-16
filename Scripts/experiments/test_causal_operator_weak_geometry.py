"""Tests for the one-operator weak-geometry controls."""

from __future__ import annotations

import numpy as np

from causal_operator_weak_geometry import (
    MINKOWSKI_INVERSE,
    corrected_gamma_field,
    coordinate_grid,
    double_multiplication_commutator,
    expected_quadratic_chart_hessians,
    lorentzian_box_field,
    potential_free_operator,
    quadratic_chart,
    triple_multiplication_commutator,
    weak_ricci_readout,
)


def test_corrected_gamma_is_double_commutator_on_one() -> None:
    rng = np.random.default_rng(20260715)
    operator = rng.normal(size=(7, 7))
    left = rng.normal(size=7)
    right = rng.normal(size=7)

    double = double_multiplication_commutator(operator, left, right)
    gamma = corrected_gamma_field(operator, left, right)

    assert np.allclose(double @ np.ones(7), 2.0 * gamma)


def test_potential_does_not_change_operator_geometry() -> None:
    rng = np.random.default_rng(20260716)
    operator = rng.normal(size=(6, 6))
    potential = rng.normal(size=6)
    first = rng.normal(size=6)
    second = rng.normal(size=6)
    third = rng.normal(size=6)
    shifted = operator + np.diag(potential)

    assert np.allclose(
        corrected_gamma_field(shifted, first, second),
        corrected_gamma_field(operator, first, second),
    )
    assert np.allclose(
        double_multiplication_commutator(shifted, first, second),
        double_multiplication_commutator(operator, first, second),
    )
    assert np.allclose(
        triple_multiplication_commutator(shifted, first, second, third),
        triple_multiplication_commutator(operator, first, second, third),
    )
    assert np.allclose(
        potential_free_operator(shifted), potential_free_operator(operator)
    )
    assert np.allclose(potential_free_operator(operator) @ np.ones(6), 0.0)


def test_affine_flat_weak_geometry_is_minkowski_and_ricci_flat() -> None:
    spacing = 0.1
    coordinates = coordinate_grid(radius=3, spacing=spacing)
    target = (3, 3, 3, 3)
    box = lambda field: lorentzian_box_field(field, spacing)

    readout = weak_ricci_readout(box, coordinates, target)

    assert np.allclose(readout.gram, MINKOWSKI_INVERSE, atol=1.0e-12)
    assert np.allclose(readout.hessians, 0.0, atol=1.0e-11)
    assert np.allclose(readout.gamma2, 0.0, atol=1.0e-10)
    assert np.allclose(readout.ricci, 0.0, atol=1.0e-10)
    assert abs(readout.scalar_curvature) < 1.0e-10


def test_quadratic_charts_have_connection_signal_but_zero_weak_ricci() -> None:
    quadratic_jets = []

    temporal = np.zeros((4, 4, 4))
    temporal[0, 0, 0] = 0.8
    quadratic_jets.append(temporal)

    shear = np.zeros((4, 4, 4))
    shear[0, 1, 1] = 1.5
    quadratic_jets.append(shear)

    for jet in quadratic_jets:
        expected_hessians = expected_quadratic_chart_hessians(jet)
        errors = []
        assert np.linalg.norm(expected_hessians) > 0.0

        for spacing in (0.08, 0.04):
            coordinates = coordinate_grid(radius=3, spacing=spacing)
            chart = quadratic_chart(coordinates, jet)
            target = (3, 3, 3, 3)
            box = lambda field, step=spacing: lorentzian_box_field(field, step)
            readout = weak_ricci_readout(box, chart, target)
            errors.append(
                (
                    np.linalg.norm(readout.gram - MINKOWSKI_INVERSE, ord="fro"),
                    np.linalg.norm(readout.hessians - expected_hessians),
                    np.linalg.norm(readout.ricci, ord="fro"),
                )
            )

        coarse_metric, coarse_hessian, coarse_ricci = errors[0]
        fine_metric, fine_hessian, fine_ricci = errors[1]
        assert fine_metric < 0.26 * coarse_metric
        assert fine_hessian < 0.26 * coarse_hessian
        assert fine_ricci < max(1.0e-10, 0.1 * coarse_ricci)
