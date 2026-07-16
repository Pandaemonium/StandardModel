import PhysicsSM.Draft.NullEdge.RelativeScaleCurvatureBridge

/-!
# Relative graph scale and Weyl-Lorentz tetrad transitions

This module composes the density-free relative scale reconstruction with the
finite coframe-transition layer. In the row-coframe convention

```text
g = e * eta * e^T,
```

a scalar length change `r` multiplies the metric by `r^2`. If `L` is Lorentz
for `eta`, the combined transition `r L` is therefore conformal Lorentz with
factor `r^2`. Multiplication of transitions respects multiplication of scales,
so the count-derived anchor cocycle gives an exact Weyl-Lorentz cocycle.

This closes a finite compositional gap between G2 relative scale, G3 coframes,
and the inverse-area curvature normalization used in G4. It does not derive
regions, counts, coframe representatives, Lorentz transitions, coordinate
charts, spin lifts, or an absolute unit from a bare graph. Those remain the
reconstruction hypotheses. Claim grade: `M [orig/comp]`.

The matrix convention here matches `SynchronizedTetradBundle.rowMetric`; that
older rational module and this real four-dimensional scale module are kept
separate to avoid silently coercing physical scale into a rational model.
-/

open Filter Matrix Topology

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge

open PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction
open PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
open PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction
open PhysicsSM.Draft.NullEdge.RelativeScaleCurvatureBridge

variable {ι : Type*} [Fintype ι]

/-- Metric represented by a row coframe and an internal bilinear form. -/
def rowMetric
    (eta e : Matrix ι ι Real) : Matrix ι ι Real :=
  e * eta * eᵀ

/-- Scalar Weyl rescaling of a row coframe. -/
def scaledCoframe
    (r : Real) (e : Matrix ι ι Real) : Matrix ι ι Real :=
  r • e

/-- A local length rescaling followed by a Lorentz-frame transition. -/
def weylLorentzTransition
    (r : Real) (L : Matrix ι ι Real) : Matrix ι ι Real :=
  r • L

/-- Row-coframe metric has Weyl weight two. -/
theorem rowMetric_scaledCoframe
    (r : Real) (eta e : Matrix ι ι Real) :
    rowMetric eta (scaledCoframe r e) = r ^ 2 • rowMetric eta e := by
  unfold rowMetric scaledCoframe
  rw [Matrix.transpose_smul, Matrix.smul_mul, Matrix.mul_smul,
    Matrix.smul_mul, smul_smul]
  ring_nf

/-- A Weyl-scaled Lorentz transition is conformal Lorentz with metric factor
`r^2`. -/
theorem weylLorentzTransition_metric
    (r : Real) (eta L : Matrix ι ι Real)
    (hLorentz : L * eta * Lᵀ = eta) :
    weylLorentzTransition r L * eta *
        (weylLorentzTransition r L)ᵀ = r ^ 2 • eta := by
  unfold weylLorentzTransition
  rw [Matrix.transpose_smul, Matrix.smul_mul, Matrix.mul_smul,
    Matrix.smul_mul, smul_smul, hLorentz]
  ring_nf

/-- Weyl-Lorentz transition multiplication separates into scalar and Lorentz
parts. -/
theorem weylLorentzTransition_mul
    (r s : Real) (L M : Matrix ι ι Real) :
    weylLorentzTransition r L * weylLorentzTransition s M =
      weylLorentzTransition (r * s) (L * M) := by
  unfold weylLorentzTransition
  rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul]

/-! ## Four-dimensional count-derived transitions -/

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Real

/-- Combine the count-derived relative length factor with a supplied Lorentz
transition between representative coframes. -/
def countWeylTransition
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (L : Mat4) : Mat4 :=
  weylLorentzTransition (relativeCountScale n e n0 e0) L

/-- Positive count and representative volumes make the Weyl factor positive,
while the combined transition acts on the metric with the count-derived area
factor. -/
theorem countWeylTransition_metric_package
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (eta L : Mat4)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0)
    (hLorentz : L * eta * Lᵀ = eta) :
    0 < relativeCountScale n e n0 e0 ∧
      countWeylTransition n e n0 e0 L * eta *
          (countWeylTransition n e n0 e0 L)ᵀ =
        relativeAreaScale n e n0 e0 • eta := by
  constructor
  · exact relativeCountScale_pos n e n0 e0 hn hn0 he he0
  · exact weylLorentzTransition_metric
      (relativeCountScale n e n0 e0) eta L hLorentz

