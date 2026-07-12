import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification
import PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner

/-!
# Target: scalar `Z2^3` flavour-cover intertwiner

Preserve every statement.  This package asks whether the eight-sheet cover of
the live successive-axis symbol has any internal dynamics.  The expected exact
answer is negative: each deck translation acts only by the scalar parity sign.

The determinant theorem must retain the even/odd quasienergy swap, and the
half-period negative control must remain.  This is a cover diagnosis, not a
unique-cone or flavour-selection theorem.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine

open PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
open PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner

/-- Translation of a momentum by the pi-sheet selected by a flavour. -/
def tau (f : Flavour) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  fun j => q j + Real.pi * (f j).val

/-- A pi translation changes one degree-one factor by exactly minus one. -/
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

/-- Pullback to every sheet is only a scalar parity copy. -/
theorem splitStep_cover_intertwines (q : Fin 3 → ℝ) (f : Flavour) :
    splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1 =
      (chi f : ℂ) • splitStep (q 0) (q 1) (q 2) 0 1 := by
  sorry

/-- Even sheets preserve quasienergy zero and odd sheets exchange zero with
pi.  No root is removed by the cover. -/
theorem cover_det_alias (q : Fin 3 → ℝ) (f : Flavour) :
    (splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1 - 1).det =
      (if Even (f 0 + f 1 + f 2).val
        then (splitStep (q 0) (q 1) (q 2) 0 1 - 1).det
        else (splitStep (q 0) (q 1) (q 2) 0 1 + 1).det) := by
  sorry

/-- A pi translation is a nonidentity sheet move: it takes the origin from a
zero-quasienergy crossing to a nonzero determinant at zero quasienergy. -/
theorem deck_nonidentity_witness :
    (splitStep Real.pi 0 0 0 1 - 1).det ≠ 0 ∧
      (splitStep 0 0 0 0 1 - 1).det = 0 := by
  sorry

/-- Pi/2 is not a valid scalar deck period. -/
theorem wrongCover_halfperiod_not_scalar :
    ¬ ∃ c : ℂ, splitStep (Real.pi / 2) 0 0 0 1 =
      c • splitStep 0 0 0 0 1 := by
  sorry

end PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine
