/-
# HNU compact-momentum one-step `O(eps^2)` and many-step `O(1/n)` continuum bound (LIVE endpoint)

Live-integration successor to `HNUManyStepContinuum`.  This module targets the
**live** repository endpoint `PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint`
(imported from `HNUExactCore`), **not** the standalone `HNUExactCore.Core`
endpoint used previously.  It provides a *quantitative* comparison of the exact
live HNU single-Weyl Floquet endpoint `U(k)` against the continuum Weyl flow
`exp(-i eps H_W(q))`, for compact momentum `q` and small step `eps`, followed by
a fixed-time many-step telescope that vanishes as `1/n`.

The live core exposes only `endpoint`/`Uplus`/`Uminus` (no rotation
factorisation).  We define the indexed Pauli aliases and the `Rrot`/`Mrot`
rotation word locally and prove the exact factorisation
`endpoint k = Mrot k * Mrot k` **directly for the live endpoint**
(`endpoint_eq_Msq`), preserving signs, rightmost-first factor order, and the
`k₃/2` half-step normalisation.  No second physical endpoint is introduced:
`Wend` is definitionally the live `endpoint`.

## Objects (matching the HNU tangent theorem, signs preserved)

* `Hw q = q₀ σ₁ + q₁ σ₂ + q₂ σ₃`   (the Weyl Hamiltonian symbol);
* `Wend q eps = endpoint (eps • q)` (the exact HNU endpoint at rescaled momentum);
* `Eflow q eps = exp(-i eps Hw q)`  (the continuum flow);
* `firstOrder q eps = 1 - (i eps) Hw q`.

The sign convention agrees with the live endpoint tangent:
to first order `endpoint (eps • q) = 1 - i eps (q·σ) + O(eps²)`, i.e. the tangent
generator is `-i (k·σ)`, exactly the generator of `Eflow`.

## What is proved

* `one_step_bound`  : `‖Wend q eps - Eflow q eps‖ ≤ Cbound q * eps²` for `|eps| ≤ 1`,
  an explicit compact-momentum second-order local remainder in the L2 operator norm;
* `many_step_bound` : with `eps = t/n`, `‖(Wend q (t/n))ⁿ - Eflow q t‖ ≤ Cbound q * t²/n`,
  obtained by an exact-unitary telescope with no exponential-in-`n` loss;
* `many_step_tendsto`: the `n`-step endpoint word converges to the exact flow.

All theorem *shapes* are reused from `FixedMomentumManyStepContinuum.lean`; the
`1+1` split-step walk there is **not** identified with the HNU endpoint — the
bounds below are proved for the actual HNU endpoint via its `U = M²` rotation
factorisation.

No position-space, full-`L²`, Lorentz, winding, chirality, or primitive-null
claim is made here.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.HNUExactCore

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HNUManyStepContinuum

open PhysicsSM.Draft.NullEdge.HNUExactCore

abbrev Mat := Matrix (Fin 2) (Fin 2) ℂ

/-! ## Local indexed Pauli aliases and rotation factorisation for the LIVE endpoint

The live core `PhysicsSM.Draft.NullEdge.HNUExactCore` exposes only the depth-eight
`endpoint` together with the substep symbols `Uplus`/`Uminus` (parametrised by a
Pauli matrix argument).  It carries **no** `Rrot`/`Mrot` rotation factorisation.
We define those objects locally here (as permitted) and prove the exact
factorisation `endpoint k = Mrot k * Mrot k` **directly for the live endpoint**,
with identical signs, rightmost-first factor order, and the `k₃/2` half-step
normalisation.  We do **not** duplicate the exact core and we do **not** define a
second physical endpoint: `Wend` below is definitionally the live `endpoint`. -/

noncomputable section LocalRotationBridge

/-- `σ₁ = σx`. -/
def sx : Mat := !![0, 1; 1, 0]
/-- `σ₂ = σy`. -/
def sy : Mat := !![0, -I; I, 0]
/-- `σ₃ = σz`. -/
def sz : Mat := !![1, 0; 0, -1]

/-- The three Pauli matrices indexed by `j : Fin 3`. -/
def pauli : Fin 3 → Mat
  | 0 => sx
  | 1 => sy
  | 2 => sz

/-- The local indexed Pauli matrices coincide with the live core's `σ₁, σ₂, σ₃`. -/
lemma sigma1_eq : σ1 = pauli 0 := rfl
lemma sigma2_eq : σ2 = pauli 1 := rfl
lemma sigma3_eq : σ3 = pauli 2 := rfl

/-- SU(2) rotation `R_j(θ) = cos θ · σ₀ - i sin θ · σ_j`. -/
def Rrot (j : Fin 3) (θ : ℝ) : Mat :=
  (Real.cos θ : ℂ) • (1 : Mat) - (I * (Real.sin θ : ℂ)) • pauli j

/-- The half-period rotation word `M(k)` (rightmost factor acts first). -/
def Mrot (k : Fin 3 → ℝ) : Mat :=
  Rrot 0 (k 0 / 2) * Rrot 2 (k 2 / 4) * Rrot 1 (k 1 / 2) * Rrot 2 (k 2 / 4)

/-
Rotations about a fixed axis add: `R_j(θ) R_j(φ) = R_j(θ+φ)`.
-/
lemma Rrot_add (j : Fin 3) (θ φ : ℝ) : Rrot j θ * Rrot j φ = Rrot j (θ + φ) := by
  fin_cases j <;> simp +decide [ Rrot, pauli ] <;> ring_nf;
  · simp +decide [ sx, Complex.cos_add, Complex.sin_add, mul_assoc, mul_left_comm, mul_comm ] ; ring;
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Complex.ext_iff ] <;> ring;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.cos_add, Complex.sin_add, Matrix.mul_apply ] <;> ring;
    · unfold sy; norm_num ; ring;
      norm_num;
    · unfold sy; norm_num;
    · simp +decide [ sy, sx, sz ];
    · unfold sy; norm_num ; ring;
      norm_num;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.cos_add, Complex.sin_add, Matrix.mul_apply, sz ] <;> ring; all_goals norm_num ; ring

/-
Live `U⁺(σ_j, θ)` factorises as a phase times a half-angle rotation.
-/
lemma Uplus_factor (j : Fin 3) (θ : ℝ) :
    Uplus (pauli j) θ = Complex.exp (-(I * (θ : ℂ)) / 2) • Rrot j (θ / 2) := by
      fin_cases j <;> ext a b <;> simp +decide [ Uplus, Pplus, Pminus, Rrot, pauli ] <;> ring_nf <;> norm_num [ Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ] ; ring_nf ;
      · norm_num [ sq, mul_assoc, ← Complex.exp_add ] ; ring;
      · fin_cases a <;> fin_cases b <;> simp +decide [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, sy ] <;> ring_nf <;> norm_num [ ← Complex.exp_add ] ; ring_nf ;
        · rw [ show θ = 2 * ( θ / 2 ) by ring, Real.cos_two_mul, Real.sin_two_mul ] ; ring ; norm_num;
        · rw [ show θ = 2 * ( θ / 2 ) by ring, Real.sin_two_mul, Real.cos_two_mul ] ; ring ; norm_num;
          rw [ Real.sin_sq ];
        · rw [ show θ = 2 * ( θ / 2 ) by ring, Real.sin_two_mul, Real.cos_two_mul ] ; ring ; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
        · rw [ show θ = 2 * ( θ / 2 ) by ring, Real.cos_two_mul, Real.sin_two_mul ] ; ring ; norm_num;
      · fin_cases a <;> fin_cases b <;> norm_num [ sz ] <;> ring_nf <;> norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ] <;> ring_nf;
        · norm_num [ sq, Complex.exp_re, Complex.exp_im, mul_div ] ; ring_nf ; norm_num [ Real.cos_two_mul, Real.sin_two_mul ] ; ring;
          exact ⟨ by rw [ ← Real.cos_two_mul' ] ; ring, by rw [ show θ = 2 * ( θ / 2 ) by ring, Real.sin_two_mul ] ; ring ⟩;
        · norm_num [ Real.cos_sq' ]

/-
Live `U⁻(σ_j, θ)` factorises as a phase times a half-angle rotation.
-/
lemma Uminus_factor (j : Fin 3) (θ : ℝ) :
    Uminus (pauli j) θ = Complex.exp ((I * (θ : ℂ)) / 2) • Rrot j (θ / 2) := by
      fin_cases j <;> simp +decide [ Uminus, Rrot ];
      · unfold Pplus Pminus pauli sx; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ] <;> ring;
        · rw [ show θ = 2 * ( θ / 2 ) by ring, Real.cos_two_mul, Real.sin_two_mul ] ; ring ; norm_num;
        · rw [ Real.sin_sq, Real.cos_sq ] ; ring ; norm_num [ mul_div ] ; ring;
          rw [ show θ = 2 * ( θ / 2 ) by ring, Real.sin_two_mul ] ; ring;
        · rw [ Real.sin_sq, Real.cos_sq ] ; ring ; norm_num;
          rw [ show θ = 2 * ( θ / 2 ) by ring, Real.sin_two_mul ] ; ring;
        · rw [ show θ = 2 * ( θ / 2 ) by ring, Real.cos_two_mul, Real.sin_two_mul ] ; ring ; norm_num;
      · unfold Pminus Pplus pauli; norm_num [ Complex.cos, Complex.sin, Complex.exp_re, Complex.exp_im ] ; ring;
        ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ] <;> ring;
        · norm_num [ sy ] ; rw [ show θ = 2 * ( θ / 2 ) by ring, Real.sin_two_mul, Real.cos_two_mul ] ; ring ; norm_num;
        · unfold sy; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
          exact ⟨ by rw [ show θ = 2 * ( θ / 2 ) by ring, Real.sin_two_mul ] ; ring, trivial ⟩;
        · rw [ show θ = 2 * ( θ / 2 ) by ring, Real.sin_two_mul, Real.sin_sq, Real.cos_sq ] ; ring ; norm_num;
        · norm_num [ sy ] ; ring ; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
          exact ⟨ trivial, by rw [ show θ = 2 * ( θ / 2 ) by ring, Real.sin_two_mul ] ; ring ⟩;
      · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ] <;> ring;
        · unfold Pplus Pminus; norm_num [ ← Complex.exp_nat_mul, ← Complex.exp_add ] ; ring;
        · norm_num [ sq, ← Complex.exp_add, Pplus, Pminus, pauli ] ; ring;
        · norm_num [ sq, ← Complex.exp_add, Pplus, Pminus, pauli ] ; ring;
        · unfold Pminus Pplus; norm_num [ ← Complex.exp_nat_mul, ← Complex.exp_add ] ; ring;

/-
**Exact factorisation of the LIVE endpoint** as the square of the rotation
word `M(k)`.  Signs, rightmost-first factor order, and the `k₃/2` half-step
normalisation are all preserved.
-/
theorem endpoint_eq_Msq (k : Fin 3 → ℝ) :
    endpoint k = Mrot k * Mrot k := by
      unfold endpoint Mrot; simp +decide [ sigma1_eq, sigma2_eq, sigma3_eq, Uplus_factor, Uminus_factor ];
      norm_num [ ← smul_assoc, ← Complex.exp_add ] ; ring;
      norm_num [ ← mul_assoc ]

/-
Along each coordinate axis the live endpoint reduces to a single rotation.
-/
lemma endpoint_along_axis (j : Fin 3) (t : ℝ) :
    endpoint (Function.update (fun _ => 0) j t) = Rrot j t := by
      convert endpoint_eq_Msq _;
      fin_cases j <;> simp +decide [ Mrot ];
      · convert Rrot_add 0 ( t / 2 ) ( t / 2 ) using 1 ; ring;
        · convert Rrot_add 0 ( t * ( 1 / 2 ) ) ( t * ( 1 / 2 ) ) |> Eq.symm using 1 ; ring;
        · convert Rrot_add 0 ( t / 2 ) ( t / 2 ) using 1 ; norm_num [ Rrot ];
      · convert Rrot_add 1 ( t / 2 ) ( t / 2 ) using 1 ; ring;
        · convert Rrot_add 1 ( t * ( 1 / 2 ) ) ( t * ( 1 / 2 ) ) |> Eq.symm using 1 ; ring;
        · convert Rrot_add 1 ( t / 2 ) ( t / 2 ) using 1 ; ring;
          unfold Rrot; norm_num;
      · unfold Rrot; norm_num [ Complex.ext_iff ] ; ring;
        unfold pauli; norm_num [ Matrix.mul_apply, Matrix.smul_eq_diagonal_mul ] ; ring;
        ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, sz ] <;> ring;
        · rw [ show ( t : ℂ ) = 2 * ( t / 2 ) by ring, show ( t / 2 : ℂ ) = 2 * ( t / 4 ) by ring ] ; norm_num [ Complex.cos_two_mul, Complex.sin_two_mul, pow_three ] ; ring;
          rw [ show Complex.sin _ ^ 4 = ( Complex.sin _ ^ 2 ) ^ 2 by ring, show Complex.sin _ ^ 3 = Complex.sin _ * Complex.sin _ ^ 2 by ring ] ; rw [ Complex.sin_sq ] ; ring;
        · rw [ show ( t : ℂ ) = 2 * ( t / 2 ) by ring, show ( t / 2 : ℂ ) = 2 * ( t / 4 ) by ring ] ; norm_num [ Complex.cos_two_mul, Complex.sin_two_mul, pow_three ] ; ring;
          rw [ show Complex.sin _ ^ 4 = ( Complex.sin _ ^ 2 ) ^ 2 by ring, show Complex.sin _ ^ 3 = Complex.sin _ * Complex.sin _ ^ 2 by ring ] ; rw [ Complex.sin_sq ] ; ring;

end LocalRotationBridge

/-! ## Reused infrastructure (copied verbatim from `FixedMomentumManyStepContinuum`) -/

/-- Entrywise max of a `2×2` matrix. -/
noncomputable def entryMax (A : Mat) : ℝ :=
  max (max ‖A 0 0‖ ‖A 0 1‖) (max ‖A 1 0‖ ‖A 1 1‖)

theorem l2_opNorm_le_two_entryMax (A : Mat) :
    ‖A‖ ≤ 2 * entryMax A := by
  set c := entryMax A with hc
  have hc_nonneg : 0 ≤ c := by
    exact le_max_of_le_left ( le_max_of_le_left ( norm_nonneg _ ) );
  have h_bound : ∀ i j, ‖A i j‖ ≤ c := by
    intro i j; fin_cases i <;> fin_cases j <;> unfold entryMax at * <;> aesop;
  convert ContinuousLinearMap.opNorm_le_bound _ _ _ using 1;
  · positivity;
  · intro x; erw [ EuclideanSpace.norm_eq ] ; simp +decide [ Fin.sum_univ_two, Matrix.mulVec ] ; ring_nf; (
    have h_triangle : ‖A 0 0 * x.ofLp 0 + A 0 1 * x.ofLp 1‖ ≤ c * (‖x.ofLp 0‖ + ‖x.ofLp 1‖) ∧ ‖x.ofLp 0 * A 1 0 + x.ofLp 1 * A 1 1‖ ≤ c * (‖x.ofLp 0‖ + ‖x.ofLp 1‖) := by
      refine' ⟨ le_trans ( norm_add_le _ _ ) _, le_trans ( norm_add_le _ _ ) _ ⟩ <;> norm_num [ mul_add, mul_comm ]; all_goals exact add_le_add ( mul_le_mul_of_nonneg_right ( h_bound _ _ ) ( norm_nonneg _ ) ) ( mul_le_mul_of_nonneg_right ( h_bound _ _ ) ( norm_nonneg _ ) );
    rw [ EuclideanSpace.norm_eq ] ; norm_num [ Fin.sum_univ_two ] ; ring_nf at * ; (
    rw [ Real.sqrt_le_iff ] ; ring_nf at * ; norm_num at *;
    exact ⟨ by positivity, by rw [ Real.sq_sqrt <| by positivity ] ; nlinarith [ sq_nonneg ( ‖x.ofLp 0‖ - ‖x.ofLp 1‖ ), mul_nonneg hc_nonneg <| norm_nonneg <| x.ofLp 0, mul_nonneg hc_nonneg <| norm_nonneg <| x.ofLp 1, pow_le_pow_left₀ ( by positivity ) h_triangle.1 2, pow_le_pow_left₀ ( by positivity ) h_triangle.2 2 ] ⟩););

theorem abs_one_sub_cos_le (x : ℝ) : |1 - Real.cos x| ≤ x ^ 2 / 2 := by
  have h_cos_bound : 1 - x^2 / 2 ≤ Real.cos x := by
    apply Real.one_sub_sq_div_two_le_cos;
  exact abs_le.mpr ⟨ by linarith [ Real.cos_le_one x ], by linarith [ Real.cos_le_one x ] ⟩

theorem abs_sub_sin_le (x : ℝ) : |x - Real.sin x| ≤ x ^ 2 / 2 := by
  by_contra! h_contra;
  have h_g_nonneg : ∀ x : ℝ, 0 ≤ x → x^2 / 2 - x + Real.sin x ≥ 0 := by
    have h_g_deriv_nonneg : ∀ x : ℝ, 0 ≤ x → x - 1 + Real.cos x ≥ 0 := by
      intro x hx_nonneg
      have h_cos_bound : ∀ x : ℝ, 0 ≤ x → Real.cos x ≥ 1 - x^2 / 2 := by
        exact fun _ _ => Real.one_sub_sq_div_two_le_cos
      nlinarith [ h_cos_bound x hx_nonneg, Real.cos_sq' x ];
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

theorem norm_exp_sub_one_sub_le (X : Mat) :
    ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖ ^ 2 / 2 * Real.exp ‖X‖ := by
  set A := NormedSpace.exp X - 1 - X with hA_def;
  have hA_series : A = ∑' n : ℕ, (1 / (Nat.factorial (n + 2)) : ℂ) • X ^ (n + 2) := by
    have hA_series : A = ∑' n : ℕ, (1 / (Nat.factorial n) : ℂ) • X ^ n - 1 - X := by
      convert rfl;
      norm_num [ NormedSpace.exp_eq_tsum ];
      grind +suggestions;
    rw [ hA_series, ← Summable.sum_add_tsum_nat_add 2 ];
    · norm_num [ Finset.sum_range_succ ] ; abel1;
    · refine' .of_norm _;
      have h_norm_pow : ∀ n : ℕ, ‖X ^ n‖ ≤ ‖X‖ ^ n := by
        exact fun n => norm_pow_le X n
      simp_all +decide [ norm_smul ];
      exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow n ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using Real.summable_pow_div_factorial ‖X‖ );
  have hA_norm : ‖A‖ ≤ ∑' n : ℕ, (‖X‖ ^ (n + 2) / (Nat.factorial (n + 2)) : ℝ) := by
    refine' hA_series ▸ le_trans ( norm_tsum_le_tsum_norm _ ) _;
    · have h_norm_pow : ∀ n : ℕ, ‖X ^ (n + 2)‖ ≤ ‖X‖ ^ (n + 2) := by
        intro n;
        exact norm_pow_le X (n + 2)
      simp_all +decide [ norm_smul ];
      exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow n ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _ );
    · refine' Summable.tsum_le_tsum _ _ _;
      · intro n; rw [ norm_smul, norm_div ] ; norm_num ; ring_nf;
        rw [ mul_assoc ] ; gcongr ; ring_nf ;
        rw [ ← pow_add ] ; exact norm_pow_le' _ ( by norm_num ) ;
      · have h_norm_pow : ∀ n : ℕ, ‖X ^ n‖ ≤ ‖X‖ ^ n := by
          intro n; induction n <;> simp_all +decide [ pow_succ' ] ;
          exact le_trans ( norm_mul_le _ _ ) ( mul_le_mul_of_nonneg_left ‹_› ( norm_nonneg _ ) );
        norm_num [ norm_smul ];
        exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow _ ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _ );
      · exact Real.summable_pow_div_factorial _ |> Summable.comp_injective <| add_left_injective 2;
  have h_sum_bound : ∑' n : ℕ, (‖X‖ ^ (n + 2) / (Nat.factorial (n + 2)) : ℝ) ≤ (‖X‖ ^ 2 / 2) * ∑' n : ℕ, (‖X‖ ^ n / (Nat.factorial n) : ℝ) := by
    rw [ ← tsum_mul_left ] ; refine' Summable.tsum_le_tsum _ _ _;
    · intro n; rw [ div_mul_div_comm ] ; rw [ div_le_div_iff₀ ] <;> first | positivity | norm_cast ; ring_nf ;
      exact mul_le_mul_of_nonneg_left ( mod_cast by rw [ add_comm ] ; exact Nat.factorial_mul_factorial_dvd_factorial_add _ _ |> Nat.le_of_dvd ( by positivity ) ) ( by positivity );
    · exact Real.summable_pow_div_factorial _ |> Summable.comp_injective <| Nat.succ_injective.comp <| Nat.succ_injective;
    · exact Summable.mul_left _ <| Real.summable_pow_div_factorial _;
  exact hA_norm.trans <| h_sum_bound.trans_eq <| by rw [ Real.exp_eq_exp_ℝ ] ; rw [ NormedSpace.exp_eq_tsum_div ] ;

theorem unitary_pow_telescope {U V : Mat}
    (hU : U ∈ Matrix.unitaryGroup (Fin 2) ℂ)
    (hV : V ∈ Matrix.unitaryGroup (Fin 2) ℂ) (n : ℕ) :
    ‖U ^ n - V ^ n‖ ≤ (n : ℝ) * ‖U - V‖ := by
  induction' n with n ih;
  · norm_num [ Norm.norm ];
  · have h_succ : U ^ (n + 1) - V ^ (n + 1) = U * (U ^ n - V ^ n) + (U - V) * V ^ n := by
      simp +decide [ pow_succ', mul_sub, sub_mul ];
    have h_unitary : ‖U‖ = 1 ∧ ‖V‖ = 1 := by
      exact ⟨ CStarRing.norm_of_mem_unitary hU, CStarRing.norm_of_mem_unitary hV ⟩;
    have h_Vn : ‖V ^ n‖ ≤ 1 := by
      refine' Nat.recOn n _ _ <;> simp_all +decide [ pow_succ' ];
      exact fun n hn => le_trans ( norm_mul_le _ _ ) ( by simpa [ hV ] using hn );
    have h_ind : ‖U * (U ^ n - V ^ n)‖ ≤ ‖U ^ n - V ^ n‖ ∧ ‖(U - V) * V ^ n‖ ≤ ‖U - V‖ := by
      exact ⟨ by simpa [ h_unitary ] using norm_mul_le U ( U ^ n - V ^ n ), by simpa [ h_unitary ] using norm_mul_le ( U - V ) ( V ^ n ) |> le_trans <| mul_le_of_le_one_right ( norm_nonneg _ ) h_Vn ⟩;
    exact h_succ.symm ▸ le_trans ( norm_add_le _ _ ) ( by push_cast; linarith )

/-! ## HNU-specific objects -/

noncomputable section

/-- The Weyl Hamiltonian symbol `H_W(q) = q₀ σ₁ + q₁ σ₂ + q₂ σ₃`. -/
def Hw (q : Fin 3 → ℝ) : Mat :=
  (q 0 : ℂ) • sx + (q 1 : ℂ) • sy + (q 2 : ℂ) • sz

/-- The exact HNU endpoint at rescaled compact momentum `W(q, eps) = U(eps • q)`. -/
def Wend (q : Fin 3 → ℝ) (eps : ℝ) : Mat := endpoint (fun i => eps * q i)

/-- The continuum Weyl flow `E(q, eps) = exp(-i eps H_W(q))`. -/
def Eflow (q : Fin 3 → ℝ) (eps : ℝ) : Mat :=
  NormedSpace.exp ((-(eps : ℂ)) • (I • Hw q))

/-- First-order term `1 - i eps H_W(q)`. -/
def firstOrder (q : Fin 3 → ℝ) (eps : ℝ) : Mat := 1 - (I * (eps : ℂ)) • Hw q

/-- First-order term of the half-period rotation word `M`: `1 - (i eps/2) H_W(q)`. -/
def Mfirst (q : Fin 3 → ℝ) (eps : ℝ) : Mat := 1 - (I * (eps : ℂ) / 2) • Hw q

/-- Compact-momentum magnitude `|q₀| + |q₁| + |q₂|`. -/
def qAbs (q : Fin 3 → ℝ) : ℝ := |q 0| + |q 1| + |q 2|

/-- Per-factor first-order generator `-(i θ) σ_j` (so `Rrot j θ = 1 + gen j θ + O(θ²)`). -/
def gen (j : Fin 3) (θ : ℝ) : Mat := -(I * (θ : ℂ)) • pauli j

theorem qAbs_nonneg (q : Fin 3 → ℝ) : 0 ≤ qAbs q := by
  unfold qAbs; positivity

/-- Generous explicit constant for the rotation-word remainder `‖M(eps•q) - Mfirst‖`. -/
def CM (q : Fin 3 → ℝ) : ℝ := 40 * (qAbs q) ^ 2 + 40 * (qAbs q) ^ 3

/-- Generous explicit one-step constant. -/
def Cbound (q : Fin 3 → ℝ) : ℝ :=
  CM q * (2 + qAbs q / 2) + (qAbs q) ^ 2 / 4 + (qAbs q) ^ 2 * Real.exp (qAbs q)

theorem CM_nonneg (q : Fin 3 → ℝ) : 0 ≤ CM q := by
  unfold CM; have := qAbs_nonneg q; positivity

theorem Cbound_nonneg (q : Fin 3 → ℝ) : 0 ≤ Cbound q := by
  unfold Cbound
  have h1 := CM_nonneg q
  have h2 := qAbs_nonneg q
  positivity

/-! ## Hermiticity and the norm of `H_W` -/

theorem Hw_isHermitian (q : Fin 3 → ℝ) : (Hw q).IsHermitian := by
  unfold Hw;
  unfold sx sy sz; ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.IsHermitian ] ;

theorem norm_Hw_le (q : Fin 3 → ℝ) : ‖Hw q‖ ≤ qAbs q := by
  refine' le_trans _ ( show qAbs q ≥ ‖( q 0 : ℂ) • sx‖ + ‖( q 1 : ℂ) • sy‖ + ‖( q 2 : ℂ) • sz‖ from _ );
  · exact le_trans ( norm_add₃_le .. ) ( by norm_num );
  · -- By definition of $sx$, $sy$, and $sz$, we know that their norms are 1.
    have h_norm_sx : ‖sx‖ ≤ 1 := by
      refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one _;
      simp +decide [ EuclideanSpace.norm_eq, sx ];
      exact fun x => Real.sqrt_le_sqrt <| by linarith!;
    have h_norm_sy : ‖sy‖ ≤ 1 := by
      refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one _;
      simp +decide [ EuclideanSpace.norm_eq, sy ];
      exact fun x => Real.sqrt_le_sqrt <| by linarith!;
    have h_norm_sz : ‖sz‖ ≤ 1 := by
      convert ContinuousLinearMap.opNorm_le_bound _ zero_le_one _;
      intro x; simp +decide [ sz, EuclideanSpace.norm_eq ];
      rfl;
    simp_all +decide [ norm_smul, qAbs ];
    exact add_le_add_three ( mul_le_of_le_one_right ( abs_nonneg _ ) h_norm_sx ) ( mul_le_of_le_one_right ( abs_nonneg _ ) h_norm_sy ) ( mul_le_of_le_one_right ( abs_nonneg _ ) h_norm_sz )

/-! ## Single-rotation first-order control -/

/-
Each `Rrot` is unitary for real angles.
-/
theorem Rrot_mem_unitary (j : Fin 3) (θ : ℝ) :
    Rrot j θ ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  apply Matrix.mem_unitaryGroup_iff'.mpr;
  fin_cases j <;> ext a b <;> fin_cases a <;> fin_cases b <;> simp +decide [ Rrot, pauli, sx, sy, sz, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply, star, Complex.ext_iff ] <;> ring_nf;
  all_goals norm_cast; norm_num [ Real.sin_sq, Real.cos_sq ] ;

theorem norm_Rrot (j : Fin 3) (θ : ℝ) : ‖Rrot j θ‖ = 1 :=
  CStarRing.norm_of_mem_unitary (Rrot_mem_unitary j θ)

/-
Entrywise `O(θ²)` bound of one rotation against its first-order term.
-/
theorem Rrot_sub_gen_bound (j : Fin 3) (θ : ℝ) :
    ‖Rrot j θ - (1 + gen j θ)‖ ≤ 2 * θ ^ 2 := by
  refine' le_trans ( l2_opNorm_le_two_entryMax _ ) _;
  fin_cases j <;> simp +decide [ entryMax, Rrot, gen, pauli ];
  · norm_num [ Complex.normSq, Complex.norm_def, sx ];
    norm_cast;
    rw [ Real.sqrt_mul_self_eq_abs, Real.sqrt_mul_self_eq_abs ];
    have := abs_one_sub_cos_le θ; have := abs_sub_sin_le θ; simp_all +decide [ abs_sub_comm ];
    grind;
  · simp +decide [ Complex.normSq, Complex.norm_def, sy ];
    norm_cast;
    rw [ Real.sqrt_mul_self_eq_abs, Real.sqrt_mul_self_eq_abs, Real.sqrt_mul_self_eq_abs ];
    have := abs_one_sub_cos_le θ; have := abs_sub_sin_le θ; simp_all +decide [ abs_sub_comm ];
    grind;
  · simp +decide [ sz ];
    norm_num [ Complex.normSq, Complex.norm_def ];
    norm_cast;
    refine' ⟨ ⟨ _, sq_nonneg _ ⟩, sq_nonneg _, _ ⟩; all_goals rw [ Real.sqrt_le_left ] <;> nlinarith [ abs_one_sub_cos_le θ, abs_sub_sin_le θ, abs_le.mp ( abs_one_sub_cos_le θ ), abs_le.mp ( abs_sub_sin_le θ ) ]

theorem norm_gen_le (j : Fin 3) (θ : ℝ) : ‖gen j θ‖ ≤ 2 * |θ| := by
  convert l2_opNorm_le_two_entryMax _ |> le_trans <| mul_le_mul_of_nonneg_left ( show entryMax ( gen j θ ) ≤ |θ| from ?_ ) zero_le_two using 1;
  unfold entryMax gen; fin_cases j <;> simp +decide [ pauli ] ;
  · unfold sx; norm_num;
  · unfold sy; norm_num [ Complex.normSq, Complex.norm_def ] ;
  · unfold sz; norm_num

/-
`‖Rrot j θ - 1‖ ≤ 2|θ| + 2θ²`.
-/
theorem norm_Rrot_sub_one (j : Fin 3) (θ : ℝ) :
    ‖Rrot j θ - 1‖ ≤ 2 * |θ| + 2 * θ ^ 2 := by
  -- Apply the norm_sub_le lemma to split the norm into two parts.
  have h_split : ‖Rrot j θ - 1‖ ≤ ‖Rrot j θ - (1 + gen j θ)‖ + ‖gen j θ‖ := by
    convert norm_add_le ( Rrot j θ - ( 1 + gen j θ ) ) ( gen j θ ) using 2 ; abel_nf;
  linarith [ Rrot_sub_gen_bound j θ, norm_gen_le j θ ]

/-! ## Binary near-identity product telescope -/

/-
If `A ≈ 1 + X` and `B ≈ 1 + Y`, then `A B ≈ 1 + (X + Y)` with the stated remainder.
This uses the exact identity
`A B - (1 + (X + Y)) = (A - (1 + X)) B + X (B - 1) + (B - (1 + Y))`.
-/
theorem prod_sub_add (A B X Y : Mat) {a x b1 nb bY : ℝ}
    (hA : ‖A - (1 + X)‖ ≤ a) (hX : ‖X‖ ≤ x)
    (hB1 : ‖B - 1‖ ≤ b1) (hnB : ‖B‖ ≤ nb) (hBY : ‖B - (1 + Y)‖ ≤ bY)
    (hb1 : 0 ≤ b1) (hnb : 0 ≤ nb) :
    ‖A * B - (1 + (X + Y))‖ ≤ a * nb + x * b1 + bY := by
  convert norm_add_le ( ( A - ( 1 + X ) ) * B + X * ( B - 1 ) ) ( B - ( 1 + Y ) ) |> le_trans <| ?_ using 1;
  · simp +decide [ add_mul, mul_add, mul_sub, sub_mul, add_assoc, add_sub_assoc ];
    exact congr_arg Norm.norm ( by abel1 );
  · refine' le_trans ( add_le_add ( norm_add_le _ _ ) le_rfl ) _;
    gcongr;
    · exact le_trans ( norm_mul_le _ _ ) ( mul_le_mul hA hnB ( by positivity ) ( by linarith [ norm_nonneg ( A - ( 1 + X ) ) ] ) );
    · exact le_trans ( norm_mul_le _ _ ) ( mul_le_mul hX hB1 ( by positivity ) ( by linarith [ norm_nonneg X ] ) )

/-! ## Rotation-word remainder `‖M(eps•q) - Mfirst‖ ≤ CM q · eps²` -/

/-
`Mfirst` is exactly `1 +` the sum of the four rotation generators of `M(eps•q)`.
-/
theorem Mfirst_eq_gensum (q : Fin 3 → ℝ) (eps : ℝ) :
    Mfirst q eps =
      1 + (((gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)) + gen 1 (eps * q 1 / 2))
        + gen 2 (eps * q 2 / 4)) := by
  unfold Mfirst gen;
  unfold Hw; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ pauli ] <;> ring;

/-
`M(k)` is unitary.
-/
theorem Mrot_mem_unitary (k : Fin 3 → ℝ) :
    Mrot k ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  exact Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Rrot_mem_unitary _ _ ) ( Rrot_mem_unitary _ _ ) ) ( Rrot_mem_unitary _ _ ) ) ( Rrot_mem_unitary _ _ )

theorem norm_Mrot (k : Fin 3 → ℝ) : ‖Mrot k‖ = 1 :=
  CStarRing.norm_of_mem_unitary (Mrot_mem_unitary k)

/-
The rotation-word second-order remainder.
-/
set_option maxHeartbeats 2000000 in
theorem Mrot_sub_Mfirst_bound (q : Fin 3 → ℝ) (eps : ℝ) (heps : |eps| ≤ 1) :
    ‖Mrot (fun i => eps * q i) - Mfirst q eps‖ ≤ CM q * eps ^ 2 := by
  unfold Mrot Mfirst CM;
  -- Apply the telescoping bound three times.
  have h1 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)))‖ ≤ 2 * eps ^ 2 * (qAbs q) ^ 2 + (2 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
    refine' le_trans ( prod_sub_add _ _ _ _ _ _ _ _ _ _ _ ) _;
    exact 2 * ( eps * q 0 / 2 ) ^ 2;
    exact 2 * |eps * q 0 / 2|;
    exact 2 * |eps * q 2 / 4| + 2 * ( eps * q 2 / 4 ) ^ 2;
    exact 1;
    exact 2 * ( eps * q 2 / 4 ) ^ 2;
    any_goals positivity;
    exact Rrot_sub_gen_bound _ _;
    · exact norm_gen_le _ _;
    · exact norm_Rrot_sub_one _ _;
    · rw [ norm_Rrot ];
    · exact Rrot_sub_gen_bound _ _;
    · refine' add_le_add_three _ _ _;
      · unfold qAbs;
        nlinarith only [ show 0 ≤ eps ^ 2 * |q 0| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 1| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 2| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, abs_mul_abs_self ( q 0 ), abs_mul_abs_self ( q 1 ), abs_mul_abs_self ( q 2 ) ];
      · refine' mul_le_mul _ _ _ _;
        · unfold qAbs; norm_num [ abs_div, abs_mul ] ; ring_nf;
          nlinarith [ abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ), abs_nonneg eps ];
        · refine' add_le_add _ _;
          · unfold qAbs;
            cases abs_cases eps <;> cases abs_cases ( q 2 ) <;> cases abs_cases ( eps * q 2 / 4 ) <;> nlinarith [ abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ) ];
          · unfold qAbs;
            nlinarith only [ show 0 ≤ eps ^ 2 * |q 2| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 0| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 1| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, abs_mul_abs_self ( q 2 ) ];
        · positivity;
        · exact mul_nonneg ( mul_nonneg zero_le_two ( abs_nonneg _ ) ) ( qAbs_nonneg _ );
      · unfold qAbs;
        nlinarith only [ show 0 ≤ eps ^ 2 * |q 0| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 1| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 2| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, abs_mul_abs_self ( q 0 ), abs_mul_abs_self ( q 1 ), abs_mul_abs_self ( q 2 ) ];
  have h2 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)))‖ ≤ (2 * eps ^ 2 * (qAbs q) ^ 2 + (2 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2) + (4 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
    have h2 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)))‖ ≤ ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)))‖ * 1 + ‖gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)‖ * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
      convert prod_sub_add _ _ _ _ _ _ _ _ _ _ _ using 1;
      all_goals norm_num [ norm_Rrot ];
      · refine' le_trans ( norm_Rrot_sub_one _ _ ) _;
        norm_num [ abs_div, abs_mul, qAbs ];
        nlinarith only [ show 0 ≤ |eps| * |q 1| by positivity, show 0 ≤ |eps| * |q 0| by positivity, show 0 ≤ |eps| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 0| by positivity, show 0 ≤ eps ^ 2 * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 2| by positivity, abs_mul_abs_self eps, abs_mul_abs_self ( q 0 ), abs_mul_abs_self ( q 1 ), abs_mul_abs_self ( q 2 ), abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ) ];
      · refine' le_trans ( Rrot_sub_gen_bound _ _ ) _;
        unfold qAbs;
        nlinarith only [ show 0 ≤ eps ^ 2 * |q 1| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 2| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, abs_mul_abs_self ( q 1 ) ];
      · exact add_nonneg ( mul_nonneg ( mul_nonneg zero_le_two ( abs_nonneg _ ) ) ( qAbs_nonneg _ ) ) ( mul_nonneg ( mul_nonneg zero_le_two ( sq_nonneg _ ) ) ( sq_nonneg _ ) );
    have h3 : ‖gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)‖ ≤ 4 * |eps| * qAbs q := by
      refine' le_trans ( norm_add_le _ _ ) _;
      refine' le_trans ( add_le_add ( norm_gen_le _ _ ) ( norm_gen_le _ _ ) ) _;
      norm_num [ abs_div, abs_mul, qAbs ];
      nlinarith only [ abs_nonneg eps, abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ), heps ];
    nlinarith [ show 0 ≤ |eps| * qAbs q by exact mul_nonneg ( abs_nonneg eps ) ( qAbs_nonneg q ), show 0 ≤ eps ^ 2 * qAbs q ^ 2 by positivity ];
  have h3 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) * Rrot 2 (eps * q 2 / 4) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2) + gen 2 (eps * q 2 / 4)))‖ ≤ (2 * eps ^ 2 * (qAbs q) ^ 2 + (2 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 + (4 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2) + (6 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
    have h3 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) * Rrot 2 (eps * q 2 / 4) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2) + gen 2 (eps * q 2 / 4)))‖ ≤ ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)))‖ * 1 + ‖gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)‖ * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
      convert prod_sub_add _ _ _ _ _ _ _ _ _ _ _ using 1;
      all_goals norm_num;
      · refine' le_trans ( norm_Rrot_sub_one _ _ ) _;
        norm_num [ abs_div, abs_mul, qAbs ];
        nlinarith only [ show 0 ≤ |eps| * |q 2| by positivity, show 0 ≤ |eps| * |q 0| by positivity, show 0 ≤ |eps| * |q 1| by positivity, show 0 ≤ |eps| * |q 2| ^ 2 by positivity, show 0 ≤ |eps| * |q 0| ^ 2 by positivity, show 0 ≤ |eps| * |q 1| ^ 2 by positivity, abs_mul_abs_self eps, abs_mul_abs_self ( q 2 ), abs_mul_abs_self ( q 0 ), abs_mul_abs_self ( q 1 ), heps ];
      · exact le_of_eq ( norm_Rrot _ _ );
      · refine' le_trans ( Rrot_sub_gen_bound _ _ ) _;
        unfold qAbs; ring_nf; norm_num;
        nlinarith only [ show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, show 0 ≤ eps ^ 2 * q 0 ^ 2 by positivity, show 0 ≤ eps ^ 2 * q 1 ^ 2 by positivity, show 0 ≤ eps ^ 2 * q 2 ^ 2 by positivity ];
      · exact add_nonneg ( mul_nonneg ( mul_nonneg zero_le_two ( abs_nonneg _ ) ) ( qAbs_nonneg _ ) ) ( mul_nonneg ( mul_nonneg zero_le_two ( sq_nonneg _ ) ) ( sq_nonneg _ ) );
    have h4 : ‖gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)‖ ≤ 6 * |eps| * qAbs q := by
      refine' le_trans ( norm_add_le _ _ ) ( le_trans ( add_le_add ( norm_add_le _ _ ) le_rfl ) _ );
      refine' le_trans ( add_le_add_three ( norm_gen_le _ _ ) ( norm_gen_le _ _ ) ( norm_gen_le _ _ ) ) _;
      norm_num [ abs_div, abs_mul, qAbs ];
      nlinarith only [ abs_nonneg eps, abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ) ];
    nlinarith [ show 0 ≤ |eps| * qAbs q by exact mul_nonneg ( abs_nonneg eps ) ( qAbs_nonneg q ), show 0 ≤ eps ^ 2 * qAbs q ^ 2 by positivity ];
  refine le_trans ?_ ( h3.trans ?_ );
  · convert le_rfl using 2 ; norm_num [ gen, Hw ] ; ring;
    ext i j ; norm_num [ pauli ] ; ring;
  · rw [ abs_eq_max_neg ] at *;
    rw [ max_def ] at * ; split_ifs at * <;> nlinarith [ show 0 ≤ qAbs q ^ 2 * eps ^ 2 by positivity, show 0 ≤ qAbs q ^ 3 * eps ^ 2 by exact mul_nonneg ( pow_nonneg ( by exact add_nonneg ( add_nonneg ( abs_nonneg _ ) ( abs_nonneg _ ) ) ( abs_nonneg _ ) ) _ ) ( sq_nonneg _ ) ]

/-! ## Endpoint one-step remainder -/

/-
`firstOrder = Mfirst² - ((i eps/2) H_W)²`.
-/
theorem firstOrder_eq_Mfirst_sq_sub (q : Fin 3 → ℝ) (eps : ℝ) :
    firstOrder q eps =
      Mfirst q eps * Mfirst q eps
        - ((I * (eps : ℂ) / 2) • Hw q) * ((I * (eps : ℂ) / 2) • Hw q) := by
  unfold firstOrder Mfirst Hw;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, sx, sy, sz ] <;> ring

/-
Second-order bound of the exact endpoint against its first-order term.
-/
theorem Wend_sub_firstOrder_bound (q : Fin 3 → ℝ) (eps : ℝ) (heps : |eps| ≤ 1) :
    ‖Wend q eps - firstOrder q eps‖
      ≤ (CM q * (2 + qAbs q / 2) + (qAbs q) ^ 2 / 4) * eps ^ 2 := by
  -- Apply the norm_mul_le and norm_add_le lemmas to the first term.
  have h1 : ‖Wend q eps - firstOrder q eps‖ ≤ ‖Mrot (fun i => eps * q i) - Mfirst q eps‖ * (1 + ‖Mfirst q eps‖) + ‖(I * (eps : ℂ) / 2) • Hw q‖ ^ 2 := by
    -- By definition of $Wend$ and $firstOrder$, we have:
    have h_eq : Wend q eps - firstOrder q eps = (Mrot (fun i => eps * q i) - Mfirst q eps) * Mrot (fun i => eps * q i) + Mfirst q eps * (Mrot (fun i => eps * q i) - Mfirst q eps) + ((I * (eps : ℂ) / 2) • Hw q) * ((I * (eps : ℂ) / 2) • Hw q) := by
      unfold Wend firstOrder;
      unfold Mfirst; simp +decide [ sub_mul, mul_sub ] ; ring;
      rw [ endpoint_eq_Msq ] ; ext i j ; norm_num ; ring;
    rw [ h_eq ];
    refine' le_trans ( norm_add_le _ _ ) ( add_le_add ( le_trans ( norm_add_le _ _ ) _ ) _ );
    · refine' le_trans ( add_le_add ( norm_mul_le _ _ ) ( norm_mul_le _ _ ) ) _;
      rw [ norm_Mrot ] ; linarith;
    · simpa only [ sq ] using norm_mul_le _ _;
  -- Apply the norm_smul lemma to the second term.
  have h2 : ‖(I * (eps : ℂ) / 2) • Hw q‖ ≤ (|eps| / 2) * qAbs q := by
    convert norm_smul_le ( I * ( eps : ℂ ) / 2 ) ( Hw q ) |> le_trans <| mul_le_mul_of_nonneg_left ( norm_Hw_le q ) ( by positivity ) using 1 ; norm_num [ abs_div, abs_mul, abs_of_nonneg ];
  -- Apply the norm_one lemma to the third term.
  have h3 : ‖Mfirst q eps‖ ≤ 1 + (|eps| / 2) * qAbs q := by
    exact le_trans ( norm_sub_le _ _ ) ( by simpa using h2 );
  -- Apply the Mrot_sub_Mfirst_bound lemma to the first term.
  have h4 : ‖Mrot (fun i => eps * q i) - Mfirst q eps‖ ≤ CM q * eps ^ 2 := by
    exact Mrot_sub_Mfirst_bound q eps heps;
  refine le_trans h1 ?_;
  refine le_trans ( add_le_add ( mul_le_mul h4 ( add_le_add le_rfl h3 ) ( by positivity ) ( by exact mul_nonneg ( CM_nonneg q ) ( sq_nonneg _ ) ) ) ( pow_le_pow_left₀ ( by positivity ) h2 2 ) ) ?_;
  unfold CM; ring_nf; norm_num [ abs_mul, abs_div ] ;
  nlinarith only [ show 0 ≤ qAbs q ^ 2 * eps ^ 2 by positivity, show 0 ≤ qAbs q ^ 3 * eps ^ 2 by exact mul_nonneg ( pow_nonneg ( qAbs_nonneg q ) _ ) ( sq_nonneg _ ), show 0 ≤ qAbs q ^ 4 * eps ^ 2 by exact mul_nonneg ( pow_nonneg ( qAbs_nonneg q ) _ ) ( sq_nonneg _ ), abs_nonneg eps, heps, show |eps| ≤ 1 by assumption, show |eps| ^ 2 ≤ 1 by nlinarith only [ abs_nonneg eps, heps ] ]

/-
The first-order term matches the exact flow to `O(eps²)`.
-/
theorem firstOrder_sub_Eflow_bound (q : Fin 3 → ℝ) (eps : ℝ) (heps : |eps| ≤ 1) :
    ‖firstOrder q eps - Eflow q eps‖ ≤ (qAbs q) ^ 2 * Real.exp (qAbs q) * eps ^ 2 := by
  have := norm_exp_sub_one_sub_le ( ( - ( eps : ℂ ) ) • ( I • Hw q ) );
  -- Substitute the bounds for ‖A‖ and ‖A‖² into the inequality.
  have h_bounds : ‖(-eps : ℂ) • (I • Hw q)‖ ≤ qAbs q ∧ ‖(-eps : ℂ) • (I • Hw q)‖ ^ 2 ≤ (qAbs q) ^ 2 * eps ^ 2 := by
    have h_bounds : ‖(-eps : ℂ) • (I • Hw q)‖ ≤ |eps| * qAbs q := by
      convert mul_le_mul_of_nonneg_left ( norm_Hw_le q ) ( abs_nonneg eps ) using 1;
      convert norm_smul ( - ( eps : ℂ ) ) ( I • Hw q ) using 1 ; norm_num [ norm_smul ];
    exact ⟨ h_bounds.trans ( mul_le_of_le_one_left ( qAbs_nonneg q ) heps ), by nlinarith [ show 0 ≤ ‖- ( eps : ℂ ) • I • Hw q‖ by positivity, show 0 ≤ qAbs q by exact qAbs_nonneg q, show |eps| ^ 2 = eps ^ 2 by rw [ sq_abs ] ] ⟩;
  convert this.trans _ using 1;
  · rw [ ← norm_neg ] ; congr ; ext i j ; simp +decide [ firstOrder, Eflow, Hw ] ; ring;
  · refine' le_trans ( mul_le_mul_of_nonneg_right ( div_le_self ( sq_nonneg _ ) ( by norm_num ) ) ( Real.exp_nonneg _ ) ) _;
    rw [ mul_right_comm ];
    exact mul_le_mul h_bounds.2 ( Real.exp_le_exp.mpr h_bounds.1 ) ( by positivity ) ( by positivity )

