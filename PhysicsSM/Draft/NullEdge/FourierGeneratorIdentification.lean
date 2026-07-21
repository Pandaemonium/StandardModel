import Mathlib

/-!
# MC6 Fourier generator identification (Opus, verified Aristotle 716c6d8e)

Last rung of the ladder audited in
`AutonomousLab/work/NE-3PLUS1/OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md`.

NORMALIZATION FINDING (reported, not forced): Mathlib's convention is
`exp (-2 pi I <x,q>)`, giving `F (d_j f) = (2 pi I) . (q_j . F f)`. Consequently the
actual differential coefficient in the generator identification is `-I / (2 pi)`,
**NOT** `-I` as the MC6 rung was written. Any MC6 statement using `-i sum_j alpha_j
partial_j` is off by a factor `2 pi` unless the convention is carried explicitly.
The constant-matrix (mass) term commutes with the Fourier transform and transfers
unchanged - only the differential term picks up the convention factor.

ANTI-OVERCLAIM (recorded at the prover's own statement): this is an IDENTIFICATION
OF GENERATORS on the Schwartz dense domain. It is NOT a convergence theorem and NOT
a statement about any discrete walk.

Namespace kept as the prover's FourierGeneratorIdentification. Provenance: verified
at pin from task 6c4d91f5. Standard three. Claim grade M, [comp]. -/

open scoped BigOperators FourierTransform ComplexConjugate
open Real Complex

noncomputable section

namespace FourierGeneratorIdentification

abbrev V (d : ℕ) := EuclideanSpace ℝ (Fin d)

variable {d : ℕ}
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℂ E]

/-- Pointwise action of a constant continuous complex-linear operator on the values of a
Schwartz function. The operator acts on the target `E`, not on the variable in `V d`. -/
def constantTargetAction (A : E →L[ℂ] E) : SchwartzMap (V d) E →L[ℂ] SchwartzMap (V d) E :=
  SchwartzMap.bilinLeftCLM
    (ContinuousLinearMap.apply ℂ E)
    (g := fun _ : V d ↦ A) (by fun_prop)

@[simp]
theorem constantTargetAction_apply (A : E →L[ℂ] E) (f : SchwartzMap (V d) E) (x : V d) :
    constantTargetAction A f x = A (f x) := by
  congr! 1

/-- The `j`-th coordinate multiplier on Schwartz functions. -/
def coordinateMultiplier (j : Fin d) : SchwartzMap (V d) E →L[ℂ] SchwartzMap (V d) E :=
  SchwartzMap.smulLeftCLM E
    (fun q : V d ↦ (inner ℝ q (EuclideanSpace.single j (1 : ℝ)) : ℂ))

@[simp]
theorem coordinateMultiplier_apply (j : Fin d) (f : SchwartzMap (V d) E) (q : V d) :
    coordinateMultiplier j f q = (q j : ℂ) • f q := by
  unfold coordinateMultiplier
  erw [SchwartzMap.smulLeftCLM_apply]
  · simp [inner]
  · fun_prop

/-- Partial differentiation in coordinate `j`, represented as a line derivative. -/
def partialDerivative (j : Fin d) : SchwartzMap (V d) E →L[ℂ] SchwartzMap (V d) E :=
  LineDeriv.lineDerivOpCLM ℂ (SchwartzMap (V d) E)
    (EuclideanSpace.single j (1 : ℝ))

/-- **Mathlib Fourier convention, explicitly:**
`𝓕(∂ⱼ f)(q) = (2 * π * I) • (qⱼ • 𝓕 f(q))`.
Thus the coordinate multiplier corresponds to `(2πI)⁻¹ ∂ⱼ = -(I/(2π)) ∂ⱼ`,
not to the unnormalised operator `-I ∂ⱼ`.
-/
theorem fourier_partialDerivative_eq (j : Fin d) (f : SchwartzMap (V d) E) :
    𝓕 (partialDerivative j f) =
      (2 * (Real.pi : ℂ) * I) • coordinateMultiplier j (𝓕 f) := by
  convert SchwartzMap.fourier_lineDerivOp_eq f ( EuclideanSpace.single j 1 ) using 1;
  ext; simp +decide [ coordinateMultiplier_apply ];
  erw [ SchwartzMap.smulLeftCLM_apply ];
  · simp +decide [ inner ];
  · fun_prop

/-- A constant matrix (more generally, a continuous complex-linear target operator) commutes
with Fourier transform. This is the componentwise extension of the scalar fact. -/
theorem fourier_constantTargetAction_eq [CompleteSpace E] (A : E →L[ℂ] E) (f : SchwartzMap (V d) E) :
    𝓕 (constantTargetAction A f) = constantTargetAction A (𝓕 f) := by
  unfold constantTargetAction; ext; simp
  convert (A.integral_comp_comm _) using 1
  · convert (MeasureTheory.integral_congr_ae _) using 3
    filter_upwards [] with x using by simp
  · refine' MeasureTheory.Integrable.smul_of_top_right _ _;
    · exact f.integrable;
    · refine' MeasureTheory.memLp_top_of_bound _ _ _;
      rotate_left;
      exact 1;
      · simp
      · simp [Real.fourierChar]
        refine' Measurable.aestronglyMeasurable _;
        fun_prop

/-- The momentum-space multiplier `q ↦ ∑ j, α j * q j + M`, acting on values. -/
def momentumGenerator (alpha : Fin d → E →L[ℂ] E) (M : E →L[ℂ] E) (f : SchwartzMap (V d) E) :
    SchwartzMap (V d) E :=
  ∑ j, constantTargetAction (alpha j) (coordinateMultiplier j f) +
    constantTargetAction M f

/-- The corresponding position-space differential generator. The coefficient forced by
Mathlib's Fourier convention is `-(I / (2 * π))`, rather than `-I`. -/
def differentialGenerator (alpha : Fin d → E →L[ℂ] E) (M : E →L[ℂ] E)
    (f : SchwartzMap (V d) E) : SchwartzMap (V d) E :=
  ∑ j, (-(I / (2 * (Real.pi : ℂ)))) •
      constantTargetAction (alpha j) (partialDerivative j f) +
    constantTargetAction M f

/-- **Generator identification only (anti-overclaim).** On the Schwartz dense domain,
the Fourier transform identifies the differential generator with its momentum multiplier.
This is **not** a convergence theorem and makes **no** statement about any discrete walk.
In Mathlib's `exp (-2π I ⟪x,q⟫)` convention, the differential coefficient is
`-I / (2π)`, not `-I`.
-/
theorem fourier_differentialGenerator_eq_momentumGenerator
    [CompleteSpace E] (alpha : Fin d → E →L[ℂ] E) (M : E →L[ℂ] E)
    (f : SchwartzMap (V d) E) :
    𝓕 (differentialGenerator alpha M f) = momentumGenerator alpha M (𝓕 f) := by
  simp [momentumGenerator, differentialGenerator, fourier_partialDerivative_eq,
    fourier_constantTargetAction_eq]
  rw [← Finset.sum_neg_distrib]
  congr
  ext
  ring_nf
  norm_num [Real.pi_ne_zero]
  simp [← smul_assoc, mul_assoc, mul_comm, mul_left_comm, Real.pi_ne_zero]

end FourierGeneratorIdentification
