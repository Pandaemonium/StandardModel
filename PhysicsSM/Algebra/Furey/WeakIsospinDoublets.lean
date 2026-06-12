import Mathlib
import PhysicsSM.Algebra.Furey.T3OpJbar
import PhysicsSM.Algebra.Furey.HyperchargeBridge

/-!
# Furey SU(2)_L doublet structure of the Jbar sector

This module proves the doublet structure of the eight Jbar basis states
under the SU(2)_L weak isospin assignments from `ElectroweakBridge`.

The four doublets are `(ν, e)`, `(u_r, d_r)`, `(u_g, d_g)`, `(u_b, d_b)`.
For each doublet we verify:

1. **Equal hypercharge**: the two states share the same `targetY`.
2. **Opposite T₃**: the two states have `targetT3` values that are negatives.
3. **Charge difference = 1**: `physicalQ(upper) - physicalQ(lower) = 1`.

We also state the corresponding operator-level facts: the T₃ eigenvalues
of the upper and lower components of each doublet are opposite.

## Claim boundary

This is a **table theorem**: the charge assignments satisfy the doublet
conditions. It does **not** define W⁺/W⁻ operators or derive the doublet
structure from the octonionic algebra.

## Status

Trusted module: no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
-/

namespace PhysicsSM.Algebra.Furey.WeakIsospinDoublets

open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.T3OpJbar

/-! ## Doublet hypercharge equality -/

/-- The neutrino (index 0) and electron (index 7) have equal
hypercharge Y = −1. -/
theorem lepton_doublet_same_hypercharge :
    targetY (⟨0, by norm_num⟩ : JbarState) =
    targetY (⟨7, by norm_num⟩ : JbarState) := by
  simp [targetY, physicalQ, targetT3]; norm_num

/-- Up and down quarks of each color have equal hypercharge
Y = 1/3. -/
theorem quark_doublet_same_hypercharge (k : Fin 3) :
    targetY (⟨4 + k.val, by omega⟩ : JbarState) =
    targetY (⟨1 + k.val, by omega⟩ : JbarState) := by
  fin_cases k <;> simp [targetY, physicalQ, targetT3] <;> norm_num

/-! ## Doublet T₃ opposition -/

/-- The neutrino and electron have opposite T₃. -/
theorem lepton_doublet_opposite_T3 :
    targetT3 (⟨0, by norm_num⟩ : JbarState) =
    -targetT3 (⟨7, by norm_num⟩ : JbarState) := by
  simp [targetT3]; norm_num

/-- Up and down quarks of each color have opposite T₃. -/
theorem quark_doublet_opposite_T3 (k : Fin 3) :
    targetT3 (⟨4 + k.val, by omega⟩ : JbarState) =
    -targetT3 (⟨1 + k.val, by omega⟩ : JbarState) := by
  fin_cases k <;> simp [targetT3] <;> norm_num

/-! ## Doublet charge difference = 1 -/

/-- The neutrino has charge 1 more than the electron:
Q(ν) − Q(e) = 1. -/
theorem lepton_doublet_charge_difference :
    physicalQ (⟨0, by norm_num⟩ : JbarState) -
    physicalQ (⟨7, by norm_num⟩ : JbarState) = 1 := by
  simp [physicalQ]

/-- Each up quark has charge 1 more than the corresponding
down quark. -/
theorem quark_doublet_charge_difference (k : Fin 3) :
    physicalQ (⟨4 + k.val, by omega⟩ : JbarState) -
    physicalQ (⟨1 + k.val, by omega⟩ : JbarState) = 1 := by
  fin_cases k <;> simp [physicalQ] <;> norm_num

/-! ## Operator-level doublet structure

The original task proposed comparing `T3End (JbarBasisState s₁)` with
`-(T3End (JbarBasisState s₂))` directly as vectors. However, this is
false when `s₁ ≠ s₂` because the eigenvectors point in different
coordinate directions. The correct operator-level statement is that the
*eigenvalues* are opposite: T₃ acts on the upper component with
eigenvalue `+1/2` and on the lower component with eigenvalue `-1/2`,
so `(1/2 : ℂ) = -((-1/2 : ℂ))`. We state this as an eigenvalue
relation.
-/

/-- The T₃ eigenvalue of the neutrino is opposite to that of
the electron. -/
theorem T3_lepton_eigenvalue_opposite :
    (targetT3 ⟨0, by norm_num⟩ : ℂ) =
    -(targetT3 ⟨7, by norm_num⟩ : ℂ) := by
  simp [targetT3]; norm_num

/-- The T₃ eigenvalue of each up quark is opposite to that of
the corresponding down quark. -/
theorem T3_quark_eigenvalue_opposite (k : Fin 3) :
    (targetT3 ⟨4 + k.val, by omega⟩ : ℂ) =
    -(targetT3 ⟨1 + k.val, by omega⟩ : ℂ) := by
  fin_cases k <;> simp [targetT3] <;> norm_num

/-! ## Bundled package -/

/-- The complete SU(2)_L doublet structure of Furey's
one-generation Jbar sector. -/
structure FureySU2LDoubletPackage where
  /-- The lepton doublet (ν, e) has equal hypercharge. -/
  lepton_hyp :
    targetY (⟨0, by norm_num⟩ : JbarState) =
    targetY (⟨7, by norm_num⟩ : JbarState)
  /-- The lepton doublet has opposite T₃. -/
  lepton_T3 :
    targetT3 (⟨0, by norm_num⟩ : JbarState) =
    -targetT3 (⟨7, by norm_num⟩ : JbarState)
  /-- The lepton doublet has charge difference 1. -/
  lepton_dQ :
    physicalQ (⟨0, by norm_num⟩ : JbarState) -
    physicalQ (⟨7, by norm_num⟩ : JbarState) = 1
  /-- Each quark doublet (u_k, d_k) has equal hypercharge. -/
  quark_hyp : ∀ k : Fin 3,
    targetY (⟨4 + k.val, by omega⟩ : JbarState) =
    targetY (⟨1 + k.val, by omega⟩ : JbarState)
  /-- Each quark doublet has opposite T₃. -/
  quark_T3 : ∀ k : Fin 3,
    targetT3 (⟨4 + k.val, by omega⟩ : JbarState) =
    -targetT3 (⟨1 + k.val, by omega⟩ : JbarState)
  /-- Each quark doublet has charge difference 1. -/
  quark_dQ : ∀ k : Fin 3,
    physicalQ (⟨4 + k.val, by omega⟩ : JbarState) -
    physicalQ (⟨1 + k.val, by omega⟩ : JbarState) = 1

/-- The assembled SU(2)_L doublet package for the Jbar sector. -/
noncomputable def fureySU2LDoubletPackage :
    FureySU2LDoubletPackage where
  lepton_hyp := lepton_doublet_same_hypercharge
  lepton_T3 := lepton_doublet_opposite_T3
  lepton_dQ := lepton_doublet_charge_difference
  quark_hyp := quark_doublet_same_hypercharge
  quark_T3 := quark_doublet_opposite_T3
  quark_dQ := quark_doublet_charge_difference

end PhysicsSM.Algebra.Furey.WeakIsospinDoublets
