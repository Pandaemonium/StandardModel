import PhysicsSM.Draft.NullEdge.VariablePlueckerPhaseConnection

/-!
# Constant phase gives the ungauged Clifford shift

This scratch theorem checks that the endpoint link induced by
`gaugedCliffordAxisShift` is trivial when the phase field is constant.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.VariablePlueckerPhaseConnection

open PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk
open PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk
open PhysicsSM.Draft.NullEdge.VariablePlueckerLocalWalk
open PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

private theorem pointwiseCoin_comp {L : Nat} (U V : Mat4) (psi : State L) :
    pointwiseCoin U (pointwiseCoin V psi) = pointwiseCoin (U * V) psi := by
  ext p a
  simp [pointwiseCoin, Matrix.mulVec_mulVec]

private theorem chiralUnitary_commutes_generator (theta : Real) (axis : Axis) :
    chiralUnitary theta * CliffordDiagonalPositionBridge.generator axis =
      CliffordDiagonalPositionBridge.generator axis * chiralUnitary theta := by
  fin_cases axis
  · exact chiralUnitary_commutes_spatial theta 0
  · exact chiralUnitary_commutes_spatial theta 1
  · exact chiralUnitary_commutes_spatial theta 2

private theorem conjugatedChiral_commutes_velocityDiag (theta : Real)
    (axis : Axis) :
    ((CliffordDiagonalPositionBridge.axisBasis axis)ᴴ * chiralUnitary theta *
          CliffordDiagonalPositionBridge.axisBasis axis) *
        CliffordDiagonalPositionBridge.velocityDiag axis =
      CliffordDiagonalPositionBridge.velocityDiag axis *
        ((CliffordDiagonalPositionBridge.axisBasis axis)ᴴ *
          chiralUnitary theta * CliffordDiagonalPositionBridge.axisBasis axis) := by
  let B := CliffordDiagonalPositionBridge.axisBasis axis
  let D := CliffordDiagonalPositionBridge.velocityDiag axis
  let A := CliffordDiagonalPositionBridge.generator axis
  let C := chiralUnitary theta
  have hunit := CliffordDiagonalPositionBridge.axisBasis_unitary axis
  have hconj : B * D * Bᴴ = A := by
    exact CliffordDiagonalPositionBridge.axisBasis_conjugates_velocity axis
  have hBD : B * D = A * B := by
    calc
      B * D = (B * D) * (Bᴴ * B) := by rw [hunit.1, Matrix.mul_one]
      _ = (B * D * Bᴴ) * B := by simp only [Matrix.mul_assoc]
      _ = A * B := by rw [hconj]
  have hDB : D * Bᴴ = Bᴴ * A := by
    calc
      D * Bᴴ = (Bᴴ * B) * (D * Bᴴ) := by rw [hunit.1, Matrix.one_mul]
      _ = Bᴴ * (B * D * Bᴴ) := by simp only [Matrix.mul_assoc]
      _ = Bᴴ * A := by rw [hconj]
  have hCA : C * A = A * C := by
    exact chiralUnitary_commutes_generator theta axis
  change (Bᴴ * C * B) * D = D * (Bᴴ * C * B)
  calc
    (Bᴴ * C * B) * D = Bᴴ * C * (B * D) := by
      simp only [Matrix.mul_assoc]
    _ = Bᴴ * C * (A * B) := by rw [hBD]
    _ = Bᴴ * (C * A) * B := by simp only [Matrix.mul_assoc]
    _ = Bᴴ * (A * C) * B := by rw [hCA]
    _ = (Bᴴ * A) * C * B := by simp only [Matrix.mul_assoc]
    _ = (D * Bᴴ) * C * B := by rw [hDB]
    _ = D * (Bᴴ * C * B) := by simp only [Matrix.mul_assoc]

