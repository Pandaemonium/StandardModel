import Mathlib.Tactic

noncomputable section

namespace NullEdgeP9PairedCancellation

open BigOperators

def pairedSourcePairing {N : Nat} (weight source : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => weight i * source i + weight i * (-source i)

theorem pairedSourcePairing_zero {N : Nat} (weight source : Fin N -> Real) :
    pairedSourcePairing weight source = 0 := by
  sorry

end NullEdgeP9PairedCancellation
