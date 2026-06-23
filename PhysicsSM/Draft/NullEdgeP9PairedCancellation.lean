import Mathlib.Tactic

/-!
# P9 paired hidden cancellation

This module records the explicit paired-source version of hidden mean-zero
bookkeeping: each weighted contribution is paired with an equal and opposite
hidden contribution.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9PairedCancellation

open BigOperators

def pairedSourcePairing {N : Nat} (weight source : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => weight i * source i + weight i * (-source i)

theorem pairedSourcePairing_zero {N : Nat} (weight source : Fin N -> Real) :
    pairedSourcePairing weight source = 0 := by
  unfold pairedSourcePairing
  apply Finset.sum_eq_zero
  intro i _
  ring

end PhysicsSM.Draft.NullEdgeP9PairedCancellation
