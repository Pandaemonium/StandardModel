# Summary of changes for run 9865446e-1f43-46c1-af8c-f2369e592f13
Delivered `RequestProject/Main.lean` (namespace `LambdaUnimodular`) and `ARISTOTLE_SUMMARY.md`, formalizing and fully proving the finite unimodular trade over ℚ (n = 3). The file builds cleanly with no `sorry`/`admit`/`native_decide`/new axioms.

Setup: state space `ℚ^3`, `A = diag(1,2,3)`, `Mc Aop c = Aop + c•1`, action `S Aop c x = x ⬝ᵥ (Mc Aop c) *ᵥ x`, `Vol x = x ⬝ᵥ x`, and constrained stationarity defined via `HasDerivAt` along tangent directions `h` with `⟪x,h⟫ = 0`.

Proved headline results:
1. `multiplier_field_equation`: for symmetric `Aop`, `x ≠ 0`, constrained stationarity ⇔ `∃ Λ, A x + c x = Λ x` — both directions via `HasDerivAt` (path derivative `2⟪h,(A+c•1)x⟫`) plus the geometric core `perp_implies_parallel`.
2. `vacuum_shift_is_gauge` (`S(c+δ) = S(c) + δ·v0` on the surface) and `gauge_solution_map` (`Λ → Λ+δ`): the vacuum mean is gauge.
3. `trace_channel_blind` / `order0_operator_blind` (order-0 term `a0·tr 1` invariant under any deformation `D → D+P`), `trace_one_eq_dim` (`tr 1 = n`), with the genuine contrast `a2_term_not_blind` (the order-2 term `tr(D²)` does depend on dynamics).
4. `unimodular_verdict`: packages 1–3 with the explicit witnesses.

Explicit rational witnesses: stationary point `x = (0,1,0)`, `c = 0`, `v0 = 1`, `Λ = 2`; gauge `δ = 5` sends it to `Λ = 7`; control point `x = (1,1,0)` proven not stationary.

Every headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`; these guards pass as part of the successful build. Honest scope: a finite n-dimensional avatar, not continuum unimodular gravity. Work committed and pushed.

# The finite unimodular trade — summary

`RequestProject/Main.lean` (namespace `LambdaUnimodular`) formalizes a finite,
purely rational avatar of the unimodular-gravity "trade": the cosmological
constant `Λ` enters only as the Lagrange multiplier of the volume/count
constraint, the vacuum mean is gauge on the constraint surface, and the order-`0`
coefficient of the finite spectral action is blind to all dynamics.

## Setup

* State space `ℚ^n` with `n = 3` (`Vec := Fin 3 → ℚ`, `Mat := Matrix (Fin 3) (Fin 3) ℚ`).
* `A = diag(1,2,3)` — the explicit rational symmetric dynamical operator.
* `Mc Aop c = Aop + c • 1` — dynamics plus the order-`0` vacuum term.
* `S Aop c x = x ⬝ᵥ (Mc Aop c) *ᵥ x` — the action.
* `Vol x = x ⬝ᵥ x` — the volume/count functional.
* `Stationary Aop c x` — constrained stationarity: for every tangent direction
  `h` with `⟪x,h⟫ = 0`, `HasDerivAt (fun t => S Aop c (x + t•h)) 0 0`.

## Headline results (all with `#print axioms` audited to `[propext, Classical.choice, Quot.sound]`)

1. `multiplier_field_equation`: for symmetric `Aop` and `x ≠ 0`,
   `Stationary Aop c x ↔ ∃ Λ, Aop *ᵥ x + c • x = Λ • x`. Both directions go through
   `HasDerivAt` (the path derivative is the explicit quadratic coefficient
   `2⟪h, (A+c•1)x⟫`), with the forward direction closed by the geometric core
   `perp_implies_parallel`.
2. `vacuum_shift_is_gauge`: on `Vol x = v0`, `S Aop (c+δ) x = S Aop c x + δ*v0`
   (a state-independent constant), and `gauge_solution_map`: `c → c+δ` sends a
   solution with multiplier `Λ` to one with `Λ+δ`.
3. `trace_channel_blind`: `order0Term a0 (D + P) = order0Term a0 D` for all
   `D, P` (and `order0_operator_blind` across any two operators); `trace_one_eq_dim`:
   `tr(1) = n`. The contrast is genuine: `a2_term_not_blind` shows the order-`2`
   term `tr(D²)` does depend on the dynamics.
4. `unimodular_verdict`: packages 1–3 with the explicit witnesses.

## Non-degeneracy witnesses (explicit rationals)

* `witness_field_eq` / `witness_stationary`: `x = (0,1,0)`, `c = 0`, `v0 = 1`
  (`witness_vol_one`) is a constrained stationary point with `Λ = 2`.
* `witness_gauge_shift`: the gauge shift `δ = 5` maps it to `Λ = 7`.
* `control_not_stationary`: `x = (1,1,0)` is not stationary — the equation
  genuinely selects.

## Scope

An honest finite `n`-dimensional avatar of the unimodular trade, not continuum
unimodular gravity. Kernel-checked, no `sorry`/`admit`/`native_decide`/new axioms;
Mathlib only.
