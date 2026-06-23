import Mathlib.Tactic

/-!
# P1 normalized determinant positive interior

The normalized Bloch determinant is positive exactly inside the observer-
normalized radius endpoint `rSq < 1`.
-/

namespace PhysicsSM.Draft.NullEdgeP1NormalizedDetPositive

noncomputable section

def normalizedBlochDet (rSq : Real) : Real :=
  (1 - rSq) / 4

theorem normalizedBlochDet_pos_iff_radius_lt_one (rSq : Real) :
    0 < normalizedBlochDet rSq <-> rSq < 1 := by
  simp [normalizedBlochDet]

end

end PhysicsSM.Draft.NullEdgeP1NormalizedDetPositive
