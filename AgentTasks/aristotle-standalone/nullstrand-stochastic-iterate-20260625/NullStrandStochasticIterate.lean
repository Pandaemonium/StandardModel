import Mathlib

/-!
# NullStrand finite stochastic iterate target

Finite trajectory-building lemma: iterated row-stochastic pushforwards preserve
probability.
-/

noncomputable section

namespace NullStrandStochasticIterate

open scoped BigOperators

/-- A finite row-stochastic matrix. -/
structure StochasticMatrix (Alpha : Type*) [Fintype Alpha] where
  prob : Alpha -> Alpha -> Real
  nonneg : ∀ i j, 0 <= prob i j
  row_sum : ∀ i, ∑ j, prob i j = 1

/-- Finite real-valued probability law. -/
def IsProbability {Alpha : Type*} [Fintype Alpha] (mu : Alpha -> Real) : Prop :=
  (∀ i, 0 <= mu i) ∧ (∑ i, mu i = 1)

/-- Push a row law forward by a stochastic matrix. -/
def push {Alpha : Type*} [Fintype Alpha]
    (K : StochasticMatrix Alpha) (mu : Alpha -> Real) : Alpha -> Real :=
  fun j => ∑ i, mu i * K.prob i j

/-- One stochastic pushforward preserves probability. -/
theorem push_preserves_probability {Alpha : Type*} [Fintype Alpha]
    (K : StochasticMatrix Alpha) (mu : Alpha -> Real) (hmu : IsProbability mu) :
    IsProbability (push K mu) := by
  simp_all +decide [IsProbability, push]
  exact ⟨
    fun i => Finset.sum_nonneg fun j _ => mul_nonneg (hmu.1 j) (K.nonneg j i),
    by
      rw [Finset.sum_comm]
      simp +decide [← Finset.mul_sum _ _ _, hmu.2, K.row_sum]⟩

/-- Iterated stochastic pushforwards preserve probability. -/
theorem push_iterate_preserves_probability {Alpha : Type*} [Fintype Alpha]
    (K : StochasticMatrix Alpha) (mu : Alpha -> Real) (hmu : IsProbability mu) (n : Nat) :
    IsProbability ((push K)^[n] mu) := by
  induction' n with n ih
  · simp
    exact hmu
  · simp +decide [Function.iterate_succ_apply']
    convert push_preserves_probability K _ ih using 1

end NullStrandStochasticIterate
