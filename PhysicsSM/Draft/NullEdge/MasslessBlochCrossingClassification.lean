import PhysicsSM.Draft.NullEdge.FullBlochZeroClassification

/-!
# Complete massless crossing classification of the live ordered Bloch step

The principal massive classification excludes `theta=0`. This module classifies
that globally chirality-split boundary exactly in cosine coordinates.

Provenance: internal composition with the live Bloch determinant API; all proof
bodies were completed by Aristotle project
`30627d07-edbf-449a-b199-39aa4a96b257` on 2026-07-11.
-/

namespace PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification

open FullBlochSplitDeterminants
open FullBlochZeroClassification

theorem algebraZero_massless_factor (x y z : Real) :
    algebraZero x y z 1 =
      (x - y * z) ^ 2 +
        (y ^ 2 * (1 - z ^ 2) + z ^ 2 * (1 - y ^ 2)) *
          (1 - x ^ 2) := by
  unfold algebraZero algebraBase
  ring

theorem algebraPi_massless_factor (x y z : Real) :
    algebraPi x y z 1 =
      (x + y * z) ^ 2 +
        (y ^ 2 * (1 - z ^ 2) + z ^ 2 * (1 - y ^ 2)) *
          (1 - x ^ 2) := by
  unfold algebraPi algebraBase
  ring

theorem algebraZero_massless_eq_zero_iff
    (x y z : Real) (hx : |x| ≤ 1) (hy : |y| ≤ 1) (hz : |z| ≤ 1) :
    algebraZero x y z 1 = 0 ↔
      (x = 0 ∧ y = 0 ∧ z = 0) ∨
      (x ^ 2 = 1 ∧ y ^ 2 = 1 ∧ z ^ 2 = 1 ∧ x = y * z) := by
  -- By definition of absolute value, we know that $x^2 \leq 1$, $y^2 \leq 1$, and $z^2 \leq 1$.
  have hx2 : x^2 ≤ 1 := by
    nlinarith [ abs_le.mp hx ]
  have hy2 : y^2 ≤ 1 := by
    nlinarith only [ abs_le.mp hy ]
  have hz2 : z^2 ≤ 1 := by
    nlinarith only [ abs_le.mp hz ];
  constructor <;> intro h;
  · rw [ algebraZero_massless_factor ] at h;
    by_cases h1 : 1 - x^2 = 0;
    · simp_all +decide [ sub_eq_iff_eq_add ];
      by_cases hy : y = 0 <;> by_cases hz : z = 0 <;> simp_all +decide [ sq ];
      constructor <;> cases abs_cases y <;> cases abs_cases z <;> nlinarith [ mul_self_pos.2 hy, mul_self_pos.2 hz ];
    · -- Since $1 - x^2 \neq 0$, we must have $y^2 * (1 - z^2) + z^2 * (1 - y^2) = 0$.
      have h2 : y^2 * (1 - z^2) + z^2 * (1 - y^2) = 0 := by
        exact mul_left_cancel₀ h1 <| by nlinarith [ sq_nonneg ( x - y * z ), mul_nonneg ( sq_nonneg y ) ( sub_nonneg.mpr hz2 ), mul_nonneg ( sq_nonneg z ) ( sub_nonneg.mpr hy2 ) ] ;
      by_cases hy0 : y = 0 <;> by_cases hz0 : z = 0 <;> simp_all +decide [ add_eq_zero_iff_of_nonneg, mul_nonneg, sq_nonneg ];
      grind +qlia;
  · grind +suggestions

theorem algebraPi_massless_eq_zero_iff
    (x y z : Real) (hx : |x| ≤ 1) (hy : |y| ≤ 1) (hz : |z| ≤ 1) :
    algebraPi x y z 1 = 0 ↔
      (x = 0 ∧ y = 0 ∧ z = 0) ∨
      (x ^ 2 = 1 ∧ y ^ 2 = 1 ∧ z ^ 2 = 1 ∧ x = -(y * z)) := by
  constructor <;> intro h;
  · -- By definition of $algebraPi$, we know that
    have h_def : algebraPi x y z 1 = (x + y * z) ^ 2 + (y ^ 2 * (1 - z ^ 2) + z ^ 2 * (1 - y ^ 2)) * (1 - x ^ 2) := by
      exact algebraPi_massless_factor x y z;
    by_cases hx2 : x ^ 2 = 1;
    · simp_all +decide [ add_eq_zero_iff_eq_neg ];
      cases hx2 <;> simp_all +decide [ abs_le ];
      · cases le_or_gt 0 y <;> cases le_or_gt 0 z <;> first | exact Or.inr ⟨ Or.inl <| by nlinarith, Or.inl <| by nlinarith ⟩ | exact Or.inr ⟨ Or.inr <| by nlinarith, Or.inr <| by nlinarith ⟩ ;
      · cases le_or_gt 0 y <;> cases le_or_gt 0 z <;> first | exact Or.inr ⟨ Or.inl <| by nlinarith, Or.inr <| by nlinarith ⟩ | exact Or.inr ⟨ Or.inr <| by nlinarith, Or.inl <| by nlinarith ⟩ ;
    · -- Since $x^2 \neq 1$, we have $1 - x^2 > 0$. Therefore, the second term $(y^2 * (1 - z^2) + z^2 * (1 - y^2)) * (1 - x^2)$ must be zero.
      have h_second_term_zero : y^2 * (1 - z^2) + z^2 * (1 - y^2) = 0 := by
        nlinarith [ show 0 < 1 - x ^ 2 by contrapose! hx2; nlinarith [ abs_le.mp hx ], show 0 ≤ y ^ 2 * ( 1 - z ^ 2 ) + z ^ 2 * ( 1 - y ^ 2 ) by nlinarith [ show 0 ≤ y ^ 2 by positivity, show 0 ≤ z ^ 2 by positivity, show y ^ 2 ≤ 1 by nlinarith [ abs_le.mp hy ], show z ^ 2 ≤ 1 by nlinarith [ abs_le.mp hz ] ] ];
      by_cases hy2 : y ^ 2 = 1 <;> by_cases hz2 : z ^ 2 = 1 <;> simp_all +decide [ add_eq_zero_iff_of_nonneg, mul_nonneg, sq_nonneg ];
      · rcases hy2 with ( rfl | rfl ) <;> rcases hz2 with ( rfl | rfl ) <;> norm_num at * <;> cases lt_or_gt_of_ne hx2.1 <;> cases lt_or_gt_of_ne hx2.2 <;> linarith;
      · grind;
      · grind;
      · grind;
  · cases h <;> simp_all +decide [ algebraPi ];
    · unfold algebraBase; norm_num;
    · rcases ‹_› with ⟨ rfl | rfl, rfl | rfl, rfl | rfl, h ⟩ <;> norm_num [ algebraBase ] at *

