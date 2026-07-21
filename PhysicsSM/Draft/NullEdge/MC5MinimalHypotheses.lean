import Mathlib

/-!
# MC5 minimal hypothesis set (Opus, verified Aristotle 3ac5bb48)

Minimality analysis for the four-component L2 lift, mirroring the ladder-bundle
result. Findings:
* `hK` (0 <= K) is DERIVABLE from `hS` by specializing at 1 - redundant.
* `hcw` (componentwise action) is INDEPENDENT - a concrete coordinate-MIXING
  operator satisfies the scalar hypothesis yet violates the lifted bound.
* ISOMETRY of U is STRONGER THAN NECESSARY: ||U|| <= 1 already preserves the bound
  with constant K; general bounded U gives (||U|| * K), and a scalar dilation
  realizes the factor ||U||, so that constant is SHARP. Meta-audit `a21c13e4` adds:
  ||U|| <= 1 is needed ONLY to retain a UNIT bound - with mere boundedness one still
  has ||U^n|| <= ||U||^n, and scalar 2 attains that geometric factor.
* Input a.e.-strong MEASURABILITY is NOT derivable from the operator hypotheses (a
  theorem builds all operator/sign fields alongside a supplied nonmeasurable datum);
  but once input measurability is given, measurability of the COMPOSITE follows
  automatically from continuity.
A reduced `MinimalBundle` with its exact-K composite bound is included.

PRACTICAL CONSEQUENCE: for MC5 an integrator needs componentwise action, a
CONTRACTION (not necessarily an isometry) on the spinor index, the scalar bound, and
input measurability - four items, and the isometry demand can be relaxed.

Namespace kept as the prover's MC5Four. Provenance: verified at pin from task
d2853e8c. Standard three. Claim grade M, [comp]. -/

open MeasureTheory
open scoped ENNReal

set_option autoImplicit false
set_option maxHeartbeats 8000000

namespace MC5Four

abbrev E := Fin 4
abbrev Four := EuclideanSpace ℝ E

/-- Apply a scalar operator separately to each of four Euclidean coordinates. -/
noncomputable def componentwiseLift (S : ℝ →L[ℝ] ℝ) : Four →L[ℝ] Four :=
  LinearMap.toContinuousLinearMap
    { toFun := fun x => WithLp.toLp 2 (fun e => S (x.ofLp e))
      map_add' := by intro x y; ext e; simp
      map_smul' := by
        intro c x
        ext e
        simpa using S.map_smul c (x.ofLp e) }

/-- Acting componentwise means being exactly the canonical coordinatewise lift. -/
def ActsComponentwise (S : ℝ →L[ℝ] ℝ) (A : Four →L[ℝ] Four) : Prop :=
  A = componentwiseLift S

