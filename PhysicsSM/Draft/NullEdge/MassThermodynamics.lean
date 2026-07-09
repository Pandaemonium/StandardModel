import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

open Filter Topology

namespace MassThermo

/-!
# Mass thermodynamics: a Gibbs–Duhem susceptibility sum rule with critical divergence

The finite null-edge program decomposes the carrier mass² into channel **shares**
`b_A + b_C + b_T = 1` (aperture / closure / turn) on the `3×3` mass block
`B(l,k) = !![l, k·i, 0; -k·i, l, 0; 0, 0, l]`, whose spectrum is `{l-k, l, l+k}`:

* the **closure** mode carries mass `l - k` (it becomes *massless* on the critical
  line `k = l`);
* the **turn** mode carries mass `l`;
* the **aperture** mode carries mass `l + k`.

**Normalization used (honest note).** We define the shares directly as rational
functions of the couplings `g = (l, k)`:

* closure share `b_C = k / (l - k)` — the closure coupling measured against the
  (vanishing) massless gap `l - k`;
* aperture share `b_A = k / (l + k)`;
* turn share `b_T = 1 - b_C - b_A` — the stable middle mode carries the balance,
  so the budget `b_A + b_C + b_T = 1` holds by construction.

Susceptibilities are the partial derivatives `χ_{X,Y} = ∂ b_X / ∂ g_Y`.
-/

/-- Closure share `b_C = k / (l - k)` (massless mode `l - k`). -/
noncomputable def bC (l k : ℝ) : ℝ := k / (l - k)

/-- Aperture share `b_A = k / (l + k)`. -/
noncomputable def bA (l k : ℝ) : ℝ := k / (l + k)

/-- Turn share `b_T = 1 - b_C - b_A` (carries the balance). -/
noncomputable def bT (l k : ℝ) : ℝ := 1 - bC l k - bA l k

/-- **The budget identity.** The three channel shares sum to `1`. -/
theorem budget (l k : ℝ) : bA l k + bC l k + bT l k = 1 := by
  simp only [bT]; ring

/-! ## Closed-form susceptibilities (the `2 × 3` matrix `χ_{X,Y}`) -/

/-- `∂ b_C / ∂ l = -k / (l - k)²`. -/
theorem hasDerivAt_bC_l (l k : ℝ) (h : l - k ≠ 0) :
    HasDerivAt (fun l => bC l k) (-k / (l - k) ^ 2) l := by
  have hc : HasDerivAt (fun _ : ℝ => k) 0 l := hasDerivAt_const l k
  have hd : HasDerivAt (fun l : ℝ => l - k) 1 l := (hasDerivAt_id l).sub_const k
  have := hc.div hd h
  convert this using 1
  field_simp
  ring

/-- `∂ b_C / ∂ k = l / (l - k)²` — the closure susceptibility that will diverge. -/
theorem hasDerivAt_bC_k (l k : ℝ) (h : l - k ≠ 0) :
    HasDerivAt (fun k => bC l k) (l / (l - k) ^ 2) k := by
  have hc : HasDerivAt (fun k : ℝ => k) 1 k := hasDerivAt_id k
  have hd : HasDerivAt (fun k : ℝ => l - k) (-1) k := by
    simpa using (hasDerivAt_id k).const_sub l
  have := hc.div hd h
  convert this using 1
  field_simp
  ring

/-- `∂ b_A / ∂ l = -k / (l + k)²`. -/
theorem hasDerivAt_bA_l (l k : ℝ) (h : l + k ≠ 0) :
    HasDerivAt (fun l => bA l k) (-k / (l + k) ^ 2) l := by
  have hc : HasDerivAt (fun _ : ℝ => k) 0 l := hasDerivAt_const l k
  have hd : HasDerivAt (fun l : ℝ => l + k) 1 l := (hasDerivAt_id l).add_const k
  have := hc.div hd h
  convert this using 1
  field_simp
  ring

