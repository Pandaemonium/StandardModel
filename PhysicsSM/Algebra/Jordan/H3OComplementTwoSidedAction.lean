import Mathlib
import PhysicsSM.Algebra.Jordan.H3OComplementMatrixAction

/-!
# Algebra.Jordan.H3OComplementTwoSidedAction

Two-sided matrix action `X ↦ A * X * B` on the orthogonal complement of
`h₃(ℂ)` in `h₃(𝕆)`, transported via the complex-linear equivalence
`complementLinearEquivM3C`.

## Main declarations

- `complementMatrixTwoSidedAction A B` — the two-sided action `X ↦ A * X * B`
  transported to the complement.
- `complementLinearEquivM3C_twoSidedAction` — coordinate equation.
- `complementMatrixTwoSidedAction_one_one` — identity law.
- `complementMatrixTwoSidedAction_mul` — composition law.
- `complementMatrixTwoSidedAction_scalar_cancel` — central scalar cancellation.

## Claim boundary

This file is only the two-sided linear action and the central scalar
cancellation calculation. It does not claim unitarity, determinant one,
quotient by `ℤ₃`, or Jordan-product preservation.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

/-- Two-sided matrix action `X ↦ A * X * B` transported to the complement. -/
noncomputable def complementMatrixTwoSidedAction
    (A B : Matrix (Fin 3) (Fin 3) ℂ) :
    complementAddSubgroup →ₗ[ℂ] complementAddSubgroup :=
  (complementMatrixLeftAction A).comp (complementMatrixRightAction B)

/-- The coordinate equation for the two-sided action. -/
theorem complementLinearEquivM3C_twoSidedAction
    (A B : Matrix (Fin 3) (Fin 3) ℂ)
    (x : complementAddSubgroup) :
    complementLinearEquivM3C
      (complementMatrixTwoSidedAction A B x) =
      A * complementLinearEquivM3C x * B := by
  unfold complementMatrixTwoSidedAction
  norm_num [complementLinearEquivM3C_leftAction,
    complementLinearEquivM3C_rightAction, mul_assoc]

/-- The two-sided action with both matrices equal to `1` is the identity. -/
theorem complementMatrixTwoSidedAction_one_one :
    complementMatrixTwoSidedAction 1 1 = LinearMap.id := by
  unfold complementMatrixTwoSidedAction
  simp +decide [complementMatrixLeftAction_one, complementMatrixRightAction_one]

/-- Composition law for the two-sided action. -/
theorem complementMatrixTwoSidedAction_mul
    (A1 A2 B1 B2 : Matrix (Fin 3) (Fin 3) ℂ) :
    complementMatrixTwoSidedAction (A1 * A2) (B2 * B1) =
      (complementMatrixTwoSidedAction A1 B1).comp
        (complementMatrixTwoSidedAction A2 B2) := by
  convert LinearMap.ext fun x => ?_ using 1
  exact complementLinearEquivM3C.injective
    (by simp +decide [complementLinearEquivM3C_twoSidedAction, Matrix.mul_assoc])

/-- Central scalar cancellation: `(z • 1) * X * (z⁻¹ • 1) = X`. -/
theorem complementMatrixTwoSidedAction_scalar_cancel
    {z : ℂ} (hz : z ≠ 0) :
    complementMatrixTwoSidedAction
      (z • (1 : Matrix (Fin 3) (Fin 3) ℂ))
      (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)) =
    LinearMap.id := by
  refine LinearMap.ext fun x => ?_
  exact complementLinearEquivM3C.injective
    (by simp +decide [complementLinearEquivM3C_twoSidedAction, smul_smul, hz])

/-- Central scalar cancellation, pointwise version. -/
theorem complementMatrixTwoSidedAction_scalar_cancel_apply
    {z : ℂ} (hz : z ≠ 0) (x : complementAddSubgroup) :
    complementMatrixTwoSidedAction
      (z • (1 : Matrix (Fin 3) (Fin 3) ℂ))
      (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)) x = x := by
  simp [complementMatrixTwoSidedAction_scalar_cancel hz]

end PhysicsSM.Algebra.Jordan.H3O
