import Mathlib

/-!
# A noncommutative two-region observable net

Independent finite matrix algebras are embedded as the two factors of an
algebraic tensor product. Each region remains internally noncommutative, every
left observable commutes with every right observable, and the two regional
algebras jointly generate the full tensor-product algebra.

This is an exact two-region locality rung for a supplied tensor factorization.
It is not a spacetime-indexed Haag-Kastler net, a continuum-QFT construction, or
a proof that graph separation supplies tensor factors.

Provenance: clean-room finite algebraic formulation using Mathlib's tensor
product API. Proofs were completed by Aristotle project
`13b40077-16df-4e15-b662-37a84ac51edb` and locally rechecked under the pinned
toolchain.
-/

namespace PhysicsSM.Draft.NullEdge.TwoRegionTensorMicrocausality

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
  unfold Commute SemiconjBy
  rw [Algebra.TensorProduct.includeLeft_apply, Algebra.TensorProduct.includeRight_apply,
    Algebra.TensorProduct.tmul_mul_tmul, Algebra.TensorProduct.tmul_mul_tmul]
  simp

/-- Every observable in the left regional algebra commutes with every
observable in the right regional algebra. -/
theorem separated_regions_commute :
    ∀ x ∈ leftAlgebra R A B, ∀ y ∈ rightAlgebra R A B, Commute x y := by
  rintro x ⟨a, rfl⟩ y ⟨b, rfl⟩
  exact separated_generators_commute R A B a b

/-- Both regional algebras are isotone into the full joint algebra. -/
theorem regional_isotony :
    leftAlgebra R A B ≤ ⊤ ∧ rightAlgebra R A B ≤ ⊤ :=
  ⟨le_top, le_top⟩

/-- The two regional algebras jointly generate the complete tensor-product
observable algebra. -/
theorem regional_generation :
    leftAlgebra R A B ⊔ rightAlgebra R A B = ⊤ := by
  have h := Algebra.TensorProduct.map_range (AlgHom.id R A) (AlgHom.id R B)
  simp only [Algebra.TensorProduct.map_id, AlgHom.comp_id, Algebra.range_id] at h
  exact h.symm

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
  intro h
  unfold Commute SemiconjBy at h
  rw [← map_mul, ← map_mul] at h
  have hinj := Algebra.TensorProduct.includeLeft_injective (R := ℂ) (S := ℂ)
    (A := Matrix (Fin 2) (Fin 2) ℂ) (B := Matrix (Fin 2) (Fin 2) ℂ)
    (FaithfulSMul.algebraMap_injective ℂ (Matrix (Fin 2) (Fin 2) ℂ))
  have h2 := hinj h
  rw [sigmaX, sigmaZ] at h2
  norm_num [Matrix.mul_fin_two, ← Matrix.ext_iff, Fin.forall_fin_two] at h2

/-- Compact two-region verdict: a noncommutative local algebra together with
exact separated-region commutativity. -/
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
        Commute x y) :=
  ⟨left_qubit_noncommutative, separated_regions_commute ℂ _ _⟩

end PhysicsSM.Draft.NullEdge.TwoRegionTensorMicrocausality
