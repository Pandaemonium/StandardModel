import PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantRetardedPropagation
import PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent

/-!
# Gauge-invariant measured Higgs propagation

This module lifts the nonuniform measured strict-past Higgs resolvent to the
leading gauge-invariant Froehlich--Morchio--Strocchi radial observable. The FMS
coefficient scales the response but changes neither its exact left/right
resolvent equations nor, at nonzero vacuum, its entrywise causal support.

The three-event control is nonvacuous: there is no direct endpoint hop, the
elementary measured response is `-3`, and the leading one-component FMS
response is `-12` in the supplied unnormalized radial coordinate.

This remains finite leading-response algebra. It does not suppress higher FMS
terms, derive a continuum pole, provide LSZ normalization, or predict the
observed Higgs mass. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantMeasuredPropagation

open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
open PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable
open PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantRetardedPropagation
open PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries
open PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent

variable {N V : Type*} [Fintype N] [Fintype V] [DecidableEq V]

/-- The leading gauge-invariant radial response obeys the same exact two-sided
measured resolvent as the elementary radial field. -/
theorem strictPast_fmsLeading_measured_two_sided_resolvent
    [Nonempty V] (vacuum : N -> Complex)
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    let K := weightedPastKernelMatrix C weight
    let M := localMassMatrix massSq vertexMeasure
    let G := measuredMassRetardedSeries K M (Fintype.card V)
    let ALeft := 1 + K * M
    let ARight := 1 + M * K
    ALeft * fmsLeadingKernel vacuum G = fmsLeadingKernel vacuum K ∧
      fmsLeadingKernel vacuum G * ARight = fmsLeadingKernel vacuum K := by
  dsimp
  obtain ⟨hLeft, hRight⟩ :=
    strictPast_measuredSeries_two_sided_resolvent
      C weight massSq vertexMeasure
  constructor
  · exact fmsLeadingKernel_resolvent vacuum _ _ _ hLeft
  · unfold fmsLeadingKernel
    rw [Matrix.smul_mul, hRight]

/-- At nonzero vacuum, the leading gauge-invariant measured kernel has exactly
the same entrywise causal support as the elementary measured response. -/
theorem strictPast_fmsLeading_measured_entry_eq_zero_iff
    (vacuum : N -> Complex) (hVacuum : vacuum ≠ 0)
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) (i j : V) :
    fmsLeadingKernel vacuum
        (measuredMassRetardedSeries
          (weightedPastKernelMatrix C weight)
          (localMassMatrix massSq vertexMeasure) (Fintype.card V)) i j = 0 ↔
      measuredMassRetardedSeries
          (weightedPastKernelMatrix C weight)
          (localMassMatrix massSq vertexMeasure) (Fintype.card V) i j = 0 := by
  exact fmsLeadingKernel_entry_eq_zero_iff vacuum _ hVacuum i j

/-- Exact gauge-invariant nonuniform three-event control. The primitive
endpoint entry vanishes, the elementary measured response is `-3`, and its
leading one-component FMS response is `-12`. -/
theorem threeLink_fmsLeading_measured_intermediate_witness :
    fmsRadialResidue (oneComponentVacuum 1) = 4 ∧
      fmsLeadingKernel (oneComponentVacuum 1) threeLinkKernel 2 0 = 0 ∧
      measuredMassRetardedSeries threeLinkKernel
          (localMassMatrix 1 threeLinkMeasure) 3 2 0 = -3 ∧
      fmsLeadingKernel (oneComponentVacuum 1)
          (measuredMassRetardedSeries threeLinkKernel
            (localMassMatrix 1 threeLinkMeasure) 3) 2 0 = -12 := by
  obtain ⟨hPrimitive, _, hMeasured⟩ := threeLink_measured_intermediate_witness
  refine ⟨by norm_num [oneComponent_fmsRadialResidue_eq], ?_, hMeasured, ?_⟩
  · simp [fmsLeadingKernel, hPrimitive]
  · change fmsRadialResidue (oneComponentVacuum 1) *
      measuredMassRetardedSeries threeLinkKernel
        (localMassMatrix 1 threeLinkMeasure) 3 2 0 = -12
    rw [oneComponent_fmsRadialResidue_eq, hMeasured]
    norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantMeasuredPropagation.strictPast_fmsLeading_measured_two_sided_resolvent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictPast_fmsLeading_measured_two_sided_resolvent

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantMeasuredPropagation.threeLink_fmsLeading_measured_intermediate_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms threeLink_fmsLeading_measured_intermediate_witness

end PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantMeasuredPropagation

end
