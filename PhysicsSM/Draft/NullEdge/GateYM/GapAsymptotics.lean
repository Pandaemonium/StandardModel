import Mathlib

/-!
# Asymptotics of the Z₂ slab strong-coupling gap

For the Z₂ (Ising) one-plaquette / slab strong-coupling expansion, the closure gap is
`g β = -log (tanh β)`, where `β` is the inverse coupling.  This file establishes the
qualitative and quantitative behaviour of this *finite* gap (the honest one-plaquette Z₂
gap, not a continuum statement):

* `g_pos`          : `g β > 0` for every `β > 0` (there is always a positive gap);
* `g_atZero_top`   : `g β → +∞` as `β → 0⁺` (strong-coupling / confinement: the gap diverges);
* `g_atTop_zero`   : `g β → 0` as `β → +∞` (weak-coupling: the gap closes);
* `g_isEquivalent` : `g β ~ 2·exp (-2β)` as `β → +∞` (leading weak-coupling behaviour);
* `g_strictAntiOn` : `g` is strictly decreasing on `(0, ∞)`.
-/

namespace PhysicsSM.Draft.NullEdge.GateYM.GapAsymptotics

open Real Filter Topology Asymptotics

/-- The Z₂ slab strong-coupling gap `g β = -log (tanh β)`. -/
noncomputable def g (β : ℝ) : ℝ := -Real.log (Real.tanh β)

/-- `tanh β = 1 - 2/(exp (2β) + 1)`, a convenient monotone form. -/
lemma tanh_eq_one_sub (x : ℝ) : Real.tanh x = 1 - 2 / (Real.exp (2 * x) + 1) := by
  rw [Real.tanh_eq_sinh_div_cosh, Real.sinh_eq, Real.cosh_eq]
  have h2 : Real.exp (2 * x) = Real.exp x * Real.exp x := by rw [← Real.exp_add]; ring_nf
  rw [h2]
  have hp : Real.exp x * Real.exp (-x) = 1 := by rw [← Real.exp_add]; simp
  have hx : Real.exp x > 0 := Real.exp_pos x
  have hnx : Real.exp (-x) > 0 := Real.exp_pos (-x)
  field_simp; ring_nf; nlinarith [hp]

/-- `tanh β = (1 - exp (-2β))/(1 + exp (-2β))`. -/
lemma tanh_eq_exp (β : ℝ) :
    Real.tanh β = (1 - Real.exp (-2 * β)) / (1 + Real.exp (-2 * β)) := by
  rw [Real.tanh_eq_sinh_div_cosh, Real.sinh_eq, Real.cosh_eq]
  have hn : Real.exp (-2 * β) = Real.exp (-β) * Real.exp (-β) := by rw [← Real.exp_add]; ring_nf
  have hp : Real.exp β * Real.exp (-β) = 1 := by rw [← Real.exp_add]; simp
  have hx : Real.exp β > 0 := Real.exp_pos β
  have hnx : Real.exp (-β) > 0 := Real.exp_pos (-β)
  rw [hn]; field_simp; nlinarith [hp]

/-- `tanh` is strictly monotone on all of `ℝ`. -/
lemma tanh_strictMono : StrictMono Real.tanh := by
  intro a b hab
  rw [tanh_eq_one_sub, tanh_eq_one_sub]
  have : Real.exp (2 * a) < Real.exp (2 * b) := Real.exp_lt_exp.mpr (by linarith)
  gcongr

/-- For `β > 0`, `tanh β` is strictly positive. -/
lemma tanh_pos_of_pos {β : ℝ} (hβ : 0 < β) : 0 < Real.tanh β := by
  rw [Real.tanh_eq_sinh_div_cosh]
  exact div_pos (Real.sinh_pos_iff.mpr hβ) (Real.cosh_pos β)

/-- `tanh` is continuous. -/
lemma continuous_tanh : Continuous Real.tanh := by
  have h : Real.tanh = fun x => Real.sinh x / Real.cosh x := funext Real.tanh_eq_sinh_div_cosh
  rw [h]
  exact Real.continuous_sinh.div Real.continuous_cosh (fun x => (Real.cosh_pos x).ne')

/-- **Positivity of the gap.** For every `β > 0` we have `g β > 0`. -/
theorem g_pos {β : ℝ} (hβ : 0 < β) : 0 < g β := by
  unfold g
  have := Real.log_neg (tanh_pos_of_pos hβ) (Real.tanh_lt_one β)
  linarith

/-- **Strong-coupling / confinement limit.** As `β → 0⁺`, the gap diverges. -/
theorem g_atZero_top : Tendsto g (𝓝[>] (0 : ℝ)) atTop := by
  have hcont : Tendsto Real.tanh (𝓝[>] (0 : ℝ)) (𝓝 (Real.tanh 0)) :=
    continuous_tanh.continuousAt.tendsto.mono_left nhdsWithin_le_nhds
  rw [Real.tanh_zero] at hcont
  have htan : Tendsto Real.tanh (𝓝[>] (0 : ℝ)) (𝓝[>] (0 : ℝ)) := by
    rw [tendsto_nhdsWithin_iff]
    exact ⟨hcont, by
      filter_upwards [self_mem_nhdsWithin] with x hx using tanh_pos_of_pos hx⟩
  have hlog : Tendsto (fun β => Real.log (Real.tanh β)) (𝓝[>] (0 : ℝ)) atBot :=
    Real.tendsto_log_nhdsGT_zero.comp htan
  unfold g
  exact tendsto_neg_atTop_iff.mpr hlog

/-- `tanh β → 1` as `β → +∞`. -/
lemma tanh_tendsto_one : Tendsto Real.tanh atTop (𝓝 1) := by
  have hcomp : Tendsto (fun x : ℝ => Real.exp (2 * x) + 1) atTop atTop := by
    apply Tendsto.atTop_add _ tendsto_const_nhds
    exact Real.tendsto_exp_atTop.comp (Filter.Tendsto.const_mul_atTop (by norm_num) tendsto_id)
  have h0 : Tendsto (fun x : ℝ => 2 / (Real.exp (2 * x) + 1)) atTop (𝓝 0) :=
    Tendsto.div_atTop tendsto_const_nhds hcomp
  have hlim : Tendsto (fun x : ℝ => 1 - 2 / (Real.exp (2 * x) + 1)) atTop (𝓝 (1 - 0)) :=
    Tendsto.sub tendsto_const_nhds h0
  simp only [sub_zero] at hlim
  have heq : Real.tanh = fun x => 1 - 2 / (Real.exp (2 * x) + 1) := funext tanh_eq_one_sub
  rw [heq]; exact hlim

/-- **Weak-coupling limit.** As `β → +∞`, the gap closes. -/
theorem g_atTop_zero : Tendsto g atTop (𝓝 0) := by
  have h1 : Tendsto (fun β => Real.log (Real.tanh β)) atTop (𝓝 (Real.log 1)) :=
    (Real.continuousAt_log (by norm_num)).tendsto.comp tanh_tendsto_one
  rw [Real.log_one] at h1
  unfold g
  simpa using h1.neg

/-- **Leading weak-coupling behaviour.** `g β ~ 2·exp (-2β)` as `β → +∞`. -/
theorem g_isEquivalent :
    (fun β => g β) ~[atTop] (fun β => 2 * Real.exp (-2 * β)) := by
  -- `h x = log (1+x) - log (1-x)` has derivative `2` at `0`.
  set h : ℝ → ℝ := fun x => Real.log (1 + x) - Real.log (1 - x) with hh
  have hderiv : HasDerivAt h 2 0 := by
    have h1 : HasDerivAt (fun x : ℝ => 1 + x) 1 0 := by
      simpa using (hasDerivAt_id (0 : ℝ)).const_add (1 : ℝ)
    have h2 : HasDerivAt (fun x : ℝ => 1 - x) (-1) 0 := by
      simpa using (hasDerivAt_id (0 : ℝ)).const_sub (1 : ℝ)
    have c1 : HasDerivAt (fun x => Real.log (1 + x)) 1 0 := by
      have : HasDerivAt (Real.log ∘ fun x : ℝ => 1 + x) (((1 : ℝ) + 0)⁻¹ * 1) 0 :=
        (Real.hasDerivAt_log (by norm_num)).comp 0 h1
      simpa [Function.comp] using this
    have c2 : HasDerivAt (fun x => Real.log (1 - x)) (-1) 0 := by
      have : HasDerivAt (Real.log ∘ fun x : ℝ => 1 - x) (((1 : ℝ) - 0)⁻¹ * (-1)) 0 :=
        (Real.hasDerivAt_log (by norm_num)).comp 0 h2
      simpa [Function.comp] using this
    have hd : HasDerivAt h (1 - (-1)) 0 := c1.sub c2
    norm_num at hd; exact hd
  -- Turn the derivative into a slope limit and compose with `exp (-2β) → 0`.
  have hslope : Tendsto (slope h 0) (𝓝[≠] (0 : ℝ)) (𝓝 2) :=
    hasDerivAt_iff_tendsto_slope.mp hderiv
  have hexp : Tendsto (fun β : ℝ => Real.exp (-2 * β)) atTop (𝓝[≠] (0 : ℝ)) := by
    have hb : Tendsto (fun β : ℝ => -2 * β) atTop atBot := by
      have h2 : Tendsto (fun β : ℝ => (2 : ℝ) * β) atTop atTop :=
        Filter.Tendsto.const_mul_atTop (by norm_num) tendsto_id
      simpa [neg_mul] using tendsto_neg_atBot_iff.mpr h2
    have h0 : Tendsto (fun β : ℝ => Real.exp (-2 * β)) atTop (𝓝 0) :=
      Real.tendsto_exp_atBot.comp hb
    rw [tendsto_nhdsWithin_iff]
    exact ⟨h0, by
      filter_upwards with x
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
      exact (Real.exp_pos _).ne'⟩
  have hcomp : Tendsto (fun β => slope h 0 (Real.exp (-2 * β))) atTop (𝓝 2) :=
    hslope.comp hexp
  have h0val : h 0 = 0 := by simp [hh]
  have hcomp2 : Tendsto (fun β => h (Real.exp (-2 * β)) / Real.exp (-2 * β)) atTop (𝓝 2) := by
    apply hcomp.congr
    intro β
    rw [slope_def_field, h0val]; ring_nf
  have hdiv : Tendsto (fun β => h (Real.exp (-2 * β)) / Real.exp (-2 * β) / 2) atTop (𝓝 1) := by
    simpa using hcomp2.div_const 2
  rw [Asymptotics.isEquivalent_iff_tendsto_one (by filter_upwards with x; positivity)]
  apply hdiv.congr'
  filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with β hβ
  have hlt : Real.exp (-2 * β) < 1 := by
    rw [show (1 : ℝ) = Real.exp 0 by simp]; exact Real.exp_lt_exp.mpr (by nlinarith)
  have hx1 : (1 : ℝ) - Real.exp (-2 * β) > 0 := by linarith
  have hx2 : (1 : ℝ) + Real.exp (-2 * β) > 0 := by positivity
  have hgeq : g β = h (Real.exp (-2 * β)) := by
    rw [hh]; simp only
    rw [g, tanh_eq_exp, Real.log_div (by linarith) (by linarith)]
    ring
  rw [Pi.div_apply, hgeq]
  field_simp

/-- **Monotonicity.** The gap `g` is strictly decreasing on `(0, ∞)`. -/
theorem g_strictAntiOn : StrictAntiOn g (Set.Ioi (0 : ℝ)) := by
  intro a ha b hb hab
  simp only [Set.mem_Ioi] at ha hb
  unfold g
  have := Real.log_lt_log (tanh_pos_of_pos ha) (tanh_strictMono hab)
  linarith

end PhysicsSM.Draft.NullEdge.GateYM.GapAsymptotics
