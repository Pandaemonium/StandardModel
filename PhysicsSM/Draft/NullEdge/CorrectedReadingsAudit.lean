import Mathlib

/-!
# Audit of the CORRECTED readings (Opus, verified a21c13e4)

A meta-audit: after five rounds corrected 18 prose over-claims, this asks whether the
CORRECTIONS are themselves accurate. Four of five were not.

1. VACUOUS. My corrected gap-pole reading - 'internal spectral data do not determine
   an external readout that is not itself determined by that spectral data' - repeats
   'not determined' as its own premise. I OVER-CORRECTED into a tautology. The sharp
   NON-vacuous form is the explicit one: a PAIR with equal spectral data and unequal
   external readouts (which `GapPoleGeneralObstruction` now supplies in every finite
   dimension). State it that way, not as the tautology.
2. STILL NOT SHARP. For the transfer witness all NORMALIZED correlators agree and all
   effective masses equal log 2 - but AMPLITUDE-SENSITIVE standard readouts DO
   distinguish the witnesses (a finite integrated readout gives 3 versus 6). So
   'separates raw values only' understates it: it separates amplitude-sensitive
   readouts, and fails only for ratio/effective-mass readouts.
3. ACCURATE. Max-type non-accumulation holds for compatible block-diagonal/direct-sum
   assembly, and provably does NOT extend to block-triangular maps or to range
   orthogonality alone (counterexamples included).
4. STILL NOT SHARP. Contractions suffice; a uniform power bound C gives C^2 n ||U-V||;
   separate bounds give CU * CV * n * ||U-V||; and the EXACT telescoping-sum estimate
   needs NO contraction or power-bound hypothesis at all.
5. STILL NOT SHARP. ||U|| <= 1 is needed only to retain a UNIT bound; with mere
   boundedness ||U^n|| <= ||U||^n, and scalar 2 attains that geometric factor.

Lesson recorded: an over-claim and its correction can BOTH be wrong, in opposite
directions. Corrections need auditing exactly as originals do.

Provenance: verified at pin from task 886bd86a. Standard three. Grade M, [orig]. -/

open scoped BigOperators

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace CorrectedReadingsAudit

/-! This file formalizes concrete witnesses and the sharp norm estimates used in the audit. -/

/-- `data` determine `readout` when equal data force equal readouts. -/
def Determines {X D R : Type*} (data : X → D) (readout : X → R) : Prop :=
  ∀ ⦃x y⦄, data x = data y → readout x = readout y

/-- On the literal reading, “does not determine a readout which is not determined”
    merely repeats its premise. -/
theorem corrected_reading_one_is_tautological {X D R : Type*}
    (data : X → D) (readout : X → R) (h : ¬ Determines data readout) :
    ¬ Determines data readout := by
  exact h

/-- A fixed internal operator.  Changing only the external probe changes its readout. -/
def internalOp (x : ℝ × ℝ) : ℝ × ℝ := (0, x.2)

def spectralData (_probe : ℝ × ℝ) : ℝ := 0

def externalReadout (probe : ℝ × ℝ) : ℝ := (internalOp probe).2

theorem same_internal_different_external_readout :
    spectralData (1, 0) = spectralData (0, 1) ∧
    externalReadout (1, 0) = 0 ∧ externalReadout (0, 1) = 1 := by
  norm_num [spectralData, externalReadout, internalOp]

theorem spectral_data_do_not_determine_external_readout :
    ¬ Determines spectralData externalReadout := by
  intro h
  have := h (x := (1, 0)) (y := (0, 1)) (by rfl)
  norm_num [externalReadout, internalOp] at this

/-- Two raw connected two-point sequences differing only by their amplitude. -/
noncomputable def corrA (n : ℕ) : ℝ := 2 * (1 / 2 : ℝ) ^ n

noncomputable def corrB (n : ℕ) : ℝ := 4 * (1 / 2 : ℝ) ^ n

noncomputable def connectedNormalized (C : ℕ → ℝ) (n : ℕ) : ℝ := C n / C 0

noncomputable def effectiveMass (C : ℕ → ℝ) (n : ℕ) : ℝ := Real.log (C n / C (n + 1))

theorem raw_two_point_values_separated : corrA 0 ≠ corrB 0 := by
  unfold corrA corrB; norm_num;

theorem normalized_ratios_both_half :
    connectedNormalized corrA 1 = 1 / 2 ∧
    connectedNormalized corrB 1 = 1 / 2 := by
  unfold connectedNormalized corrA corrB; norm_num;

theorem normalized_readouts_all_equal (n : ℕ) :
    connectedNormalized corrA n = connectedNormalized corrB n := by
  unfold connectedNormalized corrA corrB
  ring_nf

theorem effective_masses_all_equal (n : ℕ) :
    effectiveMass corrA n = effectiveMass corrB n := by
  unfold effectiveMass corrA corrB
  ring_nf

