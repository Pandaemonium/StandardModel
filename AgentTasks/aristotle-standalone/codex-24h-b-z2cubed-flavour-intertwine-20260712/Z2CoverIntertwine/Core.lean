import Mathlib

/-!
Focused standalone target for the exact scalar `Z2^3` cover intertwiner.
All definitions below are copied from the live theorem statements, not from an
external implementation. Preserve every theorem statement.
-/

noncomputable section

open Matrix Complex

namespace Z2CoverIntertwine

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ
abbrev Flavour := Fin 3 → ZMod 2

def alpha1 : Mat4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I; 0, 0, I, 0; 0, -I, 0, 0; I, 0, 0, 0]

def alpha3 : Mat4 :=
  !![0, 0, 1, 0; 0, 0, 0, -1; 1, 0, 0, 0; 0, -1, 0, 0]

def beta : Mat4 :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

def factor (q : ℝ) (g : Mat4) : Mat4 :=
  (Real.cos q : ℂ) • (1 : Mat4) - (I * (Real.sin q : ℂ)) • g

def splitStep (kx ky kz m eps : ℝ) : Mat4 :=
  factor (kx * eps) alpha1 * factor (ky * eps) alpha2 *
    factor (kz * eps) alpha3 * factor (m * eps) beta

def chi (f : Flavour) : ℤ := (-1) ^ (f 0 + f 1 + f 2).val

def tau (f : Flavour) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  fun j => q j + Real.pi * (f j).val

theorem factor_pi_shift (q : ℝ) (g : Mat4) :
    factor (q + Real.pi) g = -factor q g := by
  sorry

theorem splitStep_pi_shift_axis0 (qx qy qz : ℝ) :
    splitStep (qx + Real.pi) qy qz 0 1 = -splitStep qx qy qz 0 1 := by
  sorry

theorem splitStep_pi_shift_axis1 (qx qy qz : ℝ) :
    splitStep qx (qy + Real.pi) qz 0 1 = -splitStep qx qy qz 0 1 := by
  sorry

theorem splitStep_pi_shift_axis2 (qx qy qz : ℝ) :
    splitStep qx qy (qz + Real.pi) 0 1 = -splitStep qx qy qz 0 1 := by
  sorry

theorem splitStep_cover_intertwines (q : Fin 3 → ℝ) (f : Flavour) :
    splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1 =
      (chi f : ℂ) • splitStep (q 0) (q 1) (q 2) 0 1 := by
  sorry

theorem cover_det_alias (q : Fin 3 → ℝ) (f : Flavour) :
    (splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1 - 1).det =
      (if Even (f 0 + f 1 + f 2).val
        then (splitStep (q 0) (q 1) (q 2) 0 1 - 1).det
        else (splitStep (q 0) (q 1) (q 2) 0 1 + 1).det) := by
  sorry

theorem deck_nonidentity_witness :
    (splitStep Real.pi 0 0 0 1 - 1).det ≠ 0 ∧
      (splitStep 0 0 0 0 1 - 1).det = 0 := by
  sorry

theorem wrongCover_halfperiod_not_scalar :
    ¬ ∃ c : ℂ, splitStep (Real.pi / 2) 0 0 0 1 =
      c • splitStep 0 0 0 0 1 := by
  sorry

end Z2CoverIntertwine
