import Mathlib

/-!
# The radial profile for the E8 theta transform

This module isolates the one-variable Gaussian profile used in the
Poisson-summation proof of the S-transform for the E8 theta series.
It depends only on Mathlib, not on Sphere-Packing-Lean.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.unusedSimpArgs false
set_option linter.flexible false
set_option linter.style.induction false
set_option maxHeartbeats 800000

open Complex Filter

namespace CodeLatticeE8.SPL.ThetaProfile

/-- The radial profile underlying the theta kernel. -/
noncomputable def thetaProfile (τ : ℂ) : ℝ → ℂ :=
  fun r => Complex.exp (((Real.pi : ℂ) * Complex.I * τ) * (r : ℂ))

lemma thetaProfile_contDiff (τ : ℂ) : ContDiff ℝ (⊤ : ℕ∞) (thetaProfile τ) := by
  convert Complex.contDiff_exp.comp (contDiff_const.mul (Complex.ofRealCLM.contDiff)) using 1

lemma neg_one_div_im_pos {τ : ℂ} (hτ : 0 < τ.im) : 0 < (-1 / τ).im := by
  simp +decide [div_eq_mul_inv, Complex.normSq_apply, hτ]
  nlinarith

lemma thetaProfile_iteratedDeriv (τ : ℂ) (n : ℕ) (r : ℝ) :
    iteratedDeriv n (thetaProfile τ) r =
      (((Real.pi : ℂ) * Complex.I * τ) ^ n) * thetaProfile τ r := by
  induction' n with n ih generalizing r <;> simp_all +decide [ pow_succ, mul_assoc, mul_comm, mul_left_comm, iteratedDeriv_succ ];
  convert HasDerivAt.deriv ( HasDerivAt.congr_of_eventuallyEq _ ( Filter.eventuallyEq_of_mem ( Metric.ball_mem_nhds r zero_lt_one ) fun x hx => ih x ) ) using 1;
  convert HasDerivAt.const_mul _ ( HasDerivAt.comp r ( Complex.hasDerivAt_exp _ ) ( HasDerivAt.const_mul _ ( hasDerivAt_id' r |> HasDerivAt.ofReal_comp ) ) ) using 1 ; ring_nf!;
  unfold thetaProfile; norm_num [ mul_assoc, mul_comm, mul_left_comm ] ;

private lemma exists_bound_pow_mul_exp_neg (k : ℕ) {a : ℝ} (ha : 0 < a) :
    ∃ C : ℝ, ∀ x : ℝ, 0 ≤ x → x ^ k * Real.exp (-a * x) ≤ C := by
  have hcont : Continuous (fun x : ℝ => x ^ k * Real.exp (-a * x)) := by fun_prop
  have hlim : Tendsto (fun x : ℝ => x ^ k * Real.exp (-a * x)) atTop (nhds 0) := by
    have h1 := tendsto_rpow_mul_exp_neg_mul_atTop_nhds_zero (s := (k : ℝ)) (b := a) ha
    simp only [Real.rpow_natCast] at h1
    exact h1
  obtain ⟨R, hR⟩ := eventually_atTop.mp (hlim.eventually (eventually_le_nhds one_pos))
  set R' := max R 0
  have hR'_nn : 0 ≤ R' := le_max_right _ _
  obtain ⟨x₀, _, hx₀_max⟩ := IsCompact.exists_isMaxOn (isCompact_Icc (a := 0) (b := R'))
    ⟨0, Set.left_mem_Icc.mpr hR'_nn⟩ hcont.continuousOn
  refine ⟨max (x₀ ^ k * Real.exp (-a * x₀)) 1, fun x hx => ?_⟩
  by_cases hxR : x ≤ R'
  · exact le_trans (hx₀_max ⟨hx, hxR⟩) (le_max_left _ _)
  · push_neg at hxR
    exact le_trans (hR x (le_trans (le_max_left R 0) hxR.le)) (le_max_right _ _)

lemma thetaProfile_decay (τ : ℂ) (hτ : 0 < τ.im) :
    ∀ (k n : ℕ), ∃ C, ∀ x : ℝ, 0 ≤ x →
      ‖x‖ ^ k * ‖iteratedFDeriv ℝ n (thetaProfile τ) x‖ ≤ C := by
  intro k n;
  -- By norm_iteratedFDeriv_eq_norm_iteratedDeriv and thetaProfile_iteratedDeriv, ‖iteratedFDeriv ℝ n f x‖ = ‖c^n * f x‖ = ‖c‖^n * ‖f x‖.
  have h_norm : ∀ x : ℝ, ‖iteratedFDeriv ℝ n (thetaProfile τ) x‖ = ‖((Real.pi : ℂ) * Complex.I * τ) ^ n * thetaProfile τ x‖ := by
    intro x; rw [ norm_iteratedFDeriv_eq_norm_iteratedDeriv ] ; rw [ thetaProfile_iteratedDeriv ] ;
  -- By norm_iteratedFDeriv_eq_norm_iteratedDeriv and thetaProfile_iteratedDeriv, ‖thetaProfile τ x‖ = exp(-π * τ.im * x).
  have h_norm_theta : ∀ x : ℝ, ‖thetaProfile τ x‖ = Real.exp (-Real.pi * τ.im * x) := by
    unfold thetaProfile; norm_num [ Complex.norm_exp ] ;
  -- By exists_bound_pow_mul_exp_neg with a = π * τ.im > 0, ∃ C₀, x^k * exp(-a*x) ≤ C₀.
  obtain ⟨C₀, hC₀⟩ : ∃ C₀ : ℝ, ∀ x : ℝ, 0 ≤ x → x ^ k * Real.exp (-Real.pi * τ.im * x) ≤ C₀ := by
    convert exists_bound_pow_mul_exp_neg k ( mul_pos Real.pi_pos hτ ) using 1;
    grind;
  use ‖((Real.pi : ℂ) * Complex.I * τ) ^ n‖ * C₀;
  intro x hx; specialize hC₀ x hx; simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ] ;
  rw [ abs_of_nonneg hx ] ; nlinarith [ show 0 ≤ ( |Real.pi| * ‖τ‖ ) ^ n by positivity ]

end CodeLatticeE8.SPL.ThetaProfile
