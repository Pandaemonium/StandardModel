# Summary of changes for run 3f772c6d-b851-4d6a-80dd-31fa07a40f77
Built a finite, fully kernel-checked avatar of Jacobson's "Einstein equation as an equation of state" for the null-edge soldering (gravity) channel, in `RequestProject/Main.lean` (namespace `JacobsonClausius`). The project builds cleanly (`lake build RequestProject.Main`) with no `sorry`/`admit`/`native_decide` and no new axioms.

Model (explicit rationals over a soldering vector `γ = (g₀,g₁)`):
- `area γ = g₀ + g₁`, `alpha = 1/4`, `entropy γ = alpha·area γ`, `heat γ = g₀²/2 + g₁²/2 + 7`, `temp = 4`; variation `path γ v t = γ + t·v`; gradients `gradHeat γ = (g₀,g₁)`, `gradArea = (1,1)`.

Delivered targets:
1. `clausius_lhs_rhs` — closed forms for the Clausius LHS/RHS (`δheat = grad heat·v`, `T·δS = (T·α)·(grad area·v)`), obtained via `HasDerivAt` gradients `heat_deriv`/`entropy_deriv`.
2. `equation_of_state` (payload) — proves both directions of `ClausiusHolds γ ↔ FieldEq γ`, where `FieldEq γ` is `gradHeat γ = (temp·alpha) • gradArea`; i.e. the finite field equation is the integrability condition of the Clausius equation of state.
3. `jacobson_verdict` (package) — bundles the universal equivalence with the mandatory non-degeneracy witnesses: `nondegenerate_witness` (γ*=(1,1), v=(1,0): field equation holds, δheat = T·δS = 1 ≠ 0) and `control_witness` (γ=(2,2), v=(1,0): field equation violated, δheat = 2 ≠ 1 = T·δS), so the equivalence is non-vacuous.

Each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. `ARISTOTLE_SUMMARY.md` documents the honest scope: this is a finite slab avatar of the equation-of-state derivation, not continuum general relativity. All work is committed and pushed to `origin/main`.

# Jacobson–Clausius: the finite gravitational equation of state

**Scope (honest).** This is a *finite, fully kernel-checked avatar* of Jacobson's 1995 derivation
of the Einstein equation as an equation of state (`δQ = T δS` with `S ∝ area` forcing the field
equation). It is **not** continuum general relativity: there is no spacetime, no metric, no Ricci
curvature, and no continuum horizon integral. Instead the null-edge soldering (gravity) channel of a
small causal slab is modelled by explicit rational functions of a soldering-decoration vector
`γ = (g₀, g₁)`, and the Clausius ⇔ field-equation equivalence is proved exactly in that finite model.
All constants are rational and every headline result is checked to depend only on the standard
axioms `[propext, Classical.choice, Quot.sound]`.

## The model (`RequestProject/Main.lean`, namespace `JacobsonClausius`)

Soldering vector `γ = (g₀, g₁) : ℝ × ℝ` (constants rational):

- `area γ = g₀ + g₁` — pierced-edge count / boundary measure (linear).
- `alpha = 1/4`, `entropy γ = alpha * area γ` — Bekenstein–Hawking `S = A/4`.
- `heat γ = g₀²/2 + g₁²/2 + 7` — the soldering-channel budget flux (`E_#` E-slot flux).
- `temp = 4` — a fixed nonzero Unruh-type temperature.
- `path g v t = γ + t·v` — a soldering variation along direction `v`.
- `gradHeat γ = (g₀, g₁)`, `gradArea = (1,1)` — the finite gradients.

## Results (all `ring`/`norm_num`/`linear_combination` + `HasDerivAt`)

- `heat_deriv`, `entropy_deriv` — the finite gradients along a soldering variation, via `HasDerivAt`.
- `clausius_lhs_rhs` (**Target 1**) — closed forms: `δheat = grad heat · v` and
  `T·δS = (T·α)·(grad area · v)`.
- `FieldEq γ := gradHeat γ = (temp*alpha) • gradArea` — the finite field equation.
- `ClausiusHolds γ` — the Clausius relation `d/dt heat = T · d/dt entropy` for all directions `v`.
- `equation_of_state` (**Target 2, payload**) — `ClausiusHolds γ ↔ FieldEq γ`. Both directions.
  The field equation is exactly the integrability condition of the equation of state.
- `nondegenerate_witness` — at `γ* = (1,1)`, `v = (1,0)`: field equation holds and
  `δheat = T·δS = 1 ≠ 0` (all quantities nonzero).
- `control_witness` — at `γ = (2,2)`, `v = (1,0)`: field equation violated and `δheat = 2 ≠ 1 = T·δS`,
  so the equivalence is not vacuous.
- `jacobson_verdict` (**Target 3, package**) — bundles the universal equivalence with both explicit
  witnesses.

## Verification

Every headline (`clausius_lhs_rhs`, `equation_of_state`, `nondegenerate_witness`, `control_witness`,
`jacobson_verdict`) carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly
`[propext, Classical.choice, Quot.sound]`. No `sorry`/`admit`/`native_decide`, no new axioms, no
`Complex`/`Real.cos`/`Real.sin`/`Real.sqrt`, no high-degree `nlinarith`. Builds with
`lake build RequestProject.Main`.
