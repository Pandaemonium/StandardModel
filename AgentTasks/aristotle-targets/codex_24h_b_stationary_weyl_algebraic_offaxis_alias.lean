import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent

/-!
# Target: exact algebraic fully off-axis stationary-Weyl alias

Exact tangent-half-angle elimination reduces the remaining numerical root to a
single quintic. Preserve every statement. In particular, retain the rational
root interval, all three nonzero tangent coordinates, the unit-circle phases,
and the actual matrix identity for the live `weylStep`.

This package proves one exact algebraic crossing. It does not yet prove that
the root is globally unique or that the complete torus census has four nodes.
-/

noncomputable section

open Matrix Complex Real Set

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlgebraicOffAxisAlias

open StationaryAmplitudeWeylTangent

/-- Elimination polynomial for the fully off-axis branch. -/
def rootPoly (t : ℝ) : ℝ :=
  480 * t ^ 5 - 575 * t ^ 4 - 1026 * t ^ 2 + 1440 * t - 575

/-- The eliminated x-axis tangent coordinate. -/
def tangentX (t : ℝ) : ℝ :=
  (1061280 * t ^ 4 - 462525 * t ^ 3 - 644875 * t ^ 2 -
    2634243 * t + 1258155) / 430976

/-- The eliminated y-axis tangent coordinate. -/
def tangentY (t : ℝ) : ℝ :=
  (574560 * t ^ 4 - 959475 * t ^ 3 - 575125 * t ^ 2 -
    958797 * t + 2176245) / 820352

/-- Unit-circle phase from a real tangent-half-angle coordinate. -/
def unitPhase (t : ℝ) : ℂ :=
  (((1 - t ^ 2) / (1 + t ^ 2) : ℝ) : ℂ) +
    I * (((2 * t) / (1 + t ^ 2) : ℝ) : ℂ)

theorem rootPoly_at_lower : rootPoly (149 / 100) < 0 := by
  sorry

theorem rootPoly_at_upper : 0 < rootPoly (3 / 2) := by
  sorry

/-- The exact algebraic branch has a root in a rational isolating interval. -/
theorem exists_rootPoly_in_interval :
    ∃ t : ℝ, 149 / 100 < t ∧ t < 3 / 2 ∧ rootPoly t = 0 := by
  sorry

theorem unitPhase_on_circle (t : ℝ) :
    starRingEnd ℂ (unitPhase t) * unitPhase t = 1 := by
  sorry

/-- The rational isolating interval keeps every tangent coordinate off zero. -/
theorem tangent_coordinates_nonzero {t : ℝ}
    (hlow : 149 / 100 < t) (hhigh : t < 3 / 2) :
    tangentX t ≠ 0 ∧ tangentY t ≠ 0 ∧ t ≠ 0 := by
  sorry

theorem unitPhase_ne_one_of_ne_zero {t : ℝ} (ht : t ≠ 0) :
    unitPhase t ≠ 1 := by
  sorry

/-- The elimination certificate reconstructs an exact identity crossing of the
live stationary-amplitude matrix symbol. -/
theorem exact_alias_of_root {t : ℝ}
    (ht : rootPoly t = 0) :
    weylStep (unitPhase (tangentX t)) (unitPhase (tangentY t))
      (unitPhase t) = 1 := by
  sorry

/-- Nondegenerate exact fully off-axis witness. -/
theorem exists_exact_fully_offaxis_alias :
    ∃ tx ty tz : ℝ,
      tx ≠ 0 ∧ ty ≠ 0 ∧ tz ≠ 0 ∧
      starRingEnd ℂ (unitPhase tx) * unitPhase tx = 1 ∧
      starRingEnd ℂ (unitPhase ty) * unitPhase ty = 1 ∧
      starRingEnd ℂ (unitPhase tz) * unitPhase tz = 1 ∧
      unitPhase tx ≠ 1 ∧ unitPhase ty ≠ 1 ∧ unitPhase tz ≠ 1 ∧
      weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1 := by
  sorry

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlgebraicOffAxisAlias
