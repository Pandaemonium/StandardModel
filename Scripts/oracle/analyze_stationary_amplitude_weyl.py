"""Exact and numerical census for the stationary-amplitude Weyl fixture.

The matrices match
`PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent`. Exact SymPy
expressions determine the SU(2) Pauli coefficients. Numerical root finding is
used only to discover candidate torus crossings for a later Lean theorem.
"""

from __future__ import annotations

import itertools

import numpy as np
import sympy as sp
from scipy.optimize import root


I = sp.I
R = sp.Rational
ONE = sp.eye(2)

SIGMA_X = sp.Matrix([[0, 1], [1, 0]])
SIGMA_Y = sp.Matrix([[0, -I], [I, 0]])
SIGMA_Z = sp.Matrix([[1, 0], [0, -1]])

PX = sp.Matrix([[R(9, 10), R(3, 10)], [R(3, 10), R(1, 10)]])
QX = sp.Matrix([[R(1, 10), R(3, 10)], [R(3, 10), R(9, 10)]])
PY = sp.Matrix([[R(9, 10), -R(3, 10) * I], [R(3, 10) * I, R(1, 10)]])
QY = sp.Matrix([[R(1, 10), -R(3, 10) * I], [R(3, 10) * I, R(9, 10)]])
PZ = sp.Matrix([[R(4, 5), R(2, 5)], [R(2, 5), R(1, 5)]])
QZ = sp.Matrix([[R(4, 5), -R(2, 5)], [-R(2, 5), R(1, 5)]])


def axis(c: sp.Expr, s: sp.Expr, p: sp.Matrix, q: sp.Matrix) -> sp.Matrix:
    z = c + I * s
    zbar = c - I * s
    gamma_plus = p * q
    gamma_zero = p * (ONE - q) + (ONE - p) * q
    gamma_minus = (ONE - p) * (ONE - q)
    return (z * gamma_plus + gamma_zero + zbar * gamma_minus).applyfunc(sp.expand)


def pauli_coefficients(u: sp.Matrix) -> tuple[sp.Expr, ...]:
    scalar = sp.expand(sp.trace(u) / 2)
    coeffs = []
    for sigma in (SIGMA_X, SIGMA_Y, SIGMA_Z):
        coeffs.append(sp.expand(sp.trace(sigma * u) / (2 * I)))
    return (scalar, *coeffs)


def wrap_angle(x: float) -> float:
    return ((x + np.pi) % (2 * np.pi)) - np.pi


def torus_distance(a: np.ndarray, b: np.ndarray) -> float:
    return float(np.linalg.norm([wrap_angle(float(x - y)) for x, y in zip(a, b)]))


