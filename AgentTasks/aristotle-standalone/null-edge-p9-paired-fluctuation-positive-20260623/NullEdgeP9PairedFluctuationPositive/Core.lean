import Mathlib.Tactic

/-!
# P9 paired mean-zero fluctuation positivity

Paired positive/negative hidden bookkeeping can have zero mean but nonzero
second moment. This target proves the nontrivial direction: if at least one
source amplitude is nonzero, then the paired second moment is strictly positive.
-/

noncomputable section

namespace NullEdgeP9PairedFluctuationPositive

open BigOperators

def sourceSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => s i ^ 2

def pairedSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  2 * sourceSqSum s

theorem sourceSqSum_pos_of_exists_nonzero {N : Nat} (s : Fin N -> Real)
    (h : Exists fun i => s i = 0 -> False) :
    0 < sourceSqSum s := by
  sorry

theorem pairedSqSum_pos_of_exists_nonzero {N : Nat} (s : Fin N -> Real)
    (h : Exists fun i => s i = 0 -> False) :
    0 < pairedSqSum s := by
  sorry

end NullEdgeP9PairedFluctuationPositive
