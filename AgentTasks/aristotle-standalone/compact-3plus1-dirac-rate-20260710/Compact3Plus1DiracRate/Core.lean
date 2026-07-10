import Mathlib

noncomputable section

open Matrix Complex Real Filter Topology
open scoped Matrix.Norms.L2Operator

namespace Compact3Plus1DiracRate

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

def alpha1 : Mat4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I; 0, 0, I, 0; 0, -I, 0, 0; I, 0, 0, 0]

def alpha3 : Mat4 :=
  !![0, 0, 1, 0; 0, 0, 0, -1; 1, 0, 0, 0; 0, -1, 0, 0]

def beta : Mat4 :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

def H (kx ky kz m : ℝ) : Mat4 :=
  (kx : ℂ) • alpha1 + (ky : ℂ) • alpha2 +
    (kz : ℂ) • alpha3 + (m : ℂ) • beta

def factor (q : ℝ) (g : Mat4) : Mat4 :=
  (Real.cos q : ℂ) • (1 : Mat4) -
    (I * (Real.sin q : ℂ)) • g

/-- Unsymmetrized first-order x/y/z/mass split used by benchmark S21. -/
def splitStep (kx ky kz m eps : ℝ) : Mat4 :=
  factor (kx * eps) alpha1 * factor (ky * eps) alpha2 *
    factor (kz * eps) alpha3 * factor (m * eps) beta

def exactFlow (kx ky kz m t : ℝ) : Mat4 :=
  NormedSpace.exp ((-(t : ℂ)) • (I • H kx ky kz m))

def B4 (kx ky kz m : ℝ) : ℝ :=
  |kx| + |ky| + |kz| + |m|

/-- Deliberately generous finite-dimensional first-order product constant. -/
def D4 (kx ky kz m : ℝ) : ℝ :=
  16 * B4 kx ky kz m ^ 2 * Real.exp (B4 kx ky kz m)

theorem generators_hermitian_square_one :
    alpha1.IsHermitian ∧ alpha2.IsHermitian ∧ alpha3.IsHermitian ∧
      beta.IsHermitian ∧
      alpha1 * alpha1 = 1 ∧ alpha2 * alpha2 = 1 ∧
      alpha3 * alpha3 = 1 ∧ beta * beta = 1 := by
  refine' ⟨ _, _, _, _, _, _, _, _ ⟩ <;> norm_num [ IsHermitian, Matrix.mul_apply, Fin.sum_univ_succ ];
  all_goals norm_num [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Fin.sum_univ_succ ] at *;
  all_goals simp +decide [ alpha1, alpha2, alpha3, beta ] at *

theorem H_isHermitian (kx ky kz m : ℝ) : (H kx ky kz m).IsHermitian := by
  ext x y; simp [H];
  fin_cases x <;> fin_cases y <;> simp +decide [ alpha1, alpha2, alpha3, beta ]

theorem factor_mem_unitary (q : ℝ) (g : Mat4)
    (hgH : g.IsHermitian) (hg2 : g * g = 1) :
    factor q g ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
  convert Matrix.mem_unitaryGroup_iff.mpr _;
  unfold factor; simp +decide [ *, Matrix.mul_assoc, Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_one, Matrix.one_mul ] ; ring;
  simp_all +decide [ mul_add, add_mul, mul_assoc, mul_left_comm, mul_comm, Complex.ext_iff, IsHermitian ];
  simp_all +decide [ mul_assoc, mul_left_comm, ← Matrix.ext_iff ];
  intro i j; specialize hg2 i j; simp_all +decide [ Complex.ext_iff, Matrix.mul_apply ] ; ring;
  norm_cast; norm_num [ Real.cos_sq' ] ;
  constructor <;> ring

theorem splitStep_mem_unitary (kx ky kz m eps : ℝ) :
    splitStep kx ky kz m eps ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
  convert Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( factor_mem_unitary ( kx * eps ) alpha1 ( generators_hermitian_square_one.1 ) ( generators_hermitian_square_one.2.2.2.2.1 ) ) ( factor_mem_unitary ( ky * eps ) alpha2 ( generators_hermitian_square_one.2.1 ) ( generators_hermitian_square_one.2.2.2.2.2.1 ) ) ) ( factor_mem_unitary ( kz * eps ) alpha3 ( generators_hermitian_square_one.2.2.1 ) ( generators_hermitian_square_one.2.2.2.2.2.2.1 ) ) ) ( factor_mem_unitary ( m * eps ) beta ( generators_hermitian_square_one.2.2.2.1 ) ( generators_hermitian_square_one.2.2.2.2.2.2.2 ) ) using 1

