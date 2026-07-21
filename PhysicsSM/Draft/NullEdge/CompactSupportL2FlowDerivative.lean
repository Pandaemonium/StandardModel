import PhysicsSM.Draft.NullEdge.CompactSupportL2Generator

/-!
# Paper D successor: the exact orbit is differentiable at every time

Target statements for the Aristotle job `l2-flow-derivative-20260719`.

Context.  `CompactSupportL2Generator` (included, PROVEN tonight, guarded)
closes the strong `Lp` derivative AT ZERO: for bounded-momentum-support
`f`, the difference quotients of the exact momentum-multiplier orbit
converge in `Lp` to the packaged generator element `genRepr m R f hf`
(`orbit_slope_tendsto`, `momMultL2Isometry_hasDerivAt_zero`).  This module
states the flow layer that upgrades the point derivative to the whole
orbit: the multiplier family is a one-parameter group, and conjugating the
`t = 0` derivative through the group gives the derivative at every time -
the "exact unitary flow with Dirac generator" statement Paper D's
multiplier-identification section needs.

Pre-registered honesty license: if a group-law lemma below already exists
in the included chain under another name (`ExactFlowGenerator` /
`MomMultL2StrongContinuity`), prove it by citation and say so.  If the
bounded-support hypothesis must travel differently through the group
conjugation (support is preserved by the multiplier - state and prove that
as a helper if needed), add the helper and record it.  Every `s o r r y`
below is a documented Aristotle handoff hole.
-/

noncomputable section

open Matrix Complex
open MeasureTheory Filter Topology

namespace PhysicsSM.Draft.NullEdge.CompactSupportL2FlowDerivative

open PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk
open PhysicsSM.Draft.NullEdge.ChangingCellFourierL2
open PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE
open PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
open PhysicsSM.Draft.NullEdge.ExactFlowGenerator
open PhysicsSM.Draft.NullEdge.MomMultL2StrongContinuity
open PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry
open PhysicsSM.Draft.NullEdge.HermitianExpLipschitz
open PhysicsSM.Draft.NullEdge.CompactSupportL2Generator

/-- Pointwise one-parameter group law for the momentum multiplier. -/
theorem momMult_add (m s t : Real) (k : FourierMomentum3) (v : Spinor) :
    momMult m (s + t) k v = momMult m s k (momMult m t k v) := by
  simp [momMult];
  have h_exp : NormedSpace.exp ((-(s + t : ℂ)) • (Complex.I • H (k 0) (k 1) (k 2) m)) = NormedSpace.exp ((-(s : ℂ)) • (Complex.I • H (k 0) (k 1) (k 2) m)) * NormedSpace.exp ((-(t : ℂ)) • (Complex.I • H (k 0) (k 1) (k 2) m)) := by
    rw [ ← Matrix.exp_add_of_commute ];
    · rw [← add_smul]
      ring_nf
    · ext i j
      simp +decide [mul_left_comm]
  unfold exactFlow
  aesop

/-- Lifted group law for the `L2` isometry family. -/
theorem momMultL2Isometry_add (m s t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    momMultL2Isometry m (s + t) f =
      momMultL2Isometry m s (momMultL2Isometry m t f) := by
  refine Lp.ext ?_
  filter_upwards [momMultL2Isometry_coeFn m (s + t) f,
    momMultL2Isometry_coeFn m t f,
    momMultL2Isometry_coeFn m s (momMultL2Isometry m t f)] with x hx₁ hx₂ hx₃
  rw [hx₁, hx₃, hx₂, momMult_add]

/-- The multiplier orbit preserves bounded momentum support. -/
theorem boundedSupport_momMultL2Isometry (m t R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f) :
    BoundedSupport R (momMultL2Isometry m t f) := by
  filter_upwards [hf, momMultL2Isometry_coeFn m t f] with k hk₁ hk₂
  aesop

/-- **Main target: the exact orbit is differentiable at every time.**
The `Lp` difference quotients at `t₀` converge to the isometry image of
the generator element - the whole-orbit upgrade of the landed
`orbit_slope_tendsto`.
-/
theorem orbit_slope_tendsto_at (m R t₀ : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f)
    (u : ℕ → Real) (hu : Tendsto u atTop (𝓝[≠] (0 : Real))) :
    Tendsto (fun n => (u n)⁻¹ •
        (momMultL2Isometry m (t₀ + u n) f - momMultL2Isometry m t₀ f))
      atTop
      (𝓝 (momMultL2Isometry m t₀ (genRepr m R f hf))) := by
  have hzero := orbit_slope_tendsto m R f hf u hu
  convert Filter.Tendsto.comp
      (Continuous.tendsto
        (show Continuous fun x => (momMultL2Isometry m t₀) x from
          LinearIsometry.continuous (momMultL2Isometry m t₀)) _)
      hzero using 2
  · simp +decide [momMultL2Isometry_add]
    convert (momMultL2Isometry m t₀).map_smul ((u ‹_›)⁻¹)
        (momMultL2Isometry m (u ‹_›) f - f) using 1
    · simp +decide [map_sub, map_smul]
      norm_cast
    · convert (momMultL2Isometry m t₀).map_smul ((u ‹_› : ℂ)⁻¹)
          (momMultL2Isometry m (u ‹_›) f - f) using 1
      norm_cast

end PhysicsSM.Draft.NullEdge.CompactSupportL2FlowDerivative
