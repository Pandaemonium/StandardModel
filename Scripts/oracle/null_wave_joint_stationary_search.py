"""Search the full coframe-Einstein nullspace for joint stationarity.

For each site, the null-wave Palatini coframe equation has the ten-parameter
solution

    [[a, b,  c,  a+i-j],
     [d, e,  f,  d],
     [g, h,  e,  g],
     [i, -b, -c, j]].

This external SymPy oracle substitutes two independent copies into all 48
nonlinear link Euler coefficients.  It reports the exact reduced polynomial
system and simple factor consequences.  It is exploratory evidence only.

Run from the repository root:

    python Scripts/oracle/null_wave_joint_stationary_search.py
"""

from __future__ import annotations

import sympy as sp

import null_wave_conformal_euler as base
from null_wave_general_coframe import face as coframe_face


PARAMETERS = tuple(
    sp.symbols(f"{name}0 {name}1", real=True)
    for name in "abcdefghij"
)
SITE_PARAMETERS = tuple(tuple(pair[site] for pair in PARAMETERS) for site in range(2))


def einstein_coframe(site: int) -> sp.Matrix:
    a, b, c, d, e, f, g, h, i, j = SITE_PARAMETERS[site]
    return sp.Matrix(
        [
            [a, b, c, a + i - j],
            [d, e, f, d],
            [g, h, e, g],
            [i, -b, -c, j],
        ]
    )


COFRAMES = (einstein_coframe(0), einstein_coframe(1))
FACES = {
    (site, first, second): coframe_face(COFRAMES[site], first, second)
    for site in range(2)
    for first in range(4)
    for second in range(4)
}


def face(site: int, first: int, second: int) -> sp.Matrix:
    return FACES[site, first, second]


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


def main() -> None:
    equations = []
    for site in range(2):
        for direction in range(4):
            for component in range(6):
                value = euler(site, direction, component)
                if value != 0:
                    equations.append((site, direction, component, value))
    print(f"nonzero reduced connection equations: {len(equations)} / 48")
    for site, direction, component, value in equations:
        print(f"site={site} direction={direction} component={component}: {value}")
    print("\nCoframe determinants:")
    for site, coframe in enumerate(COFRAMES):
        print(f"site={site}: {sp.factor(coframe.det())}")


if __name__ == "__main__":
    main()
