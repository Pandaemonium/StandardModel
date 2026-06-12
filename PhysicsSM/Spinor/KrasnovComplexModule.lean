import Mathlib
import PhysicsSM.Spinor.KrasnovComplexCentralizer

/-!
# Spinor.KrasnovComplexModule

The ℂ-module structure on `OctonionicQubit` induced by the Krasnov complex
structure `J = rightMulE111`.

## Mathematical context

The complex scalar action `complexSmul z q = z.re • q + z.im • J(q)` turns
`𝕆²` into an 8-dimensional complex vector space. This file verifies the
module axioms: identity, distributivity over both scalar and vector addition,
compatibility with scalar multiplication, and zero laws.

The key identity is the multiplicativity `complexSmul (z * w) = complexSmul z ∘ complexSmul w`,
which relies on `J² = -id` (proved as `rightMulE111_sq_neg`).

## Claim boundary

This file proves the ℂ-module laws for the Krasnov complex structure. It
does **not** claim an orthonormal basis of ℂ⁸, a representation of
Spin(9), or a Standard Model gauge group identification.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Helper lemmas for rightMulE111 -/

/-- `rightMulE111` distributes over addition. -/
theorem rightMulE111_add (q r : OctonionicQubit) :
    rightMulE111 (q + r) = rightMulE111 q + rightMulE111 r := by
  ext <;> simp [rightMulE111] <;> ring

/-! ## Module laws -/

/-- `complexSmul 1 q = q` -/
theorem complexSmul_one (q : OctonionicQubit) :
    complexSmul 1 q = q := by
  convert OctonionicQubit_one_smul q
  convert OctonionicQubit_one_smul q
  exact iff_of_true (funext fun q => by unfold complexSmul; aesop) (OctonionicQubit_one_smul q)

/-- `complexSmul (z + w) q = complexSmul z q + complexSmul w q` -/
theorem complexSmul_add_left (z w : ℂ) (q : OctonionicQubit) :
    complexSmul (z + w) q = complexSmul z q + complexSmul w q := by
  norm_num [complexSmul]
  ext <;> simp [add_smul, add_assoc, add_comm, add_left_comm]
  all_goals ring

/-- `complexSmul z (q + r) = complexSmul z q + complexSmul z r` -/
theorem complexSmul_add_right (z : ℂ) (q r : OctonionicQubit) :
    complexSmul z (q + r) = complexSmul z q + complexSmul z r := by
  ext
  all_goals simp +decide [rightMulE111_add, complexSmul]; ring

/-- `complexSmul (z * w) q = complexSmul z (complexSmul w q)` -/
theorem complexSmul_mul (z w : ℂ) (q : OctonionicQubit) :
    complexSmul (z * w) q = complexSmul z (complexSmul w q) := by
  simp [complexSmul]
  ext <;> norm_num [rightMulE111_add, rightMulE111_smul] <;> ring
  all_goals
    rw [show rightMulE111 (rightMulE111 q) = -q from rightMulE111_sq_neg q]
    norm_num; ring

/-- `complexSmul 0 q = 0` -/
theorem complexSmul_zero_left (q : OctonionicQubit) :
    complexSmul 0 q = 0 := by
  ext
  all_goals unfold complexSmul; norm_num [OctonionicQubit_zero_smul]

/-- `complexSmul z 0 = 0` -/
theorem complexSmul_zero_right (z : ℂ) :
    complexSmul z 0 = 0 := by
  ext <;> simp +decide [complexSmul]
  all_goals unfold rightMulE111; simp +decide [Octonion.ext_iff]

/-! ## Package -/

/-- A package bundling the ℂ-module laws for the Krasnov complex structure,
    establishing that `complexSmul` gives `OctonionicQubit` the structure
    of a module over `ℂ`. -/
structure KrasnovComplexModulePackage where
  complexSmul_one : ∀ q : OctonionicQubit, complexSmul 1 q = q
  complexSmul_mul : ∀ z w : ℂ, ∀ q : OctonionicQubit,
      complexSmul (z * w) q = complexSmul z (complexSmul w q)
  complexSmul_add_left : ∀ z w : ℂ, ∀ q : OctonionicQubit,
      complexSmul (z + w) q = complexSmul z q + complexSmul w q
  complexSmul_add_right : ∀ z : ℂ, ∀ q r : OctonionicQubit,
      complexSmul z (q + r) = complexSmul z q + complexSmul z r

/-- Witness of the ℂ-module package: all module laws verified. -/
def krasnovComplexModulePackage : KrasnovComplexModulePackage where
  complexSmul_one := complexSmul_one
  complexSmul_mul := complexSmul_mul
  complexSmul_add_left := complexSmul_add_left
  complexSmul_add_right := complexSmul_add_right

end PhysicsSM.Spinor.KrasnovComplexStructure