/-- The count-derived Weyl-Lorentz transitions obey the same anchor-overlap
cocycle as the relative scales and supplied Lorentz transitions. -/
theorem countWeylTransition_anchor_cocycle
    (n : Nat) (e : Coframe4)
    (n1 : Nat) (e1 : Coframe4)
    (n0 : Nat) (e0 : Coframe4)
    (LTargetMid LMidAnchor LTargetAnchor : Mat4)
    (hn : 0 < n) (hn1 : 0 < n1) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e)
    (he1 : 0 < coframeVolume e1)
    (he0 : 0 < coframeVolume e0)
    (hLorentzCocycle : LTargetMid * LMidAnchor = LTargetAnchor) :
    countWeylTransition n e n1 e1 LTargetMid *
        countWeylTransition n1 e1 n0 e0 LMidAnchor =
      countWeylTransition n e n0 e0 LTargetAnchor := by
  unfold countWeylTransition
  rw [weylLorentzTransition_mul, hLorentzCocycle]
  rw [relativeCountScale_anchor_cocycle
    n e n1 e1 n0 e0 hn hn1 hn0 he he1 he0]

/-- **G2-G3-G4 scale capstone.** One positive count-derived length factor gives
the Weyl-Lorentz metric factor and the inverse factor for area-normalized
holonomy curvature. The holonomy limit and Lorentz transition remain explicit
inputs. -/
theorem countWeylTransition_curvature_package
    {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (eta L : Mat4)
    (area : Nat → Real) (holonomy : Nat → E) (base target : E)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0)
    (hLorentz : L * eta * Lᵀ = eta)
    (hlimit :
      Tendsto (normalizedHolonomyCurvature area holonomy base)
        atTop (nhds target)) :
    0 < relativeCountScale n e n0 e0 ∧
      countWeylTransition n e n0 e0 L * eta *
          (countWeylTransition n e n0 e0 L)ᵀ =
        relativeAreaScale n e n0 e0 • eta ∧
      Tendsto
        (normalizedHolonomyCurvature
          (fun k => relativeAreaScale n e n0 e0 * area k)
          holonomy base)
        atTop
        (nhds ((relativeAreaScale n e n0 e0)⁻¹ • target)) := by
  have hmetric := countWeylTransition_metric_package
    n e n0 e0 eta L hn hn0 he he0 hLorentz
  exact ⟨hmetric.1, hmetric.2,
    relativeAreaScale_rescales_curvature_limit
      n e n0 e0 area holonomy base target hlimit⟩

/-- Mostly-minus real internal metric in four dimensions. -/
def eta4 : Mat4 :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

/-- Sixteen events relative to one produce a non-Lorentz Weyl transition
`2 I` whose metric factor is four. This witnesses that the scale channel is
genuinely distinct from Lorentz gauge. -/
theorem countWeylTransition_nonunit_witness :
    countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1 ≠ 1 ∧
      countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1 * eta4 *
          (countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1)ᵀ =
        (4 : Real) • eta4 := by
  have hscale :
      relativeCountScale 16 (1 : Coframe4) 1 (1 : Coframe4) = 2 :=
    relative_scale_unit_witness.1
  have htransition :
      countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1 =
        (2 : Real) • (1 : Mat4) := by
    simp only [countWeylTransition, weylLorentzTransition, hscale]
  constructor
  · rw [htransition]
    intro h
    have h00 := congrArg (fun M : Mat4 => M 0 0) h
    norm_num at h00
  · have hmetric := (countWeylTransition_metric_package
      16 (1 : Coframe4) 1 (1 : Coframe4) eta4 1
      (by norm_num) (by norm_num)
      (by simp [coframeVolume]) (by simp [coframeVolume])
      (by simp)).2
    rw [relativeAreaScale, hscale] at hmetric
    norm_num at hmetric
    exact hmetric

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.rowMetric_scaledCoframe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.rowMetric_scaledCoframe

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.countWeylTransition_metric_package' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.countWeylTransition_metric_package

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.countWeylTransition_anchor_cocycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.countWeylTransition_anchor_cocycle

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.countWeylTransition_curvature_package' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.countWeylTransition_curvature_package

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.countWeylTransition_nonunit_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge.countWeylTransition_nonunit_witness

end PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge
