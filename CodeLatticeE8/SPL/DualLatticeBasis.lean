import Mathlib

/-!
# Dual bases for integral unimodular lattices

This module proves the local self-duality criterion used by the E8 theta
series argument: for the inner product bilinear form on
`EuclideanSpace ℝ (Fin n)`, if a basis has integer Gram matrix and unimodular
determinant, then the dual lattice equals the original lattice.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.unusedSimpArgs false
set_option linter.flexible false
set_option maxHeartbeats 800000

open Module LinearMap.BilinForm

namespace CodeLatticeE8.SPL

noncomputable section

abbrev ipBilin (n : ℕ) : LinearMap.BilinForm ℝ (EuclideanSpace ℝ (Fin n)) :=
  innerₗ (EuclideanSpace ℝ (Fin n))

/-- The integer-valued Gram matrix of a basis w.r.t. the inner product. -/
def gramMatrixZ (n : ℕ)
    (b : Basis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hInt : ∀ i j : Fin n, @inner ℝ (EuclideanSpace ℝ (Fin n)) _ (b i) (b j) ∈ (1 : Submodule ℤ ℝ)) :
    Matrix (Fin n) (Fin n) ℤ :=
  fun i j => (Submodule.mem_one.mp (hInt i j)).choose

lemma gramMatrixZ_spec (n : ℕ)
    (b : Basis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hInt : ∀ i j : Fin n, @inner ℝ (EuclideanSpace ℝ (Fin n)) _ (b i) (b j) ∈ (1 : Submodule ℤ ℝ))
    (i j : Fin n) :
    (algebraMap ℤ ℝ) ((gramMatrixZ n b hInt) i j) = @inner ℝ (EuclideanSpace ℝ (Fin n)) _ (b i) (b j) :=
  (Submodule.mem_one.mp (hInt i j)).choose_spec

/-
Each original basis vector lies in the ℤ-span of the dual basis.
-/
lemma span_basis_le_span_dualBasis (n : ℕ)
    (b : Basis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hB : (ipBilin n).Nondegenerate)
    (hInt : ∀ i j : Fin n, @inner ℝ (EuclideanSpace ℝ (Fin n)) _ (b i) (b j) ∈ (1 : Submodule ℤ ℝ)) :
    Submodule.span ℤ (Set.range b) ≤
      Submodule.span ℤ (Set.range ((ipBilin n).dualBasis hB b)) := by
  -- By definition of dual basis, we know that $(ipBilin n).dualBasis hB b i$ is the unique element in the dual space such that $(ipBilin n) (b j) ((ipBilin n).dualBasis hB b i) = \delta_{ij}$.
  have h_dual_basis : ∀ i, b i = ∑ j, ( Inner.inner ℝ (b i) (b j) : ℝ ) • ((ipBilin n).dualBasis hB b j) := by
    intro i;
    -- By definition of dual basis, we know that for any vector $v$ in the span of $b$, $v = \sum_{j} \langle v, b_j \rangle b_j^*$.
    have h_dual_basis_def : ∀ v : EuclideanSpace ℝ (Fin n), v ∈ Submodule.span ℝ (Set.range b) → v = ∑ j : Fin n, (ipBilin n) v (b j) • ((ipBilin n).dualBasis hB b j) := by
      intro v hv
      have h_dual_basis_def : v = ∑ j : Fin n, (Basis.repr ((ipBilin n).dualBasis hB b) v) j • ((ipBilin n).dualBasis hB b j) := by
        exact Eq.symm ( Basis.sum_repr ( ( ipBilin n ).dualBasis hB b ) v );
      convert h_dual_basis_def using 3;
      expose_names
      exact Eq.symm (dualBasis_repr_apply hB b v x)
    exact h_dual_basis_def _ ( Submodule.subset_span ( Set.mem_range_self _ ) );
  rw [ Submodule.span_le, Set.range_subset_iff ];
  intro i
  rw [h_dual_basis i];
  apply_rules [ Submodule.sum_mem, Submodule.smul_mem ];
  intro j _;
  obtain ⟨ m, hm ⟩ := hInt i j;
  rw [ ← hm ];
  convert Submodule.smul_mem _ m ( Submodule.subset_span ( Set.mem_range_self j ) ) using 1;
  simp +decide [ Algebra.smul_def ];
  norm_cast

