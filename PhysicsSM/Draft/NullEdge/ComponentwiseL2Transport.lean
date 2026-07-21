import Mathlib

/-!
# Componentwise L2 transport (Opus, verified Aristotle d0df1641)

Abstract Mathlib-only brick discharging MC5 hidden-assumption item 2 of
`AutonomousLab/work/NE-3PLUS1/OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md`:
when a two-component L2 argument is lifted to four components, representatives and
measurability must be TRANSPORTED, not assumed. CORRECTION (docstring audit
`6d88b22a`): componentwise reuse is free in the CONSTANT but NOT in MEASURABILITY -
a witness on a two-point domain has a measurable constant component and a
non-measurable varying one. Measurability must be established per component or via a
common measurable-construction theorem covering all components. Contents: strong (and a.e. strong)
measurability is equivalent to componentwise; the exact Pythagorean assembly
||f||_2^2 = sum_i ||f_i||_2^2; component bounds assemble as sqrt(sum_i B_i^2) with
NO extraneous factor n; measurability transported through pointwise matrix-vector
multiplication; and the multiplier theorem carrying an a.e. pointwise L2
operator-norm bound to the global L2 estimate, with every source measurability
hypothesis stated explicitly.

Offered to Codex for the MC5 integration (walk-agnostic; no MC file touched).
Namespace kept as the prover's ComponentwiseL2. Provenance: verified at pin from
task c49a0335. Standard three. Claim grade M, [comp]. -/

open scoped BigOperators ENNReal NNReal Matrix.Norms.L2Operator
open MeasureTheory

set_option autoImplicit false

namespace ComponentwiseL2

variable {X : Type*} [MeasurableSpace X]
variable {𝕜 : Type*} [RCLike 𝕜]
variable {n : ℕ} (μ : Measure X)

/-- The real-valued `L²` seminorm of a representative. -/
noncomputable def L2Norm (f : X → EuclideanSpace 𝕜 (Fin n)) : ℝ :=
  lpNorm f 2 μ

/-- The scalar `L²` seminorm of a component representative. -/
noncomputable def componentL2Norm (g : X → 𝕜) : ℝ :=
  lpNorm g 2 μ

