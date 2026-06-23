import Mathlib.Tactic

noncomputable section

namespace NullEdgeP9MeanZeroFluctuation

open BigOperators

def pairedSqSum {N : Nat} (source : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => source i ^ 2 + (-source i) ^ 2

def sourceSqSum {N : Nat} (source : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => source i ^ 2

theorem pairedSqSum_eq_two_mul_sourceSqSum {N : Nat} (source : Fin N -> Real) :
    pairedSqSum source = 2 * sourceSqSum source := by
  sorry

end NullEdgeP9MeanZeroFluctuation
