"""Derive the ordered 3+1 split-walk Floquet determinant candidates.

This is an external SymPy oracle, not a trusted proof.  It constructs the exact
4 x 4 matrices used by `Compact3Plus1DiracRate`, computes det(U - I) and
det(U + I), and checks the compact candidate formulas modulo

    sx^2 + cx^2 = sy^2 + cy^2 = sz^2 + cz^2 = st^2 + ct^2 = 1.

The kernel-checked target is tracked in Aristotle project `c6cdee4d` and must be
landed independently before the formulas acquire theorem status.

Run from the repository root:

    python Scripts/oracle/derive_split4_floquet_polynomial.py
"""

from __future__ import annotations

import sympy as sp


def main() -> None:
    i = sp.I
    cx, cy, cz, ct = sp.symbols("cx cy cz ct", real=True)
    sx, sy, sz, st = sp.symbols("sx sy sz st", real=True)

    alpha1 = sp.Matrix(
        [[0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]]
    )
    alpha2 = sp.Matrix(
        [[0, 0, 0, -i], [0, 0, i, 0], [0, -i, 0, 0], [i, 0, 0, 0]]
    )
    alpha3 = sp.Matrix(
        [[0, 0, 1, 0], [0, 0, 0, -1], [1, 0, 0, 0], [0, -1, 0, 0]]
    )
    beta = sp.diag(1, 1, -1, -1)
    identity = sp.eye(4)

    def factor(cosine: sp.Symbol, sine: sp.Symbol, generator: sp.Matrix) -> sp.Matrix:
        return cosine * identity - i * sine * generator

    walk = (
        factor(cx, sx, alpha1)
        * factor(cy, sy, alpha2)
        * factor(cz, sz, alpha3)
        * factor(ct, st, beta)
    )

    spectral_base = (
        4 * ct**2 * cx**2 * cy**2 * cz**2
        - 2 * ct**2 * cx**2 * cy**2
        - 2 * ct**2 * cx**2 * cz**2
        + ct**2 * cx**2
        - 2 * ct**2 * cy**2 * cz**2
        + ct**2 * cy**2
        + ct**2 * cz**2
        - 2 * cx**2 * cy**2 * cz**2
        + cx**2 * cy**2
        + cx**2 * cz**2
        + cy**2 * cz**2
    )
    zero_mode = spectral_base - 2 * ct * cx * cy * cz
    pi_mode = spectral_base + 2 * ct * cx * cy * cz

    det_minus = sp.expand((walk - identity).det())
    det_plus = sp.expand((walk + identity).det())

    variables = (sx, sy, sz, st, cx, cy, cz, ct)
    unit_circle_ideal = sp.groebner(
        [
            sx**2 + cx**2 - 1,
            sy**2 + cy**2 - 1,
            sz**2 + cz**2 - 1,
            st**2 + ct**2 - 1,
        ],
        *variables,
    )
    minus_remainder = unit_circle_ideal.reduce(det_minus - 4 * zero_mode)[1]
    plus_remainder = unit_circle_ideal.reduce(det_plus - 4 * pi_mode)[1]

    assert sp.expand(minus_remainder) == 0
    assert sp.expand(plus_remainder) == 0
    assert sp.expand(zero_mode.subs({cx: 0, cy: 0, cz: 0})) == 0
    assert sp.expand(pi_mode.subs({cx: 0, cy: 0, cz: 0})) == 0

    print(f"SymPy {sp.__version__}")
    print("det(U - I) = 4 * zero_mode_polynomial")
    print(sp.factor(zero_mode))
    print("det(U + I) = 4 * pi_mode_polynomial")
    print(sp.factor(pi_mode))
    print("PASS: both differences reduce to zero modulo the unit-circle ideal")
    print("PASS: both polynomials vanish at body-center cosines cx=cy=cz=0")


if __name__ == "__main__":
    main()
