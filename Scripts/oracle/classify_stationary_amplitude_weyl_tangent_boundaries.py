"""Exact oracle for the omitted stationary-Weyl tangent-chart boundaries.

This script reproduces the matrices in
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean` using exact
SymPy rational arithmetic.  The ordinary tangent-half-angle chart omits a
phase equal to `-1`.  We stratify that omitted set into three open faces,
three open edges, and the all-`-1` corner, derive the exact Pauli-vector
numerators on each chart, and compute reduced Groebner bases.

The output is an external algebra oracle, not a Lean proof.  Its purpose is to
provide exact theorem statements and reproducible polynomial certificates for
a later kernel-checked classification.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations

import sympy as sp


I = sp.I
R = sp.Rational
ONE = sp.eye(2)

SIGMA_X = sp.Matrix([[0, 1], [1, 0]])
SIGMA_Y = sp.Matrix([[0, -I], [I, 0]])
SIGMA_Z = sp.Matrix([[1, 0], [0, -1]])
PAULI = (SIGMA_X, SIGMA_Y, SIGMA_Z)

PX = sp.Matrix([[R(9, 10), R(3, 10)], [R(3, 10), R(1, 10)]])
QX = sp.Matrix([[R(1, 10), R(3, 10)], [R(3, 10), R(9, 10)]])
PY = sp.Matrix([[R(9, 10), -R(3, 10) * I], [R(3, 10) * I, R(1, 10)]])
QY = sp.Matrix([[R(1, 10), -R(3, 10) * I], [R(3, 10) * I, R(9, 10)]])
PZ = sp.Matrix([[R(4, 5), R(2, 5)], [R(2, 5), R(1, 5)]])
QZ = sp.Matrix([[R(4, 5), -R(2, 5)], [-R(2, 5), R(1, 5)]])

AXES = (
    ("x", PX, QX),
    ("y", PY, QY),
    ("z", PZ, QZ),
)

TX, TY, TZ = sp.symbols("tx ty tz", real=True)
TANGENT_VARIABLES = (TX, TY, TZ)


def stationary_axis(
    cosine: sp.Expr,
    sine: sp.Expr,
    p: sp.Matrix,
    q: sp.Matrix,
) -> sp.Matrix:
    """The exact live stationaryWalk symbol at `z = cosine + i*sine`."""

    z = cosine + I * sine
    zbar = cosine - I * sine
    gamma_plus = p * q
    gamma_zero = p * (ONE - q) + (ONE - p) * q
    gamma_minus = (ONE - p) * (ONE - q)
    return (z * gamma_plus + gamma_zero + zbar * gamma_minus).applyfunc(sp.expand)


def half_angle(tangent: sp.Symbol) -> tuple[sp.Expr, sp.Expr]:
    """Return `(cos q, sin q)` for `tangent = tan(q/2)`."""

    denominator = 1 + tangent**2
    return (1 - tangent**2) / denominator, 2 * tangent / denominator


def pauli_coefficients(matrix: sp.Matrix) -> tuple[sp.Expr, ...]:
    """Write an SU(2)-shaped matrix as `u0 I + i sum_j w_j sigma_j`."""

    scalar = sp.cancel(sp.trace(matrix) / 2)
    vector = tuple(sp.cancel(sp.trace(sigma * matrix) / (2 * I)) for sigma in PAULI)
    reconstruction = scalar * ONE
    for coefficient, sigma in zip(vector, PAULI):
        reconstruction += I * coefficient * sigma
    assert (matrix - reconstruction).applyfunc(sp.simplify) == sp.zeros(2)
    return (scalar, *vector)


def canonical_numerator(expression: sp.Expr, variables: tuple[sp.Symbol, ...]) -> sp.Expr:
    """Cancel denominators and return a sign-normalized primitive numerator."""

    numerator = sp.cancel(expression).as_numer_denom()[0]
    polynomial = sp.Poly(numerator, *variables, domain=sp.QQ)
    primitive = polynomial.primitive()[1]
    if primitive.LC() < 0:
        primitive = -primitive
    return sp.factor(primitive.as_expr())


@dataclass(frozen=True)
class BoundaryChart:
    """A disjoint chart whose listed axes have phase exactly `-1`."""

    fixed_axes: tuple[int, ...]

    @property
    def label(self) -> str:
        return "".join(AXES[index][0] for index in self.fixed_axes)

    @property
    def variables(self) -> tuple[sp.Symbol, ...]:
        return tuple(
            variable
            for index, variable in enumerate(TANGENT_VARIABLES)
            if index not in self.fixed_axes
        )

    def matrix(self) -> sp.Matrix:
        factors: list[sp.Matrix] = []
        for index, (_, p, q) in enumerate(AXES):
            if index in self.fixed_axes:
                factors.append(stationary_axis(sp.Integer(-1), sp.Integer(0), p, q))
            else:
                factors.append(stationary_axis(*half_angle(TANGENT_VARIABLES[index]), p, q))
        return (factors[0] * factors[1] * factors[2]).applyfunc(sp.cancel)


EXPECTED_BASES: dict[str, tuple[sp.Expr, ...]] = {
    "x": (sp.Integer(1),),
    "y": (sp.Integer(1),),
    "z": (sp.Integer(1),),
    "xy": (sp.Integer(1),),
    "xz": (TY,),
    "yz": (sp.Integer(1),),
}


def classify_positive_dimensional_chart(chart: BoundaryChart) -> None:
    matrix = chart.matrix()
    scalar, *vector = pauli_coefficients(matrix)
    variables = chart.variables
    numerators = tuple(canonical_numerator(value, variables) for value in vector)
    basis = sp.groebner(numerators, *variables, order="lex", domain=sp.QQ)
    basis_expressions = tuple(sp.factor(polynomial.as_expr()) for polynomial in basis.polys)

    print(f"\nSTRATUM {chart.label}: fixed phase(s) = -1")
    print("finite tangent variables:", ", ".join(map(str, variables)))
    for name, numerator in zip(("Fx", "Fy", "Fz"), numerators):
        print(f"{name} = {numerator}")
    print("reduced lex Groebner basis:", basis_expressions)

    expected = EXPECTED_BASES[chart.label]
    assert basis_expressions == expected, (
        f"unexpected basis on {chart.label}: {basis_expressions} != {expected}"
    )

    if basis_expressions == (sp.Integer(1),):
        print("classification: no Pauli-vector zero over C; hence no identity root")
        return

    assert chart.label == "xz" and basis_expressions == (TY,)
    root_matrix = matrix.subs(TY, 0).applyfunc(sp.simplify)
    root_scalar = sp.simplify(scalar.subs(TY, 0))
    assert root_matrix == ONE
    assert root_scalar == 1
    print("classification: unique Pauli-vector zero at ty = 0")
    print("scalar at root:", root_scalar)
    print("matrix at root:", root_matrix)
    print("phase triple at root: (-1, 1, -1), an exact identity crossing")


def classify_corner() -> None:
    chart = BoundaryChart((0, 1, 2))
    matrix = chart.matrix().applyfunc(sp.simplify)
    coefficients = tuple(sp.simplify(value) for value in pauli_coefficients(matrix))
    assert matrix != ONE
    assert any(value != 0 for value in coefficients[1:])
    print("\nSTRATUM xyz: all phases = -1")
    print("matrix:", matrix)
    print("(u0, wx, wy, wz):", coefficients)
    print("classification: not an identity root")


def main() -> None:
    print("Stationary-amplitude Weyl tangent-boundary exact census")
    print("SymPy version:", sp.__version__)
    print("phase convention: z = exp(i q), t = tan(q/2)")
    print("ordered symbol: Ux * Uy * Uz")

    for cardinality in (1, 2):
        for fixed_axes in combinations(range(3), cardinality):
            classify_positive_dimensional_chart(BoundaryChart(fixed_axes))
    classify_corner()

    exact_root = (
        stationary_axis(-1, 0, PX, QX)
        * stationary_axis(1, 0, PY, QY)
        * stationary_axis(-1, 0, PZ, QZ)
    ).applyfunc(sp.simplify)
    assert exact_root == ONE

    print("\nEXACT BOUNDARY CENSUS")
    print("identity roots with at least one phase -1: {(-1, 1, -1)}")
    print("PASS: all seven disjoint boundary strata classified with exact arithmetic")


if __name__ == "__main__":
    main()
