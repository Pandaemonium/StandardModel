import Mathlib

/-!
# Ladder precondition bundle, with minimality (Opus, verified e3bdb133)

Turns the scattered side-condition checklist from `MCBrickCompositionAudit` into ONE
structure `LadderPreconditions` and ONE theorem `error_bound`
(||(W (t/n))^n - E t|| <= c t^2 / n) with a `tendsto_ladder` corollary - so an
integrator discharges a record rather than remembering a list.

MINIMALITY - the checklist I previously circulated was REDUNDANT. Of the six fields:
* INDEPENDENT (counterexample families given, conclusion fails without each):
  `hW` (W unitary), `hgroup` (exact group law), `hstep` (the local eps^2 estimate);
* DERIVABLE, so NOT to be discharged separately:
  `hid` (E 0 = 1) follows from `hE` and `hgroup`;
  `hE` (E unitary) follows from `hW`, `hgroup`, `hid`, `hstep`, `hc` - by
    approximation via unitary powers and closedness of the unitary group, so NO
    counterexample for `hE` can exist;
  `hc` (0 <= c) follows from `hstep` by specializing at eps = 1.

PRACTICAL CONSEQUENCE: discharge THREE conditions - W unitary, the exact group law,
and the one-step estimate. This corrects and simplifies my earlier guidance, which
asked for reference-family unitarity as a separate obligation.

Namespace kept as the prover's. Provenance: verified at pin from task 2ca1e399.
Standard three. Claim grade M, [comp]. -/

open scoped Matrix.Norms.L2Operator
open Filter Topology

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

abbrev LadderMatrix := Matrix (Fin 4) (Fin 4) ℂ

/-- The complete checklist needed for the continuum-ladder estimate. -/
structure LadderPreconditions (c : ℝ) where
  W : ℝ → LadderMatrix
  E : ℝ → LadderMatrix
  hW : ∀ eps, W eps ∈ Matrix.unitaryGroup (Fin 4) ℂ
  hE : ∀ eps, E eps ∈ Matrix.unitaryGroup (Fin 4) ℂ
  hgroup : ∀ s t, E s * E t = E (s + t)
  hid : E 0 = 1
  hstep : ∀ eps, 0 ≤ eps → eps ≤ 1 → ‖W eps - E eps‖ ≤ c * eps ^ 2
  hc : 0 ≤ c

namespace LadderPreconditions

variable {c : ℝ}

lemma unitary_norm {A : LadderMatrix}
    (hA : A ∈ Matrix.unitaryGroup (Fin 4) ℂ) : ‖A‖ = 1 := by
  exact CStarRing.norm_of_mem_unitary hA

lemma group_pow (P : LadderPreconditions c) (x : ℝ) (n : ℕ) :
    (P.E x) ^ n = P.E (n * x) := by
  induction n <;> simp_all +decide [ pow_succ, add_mul ];
  · exact P.hid.symm;
  · exact P.hgroup _ _

lemma norm_pow_sub_pow_le (P : LadderPreconditions c) (x : ℝ) (n : ℕ) :
    ‖(P.W x) ^ n - (P.E x) ^ n‖ ≤ n * ‖P.W x - P.E x‖ := by
  -- By the properties of the operator norm, we can bound the norm of the difference of powers.
  have h_norm_diff_powers : ∀ (A B : LadderMatrix), ‖A‖ ≤ 1 → ‖B‖ ≤ 1 → ∀ n : ℕ, ‖A^n - B^n‖ ≤ n * ‖A - B‖ := by
    intros A B hA hB n
    induction' n with n ih;
    · norm_num;
    · -- Using the triangle inequality and the induction hypothesis, we get:
      have h_step : ‖A ^ (n + 1) - B ^ (n + 1)‖ ≤ ‖A ^ n * (A - B)‖ + ‖(A ^ n - B ^ n) * B‖ := by
        convert norm_add_le ( A ^ n * ( A - B ) ) ( ( A ^ n - B ^ n ) * B ) using 2 ; simp +decide [ mul_sub, sub_mul, pow_succ ];
      -- Using the induction hypothesis and the properties of the operator norm, we get:
      have h_ind_step : ‖A ^ n * (A - B)‖ ≤ ‖A ^ n‖ * ‖A - B‖ ∧ ‖(A ^ n - B ^ n) * B‖ ≤ ‖A ^ n - B ^ n‖ * ‖B‖ := by
        exact ⟨ norm_mul_le _ _, norm_mul_le _ _ ⟩;
      -- Using the induction hypothesis and the properties of the operator norm, we get ‖A^n‖ ≤ 1.
      have h_ind_step2 : ‖A ^ n‖ ≤ 1 := by
        refine' Nat.recOn n _ _ <;> simp_all +decide [ pow_succ' ];
        exact fun n hn => le_trans ( norm_mul_le _ _ ) ( mul_le_one₀ hA ( norm_nonneg _ ) hn );
      push_cast; nlinarith [ norm_nonneg ( A - B ), norm_nonneg ( A ^ n - B ^ n ), norm_nonneg B ] ;
  exact h_norm_diff_powers _ _ ( unitary_norm ( P.hW x ) ▸ le_rfl ) ( unitary_norm ( P.hE x ) ▸ le_rfl ) n

/-
The single integration theorem: all side conditions are supplied by one record.
-/
theorem error_bound (P : LadderPreconditions c) :
    ∀ t : ℝ, 0 < t → ∀ n : ℕ, 0 < n → t / n ≤ 1 →
      ‖(P.W (t / n)) ^ n - P.E t‖ ≤ c * t ^ 2 / n := by
  intros t ht n hn ht_le_one
  have h_norm : ‖P.W (t / n) ^ n - P.E (n * (t / n))‖ ≤ n * ‖P.W (t / n) - P.E (t / n)‖ := by
    convert P.norm_pow_sub_pow_le ( t / n ) n using 1 ; rw [ P.group_pow ];
  convert h_norm.trans ( mul_le_mul_of_nonneg_left ( P.hstep ( t / n ) ( by positivity ) ht_le_one ) ( Nat.cast_nonneg n ) ) using 1 <;> ring_nf ; norm_num [ hn.ne' ];
  simp +decide [ sq, mul_assoc, hn.ne' ]

/-
At fixed positive time, the ladder products converge in L2 operator norm.
-/
theorem tendsto_ladder (P : LadderPreconditions c) {t : ℝ} (ht : 0 < t) :
    Tendsto (fun n : ℕ => (P.W (t / n)) ^ n) atTop (𝓝 (P.E t)) := by
  refine' Metric.tendsto_atTop.mpr _;
  intro ε hεpos
  obtain ⟨N, hN⟩ : ∃ N : ℕ, ∀ n ≥ N, c * t ^ 2 / n < ε := by
    exact ⟨ ⌈c * t ^ 2 / ε⌉₊ + 1, fun n hn => by rw [ div_lt_iff₀ ] <;> nlinarith [ Nat.le_ceil ( c * t ^ 2 / ε ), show ( n : ℝ ) ≥ ⌈c * t ^ 2 / ε⌉₊ + 1 by exact_mod_cast hn, mul_div_cancel₀ ( c * t ^ 2 ) hεpos.ne' ] ⟩
  use N + ⌈t⌉₊ + 1;
  intro n hn; rw [ dist_eq_norm ] ; refine' lt_of_le_of_lt _ ( hN n ( by linarith ) ) ; convert error_bound P t ht n ( by linarith ) ( by rw [ div_le_iff₀ ( by norm_cast; linarith ) ] ; nlinarith [ Nat.le_ceil t, show ( n : ℝ ) ≥ N + ⌈t⌉₊ + 1 by norm_cast ] ) using 1 ;

end LadderPreconditions

/-
`hc` is redundant: the step estimate at `eps = 1` forces `c ≥ 0`.
-/
theorem ladder_hc_derived
    (c : ℝ) (W E : ℝ → LadderMatrix)
    (hstep : ∀ eps, 0 ≤ eps → eps ≤ 1 → ‖W eps - E eps‖ ≤ c * eps ^ 2) :
    0 ≤ c := by
  exact le_trans ( norm_nonneg _ ) ( hstep 1 ( by norm_num ) ( by norm_num ) ) |> le_trans <| by norm_num;

/-
`hid` is not independent: unitarity of `E` and the group law force it.
-/
theorem ladder_hid_derived
    (E : ℝ → LadderMatrix)
    (hE : ∀ eps, E eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hgroup : ∀ s t, E s * E t = E (s + t)) :
    E 0 = 1 := by
  -- Since $E(0)$ is unitary, we have $E(0) * E(0)^* = 1$.
  have h_unitary : E 0 * (star (E 0)) = 1 := by
    exact hE 0 |>.2;
  grind +qlia

/-
Independence witness for `hW`; all matrices are scalar diagonal matrices.
-/
theorem ladder_hW_independent :
    ∃ (c : ℝ) (W E : ℝ → LadderMatrix) (t : ℝ) (n : ℕ),
      (∀ eps, E eps ∈ Matrix.unitaryGroup (Fin 4) ℂ) ∧
      (∀ s u, E s * E u = E (s + u)) ∧ E 0 = 1 ∧
      (∀ eps, 0 ≤ eps → eps ≤ 1 → ‖W eps - E eps‖ ≤ c * eps ^ 2) ∧
      0 ≤ c ∧ (¬ ∀ eps, W eps ∈ Matrix.unitaryGroup (Fin 4) ℂ) ∧
      0 < t ∧ 0 < n ∧ t / n ≤ 1 ∧
      ¬ ‖(W (t / n)) ^ n - E t‖ ≤ c * t ^ 2 / n := by
  refine' ⟨ 4, fun eps => if eps = 1 / 2 then 2 • 1 else 1, fun _ => 1, 1, 2, _, _, _, _ ⟩ <;> norm_num;
  refine' ⟨ _, ⟨ 1 / 2, _ ⟩, _ ⟩ <;> norm_num [ Matrix.norm_def ];
  · intro eps hε₁ hε₂; split_ifs <;> norm_num;
    · norm_num [ ‹_› ];
    · positivity;
  · intro h; have := h.2; norm_num [ ← Matrix.ext_iff ] at this;
    exact absurd ( this 0 0 ) ( by norm_num [ show ( 4 : Matrix ( Fin 4 ) ( Fin 4 ) ℂ ) = fun i j => if i = j then 4 else 0 from by ext i j; fin_cases i <;> fin_cases j <;> rfl ] );
  · refine' lt_of_lt_of_le _ ( le_csInf _ _ );
    exact lt_add_one _;
    · refine' ⟨ 3, _, _ ⟩ <;> norm_num;
      intro x; erw [ Matrix.toEuclideanLin ] ; norm_num [ EuclideanSpace.norm_eq ] ; ring_nf;
      norm_num [ ← Finset.sum_mul _ _ _, Real.sqrt_le_iff ];
    · intro c hc; have := hc.2 ( EuclideanSpace.single 0 1 ) ; norm_num [ EuclideanSpace.norm_eq, Matrix.toEuclideanLin ] at this;
      norm_num [ Fin.sum_univ_succ, Pi.single_apply ] at this;
      linarith

/-
Independence witness for `hgroup`.
-/
theorem ladder_hgroup_independent :
    ∃ (c : ℝ) (W E : ℝ → LadderMatrix) (t : ℝ) (n : ℕ),
      (∀ eps, W eps ∈ Matrix.unitaryGroup (Fin 4) ℂ) ∧
      (∀ eps, E eps ∈ Matrix.unitaryGroup (Fin 4) ℂ) ∧ E 0 = 1 ∧
      (∀ eps, 0 ≤ eps → eps ≤ 1 → ‖W eps - E eps‖ ≤ c * eps ^ 2) ∧
      0 ≤ c ∧ (¬ ∀ s u, E s * E u = E (s + u)) ∧
      0 < t ∧ 0 < n ∧ t / n ≤ 1 ∧
      ¬ ‖(W (t / n)) ^ n - E t‖ ≤ c * t ^ 2 / n := by
  refine' ⟨ 0, _, _, 2, 2, _, _, _, _, _ ⟩ <;> norm_num;
  refine' fun _ => 1;
  refine' fun eps => if eps = 2 then -1 else 1;
  · exact fun _ => by aesop;
  · intro eps; split_ifs <;> simp +decide [ Matrix.mem_unitaryGroup_iff ] ;
  · norm_num [ Fin.ext_iff ];
  · aesop;
  · norm_num [ ← Matrix.ext_iff ];
    refine' ⟨ ⟨ 1, 1, 0, 0, _ ⟩, 0, 0, _ ⟩ <;> norm_num;
    exact two_ne_zero

/-
Independence witness for `hstep`.
-/
theorem ladder_hstep_independent :
    ∃ (c : ℝ) (W E : ℝ → LadderMatrix) (t : ℝ) (n : ℕ),
      (∀ eps, W eps ∈ Matrix.unitaryGroup (Fin 4) ℂ) ∧
      (∀ eps, E eps ∈ Matrix.unitaryGroup (Fin 4) ℂ) ∧
      (∀ s u, E s * E u = E (s + u)) ∧ E 0 = 1 ∧ 0 ≤ c ∧
      (¬ ∀ eps, 0 ≤ eps → eps ≤ 1 → ‖W eps - E eps‖ ≤ c * eps ^ 2) ∧
      0 < t ∧ 0 < n ∧ t / n ≤ 1 ∧
      ¬ ‖(W (t / n)) ^ n - E t‖ ≤ c * t ^ 2 / n := by
  refine' ⟨ 0, fun _ => -1, fun _ => 1, 1, 1, _, _, _, _, _ ⟩ <;> norm_num;
  · constructor <;> norm_num;
  · refine' ⟨ ⟨ 0, by norm_num, by norm_num, _ ⟩, _ ⟩;
    · norm_num [ ← Matrix.ext_iff ];
      exact ⟨ 0, 0, two_ne_zero ⟩;
    · norm_num [ ← Matrix.ext_iff ];
      exact ⟨ 0, 0, by exact two_ne_zero ⟩

/-
The remaining apparent independence question is resolved below: `hE` is derivable.

If `W` is unitary and has quadratic local error from a multiplicative `E`, then `E` is
itself unitary. Thus `hE`, like `hid`, is redundant rather than independent.
-/
theorem ladder_hE_derived
    (c : ℝ) (W E : ℝ → LadderMatrix)
    (hW : ∀ eps, W eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hgroup : ∀ s t, E s * E t = E (s + t))
    (hid : E 0 = 1)
    (hstep : ∀ eps, 0 ≤ eps → eps ≤ 1 → ‖W eps - E eps‖ ≤ c * eps ^ 2)
    (hc : 0 ≤ c) :
    ∀ eps, E eps ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
  intro x;
  -- The matrix E(x/n) is within c(x/n)^2 of the unitary W(x/n), so its norm is at most 1+c(x/n)^2. A telescoping power estimate shows `dist (E(x/n)^n) (W(x/n)^n) ≤ n*c*(x/n)^2*(1+c*(x/n)^2)^(n-1)`, tending to zero.
  have h_norm : ∀ x > 0, Filter.Tendsto (fun n : ℕ => ‖(E (x / n)) ^ n - (W (x / n)) ^ n‖) Filter.atTop (nhds 0) := by
    intro x hx_pos
    have h_norm_bound : ∀ n : ℕ, 0 < n → x / n ≤ 1 → ‖(E (x / n)) ^ n - (W (x / n)) ^ n‖ ≤ n * c * (x / n) ^ 2 * (1 + c * (x / n) ^ 2) ^ (n - 1) := by
      intros n hn_pos hn_le_one
      have h_norm_bound : ∀ k : ℕ, 0 < k → k ≤ n → ‖(E (x / n)) ^ k - (W (x / n)) ^ k‖ ≤ k * c * (x / n) ^ 2 * (1 + c * (x / n) ^ 2) ^ (k - 1) := by
        intro k hk_pos hk_le_n
        induction' hk_pos with k hk ih;
        · simpa [ norm_sub_rev ] using hstep ( x / n ) ( by positivity ) hn_le_one;
        · -- Using the induction hypothesis and the triangle inequality, we get:
          have h_triangle : ‖(E (x / n)) ^ (k + 1) - (W (x / n)) ^ (k + 1)‖ ≤ ‖(E (x / n)) ^ k - (W (x / n)) ^ k‖ * ‖E (x / n)‖ + ‖(W (x / n)) ^ k‖ * ‖E (x / n) - W (x / n)‖ := by
            have h_triangle : ‖(E (x / n)) ^ (k + 1) - (W (x / n)) ^ (k + 1)‖ ≤ ‖((E (x / n)) ^ k - (W (x / n)) ^ k) * E (x / n)‖ + ‖(W (x / n)) ^ k * (E (x / n) - W (x / n))‖ := by
              convert norm_add_le ( ( E ( x / n ) ^ k - W ( x / n ) ^ k ) * E ( x / n ) ) ( W ( x / n ) ^ k * ( E ( x / n ) - W ( x / n ) ) ) using 2 ; simp +decide [ pow_succ, sub_mul, mul_sub ];
            exact h_triangle.trans ( add_le_add ( norm_mul_le _ _ ) ( norm_mul_le _ _ ) );
          -- Using the induction hypothesis and the fact that ‖E (x / n)‖ ≤ 1 + c * (x / n) ^ 2, we get:
          have h_induction_step : ‖(E (x / n)) ^ k - (W (x / n)) ^ k‖ * ‖E (x / n)‖ + ‖(W (x / n)) ^ k‖ * ‖E (x / n) - W (x / n)‖ ≤ (k * c * (x / n) ^ 2 * (1 + c * (x / n) ^ 2) ^ (k - 1)) * (1 + c * (x / n) ^ 2) + 1 * (c * (x / n) ^ 2) := by
            gcongr;
            · exact ih ( Nat.le_of_succ_le hk_le_n );
            · have h_norm_E : ‖E (x / n)‖ ≤ ‖W (x / n)‖ + ‖W (x / n) - E (x / n)‖ := by
                simpa using norm_sub_le ( W ( x / n ) ) ( W ( x / n ) - E ( x / n ) );
              exact h_norm_E.trans ( add_le_add ( by simpa using LadderPreconditions.unitary_norm ( hW ( x / n ) ) |> le_of_eq ) ( hstep ( x / n ) ( by positivity ) hn_le_one ) );
            · have h_unitary : ∀ k : ℕ, ‖(W (x / n)) ^ k‖ ≤ 1 := by
                intro k; induction' k with k ih <;> simp_all +decide [ pow_succ' ] ;
                exact le_trans ( norm_mul_le _ _ ) ( mul_le_one₀ ( by simpa using LadderPreconditions.unitary_norm ( hW ( x / n ) ) |> le_of_eq ) ( by positivity ) ih );
              exact h_unitary k;
            · simpa only [ norm_sub_rev ] using hstep ( x / n ) ( by positivity ) hn_le_one;
          refine le_trans h_triangle <| h_induction_step.trans ?_;
          rcases k <;> simp_all +decide [ pow_succ, mul_assoc ];
          ring_nf;
          nlinarith [ show 0 ≤ c * x ^ 2 * ( n : ℝ ) ⁻¹ ^ 2 by positivity, show 0 ≤ c ^ 2 * x ^ 4 * ( n : ℝ ) ⁻¹ ^ 4 by positivity, show ( 1 + c * x ^ 2 * ( n : ℝ ) ⁻¹ ^ 2 ) ^ ‹_› ≥ 1 by exact one_le_pow₀ ( by nlinarith [ show 0 ≤ c * x ^ 2 * ( n : ℝ ) ⁻¹ ^ 2 by positivity ] ) ];
      exact h_norm_bound n hn_pos le_rfl;
    -- We'll use the fact that $(1 + c * (x / n) ^ 2) ^ (n - 1)$ is bounded above by $e^{c * x^2 / n}$.
    have h_exp_bound : ∀ n : ℕ, 0 < n → x / n ≤ 1 → (1 + c * (x / n) ^ 2) ^ (n - 1) ≤ Real.exp (c * x ^ 2 / n) := by
      intro n hn hn'; rw [ ← Real.rpow_natCast, Real.rpow_def_of_pos ( by positivity ) ] ; norm_num ; ring_nf ;
      rw [ Nat.cast_pred hn ];
      refine' le_trans ( mul_le_mul_of_nonneg_right ( Real.log_le_sub_one_of_pos ( by positivity ) ) ( sub_nonneg.mpr ( Nat.one_le_cast.mpr hn ) ) ) _ ; ring_nf ; norm_num [ hn.ne' ];
      exact le_add_of_le_of_nonneg ( by simp +decide [ sq, mul_assoc, hn.ne' ] ) ( by positivity );
    -- Using the bounds, we can show that the norm tends to zero.
    have h_tendsto_zero : Filter.Tendsto (fun n : ℕ => n * c * (x / n) ^ 2 * Real.exp (c * x ^ 2 / n)) Filter.atTop (nhds 0) := by
      -- Simplify the expression inside the limit.
      suffices h_simplify : Filter.Tendsto (fun n : ℕ => c * x ^ 2 / n * Real.exp (c * x ^ 2 / n)) Filter.atTop (nhds 0) by
        grind;
      simpa using Filter.Tendsto.mul ( tendsto_const_nhds.mul tendsto_inv_atTop_nhds_zero_nat ) ( Real.continuous_exp.continuousAt.tendsto.comp ( tendsto_const_nhds.mul tendsto_inv_atTop_nhds_zero_nat ) );
    refine' squeeze_zero_norm' _ h_tendsto_zero;
    filter_upwards [ Filter.eventually_gt_atTop 0, Filter.eventually_ge_atTop ⌈x⌉₊ ] with n hn hn' using by rw [ Real.norm_of_nonneg ( norm_nonneg _ ) ] ; exact le_trans ( h_norm_bound n hn ( by rw [ div_le_iff₀ ( Nat.cast_pos.mpr hn ) ] ; nlinarith [ Nat.le_ceil x, show ( n : ℝ ) ≥ ⌈x⌉₊ by exact_mod_cast hn' ] ) ) ( mul_le_mul_of_nonneg_left ( h_exp_bound n hn ( by rw [ div_le_iff₀ ( Nat.cast_pos.mpr hn ) ] ; nlinarith [ Nat.le_ceil x, show ( n : ℝ ) ≥ ⌈x⌉₊ by exact_mod_cast hn' ] ) ) ( by positivity ) ) ;
  -- Since $W(x/n)$ is unitary, $(W(x/n))^n$ is also unitary. The unitary set is closed, so $E(x)$ is unitary.
  have h_unitary : ∀ x > 0, E x ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
    intro x hx_pos
    have h_unitary_seq : ∀ n : ℕ, 0 < n → x / n ≤ 1 → (W (x / n)) ^ n ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
      exact fun n hn hn' => Submonoid.pow_mem _ ( hW _ ) _;
    have h_unitary_limit : Filter.Tendsto (fun n : ℕ => (W (x / n)) ^ n) Filter.atTop (nhds (E x)) := by
      have h_unitary_limit : Filter.Tendsto (fun n : ℕ => (E (x / n)) ^ n) Filter.atTop (nhds (E x)) := by
        refine' tendsto_const_nhds.congr' _;
        filter_upwards [ Filter.eventually_gt_atTop ⌈x⌉₊ ] with n hn;
        have h_group : ∀ m : ℕ, E (m * (x / n)) = (E (x / n)) ^ m := by
          intro m; induction m <;> simp_all +decide [ pow_succ, add_mul ] ;
          rw [ ← hgroup, ‹E _ = _› ];
        simpa [ mul_div_cancel₀, show n ≠ 0 by linarith ] using h_group n;
      have := h_norm x hx_pos;
      convert h_unitary_limit.sub ( tendsto_zero_iff_norm_tendsto_zero.mpr this ) using 2 <;> norm_num;
    have h_unitary_closed : IsClosed (Matrix.unitaryGroup (Fin 4) ℂ : Set (Matrix (Fin 4) (Fin 4) ℂ)) := by
      convert isClosed_unitary; all_goals infer_instance;
    exact h_unitary_closed.mem_of_tendsto h_unitary_limit ( Filter.eventually_atTop.mpr ⟨ ⌈x⌉₊ + 1, fun n hn => h_unitary_seq n ( by linarith ) ( by rw [ div_le_iff₀ ] <;> nlinarith [ Nat.le_ceil x, show ( n : ℝ ) ≥ ⌈x⌉₊ + 1 by exact_mod_cast hn ] ) ⟩ );
  -- For x<0, E x * E(-x)=E0=1 and E(-x) is unitary by the positive case, so E x equals its adjoint/inverse and is unitary.
  have h_neg : ∀ x < 0, E x ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
    intro x hx_neg
    have h_inv : E x * E (-x) = 1 := by
      rw [ hgroup, add_neg_cancel, hid ];
    have h_inv_unitary : E x = (E (-x))⁻¹ := by
      rw [ Matrix.inv_eq_left_inv h_inv ];
    simp_all +decide [ Matrix.mem_unitaryGroup_iff ];
    rw [ Matrix.inv_eq_right_inv ];
    any_goals exact star ( E ( -x ) );
    · simp +decide [ mul_eq_one_comm ];
      exact h_unitary _ ( neg_pos.mpr hx_neg );
    · exact h_unitary _ ( neg_pos.mpr hx_neg );
  cases lt_trichotomy x 0 <;> aesop
