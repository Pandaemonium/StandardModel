import Mathlib

/-!
# Focused target: quantitative many-step Dirac-walk convergence

Prove the fixed-momentum continuum theorem for the explicit `2 x 2` split-step
walk.  The target norm is Mathlib's Euclidean (`L2`) matrix operator norm.  The
result must keep the explicit local remainder, prove both steps unitary, use a
unitary telescope with no exponential-in-`n` loss, and identify the `n`th power
of the exact short-time flow with the exact time-`t` flow.

This is a fixed-momentum matrix theorem.  It is not a spacetime propagator,
uniform-in-momentum estimate, PDE convergence theorem, or `3+1` result.

Provenance: prepared in the 2026-07-09 all-mass run and completed by Aristotle
project `3906ed40-adf5-4d47-a46b-bd979c70cfba`. The source was independently
checked under the repository's pinned Lean toolchain before integration.
-/

noncomputable section

open Matrix Complex Real Filter Topology
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.FixedMomentumManyStepContinuum

abbrev Mat := Matrix (Fin 2) (Fin 2) ℂ

def sigmaX : Mat := !![0, 1; 1, 0]
def sigmaZ : Mat := !![1, 0; 0, -1]

def shift (q : ℝ) : Mat :=
  !![(Real.cos q : ℂ) - I * Real.sin q, 0;
     0, (Real.cos q : ℂ) + I * Real.sin q]

def coin (r : ℝ) : Mat :=
  !![(Real.cos r : ℂ), -I * Real.sin r;
     -I * Real.sin r, (Real.cos r : ℂ)]

def walk (q r : ℝ) : Mat := shift q * coin r

def H (k m : ℝ) : Mat := (k : ℂ) • sigmaZ + (m : ℂ) • sigmaX

def firstOrder (k m eps : ℝ) : Mat :=
  1 - (I * (eps : ℂ)) • H k m

def exactFlow (k m t : ℝ) : Mat :=
  NormedSpace.exp ((-(t : ℂ)) • (I • H k m))

def entryMax (A : Mat) : ℝ :=
  max (max ‖A 0 0‖ ‖A 0 1‖) (max ‖A 1 0‖ ‖A 1 1‖)

def Ckm (k m : ℝ) : ℝ :=
  2 * k ^ 2 + 2 * m ^ 2 + |k| * m ^ 2 + k ^ 2 * |m| + |k| * |m|

/-- A deliberately generous explicit constant absorbing the entrywise walk
remainder, conversion to the L2 operator norm, and the exponential remainder. -/
def Dkm (k m : ℝ) : ℝ :=
  4 * Ckm k m +
    4 * (|k| + |m|) ^ 2 * Real.exp (|k| + |m|)

theorem Dkm_nonneg (k m : ℝ) : 0 ≤ Dkm k m := by
  exact add_nonneg ( mul_nonneg zero_le_four ( by unfold Ckm; positivity ) ) ( mul_nonneg ( by positivity ) ( Real.exp_nonneg _ ) )

/-
The L2 operator norm is controlled by twice the largest matrix entry in
dimension two.
-/
theorem l2_opNorm_le_two_entryMax (A : Mat) :
    ‖A‖ ≤ 2 * entryMax A := by
  -- Let `c = entryMax A`, so `‖A i j‖ ≤ c` for all `i,j` (from the four `le_max` facts). Note `0 ≤ c`.
  set c := entryMax A with hc
  have hc_nonneg : 0 ≤ c := by
    exact le_max_of_le_left ( le_max_of_le_left ( norm_nonneg _ ) );
  -- By definition of $c$, we know that for all $i, j$, $‖A i j‖ ≤ c$.
  have h_bound : ∀ i j, ‖A i j‖ ≤ c := by
    intro i j; fin_cases i <;> fin_cases j <;> unfold entryMax at * <;> aesop;
  convert ContinuousLinearMap.opNorm_le_bound _ _ _ using 1;
  · positivity;
  · intro x; erw [ EuclideanSpace.norm_eq ] ; simp +decide [ Fin.sum_univ_two, Matrix.mulVec ] ; ring_nf; (
    -- Apply the triangle inequality and the bound on the entries of $A$.
    have h_triangle : ‖A 0 0 * x.ofLp 0 + A 0 1 * x.ofLp 1‖ ≤ c * (‖x.ofLp 0‖ + ‖x.ofLp 1‖) ∧ ‖x.ofLp 0 * A 1 0 + x.ofLp 1 * A 1 1‖ ≤ c * (‖x.ofLp 0‖ + ‖x.ofLp 1‖) := by
      refine' ⟨ le_trans ( norm_add_le _ _ ) _, le_trans ( norm_add_le _ _ ) _ ⟩ <;> norm_num [ mul_add, mul_comm ]; all_goals exact add_le_add ( mul_le_mul_of_nonneg_right ( h_bound _ _ ) ( norm_nonneg _ ) ) ( mul_le_mul_of_nonneg_right ( h_bound _ _ ) ( norm_nonneg _ ) );
    rw [ EuclideanSpace.norm_eq ] ; norm_num [ Fin.sum_univ_two ] ; ring_nf at * ; (
    rw [ Real.sqrt_le_iff ] ; ring_nf at * ; norm_num at *;
    exact ⟨ by positivity, by rw [ Real.sq_sqrt <| by positivity ] ; nlinarith [ sq_nonneg ( ‖x.ofLp 0‖ - ‖x.ofLp 1‖ ), mul_nonneg hc_nonneg <| norm_nonneg <| x.ofLp 0, mul_nonneg hc_nonneg <| norm_nonneg <| x.ofLp 1, pow_le_pow_left₀ ( by positivity ) h_triangle.1 2, pow_le_pow_left₀ ( by positivity ) h_triangle.2 2 ] ⟩););

