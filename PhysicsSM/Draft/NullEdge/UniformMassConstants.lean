import Mathlib

/-!
# MC5 uniform-in-mass constants (Opus, verified Aristotle b1d8c63d)

Abstract Mathlib-only brick discharging MC5 hidden-assumption item 4 of
`AutonomousLab/work/NE-3PLUS1/OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md`.
I first judged item 4 a scoping decision rather than a lemma; it is in fact a
lemma, and this is it. Contents: uniform generator bound ||M z|| <= c0 * Mbound on
the ball ||z|| <= Mbound (with the concrete real/imaginary-linear instance
||z.re.B1 + z.im.B2|| <= (||B1||+||B2||) ||z||); uniform exponential estimate; the
EXACT norm-one result under an explicit IsHermitian hypothesis (exponent proved
skew-adjoint, exponential unitary); uniform second-order remainder; and - the
payload - a general upgrade theorem turning any pointwise estimate
error z <= F ||M z|| (F monotone) into a UNIFORM estimate on the mass ball.

So a fixed-z estimate whose constant depends only on ||M z|| upgrades to
uniform-in-z on ||z|| <= Mbound. Offered to Codex for the MC5 family theorem
(walk-agnostic; no MC file touched). Namespace kept as the prover's UniformMass.
Provenance: verified at pin from task 4b56317c. Standard three. Grade M, [comp]. -/

open scoped Matrix.Norms.L2Operator

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace UniformMass

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

/-- A termwise norm bound comparing an algebra exponential series with the real one. -/
lemma norm_expSeries_term_le {A : Type*} [NormedRing A] [NormOneClass A] [NormedAlgebra ℂ A]
    (x : A) (n : ℕ) :
    ‖(NormedSpace.expSeries ℂ A n) (fun _ => x)‖ ≤
      (NormedSpace.expSeries ℝ ℝ n) (fun _ => ‖x‖) := by
  rw [NormedSpace.expSeries_apply_eq, NormedSpace.expSeries_apply_eq]
  rw [norm_smul]
  simp only [norm_inv, Complex.norm_natCast, smul_eq_mul]
  rw [inv_mul_eq_div, inv_mul_eq_div]
  exact div_le_div_of_nonneg_right (norm_pow_le x n) (Nat.cast_nonneg _)

/-
The exponential norm estimate needed below, stated for an arbitrary complex Banach algebra.
-/
lemma norm_exp_le_exp_norm {A : Type*} [NormedRing A] [NormOneClass A] [NormedAlgebra ℂ A]
    [CompleteSpace A] (x : A) :
    ‖NormedSpace.exp x‖ ≤ Real.exp ‖x‖ := by
  have := @norm_expSeries_term_le A _ _ _;
  by_contra h_contra;
  -- Apply the contradiction assumption to find the contradiction.
  have h_contra' : Filter.Tendsto (fun n => ‖∑ i ∈ Finset.range n, (NormedSpace.expSeries ℂ A i) (fun _ => x)‖) Filter.atTop (nhds (‖NormedSpace.exp x‖)) := by
    exact Filter.Tendsto.norm ( NormedSpace.expSeries_hasSum_exp x |> HasSum.tendsto_sum_nat );
  have h_contra'' : Filter.Tendsto (fun n => ∑ i ∈ Finset.range n, (NormedSpace.expSeries ℝ ℝ i) (fun _ => ‖x‖)) Filter.atTop (nhds (Real.exp ‖x‖)) := by
    convert Real.summable_pow_div_factorial ‖x‖ |> Summable.hasSum |> HasSum.tendsto_sum_nat using 1;
    · simp +decide [ NormedSpace.expSeries ];
      exact funext fun n => Finset.sum_congr rfl fun _ _ => by ring;
    · simp +decide [ Real.exp_eq_exp_ℝ, NormedSpace.exp_eq_tsum_div ];
  exact h_contra ( le_of_tendsto_of_tendsto' h_contra' h_contra'' fun n => le_trans ( norm_sum_le _ _ ) ( Finset.sum_le_sum fun _ _ => this _ _ ) )

