import Mathlib

/-!
# NullStrand two-state minimal coupling target

Finite algebraic uniqueness target for ZZ-005.
-/

namespace NullStrandTwoStateCoupling

/-- Positive part of a real number. -/
def realPos (z : Real) : Real := max z 0

/-- The minimal nonnegative two-state coupling with net current `J` is unique. -/
theorem minimalTwoStateCoupling_unique
    (J a b : Real) (ha : 0 <= a) (hb : 0 <= b)
    (hnet : a - b = J) (hdisjoint : a * b = 0) :
    a = realPos J ∧ b = realPos (-J) := by
  unfold realPos
  rcases mul_eq_zero.mp hdisjoint with ha0 | hb0
  · subst ha0
    have hJ : J = -b := by linarith
    subst hJ
    constructor
    · rw [max_eq_right (by linarith)]
    · rw [neg_neg, max_eq_left hb]
  · subst hb0
    have hJ : J = a := by linarith
    subst hJ
    constructor
    · rw [max_eq_left ha]
    · rw [max_eq_right (by linarith)]

/-- The canonical positive-part pair has the prescribed net current. -/
theorem minimalTwoStateCoupling_net (J : Real) :
    realPos J - realPos (-J) = J := by
  unfold realPos
  rcases le_total 0 J with h | h
  · rw [max_eq_left h, max_eq_right (by linarith)]
    ring
  · rw [max_eq_right h, max_eq_left (by linarith)]
    ring

end NullStrandTwoStateCoupling
