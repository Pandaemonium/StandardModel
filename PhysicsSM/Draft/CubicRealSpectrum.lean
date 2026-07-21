import Mathlib

/-!
# Real spectrum of a real cubic with nonnegative discriminant

**Provenance:** proven by Aristotle (job 9d6a0a84, harvested + VERIFIED
VERBATIM at the repo pin 2026-07-18: 0 errors, 0 sorries, standard-three axiom
audit on both theorems). Route: IVT real root via polynomial asymptotics,
linear/quadratic factorization at the root, cubic-discriminant factor identity,
quadratic formula over `Real.sqrt`. Plan P7 step 1
(`Sources/Null_Edge_Ten_Priorities_Research_Plan_2026-07-18.md`).

Support lemma for the exceptional-Jordan-algebra `h3(O)` spectral program: the
characteristic cubic of a Jordan-hermitian element has three real eigenvalues.
This file is the Mathlib-only analytic core: a real cubic with nonnegative
discriminant splits over `R` (all three roots real, with multiplicity).
-/

namespace CubicRealSpectrum

open Polynomial

set_option maxHeartbeats 1000000

private lemma real_cubic_exists_root (P : Cubic ℝ) (ha : P.a ≠ 0) :
    ∃ r : ℝ, P.toPoly.eval r = 0 := by
  by_cases h_pos : 0 < P.a;
  · -- Since $P.a > 0$, we have $\lim_{x \to \infty} P(x) = \infty$ and $\lim_{x \to -\infty} P(x) = -\infty$.
    have h_lim_inf : Filter.Tendsto (fun x : ℝ => P.toPoly.eval x) Filter.atTop Filter.atTop := by
      convert P.toPoly.tendsto_atTop_of_leadingCoeff_nonneg _ using 1;
      · simp +decide [ Cubic.toPoly, ha ];
        exact Or.inl h_pos.le;
      · rw [ Cubic.degree_of_a_ne_zero ha ] ; norm_num
    have h_lim_neg_inf : Filter.Tendsto (fun x : ℝ => P.toPoly.eval x) Filter.atBot Filter.atBot := by
      have h_lim_neg_inf : Filter.Tendsto (fun x : ℝ => P.toPoly.comp (-Polynomial.X) |> Polynomial.eval x) Filter.atTop Filter.atBot := by
        have h_lim_neg_inf : Polynomial.leadingCoeff (P.toPoly.comp (-Polynomial.X)) < 0 := by
          simp_all +decide [ Polynomial.leadingCoeff_comp ];
        have h_lim_neg_inf : Polynomial.natDegree (P.toPoly.comp (-Polynomial.X)) = 3 := by
          rw [ Polynomial.natDegree_comp, Polynomial.natDegree_neg, Polynomial.natDegree_X, Cubic.natDegree_of_a_ne_zero ha ];
        rw [ Polynomial.tendsto_atBot_iff_leadingCoeff_nonpos ];
        exact ⟨ Polynomial.natDegree_pos_iff_degree_pos.mp ( by linarith ), le_of_lt ‹_› ⟩;
      convert h_lim_neg_inf.comp Filter.tendsto_neg_atBot_atTop using 2 ; norm_num;
    -- By the Intermediate Value Theorem, since $P$ is continuous and tends to $+\infty$ as $x$ tends to $+\infty$ and $-\infty$ as $x$ tends to $-\infty$, there must be some $r$ such that $P(r) = 0$.
    have h_ivt : IsConnected (Set.range (fun x : ℝ => P.toPoly.eval x)) := by
      exact isConnected_range ( by exact P.toPoly.continuous );
    exact h_ivt.Icc_subset ( Set.mem_range_self <| Classical.choose <| Filter.Eventually.exists <| h_lim_neg_inf.eventually ( Filter.eventually_lt_atBot 0 ) ) ( Set.mem_range_self <| Classical.choose <| Filter.Eventually.exists <| h_lim_inf.eventually_gt_atTop 0 ) ⟨ by linarith [ Classical.choose_spec <| Filter.Eventually.exists <| h_lim_neg_inf.eventually ( Filter.eventually_lt_atBot 0 ) ], by linarith [ Classical.choose_spec <| Filter.Eventually.exists <| h_lim_inf.eventually_gt_atTop 0 ] ⟩;
  · -- Since $P.a < 0$, we have $P.toPoly(x) \to -\infty$ as $x \to +\infty$ and $P.toPoly(x) \to +\infty$ as $x \to -\infty$.
    have h_tendsto_neg_infty : Filter.Tendsto (fun x : ℝ => P.toPoly.eval x) Filter.atTop Filter.atBot := by
      rw [ Polynomial.tendsto_atBot_iff_leadingCoeff_nonpos ];
      simp_all +decide [ Cubic.toPoly ]
    have h_tendsto_pos_infty : Filter.Tendsto (fun x : ℝ => P.toPoly.eval x) Filter.atBot Filter.atTop := by
      have h_tendsto_pos_infty : Filter.Tendsto (fun x : ℝ => P.toPoly.eval (-x)) Filter.atTop Filter.atTop := by
        have h_tendsto_pos_infty : Filter.Tendsto (fun x : ℝ => Polynomial.eval x (P.toPoly.comp (-Polynomial.X))) Filter.atTop Filter.atTop := by
          rw [ Polynomial.tendsto_atTop_iff_leadingCoeff_nonneg ];
          simp_all +decide [ Polynomial.leadingCoeff_comp, Polynomial.natDegree_neg ];
        aesop;
      convert h_tendsto_pos_infty.comp Filter.tendsto_neg_atBot_atTop using 2 ; norm_num;
    -- By the Intermediate Value Theorem, since $P.toPoly(x)$ tends to $-\infty$ as $x \to +\infty$ and $+\infty$ as $x \to -\infty$, there exists some $r \in \mathbb{R}$ such that $P.toPoly(r) = 0$.
    have h_ivt : IsConnected (Set.range (fun x : ℝ => P.toPoly.eval x)) := by
      exact isConnected_range ( by exact P.toPoly.continuous );
    exact h_ivt.Icc_subset ( Set.mem_range_self <| Classical.choose <| Filter.Eventually.exists <| h_tendsto_neg_infty.eventually ( Filter.eventually_le_atBot 0 ) ) ( Set.mem_range_self <| Classical.choose <| Filter.Eventually.exists <| h_tendsto_pos_infty.eventually ( Filter.eventually_ge_atTop 0 ) ) ⟨ by linarith [ Classical.choose_spec <| Filter.Eventually.exists <| h_tendsto_neg_infty.eventually ( Filter.eventually_le_atBot 0 ) ], by linarith [ Classical.choose_spec <| Filter.Eventually.exists <| h_tendsto_pos_infty.eventually ( Filter.eventually_ge_atTop 0 ) ] ⟩

