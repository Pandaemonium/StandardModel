import Mathlib.Tactic

/-!
# P1 normalized determinant endpoint

The normalized Bloch determinant vanishes exactly on the pure-state endpoint
`rSq = 1`. This is an observer-normalized `m/E` endpoint theorem, not the
unnormalized invariant mass theorem.
-/

namespace PhysicsSM.Draft.NullEdgeP1NormalizedDetZero

noncomputable section

def normalizedBlochDet (rSq : Real) : Real :=
  (1 - rSq) / 4

theorem normalizedBlochDet_eq_zero_iff_radius_eq_one (rSq : Real) :
    normalizedBlochDet rSq = 0 <-> rSq = 1 := by
  unfold normalizedBlochDet
  constructor
  · intro h
    have hnum : 1 - rSq = 0 := by
      have hcases := (div_eq_zero_iff).mp h
      rcases hcases with h1 | h2
      · exact h1
      · norm_num at h2
    linarith
  · intro h
    rw [h]
    norm_num

end

end PhysicsSM.Draft.NullEdgeP1NormalizedDetZero
