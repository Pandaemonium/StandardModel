import PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional
import PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable

/-!
# Finite Higgs-curvature action response

This module isolates the first-variation algebra of the local nonminimal term

```text
S_xi = -measure * xi * curvature * ||H||^2.
```

With the Higgs field held fixed, the response separates into a volume part and
a curvature part:

```text
delta S_xi = -xi * ||H||^2 *
  (measureResponse * curvature + measure * curvatureResponse).
```

The split matters for the null-edge program. Treating `xi * curvature` only as
a position-dependent scalar insertion captures the field equation but not the
full gravitational response: metric or coframe variation also changes the
curvature itself. This module makes that missing input explicit rather than
claiming a finite improved stress tensor.

The final theorem combines this response with a covariantly constant frozen-
modulus Higgs vacuum. Its link kinetic cost is exactly zero, while a nonzero
curvature response can still give a nonzero local action response.

Curvature, measure, and both geometry responses are supplied. No graph-derived
curvature, continuum metric variation, improved stress tensor, conservation
law, or Einstein equation is claimed. Claim grade: `M [orig/comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsCurvatureActionResponse

open PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional
open PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable

variable {N : Type*} [Fintype N]

/-- Local nonminimal Higgs-curvature action term in the displayed sign
convention. -/
def localCurvatureAction
    (measure xi curvature : Real) (field : N -> Complex) : Real :=
  -measure * xi * curvature * vectorNormSq field

/-- First response of the local nonminimal term to independent supplied
measure and curvature responses, with the Higgs field held fixed. -/
def curvatureActionResponse
    (measure measureResponse xi curvature curvatureResponse : Real)
    (field : N -> Complex) : Real :=
  -xi * vectorNormSq field *
    (measureResponse * curvature + measure * curvatureResponse)

/-- Simultaneous affine measure and curvature perturbations have this exact
quadratic expansion. -/
theorem localCurvatureAction_affine_expansion
    (measure measureResponse xi curvature curvatureResponse epsilon : Real)
    (field : N -> Complex) :
    localCurvatureAction
        (measure + epsilon * measureResponse) xi
        (curvature + epsilon * curvatureResponse) field =
      localCurvatureAction measure xi curvature field +
        epsilon * curvatureActionResponse
          measure measureResponse xi curvature curvatureResponse field -
        epsilon ^ 2 * xi * vectorNormSq field *
          measureResponse * curvatureResponse := by
  unfold localCurvatureAction curvatureActionResponse
  ring

/-- The displayed response is the derivative of the simultaneous affine
geometry path at the base point. -/
theorem hasDerivAt_localCurvatureAction_affine
    (measure measureResponse xi curvature curvatureResponse : Real)
    (field : N -> Complex) :
    HasDerivAt
      (fun epsilon => localCurvatureAction
        (measure + epsilon * measureResponse) xi
        (curvature + epsilon * curvatureResponse) field)
      (curvatureActionResponse
        measure measureResponse xi curvature curvatureResponse field)
      0 := by
  simp only [localCurvatureAction_affine_expansion]
  convert HasDerivAt.sub
    (HasDerivAt.add (hasDerivAt_const _ _)
      (HasDerivAt.mul (hasDerivAt_id (0 : Real)) (hasDerivAt_const _ _)))
    (HasDerivAt.mul
      (HasDerivAt.mul
        (HasDerivAt.mul
          (HasDerivAt.mul (hasDerivAt_pow 2 (0 : Real))
            (hasDerivAt_const _ _))
          (hasDerivAt_const _ _))
        (hasDerivAt_const _ _))
      (hasDerivAt_const _ _)) using 1
  all_goals norm_num

/-- The response is exactly the sum of the volume and curvature channels. -/
theorem curvatureActionResponse_channel_split
    (measure measureResponse xi curvature curvatureResponse : Real)
    (field : N -> Complex) :
    curvatureActionResponse
        measure measureResponse xi curvature curvatureResponse field =
      -xi * vectorNormSq field * measureResponse * curvature +
        -xi * vectorNormSq field * measure * curvatureResponse := by
  unfold curvatureActionResponse
  ring

/-- Internal unitary transformations preserve the local curvature term. -/
theorem localCurvatureAction_unitary
    [DecidableEq N] (g : Matrix.unitaryGroup N Complex)
    (measure xi curvature : Real) (field : N -> Complex) :
    localCurvatureAction measure xi curvature (unitaryTransform g field) =
      localCurvatureAction measure xi curvature field := by
  unfold localCurvatureAction
  rw [vectorNormSq_unitary]

/-- Internal unitary transformations preserve the complete supplied geometry
response. -/
theorem curvatureActionResponse_unitary
    [DecidableEq N] (g : Matrix.unitaryGroup N Complex)
    (measure measureResponse xi curvature curvatureResponse : Real)
    (field : N -> Complex) :
    curvatureActionResponse measure measureResponse xi curvature
        curvatureResponse (unitaryTransform g field) =
      curvatureActionResponse measure measureResponse xi curvature
        curvatureResponse field := by
  unfold curvatureActionResponse
  rw [vectorNormSq_unitary]

/-- With fixed local volume, a nonzero curvature response produces a nonzero
Higgs-curvature action response whenever all displayed factors are nonzero. -/
theorem fixedMeasure_curvatureActionResponse_ne_zero
    {measure xi curvature curvatureResponse : Real} {field : N -> Complex}
    (hMeasure : measure ≠ 0) (hXi : xi ≠ 0)
    (hNorm : vectorNormSq field ≠ 0)
    (hCurvatureResponse : curvatureResponse ≠ 0) :
    curvatureActionResponse
        measure 0 xi curvature curvatureResponse field ≠ 0 := by
  unfold curvatureActionResponse
  simp only [zero_mul, zero_add]
  exact mul_ne_zero
    (mul_ne_zero (neg_ne_zero.mpr hXi) hNorm)
    (mul_ne_zero hMeasure hCurvatureResponse)

/-- A one-component frozen-modulus Higgs value has squared norm exactly equal
to the supplied real vacuum value squared, independently of its phase. -/
theorem oneComponent_frozenModulus_vectorNormSq
    (vacuum : Real) (phase : Circle) :
    vectorNormSq (fun _ : Fin 1 =>
      (vacuum : Complex) * (phase : Complex)) = vacuum ^ 2 := by
  unfold vectorNormSq realHermitianBilinear
  simp only [Fin.sum_univ_one]
  rw [Complex.star_def]
  rw [← Complex.normSq_eq_conj_mul_self]
  change Complex.normSq ((vacuum : Complex) * (phase : Complex)) = vacuum ^ 2
  rw [Complex.normSq_mul, Complex.normSq_ofReal]
  have hPhase : Complex.normSq (phase : Complex) = 1 := by
    rw [Complex.normSq_eq_norm_sq, Circle.norm_coe]
    norm_num
  rw [hPhase, mul_one]
  ring

/-- A covariantly constant Higgs vacuum can have zero link kinetic and
potential cost while retaining a nonzero response to changing supplied
curvature. This is the finite distinction between no Higgs transport in the
vacuum and nontrivial Higgs gravitational response. -/
theorem parallelVacuum_zero_cost_but_curvature_response_ne_zero
    {V E : Type*} [Fintype V] [Fintype E]
    (s t : E -> V) (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (lam vacuum : Real) (sigma : V -> Circle)
    (x : V) {measure xi curvature curvatureResponse : Real}
    (hVacuum : vacuum ≠ 0) (hMeasure : measure ≠ 0) (hXi : xi ≠ 0)
    (hCurvatureResponse : curvatureResponse ≠ 0) :
    weightedHiggsFunctional s t edgeWeight vertexWeight lam vacuum
        (fun y => (vacuum : Complex) * (sigma y : Complex))
        (fun e => sigma (s e) * (sigma (t e))⁻¹) = 0 ∧
      curvatureActionResponse measure 0 xi curvature curvatureResponse
          (fun _ : Fin 1 =>
            (vacuum : Complex) * (sigma x : Complex)) ≠ 0 := by
  constructor
  · exact weightedHiggsFunctional_parallel_vacuum_zero
      s t edgeWeight vertexWeight lam vacuum sigma
  · apply fixedMeasure_curvatureActionResponse_ne_zero
      hMeasure hXi _ hCurvatureResponse
    rw [oneComponent_frozenModulus_vectorNormSq]
    exact pow_ne_zero 2 hVacuum

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCurvatureActionResponse.hasDerivAt_localCurvatureAction_affine' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_localCurvatureAction_affine

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCurvatureActionResponse.curvatureActionResponse_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms curvatureActionResponse_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCurvatureActionResponse.parallelVacuum_zero_cost_but_curvature_response_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parallelVacuum_zero_cost_but_curvature_response_ne_zero

end PhysicsSM.Draft.NullEdge.HiggsCurvatureActionResponse

end
