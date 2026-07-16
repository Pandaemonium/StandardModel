"""Weak Lorentzian geometry derived from one finite scalar operator.

This module isolates algebraic identities that any count-normalized causal
operator can be tested against before attempting pointwise connection or
curvature regression.  For a finite operator ``B`` and multiplication by a
field ``f``, the corrected product defect is

    Gamma_B(f, h) = (B(fh) - f Bh - h Bf + fh B1) / 2.

It is half of the double multiplication commutator applied to one and is
unchanged by adding a diagonal multiplication potential.  The weak Hessian and
Bakry-Emery ``Gamma2`` constructions below then use only this product defect
and the potential-free operator ``Box = B - diag(B1)``.

The array controls use the flat four-dimensional d'Alembertian with signature
(+---).  They are exact/finite numerical controls, not causal-set convergence
results and not a derivation of curvature from a bare graph.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Callable

import numpy as np


MINKOWSKI_INVERSE = np.diag([1.0, -1.0, -1.0, -1.0])


def _square_matrix(operator: np.ndarray) -> np.ndarray:
    matrix = np.asarray(operator, dtype=float)
    if matrix.ndim != 2 or matrix.shape[0] != matrix.shape[1]:
        raise ValueError("operator must be a square matrix")
    return matrix


def _field(field: np.ndarray, size: int) -> np.ndarray:
    values = np.asarray(field, dtype=float)
    if values.shape != (size,):
        raise ValueError(f"field must have shape ({size},)")
    return values


def multiplication_operator(field: np.ndarray) -> np.ndarray:
    """Return the diagonal operator for pointwise multiplication by a field."""

    values = np.asarray(field, dtype=float)
    if values.ndim != 1:
        raise ValueError("field must be one-dimensional")
    return np.diag(values)


def commutator(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    """Return the matrix commutator ``left right - right left``."""

    left_matrix = _square_matrix(left)
    right_matrix = _square_matrix(right)
    if left_matrix.shape != right_matrix.shape:
        raise ValueError("commutator operands must have the same shape")
    return left_matrix @ right_matrix - right_matrix @ left_matrix


def potential_free_operator(operator: np.ndarray) -> np.ndarray:
    """Remove the unique diagonal multiplication term that makes ``Box 1 = 0``."""

    matrix = _square_matrix(operator)
    operator_one = matrix @ np.ones(matrix.shape[0])
    return matrix - np.diag(operator_one)


def corrected_gamma_field(
    operator: np.ndarray,
    left: np.ndarray,
    right: np.ndarray,
) -> np.ndarray:
    """Evaluate the corrected product defect at every finite event."""

    matrix = _square_matrix(operator)
    size = matrix.shape[0]
    left_values = _field(left, size)
    right_values = _field(right, size)
    operator_one = matrix @ np.ones(size)
    return 0.5 * (
        matrix @ (left_values * right_values)
        - left_values * (matrix @ right_values)
        - right_values * (matrix @ left_values)
        + left_values * right_values * operator_one
    )


def double_multiplication_commutator(
    operator: np.ndarray,
    left: np.ndarray,
    right: np.ndarray,
) -> np.ndarray:
    """Return ``[[B, M_left], M_right]``."""

    matrix = _square_matrix(operator)
    size = matrix.shape[0]
    left_values = _field(left, size)
    right_values = _field(right, size)
    return commutator(
        commutator(matrix, multiplication_operator(left_values)),
        multiplication_operator(right_values),
    )


def triple_multiplication_commutator(
    operator: np.ndarray,
    first: np.ndarray,
    second: np.ndarray,
    third: np.ndarray,
) -> np.ndarray:
    """Return ``[[[B, M_first], M_second], M_third]``."""

    matrix = _square_matrix(operator)
    size = matrix.shape[0]
    first_values = _field(first, size)
    second_values = _field(second, size)
    third_values = _field(third, size)
    return commutator(
        double_multiplication_commutator(matrix, first_values, second_values),
        multiplication_operator(third_values),
    )


def double_commutator_multiplication_defect(
    operator: np.ndarray,
    left: np.ndarray,
    right: np.ndarray,
) -> float:
    """Measure failure of the double commutator to be multiplication.

    The comparison multiplication operator is fixed intrinsically by applying
    the double commutator to the constant-one field.
    """

    double = double_multiplication_commutator(operator, left, right)
    fitted = np.diag(double @ np.ones(double.shape[0]))
    denominator = max(1.0, float(np.linalg.norm(double, ord="fro")))
    return float(np.linalg.norm(double - fitted, ord="fro") / denominator)


ArrayOperator = Callable[[np.ndarray], np.ndarray]


def lorentzian_box_field(field: np.ndarray, spacing: float) -> np.ndarray:
    """Apply the centered flat (+---) d'Alembertian on a four-dimensional grid.

    Boundary entries are ``nan`` because no boundary condition is imposed.  A
    nested weak-geometry evaluation therefore needs a target at least two grid
    steps from every boundary.
    """

    values = np.asarray(field, dtype=float)
    if values.ndim != 4 or min(values.shape) < 3:
        raise ValueError("field must be a four-dimensional grid of width at least 3")
    if spacing <= 0.0:
        raise ValueError("spacing must be positive")

    result = np.full(values.shape, np.nan, dtype=float)
    center = tuple(slice(1, -1) for _ in range(4))
    second_derivatives: list[np.ndarray] = []
    for axis in range(4):
        forward = [slice(1, -1) for _ in range(4)]
        backward = [slice(1, -1) for _ in range(4)]
        forward[axis] = slice(2, None)
        backward[axis] = slice(None, -2)
        second_derivatives.append(
            (
                values[tuple(forward)]
                - 2.0 * values[center]
                + values[tuple(backward)]
            )
            / spacing**2
        )
    result[center] = second_derivatives[0] - sum(second_derivatives[1:])
    return result


def gamma_field(
    box: ArrayOperator,
    left: np.ndarray,
    right: np.ndarray,
) -> np.ndarray:
    """Evaluate ``Gamma`` from an array operator satisfying ``Box 1 = 0``."""

    left_values = np.asarray(left, dtype=float)
    right_values = np.asarray(right, dtype=float)
    if left_values.shape != right_values.shape:
        raise ValueError("Gamma fields must have the same shape")
    return 0.5 * (
        box(left_values * right_values)
        - left_values * box(right_values)
        - right_values * box(left_values)
    )


def weak_hessian_field(
    box: ArrayOperator,
    function: np.ndarray,
    first_probe: np.ndarray,
    second_probe: np.ndarray,
) -> np.ndarray:
    """Reconstruct the weak Hessian from the operator product defect."""

    function_second = gamma_field(box, function, second_probe)
    function_first = gamma_field(box, function, first_probe)
    probe_pair = gamma_field(box, first_probe, second_probe)
    return 0.5 * (
        gamma_field(box, first_probe, function_second)
        + gamma_field(box, second_probe, function_first)
        - gamma_field(box, function, probe_pair)
    )


def gamma2_field(
    box: ArrayOperator,
    left: np.ndarray,
    right: np.ndarray,
) -> np.ndarray:
    """Evaluate the polarized Bakry-Emery ``Gamma2`` field."""

    gamma = gamma_field(box, left, right)
    return 0.5 * (
        box(gamma)
        - gamma_field(box, left, box(right))
        - gamma_field(box, right, box(left))
    )


@dataclass(frozen=True)
class WeakRicciReadout:
    """Pointwise weak-geometry readout in a supplied probe basis."""

    gram: np.ndarray
    covariant_gram: np.ndarray
    hessians: np.ndarray
    gamma2: np.ndarray
    hessian_inner_products: np.ndarray
    ricci: np.ndarray
    scalar_curvature: float


def weak_ricci_readout(
    box: ArrayOperator,
    probes: np.ndarray,
    target: tuple[int, int, int, int],
) -> WeakRicciReadout:
    """Subtract the Hessian contraction from ``Gamma2`` in a probe basis.

    The probes must have a nondegenerate Lorentzian Gram matrix at the target.
    This is a readout identity on supplied fields; it does not select the probe
    algebra or establish convergence of a graph operator.
    """

    fields = np.asarray(probes, dtype=float)
    if fields.ndim != 5:
        raise ValueError("probes must have shape (probe_count, n0, n1, n2, n3)")
    if len(target) != 4:
        raise ValueError("target must have four indices")

    probe_count = fields.shape[0]
    gram = np.empty((probe_count, probe_count), dtype=float)
    gamma2 = np.empty_like(gram)
    hessians = np.empty((probe_count, probe_count, probe_count), dtype=float)

    for a in range(probe_count):
        for b in range(probe_count):
            gram[a, b] = gamma_field(box, fields[a], fields[b])[target]
            gamma2[a, b] = gamma2_field(box, fields[a], fields[b])[target]
            for c in range(probe_count):
                hessians[a, b, c] = weak_hessian_field(
                    box, fields[a], fields[b], fields[c]
                )[target]

    gram = 0.5 * (gram + gram.T)
    gamma2 = 0.5 * (gamma2 + gamma2.T)
    covariant_gram = np.linalg.inv(gram)
    hessian_inner_products = np.empty_like(gram)
    for a in range(probe_count):
        for b in range(probe_count):
            hessian_inner_products[a, b] = np.einsum(
                "ik,jl,ij,kl->",
                covariant_gram,
                covariant_gram,
                hessians[a],
                hessians[b],
            )
    ricci = gamma2 - hessian_inner_products
    ricci = 0.5 * (ricci + ricci.T)
    scalar_curvature = float(np.einsum("ab,ab->", covariant_gram, ricci))
    return WeakRicciReadout(
        gram=gram,
        covariant_gram=covariant_gram,
        hessians=hessians,
        gamma2=gamma2,
        hessian_inner_products=hessian_inner_products,
        ricci=ricci,
        scalar_curvature=scalar_curvature,
    )


def coordinate_grid(radius: int, spacing: float) -> np.ndarray:
    """Return four coordinate fields on a centered Cartesian grid."""

    if radius < 2:
        raise ValueError("radius must be at least 2 for nested operator controls")
    if spacing <= 0.0:
        raise ValueError("spacing must be positive")
    axis = np.arange(-radius, radius + 1, dtype=float) * spacing
    return np.asarray(np.meshgrid(axis, axis, axis, axis, indexing="ij"))


def quadratic_chart(coordinates: np.ndarray, quadratic_jet: np.ndarray) -> np.ndarray:
    """Apply ``y^a = u^a + Q^a_mn u^m u^n / 2`` to coordinate fields."""

    fields = np.asarray(coordinates, dtype=float)
    jet = np.asarray(quadratic_jet, dtype=float)
    if fields.ndim != 5 or fields.shape[0] != 4:
        raise ValueError("coordinates must have shape (4, n0, n1, n2, n3)")
    if jet.shape != (4, 4, 4):
        raise ValueError("quadratic jet must have shape (4, 4, 4)")
    if not np.allclose(jet, np.swapaxes(jet, 1, 2)):
        raise ValueError("quadratic jet must be symmetric in its lower indices")
    return fields + 0.5 * np.einsum("amn,m...,n...->a...", jet, fields, fields)


def expected_quadratic_chart_hessians(quadratic_jet: np.ndarray) -> np.ndarray:
    """Return the exact pivot Hessians in the gradient basis of the chart."""

    jet = np.asarray(quadratic_jet, dtype=float)
    if jet.shape != (4, 4, 4):
        raise ValueError("quadratic jet must have shape (4, 4, 4)")
    return np.einsum(
        "amn,bm,cn->abc", jet, MINKOWSKI_INVERSE, MINKOWSKI_INVERSE
    )


def run_flat_weak_geometry_control(spacings: tuple[float, ...]) -> dict[str, object]:
    """Run affine and nonlinear-coordinate controls for flat weak geometry."""

    if len(spacings) < 2 or any(step <= 0.0 for step in spacings):
        raise ValueError("at least two positive spacings are required")

    jets: dict[str, np.ndarray] = {}
    temporal = np.zeros((4, 4, 4))
    temporal[0, 0, 0] = 0.8
    jets["temporal_quadratic"] = temporal
    shear = np.zeros((4, 4, 4))
    shear[0, 1, 1] = 1.5
    jets["shear_quadratic"] = shear

    charts: dict[str, object] = {}
    for name, jet in jets.items():
        expected_hessians = expected_quadratic_chart_hessians(jet)
        samples = []
        for spacing in spacings:
            coordinates = coordinate_grid(radius=3, spacing=spacing)
            probes = quadratic_chart(coordinates, jet)
            box = lambda field, step=spacing: lorentzian_box_field(field, step)
            readout = weak_ricci_readout(box, probes, (3, 3, 3, 3))
            samples.append(
                {
                    "spacing": spacing,
                    "metric_frobenius_error": float(
                        np.linalg.norm(readout.gram - MINKOWSKI_INVERSE, ord="fro")
                    ),
                    "hessian_frobenius_error": float(
                        np.linalg.norm(readout.hessians - expected_hessians)
                    ),
                    "expected_hessian_signal": float(
                        np.linalg.norm(expected_hessians)
                    ),
                    "weak_ricci_frobenius_error": float(
                        np.linalg.norm(readout.ricci, ord="fro")
                    ),
                    "weak_scalar_curvature_error": abs(readout.scalar_curvature),
                }
            )
        charts[name] = {"samples": samples}

    affine_spacing = spacings[-1]
    affine_coordinates = coordinate_grid(radius=3, spacing=affine_spacing)
    affine_box = lambda field: lorentzian_box_field(field, affine_spacing)
    affine = weak_ricci_readout(
        affine_box, affine_coordinates, (3, 3, 3, 3)
    )
    return {
        "status": "exact algebra plus external flat numerical control; not a graph convergence proof",
        "signature": "(+---)",
        "spacings": list(spacings),
        "affine_control": {
            "spacing": affine_spacing,
            "metric_frobenius_error": float(
                np.linalg.norm(affine.gram - MINKOWSKI_INVERSE, ord="fro")
            ),
            "hessian_frobenius_error": float(np.linalg.norm(affine.hessians)),
            "weak_ricci_frobenius_error": float(
                np.linalg.norm(affine.ricci, ord="fro")
            ),
            "weak_scalar_curvature_error": abs(affine.scalar_curvature),
        },
        "quadratic_chart_controls": charts,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--spacings",
        type=float,
        nargs="+",
        default=[0.16, 0.08, 0.04],
        help="Grid spacings for the flat nonlinear-chart refinement control.",
    )
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_flat_weak_geometry_control(tuple(args.spacings))
    rendered = json.dumps(result, indent=2) + "\n"
    if args.output is None:
        print(rendered, end="")
    else:
        args.output.write_text(rendered, encoding="utf-8", newline="\n")


if __name__ == "__main__":
    main()
