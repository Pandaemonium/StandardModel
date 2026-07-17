import Mathlib

/-!
# Finite complex Higgs Hilbert-stress algebra

This module isolates the finite algebra connecting a complex unitary multiplet
to a symmetric inverse-metric response. The complex-multiplet convention is

```text
L = gInv^{ab} Re((D_a H)^dagger D_b H) - V,
T_ab = 2 Re((D_a H)^dagger D_b H) - g_ab L.
```

Consequently the inverse-metric response convention is
`delta S = +(1/2) measure T_ab delta gInv^{ab}`. Equivalently, covariant-metric
variation carries the opposite sign. The factor two is the complex-field
normalization, equivalent to one-half normalization on each real component.

Provenance: clean-room finite formalization of the Hilbert metric-variation
definition and standard complex-scalar tensor shape. Convention cross-checks
are arXiv:2211.03092 for metric/coframe variational stress and arXiv:2112.11168,
Eq. (3), for the symmetric complex-scalar derivative bilinear; their paper-
specific signs and normalizations are kept separate. The proofs were completed
by Aristotle task `455ef650-659d-4955-80b4-6a7011cfed74` and replayed in the
pinned project environment.

The covariant and inverse metric matrices, measure, measure response, and
derivative components are supplied. No graph reconstruction, continuum limit,
field equation, conservation law, or Einstein equation is claimed.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsHilbertStress

open scoped BigOperators ComplexConjugate

variable {N I : Type*} [Fintype N] [Fintype I]

/-- Real part of the finite Hermitian pairing on internal multiplet vectors. -/
def realHermitianBilinear (left right : N -> Complex) : Real :=
  ∑ n, (star (left n) * right n).re

/-- Symmetric real derivative bilinear in supplied frame components. -/
def derivativeBilinear
    (derivative : I -> N -> Complex) (a b : I) : Real :=
  realHermitianBilinear (derivative a) (derivative b)

/-- Apply one internal unitary transformation to every derivative component. -/
def unitaryTransformDerivative
    [DecidableEq N]
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
  unfold realHermitianBilinear
  simp +decide [mul_comm]

/-- Internal unitary transformations preserve the full real Hermitian
bilinear, not only its diagonal norm-square values. -/
theorem realHermitianBilinear_unitary
    [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex) (left right : N -> Complex) :
    realHermitianBilinear
        (Matrix.mulVec (g : Matrix N N Complex) left)
        (Matrix.mulVec (g : Matrix N N Complex) right) =
      realHermitianBilinear left right := by
  have h_unitary : Matrix.conjTranspose g.val * g.val = 1 := by
    exact g.2.1
  convert congr_arg Complex.re
    (show
      (∑ i, g.val.mulVec left i *
        (starRingEnd Complex) (g.val.mulVec right i)) =
        ∑ i, left i * (starRingEnd Complex) (right i) from ?_) using 1
  · simp +decide [realHermitianBilinear]
  · unfold realHermitianBilinear
    simp +decide
  · convert congr_arg (fun m : Matrix N N Complex => m.trace)
      (show
        Matrix.of (fun i j => g.val.mulVec left i *
          (starRingEnd Complex) (g.val.mulVec right j)) =
          g.val * Matrix.of (fun i j =>
            left i * (starRingEnd Complex) (right j)) *
            g.val.conjTranspose from ?_) using 1
    · simp +decide [Matrix.mul_assoc, Matrix.trace_mul_comm g.val, h_unitary]
      simp +decide [Matrix.trace]
    · ext i j
      simp +decide [Matrix.mul_apply, Matrix.mulVec]
      ring_nf
      simp +decide [dotProduct, Finset.mul_sum _ _ _, mul_assoc, mul_comm,
        mul_left_comm]
      simp +decide only [Finset.sum_mul, mul_assoc]

/-- The kinetic contraction is affine-linear in the inverse metric. -/
theorem metricKinetic_affine
    (gInv variation : Matrix I I Real)
    (derivative : I -> N -> Complex) (epsilon : Real) :
    metricKinetic (gInv + epsilon • variation) derivative =
      metricKinetic gInv derivative +
        epsilon * metricKinetic variation derivative := by
  unfold metricKinetic
  simp +decide [Finset.mul_sum _ _ _, Finset.sum_add_distrib, add_mul,
    mul_assoc]

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
  unfold localMetricAction inverseMetricMeasureResponse
  unfold metricLagrangian
  rw [metricKinetic_affine]
  ring

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
  simp +decide only [localMetricAction_affine_expansion]
  convert HasDerivAt.add
    (HasDerivAt.add (hasDerivAt_const _ _)
      (HasDerivAt.mul (hasDerivAt_id (0 : Real)) (hasDerivAt_const _ _)))
    (HasDerivAt.mul (hasDerivAt_pow 2 (0 : Real))
      (hasDerivAt_const _ _)) using 1; norm_num

/-- A symmetric supplied covariant metric gives a symmetric Hilbert-stress
coefficient matrix. -/
theorem hilbertStress_symmetric
    (gCov gInv : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real)
    (hSymm : gCov.IsSymm) :
    (hilbertStress gCov gInv derivative potentialDensity).IsSymm := by
  ext a b
  simp +decide [*, hilbertStress]
  rw [← hSymm.apply]
  exact congrArg₂ _
    (congrArg₂ _ rfl (realHermitianBilinear_symm _ _)) rfl

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
  unfold inverseMetricMeasureResponse hilbertStress;
  simp +decide only [hMeasure, mul_assoc, sub_mul, Finset.sum_sub_distrib];
  simp +decide [mul_sub, mul_assoc, mul_comm, Finset.mul_sum _ _ _,
    metricKinetic]
  simp [mul_left_comm]
  ring

/-- The Hilbert-stress coefficient is invariant under one common internal
unitary transformation of every derivative component. -/
theorem hilbertStress_unitary
    [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex)
    (gCov gInv : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real) :
    hilbertStress gCov gInv (unitaryTransformDerivative g derivative)
        potentialDensity =
      hilbertStress gCov gInv derivative potentialDensity := by
  unfold hilbertStress
  unfold derivativeBilinear metricLagrangian metricKinetic
  unfold unitaryTransformDerivative
  unfold derivativeBilinear
  simp +decide [realHermitianBilinear_unitary]

/-- The complete independent measure/inverse-metric first response is
invariant under one common internal unitary transformation. -/
theorem inverseMetricMeasureResponse_unitary
    [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex)
    (measure measureResponse : Real)
    (gInv variation : Matrix I I Real)
    (derivative : I -> N -> Complex) (potentialDensity : Real) :
    inverseMetricMeasureResponse measure measureResponse gInv variation
        (unitaryTransformDerivative g derivative) potentialDensity =
      inverseMetricMeasureResponse measure measureResponse gInv variation
        derivative potentialDensity := by
  unfold inverseMetricMeasureResponse metricLagrangian metricKinetic
  unfold derivativeBilinear unitaryTransformDerivative
  simp +decide only [realHermitianBilinear_unitary]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsHilbertStress.realHermitianBilinear_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms realHermitianBilinear_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsHilbertStress.volumeCompatible_response_eq_hilbert_pairing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms volumeCompatible_response_eq_hilbert_pairing

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsHilbertStress.inverseMetricMeasureResponse_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inverseMetricMeasureResponse_unitary

end PhysicsSM.Draft.NullEdge.HiggsHilbertStress

end