theorem exactFlow_mem_unitary (kx ky kz m t : ℝ) :
    exactFlow kx ky kz m t ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
  refine' ⟨ _, _ ⟩;
  · -- By definition of $exactFlow$, we know that $exactFlow kx ky kz m t = \exp(-(t : ℂ) • (I • H kx ky kz m))$.
    have h_exp : star (NormedSpace.exp (-(t : ℂ) • (I • H kx ky kz m))) = NormedSpace.exp (star (-(t : ℂ) • (I • H kx ky kz m))) := by
      -- The exponential of a matrix is defined as a power series, and the star operation is linear.
      have h_exp_star : ∀ (A : Matrix (Fin 4) (Fin 4) ℂ), star (NormedSpace.exp A) = NormedSpace.exp (star A) := by
        exact fun A => NormedSpace.star_exp A;
      exact h_exp_star _;
    -- Since $-(t : ℂ) • (I • H kx ky kz m)$ is skew-Hermitian, we have $\exp(-(t : ℂ) • (I • H kx ky kz m)) * \exp(-(t : ℂ) • (I • H kx ky kz m))ᴴ = \exp(0) = I$.
    have h_skew_herm : ∀ (A : Mat4), (star A = -A) → NormedSpace.exp A * NormedSpace.exp (star A) = 1 := by
      intro A hA
      have h_comm : Commute A (star A) := by
        simp +decide [ hA, mul_neg, neg_mul ];
      rw [ ← Matrix.exp_add_of_commute ] <;> aesop;
    simp_all +decide [ exactFlow ];
    convert h_skew_herm ( - ( t • I • H kx ky kz m ) ) _ using 1 <;> norm_num [ H_isHermitian ];
    · rw [ H_isHermitian _ _ _ _ |> IsSelfAdjoint.star_eq ] ;
      rw [ ← Matrix.exp_add_of_commute, ← Matrix.exp_add_of_commute ] <;> norm_num [ mul_comm ];
    · exact congr_arg _ ( congr_arg _ ( H_isHermitian kx ky kz m |> fun h => h.eq ) );
  · have h_exp : star (NormedSpace.exp ((-(t : ℂ)) • (I • H kx ky kz m))) = NormedSpace.exp ((t : ℂ) • (I • H kx ky kz m)) := by
      -- By definition of exponentiation, we know that $(e^A)^* = e^{A^*}$.
      have h_exp_star : ∀ A : Matrix (Fin 4) (Fin 4) ℂ, star (NormedSpace.exp A) = NormedSpace.exp (star A) := by
        exact fun A => NormedSpace.star_exp A;
      convert h_exp_star _ using 2 ; ext i j ; simp +decide [ Matrix.mul_apply, mul_comm ];
      unfold H; norm_num [ alpha1, alpha2, alpha3, beta ] ;
      fin_cases i <;> fin_cases j <;> simp +decide [ Complex.ext_iff ];
    have h_exp : NormedSpace.exp ((-(t : ℂ)) • (I • H kx ky kz m)) * NormedSpace.exp ((t : ℂ) • (I • H kx ky kz m)) = 1 := by
      rw [ ← Matrix.exp_add_of_commute ] <;> norm_num;
    unfold exactFlow; aesop;

theorem norm_H_le_B4 (kx ky kz m : ℝ) :
    ‖H kx ky kz m‖ ≤ B4 kx ky kz m := by
  -- Each generator is a Hermitian involution hence unitary (from generators_hermitian_square_one and factor... no—directly: alpha_i * alpha_i = 1 and Hermitian means alpha_iᴴ = alpha_i so alpha_iᴴ*alpha_i = 1, unitary), so its L2 operator norm is ≤ 1.
  have alpha_norm_le_one : ‖alpha1‖ ≤ 1 ∧ ‖alpha2‖ ≤ 1 ∧ ‖alpha3‖ ≤ 1 ∧ ‖beta‖ ≤ 1 := by
    refine' ⟨ _, _, _, _ ⟩ <;> refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one _ <;> norm_num [ Matrix.mulVec ];
    · intro x; exact (by
      simp +decide [ alpha1, EuclideanSpace.norm_eq, Fin.sum_univ_four ];
      exact Real.sqrt_le_sqrt ( by linarith! ));
    · intro x
      simp [toEuclideanLin, alpha2];
      norm_num [ EuclideanSpace.norm_eq, Fin.sum_univ_succ ];
      exact Real.sqrt_le_sqrt ( by linarith! );
    · intro x; rw [ toEuclideanLin_apply ] ; norm_num [ EuclideanSpace.norm_eq ] ; ring_nf; norm_num;
      norm_num [ Fin.sum_univ_succ, alpha3 ] ; ring_nf ;
      exact Real.sqrt_le_sqrt ( by linarith! );
    · intro x; erw [ EuclideanSpace.norm_eq ] ; erw [ EuclideanSpace.norm_eq ] ; norm_num [ Fin.sum_univ_four, beta ] ; ring_nf ;
      simp +decide [ vecHead, vecTail ];
  -- Apply the triangle inequality to the sum of the norms.
  have h_triangle : ‖(kx : ℂ) • alpha1 + (ky : ℂ) • alpha2 + (kz : ℂ) • alpha3 + (m : ℂ) • beta‖ ≤ ‖(kx : ℂ) • alpha1‖ + ‖(ky : ℂ) • alpha2‖ + ‖(kz : ℂ) • alpha3‖ + ‖(m : ℂ) • beta‖ := by
    exact le_trans ( norm_add_le _ _ ) ( add_le_add ( le_trans ( norm_add_le _ _ ) ( add_le_add ( norm_add_le _ _ ) le_rfl ) ) le_rfl );
  refine le_trans h_triangle ?_;
  simp_all +decide [ norm_smul, B4 ];
  exact add_le_add ( add_le_add ( add_le_add ( mul_le_of_le_one_right ( abs_nonneg _ ) alpha_norm_le_one.1 ) ( mul_le_of_le_one_right ( abs_nonneg _ ) alpha_norm_le_one.2.1 ) ) ( mul_le_of_le_one_right ( abs_nonneg _ ) alpha_norm_le_one.2.2.1 ) ) ( mul_le_of_le_one_right ( abs_nonneg _ ) alpha_norm_le_one.2.2.2 )

/-
The four Clifford generators all have L2 operator norm at most one.
-/
lemma generators_norm_le_one :
    ‖alpha1‖ ≤ 1 ∧ ‖alpha2‖ ≤ 1 ∧ ‖alpha3‖ ≤ 1 ∧ ‖beta‖ ≤ 1 := by
  refine' ⟨ _, _, _, _ ⟩;
  · refine' csInf_le _ _ <;> norm_num [ alpha1 ];
    · exact ⟨ 0, fun c hc => hc.1 ⟩;
    · norm_num [ EuclideanSpace.norm_eq, Fin.sum_univ_succ ];
      exact fun x => Real.sqrt_le_sqrt <| by linarith!;
  · refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => _;
    simp +decide [ EuclideanSpace.norm_eq, Fin.sum_univ_four ];
    simp +decide [ alpha2, Matrix.mulVec ];
    exact Real.sqrt_le_sqrt ( by linarith! );
  · refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => _;
    norm_num [ EuclideanSpace.norm_eq, Fin.sum_univ_four ];
    simp +decide [ alpha3, Matrix.mulVec ];
    exact Real.sqrt_le_sqrt ( by linarith! );
  · refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => _;
    simp +decide [ EuclideanSpace.norm_eq, Matrix.mulVec, beta ];
    simp +decide [ Fin.sum_univ_succ, dotProduct ]

/-
Elementary scalar remainder bound `e^a - 1 - a ≤ a² e^a` for `a ≥ 0`.
-/
lemma exp_sub_one_sub_self_le_sq {a : ℝ} (ha : 0 ≤ a) :
    Real.exp a - 1 - a ≤ a ^ 2 * Real.exp a := by
  have := Real.add_one_le_exp ( -a );
  rw [ Real.exp_neg ] at this;
  nlinarith [ Real.add_one_le_exp a, mul_inv_cancel₀ ( ne_of_gt ( Real.exp_pos a ) ), mul_nonneg ha ( Real.exp_nonneg a ) ]

/-
Cubic lower bound for the exponential on the nonnegative reals.
-/
lemma one_add_cubic_le_exp {a : ℝ} (ha : 0 ≤ a) :
    1 + a + a ^ 2 / 2 + a ^ 3 / 6 ≤ Real.exp a := by
  -- We'll use the exponential property to simplify the expression. Note that $e^a = \sum_{n=0}^{\infty} \frac{a^n}{n!}$.
  have h_exp : Real.exp a = ∑' n : ℕ, a^n / Nat.factorial n := by
    simp +decide [ Real.exp_eq_exp_ℝ, NormedSpace.exp_eq_tsum_div ];
  refine' h_exp ▸ le_trans _ ( Summable.sum_le_tsum ( Finset.range 4 ) ( fun _ _ => by positivity ) ( by simpa using Real.summable_pow_div_factorial a ) ) ; norm_num [ Finset.sum_range_succ, Nat.factorial ]

/-
Combined scalar bound: `|cos q - 1| + |sin q - q| ≤ e^{|q|} - 1 - |q|`.
-/
lemma abs_cos_sub_one_add_abs_sin_sub_le (q : ℝ) :
    |Real.cos q - 1| + |Real.sin q - q| ≤ Real.exp |q| - 1 - |q| := by
  -- By the properties of the exponential function and the triangle inequality, we have:
  have h_exp : |Real.cos q - 1| ≤ |q|^2 / 2 := by
    -- Using the fact that $|\cos q - 1| = 2 \sin^2 (q/2)$ and $\sin^2 (q/2) \leq (q/2)^2$, we get $|\cos q - 1| \leq q^2 / 2$.
    have h_sin_sq : Real.sin (q / 2) ^ 2 ≤ (q / 2) ^ 2 := by
      exact sin_sq_le_sq;
    rw [ show Real.cos q - 1 = -2 * Real.sin ( q / 2 ) ^ 2 by rw [ Real.sin_sq, Real.cos_sq ] ; ring ] ; norm_num [ abs_mul, abs_neg, abs_of_nonneg ] ; nlinarith [ abs_mul_abs_self q ] ;
  have h_sin : |Real.sin q - q| ≤ |q|^3 / 6 := by
    have h_sin : ∀ x : ℝ, 0 ≤ x → |Real.sin x - x| ≤ x^3 / 6 := by
      intro x hx
      have h_sin_bound : ∀ t ∈ Set.Icc 0 x, |Real.cos t - 1| ≤ t^2 / 2 := by
        -- Use the trigonometric identity $\cos t = 1 - 2 \sin^2 (t/2)$ and the fact that $|\sin (t/2)| \leq t/2$ for $t \geq 0$.
        have h_sin_sq : ∀ t ∈ Set.Icc 0 x, |Real.sin (t / 2)| ≤ t / 2 := by
          intro t ht; rw [ abs_le ] ; constructor <;> by_cases h : t = 0 <;> simpa [ h ] using le_of_not_gt fun h' => by nlinarith [ Real.sin_lt <| show 0 < t / 2 from div_pos ( lt_of_le_of_ne ht.1 <| Ne.symm h ) zero_lt_two, Real.sin_nonneg_of_nonneg_of_le_pi ( show 0 ≤ t / 2 from div_nonneg ht.1 zero_le_two ) ( by linarith [ Real.pi_gt_three, abs_le.mp ( Real.abs_sin_le_one ( t / 2 ) ), ht.2 ] ) ] ;
        intro t ht; rw [ show Real.cos t - 1 = -2 * Real.sin ( t / 2 ) ^ 2 by rw [ Real.sin_sq, Real.cos_sq ] ; ring ] ; rw [ abs_le ] ; constructor <;> nlinarith [ abs_le.mp ( h_sin_sq t ht ) ] ;
      -- Integrate both sides of $|\cos t - 1| \leq t^2 / 2$ from $0$ to $x$.
      have h_integral_bound : |∫ t in (0 : ℝ)..x, (Real.cos t - 1)| ≤ ∫ t in (0 : ℝ)..x, t^2 / 2 := by
        refine' le_trans ( intervalIntegral.abs_integral_le_integral_abs _ ) ( intervalIntegral.integral_mono_on _ _ _ h_sin_bound ) <;> norm_num [ hx ];
        exact Continuous.intervalIntegrable ( by continuity ) _ _;
      norm_num at *; ring_nf at *; aesop;
    cases abs_cases q <;> simp +decide [ * ];
    have := h_sin ( -q ) ( by linarith ) ; simp_all +decide [ abs_sub_comm ];
    grind;
  have := one_add_cubic_le_exp ( abs_nonneg q );
  linarith

/-
Combined scalar bound: `|cos q - 1| + |sin q| ≤ e^{|q|} - 1`.
-/
lemma abs_cos_sub_one_add_abs_sin_le (q : ℝ) :
    |Real.cos q - 1| + |Real.sin q| ≤ Real.exp |q| - 1 := by
  -- From 1-cos ≤ q^2/2 (global), we get |cos q - 1| = 1 - cos q ≤ q^2/2 = a^2/2.
  have h_cos : abs (Real.cos q - 1) ≤ abs q ^ 2 / 2 := by
    -- Use the trigonometric identity $|\cos q - 1| = 2 |\sin^2 (q/2)|$ and the fact that $|\sin x| \leq |x|$ for all $x$.
    have h_sin_bound : |Real.sin (q / 2)| ≤ |q / 2| := by
      grind +suggestions
    have h_cos_bound : |Real.cos q - 1| = 2 * |Real.sin (q / 2)| ^ 2 := by
      norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
      rw [ abs_of_nonpos ] <;> linarith [ Real.cos_le_one q ]
    rw [h_cos_bound];
    exact le_trans ( mul_le_mul_of_nonneg_left ( pow_le_pow_left₀ ( abs_nonneg _ ) h_sin_bound 2 ) zero_le_two ) ( by norm_num [ abs_div ] ; ring_nf; norm_num );
  -- From Real.abs_sin_le_abs, we get |sin q| ≤ |q|.
  have h_sin : abs (Real.sin q) ≤ abs q := by
    exact abs_sin_le_abs;
  nlinarith [ abs_nonneg q, one_add_cubic_le_exp ( abs_nonneg q ) ]

/-
Second-order estimate for a single split factor against its linearization
`1 + (-(q) • (I • g))`.
-/
lemma factor_sub_one_sub_gen_bound (q : ℝ) (g : Mat4) (hg : ‖g‖ ≤ 1) :
    ‖factor q g - 1 - ((-(q : ℂ)) • ((I : ℂ) • g))‖ ≤
      Real.exp |q| - 1 - |q| := by
  -- By definition of $factor$, we have
  have h_factor_def : factor q g - 1 - (-(q : ℂ)) • I • g = ((Real.cos q - 1 : ℝ) : ℂ) • (1 : Mat4) + ((I * (q - Real.sin q) : ℂ)) • g := by
    ext i j; simp +decide [ factor, Matrix.mul_apply ] ; ring;
  -- By the triangle inequality and properties of norms, we have
  have h_norm : ‖factor q g - 1 - (-(q : ℂ)) • I • g‖ ≤ |Real.cos q - 1| + |q - Real.sin q| := by
    convert norm_add_le ( ( Real.cos q - 1 : ℝ ) • ( 1 : Mat4 ) ) ( ( I * ( q - Real.sin q ) : ℂ ) • g ) |> le_trans <| add_le_add ?_ ?_ using 1;
    · convert congr_arg Norm.norm h_factor_def using 2;
    · norm_num [ norm_smul ];
    · convert norm_smul_le ( I * ( q - Real.sin q ) : ℂ ) g |> le_trans <| mul_le_of_le_one_right ( by positivity ) hg using 1 ; norm_num [ Complex.norm_def, Complex.normSq ];
      norm_cast ; rw [ Real.sqrt_mul_self_eq_abs ];
  exact h_norm.trans ( by simpa [ abs_sub_comm ] using abs_cos_sub_one_add_abs_sin_sub_le q )

/-
First-order estimate for a single split factor against the identity.
-/
lemma factor_sub_one_bound (q : ℝ) (g : Mat4) (hg : ‖g‖ ≤ 1) :
    ‖factor q g - 1‖ ≤ Real.exp |q| - 1 := by
  refine' le_trans _ ( abs_cos_sub_one_add_abs_sin_le q );
  -- Apply the triangle inequality to the expression.
  have h_triangle : ‖(Real.cos q - 1 : ℂ) • (1 : Mat4) - (I * Real.sin q : ℂ) • g‖ ≤ ‖(Real.cos q - 1 : ℂ) • (1 : Mat4)‖ + ‖(I * Real.sin q : ℂ) • g‖ := by
    exact norm_sub_le _ _;
  convert h_triangle.trans _ using 1;
  · convert rfl using 2 ; ext i j ; norm_num [ factor ] ; ring;
  · gcongr;
    · convert norm_smul_le ( Real.cos q - 1 : ℂ ) ( 1 : Mat4 ) using 1 ; norm_num;
      norm_cast;
    · convert norm_smul_le ( I * Real.sin q : ℂ ) g |> le_trans <| mul_le_of_le_one_right ( by positivity ) hg using 1 ; norm_num [ Complex.normSq, Complex.norm_def ];
      norm_cast ; rw [ Real.sqrt_mul_self_eq_abs ]

/-
The multiplicative Trotter accumulation step: extending a partial product by
one more (already-linearized) factor keeps the `e^s - 1 - s` envelope.
-/
lemma trotter_step (P S F A : Mat4) (s a : ℝ)
    (hs : 0 ≤ s) (ha : 0 ≤ a)
    (hS : ‖S‖ ≤ s)
    (hPS : ‖P - 1 - S‖ ≤ Real.exp s - 1 - s)
    (hFA : ‖F - 1 - A‖ ≤ Real.exp a - 1 - a)
    (hF1 : ‖F - 1‖ ≤ Real.exp a - 1)
    (hF : ‖F‖ ≤ Real.exp a) :
    ‖P * F - 1 - (S + A)‖ ≤ Real.exp (s + a) - 1 - (s + a) := by
  -- Use the exact algebraic identity P*F-1-(S+A)=(P-1-S)(F)+F-1-A+S*(F-1).
  have h_identity : P * F - 1 - (S + A) = (P - 1 - S) * F + (F - 1 - A) + S * (F - 1) := by
    grind
  rw [h_identity];
  refine' le_trans ( norm_add₃_le .. ) _;
  refine' le_trans ( add_le_add_three ( norm_mul_le _ _ ) hFA ( norm_mul_le _ _ ) ) _;
  rw [ Real.exp_add ];
  nlinarith [ Real.add_one_le_exp s, Real.add_one_le_exp a, norm_nonneg ( P - 1 - S ), norm_nonneg S, norm_nonneg ( F - 1 ) ]

