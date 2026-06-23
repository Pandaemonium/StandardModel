import PhysicsSM.Draft.NullEdgeRelativeEntropyObserverRoadmap

/-!
# Finite recoverability gap and source visibility

Proof targets for the P7 relative-entropy observer-channel recoverability gap.
Ties the recoverability gap to source-visibility/invisibility.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7RecoverabilityGap

open PhysicsSM.Draft.NullEdgeRelativeEntropyObserver

variable {ι κ μ : Type*} [Fintype ι] [Fintype κ] [Fintype μ]

@[ext]
theorem FinDist.ext {ι : Type*} [Fintype ι] {p q : FinDist ι} (h : p.p = q.p) : p = q := by
  cases p; cases q; simp_all

/-- Pushforward of composition is composition of pushforwards. -/
theorem pushforward_comp (S : FinObs κ μ) (T : FinObs ι κ) (d : FinDist ι) :
    pushforward (S.comp T) d = pushforward S (pushforward T d) := by
  ext m
  unfold pushforward applyObs FinObs.comp
  dsimp
  have h_eq : (∑ i, (∑ j, S.M m j * T.M j i) * d.p i) = ∑ j, S.M m j * ∑ i, T.M j i * d.p i := by
    have h_dist : ∀ i, (∑ j, S.M m j * T.M j i) * d.p i = ∑ j, S.M m j * T.M j i * d.p i := by
      intro i
      rw [Finset.sum_mul]
    simp_rw [h_dist]
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun j _ => ?_
    simp_rw [mul_assoc]
    rw [← Finset.mul_sum]
  exact h_eq

/-- If q is absolutely continuous, then so is any pushforward. -/
theorem AbsCont_pushforward (T : FinObs ι κ) {p q : FinDist ι} (hac : AbsCont p q) :
    AbsCont (pushforward T p) (pushforward T q) := by
  intro j hj
  unfold pushforward applyObs at hj
  dsimp at hj
  rw [Finset.sum_eq_zero_iff_of_nonneg (fun i _ => mul_nonneg (T.nonneg j i) (q.nonneg i))] at hj
  unfold pushforward applyObs
  dsimp
  refine Finset.sum_eq_zero fun i hi => ?_
  specialize hj i hi
  by_cases hqi : q.p i = 0
  · rw [hac i hqi, mul_zero]
  · by_cases hT : T.M j i = 0
    · rw [hT, zero_mul]
    · exfalso
      have : 0 < T.M j i * q.p i := mul_pos (lt_of_le_of_ne (T.nonneg j i) (Ne.symm hT)) (lt_of_le_of_ne (q.nonneg i) (Ne.symm hqi))
      linarith

/-- The recoverability gap is always non-negative. -/
theorem recoverabilityGap_nonneg (T : FinObs ι κ) (R : FinObs κ ι) (p q : FinDist ι)
    (hac : AbsCont p q) :
    0 ≤ recoverabilityGap T R p q := by
  unfold recoverabilityGap
  have hacT : AbsCont (pushforward T p) (pushforward T q) := AbsCont_pushforward T hac
  have h1 := klDiv_dataProcessing R (pushforward T p) (pushforward T q) hacT
  have h2 := klDiv_dataProcessing T p q hac
  linarith

/-- If exact recovery is possible, the recoverability gap is exactly the observer loss. -/
theorem recoverabilityGap_eq_observerLoss_of_exactRecovery (T : FinObs ι κ) (R : FinObs κ ι) (p q : FinDist ι)
    (hac : AbsCont p q) (hR : ExactRecovery T R p q) :
    recoverabilityGap T R p q = observerLoss T p q := by
  unfold recoverabilityGap
  rw [hR.1, hR.2]
  rw [observerLoss_zero_of_exactRecovery T R p q hac hR]
  ring

/-- The conjectural inequality showing recoverability gap controls source visibility. -/
def ConjecturalSourceVisibilityInequality (T : FinObs ι κ) (R : FinObs κ ι) (p q : FinDist ι)
    (defect : Real) : Prop :=
  defect ≤ recoverabilityGap T R p q

end PhysicsSM.Draft.NullEdgeP7RecoverabilityGap