theorem effective_masses_eq_log_two (n : ℕ) :
    effectiveMass corrA n = Real.log 2 ∧ effectiveMass corrB n = Real.log 2 := by
  unfold effectiveMass corrA corrB;
  ring_nf; norm_num;
  norm_num [ ← mul_pow ]

/-- A standard amplitude-sensitive integrated readout still distinguishes them. -/
theorem finite_susceptibility_separated :
    corrA 0 + corrA 1 = 3 ∧ corrB 0 + corrB 1 = 6 := by
  norm_num [corrA, corrB]

/-- Rectangular block-diagonal assembly between two product decompositions. -/
def blockDiagonal {α β γ δ : Type*} (f : α → γ) (g : β → δ)
    (x : α × β) : γ × δ := (f x.1, g x.2)

theorem block_diagonal_pointwise_nonaccumulation
    {α β γ δ : Type*}
    [SeminormedAddCommGroup α] [SeminormedAddCommGroup β]
    [SeminormedAddCommGroup γ] [SeminormedAddCommGroup δ]
    (f : α → γ) (g : β → δ) (A B : ℝ)
    (hf : ∀ x, ‖f x‖ ≤ A * ‖x‖) (hg : ∀ y, ‖g y‖ ≤ B * ‖y‖)
    (x : α × β) :
    ‖blockDiagonal f g x‖ ≤ max A B * ‖x‖ := by
  -- By definition of maxSpaceNorm, we have maxSpaceNorm (blockDiagonal f g x) = max ‖f x.1‖ ‖g x.2‖.
  simp [blockDiagonal, Prod.norm_def];
  refine' ⟨ le_trans ( hf _ ) _, le_trans ( hg _ ) _ ⟩;
  · by_cases hx : ‖x.1‖ = 0;
    · simp +decide [ hx ];
      contrapose! hg;
      exact ⟨ x.2, lt_of_lt_of_le ( lt_of_le_of_lt ( mul_le_mul_of_nonneg_right ( le_max_right _ _ ) ( norm_nonneg _ ) ) hg ) ( norm_nonneg _ ) ⟩;
    · exact mul_le_mul ( le_max_left _ _ ) ( le_max_left _ _ ) ( norm_nonneg _ ) ( by exact le_max_of_le_left ( show 0 ≤ A by have := hf x.1; nlinarith [ norm_nonneg ( f x.1 ), norm_nonneg x.1, show 0 < ‖x.1‖ from lt_of_le_of_ne ( norm_nonneg _ ) ( Ne.symm hx ) ] ) );
  · by_cases hB : B ≤ 0;
    · by_cases hB : B = 0;
      · simp +decide [ hB ];
        positivity;
      · contrapose! hg;
        -- Since $B < 0$, we can choose $y$ such that $\|y\| > 0$.
        obtain ⟨y, hy⟩ : ∃ y : β, ‖y‖ > 0 := by
          by_cases hβ : ∀ y : β, ‖y‖ = 0;
          · simp_all +decide [ max_def ];
            split_ifs at hg <;> nlinarith [ norm_nonneg x.1, show 0 ≤ A by exact le_of_not_gt fun h => by nlinarith [ norm_nonneg x.1, hf x.1, show 0 ≤ ‖f x.1‖ by positivity ] ];
          · exact by push_neg at hβ; exact hβ.imp fun x hx => lt_of_le_of_ne ( norm_nonneg x ) ( Ne.symm hx ) ;
        exact ⟨ y, lt_of_lt_of_le ( mul_neg_of_neg_of_pos ( lt_of_le_of_ne ‹_› hB ) hy ) ( norm_nonneg _ ) ⟩;
    · exact mul_le_mul ( le_max_right _ _ ) ( le_max_right _ _ ) ( norm_nonneg _ ) ( by linarith [ le_max_left A B, le_max_right A B ] )

/-
An upper-triangular off-diagonal block can exceed the diagonal bound.
-/
theorem block_triangular_counterexample :
    let T : ℝ × ℝ → ℝ × ℝ := fun x => (x.1 + 2 * x.2, x.2)
    ‖T (0, 1)‖ = 2 ∧ ‖((0, 1) : ℝ × ℝ)‖ = 1 := by
  norm_num [ Norm.norm ]

/-
Orthogonality of ranges alone does not give a max bound: two unit orthogonal
    outputs fed by the same scalar have squared norm two.