private lemma quadratic_factor_of_discr_nonneg (a b c : ℝ) (ha : a ≠ 0)
    (hd : 0 ≤ discrim a b c) :
    ∃ x y : ℝ,
      C a * X ^ 2 + C b * X + C c = C a * (X - C x) * (X - C y) := by
  refine' ⟨ ( -b - Real.sqrt ( discrim a b c ) ) / ( 2 * a ), ( -b + Real.sqrt ( discrim a b c ) ) / ( 2 * a ), Polynomial.funext fun x => _ ⟩ ; norm_num ; ring;
  rw [ Real.sq_sqrt ( by linarith ) ] ; norm_num [ ha, sq, mul_assoc, mul_comm a ] ; ring;
  unfold discrim; ring;
  rw [ mul_right_comm, mul_inv_cancel₀ ha, one_mul ]

private lemma cubic_factor_at_root (P : Cubic ℝ) (r : ℝ)
    (hr : P.toPoly.eval r = 0) :
    P.toPoly = (X - C r) *
      (C P.a * X ^ 2 + C (P.b + P.a * r) * X +
        C (P.c + P.b * r + P.a * r ^ 2)) := by
  norm_num [ Cubic.toPoly ] at hr ⊢;
  exact Polynomial.funext fun x => by norm_num; linear_combination hr;

private lemma cubic_discr_factor_at_root (P : Cubic ℝ) (r : ℝ)
    (hr : P.toPoly.eval r = 0) :
    P.discr =
      discrim P.a (P.b + P.a * r) (P.c + P.b * r + P.a * r ^ 2) *
        (3 * P.a * r ^ 2 + 2 * P.b * r + P.c) ^ 2 := by
  unfold Cubic.discr Cubic.toPoly at *; simp_all +decide [ discrim ] ; ring;
  grind

