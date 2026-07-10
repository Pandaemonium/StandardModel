import PhysicsSM.Draft.NullEdge.ComplexPlueckerLocalWalk
import PhysicsSM.Draft.NullEdge.LocalQCAProperties
import PhysicsSM.Spinor.PluckerMass

/-!
# Position-dependent complex Pluecker mass walk

This module promotes the constant complex Pluecker coordinate to a field on the
finite three-torus.  The existing formula for `massCoin4` is already total at
the collinear point `z = 0`; there it reduces exactly to the identity.  We prove
unitarity and the group law for every `z`, define a sitewise coin field, and
compose it with the live Clifford shifts.

The resulting inhomogeneous update preserves the finite inner product, has an
explicit two-sided inverse, reduces exactly to the landed constant-field walk,
and identifies local coin triviality with local spinor collinearity.

This module does not yet introduce a local polar phase or winding.  Those
require endpoint link conventions and belong in the successor phase-connection
and defect/index modules.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.VariablePlueckerLocalWalk

open PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk
open PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk

abbrev Mat4 := SuccessiveAxisDiracWalk.Mat4
abbrev Position (L : Nat) := SuccessiveAxisPositionWalk.Position L
abbrev State (L : Nat) := SuccessiveAxisPositionWalk.State L
abbrev CSpinor := PhysicsSM.Spinor.PluckerMass.CSpinor
abbrev SpinorField (L : Nat) := Position L → CSpinor
abbrev PlueckerField (L : Nat) := Position L → Complex
abbrev SpaceTimePlueckerField (L : Nat) := Nat → PlueckerField L

/-- Local Pluecker coordinate derived from two spinor fields. -/
def plueckerField {L : Nat} (psi phi : SpinorField L) : PlueckerField L :=
  fun p => PhysicsSM.Spinor.PluckerMass.spinorWedge (psi p) (phi p)

/-- The existing mass coin has the correct continuous value at collinearity. -/
theorem massCoin4_zero (a : Real) :
    Pluecker3Plus1ComplexMass.massCoin4 0 a = (1 : Mat4) := by
  simp [Pluecker3Plus1ComplexMass.massCoin4,
    Pluecker3Plus1ComplexMass.mass4]

/-- Exact unitarity of the mass coin, including the collinear point. -/
theorem massCoin4_isUnitary_total (z : Complex) (a : Real) :
    IsUnitary (Pluecker3Plus1ComplexMass.massCoin4 z a) := by
  by_cases hz : z = 0
  · subst z
    simp [massCoin4_zero, IsUnitary]
  · exact ComplexPlueckerLocalWalk.massCoin4_isUnitary z hz a

/-- Exact one-parameter group law, including the collinear point. -/
theorem massCoin4_group_total (z : Complex) (a b : Real) :
    Pluecker3Plus1ComplexMass.massCoin4 z a *
        Pluecker3Plus1ComplexMass.massCoin4 z b =
      Pluecker3Plus1ComplexMass.massCoin4 z (a + b) := by
  by_cases hz : z = 0
  · subst z
    simp [massCoin4_zero]
  · exact (Pluecker3Plus1ComplexMass.massCoin4_unitary_group z hz a b).2

/-- A matrix field acts without moving position support. -/
def sitewiseCoin {L : Nat} (U : Position L → Mat4) (psi : State L) : State L :=
  fun p => (U p).mulVec (psi p)

/-- A pointwise unitary matrix field preserves the finite inner product. -/
theorem sitewiseCoin_inner {L : Nat} [NeZero L]
    (U : Position L → Mat4) (hU : ∀ p, IsUnitary (U p))
    (psi phi : State L) :
    SuccessiveAxisPositionWalk.inner (sitewiseCoin U psi) (sitewiseCoin U phi) =
      SuccessiveAxisPositionWalk.inner psi phi := by
  unfold SuccessiveAxisPositionWalk.inner sitewiseCoin
  apply Finset.sum_congr rfl
  intro p _
  have hunitary : (U p)ᴴ * U p = 1 := (hU p).1
  have hmove :
      ∑ a, star ((U p *ᵥ psi p) a) * (U p *ᵥ phi p) a =
        ∑ a, star (psi p a) * ((U p)ᴴ *ᵥ (U p *ᵥ phi p)) a := by
    simp +decide [Matrix.mulVec, dotProduct, mul_assoc, mul_comm,
      mul_left_comm, Finset.mul_sum _ _ _]
    exact Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ =>
      Finset.sum_congr rfl fun _ _ =>
        Finset.sum_congr rfl fun _ _ => by ring)
  rw [hmove, Matrix.mulVec_mulVec, hunitary]
  simp

