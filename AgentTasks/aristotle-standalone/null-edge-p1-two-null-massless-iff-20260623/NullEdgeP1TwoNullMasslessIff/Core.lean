import Mathlib.Tactic

/-!
# P1 two-null masslessness in the observer-axis split

With nonnegative right/left null energies, the scalar mass square `4ab`
vanishes exactly when one component is absent, and is positive exactly when both
are present.
-/

namespace NullEdgeP1TwoNullMasslessIff

def splitMassSq (a b : Real) : Real :=
  4 * a * b

theorem splitMassSq_eq_zero_iff_left_or_right_zero
    (a b : Real) (ha : 0 <= a) (hb : 0 <= b) :
    splitMassSq a b = 0 <-> a = 0 ∨ b = 0 := by
  sorry

theorem splitMassSq_pos_iff_left_and_right_pos
    (a b : Real) (ha : 0 <= a) (hb : 0 <= b) :
    0 < splitMassSq a b <-> 0 < a ∧ 0 < b := by
  sorry

end NullEdgeP1TwoNullMasslessIff
