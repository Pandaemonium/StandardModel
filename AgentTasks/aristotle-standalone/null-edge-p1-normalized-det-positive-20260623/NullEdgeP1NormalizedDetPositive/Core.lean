import Mathlib.Tactic

/-!
# P1 normalized determinant positive interior

The normalized Bloch determinant is positive exactly inside the Bloch-ball
radius endpoint `rSq < 1` in this scalar model.
-/

namespace NullEdgeP1NormalizedDetPositive

noncomputable section

def normalizedBlochDet (rSq : Real) : Real :=
  (1 - rSq) / 4

theorem normalizedBlochDet_pos_iff_radius_lt_one (rSq : Real) :
    0 < normalizedBlochDet rSq <-> rSq < 1 := by
  sorry

end

end NullEdgeP1NormalizedDetPositive