/-- The sitewise adjoint coin is a left inverse. -/
theorem sitewiseCoin_conjTranspose_after {L : Nat}
    (U : Position L → Mat4) (hU : ∀ p, IsUnitary (U p)) (psi : State L) :
    sitewiseCoin (fun p => (U p)ᴴ) (sitewiseCoin U psi) = psi := by
  ext p a
  unfold sitewiseCoin
  rw [Matrix.mulVec_mulVec, (hU p).1]
  simp

/-- The sitewise adjoint coin is also a right inverse. -/
theorem sitewiseCoin_after_conjTranspose {L : Nat}
    (U : Position L → Mat4) (hU : ∀ p, IsUnitary (U p)) (psi : State L) :
    sitewiseCoin U (sitewiseCoin (fun p => (U p)ᴴ) psi) = psi := by
  ext p a
  unfold sitewiseCoin
  rw [Matrix.mulVec_mulVec, (hU p).2]
  simp

/-- Inverse Clifford shift: conjugate the reversed component shift into the
same physical Clifford basis. -/
def inverseCliffordAxisShift {L : Nat} (axis : Axis) (psi : State L) : State L :=
  pointwiseCoin (CliffordDiagonalPositionBridge.axisBasis axis)
    (conditionalShift
      (LocalQCAProperties.reverseVelocity tetraVelocity)
      axis
      (pointwiseCoin ((CliffordDiagonalPositionBridge.axisBasis axis)ᴴ) psi))

/-- The inverse Clifford shift cancels the forward shift on the left. -/
theorem inverseCliffordAxisShift_after {L : Nat} [NeZero L]
    (axis : Axis) (psi : State L) :
    inverseCliffordAxisShift axis
        (CliffordDiagonalPositionBridge.cliffordAxisShift axis psi) = psi := by
  unfold inverseCliffordAxisShift
  unfold CliffordDiagonalPositionBridge.cliffordAxisShift
  rw [LocalQCAProperties.pointwiseCoin_conjTranspose_after _
      (CliffordDiagonalPositionBridge.axisBasis_unitary axis),
    LocalQCAProperties.conditionalShift_reverse_after,
    LocalQCAProperties.pointwiseCoin_after_conjTranspose _
      (CliffordDiagonalPositionBridge.axisBasis_unitary axis)]

/-- The inverse Clifford shift cancels the forward shift on the right. -/
theorem cliffordAxisShift_after_inverse {L : Nat} [NeZero L]
    (axis : Axis) (psi : State L) :
    CliffordDiagonalPositionBridge.cliffordAxisShift axis
        (inverseCliffordAxisShift axis psi) = psi := by
  unfold inverseCliffordAxisShift
  unfold CliffordDiagonalPositionBridge.cliffordAxisShift
  rw [LocalQCAProperties.pointwiseCoin_conjTranspose_after _
      (CliffordDiagonalPositionBridge.axisBasis_unitary axis),
    LocalQCAProperties.conditionalShift_after_reverse,
    LocalQCAProperties.pointwiseCoin_after_conjTranspose _
      (CliffordDiagonalPositionBridge.axisBasis_unitary axis)]

/-- Local update for an arbitrary position-dependent complex Pluecker field. -/
def variableComplexLocalStep {L : Nat} (z : PlueckerField L) (eps : Real)
    (psi : State L) : State L :=
  CliffordDiagonalPositionBridge.cliffordAxisShift 0
    (CliffordDiagonalPositionBridge.cliffordAxisShift 1
      (CliffordDiagonalPositionBridge.cliffordAxisShift 2
        (sitewiseCoin
          (fun p => Pluecker3Plus1ComplexMass.massCoin4 (z p) eps) psi)))

/-- Exact norm preservation for arbitrary profiles, including profiles with
collinear sites. -/
theorem variableComplexLocalStep_preserves_norm {L : Nat} [NeZero L]
    (z : PlueckerField L) (eps : Real) (psi : State L) :
    SuccessiveAxisPositionWalk.inner (variableComplexLocalStep z eps psi)
        (variableComplexLocalStep z eps psi) =
      SuccessiveAxisPositionWalk.inner psi psi := by
  unfold variableComplexLocalStep
  rw [CliffordDiagonalPositionBridge.cliffordAxisShift_inner,
    CliffordDiagonalPositionBridge.cliffordAxisShift_inner,
    CliffordDiagonalPositionBridge.cliffordAxisShift_inner,
    sitewiseCoin_inner]
  intro p
  exact massCoin4_isUnitary_total (z p) eps

/-- Explicit inverse of the inhomogeneous update. -/
def inverseVariableComplexLocalStep {L : Nat} (z : PlueckerField L)
    (eps : Real) (psi : State L) : State L :=
  sitewiseCoin
    (fun p => (Pluecker3Plus1ComplexMass.massCoin4 (z p) eps)ᴴ)
    (inverseCliffordAxisShift 2
      (inverseCliffordAxisShift 1
        (inverseCliffordAxisShift 0 psi)))