/-
**One-step compact-momentum `O(eps²)` estimate** in the L2 operator norm.
-/
theorem one_step_bound (q : Fin 3 → ℝ) (eps : ℝ) (heps : |eps| ≤ 1) :
    ‖Wend q eps - Eflow q eps‖ ≤ Cbound q * eps ^ 2 := by
  convert norm_add_le ( Wend q eps - firstOrder q eps ) ( firstOrder q eps - Eflow q eps ) |> ( fun h => h.trans ?_ ) using 1;
  · rw [ sub_add_sub_cancel ];
  · convert add_le_add ( Wend_sub_firstOrder_bound q eps heps ) ( firstOrder_sub_Eflow_bound q eps heps ) using 1 ; unfold Cbound ; ring

/-! ## Unitarity and the exact-flow group law -/

theorem Wend_mem_unitary (q : Fin 3 → ℝ) (eps : ℝ) :
    Wend q eps ∈ Matrix.unitaryGroup (Fin 2) ℂ :=
  endpoint_unitary (fun i => eps * q i)

theorem Eflow_mem_unitary (q : Fin 3 → ℝ) (eps : ℝ) :
    Eflow q eps ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  convert NormedSpace.exp_mem_unitary_of_mem_skewAdjoint _;
  · refine' { .. };
    intro r x; exact (by
    convert norm_smul_le ( r : ℝ ) x using 1);
  · infer_instance;
  · infer_instance;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Hw, sx, sy, sz, Matrix.mul_apply ]

/-
Exact short-time flows compose to the time-`t` flow.
-/
theorem Eflow_div_pow (q : Fin 3 → ℝ) (t : ℝ) (n : ℕ) (hn : 0 < n) :
    (Eflow q (t / (n : ℝ))) ^ n = Eflow q t := by
  unfold Eflow; simp +decide [ ← smul_assoc ] ;
  have h_exp_smul : ∀ (x : Mat) (n : ℕ), NormedSpace.exp (n • x) = (NormedSpace.exp x) ^ n := by
    intros x n; exact (by
    rw [ ← Matrix.exp_nsmul ]);
  convert h_exp_smul _ n |> Eq.symm using 2 ; ring;
  ext i j; norm_num [ hn.ne', mul_assoc, mul_left_comm, mul_comm ] ;

/-! ## Fixed-time many-step estimate -/

/-
**Many-step `O(1/n)` estimate**: with `eps = t/n`, the `n`-step endpoint word
converges to the exact Weyl flow at rate `Cbound q · t²/n`.
-/
theorem many_step_bound (q : Fin 3 → ℝ) (t : ℝ) (n : ℕ) (hn : 0 < n)
    (hsmall : |t / (n : ℝ)| ≤ 1) :
    ‖(Wend q (t / (n : ℝ))) ^ n - Eflow q t‖ ≤ Cbound q * t ^ 2 / n := by
  convert unitary_pow_telescope ( Wend_mem_unitary q ( t / n ) ) ( Eflow_mem_unitary q ( t / n ) ) n |> le_trans <| mul_le_mul_of_nonneg_left ( one_step_bound q ( t / n ) hsmall ) <| Nat.cast_nonneg n using 1 ; ring;
  · convert rfl using 2;
    convert congr_arg ( fun x : Mat => Wend q ( t * ( n : ℝ ) ⁻¹ ) ^ n - x ) ( Eflow_div_pow q t n hn ) using 1;
  · field_simp

/-
Compact-momentum many-step convergence as `n → ∞`.
-/
theorem many_step_tendsto (q : Fin 3 → ℝ) (t : ℝ) :
    Filter.Tendsto
      (fun n : ℕ => (Wend q (t / ((n + 1 : ℕ) : ℝ))) ^ (n + 1))
      Filter.atTop (nhds (Eflow q t)) := by
  rw [ tendsto_iff_norm_sub_tendsto_zero ];
  refine' squeeze_zero_norm' _ _;
  use fun n => Cbound q * t ^ 2 / ( n + 1 );
  · refine' Filter.eventually_atTop.mpr ⟨ ⌈|t|⌉₊, fun n hn => _ ⟩;
    convert many_step_bound q t ( n + 1 ) ( Nat.succ_pos _ ) _ using 1 <;> norm_num;
    rw [ abs_div, abs_of_nonneg ( by positivity : 0 ≤ ( n : ℝ ) + 1 ), div_le_iff₀ ] <;> cases abs_cases t <;> nlinarith [ Nat.ceil_le.mp hn ];
  · exact tendsto_const_nhds.div_atTop ( Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop )

/-! ## Nonzero axis witness -/

/-
The Weyl symbol on the `q₀`-axis is `σ₁ ≠ 0`.
-/
theorem Hw_axis_witness : Hw ![1, 0, 0] = sx := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Hw, sx ]

/-
The Weyl symbol on the `q₀`-axis is nonzero: an explicit nonzero axis witness.
-/
theorem Hw_axis_witness_ne_zero : Hw ![1, 0, 0] ≠ 0 := by
  rw [Hw_axis_witness]
  intro h
  have h01 : (sx : Mat) 0 1 = 0 := by rw [h]; rfl
  simp [sx] at h01

/-
On the `q₀`-axis the exact endpoint is a single rotation, `W(e₀, eps) = R₁(eps)`.
-/
theorem Wend_axis_witness (eps : ℝ) : Wend ![1, 0, 0] eps = Rrot 0 eps := by
  -- By definition of `Wend`, we have `Wend ![1, 0, 0] eps = endpoint (fun i => eps * ![1, 0, 0] i)`.
  have h_wend : Wend ![1, 0, 0] eps = endpoint (fun i => eps * ![1, 0, 0] i) := by
    rfl;
  rw [ h_wend, show ( fun i => eps * ![1, 0, 0] i : Fin 3 → ℝ ) = Function.update ( fun _ => 0 ) 0 eps by ext i; fin_cases i <;> simp +decide ] ; exact endpoint_along_axis 0 eps;

end

/-! ## Standard-three axiom footprint of every headline theorem

Each guard is build-enforced: it fails compilation unless the theorem depends
only on the standard three axioms `propext`, `Classical.choice`, `Quot.sound`. -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.endpoint_eq_Msq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms endpoint_eq_Msq
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.endpoint_along_axis' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms endpoint_along_axis
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.one_step_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms one_step_bound
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.Wend_sub_firstOrder_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms Wend_sub_firstOrder_bound
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.firstOrder_sub_Eflow_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms firstOrder_sub_Eflow_bound
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.Mrot_sub_Mfirst_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms Mrot_sub_Mfirst_bound
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.many_step_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms many_step_bound
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.many_step_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms many_step_tendsto
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.Wend_mem_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms Wend_mem_unitary
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.Eflow_mem_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms Eflow_mem_unitary
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.Hw_axis_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms Hw_axis_witness
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.Hw_axis_witness_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms Hw_axis_witness_ne_zero
/-- info: 'PhysicsSM.Draft.NullEdge.HNUManyStepContinuum.Wend_axis_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms Wend_axis_witness

end PhysicsSM.Draft.NullEdge.HNUManyStepContinuum