/-
The explicit split-step walk is unitary for real angles.
-/
theorem walk_mem_unitary (q r : ℝ) :
    walk q r ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  refine' ⟨ _, _ ⟩;
  · unfold walk;
    unfold shift coin;
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Matrix.mul_apply ];
    · norm_cast; ring_nf; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
    · constructor <;> ring;
    · constructor <;> ring;
    · norm_cast; ring_nf; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, walk ] <;> ring;
    · unfold shift coin; norm_num [ Complex.ext_iff ] ; ring; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
      norm_cast; nlinarith [ Real.sin_sq_add_cos_sq q, Real.sin_sq_add_cos_sq r ] ;
    · unfold shift coin; norm_num [ Complex.ext_iff ] ; ring;
      norm_num;
    · unfold shift coin; norm_num [ Complex.ext_iff ] ; ring;
      grind;
    · unfold shift coin; norm_num [ Complex.ext_iff ] ; ring; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
      norm_cast; nlinarith [ Real.sin_sq_add_cos_sq q, Real.sin_sq_add_cos_sq r ] ;

/-
The continuum Dirac symbol is Hermitian.
-/
theorem H_isHermitian (k m : ℝ) : (H k m).IsHermitian := by
  unfold H;
  unfold sigmaZ sigmaX; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff ] ;

/-
The exact Hermitian-generated flow is unitary.
-/
theorem exactFlow_mem_unitary (k m t : ℝ) :
    exactFlow k m t ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  convert NormedSpace.exp_mem_unitary_of_mem_skewAdjoint _;
  · refine' { .. };
    intro r x; exact (by
    convert norm_smul_le ( r : ℝ ) x using 1);
  · infer_instance;
  · infer_instance;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ H, sigmaX, sigmaZ, Matrix.mul_apply ] ;

/-
`1 - cos x` is bounded by `x^2 / 2`.
-/
theorem abs_one_sub_cos_le (x : ℝ) : |1 - Real.cos x| ≤ x ^ 2 / 2 := by
  -- Apply the lemma Real.one_sub_sq_div_two_le_cos to get 1 - x^2 / 2 ≤ Real.cos x.
  have h_cos_bound : 1 - x^2 / 2 ≤ Real.cos x := by
    apply Real.one_sub_sq_div_two_le_cos;
  exact abs_le.mpr ⟨ by linarith [ Real.cos_le_one x ], by linarith [ Real.cos_le_one x ] ⟩