/-- A real cubic with `a != 0` and nonnegative discriminant has all three
roots real: its real root multiset has the full cardinality-three form.
-/
theorem cubic_real_splits_of_discr_nonneg (P : Cubic ℝ)
    (ha : P.a ≠ 0) (hd : 0 ≤ P.discr) :
    ∃ x y z : ℝ, P.roots = {x, y, z} := by
  -- By definition of $P$, we know that its roots are precisely the roots of its characteristic polynomial.
  have h_char : P.roots = Multiset.map (fun x => x) (Polynomial.roots (P.toPoly)) := by
    simp +decide [ Cubic.roots ];
  -- By definition of $P$, we know that its roots are precisely the roots of its characteristic polynomial, which is a cubic polynomial.
  have h_cubic : ∃ x y z : ℝ, P.toPoly = Polynomial.C P.a * (Polynomial.X - Polynomial.C x) * (Polynomial.X - Polynomial.C y) * (Polynomial.X - Polynomial.C z) := by
    obtain ⟨r, hr⟩ : ∃ r : ℝ, P.toPoly.eval r = 0 := by
      exact real_cubic_exists_root P ha
    have h_factor : P.toPoly = (Polynomial.X - Polynomial.C r) * (Polynomial.C P.a * Polynomial.X ^ 2 + Polynomial.C (P.b + P.a * r) * Polynomial.X + Polynomial.C (P.c + P.b * r + P.a * r ^ 2)) := by
      convert cubic_factor_at_root P r hr using 1
    have h_discriminant : discrim P.a (P.b + P.a * r) (P.c + P.b * r + P.a * r ^ 2) ≥ 0 := by
      have h_discriminant : P.discr = discrim P.a (P.b + P.a * r) (P.c + P.b * r + P.a * r ^ 2) * (3 * P.a * r ^ 2 + 2 * P.b * r + P.c) ^ 2 := by
        convert cubic_discr_factor_at_root P r hr using 1;
      by_cases h : 3 * P.a * r ^ 2 + 2 * P.b * r + P.c = 0 <;> simp_all +decide [ sq ];
      unfold discrim; ring_nf;
      cases lt_or_gt_of_ne ha <;> nlinarith [ sq_nonneg ( P.b + 3 * P.a * r ) ]
    have h_quadratic_factor : ∃ x y : ℝ, Polynomial.C P.a * Polynomial.X ^ 2 + Polynomial.C (P.b + P.a * r) * Polynomial.X + Polynomial.C (P.c + P.b * r + P.a * r ^ 2) = Polynomial.C P.a * (Polynomial.X - Polynomial.C x) * (Polynomial.X - Polynomial.C y) := by
      exact quadratic_factor_of_discr_nonneg P.a (P.b + P.a * r)
        (P.c + P.b * r + P.a * r ^ 2) ha h_discriminant
    obtain ⟨x, y, hxy⟩ := h_quadratic_factor
    use r, x, y
    rw [h_factor, hxy]
    ring;
  obtain ⟨ x, y, z, h ⟩ := h_cubic; use x, y, z; rw [ h_char, h ] ; simp +decide [ ha, Polynomial.roots_mul, Polynomial.X_sub_C_ne_zero ] ;

/-- Monic specialization (the `h3(O)` characteristic-cubic shape
`X^3 + b X^2 + c X + d`): nonnegative discriminant gives three real
eigenvalues. -/
theorem monic_cubic_real_spectrum_of_discr_nonneg (b c d : ℝ)
    (hd : 0 ≤ (⟨1, b, c, d⟩ : Cubic ℝ).discr) :
    ∃ x y z : ℝ, (⟨1, b, c, d⟩ : Cubic ℝ).roots = {x, y, z} := by
  exact cubic_real_splits_of_discr_nonneg ⟨1, b, c, d⟩ one_ne_zero hd

end CubicRealSpectrum
/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'CubicRealSpectrum.cubic_real_splits_of_discr_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms CubicRealSpectrum.cubic_real_splits_of_discr_nonneg

/-- info: 'CubicRealSpectrum.monic_cubic_real_spectrum_of_discr_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms CubicRealSpectrum.monic_cubic_real_spectrum_of_discr_nonneg
