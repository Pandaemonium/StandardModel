import PhysicsSM.Draft.NullEdge.VariablePlueckerLocalWalk

/-!
# Local Pluecker phase as an induced connection

A site-dependent chiral phase rotates the complex Pluecker field and, because
spatial translation compares different sites, induces endpoint link matrices
on every Clifford shift.  This module proves the exact finite conjugacy.  It
uses a supplied real phase field and therefore remains valid at zeros of the
Pluecker field; no polar argument or branch choice is used.

The construction is an exact finite gauge-covariance identity.  It does not
claim that the phase field is dynamically selected, that every link field is
pure gauge, or that its winding already equals an analytic index.

Provenance: clean-room finite conjugation using the local walk in
`VariablePlueckerLocalWalk` and the chiral covariance in
`Pluecker3Plus1ComplexMass`.  Lean 4.28.0.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.VariablePlueckerPhaseConnection

open PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk
open PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk
open PhysicsSM.Draft.NullEdge.VariablePlueckerLocalWalk
open PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

abbrev Mat4 := SuccessiveAxisDiracWalk.Mat4
abbrev Position (L : Nat) := SuccessiveAxisPositionWalk.Position L
abbrev State (L : Nat) := SuccessiveAxisPositionWalk.State L
abbrev PhaseField (L : Nat) := Position L -> Real
abbrev PlueckerField (L : Nat) := Position L -> Complex

/-- Pointwise rotation of the Pluecker field by a supplied phase. -/
def rotateField {L : Nat} (theta : PhaseField L) (z : PlueckerField L) :
    PlueckerField L :=
  fun p => Complex.exp (I * theta p) * z p

/-- Chiral basis change at each lattice site. -/
def chiralField {L : Nat} (theta : PhaseField L) (psi : State L) : State L :=
  sitewiseCoin (fun p => chiralUnitary (theta p)) psi

/-- Pointwise inverse chiral basis change. -/
def inverseChiralField {L : Nat} (theta : PhaseField L)
    (psi : State L) : State L :=
  sitewiseCoin (fun p => (chiralUnitary (theta p))ᴴ) psi

theorem chiralField_after_inverse {L : Nat} (theta : PhaseField L)
    (psi : State L) :
    chiralField theta (inverseChiralField theta psi) = psi := by
  exact sitewiseCoin_after_conjTranspose _
    (fun p => chiralUnitary_is_unitary (theta p)) psi

theorem inverseChiralField_after {L : Nat} (theta : PhaseField L)
    (psi : State L) :
    inverseChiralField theta (chiralField theta psi) = psi := by
  exact sitewiseCoin_conjTranspose_after _
    (fun p => chiralUnitary_is_unitary (theta p)) psi

/-- Exact covariance of the normalized mass coin, including `z = 0`. -/
theorem massCoin4_phase_covariance (z : Complex) (theta eps : Real) :
    chiralUnitary theta * massCoin4 z eps * (chiralUnitary theta)ᴴ =
      massCoin4 (Complex.exp (I * theta) * z) eps := by
  have hnorm : ‖Complex.exp (I * theta) * z‖ = ‖z‖ := by
    rw [norm_mul, Complex.norm_exp]
    simp
  unfold massCoin4
  rw [hnorm]
  simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul,
    Matrix.smul_mul, Matrix.mul_assoc]
  have hunit : chiralUnitary theta * (chiralUnitary theta)ᴴ = 1 := by
    exact Matrix.mem_unitaryGroup_iff.mp (chiralUnitary_is_unitary theta)
  rw [Matrix.one_mul, hunit]
  rw [← Matrix.mul_assoc]
  rw [complex_phase_covariance]

/-- Conjugating one spatial shift by a local chiral field produces the exact
endpoint-linked shift. -/
def gaugedCliffordAxisShift {L : Nat} (theta : PhaseField L) (axis : Axis)
    (psi : State L) : State L :=
  chiralField theta
    (CliffordDiagonalPositionBridge.cliffordAxisShift axis
      (inverseChiralField theta psi))

