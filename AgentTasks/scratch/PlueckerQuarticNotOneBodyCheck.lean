import PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.PlueckerQuarticNotOneBodyCheck

open PlueckerQuarticInteraction FiniteCARFockBasic

def oneBodyGenerator (A : Matrix (Fin 4) (Fin 4) Complex)
    (psi : Fock (Fin 4)) : Fock (Fin 4) := fun S =>
  ∑ i : Fin 4, ∑ j : Fin 4, A i j * create i (annihilate j psi) S

theorem oneBodyGenerator_high_to_low_zero
    (A : Matrix (Fin 4) (Fin 4) Complex) :
    oneBodyGenerator A (basisVec highPair) lowPair = 0 := by
  simp only [oneBodyGenerator, Fin.sum_univ_four]
  simp +decide [basisVec, lowPair, create, annihilate,
    opSign, belowCount]

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

end PhysicsSM.Draft.NullEdge.PlueckerQuarticNotOneBodyCheck
