import PhysicsSM.Draft.NullEdge.ChangingCellFourierL2
import Mathlib

/-!
# Temperate growth of the exact Dirac momentum multiplier

DRAFT HANDOFF TARGET.

The accepted continuum F1 result transports an `L2` error through inverse
Fourier transform. The next F3 construction needs the exact multiplier
`k |-> exp(-i t H(k))`, acting on the four-component Euclidean spinor, to
preserve Schwartz space. Mathlib's `SchwartzMap.bilinLeftCLM` reduces that
obligation to temperate growth of this operator-valued function.

The theorem below is intentionally isolated from the two active F2 Aristotle
jobs. It reuses the current repository definitions under a distinct local name
and does not touch their output modules.

Mathematical route: the four Dirac generators satisfy the Clifford relations,
so `H(k)^2 = (kx^2+ky^2+kz^2+m^2) • 1`.  Hence the exact flow has the closed
form

  `exp(-i t H(k)) = cosCoef(t^2 Q(k)) • 1 + sincCoef(t^2 Q(k)) • (-i t H(k))`,

where `Q(k) = kx^2+ky^2+kz^2+m^2 ≥ 0` and `cosCoef`, `sincCoef` are the entire
even/odd `cos √· / sinc √·` power series.  Because `Q ≥ 0`, only the bounded
branch of these entire functions is ever sampled, so all iterated derivatives
of the coefficient functions are bounded on the sampled ray and the resulting
matrix-valued map has genuine polynomial (in fact bounded) derivative growth,
i.e. temperate growth — never the invalid `exp(C‖k‖)` envelope.
-/

set_option synthInstance.maxHeartbeats 1000000
set_option maxHeartbeats 800000

noncomputable section

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.ChangingCellFourierTemperate

open ChangingCellFourierL2
open ChangingCellScaledLiveWalk
open Compact3Plus1DiracRate

/-- The exact momentum-space Dirac evolution as a bounded operator on the
Euclidean spinor. This local name avoids collision with the active F2 job. -/
def momMultForGrowth (m t : Real) (k : FourierMomentum3) :
    ChangingCellScaledLiveWalk.Spinor →L[Complex]
      ChangingCellScaledLiveWalk.Spinor :=
  (Matrix.toEuclideanCLM (𝕜 := Complex))
    (exactFlow (k 0) (k 1) (k 2) m t)

/-! ## Clifford square and the closed form for the exact flow -/

/-- The Dirac symbol dispersion `Q(k) = kx^2 + ky^2 + kz^2 + m^2`. -/
def Qform (kx ky kz m : ℝ) : ℝ := kx ^ 2 + ky ^ 2 + kz ^ 2 + m ^ 2

lemma Qform_nonneg (kx ky kz m : ℝ) : 0 ≤ Qform kx ky kz m := by
  unfold Qform; positivity

/-- Clifford relation: the Dirac Hamiltonian squares to the scalar dispersion. -/
theorem H_sq (kx ky kz m : ℝ) :
    H kx ky kz m * H kx ky kz m
      = ((Qform kx ky kz m : ℝ) : ℂ) • (1 : Mat4) := by
  unfold Qform
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [H, Matrix.mul_apply, Fin.sum_univ_succ, alpha1, alpha2, alpha3, beta] <;>
    apply Complex.ext <;>
    simp [Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im,
      Complex.neg_re, Complex.neg_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, ← Complex.ofReal_pow] <;> ring

/-- The entire "`cos √·`" power series: `cosCoef u = ∑ (-1)^n u^n / (2n)!`.
For `u ≥ 0` this equals `Real.cos (Real.sqrt u)`. -/
def cosCoef (u : ℝ) : ℝ := ∑' n : ℕ, (-1 : ℝ) ^ n * u ^ n / (Nat.factorial (2 * n))

/-- The entire "`sinc √·`" power series: `sincCoef u = ∑ (-1)^n u^n / (2n+1)!`.
For `u ≥ 0` this equals `Real.sin (Real.sqrt u) / Real.sqrt u`. -/
def sincCoef (u : ℝ) : ℝ := ∑' n : ℕ, (-1 : ℝ) ^ n * u ^ n / (Nat.factorial (2 * n + 1))

