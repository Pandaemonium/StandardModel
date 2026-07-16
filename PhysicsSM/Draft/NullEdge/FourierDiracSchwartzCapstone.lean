import PhysicsSM.Draft.NullEdge.FourierPartialCorrespondence
import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate

/-!
# Aristotle target: exact Schwartz-domain Fourier/Dirac composition

Prove the exact position-to-momentum correspondence for the free `3+1` Dirac
generator on a displayed Schwartz domain. Mathlib's forward Fourier transform
uses `exp (-2 * pi * I * <x,w>)`; consequently the position differential
operator carries the explicit normalization `-I / (2*pi)`.

This target is a generator-symbol theorem on Schwartz functions. It is not a
claim about the domain of the closed `L2` generator, changing-lattice
convergence, or a completed PDE reconstruction.

Provenance: the immutable definitions and theorem statements were prepared
in-project. Aristotle project `c8b815ee-f0fa-44ca-af6d-2ad3cf4bae86`
returned the proofs on 2026-07-13; the exact file was replayed locally under
Lean 4.28 before this draft integration. Cross-family semantic review remains
required before manuscript promotion.
-/

noncomputable section

open MeasureTheory Complex Real Matrix
open FourierTransform
open scoped RealInnerProductSpace

namespace PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone

open ChangingCellFourierL2 ChangingCellScaledLiveWalk
open Compact3Plus1DiracRate FourierPartialCorrespondence

/-- The bounded spinor action of a fixed `4 x 4` complex matrix. -/
def matrixAction (A : Mat4) : Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (𝕜 := Complex) A

/-- Coordinate derivative of a Schwartz spinor. -/
def coordinateDerivative (g : SchwartzMap FourierMomentum3 Spinor) (j : Fin 3)
    (x : FourierMomentum3) : Spinor :=
  fderiv Real (fun y => g y) x (EuclideanSpace.single j (1 : Real))

/-- Position-space free Dirac differential expression in Mathlib's Fourier
normalization. -/
def positionDirac (m : Real) (g : SchwartzMap FourierMomentum3 Spinor)
    (x : FourierMomentum3) : Spinor :=
  ((-Complex.I / (2 * (Real.pi : Complex))) •
      (matrixAction alpha1 (coordinateDerivative g 0 x) +
        matrixAction alpha2 (coordinateDerivative g 1 x) +
        matrixAction alpha3 (coordinateDerivative g 2 x))) +
    (m : Complex) • matrixAction beta (g x)

/-- Fourier transform commutes with a fixed bounded matrix action. -/
theorem fourier_matrixAction
    (A : Mat4) (f : FourierMomentum3 -> Spinor) (hf : Integrable f) :
    𝓕 (fun x => matrixAction A (f x)) =
      fun w => matrixAction A (𝓕 f w) := by
  funext w
  simp only [Real.fourier_eq]
  rw [← ContinuousLinearMap.integral_comp_comm]
  · congr 1
    funext v
    rw [ContinuousLinearMap.map_smul_of_tower]
  · -- the Fourier integrand is integrable because `𝐞` has norm one
    have hbdd : (fun v => (𝐞 (-⟪v, w⟫) : Circle) • f v)
        = (fun v => ((𝐞 (-⟪v, w⟫) : Circle) : ℂ)) • f := by
      funext v; simp [Circle.smul_def]
    rw [hbdd]
    apply hf.smul_of_top_right
    apply MeasureTheory.memLp_top_of_bound (C := 1)
      (Continuous.aestronglyMeasurable (by fun_prop))
    filter_upwards with v
    simp

/-- The displayed Dirac differential expression is integrable on every
Schwartz spinor. -/
theorem positionDirac_integrable
    (m : Real) (g : SchwartzMap FourierMomentum3 Spinor) :
    Integrable (positionDirac m g) := by
  have hInt : Integrable (fderiv ℝ (⇑g)) := by
    have h := (SchwartzMap.fderivCLM ℝ FourierMomentum3 Spinor g).integrable (μ := volume)
    simpa [SchwartzMap.fderivCLM_apply] using h
  have hcoord : ∀ j : Fin 3, Integrable (coordinateDerivative g j) := fun j =>
    hInt.apply_continuousLinearMap (EuclideanSpace.single j (1 : ℝ))
  have hg : Integrable (fun x => g x) := g.integrable
  have hsum : Integrable (fun x =>
      matrixAction alpha1 (coordinateDerivative g 0 x) +
        matrixAction alpha2 (coordinateDerivative g 1 x) +
        matrixAction alpha3 (coordinateDerivative g 2 x)) :=
    (((matrixAction alpha1).integrable_comp (hcoord 0)).add
      ((matrixAction alpha2).integrable_comp (hcoord 1))).add
      ((matrixAction alpha3).integrable_comp (hcoord 2))
  unfold positionDirac
  exact (hsum.smul (-Complex.I / (2 * (Real.pi : Complex)))).add
    (((matrixAction beta).integrable_comp hg).smul (m : Complex))