def main() -> None:
    cx, sx, cy, sy, cz, sz = sp.symbols("cx sx cy sy cz sz", real=True)
    print("Building exact axis symbols...", flush=True)
    ux = axis(cx, sx, PX, QX)
    uy = axis(cy, sy, PY, QY)
    uz = axis(cz, sz, PZ, QZ)
    print("Multiplying exact three-axis symbol...", flush=True)
    u = (ux * uy * uz).applyfunc(sp.expand)

    print("det(Ux), det(Uy), det(Uz), det(U):")
    axis_dets = [sp.expand(x.det()) for x in (ux, uy, uz)]
    print(*axis_dets, sp.expand(sp.prod(axis_dets)), sep="\n", flush=True)

    names = ("u0", "wx", "wy", "wz")
    raw_coeffs = pauli_coefficients(u)
    coeffs = tuple(sp.factor(sp.re(sp.expand_complex(v))) for v in raw_coeffs)
    imaginary_parts = tuple(sp.factor(sp.im(sp.expand_complex(v))) for v in raw_coeffs)
    for name, value in zip(names, coeffs):
        print(f"\n{name} =")
        print(value)
        print("imaginary part:", imaginary_parts[names.index(name)])

    print("\nExact origin controls:")
    for name, value in zip(names, coeffs):
        print(name, sp.simplify(value.subs({cx: 1, sx: 0, cy: 1, sy: 0, cz: 1, sz: 0})))

    # Convert the three real vector coefficients to a numerical torus map.
    vector_fn = sp.lambdify(
        (cx, sx, cy, sy, cz, sz), coeffs[1:], modules="numpy"
    )
    scalar_fn = sp.lambdify(
        (cx, sx, cy, sy, cz, sz), coeffs[0], modules="numpy"
    )

    def vector_at(q: np.ndarray) -> np.ndarray:
        vals = vector_fn(
            np.cos(q[0]), np.sin(q[0]),
            np.cos(q[1]), np.sin(q[1]),
            np.cos(q[2]), np.sin(q[2]),
        )
        return np.asarray(vals, dtype=float).reshape(3)

    roots: list[np.ndarray] = []
    grid = np.linspace(-np.pi, np.pi, 7, endpoint=False)
    seeds = list(itertools.product(grid, repeat=3))
    rng = np.random.default_rng(20260711)
    seeds.extend(rng.uniform(-np.pi, np.pi, size=(5000, 3)))
    for seed in seeds:
        sol = root(vector_at, np.asarray(seed, dtype=float), method="hybr")
        if not sol.success or np.linalg.norm(vector_at(sol.x)) > 1e-9:
            continue
        q = np.asarray([wrap_angle(float(v)) for v in sol.x])
        if all(torus_distance(q, old) > 1e-6 for old in roots):
            roots.append(q)

    roots.sort(key=lambda q: tuple(np.round(q, 10)))
    print(f"\nNumerical Pauli-vector roots: {len(roots)}")
    for q in roots:
        scalar = float(
            scalar_fn(
                np.cos(q[0]), np.sin(q[0]),
                np.cos(q[1]), np.sin(q[1]),
                np.cos(q[2]), np.sin(q[2]),
            )
        )
        print(
            "q/pi =",
            np.round(q / np.pi, 12),
            "u0 =",
            f"{scalar:+.12f}",
            "residual =",
            f"{np.linalg.norm(vector_at(q)):.3e}",
        )

    # A root of the Pauli vector should have u0 = +/-1 by exact unitarity.
    bad = [q for q in roots if abs(abs(float(scalar_fn(
        np.cos(q[0]), np.sin(q[0]), np.cos(q[1]), np.sin(q[1]),
        np.cos(q[2]), np.sin(q[2])
    ))) - 1) > 1e-7]
    if bad:
        raise SystemExit(f"FAIL: {len(bad)} vector roots are not +/- identity")

    # Exact tangent-half-angle elimination.  This chart uses
    # z = (1 - t^2 + 2 i t) / (1 + t^2) and therefore omits q = pi.
    tx, ty, tz = sp.symbols("tx ty tz", real=True)

    def half_angle(t: sp.Symbol) -> tuple[sp.Expr, sp.Expr]:
        return (1 - t**2) / (1 + t**2), 2 * t / (1 + t**2)

    tangent_u = (
        axis(*half_angle(tx), PX, QX)
        * axis(*half_angle(ty), PY, QY)
        * axis(*half_angle(tz), PZ, QZ)
    )
    tangent_coeffs = pauli_coefficients(tangent_u)[1:]
    tangent_numerators: list[sp.Expr] = []
    print("\nTangent-half-angle Pauli numerators:")
    for name, value in zip(("Fx", "Fy", "Fz"), tangent_coeffs):
        numerator = sp.cancel(value).as_numer_denom()[0]
        primitive = sp.Poly(numerator, tx, ty, tz).primitive()[1].as_expr()
        primitive = sp.factor(primitive)
        tangent_numerators.append(primitive)
        print(f"{name} = {primitive}")

    tangent_basis = sp.groebner(
        tangent_numerators, tx, ty, tz, order="lex"
    )
    elimination = sp.factor(tangent_basis.polys[-1].as_expr())
    print("\nTangent-chart elimination factor:")
    print(elimination)

    root_poly = 480 * tz**5 - 575 * tz**4 - 1026 * tz**2 + 1440 * tz - 575
    excluded_poly = (
        16384 * tz**6 + 11040 * tz**5 + 56375 * tz**4
        + 48000 * tz**3 + 44050 * tz**2 + 19680 * tz + 5175
    )
    print("Real roots of quintic:", sp.Poly(root_poly, tz).count_roots(-sp.oo, sp.oo))
    print("Real roots of sextic:", sp.Poly(excluded_poly, tz).count_roots(-sp.oo, sp.oo))

    branch_basis = sp.groebner(
        [*tangent_numerators, root_poly], tx, ty, tz, order="lex"
    )
    print("\nTriangular quintic-branch certificate:")
    for polynomial in branch_basis.polys:
        print(sp.factor(polynomial.as_expr()))

    print(
        "\nPASS: exact coefficients and tangent elimination derived; "
        "every numerical vector root is +/- identity."
    )


if __name__ == "__main__":
    main()
