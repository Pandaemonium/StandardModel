import Mathlib
import PhysicsSM.Algebra.Furey.ConjugateIdeal
import PhysicsSM.Algebra.Furey.QopJEigenBridge
import PhysicsSM.Algebra.Furey.ElectroweakBridge
import PhysicsSM.Algebra.Furey.T3OpJbar
import PhysicsSM.Algebra.Furey.JbarCoordinateEquiv

/-!
# Draft.NullEdgeFureyJbarCoordinateBridge

Task **FUR-H9A**: a *minimal* compatibility bridge from the conjugate-ideal
coordinate model of `PhysicsSM.Algebra.Furey.ConjugateIdeal` to the live `Jbar`
coordinate / eigenvalue machinery
(`PhysicsSM.Algebra.Furey.JbarCoordinateEquiv`, `QopJEigenBridge`,
`ElectroweakBridge`, `T3OpJbar`).

The previous broad FUR-H9 job ran out of budget; this module narrows the target
to one compatibility bridge and proves it kernel-checked.

## What is bridged

Both sides model their 8-state ideal as the coordinate space `Fin 8 → ℂ` with
the standard basis `Pi.single i 1`:

* `ConjugateIdeal.V := Fin 8 → ℂ`, basis `ConjugateIdeal.JstarBasis i = Pi.single i 1`;
* `OperatorElectroweakIdentity.JbarWavefunction := JbarState → ℂ` with `JbarState = Fin 8`,
  basis `T3OpJbar.JbarBasisState s = Pi.single s 1`.

So the two coordinate spaces are *definitionally equal* and their bases agree on
the nose (`conjIdeal_basis_eq_jbar_basis`).  We package this as the identity
linear equivalence `coordEquiv` and, composing with the octonionic coordinate
equivalence `MinimalLeftIdeal.jbarCoordinateEquivPackage`, an equivalence
`coordToJbarSubmodule : ConjugateIdeal.V ≃ₗ[ℂ] Jbar'` from the conjugate-ideal
coordinate model all the way to the *octonionic* minimal left ideal
`Jbar' ⊆ ℂ⊗𝕆`, sending `JstarBasis i` to the octonionic basis state
`JbarBasisState' i` (`coordToJbarSubmodule_basis`).

## Charge / action-table compatibility

The conjugate-ideal `J`-sector charge table `ConjugateIdeal.qJ` agrees with the
live `Q_op` eigenvalue table in two senses:

* `qJ_eq_rawQopJ` : `qJ i = QopJEigenBridge.rawQopJ i` — *same* index convention
  (electron-first `omega, v1..v6, nu`), agreement on the nose;
* `qJ_eq_rawQop_relabel` : `qJ i = ElectroweakBridge.rawQop i.rev` — the
  **Furey ↔ Jbar relabeling** is the index reversal `Fin.rev` (`jbarRelabel`),
  which carries the electron-first `J`-order to the neutrino-first `Jbar`-order.

The conjugation convention is recorded by `qJstar_eq_neg_rawQopJ`
(`qJstar i = - rawQopJ i`): charge conjugation negates every raw `Q_op`
eigenvalue.

## Conventions (recorded explicitly)

* **XOR octonion basis / Fano orientation / Furey labels**: inherited verbatim
  from the imported live modules (`MinimalLeftIdeal`, `JbarLinearIndependence`,
  `ElectroweakBridge`); this bridge does not introduce or alter any octonion
  multiplication, Fano line orientation, or ladder convention.
* **Furey/Jbar relabeling**: the `J`-sector index order
  `0 = omega(e), 1..3, 4..6, 7 = nu` of `ConjugateIdeal.qJ` / `rawQopJ` is
  carried to the `Jbar`-sector order `0 = nu, 1..3 (d), 4..6 (u), 7 = e` of
  `ElectroweakBridge.rawQop` by the reversal permutation `Fin.rev`
  (`jbarRelabel`).  This is the unique order-reversing map matching the two raw
  charge tables.
* **Conjugation convention**: `ConjugateIdeal.Cconj` is coordinatewise complex
  conjugation (antilinear involution); on charges it acts by negation,
  `qJstar = - qJ = - rawQopJ`.

## Claim boundary

This is a *finite coordinate / charge-table* compatibility bridge in the style of
the project's existing bridge files.  All octonionic content is reused from the
live modules through `jbarCoordinateEquivPackage`; the only genuinely new
mathematical fact established here is that the conjugate-ideal labelling matches
the live `Jbar` labelling under the explicit reversal relabeling.  No mass
values and no three-generation claim are made.

## Status

Experimental draft module (under `PhysicsSM/Draft/`).  No `sorry`, `admit`,
`axiom`, `opaque`, or `unsafe`: all proofs are kernel-checked finite
computations or reuse of trusted live lemmas.
-/

namespace PhysicsSM.Draft.NullEdgeFureyJbarCoordinateBridge

open PhysicsSM.Algebra.Furey
open PhysicsSM.Algebra.Furey.ConjugateIdeal
open PhysicsSM.Algebra.Furey.QopJEigenBridge
open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.T3OpJbar
open PhysicsSM.Algebra.Furey.JbarLinearIndependence
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/-! ## Coordinate-space and basis identification -/

/-- The conjugate-ideal coordinate space and the live `Jbar` wavefunction space
are the *same* coordinate space `Fin 8 → ℂ`. -/
theorem coordSpace_eq :
    ConjugateIdeal.V = OperatorElectroweakIdentity.JbarWavefunction := rfl

/-- The conjugate-ideal basis state and the live `Jbar` coordinate basis state
agree on the nose: both are `Pi.single i 1`. -/
theorem conjIdeal_basis_eq_jbar_basis (i : Fin 8) :
    ConjugateIdeal.JstarBasis i = T3OpJbar.JbarBasisState i := rfl

