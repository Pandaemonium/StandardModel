import Mathlib

/-!
# MC5 L2 operator-norm bookkeeping (Opus, verified Aristotle b078790e)

Abstract Mathlib-only bricks answering the MC5 hidden-assumption question raised in
`AutonomousLab/work/NE-3PLUS1/OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md`:
does a four-component estimate assembled from two-component estimates accumulate a
constant? ANSWER: NO **for BLOCK-DIAGONAL assembly** (the only case proved here).
CORRECTION (docstring audit `6d88b22a`): this does NOT extend to a general block
matrix - the witness [[I,I],[I,I]] has every block of constant 1 yet norm ratio 2, so
OFF-DIAGONAL blocks DO accumulate. Do not cite this for non-block-diagonal assembly. With the L2 operator norm - unitary matrices have norm 1,
unitary conjugation is an isometry, and (proved as a general equality for arbitrary
finite nonempty block index types) ||fromBlocks A 0 0 B|| = max ||A|| ||B||, giving
the difference estimate at constant exactly 1.

Offered to Codex for the MC2/MC5 integration (Codex owns the MC Lean; this module is
walk-agnostic and touches no MC file). Namespace kept as the prover's
MC5NormBookkeeping. Provenance: verified at pin from task f032fd17. Standard three.
Claim grade M, [comp]. -/

open scoped Matrix.Norms.L2Operator

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option autoImplicit false

namespace MC5NormBookkeeping

