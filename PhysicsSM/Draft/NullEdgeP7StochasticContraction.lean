import Mathlib.Tactic

/-!
# P7 finite data-processing: stochastic maps contract L1 distance

The discrete data-processing inequality in its trace-distance form: applying a
column-stochastic transition matrix (nonnegative entries, each column summing to
one) to the difference of two finite distributions cannot increase the L1 norm.
This is the finite observer/coarse-graining contraction the P7 recoverability
line uses: information visible to a coarse-grained observer is a contraction of
the underlying distinguishability.

```text
|T x|_1 <= |x|_1   when T is column-stochastic.
```

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7StochasticContraction

open BigOperators

/-- L1 norm of a finite signed vector. -/
def l1 {n : Nat} (x : Fin n -> Real) : Real := Finset.univ.sum fun i => |x i|

/-- Apply a finite nonnegative transition matrix to a vector. -/
def applyMap {m n : Nat} (T : Fin m -> Fin n -> Real)
    (x : Fin n -> Real) : Fin m -> Real :=
  fun i => Finset.univ.sum fun j => T i j * x j

/-
Data-processing / trace-distance contraction: a column-stochastic map does
not increase the L1 norm.
-/
theorem l1_contracts_under_stochastic {m n : Nat}
    (T : Fin m -> Fin n -> Real)
    (hnonneg : forall i j, 0 <= T i j)
    (hcol : forall j, Finset.univ.sum (fun i => T i j) = 1)
    (x : Fin n -> Real) :
    l1 (applyMap T x) <= l1 x := by
  unfold l1 applyMap
  -- Bound each row by the triangle inequality, then swap the order of summation.
  calc
    ∑ i, |∑ j, T i j * x j|
        ≤ ∑ i, ∑ j, T i j * |x j| := by
          refine Finset.sum_le_sum fun i _ => ?_
          refine le_trans (Finset.abs_sum_le_sum_abs _ _) (Finset.sum_le_sum fun j _ => ?_)
          rw [abs_mul, abs_of_nonneg (hnonneg i j)]
    _ = ∑ j, (∑ i, T i j) * |x j| := by
          rw [Finset.sum_comm]
          exact Finset.sum_congr rfl fun j _ => (Finset.sum_mul _ _ _).symm
    _ = ∑ j, |x j| := by
          exact Finset.sum_congr rfl fun j _ => by rw [hcol j, one_mul]

end PhysicsSM.Draft.NullEdgeP7StochasticContraction
