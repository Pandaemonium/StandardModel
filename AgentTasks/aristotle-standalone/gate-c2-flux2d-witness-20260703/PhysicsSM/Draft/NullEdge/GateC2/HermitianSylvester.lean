import Mathlib

/-!
# Sylvester's law of inertia for complex Hermitian matrices (eigenvalue-count form)

Draft-trust Mathlib-only port of Aristotle job
`635b44ae-206b-48f0-99bd-ec6cd59ada1a`. This fills a useful Mathlib-facing
bridge: Mathlib has Sylvester's law of inertia for quadratic forms
(`QuadraticForm.equivalent_signType_weighted_sum_squared`,
`QuadraticForm.sigPos_of_equiv_weightedSumSquares`,
`QuadraticForm.sigNeg_of_equiv_weightedSumSquares`,
`QuadraticForm.sigPos_add_sigNeg_add_radical`), but not the complex-Hermitian
matrix form in terms of `Matrix.IsHermitian.eigenvalues`.

## The theorem

`congruence_preserves_inertia`: if `A`, `B` are complex Hermitian matrices,
`S` is invertible, and `B = Sᴴ A S` (a `*`-congruence), then `A` and `B` have the
same number of positive eigenvalues and the same number of negative eigenvalues
(counted with `Matrix.IsHermitian.eigenvalues`).

## Proof strategy (min-max / subspace dimension)

For a real-valued Hermitian form `Q A x = re (xᴴ A x)` on `ℂⁿ` we define
`maxPosDimF Q`, the maximal dimension of a subspace on which `Q` is positive
(on nonzero vectors). Two facts give the result:

* **Invariance** (`maxPosDimF_congr`): if `Q₂ x = Q₁ (F x)` for a linear
  equivalence `F` of `ℂⁿ`, then `maxPosDimF Q₂ = maxPosDimF Q₁`. Applied with
  `F x = S *ᵥ x` and `Q A x = re (xᴴ A x)` (using `qform_congr`), this shows the
  invariant is unchanged by a `*`-congruence.
* **Eigenvalue count** (`maxPosDimF_eq_posCard`): for the diagonalised form
  `Q x = ∑ i, w i * ‖(E x) i‖²` (weights `w`, `E` a linear equivalence),
  `maxPosDimF Q = #{i | 0 < w i}`. The spectral theorem
  (`exists_qform_weighted`) puts `qform A` in this shape with `w` the eigenvalues,
  so `maxPosDimF (qform A) = #{i | 0 < eigenvalues A i}`.

For the negative count we run the same two lemmas with the negated weights
`w i = -eigenvalues A i` and the form `-qform A`, using that
`#{i | 0 < -eigenvalues A i} = #{i | eigenvalues A i < 0}` over the same index
set (no reindexing needed).
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.GateC2.HermitianSylvester

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The real-valued Hermitian quadratic form `x ↦ re (xᴴ A x)`. -/
noncomputable def qform (A : Matrix n n ℂ) (x : n → ℂ) : ℝ :=
  (star x ⬝ᵥ A *ᵥ x).re

omit [DecidableEq n] in
/-- A `*`-congruence transports the form along the linear map `x ↦ S *ᵥ x`. -/
lemma qform_congr (A S : Matrix n n ℂ) (x : n → ℂ) :
    qform (Sᴴ * A * S) x = qform A (S *ᵥ x) := by
  unfold qform
  congr 1
  rw [Matrix.mul_assoc, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec,
      Matrix.dotProduct_mulVec, ← Matrix.star_mulVec]

