import PhysicsSM.Draft.NullEdge.FullBlochZeroClassification

/-!
# Complete massless crossing classification of the live ordered Bloch step

The principal massive classification excludes `theta=0`. This target classifies
that globally chirality-split boundary exactly in cosine coordinates.
-/

namespace PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification

open FullBlochSplitDeterminants
open FullBlochZeroClassification

theorem algebraZero_massless_factor (x y z : Real) :
    algebraZero x y z 1 =
      (x - y * z) ^ 2 +
        (y ^ 2 * (1 - z ^ 2) + z ^ 2 * (1 - y ^ 2)) *
          (1 - x ^ 2) := by
  sorry

theorem algebraPi_massless_factor (x y z : Real) :
    algebraPi x y z 1 =
      (x + y * z) ^ 2 +
        (y ^ 2 * (1 - z ^ 2) + z ^ 2 * (1 - y ^ 2)) *
          (1 - x ^ 2) := by
  sorry

theorem algebraZero_massless_eq_zero_iff
    (x y z : Real) (hx : |x| ≤ 1) (hy : |y| ≤ 1) (hz : |z| ≤ 1) :
    algebraZero x y z 1 = 0 ↔
      (x = 0 ∧ y = 0 ∧ z = 0) ∨
      (x ^ 2 = 1 ∧ y ^ 2 = 1 ∧ z ^ 2 = 1 ∧ x = y * z) := by
  sorry

theorem algebraPi_massless_eq_zero_iff
    (x y z : Real) (hx : |x| ≤ 1) (hy : |y| ≤ 1) (hz : |z| ≤ 1) :
    algebraPi x y z 1 = 0 ↔
      (x = 0 ∧ y = 0 ∧ z = 0) ∨
      (x ^ 2 = 1 ∧ y ^ 2 = 1 ∧ z ^ 2 = 1 ∧ x = -(y * z)) := by
  sorry

theorem live_massless_det_sub_one_eq_zero_iff (qx qy qz : Real) :
    (Compact3Plus1DiracRate.splitStep qx qy qz 0 1 - 1).det = 0 ↔
      (Real.cos qx = 0 ∧ Real.cos qy = 0 ∧ Real.cos qz = 0) ∨
      (Real.cos qx ^ 2 = 1 ∧ Real.cos qy ^ 2 = 1 ∧
        Real.cos qz ^ 2 = 1 ∧ Real.cos qx = Real.cos qy * Real.cos qz) := by
  sorry

theorem live_massless_det_add_one_eq_zero_iff (qx qy qz : Real) :
    (Compact3Plus1DiracRate.splitStep qx qy qz 0 1 + 1).det = 0 ↔
      (Real.cos qx = 0 ∧ Real.cos qy = 0 ∧ Real.cos qz = 0) ∨
      (Real.cos qx ^ 2 = 1 ∧ Real.cos qy ^ 2 = 1 ∧
        Real.cos qz ^ 2 = 1 ∧ Real.cos qx = -(Real.cos qy * Real.cos qz)) := by
  sorry

/-- Nondegenerate boundary fixtures: the origin-angle corner is a zero mode,
while a one-axis pi corner has the opposite parity and is excluded. -/
theorem massless_corner_parity_controls :
    (Compact3Plus1DiracRate.splitStep 0 0 0 0 1 - 1).det = 0 ∧
    (Compact3Plus1DiracRate.splitStep Real.pi 0 0 0 1 - 1).det ≠ 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification
