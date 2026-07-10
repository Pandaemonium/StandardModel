import Mathlib

/-!
# A noncommutative two-region local observable net

Standalone Aristotle target. Independent finite matrix algebras are embedded as
the two factors of an algebraic tensor product. Each region remains internally
noncommutative, while every left observable commutes with every right
observable. Together the two regional algebras generate the joint algebra.
-/

namespace FiniteLocalNet

open Algebra.TensorProduct
open scoped TensorProduct

variable (R A B : Type*) [CommSemiring R] [Semiring A] [Semiring B]
  [Algebra R A] [Algebra R B]

/-- Algebra of observables localized in the left tensor factor. -/
def leftAlgebra : Subalgebra R (A ⊗[R] B) :=
  (Algebra.TensorProduct.includeLeft : A →ₐ[R] A ⊗[R] B).range

/-- Algebra of observables localized in the right tensor factor. -/
def rightAlgebra : Subalgebra R (A ⊗[R] B) :=
  (Algebra.TensorProduct.includeRight : B →ₐ[R] A ⊗[R] B).range

/-- Elementary observables in separated tensor factors commute. -/
theorem separated_generators_commute (a : A) (b : B) :
    Commute
      ((Algebra.TensorProduct.includeLeft : A →ₐ[R] A ⊗[R] B) a)
      ((Algebra.TensorProduct.includeRight : B →ₐ[R] A ⊗[R] B) b) := by
  sorry

/-- **Finite microcausality.** Every observable in the left regional algebra
commutes with every observable in the right regional algebra. -/
theorem separated_regions_commute :
    ∀ x ∈ leftAlgebra R A B, ∀ y ∈ rightAlgebra R A B, Commute x y := by
  sorry

/-- Isotony into the full joint algebra. -/
theorem regional_isotony :
    leftAlgebra R A B ≤ ⊤ ∧ rightAlgebra R A B ≤ ⊤ := by
  sorry

/-- The two regional algebras jointly generate the complete tensor-product
observable algebra. -/
theorem regional_generation :
    leftAlgebra R A B ⊔ rightAlgebra R A B = ⊤ := by
  sorry

/-! ## Noncommutative qubit witness -/

noncomputable def sigmaX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]
noncomputable def sigmaZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The left region is genuinely noncommutative even though it commutes with
the separated right region. -/
theorem left_qubit_noncommutative :
    ¬ Commute
      ((Algebra.TensorProduct.includeLeft :
        Matrix (Fin 2) (Fin 2) ℂ →ₐ[ℂ]
          Matrix (Fin 2) (Fin 2) ℂ ⊗[ℂ] Matrix (Fin 2) (Fin 2) ℂ) sigmaX)
      ((Algebra.TensorProduct.includeLeft :
        Matrix (Fin 2) (Fin 2) ℂ →ₐ[ℂ]
          Matrix (Fin 2) (Fin 2) ℂ ⊗[ℂ] Matrix (Fin 2) (Fin 2) ℂ) sigmaZ) := by
  sorry

/-- Compact two-region net verdict: noncommutative local algebras, exact
separated-region commutativity, isotony, and joint generation. -/
theorem two_qubit_local_net_verdict :
    (¬ Commute
      ((Algebra.TensorProduct.includeLeft :
        Matrix (Fin 2) (Fin 2) ℂ →ₐ[ℂ]
          Matrix (Fin 2) (Fin 2) ℂ ⊗[ℂ] Matrix (Fin 2) (Fin 2) ℂ) sigmaX)
      ((Algebra.TensorProduct.includeLeft :
        Matrix (Fin 2) (Fin 2) ℂ →ₐ[ℂ]
          Matrix (Fin 2) (Fin 2) ℂ ⊗[ℂ] Matrix (Fin 2) (Fin 2) ℂ) sigmaZ)) ∧
    (∀ x ∈ leftAlgebra ℂ (Matrix (Fin 2) (Fin 2) ℂ) (Matrix (Fin 2) (Fin 2) ℂ),
      ∀ y ∈ rightAlgebra ℂ (Matrix (Fin 2) (Fin 2) ℂ) (Matrix (Fin 2) (Fin 2) ℂ),
        Commute x y) := by
  sorry

end FiniteLocalNet
