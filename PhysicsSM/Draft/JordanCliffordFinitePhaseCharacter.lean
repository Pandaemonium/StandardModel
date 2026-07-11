import PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge

/-!
# Finite additive phase character for the Jordan-Clifford center labels

This module upgrades the finite phase-triviality predicate from
`JordanCliffordSpinorZ6Bridge` to an explicit additive character. The domain is
the finite additive group of `SU(3)`, `SU(2)`, and sixth-root center labels; the
codomain records the phase exponent modulo six on every actual even five-mode
Fock occupation. The character kernel is proved equal to the six standard
powers already linked to the trusted unit-level covering-kernel family.

Scope: this is a finite additive-character theorem for phase exponents. It is
not yet a complex representation of the full continuous covering group, a
Jordan-flag derivation of the weak/color split, or an operator-level statement
about the complete spinor representation.

Provenance: clean-room finite formalization composed from
`JordanCliffordFermionKernel`, `JordanCliffordSpinorZ6Bridge`, and the repository's
trusted covering-kernel package. Kernel evaluation only; no compiled evaluator.
-/

noncomputable section

namespace PhysicsSM.Draft.JordanCliffordFinitePhaseCharacter

open PhysicsSM.Draft.JordanCliffordFermionKernel
open PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge
open PhysicsSM.StandardModel.SpinorFockHypercharge
open PhysicsSM.Gauge.StandardModelSubgroup

/-- Finite labels for the three center factors used in the phase calculation. -/
abbrev CenterLabels := Fin 3 × Fin 2 × Fin 6

/-- Actual even occupations in the five-mode exterior/Fock model. -/
abbrev EvenOccupation := {S : Finset (Fin 5) // S.card % 2 = 0}

/-- The center-label phase exponent modulo six on an even occupation. -/
def phaseValue (t : CenterLabels) (S : EvenOccupation) : ZMod 6 :=
  (centralPhase t.1.val t.2.1.val t.2.2.val
    (weakCount S.1) (colorCount S.1) : Int)

set_option maxHeartbeats 2000000 in
/-- The zero center label has zero phase on every even occupation. -/
theorem phaseValue_zero : phaseValue (0 : CenterLabels) = 0 := by
  decide

set_option maxHeartbeats 2000000 in
/-- Center-label addition becomes pointwise addition of phase exponents. -/
theorem phaseValue_add (t u : CenterLabels) :
    phaseValue (t + u) = phaseValue t + phaseValue u := by
  revert t u
  decide

set_option maxHeartbeats 2000000 in
/-- The finite center labels act on even occupations through an additive phase
character valued in phase-exponent functions modulo six. -/
def phaseCharacter : CenterLabels →+ (EvenOccupation → ZMod 6) where
  toFun := phaseValue
  map_zero' := phaseValue_zero
  map_add' := phaseValue_add

/-- The finite kernel of the explicit additive phase character. -/
def characterKernel : Finset CenterLabels :=
  Finset.univ.filter (fun t => phaseCharacter t = 0)

/-- Membership in the enumerated kernel is exactly vanishing of the additive
phase character. -/
theorem mem_characterKernel_iff (t : CenterLabels) :
    t ∈ characterKernel ↔ phaseCharacter t = 0 := by
  constructor
  · intro h
    exact (Finset.mem_filter.mp h).2
  · intro h
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, h⟩

set_option maxHeartbeats 2000000 in
/-- The additive-character kernel is exactly the earlier phase-triviality
predicate quantified over all actual even occupations. -/
theorem characterKernel_eq_evenFockCentralKernel :
    characterKernel = evenFockCentralKernel := by
  decide

/-- Consequently, the additive-character kernel is exactly the six standard
center powers. -/
theorem characterKernel_eq_standardPowers :
    characterKernel = Finset.univ.image standardKernelPower := by
  rw [characterKernel_eq_evenFockCentralKernel,
    evenFockCentralKernel_eq_standardPowers]

/-- Every element of the additive-character kernel has a unique standard-power
index. The trusted family element at that index has identity covering image;
this image fact holds uniformly across the family and does not itself select
the index or prove equality of kernel types. -/
theorem characterKernel_unique_unitCovering_witness
    (t : CenterLabels) (ht : t ∈ characterKernel) :
    ExistsUnique (fun m : Fin 6 =>
      t = standardKernelPower m ∧
        unitCoveringTripleImageGroupHom
          ((sixUnitCoveringKernelElts m).toUnitCoveringTriple) = 1) := by
  apply evenFockKernel_unique_unitCovering_witness t
  rw [← characterKernel_eq_evenFockCentralKernel]
  exact ht

/-- The standard mixed center generator has zero phase on every even
occupation. -/
theorem standard_generator_character_zero :
    phaseCharacter ((1 : Fin 3), (1 : Fin 2), (1 : Fin 6)) = 0 := by
  rw [← mem_characterKernel_iff]
  rw [characterKernel_eq_evenFockCentralKernel,
    evenFockCentralKernel_eq_fermionCentralKernel]
  exact standard_generator_mem

/-- Near-miss control: removing the compensating `SU(2)` center makes the
phase character nonzero on at least one actual even occupation. -/
theorem missing_su2_character_nonzero :
    phaseCharacter ((1 : Fin 3), (0 : Fin 2), (1 : Fin 6)) ≠ 0 := by
  intro h
  have hmem :
      ((1 : Fin 3), (0 : Fin 2), (1 : Fin 6)) ∈ characterKernel :=
    (mem_characterKernel_iff _).2 h
  rw [characterKernel_eq_evenFockCentralKernel] at hmem
  exact mixed_missing_su2_control_not_mem hmem

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.JordanCliffordFinitePhaseCharacter.phaseValue_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phaseValue_add

/-- info: 'PhysicsSM.Draft.JordanCliffordFinitePhaseCharacter.characterKernel_eq_evenFockCentralKernel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms characterKernel_eq_evenFockCentralKernel

/-- info: 'PhysicsSM.Draft.JordanCliffordFinitePhaseCharacter.characterKernel_eq_standardPowers' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms characterKernel_eq_standardPowers

/-- info: 'PhysicsSM.Draft.JordanCliffordFinitePhaseCharacter.characterKernel_unique_unitCovering_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms characterKernel_unique_unitCovering_witness

/-- info: 'PhysicsSM.Draft.JordanCliffordFinitePhaseCharacter.standard_generator_character_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms standard_generator_character_zero

/-- info: 'PhysicsSM.Draft.JordanCliffordFinitePhaseCharacter.missing_su2_character_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms missing_su2_character_nonzero

end PhysicsSM.Draft.JordanCliffordFinitePhaseCharacter
