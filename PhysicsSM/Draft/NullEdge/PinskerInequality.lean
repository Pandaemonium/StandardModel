import Mathlib

/-!
# Pinsker's inequality (finite)

Draft module. Relative entropy dominates the squared total variation distance:
`(1/2) (sum_i |p_i - q_i|)^2 <= relEntropy p q`. This is the quantitative
sharpening of Gibbs' inequality (relative entropy nonnegativity) and the
metric-control lemma the information-resource / gravity-DPI program needs to turn
entropy statements into distance statements. Companion to the finite Gibbs
inequality (S2 lane) and the classical DPI (Q1 gate).

## Statement

`(1 / 2) * (totalVariation p q) ^ 2 <= relEntropy p q` for probability vectors
`p` (nonnegative, sum one) and `q` (strictly positive, sum one), with
`relEntropy p q = sum_i p_i log (p_i / q_i)` and
`totalVariation p q = sum_i |p_i - q_i|`.

## Trust status

Draft-trust by kernel: `pinsker` is `sorry`-free and depends only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.
Independently re-checked under the pinned toolchain despite the upstream job's
`COMPLETE_WITH_ERRORS` label (which reflected Aristotle's search iterations, not
the final artifact): the downloaded file compiles clean with kernel-only axioms.

## Provenance

Statement authored in-project (AFPL run 2026-07-12). Proof search by Aristotle
(project `9cc68db9-eaff-41a0-a681-7f929406c625`), then independently re-checked in
this repo (`lake env lean`; axiom footprint confirmed kernel-only). Route: the
scalar (Bernoulli) bound `2 (P-Q)^2 <= P log(P/Q) + (1-P) log((1-P)/(1-Q))` by
calculus (nonnegative second derivative `1/(x(1-x)) - 4 >= 0`, stationary at `Q`),
lifted to the finite case. Clean-room formalization from the mathematical
statement, not copied from external code.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Pinsker

open scoped BigOperators

variable {k : Type*} [Fintype k]

/-- Finite relative entropy `∑ i, p i * log (p i / q i)`. -/
def relEntropy (p q : k → ℝ) : ℝ :=
  ∑ i, p i * Real.log (p i / q i)

/-- Total variation distance (`ℓ¹`), `∑ i, |p i - q i|`. -/
def totalVariation (p q : k → ℝ) : ℝ :=
  ∑ i, |p i - q i|

/-
**Scalar (Bernoulli) Pinsker bound.**  For `P ∈ [0,1]` and `Q ∈ (0,1)`,
`P log (P/Q) + (1-P) log ((1-P)/(1-Q)) ≥ 2 (P-Q)^2`.
-/
set_option maxHeartbeats 1600000 in
lemma scalar_bound (P Q : ℝ) (hP0 : 0 ≤ P) (hP1 : P ≤ 1) (hQ0 : 0 < Q) (hQ1 : Q < 1) :
    2 * (P - Q) ^ 2 ≤ P * Real.log (P / Q) + (1 - P) * Real.log ((1 - P) / (1 - Q)) := by
  -- Define F : ℝ → ℝ by F x = x * Real.log (x / Q) + (1 - x) * Real.log ((1 - x) / (1 - Q)) - 2 * (x - Q)^2.
  set F : ℝ → ℝ := fun x => x * Real.log (x / Q) + (1 - x) * Real.log ((1 - x) / (1 - Q)) - 2 * (x - Q)^2;
  -- Since $F$ is convex and $F(Q) = 0$, we have $F(x) \geq F(Q)$ for all $x \in [0, 1]$.
  have h_convex : ConvexOn ℝ (Set.Icc 0 1) F := by
    apply_rules [ convexOn_of_deriv2_nonneg, convex_Icc ];
    · refine' ContinuousOn.sub ( ContinuousOn.add _ _ ) _;
      · have h_cont : ContinuousOn (fun x => x * Real.log x - x * Real.log Q) (Set.Icc 0 1) := by
          exact ContinuousOn.sub ( Real.continuous_mul_log.continuousOn ) ( continuousOn_id.mul continuousOn_const );
        refine' h_cont.congr fun x hx => by by_cases h : x = 0 <;> simp +decide [ h, Real.log_div, hQ0.ne' ] ; ring;
      · have h_cont : ContinuousOn (fun x => x * Real.log x) (Set.Icc 0 1) := by
          exact Continuous.continuousOn ( Real.continuous_mul_log );
        have h_cont : ContinuousOn (fun x => (1 - x) * Real.log (1 - x) - (1 - x) * Real.log (1 - Q)) (Set.Icc 0 1) := by
          exact ContinuousOn.sub ( h_cont.comp ( continuousOn_const.sub continuousOn_id ) fun x hx => by constructor <;> linarith [ hx.1, hx.2 ] ) ( ContinuousOn.mul ( continuousOn_const.sub continuousOn_id ) continuousOn_const );
        refine' h_cont.congr fun x hx => _;
        by_cases h : 1 - x = 0 <;> simp +decide [ h, Real.log_div, show ( 1 - Q ) ≠ 0 by linarith ] ; ring;
      · exact Continuous.continuousOn ( by continuity );
    · norm_num +zetaDelta at *;
      exact fun x hx => DifferentiableAt.differentiableWithinAt ( by exact DifferentiableAt.sub ( DifferentiableAt.add ( DifferentiableAt.mul ( differentiableAt_id ) ( DifferentiableAt.log ( differentiableAt_id.div_const _ ) ( by exact div_ne_zero hx.1.ne' hQ0.ne' ) ) ) ( DifferentiableAt.mul ( differentiableAt_id.const_sub _ ) ( DifferentiableAt.log ( DifferentiableAt.div ( differentiableAt_id.const_sub _ ) ( differentiableAt_const _ ) ( by linarith ) ) ( by exact div_ne_zero ( by linarith [ hx.2 ] ) ( by linarith ) ) ) ) ) ( DifferentiableAt.mul ( differentiableAt_const _ ) ( DifferentiableAt.pow ( differentiableAt_id.sub ( differentiableAt_const _ ) ) _ ) ) ) ;
    · -- Let's calculate the first derivative of $F$.
      have h_deriv : ∀ x ∈ Set.Ioo 0 1, deriv F x = Real.log (x / Q) - Real.log ((1 - x) / (1 - Q)) - 4 * (x - Q) := by
        intro x hx; norm_num [ F, show x ≠ 0 from hx.1.ne', show x ≠ 1 from hx.2.ne, show Q ≠ 0 from hQ0.ne', show Q ≠ 1 from hQ1.ne, sub_ne_zero, mul_comm, mul_assoc, mul_left_comm, div_eq_mul_inv ] ; ring;
        norm_num [ show x ≠ 0 from hx.1.ne', show Q ≠ 0 from hQ0.ne', show ( 1 - Q ) ≠ 0 from by linarith, show - ( x * ( 1 - Q ) ⁻¹ ) + ( 1 - Q ) ⁻¹ ≠ 0 from by nlinarith [ hx.1, hx.2, mul_inv_cancel₀ ( by linarith : ( 1 - Q ) ≠ 0 ) ] ] ; ring;
        grind;
      norm_num +zetaDelta at *;
      exact DifferentiableOn.congr ( fun x hx => DifferentiableAt.differentiableWithinAt <| by exact DifferentiableAt.sub ( DifferentiableAt.sub ( DifferentiableAt.log ( differentiableAt_id.div_const _ ) <| by exact ne_of_gt <| div_pos hx.1 hQ0 ) <| DifferentiableAt.log ( DifferentiableAt.div ( differentiableAt_id.const_sub _ ) ( differentiableAt_const _ ) <| by linarith ) <| by exact ne_of_gt <| div_pos ( by linarith [ hx.1, hx.2 ] ) <| by linarith ) <| DifferentiableAt.mul ( differentiableAt_const _ ) <| differentiableAt_id.sub_const _ ) fun x hx => h_deriv x hx.1 hx.2;
    · -- Let's calculate the first derivative of $F$.
      have h_deriv : ∀ x ∈ Set.Ioo 0 1, deriv F x = Real.log (x / Q) - Real.log ((1 - x) / (1 - Q)) - 4 * (x - Q) := by
        intro x hx; norm_num [ F, show x ≠ 0 from hx.1.ne', show x ≠ 1 from hx.2.ne, show Q ≠ 0 from hQ0.ne', show Q ≠ 1 from hQ1.ne, sub_ne_zero, mul_comm, mul_assoc, mul_left_comm, div_eq_mul_inv ] ; ring;
        norm_num [ show x ≠ 0 from hx.1.ne', show Q ≠ 0 from hQ0.ne', show ( 1 - Q ) ≠ 0 from by linarith, show - ( x * ( 1 - Q ) ⁻¹ ) + ( 1 - Q ) ⁻¹ ≠ 0 from by nlinarith [ hx.1, hx.2, mul_inv_cancel₀ ( by linarith : ( 1 - Q ) ≠ 0 ) ] ] ; ring;
        grind;
      -- Let's calculate the second derivative of $F$.
      have h_deriv2 : ∀ x ∈ Set.Ioo 0 1, deriv^[2] F x = 1 / x + 1 / (1 - x) - 4 := by
        intro x hx; refine' HasDerivAt.deriv _ ; convert HasDerivAt.congr_of_eventuallyEq _ ( Filter.eventuallyEq_of_mem ( Ioo_mem_nhds hx.1 hx.2 ) fun y hy => h_deriv y hy ) using 1 ; ring;
        convert HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.mul ( hasDerivAt_id x ) ( hasDerivAt_const _ _ ) ) ) ( hasDerivAt_const _ _ ) ) ( HasDerivAt.sub ( HasDerivAt.log ( HasDerivAt.mul ( hasDerivAt_id x ) ( hasDerivAt_const _ _ ) ) _ ) ( HasDerivAt.log ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.mul ( hasDerivAt_id x ) ( hasDerivAt_const _ _ ) ) ) ( hasDerivAt_const _ _ ) ) _ ) ) using 1 <;> norm_num <;> ring <;> try nlinarith [ hx.1, hx.2, mul_inv_cancel₀ ( by linarith : ( 1 - Q ) ≠ 0 ) ] ;
        · grind;
        · exact ⟨ hx.1.ne', hQ0.ne' ⟩
      simp_all +decide [ div_eq_mul_inv ] ; (
      exact fun x hx₁ hx₂ => by nlinarith [ inv_pos.2 hx₁, inv_pos.2 ( sub_pos.2 hx₂ ), mul_inv_cancel₀ hx₁.ne', mul_inv_cancel₀ ( sub_ne_zero.2 hx₂.ne' ), sq_nonneg ( x - 1 / 2 ) ] ;)
  have h_min : ∀ x ∈ Set.Icc 0 1, F x ≥ F Q := by
    have h_min : ∀ x ∈ Set.Ioo 0 1, deriv F x = Real.log (x / Q) - Real.log ((1 - x) / (1 - Q)) - 4 * (x - Q) := by
      intro x hx; erw [ deriv_sub ] <;> norm_num [ sub_ne_zero, hx.1.ne', hx.2.ne', ne_of_gt hQ0, ne_of_gt ( sub_pos.2 hQ1 ) ] ; ring;
      · norm_num [ show x ≠ 0 by linarith [ hx.1 ], show x ≠ 1 by linarith [ hx.2 ], show Q ≠ 0 by linarith, show Q ≠ 1 by linarith, show ( 1 - Q ) ≠ 0 by linarith, show ( - ( x * ( 1 - Q ) ⁻¹ ) + ( 1 - Q ) ⁻¹ ) ≠ 0 by nlinarith [ hx.1, hx.2, mul_inv_cancel₀ ( by linarith : ( 1 - Q ) ≠ 0 ) ] ] ; ring;
        grind;
      · exact DifferentiableAt.mul ( differentiableAt_id.const_sub _ ) ( DifferentiableAt.log ( DifferentiableAt.div ( differentiableAt_id.const_sub _ ) ( differentiableAt_const _ ) ( by linarith ) ) ( div_ne_zero ( by linarith [ hx.1, hx.2 ] ) ( by linarith ) ) );
    intros x hx
    have h_deriv_zero : derivWithin F (Set.Ioi Q) Q = 0 := by
      rw [ derivWithin ];
      rw [ fderivWithin_eq_fderiv ] <;> norm_num [ h_min Q ⟨ hQ0, hQ1 ⟩ ];
      · exact uniqueDiffWithinAt_Ioi _;
      · apply_rules [ DifferentiableAt.sub, DifferentiableAt.add, DifferentiableAt.mul, DifferentiableAt.log, differentiableAt_id, differentiableAt_const ] <;> norm_num [ hQ0.ne', hQ1.ne' ];
        linarith;
    have := h_convex.isMinOn_of_rightDeriv_eq_zero ( show Q ∈ interior ( Set.Icc 0 1 ) from by rw [ interior_Icc ] ; exact ⟨ by linarith, by linarith ⟩ ) h_deriv_zero;
    exact this hx
  have h_FQ_zero : F Q = 0 := by
    simp +zetaDelta at *
  have h_final : F P ≥ 0 := by
    exact h_FQ_zero ▸ h_min P ⟨ hP0, hP1 ⟩
  linarith [h_final]

/-
**Log-sum inequality.**  For nonnegative `a` and positive `b` on a finset `s`,
`(∑ a) log ((∑ a)/(∑ b)) ≤ ∑ a_i log (a_i / b_i)`.  This is Jensen for the convex
function `x ↦ x log x`.
-/
omit [Fintype k] in
lemma logSum_ge (s : Finset k) (a b : k → ℝ)
    (ha : ∀ i ∈ s, 0 ≤ a i) (hb : ∀ i ∈ s, 0 < b i) :
    (∑ i ∈ s, a i) * Real.log ((∑ i ∈ s, a i) / (∑ i ∈ s, b i))
      ≤ ∑ i ∈ s, a i * Real.log (a i / b i) := by
  by_cases h : ∑ i ∈ s, a i = 0;
  · simp_all +decide [ Finset.sum_eq_zero_iff_of_nonneg ];
  · have h_jensen : (∑ i ∈ s, (b i / ∑ i ∈ s, b i) * ((a i / b i) * Real.log (a i / b i))) ≥ ((∑ i ∈ s, (b i / ∑ i ∈ s, b i) * (a i / b i))) * Real.log ((∑ i ∈ s, (b i / ∑ i ∈ s, b i) * (a i / b i))) := by
      have h_jensen : ConvexOn ℝ (Set.Ici 0) (fun x => x * Real.log x) := by
        exact ( Real.convexOn_mul_log );
      apply ConvexOn.map_sum_le h_jensen;
      · exact fun i hi => div_nonneg ( le_of_lt ( hb i hi ) ) ( Finset.sum_nonneg fun _ _ => le_of_lt ( hb _ ‹_› ) );
      · rw [ ← Finset.sum_div, div_self ( ne_of_gt ( Finset.sum_pos ( fun i hi => hb i hi ) ( Finset.nonempty_of_ne_empty ( by aesop_cat ) ) ) ) ];
      · exact fun i hi => div_nonneg ( ha i hi ) ( le_of_lt ( hb i hi ) );
    simp_all +decide [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul ];
    simp_all +decide [ ne_of_gt ( hb _ _ ) ];
    simp_all +decide [ ← mul_assoc, ← Finset.sum_mul ];
    convert mul_le_mul_of_nonneg_left h_jensen ( show 0 ≤ ∑ i ∈ s, b i from Finset.sum_nonneg fun _ _ => le_of_lt ( hb _ ‹_› ) ) using 1 <;> ring;
    · by_cases h' : ∑ i ∈ s, b i = 0 <;> simp_all +decide [ mul_assoc ];
    · simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, ne_of_gt ( show 0 < ∑ i ∈ s, b i from Finset.sum_pos hb ( Finset.nonempty_of_ne_empty ( by aesop_cat ) ) ) ]

/-
**TARGET (the hole): Pinsker's inequality.**  Relative entropy dominates the
squared total variation distance.
-/
theorem pinsker (p q : k → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hps : ∑ i, p i = 1) (hqs : ∑ i, q i = 1) :
    (1 / 2) * (totalVariation p q) ^ 2 ≤ relEntropy p q := by
  -- Apply the scalar bound to the aggregated masses $P$ and $R$.
  have h_scalar_bound : 2 * ((∑ i ∈ Finset.univ.filter (fun i => q i ≤ p i), p i) - (∑ i ∈ Finset.univ.filter (fun i => q i ≤ p i), q i)) ^ 2 ≤ (∑ i ∈ Finset.univ.filter (fun i => q i ≤ p i), p i) * Real.log ((∑ i ∈ Finset.univ.filter (fun i => q i ≤ p i), p i) / (∑ i ∈ Finset.univ.filter (fun i => q i ≤ p i), q i)) + (1 - (∑ i ∈ Finset.univ.filter (fun i => q i ≤ p i), p i)) * Real.log ((1 - (∑ i ∈ Finset.univ.filter (fun i => q i ≤ p i), p i)) / (1 - (∑ i ∈ Finset.univ.filter (fun i => q i ≤ p i), q i))) := by
    by_cases h : ∑ i with q i ≤ p i, q i = 0 <;> by_cases h' : ∑ i with q i ≤ p i, q i = 1 <;> simp_all +decide [ Finset.sum_eq_zero_iff_of_nonneg, le_of_lt ];
    · rw [ Finset.sum_eq_zero ] <;> simp_all +decide [ ne_of_gt ];
      exact absurd ( Finset.sum_lt_sum_of_nonempty ( Finset.univ_nonempty_iff.mpr ⟨ Classical.choose ( show ∃ i, True from by
                                                                                                        cases isEmpty_or_nonempty k <;> aesop ) ⟩ ) fun i _ => h i ) ( by simp +decide [ * ] );
    · -- Since $\sum_{i \in s} q_i = 1$, we have $\sum_{i \in s} p_i = 1$ as well.
      have h_sum_eq : ∑ i with q i ≤ p i, p i = 1 := by
        refine' le_antisymm _ _;
        · exact hps ▸ Finset.sum_le_sum_of_subset_of_nonneg ( Finset.subset_univ _ ) fun _ _ _ => hp _;
        · exact h'.symm ▸ Finset.sum_le_sum fun i hi => Finset.mem_filter.mp hi |>.2;
      aesop;
    · convert scalar_bound ( ∑ i with q i ≤ p i, p i ) ( ∑ i with q i ≤ p i, q i ) _ _ _ _ using 1;
      · exact Finset.sum_nonneg fun _ _ => hp _;
      · exact hps ▸ Finset.sum_le_sum_of_subset_of_nonneg ( Finset.subset_univ _ ) fun _ _ _ => hp _;
      · exact Finset.sum_pos ( fun i hi => hq i ) ⟨ h.choose, Finset.mem_filter.mpr ⟨ Finset.mem_univ _, h.choose_spec.1 ⟩ ⟩;
      · exact lt_of_le_of_ne ( hqs ▸ Finset.sum_le_sum_of_subset_of_nonneg ( Finset.subset_univ _ ) fun _ _ _ => le_of_lt ( hq _ ) ) h';
  convert h_scalar_bound.trans _ using 1;
  · -- By definition of total variation, we have:
    have h_total_variation : totalVariation p q = (∑ i ∈ Finset.univ.filter (fun i => q i ≤ p i), (p i - q i)) + (∑ i ∈ Finset.univ.filter (fun i => q i > p i), (q i - p i)) := by
      unfold totalVariation;
      rw [ Finset.sum_filter, Finset.sum_filter ] ; rw [ ← Finset.sum_add_distrib ] ; congr ; ext i ; split_ifs <;> cases abs_cases ( p i - q i ) <;> linarith;
    simp_all +decide [ Finset.sum_ite ];
    rw [ show ( ∑ i with p i < q i, q i ) = 1 - ∑ i with q i ≤ p i, q i by rw [ ← hqs, ← Finset.sum_filter_add_sum_filter_not Finset.univ ( fun i => q i ≤ p i ) ] ; simp +decide [ Finset.filter_not, Finset.sum_add_distrib ] ] ; rw [ show ( ∑ i with p i < q i, p i ) = 1 - ∑ i with q i ≤ p i, p i by rw [ ← hps, ← Finset.sum_filter_add_sum_filter_not Finset.univ ( fun i => q i ≤ p i ) ] ; simp +decide [ Finset.filter_not, Finset.sum_add_distrib ] ] ; ring;
  · convert add_le_add ( logSum_ge ( Finset.univ.filter ( fun i => q i ≤ p i ) ) p q ( fun i hi => hp i ) ( fun i hi => hq i ) ) ( logSum_ge ( Finset.univ.filter ( fun i => ¬q i ≤ p i ) ) p q ( fun i hi => hp i ) ( fun i hi => hq i ) ) using 1 <;> simp +decide [ Finset.sum_filter, Finset.sum_add_distrib, hps, hqs ];
    · congr! 2;
      · rw [ ← hps, ← Finset.sum_sub_distrib ] ; congr ; ext i ; split_ifs <;> linarith;
      · congr! 1;
        · rw [ ← hps, ← Finset.sum_sub_distrib ] ; congr ; ext i ; split_ifs <;> linarith;
        · rw [ ← hqs, ← Finset.sum_sub_distrib ] ; congr ; ext i ; split_ifs <;> linarith;
    · simpa only [ ← Finset.sum_add_distrib ] using Finset.sum_congr rfl fun i _ => by split_ifs <;> linarith;

end PhysicsSM.Draft.NullEdge.Pinsker

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.Pinsker.pinsker' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Pinsker.pinsker