/-
Second-order Taylor remainder for the matrix exponential.
-/
lemma norm_exp_sub_one_sub_self_le (X : Mat4) :
    ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖ ^ 2 * Real.exp ‖X‖ := by
  -- We begin with the series expansion of the exponential function:
  -- $\exp(X) = \sum_{n=0}^{\infty} \frac{X^n}{n!}$.
  have h_expansion : NormedSpace.exp X = ∑' n : Nat, (Nat.factorial n : ℂ)⁻¹ • X ^ n := by
    grind +suggestions
  generalize_proofs at *; (
  -- We can split the series into the first two terms and the rest:
  have h_split : NormedSpace.exp X - 1 - X = ∑' n : Nat, (Nat.factorial (n + 2) : ℂ)⁻¹ • X ^ (n + 2) := by
    rw [ h_expansion, ← Summable.sum_add_tsum_nat_add 2 ];
    · norm_num [ Finset.sum_range_succ ] ; abel1;
    · refine' .of_norm _;
      -- We'll use the fact that |X^n| ≤ |X|^n.
      have h_norm_pow : ∀ n : ℕ, ‖X ^ n‖ ≤ ‖X‖ ^ n := by
        intro n; induction n <;> simp_all +decide [ pow_succ' ] ;
        exact le_trans ( norm_mul_le _ _ ) ( mul_le_mul_of_nonneg_left ‹_› ( norm_nonneg _ ) )
      generalize_proofs at *; (
      simp_all +decide [ norm_smul ];
      exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow n ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using Real.summable_pow_div_factorial ‖X‖ ))
  generalize_proofs at *; (
  -- We bound the norm of each term in the series:
  have h_term_bound : ∀ n : ℕ, ‖(Nat.factorial (n + 2) : ℂ)⁻¹ • X ^ (n + 2)‖ ≤ (‖X‖ ^ 2 / (Nat.factorial n : ℝ)) * ‖X‖ ^ n := by
    intro n
    have h_term_bound : ‖X ^ (n + 2)‖ ≤ ‖X‖ ^ (n + 2) := by
      exact norm_pow_le X (n + 2)
    generalize_proofs at *; (
    rw [ norm_smul, norm_inv, Complex.norm_natCast ] ; ring_nf at *;
    exact le_trans ( mul_le_mul_of_nonneg_left h_term_bound <| by positivity ) <| by rw [ mul_comm ] ; gcongr ; linarith [ Nat.self_le_factorial n, Nat.factorial_le ( by linarith : n ≤ 2 + n ) ] ;)
  generalize_proofs at *; (
  rw [ h_split, Real.exp_eq_exp_ℝ ];
  refine' le_trans ( norm_tsum_le_tsum_norm _ ) ( le_trans ( Summable.tsum_le_tsum h_term_bound _ _ ) _ );
  · refine' Summable.of_nonneg_of_le ( fun n => norm_nonneg _ ) ( fun n => h_term_bound n ) _;
    convert Summable.mul_left ( ‖X‖ ^ 2 ) ( Real.summable_pow_div_factorial ‖X‖ ) using 2 ; ring;
  · refine' Summable.of_nonneg_of_le ( fun n => norm_nonneg _ ) ( fun n => h_term_bound n ) _;
    convert Summable.mul_left ( ‖X‖ ^ 2 ) ( Real.summable_pow_div_factorial ‖X‖ ) using 2 ; ring;
  · convert Summable.mul_left ( ‖X‖ ^ 2 ) ( Real.summable_pow_div_factorial ‖X‖ ) using 2 ; ring;
  · rw [ NormedSpace.exp_eq_tsum_div ] ; rw [ ← tsum_mul_left ] ; exact le_of_eq <| tsum_congr fun n => by ring;)))

