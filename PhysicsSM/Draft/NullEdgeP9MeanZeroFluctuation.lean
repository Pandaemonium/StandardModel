import Mathlib.Tactic

/-!
# P9 mean-zero paired fluctuations

Paired hidden bookkeeping can have zero mean while still carrying nonzero
second moment. This keeps the P9 source-visibility branch honest: mean-zero is
not the same thing as fluctuation-free.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation

open BigOperators

def pairedSqSum {N : Nat} (source : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => source i ^ 2 + (-source i) ^ 2

def sourceSqSum {N : Nat} (source : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => source i ^ 2

theorem pairedSqSum_eq_two_mul_sourceSqSum {N : Nat} (source : Fin N -> Real) :
    pairedSqSum source = 2 * sourceSqSum source := by
  unfold pairedSqSum sourceSqSum
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  ring

end PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation
