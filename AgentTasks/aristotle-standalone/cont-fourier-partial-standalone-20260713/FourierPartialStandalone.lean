import Mathlib

/-!
# Coordinate derivatives under Mathlib's forward Fourier transform

This focused file isolates the convention-critical Fourier lemma needed by the
null-edge continuum ladder. Mathlib's forward transform uses the kernel
`exp (-2 * pi * I * <x,w>)`; consequently a coordinate derivative has the
positive multiplier `2 * pi * I * w_j`.

The target is intentionally independent of the PhysicsSM import graph. The
statement, scalar field, sign, and `2 * pi` normalization are immutable.
-/

noncomputable section

open MeasureTheory Complex Real
open FourierTransform
open scoped RealInnerProductSpace

namespace FourierPartialStandalone

abbrev FourierMomentum3 := EuclideanSpace Real (Fin 3)
abbrev Spinor := EuclideanSpace Complex (Fin 4)

/-- Under Mathlib's forward-transform convention, differentiating in the
`j`-th coordinate multiplies the transform by `2 * pi * I * w_j`. -/
theorem fourier_partial_correspondence
    (g : SchwartzMap FourierMomentum3 Spinor) (j : Fin 3) :
    (𝓕 fun x =>
      fderiv Real (fun y => g y) x
        (EuclideanSpace.single j (1 : Real)))
      = fun w =>
          (2 * (Real.pi : Complex) * Complex.I * (w j : Complex)) •
            𝓕 (fun x => g x) w := by
  have hInt : Integrable (fderiv ℝ (⇑g)) := by
    have h :=
      (SchwartzMap.fderivCLM ℝ FourierMomentum3 Spinor g).integrable
        (μ := volume)
    simpa [SchwartzMap.fderivCLM_apply] using h
  funext w
  rw [(Real.fourier_continuousLinearMap_apply (f := fderiv ℝ ⇑g)
        (a := EuclideanSpace.single j (1 : ℝ)) (v := w) hInt).symm]
  rw [Real.fourier_fderiv g.integrable g.differentiable hInt,
    VectorFourier.fourierSMulRight_apply]
  simp only [ContinuousLinearMap.neg_apply, EuclideanSpace.inner_single_right,
    innerSL_apply_apply, RCLike.conj_to_real, one_mul, ← Complex.coe_smul,
    smul_smul]
  push_cast
  ring_nf

/-- Boundary control: the correspondence specializes coherently to the zero
Schwartz map. -/
theorem fourier_partial_correspondence_zero (j : Fin 3) :
    (𝓕 fun x =>
      fderiv Real
        (fun y => (0 : SchwartzMap FourierMomentum3 Spinor) y) x
        (EuclideanSpace.single j (1 : Real)))
      = fun w =>
          (2 * (Real.pi : Complex) * Complex.I * (w j : Complex)) •
            𝓕 (fun x => (0 : SchwartzMap FourierMomentum3 Spinor) x) w :=
  fourier_partial_correspondence 0 j

end FourierPartialStandalone
