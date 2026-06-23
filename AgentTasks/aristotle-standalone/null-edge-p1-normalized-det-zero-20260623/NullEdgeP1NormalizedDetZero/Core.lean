import Mathlib.Tactic

/-!
# P1 normalized determinant endpoint

The normalized Bloch determinant vanishes exactly on the pure-state endpoint
`rSq = 1`. This is the scalar frame-relative guardrail behind the slogan
"massless means pure celestial direction" after an observer normalization is
chosen.
-/

namespace NullEdgeP1NormalizedDetZero

noncomputable section

def normalizedBlochDet (rSq : Real) : Real :=
  (1 - rSq) / 4

theorem normalizedBlochDet_eq_zero_iff_radius_eq_one (rSq : Real) :
    normalizedBlochDet rSq = 0 <-> rSq = 1 := by
  sorry

end

end NullEdgeP1NormalizedDetZero