private theorem matrix_entry_zero_of_velocity_ne (axis : Axis) (U : Mat4)
    (hcomm : U * CliffordDiagonalPositionBridge.velocityDiag axis =
      CliffordDiagonalPositionBridge.velocityDiag axis * U)
    (a b : Internal) (hab : tetraVelocity axis a ≠ tetraVelocity axis b) :
    U a b = 0 := by
  have h := congrFun (congrFun hcomm a) b
  cases ha : tetraVelocity axis a <;>
    cases hb : tetraVelocity axis b <;>
    simp [ha, hb] at hab
  all_goals
    simp [CliffordDiagonalPositionBridge.velocityDiag,
      CliffordDiagonalPositionBridge.velocitySign, ha, hb] at h
  all_goals
    simpa only [CharZero.neg_eq_self_iff, CharZero.eq_neg_self_iff] using h

private theorem conditionalShift_conjugatedChiral (L : Nat) (theta : Real)
    (axis : Axis) (psi : State L) :
    conditionalShift tetraVelocity axis
        (pointwiseCoin
          ((CliffordDiagonalPositionBridge.axisBasis axis)ᴴ *
            chiralUnitary theta * CliffordDiagonalPositionBridge.axisBasis axis)
          psi) =
      pointwiseCoin
        ((CliffordDiagonalPositionBridge.axisBasis axis)ᴴ *
          chiralUnitary theta * CliffordDiagonalPositionBridge.axisBasis axis)
        (conditionalShift tetraVelocity axis psi) := by
  ext p a
  simp only [conditionalShift, pointwiseCoin, Matrix.mulVec, dotProduct]
  apply Finset.sum_congr rfl
  intro b _
  by_cases hab : tetraVelocity axis a = tetraVelocity axis b
  · congr 2
    ext j
    simp [sourcePosition, hab]
  · rw [matrix_entry_zero_of_velocity_ne axis _
      (conjugatedChiral_commutes_velocityDiag theta axis) a b hab]
    simp

/-- A spatially constant chiral field commutes with every Clifford shift. -/
private theorem chiralField_constant_commutes_cliffordAxisShift {L : Nat}
    (theta : Real) (axis : Axis) (psi : State L) :
    chiralField (fun _ => theta)
        (CliffordDiagonalPositionBridge.cliffordAxisShift axis psi) =
      CliffordDiagonalPositionBridge.cliffordAxisShift axis
        (chiralField (fun _ => theta) psi) := by
  let B := CliffordDiagonalPositionBridge.axisBasis axis
  let C := chiralUnitary theta
  let U := Bᴴ * C * B
  have hunit := CliffordDiagonalPositionBridge.axisBasis_unitary axis
  have hCB : C * B = B * U := by
    dsimp [U]
    calc
      C * B = (B * Bᴴ) * (C * B) := by rw [hunit.2, Matrix.one_mul]
      _ = B * (Bᴴ * C * B) := by simp only [Matrix.mul_assoc]
  have hUB : U * Bᴴ = Bᴴ * C := by
    dsimp [U]
    calc
      (Bᴴ * C * B) * Bᴴ = Bᴴ * C * (B * Bᴴ) := by
        simp only [Matrix.mul_assoc]
      _ = Bᴴ * C := by rw [hunit.2, Matrix.mul_one]
  change pointwiseCoin C
      (CliffordDiagonalPositionBridge.cliffordAxisShift axis psi) =
    CliffordDiagonalPositionBridge.cliffordAxisShift axis
      (pointwiseCoin C psi)
  unfold CliffordDiagonalPositionBridge.cliffordAxisShift
  rw [pointwiseCoin_comp, hCB, ← pointwiseCoin_comp]
  dsimp [U]
  rw [← conditionalShift_conjugatedChiral L theta axis]
  rw [pointwiseCoin_comp, hUB, ← pointwiseCoin_comp]

/-- A constant chiral phase induces no endpoint link on a Clifford shift. -/
theorem gaugedCliffordAxisShift_constant {L : Nat} (theta : Real)
    (axis : Axis) (psi : State L) :
    gaugedCliffordAxisShift (fun _ => theta) axis psi =
      CliffordDiagonalPositionBridge.cliffordAxisShift axis psi := by
  unfold gaugedCliffordAxisShift
  rw [chiralField_constant_commutes_cliffordAxisShift,
    chiralField_after_inverse]

end PhysicsSM.Draft.NullEdge.VariablePlueckerPhaseConnection
