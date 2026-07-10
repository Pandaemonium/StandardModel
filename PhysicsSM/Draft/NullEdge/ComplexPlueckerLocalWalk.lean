import PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge
import PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

/-!
# Local 3+1 walk with the complex Pluecker-derived mass coin

This module inserts the phase-retaining `massCoin4 z` into the actual finite
position-space successive-axis walk.  The resulting update preserves the
finite inner product exactly, and every product plane-wave sector is invariant
with the ordered axis-0/axis-1/axis-2/complex-mass block.

This closes the operator-to-local-walk composition.  A compact `O(1/n)` rate
for complex `z` still requires transporting the real-mass estimate through the
chiral phase conjugacy (or reproving the one-step estimate directly).
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.ComplexPlueckerLocalWalk

abbrev Mat4 := SuccessiveAxisDiracWalk.Mat4
abbrev State (L : Nat) := SuccessiveAxisPositionWalk.State L
abbrev Position (L : Nat) := SuccessiveAxisPositionWalk.Position L
abbrev Vec4 := Finite3Plus1FourierBridge.Vec4

/-- Membership in the matrix unitary group supplies the two-sided unitarity
packet used by the finite position-walk API. -/
theorem massCoin4_isUnitary (z : Complex) (hz : z ≠ 0) (eps : Real) :
    SuccessiveAxisDiracWalk.IsUnitary
      (Pluecker3Plus1ComplexMass.massCoin4 z eps) := by
  have hmem := (Pluecker3Plus1ComplexMass.massCoin4_unitary_group
    z hz eps 0).1
  exact ⟨Matrix.mem_unitaryGroup_iff'.mp hmem,
    Matrix.mem_unitaryGroup_iff.mp hmem⟩

/-- Local finite-torus update with the complex Pluecker-derived mass coin. -/
def complexLocalStep {L : Nat} (z : Complex) (eps : Real)
    (psi : State L) : State L :=
  CliffordDiagonalPositionBridge.cliffordAxisShift 0
    (CliffordDiagonalPositionBridge.cliffordAxisShift 1
      (CliffordDiagonalPositionBridge.cliffordAxisShift 2
        (SuccessiveAxisPositionWalk.pointwiseCoin
          (Pluecker3Plus1ComplexMass.massCoin4 z eps) psi)))

/-- The phase-retaining local walk preserves the finite inner product exactly. -/
theorem complexLocalStep_preserves_norm {L : Nat} [NeZero L]
    (z : Complex) (hz : z ≠ 0) (eps : Real) (psi : State L) :
    SuccessiveAxisPositionWalk.inner (complexLocalStep z eps psi)
        (complexLocalStep z eps psi) =
      SuccessiveAxisPositionWalk.inner psi psi := by
  unfold complexLocalStep
  rw [CliffordDiagonalPositionBridge.cliffordAxisShift_inner,
    CliffordDiagonalPositionBridge.cliffordAxisShift_inner,
    CliffordDiagonalPositionBridge.cliffordAxisShift_inner,
    SuccessiveAxisPositionWalk.pointwiseCoin_inner]
  exact massCoin4_isUnitary z hz eps

/-- Exact finite-character symbol of the complex-mass local update. -/
def complexFiniteLocalSymbol {L : Nat} [NeZero L]
    (z : Complex) (eps : Real) (k : Position L) : Mat4 :=
  Finite3Plus1FourierBridge.finiteAxisSymbol 0 k *
    Finite3Plus1FourierBridge.finiteAxisSymbol 1 k *
      Finite3Plus1FourierBridge.finiteAxisSymbol 2 k *
        Pluecker3Plus1ComplexMass.massCoin4 z eps

/-- Every finite product plane wave remains an exact invariant sector after
the scalar mass coin is replaced by the complex Pluecker-derived coin. -/
theorem complexLocalStep_mode {L : Nat} [NeZero L]
    (z : Complex) (eps : Real) (k : Position L) (v : Vec4) :
    complexLocalStep z eps (Finite3Plus1FourierBridge.modeState k v) =
      Finite3Plus1FourierBridge.modeState k
        ((complexFiniteLocalSymbol z eps k).mulVec v) := by
  unfold complexLocalStep complexFiniteLocalSymbol
  rw [Finite3Plus1FourierBridge.pointwiseCoin_mode,
    Finite3Plus1FourierBridge.cliffordAxisShift_mode,
    Finite3Plus1FourierBridge.cliffordAxisShift_mode,
    Finite3Plus1FourierBridge.cliffordAxisShift_mode]
  rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec]

end PhysicsSM.Draft.NullEdge.ComplexPlueckerLocalWalk

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ComplexPlueckerLocalWalk.complexLocalStep_preserves_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ComplexPlueckerLocalWalk.complexLocalStep_preserves_norm

/-- info: 'PhysicsSM.Draft.NullEdge.ComplexPlueckerLocalWalk.complexLocalStep_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ComplexPlueckerLocalWalk.complexLocalStep_mode
