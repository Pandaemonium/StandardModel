import Mathlib
import PhysicsSM.Algebra.Jordan.DVTComplementTwoSidedAction

/-!
# Algebra.Jordan.DVTComplementCentralKernel

Reusable central-kernel API for the DVT complement scaffold.

Central scalar pairs `(z · I, z⁻¹ · I)` act trivially on the DVT complement
model `H3OComplement`. This packages the cancellation theorem from
`DVTComplementTwoSidedAction` into a named definition and several convenient
wrapper theorems, including a cube-root-of-unity specialisation useful for
the later `ℤ₃` kernel story.

## Main declarations

- `h3oComplementCentralScalarAction` — the central scalar pair action.
- `h3oComplementCentralScalarAction_eq_id` — it equals the identity.
- `h3oComplementCentralScalarAction_apply` — pointwise version.
- `ne_zero_of_cube_eq_one` — a cube root of unity is nonzero.
- `h3oComplementCentralScalarAction_eq_id_of_cube_eq_one` — cube-root specialisation.
- `h3oComplementCentralScalarAction_apply_of_cube_eq_one` — pointwise cube-root version.
- `h3oComplementCentralScalarAction_comp` — composition of two central scalar actions.

## Claim boundary

This file proves only additive-action central-kernel facts on the DVT
complement scaffold. It does not define a quotient group, a `ℤ₃` subgroup,
the full Yokota action, or the DVT stabilizer theorem.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O
open Complex

/-- The central scalar pair action `X ↦ (z · I) * X * (z⁻¹ · I)` on the
    DVT complement scaffold. -/
noncomputable def h3oComplementCentralScalarAction (z : ℂ) :
    H3OComplement →+ H3OComplement :=
  h3oComplementTwoSidedAction
    (z • (1 : Matrix (Fin 3) (Fin 3) ℂ))
    (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ))

/-- The central scalar pair action is the identity for nonzero `z`. -/
theorem h3oComplementCentralScalarAction_eq_id
    {z : ℂ} (hz : z ≠ 0) :
    h3oComplementCentralScalarAction z =
      AddMonoidHom.id H3OComplement := by
  exact h3oComplementTwoSidedAction_scalar_cancel hz

/-- The central scalar pair action fixes every element, pointwise. -/
theorem h3oComplementCentralScalarAction_apply
    {z : ℂ} (hz : z ≠ 0) (w : H3OComplement) :
    h3oComplementCentralScalarAction z w = w := by
  exact congr_fun (congr_arg _ (h3oComplementCentralScalarAction_eq_id hz)) w

/-- A cube root of unity is nonzero. -/
theorem ne_zero_of_cube_eq_one {z : ℂ} (hz : z ^ 3 = 1) :
    z ≠ 0 := by
  aesop

/-- The central scalar pair action is the identity when `z` is a cube root
    of unity. -/
theorem h3oComplementCentralScalarAction_eq_id_of_cube_eq_one
    {z : ℂ} (hz : z ^ 3 = 1) :
    h3oComplementCentralScalarAction z =
      AddMonoidHom.id H3OComplement :=
  h3oComplementCentralScalarAction_eq_id (ne_zero_of_cube_eq_one hz)

/-- The central scalar pair action fixes every element when `z` is a cube
    root of unity. -/
theorem h3oComplementCentralScalarAction_apply_of_cube_eq_one
    {z : ℂ} (hz : z ^ 3 = 1) (w : H3OComplement) :
    h3oComplementCentralScalarAction z w = w :=
  h3oComplementCentralScalarAction_apply (ne_zero_of_cube_eq_one hz) w

/-- Composition of two central scalar actions is again trivial when both
    scalars are nonzero. -/
theorem h3oComplementCentralScalarAction_comp
    {z₁ z₂ : ℂ} (hz₁ : z₁ ≠ 0) (hz₂ : z₂ ≠ 0) :
    (h3oComplementCentralScalarAction z₁).comp
      (h3oComplementCentralScalarAction z₂) =
    AddMonoidHom.id H3OComplement := by
  rw [h3oComplementCentralScalarAction_eq_id hz₁,
      h3oComplementCentralScalarAction_eq_id hz₂]
  exact AddMonoidHom.id_comp _

end PhysicsSM.Algebra.Jordan.DVTAction