/-- `∂ b_A / ∂ k = l / (l + k)²`. -/
theorem hasDerivAt_bA_k (l k : ℝ) (h : l + k ≠ 0) :
    HasDerivAt (fun k => bA l k) (l / (l + k) ^ 2) k := by
  have hc : HasDerivAt (fun k : ℝ => k) 1 k := hasDerivAt_id k
  have hd : HasDerivAt (fun k : ℝ => l + k) 1 k := (hasDerivAt_id k).const_add l
  have := hc.div hd h
  convert this using 1
  field_simp
  ring

/-- `∂ b_T / ∂ l = k / (l - k)² + k / (l + k)²`. -/
theorem hasDerivAt_bT_l (l k : ℝ) (h1 : l - k ≠ 0) (h2 : l + k ≠ 0) :
    HasDerivAt (fun l => bT l k) (k / (l - k) ^ 2 + k / (l + k) ^ 2) l := by
  have hconst : HasDerivAt (fun _ : ℝ => (1 : ℝ)) 0 l := hasDerivAt_const l 1
  have := (hconst.sub (hasDerivAt_bC_l l k h1)).sub (hasDerivAt_bA_l l k h2)
  convert this using 1
  ring

/-- `∂ b_T / ∂ k = -l / (l - k)² - l / (l + k)²`. -/
theorem hasDerivAt_bT_k (l k : ℝ) (h1 : l - k ≠ 0) (h2 : l + k ≠ 0) :
    HasDerivAt (fun k => bT l k) (-l / (l - k) ^ 2 - l / (l + k) ^ 2) k := by
  have hconst : HasDerivAt (fun _ : ℝ => (1 : ℝ)) 0 k := hasDerivAt_const k 1
  have := (hconst.sub (hasDerivAt_bC_k l k h1)).sub (hasDerivAt_bA_k l k h2)
  convert this using 1
  ring

/-- **The full susceptibility matrix in closed form.** All six partial
derivatives `χ_{X,Y} = ∂ b_X / ∂ g_Y` as explicit rational functions of `(l, k)`. -/
theorem susceptibility_matrix_closed_form (l k : ℝ)
    (h1 : l - k ≠ 0) (h2 : l + k ≠ 0) :
    HasDerivAt (fun l => bA l k) (-k / (l + k) ^ 2) l ∧
    HasDerivAt (fun k => bA l k) (l / (l + k) ^ 2) k ∧
    HasDerivAt (fun l => bC l k) (-k / (l - k) ^ 2) l ∧
    HasDerivAt (fun k => bC l k) (l / (l - k) ^ 2) k ∧
    HasDerivAt (fun l => bT l k) (k / (l - k) ^ 2 + k / (l + k) ^ 2) l ∧
    HasDerivAt (fun k => bT l k) (-l / (l - k) ^ 2 - l / (l + k) ^ 2) k :=
  ⟨hasDerivAt_bA_l l k h2, hasDerivAt_bA_k l k h2,
   hasDerivAt_bC_l l k h1, hasDerivAt_bC_k l k h1,
   hasDerivAt_bT_l l k h1 h2, hasDerivAt_bT_k l k h1 h2⟩

/-! ## The Gibbs–Duhem sum rule: `Σ_X χ_{X,Y} = 0` -/

/-- **Gibbs–Duhem sum rule for the coupling `l`.** Differentiating the constant
budget `b_A + b_C + b_T = 1` in `l` makes the three susceptibilities sum to `0`. -/
theorem gibbs_duhem_sum_rule_l (l k : ℝ) (h1 : l - k ≠ 0) (h2 : l + k ≠ 0) :
    deriv (fun l => bA l k) l + deriv (fun l => bC l k) l
      + deriv (fun l => bT l k) l = 0 := by
  rw [(hasDerivAt_bA_l l k h2).deriv, (hasDerivAt_bC_l l k h1).deriv,
    (hasDerivAt_bT_l l k h1 h2).deriv]
  ring

