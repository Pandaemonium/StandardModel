"""Tests for the Stage A40 projected weak calculus."""

from __future__ import annotations

import numpy as np

from causal_mesoscopic_algebra import degree_two_generator_algebra
from causal_projected_weak_geometry import (
    deepest_event_orbit,
    project_fields,
    projected_commutator_defects,
    projected_weak_readout,
    quadratic_coordinate_chart,
)


def flat_lorentzian_stencil(width: int, spacing: float) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    axis = np.arange(-(width // 2), width // 2 + 1) * spacing
    coordinates = np.asarray(
        np.meshgrid(axis, axis, axis, axis, indexing="ij")
    ).reshape(4, -1).T
    event_count = len(coordinates)
    operator = np.zeros((event_count, event_count))
    mask = np.zeros(event_count, dtype=bool)

    def index(position: list[int]) -> int:
        value = position[0]
        for coordinate in position[1:]:
            value = value * width + coordinate
        return value

    signs = (1.0, -1.0, -1.0, -1.0)
    for position_tuple in np.ndindex(*(width - 2 for _ in range(4))):
        position = [coordinate + 1 for coordinate in position_tuple]
        row = index(position)
        mask[row] = True
        for direction, sign in enumerate(signs):
            operator[row, row] += -2.0 * sign / spacing**2
            for displacement in (-1, 1):
                neighbor = position.copy()
                neighbor[direction] += displacement
                operator[row, index(neighbor)] += sign / spacing**2
    orbit = np.zeros(event_count, dtype=bool)
    orbit[index([width // 2] * 4)] = True
    return coordinates, operator, mask, orbit


def test_deepest_event_orbit_is_relabeling_covariant() -> None:
    relation = np.zeros((9, 9), dtype=bool)
    for left in range(9):
        for right in range(left + 1, 9):
            relation[left, right] = True
    mask = np.ones(9, dtype=bool)
    orbit = deepest_event_orbit(relation, mask)
    permutation = np.array([4, 0, 8, 2, 6, 1, 7, 3, 5])
    relabeled = relation[np.ix_(permutation, permutation)]
    relabeled_orbit = deepest_event_orbit(relabeled, mask[permutation])
    assert np.array_equal(relabeled_orbit[np.argsort(permutation)], orbit)


def test_projection_is_idempotent_on_degree_two_envelope() -> None:
    rng = np.random.default_rng(20260718)
    coordinates = rng.normal(size=(70, 4))
    mask = np.ones(70, dtype=bool)
    algebra = degree_two_generator_algebra(coordinates, mask)
    fields = algebra.envelope_basis @ rng.normal(size=(15, 5))
    assert np.allclose(project_fields(algebra, fields, mask), fields)


def test_quadratic_chart_has_expected_shape() -> None:
    coordinates = np.array([[0.2, -0.3, 0.1, 0.4]])
    jet = np.zeros((4, 4, 4))
    jet[0, 1, 1] = 1.5
    chart = quadratic_coordinate_chart(coordinates, jet)
    assert np.allclose(chart[0, 0], 0.2 + 0.75 * 0.3**2)
    assert np.allclose(chart[0, 1:], coordinates[0, 1:])


def test_pure_multiplication_has_zero_projected_geometry() -> None:
    rng = np.random.default_rng(20260719)
    coordinates = rng.normal(size=(60, 4))
    mask = np.ones(60, dtype=bool)
    orbit = np.zeros(60, dtype=bool)
    orbit[0] = True
    algebra = degree_two_generator_algebra(coordinates, mask)
    operator = np.diag(rng.normal(size=60))
    box = np.zeros_like(operator)

    double, triple = projected_commutator_defects(box, algebra, mask)
    readout = projected_weak_readout(operator, algebra, mask, orbit)

    assert double == 0.0
    assert triple == 0.0
    assert readout["hessian_norm"] == 0.0
    assert readout["gamma2_norm"] == 0.0
    assert readout["ricci_norm"] is None


def test_projected_quadratic_flat_charts_cancel_weak_ricci() -> None:
    coordinates, operator, mask, orbit = flat_lorentzian_stencil(5, 0.1)
    cases = [((0, 0, 0), 0.8, 1.0e-9), ((0, 1, 1), 1.5, 1.0e-4)]

    for index, value, tolerance in cases:
        jet = np.zeros((4, 4, 4))
        jet[index] = value
        chart = quadratic_coordinate_chart(coordinates, jet)
        algebra = degree_two_generator_algebra(chart, mask)
        readout = projected_weak_readout(operator, algebra, mask, orbit)

        assert readout["metric_signature"] == (1, 3, 0)
        assert readout["hessian_norm"] > 1.0
        assert readout["ricci_cancellation_residual"] < tolerance
