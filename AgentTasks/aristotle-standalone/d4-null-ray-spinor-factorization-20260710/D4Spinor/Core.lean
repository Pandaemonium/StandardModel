import Mathlib

open Matrix Complex

namespace D4Spinor

abbrev Vec4 := Fin 4 -> ℤ
abbrev Spinor := Fin 2 -> ℂ
abbrev Mat2 := Matrix (Fin 2) (Fin 2) ℂ

inductive FutureRay where
  | xPos | xNeg | yPos | yNeg | zPos | zNeg
  deriving DecidableEq, Fintype, Repr

def root : FutureRay -> Vec4
  | .xPos => ![1, 1, 0, 0]
  | .xNeg => ![1, -1, 0, 0]
  | .yPos => ![1, 0, 1, 0]
  | .yNeg => ![1, 0, -1, 0]
  | .zPos => ![1, 0, 0, 1]
  | .zNeg => ![1, 0, 0, -1]

def rayScale : FutureRay -> ℤ
  | .xPos | .xNeg | .yPos | .yNeg => 2
  | .zPos | .zNeg => 1

def scaledRoot (r : FutureRay) : Vec4 := fun i => rayScale r * root r i

def spinor : FutureRay -> Spinor
  | .xPos => ![1, 1]
  | .xNeg => ![1, -1]
  | .yPos => ![1, I]
  | .yNeg => ![1, -I]
  | .zPos => ![1, 0]
  | .zNeg => ![0, 1]

def rankOne (psi : Spinor) : Mat2 := Matrix.vecMulVec psi (star psi)

/-- Half-Pauli map for signature `(+---)` and coordinates `(t,x,y,z)`. -/
noncomputable def pauliHalf (v : Vec4) : Mat2 :=
  ((1 / 2 : ℝ) : ℂ) •
    !![((v 0 + v 3 : ℤ) : ℂ),
       ((v 1 : ℂ) - I * (v 2 : ℂ));
       ((v 1 : ℂ) + I * (v 2 : ℂ)),
       ((v 0 - v 3 : ℤ) : ℂ)]

def minkowskiSq (v : Vec4) : ℤ :=
  (v 0) ^ 2 - (v 1) ^ 2 - (v 2) ^ 2 - (v 3) ^ 2

theorem roots_are_future_null :
    ∀ r : FutureRay, root r 0 = 1 ∧ minkowskiSq (root r) = 0 := by
  sorry

theorem scales_positive : ∀ r : FutureRay, 0 < rayScale r := by
  sorry

/-- Every future axial D4 null ray has an explicit Gaussian-integer spinor
factor, up to the displayed positive projective scale. -/
theorem all_d4_null_rays_factor :
    ∀ r : FutureRay, rankOne (spinor r) = pauliHalf (scaledRoot r) := by
  sorry

/-- Distinct axial rays are not collapsed to one spinor direction. -/
theorem noncollinear_spinor_control :
    spinor .xPos 0 * spinor .yPos 1 -
      spinor .xPos 1 * spinor .yPos 0 ≠ 0 := by
  sorry

end D4Spinor
