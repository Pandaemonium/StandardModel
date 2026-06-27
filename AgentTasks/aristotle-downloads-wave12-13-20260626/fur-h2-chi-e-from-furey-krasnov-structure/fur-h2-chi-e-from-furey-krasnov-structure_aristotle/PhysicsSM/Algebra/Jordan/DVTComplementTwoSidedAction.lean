import Mathlib
import PhysicsSM.Algebra.Jordan.DVTComplementBridge
import PhysicsSM.Algebra.Jordan.H3OComplementTwoSidedAction

/-!
# Algebra.Jordan.DVTComplementTwoSidedAction

Transport the trusted two-sided matrix action `X ↦ A * X * B` on
`H3O.complementAddSubgroup` back to the DVT complement scaffold
`DVTAction.H3OComplement`, via the additive equivalence
`h3oComplementAddEquivComplementSubgroup`.

## Main declarations

- `h3oComplementTwoSidedAction` — the transported two-sided action.
- `h3oComplementEquivM3C_twoSidedAction` — coordinate equation.
- `h3oComplementTwoSidedAction_one_one` — identity law.
- `h3oComplementTwoSidedAction_mul` — composition law.
- `h3oComplementTwoSidedAction_scalar_cancel` — central scalar cancellation.
- `h3oComplementTwoSidedAction_scalar_cancel_apply` — pointwise version.

## Claim boundary

This is only a transported additive action on the DVT complement scaffold.
It does not claim unitarity, determinant one, quotient by `ℤ₃`, the DVT
stabilizer theorem, or Jordan-product preservation.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

/-- Two-sided matrix action `X ↦ A * X * B` transported to the DVT
    complement scaffold `H3OComplement`. -/
noncomputable def h3oComplementTwoSidedAction
    (A B : Matrix (Fin 3) (Fin 3) ℂ) :
    H3OComplement →+ H3OComplement :=
  h3oComplementAddEquivComplementSubgroup.symm.toAddMonoidHom.comp
    ((complementMatrixTwoSidedAction A B).toAddMonoidHom.comp
      h3oComplementAddEquivComplementSubgroup.toAddMonoidHom)

private theorem h3oComplementTwoSidedAction_apply
    (A B : Matrix (Fin 3) (Fin 3) ℂ) (w : H3OComplement) :
    h3oComplementTwoSidedAction A B w =
      h3oComplementAddEquivComplementSubgroup.symm
        (complementMatrixTwoSidedAction A B
          (h3oComplementAddEquivComplementSubgroup w)) := by
  rfl

/-- The coordinate equation for the transported two-sided action. -/
theorem h3oComplementEquivM3C_twoSidedAction
    (A B : Matrix (Fin 3) (Fin 3) ℂ)
    (w : H3OComplement) :
    h3oComplementEquivM3C (h3oComplementTwoSidedAction A B w) =
      A * h3oComplementEquivM3C w * B := by
  convert complementLinearEquivM3C_twoSidedAction A B
    (h3oComplementAddEquivComplementSubgroup w) using 1

/-- The two-sided action with both matrices equal to `1` is the identity. -/
theorem h3oComplementTwoSidedAction_one_one :
    h3oComplementTwoSidedAction 1 1 = AddMonoidHom.id H3OComplement := by
  ext w : 1
  · rw [h3oComplementTwoSidedAction_apply]
    simp [complementMatrixTwoSidedAction_one_one]

/-- Composition law for the transported two-sided action. -/
theorem h3oComplementTwoSidedAction_mul
    (A1 A2 B1 B2 : Matrix (Fin 3) (Fin 3) ℂ) :
    h3oComplementTwoSidedAction (A1 * A2) (B2 * B1) =
      (h3oComplementTwoSidedAction A1 B1).comp
        (h3oComplementTwoSidedAction A2 B2) := by
  unfold h3oComplementTwoSidedAction
  simp +decide only [complementMatrixTwoSidedAction_mul,
    AddMonoidHom.comp_assoc]
  exact AddMonoidHom.ext fun x => by
    simp +decide

/-- Central scalar cancellation: `(z • 1) * X * (z⁻¹ • 1) = X`. -/
theorem h3oComplementTwoSidedAction_scalar_cancel
    {z : ℂ} (hz : z ≠ 0) :
    h3oComplementTwoSidedAction
      (z • (1 : Matrix (Fin 3) (Fin 3) ℂ))
      (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)) =
    AddMonoidHom.id H3OComplement := by
  ext w : 1
  · rw [h3oComplementTwoSidedAction_apply]
    simp [complementMatrixTwoSidedAction_scalar_cancel hz]

/-- Central scalar cancellation, pointwise version. -/
theorem h3oComplementTwoSidedAction_scalar_cancel_apply
    {z : ℂ} (hz : z ≠ 0) (w : H3OComplement) :
    h3oComplementTwoSidedAction
      (z • (1 : Matrix (Fin 3) (Fin 3) ℂ))
      (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)) w = w := by
  simp [h3oComplementTwoSidedAction_scalar_cancel hz]

end PhysicsSM.Algebra.Jordan.DVTAction