/-- **Key diagonalisation.** By the spectral theorem the Hermitian form `qform A`
is, in the eigenvector coordinates `E`, a weighted sum of squares with the
eigenvalues as weights. -/
lemma exists_qform_weighted (A : Matrix n n ℂ) (hA : A.IsHermitian) :
    ∃ E : (n → ℂ) ≃ₗ[ℂ] (n → ℂ),
      ∀ x, qform A x = ∑ i, hA.eigenvalues i * ‖(E x) i‖ ^ 2 := by
  classical
  set U : Matrix n n ℂ := (hA.eigenvectorUnitary : Matrix n n ℂ) with hU
  have hmul : U * star U = 1 := by
    rw [hU]; exact (hA.eigenvectorUnitary).2.2
  have hInv : Invertible (star U) := invertibleOfLeftInverse (star U) U hmul
  refine ⟨(star U).toLinearEquiv' hInv, fun x => ?_⟩
  have hEx : ((star U).toLinearEquiv' hInv) x = star U *ᵥ x := rfl
  rw [hEx]
  -- Now the concrete weighted-sum identity, proved via the spectral theorem.
  set D : Matrix n n ℂ := diagonal (RCLike.ofReal ∘ hA.eigenvalues) with hD
  have hAe : A = U * D * star U := by
    conv_lhs => rw [hA.spectral_theorem]; rw [Unitary.conjStarAlgAut_apply]
  set y : n → ℂ := star U *ᵥ x with hy
  have hAx : A *ᵥ x = U *ᵥ (D *ᵥ y) := by
    rw [hAe, hy, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, mul_assoc]
  have h1 : (star x ⬝ᵥ A *ᵥ x).re = (star y ⬝ᵥ D *ᵥ y).re := by
    congr 1
    rw [hAx, Matrix.dotProduct_mulVec]
    congr 1
    rw [hy, Matrix.star_mulVec, star_eq_conjTranspose, conjTranspose_conjTranspose]
  rw [qform, h1, dotProduct, Complex.re_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [hD]
  simp only [Matrix.mulVec_diagonal, Function.comp_apply, Pi.star_apply, RCLike.star_def]
  rw [show (starRingEnd ℂ) (y i) * ((RCLike.ofReal (hA.eigenvalues i)) * y i)
      = (RCLike.ofReal (hA.eigenvalues i)) * (starRingEnd ℂ (y i) * y i) by ring]
  rw [Complex.mul_re, show (RCLike.ofReal (hA.eigenvalues i) : ℂ) = ((hA.eigenvalues i : ℝ) : ℂ) from rfl]
  simp only [Complex.ofReal_re, Complex.ofReal_im, zero_mul, sub_zero]
  rw [mul_comm (starRingEnd ℂ (y i)) (y i), Complex.mul_conj, Complex.ofReal_re,
    Complex.normSq_eq_norm_sq]

/-- A subspace on which the form `Q` is positive on all nonzero vectors. -/
def IsPosSubF (Q : (n → ℂ) → ℝ) (V : Submodule ℂ (n → ℂ)) : Prop :=
  ∀ x ∈ V, x ≠ 0 → 0 < Q x

/-- The set of dimensions of `Q`-positive subspaces. -/
def posDimSetF (Q : (n → ℂ) → ℝ) : Set ℕ :=
  {d | ∃ V : Submodule ℂ (n → ℂ), IsPosSubF Q V ∧ Module.finrank ℂ V = d}

/-- The maximal dimension of a `Q`-positive subspace. -/
noncomputable def maxPosDimF (Q : (n → ℂ) → ℝ) : ℕ := sSup (posDimSetF Q)

omit [Fintype n] [DecidableEq n] in
lemma posDimSetF_nonempty (Q : (n → ℂ) → ℝ) : (posDimSetF Q).Nonempty := by
  refine ⟨0, ⊥, ?_, finrank_bot ℂ (n → ℂ)⟩
  intro x hx hx0
  simp only [Submodule.mem_bot] at hx
  exact absurd hx hx0

omit [Fintype n] [DecidableEq n] in
lemma posDimSetF_bddAbove [Finite n] (Q : (n → ℂ) → ℝ) : BddAbove (posDimSetF Q) := by
  letI := Fintype.ofFinite n
  refine ⟨Fintype.card n, ?_⟩
  rintro d ⟨V, _, rfl⟩
  calc Module.finrank ℂ V ≤ Module.finrank ℂ (n → ℂ) := Submodule.finrank_le V
    _ = Fintype.card n := by simp

omit [Fintype n] [DecidableEq n] in
/-- One inclusion of the dimension sets under a change of variables. -/
lemma posDimSetF_subset_of_congr
    (Q₁ Q₂ : (n → ℂ) → ℝ) (F : (n → ℂ) ≃ₗ[ℂ] (n → ℂ))
    (h : ∀ x, Q₂ x = Q₁ (F x)) : posDimSetF Q₂ ⊆ posDimSetF Q₁ := by
  rintro d ⟨V, hV, rfl⟩
  refine ⟨V.map (F : (n → ℂ) →ₗ[ℂ] (n → ℂ)), ?_, LinearEquiv.finrank_map_eq F V⟩
  rintro y hy hy0
  rw [Submodule.mem_map] at hy
  obtain ⟨v, hvV, rfl⟩ := hy
  simp only [LinearEquiv.coe_coe] at hy0 ⊢
  rw [← h v]
  refine hV v hvV (fun hv => hy0 ?_)
  rw [hv]; exact map_zero F

omit [Fintype n] [DecidableEq n] in
/-- Invariance of the invariant under a linear change of variables. -/
lemma maxPosDimF_congr
    (Q₁ Q₂ : (n → ℂ) → ℝ) (F : (n → ℂ) ≃ₗ[ℂ] (n → ℂ))
    (h : ∀ x, Q₂ x = Q₁ (F x)) : maxPosDimF Q₂ = maxPosDimF Q₁ := by
  unfold maxPosDimF
  congr 1
  refine Set.Subset.antisymm (posDimSetF_subset_of_congr Q₁ Q₂ F h)
    (posDimSetF_subset_of_congr Q₂ Q₁ F.symm ?_)
  intro x
  rw [h (F.symm x), LinearEquiv.apply_symm_apply]

/-- The submodule of functions supported on `T`. -/
def coordSpace (T : Finset n) : Submodule ℂ (n → ℂ) where
  carrier := {x | ∀ i, i ∉ T → x i = 0}
  add_mem' ha hb i hi := by simp [ha i hi, hb i hi]
  zero_mem' := by intro i _; rfl
  smul_mem' c a ha i hi := by simp [ha i hi]

omit [Fintype n] [DecidableEq n] in
@[simp] lemma mem_coordSpace {T : Finset n} {x : n → ℂ} :
    x ∈ coordSpace T ↔ ∀ i, i ∉ T → x i = 0 := Iff.rfl

/-- Restriction identifies `coordSpace T` with functions on `T`. -/
noncomputable def coordEquiv (T : Finset n) : coordSpace T ≃ₗ[ℂ] (T → ℂ) where
  toFun x := fun j => (x : n → ℂ) j
  map_add' x y := rfl
  map_smul' c x := rfl
  invFun g := ⟨fun i => if h : i ∈ T then g ⟨i, h⟩ else 0, by intro i hi; simp [hi]⟩
  left_inv := by
    rintro ⟨x, hx⟩
    ext i
    by_cases h : i ∈ T
    · simp [h]
    · simp [h, hx i h]
  right_inv := by
    intro g
    ext j
    simp [j.2]

omit [Fintype n] [DecidableEq n] in
lemma finrank_coordSpace (T : Finset n) :
    Module.finrank ℂ (coordSpace T) = T.card := by
  classical
  rw [(coordEquiv T).finrank_eq, Module.finrank_pi]
  simp

omit [DecidableEq n] in
/-- **Eigenvalue count.** For a diagonalised form `Q x = ∑ i, w i * ‖(E x) i‖²`
the maximal dimension of a `Q`-positive subspace is the number of positive
weights. -/
lemma maxPosDimF_eq_posCard (w : n → ℝ) (E : (n → ℂ) ≃ₗ[ℂ] (n → ℂ))
    (Q : (n → ℂ) → ℝ) (hQ : ∀ x, Q x = ∑ i, w i * ‖(E x) i‖ ^ 2) :
    maxPosDimF Q = (Finset.univ.filter (fun i => 0 < w i)).card := by
  classical
  set posT : Finset n := Finset.univ.filter (fun i => 0 < w i) with hposT
  set negT : Finset n := Finset.univ.filter (fun i => ¬ 0 < w i) with hnegT
  have hpart : posT.card + negT.card = Fintype.card n := by
    rw [hposT, hnegT]; exact Finset.card_filter_add_card_filter_not _
  -- Upper bound: any `Q`-positive subspace has dimension at most `posT.card`.
  have hmemUpper : ∀ (V : Submodule ℂ (n → ℂ)), IsPosSubF Q V →
      Module.finrank ℂ V ≤ posT.card := by
    intro V hV
    set W : Submodule ℂ (n → ℂ) := (coordSpace negT).map (E.symm : (n→ℂ) →ₗ[ℂ] (n→ℂ)) with hW
    have hWfin : Module.finrank ℂ W = negT.card := by
      rw [hW, LinearEquiv.finrank_map_eq, finrank_coordSpace]
    have hinf : V ⊓ W = ⊥ := by
      rw [Submodule.eq_bot_iff]
      intro x hx
      rw [Submodule.mem_inf] at hx
      obtain ⟨hxV, hxW⟩ := hx
      by_contra hx0
      have hpos := hV x hxV hx0
      rw [hW, Submodule.mem_map_equiv, LinearEquiv.symm_symm, mem_coordSpace] at hxW
      have hle : Q x ≤ 0 := by
        rw [hQ]; apply Finset.sum_nonpos; intro i _
        by_cases hi : i ∈ negT
        · have hwi : w i ≤ 0 := by
            rw [hnegT] at hi; simpa using not_lt.1 (Finset.mem_filter.1 hi).2
          exact mul_nonpos_of_nonpos_of_nonneg hwi (by positivity)
        · rw [hxW i hi]; simp
      linarith
    have h1 := Submodule.finrank_sup_add_finrank_inf_eq V W
    rw [hinf, finrank_bot, add_zero, hWfin] at h1
    have h2 : Module.finrank ℂ ↥(V ⊔ W) ≤ Fintype.card n :=
      le_trans (Submodule.finrank_le _) (by simp)
    omega
  -- Lower bound: the eigenspace of positive weights is `Q`-positive.
  have hlower : posT.card ∈ posDimSetF Q := by
    refine ⟨(coordSpace posT).map (E.symm : (n→ℂ) →ₗ[ℂ] (n→ℂ)), ?_, ?_⟩
    · intro x hxV hx0
      rw [Submodule.mem_map_equiv, LinearEquiv.symm_symm, mem_coordSpace] at hxV
      rw [hQ]
      apply Finset.sum_pos'
      · intro i _
        by_cases hi : i ∈ posT
        · have hwi : 0 < w i := by rw [hposT] at hi; simpa using (Finset.mem_filter.1 hi).2
          exact mul_nonneg hwi.le (by positivity)
        · rw [hxV i hi]; simp
      · have hEx : E x ≠ 0 := fun h => hx0 (by have := congrArg E.symm h; simpa using this)
        rw [Function.ne_iff] at hEx
        obtain ⟨i, hi⟩ := hEx
        have hival : (E x) i ≠ 0 := by simpa using hi
        have hiT : i ∈ posT := by by_contra hnot; exact hival (hxV i hnot)
        have hwi : 0 < w i := by rw [hposT] at hiT; simpa using (Finset.mem_filter.1 hiT).2
        exact ⟨i, Finset.mem_univ i, mul_pos hwi (by positivity)⟩
    · rw [LinearEquiv.finrank_map_eq, finrank_coordSpace]
  refine le_antisymm ?_ ?_
  · exact csSup_le (posDimSetF_nonempty Q) (by rintro d ⟨V, hV, rfl⟩; exact hmemUpper V hV)
  · exact le_csSup (posDimSetF_bddAbove Q) hlower

/-- **Sylvester's law of inertia (Hermitian matrix / eigenvalue-count form).**
A `*`-congruence `B = Sᴴ A S` by an invertible `S` preserves the number of
positive eigenvalues and the number of negative eigenvalues of a complex Hermitian
matrix. -/
theorem congruence_preserves_inertia
    (A B S : Matrix n n ℂ) (hA : A.IsHermitian) (hB : B.IsHermitian)
    (hS : IsUnit S.det) (hcongr : B = Sᴴ * A * S) :
    (Finset.univ.filter (fun i => 0 < hA.eigenvalues i)).card
        = (Finset.univ.filter (fun i => 0 < hB.eigenvalues i)).card
    ∧ (Finset.univ.filter (fun i => hA.eigenvalues i < 0)).card
        = (Finset.univ.filter (fun i => hB.eigenvalues i < 0)).card := by
  -- The change-of-variables equivalence `F x = S *ᵥ x`.
  have hInvS : Invertible S := S.invertibleOfIsUnitDet hS
  set F : (n → ℂ) ≃ₗ[ℂ] (n → ℂ) := S.toLinearEquiv' hInvS with hF
  have hFx : ∀ x, F x = S *ᵥ x := fun x => rfl
  -- Diagonalisations of A and B.
  obtain ⟨EA, hEA⟩ := exists_qform_weighted A hA
  obtain ⟨EB, hEB⟩ := exists_qform_weighted B hB
  -- Congruence relation on the forms.
  have hcong : ∀ x, qform B x = qform A (F x) := by
    intro x; rw [hcongr, qform_congr, hFx]
  have hcongNeg : ∀ x, (fun x => -qform B x) x = (fun x => -qform A x) (F x) := by
    intro x; show -qform B x = -qform A (F x); rw [hcong]
  -- POSITIVE count.
  have hposA : maxPosDimF (qform A)
      = (Finset.univ.filter (fun i => 0 < hA.eigenvalues i)).card :=
    maxPosDimF_eq_posCard hA.eigenvalues EA (qform A) hEA
  have hposB : maxPosDimF (qform B)
      = (Finset.univ.filter (fun i => 0 < hB.eigenvalues i)).card :=
    maxPosDimF_eq_posCard hB.eigenvalues EB (qform B) hEB
  have hposInv : maxPosDimF (qform B) = maxPosDimF (qform A) :=
    maxPosDimF_congr (qform A) (qform B) F hcong
  -- NEGATIVE count via negated weights.
  have hnegA : maxPosDimF (fun x => -qform A x)
      = (Finset.univ.filter (fun i => hA.eigenvalues i < 0)).card := by
    have := maxPosDimF_eq_posCard (fun i => -hA.eigenvalues i) EA (fun x => -qform A x)
      (by intro x; show -qform A x = ∑ i, -hA.eigenvalues i * ‖EA x i‖ ^ 2
          rw [hEA, ← Finset.sum_neg_distrib]
          exact Finset.sum_congr rfl (fun i _ => by ring))
    rw [this]; congr 1; ext i; simp
  have hnegB : maxPosDimF (fun x => -qform B x)
      = (Finset.univ.filter (fun i => hB.eigenvalues i < 0)).card := by
    have := maxPosDimF_eq_posCard (fun i => -hB.eigenvalues i) EB (fun x => -qform B x)
      (by intro x; show -qform B x = ∑ i, -hB.eigenvalues i * ‖EB x i‖ ^ 2
          rw [hEB, ← Finset.sum_neg_distrib]
          exact Finset.sum_congr rfl (fun i _ => by ring))
    rw [this]; congr 1; ext i; simp
  have hnegInv : maxPosDimF (fun x => -qform B x) = maxPosDimF (fun x => -qform A x) :=
    maxPosDimF_congr (fun x => -qform A x) (fun x => -qform B x) F hcongNeg
  refine ⟨?_, ?_⟩
  · rw [← hposA, ← hposB, hposInv]
  · rw [← hnegA, ← hnegB, hnegInv]

end PhysicsSM.Draft.NullEdge.GateC2.HermitianSylvester