/-- A unitary matrix has L2 operator norm one. -/
theorem unitary_l2_opNorm {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    {U : Matrix n n ℂ} (hU : U ∈ Matrix.unitaryGroup n ℂ) :
    ‖U‖ = 1 := by
  convert CStarRing.norm_of_mem_unitary hU

/-- Conjugation by a unitary matrix preserves the L2 operator norm. -/
theorem unitary_conjugation_l2_opNorm {n : Type*} [Fintype n] [DecidableEq n]
    {U A : Matrix n n ℂ} (hU : U ∈ Matrix.unitaryGroup n ℂ) :
    ‖U * A * star U‖ = ‖A‖ := by
  rw [Matrix.mul_assoc, CStarRing.norm_mem_unitary_mul (A * star U) hU,
    CStarRing.norm_mul_mem_unitary A (Unitary.star_mem hU)]

/-- The L2 operator norm of a block diagonal matrix is the maximum of the
operator norms of its diagonal blocks. -/
theorem l2_opNorm_fromBlocks_zero {m n : Type*}
    [Fintype m] [DecidableEq m] [Nonempty m]
    [Fintype n] [DecidableEq n] [Nonempty n]
    (A : Matrix m m ℂ) (B : Matrix n n ℂ) :
    ‖Matrix.fromBlocks A 0 0 B‖ = max ‖A‖ ‖B‖ := by
  refine' le_antisymm _ _;
  · have := Matrix.l2_opNorm_def ( Matrix.fromBlocks A 0 0 B );
    refine' this ▸ ContinuousLinearMap.opNorm_le_bound _ ( by positivity ) fun x => _;
    simp +decide [ EuclideanSpace.norm_eq, Matrix.toEuclideanLin ];
    -- Apply the triangle inequality to the sums.
    have h_triangle : (∑ a₁, ‖(A.mulVec (fun i => x.ofLp (Sum.inl i))) a₁‖ ^ 2) ≤ ‖A‖ ^ 2 * (∑ a₁, ‖x.ofLp (Sum.inl a₁)‖ ^ 2) ∧ (∑ a₂, ‖(B.mulVec (fun i => x.ofLp (Sum.inr i))) a₂‖ ^ 2) ≤ ‖B‖ ^ 2 * (∑ a₂, ‖x.ofLp (Sum.inr a₂)‖ ^ 2) := by
      have h_triangle : ∀ (M : Matrix m m ℂ) (v : EuclideanSpace ℂ m), (∑ a₁, ‖(M.mulVec v) a₁‖ ^ 2) ≤ ‖M‖ ^ 2 * (∑ a₁, ‖v a₁‖ ^ 2) := by
        intro M v
        have h_triangle : ‖(Matrix.toEuclideanLin M) v‖ ^ 2 ≤ ‖M‖ ^ 2 * ‖v‖ ^ 2 := by
          rw [ ← mul_pow ];
          exact pow_le_pow_left₀ ( norm_nonneg _ ) ( ContinuousLinearMap.le_opNorm ( Matrix.toEuclideanLin M |> LinearMap.toContinuousLinearMap ) v ) _;
        simp_all +decide [ EuclideanSpace.norm_eq, Real.sq_sqrt ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ];
      have h_triangle_B : ∀ (M : Matrix n n ℂ) (v : EuclideanSpace ℂ n), (∑ a₂, ‖(M.mulVec v) a₂‖ ^ 2) ≤ ‖M‖ ^ 2 * (∑ a₂, ‖v a₂‖ ^ 2) := by
        intro M v
        have h_triangle : ∀ (v : EuclideanSpace ℂ n), ‖(Matrix.toEuclideanLin M) v‖ ^ 2 ≤ ‖M‖ ^ 2 * ‖v‖ ^ 2 := by
          intro v
          have h_triangle : ‖(Matrix.toEuclideanLin M) v‖ ≤ ‖M‖ * ‖v‖ := by
            convert ContinuousLinearMap.le_opNorm ( Matrix.toEuclideanLin M |> LinearMap.toContinuousLinearMap ) v using 1;
          simpa only [ mul_pow ] using pow_le_pow_left₀ ( norm_nonneg _ ) h_triangle 2;
        simp_all +decide [ EuclideanSpace.norm_eq, Real.sq_sqrt ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ];
      exact ⟨ h_triangle A ( EuclideanSpace.equiv _ _ |>.symm <| fun i => x.ofLp ( Sum.inl i ) ), h_triangle_B B ( EuclideanSpace.equiv _ _ |>.symm <| fun i => x.ofLp ( Sum.inr i ) ) ⟩;
    rw [ Real.sqrt_le_iff ];
    simp_all +decide [ mul_pow, Real.sq_sqrt ( add_nonneg ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ) ];
    refine' ⟨ mul_nonneg ( le_max_of_le_left ( norm_nonneg _ ) ) ( Real.sqrt_nonneg _ ), _ ⟩;
    simp_all +decide [ Matrix.mulVec, dotProduct ];
    nlinarith [ show 0 ≤ ∑ i : m, ‖x.ofLp ( Sum.inl i )‖ ^ 2 by exact Finset.sum_nonneg fun _ _ => sq_nonneg _, show 0 ≤ ∑ i : n, ‖x.ofLp ( Sum.inr i )‖ ^ 2 by exact Finset.sum_nonneg fun _ _ => sq_nonneg _, show ‖A‖ ^ 2 ≤ max ‖A‖ ‖B‖ ^ 2 by exact pow_le_pow_left₀ ( norm_nonneg _ ) ( le_max_left _ _ ) _, show ‖B‖ ^ 2 ≤ max ‖A‖ ‖B‖ ^ 2 by exact pow_le_pow_left₀ ( norm_nonneg _ ) ( le_max_right _ _ ) _ ];
  · refine' max_le _ _;
    · refine' le_csInf _ _ <;> norm_num;
      · refine' ⟨ ‖Matrix.fromBlocks A 0 0 B‖, ⟨ norm_nonneg _, fun x => _ ⟩ ⟩;
        convert ContinuousLinearMap.le_opNorm ( Matrix.toEuclideanLin ( Matrix.fromBlocks A 0 0 B ) |> ContinuousLinearMap.mk ) x using 1;
      · intro b hb h; refine' ContinuousLinearMap.opNorm_le_bound _ hb fun x => _; simp_all +decide [ Matrix.toEuclideanLin, EuclideanSpace.norm_eq ] ;
        convert h ( WithLp.toLp _ ( Sum.elim x 0 ) ) using 1 <;> simp +decide [ Matrix.mulVec, dotProduct ];
    · refine' le_csInf _ _;
      · refine' ⟨ ‖Matrix.fromBlocks A 0 0 B‖, _, _ ⟩;
        · positivity;
        · convert ContinuousLinearMap.le_opNorm ( Matrix.toEuclideanLin ( Matrix.fromBlocks A 0 0 B ) |> LinearMap.toContinuousLinearMap ) using 1;
      · intro c hc;
        refine' csInf_le _ _;
        · exact ⟨ 0, fun c hc => hc.1 ⟩;
        · simp_all +decide [ EuclideanSpace.norm_eq, Matrix.toEuclideanLin ];
          intro x; specialize hc; have := hc.2 ( EuclideanSpace.single ( Sum.inr ( Classical.arbitrary n ) ) 1 ) ; simp_all +decide [ Matrix.mulVec, dotProduct ] ;
          convert hc.2 ( x := ( 0 : EuclideanSpace ℂ m ) |> fun y => WithLp.toLp 2 ( Sum.elim y x ) ) using 1 <;> simp +decide

/-- Specialization of `l2_opNorm_fromBlocks_zero` to two two-component blocks. -/
theorem l2_opNorm_fromBlocks_fin2 (A B : Matrix (Fin 2) (Fin 2) ℂ) :
    ‖Matrix.fromBlocks A 0 0 B‖ = max ‖A‖ ‖B‖ := by
  convert l2_opNorm_fromBlocks_zero A B using 1

/-- Taking the difference of two block diagonal matrices does not enlarge the
larger of the two blockwise errors. -/
theorem l2_opNorm_fromBlocks_sub_fin2
    (A B A' B' : Matrix (Fin 2) (Fin 2) ℂ) :
    ‖Matrix.fromBlocks A 0 0 B - Matrix.fromBlocks A' 0 0 B'‖ ≤
      max ‖A - A'‖ ‖B - B'‖ := by
  rw [ ← l2_opNorm_fromBlocks_fin2 ];
  convert le_rfl using 2 ; ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.fromBlocks ]

end MC5NormBookkeeping
