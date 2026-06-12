import Mathlib
import PhysicsSM.Algebra.Furey.QopJbarEigenBridge
import PhysicsSM.Algebra.Furey.HyperchargeBridge
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity

/-!
# Furey T₃ weak-isospin operator on the Jbar sector

This module formalizes the weak isospin third-component operator `T₃` as a
diagonal continuous-linear endomorphism on the `JbarWavefunction` space and
proves it has the correct eigenvalues from the Standard Model electroweak
table in `ElectroweakBridge`.

## Claim boundary

This file formalizes the weak isospin T₃ operator for the Jbar sector. It
does **not** derive T₃ from the octonionic ladder algebra — the table values
are taken from the Standard Model literature. A future derivation from the
division-algebra structure would be a separate result.

## Main declarations

- `T3End` — the T₃ diagonal operator on `JbarWavefunction`.
- `T3End_eigenvalue` — eigenvalue theorem for each basis state.
- `T3End_eq_targetT3End` — equality with the target operator from
  `OperatorElectroweakIdentity`.
- `T3End_add_half_YEnd_eq_QEnd` — operator-level Gell-Mann–Nishijima.
- `T3End_neutrino`, `T3End_electron`, `T3End_uQuark`, `T3End_dQuark` —
  individual doublet structure theorems.
- `T3OpJbarPackage` / `t3OpJbarPackage` — bundled package of all results.

## Status

Trusted module: no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
-/

namespace PhysicsSM.Algebra.Furey.T3OpJbar

open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
open Complex

/-! ## Wavefunction basis states -/

/-- The standard basis state for `JbarWavefunction`: the indicator function
    that is `1` at state `s` and `0` elsewhere. -/
noncomputable def JbarBasisState (s : JbarState) : JbarWavefunction :=
  Pi.single s 1

/-! ## T₃ operator definition -/

/-- The T₃ weak-isospin operator on `JbarWavefunction`, as the diagonal
    continuous-linear endomorphism whose eigenvalue on `JbarBasisState s`
    is `targetT3 s`. -/
noncomputable def T3End :
    JbarWavefunction →L[ℂ] JbarWavefunction :=
  diagonalEnd (fun s => (targetT3 s : ℂ))

/-! ## Eigenvalue theorem -/

/-- T₃ acts on `JbarBasisState s` with eigenvalue `targetT3 s`. -/
theorem T3End_eigenvalue (s : JbarState) :
    T3End (JbarBasisState s) = (targetT3 s : ℚ) • JbarBasisState s := by
  ext t
  by_cases h : t = s <;> simp +decide [h]
  · simp [T3End, JbarBasisState]
  · unfold T3End JbarBasisState; simp +decide [h, diagonalEnd_apply]

/-! ## Equality with targetT3End -/

/-- `T3End` equals the `targetT3End` defined in `OperatorElectroweakIdentity`. -/
theorem T3End_eq_targetT3End : T3End = targetT3End := by
  rfl

/-! ## Gell-Mann–Nishijima relation at operator level -/

/-- The operator-level GMN relation: `Q_op = T3End + (1/2) • YEnd`. -/
theorem T3End_add_half_YEnd_eq_QEnd :
    T3End + (1/2 : ℂ) • targetYEnd = physicalQEnd := by
  rw [T3End_eq_targetT3End,
    physicalQEnd_eq_targetT3End_add_half_targetYEnd.symm]

/-! ## Weak isospin doublet structure -/

/-
The neutrino state (index 0) has T₃ = +1/2.
-/
theorem T3End_neutrino :
    T3End (JbarBasisState ⟨0, by norm_num⟩) =
      (1/2 : ℂ) • JbarBasisState ⟨0, by norm_num⟩ := by
  convert T3End_eigenvalue ⟨ 0, by decide ⟩ using 1 ; norm_num [ ElectroweakBridge.targetT3 ];
  ext; norm_num [ JbarBasisState ] ;
  rename_i x; fin_cases x <;> norm_num [ Pi.single_apply ] ;

/-
The electron state (index 7) has T₃ = -1/2.
-/
theorem T3End_electron :
    T3End (JbarBasisState ⟨7, by norm_num⟩) =
      (-1/2 : ℂ) • JbarBasisState ⟨7, by norm_num⟩ := by
  -- Apply the definition of T3End as the diagonal operator with entries targetT3.
  convert T3End_eigenvalue ⟨7, by norm_num⟩ using 1;
  norm_num [ targetT3, JbarBasisState ];
  ext; norm_num [ Algebra.smul_def ] ;

/-
The up-quark states (indices 4-6) have T₃ = +1/2.
-/
theorem T3End_uQuark (k : Fin 3) :
    T3End (JbarBasisState ⟨4 + k.val, by omega⟩) =
      (1/2 : ℂ) • JbarBasisState ⟨4 + k.val, by omega⟩ := by
  convert T3End_eigenvalue ⟨ 4 + k, by fin_cases k <;> decide ⟩ using 1 ; norm_num [ Fin.ext_iff ];
  fin_cases k <;> norm_num [ Fin.ext_iff, targetT3 ];
  · ext;
    norm_num [ Algebra.smul_def ];
  · ext;
    norm_num [ Algebra.smul_def ];
  · ext;
    norm_num [ Algebra.smul_def ]

/-
The down-quark states (indices 1-3) have T₃ = -1/2.
-/
theorem T3End_dQuark (k : Fin 3) :
    T3End (JbarBasisState ⟨1 + k.val, by omega⟩) =
      (-1/2 : ℂ) • JbarBasisState ⟨1 + k.val, by omega⟩ := by
  convert T3End_eigenvalue ⟨ 1 + k.val, by fin_cases k <;> trivial ⟩ using 1
  fin_cases k <;> simp +decide [targetT3] <;> norm_cast

/-! ## Package -/

/-- Bundled package of T₃ operator results for the Jbar sector. -/
structure T3OpJbarPackage where
  /-- T₃ is the diagonal operator with eigenvalues from the charge table. -/
  T3_def : T3End = targetT3End
  /-- T₃ eigenvalue on each Jbar basis state. -/
  T3_eigenvalue : ∀ s : JbarState,
      T3End (JbarBasisState s) = (targetT3 s : ℚ) • JbarBasisState s
  /-- The operator-level Gell-Mann–Nishijima relation. -/
  gmn_operator : T3End + (1/2 : ℂ) • targetYEnd = physicalQEnd

/-- The assembled T₃ operator package for the Jbar sector. -/
noncomputable def t3OpJbarPackage : T3OpJbarPackage where
  T3_def := T3End_eq_targetT3End
  T3_eigenvalue := T3End_eigenvalue
  gmn_operator := T3End_add_half_YEnd_eq_QEnd

end PhysicsSM.Algebra.Furey.T3OpJbar