/-
Each dual basis vector lies in the ℤ-span of the original basis.
-/
lemma span_dualBasis_le_span_basis (n : ℕ)
    (b : Basis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hB : (ipBilin n).Nondegenerate)
    (hInt : ∀ i j : Fin n, @inner ℝ (EuclideanSpace ℝ (Fin n)) _ (b i) (b j) ∈ (1 : Submodule ℤ ℝ))
    (hDet : IsUnit (gramMatrixZ n b hInt).det) :
    Submodule.span ℤ (Set.range ((ipBilin n).dualBasis hB b)) ≤
      Submodule.span ℤ (Set.range b) := by
  -- By definition of $C$, we know that for each $k$, $(C k j : ℝ) • b j$ is a linear combination of the original basis vectors.
  have h_comb : ∀ k, ∑ j, ( (gramMatrixZ n b hInt)⁻¹ k j : ℤ) • b j = (ipBilin n).dualBasis hB b k := by
    intro k
    apply (ipBilin n).dualBasis hB b |>.repr.injective
    simp [LinearMap.BilinForm.dualBasis_repr_apply];
    -- By definition of $C$, we know that for each $k$, $(C k j : ℝ) • b j$ is a linear combination of the original basis vectors, and thus its representation in the dual basis is given by the $k$-th row of $C$.
    have h_comb : ∀ k i, ∑ j, ( (gramMatrixZ n b hInt)⁻¹ k j : ℤ) * (ipBilin n) (b j) (b i) = if k = i then 1 else 0 := by
      -- By definition of $C$, we know that for each $k$, $(C k j : ℝ) • b j$ is a linear combination of the original basis vectors, and thus its representation in the dual basis is given by the $k$-th row of $C$. Use this fact.
      have h_comb : ∀ k i, ∑ j, ( (gramMatrixZ n b hInt)⁻¹ k j : ℤ) * (gramMatrixZ n b hInt) j i = if k = i then 1 else 0 := by
        intro k i
        rw [← Matrix.mul_apply]
        simpa using congr_fun
          (congr_fun (Matrix.nonsing_inv_mul (gramMatrixZ n b hInt) hDet) k) i
      convert h_comb using 3;
      rw [ ← @Int.cast_inj ℝ ] ; push_cast ; congr! 2 ; ring_nf!;
      exact congrArg _ ( Eq.symm <| gramMatrixZ_spec _ _ _ _ _ );
    ext i; specialize h_comb k i; simp_all +decide [ Finsupp.single_apply, Finset.sum_ite_eq ] ;
  rw [ Submodule.span_le ];
  rintro _ ⟨ k, rfl ⟩;
  exact h_comb k ▸ Submodule.sum_mem _ fun i _ => Submodule.smul_mem _ _ ( Submodule.subset_span ( Set.mem_range_self _ ) )

/-- If the Gram matrix of a basis w.r.t. the inner product has integer entries
and unimodular determinant, the dual lattice equals the original lattice. -/
theorem dualSubmodule_innerₗ_eq_span_of_integral_unimodular (n : ℕ)
    (b : Basis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hB : (ipBilin n).Nondegenerate)
    (hInt : ∀ i j : Fin n, @inner ℝ (EuclideanSpace ℝ (Fin n)) _ (b i) (b j) ∈ (1 : Submodule ℤ ℝ))
    (hDet : IsUnit (gramMatrixZ n b hInt).det) :
    (ipBilin n).dualSubmodule (Submodule.span ℤ (Set.range b)) = Submodule.span ℤ (Set.range b) := by
  rw [dualSubmodule_span_of_basis _ hB b]
  exact le_antisymm
    (span_dualBasis_le_span_basis n b hB hInt hDet)
    (span_basis_le_span_dualBasis n b hB hInt)

end

end CodeLatticeE8.SPL
