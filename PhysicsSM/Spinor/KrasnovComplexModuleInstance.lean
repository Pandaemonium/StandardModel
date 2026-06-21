import Mathlib
import PhysicsSM.Spinor.KrasnovComplexModule

/-!
# Spinor.KrasnovComplexModuleInstance

Typeclass instances upgrading the Krasnov complex-structure scalar laws
to actual `SMul`, `AddCommGroup`, and `Module` instances on `OctonionicQubit`.

## Mathematical context

The complex scalar action `complexSmul z q = z.re • q + z.im • J(q)` (where
`J = rightMulE111`) turns `𝕆²` into an 8-dimensional complex vector space.
The file `KrasnovComplexModule.lean` proves the module laws as standalone
theorems; this file packages them as actual Lean typeclass instances.

## Claim boundary

This is a complex vector-space API for the Krasnov qubit. It does not prove a
Spin(9) representation theorem, a Standard Model centralizer theorem, or a
physical chirality result.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Sub instance -/

instance : Sub OctonionicQubit where
  sub a b := ⟨a.fst - b.fst, a.snd - b.snd⟩

@[simp] theorem sub_fst (a b : OctonionicQubit) :
    (a - b).fst = a.fst - b.fst := rfl
@[simp] theorem sub_snd (a b : OctonionicQubit) :
    (a - b).snd = a.snd - b.snd := rfl

/-! ## AddCommGroup instance -/

private def qubitNSMul : ℕ → OctonionicQubit → OctonionicQubit
  | 0, _ => 0
  | n + 1, q => qubitNSMul n q + q

private def qubitZSMul : ℤ → OctonionicQubit → OctonionicQubit
  | .ofNat n, q => qubitNSMul n q
  | .negSucc n, q => -(qubitNSMul (n + 1) q)

set_option maxHeartbeats 400000 in
-- OctonionicQubit has no pre-existing AddCommGroup; componentwise ext proofs are heavy.
instance : AddCommGroup OctonionicQubit where
  add_assoc a b c := by ext <;> simp [add_assoc]
  zero_add a := by ext <;> simp
  add_zero a := by ext <;> simp
  add_comm a b := by ext <;> simp [add_comm]
  neg_add_cancel a := by ext <;> simp
  sub_eq_add_neg a b := by ext <;> simp [sub_eq_add_neg]
  nsmul := qubitNSMul
  zsmul := qubitZSMul
  nsmul_zero a := by simp [qubitNSMul]
  nsmul_succ n a := by simp [qubitNSMul]
  zsmul_zero' a := by simp [qubitZSMul, qubitNSMul]
  zsmul_succ' n a := by simp [qubitZSMul, qubitNSMul]
  zsmul_neg' n a := by simp [qubitZSMul]

/-! ## Module ℝ instance -/

set_option maxHeartbeats 400000 in
-- Componentwise ext + ring proofs for the 16 real coordinates of 𝕆².
noncomputable instance : Module ℝ OctonionicQubit where
  one_smul a := by ext <;> simp
  mul_smul r s a := by ext <;> simp <;> ring
  smul_zero r := by ext <;> simp
  smul_add r a b := by ext <;> simp <;> ring
  add_smul r s a := by ext <;> simp <;> ring
  zero_smul a := by ext <;> simp

/-! ## SMul ℂ instance -/

noncomputable instance : SMul ℂ OctonionicQubit where
  smul z q := complexSmul z q

@[simp] theorem complex_smul_def (z : ℂ) (q : OctonionicQubit) :
    z • q = complexSmul z q := rfl

/-! ## Module ℂ instance -/

noncomputable instance : Module ℂ OctonionicQubit where
  one_smul q := by
    simp only [complex_smul_def]
    exact complexSmul_one q
  mul_smul z w q := by
    simp only [complex_smul_def]
    exact complexSmul_mul z w q
  smul_zero z := by
    simp only [complex_smul_def]
    exact complexSmul_zero_right z
  smul_add z q r := by
    simp only [complex_smul_def]
    exact complexSmul_add_right z q r
  add_smul z w q := by
    simp only [complex_smul_def]
    exact complexSmul_add_left z w q
  zero_smul q := by
    simp only [complex_smul_def]
    exact complexSmul_zero_left q

/-! ## Simp wrappers and restatements -/

theorem rightMulE111_eq_I_smul (q : OctonionicQubit) :
    rightMulE111 q = Complex.I • q := by
  simp only [complex_smul_def, complexSmul]
  ext <;> simp [rightMulE111]

/-- The centralizer theorem restated with actual scalar notation. -/
theorem commutesWithRightMulE111_iff_map_complex_smul
    (T : OctonionicQubit → OctonionicQubit)
    (hT_lin : IsRealLinear T) :
    CommutesWithRightMulE111 T ↔
      ∀ z : ℂ, ∀ q : OctonionicQubit,
        T (z • q) = z • T q := by
  constructor
  · intro hT_comm z q
    simp only [complex_smul_def]
    exact commutesWithRightMulE111_complexLinear T hT_lin hT_comm z q
  · intro h
    have h' : ∀ z : ℂ, ∀ q : OctonionicQubit,
        T (complexSmul z q) = complexSmul z (T q) := by
      intro z q; exact h z q
    exact complexLinear_commutesWithRightMulE111 T hT_lin h'

/-! ## Package -/

/-- A package bundling the `Module ℂ OctonionicQubit` instance together with
    the identification of `rightMulE111` as multiplication by `Complex.I`. -/
structure KrasnovComplexModuleInstancePackage where
  module_inst : Module ℂ OctonionicQubit
  I_smul :
    ∀ q : OctonionicQubit, rightMulE111 q = Complex.I • q

noncomputable def krasnovComplexModuleInstancePackage :
    KrasnovComplexModuleInstancePackage where
  module_inst := inferInstance
  I_smul := rightMulE111_eq_I_smul

end PhysicsSM.Spinor.KrasnovComplexStructure