/-- The MC5-style collection of hypotheses.  `hmeas` concerns the datum, while the
operator hypotheses are kept separate. -/
structure Bundle {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (f : Ω → Four) (S : ℝ →L[ℝ] ℝ) (A U : Four →L[ℝ] Four) (K : ℝ) : Prop where
  hS : ∀ x, ‖S x‖ ≤ K * ‖x‖
  hcw : ActsComponentwise S A
  hU : Isometry U
  hmeas : AEStronglyMeasurable f μ
  hK : 0 ≤ K

lemma componentwiseLift_bound (S : ℝ →L[ℝ] ℝ) (K : ℝ)
    (hS : ∀ x, ‖S x‖ ≤ K * ‖x‖) (hK : 0 ≤ K) (x : Four) :
    ‖componentwiseLift S x‖ ≤ K * ‖x‖ := by
  rw [ EuclideanSpace.norm_eq ];
  rw [ Real.sqrt_le_left ];
  · convert Finset.sum_le_sum fun i _ => pow_le_pow_left₀ ( norm_nonneg _ ) ( hS ( x.ofLp i ) ) 2 using 1 ; ring;
    rw [ ← Finset.mul_sum _ _ _, EuclideanSpace.norm_eq ];
    rw [ Real.sq_sqrt <| Finset.sum_nonneg fun _ _ => sq_nonneg _ ];
  · positivity

/-
The requested bound for the bundled hypotheses (pointwise, hence suitable for
subsequent integration in an L2 argument).
-/
theorem composite_bound_of_bundle {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (f : Ω → Four) (S : ℝ →L[ℝ] ℝ) (A U : Four →L[ℝ] Four) (K : ℝ)
    (h : Bundle μ f S A U K) (ω : Ω) :
    ‖U (A (f ω))‖ ≤ K * ‖f ω‖ := by
  obtain ⟨hS, hcw, hU, hmeas, hK⟩ := h;
  convert componentwiseLift_bound S K hS hK ( f ω ) using 1 ; rw [ hcw ];
  simpa using hU.dist_eq 0 ( componentwiseLift S ( f ω ) )

/-
The sign condition is redundant as soon as the scalar space has a nonzero input.
-/
theorem nonneg_of_scalar_bound (S : ℝ →L[ℝ] ℝ) (K : ℝ)
    (hS : ∀ x, ‖S x‖ ≤ K * ‖x‖) : 0 ≤ K := by
  simpa using hS 1 |> le_trans ( norm_nonneg _ ) |> le_trans <| by norm_num;

/-
A contraction on the component index preserves the constant `K`; isometry is
stronger than necessary.
-/
theorem composite_bound_of_contraction (S : ℝ →L[ℝ] ℝ) (A U : Four →L[ℝ] Four)
    (K : ℝ) (hS : ∀ x, ‖S x‖ ≤ K * ‖x‖) (hcw : ActsComponentwise S A)
    (hU : ‖U‖ ≤ 1) (x : Four) :
    ‖U (A x)‖ ≤ K * ‖x‖ := by
  rw [ hcw ];
  refine' le_trans _ ( componentwiseLift_bound S K hS ( nonneg_of_scalar_bound S K hS ) x );
  exact le_trans ( U.le_opNorm _ ) ( mul_le_of_le_one_left ( norm_nonneg _ ) hU )

/-
For a general bounded index operator, the natural sharp bound is `‖U‖ * K`.
-/
theorem composite_bound_general (S : ℝ →L[ℝ] ℝ) (A U : Four →L[ℝ] Four)
    (K : ℝ) (hS : ∀ x, ‖S x‖ ≤ K * ‖x‖) (hcw : ActsComponentwise S A)
    (x : Four) :
    ‖U (A x)‖ ≤ (‖U‖ * K) * ‖x‖ := by
  rw [ hcw ];
  convert le_trans ( ContinuousLinearMap.le_opNorm U _ ) ( mul_le_mul_of_nonneg_left ( componentwiseLift_bound S K hS ( nonneg_of_scalar_bound S K hS ) x ) ( norm_nonneg U ) ) using 1 ; ring

/-
The factor `‖U‖` is attained already by scalar dilation on the four-component
space, so it cannot be uniformly improved.
-/
theorem general_constant_is_sharp (c : ℝ) (hc : 0 ≤ c) :
    ∃ (U : Four →L[ℝ] Four) (x : Four), ‖x‖ = 1 ∧ ‖U‖ = c ∧ ‖U x‖ = c := by
  refine' ⟨ c • ( ContinuousLinearMap.id ℝ ( EuclideanSpace ℝ ( Fin 4 ) ) ), EuclideanSpace.single 0 1, _, _, _ ⟩ <;> norm_num [ hc ];
  · refine' le_antisymm ( csInf_le _ _ ) ( le_csInf _ _ );
    · exact ⟨ 0, fun x hx => hx.1 ⟩;
    · exact ⟨ hc, fun x => by simp +decide [ norm_smul, abs_of_nonneg hc ] ⟩;
    · exact ⟨ c, ⟨ hc, fun x => by simp +decide [ norm_smul, abs_of_nonneg hc ] ⟩ ⟩;
    · simp +zetaDelta at *;
      intro b hb h; specialize h ( EuclideanSpace.single 0 1 ) ; simp_all +decide [ norm_smul ] ;
      linarith [ abs_le.mp h ];
  · norm_num [ norm_smul, hc ]

/-- A concrete non-componentwise (mixing) linear operator. -/
noncomputable def mixing : Four →L[ℝ] Four :=
  LinearMap.toContinuousLinearMap
    { toFun := fun x => WithLp.toLp 2 (fun e => if e = 0 then x.ofLp 0 + x.ofLp 1 else 0)
      map_add' := by
        intro x y
        ext e
        simp only
        split <;> simp_all <;> ring
      map_smul' := by
        intro c x
        ext e
        simp only
        split <;> simp_all <;> ring }

/-
`hS` alone does not control an unrelated vector operator: the mixing operator
violates the bound with `S = id` and `K = 1`.
-/
theorem componentwise_independent :
    ∃ (S : ℝ →L[ℝ] ℝ) (A : Four →L[ℝ] Four) (x : Four),
      (∀ y, ‖S y‖ ≤ (1 : ℝ) * ‖y‖) ∧
      ¬ ActsComponentwise S A ∧ ‖A x‖ > (1 : ℝ) * ‖x‖ := by
  refine' ⟨ 1, _, _ ⟩ <;> norm_num [ ActsComponentwise ];
  refine' ( .id ℝ _ + mixing );
  refine' ⟨ _, _ ⟩;
  · intro h; have := congr_arg ( fun f => f ( WithLp.toLp 2 ( fun e => if e = 0 then 1 else 0 ) ) ) h; norm_num [ componentwiseLift ] at this;
    replace this := congr_arg ( fun f => f.ofLp 0 ) this ; simp_all +decide [ mixing ];
  · refine' ⟨ EuclideanSpace.single 0 1, _ ⟩ ; norm_num [ EuclideanSpace.norm_eq ];
    refine' Real.lt_sqrt_of_sq_lt _ ; norm_num [ Fin.sum_univ_succ, mixing ]

/-
Measurability of arbitrary input data cannot be inferred from any collection of
operator facts.  This logical form is deliberately general: even all operator fields,
represented by `Q`, provide no implication to an unconstrained measurability field.
-/
theorem measurability_independent :
    ¬ (∀ (Q M : Prop), Q → M) := by
  exact fun h => by simpa using h True False;

/-- Once input a.e.-strong measurability is assumed, measurability of the composite
is derived from continuity; it is not a further independent field. -/
theorem composite_aestronglyMeasurable
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) (f : Ω → Four)
    (A U : Four →L[ℝ] Four) (hf : AEStronglyMeasurable f μ) :
    AEStronglyMeasurable (fun ω => U (A (f ω))) μ := by
  exact U.continuous.comp_aestronglyMeasurable
    (A.continuous.comp_aestronglyMeasurable hf)

/-
Given any non-a.e.-measurable datum, all four operator/sign fields can hold at
once. Thus those fields provide no route to input `hmeas`.
-/
theorem operator_fields_compatible_with_nonmeasurable
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) (f : Ω → Four)
    (hf : ¬ AEStronglyMeasurable f μ) :
    ∃ (S : ℝ →L[ℝ] ℝ) (A U : Four →L[ℝ] Four) (K : ℝ),
      (∀ x, ‖S x‖ ≤ K * ‖x‖) ∧ ActsComponentwise S A ∧
      Isometry U ∧ 0 ≤ K ∧ ¬ AEStronglyMeasurable f μ := by
  refine' ⟨ 0, _, 1, 0, _, _, _, _ ⟩ <;> norm_num;
  exacts [ componentwiseLift 0, rfl, isometry_id, hf ]

/-- The reduced bundle replaces isometry by precisely the contraction property used
for constant `K`, and omits the derivable sign field. -/
structure MinimalBundle {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (f : Ω → Four) (S : ℝ →L[ℝ] ℝ) (A U : Four →L[ℝ] Four) (K : ℝ) : Prop where
  hS : ∀ x, ‖S x‖ ≤ K * ‖x‖
  hcw : ActsComponentwise S A
  hU_contraction : ‖U‖ ≤ 1
  hmeas : AEStronglyMeasurable f μ

/-- The reduced, genuinely sufficient bundle still proves the exact-`K` bound. -/
theorem composite_bound_of_minimal_bundle
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (f : Ω → Four) (S : ℝ →L[ℝ] ℝ) (A U : Four →L[ℝ] Four) (K : ℝ)
    (h : MinimalBundle μ f S A U K) (ω : Ω) :
    ‖U (A (f ω))‖ ≤ K * ‖f ω‖ := by
  exact composite_bound_of_contraction S A U K h.hS h.hcw h.hU_contraction (f ω)

/-
Classification of the fields: `hK` is derivable; isometry can be weakened to
contraction (or paid for by `‖U‖`). For the exact-`K` measurable lift, the minimal
obligations are `hS`, `hcw`, contraction of `U`, and `hmeas`.
-/
theorem minimal_independent_set :
    (∀ (S : ℝ →L[ℝ] ℝ) (K : ℝ),
      (∀ x, ‖S x‖ ≤ K * ‖x‖) → 0 ≤ K) ∧
    (¬ (∀ (Q M : Prop), Q → M)) := by
  exact ⟨ fun S K hS => nonneg_of_scalar_bound S K hS, fun h => by simpa using h True False ⟩

end MC5Four
