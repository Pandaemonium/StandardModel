import PhysicsSM.Draft.NullEdge.LocalizedIntervalAffineActionNoGo

/-!
# Finite Einstein-Hilbert bulk response interface

This module records the minimal nonlinear algebra that the null-edge gravity
action must eventually realize. For supplied local volume and scalar-curvature
fields, define

```text
S_EH = sum_x volume(x) * (R(x) - 2 Lambda).
```

Under simultaneous affine perturbations of volume and curvature, its first
response has two channels:

```text
delta S_EH = sum_x [delta volume(x) * (R(x) - 2 Lambda)
                    + volume(x) * delta R(x)].
```

The exact finite expansion also has a quadratic cross term. This is the first
nonlinearity absent from the fixed-measure interval action. The module does not
construct volume, scalar curvature, their metric responses, the boundary term,
or the integration-by-parts identity that turns the curvature response into
the Einstein tensor. Those remain the physical descent obligations.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteEinsteinHilbertActionResponse

open scoped BigOperators

variable {Site : Type*} [Fintype Site]

/-- Supplied finite Einstein-Hilbert bulk functional, before normalization by
the gravitational coupling and before adding a boundary term. -/
def finiteEinsteinHilbertBulk
    (volume scalarCurvature : Site -> Real)
    (cosmologicalConstant : Real) : Real :=
  ∑ site : Site,
    volume site * (scalarCurvature site - 2 * cosmologicalConstant)

/-- First response of the finite bulk functional to supplied local volume and
scalar-curvature responses. -/
def finiteEinsteinHilbertBulkResponse
    (volume volumeResponse scalarCurvature curvatureResponse : Site -> Real)
    (cosmologicalConstant : Real) : Real :=
  ∑ site : Site,
    (volumeResponse site *
        (scalarCurvature site - 2 * cosmologicalConstant) +
      volume site * curvatureResponse site)

/-- The second-order cross response generated when both supplied geometric
channels vary. -/
def finiteEinsteinHilbertBulkCrossResponse
    (volumeResponse curvatureResponse : Site -> Real) : Real :=
  ∑ site : Site, volumeResponse site * curvatureResponse site

/-- Simultaneous affine volume and curvature perturbations have an exact
quadratic expansion. -/
theorem finiteEinsteinHilbertBulk_affine_expansion
    (volume volumeResponse scalarCurvature curvatureResponse : Site -> Real)
    (cosmologicalConstant epsilon : Real) :
    finiteEinsteinHilbertBulk
        (fun site => volume site + epsilon * volumeResponse site)
        (fun site => scalarCurvature site + epsilon * curvatureResponse site)
        cosmologicalConstant =
      finiteEinsteinHilbertBulk volume scalarCurvature cosmologicalConstant +
        epsilon * finiteEinsteinHilbertBulkResponse volume volumeResponse
          scalarCurvature curvatureResponse cosmologicalConstant +
        epsilon ^ 2 *
          finiteEinsteinHilbertBulkCrossResponse volumeResponse
            curvatureResponse := by
  unfold finiteEinsteinHilbertBulk finiteEinsteinHilbertBulkResponse
    finiteEinsteinHilbertBulkCrossResponse
  rw [Finset.mul_sum, Finset.mul_sum]
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro site _
  ring

/-- The displayed two-channel response is the derivative of the simultaneous
affine geometry path at the base point. -/
theorem hasDerivAt_finiteEinsteinHilbertBulk_affine
    (volume volumeResponse scalarCurvature curvatureResponse : Site -> Real)
    (cosmologicalConstant : Real) :
    HasDerivAt
      (fun epsilon : Real =>
        finiteEinsteinHilbertBulk
          (fun site => volume site + epsilon * volumeResponse site)
          (fun site => scalarCurvature site + epsilon * curvatureResponse site)
          cosmologicalConstant)
      (finiteEinsteinHilbertBulkResponse volume volumeResponse
        scalarCurvature curvatureResponse cosmologicalConstant) 0 := by
  unfold finiteEinsteinHilbertBulk finiteEinsteinHilbertBulkResponse
  apply HasDerivAt.fun_sum
  intro site _
  have hVolume : HasDerivAt
      (fun epsilon : Real => volume site + epsilon * volumeResponse site)
      (volumeResponse site) 0 := by
    simpa using
      ((hasDerivAt_id (𝕜 := Real) 0).mul_const
        (volumeResponse site)).const_add (volume site)
  have hCurvature : HasDerivAt
      (fun epsilon : Real =>
        scalarCurvature site + epsilon * curvatureResponse site -
          2 * cosmologicalConstant)
      (curvatureResponse site) 0 := by
    simpa using
      (((hasDerivAt_id (𝕜 := Real) 0).mul_const
        (curvatureResponse site)).const_add
          (scalarCurvature site)).sub_const (2 * cosmologicalConstant)
  convert hVolume.mul hCurvature using 1; ring

/-- The first response splits exactly into local volume and curvature
channels. -/
theorem finiteEinsteinHilbertBulkResponse_channel_split
    (volume volumeResponse scalarCurvature curvatureResponse : Site -> Real)
    (cosmologicalConstant : Real) :
    finiteEinsteinHilbertBulkResponse volume volumeResponse scalarCurvature
        curvatureResponse cosmologicalConstant =
      (∑ site : Site,
        volumeResponse site *
          (scalarCurvature site - 2 * cosmologicalConstant)) +
      ∑ site : Site, volume site * curvatureResponse site := by
  unfold finiteEinsteinHilbertBulkResponse
  rw [Finset.sum_add_distrib]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteEinsteinHilbertActionResponse.finiteEinsteinHilbertBulk_affine_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteEinsteinHilbertBulk_affine_expansion

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteEinsteinHilbertActionResponse.hasDerivAt_finiteEinsteinHilbertBulk_affine' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_finiteEinsteinHilbertBulk_affine

end PhysicsSM.Draft.NullEdge.FiniteEinsteinHilbertActionResponse