/-
The scalar exponential tail after the linear term has the convenient bound used here.
-/
lemma real_exp_tail_two_bound (r : ℝ) (hr : 0 ≤ r) :
    (∑' k : ℕ, r ^ (k + 2) / (k + 2).factorial) ≤ r ^ 2 * Real.exp r := by
  rw [ Real.exp_eq_exp_ℝ ];
  rw [ NormedSpace.exp_eq_tsum_div, ← tsum_mul_left ];
  refine' Summable.tsum_le_tsum _ _ _;
  · intro i; rw [ pow_add, mul_div ] ; ring_nf;
    exact mul_le_mul_of_nonneg_left ( inv_anti₀ ( by positivity ) ( mod_cast Nat.factorial_le ( by linarith ) ) ) ( by positivity );
  · exact Real.summable_pow_div_factorial _ |> Summable.comp_injective <| add_left_injective 2;
  · exact Summable.mul_left _ <| Real.summable_pow_div_factorial _

/-
Removing the constant and linear terms from the algebra exponential leaves its tail.
-/
lemma exp_sub_one_sub_eq_tail {A : Type*} [NormedRing A] [NormOneClass A]
    [NormedAlgebra ℂ A] [CompleteSpace A] (x : A) :
    NormedSpace.exp x - 1 - x =
      ∑' k : ℕ, (NormedSpace.expSeries ℂ A (k + 2)) (fun _ => x) := by
  have h_exp_sum : ∑' k : ℕ, (NormedSpace.expSeries ℂ A k) (fun _ => x) = ∑ k ∈ Finset.range 2, (NormedSpace.expSeries ℂ A k) (fun _ => x) + ∑' k : ℕ, (NormedSpace.expSeries ℂ A (k + 2)) (fun _ => x) := by
    by_cases h : Summable ( fun k : ℕ => ( NormedSpace.expSeries ℂ A k ) fun _ => x );
    · rw [ ← Summable.sum_add_tsum_nat_add ] ; tauto;
    · exact False.elim ( h ( NormedSpace.expSeries_summable x ) );
  simp_all +decide [ NormedSpace.exp, Finset.sum_range_succ ];
  convert congr_arg ( fun y => y - 1 - x ) h_exp_sum using 1;
  · convert rfl;
    convert NormedSpace.expSeries_hasSum_exp x |> HasSum.tsum_eq using 1;
    all_goals try infer_instance;
    exact Eq.symm (NormedSpace.exp_def x);
  · simp +decide [ NormedSpace.expSeries ];
    abel1

/-
A convenient (slightly non-sharp) second-order exponential remainder estimate.
-/
lemma norm_exp_sub_one_sub_le {A : Type*} [NormedRing A] [NormOneClass A]
    [NormedAlgebra ℂ A] [CompleteSpace A] (x : A) :
    ‖NormedSpace.exp x - 1 - x‖ ≤ ‖x‖ ^ 2 * Real.exp ‖x‖ := by
  rw [ exp_sub_one_sub_eq_tail ];
  -- Apply the norm_expSeries_term_le to each term in the sum.
  have h_norm_term : ∀ k : ℕ, ‖(NormedSpace.expSeries ℂ A (k + 2)) (fun _ => x)‖ ≤ (‖x‖ ^ (k + 2)) / (k + 2).factorial := by
    intro k;
    convert norm_expSeries_term_le x ( k + 2 ) using 1;
    simp +decide [ NormedSpace.expSeries ];
    ring;
  refine' le_trans ( norm_tsum_le_tsum_norm _ ) ( le_trans ( Summable.tsum_le_tsum h_norm_term _ _ ) _ );
  · exact Summable.of_nonneg_of_le ( fun k => norm_nonneg _ ) h_norm_term ( by simpa using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _ );
  · exact Summable.of_nonneg_of_le ( fun k => norm_nonneg _ ) h_norm_term ( by simpa using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _ );
  · exact Real.summable_pow_div_factorial _ |> Summable.comp_injective <| add_left_injective 2;
  · convert real_exp_tail_two_bound ‖x‖ ( norm_nonneg x ) using 1

/-
Item 1: a pointwise linear-in-mass bound becomes uniform on a norm ball.
-/
theorem uniform_generator_bound (M : ℂ → Mat4) (c0 Mbound : ℝ)
    (hM : ∀ z, ‖M z‖ ≤ c0 * ‖z‖) {z : ℂ} (hz : ‖z‖ ≤ Mbound) :
    ‖M z‖ ≤ c0 * Mbound := by
  exact le_trans ( hM z ) ( mul_le_mul_of_nonneg_left hz ( show 0 ≤ c0 by have := hM 1; norm_num at this; linarith [ norm_nonneg ( M 1 ) ] ) )

/-
The advertised concrete source of a linear-in-mass estimate.
-/
theorem real_imag_generator_bound (B1 B2 : Mat4) (z : ℂ) :
    ‖z.re • B1 + z.im • B2‖ ≤ (‖B1‖ + ‖B2‖) * ‖z‖ := by
  refine' le_trans ( norm_add_le _ _ ) _;
  norm_num [ add_mul, norm_smul ];
  nlinarith [ abs_nonneg z.re, abs_nonneg z.im, norm_nonneg B1, norm_nonneg B2, Complex.abs_re_le_norm z, Complex.abs_im_le_norm z ]

/-
Item 2: exponential bounds are uniform on the bounded mass ball.
-/
theorem uniform_exponential_bound (M : ℂ → Mat4) (c0 Mbound eps : ℝ)
    (hM : ∀ z, ‖M z‖ ≤ c0 * ‖z‖) (heps : 0 ≤ eps)
    {z : ℂ} (hz : ‖z‖ ≤ Mbound) :
    ‖NormedSpace.exp (eps • (Complex.I • M z))‖ ≤ Real.exp (eps * c0 * Mbound) := by
  refine' le_trans ( norm_exp_le_exp_norm _ ) ( Real.exp_le_exp.mpr _ );
  convert mul_le_mul_of_nonneg_left ( uniform_generator_bound M c0 Mbound hM hz ) heps using 1;
  · norm_num [ norm_smul, heps ];
  · ring

/-
Under the explicitly stated Hermitian hypothesis, the exponent is skew-adjoint,
so its exponential is unitary and has L2 operator norm exactly one.
-/
theorem hermitian_exponential_norm (M : ℂ → Mat4) (eps : ℝ) {z : ℂ}
    (hherm : (M z).IsHermitian) :
    ‖NormedSpace.exp (eps • (Complex.I • M z))‖ = 1 := by
  apply CStarRing.norm_of_mem_unitary;
  convert NormedSpace.exp_mem_unitary_of_mem_skewAdjoint _;
  · exact NormedAlgebra.restrictScalars ℚ ℂ _;
  · infer_instance;
  · infer_instance;
  · simp_all +decide [ Matrix.IsHermitian, skewAdjoint ];
    simp_all +decide [ Matrix.star_eq_conjTranspose ]

/-
Item 3: the second-order remainder is uniform on the bounded mass ball.
-/
theorem uniform_second_order_remainder (M : ℂ → Mat4) (c0 Mbound eps : ℝ)
    (hM : ∀ z, ‖M z‖ ≤ c0 * ‖z‖) (heps : 0 ≤ eps)
    {z : ℂ} (hz : ‖z‖ ≤ Mbound) :
    ‖NormedSpace.exp (eps • (Complex.I • M z)) - 1 - eps • (Complex.I • M z)‖ ≤
      (eps * c0 * Mbound) ^ 2 * Real.exp (eps * c0 * Mbound) := by
  refine' le_trans _ ( mul_le_mul_of_nonneg_right ( pow_le_pow_left₀ _ _ _ ) _ );
  rotate_left;
  exact ‖eps • Complex.I • M z‖;
  · positivity;
  · simp_all +decide [ mul_assoc, norm_smul ];
    rw [ abs_of_nonneg heps ] ; exact mul_le_mul_of_nonneg_left ( le_trans ( hM z ) ( mul_le_mul_of_nonneg_left hz ( show 0 ≤ c0 by have := hM 1; norm_num at this; linarith [ norm_nonneg ( M 1 ) ] ) ) ) heps;
  · positivity;
  · convert norm_exp_sub_one_sub_le ( eps • Complex.I • M z ) |> le_trans <| mul_le_mul_of_nonneg_left _ <| sq_nonneg _ using 1;
    norm_num [ norm_smul, mul_assoc ];
    rw [ abs_of_nonneg heps ] ; exact mul_le_mul_of_nonneg_left ( le_trans ( hM z ) ( mul_le_mul_of_nonneg_left hz ( show 0 ≤ c0 by have := hM 1; norm_num at this; linarith [ norm_nonneg ( M 1 ) ] ) ) ) heps

/-
Item 4, precise form: every monotone function of `‖M z‖` is uniformly bounded
by evaluating it at the uniform generator bound.
-/
theorem uniform_constant_of_norm (M : ℂ → Mat4) (c0 Mbound : ℝ)
    (hM : ∀ z, ‖M z‖ ≤ c0 * ‖z‖) (F : ℝ → ℝ) (hF : Monotone F)
    {z : ℂ} (hz : ‖z‖ ≤ Mbound) :
    F ‖M z‖ ≤ F (c0 * Mbound) := by
  convert hF _;
  convert uniform_generator_bound M c0 Mbound hM hz using 1

/-
Consequently, a fixed-mass estimate whose mass-dependent constant is a monotone
function of `‖M z‖` upgrades to a uniform estimate on the whole mass ball.
-/
theorem upgrade_fixed_mass_estimate (M : ℂ → Mat4) (c0 Mbound : ℝ)
    (hM : ∀ z, ‖M z‖ ≤ c0 * ‖z‖) (F : ℝ → ℝ) (hF : Monotone F)
    (error : ℂ → ℝ) (hfixed : ∀ z, error z ≤ F ‖M z‖) :
    ∀ z, ‖z‖ ≤ Mbound → error z ≤ F (c0 * Mbound) := by
  intro z hz;
  refine le_trans ( hfixed z ) ?_;
  by_cases hc0 : c0 ≥ 0;
  · exact hF ( le_trans ( hM z ) ( mul_le_mul_of_nonneg_left hz hc0 ) );
  · contrapose! hM;
    exact ⟨ 1, lt_of_lt_of_le ( mul_neg_of_neg_of_pos ( not_le.mp hc0 ) ( by norm_num ) ) ( norm_nonneg _ ) ⟩

end UniformMass
