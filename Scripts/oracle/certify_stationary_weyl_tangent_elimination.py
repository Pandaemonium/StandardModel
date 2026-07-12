"""Certify the exact stationary-Weyl tangent elimination identity.

This sidecar intentionally does not import the numerical/analyzer script.  It
repeats the three displayed tangent numerator polynomials from
``B_STATIONARY_WEYL_TANGENT_ELIMINATION_2026-07-12.md`` and works over
``QQ[tx, ty, tz]``.

The key distinction checked here is polynomial-ideal membership versus a real
tangent-chart simplification.  The bare product

    tz * rootPoly(tz) * excludedPoly(tz)

is not in ``<Fx, Fy, Fz>``.  The actual univariate Groebner generator carries
the additional factor ``(1 + tz**2)**2``.  Since that factor is positive over
the reals, it can be cancelled when classifying real zeros, but it cannot be
cancelled inside the polynomial ideal.

The script also asks SymPy's extended module Groebner implementation for exact
quotients in the original three generators and verifies the expanded identity.
Use ``--emit-lean`` to print complete Lean-style definitions for those exact
quotients and the corrected identity (the output is intentionally very large).
"""

from __future__ import annotations

import argparse
import contextlib
import hashlib
import io
import platform
from collections.abc import Iterable
from pathlib import Path

import sympy as sp


tx, ty, tz = sp.symbols("tx ty tz")
GENS = (tx, ty, tz)


# These signs match the polynomials displayed in the memo.  The analyzer uses
# the negatives of Fx and Fz after primitive normalization; the ideals agree.
FX = (
    2108 * tx**2 * ty**2 * tz**2
    - 840 * tx**2 * ty**2 * tz
    - 700 * tx**2 * ty**2
    + 1050 * tx**2 * ty * tz
    - 3000 * tx**2 * tz
    - 245 * tx * ty**2 * tz**2
    - 875 * tx * ty**2
    + 3600 * tx * ty * tz**2
    - 875 * tx * tz**2
    - 3125 * tx
    - 700 * ty**2 * tz**2
    - 2500 * ty**2
    + 3750 * ty * tz
)

FY = (
    168 * tx**2 * ty**2 * tz
    - 140 * tx**2 * ty**2
    + 625 * tx**2 * ty * tz**2
    + 175 * tx**2 * ty
    - 500 * tx**2
    - 576 * tx * ty**2 * tz**2
    + 210 * tx * ty**2 * tz
    + 750 * tx * tz
    + 140 * ty**2 * tz**2
    + 600 * ty**2 * tz
    + 175 * ty * tz**2
    + 625 * ty
    + 500 * tz**2
)

FZ = (
    1344 * tx**2 * ty**2 * tz**2
    - 245 * tx**2 * ty**2 * tz
    + 2400 * tx**2 * ty**2
    - 3600 * tx**2 * ty * tz
    - 875 * tx**2 * tz
    + 840 * tx * ty**2 * tz**2
    + 3600 * tx * ty**2 * tz
    + 1050 * tx * ty * tz**2
    + 3750 * tx * ty
    + 3000 * tx * tz**2
    + 2400 * ty**2 * tz**2
    - 875 * ty**2 * tz
    - 3125 * tz
)

ROOT_POLY = 480 * tz**5 - 575 * tz**4 - 1026 * tz**2 + 1440 * tz - 575

EXCLUDED_POLY = (
    16384 * tz**6
    + 11040 * tz**5
    + 56375 * tz**4
    + 48000 * tz**3
    + 44050 * tz**2
    + 19680 * tz
    + 5175
)

BARE_PRODUCT = sp.expand(tz * ROOT_POLY * EXCLUDED_POLY)
CHART_FACTOR = (1 + tz**2) ** 2
CLEARED_PRODUCT = sp.expand(CHART_FACTOR * BARE_PRODUCT)
EXPECTED_MONIC_GENERATOR = sp.expand(CLEARED_PRODUCT / sp.Integer(7864320))


def canonical_poly(poly: sp.Poly) -> str:
    """Serialize a rational polynomial deterministically for hashing."""

    records = []
    for monomial, coefficient in poly.terms():
        records.append(
            f"{monomial[0]},{monomial[1]},{monomial[2]}:"
            f"{coefficient.p}/{coefficient.q}"
        )
    return ";".join(records)


def digest(poly: sp.Poly) -> str:
    return hashlib.sha256(canonical_poly(poly).encode("ascii")).hexdigest()


