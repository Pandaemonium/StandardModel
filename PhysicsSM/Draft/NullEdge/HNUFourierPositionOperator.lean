import Mathlib.Analysis.InnerProductSpace.LinearPMap
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.Analysis.Distribution.SchwartzSpace.Fourier

/-!
# Fourier-conjugated maximal HNU position operator

This module supplies the exact unitary-conjugation layer needed to transport a
self-adjoint maximal momentum multiplier to position space.  It proves the
pulled-back domain, self-adjointness, closedness, graph identity, and exact
graph-norm identity.  It also records Mathlib's `2 * pi` Fourier derivative
normalization on Schwartz functions.

This is not a vector-valued Sobolev-domain identification.  The missing bridge
is an `L2` weak-derivative characterization by weighted Fourier transforms,
followed by a coercive comparison between the affine Dirac-symbol graph norm
and the weighted momentum norm.

Provenance: Aristotle project `505e0520-4ebb-4a2e-b924-8604403d61b4`, task
`0f781389-ce04-42b5-8041-c74bd354027e`.  The returned source was independently
rechecked in the repository toolchain before integration.
-/

noncomputable section

open Complex Real MeasureTheory
open scoped FourierTransform ComplexConjugate SchwartzMap LineDeriv

set_option autoImplicit false

namespace LinearPMap

variable {𝕜 E : Type*} [RCLike 𝕜] [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]

/-- `unitaryConjugate U A` is `U⁻¹ A U`, with the exact pulled-back maximal domain. -/
def unitaryConjugate (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E) : E →ₗ.[𝕜] E where
  domain := A.domain.comap U.toLinearEquiv.toLinearMap
  toFun := U.symm.toLinearEquiv.toLinearMap.comp (A.toFun.comp
    ({ toFun := fun x => ⟨U x, x.property⟩
       map_add' := fun x y => by ext; simp
       map_smul' := fun c x => by ext; exact U.map_smul c x } :
      (A.domain.comap U.toLinearEquiv.toLinearMap) →ₗ[𝕜] A.domain))

@[simp] theorem unitaryConjugate_domain (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E) :
    (unitaryConjugate U A).domain = A.domain.comap U.toLinearEquiv.toLinearMap := rfl

@[simp] theorem mem_unitaryConjugate_domain (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E)
    (x : E) : x ∈ (unitaryConjugate U A).domain ↔ U x ∈ A.domain := Iff.rfl

@[simp] theorem unitaryConjugate_apply (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E)
    (x : (unitaryConjugate U A).domain) :
    unitaryConjugate U A x = U.symm (A ⟨U x, x.property⟩) := by
  rfl

lemma dense_domain_unitaryConjugate (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E)
    (hA : Dense (A.domain : Set E)) : Dense ((unitaryConjugate U A).domain : Set E) := by
  apply_rules [Dense.preimage, hA]
  · convert U.toHomeomorph.isOpenMap
  · intro s hs
    simpa using hs

lemma unitaryConjugate_isFormalAdjoint_self (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E)
    (hA : A.IsFormalAdjoint A) :
    (unitaryConjugate U A).IsFormalAdjoint (unitaryConjugate U A) := by
  intro x y
  convert hA ⟨U x, x.2⟩ ⟨U y, y.2⟩ using 1
  · simp +decide [unitaryConjugate_apply]
    rw [← U.inner_map_map]
    rw [U.apply_symm_apply]
  · rw [← U.inner_map_map]
    aesop

lemma adjoint_domain_le_unitaryConjugate [CompleteSpace E]
    (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E) (hA : IsSelfAdjoint A) :
    (unitaryConjugate U A)†.domain ≤ (unitaryConjugate U A).domain := by
  intro x hx
  have hUx_Adomain : U x ∈ A†.domain := by
    rw [LinearPMap.mem_adjoint_domain_iff] at hx ⊢
    convert hx.comp (show Continuous
      (fun z : A.domain => ⟨U.symm z, by
        change U (U.symm z) ∈ A.domain
        simpa using z.property⟩ :
        A.domain → (unitaryConjugate U A).domain) from by fun_prop) using 1
    all_goals norm_num
    grind +suggestions
  change U x ∈ A.domain
  rw [← LinearPMap.isSelfAdjoint_def.mp hA]
  exact hUx_Adomain

/-- Unitary conjugation preserves self-adjointness of partially defined operators. -/
theorem isSelfAdjoint_unitaryConjugate [CompleteSpace E]
    (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E) (hA : IsSelfAdjoint A) :
    IsSelfAdjoint (unitaryConjugate U A) := by
  have hformalA : A.IsFormalAdjoint A := by
    have hh := (LinearPMap.adjoint_isFormalAdjoint hA.dense_domain).symm
    rw [LinearPMap.isSelfAdjoint_def.mp hA] at hh
    exact hh
  have hformal := unitaryConjugate_isFormalAdjoint_self U A hformalA
  have hdense := dense_domain_unitaryConjugate U A hA.dense_domain
  have h_spec : (unitaryConjugate U A) ≤ (unitaryConjugate U A)† :=
    LinearPMap.IsFormalAdjoint.le_adjoint hdense hformal
  have h_spec' : (unitaryConjugate U A)† ≤ (unitaryConjugate U A) := by
    refine ⟨adjoint_domain_le_unitaryConjugate U A hA, ?_⟩
    intro x y hxy
    have h := h_spec.2
    convert (h hxy.symm).symm
  grind +suggestions

/-- The conjugated graph is the exact pullback of the original graph. -/
theorem graph_unitaryConjugate (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E) :
    (unitaryConjugate U A).graph =
      A.graph.comap (U.toLinearEquiv.toLinearMap.prodMap U.toLinearEquiv.toLinearMap) := by
  refine le_antisymm ?_ ?_ <;> intro x hx <;>
    simp_all +decide [Submodule.mem_comap, LinearPMap.mem_graph_iff]
  · obtain ⟨hx₁, hx₂⟩ := hx
    use hx₁
    rw [← hx₂, U.apply_symm_apply]
  · aesop

/-- A unitary conjugate of a self-adjoint operator is closed. -/
theorem isClosed_unitaryConjugate [CompleteSpace E]
    (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E) (hA : IsSelfAdjoint A) :
    (unitaryConjugate U A).IsClosed :=
  (isSelfAdjoint_unitaryConjugate U A hA).isClosed

/-- Exact invariance of the two graph-norm terms. -/
theorem unitaryConjugate_graph_norm_terms (U : E ≃ₗᵢ[𝕜] E) (A : E →ₗ.[𝕜] E)
    (x : (unitaryConjugate U A).domain) :
    ‖(x : E)‖ ^ 2 + ‖unitaryConjugate U A x‖ ^ 2 =
      ‖U x‖ ^ 2 + ‖A ⟨U x, x.property⟩‖ ^ 2 := by
  simp +decide [unitaryConjugate_apply]

end LinearPMap

namespace PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator

variable {V F : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
  [FiniteDimensional ℝ V] [MeasurableSpace V] [BorelSpace V]
  [NormedAddCommGroup F] [InnerProductSpace ℂ F]

/-- Mathlib's Schwartz Fourier derivative identity, including the `2 * pi` convention. -/
theorem fourier_lineDeriv_eq_momentum (m : V) (f : 𝓢(V, F)) :
    𝓕 (∂_{m} f) =
      (2 * π * I) • SchwartzMap.smulLeftCLM F (fun x => inner ℝ x m) (𝓕 f) := by
  exact SchwartzMap.fourier_lineDerivOp_eq f m

variable [CompleteSpace F]

/-- The inverse Fourier momentum/derivative bridge. -/
theorem fourierInv_momentum_fourier_eq_lineDeriv (m : V) (f : 𝓢(V, F)) :
    𝓕⁻ (SchwartzMap.smulLeftCLM F (fun x => inner ℝ x m) (𝓕 f)) =
      (2 * π * I)⁻¹ • ∂_{m} f := by
  have h_fourier_inv :
      𝓕⁻ ((2 * Real.pi * I) •
        (SchwartzMap.smulLeftCLM F (fun x => inner ℝ x m)) (𝓕 f)) = ∂_{m} f := by
    rw [← fourier_lineDeriv_eq_momentum]
    exact FourierPair.fourierInv_fourier_eq (∂_{m} f)
  convert congr_arg ((2 * Real.pi * I)⁻¹ • ·) h_fourier_inv using 1
  simp [← mul_assoc, ← smul_assoc, Real.pi_ne_zero]

/-- One-dimensional sign and normalization control. -/
theorem scalar_fourier_deriv_control (f : 𝓢(ℝ, ℂ)) :
    𝓕 (SchwartzMap.derivCLM ℂ ℂ f) =
      (2 * π * I) • SchwartzMap.smulLeftCLM ℂ (fun x : ℝ => x) (𝓕 f) := by
  convert fourier_lineDeriv_eq_momentum 1 f using 1
  norm_num [inner]

section Position

variable (M : Lp F 2 (volume : Measure V) →ₗ.[ℂ] Lp F 2 (volume : Measure V))

/-- The position-space maximal operator is the inverse-Fourier unitary conjugate
of its maximal momentum multiplier. -/
def positionDirac : Lp F 2 (volume : Measure V) →ₗ.[ℂ] Lp F 2 (volume : Measure V) :=
  LinearPMap.unitaryConjugate (Lp.fourierTransformₗᵢ V F) M

@[simp] theorem positionDirac_domain :
    (positionDirac M).domain =
      M.domain.comap (Lp.fourierTransformₗᵢ V F).toLinearEquiv.toLinearMap := rfl

theorem mem_positionDirac_domain (u : Lp F 2 (volume : Measure V)) :
    u ∈ (positionDirac M).domain ↔ 𝓕 u ∈ M.domain := Iff.rfl

theorem positionDirac_isSelfAdjoint (hM : IsSelfAdjoint M) :
    IsSelfAdjoint (positionDirac M) :=
  LinearPMap.isSelfAdjoint_unitaryConjugate _ _ hM

theorem positionDirac_isClosed (hM : IsSelfAdjoint M) :
    (positionDirac M).IsClosed := (positionDirac_isSelfAdjoint M hM).isClosed

theorem positionDirac_graph :
    (positionDirac M).graph = M.graph.comap
      ((Lp.fourierTransformₗᵢ V F).toLinearEquiv.toLinearMap.prodMap
       (Lp.fourierTransformₗᵢ V F).toLinearEquiv.toLinearMap) :=
  LinearPMap.graph_unitaryConjugate _ _

theorem positionDirac_graph_norm_exact (u : (positionDirac M).domain) :
    ‖(u : Lp F 2 (volume : Measure V))‖ ^ 2 + ‖positionDirac M u‖ ^ 2 =
      ‖𝓕 (u : Lp F 2 (volume : Measure V))‖ ^ 2 +
        ‖M ⟨𝓕 (u : Lp F 2 (volume : Measure V)), u.property⟩‖ ^ 2 :=
  LinearPMap.unitaryConjugate_graph_norm_terms _ _ u

end Position

end PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator
