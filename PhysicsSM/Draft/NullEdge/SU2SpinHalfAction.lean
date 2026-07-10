import PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber

/-!
# The defining SU(2) spin-half action

The determinant-fixed factorization fiber landed as an `SU(2)` matrix orbit.
This module supplies its defining action on two-component complex spinors,
proves the representation law and Hermitian-inner-product invariance, and
checks the nontrivial quarter-turn whose square is `-I` and fourth power is
`I`.

This is the finite spin-half representation rung. It does not identify a
particular constraint-cohomology class as a particle, construct Wigner
rotations, or prove spin-statistics.

Provenance: theorem shapes checked against PhysLean's Weyl-spinor and invariant
inner-product APIs; proof completed by Aristotle project
`adb502b2-1c4b-4b5b-a2dd-4513c5e2fc4d` and connected here to the landed
factorization-fiber rotation.
-/

open Matrix Complex
open scoped ComplexOrder

namespace PhysicsSM.Draft.NullEdge.SU2SpinHalfAction

open PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber

abbrev Spinor := Fin 2 -> ℂ

/-- A proposition-level form of membership in the special unitary group. -/
def IsSU2 (U : Mat2) : Prop := Uᴴ * U = 1 ∧ U.det = 1

noncomputable def spinAction (U : Mat2) (psi : Spinor) : Spinor := U *ᵥ psi

noncomputable def spinInner (psi phi : Spinor) : ℂ :=
  dotProduct (star psi) phi

theorem isSU2_iff_mem_specialUnitaryGroup (U : Mat2) :
    IsSU2 U ↔ U ∈ Matrix.specialUnitaryGroup (Fin 2) ℂ := by
  rw [Matrix.mem_specialUnitaryGroup_iff]
  constructor
  · intro h
    exact ⟨Matrix.mem_unitaryGroup_iff'.2 h.1, h.2⟩
  · intro h
    exact ⟨Matrix.mem_unitaryGroup_iff'.1 h.1, h.2⟩

theorem isSU2_one : IsSU2 (1 : Mat2) := by
  simp [IsSU2]

theorem isSU2_mul {U V : Mat2} (hU : IsSU2 U) (hV : IsSU2 V) :
    IsSU2 (U * V) := by
  simp_all +decide [Matrix.mul_assoc, IsSU2]
  simp +decide [← mul_assoc, hU.1, hV.1]

/-- Matrix multiplication gives the defining two-dimensional representation. -/
theorem spinAction_mul (U V : Mat2) (psi : Spinor) :
    spinAction (U * V) psi = spinAction U (spinAction V psi) := by
  unfold spinAction
  aesop

/-- The defining spin-half action preserves the Hermitian inner product. -/
theorem spinInner_preserved {U : Mat2} (hU : IsSU2 U) (psi phi : Spinor) :
    spinInner (spinAction U psi) (spinAction U phi) = spinInner psi phi := by
  convert congr_arg (fun x : Spinor => dotProduct (star psi) x)
    (show Uᴴ *ᵥ (U *ᵥ phi) = phi from ?_) using 1
  · unfold spinInner spinAction
    simp +decide [Matrix.mulVec, dotProduct]
    ring
  · simp_all +decide [IsSU2]

/-- Every determinant-fixed unitary factor acts by an inner-product-preserving
spin-half transformation. -/
theorem special_unitary_spinInner_preserved
    {U : Mat2} (hU : U ∈ Matrix.specialUnitaryGroup (Fin 2) ℂ)
    (psi phi : Spinor) :
    spinInner (spinAction U psi) (spinAction U phi) = spinInner psi phi := by
  exact spinInner_preserved ((isSU2_iff_mem_specialUnitaryGroup U).2 hU) psi phi

def up : Spinor := ![1, 0]

/-- The already-landed nontrivial factor-fiber rotation realizes the defining
spin-half double-cover control. -/
theorem factor_fiber_spin_half_witness :
    IsSU2 witnessRotation ∧ spinAction witnessRotation up ≠ up ∧
      witnessRotation ^ 2 = -(1 : Mat2) ∧ witnessRotation ^ 4 = 1 := by
  refine ⟨(isSU2_iff_mem_specialUnitaryGroup witnessRotation).2
      witness_rotation_special_unitary, ?_, ?_, ?_⟩
  · exact ne_of_apply_ne (fun x => x 1)
      (by norm_num [up, witnessRotation, spinAction])
  · ext i j
    fin_cases i <;> fin_cases j <;> norm_num [sq, witnessRotation]
  · ext i j
    fin_cases i <;> fin_cases j <;> norm_num [pow_succ, witnessRotation]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SU2SpinHalfAction.spinInner_preserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spinInner_preserved

/-- info: 'PhysicsSM.Draft.NullEdge.SU2SpinHalfAction.special_unitary_spinInner_preserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms special_unitary_spinInner_preserved

/-- info: 'PhysicsSM.Draft.NullEdge.SU2SpinHalfAction.factor_fiber_spin_half_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms factor_fiber_spin_half_witness

end PhysicsSM.Draft.NullEdge.SU2SpinHalfAction
