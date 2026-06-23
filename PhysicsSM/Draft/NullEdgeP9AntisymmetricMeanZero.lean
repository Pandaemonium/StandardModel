import Mathlib.Tactic

/-!
# P9 antisymmetric hidden relabeling and mean-zero source

This module records a minimal finite mechanism for the P9 source-visibility
program. If a residual face source is antisymmetric under an observer-hidden
relabeling of the faces, then its pairing with the constant curvature-defect
test vanishes.

This is deliberately modest: it proves a mean-zero condition for one explicit
test functional. It does not by itself prove cosmological suppression, source
invisibility for all observers, or a continuum limit.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9AntisymmetricMeanZero

open BigOperators

/-- Pairing of a face source with the constant curvature-defect test. -/
def constantPairing {N : Nat} (source : Fin N -> Real) : Real :=
  Finset.univ.sum source

/--
If a residual source is antisymmetric under an observer-hidden relabeling of
faces, then it is invisible to the constant curvature-defect test.

This is the finite algebraic mechanism behind the "mean-zero hidden
bookkeeping" branch of the P9 cosmological-constant program.
-/
theorem antisymmetric_relabeling_constantPairing_zero {N : Nat}
    (tau : Equiv.Perm (Fin N)) (source : Fin N -> Real)
    (hanti : ∀ i, source (tau i) = - source i) :
    constantPairing source = 0 := by
  unfold constantPairing
  have hsum := Equiv.sum_comp tau source
  simp only [hanti, Finset.sum_neg_distrib] at hsum
  linarith

end PhysicsSM.Draft.NullEdgeP9AntisymmetricMeanZero
