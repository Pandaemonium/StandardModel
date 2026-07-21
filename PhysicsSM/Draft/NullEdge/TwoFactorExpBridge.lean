import Mathlib

/-!
# MC3 two-factor exp(eps.A)exp(eps.B) bridge (Opus, verified cf645181)

Abstract Mathlib-only brick for the ladder audited in
`AutonomousLab/work/NE-3PLUS1/OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md`,
implementing that audit's section-4 'cheapest path' recommendation for MC3.
Contents: the envelope-to-quadratic conversion exp s - 1 - s <= s^2 exp s; a generic
complete-normed-algebra second-order remainder plus its 4x4 complex specialization;
and two_factor_product_bridge bounding the Lie-Trotter defect
||exp(eps.A) exp(eps.B) - exp(eps.(A+B))|| by an EXPLICIT constant times eps^2 with
NO commutation hypothesis, plus an eps-independent constant form for 0 <= eps <= 1.

The constant is explicit but generous (8 (1+E)^2 exp(2E) E^2 with E = ||A||+||B||);
it is fit for a rate theorem, not for a sharp-constant claim. Do not cite it as
optimal.

Offered to Codex for the MC3 integration (walk-agnostic; no MC file touched).
Namespace kept as the prover's TwoFactorExpBridge. Provenance: verified at pin from
task 69dd4ee3. Standard three. Claim grade M, [comp]. -/

open scoped Matrix.Norms.L2Operator
open scoped BigOperators

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace TwoFactorExpBridge

/-
The scalar exponential remainder is bounded by its quadratic envelope.
-/
theorem real_exp_sub_one_sub_le_quadratic (s : ℝ) (hs : 0 ≤ s) :
    Real.exp s - 1 - s ≤ s ^ 2 * Real.exp s := by
  nlinarith [ Real.exp_pos s, mul_inv_cancel₀ ( ne_of_gt ( Real.exp_pos s ) ), Real.exp_neg s, Real.add_one_le_exp s, Real.add_one_le_exp ( -s ), Real.exp_neg s, Real.exp_pos ( -s ), mul_le_mul_of_nonneg_left ( Real.add_one_le_exp ( s ) ) hs, mul_le_mul_of_nonneg_left ( Real.add_one_le_exp ( -s ) ) hs ]

/-
Second-order norm estimate for the exponential in a complete normed algebra.
-/
theorem norm_exp_sub_one_sub_le {𝔸 : Type*} [NormedRing 𝔸] [NormedAlgebra ℝ 𝔸]
    [CompleteSpace 𝔸] (X : 𝔸) :
    ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖ ^ 2 * Real.exp ‖X‖ := by
  by_contra! h_contra;
  -- Expand exp X as its absolutely convergent power series and remove n=0,1.
  have h_series : NormedSpace.exp X - 1 - X = ∑' n : ℕ, (1 / (Nat.factorial (n + 2)) : ℝ) • X ^ (n + 2) := by
    have h_series : NormedSpace.exp X = ∑' n : ℕ, (1 / (Nat.factorial n) : ℝ) • X ^ n := by
      simp +decide;
      convert NormedSpace.exp_eq_tsum using 1;
      constructor <;> intro h;
      convert NormedSpace.exp_eq_tsum;
      convert congr_fun ( h ℝ ) X using 1;
    rw [ h_series, ← Summable.sum_add_tsum_nat_add 2 ];
    · simp +decide [ Finset.sum_range_succ ];
      abel1;
    · contrapose! h_contra;
      refine' False.elim ( h_contra _ );
      refine' summable_of_ratio_norm_eventually_le _ _;
      exact 1 / 2;
      · norm_num;
      · simp +decide [ norm_smul, Nat.factorial_succ ];
        refine' ⟨ ⌈2 * ‖X‖⌉₊ + 1, fun n hn => _ ⟩ ; rw [ pow_succ' ] ; norm_cast ; norm_num ; ring_nf;
        rw [ mul_assoc, mul_assoc ];
        exact mul_le_mul_of_nonneg_left ( by rw [ inv_mul_le_iff₀ ( by positivity ) ] ; nlinarith [ Nat.le_ceil ( 2 * ‖X‖ ), show ( n : ℝ ) ≥ ⌈2 * ‖X‖⌉₊ + 1 by exact_mod_cast hn, norm_nonneg X, norm_nonneg ( X ^ n ), norm_mul_le X ( X ^ n ) ] ) ( by positivity );
  -- Bound termwise by ||X||^n/n!, whose tail is Real.exp ||X|| - 1 - ||X||.
  have h_bound : ‖∑' n : ℕ, (1 / (Nat.factorial (n + 2)) : ℝ) • X ^ (n + 2)‖ ≤ ∑' n : ℕ, (1 / (Nat.factorial (n + 2)) : ℝ) * ‖X‖ ^ (n + 2) := by
    have h_bound : ∀ n : ℕ, ‖(1 / (Nat.factorial (n + 2)) : ℝ) • X ^ (n + 2)‖ ≤ (1 / (Nat.factorial (n + 2)) : ℝ) * ‖X‖ ^ (n + 2) := by
      exact fun n => by rw [ norm_smul, Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_mul_of_nonneg_left ( norm_pow_le' _ <| by positivity ) <| by positivity;
    refine' le_trans ( norm_tsum_le_tsum_norm _ ) ( Summable.tsum_le_tsum h_bound _ _ );
    · exact Summable.of_nonneg_of_le ( fun n => norm_nonneg _ ) h_bound ( by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial ‖X‖ );
    · exact Summable.of_nonneg_of_le ( fun n => norm_nonneg _ ) h_bound ( by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial ‖X‖ );
    · simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _;
  -- Recognize that the series $\sum_{n=2}^{\infty} \frac{\|X\|^n}{n!}$ is the Taylor series for $e^{\|X\|}$ minus the first two terms.
  have h_taylor : ∑' n : ℕ, (1 / (Nat.factorial (n + 2)) : ℝ) * ‖X‖ ^ (n + 2) = Real.exp ‖X‖ - 1 - ‖X‖ := by
    norm_num [ Real.exp_eq_exp_ℝ, NormedSpace.exp_eq_tsum ];
    rw [ NormedSpace.exp_eq_tsum_div ] ; symm; rw [ Summable.tsum_eq_zero_add ] ; norm_num;
    · rw [ ← Summable.sum_add_tsum_nat_add 3 ];
      · norm_num [ Finset.sum_range_succ, div_eq_inv_mul ] ; ring;
      · exact Real.summable_pow_div_factorial _;
    · exact Summable.of_nonneg_of_le ( fun n => by positivity ) ( fun n => mul_le_mul_of_nonneg_left ( pow_le_pow_left₀ ( by positivity ) ( show ‖X‖ ≤ ‖X‖ + 1 by linarith ) _ ) ( by positivity ) ) ( by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _ );
  exact h_contra.not_ge ( h_series ▸ h_bound.trans ( h_taylor ▸ by nlinarith [ real_exp_sub_one_sub_le_quadratic ‖X‖ ( norm_nonneg X ) ] ) )

/-- A coarse exponential norm estimate, deduced solely from the second-order
remainder. -/
theorem norm_exp_le_coarse {𝔸 : Type*} [NormedRing 𝔸] [NormedAlgebra ℝ 𝔸]
    [CompleteSpace 𝔸] [NormOneClass 𝔸] (X : 𝔸) :
    ‖NormedSpace.exp X‖ ≤ 1 + ‖X‖ + ‖X‖ ^ 2 * Real.exp ‖X‖ := by
  have h₁ : ‖NormedSpace.exp X‖ ≤ ‖NormedSpace.exp X - 1 - X‖ + ‖X‖ + ‖(1 : 𝔸)‖ := by
    calc
      ‖NormedSpace.exp X‖ = ‖(NormedSpace.exp X - 1 - X) + X + 1‖ := by
        congr 1
        noncomm_ring
      _ ≤ ‖(NormedSpace.exp X - 1 - X) + X‖ + ‖(1 : 𝔸)‖ := norm_add_le _ _
      _ ≤ (‖NormedSpace.exp X - 1 - X‖ + ‖X‖) + ‖(1 : 𝔸)‖ := by
        gcongr
        exact norm_add_le _ _
  have h₂ := norm_exp_sub_one_sub_le X
  rw [norm_one] at h₁
  linarith

/-
A scalar accumulation estimate used to collect the four defect terms.
-/
theorem scalar_accumulation_bound (p q : ℝ) (hp : 0 ≤ p) (hq : 0 ≤ q) :
    p ^ 2 * Real.exp p * Real.exp q +
          (1 + p) * (q ^ 2 * Real.exp q) + p * q +
          (p + q) ^ 2 * Real.exp (p + q) ≤
      2 * (p + q) ^ 2 * Real.exp (p + q) := by
  -- Since $p \leq \exp p$, we have $p q^2 \leq q^2 \exp p$.
  have hp_exp : p ≤ Real.exp p := by
    linarith [ Real.add_one_le_exp p ]
  have h_ineq : p * q^2 ≤ q^2 * Real.exp p := by
    nlinarith;
  rw [ Real.exp_add ];
  nlinarith [ mul_nonneg hp hq, mul_le_mul_of_nonneg_left hp_exp hq, mul_le_mul_of_nonneg_left hp_exp hp, Real.add_one_le_exp p, Real.add_one_le_exp q, mul_le_mul_of_nonneg_left ( Real.add_one_le_exp p ) ( Real.exp_nonneg q ), mul_le_mul_of_nonneg_left ( Real.add_one_le_exp q ) ( Real.exp_nonneg p ) ]

abbrev Mat4C := Matrix (Fin 4) (Fin 4) ℂ

/-- The requested second-order exponential remainder for `4 × 4` complex matrices,
with the scoped L2 operator norm. -/
theorem matrix_norm_exp_sub_one_sub_le (X : Mat4C) :
    ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖ ^ 2 * Real.exp ‖X‖ := by
  exact norm_exp_sub_one_sub_le X

/-
Lie--Trotter two-factor defect, with an explicit bound valid for every
nonnegative `eps`.  No commutation hypothesis is used.
-/
theorem two_factor_product_bridge (A B : Mat4C) (eps : ℝ) (heps : 0 ≤ eps) :
    ‖NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) -
        NormedSpace.exp (eps • (A + B))‖ ≤
      8 * (1 + eps * (‖A‖ + ‖B‖)) ^ 2 *
        Real.exp (2 * eps * (‖A‖ + ‖B‖)) *
        (‖A‖ + ‖B‖) ^ 2 * eps ^ 2 := by
  -- Use the triangle inequality and the bounds from `norm_exp_sub_one_sub_le` and `norm_exp_le_coarse`.
  have h_triangle : ‖NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) - NormedSpace.exp (eps • (A + B))‖ ≤ ‖NormedSpace.exp (eps • A) - 1 - eps • A‖ * (1 + ‖eps • B‖ + ‖eps • B‖ ^ 2 * Real.exp ‖eps • B‖) + ‖eps • A‖ * ‖NormedSpace.exp (eps • B) - 1 - eps • B‖ + ‖eps • A‖ * ‖eps • B‖ + ‖NormedSpace.exp (eps • B) - 1 - eps • B‖ + ‖NormedSpace.exp (eps • (A + B)) - 1 - eps • (A + B)‖ := by
    -- Use the algebra identity: Ex*Ey-Ez = (Ex-1-x)*Ey + x*(Ey-1-y) + x*y + (Ey-1-y) - (Ez-1-z).
    have h_identity : NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) - NormedSpace.exp (eps • (A + B)) = (NormedSpace.exp (eps • A) - 1 - eps • A) * NormedSpace.exp (eps • B) + eps • A * (NormedSpace.exp (eps • B) - 1 - eps • B) + eps • A * eps • B + (NormedSpace.exp (eps • B) - 1 - eps • B) - (NormedSpace.exp (eps • (A + B)) - 1 - eps • (A + B)) := by
      simp +decide [sub_mul, mul_sub, smul_add] ; abel_nf;
    rw [h_identity];
    refine' le_trans ( norm_sub_le _ _ ) ( add_le_add ( le_trans ( norm_add_le _ _ ) ( add_le_add ( le_trans ( norm_add_le _ _ ) ( add_le_add ( le_trans ( norm_add_le _ _ ) ( add_le_add ( _ ) ( _ ) ) ) ( _ ) ) ) ( _ ) ) ) ( _ ) );
    · refine' le_trans ( norm_mul_le _ _ ) ( mul_le_mul_of_nonneg_left _ ( norm_nonneg _ ) );
      convert norm_exp_le_coarse ( eps • B ) using 1;
    · exact norm_mul_le _ _;
    · exact norm_mul_le _ _;
    · norm_num;
    · rfl;
  -- Apply the bounds from `norm_exp_sub_one_sub_le` and `norm_exp_le_coarse`.
  have h_bounds : ‖NormedSpace.exp (eps • A) - 1 - eps • A‖ ≤ ‖eps • A‖ ^ 2 * Real.exp ‖eps • A‖ ∧ ‖NormedSpace.exp (eps • B) - 1 - eps • B‖ ≤ ‖eps • B‖ ^ 2 * Real.exp ‖eps • B‖ ∧ ‖NormedSpace.exp (eps • (A + B)) - 1 - eps • (A + B)‖ ≤ ‖eps • (A + B)‖ ^ 2 * Real.exp ‖eps • (A + B)‖ := by
    exact ⟨ matrix_norm_exp_sub_one_sub_le _, matrix_norm_exp_sub_one_sub_le _, matrix_norm_exp_sub_one_sub_le _ ⟩;
  -- Apply the bounds from `norm_smul` and `norm_add_le`.
  have h_smul_add : ‖eps • A‖ = eps * ‖A‖ ∧ ‖eps • B‖ = eps * ‖B‖ ∧ ‖eps • (A + B)‖ ≤ eps * (‖A‖ + ‖B‖) := by
    exact ⟨ by rw [ norm_smul, Real.norm_of_nonneg heps ], by rw [ norm_smul, Real.norm_of_nonneg heps ], by rw [ norm_smul, Real.norm_of_nonneg heps ] ; exact mul_le_mul_of_nonneg_left ( norm_add_le _ _ ) heps ⟩;
  -- Substitute the bounds from `h_bounds` and `h_smul_add` into the triangle inequality.
  have h_subst : ‖NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) - NormedSpace.exp (eps • (A + B))‖ ≤ (eps * ‖A‖) ^ 2 * Real.exp (eps * ‖A‖) * (1 + eps * ‖B‖ + (eps * ‖B‖) ^ 2 * Real.exp (eps * ‖B‖)) + (eps * ‖A‖) * (eps * ‖B‖) ^ 2 * Real.exp (eps * ‖B‖) + (eps * ‖A‖) * (eps * ‖B‖) + (eps * ‖B‖) ^ 2 * Real.exp (eps * ‖B‖) + (eps * (‖A‖ + ‖B‖)) ^ 2 * Real.exp (eps * (‖A‖ + ‖B‖)) := by
    refine le_trans h_triangle ?_;
    refine' add_le_add ( add_le_add ( add_le_add ( add_le_add _ _ ) _ ) _ ) _;
    · gcongr <;> aesop;
    · convert mul_le_mul_of_nonneg_left h_bounds.2.1 ( norm_nonneg ( eps • A ) ) using 1 ; rw [ h_smul_add.1, h_smul_add.2.1 ] ; ring;
    · rw [ h_smul_add.1, h_smul_add.2.1 ];
    · aesop;
    · exact le_trans h_bounds.2.2 ( mul_le_mul ( pow_le_pow_left₀ ( norm_nonneg _ ) h_smul_add.2.2 2 ) ( Real.exp_le_exp.mpr h_smul_add.2.2 ) ( by positivity ) ( by positivity ) );
  refine le_trans h_subst ?_;
  -- Apply the bounds from `scalar_accumulation_bound`.
  have h_scalar_bound : ∀ p q : ℝ, 0 ≤ p → 0 ≤ q → p ^ 2 * Real.exp p * (1 + q + q ^ 2 * Real.exp q) + p * q ^ 2 * Real.exp q + p * q + q ^ 2 * Real.exp q + (p + q) ^ 2 * Real.exp (p + q) ≤ 8 * (1 + p + q) ^ 2 * Real.exp (2 * (p + q)) * (p + q) ^ 2 := by
    intro p q hp hq;
    refine le_trans ?_ ( mul_le_mul_of_nonneg_right ( mul_le_mul_of_nonneg_left ( show Real.exp ( 2 * ( p + q ) ) ≥ Real.exp ( p + q ) by exact Real.exp_le_exp.mpr ( by linarith ) ) ( by positivity ) ) ( by positivity ) );
    rw [ Real.exp_add ];
    nlinarith only [ show 0 ≤ p * q ^ 2 * Real.exp q by positivity, show 0 ≤ p * q by positivity, show 0 ≤ q ^ 2 * Real.exp q by positivity, show 0 ≤ p ^ 2 * Real.exp p by positivity, show 0 ≤ q ^ 2 * Real.exp p by positivity, show 0 ≤ p * q * Real.exp p by positivity, show 0 ≤ p * q * Real.exp q by positivity, show 0 ≤ p ^ 2 * Real.exp p * Real.exp q by positivity, show 0 ≤ q ^ 2 * Real.exp p * Real.exp q by positivity, Real.add_one_le_exp p, Real.add_one_le_exp q, hp, hq ];
  convert h_scalar_bound ( eps * ‖A‖ ) ( eps * ‖B‖ ) ( by positivity ) ( by positivity ) using 1 <;> ring

/-
A genuinely `eps`-independent constant, obtained on the usual range
`0 ≤ eps ≤ 1`.
-/
theorem two_factor_product_bridge_unit (A B : Mat4C) (eps : ℝ)
    (heps : 0 ≤ eps) (heps1 : eps ≤ 1) :
    ‖NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) -
        NormedSpace.exp (eps • (A + B))‖ ≤
      (8 * (1 + (‖A‖ + ‖B‖)) ^ 2 *
        Real.exp (2 * (‖A‖ + ‖B‖)) * (‖A‖ + ‖B‖) ^ 2) * eps ^ 2 := by
  convert two_factor_product_bridge A B eps heps |> le_trans <| ?_ using 1;
  gcongr;
  · exact mul_le_of_le_one_left ( by positivity ) heps1;
  · linarith

end TwoFactorExpBridge
