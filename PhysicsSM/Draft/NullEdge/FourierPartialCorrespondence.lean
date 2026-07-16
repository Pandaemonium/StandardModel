import PhysicsSM.Draft.NullEdge.ChangingCellFourierL2

/-!
# Fourier transform of a coordinate derivative

This module pins the convention-critical Schwartz derivative theorem used by
the null-edge continuum ladder. Mathlib's forward Fourier transform uses the
kernel `exp (-2 * pi * I * <x,w>)`. Under this convention, transforming the
`j`-th coordinate derivative multiplies by the positive symbol
`2 * pi * I * w_j`.

The theorem is a Schwartz-space Fourier identity. It does not by itself prove
that the live walk converges to a position-space PDE; that conclusion still
requires composition with the multiplier limit on a displayed function domain.

The proof was returned by Aristotle project
`7be67a65-d965-4ad4-8609-2bb723dc415a` in a Mathlib-only package, then adapted
definitionally to the repository's `FourierMomentum3` and `Spinor` aliases and
replayed under Lean 4.28.
-/

noncomputable section

open MeasureTheory Complex Real
open FourierTransform
open scoped RealInnerProductSpace

namespace PhysicsSM.Draft.NullEdge.FourierPartialCorrespondence

open ChangingCellFourierL2 ChangingCellScaledLiveWalk

/-- Under Mathlib's forward-transform convention, differentiating in the
`j`-th coordinate multiplies the transform by `2 * pi * I * w_j`. -/
theorem fourier_partial_correspondence
    (g : SchwartzMap FourierMomentum3 Spinor) (j : Fin 3) :
    (𝓕 fun x =>
      fderiv Real (fun y => g y) x
        (EuclideanSpace.single j (1 : Real))) =
      fun w =>
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
        (EuclideanSpace.single j (1 : Real))) =
      fun w =>
        (2 * (Real.pi : Complex) * Complex.I * (w j : Complex)) •
          𝓕 (fun x => (0 : SchwartzMap FourierMomentum3 Spinor) x) w :=
  fourier_partial_correspondence 0 j

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FourierPartialCorrespondence.fourier_partial_correspondence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_partial_correspondence

/-- info: 'PhysicsSM.Draft.NullEdge.FourierPartialCorrespondence.fourier_partial_correspondence_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_partial_correspondence_zero

end PhysicsSM.Draft.NullEdge.FourierPartialCorrespondence
