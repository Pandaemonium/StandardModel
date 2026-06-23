import Mathlib.Tactic

noncomputable section

namespace NullEdgeP9MaxWeightResidualBound

open BigOperators

def weightSqSum {N : Nat} (w : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => w i ^ 2

def weightSum {N : Nat} (w : Fin N -> Real) : Real :=
  Finset.univ.sum w

theorem weightSqSum_le_eps_mul_weightSum {N : Nat} (w : Fin N -> Real)
    (eps : Real) (hnonneg : ∀ i, 0 <= w i) (hbound : ∀ i, w i <= eps) :
    weightSqSum w <= eps * weightSum w := by
  sorry

end NullEdgeP9MaxWeightResidualBound
