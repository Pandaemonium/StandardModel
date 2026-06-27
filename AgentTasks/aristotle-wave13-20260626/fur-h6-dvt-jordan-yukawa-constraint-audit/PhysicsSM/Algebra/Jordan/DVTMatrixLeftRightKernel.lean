import Mathlib
import PhysicsSM.Algebra.Jordan.DVTComplementTwoSidedAction

/-!
# Algebra.Jordan.DVTMatrixLeftRightKernel

The hard converse of the DVT central-kernel story at the finite matrix level:
if a left-right action `X ↦ A * X * B` on all `3 × 3` complex matrices is the
identity and `A`, `B` are units, then `A` and `B` are reciprocal scalar matrices.

## Main declarations

- `matrix_commutes_all_iff_scalar` - a `3 x 3` complex matrix that commutes
  with every matrix is a scalar matrix.
- `matrix_left_right_identity_kernel_scalar` - the main kernel theorem.
- `h3oComplementTwoSidedAction_kernel_scalar_converse` - transport to the
  DVT complement action.
- `DVTMatrixLeftRightKernelPackage` - packaging structure.

## Claim boundary

This is a finite matrix-algebra kernel theorem. It does not prove unitarity,
determinant-one constraints, quotient topology, compact Lie groups, or the full
DVT stabilizer theorem.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open Matrix Complex

/-! ## Core: a matrix that commutes with all matrices is scalar -/

/-- Off-diagonal entries of a matrix commuting with all matrices vanish. -/
private theorem commutes_all_off_diag
    (A : Matrix (Fin 3) (Fin 3) ℂ)
    (hcomm : ∀ X : Matrix (Fin 3) (Fin 3) ℂ, A * X = X * A)
    (i j : Fin 3) (hij : i ≠ j) :
    A i j = 0 := by
  specialize hcomm (Matrix.diagonal (fun k => if k = i then 1 else 0))
  replace hcomm := congr_fun (congr_fun hcomm i) j
  aesop

/-- Diagonal entries of a matrix commuting with all matrices are equal. -/
private theorem commutes_all_diag_eq
    (A : Matrix (Fin 3) (Fin 3) ℂ)
    (hcomm : ∀ X : Matrix (Fin 3) (Fin 3) ℂ, A * X = X * A)
    (i j : Fin 3) :
    A i i = A j j := by
  have := congr_fun (congr_fun
    (hcomm (Matrix.of fun k l => if k = i ∧ l = j then 1 else 0)) i) j
  fin_cases i <;> fin_cases j <;> simp_all +decide [Matrix.mul_apply]

/-- A `3 × 3` complex matrix that commutes with every matrix is scalar. -/
theorem matrix_commutes_all_iff_scalar
    (A : Matrix (Fin 3) (Fin 3) ℂ)
    (h : ∀ X : Matrix (Fin 3) (Fin 3) ℂ, A * X = X * A) :
    ∃ z : ℂ, A = z • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  refine ⟨A 0 0, ?_⟩
  ext i j
  simp only [smul_apply, one_apply]
  by_cases hij : i = j
  · subst hij
    simp [commutes_all_diag_eq A h 0 i]
  · simp [hij, commutes_all_off_diag A h i j hij]

/-! ## Main kernel theorem -/

/-- If `A * X * B = X` for all matrices and `A`, `B` are units, then `A`
    and `B` are reciprocal scalar matrices. -/
theorem matrix_left_right_identity_kernel_scalar
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ))
    (h : ∀ X : Matrix (Fin 3) (Fin 3) ℂ,
      (A : Matrix (Fin 3) (Fin 3) ℂ) * X *
        (B : Matrix (Fin 3) (Fin 3) ℂ) = X) :
    ∃ z : ℂ,
      z ≠ 0 ∧
      (A : Matrix (Fin 3) (Fin 3) ℂ) =
        z • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (B : Matrix (Fin 3) (Fin 3) ℂ) =
        z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  -- A * B = 1 from h(1)
  have hAB : (A : Matrix (Fin 3) (Fin 3) ℂ) *
      (B : Matrix (Fin 3) (Fin 3) ℂ) = 1 := by
    simpa using h 1
  -- A commutes with all matrices
  have h_comm : ∀ X : Matrix (Fin 3) (Fin 3) ℂ,
      (A : Matrix (Fin 3) (Fin 3) ℂ) * X =
        X * (A : Matrix (Fin 3) (Fin 3) ℂ) := by
    intro X
    have := h (X * A)
    simp_all +decide [mul_assoc]
  -- A is scalar
  obtain ⟨z, hz⟩ := matrix_commutes_all_iff_scalar _ h_comm
  by_cases hz0 : z = 0 <;> simp_all +decide
  exact eq_inv_smul_iff₀ hz0 |>.2 hAB

/-! ## Transport to DVT complement action -/

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

/-- Converse kernel theorem transported to the DVT complement action. -/
theorem h3oComplementTwoSidedAction_kernel_scalar_converse
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ))
    (h : h3oComplementTwoSidedAction
        (A : Matrix (Fin 3) (Fin 3) ℂ)
        (B : Matrix (Fin 3) (Fin 3) ℂ) =
      AddMonoidHom.id H3OComplement) :
    ∃ z : ℂ,
      z ≠ 0 ∧
      (A : Matrix (Fin 3) (Fin 3) ℂ) =
        z • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (B : Matrix (Fin 3) (Fin 3) ℂ) =
        z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  -- Extract matrix equation from complement action identity
  have h_eq : ∀ w : H3OComplement,
      A.val * h3oComplementEquivM3C w * B.val =
        h3oComplementEquivM3C w := by
    intro w
    convert congr_arg
      (fun f : H3OComplement →+ H3OComplement =>
        h3oComplementEquivM3C (f w)) h using 1
    simp +decide [h3oComplementEquivM3C_twoSidedAction]
  -- Lift to all matrices via surjectivity of h3oComplementEquivM3C
  convert matrix_left_right_identity_kernel_scalar A B ?_
  intro X
  specialize h_eq (h3oComplementEquivM3C.symm X)
  aesop

/-! ## Package -/

/-- Packaging structure for the matrix left-right kernel theorem. -/
structure DVTMatrixLeftRightKernelPackage where
  kernel_scalar :
    ∀ A B : Units (Matrix (Fin 3) (Fin 3) ℂ),
      (∀ X : Matrix (Fin 3) (Fin 3) ℂ,
        (A : Matrix (Fin 3) (Fin 3) ℂ) * X *
          (B : Matrix (Fin 3) (Fin 3) ℂ) = X) →
      ∃ z : ℂ,
        z ≠ 0 ∧
        (A : Matrix (Fin 3) (Fin 3) ℂ) =
          z • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
        (B : Matrix (Fin 3) (Fin 3) ℂ) =
          z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-- The kernel package instance. -/
noncomputable def dvtMatrixLeftRightKernelPackage :
    DVTMatrixLeftRightKernelPackage :=
  ⟨matrix_left_right_identity_kernel_scalar⟩

end PhysicsSM.Algebra.Jordan.DVTAction
