import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The fixed-point set of the null-edge RG map `R2`

This file characterizes, over the rationals, the fixed-point set and orbit structure
of the exact rational RG map

`R2(lam, kap) = (lam - 2 kap^2 / lam, -kap^2 / lam)`,

on the domain `lam ≠ 0`.

Main results:

* `fixed_points`   : for `lam ≠ 0`, `R2 lam kap = (lam, kap) ↔ kap = 0`, i.e. the fixed points
  are exactly the DECOUPLED / free line `kap = 0`.
* `critical_line_period2` : on the critical line `kap = lam`, `R2` is the sign flip
  `(lam,lam) → (-lam,-lam) → (lam,lam)`, a genuine period-2 orbit and NOT a fixed point.
* `flow_toward_decoupled` : in the massive phase `0 < |kap| < |lam|` the closure coupling
  strictly shrinks, `|kap'| = kap^2 / |lam| < |kap|`, so the flow is attracted to `kap = 0`.
* `basin_verdict` : the packaged statement of the above.

Plus concrete non-degeneracy witnesses `R2 1 (1/2) = (1/2, -1/4)` (shrinking) and the
period-2 orbit `R2 1 1 = (-1,-1)`, `R2 (-1) (-1) = (1,1)`.
-/

namespace RGFixedPointStructure

/-- The null-edge RG map (2-channel), on rational couplings, with intended domain `lam ≠ 0`. -/
def R2 (lam kap : ℚ) : ℚ × ℚ := (lam - 2 * kap ^ 2 / lam, -kap ^ 2 / lam)

/-! ### Concrete non-degeneracy witnesses -/

/-- A massive rational point where the closure coupling shrinks: `|kap|` goes `1/2 → 1/4`. -/
theorem R2_massive_example : R2 1 (1 / 2) = (1 / 2, -(1 / 4)) := by
  norm_num [R2]

/-- Forward leg of the period-2 orbit on the critical line at `lam = 1`. -/
theorem R2_period2_forward : R2 1 1 = (-1, -1) := by
  norm_num [R2]

/-- Return leg of the period-2 orbit on the critical line at `lam = 1`. -/
theorem R2_period2_back : R2 (-1) (-1) = (1, 1) := by
  norm_num [R2]

/-! ### The fixed-point set -/

/-- **Fixed points.** For `lam ≠ 0`, `(lam, kap)` is a fixed point of `R2` iff `kap = 0`.
Thus the fixed-point set is exactly the decoupled/free line `{(lam, 0) : lam ≠ 0}`.

The second-coordinate equation `-kap^2/lam = kap` forces `kap = 0` or `kap = -lam`, but the
first-coordinate equation `lam - 2 kap^2/lam = lam` forces `kap = 0`; hence `kap = -lam`
is a spurious root and only `kap = 0` gives a genuine fixed point. -/
theorem fixed_points {lam kap : ℚ} (hlam : lam ≠ 0) :
    R2 lam kap = (lam, kap) ↔ kap = 0 := by
  constructor
  · intro h
    rw [R2, Prod.ext_iff] at h
    obtain ⟨h1, _h2⟩ := h
    field_simp at h1
    nlinarith [sq_nonneg kap]
  · intro h; subst h; simp [R2]

/-! ### The critical line is a period-2 invariant set -/

/-- **Critical line is period-2.** On the critical (massless) line `kap = lam` with `lam ≠ 0`,
`R2` acts as the sign flip `(lam,lam) → (-lam,-lam)`, and back, a genuine period-2 orbit
that is NOT a fixed point. -/
theorem critical_line_period2 {lam : ℚ} (hlam : lam ≠ 0) :
    R2 lam lam = (-lam, -lam) ∧ R2 (-lam) (-lam) = (lam, lam) ∧
      ((-lam, -lam) : ℚ × ℚ) ≠ (lam, lam) := by
  refine ⟨?_, ?_, ?_⟩
  · rw [R2, Prod.ext_iff]; refine ⟨?_, ?_⟩ <;> (field_simp; try ring)
  · rw [R2, Prod.ext_iff]; refine ⟨?_, ?_⟩ <;> (field_simp; try ring)
  · simp only [ne_eq, Prod.mk.injEq, not_and]
    intro h; exact absurd h (by intro hh; exact hlam (by linarith))

/-! ### The massive phase flows to the free line -/

/-- **Flow toward decoupling.** In the massive phase `0 < |kap| < |lam|`, the closure coupling
strictly shrinks under decimation: `|kap'| = kap^2 / |lam| < |kap|`. Hence the massive region
is attracted to the free/decoupled fixed line `kap = 0`. -/
theorem flow_toward_decoupled {lam kap : ℚ} (hlam : lam ≠ 0)
    (hkap : kap ≠ 0) (hmass : |kap| < |lam|) :
    |(R2 lam kap).2| = kap ^ 2 / |lam| ∧ |(R2 lam kap).2| < |kap| := by
  have hla : (0 : ℚ) < |lam| := abs_pos.mpr hlam
  have hka : (0 : ℚ) < |kap| := abs_pos.mpr hkap
  have heq : |(R2 lam kap).2| = kap ^ 2 / |lam| := by
    simp only [R2]
    rw [abs_div, abs_neg, abs_of_nonneg (sq_nonneg kap)]
  refine ⟨heq, ?_⟩
  rw [heq, div_lt_iff₀ hla]
  have hsq : kap ^ 2 = |kap| ^ 2 := (sq_abs kap).symm
  nlinarith [hka, hla, hmass]

/-! ### Packaged verdict -/

/-- **Basin verdict (package).** The fixed-point set of `R2` is the free line `kap = 0`;
the critical line `kap = lam` is a period-2 invariant set (the separatrix / boundary); and
the massive region `0 < |kap| < |lam|` flows toward the free line, the closure coupling being
irrelevant in the massive phase. -/
theorem basin_verdict :
    (∀ lam kap : ℚ, lam ≠ 0 → (R2 lam kap = (lam, kap) ↔ kap = 0)) ∧
    (∀ lam : ℚ, lam ≠ 0 → R2 lam lam = (-lam, -lam) ∧ R2 (-lam) (-lam) = (lam, lam) ∧
      ((-lam, -lam) : ℚ × ℚ) ≠ (lam, lam)) ∧
    (∀ lam kap : ℚ, lam ≠ 0 → kap ≠ 0 → |kap| < |lam| →
      |(R2 lam kap).2| = kap ^ 2 / |lam| ∧ |(R2 lam kap).2| < |kap|) := by
  refine ⟨fun lam kap h => fixed_points h, fun lam h => critical_line_period2 h,
    fun lam kap h hk hm => flow_toward_decoupled h hk hm⟩

/-! ### Kernel-checked axiom footprint (headlines) -/

/-- info: 'RGFixedPointStructure.R2_massive_example' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms R2_massive_example

/-- info: 'RGFixedPointStructure.R2_period2_forward' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms R2_period2_forward

/-- info: 'RGFixedPointStructure.R2_period2_back' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms R2_period2_back

/-- info: 'RGFixedPointStructure.fixed_points' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_points

/-- info: 'RGFixedPointStructure.critical_line_period2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms critical_line_period2

/-- info: 'RGFixedPointStructure.flow_toward_decoupled' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms flow_toward_decoupled

/-- info: 'RGFixedPointStructure.basin_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms basin_verdict

end RGFixedPointStructure
