import Mathlib

open scoped BigOperators Matrix.Norms.L2Operator
open Filter Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace UniformMass

abbrev Mat := Matrix (Fin 4) (Fin 4) ℂ

/-- The worst error on the closed mass ball, expressed as a genuine supremum. -/
noncomputable def ballErrorSup (W E : ℂ → ℝ → Mat) (Mb t : ℝ) (n : ℕ) : ℝ :=
  sSup {x : ℝ | ∃ z : ℂ, ‖z‖ ≤ Mb ∧ x = ‖(W z (t / n)) ^ n - E z t‖}

/-
Monotonicity of the local constant turns a pointwise one-step estimate into one
with a single constant on a closed mass ball.
-/
theorem uniform_one_step
    (W E : ℂ → ℝ → Mat) (massMatrix : ℂ → Mat) (K : ℝ → ℝ)
    (c0 Mb : ℝ)
    (hc0 : 0 ≤ c0) (hK_mono : Monotone K)
    (hmass : ∀ z, ‖massMatrix z‖ ≤ c0 * ‖z‖)
    (hone : ∀ z eps, ‖W z eps - E z eps‖ ≤ K ‖massMatrix z‖ * eps ^ 2) :
    ∀ z, ‖z‖ ≤ Mb → ∀ eps,
      ‖W z eps - E z eps‖ ≤ K (c0 * Mb) * eps ^ 2 := by
  intro z hz eps; refine le_trans ( hone z eps ) ?_; gcongr;
  exact hK_mono ( le_trans ( hmass z ) ( mul_le_mul_of_nonneg_left hz hc0 ) )

/-
Telescoping estimate for powers of contractions in the matrix L2 operator norm.
-/
theorem norm_pow_sub_pow_le
    (A B : Mat) (n : ℕ) (hA : ‖A‖ ≤ 1) (hB : ‖B‖ ≤ 1) :
    ‖A ^ n - B ^ n‖ ≤ n * ‖A - B‖ := by
  induction' n with n ih; aesop; (
  -- Using the triangle inequality and the induction hypothesis, we get:
  have h_step : ‖A ^ (n + 1) - B ^ (n + 1)‖ ≤ ‖A ^ n * (A - B)‖ + ‖(A ^ n - B ^ n) * B‖ := by
    convert norm_add_le ( A ^ n * ( A - B ) ) ( ( A ^ n - B ^ n ) * B ) using 1 ; simp +decide [ pow_succ, mul_sub, sub_mul ];
  -- Using the induction hypothesis and the fact that ‖A‖ ≤ 1 and ‖B‖ ≤ 1, we get:
  have h_bound : ‖A ^ n * (A - B)‖ ≤ ‖A - B‖ ∧ ‖(A ^ n - B ^ n) * B‖ ≤ n * ‖A - B‖ := by
    refine' ⟨ le_trans ( Matrix.l2_opNorm_mul _ _ ) _, le_trans ( Matrix.l2_opNorm_mul _ _ ) _ ⟩;
    · refine' mul_le_of_le_one_left ( norm_nonneg _ ) _;
      refine' Nat.recOn n _ _ <;> simp_all +decide [ pow_succ' ];
      exact fun n hn => le_trans ( Matrix.l2_opNorm_mul _ _ ) ( mul_le_one₀ hA ( norm_nonneg _ ) hn );
    · exact le_trans ( mul_le_of_le_one_right ( norm_nonneg _ ) hB ) ih;
  norm_num; linarith;)

/-
An exact additive one-parameter family exponentiates subdivision exactly.
-/
theorem exact_group_pow
    (E : ℝ → Mat) (hadd : ∀ s t, E (s + t) = E s * E t)
    (t : ℝ) {n : ℕ} (hn : 0 < n) :
    (E (t / n)) ^ n = E t := by
  -- By induction on $n$, we can show that $E(k \cdot (t / n)) = (E(t / n))^k$ for any positive integer $k$.
  have h_ind : ∀ k : ℕ, 0 < k → E (k * (t / n)) = (E (t / n)) ^ k := by
    intro k hk; induction hk <;> simp_all +decide [ pow_succ, add_mul ] ;
  rw [ ← h_ind n hn, mul_div_cancel₀ _ ( by positivity ) ]

