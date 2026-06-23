import Mathlib.Tactic

/-!
# P9 max-weight residual bound

This module gives a reusable finite bound for residual-noise estimates. If each
cell weight is nonnegative and at most `eps`, then the squared-weight sum is at
most `eps` times the total weight.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9MaxWeightResidualBound

open BigOperators

def weightSqSum {N : Nat} (w : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => w i ^ 2

def weightSum {N : Nat} (w : Fin N -> Real) : Real :=
  Finset.univ.sum w

theorem weightSqSum_le_eps_mul_weightSum {N : Nat} (w : Fin N -> Real)
    (eps : Real) (hnonneg : ∀ i, 0 <= w i) (hbound : ∀ i, w i <= eps) :
    weightSqSum w <= eps * weightSum w := by
  unfold weightSqSum weightSum
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro i _
  rw [sq]
  exact mul_le_mul_of_nonneg_right (hbound i) (hnonneg i)

end PhysicsSM.Draft.NullEdgeP9MaxWeightResidualBound
