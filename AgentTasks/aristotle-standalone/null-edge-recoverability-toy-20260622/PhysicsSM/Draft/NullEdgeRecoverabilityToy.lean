import PhysicsSM.Draft.NullEdgeRelativeEntropyObserverRoadmap

/-!
# Finite recoverability toy witness

Standalone Aristotle target for the next relative-entropy observer-channel
bridge.  The core scaffold already proves finite KL data processing and exact
recoverability saturation.  This file asks for a tiny witness showing that a
non-injective observer can lose information in a strictly positive way.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeRecoverabilityToy

open scoped BigOperators
open PhysicsSM.Draft.NullEdgeRelativeEntropyObserver

/-- Deterministic observer induced by a finite function. -/
def deterministicObs {ι κ : Type*} [Fintype ι] [Fintype κ] [DecidableEq κ]
    (f : ι -> κ) : FinObs ι κ where
  M := fun j i => if f i = j then 1 else 0
  nonneg := by
    intro j i
    by_cases h : f i = j <;> simp [h]
  col_sum_one := by
    intro i
    classical
    sorry

/-- Observer that forgets which of two hidden states occurred. -/
def mergeToUnit : FinObs (Fin 2) (Fin 1) :=
  deterministicObs fun _ => (0 : Fin 1)

/-- Point mass at the first hidden state. -/
def pointMass0 : FinDist (Fin 2) where
  p := fun i => if i = 0 then 1 else 0
  nonneg := by
    intro i
    fin_cases i <;> norm_num
  sum_one := by
    simp [Fin.sum_univ_two]

/-- Fair reference distribution on two hidden states. -/
def fairCoin : FinDist (Fin 2) where
  p := fun _ => (1 / 2 : Real)
  nonneg := by
    intro i
    norm_num
  sum_one := by
    simp [Fin.sum_univ_two]

/-- The point mass is absolutely continuous with respect to the fair coin. -/
theorem pointMass0_absCont_fairCoin : AbsCont pointMass0 fairCoin := by
  intro i h
  norm_num [fairCoin] at h

/-- The merge sends both test distributions to the unique one-point distribution. -/
theorem merge_pushforward_pointMass0_eq_fairCoin :
    pushforward mergeToUnit pointMass0 = pushforward mergeToUnit fairCoin := by
  sorry

/-- Merging the hidden bit has strictly positive observer loss. -/
theorem merge_observerLoss_pos :
    0 < observerLoss mergeToUnit pointMass0 fairCoin := by
  sorry

/-- No recovery channel can exactly recover both distributions after the merge. -/
theorem merge_no_exactRecovery (R : FinObs (Fin 1) (Fin 2)) :
    ¬ ExactRecovery mergeToUnit R pointMass0 fairCoin := by
  sorry

/-- Every recovery candidate has a strictly positive recoverability gap. -/
theorem merge_recoverabilityGap_pos (R : FinObs (Fin 1) (Fin 2)) :
    0 < recoverabilityGap mergeToUnit R pointMass0 fairCoin := by
  sorry

end PhysicsSM.Draft.NullEdgeRecoverabilityToy

end
