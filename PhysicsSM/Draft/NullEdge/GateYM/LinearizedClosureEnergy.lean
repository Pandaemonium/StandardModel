/-
# Leading closure defect is positive energy (roadmap S1a core)

DRAFT (kernel-clean; no `s o r r y`). Overnight all-mass run 2026-07-08.
The algebraic core of QCD-roadmap stage S1a (Amendment A1): at the flat
connection, the leading (quadratic-in-connection) closure defect is the
positive Hilbert-Schmidt energy `||A||^2` - i.e. the `|F|^2` gauge-field
energy density at leading order.

## The statements

For a linearized connection `A` in the Lie algebra (skew-Hermitian,
`Aᴴ = -A`, the `su(N)` tangent at `U = 1`):

* `skew_leading_closure_energy`: `Tr(A A) = -Tr(Aᴴ A)` - the quadratic
  closure form equals minus the trace of `A²`, which is the HS norm.
* `leading_closure_energy_nonneg`: `0 <= -Tr(A A)` - the leading closure
  energy is NON-NEGATIVE (it is `Tr(Aᴴ A) = ||A||_HS^2 >= 0`).

Combined with `PlaquetteClosureAction.wilson_plaquette_eq_half_closure_defect`
(the Wilson weight is half the squared closure defect `|1 - U|^2`), and the
expansion `1 - U ~ -A` at `U = exp(A) ~ 1 + A`, this is the leading-order
statement that **closure disagreement is positive gauge-field energy**:
`N - Re Tr U ~ (1/2)||A||^2 = (1/2)|F|^2 a^4 + O(a^5)`.

## Claim boundary

This is the ALGEBRAIC quadratic form (the Hessian's value), stated for the
linearized connection - NOT a second-derivative computation through the
matrix exponential (which would add analysis). It is the `|F|^2` DEFECT-GRAM
energy of Amendment A0/A1, NOT the Weitzenboeck `Q_C` channel (which is the
chromomagnetic `sigma·F`, linear in `F` - Amendment B rail; do not
conflate). The full `d_1^# d_1 (x) kappa` Hessian over the face-edge
coboundary is the next rung (needs the coboundary operator); this file is
the per-face positive-energy core.

## Provenance

QCD roadmap Amendment A1 / SevenChallenges S1a - [comp]; the skew-Hermitian
trace algebra and `Tr(Aᴴ A) >= 0` are standard - [import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.GateYM.LinearizedClosureEnergy

open Matrix

open scoped ComplexOrder

variable {n : Type*} [Fintype n]

/-- **Leading closure form = minus `Tr(A²)`.** For a skew-Hermitian
linearized connection `A` (`Aᴴ = -A`), `Tr(A A) = -Tr(Aᴴ A)`. The right
side is the (real, non-negative) Hilbert-Schmidt energy. -/
theorem skew_leading_closure_energy (A : Matrix n n ℂ) (hskew : Aᴴ = -A) :
    (A * A).trace = -(Aᴴ * A).trace := by
  rw [hskew, neg_mul, trace_neg, neg_neg]

/-- **The leading closure energy is non-negative:** `0 <= -Tr(A A)`. It
equals `Tr(Aᴴ A) = ||A||_HS^2 >= 0`, the positive `|F|^2`-shaped gauge-field
energy at leading order. -/
theorem leading_closure_energy_nonneg (A : Matrix n n ℂ) (hskew : Aᴴ = -A) :
    0 ≤ -(A * A).trace := by
  rw [skew_leading_closure_energy A hskew, neg_neg]
  exact (Matrix.posSemidef_conjTranspose_mul_self A).trace_nonneg

/-- The leading closure energy vanishes iff the connection is flat
(`A = 0`): no disagreement, no energy. -/
theorem leading_closure_energy_eq_zero_iff (A : Matrix n n ℂ)
    (hskew : Aᴴ = -A) : (A * A).trace = 0 ↔ A = 0 := by
  rw [skew_leading_closure_energy A hskew, neg_eq_zero]
  constructor
  · intro h
    exact Matrix.conjTranspose_mul_self_eq_zero.mp
      ((Matrix.posSemidef_conjTranspose_mul_self A).trace_eq_zero_iff.mp h)
  · intro h; rw [h]; simp

/-! ## Local axiom guard (self-contained; no shared-guard-file contention) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.LinearizedClosureEnergy.skew_leading_closure_energy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms skew_leading_closure_energy

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.LinearizedClosureEnergy.leading_closure_energy_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms leading_closure_energy_nonneg

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.LinearizedClosureEnergy.leading_closure_energy_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms leading_closure_energy_eq_zero_iff

end PhysicsSM.Draft.NullEdge.GateYM.LinearizedClosureEnergy