lemma cosCoef_contDiff : ContDiff ℝ (⊤ : ℕ∞) cosCoef := by
  refine' ( contDiff_iff_contDiffAt.mpr _ );
  intro x
  have h_cosCoef_analytic : AnalyticAt ℝ cosCoef x := by
    -- The series $\sum_{n=0}^{\infty} \frac{(-1)^n u^n}{(2n)!}$ is the Taylor series for $\cos(\sqrt{u})$, which is known to be analytic everywhere.
    have h_cos_sqrt : ∀ u : ℝ, 0 ≤ u → cosCoef u = Real.cos (Real.sqrt u) := by
      intro u hu; rw [ Real.cos_eq_tsum ] ; simp +decide [ cosCoef ] ; ring;
      norm_num [ pow_mul', hu ];
    by_cases hx : 0 ≤ x;
    · by_cases hx' : x = 0 <;> simp_all +decide [ Real.sqrt_eq_rpow ];
      · refine' ( AnalyticAt.congr _ _ );
        exact fun u => ∑' n : ℕ, ( -1 : ℝ ) ^ n * u ^ n / ( Nat.factorial ( 2 * n ) );
        · refine' ( HasFPowerSeriesAt.analyticAt _ );
          exact ( FormalMultilinearSeries.ofScalars ℝ fun n => ( -1 : ℝ ) ^ n / ( Nat.factorial ( 2 * n ) ) );
          simp +decide [ hasFPowerSeriesAt_iff, FormalMultilinearSeries.ofScalars ];
          filter_upwards [ Metric.ball_mem_nhds _ zero_lt_one ] with z hz;
          convert Summable.hasSum _ using 1;
          · exact tsum_congr fun n => by ring;
          · field_simp;
            exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.of_nonneg_of_le ( fun n => by positivity ) fun n => by simpa using by gcongr ; linarith;
        · filter_upwards [ Metric.ball_mem_nhds _ zero_lt_one ] with u hu;
          exact tsum_congr fun n => by ring;
      · refine' AnalyticAt.congr _ _;
        exact fun u => Real.cos ( u ^ ( 2⁻¹ : ℝ ) );
        · apply_rules [ ContDiffAt.analyticAt ];
          exact ContDiffAt.cos ( ContDiffAt.rpow ( contDiffAt_id ) contDiffAt_const <| by positivity );
        · filter_upwards [ lt_mem_nhds ( show x > 0 from lt_of_le_of_ne hx ( Ne.symm hx' ) ) ] with u hu using by rw [ h_cos_sqrt u hu.le ] ;
    · -- For $u < 0$, we can use the fact that $\cosh(\sqrt{-u})$ is analytic.
      have h_cosh_sqrt : ∀ u : ℝ, u < 0 → cosCoef u = Real.cosh (Real.sqrt (-u)) := by
        intro u hu
        have h_cosCoef_neg : cosCoef u = ∑' n : ℕ, (Real.sqrt (-u)) ^ (2 * n) / (Nat.factorial (2 * n)) := by
          exact tsum_congr fun n => by rw [ pow_mul, Real.sq_sqrt ( neg_nonneg.mpr hu.le ) ] ; ring;
        rw [ h_cosCoef_neg, Real.cosh_eq_tsum ];
      refine' AnalyticAt.congr _ _;
      exact fun u => Real.cosh ( Real.sqrt ( -u ) );
      · apply_rules [ ContDiffAt.analyticAt ];
        exact ContDiffAt.cosh ( ContDiffAt.sqrt ( contDiffAt_id.neg ) ( by linarith ) );
      · filter_upwards [ Iio_mem_nhds ( lt_of_not_ge hx ) ] with u hu using Eq.symm ( h_cosh_sqrt u hu )
  exact h_cosCoef_analytic.contDiffAt

lemma sincCoef_contDiff : ContDiff ℝ (⊤ : ℕ∞) sincCoef := by
  refine' contDiff_iff_contDiffAt.2 fun x => _;
  refine' AnalyticAt.contDiffAt _;
  by_cases hx : x = 0;
  · refine' ⟨ _, _ ⟩;
    exact ( FormalMultilinearSeries.ofScalars ℝ fun n => ( -1 : ℝ ) ^ n / ( Nat.factorial ( 2 * n + 1 ) ) );
    rw [ hasFPowerSeriesAt_iff ];
    filter_upwards [ Metric.ball_mem_nhds _ zero_lt_one ] with z hz;
    convert Summable.hasSum _ using 1;
    · simp +decide [ hx, sincCoef, FormalMultilinearSeries.ofScalars ];
      exact tsum_congr fun n => by ring;
    · refine' Summable.of_norm _;
      norm_num [ FormalMultilinearSeries.ofScalars ];
      exact Summable.of_nonneg_of_le ( fun n => by positivity ) ( fun n => mul_le_of_le_one_right ( by positivity ) ( inv_le_one_of_one_le₀ ( mod_cast Nat.factorial_pos _ ) ) ) ( summable_geometric_of_lt_one ( by positivity ) ( by simpa using hz ) );
  · by_cases hx_pos : 0 < x;
    · -- For $x > 0$, we can use the fact that $\sin(\sqrt{x}) / \sqrt{x}$ is analytic.
      have h_sin_sqrt : AnalyticAt ℝ (fun x => Real.sin (Real.sqrt x) / Real.sqrt x) x := by
        have h_sin_sqrt : AnalyticAt ℝ (fun x => Real.sin x / x) (Real.sqrt x) := by
          apply_rules [ AnalyticAt.div, Real.differentiable_sin, analyticAt_id ];
          · fun_prop;
          · positivity;
        have h_sqrt : AnalyticAt ℝ (fun x => Real.sqrt x) x := by
          apply_rules [ ContDiffAt.analyticAt, Real.contDiffAt_sqrt ];
        exact h_sin_sqrt.comp h_sqrt;
      have h_sin_sqrt_eq : ∀ x > 0, Real.sin (Real.sqrt x) / Real.sqrt x = ∑' n : ℕ, (-1 : ℝ) ^ n * x ^ n / (Nat.factorial (2 * n + 1)) := by
        intro x hx_pos; rw [ Real.sin_eq_tsum ] ; rw [ div_eq_iff ( ne_of_gt ( Real.sqrt_pos.mpr hx_pos ) ) ] ; ring;
        rw [ ← tsum_mul_left ] ; congr ; ext n ; rw [ pow_mul', Real.sq_sqrt hx_pos.le ] ; ring;
      exact h_sin_sqrt.congr ( Filter.eventuallyEq_of_mem ( Ioi_mem_nhds hx_pos ) fun y hy => h_sin_sqrt_eq y hy ▸ rfl );
    · -- For x < 0, use the power series representation directly.
      have h_series_neg : ∀ x : ℝ, x < 0 → sincCoef x = Real.sinh (Real.sqrt (-x)) / Real.sqrt (-x) := by
        intro x hx_neg
        have h_series_neg : sincCoef x = ∑' n : ℕ, (Real.sqrt (-x)) ^ (2 * n) / (Nat.factorial (2 * n + 1)) := by
          convert tsum_congr fun n => ?_ using 2 ; ring;
          rw [ pow_mul', Real.sq_sqrt ( by linarith ) ] ; ring;
        rw [ h_series_neg, Real.sinh_eq_tsum ];
        rw [ eq_div_iff ( ne_of_gt ( Real.sqrt_pos.mpr ( neg_pos.mpr hx_neg ) ) ), ← tsum_mul_right ] ; congr ; ext n ; ring;
      refine' AnalyticAt.congr _ _;
      exact fun x => Real.sinh ( Real.sqrt ( -x ) ) / Real.sqrt ( -x );
      · apply_rules [ ContDiffAt.analyticAt ];
        exact ContDiffAt.div ( ContDiffAt.sinh ( ContDiffAt.sqrt ( contDiffAt_id.neg ) ( by norm_num; contrapose! hx; linarith ) ) ) ( ContDiffAt.sqrt ( contDiffAt_id.neg ) ( by norm_num; contrapose! hx; linarith ) ) ( ne_of_gt ( Real.sqrt_pos.mpr ( neg_pos.mpr ( lt_of_le_of_ne ( le_of_not_gt hx_pos ) hx ) ) ) );
      · filter_upwards [ Iio_mem_nhds ( lt_of_le_of_ne ( le_of_not_gt hx_pos ) hx ) ] with y hy using Eq.symm ( h_series_neg y hy )

/-
Closed form for the exact Dirac flow via the Clifford square.
-/
theorem exactFlow_closed_form (kx ky kz m t : ℝ) :
    exactFlow kx ky kz m t
      = (cosCoef (t ^ 2 * Qform kx ky kz m) : ℂ) • (1 : Mat4)
        + (sincCoef (t ^ 2 * Qform kx ky kz m) : ℂ) •
            ((-(t : ℂ)) • (I • H kx ky kz m)) := by
              have h_exp : ∀ x : Mat4, x * x = (-(t^2 * Qform kx ky kz m : ℝ) : ℂ) • (1 : Mat4) → NormedSpace.exp x = (cosCoef (t^2 * Qform kx ky kz m) : ℂ) • (1 : Mat4) + (sincCoef (t^2 * Qform kx ky kz m) : ℂ) • x := by
                intro x hx
                have h_exp_series : ∀ n : ℕ, x ^ n = if n % 2 = 0 then ((-1 : ℂ) ^ (n / 2) * (t ^ 2 * Qform kx ky kz m) ^ (n / 2) : ℂ) • (1 : Mat4) else ((-1 : ℂ) ^ (n / 2) * (t ^ 2 * Qform kx ky kz m) ^ (n / 2) : ℂ) • x := by
                  intro n; rw [ ← Nat.mod_add_div n 2 ] ; rcases Nat.mod_two_eq_zero_or_one n with h | h <;> simp +decide [ *, pow_add, pow_mul ] ;
                  · induction n / 2 <;> simp_all +decide [ pow_succ, mul_assoc, mul_left_comm, mul_smul_comm ];
                    ext i j ; norm_num ; ring;
                  · induction n / 2 <;> simp_all +decide [ Nat.add_div, pow_succ, mul_assoc ];
                    simp +decide [ mul_assoc, mul_comm, mul_left_comm, smul_smul ];
                have h_exp_series : NormedSpace.exp x = ∑' n : ℕ, (1 / (Nat.factorial n) : ℂ) • x ^ n := by
                  grind +suggestions;
                rw [ h_exp_series, ← tsum_even_add_odd ];
                · simp_all +decide [ Nat.add_mod, Nat.mul_mod, Nat.factorial_succ ];
                  norm_num [ Nat.add_div, cosCoef, sincCoef ];
                  congr! 1;
                  · rw [ ← Summable.tsum_smul_const ] ; congr ; ext n ; norm_num ; ring;
                    exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.of_nonneg_of_le ( fun n => by positivity ) fun n => by gcongr ; linarith;
                  · rw [ ← Summable.tsum_smul_const ] ; congr ; ext n ; norm_cast ; norm_num [ Nat.factorial_succ, div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm ];
                    exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.of_nonneg_of_le ( fun n => by positivity ) fun n => by gcongr ; linarith;
                · simp_all +decide [ Nat.even_iff ];
                  refine' Summable.of_norm _;
                  norm_num [ norm_smul ];
                  field_simp;
                  exact Real.summable_pow_div_factorial _ |> Summable.of_nonneg_of_le ( fun n => by positivity ) fun n => by gcongr ; linarith;
                · have h_summable : Summable (fun k : ℕ => (1 / (Nat.factorial (2 * k + 1)) : ℂ) * ((-1 : ℂ) ^ k * (t ^ 2 * Qform kx ky kz m) ^ k)) := by
                    have h_summable : Summable (fun k : ℕ => (1 / (Nat.factorial (2 * k + 1)) : ℝ) * |t ^ 2 * Qform kx ky kz m| ^ k) := by
                      have h_summable : Summable (fun k : ℕ => (|t ^ 2 * Qform kx ky kz m| ^ k) / (Nat.factorial k : ℝ)) := by
                        exact Real.summable_pow_div_factorial _;
                      exact Summable.of_nonneg_of_le ( fun n => by positivity ) ( fun n => by rw [ one_div, inv_mul_eq_div ] ; gcongr ; linarith ) h_summable;
                    rw [ ← summable_norm_iff ] at * ; norm_num at *;
                    convert h_summable using 1;
                  convert h_summable.smul_const x using 2 ; norm_num [ ‹∀ n : ℕ, x ^ n = _› ];
                  norm_num [ Nat.add_div, smul_smul ];
              convert h_exp _ _ using 2 ; norm_num [ H_sq ];
              ext i j ; norm_num [ Matrix.mul_apply, pow_two ] ; ring;
              norm_num [ Complex.ext_iff, sq ]

/-! ## Bounded iterated derivatives of the coefficient functions on `[0,∞)` -/

lemma cosCoef_iteratedDeriv_bddOn (n : ℕ) :
    ∃ C : ℝ, ∀ u : ℝ, 0 ≤ u → |iteratedDeriv n cosCoef u| ≤ C := by
      -- By definition of $cosCoef$, we know that it is the cosine function applied to the square root of $u$.
      have h_cosCoef : ∀ u : ℝ, 0 ≤ u → cosCoef u = Real.cos (Real.sqrt u) := by
        intro u hu; rw [ Real.cos_eq_tsum ] ;
        exact tsum_congr fun n => by rw [ pow_mul, Real.sq_sqrt hu ] ;
      -- We'll use induction on $n$ to show that the $n$-th derivative of $\cos(\sqrt{u})$ is bounded.
      have h_ind : ∀ n : ℕ, ∃ p q : Polynomial ℝ, ∀ u : ℝ, 0 < u → iteratedDeriv n (fun u => Real.cos (Real.sqrt u)) u = p.eval (1 / Real.sqrt u) * Real.cos (Real.sqrt u) + q.eval (1 / Real.sqrt u) * Real.sin (Real.sqrt u) := by
        intro n;
        induction' n with n ih;
        · exact ⟨ 1, 0, fun u hu => by norm_num ⟩;
        · obtain ⟨ p, q, hpq ⟩ := ih;
          -- By definition of iterated derivative, we have:
          have h_iter : ∀ u : ℝ, 0 < u → iteratedDeriv (n + 1) (fun u => Real.cos (Real.sqrt u)) u = deriv (fun u => p.eval (1 / Real.sqrt u) * Real.cos (Real.sqrt u) + q.eval (1 / Real.sqrt u) * Real.sin (Real.sqrt u)) u := by
            intro u hu; rw [ iteratedDeriv_succ ] ; exact Filter.EventuallyEq.deriv_eq ( Filter.eventuallyEq_of_mem ( Ioi_mem_nhds hu ) fun x hx => hpq x hx ) ;
          -- By definition of polynomial evaluation, we can write the derivative as a polynomial in $1/\sqrt{u}$.
          have h_poly_deriv : ∀ p : Polynomial ℝ, ∃ p' : Polynomial ℝ, ∀ u : ℝ, 0 < u → deriv (fun u => p.eval (1 / Real.sqrt u)) u = p'.eval (1 / Real.sqrt u) * (-1 / (2 * u ^ (3 / 2 : ℝ))) := by
            intro p
            use Polynomial.derivative p;
            intro u hu; convert HasDerivAt.deriv ( HasDerivAt.comp u ( p.hasDerivAt _ ) ( HasDerivAt.div ( hasDerivAt_const _ _ ) ( Real.hasDerivAt_sqrt hu.ne' ) ( by positivity ) ) ) using 1 ; norm_num ; ring;
            norm_num [ Real.sqrt_eq_rpow, ← Real.rpow_natCast, ← Real.rpow_mul hu.le ];
          obtain ⟨ p', hp' ⟩ := h_poly_deriv p; obtain ⟨ q', hq' ⟩ := h_poly_deriv q; use p' * Polynomial.C ( -1 / 2 ) * Polynomial.X ^ 3 + q * Polynomial.C ( 1 / 2 ) * Polynomial.X, q' * Polynomial.C ( -1 / 2 ) * Polynomial.X ^ 3 - p * Polynomial.C ( 1 / 2 ) * Polynomial.X; intros u hu; rw [ h_iter u hu ] ; norm_num [ Real.sqrt_eq_rpow, hu.ne', hp' u hu, hq' u hu, Real.rpow_neg hu.le ] ; ring;
          convert HasDerivAt.deriv ( HasDerivAt.add ( HasDerivAt.mul ( hasDerivAt_deriv_iff.mpr _ ) ( HasDerivAt.cos ( Real.hasDerivAt_rpow_const _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_deriv_iff.mpr _ ) ( HasDerivAt.sin ( Real.hasDerivAt_rpow_const _ ) ) ) ) using 1 <;> norm_num [ hu.ne', hu.le ] ; ring;
          · rw [ show deriv ( fun u => Polynomial.eval ( u ^ ( 1 / 2 : ℝ ) ) ⁻¹ p ) u = Polynomial.eval ( u ^ ( 1 / 2 : ℝ ) ) ⁻¹ p' * ( -1 / ( 2 * u ^ ( 3 / 2 : ℝ ) ) ) by simpa [ Real.sqrt_eq_rpow ] using hp' u hu ] ; rw [ show deriv ( fun u => Polynomial.eval ( u ^ ( 1 / 2 : ℝ ) ) ⁻¹ q ) u = Polynomial.eval ( u ^ ( 1 / 2 : ℝ ) ) ⁻¹ q' * ( -1 / ( 2 * u ^ ( 3 / 2 : ℝ ) ) ) by simpa [ Real.sqrt_eq_rpow ] using hq' u hu ] ; norm_num [ Real.rpow_neg hu.le ] ; ring;
            norm_num [ ← Real.rpow_natCast, ← Real.rpow_mul hu.le, ← Real.rpow_neg hu.le ] ; ring;
          · exact DifferentiableAt.comp u ( p.differentiableAt ) ( DifferentiableAt.inv ( DifferentiableAt.rpow ( differentiableAt_id ) ( by norm_num ) ( by positivity ) ) ( by positivity ) );
          · exact DifferentiableAt.comp u ( q.differentiableAt ) ( DifferentiableAt.inv ( DifferentiableAt.rpow ( differentiableAt_id ) ( by norm_num ) ( by positivity ) ) ( by positivity ) );
      obtain ⟨ p, q, hpq ⟩ := h_ind n;
      -- Since $p$ and $q$ are polynomials, their evaluations at $1 / \sqrt{u}$ are bounded for $u \geq 1$.
      obtain ⟨C₁, hC₁⟩ : ∃ C₁ : ℝ, ∀ u : ℝ, 1 ≤ u → |p.eval (1 / Real.sqrt u)| ≤ C₁ ∧ |q.eval (1 / Real.sqrt u)| ≤ C₁ := by
        have h_poly_bound : ∃ C₁ : ℝ, ∀ x : ℝ, 0 ≤ x ∧ x ≤ 1 → |p.eval x| ≤ C₁ ∧ |q.eval x| ≤ C₁ := by
          obtain ⟨ C₁, hC₁ ⟩ := IsCompact.exists_bound_of_continuousOn ( CompactIccSpace.isCompact_Icc ) ( p.continuous.continuousOn ) ; ( obtain ⟨ C₂, hC₂ ⟩ := IsCompact.exists_bound_of_continuousOn ( CompactIccSpace.isCompact_Icc ) ( q.continuous.continuousOn ) ; exact ⟨ Max.max C₁ C₂, fun x hx => ⟨ le_trans ( hC₁ x hx ) ( le_max_left _ _ ), le_trans ( hC₂ x hx ) ( le_max_right _ _ ) ⟩ ⟩ ; );
        exact ⟨ h_poly_bound.choose, fun u hu => h_poly_bound.choose_spec _ ⟨ by positivity, by simpa using inv_le_one_of_one_le₀ <| Real.le_sqrt_of_sq_le <| by linarith ⟩ ⟩;
      -- For $u \geq 1$, we have $|iteratedDeriv n cosCoef u| \leq C₁ + C₁ = 2C₁$.
      have h_bound_ge_one : ∀ u : ℝ, 1 ≤ u → |iteratedDeriv n cosCoef u| ≤ 2 * C₁ := by
        intro u hu; rw [ show iteratedDeriv n cosCoef u = iteratedDeriv n ( fun u => Real.cos ( Real.sqrt u ) ) u from ?_ ] ; rw [ hpq u ( by positivity ) ] ; exact abs_le.mpr ⟨ by nlinarith [ abs_le.mp ( hC₁ u hu |>.1 ), abs_le.mp ( hC₁ u hu |>.2 ), abs_le.mp ( Real.abs_cos_le_one ( Real.sqrt u ) ), abs_le.mp ( Real.abs_sin_le_one ( Real.sqrt u ) ) ], by nlinarith [ abs_le.mp ( hC₁ u hu |>.1 ), abs_le.mp ( hC₁ u hu |>.2 ), abs_le.mp ( Real.abs_cos_le_one ( Real.sqrt u ) ), abs_le.mp ( Real.abs_sin_le_one ( Real.sqrt u ) ) ] ⟩ ;
        rw [ Filter.EventuallyEq.iteratedDeriv_eq ];
        filter_upwards [ lt_mem_nhds ( show 0 < u by linarith ) ] with x hx using h_cosCoef x hx.le;
      -- For $0 \leq u < 1$, we can use the fact that the $n$-th derivative of $\cos(\sqrt{u})$ is continuous and bounded.
      have h_bound_lt_one : ∃ C₂ : ℝ, ∀ u : ℝ, 0 ≤ u ∧ u < 1 → |iteratedDeriv n cosCoef u| ≤ C₂ := by
        have h_cont : ContinuousOn (fun u => iteratedDeriv n cosCoef u) (Set.Icc 0 1) := by
          have h_cont : ContDiff ℝ (⊤ : ℕ∞) cosCoef := by
            convert cosCoef_contDiff using 1;
          have h_cont : ∀ n : ℕ, ContDiff ℝ (⊤ : ℕ∞) (iteratedDeriv n cosCoef) := by
            intro n; induction' n with n ih <;> simp_all +decide [ iteratedDeriv_succ ] ;
            fun_prop;
          exact h_cont n |> ContDiff.continuous |> Continuous.continuousOn;
        obtain ⟨ C₂, hC₂ ⟩ := IsCompact.exists_bound_of_continuousOn ( CompactIccSpace.isCompact_Icc ) h_cont; use C₂; intro u hu; exact hC₂ u ⟨ hu.1, hu.2.le ⟩ ;
      exact ⟨ Max.max ( 2 * C₁ ) h_bound_lt_one.choose, fun u hu => if hu' : u < 1 then le_trans ( h_bound_lt_one.choose_spec u ⟨ hu, hu' ⟩ ) ( le_max_right _ _ ) else le_trans ( h_bound_ge_one u ( le_of_not_gt hu' ) ) ( le_max_left _ _ ) ⟩

lemma sincCoef_iteratedDeriv_bddOn (n : ℕ) :
    ∃ C : ℝ, ∀ u : ℝ, 0 ≤ u → |iteratedDeriv n sincCoef u| ≤ C := by
      obtain ⟨C₁, hC₁⟩ : ∃ C₁ : ℝ, ∀ u : ℝ, 1 ≤ u → |iteratedDeriv n sincCoef u| ≤ C₁ := by
        obtain ⟨ p, q, hpq ⟩ : ∃ p q : Polynomial ℝ, ∀ u : ℝ, 0 < u → iteratedDeriv n (fun u => Real.sin (Real.sqrt u) / Real.sqrt u) u = p.eval (1 / Real.sqrt u) * Real.cos (Real.sqrt u) + q.eval (1 / Real.sqrt u) * Real.sin (Real.sqrt u) := by
          induction' n with n ih;
          · use 0, Polynomial.X; intro u hu; simp +decide [ hu.le ] ; ring;
          · obtain ⟨ p, q, hpq ⟩ := ih;
            -- Differentiate the expression for the nth derivative.
            have h_diff : ∀ u : ℝ, 0 < u → deriv (fun u => p.eval (1 / Real.sqrt u) * Real.cos (Real.sqrt u) + q.eval (1 / Real.sqrt u) * Real.sin (Real.sqrt u)) u = (-1 / 2) * p.derivative.eval (1 / Real.sqrt u) * (1 / u ^ (3 / 2 : ℝ)) * Real.cos (Real.sqrt u) - p.eval (1 / Real.sqrt u) * (1 / (2 * Real.sqrt u)) * Real.sin (Real.sqrt u) + (-1 / 2) * q.derivative.eval (1 / Real.sqrt u) * (1 / u ^ (3 / 2 : ℝ)) * Real.sin (Real.sqrt u) + q.eval (1 / Real.sqrt u) * (1 / (2 * Real.sqrt u)) * Real.cos (Real.sqrt u) := by
              intro u hu; norm_num [ Real.sqrt_eq_rpow, hu.ne', hu.le, Real.rpow_neg hu.le, Real.rpow_two, mul_assoc, mul_comm, mul_left_comm, Polynomial.differentiableAt ] ; ring;
              convert HasDerivAt.deriv ( HasDerivAt.add ( HasDerivAt.mul ( HasDerivAt.comp u ( p.hasDerivAt _ ) <| HasDerivAt.inv ( Real.hasDerivAt_rpow_const _ ) _ ) <| HasDerivAt.cos <| Real.hasDerivAt_rpow_const _ ) <| HasDerivAt.mul ( HasDerivAt.comp u ( q.hasDerivAt _ ) <| HasDerivAt.inv ( Real.hasDerivAt_rpow_const _ ) _ ) <| HasDerivAt.sin <| Real.hasDerivAt_rpow_const _ ) using 1 <;> norm_num [ hu.ne', hu.le ] ; ring;
              norm_num [ sq, mul_assoc, mul_left_comm, ← Real.rpow_neg hu.le, ← Real.rpow_add hu ] ; ring;
              rw [ show ( -3 / 2 : ℝ ) = -1 / 2 + ( -1 ) by norm_num, Real.rpow_add hu ] ; norm_num ; ring;
            -- Combine like terms and simplify the expression.
            use Polynomial.C (-1 / 2) * Polynomial.derivative p * Polynomial.X ^ 3 + Polynomial.C (1 / 2) * q * Polynomial.X, Polynomial.C (-1 / 2) * Polynomial.derivative q * Polynomial.X ^ 3 - Polynomial.C (1 / 2) * p * Polynomial.X;
            intro u hu; rw [ iteratedDeriv_succ ] ; rw [ Filter.EventuallyEq.deriv_eq ( Filter.eventuallyEq_of_mem ( Ioi_mem_nhds hu ) fun x hx => hpq x hx ) ] ; rw [ h_diff u hu ] ; norm_num ; ring;
            norm_num [ Real.sqrt_eq_rpow, ← Real.rpow_natCast, ← Real.rpow_mul hu.le ] ; ring;
            norm_num;
        -- Since $p$ and $q$ are polynomials, their evaluations at $1/\sqrt{u}$ are bounded for $u \geq 1$.
        obtain ⟨C_p, hC_p⟩ : ∃ C_p : ℝ, ∀ u : ℝ, 1 ≤ u → |p.eval (1 / Real.sqrt u)| ≤ C_p := by
          obtain ⟨ C_p, hC_p ⟩ := IsCompact.exists_bound_of_continuousOn ( CompactIccSpace.isCompact_Icc ) ( show ContinuousOn ( fun u : ℝ => p.eval u ) ( Set.Icc 0 1 ) from p.continuous.continuousOn ) ; use C_p; intro u hu; exact hC_p ( 1 / Real.sqrt u ) ⟨ by positivity, by simpa using inv_le_one_of_one_le₀ <| Real.le_sqrt_of_sq_le <| by linarith ⟩ ;
        obtain ⟨C_q, hC_q⟩ : ∃ C_q : ℝ, ∀ u : ℝ, 1 ≤ u → |q.eval (1 / Real.sqrt u)| ≤ C_q := by
          have h_poly_bound : ∃ C_q : ℝ, ∀ x : ℝ, 0 ≤ x ∧ x ≤ 1 → |q.eval x| ≤ C_q := by
            exact IsCompact.exists_bound_of_continuousOn ( CompactIccSpace.isCompact_Icc ) ( q.continuous.continuousOn );
          exact ⟨ h_poly_bound.choose, fun u hu => h_poly_bound.choose_spec _ ⟨ by positivity, by simpa using inv_le_one_of_one_le₀ <| Real.le_sqrt_of_sq_le <| by linarith ⟩ ⟩;
        -- Since $sincCoef u = \frac{\sin(\sqrt{u})}{\sqrt{u}}$ for $u > 0$, we can use the bound on the iterated derivative of $\frac{\sin(\sqrt{u})}{\sqrt{u}}$.
        have h_sincCoef_eq : ∀ u : ℝ, 0 < u → sincCoef u = Real.sin (Real.sqrt u) / Real.sqrt u := by
          intro u hu; rw [ sincCoef ] ; rw [ Real.sin_eq_tsum ] ;
          rw [ ← tsum_div_const ] ; congr ; ext n ; rw [ pow_add, pow_mul ] ; norm_num [ hu.le, hu.ne' ] ; ring;
          norm_num [ hu.le, hu.ne' ];
        use C_p + C_q;
        intro u hu; rw [ show iteratedDeriv n sincCoef u = iteratedDeriv n ( fun u => Real.sin ( Real.sqrt u ) / Real.sqrt u ) u from ?_ ] ; rw [ hpq u ( by positivity ) ] ; exact abs_le.mpr ⟨ by nlinarith [ abs_le.mp ( hC_p u hu ), abs_le.mp ( hC_q u hu ), abs_le.mp ( Real.abs_cos_le_one ( Real.sqrt u ) ), abs_le.mp ( Real.abs_sin_le_one ( Real.sqrt u ) ) ], by nlinarith [ abs_le.mp ( hC_p u hu ), abs_le.mp ( hC_q u hu ), abs_le.mp ( Real.abs_cos_le_one ( Real.sqrt u ) ), abs_le.mp ( Real.abs_sin_le_one ( Real.sqrt u ) ) ] ⟩ ;
        rw [ Filter.EventuallyEq.iteratedDeriv_eq ];
        filter_upwards [ lt_mem_nhds ( show 0 < u by positivity ) ] with u hu using h_sincCoef_eq u hu;
      have h_cont : ContinuousOn (iteratedDeriv n sincCoef) (Set.Icc 0 1) := by
        have h_cont : ContDiff ℝ (n : ℕ∞) sincCoef := by
          exact sincCoef_contDiff.of_le ( mod_cast le_top );
        fun_prop;
      obtain ⟨ C₂, hC₂ ⟩ := IsCompact.exists_bound_of_continuousOn ( CompactIccSpace.isCompact_Icc ) h_cont; use Max.max C₁ C₂; intro u hu; cases le_total u 1 <;> aesop;

/-! ## A composition lemma for temperate growth with nonnegative inner data -/

/-
If `g : ℝ → ℝ` is smooth with all iterated derivatives bounded on `[0,∞)`,
and `φ` has temperate growth with nonnegative values, then `g ∘ φ` has
temperate growth.  This is the mechanism that turns the (only apparently
exponential) entire coefficient functions into genuine temperate multipliers,
because the dispersion `Q ≥ 0` never samples the growing branch.
-/
lemma hasTemperateGrowth_comp_nonneg {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (g : ℝ → ℝ) (hg : ContDiff ℝ (⊤ : ℕ∞) g)
    (hb : ∀ n : ℕ, ∃ C : ℝ, ∀ u : ℝ, 0 ≤ u → |iteratedDeriv n g u| ≤ C)
    (φ : E → ℝ) (hφ : Function.HasTemperateGrowth φ) (hnn : ∀ x, 0 ≤ φ x) :
    Function.HasTemperateGrowth (fun x => g (φ x)) := by
      use by
        exact hg.comp hφ.1;
      intro n
      obtain ⟨k, C, hC⟩ : ∃ k C, ∀ x, ‖iteratedFDeriv ℝ n (fun x => g (φ x)) x‖ ≤ C * (1 + ‖x‖) ^ k := by
        have h_g_bounded : ∀ n, ∃ C, ∀ u, 0 ≤ u → |iteratedDeriv n g u| ≤ C := hb
        have h_g_bounded : ∃ g' : ℝ → ℝ, ContDiff ℝ (⊤ : ℕ∞) g' ∧ (∀ u, 0 ≤ u → g' u = g u) ∧ (∀ n, ∃ C, ∀ u, |iteratedDeriv n g' u| ≤ C) := by
          refine' ⟨ fun u => g u * Real.smoothTransition ( u + 1 ), _, _, _ ⟩ <;> norm_num [ Real.smoothTransition ];
          · refine' hg.mul _;
            refine' ContDiff.div _ _ _;
            · exact expNegInvGlue.contDiff.comp ( contDiff_id.add contDiff_const );
            · exact ContDiff.add ( expNegInvGlue.contDiff.comp ( contDiff_id.add contDiff_const ) ) ( expNegInvGlue.contDiff.comp ( contDiff_neg ) );
            · intro x; by_cases hx : x + 1 ≤ 0 <;> by_cases hx' : -x ≤ 0 <;> simp +decide [ hx, hx', expNegInvGlue ] ;
              · linarith;
              · positivity;
          · intro u hu; rw [ expNegInvGlue, expNegInvGlue ] ; norm_num [ hu ] ;
            rw [ if_neg ( by linarith ), div_self ( by positivity ), mul_one ];
          · intro n
            have h_g_bounded : ∃ C, ∀ u, |iteratedDeriv n (fun u => g u * (expNegInvGlue (u + 1) / (expNegInvGlue (u + 1) + expNegInvGlue (-u))) ) u| ≤ C := by
              have h_support : ∀ u, u < -1 → iteratedDeriv n (fun u => g u * (expNegInvGlue (u + 1) / (expNegInvGlue (u + 1) + expNegInvGlue (-u))) ) u = 0 := by
                intro u hu; induction' n with n ih generalizing u <;> simp_all +decide [ iteratedDeriv_succ ] ;
                · exact Or.inr <| Or.inl <| by linarith;
                · exact HasDerivAt.deriv ( HasDerivAt.congr_of_eventuallyEq ( hasDerivAt_const _ _ ) ( Filter.eventuallyEq_of_mem ( Iio_mem_nhds hu ) fun x hx => ih x hx ) )
              have h_support : ∃ C, ∀ u, -1 ≤ u ∧ u ≤ 0 → |iteratedDeriv n (fun u => g u * (expNegInvGlue (u + 1) / (expNegInvGlue (u + 1) + expNegInvGlue (-u))) ) u| ≤ C := by
                have h_support : ContinuousOn (fun u => iteratedDeriv n (fun u => g u * (expNegInvGlue (u + 1) / (expNegInvGlue (u + 1) + expNegInvGlue (-u))) ) u) (Set.Icc (-1 : ℝ) 0) := by
                  have h_bounded : ContDiff ℝ (⊤ : ℕ∞) (fun u => g u * (expNegInvGlue (u + 1) / (expNegInvGlue (u + 1) + expNegInvGlue (-u))) ) := by
                    apply_rules [ ContDiff.mul, ContDiff.div, ContDiff.add, contDiff_id, contDiff_const ];
                    · exact contDiff_iff_contDiffAt.mpr fun x => by exact ( expNegInvGlue.contDiff.contDiffAt.comp x ( contDiffAt_id.add contDiffAt_const ) ) ;
                    · refine' ContDiff.inv _ _;
                      · exact ContDiff.add ( expNegInvGlue.contDiff.comp ( contDiff_id.add contDiff_const ) ) ( expNegInvGlue.contDiff.comp ( contDiff_neg ) );
                      · intro x; by_cases hx : x + 1 ≤ 0 <;> by_cases hx' : -x ≤ 0 <;> simp +decide [ hx, hx', expNegInvGlue ] ;
                        · linarith;
                        · positivity;
                  have h_bounded : ∀ n, ContDiff ℝ (⊤ : ℕ∞) (fun u => iteratedDeriv n (fun u => g u * (expNegInvGlue (u + 1) / (expNegInvGlue (u + 1) + expNegInvGlue (-u))) ) u) := by
                    intro n; induction' n with n ih <;> simp_all +decide [ iteratedDeriv_succ ] ;
                    fun_prop;
                  exact h_bounded n |> ContDiff.continuous |> Continuous.continuousOn;
                exact IsCompact.exists_bound_of_continuousOn ( CompactIccSpace.isCompact_Icc ) h_support |> fun ⟨ C, hC ⟩ => ⟨ C, fun u hu => hC u hu ⟩;
              obtain ⟨ C, hC ⟩ := h_support
              obtain ⟨ D, hD ⟩ := h_g_bounded n
              use max C D
              intro u
              by_cases hu : u < -1 ∨ u > 0;
              · cases hu <;> simp_all +decide [ iteratedDeriv_eq_iterate ];
                · exact Or.inl ( le_trans ( abs_nonneg _ ) ( hC 0 ( by norm_num ) ( by norm_num ) ) );
                · refine' Or.inr ( le_trans _ ( hD u ( by linarith ) ) );
                  rw [ show deriv^[n] ( fun u => g u * ( expNegInvGlue ( u + 1 ) / ( expNegInvGlue ( u + 1 ) + expNegInvGlue ( -u ) ) ) ) u = deriv^[n] g u from _ ];
                  have h_eq : ∀ m ≤ n, ∀ u, 0 < u → deriv^[m] (fun u => g u * (expNegInvGlue (u + 1) / (expNegInvGlue (u + 1) + expNegInvGlue (-u))) ) u = deriv^[m] g u := by
                    intro m hm u hu; induction' m with m ih generalizing u <;> simp_all +decide [ Function.iterate_succ_apply' ] ;
                    · simp +decide [ expNegInvGlue, hu.ne' ];
                      split_ifs <;> first | linarith | simp_all +decide [ ne_of_gt, Real.exp_pos ];
                    · exact Filter.EventuallyEq.deriv_eq ( Filter.eventuallyEq_of_mem ( Ioi_mem_nhds hu ) fun x hx => ih ( Nat.le_of_lt hm ) x hx );
                  exact h_eq n le_rfl u ‹_›;
              · exact le_trans ( hC u ⟨ by push_neg at hu; linarith, by push_neg at hu; linarith ⟩ ) ( le_max_left _ _ )
            exact h_g_bounded;
        obtain ⟨ g', hg', hg'_eq, hg'_bounded ⟩ := h_g_bounded;
        have h_g'_temperate : Function.HasTemperateGrowth g' := by
          refine' ⟨ _, _ ⟩;
          · exact hg';
          · intro n
            obtain ⟨ C, hC ⟩ := hg'_bounded n
            use 0, C
            intro x
            simp [hC];
            convert hC x using 1;
            rw [ iteratedFDeriv_eq_equiv_comp ] ; norm_num [ iteratedDeriv_eq_iteratedFDeriv ] ;
        generalize_proofs at *; (
        obtain ⟨ k, hk ⟩ := h_g'_temperate.comp hφ
        generalize_proofs at *; (
        obtain ⟨ k, C, hC ⟩ := hk n; use k, C; intro x; specialize hC x; simp_all +decide [ Function.comp_def, iteratedFDeriv_eq_equiv_comp ] ;))
      use k, C

/-! ## Temperate growth of the scalar dispersion coefficients -/

/-
`k ↦ t^2 Q(k)` has temperate growth (it is a polynomial in `k`).
-/
lemma tsqQ_hasTemperateGrowth (m t : ℝ) :
    Function.HasTemperateGrowth
      (fun k : FourierMomentum3 => t ^ 2 * Qform (k 0) (k 1) (k 2) m) := by
        unfold Qform;
        -- Each term in the sum is a polynomial in $k$, hence has temperate growth.
        have h_poly : ∀ i : Fin 3, Function.HasTemperateGrowth (fun k : FourierMomentum3 => k.ofLp i ^ 2) := by
          intro i;
          convert Function.HasTemperateGrowth.pow ( EuclideanSpace.proj i |> ContinuousLinearMap.hasTemperateGrowth ) 2 using 1;
        fun_prop

lemma tsqQ_nonneg (m t : ℝ) (k : FourierMomentum3) :
    0 ≤ t ^ 2 * Qform (k 0) (k 1) (k 2) m := by
  have := Qform_nonneg (k 0) (k 1) (k 2) m
  positivity

lemma cosCoef_comp_hasTemperateGrowth (m t : ℝ) :
    Function.HasTemperateGrowth
      (fun k : FourierMomentum3 => cosCoef (t ^ 2 * Qform (k 0) (k 1) (k 2) m)) :=
  hasTemperateGrowth_comp_nonneg cosCoef cosCoef_contDiff cosCoef_iteratedDeriv_bddOn
    _ (tsqQ_hasTemperateGrowth m t) (tsqQ_nonneg m t)

lemma sincCoef_comp_hasTemperateGrowth (m t : ℝ) :
    Function.HasTemperateGrowth
      (fun k : FourierMomentum3 => sincCoef (t ^ 2 * Qform (k 0) (k 1) (k 2) m)) :=
  hasTemperateGrowth_comp_nonneg sincCoef sincCoef_contDiff sincCoef_iteratedDeriv_bddOn
    _ (tsqQ_hasTemperateGrowth m t) (tsqQ_nonneg m t)

/-! ## Temperate growth of the affine Dirac symbol -/

/-
`k ↦ -i t H(k)` is affine-linear in `k`, hence of temperate growth.
-/
lemma Xsymbol_hasTemperateGrowth (m t : ℝ) :
    Function.HasTemperateGrowth
      (fun k : FourierMomentum3 => (-(t : ℂ)) • (I • H (k 0) (k 1) (k 2) m)) := by
        unfold H;
        simp +decide [ ← smul_assoc, ← add_smul ];
        -- Each term in the sum is a scalar multiple of a constant matrix, which is temperate.
        have h_term : ∀ (c : Mat4) (i : Fin 3), Function.HasTemperateGrowth (fun k : EuclideanSpace ℝ (Fin 3) => (k i : ℂ) • c) := by
          intro c i;
          have h_term : Function.HasTemperateGrowth (fun k : EuclideanSpace ℝ (Fin 3) => (k i : ℝ)) := by
            exact ContinuousLinearMap.hasTemperateGrowth ( EuclideanSpace.proj i );
          convert Function.Complex.hasTemperateGrowth_ofReal.comp h_term |> Function.HasTemperateGrowth.smul <| Function.HasTemperateGrowth.const c using 1;
        apply_rules [ Function.HasTemperateGrowth.add, Function.HasTemperateGrowth.smul, Function.HasTemperateGrowth.const ];
        · convert h_term ( - ( t * I ) • alpha1 ) 0 using 1 ; ext ; simp +decide [ mul_assoc, mul_comm, mul_left_comm ];
        · convert h_term ( ( - ( t * I ) ) • alpha2 ) 1 using 1 ; ext ; simp +decide [ mul_assoc, mul_comm, mul_left_comm ];
        · convert h_term ( - ( ( t : ℂ ) * I ) • alpha3 ) 2 using 1 ; ext ; simp +decide [ mul_assoc, mul_comm, mul_left_comm ]

/-! ## Matrix → operator transport preserves temperate growth -/

/-- `Matrix.toEuclideanCLM` packaged as a real-linear continuous map; it is an
isometry for the L2 operator norm, hence bounded. -/
def toEuclCLM_R :
    Mat4 →L[ℝ] (ChangingCellScaledLiveWalk.Spinor →L[Complex] ChangingCellScaledLiveWalk.Spinor) :=
  (((Matrix.toEuclideanCLM (𝕜 := Complex)).toAlgEquiv.toLinearMap).restrictScalars ℝ).mkContinuous 1
    (by
      intro A
      rw [one_mul]
      exact le_of_eq (Matrix.l2_opNorm_toEuclideanCLM A))

@[simp] lemma toEuclCLM_R_apply (A : Mat4) :
    toEuclCLM_R A = Matrix.toEuclideanCLM (𝕜 := Complex) A := rfl

/-! ## Main theorem -/

/-- The exact unitary Dirac multiplier has temperate growth as an
operator-valued function of momentum. This is the missing hypothesis required
to multiply a Schwartz spinor by the exact flow using
`SchwartzMap.bilinLeftCLM`. -/
theorem momMultForGrowth_hasTemperateGrowth (m t : Real) :
    Function.HasTemperateGrowth (momMultForGrowth m t) := by
  -- Reduce to temperate growth of the matrix-valued flow, transported by the
  -- bounded operator `toEuclCLM_R`.
  have hmat : Function.HasTemperateGrowth
      (fun k : FourierMomentum3 => exactFlow (k 0) (k 1) (k 2) m t) := by
    -- Use the closed form.
    have hcos := cosCoef_comp_hasTemperateGrowth m t
    have hsin := sincCoef_comp_hasTemperateGrowth m t
    have hX := Xsymbol_hasTemperateGrowth m t
    have hconst : Function.HasTemperateGrowth (fun _ : FourierMomentum3 => (1 : Mat4)) :=
      Function.HasTemperateGrowth.const _
    have hterm1 : Function.HasTemperateGrowth
        (fun k : FourierMomentum3 =>
          (cosCoef (t ^ 2 * Qform (k 0) (k 1) (k 2) m) : ℂ) • (1 : Mat4)) :=
      (Function.HasTemperateGrowth.comp Function.Complex.hasTemperateGrowth_ofReal hcos).smul hconst
    have hterm2 : Function.HasTemperateGrowth
        (fun k : FourierMomentum3 =>
          (sincCoef (t ^ 2 * Qform (k 0) (k 1) (k 2) m) : ℂ) •
            ((-(t : ℂ)) • (I • H (k 0) (k 1) (k 2) m))) :=
      (Function.HasTemperateGrowth.comp Function.Complex.hasTemperateGrowth_ofReal hsin).smul hX
    have hsum := hterm1.add hterm2
    -- rewrite via the closed form
    have hEq : (fun k : FourierMomentum3 => exactFlow (k 0) (k 1) (k 2) m t)
        = (fun k : FourierMomentum3 =>
            (cosCoef (t ^ 2 * Qform (k 0) (k 1) (k 2) m) : ℂ) • (1 : Mat4)
            + (sincCoef (t ^ 2 * Qform (k 0) (k 1) (k 2) m) : ℂ) •
                ((-(t : ℂ)) • (I • H (k 0) (k 1) (k 2) m))) := by
      funext k
      exact exactFlow_closed_form (k 0) (k 1) (k 2) m t
    rw [hEq]
    exact hsum
  have hcomp := (toEuclCLM_R.hasTemperateGrowth).comp hmat
  have hEq2 : momMultForGrowth m t
      = toEuclCLM_R ∘ (fun k : FourierMomentum3 => exactFlow (k 0) (k 1) (k 2) m t) := by
    funext k
    simp only [momMultForGrowth, Function.comp, toEuclCLM_R_apply]
  rw [hEq2]
  exact hcomp

/-! ## Exact controls -/

/-
At `t = 0` the multiplier is the identity operator.
-/
theorem momMultForGrowth_zero_time (m : Real) (k : FourierMomentum3) :
    momMultForGrowth m 0 k = ContinuousLinearMap.id Complex ChangingCellScaledLiveWalk.Spinor := by
  unfold momMultForGrowth;
  unfold exactFlow; norm_num;
  rfl

/-- At zero momentum the multiplier is `exp(-i t m β)` transported to the spinor. -/
theorem momMultForGrowth_zero_momentum (m t : Real)
    (k : FourierMomentum3) (hk : k 0 = 0 ∧ k 1 = 0 ∧ k 2 = 0) :
    momMultForGrowth m t k
      = (Matrix.toEuclideanCLM (𝕜 := Complex))
          (exactFlow 0 0 0 m t) := by
  obtain ⟨h0, h1, h2⟩ := hk
  unfold momMultForGrowth
  rw [h0, h1, h2]

/-- A nonzero `3-4-5` spatial momentum witness: the dispersion equals `25 + m^2`. -/
theorem momMultForGrowth_345_dispersion (m : Real) :
    Qform 3 4 0 m = 25 + m ^ 2 := by
  unfold Qform; ring

end PhysicsSM.Draft.NullEdge.ChangingCellFourierTemperate