/-
Strong measurability of a finite Euclidean-valued function is exactly
strong measurability of all its coordinates.
-/
theorem stronglyMeasurable_euclidean_iff
    (f : X → EuclideanSpace 𝕜 (Fin n)) :
    StronglyMeasurable f ↔ ∀ i, StronglyMeasurable (fun x ↦ (f x).ofLp i) := by
  refine' ⟨ fun hf i => _, fun hf => _ ⟩;
  · fun_prop;
  · have h_prod : ∀ {f : X → (Fin n) → 𝕜}, (∀ i, StronglyMeasurable (fun x => f x i)) → StronglyMeasurable f := by
      intro f hf;
      exact Measurable.stronglyMeasurable ( measurable_pi_iff.mpr fun i => ( hf i |> StronglyMeasurable.measurable ) );
    convert h_prod fun i => ?_;
    rotate_left;
    exact fun x i => ( f x ).ofLp i;
    · exact hf i;
    · constructor <;> intro h;
      · exact h_prod hf;
      · convert h.comp_measurable ( measurable_id' ) using 1;
        constructor <;> intro h <;> rcases h with ⟨ g, hg ⟩;
        · exact h;
        · refine' ⟨ fun n => SimpleFunc.map ( fun x => ( EuclideanSpace.equiv _ _ ).symm x ) ( g n ), _ ⟩;
          intro x;
          convert Filter.Tendsto.comp ( Continuous.tendsto ( show Continuous fun x : Fin n → 𝕜 => ( EuclideanSpace.equiv ( Fin n ) 𝕜 ).symm x from by continuity ) _ ) ( hg x ) using 1

/-
The a.e.-strongly-measurable form used for representatives in `L²`.
In particular, coordinate representatives must be transported explicitly.
-/
theorem aeStronglyMeasurable_euclidean_iff
    (f : X → EuclideanSpace 𝕜 (Fin n)) :
    AEStronglyMeasurable f μ ↔
      ∀ i, AEStronglyMeasurable (fun x ↦ (f x).ofLp i) μ := by
  refine' ⟨ fun h i => _, fun h => _ ⟩;
  · exact Continuous.aestronglyMeasurable ( continuous_apply i |> Continuous.comp <| continuous_induced_dom ) |> fun h' => h'.comp_aemeasurable h.aemeasurable;
  · choose g hg using h;
    refine' ⟨ fun x => ( EuclideanSpace.equiv _ _ ).symm ( fun i => g i x ), _, _ ⟩;
    · exact Continuous.stronglyMeasurable ( by continuity ) |> fun h => h.comp_measurable ( measurable_pi_iff.mpr fun i => hg i |>.1.measurable );
    · filter_upwards [ MeasureTheory.ae_all_iff.2 fun i => hg i |>.2 ] with x hx using by ext i; simpa using hx i;

/-
Pythagorean assembly of the `L²` seminorm from coordinate representatives.
-/
theorem L2Norm_sq_eq_sum_component
    (f : X → EuclideanSpace 𝕜 (Fin n)) (hf : MemLp f 2 μ) :
    L2Norm μ f ^ 2 = ∑ i, componentL2Norm μ (fun x ↦ (f x).ofLp i) ^ 2 := by
  have := hf;
  -- Expand the L² norm using the definition.
  have h_expand : L2Norm μ f ^ 2 = ∫ x, ‖f x‖ ^ 2 ∂μ := by
    unfold L2Norm;
    simp +decide [lpNorm];
    rw [ if_pos this.1, eLpNorm_eq_lintegral_rpow_enorm_toReal ] <;> norm_num;
    rw [ ← ENNReal.toReal_rpow ];
    rw [ ← Real.sqrt_eq_rpow, Real.sq_sqrt ( ENNReal.toReal_nonneg ), MeasureTheory.integral_eq_lintegral_of_nonneg_ae ];
    · simp +decide;
    · exact Filter.Eventually.of_forall fun x => sq_nonneg _;
    · exact this.1.norm.aemeasurable.pow_const 2 |> fun h => h.aestronglyMeasurable;
  -- By definition of componentL2Norm, we have that for each i, componentL2Norm μ (fun x => (f x).ofLp i) = (∫ x, ‖(f x).ofLp i‖ ^ 2 ∂μ) ^ (1 / 2 : ℝ).
  have h_componentL2Norm : ∀ i, componentL2Norm μ (fun x => (f x).ofLp i) = (∫ x, ‖(f x).ofLp i‖ ^ 2 ∂μ) ^ (1 / 2 : ℝ) := by
    intro i;
    convert lpNorm_eq_integral_norm_rpow_toReal _ _ _ using 1;
    · norm_num;
    · norm_num;
    · decide +kernel;
    · have := this.aestronglyMeasurable;
      fun_prop;
  simp_all +decide [EuclideanSpace.norm_eq];
  rw [ MeasureTheory.integral_congr_ae ( Filter.Eventually.of_forall fun x => Real.sq_sqrt <| Finset.sum_nonneg fun _ _ => sq_nonneg _ ), MeasureTheory.integral_finset_sum ];
  · exact Finset.sum_congr rfl fun _ _ => by rw [ ← Real.rpow_natCast, ← Real.rpow_mul ( MeasureTheory.integral_nonneg fun _ => sq_nonneg _ ) ] ; norm_num;
  · intro i _;
    refine' MeasureTheory.MemLp.integrable_sq _;
    refine' MemLp.norm _;
    exact MemLp.eval_piLp this i

/-
Component bounds assemble with the Pythagorean constant, not with a factor `n`.
-/
theorem L2Norm_le_sqrt_sum_sq
    (f : X → EuclideanSpace 𝕜 (Fin n)) (hf : MemLp f 2 μ)
    (B : Fin n → ℝ)
    (hcomp : ∀ i, componentL2Norm μ (fun x ↦ (f x).ofLp i) ≤ B i) :
    L2Norm μ f ≤ Real.sqrt (∑ i, B i ^ 2) := by
  contrapose! hcomp;
  -- By the properties of the L2 norm and the definition of `componentL2Norm`, we have:
  have h_sum_sq : ∑ i, (componentL2Norm μ (fun x => (f x).ofLp i))^2 ≥ (L2Norm μ f)^2 := by
    convert L2Norm_sq_eq_sum_component μ f hf |> le_of_eq using 1;
  contrapose! hcomp;
  exact Real.le_sqrt_of_sq_le ( h_sum_sq.trans ( Finset.sum_le_sum fun i _ => pow_le_pow_left₀ (by
      unfold componentL2Norm
      exact lpNorm_nonneg) (hcomp i) 2 ) )

/-
Measurability transport through pointwise matrix-vector multiplication.
Both the matrix representative and vector representative are explicit inputs.
-/
theorem aeStronglyMeasurable_matrix_mulVec
    (M : X → Matrix (Fin n) (Fin n) 𝕜)
    (f : X → EuclideanSpace 𝕜 (Fin n))
    (hM : AEStronglyMeasurable M μ)
    (hf : AEStronglyMeasurable f μ) :
    AEStronglyMeasurable
      (fun x ↦ WithLp.toLp 2 ((M x).mulVec (f x).ofLp)) μ := by
  obtain ⟨ g, hg, h ⟩ := hM;
  obtain ⟨ k, hk, h ⟩ := hf;
  refine' ⟨ fun x => WithLp.toLp 2 ( g x |> fun m => m.mulVec ( k x |> fun v => v.ofLp ) ), _, _ ⟩;
  · have h_cont : Continuous (fun p : Matrix (Fin n) (Fin n) 𝕜 × EuclideanSpace 𝕜 (Fin n) => WithLp.toLp 2 (p.1.mulVec p.2.ofLp)) := by
      fun_prop;
    exact h_cont.comp_stronglyMeasurable ( hg.prodMk hk );
  · filter_upwards [ ‹M =ᶠ[ae μ] g›, ‹f =ᶠ[ae μ] k› ] with x hx₁ hx₂ using by simp +decide [ hx₁, hx₂ ] ;

/-
Pointwise matrix multiplication is bounded once measurability of the output
representative has been transported. This minimal version states that hypothesis
explicitly; `matrix_multiplier_L2_of_measurable` below derives it from measurable
matrix and vector representatives.
-/
theorem matrix_multiplier_L2 [Nonempty (Fin n)]
    (M : X → Matrix (Fin n) (Fin n) 𝕜)
    (f : X → EuclideanSpace 𝕜 (Fin n)) (K : ℝ)
    (hf : MemLp f 2 μ)
    (hMf : AEStronglyMeasurable
      (fun x ↦ WithLp.toLp 2 ((M x).mulVec (f x).ofLp)) μ)
    (hK : 0 ≤ K)
    (hM : ∀ᵐ x ∂μ, ‖M x‖ ≤ K) :
    L2Norm μ (fun x ↦ WithLp.toLp 2 ((M x).mulVec (f x).ofLp)) ≤
      K * L2Norm μ f := by
  convert ENNReal.toReal_mono _ _;
  rotate_left;
  rotate_left;
  exact eLpNorm ( fun x => WithLp.toLp 2 ( ( M x ).mulVec ( f x ).ofLp ) ) 2 μ;
  exact ENNReal.ofReal K * eLpNorm f 2 μ;
  · exact ENNReal.mul_ne_top ENNReal.ofReal_ne_top ( hf.2.ne );
  · rw [ eLpNorm_eq_lintegral_rpow_enorm_toReal ];
    · -- Apply the inequality $‖M x * f x‖ ≤ K * ‖f x‖$ almost everywhere.
      have h_ineq : ∀ᵐ x ∂μ, ‖WithLp.toLp 2 ((M x).mulVec (f x).ofLp)‖ₑ ≤ ENNReal.ofReal K * ‖f x‖ₑ := by
        filter_upwards [ hM ] with x hx;
        rw [ ← ENNReal.toReal_le_toReal ] <;> norm_num;
        · convert Matrix.l2_opNorm_mulVec ( M x ) ( f x |> WithLp.toLp 2 ) |> le_trans <| mul_le_mul_of_nonneg_right hx <| norm_nonneg _ using 1;
          rw [ ENNReal.toReal_ofReal hK ];
        · exact ENNReal.mul_ne_top ENNReal.ofReal_ne_top ( by simp +decide );
      refine' le_trans ( ENNReal.rpow_le_rpow ( MeasureTheory.lintegral_mono_ae _ ) ( by norm_num ) ) _;
      use fun x => ENNReal.ofReal K ^ 2 * ‖f x‖ₑ ^ 2;
      · filter_upwards [ h_ineq ] with x hx using by simpa [ mul_pow ] using pow_le_pow_left₀ ( by positivity ) hx 2;
      · rw [ MeasureTheory.lintegral_const_mul' ] <;> norm_num;
        rw [ ENNReal.mul_rpow_of_nonneg ] <;> norm_num;
        rw [ ← ENNReal.rpow_natCast, ← ENNReal.rpow_mul ] ; norm_num;
        rw [ eLpNorm_eq_lintegral_rpow_enorm_toReal ] ; norm_num;
        · norm_num;
        · finiteness;
    · norm_num;
    · norm_num;
  · unfold L2Norm;
    simp +decide [ lpNorm ];
    exact fun h => False.elim <| h hMf;
  · rw [ ENNReal.toReal_mul, ENNReal.toReal_ofReal hK, L2Norm ];
    simp +decide [ lpNorm ];
    exact fun h => False.elim <| h <| hf.1


/-- Multiplier transport with all source measurability assumptions exposed. -/
theorem matrix_multiplier_L2_of_measurable [Nonempty (Fin n)]
    (M : X → Matrix (Fin n) (Fin n) 𝕜)
    (f : X → EuclideanSpace 𝕜 (Fin n)) (K : ℝ)
    (hM_meas : AEStronglyMeasurable M μ)
    (hf : MemLp f 2 μ)
    (hK : 0 ≤ K)
    (hM_bound : ∀ᵐ x ∂μ, ‖M x‖ ≤ K) :
    L2Norm μ (fun x ↦ WithLp.toLp 2 ((M x).mulVec (f x).ofLp)) ≤
      K * L2Norm μ f := by
  exact matrix_multiplier_L2 μ M f K hf
    (aeStronglyMeasurable_matrix_mulVec μ M f hM_meas hf.1) hK hM_bound

end ComponentwiseL2