theorem live_massless_det_sub_one_eq_zero_iff (qx qy qz : Real) :
    (Compact3Plus1DiracRate.splitStep qx qy qz 0 1 - 1).det = 0 ↔
      (Real.cos qx = 0 ∧ Real.cos qy = 0 ∧ Real.cos qz = 0) ∨
      (Real.cos qx ^ 2 = 1 ∧ Real.cos qy ^ 2 = 1 ∧
        Real.cos qz ^ 2 = 1 ∧ Real.cos qx = Real.cos qy * Real.cos qz) := by
  rw [← FullBlochSplitDeterminants.splitStep_eq_live,
    FullBlochSplitPlus.det_splitStep_sub_one]
  have key : zeroModePolynomial qx qy qz 0
      = algebraZero (Real.cos qx) (Real.cos qy) (Real.cos qz) 1 := by
    simp [zeroModePolynomial, spectralBase, algebraZero, algebraBase, Real.cos_zero]
  have hpoly := algebraZero_massless_eq_zero_iff (Real.cos qx) (Real.cos qy)
    (Real.cos qz) (Real.abs_cos_le_one qx) (Real.abs_cos_le_one qy)
    (Real.abs_cos_le_one qz)
  rw [key]
  constructor
  · intro h
    have hr : 4 * algebraZero (Real.cos qx) (Real.cos qy) (Real.cos qz) 1 = 0 := by
      exact_mod_cast h
    have hp : algebraZero (Real.cos qx) (Real.cos qy) (Real.cos qz) 1 = 0 := by
      linarith
    exact hpoly.mp hp
  · intro h
    simp [hpoly.mpr h]

theorem live_massless_det_add_one_eq_zero_iff (qx qy qz : Real) :
    (Compact3Plus1DiracRate.splitStep qx qy qz 0 1 + 1).det = 0 ↔
      (Real.cos qx = 0 ∧ Real.cos qy = 0 ∧ Real.cos qz = 0) ∨
      (Real.cos qx ^ 2 = 1 ∧ Real.cos qy ^ 2 = 1 ∧
        Real.cos qz ^ 2 = 1 ∧ Real.cos qx = -(Real.cos qy * Real.cos qz)) := by
  rw [← FullBlochSplitDeterminants.splitStep_eq_live,
    FullBlochSplitMinus.det_splitStep_add_one]
  have key : piModePolynomial qx qy qz 0
      = algebraPi (Real.cos qx) (Real.cos qy) (Real.cos qz) 1 := by
    simp [piModePolynomial, spectralBase, algebraPi, algebraBase, Real.cos_zero]
  have hpoly := algebraPi_massless_eq_zero_iff (Real.cos qx) (Real.cos qy)
    (Real.cos qz) (Real.abs_cos_le_one qx) (Real.abs_cos_le_one qy)
    (Real.abs_cos_le_one qz)
  rw [key]
  constructor
  · intro h
    have hr : 4 * algebraPi (Real.cos qx) (Real.cos qy) (Real.cos qz) 1 = 0 := by
      exact_mod_cast h
    have hp : algebraPi (Real.cos qx) (Real.cos qy) (Real.cos qz) 1 = 0 := by
      linarith
    exact hpoly.mp hp
  · intro h
    simp [hpoly.mpr h]

/-- Nondegenerate boundary fixtures: the origin-angle corner is a zero mode,
while a one-axis pi corner has the opposite parity and is excluded. -/
theorem massless_corner_parity_controls :
    (Compact3Plus1DiracRate.splitStep 0 0 0 0 1 - 1).det = 0 ∧
    (Compact3Plus1DiracRate.splitStep Real.pi 0 0 0 1 - 1).det ≠ 0 := by
  constructor
  · rw [live_massless_det_sub_one_eq_zero_iff]
    right
    norm_num [Real.cos_zero]
  · rw [ne_eq, live_massless_det_sub_one_eq_zero_iff]
    norm_num [Real.cos_pi, Real.cos_zero]

end PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification
