import Mathlib
import PhysicsSM.Algebra.Octonion.G2HermitianPreservation
import PhysicsSM.Algebra.Octonion.G2C3GUTUnitary

/-!
# Algebra.Octonion.G2FixingE111Determinant

Determinant consequences for `FixingE111MulLinear` maps: the determinant of
`g.onComplexVecMatrix` lies on the complex unit circle (|det|² = 1, det ≠ 0),
and we package it as a unit of `ℂ`.

## Claim boundary

This proves that the determinant lies on the complex unit circle. It does **not**
prove determinant one, `Stab_{G₂}(e111) = SU(3)`, a connectedness theorem, or a
Lie group isomorphism.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Determinant norm and nonzero lemmas -/

/-- The squared complex norm of the determinant of `g.onComplexVecMatrix` is 1. -/
theorem fixingE111MulLinear_det_normSq_eq_one
    (g : FixingE111MulLinear) :
    Complex.normSq g.onComplexVecMatrix.det = 1 :=
  (fixingE111MulLinear_preservesHermitian g).matrixActsUnitary.det_normSq_eq_one

/-- The determinant of `g.onComplexVecMatrix` is nonzero. -/
theorem fixingE111MulLinear_det_ne_zero
    (g : FixingE111MulLinear) :
    Ne g.onComplexVecMatrix.det 0 :=
  (fixingE111MulLinear_preservesHermitian g).matrixActsUnitary.det_ne_zero

/-! ## Determinant as a unit -/

/-- Package the determinant as a unit of `ℂ`. -/
noncomputable def FixingE111MulLinear.detUnit
    (g : FixingE111MulLinear) : Units ℂ := by
  refine Units.mk0 g.onComplexVecMatrix.det ?_
  exact fixingE111MulLinear_det_ne_zero g

@[simp] theorem FixingE111MulLinear.detUnit_val
    (g : FixingE111MulLinear) :
    (g.detUnit : ℂ) = g.onComplexVecMatrix.det := by
  simp [FixingE111MulLinear.detUnit]

theorem FixingE111MulLinear.detUnit_normSq_eq_one
    (g : FixingE111MulLinear) :
    Complex.normSq (g.detUnit : ℂ) = 1 := by
  rw [detUnit_val]
  exact fixingE111MulLinear_det_normSq_eq_one g

/-! ## Bundled package -/

/-- A bundled record of the determinant consequences for `FixingE111MulLinear`. -/
structure G2FixingE111DeterminantPackage where
  det_normSq_one :
    ∀ g : FixingE111MulLinear,
      Complex.normSq g.onComplexVecMatrix.det = 1
  det_ne_zero :
    ∀ g : FixingE111MulLinear,
      Ne g.onComplexVecMatrix.det 0
  det_unit : FixingE111MulLinear → Units ℂ
  det_unit_val :
    ∀ g : FixingE111MulLinear,
      ((det_unit g : Units ℂ) : ℂ) = g.onComplexVecMatrix.det

/-- The canonical `G2FixingE111DeterminantPackage`. -/
noncomputable def g2FixingE111DeterminantPackage :
    G2FixingE111DeterminantPackage where
  det_normSq_one := fixingE111MulLinear_det_normSq_eq_one
  det_ne_zero := fixingE111MulLinear_det_ne_zero
  det_unit := FixingE111MulLinear.detUnit
  det_unit_val := FixingE111MulLinear.detUnit_val

end PhysicsSM.Algebra.Octonion.G2ComplexLine
