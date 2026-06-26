import Mathlib

/-!
# NullStrand.RealPositivePart

Shared positive-part helper for real scalars.

This module unifies the positive-part definition `realPos z = max z 0` and its
elementary lemmas, which were previously duplicated **identically** in the
`PhysicsSM.NullStrand.BellQFT.*` files (`FiniteCurrent`, `MinimalJumpRates`) and in
`PhysicsSM.NullStrand.ZigZag.TransferCurrent` / `ZigZag.MinimalRates`.

The single source of truth now lives in the `PhysicsSM.NullStrand` namespace, so
both the `BellQFT` and `ZigZag` sub-namespaces pick up the *same* `realPos`,
`realPos_nonneg`, `realPos_sub_realPos_neg`, and `realPos_mul_realPos_neg` by the
usual parent-namespace name resolution — no per-lane copy is required.

This removes the three accidental short-name duplicates (`realPos`,
`realPos_nonneg`, `realPos_sub_realPos_neg`) that the base-name collision audit
(`PhysicsSM.NullStrand.Audit.DuplicateNames`) tracked under
`knownDuplicatesPendingDedup`.
-/

noncomputable section

namespace PhysicsSM.NullStrand

/-- Positive part of a real scalar, `max z 0`. -/
def realPos (z : ℝ) : ℝ := max z 0

@[simp] theorem realPos_nonneg (z : ℝ) : 0 ≤ realPos z := le_max_right _ _

/-- The signed decomposition `z⁺ - (-z)⁺ = z`. -/
theorem realPos_sub_realPos_neg (x : ℝ) : realPos x - realPos (-x) = x := by
  by_cases hx : 0 ≤ x
  · simp [realPos, max_eq_left hx, max_eq_right (neg_nonpos.mpr hx)]
  · have hx' : x < 0 := lt_of_not_ge hx
    simp [realPos, max_eq_right (le_of_lt hx'), max_eq_left (neg_nonneg.mpr (le_of_lt hx'))]

/-- Positive parts of `z` and `-z` never overlap: their product vanishes. -/
theorem realPos_mul_realPos_neg (z : ℝ) : realPos z * realPos (-z) = 0 := by
  unfold realPos
  rcases le_total 0 z with h | h
  · simp [max_eq_right (by linarith : -z ≤ 0)]
  · simp [max_eq_right (by linarith : z ≤ 0)]

end PhysicsSM.NullStrand
