import PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
import PhysicsSM.Draft.NullEdge.HiggsRadialCurvature
import PhysicsSM.Draft.NullEdge.MassiveRetardedLinkSeries

/-!
# Finite Higgs radial-mass retarded propagation

This capstone joins three independently checked finite ingredients:

1. a weighted kernel supported on strict causal precedence is nilpotent;
2. a nilpotent primitive retarded kernel generates an exact finite massive
   resolvent series; and
3. the one-component Higgs control potential supplies the radial curvature
   `massSq = 8 * lam * vacuum^2`.

Thus the radial Higgs excitation is not assigned one primitive null edge. Its
massive retarded response is a finite sum over chains of primitive causal
steps. The three-event witness makes this distinction nonvacuous: its direct
endpoint kernel entry is zero, while the mass-deformed two-link contribution
is nonzero.

This is finite algebra with a supplied strict order, weights, coupling, and
vacuum. It does not establish a continuum Klein-Gordon pole, derive the
Standard Model normalization, or predict the observed Higgs mass.
Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsMassiveRetardedPropagation

open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
open PhysicsSM.Draft.NullEdge.HiggsRadialCurvature
open PhysicsSM.Draft.NullEdge.MassiveRetardedLinkSeries

variable {V : Type*} [Fintype V] [DecidableEq V] [Nonempty V]

/-- The radial Higgs mass parameter gives exact left and right finite
resolvent identities on every weighted finite strict-past kernel. -/
theorem strictPast_radialHiggs_resolvent
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (lam vacuum : Real) :
    (1 + radialMassSquared lam vacuum • weightedPastKernelMatrix C weight) *
          massiveRetardedSeries (weightedPastKernelMatrix C weight)
            (radialMassSquared lam vacuum) (Fintype.card V) =
        weightedPastKernelMatrix C weight ∧
      massiveRetardedSeries (weightedPastKernelMatrix C weight)
            (radialMassSquared lam vacuum) (Fintype.card V) *
          (1 + radialMassSquared lam vacuum •
            weightedPastKernelMatrix C weight) =
        weightedPastKernelMatrix C weight := by
  constructor
  · apply one_add_mass_kernel_mul_series_of_nilpotent
    exact weightedPastKernelMatrix_pow_card_add_one_eq_zero C weight
  · apply series_mul_one_add_mass_kernel_of_nilpotent
    exact weightedPastKernelMatrix_pow_card_add_one_eq_zero C weight

/-- With zero quartic coupling, the radial curvature vanishes and the positive-
length series reduces exactly to the primitive retarded kernel. -/
theorem zeroQuartic_radialSeries_eq_primitive
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (vacuum : Real) :
    massiveRetardedSeries (weightedPastKernelMatrix C weight)
        (radialMassSquared 0 vacuum) (Fintype.card V) =
      weightedPastKernelMatrix C weight := by
  simpa [radialMassSquared] using
    massiveRetardedSeries_zero_mass (weightedPastKernelMatrix C weight)
      (Fintype.card V) Fintype.card_pos

/-- Exact three-event control at `lam = 1/8` and `vacuum = 1`. In this module's
potential normalization the radial mass squared is one. No direct primitive
endpoint hop exists, but the two-step massive endpoint amplitude is `-1`. -/
theorem unitRadialMass_threeLink_multiedge_witness :
    radialMassSquared (1 / 8) 1 = 1 ∧
      threeLinkKernel 2 0 = 0 ∧
      (threeLinkKernel ^ 2) 2 0 = 1 ∧
      threeLinkKernel ^ 3 = 0 ∧
      massiveRetardedSeries threeLinkKernel
          (radialMassSquared (1 / 8) 1) 3 2 0 = -1 ∧
      massiveRetardedSeries threeLinkKernel 0 3 2 0 = 0 := by
  constructor
  · norm_num [radialMassSquared]
  · simpa [radialMassSquared] using threeLink_massive_multiedge_witness

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsMassiveRetardedPropagation.strictPast_radialHiggs_resolvent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictPast_radialHiggs_resolvent

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsMassiveRetardedPropagation.unitRadialMass_threeLink_multiedge_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unitRadialMass_threeLink_multiedge_witness

end PhysicsSM.Draft.NullEdge.HiggsMassiveRetardedPropagation

end
