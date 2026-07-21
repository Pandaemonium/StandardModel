import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv

/-!
# Determinant criteria for exact Floquet modes

This module isolates the generic linear-algebra bridge needed by all-Bloch
audits.  For a finite square matrix `U`, an exact `+1` (respectively `-1`)
Floquet mode exists exactly when `det (U - 1)` (respectively `det (U + 1)`)
vanishes.  The vector is required to be nonzero.

Keeping this bridge independent of any walk prevents symbolic determinant
expansion from being entangled with Mathlib kernel API search.
-/

namespace PhysicsSM.Draft.NullEdge.FloquetDeterminantCriterion

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {A : Type*} [CommRing A] [IsDomain A]

/-- Exact `+1` Floquet mode iff the shifted determinant vanishes. -/
theorem exists_plus_mode_iff_det_sub_one_eq_zero (U : Matrix n n A) :
    (Exists fun v : n → A => v ≠ 0 ∧ U *ᵥ v = v) ↔
      Matrix.det (U - 1) = 0 := by
  rw [← Matrix.exists_mulVec_eq_zero_iff]
  constructor
  · rintro ⟨v, hv, hUv⟩
    refine ⟨v, hv, ?_⟩
    rw [Matrix.sub_mulVec, hUv]
    simp
  · rintro ⟨v, hv, hker⟩
    refine ⟨v, hv, ?_⟩
    rw [Matrix.sub_mulVec] at hker
    simpa using sub_eq_zero.mp hker

/-- Exact `-1` Floquet mode iff the oppositely shifted determinant vanishes. -/
theorem exists_minus_mode_iff_det_add_one_eq_zero (U : Matrix n n A) :
    (Exists fun v : n → A => v ≠ 0 ∧ U *ᵥ v = -v) ↔
      Matrix.det (U + 1) = 0 := by
  rw [← Matrix.exists_mulVec_eq_zero_iff]
  constructor
  · rintro ⟨v, hv, hUv⟩
    refine ⟨v, hv, ?_⟩
    rw [Matrix.add_mulVec, hUv]
    simp
  · rintro ⟨v, hv, hker⟩
    refine ⟨v, hv, ?_⟩
    rw [Matrix.add_mulVec] at hker
    simpa using eq_neg_of_add_eq_zero_left hker

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetDeterminantCriterion.exists_plus_mode_iff_det_sub_one_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_plus_mode_iff_det_sub_one_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetDeterminantCriterion.exists_minus_mode_iff_det_add_one_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_minus_mode_iff_det_add_one_eq_zero

end PhysicsSM.Draft.NullEdge.FloquetDeterminantCriterion
