import PhysicsSM.Algebra.Furey.JbarActionTable
import PhysicsSM.Algebra.Furey.JbarCoordinateEquiv

/-!
# Corrected Furey basis and the three-mode exterior action table

This module identifies the eight corrected `Jbar'` basis labels with all
subsets of three ordered modes. Under that bijection, every one of the 48
creation/annihilation table entries agrees exactly with the standard signed
exterior-basis rule. It also composes the trusted coordinate equivalence for
the corrected octonionic span with this occupancy reindexing.

Scope: `jbarAlphaAction_eq_fockAction` is an exact comparison of finite action
tables. The imported theorem `alpha_mul_JbarBasisState'_eq_action` separately
proves that the Furey table describes explicitly parenthesized left
multiplication on every corrected basis state. This module does not yet bundle
those left multiplications as endomorphisms of the whole `Jbar'` submodule or
prove a linear-operator intertwining theorem. It makes no claim that raw
octonion multiplication is associative, and it does not derive an `SU(3)`
action or particle-antiparticle interpretation.

Provenance: proofs synthesized by Aristotle project
`2b4328ae-c91d-4bb5-b726-61f423895e62` and independently reviewed and compiled
against the pinned repository toolchain on 2026-07-11. Finite case proofs use
kernel evaluation only, not compiled evaluation.
-/

noncomputable section

namespace PhysicsSM.Draft.JordanCliffordFureyFockBridge

open PhysicsSM.Algebra.Furey
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open PhysicsSM.Algebra.Furey.JbarLinearIndependence
open PhysicsSM.Algebra.Furey.T3OpJbar
open PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity

/-- Occupied color modes for each corrected Furey `Jbar'` basis state. -/
def occupancy : Fin 8 -> Finset (Fin 3)
  | 0 => {}
  | 1 => {0}
  | 2 => {1}
  | 3 => {2}
  | 4 => {0, 1}
  | 5 => {0, 2}
  | 6 => {1, 2}
  | 7 => {0, 1, 2}

theorem occupancy_bijective : Function.Bijective occupancy := by
  decide

noncomputable def occupancyEquiv : Fin 8 ≃ Finset (Fin 3) :=
  Equiv.ofBijective occupancy occupancy_bijective

/-- Standard exterior-basis sign: minus exactly when an odd number of
occupied lower-index modes precedes `k`. -/
def fockSign (S : Finset (Fin 3)) (k : Fin 3) : Complex :=
  if (S.filter fun j => j < k).card % 2 = 0 then 1 else -1

/-- Standard signed creation (`dagger = true`) or contraction
(`dagger = false`) action on the three-mode exterior basis. -/
def fockAction (dagger : Bool) (k : Fin 3) (S : Finset (Fin 3)) :
    Option (Complex × Finset (Fin 3)) :=
  if dagger then
    if k ∈ S then none else some (fockSign S k, insert k S)
  else
    if k ∈ S then some (fockSign S k, S.erase k) else none

/-- The complete corrected Furey ladder table is the standard signed
three-mode exterior-basis creation/contraction table. -/
theorem jbarAlphaAction_eq_fockAction
    (dagger : Bool) (k : Fin 3) (s : Fin 8) :
    (jbarAlphaAction dagger k s).map
        (fun x => (x.1, occupancy x.2)) =
      fockAction dagger k (occupancy s) := by
  fin_cases dagger <;> fin_cases k <;> fin_cases s <;>
    simp only [jbarAlphaAction, occupancy, fockAction, fockSign,
      Option.map_some, Option.map_none] <;>
    norm_num [Finset.filter_insert, Finset.filter_singleton, Finset.ext_iff] <;>
    decide

/-- Coordinate wavefunctions on the eight corrected Furey states are
linearly equivalent to wavefunctions on all three-mode exterior labels. -/
def reindexWavefunction :
    JbarWavefunction ≃ₗ[Complex] (Finset (Fin 3) -> Complex) where
  toFun psi S := psi (occupancyEquiv.symm S)
  invFun phi s := phi (occupancyEquiv s)
  left_inv psi := by
    funext s
    simp
  right_inv phi := by
    funext S
    simp
  map_add' psi chi := by
    rfl
  map_smul' c psi := by
    rfl

/-- The corrected concrete octonionic span is linearly equivalent to the
three-mode exterior-basis coordinate module. -/
def jbarFockLinearEquiv :
    Jbar' ≃ₗ[Complex] (Finset (Fin 3) -> Complex) :=
  JbarSubmoduleLinearEquivWavefunction.trans reindexWavefunction

/-- Standard basis vector at an exterior occupancy label. -/
def fockBasis (S : Finset (Fin 3)) : Finset (Fin 3) -> Complex :=
  Pi.single S 1

/-- The linear equivalence sends every corrected Furey basis state to the
matching exterior occupancy basis vector. -/
theorem jbarFockLinearEquiv_basis (s : Fin 8) :
    jbarFockLinearEquiv
      ⟨JbarBasisState' s,
        Submodule.subset_span (Set.mem_range_self s)⟩ =
      fockBasis (occupancy s) := by
  rw [jbarFockLinearEquiv, LinearEquiv.trans_apply,
      JbarSubmoduleLinearEquivWavefunction_basis]
  funext S
  show JbarBasisState s (occupancyEquiv.symm S) = fockBasis (occupancy s) S
  simp only [JbarBasisState, fockBasis]
  rw [Pi.single_apply, Pi.single_apply]
  simp only [Equiv.symm_apply_eq]
  rfl

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.JordanCliffordFureyFockBridge.occupancy_bijective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms occupancy_bijective

/-- info: 'PhysicsSM.Draft.JordanCliffordFureyFockBridge.jbarAlphaAction_eq_fockAction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms jbarAlphaAction_eq_fockAction

/-- info: 'PhysicsSM.Draft.JordanCliffordFureyFockBridge.jbarFockLinearEquiv_basis' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms jbarFockLinearEquiv_basis

end PhysicsSM.Draft.JordanCliffordFureyFockBridge
