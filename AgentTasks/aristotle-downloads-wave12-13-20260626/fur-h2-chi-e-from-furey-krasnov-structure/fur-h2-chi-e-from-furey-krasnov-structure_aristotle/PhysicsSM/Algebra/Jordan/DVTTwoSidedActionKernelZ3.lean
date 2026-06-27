import Mathlib
import PhysicsSM.Algebra.Jordan.DVTMatrixLeftRightKernel
import PhysicsSM.Algebra.Jordan.DVTZ3CentralUnitEquiv

/-!
# Algebra.Jordan.DVTTwoSidedActionKernelZ3

Refines the existing matrix left-right identity kernel theorem to the
determinant-one `ℤ₃` kernel: if `A * X * B = X` for all `3 × 3` complex
matrices, `A` and `B` are units with `det A = 1` and `det B = 1`, then the
kernel scalar `z` satisfies `z ^ 3 = 1`, i.e. the kernel is the cube roots
of unity.

## Main declarations

- `det_scalar_matrix_fin3` — determinant of a scalar `3 × 3` matrix is `z ^ 3`.
- `matrix_left_right_identity_kernel_z3` — the main Z₃ kernel theorem.
- `h3oComplementTwoSidedAction_kernel_z3` — transport to `H3OComplement`.
- `DVTTwoSidedActionKernelZ3Package` / `dvtTwoSidedActionKernelZ3Package` —
  packaged result.

## Claim boundary

This is an algebraic kernel theorem for the two-sided matrix action. It does
not prove compact Lie group quotients, topological exactness, or the full DVT
stabilizer theorem.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open Matrix Complex

/-! ### Determinant of scalar matrices -/

/-
The determinant of `z • 1` for a `3 × 3` complex matrix is `z ^ 3`.
-/
theorem det_scalar_matrix_fin3 (z : ℂ) :
    (z • (1 : Matrix (Fin 3) (Fin 3) ℂ)).det = z ^ 3 := by
  norm_num [ Matrix.det_fin_three ]

/-! ### Main Z₃ kernel theorem -/

/-
If `A * X * B = X` for all `3 × 3` complex matrices, `A` and `B` are
    units with determinant one, then there exists a cube root of unity `z`
    such that `A = z • 1` and `B = z⁻¹ • 1`.
-/
theorem matrix_left_right_identity_kernel_z3
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ))
    (hact :
      ∀ X : Matrix (Fin 3) (Fin 3) ℂ,
        (A : Matrix (Fin 3) (Fin 3) ℂ) * X *
            (B : Matrix (Fin 3) (Fin 3) ℂ) = X)
    (hdetA : (A : Matrix (Fin 3) (Fin 3) ℂ).det = 1)
    (_hdetB : (B : Matrix (Fin 3) (Fin 3) ℂ).det = 1) :
    ∃ z : DVTZ3CentralScalar,
      (A : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (B : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  -- Use matrix_left_right_identity_kernel_scalar to get z ≠ 0 with A = z • 1 and B = z⁻¹ • 1.
  obtain ⟨z, hz, hA, hB⟩ := matrix_left_right_identity_kernel_scalar A B hact
  simp_all +decide

/-! ### Transport to H3OComplement -/

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

/-
Transport of the Z₃ kernel theorem to the DVT complement action.
-/
theorem h3oComplementTwoSidedAction_kernel_z3
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ))
    (hact :
      h3oComplementTwoSidedAction
        (A : Matrix (Fin 3) (Fin 3) ℂ)
        (B : Matrix (Fin 3) (Fin 3) ℂ) =
      AddMonoidHom.id H3OComplement)
    (hdetA : (A : Matrix (Fin 3) (Fin 3) ℂ).det = 1)
    (_hdetB : (B : Matrix (Fin 3) (Fin 3) ℂ).det = 1) :
    ∃ z : DVTZ3CentralScalar,
      (A : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (B : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  obtain ⟨z, hz⟩ := h3oComplementTwoSidedAction_kernel_scalar_converse A B hact
  simp_all +decide

/-! ### Package -/

/-- Packaging structure for the Z₃ two-sided action kernel theorem. -/
structure DVTTwoSidedActionKernelZ3Package where
  matrix_kernel_z3 :
    ∀ A B : Units (Matrix (Fin 3) (Fin 3) ℂ),
      (∀ X : Matrix (Fin 3) (Fin 3) ℂ,
        (A : Matrix (Fin 3) (Fin 3) ℂ) * X *
          (B : Matrix (Fin 3) (Fin 3) ℂ) = X) →
      (A : Matrix (Fin 3) (Fin 3) ℂ).det = 1 →
      (B : Matrix (Fin 3) (Fin 3) ℂ).det = 1 →
      ∃ z : DVTZ3CentralScalar,
        (A : Matrix (Fin 3) (Fin 3) ℂ) =
          (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
        (B : Matrix (Fin 3) (Fin 3) ℂ) =
          (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-- The Z₃ kernel package. -/
noncomputable def dvtTwoSidedActionKernelZ3Package :
    DVTTwoSidedActionKernelZ3Package where
  matrix_kernel_z3 := matrix_left_right_identity_kernel_z3

end PhysicsSM.Algebra.Jordan.DVTAction
