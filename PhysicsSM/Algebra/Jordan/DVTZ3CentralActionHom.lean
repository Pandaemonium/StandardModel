import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralScalarGroup

/-!
# Algebra.Jordan.DVTZ3CentralActionHom

Bundle the trivial central action of cube-root scalars on the DVT complement
as a monoid homomorphism into additive endomorphisms.

## Main declarations

- `dvtZ3CentralScalarActionMonoidHom` — bundled `→*` from `DVTZ3CentralScalar`
  to `AddMonoid.End H3OComplement`.
- `dvtZ3CentralScalarActionMonoidHom_apply` — the homomorphism agrees with
  `DVTZ3CentralScalar.action`.
- `dvtZ3CentralScalarActionMonoidHom_eq_id` — triviality: the image is always
  `AddMonoidHom.id`.
- `dvtZ3CentralScalarActionMonoidHom_apply_point` — pointwise triviality.
- `dvtZ3CentralUnitActionMonoidHom` — unit-facing version composing with
  `dvtZ3CentralUnitToScalarMonoidHom`.
- `DVTZ3CentralActionHomPackage` — bundled package.

## Claim boundary

This only packages the trivial action of the central cube-root subgroup on the
current DVT complement scaffold. It does not prove the full `(SU(3) × SU(3)) /
ℤ₃` DVT action theorem or the DVT stabilizer theorem.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

/-! ### Scalar action monoid homomorphism -/

/-- The central scalar action bundled as a monoid homomorphism from
    `DVTZ3CentralScalar` to the additive endomorphisms of `H3OComplement`.
    Since the central cube-root action is trivial, this maps every scalar
    to the identity endomorphism. -/
noncomputable def dvtZ3CentralScalarActionMonoidHom :
    DVTZ3CentralScalar →* AddMonoid.End H3OComplement where
  toFun := DVTZ3CentralScalar.action
  map_one' := DVTZ3CentralScalar.action_eq_id 1
  map_mul' z w := by
    -- Both sides equal `AddMonoidHom.id`, so they are equal.
    simp only [DVTZ3CentralScalar.action_eq_id]
    exact (one_mul _).symm

/-- The monoid homomorphism agrees with the raw action. -/
@[simp] theorem dvtZ3CentralScalarActionMonoidHom_apply
    (z : DVTZ3CentralScalar) :
    dvtZ3CentralScalarActionMonoidHom z = DVTZ3CentralScalar.action z :=
  rfl

/-- The monoid homomorphism maps every scalar to the identity endomorphism. -/
theorem dvtZ3CentralScalarActionMonoidHom_eq_id
    (z : DVTZ3CentralScalar) :
    dvtZ3CentralScalarActionMonoidHom z =
      AddMonoidHom.id H3OComplement :=
  DVTZ3CentralScalar.action_eq_id z

/-- Pointwise triviality: applying the homomorphism to any scalar and any
    complement element returns the element unchanged. -/
theorem dvtZ3CentralScalarActionMonoidHom_apply_point
    (z : DVTZ3CentralScalar) (w : H3OComplement) :
    dvtZ3CentralScalarActionMonoidHom z w = w :=
  DVTZ3CentralScalar.action_apply z w

/-! ### Unit-facing version -/

/-- The central unit action bundled as a monoid homomorphism from
    `DVTZ3CentralUnit` to the additive endomorphisms of `H3OComplement`,
    obtained by composing `dvtZ3CentralUnitToScalarMonoidHom` with
    `dvtZ3CentralScalarActionMonoidHom`. -/
noncomputable def dvtZ3CentralUnitActionMonoidHom :
    DVTZ3CentralUnit →* AddMonoid.End H3OComplement :=
  dvtZ3CentralScalarActionMonoidHom.comp dvtZ3CentralUnitToScalarMonoidHom

/-! ### Bundled package -/

/-- A bundled record packaging the scalar action homomorphism together with
    its triviality proof. -/
structure DVTZ3CentralActionHomPackage where
  /-- The monoid homomorphism from scalars to additive endomorphisms. -/
  scalar_action_hom :
    DVTZ3CentralScalar →* AddMonoid.End H3OComplement
  /-- Every scalar maps to the identity endomorphism. -/
  scalar_action_trivial :
    ∀ z : DVTZ3CentralScalar,
      scalar_action_hom z = AddMonoidHom.id H3OComplement

/-- The canonical `DVTZ3CentralActionHomPackage`. -/
noncomputable def dvtZ3CentralActionHomPackage :
    DVTZ3CentralActionHomPackage where
  scalar_action_hom := dvtZ3CentralScalarActionMonoidHom
  scalar_action_trivial := dvtZ3CentralScalarActionMonoidHom_eq_id

end PhysicsSM.Algebra.Jordan.DVTAction
