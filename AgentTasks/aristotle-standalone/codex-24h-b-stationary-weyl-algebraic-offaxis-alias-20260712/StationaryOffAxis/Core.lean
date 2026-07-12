import Mathlib

/-!
Focused standalone target for the exact algebraic fully off-axis crossing.
Preserve every theorem statement.
-/

noncomputable section

open Matrix Complex Real Set

namespace StationaryOffAxis

abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

def complement (P : M2) : M2 := 1 - P
def forwardPhase (z : ℂ) (P : M2) : M2 := z • P + complement P
def backwardPhase (z : ℂ) (P : M2) : M2 := P + z⁻¹ • complement P
def stationaryWalk (z : ℂ) (P Q : M2) : M2 :=
  forwardPhase z P * backwardPhase z Q

def Px : M2 := !![9 / 10, 3 / 10; 3 / 10, 1 / 10]
def Qx : M2 := !![1 / 10, 3 / 10; 3 / 10, 9 / 10]
def Py : M2 := !![9 / 10, -(3 / 10) * I; (3 / 10) * I, 1 / 10]
def Qy : M2 := !![1 / 10, -(3 / 10) * I; (3 / 10) * I, 9 / 10]
def Pz : M2 := !![4 / 5, 2 / 5; 2 / 5, 1 / 5]
def Qz : M2 := !![4 / 5, -2 / 5; -2 / 5, 1 / 5]

def weylStep (zx zy zz : ℂ) : M2 :=
  stationaryWalk zx Px Qx * stationaryWalk zy Py Qy *
    stationaryWalk zz Pz Qz

def rootPoly (t : ℝ) : ℝ :=
  480 * t ^ 5 - 575 * t ^ 4 - 1026 * t ^ 2 + 1440 * t - 575

def tangentX (t : ℝ) : ℝ :=
  (1061280 * t ^ 4 - 462525 * t ^ 3 - 644875 * t ^ 2 -
    2634243 * t + 1258155) / 430976

def tangentY (t : ℝ) : ℝ :=
  (574560 * t ^ 4 - 959475 * t ^ 3 - 575125 * t ^ 2 -
    958797 * t + 2176245) / 820352

def unitPhase (t : ℝ) : ℂ :=
  (((1 - t ^ 2) / (1 + t ^ 2) : ℝ) : ℂ) +
    I * (((2 * t) / (1 + t ^ 2) : ℝ) : ℂ)

theorem rootPoly_at_lower : rootPoly (149 / 100) < 0 := by
  sorry

theorem rootPoly_at_upper : 0 < rootPoly (3 / 2) := by
  sorry

theorem exists_rootPoly_in_interval :
    ∃ t : ℝ, 149 / 100 < t ∧ t < 3 / 2 ∧ rootPoly t = 0 := by
  sorry

theorem unitPhase_on_circle (t : ℝ) :
    starRingEnd ℂ (unitPhase t) * unitPhase t = 1 := by
  sorry

theorem tangent_coordinates_nonzero {t : ℝ}
    (hlow : 149 / 100 < t) (hhigh : t < 3 / 2) :
    tangentX t ≠ 0 ∧ tangentY t ≠ 0 ∧ t ≠ 0 := by
  sorry

theorem unitPhase_ne_one_of_ne_zero {t : ℝ} (ht : t ≠ 0) :
    unitPhase t ≠ 1 := by
  sorry

theorem exact_alias_of_root {t : ℝ}
    (ht : rootPoly t = 0) :
    weylStep (unitPhase (tangentX t)) (unitPhase (tangentY t))
      (unitPhase t) = 1 := by
  sorry

theorem exists_exact_fully_offaxis_alias :
    ∃ tx ty tz : ℝ,
      tx ≠ 0 ∧ ty ≠ 0 ∧ tz ≠ 0 ∧
      starRingEnd ℂ (unitPhase tx) * unitPhase tx = 1 ∧
      starRingEnd ℂ (unitPhase ty) * unitPhase ty = 1 ∧
      starRingEnd ℂ (unitPhase tz) * unitPhase tz = 1 ∧
      unitPhase tx ≠ 1 ∧ unitPhase ty ≠ 1 ∧ unitPhase tz ≠ 1 ∧
      weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1 := by
  sorry

end StationaryOffAxis
