import Mathlib.Tactic

/-!
# P9 mean/fluctuation decomposition

This draft module integrates Aristotle project
`3b36d45f-be28-43d2-9708-1df8513d30f3`.

It proves the finite algebraic guardrail behind the cosmological-constant
source-visibility branch: a residual second moment splits into a centered
fluctuation term plus a squared-mean term. Any proposal that wants only
fluctuating residual noise must specify how the mean term is killed, subtracted,
or rendered observer-invisible.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9MeanFluctuation

open BigOperators

/-- Total signed residual scale. -/
def totalScale {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum amp

/-- Total residual second moment. -/
def secondMoment {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => amp i ^ 2

/-- Mean signed residual amplitude. -/
def mean {N : Nat} (_hN : 0 < N) (amp : Fin N -> Real) : Real :=
  totalScale amp / (N : Real)

/-- Second moment after removing the finite mean. -/
def centeredSecondMoment {N : Nat} (hN : 0 < N) (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => (amp i - mean hN amp) ^ 2

/--
Finite mean/fluctuation decomposition.

The total residual second moment splits into a centered fluctuation term plus
the squared mean contribution.
-/
theorem secondMoment_eq_centered_plus_mean_term {N : Nat} (hN : 0 < N)
    (amp : Fin N -> Real) :
    secondMoment amp =
      centeredSecondMoment hN amp + (totalScale amp) ^ 2 / (N : Real) := by
  unfold secondMoment centeredSecondMoment totalScale
  simp +decide [Finset.sum_add_distrib, sub_sq, mean]
  norm_num [← Finset.mul_sum _ _ _, ← Finset.sum_mul, totalScale]
  ring_nf
  norm_num [hN.ne']
  simp +decide [sq, mul_assoc, hN.ne']

/-- If the signed residual scale is mean-zero, the second moment is purely centered. -/
theorem mean_zero_secondMoment_eq_centered {N : Nat} (hN : 0 < N)
    (amp : Fin N -> Real) (hzero : totalScale amp = 0) :
    secondMoment amp = centeredSecondMoment hN amp := by
  have := secondMoment_eq_centered_plus_mean_term hN amp
  aesop

/-- The squared mean contribution is always a lower bound on the second moment. -/
theorem mean_term_le_secondMoment {N : Nat} (hN : 0 < N) (amp : Fin N -> Real) :
    (totalScale amp) ^ 2 / (N : Real) <= secondMoment amp := by
  rw [secondMoment_eq_centered_plus_mean_term hN]
  exact le_add_of_nonneg_left (Finset.sum_nonneg fun _ _ => sq_nonneg _)

end PhysicsSM.Draft.NullEdgeP9MeanFluctuation