/-
The split step is second-order close to its shared linearization.
-/
lemma splitStep_sub_lin_bound (kx ky kz m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖splitStep kx ky kz m eps -
        (1 + ((-(eps : ℂ)) • ((I : ℂ) • H kx ky kz m)))‖ ≤
      eps ^ 2 * B4 kx ky kz m ^ 2 * Real.exp (B4 kx ky kz m) := by
  have h_step1 : ‖splitStep kx ky kz m eps - 1 - ((-(eps : ℂ)) • ((I : ℂ) • H kx ky kz m))‖ ≤ Real.exp (|eps| * B4 kx ky kz m) - 1 - |eps| * B4 kx ky kz m := by
    -- Let's calculate the norm of the difference between the product of the factors and the linear approximation.
    have h_diff : ‖(factor (kx * eps) alpha1) * (factor (ky * eps) alpha2) * (factor (kz * eps) alpha3) * (factor (m * eps) beta) - 1 - ((-(eps : ℂ)) • ((I : ℂ) • (H kx ky kz m)))‖ ≤ Real.exp (|kx * eps| + |ky * eps| + |kz * eps| + |m * eps|) - 1 - (|kx * eps| + |ky * eps| + |kz * eps| + |m * eps|) := by
      -- Apply the trotter_step lemma four times, each time with the appropriate parameters.
      have h_trotter : ∀ (P : Mat4) (S : Mat4) (q : ℝ) (g : Mat4) (a : ℝ), ‖g‖ ≤ 1 → ‖S‖ ≤ a → ‖P - 1 - S‖ ≤ Real.exp a - 1 - a → ‖(P * (factor (q) g)) - 1 - (S + ((-(q : ℂ)) • ((I : ℂ) • g)))‖ ≤ Real.exp (a + |q|) - 1 - (a + |q|) := by
        intros P S q g a hg hS hP
        have hF : ‖factor q g - 1 - ((-(q : ℂ)) • ((I : ℂ) • g))‖ ≤ Real.exp |q| - 1 - |q| := by
          convert factor_sub_one_sub_gen_bound q g hg using 1;
        have hF1 : ‖factor q g - 1‖ ≤ Real.exp |q| - 1 := by
          convert factor_sub_one_bound q g hg using 1
        have hF2 : ‖factor q g‖ ≤ Real.exp |q| := by
          have := norm_add_le ( factor q g - 1 ) 1; norm_num at *; linarith;
        have hF3 : 0 ≤ a := by
          exact le_trans ( norm_nonneg _ ) hS
        have hF4 : 0 ≤ |q| := by
          positivity
        exact trotter_step P S (factor q g) ((-(q : ℂ)) • ((I : ℂ) • g)) a |q| hF3 hF4 hS hP hF hF1 hF2;
      -- Apply the trotter_step lemma four times to accumulate the bounds.
      have h_accum : ∀ (q1 q2 q3 q4 : ℝ) (g1 g2 g3 g4 : Mat4), ‖g1‖ ≤ 1 → ‖g2‖ ≤ 1 → ‖g3‖ ≤ 1 → ‖g4‖ ≤ 1 →
          ‖factor q1 g1 * factor q2 g2 * factor q3 g3 * factor q4 g4 - 1 - ((-(q1 : ℂ)) • ((I : ℂ) • g1) + (-(q2 : ℂ)) • ((I : ℂ) • g2) + (-(q3 : ℂ)) • ((I : ℂ) • g3) + (-(q4 : ℂ)) • ((I : ℂ) • g4))‖ ≤
            Real.exp (|q1| + |q2| + |q3| + |q4|) - 1 - (|q1| + |q2| + |q3| + |q4|) := by
              intros q1 q2 q3 q4 g1 g2 g3 g4 hg1 hg2 hg3 hg4
              have h1 : ‖factor q1 g1 - 1 - ((-(q1 : ℂ)) • ((I : ℂ) • g1))‖ ≤ Real.exp |q1| - 1 - |q1| := by
                exact factor_sub_one_sub_gen_bound q1 g1 hg1
              have h2 : ‖factor q1 g1 * factor q2 g2 - 1 - ((-(q1 : ℂ)) • ((I : ℂ) • g1) + (-(q2 : ℂ)) • ((I : ℂ) • g2))‖ ≤ Real.exp (|q1| + |q2|) - 1 - (|q1| + |q2|) := by
                convert h_trotter ( factor q1 g1 ) ( - ( q1 : ℂ ) • I • g1 ) q2 g2 |q1| hg2 _ h1 using 1;
                norm_num [ norm_smul, hg1 ];
                exact mul_le_of_le_one_right ( abs_nonneg _ ) hg1
              have h3 : ‖factor q1 g1 * factor q2 g2 * factor q3 g3 - 1 - ((-(q1 : ℂ)) • ((I : ℂ) • g1) + (-(q2 : ℂ)) • ((I : ℂ) • g2) + (-(q3 : ℂ)) • ((I : ℂ) • g3))‖ ≤ Real.exp (|q1| + |q2| + |q3|) - 1 - (|q1| + |q2| + |q3|) := by
                convert h_trotter _ _ _ _ _ hg3 _ h2 using 1;
                refine' le_trans ( norm_add_le _ _ ) _;
                norm_num [ norm_smul ];
                exact add_le_add ( mul_le_of_le_one_right ( abs_nonneg _ ) hg1 ) ( mul_le_of_le_one_right ( abs_nonneg _ ) hg2 )
              have h4 : ‖factor q1 g1 * factor q2 g2 * factor q3 g3 * factor q4 g4 - 1 - ((-(q1 : ℂ)) • ((I : ℂ) • g1) + (-(q2 : ℂ)) • ((I : ℂ) • g2) + (-(q3 : ℂ)) • ((I : ℂ) • g3) + (-(q4 : ℂ)) • ((I : ℂ) • g4))‖ ≤ Real.exp (|q1| + |q2| + |q3| + |q4|) - 1 - (|q1| + |q2| + |q3| + |q4|) := by
                convert h_trotter _ _ _ _ _ hg4 _ h3 using 1;
                refine' le_trans ( norm_add_le _ _ ) ( add_le_add ( le_trans ( norm_add_le _ _ ) ( add_le_add _ _ ) ) _ ) <;> norm_num [ norm_smul, hg1, hg2, hg3 ];
                · exact mul_le_of_le_one_right ( abs_nonneg _ ) hg1;
                · exact mul_le_of_le_one_right ( abs_nonneg _ ) hg2;
                · exact mul_le_of_le_one_right ( abs_nonneg _ ) hg3
              exact h4;
      convert h_accum ( kx * eps ) ( ky * eps ) ( kz * eps ) ( m * eps ) alpha1 alpha2 alpha3 beta _ _ _ _ using 2 <;> norm_num [ generators_norm_le_one ];
      unfold H; norm_num [ mul_assoc, mul_left_comm, mul_comm ] ;
      ext i j ; norm_num ; ring;
    convert h_diff using 2 ; norm_num [ abs_mul, B4 ] ; ring;
    unfold B4; norm_num [ abs_mul, mul_comm ] ; ring;
  -- Apply the exponential bound to the right-hand side of the inequality.
  have h_exp_bound : Real.exp (|eps| * B4 kx ky kz m) - 1 - |eps| * B4 kx ky kz m ≤ (|eps| * B4 kx ky kz m)^2 * Real.exp (B4 kx ky kz m) := by
    convert exp_sub_one_sub_self_le_sq ( show 0 ≤ |eps| * B4 kx ky kz m by exact mul_nonneg ( abs_nonneg _ ) ( by exact abs_nonneg _ |> fun h1 => abs_nonneg _ |> fun h2 => abs_nonneg _ |> fun h3 => abs_nonneg _ |> fun h4 => add_nonneg ( add_nonneg ( add_nonneg h1 h2 ) h3 ) h4 ) ) |> le_trans <| mul_le_mul_of_nonneg_left ( Real.exp_le_exp.mpr <| show |eps| * B4 kx ky kz m ≤ B4 kx ky kz m by exact mul_le_of_le_one_left ( by exact abs_nonneg _ |> fun h1 => abs_nonneg _ |> fun h2 => abs_nonneg _ |> fun h3 => abs_nonneg _ |> fun h4 => add_nonneg ( add_nonneg ( add_nonneg h1 h2 ) h3 ) h4 ) heps ) <| sq_nonneg _ using 1;
  convert h_step1.trans h_exp_bound using 1 <;> norm_num [ mul_pow ];
  exact congr_arg Norm.norm ( by ext; norm_num; ring )

/-
The exact flow is second-order close to the same shared linearization.
-/
lemma exactFlow_sub_lin_bound (kx ky kz m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖exactFlow kx ky kz m eps -
        (1 + ((-(eps : ℂ)) • ((I : ℂ) • H kx ky kz m)))‖ ≤
      eps ^ 2 * B4 kx ky kz m ^ 2 * Real.exp (B4 kx ky kz m) := by
  -- Let $X = -(eps : ℂ) • (I • H kx ky kz m)$. By definition of $exactFlow$, we have $exactFlow kx ky kz m eps = NormedSpace.exp X$.
  set X : Mat4 := -(eps : ℂ) • (I • H kx ky kz m)
  have hX : exactFlow kx ky kz m eps = NormedSpace.exp X := by
    rfl;
  -- By norm_exp_sub_one_sub_self_le, we have ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖^2 * Real.exp ‖X‖.
  have h_exp : ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖^2 * Real.exp ‖X‖ := by
    convert norm_exp_sub_one_sub_self_le X using 1;
  -- Compute ‖X‖ = ‖-(eps:ℂ)‖ * ‖(I:ℂ) • H‖ = |eps| * (‖I‖ * ‖H‖) = |eps| * ‖H‖ (norm_smul, Complex.norm_I=1, Complex.norm_neg, Complex.norm_real).
  have hX_norm : ‖X‖ ≤ |eps| * B4 kx ky kz m := by
    convert norm_smul_le ( - ( eps : ℂ ) ) ( I • H kx ky kz m ) |> le_trans <| ?_ using 1 ; ring;
    convert mul_le_mul_of_nonneg_left ( norm_smul_le ( I : ℂ ) ( H kx ky kz m ) ) ( abs_nonneg eps ) |> le_trans <| ?_ using 1 ; norm_num [ Complex.norm_exp ];
    exact mul_le_mul_of_nonneg_left ( mul_le_of_le_one_left ( norm_nonneg _ ) ( by norm_num [ Norm.norm ] ) |> le_trans <| norm_H_le_B4 _ _ _ _ ) ( abs_nonneg _ );
  -- Since ‖X‖ ≤ |eps| * B4 and |eps| ≤ 1, we have ‖X‖ ≤ B4.
  have hX_norm_le_B4 : ‖X‖ ≤ B4 kx ky kz m := by
    exact hX_norm.trans ( mul_le_of_le_one_left ( by exact add_nonneg ( add_nonneg ( add_nonneg ( abs_nonneg _ ) ( abs_nonneg _ ) ) ( abs_nonneg _ ) ) ( abs_nonneg _ ) ) heps );
  -- Since ‖X‖ ≤ B4, we have ‖X‖^2 ≤ (|eps| * B4)^2 = eps^2 * B4^2.
  have hX_sq_le_eps_sq_B4_sq : ‖X‖^2 ≤ eps^2 * B4 kx ky kz m^2 := by
    simpa [ mul_pow ] using pow_le_pow_left₀ ( norm_nonneg _ ) hX_norm 2;
  simp_all +decide [ sub_sub ];
  exact h_exp.trans ( mul_le_mul hX_sq_le_eps_sq_B4_sq ( Real.exp_le_exp.mpr hX_norm_le_B4 ) ( by positivity ) ( by positivity ) )

/-
Explicit local Trotter estimate for the actual four-factor `3+1` step.
-/
theorem one_step_to_exact_flow_bound (kx ky kz m eps : ℝ)
    (heps : |eps| ≤ 1) :
    ‖splitStep kx ky kz m eps - exactFlow kx ky kz m eps‖ ≤
      D4 kx ky kz m * eps ^ 2 := by
  convert le_trans _ ( mul_le_mul_of_nonneg_right ( show D4 kx ky kz m ≥ 2 * B4 kx ky kz m ^ 2 * Real.exp ( B4 kx ky kz m ) by
                                                      exact le_of_sub_nonneg ( by unfold D4; ring_nf; positivity ) ) ( sq_nonneg eps ) ) using 1;
  convert le_trans ( norm_sub_le _ _ ) ( add_le_add ( splitStep_sub_lin_bound kx ky kz m eps heps ) ( exactFlow_sub_lin_bound kx ky kz m eps heps ) ) using 1 ; ring;
  · rw [ sub_sub_sub_cancel_right ];
  · ring

theorem unitary_pow_telescope {U V : Mat4}
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hV : V ∈ Matrix.unitaryGroup (Fin 4) ℂ) (n : ℕ) :
    ‖U ^ n - V ^ n‖ ≤ (n : ℝ) * ‖U - V‖ := by
  induction' n with n ih <;> simp_all +decide [ pow_succ _, mul_assoc ];
  -- Apply the triangle inequality to the expression.
  have h_triangle : ‖U ^ n * U - V ^ n * V‖ ≤ ‖U ^ n * (U - V)‖ + ‖(U ^ n - V ^ n) * V‖ := by
    convert norm_add_le ( U ^ n * ( U - V ) ) ( ( U ^ n - V ^ n ) * V ) using 2 ; simp +decide [ mul_sub, sub_mul ];
  -- Since $U$ and $V$ are unitary, we have $\|U^n\| = 1$ and $\|V\| = 1$.
  have h_unitary_norm : ∀ (n : ℕ), ‖U ^ n‖ ≤ 1 ∧ ‖V‖ ≤ 1 := by
    intro n
    have h_unitary_norm : ∀ (M : Mat4), M ∈ Matrix.unitaryGroup (Fin 4) ℂ → ‖M‖ ≤ 1 := by
      intro M hM; rw [ Matrix.unitaryGroup ] at hM; simp_all +decide [ Matrix.IsHermitian, Matrix.mul_apply ] ;
    exact ⟨ h_unitary_norm _ ( Submonoid.pow_mem _ hU _ ), h_unitary_norm _ hV ⟩;
  -- Apply the submultiplicative property of the operator norm.
  have h_submultiplicative : ‖U ^ n * (U - V)‖ ≤ ‖U ^ n‖ * ‖U - V‖ ∧ ‖(U ^ n - V ^ n) * V‖ ≤ ‖U ^ n - V ^ n‖ * ‖V‖ := by
    exact ⟨ norm_mul_le _ _, norm_mul_le _ _ ⟩;
  nlinarith [ h_unitary_norm n, norm_nonneg ( U - V ), norm_nonneg ( U ^ n - V ^ n ) ]

theorem exactFlow_div_pow (kx ky kz m t : ℝ) (n : ℕ) (hn : 0 < n) :
    (exactFlow kx ky kz m (t / (n : ℝ))) ^ n =
      exactFlow kx ky kz m t := by
  -- By definition of exponentiation, we can write $(e^{-(t/n)I H})^n = e^{-(n \cdot (t/n))I H} = e^{-tI H}$.
  have h_exp : ∀ x : Mat4, (NormedSpace.exp x) ^ n = NormedSpace.exp (n • x) := by
    intro x; exact (by
    induction hn <;> simp_all +decide [ pow_succ, add_mul ];
    rw [ Matrix.exp_add_of_commute ];
    simp +decide [ mul_assoc, Algebra.commutes ]);
  convert h_exp _ using 2;
  apply congr_arg NormedSpace.exp;
  simp +decide [ ← smul_assoc, hn.ne', mul_div_cancel₀ ];
  simp +decide [ ← mul_assoc, mul_div_cancel₀, hn.ne' ]

/-
Fixed-momentum `3+1` first-order rate, matching S21's factor order.
-/
theorem fixed_time_many_step_bound (kx ky kz m t : ℝ) (n : ℕ)
    (hn : 0 < n) (hsmall : |t / (n : ℝ)| ≤ 1) :
    ‖(splitStep kx ky kz m (t / (n : ℝ))) ^ n -
        exactFlow kx ky kz m t‖ ≤
      D4 kx ky kz m * t ^ 2 / n := by
  rw [ ← exactFlow_div_pow kx ky kz m t n hn ];
  refine le_trans ( unitary_pow_telescope ( splitStep_mem_unitary kx ky kz m ( t / n ) ) ( exactFlow_mem_unitary kx ky kz m ( t / n ) ) n ) ?_;
  convert mul_le_mul_of_nonneg_left ( one_step_to_exact_flow_bound kx ky kz m ( t / n ) hsmall ) ( Nat.cast_nonneg n ) using 1 ; ring_nf;
  simp +decide [ sq, mul_assoc, hn.ne' ]

def Dbox (K M : ℝ) : ℝ :=
  16 * (3 * K + M) ^ 2 * Real.exp (3 * K + M)

theorem D4_le_Dbox (kx ky kz m K M : ℝ)
    (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hx : |kx| ≤ K) (hy : |ky| ≤ K) (hz : |kz| ≤ K)
    (hm : |m| ≤ M) :
    D4 kx ky kz m ≤ Dbox K M := by
  unfold D4 Dbox;
  gcongr <;> unfold B4 <;> linarith [ abs_nonneg kx, abs_nonneg ky, abs_nonneg kz, abs_nonneg m ]

/-
Uniform compact-momentum and bounded-mass `O(1/n)` theorem.
-/
theorem fixed_time_many_step_bound_on_box
    (kx ky kz m K M t : ℝ) (n : ℕ)
    (hn : 0 < n) (hsmall : |t / (n : ℝ)| ≤ 1)
    (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hx : |kx| ≤ K) (hy : |ky| ≤ K) (hz : |kz| ≤ K)
    (hm : |m| ≤ M) :
    ‖(splitStep kx ky kz m (t / (n : ℝ))) ^ n -
        exactFlow kx ky kz m t‖ ≤
      Dbox K M * t ^ 2 / n := by
  refine' le_trans _ ( div_le_div_of_nonneg_right ( mul_le_mul_of_nonneg_right ( D4_le_Dbox kx ky kz m K M hK hM hx hy hz hm ) ( sq_nonneg t ) ) ( Nat.cast_nonneg n ) );
  convert fixed_time_many_step_bound kx ky kz m t n hn hsmall using 1

theorem box_error_envelope_tendsto_zero (K M t : ℝ) :
    Tendsto (fun n : ℕ => Dbox K M * t ^ 2 / (n + 1 : ℝ))
      atTop (𝓝 0) := by
  exact tendsto_const_nhds.div_atTop ( Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop )

/-
Noncommutation is the exact control forbidding promotion of this naive
unsymmetrized product to a second-order method.
-/
theorem spatial_generators_noncommute :
    alpha1 * alpha2 ≠ alpha2 * alpha1 := by
  unfold alpha1 alpha2;
  intro h; have := congr_fun ( congr_fun h 0 ) 0; norm_num at this;
  norm_num [ Complex.ext_iff ] at this

theorem benchmark_1223_nondegenerate :
    H 1 2 2 3 * H 1 2 2 3 = (18 : ℂ) • (1 : Mat4) ∧
      H 1 2 2 3 ≠ 0 ∧ Dbox 2 3 > 0 := by
  unfold H Dbox;
  refine' ⟨ _, _, by positivity ⟩;
  · simp +decide [ alpha1, alpha2, alpha3, beta ];
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff ];
  · intro h; have := congr_fun ( congr_fun h 0 ) 0; norm_num [ alpha1, alpha2, alpha3, beta ] at this;

end Compact3Plus1DiracRate
