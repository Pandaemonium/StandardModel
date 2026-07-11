import PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction

/-!
# The Pluecker quartic transfer is not a one-body CAR generator

The standard number-preserving one-body generator on finite occupation Fock
space has the form

`sum i j, A i j * create i (annihilate j psi)`.

Such a term changes at most one occupied mode. Consequently it has zero matrix
element between the disjoint pairs `{2,3}` and `{0,1}`. The Hermitian Pluecker
quartic transfer has exactly the nonzero unit-phase matrix element between
those pairs. This proves that no one-particle matrix produces the displayed
quartic generator.

This is a finite, fixed-basis two-body certificate. It does not prove spatial
locality, identify the kick as a continuous-time exponential, compute a
scattering amplitude, or exclude general fermionic Gaussian transformations.

Provenance: theorem designed locally after hostile audit project
`4204b732-02bb-404d-8d21-e28410fc1ece` distinguished one-particle exterior
evolution `Gamma(U)` from a one-body CAR generator. Lean 4.28.0.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.PlueckerQuarticNotOneBody

open PlueckerQuarticInteraction FiniteCARFockBasic

/-- The standard number-preserving one-body CAR generator. -/
def oneBodyGenerator (A : Matrix (Fin 4) (Fin 4) Complex)
    (psi : Fock (Fin 4)) : Fock (Fin 4) := fun S =>
  ∑ i : Fin 4, ∑ j : Fin 4, A i j * create i (annihilate j psi) S

/-- A one-body generator cannot replace both occupied modes of the displayed
high pair by the disjoint low pair in one application. -/
theorem oneBodyGenerator_high_to_low_zero
    (A : Matrix (Fin 4) (Fin 4) Complex) :
    oneBodyGenerator A (basisVec highPair) lowPair = 0 := by
  simp only [oneBodyGenerator, Fin.sum_univ_four]
  simp +decide [basisVec, lowPair, create, annihilate, opSign, belowCount]

/-- The unit-phase Pluecker quartic transfer is not any number-preserving
one-body CAR generator. -/
theorem witnessQuartic_not_oneBodyGenerator :
    ¬ ∃ A : Matrix (Fin 4) (Fin 4) Complex,
      ∀ psi, quarticPairTransfer witnessUnitPhase psi = oneBodyGenerator A psi := by
  rintro ⟨A, hA⟩
  have h := congrFun (hA (basisVec highPair)) lowPair
  simp only [highPair, lowPair] at h
  have hzero := oneBodyGenerator_high_to_low_zero A
  simp only [highPair, lowPair] at hzero
  rw [quarticPairTransfer_forward_amplitude, hzero] at h
  exact witnessUnitPhase_ne_zero h

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticNotOneBody.oneBodyGenerator_high_to_low_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms oneBodyGenerator_high_to_low_zero

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerQuarticNotOneBody.witnessQuartic_not_oneBodyGenerator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witnessQuartic_not_oneBodyGenerator

end PhysicsSM.Draft.NullEdge.PlueckerQuarticNotOneBody