/-
`x - sin x` is bounded by `x^2 / 2`.
-/
theorem abs_sub_sin_le (x : ℝ) : |x - Real.sin x| ≤ x ^ 2 / 2 := by
  by_contra! h_contra;
  -- Consider the function $g(x) = x^2 / 2 - x + \sin x$ and show that $g(x) \geq 0$ for all $x \geq 0$.
  have h_g_nonneg : ∀ x : ℝ, 0 ≤ x → x^2 / 2 - x + Real.sin x ≥ 0 := by
    -- We'll use the fact that $g'(x) = x - 1 + \cos x \geq 0$ for $x \geq 0$.
    have h_g_deriv_nonneg : ∀ x : ℝ, 0 ≤ x → x - 1 + Real.cos x ≥ 0 := by
      intro x hx_nonneg
      have h_cos_bound : ∀ x : ℝ, 0 ≤ x → Real.cos x ≥ 1 - x^2 / 2 := by
        exact?;
      nlinarith [ h_cos_bound x hx_nonneg, Real.cos_sq' x ];
    -- Integrate $g'(x) = x - 1 + \cos x$ from $0$ to $x$ to find $g(x)$.
    have h_g_integral : ∀ x : ℝ, 0 ≤ x → ∫ t in (0 : ℝ)..x, (t - 1 + Real.cos t) = x^2 / 2 - x + Real.sin x := by
      norm_num;
    exact fun x hx => h_g_integral x hx ▸ intervalIntegral.integral_nonneg ( by linarith ) fun t ht => h_g_deriv_nonneg t ( by linarith [ ht.1 ] );
  cases abs_cases ( x - Real.sin x ) <;> simp_all +decide;
  · by_cases hx : 0 ≤ x;
    · linarith [ h_g_nonneg x hx ];
    · nlinarith [ Real.sin_lt ( neg_pos.mpr ( lt_of_not_ge hx ) ), Real.sin_neg x ];
  · by_cases hx : x < 0;
    · have := h_g_nonneg ( -x ) ( by linarith ) ; norm_num at * ; nlinarith [ Real.sin_neg x ] ;
    · nlinarith [ Real.sin_lt <| show 0 < x from lt_of_le_of_ne ( le_of_not_gt hx ) ( Ne.symm <| by rintro rfl; norm_num at h_contra ) ]

/-
Operator-norm bound on the Dirac symbol.
-/
theorem norm_H_le (k m : ℝ) : ‖H k m‖ ≤ |k| + |m| := by
  -- By definition of $H$, we know that $H k m = k • sigmaZ + m • sigmaX$.
  have h_H : H k m = (k : ℂ) • sigmaZ + (m : ℂ) • sigmaX := by
    rfl;
  -- By definition of $sigmaZ$ and $sigmaX$, we know that they are unitary matrices.
  have h_sigmaZ_unitary : ‖sigmaZ‖ ≤ 1 := by
    refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => _;
    simp +decide [ EuclideanSpace.norm_eq, sigmaZ ];
    rfl
  have h_sigmaX_unitary : ‖sigmaX‖ ≤ 1 := by
    refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => _;
    simp +decide [ EuclideanSpace.norm_eq, sigmaX ];
    exact Real.sqrt_le_sqrt ( by linarith! );
  refine' h_H ▸ le_trans ( norm_add_le _ _ ) _;
  norm_num [ norm_smul, h_sigmaZ_unitary, h_sigmaX_unitary ];
  exact add_le_add ( mul_le_of_le_one_right ( abs_nonneg k ) h_sigmaZ_unitary ) ( mul_le_of_le_one_right ( abs_nonneg m ) h_sigmaX_unitary )

/-
Banach-algebra exponential-series second-order remainder bound.
-/
theorem norm_exp_sub_one_sub_le (X : Mat) :
    ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖ ^ 2 / 2 * Real.exp ‖X‖ := by
  -- Let $A = \exp X - I - X$.
  set A := NormedSpace.exp X - 1 - X with hA_def;
  -- We'll use the fact that $A = \sum_{n=2}^\infty \frac{X^n}{n!}$ to bound the norm of $A$.
  have hA_series : A = ∑' n : ℕ, (1 / (Nat.factorial (n + 2)) : ℂ) • X ^ (n + 2) := by
    have hA_series : A = ∑' n : ℕ, (1 / (Nat.factorial n) : ℂ) • X ^ n - 1 - X := by
      convert rfl;
      norm_num [ NormedSpace.exp_eq_tsum ];
      grind +suggestions;
    rw [ hA_series, ← Summable.sum_add_tsum_nat_add 2 ];
    · norm_num [ Finset.sum_range_succ ] ; abel1;
    · refine' .of_norm _;
      -- We'll use the fact that |X^n| ≤ |X|^n for any matrix X.
      have h_norm_pow : ∀ n : ℕ, ‖X ^ n‖ ≤ ‖X‖ ^ n := by
        exact?;
      simp_all +decide [ norm_smul ];
      exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow n ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using Real.summable_pow_div_factorial ‖X‖ );
  -- We'll use the fact that $\|X^{n+2}\| \leq \|X\|^{n+2}$ to bound the norm of $A$.
  have hA_norm : ‖A‖ ≤ ∑' n : ℕ, (‖X‖ ^ (n + 2) / (Nat.factorial (n + 2)) : ℝ) := by
    refine' hA_series ▸ le_trans ( norm_tsum_le_tsum_norm _ ) _;
    · -- We'll use the fact that ‖X^(n+2)‖ ≤ ‖X‖^(n+2) to bound the norm of the series.
      have h_norm_pow : ∀ n : ℕ, ‖X ^ (n + 2)‖ ≤ ‖X‖ ^ (n + 2) := by
        intro n;
        exact?;
      simp_all +decide [ norm_smul ];
      exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow n ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _ );
    · refine' Summable.tsum_le_tsum _ _ _;
      · intro n; rw [ norm_smul, norm_div ] ; norm_num ; ring_nf;
        rw [ mul_assoc ] ; gcongr ; ring_nf ;
        rw [ ← pow_add ] ; exact norm_pow_le' _ ( by norm_num ) ;
      · -- We'll use the fact that |X^n| ≤ |X|^n for any matrix X.
        have h_norm_pow : ∀ n : ℕ, ‖X ^ n‖ ≤ ‖X‖ ^ n := by
          intro n; induction n <;> simp_all +decide [ pow_succ' ] ;
          exact le_trans ( norm_mul_le _ _ ) ( mul_le_mul_of_nonneg_left ‹_› ( norm_nonneg _ ) );
        norm_num [ norm_smul ];
        exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow _ ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _ );
      · exact Real.summable_pow_div_factorial _ |> Summable.comp_injective <| add_left_injective 2;
  -- We'll use the fact that $\sum_{n=2}^\infty \frac{\|X\|^n}{n!} \leq \frac{\|X\|^2}{2} \sum_{n=0}^\infty \frac{\|X\|^n}{n!}$.
  have h_sum_bound : ∑' n : ℕ, (‖X‖ ^ (n + 2) / (Nat.factorial (n + 2)) : ℝ) ≤ (‖X‖ ^ 2 / 2) * ∑' n : ℕ, (‖X‖ ^ n / (Nat.factorial n) : ℝ) := by
    rw [ ← tsum_mul_left ] ; refine' Summable.tsum_le_tsum _ _ _;
    · intro n; rw [ div_mul_div_comm ] ; rw [ div_le_div_iff₀ ] <;> first | positivity | norm_cast ; ring_nf ;
      exact mul_le_mul_of_nonneg_left ( mod_cast by rw [ add_comm ] ; exact Nat.factorial_mul_factorial_dvd_factorial_add _ _ |> Nat.le_of_dvd ( by positivity ) ) ( by positivity );
    · exact Real.summable_pow_div_factorial _ |> Summable.comp_injective <| Nat.succ_injective.comp <| Nat.succ_injective;
    · exact Summable.mul_left _ <| Real.summable_pow_div_factorial _;
  exact hA_norm.trans <| h_sum_bound.trans_eq <| by rw [ Real.exp_eq_exp_ℝ ] ; rw [ NormedSpace.exp_eq_tsum_div ] ;

