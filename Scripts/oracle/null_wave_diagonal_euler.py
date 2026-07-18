"""Exact symbolic audit of diagonal coframes for the two-site null wave.

This external SymPy oracle widens the conformal audit to independent diagonal
tetrad entries at both sites.  It computes all nonlinear link Euler
coefficients and all mixed vacuum Einstein entries.  It is exploratory evidence
only; any resulting claim must be reconstructed and proved in Lean.

Run from the repository root:

    python Scripts/oracle/null_wave_diagonal_euler.py
"""

from __future__ import annotations

import sympy as sp

import null_wave_conformal_euler as base


SITE_DIAGONALS = (
    sp.symbols("e00 e01 e02 e03", nonzero=True, real=True),
    sp.symbols("e10 e11 e12 e13", nonzero=True, real=True),
)


def diagonal_coframe(site: int) -> sp.Matrix:
    return sp.diag(*SITE_DIAGONALS[site])


def coframe_wedge(coframe: sp.Matrix, first: int, second: int) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for component, (i, j) in enumerate(base.BIVECTOR_PAIRS):
        result[component] = (
            coframe[i, first] * coframe[j, second]
            - coframe[i, second] * coframe[j, first]
        )
    return result


def diagonal_face(site: int, first: int, second: int) -> sp.Matrix:
    coframe = diagonal_coframe(site)
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


DIAGONAL_FACES = {
    (site, first, second): diagonal_face(site, first, second)
    for site in range(2)
    for first in range(4)
    for second in range(4)
}


def face(site: int, first: int, second: int) -> sp.Matrix:
    return DIAGONAL_FACES[site, first, second]


def euler(site: int, direction: int, component: int) -> sp.Expr:
    probe = sp.zeros(6, 1)
    probe[component] = 1
    first = sum(
        base.response(
            face(site, direction, b),
            base.link(site, direction),
            probe,
            base.plaquette(site, direction, b),
        )
        for b in range(4)
    )
    second = 0
    for a in range(4):
        predecessor = base.shift(a, site)
        second += base.response(
            face(predecessor, a, direction),
            base.two_step(predecessor, a, direction),
            probe,
            base.plaquette(predecessor, a, direction),
        )
    third = 0
    for a in range(4):
        holonomy = base.plaquette(site, a, direction)
        third += base.response(
            face(site, a, direction),
            holonomy * base.link(site, direction),
            probe,
            holonomy,
        )
    fourth = 0
    for b in range(4):
        predecessor = base.shift(b, site)
        fourth += base.response(
            face(predecessor, direction, b),
            base.two_step(predecessor, direction, b),
            probe,
            base.plaquette(predecessor, direction, b),
        )
    return sp.factor(first + second - third - fourth)


FACE_ONE = sp.Matrix(
    [
        [0, 1, 0, 0],
        [-1, 0, 0, -1],
        [0, 0, 0, 0],
        [0, 1, 0, 0],
    ]
)
FACE_TWO = sp.Matrix(
    [
        [0, 0, 1, 0],
        [0, 0, 0, 0],
        [-1, 0, 0, -1],
        [0, 0, 1, 0],
    ]
)


def curvature(site: int, first: int, second: int) -> sp.Matrix:
    amplitude = 1 if site == 0 else -1
    return amplitude * (
        FACE_ONE[first, second] * base.P1
        + FACE_TWO[first, second] * base.P2
    )


def mixed_einstein(site: int, coframe_direction: int, raised_direction: int) -> sp.Expr:
    inverse = diagonal_coframe(site).inv()
    ricci = 0
    for i in range(4):
        for b in range(4):
            for j in range(4):
                ricci += (
                    inverse[raised_direction, i]
                    * inverse[b, j]
                    * base.bivector_matrix(curvature(site, coframe_direction, b))[i, j]
                )
    scalar = 0
    for a in range(4):
        for b in range(4):
            for i in range(4):
                for j in range(4):
                    scalar += (
                        inverse[a, i]
                        * inverse[b, j]
                        * base.bivector_matrix(curvature(site, a, b))[i, j]
                    )
    delta = int(raised_direction == coframe_direction)
    return sp.factor(2 * ricci - delta * scalar)


def main() -> None:
    print("Nonzero connection coefficients:")
    connection_equations = []
    for site in range(2):
        for direction in range(4):
            for component in range(6):
                value = euler(site, direction, component)
                if value != 0:
                    connection_equations.append(value)
                    print(
                        f"site={site} direction={direction} "
                        f"component={component}: {value}"
                    )
    print(f"nonzero symbolic coefficients: {len(connection_equations)} / 48")

    print("\nNonzero mixed Einstein entries:")
    einstein_equations = []
    for site in range(2):
        for coframe_direction in range(4):
            for raised_direction in range(4):
                value = mixed_einstein(site, coframe_direction, raised_direction)
                if value != 0:
                    einstein_equations.append(value)
                    print(
                        f"site={site} c={coframe_direction} "
                        f"d={raised_direction}: {value}"
                    )
    print(f"nonzero symbolic entries: {len(einstein_equations)} / 32")


if __name__ == "__main__":
    main()