/-
The uniform many-step estimate.  All constants are independent of `z` inside
`‖z‖ ≤ Mb`.  Unitarity is represented by membership in the matrix unitary group.
-/
theorem uniform_many_step
    (W E : ℂ → ℝ → Mat) (massMatrix : ℂ → Mat) (K : ℝ → ℝ)
    (c0 Mb t : ℝ) (n : ℕ)
    (hc0 : 0 ≤ c0) (hK_mono : Monotone K)
    (hmass : ∀ z, ‖massMatrix z‖ ≤ c0 * ‖z‖)
    (hone : ∀ z eps, ‖W z eps - E z eps‖ ≤ K ‖massMatrix z‖ * eps ^ 2)
    (hWunitary : ∀ z eps, W z eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hEunitary : ∀ z eps, E z eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hEadd : ∀ z s u, E z (s + u) = E z s * E z u)
    (hn : 0 < n) :
    ∀ z, ‖z‖ ≤ Mb →
      ‖(W z (t / n)) ^ n - E z t‖ ≤ K (c0 * Mb) * t ^ 2 / n := by
  intro z hz
  have h_unitary : ∀ A : Mat, A ∈ unitaryGroup (Fin 4) ℂ → ‖A‖ = 1 := by
    intro A hA; rw [ CStarRing.norm_of_mem_unitary ] ; aesop;
  -- Apply the norm_pow_sub_pow_le lemma to A=W z(t/n), B=E z(t/n).
  have h_norm_pow_sub_pow : ‖(W z (t / n)) ^ n - (E z (t / n)) ^ n‖ ≤ n * ‖W z (t / n) - E z (t / n)‖ := by
    apply norm_pow_sub_pow_le; exact h_unitary _ (hWunitary z (t / n)) ▸ le_rfl; exact h_unitary _ (hEunitary z (t / n)) ▸ le_rfl;
  convert h_norm_pow_sub_pow.trans ( mul_le_mul_of_nonneg_left ( hone z ( t / n ) |> le_trans <| mul_le_mul_of_nonneg_right ( hK_mono <| hmass z |> le_trans <| mul_le_mul_of_nonneg_left hz hc0 ) <| sq_nonneg _ ) <| Nat.cast_nonneg _ ) using 1;
  · rw [ exact_group_pow _ ( fun s u => hEadd z s u ) t hn ];
  · field_simp

/-
Supremum version of uniform convergence on a mass ball.  We use `n+1` so every
subdivision count is positive.
-/
theorem ballErrorSup_tendsto_zero
    (W E : ℂ → ℝ → Mat) (massMatrix : ℂ → Mat) (K : ℝ → ℝ)
    (c0 Mb t : ℝ)
    (hc0 : 0 ≤ c0) (hMb : 0 ≤ Mb)
    (hK_mono : Monotone K)
    (hmass : ∀ z, ‖massMatrix z‖ ≤ c0 * ‖z‖)
    (hone : ∀ z eps, ‖W z eps - E z eps‖ ≤ K ‖massMatrix z‖ * eps ^ 2)
    (hWunitary : ∀ z eps, W z eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hEunitary : ∀ z eps, E z eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hEadd : ∀ z s u, E z (s + u) = E z s * E z u) :
    Tendsto (fun n => ballErrorSup W E Mb t (n + 1)) atTop (nhds 0) := by
  refine' squeeze_zero ( fun n => _ ) ( fun n => _ ) ( show Filter.Tendsto ( fun n : ℕ => K ( c0 * Mb ) * t ^ 2 / ( n + 1 ) ) Filter.atTop ( nhds 0 ) from _ );
  · apply_rules [ Real.sSup_nonneg ] ; aesop;
  · refine' csSup_le _ _;
    · exact ⟨ _, ⟨ 0, by simpa using hMb, rfl ⟩ ⟩;
    · rintro x ⟨ z, hz, rfl ⟩ ; convert uniform_many_step W E massMatrix K c0 Mb t ( n + 1 ) hc0 hK_mono hmass hone hWunitary hEunitary hEadd ( Nat.succ_pos n ) z hz using 1 ; push_cast ; ring;
  · exact tendsto_const_nhds.div_atTop ( Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop )

/-
The positive-part function is an explicit monotone, nonnegative, unbounded
choice of local constant. Thus no finite constant can dominate it over all masses.
-/
theorem unbounded_monotone_constant_witness :
    ∃ K : ℝ → ℝ, Monotone K ∧ (∀ z : ℂ, 0 ≤ K ‖z‖) ∧
      ∀ A : ℝ, ∃ z : ℂ, A < K ‖z‖ := by
  refine' ⟨ fun x => if 0 ≤ x then x else 0, _, _, _ ⟩ <;> norm_num [ Monotone ];
  · intro a b h; split_ifs <;> linarith;
  · exact fun A => by rcases exists_nat_gt A with ⟨ n, hn ⟩ ; exact ⟨ n, by simpa using hn ⟩ ;

end UniformMass
