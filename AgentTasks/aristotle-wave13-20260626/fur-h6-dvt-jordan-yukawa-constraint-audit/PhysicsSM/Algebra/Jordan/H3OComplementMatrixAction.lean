import Mathlib
import PhysicsSM.Algebra.Jordan.H3OComplexMatrixLinear

/-!
# Algebra.Jordan.H3OComplementMatrixAction

Left and right matrix multiplication on `M₃(ℂ)` transported to the
orthogonal complement of `h₃(ℂ)` in `h₃(𝕆)` via the complex-linear
equivalence `complementLinearEquivM3C`.

## Main declarations

- `complementMatrixLeftAction A` — left multiplication by `A ∈ M₃(ℂ)`,
  transported to the complement.
- `complementMatrixRightAction B` — right multiplication by `B ∈ M₃(ℂ)`,
  transported to the complement.
- Coordinate equations showing these reduce to ordinary matrix multiplication.
- Identity, composition, and commutation laws.

## Claim boundary

This is only the linear action scaffold on the complement. It does not claim
unitarity, determinant one, quotient by `ℤ₃`, or Jordan-product preservation.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

/-! ## Left matrix action on the complement -/

/-- Left multiplication by `A ∈ M₃(ℂ)` transported to the complement. -/
noncomputable def complementMatrixLeftAction
    (A : Matrix (Fin 3) (Fin 3) ℂ) :
    complementAddSubgroup →ₗ[ℂ] complementAddSubgroup :=
  complementLinearEquivM3C.symm.toLinearMap ∘ₗ
    (LinearMap.mulLeft ℂ A) ∘ₗ
    complementLinearEquivM3C.toLinearMap

/-- The coordinate equation for left matrix action. -/
theorem complementLinearEquivM3C_leftAction
    (A : Matrix (Fin 3) (Fin 3) ℂ)
    (x : complementAddSubgroup) :
    complementLinearEquivM3C (complementMatrixLeftAction A x) =
      A * complementLinearEquivM3C x := by
  simp [complementMatrixLeftAction, LinearMap.mulLeft_apply]

/-! ## Right matrix action on the complement -/

/-- Right multiplication by `B ∈ M₃(ℂ)` transported to the complement. -/
noncomputable def complementMatrixRightAction
    (B : Matrix (Fin 3) (Fin 3) ℂ) :
    complementAddSubgroup →ₗ[ℂ] complementAddSubgroup :=
  complementLinearEquivM3C.symm.toLinearMap ∘ₗ
    (LinearMap.mulRight ℂ B) ∘ₗ
    complementLinearEquivM3C.toLinearMap

/-- The coordinate equation for right matrix action. -/
theorem complementLinearEquivM3C_rightAction
    (B : Matrix (Fin 3) (Fin 3) ℂ)
    (x : complementAddSubgroup) :
    complementLinearEquivM3C (complementMatrixRightAction B x) =
      complementLinearEquivM3C x * B := by
  simp [complementMatrixRightAction, LinearMap.mulRight_apply]

/-! ## Identity laws -/

theorem complementMatrixLeftAction_one :
    complementMatrixLeftAction 1 = LinearMap.id := by
  convert LinearMap.ext ?_
  intro x
  exact complementLinearEquivM3C.injective
    (by simp [complementLinearEquivM3C_leftAction])

theorem complementMatrixRightAction_one :
    complementMatrixRightAction 1 = LinearMap.id := by
  convert LinearMap.ext ?_
  intro x
  exact complementLinearEquivM3C.injective
    (by simp [complementMatrixRightAction])

/-! ## Composition laws -/

theorem complementMatrixLeftAction_mul
    (A B : Matrix (Fin 3) (Fin 3) ℂ) :
    complementMatrixLeftAction (A * B) =
      (complementMatrixLeftAction A).comp
        (complementMatrixLeftAction B) := by
  exact LinearMap.ext fun x =>
    complementLinearEquivM3C.injective (by
      simp +decide [complementLinearEquivM3C_leftAction,
        Matrix.mul_assoc])

theorem complementMatrixRightAction_mul
    (A B : Matrix (Fin 3) (Fin 3) ℂ) :
    complementMatrixRightAction (A * B) =
      (complementMatrixRightAction B).comp
        (complementMatrixRightAction A) := by
  refine LinearMap.ext fun x => ?_
  have h_eq : complementLinearEquivM3C
      (complementMatrixRightAction (A * B) x) =
      complementLinearEquivM3C
      ((complementMatrixRightAction B ∘ₗ
        complementMatrixRightAction A) x) := by
    simp +decide [← Matrix.mul_assoc,
      complementLinearEquivM3C_rightAction]
  exact complementLinearEquivM3C.injective h_eq

/-! ## Commutation law -/

theorem complementMatrixLeftRight_commute
    (A B : Matrix (Fin 3) (Fin 3) ℂ)
    (x : complementAddSubgroup) :
    complementMatrixLeftAction A
      (complementMatrixRightAction B x) =
      complementMatrixRightAction B
        (complementMatrixLeftAction A x) := by
  apply_fun complementLinearEquivM3C using
    complementLinearEquivM3C.injective
  rw [complementLinearEquivM3C_leftAction,
    complementLinearEquivM3C_rightAction,
    complementLinearEquivM3C_rightAction,
    complementLinearEquivM3C_leftAction,
    Matrix.mul_assoc]

end PhysicsSM.Algebra.Jordan.H3O
