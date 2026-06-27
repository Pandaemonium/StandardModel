import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralActionHom
import PhysicsSM.Algebra.Jordan.DVTZ3CentralScalarFinite

/-!
# Algebra.Jordan.DVTZ3CentralRootsMulEquiv

Multiplicative equivalences between the DVT central cube-root groups
and Mathlib's `rootsOfUnity 3 ℂ`, plus cyclicity transfer.

## Main declarations

- `dvtZ3CentralUnitMulEquivRootsOfUnity` — `MulEquiv` from `DVTZ3CentralUnit`
  to `rootsOfUnity 3 ℂ`.
- `dvtZ3CentralScalarMulEquivRootsOfUnity` — `MulEquiv` from
  `DVTZ3CentralScalar` to `rootsOfUnity 3 ℂ`.
- `DVTZ3CentralUnit.instIsCyclic` / `DVTZ3CentralScalar.instIsCyclic` —
  cyclicity instances transferred from `rootsOfUnity.isCyclic`.
- `DVTZ3CentralRootsMulEquivPackage` — bundled result.

## Claim boundary

This proves the finite central cube-root group API for the current DVT
central-kernel scaffold. It does not prove the full DVT stabilizer theorem,
the full `(SU(3) × SU(3)) / ℤ₃` action, or faithfulness of a noncentral
action.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open Complex

/-! ### MulEquiv: DVTZ3CentralUnit ≃* rootsOfUnity 3 ℂ -/

/-- Promote the plain equivalence `dvtZ3CentralUnitEquivRootsOfUnity` to a
    multiplicative equivalence. Both sides carry their multiplication from
    `ℂˣ`, so the map is automatically a homomorphism. -/
noncomputable def dvtZ3CentralUnitMulEquivRootsOfUnity :
    MulEquiv DVTZ3CentralUnit (rootsOfUnity 3 ℂ) where
  toEquiv := dvtZ3CentralUnitEquivRootsOfUnity
  map_mul' u v := by
    simp only [dvtZ3CentralUnitEquivRootsOfUnity]
    ext
    rfl

/-- The unit–scalar equivalence as a `MulEquiv`. -/
noncomputable def dvtZ3CentralUnitMulEquivScalar :
    MulEquiv DVTZ3CentralUnit DVTZ3CentralScalar where
  toEquiv := dvtZ3CentralUnitEquivScalar
  map_mul' u v := dvtZ3CentralUnitEquivScalar_mul u v

/-- Promote the scalar equivalence to a multiplicative equivalence with
    `rootsOfUnity 3 ℂ`, by composing the unit–scalar `MulEquiv` with the
    unit–roots `MulEquiv`. -/
noncomputable def dvtZ3CentralScalarMulEquivRootsOfUnity :
    MulEquiv DVTZ3CentralScalar (rootsOfUnity 3 ℂ) :=
  dvtZ3CentralUnitMulEquivScalar.symm.trans
    dvtZ3CentralUnitMulEquivRootsOfUnity

/-! ### Coercion / application lemmas -/

@[simp] theorem dvtZ3CentralUnitMulEquivRootsOfUnity_apply_val
    (u : DVTZ3CentralUnit) :
    ((dvtZ3CentralUnitMulEquivRootsOfUnity u : ℂˣ) : ℂ) =
      (u : ℂˣ) := by
  rfl

@[simp] theorem dvtZ3CentralScalarMulEquivRootsOfUnity_apply_val
    (z : DVTZ3CentralScalar) :
    ((dvtZ3CentralScalarMulEquivRootsOfUnity z : ℂˣ) : ℂ) =
      (z : ℂ) := by
  exact ext rfl rfl

/-! ### Cyclicity -/

noncomputable instance DVTZ3CentralUnit.instIsCyclic :
    IsCyclic DVTZ3CentralUnit := by
  have h_cyclic : IsCyclic (rootsOfUnity 3 ℂ) := inferInstance
  obtain ⟨g, hg⟩ := h_cyclic.exists_generator
  exact ⟨⟨dvtZ3CentralUnitMulEquivRootsOfUnity.symm g, fun a => by
    obtain ⟨n, hn⟩ := hg (dvtZ3CentralUnitMulEquivRootsOfUnity a)
    exact ⟨n, by simp_all +decide [← map_zpow]⟩⟩⟩

noncomputable instance DVTZ3CentralScalar.instIsCyclic :
    IsCyclic DVTZ3CentralScalar :=
  isCyclic_of_surjective
    dvtZ3CentralUnitMulEquivScalar.toMonoidHom
    dvtZ3CentralUnitMulEquivScalar.surjective

/-! ### Bundled package -/

/-- Bundled result packaging the multiplicative equivalences, cardinality, and
    cyclicity for the DVT central cube-root groups. -/
structure DVTZ3CentralRootsMulEquivPackage where
  unit_mul_equiv_roots :
    MulEquiv DVTZ3CentralUnit (rootsOfUnity 3 ℂ)
  scalar_mul_equiv_roots :
    MulEquiv DVTZ3CentralScalar (rootsOfUnity 3 ℂ)
  scalar_card_three : Fintype.card DVTZ3CentralScalar = 3
  unit_card_three : Fintype.card DVTZ3CentralUnit = 3
  scalar_is_cyclic : IsCyclic DVTZ3CentralScalar

noncomputable def dvtZ3CentralRootsMulEquivPackage :
    DVTZ3CentralRootsMulEquivPackage where
  unit_mul_equiv_roots := dvtZ3CentralUnitMulEquivRootsOfUnity
  scalar_mul_equiv_roots := dvtZ3CentralScalarMulEquivRootsOfUnity
  scalar_card_three := dvtZ3CentralScalar_card
  unit_card_three := dvtZ3CentralUnit_card
  scalar_is_cyclic := DVTZ3CentralScalar.instIsCyclic

end PhysicsSM.Algebra.Jordan.DVTAction
