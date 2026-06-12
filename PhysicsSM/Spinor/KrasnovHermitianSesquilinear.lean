import Mathlib
import PhysicsSM.Spinor.KrasnovQubitHermitian
import PhysicsSM.Spinor.KrasnovComplexModuleInstance

/-!
# Spinor.KrasnovHermitianSesquilinear

ℂ-sesquilinearity of the Krasnov Hermitian form on `ℂ⁸`.

## Mathematical context

The `KrasnovQubitHermitian.lean` module defines `flatHermitian` (a Hermitian
form on the coordinate space `Fin 8 → ℂ`) and `flatNormSq`. The
`KrasnovComplexModuleInstance.lean` module provides `Module ℂ OctonionicQubit`
and the key identification `rightMulE111 q = Complex.I • q`.

This file proves that `flatHermitian` is **ℂ-sesquilinear**: ℂ-linear in the
second argument and ℂ-conjugate-linear (antilinear) in the first. It also
establishes Hermitian symmetry, positive semidefiniteness, and J-invariance.

### Note on qubit-level sesquilinearity

The original task proposed lifting sesquilinearity from `Fin 8 → ℂ` to
`OctonionicQubit` via `flattenQubit`. However, the Krasnov complex structure
on `OctonionicQubit` (given by `complexSmul z q = z.re • q + z.im • J(q)`)
acts as `+I` on line coordinates (indices 0, 4) and `-I` on complement
coordinates (indices 1, 2, 3, 5, 6, 7). This means `flattenQubit` is NOT
ℂ-linear from the Krasnov ℂ-module on `OctonionicQubit` to the standard
pointwise ℂ-module on `Fin 8 → ℂ`. Consequently, the proposed qubit-level
sesquilinearity statements are false as stated. See the commented-out
declarations below for details.

The coordinate-level sesquilinearity (`flatHermitian_linear_right`,
`flatHermitian_antilinear_left`) and J-invariance
(`flatHermitian_J_invariant`) are the correct and fully proved results.

## Claim boundary

This file proves sesquilinearity and J-invariance of the Krasnov Hermitian
form. It does **not** prove:
- That the isometry group of the form is U(8).
- Any intersection with Spin(9).
- The Standard Model gauge group centralizer theorem.

## Sources

- Kirill Krasnov, "SO(9) characterisation of the Standard Model gauge group",
  arXiv:1912.11282.
- Kirill Krasnov, "Octonions, complex structures and Standard Model fermions",
  arXiv:2504.16465.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open Complex Finset
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Convenience alias -/

/-- Flatten an `OctonionicQubit` to `Fin 8 → ℂ` by composing
    `toComplexCoordinates` with `toComplexVec`. -/
noncomputable def flattenQubit (q : OctonionicQubit) : Fin 8 → ℂ :=
  (toComplexCoordinates q).toComplexVec

/-! ## Sesquilinearity of flatHermitian -/

/-- `flatHermitian` is ℂ-linear in the second argument. -/
theorem flatHermitian_linear_right
    (q : Fin 8 → ℂ) (z : ℂ) (r₁ r₂ : Fin 8 → ℂ) :
    QubitComplexCoordinates.flatHermitian q (z • r₁ + r₂) =
      z * QubitComplexCoordinates.flatHermitian q r₁ +
        QubitComplexCoordinates.flatHermitian q r₂ := by
  unfold QubitComplexCoordinates.flatHermitian; ring;
  simp +decide [mul_add, mul_assoc, mul_left_comm, Finset.mul_sum _ _ _,
    Finset.sum_add_distrib]

/-- `flatHermitian` is ℂ-conjugate-linear in the first argument. -/
theorem flatHermitian_antilinear_left
    (z : ℂ) (q : Fin 8 → ℂ) (r : Fin 8 → ℂ) :
    QubitComplexCoordinates.flatHermitian (z • q) r =
      starRingEnd ℂ z * QubitComplexCoordinates.flatHermitian q r := by
  unfold QubitComplexCoordinates.flatHermitian;
  simp +decide [mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _]

/-- `flatHermitian` is Hermitian symmetric. -/
theorem flatHermitian_conj_symm (q r : Fin 8 → ℂ) :
    QubitComplexCoordinates.flatHermitian q r =
      starRingEnd ℂ (QubitComplexCoordinates.flatHermitian r q) := by
  simp +decide [QubitComplexCoordinates.flatHermitian];
  ac_rfl

/-- `flatHermitian` is positive semidefinite. -/
theorem flatHermitian_pos_semidef (q : Fin 8 → ℂ) :
    0 ≤ (QubitComplexCoordinates.flatHermitian q q).re ∧
    (QubitComplexCoordinates.flatHermitian q q).im = 0 := by
  unfold QubitComplexCoordinates.flatHermitian
  simp +decide [mul_comm, Complex.ext_iff]
  exact Finset.sum_nonneg fun _ _ => add_nonneg (mul_self_nonneg _) (mul_self_nonneg _)

