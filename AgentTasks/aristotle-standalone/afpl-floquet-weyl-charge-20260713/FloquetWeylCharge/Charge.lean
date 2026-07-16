import Mathlib

/-!
# Local orientation charge for a three-dimensional Weyl crossing

This focused target isolates the finite differential-topology rung needed by
the anomalous-Floquet route.  A linearized two-band crossing has three Pauli
coefficients.  Their `3 x 3` Jacobian is nondegenerate exactly when its
determinant is nonzero, and its local Weyl charge is the determinant sign.

The target proves the normalization witness and the transformation laws that
prevent a basis convention from silently changing the charge.
-/

noncomputable section

namespace FloquetWeylCharge

open Matrix

abbrev Jac := Matrix (Fin 3) (Fin 3) Real

def OrientationPositive (A : Jac) : Prop := 0 < A.det

def OrientationNegative (A : Jac) : Prop := A.det < 0

def Nondegenerate (A : Jac) : Prop := A.det ≠ 0

/-- The canonical Pauli tangent has positive local Weyl charge. -/
theorem canonical_positive : OrientationPositive (1 : Jac) := by
  simp [OrientationPositive]

/-- A nonzero positive charge is a genuinely isolated linear crossing. -/
theorem positive_nondegenerate {A : Jac} (hA : OrientationPositive A) :
    Nondegenerate A := by
  exact ne_of_gt hA

/-- Proper changes of momentum and Pauli frames preserve positive charge. -/
theorem positive_mul_of_det_one {A R S : Jac}
    (hA : OrientationPositive A) (hR : R.det = 1) (hS : S.det = 1) :
    OrientationPositive (R * A * S) := by
  simpa [OrientationPositive, Matrix.det_mul, hR, hS] using hA

/-- A single orientation-reversing frame change flips the charge. -/
theorem negative_mul_of_left_reflection {A R : Jac}
    (hA : OrientationPositive A) (hR : R.det = -1) :
    OrientationNegative (R * A) := by
  simp only [OrientationNegative, Matrix.det_mul, hR]
  change 0 < A.det at hA
  linarith

/-- Positive rescaling of the tangent cannot change its charge. -/
theorem positive_smul {A : Jac} (hA : OrientationPositive A)
    {c : Real} (hc : 0 < c) : OrientationPositive (c • A) := by
  rw [OrientationPositive, Matrix.det_smul]
  exact mul_pos (pow_pos hc _) hA

/-- info: 'FloquetWeylCharge.positive_mul_of_det_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_mul_of_det_one

/-- info: 'FloquetWeylCharge.negative_mul_of_left_reflection' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms negative_mul_of_left_reflection

/-- info: 'FloquetWeylCharge.positive_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_smul

end FloquetWeylCharge
