import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralScalarGroup

/-!
# Algebra.Jordan.DVTZ3CentralScalarFinite

Finiteness and cardinality for the DVT central cube-root scalar group.

This module connects the bundled `DVTZ3CentralUnit` to Mathlib's
`rootsOfUnity 3 ℂ` and derives that both `DVTZ3CentralUnit` and
`DVTZ3CentralScalar` have exactly three elements.

## Main declarations

- `dvtZ3CentralUnitEquivRootsOfUnity` — explicit equivalence between
  `DVTZ3CentralUnit` and `rootsOfUnity 3 ℂ`.
- `DVTZ3CentralUnit.instFintype` — `Fintype` instance for the unit type.
- `DVTZ3CentralScalar.instFintype` — `Fintype` instance for the scalar type.
- `dvtZ3CentralUnit_card` — `Fintype.card DVTZ3CentralUnit = 3`.
- `dvtZ3CentralScalar_card` — `Fintype.card DVTZ3CentralScalar = 3`.
- `DVTZ3CentralScalarFinitePackage` / `dvtZ3CentralScalarFinitePackage` —
  bundled package.

## Claim boundary

This proves finite cardinality for the current central-kernel scaffold. It
does not prove the full DVT stabilizer theorem, a compact Lie group quotient,
or the faithfulness of a noncentral DVT action.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open Complex

/-! ### Equivalence between `DVTZ3CentralUnit` and `rootsOfUnity 3 ℂ` -/

/-- The cube-root condition on the coercion `(u : ℂ)` is equivalent to
the `ℂˣ`-level cube-root condition used by `rootsOfUnity`. -/
private theorem dvtZ3_cube_units_iff (u : ℂˣ) :
    (u : ℂ) ^ 3 = 1 ↔ u ^ 3 = 1 := by
  constructor
  · intro h; ext; simpa [Units.val_pow_eq_pow_val] using h
  · intro h
    have := congr_arg Units.val h
    simpa [Units.val_pow_eq_pow_val] using this

/-- Explicit equivalence between `DVTZ3CentralUnit` and `rootsOfUnity 3 ℂ`. -/
noncomputable def dvtZ3CentralUnitEquivRootsOfUnity :
    Equiv DVTZ3CentralUnit (rootsOfUnity 3 ℂ) where
  toFun u := ⟨u.val, (_root_.mem_rootsOfUnity 3 u.val).mpr
    ((dvtZ3_cube_units_iff u.val).mp u.prop)⟩
  invFun r := ⟨r.val, (dvtZ3_cube_units_iff r.val).mpr
    ((_root_.mem_rootsOfUnity 3 r.val).mp r.prop)⟩
  left_inv u := by ext; rfl
  right_inv r := by ext; rfl

/-! ### Fintype instances -/

/-- `DVTZ3CentralUnit` is finite (via equivalence with `rootsOfUnity 3 ℂ`). -/
noncomputable instance DVTZ3CentralUnit.instFintype :
    Fintype DVTZ3CentralUnit :=
  Fintype.ofEquiv (rootsOfUnity 3 ℂ) dvtZ3CentralUnitEquivRootsOfUnity.symm

/-- `DVTZ3CentralScalar` is finite (via equivalence with `DVTZ3CentralUnit`). -/
noncomputable instance DVTZ3CentralScalar.instFintype :
    Fintype DVTZ3CentralScalar :=
  Fintype.ofEquiv DVTZ3CentralUnit dvtZ3CentralUnitEquivScalar

/-! ### Cardinality results -/

/-- The central unit group has exactly three elements. -/
theorem dvtZ3CentralUnit_card :
    Fintype.card DVTZ3CentralUnit = 3 := by
  rw [Fintype.ofEquiv_card dvtZ3CentralUnitEquivRootsOfUnity.symm]
  exact Complex.card_rootsOfUnity 3

/-- The central scalar group has exactly three elements. -/
theorem dvtZ3CentralScalar_card :
    Fintype.card DVTZ3CentralScalar = 3 := by
  rw [Fintype.ofEquiv_card dvtZ3CentralUnitEquivScalar]
  exact dvtZ3CentralUnit_card

/-! ### Packaged result -/

/-- Bundled finiteness and cardinality package for the DVT central scalar group. -/
structure DVTZ3CentralScalarFinitePackage where
  scalar_fintype : Fintype DVTZ3CentralScalar
  unit_fintype : Fintype DVTZ3CentralUnit
  scalar_card_three : Fintype.card DVTZ3CentralScalar = 3
  unit_card_three : Fintype.card DVTZ3CentralUnit = 3

/-- The central scalar finite package: both types have three elements. -/
noncomputable def dvtZ3CentralScalarFinitePackage :
    DVTZ3CentralScalarFinitePackage where
  scalar_fintype := DVTZ3CentralScalar.instFintype
  unit_fintype := DVTZ3CentralUnit.instFintype
  scalar_card_three := dvtZ3CentralScalar_card
  unit_card_three := dvtZ3CentralUnit_card

end PhysicsSM.Algebra.Jordan.DVTAction