/-! ## Qubit-level sesquilinearity — corrected analysis

The original task proposed the following qubit-level sesquilinearity theorems:

```
theorem flatHermitian_linear_right_qubit
    (q : OctonionicQubit) (z : ℂ) (r₁ r₂ : OctonionicQubit) :
    flatHermitian (flattenQubit q) (flattenQubit (z • r₁ + r₂)) =
      z * flatHermitian (flattenQubit q) (flattenQubit r₁) +
        flatHermitian (flattenQubit q) (flattenQubit r₂)

theorem flatHermitian_antilinear_left_qubit
    (z : ℂ) (q r : OctonionicQubit) :
    flatHermitian (flattenQubit (z • q)) (flattenQubit r) =
      starRingEnd ℂ z * flatHermitian (flattenQubit q) (flattenQubit r)
```

**These are false.** The reason: `flattenQubit` is NOT ℂ-linear from the
Krasnov ℂ-module on `OctonionicQubit` to the standard pointwise ℂ-module on
`Fin 8 → ℂ`.

Specifically, the Krasnov ℂ-action is `z • q = z.re • q + z.im • J(q)`, where
`J = rightMulE111`. In flattened coordinates, J acts as multiplication by `+I`
on line coordinates (indices 0, 4) but as multiplication by `-I` on complement
coordinates (indices 1, 2, 3, 5, 6, 7). Therefore:

- `flattenQubit (I • q) i = I * flattenQubit q i` for line indices `i ∈ {0, 4}`
- `flattenQubit (I • q) i = -I * flattenQubit q i` for complement indices

This means `flattenQubit (I • q) ≠ I • flattenQubit q` whenever complement
coordinates are nonzero, and the qubit-level sesquilinearity fails.

The coordinate-level sesquilinearity (`flatHermitian_linear_right` and
`flatHermitian_antilinear_left`) and J-invariance (`flatHermitian_J_invariant`)
are the correct and complete results.
-/

/-! ## J preserves the Hermitian form -/

/-- Right multiplication by e111 (= i •) preserves the Hermitian norm.

This follows from `rightMulE111` acting diagonally with unit eigenvalues
(+I and -I), so `|eigenvalue|² = 1` at each coordinate. -/
theorem flatHermitian_J_invariant (q : OctonionicQubit) :
    QubitComplexCoordinates.flatHermitian
        (flattenQubit (rightMulE111 q))
        (flattenQubit (rightMulE111 q)) =
      QubitComplexCoordinates.flatHermitian
        (flattenQubit q) (flattenQubit q) := by
  convert QubitComplexCoordinates.flatHermitian_diagonal_left
    ((toComplexCoordinates q).toComplexVec)
    ((toComplexCoordinates q).toComplexVec) using 1
  rw [← toComplexVec_toComplexCoordinates_rightMulE111]
  rfl

/-! ## Bundled package -/

/-- A package bundling the sesquilinearity, Hermitian symmetry, and
    J-invariance of the Krasnov Hermitian form. -/
structure KrasnovHermitianSesquilinearPackage where
  /-- Sesquilinearity: linear in second argument. -/
  linear_right :
    ∀ (q : Fin 8 → ℂ) (z : ℂ) (r₁ r₂ : Fin 8 → ℂ),
      QubitComplexCoordinates.flatHermitian q (z • r₁ + r₂) =
        z * QubitComplexCoordinates.flatHermitian q r₁ +
          QubitComplexCoordinates.flatHermitian q r₂
  /-- Sesquilinearity: conjugate-linear in first argument. -/
  antilinear_left :
    ∀ (z : ℂ) (q r : Fin 8 → ℂ),
      QubitComplexCoordinates.flatHermitian (z • q) r =
        starRingEnd ℂ z * QubitComplexCoordinates.flatHermitian q r
  /-- Hermitian symmetry. -/
  conj_symm :
    ∀ (q r : Fin 8 → ℂ),
      QubitComplexCoordinates.flatHermitian q r =
        starRingEnd ℂ (QubitComplexCoordinates.flatHermitian r q)
  /-- J (= rightMulE111) preserves the norm. -/
  J_norm_preserving :
    ∀ q : OctonionicQubit,
      QubitComplexCoordinates.flatHermitian
          (flattenQubit (rightMulE111 q))
          (flattenQubit (rightMulE111 q)) =
        QubitComplexCoordinates.flatHermitian
          (flattenQubit q) (flattenQubit q)

/-- The fully verified sesquilinearity package. -/
noncomputable def krasnovHermitianSesquilinearPackage :
    KrasnovHermitianSesquilinearPackage where
  linear_right := flatHermitian_linear_right
  antilinear_left := flatHermitian_antilinear_left
  conj_symm := flatHermitian_conj_symm
  J_norm_preserving := flatHermitian_J_invariant

end PhysicsSM.Spinor.KrasnovComplexStructure