/-
Entrywise `O(eps^2)` bound of one split step against its first-order term,
`(0,0)` entry.
-/
theorem walk_sub_firstOrder_entry00_bound (k m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖(walk (k * eps) (m * eps) - firstOrder k m eps) 0 0‖
      ≤ 2 * Ckm k m * eps ^ 2 := by
  -- Apply the bounds on the real and imaginary parts to get the final result.
  have h_bound : |Real.cos (k * eps) * Real.cos (m * eps) - 1| + |k * eps - Real.sin (k * eps) * Real.cos (m * eps)| ≤ (2 * k^2 + m^2 + |k| * m^2) / 2 * eps^2 := by
    -- Apply the bounds on the real and imaginary parts separately.
    have h_real : |Real.cos (k * eps) * Real.cos (m * eps) - 1| ≤ (k * eps)^2 / 2 + (m * eps)^2 / 2 := by
      have h_cos_prod : |Real.cos (k * eps) * Real.cos (m * eps) - 1| ≤ |Real.cos (k * eps) - 1| + |Real.cos (m * eps) - 1| := by
        cases abs_cases ( Real.cos ( k * eps ) * Real.cos ( m * eps ) - 1 ) <;> cases abs_cases ( Real.cos ( k * eps ) - 1 ) <;> cases abs_cases ( Real.cos ( m * eps ) - 1 ) <;> nlinarith [ Real.neg_one_le_cos ( k * eps ), Real.cos_le_one ( k * eps ), Real.neg_one_le_cos ( m * eps ), Real.cos_le_one ( m * eps ) ];
      exact h_cos_prod.trans ( add_le_add ( by simpa [ abs_sub_comm ] using abs_one_sub_cos_le ( k * eps ) ) ( by simpa [ abs_sub_comm ] using abs_one_sub_cos_le ( m * eps ) ) )
    have h_imag : |k * eps - Real.sin (k * eps) * Real.cos (m * eps)| ≤ (k * eps)^2 / 2 + |k * eps| * (m * eps)^2 / 2 := by
      -- Apply the bounds on the sine and cosine functions.
      have h_sin : |k * eps - Real.sin (k * eps)| ≤ (k * eps)^2 / 2 := by
        convert abs_sub_sin_le ( k * eps ) using 1
      have h_cos : |1 - Real.cos (m * eps)| ≤ (m * eps)^2 / 2 := by
        exact?;
      rw [ abs_le ] at *;
      constructor <;> cases abs_cases ( k * eps ) <;> nlinarith [ Real.neg_one_le_sin ( k * eps ), Real.sin_le_one ( k * eps ), Real.neg_one_le_cos ( m * eps ), Real.cos_le_one ( m * eps ) ];
    refine le_trans ( add_le_add h_real h_imag ) ?_;
    norm_num [ abs_mul ];
    nlinarith only [ show 0 ≤ k ^ 2 * eps ^ 2 by positivity, show 0 ≤ m ^ 2 * eps ^ 2 by positivity, show 0 ≤ |k| * m ^ 2 * eps ^ 2 by positivity, show |eps| ≤ 1 by assumption, show |eps| ^ 2 ≤ 1 by nlinarith only [ abs_nonneg eps, heps ] ];
  refine' le_trans _ ( h_bound.trans _ );
  · convert Complex.norm_le_abs_re_add_abs_im _ using 1 ; norm_num [ walk, firstOrder, H, sigmaX, sigmaZ ] ; ring;
    unfold shift coin; norm_num [ Matrix.mul_apply ] ; ring;
    norm_cast ; ring;
  · exact mul_le_mul_of_nonneg_right ( by unfold Ckm; nlinarith [ abs_nonneg k, abs_nonneg m ] ) ( sq_nonneg _ )

/-
Entrywise `O(eps^2)` bound of one split step against its first-order term,
`(0,1)` entry.
-/
theorem walk_sub_firstOrder_entry01_bound (k m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖(walk (k * eps) (m * eps) - firstOrder k m eps) 0 1‖
      ≤ 2 * Ckm k m * eps ^ 2 := by
  refine' le_trans ( Complex.norm_le_abs_re_add_abs_im _ ) _;
  -- Apply the component bounds to each part of the expression.
  have h_comp_bounds : |Real.sin (k * eps) * Real.sin (m * eps)| ≤ |k * eps| * |m * eps| ∧ |eps * m - Real.cos (k * eps) * Real.sin (m * eps)| ≤ (m * eps)^2 / 2 + |m * eps| * (k * eps)^2 / 2 := by
    constructor;
    · rw [ abs_mul ];
      -- Apply the inequality $|\sin(x)| \leq |x|$ to each term.
      have h_sin_le : ∀ x : ℝ, |Real.sin x| ≤ |x| := by
        exact?;
      exact mul_le_mul ( h_sin_le _ ) ( h_sin_le _ ) ( by positivity ) ( by positivity );
    · have h_triangle : |eps * m - Real.sin (m * eps)| ≤ (m * eps) ^ 2 / 2 ∧ |Real.sin (m * eps) * (1 - Real.cos (k * eps))| ≤ |m * eps| * (k * eps) ^ 2 / 2 := by
        constructor;
        · convert abs_sub_sin_le ( m * eps ) using 1 ; ring;
        · have h_sin_cos : |Real.sin (m * eps)| ≤ |m * eps| ∧ |1 - Real.cos (k * eps)| ≤ (k * eps) ^ 2 / 2 := by
            constructor;
            · exact?;
            · convert abs_one_sub_cos_le ( k * eps ) using 1;
          simpa only [ abs_mul, mul_div_assoc ] using mul_le_mul h_sin_cos.1 h_sin_cos.2 ( by positivity ) ( by positivity );
      exact abs_le.mpr ⟨ by linarith [ abs_le.mp h_triangle.1, abs_le.mp h_triangle.2 ], by linarith [ abs_le.mp h_triangle.1, abs_le.mp h_triangle.2 ] ⟩;
  unfold walk firstOrder; norm_num [ Matrix.mul_apply, Matrix.sub_apply ] ; ring_nf at *; norm_num at *;
  unfold Ckm; unfold H; unfold shift; unfold coin; norm_num [ Complex.normSq, Complex.exp_re, Complex.exp_im ] ; ring_nf at *; norm_num at *;
  norm_cast ; norm_num [ sigmaX, sigmaZ ] ; ring_nf at * ; norm_num at *;
  nlinarith [ show 0 ≤ k ^ 2 * eps ^ 2 by positivity, show 0 ≤ eps ^ 2 * m ^ 2 by positivity, show 0 ≤ eps ^ 2 * |m| * |k| by positivity, show 0 ≤ k ^ 2 * eps ^ 2 * |m| by positivity, show 0 ≤ eps ^ 2 * m ^ 2 * |k| by positivity, abs_nonneg m, abs_nonneg k, abs_nonneg eps, mul_le_mul_of_nonneg_left heps <| show 0 ≤ eps ^ 2 * |m| * |k| by positivity ]

/-
Entrywise `O(eps^2)` bound of one split step against its first-order term,
`(1,0)` entry.
-/
theorem walk_sub_firstOrder_entry10_bound (k m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖(walk (k * eps) (m * eps) - firstOrder k m eps) 1 0‖
      ≤ 2 * Ckm k m * eps ^ 2 := by
  -- Let `a = k*eps`, `b = m*eps`. The `(1,0)` entry of `walk (k*eps) (m*eps) - firstOrder k m eps` is the complex number with `re = Real.sin a * Real.sin b` and `im = eps*m - Real.cos a * Real.sin b` (note `eps*m = b`).
  set a : ℝ := k * eps
  set b : ℝ := m * eps
  have h_entry : ‖(walk (k * eps) (m * eps) - firstOrder k m eps) 1 0‖ ≤ |Real.sin a * Real.sin b| + |eps * m - Real.cos a * Real.sin b| := by
    convert Complex.norm_le_abs_re_add_abs_im _ using 2 ; norm_num [ walk, shift, coin, firstOrder, H, sigmaX, sigmaZ ] ; ring;
    · norm_cast ; ring;
      rw [ ← abs_mul, mul_comm ] ; ring!;
    · unfold walk firstOrder; norm_num [ Complex.exp_re, Complex.exp_im, Complex.sin, Complex.cos ] ; ring;
      unfold H shift coin; norm_num [ Matrix.mul_apply ] ; ring;
      norm_cast ; norm_num [ sigmaX, sigmaZ ] ; ring;
      grind;
  -- Bound by `Complex.norm_le_abs_re_add_abs_im`, then bound `|re| + |im|`.
  have h_re : |Real.sin a * Real.sin b| ≤ |a| * |b| := by
    -- Apply the inequality $|\sin x| \leq |x|$ to both $a$ and $b$.
    have h_sin_bound : ∀ x : ℝ, |Real.sin x| ≤ |x| := by
      grind +suggestions;
    simpa only [ abs_mul ] using mul_le_mul ( h_sin_bound a ) ( h_sin_bound b ) ( by positivity ) ( by positivity )
  have h_im : |eps * m - Real.cos a * Real.sin b| ≤ b^2 / 2 + |b| * a^2 / 2 := by
    have h_im : |eps * m - Real.cos a * Real.sin b| ≤ |b - Real.sin b| + |Real.sin b| * |1 - Real.cos a| := by
      rw [ ← abs_mul ] ; ring_nf;
      grind;
    -- Apply the bounds from `abs_sub_sin_le` and `abs_one_sub_cos_le`.
    have h_sin_bound : |b - Real.sin b| ≤ b^2 / 2 := by
      convert abs_sub_sin_le b using 1
    have h_cos_bound : |1 - Real.cos a| ≤ a^2 / 2 := by
      exact?
    have h_sin_bound' : |Real.sin b| ≤ |b| := by
      exact?;
    exact h_im.trans ( by nlinarith only [ abs_nonneg ( Real.sin b ), abs_nonneg ( 1 - Real.cos a ), h_sin_bound, h_cos_bound, h_sin_bound' ] )
  have h_bound : |Real.sin a * Real.sin b| + |eps * m - Real.cos a * Real.sin b| ≤ 2 * Ckm k m * eps ^ 2 := by
    refine le_trans ( add_le_add h_re h_im ) ?_;
    unfold Ckm; ring_nf;
    rw [ show a = k * eps by rfl, show b = m * eps by rfl ] ; norm_num [ abs_mul ] ; ring_nf;
    rw [ show |eps| ^ 2 = eps ^ 2 by rw [ sq_abs ] ];
    nlinarith only [ show 0 ≤ |k| * |m| * eps ^ 2 by positivity, show 0 ≤ |k| * eps ^ 2 * m ^ 2 by positivity, show 0 ≤ |m| * k ^ 2 * eps ^ 2 by positivity, show 0 ≤ k ^ 2 * eps ^ 2 by positivity, show 0 ≤ eps ^ 2 * m ^ 2 by positivity, show |eps| * |m| * k ^ 2 * eps ^ 2 ≤ |m| * k ^ 2 * eps ^ 2 by exact mul_le_mul_of_nonneg_right ( mul_le_mul_of_nonneg_right ( mul_le_of_le_one_left ( by positivity ) heps ) ( by positivity ) ) ( by positivity ) ];
  exact h_entry.trans h_bound

/-
Entrywise `O(eps^2)` bound of one split step against its first-order term,
`(1,1)` entry.
-/
theorem walk_sub_firstOrder_entry11_bound (k m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖(walk (k * eps) (m * eps) - firstOrder k m eps) 1 1‖
      ≤ 2 * Ckm k m * eps ^ 2 := by
  unfold walk firstOrder H sigmaX sigmaZ Ckm;
  simp +decide [ shift, coin, Matrix.mul_apply, Complex.norm_def, Complex.normSq ];
  norm_cast ; norm_num;
  -- Apply the bounds from `abs_one_sub_cos_le` and `abs_sub_sin_le`.
  have h_cos_sin_bounds : |Real.cos (k * eps) * Real.cos (m * eps) - 1| ≤ (k * eps) ^ 2 / 2 + (m * eps) ^ 2 / 2 ∧ |Real.sin (k * eps) * Real.cos (m * eps) - eps * k| ≤ (k * eps) ^ 2 / 2 + |k * eps| * (m * eps) ^ 2 / 2 := by
    constructor;
    · have h_cos_prod : |Real.cos (k * eps) * Real.cos (m * eps) - 1| ≤ |Real.cos (k * eps) - 1| + |Real.cos (m * eps) - 1| := by
        cases abs_cases ( Real.cos ( k * eps ) * Real.cos ( m * eps ) - 1 ) <;> cases abs_cases ( Real.cos ( k * eps ) - 1 ) <;> cases abs_cases ( Real.cos ( m * eps ) - 1 ) <;> nlinarith [ Real.neg_one_le_cos ( k * eps ), Real.cos_le_one ( k * eps ), Real.neg_one_le_cos ( m * eps ), Real.cos_le_one ( m * eps ) ];
      exact h_cos_prod.trans ( add_le_add ( abs_one_sub_cos_le _ |> le_trans ( by rw [ abs_sub_comm ] ) ) ( abs_one_sub_cos_le _ |> le_trans ( by rw [ abs_sub_comm ] ) ) );
    · -- We'll use the fact that $|\sin(x) - x| \leq x^2 / 2$ and $|1 - \cos(x)| \leq x^2 / 2$ to bound the terms.
      have h_sin_cos : |Real.sin (k * eps) - k * eps| ≤ (k * eps)^2 / 2 ∧ |1 - Real.cos (m * eps)| ≤ (m * eps)^2 / 2 := by
        exact ⟨ by simpa [ abs_sub_comm ] using abs_sub_sin_le ( k * eps ), by simpa [ abs_sub_comm ] using abs_one_sub_cos_le ( m * eps ) ⟩;
      rw [ abs_le ] at *;
      constructor <;> cases abs_cases ( k * eps ) <;> nlinarith [ abs_le.mp h_sin_cos.2, Real.neg_one_le_cos ( m * eps ), Real.cos_le_one ( m * eps ) ];
  rw [ Real.sqrt_le_left ];
  · -- Apply the bounds from `abs_one_sub_cos_le` and `abs_sub_sin_le` to each term.
    have h_bound : |Real.cos (k * eps) * Real.cos (m * eps) - 1| ≤ (k^2 + m^2) * eps^2 ∧ |Real.sin (k * eps) * Real.cos (m * eps) - eps * k| ≤ (k^2 + |k| * m^2) * eps^2 := by
      norm_num [ abs_mul ] at *;
      constructor <;> nlinarith [ show 0 ≤ |k| * |eps| * eps ^ 2 by positivity, show |k| * |eps| * eps ^ 2 ≤ |k| * eps ^ 2 by exact mul_le_mul_of_nonneg_right ( mul_le_of_le_one_right ( abs_nonneg _ ) heps ) ( sq_nonneg _ ), abs_mul_abs_self eps ];
    refine' le_trans ( add_le_add ( show ( Real.cos ( k * eps ) * Real.cos ( m * eps ) - 1 ) * ( Real.cos ( k * eps ) * Real.cos ( m * eps ) - 1 ) ≤ ( ( k ^ 2 + m ^ 2 ) * eps ^ 2 ) ^ 2 by nlinarith only [ abs_le.mp h_bound.1 ] ) ( show ( Real.sin ( k * eps ) * Real.cos ( m * eps ) - eps * k ) * ( Real.sin ( k * eps ) * Real.cos ( m * eps ) - eps * k ) ≤ ( ( k ^ 2 + |k| * m ^ 2 ) * eps ^ 2 ) ^ 2 by nlinarith only [ abs_le.mp h_bound.2 ] ) ) _;
    exact le_of_sub_nonneg ( by ring_nf; positivity );
  · positivity

/-- Entrywise `O(eps^2)` bound of one split step against its first-order term. -/
theorem walk_sub_firstOrder_entry_bound (k m eps : ℝ) (heps : |eps| ≤ 1)
    (i j : Fin 2) :
    ‖(walk (k * eps) (m * eps) - firstOrder k m eps) i j‖
      ≤ 2 * Ckm k m * eps ^ 2 := by
  fin_cases i <;> fin_cases j
  · exact walk_sub_firstOrder_entry00_bound k m eps heps
  · exact walk_sub_firstOrder_entry01_bound k m eps heps
  · exact walk_sub_firstOrder_entry10_bound k m eps heps
  · exact walk_sub_firstOrder_entry11_bound k m eps heps

/-
Operator-norm `O(eps^2)` bound of one split step against its first-order term.
-/
theorem walk_sub_firstOrder_bound (k m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖walk (k * eps) (m * eps) - firstOrder k m eps‖
      ≤ 4 * Ckm k m * eps ^ 2 := by
  convert l2_opNorm_le_two_entryMax _ |> le_trans <| ?_ using 1;
  convert mul_le_mul_of_nonneg_left ( show entryMax ( walk ( k * eps ) ( m * eps ) - firstOrder k m eps ) ≤ 2 * Ckm k m * eps ^ 2 from ?_ ) zero_le_two using 1 ; ring;
  exact max_le_iff.mpr ⟨ max_le_iff.mpr ⟨ walk_sub_firstOrder_entry_bound k m eps heps 0 0, walk_sub_firstOrder_entry_bound k m eps heps 0 1 ⟩, max_le_iff.mpr ⟨ walk_sub_firstOrder_entry_bound k m eps heps 1 0, walk_sub_firstOrder_entry_bound k m eps heps 1 1 ⟩ ⟩

/-
The first-order term matches the exact flow to `O(eps^2)`.
-/
theorem firstOrder_sub_exactFlow_bound (k m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖firstOrder k m eps - exactFlow k m eps‖
      ≤ (|k| + |m|) ^ 2 * Real.exp (|k| + |m|) * eps ^ 2 := by
  -- Let `A = (-(eps:ℂ)) • (I • H k m)`, so `exactFlow k m eps = NormedSpace.exp A`.
  set A : Mat := (-(eps : ℂ)) • (I • H k m);
  -- By definition of $firstOrder$, we have $firstOrder k m eps = 1 + A$.
  have h_firstOrder : firstOrder k m eps = 1 + A := by
    ext i j; simp +decide [ A, firstOrder ] ; ring;
  -- Hence `firstOrder k m eps - exactFlow k m eps = (1 + A) - NormedSpace.exp A = -(NormedSpace.exp A - 1 - A)`, and `‖firstOrder - exactFlow‖ = ‖NormedSpace.exp A - 1 - A‖`.
  have h_diff : ‖firstOrder k m eps - exactFlow k m eps‖ = ‖NormedSpace.exp A - 1 - A‖ := by
    convert norm_neg _ using 2 ; rw [ h_firstOrder ] ; ring!;
    unfold exactFlow; abel1;
  -- Now bound `‖A‖`: `‖A‖ = ‖(-(eps:ℂ))‖ * ‖I • H‖ = |eps| * (‖I‖ * ‖H k m‖) = |eps| * ‖H k m‖ ≤ |eps| * (|k|+|m|)` using `norm_smul`, `Complex.norm_I`, `norm_H_le`.
  have h_norm_A : ‖A‖ ≤ |eps| * (|k| + |m|) := by
    convert norm_smul_le ( - ( eps : ℂ ) ) ( I • H k m ) |> le_trans <| mul_le_mul_of_nonneg_left ( norm_smul_le _ _ |> le_trans <| mul_le_of_le_one_left ( by positivity ) Complex.norm_I.le ) ( by positivity ) |> le_trans <| mul_le_mul_of_nonneg_left ( norm_H_le k m ) ( by positivity ) using 1 ; norm_num [ Complex.normSq, Complex.norm_def ];
  -- Since `|eps| ≤ 1` and `|k|+|m| ≥ 0`, we get `‖A‖ ≤ |k|+|m|`, hence `Real.exp ‖A‖ ≤ Real.exp (|k|+|m|)`.
  have h_exp_A : Real.exp ‖A‖ ≤ Real.exp (|k| + |m|) := by
    exact Real.exp_le_exp.mpr ( h_norm_A.trans ( mul_le_of_le_one_left ( by positivity ) heps ) );
  -- Also `‖A‖^2 ≤ (|eps|*(|k|+|m|))^2 = eps^2 * (|k|+|m|)^2`, so `‖A‖^2/2 ≤ eps^2 * (|k|+|m|)^2 / 2 ≤ eps^2 * (|k|+|m|)^2`.
  have h_norm_A_sq : ‖A‖^2 / 2 ≤ eps^2 * (|k| + |m|)^2 := by
    exact le_trans ( div_le_self ( sq_nonneg _ ) ( by norm_num ) ) ( by nlinarith only [ show 0 ≤ ‖A‖ by positivity, show 0 ≤ |eps| * ( |k| + |m| ) by positivity, h_norm_A, show |eps|^2 = eps^2 by rw [ sq_abs ] ] );
  exact h_diff.symm ▸ le_trans ( norm_exp_sub_one_sub_le A ) ( by nlinarith [ Real.exp_pos ‖A‖ ] )

/-
Explicit local comparison between one split step and the exact Dirac flow.
The statement is global for `|eps| <= 1` and uses the L2 operator norm.
-/
theorem one_step_to_exact_flow_bound (k m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖walk (k * eps) (m * eps) - exactFlow k m eps‖
      ≤ Dkm k m * eps ^ 2 := by
  -- Apply the triangle inequality to the norm of the difference.
  have h_triangle : ‖walk (k * eps) (m * eps) - exactFlow k m eps‖ ≤ ‖walk (k * eps) (m * eps) - firstOrder k m eps‖ + ‖firstOrder k m eps - exactFlow k m eps‖ := by
    simpa using norm_add_le ( walk ( k * eps ) ( m * eps ) - firstOrder k m eps ) ( firstOrder k m eps - exactFlow k m eps );
  refine le_trans h_triangle <| le_trans ( add_le_add ( walk_sub_firstOrder_bound k m eps heps ) ( firstOrder_sub_exactFlow_bound k m eps heps ) ) ?_;
  unfold Dkm; nlinarith [ show 0 ≤ ( |k| + |m| ) ^ 2 * Real.exp ( |k| + |m| ) by positivity ] ;

/-
Unitary power telescope with no growth factor.
-/
theorem unitary_pow_telescope {U V : Mat}
    (hU : U ∈ Matrix.unitaryGroup (Fin 2) ℂ)
    (hV : V ∈ Matrix.unitaryGroup (Fin 2) ℂ) (n : ℕ) :
    ‖U ^ n - V ^ n‖ ≤ (n : ℝ) * ‖U - V‖ := by
  induction' n with n ih;
  · norm_num [ Norm.norm ];
  · -- For the successor case, we have $U^{n+1} - V^{n+1} = U(U^n - V^n) + (U - V)V^n$.
    have h_succ : U ^ (n + 1) - V ^ (n + 1) = U * (U ^ n - V ^ n) + (U - V) * V ^ n := by
      simp +decide [ pow_succ', mul_sub, sub_mul ];
    -- Since $U$ and $V$ are unitary, we have $\|U\| = 1$ and $\|V\| = 1$, thus $\|U^n\| = 1$ and $\|V^n\| = 1$.
    have h_unitary : ‖U‖ = 1 ∧ ‖V‖ = 1 := by
      exact ⟨ CStarRing.norm_of_mem_unitary hU, CStarRing.norm_of_mem_unitary hV ⟩;
    -- Since $V$ is unitary, we have $\|V^n\| = 1$.
    have h_Vn : ‖V ^ n‖ ≤ 1 := by
      refine' Nat.recOn n _ _ <;> simp_all +decide [ pow_succ' ];
      exact fun n hn => le_trans ( norm_mul_le _ _ ) ( by simpa [ hV ] using hn );
    -- Using the induction hypothesis and the fact that $\|U\| = 1$ and $\|V\| = 1$, we get:
    have h_ind : ‖U * (U ^ n - V ^ n)‖ ≤ ‖U ^ n - V ^ n‖ ∧ ‖(U - V) * V ^ n‖ ≤ ‖U - V‖ := by
      exact ⟨ by simpa [ h_unitary ] using norm_mul_le U ( U ^ n - V ^ n ), by simpa [ h_unitary ] using norm_mul_le ( U - V ) ( V ^ n ) |> le_trans <| mul_le_of_le_one_right ( norm_nonneg _ ) h_Vn ⟩;
    exact h_succ.symm ▸ le_trans ( norm_add_le _ _ ) ( by push_cast; linarith )

/-
Exact short-time flows compose to the time-`t` flow.
-/
theorem exactFlow_div_pow (k m t : ℝ) (n : ℕ) (hn : 0 < n) :
    (exactFlow k m (t / (n : ℝ))) ^ n = exactFlow k m t := by
  unfold exactFlow; simp +decide [ ← smul_assoc, hn.ne', mul_div_cancel₀ ] ;
  -- Apply the lemma that states the exponential of a scalar multiple is the scalar multiple of the exponential.
  have h_exp_smul : ∀ (x : Mat) (n : ℕ), NormedSpace.exp (n • x) = (NormedSpace.exp x) ^ n := by
    exact?;
  convert h_exp_smul _ n |> Eq.symm using 2 ; ring;
  ext i j ; norm_num [ hn.ne', mul_assoc, mul_left_comm, mul_comm ]

/-
Flagship fixed-time estimate: with `eps=t/n`, the `n`-step walk converges
to exact Dirac evolution at rate `D(k,m) t^2/n`.
-/
theorem fixed_time_many_step_bound (k m t : ℝ) (n : ℕ) (hn : 0 < n)
    (hsmall : |t / (n : ℝ)| ≤ 1) :
    ‖(walk (k * (t / (n : ℝ))) (m * (t / (n : ℝ)))) ^ n - exactFlow k m t‖
      ≤ Dkm k m * t ^ 2 / n := by
  rw [ ← exactFlow_div_pow k m t n hn ];
  refine' le_trans ( unitary_pow_telescope _ _ _ ) _;
  · exact walk_mem_unitary _ _;
  · exact exactFlow_mem_unitary k m _;
  · convert mul_le_mul_of_nonneg_left ( one_step_to_exact_flow_bound k m ( t / n ) hsmall ) ( Nat.cast_nonneg n ) using 1 ; ring;
    simp +decide [ sq, mul_assoc, hn.ne' ]

/-
Fixed-momentum convergence as the number of steps tends to infinity.
-/
theorem fixed_time_many_step_tendsto (k m t : ℝ) :
    Tendsto
      (fun n : ℕ =>
        (walk (k * (t / ((n + 1 : ℕ) : ℝ)))
          (m * (t / ((n + 1 : ℕ) : ℝ)))) ^ (n + 1))
      atTop (𝓝 (exactFlow k m t)) := by
  -- Choose N such that for all n ≥ N, |t/(n+1)| ≤ 1.
  obtain ⟨N, hN⟩ : ∃ N : ℕ, ∀ n ≥ N, |t / (n + 1 : ℝ)| ≤ 1 := by
    exact ⟨ ⌈|t|⌉₊, fun n hn => by rw [ abs_div, abs_of_nonneg ( by positivity : 0 ≤ ( n : ℝ ) + 1 ) ] ; rw [ div_le_iff₀ ] <;> cases abs_cases t <;> nlinarith [ Nat.ceil_le.mp hn ] ⟩;
  rw [ tendsto_iff_norm_sub_tendsto_zero ];
  refine' squeeze_zero_norm' _ _;
  use fun n => Dkm k m * t ^ 2 / ( n + 1 );
  · filter_upwards [ Filter.eventually_ge_atTop N ] with n hn using by rw [ Real.norm_of_nonneg ( norm_nonneg _ ) ] ; simpa using fixed_time_many_step_bound k m t ( n + 1 ) ( Nat.succ_pos _ ) ( by simpa using hN n hn ) ;
  · exact tendsto_const_nhds.div_atTop ( Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop )

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FixedMomentumManyStepContinuum.fixed_time_many_step_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_time_many_step_bound

/-- info: 'PhysicsSM.Draft.NullEdge.FixedMomentumManyStepContinuum.fixed_time_many_step_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_time_many_step_tendsto

end PhysicsSM.Draft.NullEdge.FixedMomentumManyStepContinuum
