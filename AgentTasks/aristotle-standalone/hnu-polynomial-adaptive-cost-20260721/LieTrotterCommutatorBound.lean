import Mathlib

/-!
# Sharp commutator Lie-Trotter bound (Opus, verified Aristotle 5719fc71)

SUPERSEDES the generous constant in `TwoFactorExpBridge`. That earlier brick bounded
the two-factor defect by 8(1+E)^2 exp(2E) E^2 eps^2 with E = ||A||+||B||, which I
flagged in its own docstring as explicit but NOT sharp - concretely, it stays
POSITIVE even for commuting generators, where the true defect is zero. This module
fixes that:

  ||exp(eps.A) exp(eps.B) - exp(eps.(A+B))||
      <= (eps^2 / 2) * ||A*B - B*A|| * exp(eps * (||A|| + ||B||))   for 0 <= eps.

The right-hand side carries the COMMUTATOR, so it genuinely reproduces 0 in the
commuting case; exact equality exp(eps.A) exp(eps.B) = exp(eps.(A+B)) for commuting
A,B is proved separately for every real eps, with a zero-norm sanity corollary.
Also included: the Banach-algebra exponential norm estimate, the integral commutator
identity, and variation of constants.

SCOPE (refined by audit wave 2, `703405f6`): the RHS vanishes exactly when eps = 0 OR
the commutator is zero - so 'zero for commuting generators' is a correct ONE-WAY
reading, and an 'exactly when commuting' gloss would overclaim. The `0 <= eps`
hypothesis is NOT load-bearing for the quadratic RHS (which is invariant under
eps -> -eps); it is needed only for the exponential factor as written.
Prefer this bound over TwoFactorExpBridge for MC3 wherever the commutator is small.
Namespace kept as the prover's LieTrotter. Provenance: verified at pin from task
7d4e45ff. Standard three. Claim grade M, [comp]. -/

open scoped BigOperators Real Nat Classical Pointwise
open scoped Matrix.Norms.L2Operator

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128
set_option relaxedAutoImplicit false
set_option autoImplicit false
set_option grind.warning false

namespace LieTrotter

abbrev M4 := Matrix (Fin 4) (Fin 4) ℂ

/-
Commuting generators have exactly zero two-factor Lie--Trotter defect.
-/
theorem exp_mul_exp_eq_exp_add_of_mul_eq_mul
    (A B : M4) (eps : ℝ) (hcomm : A * B = B * A) :
    NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) =
      NormedSpace.exp (eps • (A + B)) := by
  -- By the properties of the exponential function and the commutativity of $A$ and $B$, we have:
  have h_exp : NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) = NormedSpace.exp (eps • A + eps • B) := by
    convert ( NormedSpace.exp_add_of_commute _ ) |> Eq.symm using 1;
    · exact NormedAlgebra.restrictScalars ℚ ℂ _;
    · infer_instance;
    · simp_all +decide [ Commute, mul_assoc ];
      simp +decide [ SemiconjBy, hcomm ];
  rw [ h_exp, smul_add ]

