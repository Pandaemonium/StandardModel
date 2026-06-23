import Mathlib.Tactic

/-!
# P9 weighted antisymmetric hidden relabeling

This module strengthens the constant-test mean-zero mechanism. If the hidden
relabeling reverses the residual source and preserves the observer's weights,
then the weighted source pairing vanishes.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9WeightedAntisymmetricMeanZero

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
    (hweight : ∀ i, weight (tau i) = weight i)
    (hanti : ∀ i, source (tau i) = - source i) :
    weightedPairing weight source = 0 := by
  unfold weightedPairing
  have hsum := Equiv.sum_comp tau fun i => weight i * source i
  simp only [hweight, hanti, mul_neg, Finset.sum_neg_distrib] at hsum
  linarith

end PhysicsSM.Draft.NullEdgeP9WeightedAntisymmetricMeanZero