/-- **Gibbs–Duhem sum rule for the coupling `k`.** Differentiating the constant
budget in `k` makes the three susceptibilities sum to `0`. -/
theorem gibbs_duhem_sum_rule_k (l k : ℝ) (h1 : l - k ≠ 0) (h2 : l + k ≠ 0) :
    deriv (fun k => bA l k) k + deriv (fun k => bC l k) k
      + deriv (fun k => bT l k) k = 0 := by
  rw [(hasDerivAt_bA_k l k h2).deriv, (hasDerivAt_bC_k l k h1).deriv,
    (hasDerivAt_bT_k l k h1 h2).deriv]
  ring

/-- The sum rule holds structurally: it is literally the derivative of the
constant function `1` obtained from the budget. (An alternative statement of
`gibbs_duhem_sum_rule_l` making the "derivative of a constant" reading explicit.) -/
theorem gibbs_duhem_from_constant_budget_l (l k : ℝ) :
    deriv (fun l => bA l k + bC l k + bT l k) l = 0 := by
  have : (fun l => bA l k + bC l k + bT l k) = fun _ => (1 : ℝ) := by
    funext l; exact budget l k
  rw [this, deriv_const']

/-! ## Critical divergence on the massless line `k = l` -/

/-- The closed-form closure susceptibility `∂ b_C / ∂ k = l / (l - k)²`
**blows up** as `k → l` (a second-order pole at the massless line). -/
theorem susceptibility_bC_k_blowup (l : ℝ) (hl : 0 < l) :
    Filter.Tendsto (fun k => l / (l - k) ^ 2) (𝓝[≠] l) Filter.atTop := by
  have h0 : Filter.Tendsto (fun k : ℝ => (l - k) ^ 2) (𝓝[≠] l)
      (𝓝[>] (0 : ℝ)) := by
    apply tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within
    · have h1 : Filter.Tendsto (fun k : ℝ => (l - k) ^ 2) (nhds l) (nhds (0 : ℝ)) := by
        have : Filter.Tendsto (fun k : ℝ => (l - k) ^ 2) (nhds l) (nhds ((l - l) ^ 2)) := by
          apply Continuous.tendsto; continuity
        simpa using this
      exact h1.mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with k hk
      have hne : l - k ≠ 0 := by
        simp only [Set.mem_compl_iff, Set.mem_singleton_iff] at hk
        intro h; apply hk; linarith
      have : (0 : ℝ) < (l - k) ^ 2 := by positivity
      simpa using this
  have hinv := tendsto_inv_nhdsGT_zero.comp h0
  have := hinv.const_mul_atTop hl
  refine this.congr (fun k => ?_)
  simp [Function.comp, div_eq_mul_inv]

/-- **Critical divergence (the physics payload).** The closure susceptibility
`χ_{C,k} = ∂ b_C / ∂ k` diverges to `+∞` as the closure coupling approaches the
aperture, `k → l` — the thermodynamic signature of the massless transition on the
critical line `l - k → 0`. -/
theorem critical_divergence (l : ℝ) (hl : 0 < l) :
    Filter.Tendsto (fun k => deriv (fun k => bC l k) k) (𝓝[≠] l) Filter.atTop := by
  refine (susceptibility_bC_k_blowup l hl).congr' ?_
  filter_upwards [self_mem_nhdsWithin] with k hk
  have hne : l - k ≠ 0 := by
    simp only [Set.mem_compl_iff, Set.mem_singleton_iff] at hk
    intro h; apply hk; linarith
  exact ((hasDerivAt_bC_k l k hne).deriv).symm

end MassThermo

/-! ## Axiom footprint guard -/

#print axioms MassThermo.budget
#print axioms MassThermo.susceptibility_matrix_closed_form
#print axioms MassThermo.gibbs_duhem_sum_rule_l
#print axioms MassThermo.gibbs_duhem_sum_rule_k
#print axioms MassThermo.critical_divergence
