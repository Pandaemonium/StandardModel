import Mathlib

/-!
# A finite self-consistent decoder

This module proves the first finite rung of the proposed backreaction relation

```text
D = D[omega],    omega = omega_D.
```

The model is deliberately small. A two-level decoder has excited energy
`E0 + g * theta`; its unit-temperature Gibbs occupation feeds back into the
scalar parameter through

```text
feedback c E0 g theta = c * gibbsWeight (E0 + g * theta).
```

For `0 <= c`, a fixed point exists in `[0,c]`. Since the logistic Gibbs weight
is `1/4`-Lipschitz, the fixed point is unique when `|c*g| < 4`. The concrete
`c=1, E0=0, g=1` model has a unique fixed point strictly inside `(0,1)`.

Honest scope: one scalar Gibbs feedback loop, not a decoder-valued geometry,
continuum backreaction, cosmology, or a principle selecting one fixed point
outside the contraction regime.

Provenance: Aristotle project `0311ff6c-25ea-4909-8c08-5865dad19d02`, task
`f35b53ce-1c2b-4818-a7a2-6c40846ee1ce`; clean-room finite analysis motivated
by the Pro/Fable self-decoding proposal supplied 2026-07-09.
-/

namespace PhysicsSM.Draft.NullEdge.SelfConsistentDecoder

/-- Gibbs excited-state weight of a two-level system at unit temperature. -/
noncomputable def gibbsWeight (E : ℝ) : ℝ :=
  Real.exp (-E) / (1 + Real.exp (-E))

/-- The state-to-geometry feedback map. -/
noncomputable def feedback (c E0 g : ℝ) (theta : ℝ) : ℝ :=
  c * gibbsWeight (E0 + g * theta)

lemma one_add_exp_pos (x : ℝ) : 0 < 1 + Real.exp x := by
  have := Real.exp_pos x
  linarith

lemma gibbsWeight_eq (E : ℝ) : gibbsWeight E = (1 + Real.exp E)⁻¹ := by
  have h : Real.exp E ≠ 0 := (Real.exp_pos E).ne'
  rw [gibbsWeight, Real.exp_neg]
  field_simp
  ring

lemma gibbsWeight_hasDerivAt (E : ℝ) :
    HasDerivAt gibbsWeight (-Real.exp E / (1 + Real.exp E) ^ 2) E := by
  convert HasDerivAt.div (HasDerivAt.exp (hasDerivAt_neg E))
    (HasDerivAt.add (hasDerivAt_const _ _) (HasDerivAt.exp (hasDerivAt_neg E))) _
      using 1 <;> norm_num
  · field_simp [Real.exp_neg]
    ring_nf
    rw [Real.exp_neg]
    field_simp
    ring
  · positivity

lemma abs_gibbsWeight_deriv_le (E : ℝ) :
    |(-Real.exp E / (1 + Real.exp E) ^ 2)| ≤ 1 / 4 := by
  rw [abs_div]
  rw [abs_of_neg, abs_of_nonneg, div_le_div_iff₀] <;>
    nlinarith [Real.exp_pos E, sq_nonneg (Real.exp E - 1)]

/-- The Gibbs occupation lies strictly between zero and one. -/
theorem gibbsWeight_mem_Ioo (E : ℝ) : gibbsWeight E ∈ Set.Ioo (0 : ℝ) 1 := by
  exact ⟨by rw [gibbsWeight_eq]; positivity,
    by rw [gibbsWeight_eq]; rw [inv_lt_comm₀] <;> norm_num <;> positivity⟩

/-- The feedback map is continuous. -/
theorem feedback_continuous (c E0 g : ℝ) : Continuous (feedback c E0 g) := by
  exact Continuous.mul continuous_const
    (by
      unfold gibbsWeight
      exact Continuous.div
        (Real.continuous_exp.comp <| ContinuousNeg.continuous_neg.comp <| by continuity)
        (by continuity) <| by intro x; positivity) |>.comp <| by continuity

/-- For nonnegative `c`, the interval `[0,c]` absorbs the feedback. -/
theorem feedback_mem_Icc (c E0 g : ℝ) (hc : 0 ≤ c) (theta : ℝ) :
    feedback c E0 g theta ∈ Set.Icc (0 : ℝ) c := by
  exact ⟨mul_nonneg hc (gibbsWeight_mem_Ioo _).1.le,
    mul_le_of_le_one_right hc (gibbsWeight_mem_Ioo _).2.le⟩

/-- A self-consistent point exists in the invariant interval. -/
theorem exists_selfConsistent (c E0 g : ℝ) (hc : 0 ≤ c) :
    ∃ theta ∈ Set.Icc (0 : ℝ) c, feedback c E0 g theta = theta := by
  set d := fun theta => feedback c E0 g theta - theta with hd_def
  have h_ivt : ∃ theta ∈ Set.Icc 0 c, d theta = 0 := by
    apply_rules [intermediate_value_Icc']
    · exact ContinuousOn.sub
        ((feedback_continuous c E0 g).continuousOn) continuousOn_id
    · constructor <;>
        have hc' := feedback_mem_Icc c E0 g hc c <;>
        have h0 := feedback_mem_Icc c E0 g hc 0 <;> aesop
  exact ⟨h_ivt.choose, h_ivt.choose_spec.1,
    sub_eq_zero.mp h_ivt.choose_spec.2⟩

/-- The Gibbs weight is `1/4`-Lipschitz. -/
theorem gibbsWeight_lipschitz :
    LipschitzWith (1 / 4 : NNReal) gibbsWeight := by
  rw [lipschitzWith_iff_norm_sub_le]
  have h_mean_value : ∀ x y : ℝ, x < y →
      ∃ c ∈ Set.Ioo x y,
        gibbsWeight y - gibbsWeight x = deriv gibbsWeight c * (y - x) := by
    intros x y hxy
    have h_slope : ∃ c ∈ Set.Ioo x y,
        deriv gibbsWeight c = (gibbsWeight y - gibbsWeight x) / (y - x) := by
      apply_rules [exists_deriv_eq_slope]
      · exact Continuous.continuousOn
          (by
            exact Continuous.div
              (Real.continuous_exp.comp <| ContinuousNeg.continuous_neg)
              (by continuity) fun x => by positivity)
      · exact fun z hz => DifferentiableAt.differentiableWithinAt
          (gibbsWeight_hasDerivAt z).differentiableAt
    exact ⟨h_slope.choose, h_slope.choose_spec.1, by
      rw [h_slope.choose_spec.2,
        div_mul_cancel₀ _ (sub_ne_zero_of_ne hxy.ne')]⟩
  have h_deriv_bound : ∀ c : ℝ, |deriv gibbsWeight c| ≤ 1 / 4 := by
    intro c
    rw [show deriv gibbsWeight c =
      -Real.exp c / (1 + Real.exp c) ^ 2 by
        exact (gibbsWeight_hasDerivAt c).deriv]
    exact abs_gibbsWeight_deriv_le c
  intro x y
  rcases lt_trichotomy x y with (hxy | rfl | hyx) <;> norm_num at *
  · obtain ⟨c, hc1, hc2⟩ := h_mean_value x y hxy
    rw [abs_le]
    constructor <;> cases abs_cases (x - y) <;>
      nlinarith [abs_le.mp (h_deriv_bound c)]
  · obtain ⟨c, hc1, hc2⟩ := h_mean_value _ _ hyx
    rw [abs_le]
    constructor <;> cases abs_cases (x - y) <;>
      nlinarith [abs_le.mp (h_deriv_bound c)]

/-- Weak-coupling uniqueness: if `|c*g| < 4`, any two fixed points coincide. -/
theorem selfConsistent_unique (c E0 g : ℝ) (h : |c * g| < 4)
    {theta1 theta2 : ℝ}
    (h1 : feedback c E0 g theta1 = theta1)
    (h2 : feedback c E0 g theta2 = theta2) : theta1 = theta2 := by
  have h_lip :
      |feedback c E0 g theta1 - feedback c E0 g theta2| ≤
        (|c * g| / 4) * |theta1 - theta2| := by
    have hgibbs :
        |gibbsWeight (E0 + g * theta1) - gibbsWeight (E0 + g * theta2)| ≤
          (1 / 4) * |(E0 + g * theta1) - (E0 + g * theta2)| := by
      convert gibbsWeight_lipschitz.dist_le_mul
        (E0 + g * theta1) (E0 + g * theta2) using 1
    convert mul_le_mul_of_nonneg_left hgibbs (abs_nonneg c) using 1 <;>
      norm_num [abs_mul, mul_assoc, mul_comm, mul_left_comm, feedback]
    · rw [← abs_mul, mul_sub]
    · rw [show g * theta1 - g * theta2 = g * (theta1 - theta2) by ring,
        abs_mul]
      ring
  cases abs_cases (theta1 - theta2) <;> cases abs_cases (c * g) <;>
    nlinarith [abs_le.mp h_lip]

/-- The model `c=1`, `E0=0`, `g=1` has a unique non-boundary fixed point. -/
theorem witness_selfConsistent :
    ∃ theta ∈ Set.Ioo (0 : ℝ) 1,
      feedback 1 0 1 theta = theta ∧
        ∀ theta' : ℝ, feedback 1 0 1 theta' = theta' → theta' = theta := by
  obtain ⟨theta, hWindow, hfix⟩ :
      ∃ theta ∈ Set.Icc (0 : ℝ) 1, feedback 1 0 1 theta = theta := by
    exact exists_selfConsistent 1 0 1 (by norm_num)
  refine ⟨theta, ?_, hfix, ?_⟩
  · unfold feedback at hfix
    constructor <;> have hGibbs := gibbsWeight_mem_Ioo theta <;> aesop
  · exact fun theta' htheta' =>
      selfConsistent_unique 1 0 1 (by norm_num) htheta' hfix

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.SelfConsistentDecoder.exists_selfConsistent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_selfConsistent

/-- info: 'PhysicsSM.Draft.NullEdge.SelfConsistentDecoder.selfConsistent_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selfConsistent_unique

/-- info: 'PhysicsSM.Draft.NullEdge.SelfConsistentDecoder.witness_selfConsistent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_selfConsistent

end PhysicsSM.Draft.NullEdge.SelfConsistentDecoder