/-- The trivial (identity) coordinate equivalence between the conjugate-ideal
coordinate model and the live `Jbar` wavefunction space. -/
noncomputable def coordEquiv :
    ConjugateIdeal.V ≃ₗ[ℂ] OperatorElectroweakIdentity.JbarWavefunction :=
  LinearEquiv.refl ℂ _

@[simp] theorem coordEquiv_basis (i : Fin 8) :
    coordEquiv (ConjugateIdeal.JstarBasis i) = T3OpJbar.JbarBasisState i := rfl

/-! ## Bridge to the octonionic minimal left ideal -/

/-- The compatibility bridge from the conjugate-ideal coordinate model all the
way to the **octonionic** minimal left ideal `Jbar' ⊆ ℂ⊗𝕆`, obtained by
composing the identity coordinate equivalence with the live octonionic
coordinate equivalence `jbarCoordinateEquivPackage.equiv`. -/
noncomputable def coordToJbarSubmodule :
    ConjugateIdeal.V ≃ₗ[ℂ] Jbar' :=
  coordEquiv.trans MinimalLeftIdeal.jbarCoordinateEquivPackage.equiv.symm

/-- Under the bridge, the conjugate-ideal basis label `JstarBasis i` maps to the
octonionic `Jbar` basis state `JbarBasisState' i`.  This is the basis-label
compatibility: the conjugate-ideal labelling and the live octonionic labelling
agree under the bridge. -/
theorem coordToJbarSubmodule_basis (i : Fin 8) :
    coordToJbarSubmodule (ConjugateIdeal.JstarBasis i) =
      ⟨JbarBasisState' i,
        Submodule.subset_span (Set.mem_range_self i)⟩ := by
  show MinimalLeftIdeal.jbarCoordinateEquivPackage.equiv.symm
      (T3OpJbar.JbarBasisState i) = _
  exact MinimalLeftIdeal.jbarCoordinateEquivPackage.basis_backward i

/-! ## Furey ↔ Jbar relabeling -/

/-- The Furey/Jbar relabeling permutation: the index reversal `Fin.rev` carrying
the electron-first `J`-sector order to the neutrino-first `Jbar`-sector order. -/
def jbarRelabel : Equiv.Perm (Fin 8) := Fin.revPerm

@[simp] theorem jbarRelabel_apply (i : Fin 8) : jbarRelabel i = i.rev := rfl

/-! ## Charge-table compatibility -/

/-- Same-convention agreement: the conjugate-ideal `J`-sector charge table equals
the live `Q_op` eigenvalue table `rawQopJ` (electron-first order). -/
theorem qJ_eq_rawQopJ (i : Fin 8) : ConjugateIdeal.qJ i = rawQopJ i := by
  fin_cases i <;> rfl

/-- Furey ↔ Jbar relabeling agreement: under the reversal relabeling the
conjugate-ideal `J`-sector charge table equals the live `Jbar`-sector raw
`Q_op` table `ElectroweakBridge.rawQop`. -/
theorem qJ_eq_rawQop_relabel (i : Fin 8) :
    ConjugateIdeal.qJ i = ElectroweakBridge.rawQop (jbarRelabel i) := by
  fin_cases i <;> rfl

/-- Conjugation convention: the conjugate-ideal charge is the negated raw `Q_op`
eigenvalue. -/
theorem qJstar_eq_neg_rawQopJ (i : Fin 8) :
    ConjugateIdeal.qJstar i = - rawQopJ i := by
  fin_cases i <;> rfl

/-! ## Bundled compatibility package -/

/-- The minimal conjugate-ideal ↔ live-`Jbar` coordinate compatibility bridge. -/
structure ConjugateIdealJbarBridge : Prop where
  /-- The two coordinate spaces coincide and their bases agree. -/
  basis_agree : ∀ i, ConjugateIdeal.JstarBasis i = T3OpJbar.JbarBasisState i
  /-- The bridge to the octonionic ideal maps basis labels to octonionic basis
  states. -/
  octonionic_basis_agree : ∀ i,
    coordToJbarSubmodule (ConjugateIdeal.JstarBasis i) =
      ⟨JbarBasisState' i, Submodule.subset_span (Set.mem_range_self i)⟩
  /-- The `J`-sector charge table agrees with the live eigenvalue table on the
  nose. -/
  charges_same_convention : ∀ i, ConjugateIdeal.qJ i = rawQopJ i
  /-- The `J`-sector charge table agrees with the live `Jbar` raw table under the
  reversal relabeling. -/
  charges_relabel : ∀ i,
    ConjugateIdeal.qJ i = ElectroweakBridge.rawQop (jbarRelabel i)
  /-- The conjugate charges are the negated live eigenvalues. -/
  conjugation_negates : ∀ i, ConjugateIdeal.qJstar i = - rawQopJ i

/-- **Main theorem (FUR-H9A).**  The conjugate-ideal coordinate model is
compatible with the live `Jbar` coordinate / eigenvalue machinery: the bases
agree (and lift to the octonionic ideal `Jbar'`), and the charge tables agree
both on the nose and under the explicit Furey↔Jbar reversal relabeling. -/
theorem conjugateIdealJbarBridge : ConjugateIdealJbarBridge where
  basis_agree := conjIdeal_basis_eq_jbar_basis
  octonionic_basis_agree := coordToJbarSubmodule_basis
  charges_same_convention := qJ_eq_rawQopJ
  charges_relabel := qJ_eq_rawQop_relabel
  conjugation_negates := qJstar_eq_neg_rawQopJ

end PhysicsSM.Draft.NullEdgeFureyJbarCoordinateBridge
