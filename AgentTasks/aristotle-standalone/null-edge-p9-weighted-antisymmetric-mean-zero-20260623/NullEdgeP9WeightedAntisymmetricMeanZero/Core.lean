import Mathlib.Tactic

noncomputable section

namespace NullEdgeP9WeightedAntisymmetricMeanZero

open BigOperators

/-- Pairing of a source with an observer weight. -/
def weightedPairing {N : Nat} (weight source : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => weight i * source i

/--
If a hidden relabeling preserves observer weights and reverses the source, then
the weighted source pairing is zero.
-/
theorem antisymmetric_relabeling_weightedPairing_zero {N : Nat}
    (tau : Equiv.Perm (Fin N)) (weight source : Fin N -> Real)
    (hweight : forall i, weight (tau i) = weight i)
    (hanti : forall i, source (tau i) = - source i) :
    weightedPairing weight source = 0 := by
  sorry

end NullEdgeP9WeightedAntisymmetricMeanZero
