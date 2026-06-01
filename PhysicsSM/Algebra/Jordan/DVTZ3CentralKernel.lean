import Mathlib
import PhysicsSM.Algebra.Jordan.DVTComplementCentralKernel

/-!
# Algebra.Jordan.DVTZ3CentralKernel

Bundled cube-root central-scalar API for the DVT complement scaffold.

This module packages the cube-root-of-unity central scalars as a reusable
subtype `DVTZ3CentralScalar` and lifts the central-kernel triviality
theorems from `DVTComplementCentralKernel` to this bundled type. It also
provides multiplication closure and a composition law.

## Main declarations

- `DVTZ3CentralScalar` — the subtype `{ z : ℂ // z ^ 3 = 1 }`.
- `DVTZ3CentralScalar.ne_zero` — every such scalar is nonzero.
- `DVTZ3CentralScalar.action` — the central scalar pair action lifted to the subtype.
- `DVTZ3CentralScalar.action_eq_id` — the action equals the identity.
- `DVTZ3CentralScalar.action_apply` — pointwise triviality.
- `DVTZ3CentralScalar.mul` — multiplication closure (cube roots are closed under `*`).
- `DVTZ3CentralScalar.action_mul` — the action of a product is trivial.

## Claim boundary

This is only a central-scalar action theorem on the current DVT complement
scaffold. It does not prove the full `(SU(3) × SU(3)) / ℤ₃` action theorem,
faithfulness, compact group quotients, or the DVT stabilizer theorem.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O
open Complex

/-- The bundled type of complex cube roots of unity. -/
abbrev DVTZ3CentralScalar := { z : ℂ // z ^ 3 = 1 }

/-- Every cube root of unity is nonzero. -/
theorem DVTZ3CentralScalar.ne_zero (z : DVTZ3CentralScalar) :
    (z : ℂ) ≠ 0 :=
  ne_zero_of_cube_eq_one z.prop

/-- The central scalar pair action on `H3OComplement`, lifted to the
    bundled cube-root subtype. -/
noncomputable def DVTZ3CentralScalar.action
    (z : DVTZ3CentralScalar) :
    H3OComplement →+ H3OComplement :=
  h3oComplementCentralScalarAction (z : ℂ)

/-- The central scalar pair action of any cube root of unity is the identity. -/
theorem DVTZ3CentralScalar.action_eq_id
    (z : DVTZ3CentralScalar) :
    DVTZ3CentralScalar.action z = AddMonoidHom.id H3OComplement :=
  h3oComplementCentralScalarAction_eq_id_of_cube_eq_one z.prop

/-- The central scalar pair action of any cube root of unity fixes every
    element pointwise. -/
theorem DVTZ3CentralScalar.action_apply
    (z : DVTZ3CentralScalar) (w : H3OComplement) :
    DVTZ3CentralScalar.action z w = w :=
  h3oComplementCentralScalarAction_apply_of_cube_eq_one z.prop w

/-- Multiplication of two cube roots of unity is again a cube root of unity. -/
noncomputable def DVTZ3CentralScalar.mul
    (z w : DVTZ3CentralScalar) : DVTZ3CentralScalar :=
  ⟨(z : ℂ) * (w : ℂ), by rw [mul_pow, z.prop, w.prop, one_mul]⟩

/-- The action of a product of cube roots of unity is the identity. -/
theorem DVTZ3CentralScalar.action_mul
    (z w : DVTZ3CentralScalar) :
    DVTZ3CentralScalar.action (DVTZ3CentralScalar.mul z w) =
      AddMonoidHom.id H3OComplement :=
  DVTZ3CentralScalar.action_eq_id _

end PhysicsSM.Algebra.Jordan.DVTAction