/-- **Schwartz F2 capstone.** The normalized position-space Dirac differential
expression transforms exactly to the repository's free momentum symbol `H`.
All three derivative coordinates and the mass term are composed in one theorem. -/
theorem fourier_positionDirac
    (m : Real) (g : SchwartzMap FourierMomentum3 Spinor) :
    𝓕 (positionDirac m g) =
      fun w => matrixAction (H (w 0) (w 1) (w 2) m)
        (𝓕 (fun x => g x) w) := by
  -- integrability inputs
  have hInt : Integrable (fderiv ℝ (⇑g)) := by
    have h := (SchwartzMap.fderivCLM ℝ FourierMomentum3 Spinor g).integrable (μ := volume)
    simpa [SchwartzMap.fderivCLM_apply] using h
  have hcoord : ∀ j : Fin 3, Integrable (coordinateDerivative g j) := fun j =>
    hInt.apply_continuousLinearMap (EuclideanSpace.single j (1 : ℝ))
  have hg : Integrable (fun x => g x) := g.integrable
  have hTint : ∀ (A : Mat4) (j : Fin 3),
      Integrable (fun x => matrixAction A (coordinateDerivative g j x)) :=
    fun A j => (matrixAction A).integrable_comp (hcoord j)
  -- Fourier-integrand integrability (`𝐞` has norm one)
  have hIntegrand : ∀ (f : FourierMomentum3 → Spinor), Integrable f →
      ∀ w : FourierMomentum3, Integrable (fun v => (𝐞 (-⟪v, w⟫) : Circle) • f v) := by
    intro f hf w
    have hbdd : (fun v => (𝐞 (-⟪v, w⟫) : Circle) • f v)
        = (fun v => ((𝐞 (-⟪v, w⟫) : Circle) : ℂ)) • f := by
      funext v; simp [Circle.smul_def]
    rw [hbdd]
    apply hf.smul_of_top_right
    apply MeasureTheory.memLp_top_of_bound (C := 1)
      (Continuous.aestronglyMeasurable (by fun_prop))
    filter_upwards with v
    simp
  -- additivity and scalar homogeneity of the Fourier transform
  have hFadd : ∀ (f₁ f₂ : FourierMomentum3 → Spinor), Integrable f₁ → Integrable f₂ →
      𝓕 (fun x => f₁ x + f₂ x) = fun w => 𝓕 f₁ w + 𝓕 f₂ w := by
    intro f₁ f₂ hf₁ hf₂
    funext w
    simp only [Real.fourier_eq]
    rw [← integral_add (hIntegrand f₁ hf₁ w) (hIntegrand f₂ hf₂ w)]
    congr 1; funext v; rw [smul_add]
  have hFsmul : ∀ (c : ℂ) (f : FourierMomentum3 → Spinor),
      𝓕 (fun x => c • f x) = fun w => c • 𝓕 f w := by
    intro c f
    funext w
    simp only [Real.fourier_eq]
    rw [← integral_smul]
    congr 1; funext v; rw [smul_comm]
  -- Fourier transform of a single matrix-weighted coordinate derivative
  have hterm : ∀ (A : Mat4) (j : Fin 3),
      𝓕 (fun x => matrixAction A (coordinateDerivative g j x))
        = fun w => matrixAction A
            ((2 * (Real.pi : Complex) * Complex.I * (w j : Complex)) • 𝓕 (fun x => g x) w) := by
    intro A j
    rw [fourier_matrixAction A (coordinateDerivative g j) (hcoord j)]
    unfold coordinateDerivative
    rw [fourier_partial_correspondence g j]
  -- split `positionDirac` into its two summands
  set c : ℂ := (-Complex.I / (2 * (Real.pi : Complex))) with hc
  set F1 : FourierMomentum3 → Spinor := fun x =>
      matrixAction alpha1 (coordinateDerivative g 0 x) +
        matrixAction alpha2 (coordinateDerivative g 1 x) +
        matrixAction alpha3 (coordinateDerivative g 2 x) with hF1
  set F2 : FourierMomentum3 → Spinor := fun x => matrixAction beta (g x) with hF2
  have hF1int : Integrable F1 :=
    (((hTint alpha1 0)).add (hTint alpha2 1)).add (hTint alpha3 2)
  have hF2int : Integrable F2 := (matrixAction beta).integrable_comp hg
  have hpd : positionDirac m g = fun x => c • F1 x + (m : ℂ) • F2 x := rfl
  rw [hpd]
  rw [hFadd (fun x => c • F1 x) (fun x => (m : ℂ) • F2 x)
        (hF1int.smul c) (hF2int.smul (m : ℂ))]
  rw [hFsmul c F1, hFsmul (m : ℂ) F2]
  -- Fourier transform of the spatial block
  have hFF1 : 𝓕 F1 = fun w =>
      matrixAction alpha1 ((2 * (Real.pi : ℂ) * Complex.I * (w 0 : ℂ)) • 𝓕 (fun x => g x) w)
      + matrixAction alpha2 ((2 * (Real.pi : ℂ) * Complex.I * (w 1 : ℂ)) • 𝓕 (fun x => g x) w)
      + matrixAction alpha3 ((2 * (Real.pi : ℂ) * Complex.I * (w 2 : ℂ)) • 𝓕 (fun x => g x) w) := by
    have hassoc : F1 = fun x =>
        (matrixAction alpha1 (coordinateDerivative g 0 x)
          + matrixAction alpha2 (coordinateDerivative g 1 x))
        + matrixAction alpha3 (coordinateDerivative g 2 x) := rfl
    rw [hassoc]
    rw [hFadd
          (fun x => matrixAction alpha1 (coordinateDerivative g 0 x)
            + matrixAction alpha2 (coordinateDerivative g 1 x))
          (fun x => matrixAction alpha3 (coordinateDerivative g 2 x))
          ((hTint alpha1 0).add (hTint alpha2 1)) (hTint alpha3 2)]
    rw [hFadd
          (fun x => matrixAction alpha1 (coordinateDerivative g 0 x))
          (fun x => matrixAction alpha2 (coordinateDerivative g 1 x))
          (hTint alpha1 0) (hTint alpha2 1)]
    rw [hterm alpha1 0, hterm alpha2 1, hterm alpha3 2]
  have hFF2 : 𝓕 F2 = fun w => matrixAction beta (𝓕 (fun x => g x) w) := by
    rw [hF2]
    exact fourier_matrixAction beta (fun x => g x) hg
  rw [hFF1, hFF2]
  funext w
  set v : Spinor := 𝓕 (fun x => g x) w with hv
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hscal : ∀ z : ℂ, c * (2 * (Real.pi : ℂ) * Complex.I * z) = z := by
    intro z; rw [hc]; field_simp; ring_nf; rw [Complex.I_sq]; ring
  simp only [map_smul, smul_add, smul_smul, hscal]
  show (w 0 : ℂ) • matrixAction alpha1 v + (w 1 : ℂ) • matrixAction alpha2 v
      + (w 2 : ℂ) • matrixAction alpha3 v + (m : ℂ) • matrixAction beta v
    = matrixAction (H (w 0) (w 1) (w 2) m) v
  unfold H matrixAction
  simp only [map_add, map_smul, ContinuousLinearMap.add_apply,
    ContinuousLinearMap.smul_apply]

/-- Zero-spinor boundary control. -/
theorem fourier_positionDirac_zero (m : Real) :
    𝓕 (positionDirac m (0 : SchwartzMap FourierMomentum3 Spinor)) =
      fun w => matrixAction (H (w 0) (w 1) (w 2) m)
        (𝓕 (fun x => (0 : SchwartzMap FourierMomentum3 Spinor) x) w) := by
  simpa using fourier_positionDirac m (0 : SchwartzMap FourierMomentum3 Spinor)

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone.fourier_matrixAction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_matrixAction

/-- info: 'PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone.positionDirac_integrable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionDirac_integrable

/-- info: 'PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone.fourier_positionDirac' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_positionDirac

/-- info: 'PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone.fourier_positionDirac_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_positionDirac_zero

end PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone
