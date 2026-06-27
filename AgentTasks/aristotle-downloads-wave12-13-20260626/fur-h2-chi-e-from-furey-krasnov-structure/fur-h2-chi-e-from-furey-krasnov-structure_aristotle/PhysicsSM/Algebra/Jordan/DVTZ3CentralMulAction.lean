import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralRootsMulEquiv

/-!
# Algebra.Jordan.DVTZ3CentralMulAction

Promote the already proved trivial central scalar action on `H3OComplement`
from a monoid homomorphism into additive endomorphisms to an explicit
`MulAction`. Then prove every orbit is a singleton.

## Main declarations

- `DVTZ3CentralScalar.instSMulH3OComplement` - scalar multiplication instance.
- `DVTZ3CentralScalar.instMulActionH3OComplement` - `MulAction` instance.
- `dvtZ3CentralScalar_smul_eq` - `z • w = DVTZ3CentralScalar.action z w`.
- `dvtZ3CentralScalar_smul_eq_self` - `z • w = w`.
- `DVTZ3CentralUnit.instSMulH3OComplement` - unit scalar multiplication.
- `DVTZ3CentralUnit.instMulActionH3OComplement` - unit `MulAction` instance.
- `dvtZ3CentralUnit_smul_eq_self` - `u • w = w`.
- `dvtZ3CentralScalar_orbit_eq_singleton` - orbits are singletons.
- `dvtZ3CentralUnit_orbit_eq_singleton` - orbits are singletons.
- `DVTZ3CentralMulActionPackage` - bundled result.

## Claim boundary

This only packages the central cube-root subgroup as a trivial action on the
current DVT complement scaffold. It does not prove the full
`(SU(3) × SU(3)) / ℤ₃` DVT action theorem, faithfulness off the central
subgroup, or the DVT stabilizer theorem.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

/-! ### Scalar SMul and MulAction -/

/-- Scalar multiplication of `DVTZ3CentralScalar` on `H3OComplement`,
    defined via the existing `DVTZ3CentralScalar.action`. -/
noncomputable instance DVTZ3CentralScalar.instSMulH3OComplement :
    SMul DVTZ3CentralScalar H3OComplement where
  smul z w := DVTZ3CentralScalar.action z w

/-- `MulAction` instance for `DVTZ3CentralScalar` on `H3OComplement`. -/
noncomputable instance DVTZ3CentralScalar.instMulActionH3OComplement :
    MulAction DVTZ3CentralScalar H3OComplement where
  one_smul w := by
    change DVTZ3CentralScalar.action 1 w = w
    exact DVTZ3CentralScalar.action_apply 1 w
  mul_smul z₁ z₂ w := by
    change DVTZ3CentralScalar.action (z₁ * z₂) w =
      DVTZ3CentralScalar.action z₁ (DVTZ3CentralScalar.action z₂ w)
    rw [DVTZ3CentralScalar.action_apply z₂ w,
        DVTZ3CentralScalar.action_apply z₁ w,
        DVTZ3CentralScalar.action_apply (z₁ * z₂) w]

@[simp] theorem dvtZ3CentralScalar_smul_eq
    (z : DVTZ3CentralScalar) (w : H3OComplement) :
    z • w = DVTZ3CentralScalar.action z w :=
  rfl

@[simp] theorem dvtZ3CentralScalar_smul_eq_self
    (z : DVTZ3CentralScalar) (w : H3OComplement) :
    z • w = w :=
  DVTZ3CentralScalar.action_apply z w

/-! ### Unit SMul and MulAction -/

/-- Scalar multiplication of `DVTZ3CentralUnit` on `H3OComplement`. -/
noncomputable instance DVTZ3CentralUnit.instSMulH3OComplement :
    SMul DVTZ3CentralUnit H3OComplement where
  smul u w := DVTZ3CentralScalar.action u.toScalar w

/-- `MulAction` instance for `DVTZ3CentralUnit` on `H3OComplement`. -/
noncomputable instance DVTZ3CentralUnit.instMulActionH3OComplement :
    MulAction DVTZ3CentralUnit H3OComplement where
  one_smul w := by
    change DVTZ3CentralScalar.action (1 : DVTZ3CentralUnit).toScalar w = w
    exact DVTZ3CentralScalar.action_apply _ w
  mul_smul u₁ u₂ w := by
    change DVTZ3CentralScalar.action (u₁ * u₂).toScalar w =
      DVTZ3CentralScalar.action u₁.toScalar
        (DVTZ3CentralScalar.action u₂.toScalar w)
    simp only [DVTZ3CentralScalar.action_apply]

@[simp] theorem dvtZ3CentralUnit_smul_eq_self
    (u : DVTZ3CentralUnit) (w : H3OComplement) :
    u • w = w :=
  DVTZ3CentralScalar.action_apply u.toScalar w

/-! ### Orbit statements -/

theorem dvtZ3CentralScalar_orbit_eq_singleton
    (w : H3OComplement) :
    MulAction.orbit DVTZ3CentralScalar w = {w} := by
  ext x
  simp only [MulAction.mem_orbit_iff, Set.mem_singleton_iff]
  constructor
  · rintro ⟨z, hz⟩
    rw [dvtZ3CentralScalar_smul_eq_self] at hz
    exact hz.symm
  · intro h
    exact ⟨1, by rw [dvtZ3CentralScalar_smul_eq_self, h]⟩

theorem dvtZ3CentralUnit_orbit_eq_singleton
    (w : H3OComplement) :
    MulAction.orbit DVTZ3CentralUnit w = {w} := by
  ext x
  simp only [MulAction.mem_orbit_iff, Set.mem_singleton_iff]
  constructor
  · rintro ⟨u, hu⟩
    rw [dvtZ3CentralUnit_smul_eq_self] at hu
    exact hu.symm
  · intro h
    exact ⟨1, by rw [dvtZ3CentralUnit_smul_eq_self, h]⟩

/-! ### Bundled package -/

/-- Bundled result packaging the `MulAction`, triviality, and orbit
    singleton properties for the central Z₃ action. -/
structure DVTZ3CentralMulActionPackage where
  scalar_action : MulAction DVTZ3CentralScalar H3OComplement
  scalar_smul_trivial :
    ∀ z : DVTZ3CentralScalar, ∀ w : H3OComplement, z • w = w
  scalar_orbit_singleton :
    ∀ w : H3OComplement,
      MulAction.orbit DVTZ3CentralScalar w = {w}

/-- The canonical `DVTZ3CentralMulActionPackage`. -/
noncomputable def dvtZ3CentralMulActionPackage :
    DVTZ3CentralMulActionPackage where
  scalar_action := DVTZ3CentralScalar.instMulActionH3OComplement
  scalar_smul_trivial := dvtZ3CentralScalar_smul_eq_self
  scalar_orbit_singleton := dvtZ3CentralScalar_orbit_eq_singleton

end PhysicsSM.Algebra.Jordan.DVTAction
