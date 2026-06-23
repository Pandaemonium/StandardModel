import Mathlib.Tactic

/-!
# P9 weighted residual benchmark bound

This packages the max-weight residual estimate into the form needed for
observational guardrails: if the total residual scale and per-cell maximum are
bounded, then the weighted second moment is below a chosen benchmark.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9WeightedBenchmarkBound

open BigOperators

def weightSqSum {N : Nat} (w : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => w i ^ 2

def weightSum {N : Nat} (w : Fin N -> Real) : Real :=
  Finset.univ.sum w

theorem weightSqSum_le_eps_mul_weightSum {N : Nat} (w : Fin N -> Real)
    (eps : Real) (hnonneg : forall i, 0 <= w i)
    (hbound : forall i, w i <= eps) :
    weightSqSum w <= eps * weightSum w := by
  have h_termwise : forall i, w i ^ 2 <= eps * w i := fun i => by
    nlinarith [hnonneg i, hbound i]
  simpa only [weightSqSum, weightSum, Finset.mul_sum _ _ _] using
    Finset.sum_le_sum fun i _ => h_termwise i

theorem weightSqSum_le_benchmark_of_max_and_total_bound {N : Nat}
    (w : Fin N -> Real) (eps total benchmark : Real)
    (heps : 0 <= eps) (hnonneg : forall i, 0 <= w i)
    (hbound : forall i, w i <= eps) (htotal : weightSum w <= total)
    (hbench : eps * total <= benchmark) :
    weightSqSum w <= benchmark := by
  have h1 := weightSqSum_le_eps_mul_weightSum w eps hnonneg hbound
  have h2 := mul_le_mul_of_nonneg_left htotal heps
  exact le_trans (le_trans h1 h2) hbench

end PhysicsSM.Draft.NullEdgeP9WeightedBenchmarkBound
