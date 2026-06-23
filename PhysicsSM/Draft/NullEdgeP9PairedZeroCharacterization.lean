import Mathlib.Tactic

/-!
# P9 zero characterization for paired second moment

The source-square sum, and hence the paired second moment, vanishes exactly
when every source amplitude vanishes. Together with the positivity theorem, this
completes the finite scalar "mean zero but nonzero second moment" pilot.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9PairedZeroCharacterization

open BigOperators

def sourceSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => s i ^ 2

def pairedSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  2 * sourceSqSum s

theorem sourceSqSum_eq_zero_iff_forall_zero {N : Nat} (s : Fin N -> Real) :
    sourceSqSum s = 0 <-> (forall i, s i = 0) := by
  constructor
  · intro h i
    have hterm := (Finset.sum_eq_zero_iff_of_nonneg
      (fun _ _ => sq_nonneg _)).1 h i
    simpa [sq] using hterm
  · intro h
    simp [h, sourceSqSum]

theorem pairedSqSum_eq_zero_iff_forall_zero {N : Nat} (s : Fin N -> Real) :
    pairedSqSum s = 0 <-> (forall i, s i = 0) := by
  unfold pairedSqSum
  norm_num [sourceSqSum_eq_zero_iff_forall_zero]

end PhysicsSM.Draft.NullEdgeP9PairedZeroCharacterization
