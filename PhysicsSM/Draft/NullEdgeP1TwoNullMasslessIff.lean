import Mathlib.Tactic

/-!
# P1 two-null masslessness in the observer-axis split

With nonnegative right/left null energies, the scalar mass square `4ab`
vanishes exactly when one component is absent, and is positive exactly when both
are present.
-/

namespace PhysicsSM.Draft.NullEdgeP1TwoNullMasslessIff

def splitMassSq (a b : Real) : Real :=
  4 * a * b

theorem splitMassSq_eq_zero_iff_left_or_right_zero
    (a b : Real) (_ha : 0 <= a) (_hb : 0 <= b) :
    splitMassSq a b = 0 <-> a = 0 ∨ b = 0 := by
  unfold splitMassSq
  aesop

theorem splitMassSq_pos_iff_left_and_right_pos
    (a b : Real) (ha : 0 <= a) (hb : 0 <= b) :
    0 < splitMassSq a b <-> 0 < a ∧ 0 < b := by
  simp only [splitMassSq]
  constructor
  · intro h
    exact ⟨lt_of_le_of_ne ha (by aesop), lt_of_le_of_ne hb (by aesop)⟩
  · intro h
    exact mul_pos (mul_pos (by norm_num) h.1) h.2

end PhysicsSM.Draft.NullEdgeP1TwoNullMasslessIff
