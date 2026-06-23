import Mathlib.Tactic

noncomputable section

namespace NullEdgeP9AntisymmetricMeanZero

open BigOperators

/-- Pairing of a face source with the constant curvature-defect test. -/
def constantPairing {N : Nat} (source : Fin N -> Real) : Real :=
  Finset.univ.sum source

/--
If a residual source is antisymmetric under an observer-hidden relabeling of
faces, then it is invisible to the constant curvature defect.

This is the finite algebraic mechanism behind "mean-zero hidden bookkeeping".
-/
theorem antisymmetric_relabeling_constantPairing_zero {N : Nat}
    (tau : Equiv.Perm (Fin N)) (source : Fin N -> Real)
    (hanti : forall i, source (tau i) = - source i) :
    constantPairing source = 0 := by
  sorry

end NullEdgeP9AntisymmetricMeanZero