-/
theorem orthogonal_ranges_counterexample :
    let e₀ : EuclideanSpace ℝ (Fin 2) := EuclideanSpace.single 0 1
    let e₁ : EuclideanSpace ℝ (Fin 2) := EuclideanSpace.single 1 1
    let f : ℝ → EuclideanSpace ℝ (Fin 2) := fun x => x • e₀
    let g : ℝ → EuclideanSpace ℝ (Fin 2) := fun x => x • e₁
    @inner ℝ _ _ (f 1) (g 1) = 0 ∧ ‖f 1‖ = 1 ∧ ‖g 1‖ = 1 ∧ ‖f 1 + g 1‖ ^ 2 = 2 := by
  norm_num [ EuclideanSpace.norm_eq, Fin.sum_univ_two ];
  norm_num [ EuclideanSpace.single_apply, inner ]

/-
The exact telescoping estimate, requiring no contraction hypothesis.
-/
theorem norm_pow_sub_pow_le_telescoping
    {A : Type*} [NormedRing A] (U V : A) (n : ℕ) :
    ‖U ^ n - V ^ n‖ ≤
      ∑ k ∈ Finset.range n,
        ‖U ^ (n - 1 - k)‖ * ‖U - V‖ * ‖V ^ k‖ := by
  -- Use the telescoping identity
  have h_telescope : U ^ n - V ^ n = ∑ k ∈ Finset.range n, U ^ (n - 1 - k) * (U - V) * V ^ k := by
    induction' n with n ih;
    · simp +decide;
    · rw [ Finset.sum_range_succ' ];
      convert congr_arg ( fun x => x * V + U ^ n * ( U - V ) ) ih using 1 <;> simp +decide [ pow_succ, mul_assoc, sub_mul, mul_sub ] ; abel_nf;
      simp +decide only [add_comm, Nat.sub_sub, Finset.sum_mul _ _ _, mul_assoc];
  rw [h_telescope];
  exact le_trans ( norm_sum_le _ _ ) ( Finset.sum_le_sum fun i hi => norm_mul_le _ _ |> le_trans <| mul_le_mul_of_nonneg_right ( norm_mul_le _ _ ) <| norm_nonneg _ )

/-
Separate power bounds give the sharper asymmetric product estimate.
-/
theorem norm_pow_sub_pow_le_of_separate_power_bounds
    {A : Type*} [NormedRing A] (U V : A) (n : ℕ) (CU CV : ℝ)
    (hCU : 0 ≤ CU)
    (hU : ∀ k : ℕ, ‖U ^ k‖ ≤ CU) (hV : ∀ k : ℕ, ‖V ^ k‖ ≤ CV) :
    ‖U ^ n - V ^ n‖ ≤ CU * CV * n * ‖U - V‖ := by
  convert norm_pow_sub_pow_le_telescoping U V n |> le_trans <| Finset.sum_le_sum fun i _ => ?_ using 1;
  rotate_left;
  use fun i => CU * ‖U - V‖ * CV;
  · gcongr <;> aesop;
  · simp +decide [mul_assoc, mul_comm, mul_left_comm]

/-
Uniformly power-bounded elements satisfy the proposed `C² n` estimate.
-/
theorem norm_pow_sub_pow_le_of_power_bounded
    {A : Type*} [NormedRing A] (U V : A) (n : ℕ) (C : ℝ)
    (hC : 0 ≤ C) (hU : ∀ k : ℕ, ‖U ^ k‖ ≤ C) (hV : ∀ k : ℕ, ‖V ^ k‖ ≤ C) :
    ‖U ^ n - V ^ n‖ ≤ C ^ 2 * n * ‖U - V‖ := by
  refine' le_trans ( norm_pow_sub_pow_le_telescoping U V n ) _;
  refine' le_trans ( Finset.sum_le_sum fun i hi => mul_le_mul ( mul_le_mul ( hU _ ) le_rfl ( norm_nonneg _ ) ( by positivity ) ) ( hV _ ) ( norm_nonneg _ ) ( by positivity ) ) _ ; norm_num ; ring_nf ; norm_num;

/-
Contractions are the `C = 1` specialization.
-/
theorem norm_pow_sub_pow_le_of_contractions
    {A : Type*} [NormedRing A] (U V : A) (n : ℕ)
    (hU : ‖U‖ ≤ 1) (hV : ‖V‖ ≤ 1) :
    ‖U ^ n - V ^ n‖ ≤ n * ‖U - V‖ := by
  -- For n=0, both sides of the inequality are zero, so it holds trivially.
  by_cases hn : n = 0;
  · simp +decide [ hn ];
  · induction' n with n ih;
    · contradiction;
    · by_cases hn : n = 0;
      · aesop;
      · have h_expand : U ^ (n + 1) - V ^ (n + 1) = U ^ n * (U - V) + (U ^ n - V ^ n) * V := by
          simp +decide [ pow_succ, mul_sub, sub_mul ];
        have h_bound : ‖U ^ n * (U - V)‖ ≤ ‖U - V‖ ∧ ‖(U ^ n - V ^ n) * V‖ ≤ n * ‖U - V‖ := by
          exact ⟨ le_trans ( norm_mul_le _ _ ) ( mul_le_of_le_one_left ( norm_nonneg _ ) ( by exact le_trans ( norm_pow_le' _ ( by positivity ) ) ( pow_le_one₀ ( norm_nonneg _ ) hU ) ) ), le_trans ( norm_mul_le _ _ ) ( mul_le_of_le_one_right ( norm_nonneg _ ) hV |> le_trans <| ih hn ) ⟩;
        exact h_expand.symm ▸ le_trans ( norm_add_le _ _ ) ( by push_cast; linarith )

/-
With no size hypothesis, boundedness gives a geometrically degraded estimate.
-/
theorem norm_pow_sub_pow_le_general
    {A : Type*} [NormedRing A] (U V : A) (n : ℕ) :
    ‖U ^ n - V ^ n‖ ≤
      n * (max ‖U‖ ‖V‖) ^ (n - 1) * ‖U - V‖ := by
  rcases n with ( _ | n ) <;> norm_cast <;> simp_all +decide;
  induction' n with n ih <;> simp_all +decide [ pow_succ, mul_assoc ];
  -- Apply the triangle inequality to split the norm into two parts.
  have h_triangle : ‖U ^ (n + 1) * U - V ^ (n + 1) * V‖ ≤ ‖U ^ (n + 1)‖ * ‖U - V‖ + ‖U ^ (n + 1) - V ^ (n + 1)‖ * ‖V‖ := by
    have h_triangle : ‖U ^ (n + 1) * U - V ^ (n + 1) * V‖ ≤ ‖U ^ (n + 1) * (U - V)‖ + ‖(U ^ (n + 1) - V ^ (n + 1)) * V‖ := by
      convert norm_add_le ( U ^ ( n + 1 ) * ( U - V ) ) ( ( U ^ ( n + 1 ) - V ^ ( n + 1 ) ) * V ) using 2 ; simp +decide [ mul_sub, sub_mul ];
    exact h_triangle.trans ( add_le_add ( norm_mul_le _ _ ) ( norm_mul_le _ _ ) );
  -- Apply the induction hypothesis to bound ‖U ^ (n + 1)‖.
  have h_ind_U : ‖U ^ (n + 1)‖ ≤ max ‖U‖ ‖V‖ ^ (n + 1) := by
    exact le_trans ( norm_pow_le' _ ( by norm_num ) ) ( pow_le_pow_left₀ ( norm_nonneg _ ) ( le_max_left _ _ ) _ );
  simp_all +decide [ pow_succ, mul_assoc ];
  refine' le_trans h_triangle ( le_trans ( add_le_add ( mul_le_mul_of_nonneg_right h_ind_U ( norm_nonneg _ ) ) ( mul_le_mul_of_nonneg_left ( show ‖V‖ ≤ max ‖U‖ ‖V‖ by exact le_max_right _ _ ) ( norm_nonneg _ ) ) ) _ );
  nlinarith [ show 0 ≤ max ‖U‖ ‖V‖ ^ n * max ‖U‖ ‖V‖ by positivity, show 0 ≤ max ‖U‖ ‖V‖ ^ n * ‖U - V‖ by positivity, show 0 ≤ max ‖U‖ ‖V‖ * ‖U - V‖ by positivity, show 0 ≤ max ‖U‖ ‖V‖ ^ n by positivity, show 0 ≤ max ‖U‖ ‖V‖ by positivity, show 0 ≤ ‖U - V‖ by positivity ]

/-- The corresponding sharp general power estimate; contraction gives factor one. -/
theorem norm_power_general
    {A : Type*} [NormedRing A] [NormOneClass A] (U : A) (n : ℕ) :
    ‖U ^ n‖ ≤ ‖U‖ ^ n := by
  exact norm_pow_le U n

theorem norm_power_of_contraction
    {A : Type*} [NormedRing A] [NormOneClass A] (U : A) (n : ℕ) (hU : ‖U‖ ≤ 1) :
    ‖U ^ n‖ ≤ 1 := by
  have h_le_one : ∀ n : ℕ, ‖U ^ n‖ ≤ ‖U‖ ^ n := by
    exact fun n => norm_pow_le U n;
  exact le_trans ( h_le_one n ) ( pow_le_one₀ ( norm_nonneg U ) hU )

/-
Scalar multiplication by two shows that the unit bound cannot survive after
    dropping the contraction hypothesis, while the geometric factor is attained.
-/
theorem contraction_threshold_witness :
    ‖(2 : ℝ)‖ > 1 ∧ ‖(2 : ℝ) ^ 3‖ = ‖(2 : ℝ)‖ ^ 3 ∧ ‖(2 : ℝ) ^ 3‖ = 8 := by
  norm_num [ Norm.norm ]

end CorrectedReadingsAudit
