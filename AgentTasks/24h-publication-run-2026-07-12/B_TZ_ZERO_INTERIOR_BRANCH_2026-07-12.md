# Gate B `tz = 0` interior tangent branch

Date: 2026-07-12
Owner: Codex
Status: exact rational/SymPy classification with a direct Lean target

## Scope

This note owns only the finite tangent-chart branch `tz = 0` in the live
stationary-amplitude Weyl identity census. It does not alter the generated
elimination certificate, the live walk, bridge targets, chart-boundary work,
manuscripts, gates, guards, or ledger.

The Lean target is:

```text
AgentTasks/aristotle-targets/codex_24h_b_tz_zero_interior_branch.lean
```

It imports the generated `certFx`, `certFy`, and `certFz` definitions and the
live `weylStep`. No projector, axis matrix, or walk fixture is copied.

## Exact slice equations

Setting `tz = 0` in the generated certificate polynomials gives

```text
Fx0 = -700 tx^2 ty^2 - 875 tx ty^2 - 3125 tx - 2500 ty^2
Fy0 = -140 tx^2 ty^2 + 175 tx^2 ty - 500 tx^2 + 625 ty
Fz0 =  2400 tx^2 ty^2 + 3750 tx ty
     = 150 tx ty (16 tx ty + 25).
```

The factorization of `Fz0` gives three cases.

1. `tx = 0`: `Fx0 = -2500 ty^2`, hence `ty = 0`.
2. `ty = 0`: `Fx0 = -3125 tx`, hence `tx = 0`.
3. `16 tx ty + 25 = 0`: exact ideal reduction gives

```text
(4 ty - 5)(64 ty^2 + 45 ty + 100) = 0.
```

One exact original-generator lift used by the Lean proof is

```text
(4 ty - 5)(64 ty^2 + 45 ty + 100)
  = (-64 ty / 625) Fx0
    - (112 tx ty^2 + 140 ty^2 - 175 ty + 500)
      (16 tx ty + 25) / 25.
```

The quadratic factor is strictly positive over the reals. Its discriminant is
`45^2 - 4*64*100 = -23575`; equivalently positivity follows from
`(128 ty + 45)^2 >= 0`. Therefore `ty = 5/4`, and the branch equation then
forces `tx = -5/4`.

## Complete real classification

There are exactly two real solutions of `Fx = Fy = Fz = 0` with `tz = 0`:

| `(tx, ty, tz)` | Live matrix | Zero-coordinate pattern |
|---|---|---|
| `(0, 0, 0)` | `U = +I` | all three coordinates are zero |
| `(-5/4, 5/4, 0)` | `U = +I` | `tx != 0`, `ty != 0`, and only `tz = 0` |

The second tangent point maps exactly to the imported `9-40-41` phases:

```text
unitPhase(-5/4) = -9/41 - (40/41)i = phaseX,
unitPhase( 5/4) = -9/41 + (40/41)i = phaseY,
unitPhase(0) = 1.
```

Thus the imported theorem `exact_offCorner_alias` proves its live
reconstruction as `+I`. The origin uses the imported `weylStep_one`. There is
no `-I` point on this branch.

## Lean theorem surface

The target states and checks:

```text
origin_numerators_zero
offCorner_numerators_zero
unitPhase_neg_five_fourths
unitPhase_five_fourths
origin_reconstructs_positive_identity
offCorner_reconstructs_positive_identity
numerators_zero_and_tz_zero_iff
tz_zero_interior_live_census
explicit_witnesses
```

The strongest statement, `tz_zero_interior_live_census`, is an iff between
the exact live-bridge numerator system plus `tz = 0` and the two explicit points. Its
right side records `U = +I` and the coordinate-zero pattern for each point.

## Exact oracle reproduction

The classification was recomputed over `QQ` with SymPy 1.14.0. The reduced
lexicographic basis for the slice ideal is

```text
(6400 tx + 1792 ty^3 + 4140 ty^2 - 1575 ty) / 6400
ty (4 ty - 5) (64 ty^2 + 45 ty + 100) / 256.
```

`solve_poly_system` returns the two real points above and one nonreal conjugate
pair. Exact substitution into the imported matrix formulas gives `Matrix.eye(2)`
at both real points. No floating-point arithmetic is used for these claims.

The corrected full elimination certificate was also rerun with:

```powershell
python Scripts/oracle/certify_stationary_weyl_tangent_elimination.py
```

That check retains the mandatory `(1+tz^2)^2` chart factor and verifies the
exact lift to the three original generated numerators.

## Trust boundary

SymPy is an external exact algebra oracle used to discover and independently
check the classification. The integrated Lean module states the classification
against the verified live matrix-bridge definitions and uses the imported live
matrix witness theorems. Direct Lean and the targeted two-module build pass;
there are no remaining executable proof handoff markers. The aggregate axiom
guard pins the full census and explicit witnesses.

Integrated module:
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTzZeroInteriorBranch.lean`.
