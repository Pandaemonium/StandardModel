/-
# Deliverable 2: Cauchy–Binet / Gram form of the `n`-edge mass (`d ≠ n`)

For a rectangular amplitude matrix `M : Matrix (Fin d) (Fin n) ℂ` (columns =
`n` null spinors living in `ℂ^d`), the momentum / Gram matrix is `P = M * Mᴴ`
of size `d × d`, and the mass `det P` decomposes as a sum of squared Plücker
minors — the honest "mass = total `d`-wise disagreement" at `n` edges:

`det (M * Mᴴ) = ∑_{f : Fin d ↪o Fin n} |det (M restricted to the d columns f)|²`.

Each order embedding `f : Fin d ↪o Fin n` selects a `d`-subset of the `n` columns
(i.e. a `d`-wise sub-bundle of null spinors); `det (M.submatrix id f)` is its top
Plücker coordinate (wedge), and the sum of the squared magnitudes of all such
`d`-wedges is the mass. This is the Cauchy–Binet formula specialized to `B = Mᴴ`
(the Gram determinant = sum of squared minors).

At `d = n` there is a single embedding (the identity), recovering
`det (M * Mᴴ) = normSq (det M)` of `NEdgeMassConcurrence`.
-/

import Mathlib

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.NEdgeCauchyBinet

