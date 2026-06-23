import Mathlib.Tactic

/-!
# P1 normalized determinant sign classification

The scalar normalized determinant changes sign at the observer-normalized
endpoint `rSq = 1`.
-/

namespace NullEdgeP1NormalizedDetSign

noncomputable section

def normalizedBlochDet (rSq : Real) : Real :=
  (1 - rSq) / 4

theorem normalizedBlochDet_neg_iff_one_lt_radius (rSq : Real) :
    normalizedBlochDet rSq < 0 <-> 1 < rSq := by
  sorry

theorem normalizedBlochDet_nonpos_iff_one_le_radius (rSq : Real) :
    normalizedBlochDet rSq <= 0 <-> 1 <= rSq := by
  sorry

end

end NullEdgeP1NormalizedDetSign
