import PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction
import PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface

/-!
# Relative graph scale and curvature normalization

This module connects the G2 relative-scale reconstruction to the G4
area-normalized holonomy interface.  If every plaquette area in a refinement
family is multiplied by a fixed positive area factor `c`, then the normalized
curvature coefficient is multiplied by `c^-1`.  The underlying Lean identity
is valid for every real `c` because inversion is totalized; at `c = 0` both
sides collapse to zero and no physical area calibration is represented.
Instantiating `c` with the positive `relativeAreaScale` furnished by positive
counts and representative volumes gives the expected four-dimensional Weyl
weight:

```text
area      has relative weight r^2,
curvature has relative weight r^-2.
```

The exact witness uses sixteen events relative to one on equal identity
conformal representatives.  Their relative length factor is two and area
factor four, so the same nontrivial holonomy family has normalized limit
`3/4` instead of `3` when expressed in the enlarged area unit.

## Scope boundary

The theorem transports a supplied first-order holonomy limit through a fixed
area calibration.  Its unconditional form is an algebraic identity using
Lean's totalized inverse; the interpretation as a physical area calibration
requires the separately proved positivity of the count-derived factor.  It
does not derive graph plaquettes, their base areas, holonomies, the first-order
expansion, or an absolute area unit.  For a positive calibration it proves
that the remaining global scale ambiguity has exactly the inverse-area action
on curvature rather than silently disappearing.

Provenance: clean-room composition of `RelativeGraphScaleReconstruction` and
`CurvatureConvergenceInterface`. Claim grade: `M [orig/comp]`.
-/

open Filter Topology

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RelativeScaleCurvatureBridge

open PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction
open PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface

abbrev ScaleCoframe4 :=
  PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.Coframe4

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]

/-- Scaling every area by a fixed real factor scales normalized holonomy
curvature by the totalized inverse factor, pointwise at every refinement
stage. For `c = 0`, this is the algebraic identity `0 = 0`, not a physical
rescaling by an area unit. -/
theorem normalizedHolonomyCurvature_const_area_scale
    (c : Real) (area : Nat → Real) (holonomy : Nat → E) (base : E) (n : Nat) :
    normalizedHolonomyCurvature (fun k => c * area k) holonomy base n =
      c⁻¹ • normalizedHolonomyCurvature area holonomy base n := by
  unfold normalizedHolonomyCurvature
  simp only [mul_inv, smul_smul]

/-- A convergent normalized holonomy family retains convergence after a fixed
real scaling, with totalized-inverse-scaled target curvature. Its physical
area-calibration reading requires a positive scaling factor. -/
theorem normalizedHolonomy_tendsto_const_area_scale
    (c : Real) (area : Nat → Real) (holonomy : Nat → E) (base target : E)
    (hlimit :
      Tendsto (normalizedHolonomyCurvature area holonomy base)
        atTop (nhds target)) :
    Tendsto
      (normalizedHolonomyCurvature (fun k => c * area k) holonomy base)
      atTop (nhds (c⁻¹ • target)) := by
  have heq :
      normalizedHolonomyCurvature (fun k => c * area k) holonomy base =
        fun n => c⁻¹ • normalizedHolonomyCurvature area holonomy base n := by
    funext n
    exact normalizedHolonomyCurvature_const_area_scale c area holonomy base n
  rw [heq]
  exact tendsto_const_nhds.smul hlimit

/-- **G2-to-G4 relative calibration bridge.** The algebraically defined
relative area factor acts on the extracted curvature coefficient with
(totalized) inverse weight. Positive counts and representative volumes make
this factor positive and justify its density-free physical interpretation. -/
theorem relativeAreaScale_rescales_curvature_limit
    (n : Nat) (e : ScaleCoframe4) (n0 : Nat) (e0 : ScaleCoframe4)
    (area : Nat → Real) (holonomy : Nat → E) (base target : E)
    (hlimit :
      Tendsto (normalizedHolonomyCurvature area holonomy base)
        atTop (nhds target)) :
    Tendsto
      (normalizedHolonomyCurvature
        (fun k => relativeAreaScale n e n0 e0 * area k) holonomy base)
      atTop
      (nhds ((relativeAreaScale n e n0 e0)⁻¹ • target)) := by
  exact normalizedHolonomy_tendsto_const_area_scale
    (relativeAreaScale n e n0 e0) area holonomy base target hlimit

/-! ## Nonzero exact control -/

/-- The sixteen-to-one count witness has area factor four. -/
theorem relativeAreaScale_unit_witness :
    relativeAreaScale 16 (1 : ScaleCoframe4) 1 (1 : ScaleCoframe4) = 4 := by
  have hscale := relative_scale_unit_witness.1
  unfold relativeAreaScale
  rw [hscale]
  norm_num

/-- Scaling the explicit shrinking-area holonomy family by the count-derived
area factor four changes its nonzero curvature limit from three to `3/4`. -/
theorem count_relative_area_curvature_witness :
    Tendsto
      (normalizedHolonomyCurvature
        (fun k =>
          relativeAreaScale 16 (1 : ScaleCoframe4) 1 (1 : ScaleCoframe4) *
            witnessArea k)
        witnessHolonomy (1 : Real))
      atTop (nhds (3 / 4 : Real)) := by
  have hbase := normalizedHolonomy_nonzero_limit_witness.2
  have hscaled := relativeAreaScale_rescales_curvature_limit
    (E := Real) 16 (1 : ScaleCoframe4) 1 (1 : ScaleCoframe4)
    witnessArea witnessHolonomy 1 3 hbase
  rw [relativeAreaScale_unit_witness] at hscaled ⊢
  convert hscaled using 1; norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeScaleCurvatureBridge.relativeAreaScale_rescales_curvature_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relativeAreaScale_rescales_curvature_limit

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeScaleCurvatureBridge.count_relative_area_curvature_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms count_relative_area_curvature_witness

end PhysicsSM.Draft.NullEdge.RelativeScaleCurvatureBridge
