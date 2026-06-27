import Mathlib
import PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3
import PhysicsSM.Algebra.Jordan.DVTZ3CentralScalarGroup

/-!
# Algebra.Jordan.DVTTwoSidedActionKernelZ3Iff

Converse and iff-style package for the determinant-one Z₃ kernel of the
DVT two-sided matrix action.

The forward direction (proved in `DVTTwoSidedActionKernelZ3`) states that if
`A * X * B = X` for all `3 × 3` complex matrices and `det A = det B = 1`,
then `A` and `B` are reciprocal scalar matrices for some cube root of unity.

This file proves the converse: every cube-root scalar pair acts trivially
and has determinant one. The two directions are combined into an iff theorem
and packaged.

## Main declarations

- `matrix_left_right_identity_of_z3_scalar` — converse: cube-root scalar
  pairs act trivially.
- `det_z3_scalar_matrix` — determinant of `z • 1` is `1` when `z ^ 3 = 1`.
- `det_z3_scalar_matrix_inv` — determinant of `z⁻¹ • 1` is `1` when
  `z ^ 3 = 1`.
- `DVTTwoSidedKernelDetOne` — predicate for the two-sided kernel with
  determinant-one constraints.
- `matrix_left_right_identity_kernel_z3_iff` — iff characterization.
- `DVTTwoSidedActionKernelZ3IffPackage` / `dvtTwoSidedActionKernelZ3IffPackage`
  — packaged result.

## Claim boundary

This is a finite matrix-algebra kernel theorem. It does not prove compact Lie
group quotients, topological exactness, or the full DVT stabilizer theorem.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open Matrix Complex

/-! ### Converse direction -/

/-
Every cube-root scalar pair acts trivially on all `3 × 3` matrices.
-/
theorem matrix_left_right_identity_of_z3_scalar
    (z : DVTZ3CentralScalar) :
    ∀ X : Matrix (Fin 3) (Fin 3) ℂ,
      ((z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)) * X *
        ((z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)) = X := by
  simp +decide [ mul_assoc, mul_left_comm, smul_smul ];
  exact fun X => by rw [ inv_mul_cancel₀ ( DVTZ3CentralScalar.ne_zero z ), one_smul ] ;

/-! ### Determinant facts -/

/-
The determinant of `z • 1` is `1` when `z` is a cube root of unity.
-/
theorem det_z3_scalar_matrix (z : DVTZ3CentralScalar) :
    ((z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)).det = 1 := by
  rw [ Matrix.det_smul ] ; aesop

/-
The determinant of `z⁻¹ • 1` is `1` when `z` is a cube root of unity.
-/
theorem det_z3_scalar_matrix_inv (z : DVTZ3CentralScalar) :
    ((z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)).det = 1 := by
  exact det_scalar_matrix_fin3 _ ▸ by norm_num [ z.2, inv_pow ] ;

/-! ### Redundancy of `hdetB` -/

/-
When `A = z • 1` and `B = z⁻¹ • 1` with `z ^ 3 = 1`, the determinant
    condition `det B = 1` follows automatically from `det A = 1`. This
    explains why the `_hdetB` hypothesis in the forward theorem is redundant
    (though it is not weakened silently).
-/
theorem det_inv_of_det_cube_root (z : ℂ) (hz : z ^ 3 = 1) :
    (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)).det = 1 := by
  rw [ Matrix.det_smul ] ; norm_num [ hz ]

/-! ### Iff predicate -/

/-- The predicate asserting that `(A, B)` lies in the two-sided kernel
    with determinant-one constraints. -/
def DVTTwoSidedKernelDetOne
    (A B : Matrix (Fin 3) (Fin 3) ℂ) : Prop :=
  (∀ X : Matrix (Fin 3) (Fin 3) ℂ, A * X * B = X) ∧
  A.det = 1 ∧ B.det = 1

/-! ### Forward direction (wrapper) -/

theorem matrix_left_right_identity_kernel_z3_forward
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ))
    (h : DVTTwoSidedKernelDetOne
      (A : Matrix (Fin 3) (Fin 3) ℂ)
      (B : Matrix (Fin 3) (Fin 3) ℂ)) :
    ∃ z : DVTZ3CentralScalar,
      (A : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (B : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) :=
  matrix_left_right_identity_kernel_z3 A B h.1 h.2.1 h.2.2

/-! ### Backward direction (wrapper) -/

theorem matrix_left_right_identity_kernel_z3_backward
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ))
    (h : ∃ z : DVTZ3CentralScalar,
      (A : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (B : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)) :
    DVTTwoSidedKernelDetOne
      (A : Matrix (Fin 3) (Fin 3) ℂ)
      (B : Matrix (Fin 3) (Fin 3) ℂ) := by
  obtain ⟨ z, hA, hB ⟩ := h; unfold DVTTwoSidedKernelDetOne; simp_all +decide ;
  exact ⟨ fun X => by rw [ inv_smul_smul₀ ( DVTZ3CentralScalar.ne_zero z ) ], z.prop ⟩

/-! ### Iff theorem -/

/-- Iff characterization: `(A, B)` lies in the determinant-one two-sided
    kernel if and only if `A` and `B` are reciprocal cube-root scalar
    matrices. -/
theorem matrix_left_right_identity_kernel_z3_iff
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ)) :
    DVTTwoSidedKernelDetOne
      (A : Matrix (Fin 3) (Fin 3) ℂ)
      (B : Matrix (Fin 3) (Fin 3) ℂ) ↔
    ∃ z : DVTZ3CentralScalar,
      (A : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (B : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) :=
  ⟨matrix_left_right_identity_kernel_z3_forward A B,
   matrix_left_right_identity_kernel_z3_backward A B⟩

/-! ### Package -/

/-- Packaging structure for the iff-style Z₃ kernel theorem. -/
structure DVTTwoSidedActionKernelZ3IffPackage where
  /-- Forward direction: kernel + det 1 implies cube-root scalar pair. -/
  forward :
    ∀ A B : Units (Matrix (Fin 3) (Fin 3) ℂ),
      DVTTwoSidedKernelDetOne
        (A : Matrix (Fin 3) (Fin 3) ℂ)
        (B : Matrix (Fin 3) (Fin 3) ℂ) →
      ∃ z : DVTZ3CentralScalar,
        (A : Matrix (Fin 3) (Fin 3) ℂ) =
          (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
        (B : Matrix (Fin 3) (Fin 3) ℂ) =
          (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)
  /-- Converse direction: cube-root scalar pair implies kernel + det 1. -/
  converse :
    ∀ A B : Units (Matrix (Fin 3) (Fin 3) ℂ),
      (∃ z : DVTZ3CentralScalar,
        (A : Matrix (Fin 3) (Fin 3) ℂ) =
          (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
        (B : Matrix (Fin 3) (Fin 3) ℂ) =
          (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)) →
      DVTTwoSidedKernelDetOne
        (A : Matrix (Fin 3) (Fin 3) ℂ)
        (B : Matrix (Fin 3) (Fin 3) ℂ)

/-- The iff-style Z₃ kernel package. -/
noncomputable def dvtTwoSidedActionKernelZ3IffPackage :
    DVTTwoSidedActionKernelZ3IffPackage where
  forward := matrix_left_right_identity_kernel_z3_forward
  converse := matrix_left_right_identity_kernel_z3_backward

end PhysicsSM.Algebra.Jordan.DVTAction
