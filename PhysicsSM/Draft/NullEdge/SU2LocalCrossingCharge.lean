import Mathlib

/-!
# Exact local crossing charge for a two-component Weyl block

For a nondegenerate two-band crossing, the local orientation is represented by
the real `3 x 3` Jacobian of the three Pauli coefficients. This draft module
packages its exact sign and verifies opposite-orientation and singular fixtures.

It does not prove a global degree or charge-sum theorem. In particular, the
two fixtures below model the two globally split Weyl sectors of a Dirac tangent;
they do not assign a nonzero charge to the complete four-component block.

Provenance: clean-room finite formulation of the Jacobian-sign local Weyl
charge described in the corrected strict-3+1 program memo. The Floquet global
charge comparison is discussed separately in Bessho-Sato, arXiv:2006.04204,
and is not imported here.
-/

namespace PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge

abbrev J3 := Matrix (Fin 3) (Fin 3) Real

/-- Exact local charge of a supplied crossing Jacobian. Singular crossings have
charge zero and lie outside the nondegenerate Weyl class. -/
noncomputable def localCrossingCharge (J : J3) : Int :=
  if 0 < J.det then 1 else if J.det < 0 then -1 else 0

/-- Positive determinant gives positive local orientation. -/
theorem localCrossingCharge_eq_one (J : J3) (h : 0 < J.det) :
    localCrossingCharge J = 1 := by
  simp [localCrossingCharge, h]

/-- Negative determinant gives negative local orientation. -/
theorem localCrossingCharge_eq_neg_one (J : J3) (h : J.det < 0) :
    localCrossingCharge J = -1 := by
  simp [localCrossingCharge, h, not_lt.mpr h.le]

/-- A singular crossing has no nondegenerate local charge. -/
theorem localCrossingCharge_eq_zero (J : J3) (h : J.det = 0) :
    localCrossingCharge J = 0 := by
  simp [localCrossingCharge, h]

/-- The charge is nonzero exactly for a nondegenerate Jacobian. -/
theorem localCrossingCharge_ne_zero_iff (J : J3) :
    localCrossingCharge J ≠ 0 ↔ J.det ≠ 0 := by
  by_cases hp : 0 < J.det
  · simp [localCrossingCharge, hp, ne_of_gt hp]
  by_cases hn : J.det < 0
  · simp [localCrossingCharge, hp, hn, ne_of_lt hn]
  · have hz : J.det = 0 := le_antisymm (not_lt.mp hp) (not_lt.mp hn)
    simp [localCrossingCharge, hz]

/-- The positive-orientation unit Weyl tangent. -/
def weylPlusJacobian : J3 := 1

/-- An opposite-orientation unit Weyl tangent, obtained by reversing one axis. -/
def weylMinusJacobian : J3 :=
  Matrix.diagonal ![(-1 : Real), 1, 1]

/-- A collapsed control with no third independent Pauli direction. -/
def singularControlJacobian : J3 :=
  Matrix.diagonal ![(1 : Real), 1, 0]

theorem weylPlusJacobian_det : weylPlusJacobian.det = 1 := by
  simp [weylPlusJacobian]

theorem weylMinusJacobian_det : weylMinusJacobian.det = -1 := by
  simp [weylMinusJacobian, Matrix.det_diagonal, Fin.prod_univ_succ]

theorem singularControlJacobian_det : singularControlJacobian.det = 0 := by
  simp [singularControlJacobian, Matrix.det_diagonal, Fin.prod_univ_succ]

/-- Exact positive charge of the first Weyl orientation. -/
theorem weylPlus_charge : localCrossingCharge weylPlusJacobian = 1 := by
  apply localCrossingCharge_eq_one
  rw [weylPlusJacobian_det]
  norm_num

/-- Exact negative charge of the opposite Weyl orientation. -/
theorem weylMinus_charge : localCrossingCharge weylMinusJacobian = -1 := by
  apply localCrossingCharge_eq_neg_one
  rw [weylMinusJacobian_det]
  norm_num

/-- The two Weyl-sector fixtures cancel in the complete Dirac block. -/
theorem diracSectorCharges_cancel :
    localCrossingCharge weylPlusJacobian +
      localCrossingCharge weylMinusJacobian = 0 := by
  rw [weylPlus_charge, weylMinus_charge]
  norm_num

/-- Singular-tangent negative control. -/
theorem singularControl_charge :
    localCrossingCharge singularControlJacobian = 0 := by
  apply localCrossingCharge_eq_zero
  exact singularControlJacobian_det

end PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge
