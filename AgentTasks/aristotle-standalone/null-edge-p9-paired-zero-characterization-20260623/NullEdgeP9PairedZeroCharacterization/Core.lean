import Mathlib.Tactic

/-!
# P9 zero characterization for paired second moment

The previous theorem says nonzero source amplitudes give positive second
moment. This target asks for the converse characterization: the source-square
sum, and hence paired second moment, is zero exactly when every amplitude
vanishes.
-/

noncomputable section

namespace NullEdgeP9PairedZeroCharacterization

open BigOperators

def sourceSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => s i ^ 2

def pairedSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  2 * sourceSqSum s

theorem sourceSqSum_eq_zero_iff_forall_zero {N : Nat} (s : Fin N -> Real) :
    sourceSqSum s = 0 <-> (forall i, s i = 0) := by
  sorry

theorem pairedSqSum_eq_zero_iff_forall_zero {N : Nat} (s : Fin N -> Real) :
    pairedSqSum s = 0 <-> (forall i, s i = 0) := by
  sorry

end NullEdgeP9PairedZeroCharacterization