theorem inverseVariableComplexLocalStep_after {L : Nat} [NeZero L]
    (z : PlueckerField L) (eps : Real) (psi : State L) :
    inverseVariableComplexLocalStep z eps
        (variableComplexLocalStep z eps psi) = psi := by
  unfold inverseVariableComplexLocalStep variableComplexLocalStep
  rw [inverseCliffordAxisShift_after,
    inverseCliffordAxisShift_after,
    inverseCliffordAxisShift_after,
    sitewiseCoin_conjTranspose_after]
  intro p
  exact massCoin4_isUnitary_total (z p) eps

theorem variableComplexLocalStep_after_inverse {L : Nat} [NeZero L]
    (z : PlueckerField L) (eps : Real) (psi : State L) :
    variableComplexLocalStep z eps
        (inverseVariableComplexLocalStep z eps psi) = psi := by
  unfold inverseVariableComplexLocalStep variableComplexLocalStep
  rw [sitewiseCoin_after_conjTranspose,
    cliffordAxisShift_after_inverse,
    cliffordAxisShift_after_inverse,
    cliffordAxisShift_after_inverse]
  intro p
  exact massCoin4_isUnitary_total (z p) eps

/-- Source maps along the three distinct axes commute.  This identifies the
nesting order produced by the Clifford walk with the established causal-source
API. -/
theorem causalSource_eq_reversed_nesting {L : Nat}
    (p : Position L) (out midZ midY : Internal) :
    LocalQCAProperties.causalSource tetraVelocity p out midZ midY =
      sourcePosition tetraVelocity 2 out
        (sourcePosition tetraVelocity 1 midZ
          (sourcePosition tetraVelocity 0 midY p)) := by
  ext j
  fin_cases j <;>
    simp [LocalQCAProperties.causalSource, sourcePosition]

/-- **Strict one-cycle causal cone.** Basis changes and the inhomogeneous
mass coin mix internal channels only.  Hence an output at `p` can depend only
on inputs reached by one conditional source shift along each spatial axis. -/
theorem variableComplexLocalStep_zero_of_causalSource_zero
    {L : Nat} [NeZero L]
    (z : PlueckerField L) (eps : Real) (psi : State L) (p : Position L)
    (hzero : forall out midZ midY input,
      psi (LocalQCAProperties.causalSource tetraVelocity p out midZ midY)
        input = 0) :
    forall out, variableComplexLocalStep z eps psi p out = 0 := by
  intro out
  simp only [variableComplexLocalStep,
    CliffordDiagonalPositionBridge.cliffordAxisShift,
    SuccessiveAxisPositionWalk.conditionalShift,
    SuccessiveAxisPositionWalk.pointwiseCoin, sitewiseCoin,
    Matrix.mulVec, dotProduct]
  apply Finset.sum_eq_zero
  intro midY _
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro internal0 _
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro midZ _
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro internal1 _
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro sourceOut _
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro internal2 _
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro input _
  apply mul_eq_zero_of_right
  have hz := hzero sourceOut midZ midY input
  rw [causalSource_eq_reversed_nesting] at hz
  exact hz

/-- Constant profiles reduce definitionally to the landed complex local walk. -/
theorem constant_field_reduction {L : Nat} (z : Complex) (eps : Real)
    (psi : State L) :
    variableComplexLocalStep (fun _ => z) eps psi =
      ComplexPlueckerLocalWalk.complexLocalStep z eps psi := by
  rfl

/-- Local Pluecker vanishing is local projective collinearity. -/
theorem plueckerField_zero_iff_collinear {L : Nat}
    (psi phi : SpinorField L) (p : Position L)
    (hpsi : psi p 0 ≠ 0 ∨ psi p 1 ≠ 0) :
    plueckerField psi phi p = 0 ↔ ∃ c : Complex, phi p = c • psi p := by
  exact PhysicsSM.Spinor.PluckerMass.spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
    (psi p) (phi p) hpsi

/-- At a locally collinear site the exact local mass coin is the identity. -/
theorem local_collinearity_coin_identity {L : Nat}
    (psi phi : SpinorField L) (p : Position L) (eps : Real)
    (hcol : plueckerField psi phi p = 0) :
    Pluecker3Plus1ComplexMass.massCoin4 (plueckerField psi phi p) eps = 1 := by
  rw [hcol]
  exact massCoin4_zero eps

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePlueckerLocalWalk.variableComplexLocalStep_preserves_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms variableComplexLocalStep_preserves_norm

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePlueckerLocalWalk.inverseVariableComplexLocalStep_after' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inverseVariableComplexLocalStep_after

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePlueckerLocalWalk.variableComplexLocalStep_zero_of_causalSource_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms variableComplexLocalStep_zero_of_causalSource_zero

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePlueckerLocalWalk.plueckerField_zero_iff_collinear' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plueckerField_zero_iff_collinear

end PhysicsSM.Draft.NullEdge.VariablePlueckerLocalWalk