/-
**Step 1+2.** Expand the Gram determinant into a sum over all index functions
`g : Fin d → Fin n`. The inner permutation sum from the determinant expansion
collapses to `star (det (M.submatrix id g))`.
-/
theorem det_gram_eq_sum_functions {d n : ℕ} (M : Matrix (Fin d) (Fin n) ℂ) :
    (M * Mᴴ).det =
      ∑ g : Fin d → Fin n, (∏ i, M i (g i)) * star ((M.submatrix id g).det) := by
  -- By definition of matrix multiplication and the properties of determinants, we can expand the determinant of $M * Mᴴ$ using the Leibniz formula.
  have h_leibniz : Matrix.det (M * Mᴴ) = ∑ σ : Equiv.Perm (Fin d), (Equiv.Perm.sign σ) * ∏ i, (M * Mᴴ) i (σ i) := by
    rw [ ← Matrix.det_transpose, Matrix.det_apply' ];
    rfl;
  -- By definition of matrix multiplication and the properties of determinants, we can expand the determinant of $M * Mᴴ$ using the Leibniz formula for the determinant.
  have h_leibniz_expanded : Matrix.det (M * Mᴴ) = ∑ σ : Equiv.Perm (Fin d), (Equiv.Perm.sign σ) * ∑ g : Fin d → Fin n, (∏ i, M i (g i)) * (∏ i, star (M (σ i) (g i))) := by
    simp +decide [ h_leibniz, Matrix.mul_apply, Finset.prod_mul_distrib ];
    simp +decide only [Finset.prod_sum, Finset.prod_mul_distrib];
    refine' Finset.sum_congr rfl fun σ _ => congr_arg _ ( Finset.sum_bij ( fun g _ => fun i => g i ( Finset.mem_univ i ) ) _ _ _ _ ) <;> simp +decide;
    · simp +decide [ funext_iff ];
    · exact fun b => ⟨ fun i _ => b i, rfl ⟩;
  -- By Fubini's theorem, we can interchange the order of summation.
  have h_fubini : ∑ σ : Equiv.Perm (Fin d), (Equiv.Perm.sign σ) * ∑ g : Fin d → Fin n, (∏ i, M i (g i)) * (∏ i, star (M (σ i) (g i))) = ∑ g : Fin d → Fin n, (∏ i, M i (g i)) * ∑ σ : Equiv.Perm (Fin d), (Equiv.Perm.sign σ) * (∏ i, star (M (σ i) (g i))) := by
    simpa only [ mul_assoc, mul_left_comm, Finset.mul_sum _ _ _ ] using Finset.sum_comm;
  convert h_fubini using 3;
  simp +decide [ Matrix.det_apply', mul_comm ]

/-
**Step 3.** Non-injective `g` contribute `0` (repeated columns), and injective
`g` regroup as `f ∘ π` over order embeddings `f : Fin d ↪o Fin n` and permutations
`π`; the permutation sum reconstructs `det (M.submatrix id f)`.
-/
set_option maxHeartbeats 1600000 in
theorem sum_functions_eq_sum_embeddings {d n : ℕ} (M : Matrix (Fin d) (Fin n) ℂ) :
    (∑ g : Fin d → Fin n, (∏ i, M i (g i)) * star ((M.submatrix id g).det)) =
      ∑ f : Fin d ↪o Fin n,
        ((M.submatrix (id : Fin d → Fin d) f).det) *
          star ((M.submatrix (id : Fin d → Fin d) f).det) := by
  -- For each injective function `g`, there exists a unique order embedding `f` such that `g = f ∘ σ` for some permutation `σ`.
  have h_inj_embedding : ∀ (g : Fin d → Fin n), Function.Injective g → ∃! (f : Fin d ↪o Fin n), ∃ σ : Equiv.Perm (Fin d), g = fun i => f (σ i) := by
    intro g hg_inj
    obtain ⟨f, σ, hf⟩ : ∃ f : Fin d ↪o Fin n, ∃ σ : Equiv.Perm (Fin d), g = fun i => f (σ i) := by
      obtain ⟨f, hf⟩ : ∃ f : Fin d ↪o Fin n, Set.range g = Set.range f := by
        -- Since $g$ is injective, its range is a finite set of size $d$.
        have h_range_finite : ∃ s : Finset (Fin n), s.card = d ∧ Set.range g = s := by
          exact ⟨ Finset.image g Finset.univ, by rw [ Finset.card_image_of_injective _ hg_inj, Finset.card_fin ], by ext; simp +decide ⟩;
        obtain ⟨ s, hs ⟩ := h_range_finite; use ( OrderEmbedding.ofStrictMono ( fun i => s.orderEmbOfFin ( by aesop ) i ) ( fun i j hij => by aesop ) ) ; aesop;
      have h_perm : ∀ i, ∃ j, g i = f j := by
        exact fun i => by rcases hf.subset ( Set.mem_range_self i ) with ⟨ j, hj ⟩ ; exact ⟨ j, hj.symm ⟩ ;
      choose σ hσ using h_perm;
      exact ⟨ f, Equiv.ofBijective σ ( Finite.injective_iff_bijective.mp ( show Function.Injective σ from fun i j hij => hg_inj <| by aesop ) ), funext hσ ⟩;
    refine' ⟨ f, ⟨ σ, hf ⟩, _ ⟩;
    rintro y ⟨ τ, hy ⟩;
    have h_range_eq : Set.range y = Set.range f := by
      simp_all +decide [ Set.range_eq_iff ];
      exact ⟨ fun a => ⟨ σ ( τ.symm a ), by have := congr_fun hf ( τ.symm a ) ; aesop ⟩, fun a => ⟨ τ ( σ.symm a ), by have := congr_fun hf ( σ.symm a ) ; aesop ⟩ ⟩;
    exact?;
  -- By partitioning the sum over all functions `g` based on their injectivity and corresponding order embeddings `f`, we can rewrite the left-hand side.
  have h_partition : ∑ g : Fin d → Fin n, (∏ i, M i (g i)) * star ((M.submatrix id g).det) = ∑ f : Fin d ↪o Fin n, ∑ g ∈ {g : Fin d → Fin n | ∃ σ : Equiv.Perm (Fin d), g = fun i => f (σ i)}, (∏ i, M i (g i)) * star ((M.submatrix id g).det) := by
    have h_partition : ∑ g : Fin d → Fin n, (∏ i, M i (g i)) * star ((M.submatrix id g).det) = ∑ g ∈ Finset.filter (fun g => Function.Injective g) (Finset.univ : Finset (Fin d → Fin n)), (∏ i, M i (g i)) * star ((M.submatrix id g).det) := by
      rw [ Finset.sum_filter_of_ne ];
      intro g _ hg; contrapose! hg; simp_all +decide [ Matrix.det_zero_of_column_eq ] ;
      obtain ⟨ i, j, hij, h ⟩ := Function.not_injective_iff.mp hg;
      exact Or.inr ( Matrix.det_zero_of_column_eq h ( by aesop ) );
    rw [ h_partition, ← Finset.sum_biUnion ];
    · congr with g ; simp +decide [ ExistsUnique ];
      exact ⟨ fun hg => by obtain ⟨ f, hf₁, hf₂ ⟩ := h_inj_embedding g hg; exact ⟨ f, hf₁.choose, hf₁.choose_spec ⟩, fun ⟨ f, σ, hf ⟩ => hf.symm ▸ fun i j hij => by simpa [ hf ] using σ.injective ( f.injective hij ) ⟩;
    · intro f hf g hg hfg; simp_all +decide [ Finset.disjoint_left ] ;
      intro a x hx y hy; specialize h_inj_embedding ( fun i => f ( x i ) ) ; simp_all +decide [ Function.Injective ] ;
      have := h_inj_embedding.unique ⟨ x, hy.symm ⟩ ⟨ y, rfl ⟩ ; aesop;
  -- For each order embedding `f`, the inner sum over `g` with `g = f ∘ σ` for some permutation `σ` is equal to the determinant of `M.submatrix id f` times its conjugate.
  have h_inner_sum : ∀ (f : Fin d ↪o Fin n), ∑ g ∈ {g : Fin d → Fin n | ∃ σ : Equiv.Perm (Fin d), g = fun i => f (σ i)}, (∏ i, M i (g i)) * star ((M.submatrix id g).det) = (M.submatrix id f).det * star ((M.submatrix id f).det) := by
    intro f
    have h_inner_sum_eq : ∑ σ : Equiv.Perm (Fin d), (∏ i, M i (f (σ i))) * star ((M.submatrix id (fun i => f (σ i))).det) = (M.submatrix id f).det * star ((M.submatrix id f).det) := by
      have h_inner_sum_eq : ∀ (σ : Equiv.Perm (Fin d)), (M.submatrix id (fun i => f (σ i))).det = (Equiv.Perm.sign σ) * (M.submatrix id f).det := by
        intro σ; rw [ Matrix.det_apply', Matrix.det_apply' ] ; simp +decide [ Finset.prod_mul_distrib, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _ ] ;
        refine' Finset.sum_bij ( fun τ _ => τ * σ⁻¹ ) _ _ _ _ <;> simp +decide [ mul_assoc, mul_comm, mul_left_comm ];
        · exact fun b => ⟨ b * σ, by simp +decide ⟩;
        · intro a; rw [ ← Equiv.prod_comp σ.symm ] ; simp +decide [ mul_assoc, mul_comm, mul_left_comm ] ;
          cases' Int.units_eq_one_or ( Equiv.Perm.sign σ ) with h h <;> simp +decide [ h ];
      have h_inner_sum_eq : ∑ σ : Equiv.Perm (Fin d), (Equiv.Perm.sign σ) * (∏ i, M i (f (σ i))) = (M.submatrix id f).det := by
        rw [ Matrix.det_apply' ];
        refine' Finset.sum_bij ( fun σ _ => σ⁻¹ ) _ _ _ _ <;> simp +decide [ Equiv.Perm.sign_inv ];
        · exact fun b => ⟨ b⁻¹, inv_inv b ⟩;
        · intro σ; rw [ ← Equiv.prod_comp σ⁻¹ ] ; simp +decide ;
      convert congr_arg ( · * star ( M.submatrix id f |> Matrix.det ) ) h_inner_sum_eq using 1;
      rw [ Finset.sum_mul _ _ _ ] ; congr ; ext ; simp +decide [ *, mul_assoc, mul_comm, mul_left_comm ] ;
    rw [ ← h_inner_sum_eq, show ( Finset.filter ( fun g => ∃ σ : Equiv.Perm ( Fin d ), g = fun i => f ( σ i ) ) Finset.univ ) = Finset.image ( fun σ : Equiv.Perm ( Fin d ) => fun i => f ( σ i ) ) Finset.univ from ?_ ];
    · rw [ Finset.sum_image ];
      exact fun σ _ τ _ h => Equiv.Perm.ext fun i => f.injective <| by simpa using congr_fun h i;
    · ext; simp [Finset.mem_image];
      simp +decide only [eq_comm];
  rw [ h_partition, Finset.sum_congr rfl fun f hf => h_inner_sum f ]

/-- **Deliverable 2 (Cauchy–Binet / Gram form).** The `n`-edge Plücker mass
`det (M * Mᴴ)` of a rectangular `d × n` amplitude matrix is the sum, over all
`d`-element ordered subsets `f` of the `n` columns, of the squared magnitude of
the corresponding `d`-wedge (Plücker minor) `det (M.submatrix id f)`. -/
theorem det_gram_eq_sum_normSq_minors {d n : ℕ} (M : Matrix (Fin d) (Fin n) ℂ) :
    (M * Mᴴ).det =
      ∑ f : Fin d ↪o Fin n,
        (Complex.normSq (M.submatrix (id : Fin d → Fin d) f).det : ℂ) := by
  rw [det_gram_eq_sum_functions, sum_functions_eq_sum_embeddings]
  refine Finset.sum_congr rfl fun f _ => ?_
  rw [Complex.star_def, Complex.mul_conj]

end PhysicsSM.Draft.NullEdge.NEdgeCauchyBinet

/-! ## Build-enforced axiom pin -/

/-- info: 'PhysicsSM.Draft.NullEdge.NEdgeCauchyBinet.det_gram_eq_sum_normSq_minors' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NEdgeCauchyBinet.det_gram_eq_sum_normSq_minors