def exact_original_generator_lift() -> list[sp.Poly]:
    """Lift the corrected target to the original displayed generators."""

    polynomial_ring = sp.QQ.old_poly_ring(*GENS)
    free_rank_one = polynomial_ring.free_module(1)
    ideal_as_module = free_rank_one.submodule([FX], [FY], [FZ])

    # This is SymPy's extended Groebner path.  Unlike GroebnerBasis.reduce,
    # the result is expressed in the original input generators.
    lift_dmp = ideal_as_module.in_terms_of_generators([CLEARED_PRODUCT])
    return [
        sp.Poly(sp.expand(polynomial_ring.to_sympy(value)), *GENS, domain=sp.QQ)
        for value in lift_dmp
    ]


def lean_coefficient(value: sp.Rational, scalar: str = "Rational") -> str:
    if value.q == 1:
        return f"({value.p} : {scalar})"
    return f"(({value.p} : {scalar}) / ({value.q} : {scalar}))"


def lean_monomial(monomial: tuple[int, int, int]) -> str:
    factors = []
    for name, exponent in zip(("tx", "ty", "tz"), monomial):
        if exponent == 1:
            factors.append(name)
        elif exponent > 1:
            factors.append(f"{name} ^ {exponent}")
    return " * ".join(factors) if factors else "1"


def emit_lean_poly(name: str, poly: sp.Poly, scalar: str = "Rational") -> None:
    print(f"def {name} (tx ty tz : {scalar}) : {scalar} :=")
    for index, (monomial, coefficient) in enumerate(poly.terms()):
        prefix = "  " if index == 0 else "  + "
        print(
            f"{prefix}{lean_coefficient(coefficient, scalar)} * "
            f"({lean_monomial(monomial)})"
        )


def emit_lean(quotients: Iterable[sp.Poly], scalar: str = "Rational") -> None:
    """Emit a self-contained Lean-style statement of the valid identity."""

    qx, qy, qz = quotients
    for name, expression in (
        ("certFx", FX),
        ("certFy", FY),
        ("certFz", FZ),
        ("certRootPoly", ROOT_POLY),
        ("certExcludedPoly", EXCLUDED_POLY),
    ):
        emit_lean_poly(name, sp.Poly(expression, *GENS, domain=sp.QQ), scalar)
        print()
    for name, quotient in zip(("certQx", "certQy", "certQz"), (qx, qy, qz)):
        emit_lean_poly(name, quotient, scalar)
        print()
    print(f"theorem correctedEliminationCertificate (tx ty tz : {scalar}) :")
    print("    (1 + tz ^ 2) ^ 2 * tz * certRootPoly tx ty tz *")
    print("        certExcludedPoly tx ty tz =")
    print("      certQx tx ty tz * certFx tx ty tz +")
    print("      certQy tx ty tz * certFy tx ty tz +")
    print("      certQz tx ty tz * certFz tx ty tz := by")
    print("  unfold certQx certQy certQz certFx certFy certFz")
    print("  unfold certRootPoly certExcludedPoly")
    print("  ring")


