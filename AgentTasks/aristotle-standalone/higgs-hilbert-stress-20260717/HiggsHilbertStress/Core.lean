import Mathlib

/-!
# Finite complex Higgs Hilbert-stress algebra

This focused package isolates the finite algebra connecting a complex unitary
multiplet to a symmetric inverse-metric response. The complex-multiplet
kinetic convention is `L = gInv^{ab} Re((D_a H)^dagger D_b H) - V`; hence its
Hilbert coefficient is `T_ab = 2 B_ab - g_ab L`. The factor two is the complex
field normalization, equivalent to the usual one-half normalization on each
real component.

The covariant and inverse metric matrices, measure, measure response, and
derivative components are supplied. No graph reconstruction, continuum limit,
field equation, conservation law, or Einstein equation is claimed.
-/

noncomputable section

namespace HiggsHilbertStress

open scoped BigOperators ComplexConjugate

variable {N I : Type*} [Fintype N] [DecidableEq N] [Fintype I]

/-- Real part of the finite Hermitian pairing on internal multiplet vectors. -/
def realHermitianBilinear (left right : N -> Complex) : Real :=
  ∑ n, (star (left n) * right n).re

/-- Symmetric real derivative bilinear in supplied frame components. -/
def derivativeBilinear
    (derivative : I -> N -> Complex) (a b : I) : Real :=
  realHermitianBilinear (derivative a) (derivative b)

/-- Apply one internal unitary transformation to every derivative component. -/
def unitaryTransformDerivative
    (g : Matrix.unitaryGroup N Complex)
    (derivative : I -> N -> Complex) : I -> N -> Complex :=
  fun a => Matrix.mulVec (g : Matrix N N Complex) (derivative a)

/-- Kinetic contraction against a supplied inverse-metric component matrix. -/
def metricKinetic
    (gInv : Matrix I I Real) (derivative : I -> N -> Complex) : Real :=
  ∑ a, ∑ b, gInv a b * derivativeBilinear derivative a b

/-- Complex-multiplet Lagrangian in the supplied inverse metric. -/
def metricLagrangian
    (gInv : Matrix I I Real) (derivative : I -> N -> Complex)
    (potentialDensity : Real) : Real :=
  metricKinetic gInv derivative - potentialDensity

/-- Local measure-weighted complex-multiplet action. -/
def localMetricAction
    (measure : Real) (gInv : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real) : Real :=
  measure * metricLagrangian gInv derivative potentialDensity

/-- First response to independent supplied measure and inverse-metric
variations, holding derivative components and potential density fixed. -/
def inverseMetricMeasureResponse
    (measure measureResponse : Real)
    (gInv variation : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real) : Real :=
  measureResponse * metricLagrangian gInv derivative potentialDensity +
    measure * metricKinetic variation derivative

/-- Covariant Hilbert-stress coefficient for the complex-multiplet kinetic
normalization used in this module. -/
def hilbertStress
    (gCov gInv : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real) :
    Matrix I I Real :=
  fun a b =>
    2 * derivativeBilinear derivative a b -
      gCov a b * metricLagrangian gInv derivative potentialDensity

/-- The real Hermitian bilinear is symmetric. -/
theorem realHermitianBilinear_symm (left right : N -> Complex) :
    realHermitianBilinear left right = realHermitianBilinear right left := by
  sorry

/-- Internal unitary transformations preserve the full real Hermitian
bilinear, not only its diagonal norm-square values. -/
theorem realHermitianBilinear_unitary
    (g : Matrix.unitaryGroup N Complex) (left right : N -> Complex) :
    realHermitianBilinear
        (Matrix.mulVec (g : Matrix N N Complex) left)
        (Matrix.mulVec (g : Matrix N N Complex) right) =
      realHermitianBilinear left right := by
  sorry

/-- The kinetic contraction is affine-linear in the inverse metric. -/
theorem metricKinetic_affine
    (gInv variation : Matrix I I Real)
    (derivative : I -> N -> Complex) (epsilon : Real) :
    metricKinetic (gInv + epsilon • variation) derivative =
      metricKinetic gInv derivative +
        epsilon * metricKinetic variation derivative := by
  sorry

/-- Simultaneous affine measure and inverse-metric perturbations have this
exact quadratic expansion. -/
theorem localMetricAction_affine_expansion
    (measure measureResponse : Real)
    (gInv variation : Matrix I I Real)
    (derivative : I -> N -> Complex)
    (potentialDensity epsilon : Real) :
    localMetricAction (measure + epsilon * measureResponse)
        (gInv + epsilon • variation) derivative potentialDensity =
      localMetricAction measure gInv derivative potentialDensity +
        epsilon * inverseMetricMeasureResponse
          measure measureResponse gInv variation derivative potentialDensity +
        epsilon ^ 2 *
          (measureResponse * metricKinetic variation derivative) := by
  sorry

/-- The displayed first response is the actual derivative at the base of the
simultaneous affine path. -/
theorem hasDerivAt_localMetricAction_affine
    (measure measureResponse : Real)
    (gInv variation : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real) :
    HasDerivAt
      (fun epsilon => localMetricAction (measure + epsilon * measureResponse)
        (gInv + epsilon • variation) derivative potentialDensity)
      (inverseMetricMeasureResponse
        measure measureResponse gInv variation derivative potentialDensity)
      0 := by
  sorry

/-- A symmetric supplied covariant metric gives a symmetric Hilbert-stress
coefficient matrix. -/
theorem hilbertStress_symmetric
    (gCov gInv : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real)
    (hSymm : gCov.IsSymm) :
    (hilbertStress gCov gInv derivative potentialDensity).IsSymm := by
  sorry

/-- When the supplied measure response obeys the inverse-metric determinant
law, the local first response is exactly one half of the measure-weighted
Hilbert-stress pairing. -/
theorem volumeCompatible_response_eq_hilbert_pairing
    (measure measureResponse : Real)
    (gCov gInv variation : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real)
    (hMeasure : measureResponse =
      -(1 / 2) * measure * (∑ a, ∑ b, gCov a b * variation a b)) :
    inverseMetricMeasureResponse
        measure measureResponse gInv variation derivative potentialDensity =
      (1 / 2) * measure *
        (∑ a, ∑ b,
          hilbertStress gCov gInv derivative potentialDensity a b *
            variation a b) := by
  sorry

/-- The Hilbert-stress coefficient is invariant under one common internal
unitary transformation of every derivative component. -/
theorem hilbertStress_unitary
    (g : Matrix.unitaryGroup N Complex)
    (gCov gInv : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real) :
    hilbertStress gCov gInv (unitaryTransformDerivative g derivative)
        potentialDensity =
      hilbertStress gCov gInv derivative potentialDensity := by
  sorry

/-- The complete independent measure/inverse-metric first response is
invariant under one common internal unitary transformation. -/
theorem inverseMetricMeasureResponse_unitary
    (g : Matrix.unitaryGroup N Complex)
    (measure measureResponse : Real)
    (gInv variation : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real) :
    inverseMetricMeasureResponse measure measureResponse gInv variation
        (unitaryTransformDerivative g derivative) potentialDensity =
      inverseMetricMeasureResponse measure measureResponse gInv variation
        derivative potentialDensity := by
  sorry

end HiggsHilbertStress

end