/-
The Banach-algebra exponential is bounded by the scalar exponential of the norm.
-/
lemma norm_exp_le_exp_norm (X : M4) :
    ‖NormedSpace.exp X‖ ≤ Real.exp ‖X‖ := by
  rw [ Real.exp_eq_exp_ℝ ];
  -- Apply the triangle inequality to the series.
  have h_triangle : ‖∑' n : ℕ, (1 / (n ! : ℂ)) • X ^ n‖ ≤ ∑' n : ℕ, ‖(1 / (n ! : ℂ)) • X ^ n‖ := by
    convert norm_tsum_le_tsum_norm _ ; norm_num;
    -- We'll use the fact that |X^n| ≤ |X|^n for any matrix X.
    have h_norm_pow : ∀ n : ℕ, ‖X ^ n‖ ≤ ‖X‖ ^ n := by
      intro n
      exact norm_pow_le X n
    norm_num [ norm_smul ];
    exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow n ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using Real.summable_pow_div_factorial ‖X‖ );
  convert h_triangle.trans _ using 1;
  · norm_num [ NormedSpace.exp_eq_tsum ];
    grind +suggestions;
  · rw [ NormedSpace.exp_eq_tsum_div ];
    refine' Summable.tsum_le_tsum _ _ _;
    · intro n; rw [ norm_smul, norm_div ] ; norm_num ; ring_nf;
      gcongr;
      induction' n with n ih <;> simp_all +decide [ pow_succ' ];
      exact le_trans ( norm_mul_le _ _ ) ( mul_le_mul_of_nonneg_left ih ( norm_nonneg _ ) );
    · -- We'll use the fact that |X^n| ≤ |X|^n for any matrix X and natural number n.
      have h_norm_pow : ∀ n : ℕ, ‖X ^ n‖ ≤ ‖X‖ ^ n := by
        intro n;
        induction' n with n ih;
        · norm_num [ Norm.norm ];
        · simpa only [ pow_succ' ] using le_trans ( norm_mul_le _ _ ) ( mul_le_mul_of_nonneg_left ih ( norm_nonneg _ ) );
      simp_all +decide [ norm_smul ];
      exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow n ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using Real.summable_pow_div_factorial ‖X‖ );
    · exact Real.summable_pow_div_factorial _

/-
Integral commutator identity used in the sharp Lie--Trotter estimate.
-/
lemma exp_mul_sub_mul_exp_eq_integral_commutator
    (A B : M4) (s : ℝ) :
    NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A) =
      ∫ r in (0 : ℝ)..s,
        NormedSpace.exp ((s - r) • A) * (A * B - B * A) *
          NormedSpace.exp (r • A) := by
  have h_deriv : ∀ r : ℝ, HasDerivAt (fun r => NormedSpace.exp ((s - r) • A) * B * NormedSpace.exp (r • A)) (- NormedSpace.exp ((s - r) • A) * (A * B - B * A) * NormedSpace.exp (r • A)) r := by
    intro r
    have h_deriv : HasDerivAt (fun r => NormedSpace.exp ((s - r) • A)) (-NormedSpace.exp ((s - r) • A) * A) r := by
      have h_deriv : HasDerivAt (fun r => NormedSpace.exp ((s - r) • A)) (-(NormedSpace.exp ((s - r) • A)) * A) r := by
        have h_chain : HasDerivAt (fun r => s - r) (-1) r := by
          exact hasDerivAt_id r |> HasDerivAt.const_sub s
        have h_chain : HasDerivAt (fun r => NormedSpace.exp ((s - r) • A)) (-(NormedSpace.exp ((s - r) • A)) * A) r := by
          have h_chain : HasDerivAt (fun r => NormedSpace.exp (r • A)) (NormedSpace.exp ((s - r) • A) * A) (s - r) := by
            exact hasDerivAt_exp_smul_const A (s - r)
          rw [ hasDerivAt_iff_tendsto_slope_zero ] at *;
          convert h_chain.neg.comp ( show Filter.Tendsto ( fun t : ℝ => -t ) ( nhdsWithin 0 { 0 } ᶜ ) ( nhdsWithin 0 { 0 } ᶜ ) from Filter.Tendsto.inf ( Continuous.tendsto' ( by continuity ) _ _ <| by norm_num ) <| by norm_num ) using 2 ; norm_num ; ring;
          norm_num [ neg_mul ];
        exact h_chain;
      exact h_deriv;
    have h_deriv2 : HasDerivAt (fun r => NormedSpace.exp (r • A)) (A * NormedSpace.exp (r • A)) r := by
      convert ( hasDerivAt_exp_smul_const' A r ) using 1;
    convert HasDerivAt.mul ( HasDerivAt.mul h_deriv ( hasDerivAt_const _ _ ) ) h_deriv2 using 1 ; norm_num ; abel_nf;
    grind;
  rw [ intervalIntegral.integral_deriv_eq_sub' ];
  case f => exact fun r => -NormedSpace.exp ( ( s - r ) • A ) * B * NormedSpace.exp ( r • A );
  · norm_num [ NormedSpace.exp_zero ] ; abel_nf;
  · ext r; specialize h_deriv r; have := h_deriv.deriv; aesop;
  · exact fun r hr => by simpa only [ neg_mul ] using DifferentiableAt.neg ( h_deriv r |> HasDerivAt.differentiableAt ) ;
  · refine' Continuous.continuousOn _;
    -- The exponential function is continuous, and the product of continuous functions is continuous.
    have h_exp_cont : Continuous (fun r : ℝ => NormedSpace.exp (r • A)) := by
      exact continuous_iff_continuousAt.mpr fun x => by simpa using HasDerivAt.continuousAt ( hasDerivAt_exp_smul_const' A x ) ;
    exact Continuous.mul ( Continuous.mul ( h_exp_cont.comp ( continuous_const.sub continuous_id' ) ) continuous_const ) h_exp_cont

/-
Norm estimate for the commutator of an exponential.
-/
lemma norm_exp_mul_sub_mul_exp_le
    (A B : M4) (s : ℝ) (hs : 0 ≤ s) :
    ‖NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A)‖ ≤
      s * ‖A * B - B * A‖ * Real.exp (s * ‖A‖) := by
  rw [ exp_mul_sub_mul_exp_eq_integral_commutator A B s ];
  refine' le_trans ( intervalIntegral.norm_integral_le_of_norm_le_const _ ) _;
  exact ‖A * B - B * A‖ * Real.exp ( s * ‖A‖ );
  · intro x hx; refine' le_trans ( norm_mul_le _ _ ) _ ; refine' le_trans ( mul_le_mul_of_nonneg_right ( norm_mul_le _ _ ) _ ) _ <;> norm_num [ Real.exp_nonneg ];
    -- Apply the norm_exp_le_exp_norm lemma to each exponential term.
    have h_exp_norm : ‖NormedSpace.exp ((s - x) • A)‖ ≤ Real.exp ((s - x) * ‖A‖) ∧ ‖NormedSpace.exp (x • A)‖ ≤ Real.exp (x * ‖A‖) := by
      exact ⟨ by simpa [ norm_smul, abs_of_nonneg ( show 0 ≤ s - x by cases Set.mem_uIoc.mp hx <;> linarith ) ] using norm_exp_le_exp_norm ( ( s - x ) • A ), by simpa [ norm_smul, abs_of_nonneg ( show 0 ≤ x by cases Set.mem_uIoc.mp hx <;> linarith ) ] using norm_exp_le_exp_norm ( x • A ) ⟩;
    convert mul_le_mul_of_nonneg_left ( mul_le_mul h_exp_norm.1 h_exp_norm.2 ( by positivity ) ( by positivity ) ) ( by positivity : 0 ≤ ‖A * B - B * A‖ ) using 1 ; ring;
    rw [ ← Real.exp_add ] ; ring;
  · rw [ abs_of_nonneg ] <;> linarith

/-- Variation-of-constants identity for the two-factor defect. -/
lemma exp_mul_exp_sub_exp_add_eq_integral
    (A B : M4) (t : ℝ) :
    NormedSpace.exp (t • A) * NormedSpace.exp (t • B) -
        NormedSpace.exp (t • (A + B)) =
      ∫ s in (0 : ℝ)..t,
        NormedSpace.exp ((t - s) • (A + B)) *
          (NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A)) *
          NormedSpace.exp (s • B) := by
  -- By the fundamental theorem of calculus, we can write
  have h_ftc : ∀ a b, ∫ s in a..b, deriv (fun s => (NormedSpace.exp ((b - s) • (A + B))) * (NormedSpace.exp (s • A) * NormedSpace.exp (s • B))) s = (NormedSpace.exp ((b - b) • (A + B))) * (NormedSpace.exp (b • A) * NormedSpace.exp (b • B)) - (NormedSpace.exp ((b - a) • (A + B))) * (NormedSpace.exp (a • A) * NormedSpace.exp (a • B)) := by
    intro a b;
    rw [ intervalIntegral.integral_deriv_eq_sub ];
    · have h_diff : ∀ (X : M4), Differentiable ℝ (fun s : ℝ => NormedSpace.exp (s • X)) := by
        intro X
        have h_diff : Differentiable ℝ (fun s : ℝ => NormedSpace.exp (s • X)) := by
          have h_exp_diff : Differentiable ℝ (fun s : M4 => NormedSpace.exp s) := by
            intro s; exact (by
            have h_exp_diff : AnalyticAt ℝ (fun s : M4 => NormedSpace.exp s) s := by
              apply_rules [ NormedSpace.exp_analytic ];
            exact h_exp_diff.differentiableAt);
          exact h_exp_diff.comp ( differentiable_id.smul_const X )
        exact h_diff;
      have h_diff : Differentiable ℝ (fun s : ℝ => NormedSpace.exp ((b - s) • (A + B))) := by
        convert h_diff ( A + B ) |> Differentiable.comp <| differentiable_id.const_sub b using 1;
      fun_prop;
    · apply_rules [ Continuous.intervalIntegrable ];
      apply_rules [ ContDiff.continuous_deriv ];
      apply_rules [ ContDiff.mul, ContDiff.smul, contDiff_const, contDiff_id ];
      any_goals exact le_rfl;
      · have h_exp_cont_diff : ContDiff ℝ 1 (fun x : M4 => NormedSpace.exp x) := by
          have h_exp_cont_diff : AnalyticOn ℝ (fun x : M4 => NormedSpace.exp x) Set.univ := by
            apply_rules [ ContDiffOn.analyticOn, NormedSpace.exp ];
            refine' ContDiffOn.congr _ _;
            exact fun x => ( NormedSpace.exp x );
            · refine' ContDiffOn.congr _ _;
              exact fun x => ( NormedSpace.exp x );
              · intro x hx;
                have h_exp_cont_diff : AnalyticAt ℝ (fun x : M4 => NormedSpace.exp x) x := by
                  apply_rules [ NormedSpace.exp_analytic ];
                exact h_exp_cont_diff.contDiffAt.contDiffWithinAt;
              · exact fun _ _ => rfl;
            · aesop;
          simp +zetaDelta at *;
          exact h_exp_cont_diff.contDiff;
        exact h_exp_cont_diff.comp ( ContDiff.smul ( contDiff_const.sub contDiff_id ) contDiff_const );
      · have h_exp_cont_diff : ContDiff ℝ 1 (fun x : M4 => NormedSpace.exp x) := by
          have h_exp_cont_diff : AnalyticOn ℝ (fun x : M4 => NormedSpace.exp x) Set.univ := by
            apply_rules [ ContDiffOn.analyticOn, NormedSpace.exp ];
            refine' ContDiffOn.congr _ _;
            exact fun x => ( NormedSpace.exp x );
            · refine' ContDiffOn.congr _ _;
              exact fun x => ( NormedSpace.exp x );
              · intro x hx;
                have h_exp_cont_diff : AnalyticAt ℝ (fun x : M4 => NormedSpace.exp x) x := by
                  apply_rules [ NormedSpace.exp_analytic ];
                exact h_exp_cont_diff.contDiffAt.contDiffWithinAt;
              · exact fun _ _ => rfl;
            · aesop;
          simp +zetaDelta at *;
          exact h_exp_cont_diff.contDiff;
        exact h_exp_cont_diff.comp ( contDiff_id.smul contDiff_const );
      · have h_exp_cont_diff : ContDiff ℝ 1 (fun x : M4 => NormedSpace.exp x) := by
          have h_exp_cont_diff : AnalyticOn ℝ (fun x : M4 => NormedSpace.exp x) Set.univ := by
            apply_rules [ ContDiffOn.analyticOn, NormedSpace.exp ];
            refine' ContDiffOn.congr _ _;
            exact fun x => ( NormedSpace.exp x );
            · refine' ContDiffOn.congr _ _;
              exact fun x => ( NormedSpace.exp x );
              · intro x hx;
                have h_exp_cont_diff : AnalyticAt ℝ (fun x : M4 => NormedSpace.exp x) x := by
                  apply_rules [ NormedSpace.exp_analytic ];
                exact h_exp_cont_diff.contDiffAt.contDiffWithinAt;
              · exact fun _ _ => rfl;
            · aesop;
          simp +zetaDelta at *;
          exact h_exp_cont_diff.contDiff;
        exact h_exp_cont_diff.comp ( contDiff_id.smul contDiff_const );
  have h_deriv : ∀ s, deriv (fun s => (NormedSpace.exp ((t - s) • (A + B))) * (NormedSpace.exp (s • A) * NormedSpace.exp (s • B))) s = -(NormedSpace.exp ((t - s) • (A + B))) * (A + B) * (NormedSpace.exp (s • A) * NormedSpace.exp (s • B)) + (NormedSpace.exp ((t - s) • (A + B))) * (A * NormedSpace.exp (s • A) * NormedSpace.exp (s • B) + NormedSpace.exp (s • A) * B * NormedSpace.exp (s • B)) := by
    intro s;
    apply_rules [ HasDerivAt.deriv ];
    have h_deriv : HasDerivAt (fun s => NormedSpace.exp ((t - s) • (A + B))) (-(A + B) * NormedSpace.exp ((t - s) • (A + B))) s ∧ HasDerivAt (fun s => NormedSpace.exp (s • A)) (A * NormedSpace.exp (s • A)) s ∧ HasDerivAt (fun s => NormedSpace.exp (s • B)) (B * NormedSpace.exp (s • B)) s := by
      refine' ⟨ _, _, _ ⟩;
      · have h_deriv : HasDerivAt (fun s => NormedSpace.exp (s • (A + B))) ((A + B) * NormedSpace.exp ((t - s) • (A + B))) (t - s) := by
          convert hasDerivAt_exp_smul_const' ( A + B ) ( t - s ) using 1;
        rw [ hasDerivAt_iff_tendsto_slope_zero ] at *;
        convert h_deriv.neg.comp ( show Filter.Tendsto ( fun x : ℝ => -x ) ( nhdsWithin 0 { 0 } ᶜ ) ( nhdsWithin 0 { 0 } ᶜ ) from Filter.Tendsto.inf ( Continuous.tendsto' ( by continuity ) _ _ <| by norm_num ) <| by norm_num ) using 2 ; norm_num ; ring;
        grind;
      · convert ( hasDerivAt_exp_smul_const' _ _ ) using 1;
        infer_instance;
      · exact hasDerivAt_exp_smul_const' B s
    convert HasDerivAt.mul h_deriv.1 ( HasDerivAt.mul h_deriv.2.1 h_deriv.2.2 ) using 1 ; norm_num ; ring;
    simp +decide [ mul_add, add_mul, mul_assoc, add_assoc, add_left_comm, add_comm ];
    have h_comm : Commute (A + B) (NormedSpace.exp ((t - s) • A + (t - s) • B)) := by
      have h_comm : Commute (A + B) ((t - s) • A + (t - s) • B) := by
        simp +decide [ Commute, mul_add, add_mul, mul_assoc, mul_left_comm, smul_smul ];
        simp +decide [ SemiconjBy, mul_add, add_mul, mul_assoc, mul_left_comm, smul_smul ];
      grind +suggestions;
    simp_all +decide [ ← mul_assoc, Commute ];
    simp_all +decide [ SemiconjBy, mul_assoc ];
    simp_all +decide [ mul_add, add_mul, mul_assoc, add_assoc, add_left_comm, add_comm ];
    simp_all +decide [ ← mul_assoc, ← eq_sub_iff_add_eq ];
    grind;
  simp_all +decide [ mul_assoc, mul_sub, sub_mul ];
  convert h_ftc 0 t using 1;
  · rw [ h_ftc ] ; norm_num;
  · convert h_ftc 0 t using 1;
    grind

/-
The sharp classical commutator bound for the two-factor Lie--Trotter defect.
The assumption `0 ≤ eps` is necessary for the requested exponent with `eps` rather
than `|eps|`; without it, the displayed estimate is false in general.
-/
theorem norm_exp_mul_exp_sub_exp_add_le
    (A B : M4) (eps : ℝ) (heps : 0 ≤ eps) :
    ‖NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) -
        NormedSpace.exp (eps • (A + B))‖ ≤
      (eps ^ 2 / 2) * ‖A * B - B * A‖ *
        Real.exp (eps * (‖A‖ + ‖B‖)) := by
  -- Apply the variation of constants formula to rewrite the defect.
  have h_defect : NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) - NormedSpace.exp (eps • (A + B)) = ∫ s in (0:ℝ)..eps, NormedSpace.exp ((eps - s) • (A + B)) * (NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A)) * NormedSpace.exp (s • B) := by
    convert exp_mul_exp_sub_exp_add_eq_integral A B eps using 1;
  -- Apply the integral bound to the integrand.
  have h_integral_bound : ∀ s ∈ Set.Icc (0 : ℝ) eps, ‖NormedSpace.exp ((eps - s) • (A + B)) * (NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A)) * NormedSpace.exp (s • B)‖ ≤ s * ‖A * B - B * A‖ * Real.exp (eps * (‖A‖ + ‖B‖)) := by
    intros s hs
    have h_norm : ‖NormedSpace.exp ((eps - s) • (A + B))‖ ≤ Real.exp ((eps - s) * (‖A‖ + ‖B‖)) := by
      refine' le_trans ( norm_exp_le_exp_norm _ ) _;
      exact Real.exp_le_exp.mpr ( by rw [ norm_smul, Real.norm_of_nonneg ( sub_nonneg.mpr hs.2 ) ] ; exact mul_le_mul_of_nonneg_left ( norm_add_le _ _ ) ( sub_nonneg.mpr hs.2 ) )
    have h_norm2 : ‖NormedSpace.exp (s • B)‖ ≤ Real.exp (s * ‖B‖) := by
      convert norm_exp_le_exp_norm ( s • B ) using 1 ; norm_num [ norm_smul, abs_of_nonneg hs.1 ]
    have h_norm3 : ‖NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A)‖ ≤ s * ‖A * B - B * A‖ * Real.exp (s * ‖A‖) := by
      apply norm_exp_mul_sub_mul_exp_le A B s hs.left;
    refine' le_trans ( norm_mul_le _ _ ) _;
    refine' le_trans ( mul_le_mul ( norm_mul_le _ _ ) h_norm2 ( by positivity ) ( by positivity ) ) _;
    refine le_trans ( mul_le_mul_of_nonneg_right ( mul_le_mul h_norm h_norm3 ( by exact norm_nonneg _ ) ( by positivity ) ) ( by positivity ) ) ?_;
    norm_num [ mul_assoc, mul_left_comm, ← Real.exp_add ] ; ring_nf ; norm_num;
  rw [ h_defect, intervalIntegral.integral_of_le heps ];
  refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm _ ) ( le_trans ( MeasureTheory.integral_mono_of_nonneg _ _ _ ) _ );
  refine' fun s => s * ‖A * B - B * A‖ * Real.exp ( eps * ( ‖A‖ + ‖B‖ ) );
  · exact Filter.Eventually.of_forall fun x => norm_nonneg _;
  · exact Continuous.integrableOn_Ioc ( by continuity );
  · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Ioc ] with s hs using h_integral_bound s <| Set.Ioc_subset_Icc_self hs;
  · rw [ ← intervalIntegral.integral_of_le heps ] ; norm_num

/-
The sharp bound itself specializes to zero for commuting generators.
-/
theorem norm_lieTrotter_defect_le_zero_of_mul_eq_mul
    (A B : M4) (eps : ℝ) (hcomm : A * B = B * A) :
    ‖NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) -
        NormedSpace.exp (eps • (A + B))‖ ≤ 0 := by
  rw [ exp_mul_exp_eq_exp_add_of_mul_eq_mul A B eps hcomm ] ; norm_num

end LieTrotter
