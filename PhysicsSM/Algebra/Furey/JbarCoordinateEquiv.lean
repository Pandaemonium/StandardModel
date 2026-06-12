import Mathlib
import PhysicsSM.Algebra.Furey.JbarLinearIndependence
import PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
import PhysicsSM.Algebra.Furey.T3OpJbar

/-!
# Coordinate equivalence from Jbar ideal to wavefunctions

This module bridges the corrected octonionic Jbar minimal-left-ideal basis
(from `JbarLinearIndependence`) to the finite coordinate space used by the
electroweak operator formalization (`OperatorElectroweakIdentity`).

## Main declarations

- `JbarSubmoduleLinearEquivWavefunction` — a linear equivalence
  `Jbar' ≃ₗ[ℂ] JbarWavefunction` sending each basis element to the
  corresponding standard basis vector.
- `JbarSubmoduleLinearEquivWavefunction_basis` — the forward direction maps
  `JbarBasisState' s` to `JbarBasisState s`.
- `JbarSubmoduleLinearEquivWavefunction_symm_basis` — the inverse direction
  maps `JbarBasisState s` to the subtype element containing
  `JbarBasisState' s`.
- `JbarCoordinateEquivPackage` / `jbarCoordinateEquivPackage` — bundled
  package of all results.

## Status

Trusted module: no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
-/

namespace PhysicsSM.Algebra.Furey
namespace MinimalLeftIdeal

open PhysicsSM.Algebra.Furey.JbarLinearIndependence
open PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
open PhysicsSM.Algebra.Furey.T3OpJbar
open PhysicsSM.Algebra.Furey.ElectroweakBridge

/-- The linear equivalence from the corrected Jbar submodule (the span of
the eight corrected basis states) to the wavefunction space `Fin 8 → ℂ`.

This is constructed by composing the basis representation
`Jbar_basis.repr : Jbar' ≃ₗ[ℂ] (Fin 8 →₀ ℂ)` with the canonical
equivalence
`Finsupp.linearEquivFunOnFinite : (Fin 8 →₀ ℂ) ≃ₗ[ℂ] (Fin 8 → ℂ)`. -/
noncomputable def JbarSubmoduleLinearEquivWavefunction :
    Jbar' ≃ₗ[Complex] JbarWavefunction :=
  Jbar_basis.repr.trans
    (Finsupp.linearEquivFunOnFinite Complex Complex (Fin 8))

/-- The forward direction sends the subtype element containing
`JbarBasisState' s` to the standard basis vector `JbarBasisState s`. -/
theorem JbarSubmoduleLinearEquivWavefunction_basis
    (s : Fin 8) :
    JbarSubmoduleLinearEquivWavefunction
      ⟨JbarBasisState' s,
        Submodule.subset_span (Set.mem_range_self s)⟩ =
      JbarBasisState s := by
  have h_basis : Jbar_basis s =
      ⟨JbarBasisState' s,
        Submodule.subset_span (Set.mem_range_self s)⟩ :=
    Subtype.ext (Module.Basis.span_apply _ _)
  rw [← h_basis]
  simp +decide [JbarSubmoduleLinearEquivWavefunction,
    JbarBasisState]

/-- The inverse sends the standard basis vector `JbarBasisState s`
to the subtype element containing `JbarBasisState' s`. -/
theorem JbarSubmoduleLinearEquivWavefunction_symm_basis
    (s : Fin 8) :
    JbarSubmoduleLinearEquivWavefunction.symm
      (JbarBasisState s) =
      ⟨JbarBasisState' s,
        Submodule.subset_span (Set.mem_range_self s)⟩ := by
  exact JbarSubmoduleLinearEquivWavefunction.symm_apply_eq.mpr
    (Eq.symm (JbarSubmoduleLinearEquivWavefunction_basis s))

/-- Package bundling the coordinate equivalence and its basis
properties. -/
structure JbarCoordinateEquivPackage where
  /-- The linear equivalence between the Jbar submodule and
  wavefunction space. -/
  equiv : Jbar' ≃ₗ[Complex] JbarWavefunction
  /-- Forward direction maps basis to basis. -/
  basis_forward : ∀ s : Fin 8,
    equiv
      ⟨JbarBasisState' s,
        Submodule.subset_span (Set.mem_range_self s)⟩ =
      JbarBasisState s
  /-- Inverse direction maps basis to basis. -/
  basis_backward : ∀ s : Fin 8,
    equiv.symm (JbarBasisState s) =
      ⟨JbarBasisState' s,
        Submodule.subset_span (Set.mem_range_self s)⟩

/-- The assembled coordinate equivalence package. -/
noncomputable def jbarCoordinateEquivPackage :
    JbarCoordinateEquivPackage where
  equiv := JbarSubmoduleLinearEquivWavefunction
  basis_forward := JbarSubmoduleLinearEquivWavefunction_basis
  basis_backward :=
    JbarSubmoduleLinearEquivWavefunction_symm_basis

end MinimalLeftIdeal
end PhysicsSM.Algebra.Furey