def emit_lean_module(quotients: Iterable[sp.Poly], scalar: str) -> None:
    """Emit a complete Lean module containing the checked certificate."""

    lean_scalar = scalar
    print("import Mathlib")
    print()
    print("set_option maxHeartbeats 0")
    print("set_option maxRecDepth 100000")
    print()
    print("/-!")
    print("Generated exact certificate for the stationary-Weyl tangent elimination.")
    print("Source: Scripts/oracle/certify_stationary_weyl_tangent_elimination.py")
    print("The chart factor `(1 + tz ^ 2) ^ 2` is mathematically mandatory.")
    print("-/")
    print()
    print("namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylEliminationCertificate")
    print()
    print("noncomputable section")
    print()
    emit_lean(quotients, lean_scalar)
    if scalar == "Real":
        print()
        print("theorem eliminationFactorNecessaryOfNumeratorsZero (tx ty tz : Real)")
        print("    (hx : certFx tx ty tz = 0)")
        print("    (hy : certFy tx ty tz = 0)")
        print("    (hz : certFz tx ty tz = 0) :")
        print("    Or (tz = 0) (Or (certRootPoly tx ty tz = 0)")
        print("      (certExcludedPoly tx ty tz = 0)) := by")
        print("  have hcert := correctedEliminationCertificate tx ty tz")
        print("  rw [hx, hy, hz] at hcert")
        print("  simp only [mul_zero, add_zero, zero_add] at hcert")
        print("  have hchart : Not ((1 + tz ^ 2) ^ 2 = 0) := by positivity")
        print("  have hrest :")
        print("      (1 + tz ^ 2) ^ 2 *")
        print("        (tz * certRootPoly tx ty tz * certExcludedPoly tx ty tz) = 0 := by")
        print("    simpa only [mul_assoc] using hcert")
        print("  have hproduct :")
        print("      tz * certRootPoly tx ty tz * certExcludedPoly tx ty tz = 0 :=")
        print("    (mul_eq_zero.mp hrest).resolve_left hchart")
        print("  exact Or.elim (mul_eq_zero.mp hproduct)")
        print("    (fun hleft => Or.elim (mul_eq_zero.mp hleft)")
        print("      (fun htz => Or.inl htz)")
        print("      (fun hroot => Or.inr (Or.inl hroot)))")
        print("    (fun hexcluded => Or.inr (Or.inr hexcluded))")
    print()
    print("end")
    print()
    print("end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylEliminationCertificate")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--emit-lean",
        action="store_true",
        help="print the complete (large) exact quotient definitions and identity",
    )
    parser.add_argument(
        "--lean-output",
        type=Path,
        help="write a complete generated Lean module to this path",
    )
    parser.add_argument(
        "--check-lean-output",
        type=Path,
        help="fail unless this file exactly matches the generated Lean module",
    )
    parser.add_argument(
        "--lean-scalar",
        choices=("Rational", "Real"),
        default="Rational",
        help="scalar used by --lean-output (default: Rational)",
    )
    args = parser.parse_args()

    print(f"Python: {platform.python_version()}")
    print(f"SymPy: {sp.__version__}")
    print("Domain: QQ[tx, ty, tz], lex order tx > ty > tz")

    basis = sp.groebner([FX, FY, FZ], *GENS, order="lex", domain=sp.QQ)
    assert len(basis.polys) == 5
    last = sp.Poly(basis.polys[-1], *GENS, domain=sp.QQ)
    expected = sp.Poly(EXPECTED_MONIC_GENERATOR, *GENS, domain=sp.QQ)
    assert last == expected

    bare_basis_quotients, bare_remainder = basis.reduce(BARE_PRODUCT)
    bare_remainder_poly = sp.Poly(bare_remainder, *GENS, domain=sp.QQ)
    assert all(quotient == 0 for quotient in bare_basis_quotients)
    assert bare_remainder_poly == sp.Poly(BARE_PRODUCT, *GENS, domain=sp.QQ)

    cleared_basis_quotients, cleared_remainder = basis.reduce(CLEARED_PRODUCT)
    assert sp.expand(cleared_remainder) == 0
    nonzero_basis_quotients = [
        (index, sp.expand(value))
        for index, value in enumerate(cleared_basis_quotients)
        if value != 0
    ]
    assert nonzero_basis_quotients == [(4, sp.Integer(7864320))]

    quotients = exact_original_generator_lift()
    lifted = sp.expand(quotients[0].as_expr() * FX)
    lifted += sp.expand(quotients[1].as_expr() * FY)
    lifted += sp.expand(quotients[2].as_expr() * FZ)
    assert sp.expand(lifted - CLEARED_PRODUCT) == 0

    print("Bare target Groebner remainder equals bare target: YES")
    print("Bare target in <Fx,Fy,Fz>: NO")
    print("Actual monic elimination generator:")
    print(sp.factor(last.as_expr()))
    print("Cleared target Groebner remainder: 0")
    print("Cleared target reduced-basis quotient: 7864320 * G[4]")
    print("Original-generator exact lift verified: YES")
    for name, quotient in zip(("Qx", "Qy", "Qz"), quotients):
        print(
            f"{name}: total_degree={quotient.total_degree()} "
            f"terms={len(quotient.terms())} sha256={digest(quotient)}"
        )
    print("Corrected exact identity:")
    print(
        "(1+tz^2)^2*tz*rootPoly(tz)*excludedPoly(tz) = "
        "Qx*Fx + Qy*Fy + Qz*Fz"
    )
    print(
        "PASS: nonmembership of the bare product and membership of the "
        "chart-cleared product were checked exactly."
    )

    if args.emit_lean:
        print("\n--- BEGIN LEAN-STYLE CERTIFICATE ---")
        emit_lean(quotients)
        print("--- END LEAN-STYLE CERTIFICATE ---")

    generated_lean = None
    if args.lean_output or args.check_lean_output:
        buffer = io.StringIO(newline="\n")
        with contextlib.redirect_stdout(buffer):
            emit_lean_module(quotients, args.lean_scalar)
        generated_lean = buffer.getvalue()

    if args.lean_output:
        args.lean_output.parent.mkdir(parents=True, exist_ok=True)
        with args.lean_output.open("w", encoding="utf-8", newline="\n") as stream:
            stream.write(generated_lean)
        print(f"Lean module written: {args.lean_output}")

    if args.check_lean_output:
        committed = args.check_lean_output.read_text(encoding="utf-8")
        assert committed == generated_lean, (
            f"generated Lean module differs from {args.check_lean_output}"
        )
        module_hash = hashlib.sha256(generated_lean.encode("utf-8")).hexdigest()
        print(f"Lean module exact-match SHA-256: {module_hash}")


if __name__ == "__main__":
    main()
