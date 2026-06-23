import Mathlib.Tactic

/-!
# P9 positive second moment iff some source amplitude is nonzero

This combines the positivity and zero-characterization lanes into a single exact
finite statement.
-/

noncomputable section

namespace NullEdgeP9PairedPositiveIff

open BigOperators

def sourceSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => s i ^ 2

def pairedSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  2 * sourceSqSum s

theorem sourceSqSum_pos_iff_exists_nonzero {N : Nat} (s : Fin N -> Real) :
    0 < sourceSqSum s <-> Exists fun i => s i = 0 -> False := by
  sorry

theorem pairedSqSum_pos_iff_exists_nonzero {N : Nat} (s : Fin N -> Real) :
    0 < pairedSqSum s <-> Exists fun i => s i = 0 -> False := by
  sorry

end NullEdgeP9PairedPositiveIff
