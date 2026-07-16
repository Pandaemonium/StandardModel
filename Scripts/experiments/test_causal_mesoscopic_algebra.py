"""Tests for the Stage A39 mesoscopic-algebra audit."""

from __future__ import annotations

import numpy as np

from causal_mesoscopic_algebra import (
    degree_two_generator_algebra,
    evaluate_algebra,
    gl_envelope_projector_error,
    order_depth_region,
)


def test_order_depth_region_is_relabeling_covariant_with_ties() -> None:
    relation = np.zeros((8, 8), dtype=bool)
    for left in range(8):
        for right in range(left + 1, 8):
            relation[left, right] = True
    mask = order_depth_region(relation, retained_fraction=0.25, minimum_events=2)
    permutation = np.array([3, 0, 7, 2, 5, 1, 6, 4])
    relabeled = relation[np.ix_(permutation, permutation)]
    relabeled_mask = order_depth_region(
        relabeled, retained_fraction=0.25, minimum_events=2
    )
    assert np.array_equal(relabeled_mask[np.argsort(permutation)], mask)


def test_degree_two_envelope_has_rank_15_and_gl_invariant_projector() -> None:
    rng = np.random.default_rng(20260715)
    coordinates = rng.normal(size=(80, 4))
    mask = np.ones(80, dtype=bool)
    algebra = degree_two_generator_algebra(coordinates, mask)

    assert algebra.generator_rank == 4
    assert algebra.envelope_rank == 15
    assert gl_envelope_projector_error(coordinates, mask, algebra) < 1.0e-12


def test_generator_products_close_exactly_in_degree_two_envelope() -> None:
    rng = np.random.default_rng(20260716)
    coordinates = rng.normal(size=(70, 4))
    mask = np.ones(70, dtype=bool)
    algebra = degree_two_generator_algebra(coordinates, mask)
    products = np.column_stack(
        [
            algebra.generator_basis[:, left] * algebra.generator_basis[:, right]
            for left in range(4)
            for right in range(left, 4)
        ]
    )
    restricted = algebra.envelope_basis[mask]
    fitted = restricted @ (restricted.T @ products[mask])
    assert np.linalg.norm(products[mask] - fitted) < 1.0e-12


def test_multiplication_operator_has_zero_operator_geometry() -> None:
    rng = np.random.default_rng(20260717)
    coordinates = rng.normal(size=(60, 4))
    potential = rng.normal(size=60)
    operator = np.diag(potential)
    mask = np.ones(60, dtype=bool)

    diagnostics = evaluate_algebra("control", coordinates, operator, mask)

    assert diagnostics.envelope_rank == 15
    assert diagnostics.operator_closure_defect == 0.0
    assert diagnostics.gamma_closure_defect == 0.0
    assert diagnostics.double_multiplication_defect == 0.0
    assert diagnostics.triple_commutator_defect == 0.0
