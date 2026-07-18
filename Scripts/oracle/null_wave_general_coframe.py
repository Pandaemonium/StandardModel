"""Exact symbolic reduction of the general null-wave coframe equations.

The Palatini coframe equations are linear in the 16 tetrad entries for fixed
curvature.  This external SymPy oracle computes their exact nullspace for the
plus-polarized two-site null-wave curvature, then provides the parameterization
needed for the quadratic connection audit.  It is not trusted proof.

Run from the repository root:

    python Scripts/oracle/null_wave_general_coframe.py
"""

from __future__ import annotations

import sympy as sp

import null_wave_conformal_euler as base
from null_wave_diagonal_euler import FACE_ONE, FACE_TWO


KREIN = sp.diag(1, 1, 1, -1, -1, -1)
ENTRY_SYMBOLS = sp.symbols("e00:04 e10:14 e20:24 e30:34", real=True)
COFRAME = sp.Matrix(4, 4, ENTRY_SYMBOLS)


def coframe_wedge(coframe: sp.Matrix, first: int, second: int) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for component, (i, j) in enumerate(base.BIVECTOR_PAIRS):
        result[component] = (
            coframe[i, first] * coframe[j, second]
            - coframe[i, second] * coframe[j, first]
        )
    return result


def face(coframe: sp.Matrix, first: int, second: int) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for c in range(4):
        for d in range(4):
            result += (
                sp.Rational(1, 2)
                * base.alternating(c, d, first, second)
                * base.HODGE
                * coframe_wedge(coframe, c, d)
            )
    return result


def curvature(first: int, second: int) -> sp.Matrix:
    return (
        FACE_ONE[first, second] * base.P1
        + FACE_TWO[first, second] * base.P2
    )


def palatini_density(coframe: sp.Matrix) -> sp.Expr:
    value = 0
    for first in range(4):
        for second in range(4):
            value += (face(coframe, first, second).T * KREIN * curvature(first, second))[0]
    return sp.expand(value)


def main() -> None:
    density = palatini_density(COFRAME)
    equations = [sp.factor(sp.diff(density, entry)) for entry in ENTRY_SYMBOLS]
    matrix, rhs = sp.linear_eq_to_matrix(equations, ENTRY_SYMBOLS)
    assert rhs == sp.zeros(16, 1)
    print(f"Palatini density: {sp.factor(density)}")
    print(f"coframe Euler rank: {matrix.rank()} / 16")
    print("Nonzero coframe equations:")
    for index, equation in enumerate(equations):
        if equation != 0:
            row, column = divmod(index, 4)
            print(f"internal={row} direction={column}: {equation}")
    nullspace = matrix.nullspace()
    print(f"coframe Euler nullity: {len(nullspace)}")
    print("Nullspace basis matrices:")
    for index, vector in enumerate(nullspace):
        print(f"basis {index}:")
        print(sp.Matrix(4, 4, list(vector)))


if __name__ == "__main__":
    main()