/-- Pointwise endpoint formula for the induced link: the target carries
`G(theta p)`, while channel `a` carries `G(theta source)^*` at its actual
one-step source. -/
theorem gaugedCliffordAxisShift_apply {L : Nat}
    (theta : PhaseField L) (axis : Axis) (psi : State L) (p : Position L) :
    gaugedCliffordAxisShift theta axis psi p =
      (chiralUnitary (theta p)).mulVec
        ((CliffordDiagonalPositionBridge.axisBasis axis).mulVec
          (fun a =>
            (((CliffordDiagonalPositionBridge.axisBasis axis)ᴴ).mulVec
              (((chiralUnitary
                (theta (sourcePosition tetraVelocity axis a p)))ᴴ).mulVec
                (psi (sourcePosition tetraVelocity axis a p)))) a)) := by
  rfl

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
  have hconj : B * D * Bᴴ = A :=
    CliffordDiagonalPositionBridge.axisBasis_conjugates_velocity axis
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
  have hCA : C * A = A * C :=
    chiralUnitary_commutes_generator theta axis
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
  rw [pointwiseCoin_comp, hCB, <- pointwiseCoin_comp]
  dsimp [U]
  rw [<- conditionalShift_conjugatedChiral L theta axis]
  rw [pointwiseCoin_comp, hUB, <- pointwiseCoin_comp]

/-- A constant chiral phase induces no endpoint link on a Clifford shift. -/
theorem gaugedCliffordAxisShift_constant {L : Nat} (theta : Real)
    (axis : Axis) (psi : State L) :
    gaugedCliffordAxisShift (fun _ => theta) axis psi =
      CliffordDiagonalPositionBridge.cliffordAxisShift axis psi := by
  unfold gaugedCliffordAxisShift
  rw [chiralField_constant_commutes_cliffordAxisShift,
    chiralField_after_inverse]

/-- Full locally linked walk after rotating the Pluecker field. -/
def gaugedVariableComplexLocalStep {L : Nat}
    (theta : PhaseField L) (z : PlueckerField L) (eps : Real)
    (psi : State L) : State L :=
  gaugedCliffordAxisShift theta 0
    (gaugedCliffordAxisShift theta 1
      (gaugedCliffordAxisShift theta 2
        (sitewiseCoin (fun p => massCoin4 (z p) eps) psi)))

theorem chiralField_coin_conjugacy {L : Nat}
    (theta : PhaseField L) (z : PlueckerField L) (eps : Real)
    (psi : State L) :
    chiralField theta
        (sitewiseCoin (fun p => massCoin4 (z p) eps)
          (inverseChiralField theta psi)) =
      sitewiseCoin (fun p => massCoin4 (rotateField theta z p) eps) psi := by
  ext p a
  simp only [chiralField, inverseChiralField, sitewiseCoin,
    Matrix.mulVec_mulVec]
  rw [← Matrix.mul_assoc]
  rw [massCoin4_phase_covariance]
  rfl

theorem coin_inverse_conjugacy {L : Nat}
    (theta : PhaseField L) (z : PlueckerField L) (eps : Real)
    (psi : State L) :
    sitewiseCoin (fun p => massCoin4 (z p) eps)
        (inverseChiralField theta psi) =
      inverseChiralField theta
        (sitewiseCoin (fun p => massCoin4 (rotateField theta z p) eps) psi) := by
  have h := congrArg (inverseChiralField theta)
    (chiralField_coin_conjugacy theta z eps psi)
  rw [inverseChiralField_after] at h
  exact h

/-- **Exact local phase/connection covariance.**  Conjugating the complete
inhomogeneous walk by a site-dependent chiral field rotates `z` pointwise and
inserts the induced endpoint link into each spatial shift. -/
theorem local_phase_connection_covariance {L : Nat}
    (theta : PhaseField L) (z : PlueckerField L) (eps : Real)
    (psi : State L) :
    chiralField theta
        (variableComplexLocalStep z eps (inverseChiralField theta psi)) =
      gaugedVariableComplexLocalStep theta (rotateField theta z) eps psi := by
  unfold variableComplexLocalStep gaugedVariableComplexLocalStep
  unfold gaugedCliffordAxisShift
  rw [inverseChiralField_after, inverseChiralField_after]
  rw [coin_inverse_conjugacy]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePlueckerPhaseConnection.massCoin4_phase_covariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massCoin4_phase_covariance

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePlueckerPhaseConnection.local_phase_connection_covariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms local_phase_connection_covariance

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePlueckerPhaseConnection.gaugedCliffordAxisShift_constant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gaugedCliffordAxisShift_constant

end PhysicsSM.Draft.NullEdge.VariablePlueckerPhaseConnection
