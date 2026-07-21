import Mathlib

/-!
# MC2 block-diagonalization + unitary-conjugation lift (Opus, verified 180a91b7)

Abstract Mathlib-only brick completing MC2 support for the ladder audited in
`AutonomousLab/work/NE-3PLUS1/OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md`.
Once that audit resolved the norm-instance question (L2 operator norm, so
conjugation by a FIXED unitary is a genuine isometry), MC2 reduced to pure
bookkeeping; CORRECTION (docstring audit `6d88b22a`): the isometry justifies
comparing two operators conjugated by the SAME fixed unitary only. It does NOT
license comparing steps conjugated by DIFFERENT unitaries - witness A = diag(1,-1)
with U0 = I and U1 = swap, both orthogonal, original squared distance 0 but
conjugated squared distance 8. Any eps-dependent conjugator needs its own variation
estimate. this is that
bookkeeping, done once and reusably. Contents: reindexing preserves the L2 operator
norm; ||fromBlocks X 0 0 Y|| = max ||X|| ||Y||; block_lift and conjugated_lift; and
combined_lift composing them while RETAINING c * eps^2 with no constant
accumulation. Proved by block algebra and C*-unitary norm preservation - it does NOT
expand the sixteen entries, honouring the 'composition theorem, not a new Taylor
expansion' requirement.

Offered to Codex for the MC2 integration (walk-agnostic; no MC file touched).
Namespace kept as the prover's MC2. Provenance: verified at pin from task 893e83a8.
Standard three. Claim grade M, [comp]. -/

open scoped Matrix.Norms.L2Operator

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

namespace MC2

open Matrix

/-- The `4 × 4` block diagonal matrix with two `2 × 2` diagonal blocks. -/
noncomputable def blockDiag (X Y : Matrix (Fin 2) (Fin 2) ℂ) :
    Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.reindex finSumFinEquiv finSumFinEquiv (Matrix.fromBlocks X 0 0 Y)

/-
Reindexing both coordinates of a complex matrix preserves the L2 operator norm.
-/
lemma l2_opNorm_reindex_equiv {m n m' n' : Type*}
    [Fintype m] [Fintype n] [Fintype m'] [Fintype n']
    [DecidableEq n] [DecidableEq n']
    (er : m ≃ m') (ec : n ≃ n') (A : Matrix m n ℂ) :
    ‖Matrix.reindex er ec A‖ = ‖A‖ := by
  refine' le_antisymm _ _ <;> simp +decide at *;
  · refine' ContinuousLinearMap.opNorm_le_bound _ ( norm_nonneg _ ) fun x => _ ; simp +decide [ EuclideanSpace.norm_eq ] at *;
    refine' le_trans _ ( mul_le_mul_of_nonneg_right ( le_csInf _ _ ) ( Real.sqrt_nonneg _ ) ) <;> norm_num at *;
    rotate_left;
    exact ( SupSet.sSup { c : ℝ | ∃ x : EuclideanSpace ℂ n, ‖x‖ = 1 ∧ c = ‖( toEuclideanLin A ) x‖ } );
    · refine' ⟨ ‖LinearMap.toContinuousLinearMap ( toEuclideanLin A )‖, ⟨ norm_nonneg _, fun x => _ ⟩ ⟩;
      exact ContinuousLinearMap.le_opNorm ( LinearMap.toContinuousLinearMap ( toEuclideanLin A ) ) x;
    · intro b hb h; by_cases h' : ∃ x : EuclideanSpace ℂ n, ‖x‖ = 1 <;> simp_all +decide;
      exact csSup_le ⟨ _, ⟨ h'.choose, h'.choose_spec, rfl ⟩ ⟩ fun c hc => by rcases hc with ⟨ x, hx, rfl ⟩ ; simpa [ hx ] using h x;
    · by_cases hx : x = 0 <;> simp_all +decide [ EuclideanSpace.norm_eq ];
      rw [ ← div_le_iff₀ ( Real.sqrt_pos.mpr <| lt_of_le_of_ne ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) <| Ne.symm <| by contrapose! hx; ext i; simp_all +decide [Finset.sum_eq_zero_iff_of_nonneg] ) ];
      refine' le_csSup _ _;
      · refine' ⟨ ∑ i, ∑ j, ‖A i j‖ ^ 2 + 1, fun c hc => _ ⟩ ; rcases hc with ⟨ x, hx, rfl ⟩ ; simp_all +decide [ Matrix.mulVec, dotProduct ];
        -- Applying the Cauchy-Schwarz inequality to each term in the sum, we get:
        have h_cauchy_schwarz : ∀ i, ‖∑ j, A i j * x.ofLp j‖ ^ 2 ≤ (∑ j, ‖A i j‖ ^ 2) * (∑ j, ‖x.ofLp j‖ ^ 2) := by
          intro i
          have h_cauchy_schwarz : ‖∑ j, A i j * x.ofLp j‖ ^ 2 ≤ (∑ j, ‖A i j‖ * ‖x.ofLp j‖) ^ 2 := by
            exact pow_le_pow_left₀ ( norm_nonneg _ ) ( norm_sum_le _ _ |> le_trans <| Finset.sum_le_sum fun _ _ => by rw [ norm_mul ] ) _;
          refine' le_trans h_cauchy_schwarz _;
          exact Finset.sum_mul_sq_le_sq_mul_sq Finset.univ
            (fun j => ‖A i j‖) (fun j => ‖x.ofLp j‖);
        rw [ Real.sqrt_le_left ] <;> try positivity;
        refine' le_trans ( Finset.sum_le_sum fun i _ => h_cauchy_schwarz i ) _ ; simp_all +decide [add_sq];
        nlinarith only [ show 0 ≤ ∑ i, ∑ j, ‖A i j‖ ^ 2 by exact Finset.sum_nonneg fun i _ => Finset.sum_nonneg fun j _ => sq_nonneg _ ];
      · refine' ⟨ _, _, _ ⟩;
        exact ( fun i => x ( ec i ) / Real.sqrt ( ∑ i, ‖x i‖ ^ 2 ) ) |> fun f => WithLp.toLp _ f;
        · simp +decide [ div_pow, Real.sq_sqrt ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ];
          rw [ ← Finset.sum_div _ _ _, div_eq_iff ] <;> norm_num [ hx ];
          · conv_rhs => rw [ ← Equiv.sum_comp ec ] ;
          · exact fun h => hx <| by ext i; simpa [ sq ] using Finset.sum_eq_zero_iff_of_nonneg ( fun _ _ => sq_nonneg _ ) |>.1 h i;
        · simp +decide [Matrix.mulVec, dotProduct];
          simp +decide [ ← mul_div_assoc, ← Finset.sum_div _ _ _, div_pow, Real.sq_sqrt ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ];
          rw [ Real.sqrt_div ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ), ← Equiv.sum_comp er.symm ];
  · refine' le_csInf _ _;
    · refine' ⟨ ‖ ( toEuclideanLin.trans LinearMap.toContinuousLinearMap ) ( A.submatrix er.symm ec.symm )‖, ⟨ norm_nonneg _, fun x => _ ⟩ ⟩;
      exact ContinuousLinearMap.le_opNorm _ _;
    · simp +decide [EuclideanSpace.norm_eq];
      intro b hb h; refine' csInf_le _ _ <;> norm_num [ hb ];
      · exact ⟨ 0, fun c hc => hc.1 ⟩;
      · intro x; specialize h ( ( EuclideanSpace.equiv n' ℂ ).symm ( x ∘ ec.symm ) ) ; simp_all +decide [EuclideanSpace.norm_eq, Matrix.mulVec, dotProduct];
        convert h using 1;
        · conv_lhs => rw [ ← Equiv.sum_comp er.symm ] ;
        · conv_lhs => rw [ ← Equiv.sum_comp ec.symm ] ;

/-
The L2 operator norm of a block diagonal matrix is the maximum of the norms
of its two diagonal blocks.
-/
lemma l2_opNorm_fromBlocks_zero {m n : Type*}
    [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]
    (X : Matrix m m ℂ) (Y : Matrix n n ℂ) :
    ‖Matrix.fromBlocks X 0 0 Y‖ = max ‖X‖ ‖Y‖ := by
  refine' le_antisymm _ _;
  · refine' ContinuousLinearMap.opNorm_le_bound _ _ fun v => _;
    · positivity;
    · -- By definition of the L2 operator norm, we have:
      have h_norm_def : ∀ (v : EuclideanSpace ℂ (m ⊕ n)), ‖(Matrix.toEuclideanLin.trans LinearMap.toContinuousLinearMap (Matrix.fromBlocks X 0 0 Y)) v‖^2 ≤ (max ‖X‖ ‖Y‖)^2 * ‖v‖^2 := by
        intro v
        obtain ⟨v₁, v₂⟩ : ∃ v₁ : EuclideanSpace ℂ m, ∃ v₂ : EuclideanSpace ℂ n, v = Sum.elim v₁ v₂ := by
          exact ⟨ { ofLp := fun i => v.ofLp ( Sum.inl i ) }, { ofLp := fun i => v.ofLp ( Sum.inr i ) }, by ext i; cases i <;> rfl ⟩;
        obtain ⟨ v₂, hv₂ ⟩ := v₂; simp_all +decide [ EuclideanSpace.norm_eq, Matrix.toEuclideanLin ] ;
        -- By definition of matrix multiplication and the properties of the L2 norm, we can expand the left-hand side.
        have h_expand : ∑ a₁, ‖(fromBlocks X 0 0 Y *ᵥ (v₁.ofLp ⊕ᵥ v₂.ofLp)) (Sum.inl a₁)‖ ^ 2 + ∑ a₂, ‖(fromBlocks X 0 0 Y *ᵥ (v₁.ofLp ⊕ᵥ v₂.ofLp)) (Sum.inr a₂)‖ ^ 2 = ∑ a₁, ‖(X.mulVec v₁) a₁‖ ^ 2 + ∑ a₂, ‖(Y.mulVec v₂) a₂‖ ^ 2 := by
          simp +decide [Matrix.mulVec, dotProduct];
        -- By definition of the L2 operator norm, we know that:
        have h_norm_X : ∑ a₁, ‖(X.mulVec v₁) a₁‖ ^ 2 ≤ ‖X‖ ^ 2 * ∑ a₁, ‖v₁ a₁‖ ^ 2 := by
          have h_norm_X : ∀ (v : EuclideanSpace ℂ m), ‖(Matrix.toEuclideanLin.trans LinearMap.toContinuousLinearMap X) v‖ ^ 2 ≤ ‖X‖ ^ 2 * ‖v‖ ^ 2 := by
            exact fun v => by rw [ ← mul_pow ] ; exact pow_le_pow_left₀ ( norm_nonneg _ ) ( ContinuousLinearMap.le_opNorm _ _ ) _;
          convert h_norm_X v₁ using 1 <;> simp +decide [ EuclideanSpace.norm_eq, Real.sq_sqrt <| Finset.sum_nonneg fun _ _ => sq_nonneg _ ]
        have h_norm_Y : ∑ a₂, ‖(Y.mulVec v₂) a₂‖ ^ 2 ≤ ‖Y‖ ^ 2 * ∑ a₂, ‖v₂ a₂‖ ^ 2 := by
          have h_norm_Y : ∀ (v : EuclideanSpace ℂ n), ‖(Matrix.toEuclideanLin.trans LinearMap.toContinuousLinearMap Y) v‖ ^ 2 ≤ ‖Y‖ ^ 2 * ‖v‖ ^ 2 := by
            intro v; exact (by
            rw [ ← mul_pow ];
            exact pow_le_pow_left₀ ( norm_nonneg _ ) ( ContinuousLinearMap.le_opNorm _ _ ) _);
          simp_all +decide [ EuclideanSpace.norm_eq, Matrix.toEuclideanLin ];
          simpa only [ Real.sq_sqrt ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ] using h_norm_Y v₂;
        rw [ Real.sq_sqrt ( add_nonneg ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ), Real.sq_sqrt ( add_nonneg ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ) ];
        rw [ h_expand, mul_add ];
        exact add_le_add ( le_trans h_norm_X ( mul_le_mul_of_nonneg_right ( pow_le_pow_left₀ ( norm_nonneg _ ) ( le_max_left _ _ ) _ ) ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ) ) ( le_trans h_norm_Y ( mul_le_mul_of_nonneg_right ( pow_le_pow_left₀ ( norm_nonneg _ ) ( le_max_right _ _ ) _ ) ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ) );
      exact le_of_pow_le_pow_left₀ ( by positivity ) ( by positivity ) ( le_trans ( h_norm_def v ) ( by rw [ mul_pow ] ) );
  · refine' max_le _ _;
    · refine' le_csInf _ _;
      · refine' ⟨ ‖ ( toEuclideanLin.trans LinearMap.toContinuousLinearMap ) ( fromBlocks X 0 0 Y )‖, ⟨ norm_nonneg _, _ ⟩ ⟩;
        exact fun x => ContinuousLinearMap.le_opNorm _ _;
      · simp +decide [Matrix.toEuclideanLin];
        intro b hb h; refine' ContinuousLinearMap.opNorm_le_bound _ hb _; intro x; simp +decide [ EuclideanSpace.norm_eq ] at *;
        convert h ( WithLp.toLp 2 ( Sum.elim x 0 ) ) using 1 <;> simp +decide [ Matrix.mulVec, dotProduct ];
    · refine' le_csInf _ _;
      · refine' ⟨ ‖( fromBlocks X 0 0 Y )‖, ⟨ norm_nonneg _, _ ⟩ ⟩;
        exact fun x => ContinuousLinearMap.le_opNorm _ _;
      · simp +decide [ EuclideanSpace.norm_eq, Matrix.toEuclideanLin ];
        intro b hb h;
        refine' ContinuousLinearMap.opNorm_le_bound _ hb fun x => _;
        simp_all +decide [ EuclideanSpace.norm_eq, Matrix.mulVec ];
        convert h ( WithLp.toLp 2 ( fun i => Sum.elim 0 x i ) ) using 1 <;> simp +decide [dotProduct]

/-
Specialized block norm formula for `blockDiag`.
-/
lemma norm_blockDiag (X Y : Matrix (Fin 2) (Fin 2) ℂ) :
    ‖blockDiag X Y‖ = max ‖X‖ ‖Y‖ := by
  convert l2_opNorm_fromBlocks_zero X Y using 1;
  convert l2_opNorm_reindex_equiv finSumFinEquiv finSumFinEquiv _ using 1

/-
Two componentwise estimates lift to the block diagonal matrix without
accumulating their common constant.
-/
theorem block_lift {Aplus Aminus Eplus Eminus : Matrix (Fin 2) (Fin 2) ℂ}
    {c eps : ℝ}
    (hplus : ‖Aplus - Eplus‖ ≤ c * eps ^ 2)
    (hminus : ‖Aminus - Eminus‖ ≤ c * eps ^ 2) :
    ‖blockDiag Aplus Aminus - blockDiag Eplus Eminus‖ ≤ c * eps ^ 2 := by
  have hBlocks :
      Matrix.fromBlocks Aplus 0 0 Aminus - Matrix.fromBlocks Eplus 0 0 Eminus =
        Matrix.fromBlocks (Aplus - Eplus) 0 0 (Aminus - Eminus) := by
    rw [sub_eq_add_neg, Matrix.fromBlocks_neg, Matrix.fromBlocks_add]
    simp only [sub_eq_add_neg, add_zero, neg_zero]
  have hReindex (P Q : Matrix (Fin 2 ⊕ Fin 2) (Fin 2 ⊕ Fin 2) ℂ) :
      Matrix.reindex finSumFinEquiv finSumFinEquiv P -
          Matrix.reindex finSumFinEquiv finSumFinEquiv Q =
        Matrix.reindex finSumFinEquiv finSumFinEquiv (P - Q) := rfl
  have hDiff :
      blockDiag Aplus Aminus - blockDiag Eplus Eminus =
        blockDiag (Aplus - Eplus) (Aminus - Eminus) := by
    unfold blockDiag
    rw [hReindex, hBlocks]
  rw [hDiff, norm_blockDiag]
  exact max_le hplus hminus

/-
Conjugation by a unitary matrix is an isometry for the L2 operator norm.
-/
lemma norm_unitary_conjugation (U X : Matrix (Fin 4) (Fin 4) ℂ)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) ℂ) :
    ‖U * X * star U‖ = ‖X‖ := by
  convert CStarRing.norm_mul_mem_unitary _ ( show star U ∈ unitaryGroup ( Fin 4 ) ℂ from ?_ ) using 1;
  · convert CStarRing.norm_mem_unitary_mul _ ( show U ∈ unitaryGroup ( Fin 4 ) ℂ from hU ) |> Eq.symm using 1;
  · simp_all +decide [ Matrix.mem_unitaryGroup_iff ]

/-
A block estimate is preserved exactly by a unitary change of basis.
-/
theorem conjugated_lift {Aplus Aminus Eplus Eminus : Matrix (Fin 2) (Fin 2) ℂ}
    {U : Matrix (Fin 4) (Fin 4) ℂ} {c eps : ℝ}
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hblock : ‖blockDiag Aplus Aminus - blockDiag Eplus Eminus‖ ≤ c * eps ^ 2) :
    ‖U * blockDiag Aplus Aminus * star U -
        U * blockDiag Eplus Eminus * star U‖ ≤ c * eps ^ 2 := by
  convert hblock using 1;
  have := norm_unitary_conjugation U ( blockDiag Aplus Aminus - blockDiag Eplus Eminus ) hU;
  simpa only [ Matrix.mul_sub, Matrix.sub_mul ] using this

/-
The combined bookkeeping lemma: two two-component bounds imply the
unitarily conjugated four-component bound with exactly the same constant.
-/
theorem combined_lift {Aplus Aminus Eplus Eminus : Matrix (Fin 2) (Fin 2) ℂ}
    {U : Matrix (Fin 4) (Fin 4) ℂ} {c eps : ℝ}
    (hplus : ‖Aplus - Eplus‖ ≤ c * eps ^ 2)
    (hminus : ‖Aminus - Eminus‖ ≤ c * eps ^ 2)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) ℂ) :
    ‖U * blockDiag Aplus Aminus * star U -
        U * blockDiag Eplus Eminus * star U‖ ≤ c * eps ^ 2 := by
  convert conjugated_lift hU ( block_lift hplus hminus ) using 1

end MC2
