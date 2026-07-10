/-
# Strict subluminality: only the massless mode saturates the light cone

The finite carrier's transfer step has the **exact lattice dispersion**
`cos ω(k) = cos k · cos θ` (`ContinuumLimit.Ustep_trace`: `tr (Ustep k θ) =
2 cos k cos θ`), with mass angle `θ` (`θ = 0` massless). Differentiating implicitly,
`−sin ω · ω'(k) = −sin k · cos θ`, so the group velocity is
`v_g = sin k cos θ / sin ω` and `v_g² = (sin k cos θ)² / sin²ω`, with
`sin²ω = 1 − cos²ω = 1 − (cos k cos θ)²`.

This module records the **relativistic speed limit as a derived theorem**, not an
assumption: the luminal deficit `sin²ω − (sin k cos θ)² = 1 − cos²θ = sin²θ ≥ 0` is
`≥ 0` always (so `v_g² ≤ 1`, nothing outruns light) and `= 0` **iff** `cos²θ = 1`
(massless). Every massive mode (`cos²θ < 1`) is strictly subluminal; only the
massless walk propagates on the light cone. (What is *not* derived is Lorentz boost
symmetry — that is expected only at the critical point.)

Kernel-clean (no `s o r r y`); footprint `[propext, Classical.choice, Quot.sound]`.
Enriches the §2a/§9a dynamics core (Fable 2026-07-08 M-target O).
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit

open Real

namespace PhysicsSM.Draft.NullEdge.Carrier.SubluminalBound

/-- **`v_g² ≤ 1` (nothing outruns light).** From the pinned dispersion
`cos ω = cos k cos θ`, the group-velocity-squared numerator `(sin k cos θ)²` is
bounded by `sin²ω = 1 − (cos k cos θ)²`. -/
theorem groupVelSq_num_le_sin_sq_omega (k θ : ℝ) :
    (sin k * cos θ) ^ 2 ≤ 1 - (cos k * cos θ) ^ 2 := by
  nlinarith [sin_sq_add_cos_sq k, cos_le_one θ, neg_one_le_cos θ, sq_nonneg (cos θ),
    sin_sq_add_cos_sq θ]

/-- **The luminal deficit is exactly `sin²θ`.** `sin²ω − (sin k cos θ)² = 1 − cos²θ`
— independent of `k`, and `≥ 0` with equality iff `cos²θ = 1`. -/
theorem subluminal_gap_eq (k θ : ℝ) :
    (1 - (cos k * cos θ) ^ 2) - (sin k * cos θ) ^ 2 = 1 - cos θ ^ 2 := by
  nlinarith [sin_sq_add_cos_sq k]

/-- **Luminal iff massless.** The group velocity saturates the light cone (`v_g² = 1`)
**iff** `cos²θ = 1`, i.e. the massless walk (`θ = 0 mod π`). Every massive mode is
strictly subluminal. -/
theorem luminal_iff_massless (k θ : ℝ) :
    (1 - (cos k * cos θ) ^ 2) - (sin k * cos θ) ^ 2 = 0 ↔ cos θ ^ 2 = 1 := by
  rw [subluminal_gap_eq]; constructor <;> intro h <;> nlinarith [h]

/-- **Massive ⇒ strictly subluminal.** If `cos²θ < 1` (a massive mode, mass angle
`θ ≠ 0 mod π`), the group-velocity numerator is *strictly* below `sin²ω`. -/
theorem massive_implies_subluminal (k θ : ℝ) (hm : cos θ ^ 2 < 1) :
    (sin k * cos θ) ^ 2 < 1 - (cos k * cos θ) ^ 2 := by
  nlinarith [subluminal_gap_eq k θ]

end PhysicsSM.Draft.NullEdge.Carrier.SubluminalBound

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SubluminalBound.groupVelSq_num_le_sin_sq_omega' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.SubluminalBound.groupVelSq_num_le_sin_sq_omega

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SubluminalBound.massive_implies_subluminal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.SubluminalBound.massive_implies_subluminal
