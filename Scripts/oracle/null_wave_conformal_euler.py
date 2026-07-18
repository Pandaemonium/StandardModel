"""Exact symbolic audit of the two-site conformal null-wave link equation.

This is an external SymPy oracle, not trusted proof.  It mirrors the fixed
mostly-minus, `(12,13,23,01,02,03)` conventions and the four local Euler sums
from `NonlinearLorentzPalatiniEuler.lean`.  The corresponding headline claims
must be proved independently in Lean.

Run from the repository root:

    python Scripts/oracle/null_wave_conformal_euler.py
"""

from __future__ import annotations

import sympy as sp


t, w0, w1 = sp.symbols("t w0 w1", real=True)
I4 = sp.eye(4)
ETA = sp.diag(1, -1, -1, -1)
BIVECTOR_PAIRS = ((1, 2), (1, 3), (2, 3), (0, 1), (0, 2), (0, 3))
HODGE = sp.Matrix(
    [
        [0, 0, 0, 0, 0, -1],
        [0, 0, 0, 0, 1, 0],
        [0, 0, 0, -1, 0, 0],
        [0, 0, 1, 0, 0, 0],
        [0, -1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0],
    ]
)
P1 = sp.Matrix([0, -1, 0, -1, 0, 0])
P2 = sp.Matrix([0, 0, 1, 0, 1, 0])


def bivector_matrix(vector: sp.Matrix) -> sp.Matrix:
    result = sp.zeros(4)
    for component, (first, second) in enumerate(BIVECTOR_PAIRS):
        result[first, second] = vector[component]
        result[second, first] = -vector[component]
    return result


def generator(vector: sp.Matrix) -> sp.Matrix:
    return bivector_matrix(vector) * ETA


G1 = generator(P1)
G2 = generator(P2)


def truncated_exp(matrix: sp.Matrix) -> sp.Matrix:
    return I4 + t * matrix + sp.Rational(1, 2) * t**2 * matrix**2


E1 = truncated_exp(G1)
E2 = truncated_exp(G2)


def shift(direction: int, site: int) -> int:
    return 1 - site if direction in (0, 3) else site


def link(site: int, direction: int) -> sp.Matrix:
    if site == 1 and direction == 1:
        return E1
    if site == 1 and direction == 2:
        return E2
    return I4


def two_step(site: int, first: int, second: int) -> sp.Matrix:
    return link(site, first) * link(shift(first, site), second)


def plaquette(site: int, first: int, second: int) -> sp.Matrix:
    left = two_step(site, first, second)
    right = two_step(site, second, first)
    return sp.simplify(left * right.inv())


def alternating(a: int, b: int, c: int, d: int) -> int:
    if len({a, b, c, d}) < 4:
        return 0
    values = (a, b, c, d)
    inversions = sum(values[i] > values[j] for i in range(4) for j in range(i + 1, 4))
    return -1 if inversions % 2 else 1


def identity_wedge(first: int, second: int) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for component, (i, j) in enumerate(BIVECTOR_PAIRS):
        result[component] = int(i == first and j == second) - int(
            i == second and j == first
        )
    return result


def identity_face(first: int, second: int) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for c in range(4):
        for d in range(4):
            result += (
                sp.Rational(1, 2)
                * alternating(c, d, first, second)
                * HODGE
                * identity_wedge(c, d)
            )
    return result


IDENTITY_FACES = {
    (first, second): identity_face(first, second)
    for first in range(4)
    for second in range(4)
}


def face(site: int, first: int, second: int) -> sp.Matrix:
    weight = w0 if site == 0 else w1
    return weight * IDENTITY_FACES[first, second]


def response(
    face_vector: sp.Matrix,
    transport: sp.Matrix,
    probe: sp.Matrix,
    holonomy: sp.Matrix,
) -> sp.Expr:
    adjoint = transport * generator(probe) * transport.inv()
    return sp.expand(-sp.Rational(1, 2) * sp.trace(generator(face_vector) * adjoint * holonomy))


def euler_branches(site: int, direction: int, component: int) -> tuple[sp.Expr, ...]:
    probe = sp.zeros(6, 1)
    probe[component] = 1
    first = sum(
        response(
            face(site, direction, b),
            link(site, direction),
            probe,
            plaquette(site, direction, b),
        )
        for b in range(4)
    )
    second = 0
    for a in range(4):
        predecessor = shift(a, site)
        second += response(
            face(predecessor, a, direction),
            two_step(predecessor, a, direction),
            probe,
            plaquette(predecessor, a, direction),
        )
    third = 0
    for a in range(4):
        holonomy = plaquette(site, a, direction)
        third += response(
            face(site, a, direction),
            holonomy * link(site, direction),
            probe,
            holonomy,
        )
    fourth = 0
    for b in range(4):
        predecessor = shift(b, site)
        fourth += response(
            face(predecessor, direction, b),
            two_step(predecessor, direction, b),
            probe,
            plaquette(predecessor, direction, b),
        )
    return tuple(sp.factor(value) for value in (first, second, third, fourth))


def euler(site: int, direction: int, component: int) -> sp.Expr:
    first, second, third, fourth = euler_branches(site, direction, component)
    return sp.factor(first + second - third - fourth)


def main() -> None:
    assert G1 * G2 == G2 * G1
    assert G1**3 == sp.zeros(4)
    assert G2**3 == sp.zeros(4)
    nonzero = []
    for site in range(2):
        for direction in range(4):
            for component in range(6):
                value = euler(site, direction, component)
                if value != 0:
                    nonzero.append((site, direction, component, value))
    for site, direction, component, value in nonzero:
        print(f"site={site} direction={direction} component={component}: {value}")
    print(f"nonzero symbolic coefficients: {len(nonzero)} / 48")
    for key in ((0, 0, 5), (1, 1, 1), (1, 2, 2)):
        branches = euler_branches(*key)
        print(f"branches {key}: {branches}")


if __name__ == "__main__":
    main()
