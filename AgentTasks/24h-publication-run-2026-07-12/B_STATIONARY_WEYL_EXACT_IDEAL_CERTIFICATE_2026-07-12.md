# Stationary-Weyl exact ideal-membership certificate sidecar

Date: 2026-07-12
Owner: Codex
Status: external exact CAS certificate; no Lean source was changed.

## Executive result

The requested bare polynomial identity is false.

Let `I = <Fx, Fy, Fz>` in `QQ[tx,ty,tz]`, with `Fx`, `Fy`, and `Fz` exactly as
displayed in
`B_STATIONARY_WEYL_TANGENT_ELIMINATION_2026-07-12.md`. Define

```text
rootPoly(tz) =
  480 tz^5 - 575 tz^4 - 1026 tz^2 + 1440 tz - 575

excludedPoly(tz) =
  16384 tz^6 + 11040 tz^5 + 56375 tz^4 + 48000 tz^3
  + 44050 tz^2 + 19680 tz + 5175

bare(tz) = tz * rootPoly(tz) * excludedPoly(tz).
```

Exact lexicographic Groebner reduction gives

```text
normalForm_I(bare) = bare != 0.
```

Therefore there are no polynomials `Qx,Qy,Qz` in `QQ[tx,ty,tz]` satisfying

```text
bare = Qx*Fx + Qy*Fy + Qz*Fz.
```

This is not a failure of proof search. It is an exact nonmembership result.
The missing factor in the requested statement is `(1+tz^2)^2`.

## Correct polynomial certificate

The reduced lexicographic Groebner basis has five elements. Its final monic
element is exactly

```text
G[4] =
  tz * (1+tz^2)^2 * rootPoly(tz) * excludedPoly(tz) / 7864320.
```

Consequently `GroebnerBasis.reduce` gives the compact exact certificate

```text
(1+tz^2)^2 * bare = 7864320 * G[4],
remainder = 0.
```

The new sidecar additionally uses SymPy's extended module-Groebner API,
`SubModule.in_terms_of_generators`, to lift the corrected target all the way
back to the three original displayed generators. It obtains exact rational
polynomials `Qx,Qy,Qz` and verifies by full expansion that

```text
(1+tz^2)^2 * tz * rootPoly(tz) * excludedPoly(tz)
  = Qx(tx,ty,tz) * Fx(tx,ty,tz)
  + Qy(tx,ty,tz) * Fy(tx,ty,tz)
  + Qz(tx,ty,tz) * Fz(tx,ty,tz).
```

The exact lift is large because this system has a substantial degree fall:

| Quotient | Total degree | Exact rational terms | Canonical coefficient SHA-256 |
|---|---:|---:|---|
| `Qx` | 18 | 174 | `9a1a327bde806192b3a8eef83129acf26e0b6fd507ebd9e86c444d4475a85056` |
| `Qy` | 17 | 170 | `7f221ee98f15e02d5ca855fe8ef16c7e557beda393d0aa1d57c6d60db373dd55` |
| `Qz` | 18 | 178 | `16f9b99aa857cac26a96726085468470406e5855db300f04bdaea58a96398e14` |

The hashes cover every exact coefficient in descending lexicographic monomial
order. The serialization is part of the script. No floating-point arithmetic
is used. Run with `--emit-lean` to print every rational coefficient and a
complete Lean-style identity rather than storing a roughly 400 KB generated
coefficient dump in the repository.

## Saturated and real-chart reading

In the localization where `1+tz^2` is invertible, the corrected polynomial
certificate can be divided by `(1+tz^2)^2`:

```text
bare
  = (Qx/(1+tz^2)^2) * Fx
  + (Qy/(1+tz^2)^2) * Fy
  + (Qz/(1+tz^2)^2) * Fz.
```

Thus `bare` belongs to the saturation

```text
I : <(1+tz^2)^infinity>,
```

but not to `I` itself. Over the reals, `1+tz^2 > 0`, so the extra factor has
no real zero and may be cancelled in a real-root classification. This explains
why omitting it from a root-census memo preserves the real zero set while still
being invalid as a polynomial ideal-membership claim.

## Lean-ready statement

The exact polynomial theorem supported by the certificate is the following
shape over `Rational` (or any commutative `Q`-algebra after coefficient maps):

```lean
example (tx ty tz : Rational) :
    (1 + tz ^ 2) ^ 2 * tz * certRootPoly tx ty tz *
        certExcludedPoly tx ty tz =
      certQx tx ty tz * certFx tx ty tz +
      certQy tx ty tz * certFy tx ty tz +
      certQz tx ty tz * certFz tx ty tz := by
  ring
```

The script's `--emit-lean` mode prints exact definitions of all eight named
polynomials, including every rational coefficient of `certQx`, `certQy`, and
`certQz`. The bare identity must not be stated as a Lean theorem. For a real
elimination implication, formalize the corrected identity and separately use
`1 + tz^2 != 0` (indeed, it is positive) to cancel the chart factor.

## Reproduction

New script:

```text
Scripts/oracle/certify_stationary_weyl_tangent_elimination.py
```

Command run from the repository root:

```powershell
python Scripts/oracle/certify_stationary_weyl_tangent_elimination.py
```

Environment reported by the script:

```text
Python: 3.12.10
SymPy: 1.14.0
Domain: QQ[tx, ty, tz], lex order tx > ty > tz
```

Exact output summary:

```text
Bare target Groebner remainder equals bare target: YES
Bare target in <Fx,Fy,Fz>: NO
Actual monic elimination generator:
tz*(tz**2 + 1)**2*(480*tz**5 - 575*tz**4 - 1026*tz**2 + 1440*tz - 575)*(16384*tz**6 + 11040*tz**5 + 56375*tz**4 + 48000*tz**3 + 44050*tz**2 + 19680*tz + 5175)/7864320
Cleared target Groebner remainder: 0
Cleared target reduced-basis quotient: 7864320 * G[4]
Original-generator exact lift verified: YES
Qx: total_degree=18 terms=174 sha256=9a1a327bde806192b3a8eef83129acf26e0b6fd507ebd9e86c444d4475a85056
Qy: total_degree=17 terms=170 sha256=7f221ee98f15e02d5ca855fe8ef16c7e557beda393d0aa1d57c6d60db373dd55
Qz: total_degree=18 terms=178 sha256=16f9b99aa857cac26a96726085468470406e5855db300f04bdaea58a96398e14
Corrected exact identity:
(1+tz^2)^2*tz*rootPoly(tz)*excludedPoly(tz) = Qx*Fx + Qy*Fy + Qz*Fz
PASS: nonmembership of the bare product and membership of the chart-cleared product were checked exactly.
```

Optional complete Lean-style coefficient emission:

```powershell
python Scripts/oracle/certify_stationary_weyl_tangent_elimination.py --emit-lean
```

Committed-module reproducibility check:

```powershell
python Scripts/oracle/certify_stationary_weyl_tangent_elimination.py `
  --check-lean-output PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylEliminationCertificate.lean `
  --lean-scalar Real
```

After the semantic-audit rename of the necessary-condition theorem, the
exact-match SHA-256 reported on July 12, 2026 is
`ee4545e7aaeebb1cdbc5616b3f8e9f8545b2150b4b8c5a23aafffdcc6b0d99b3`.

## Trust boundary

The script remains an external exact CAS oracle, but its generated certificate
has now been promoted to
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylEliminationCertificate.lean`,
where the chart-cleared identity and real root consequence are kernel-checked.
The valid result is the chart-cleared identity (or the localized/saturated
identity), not polynomial membership of the bare product. The separate live
matrix-to-numerator bridge remains open.
