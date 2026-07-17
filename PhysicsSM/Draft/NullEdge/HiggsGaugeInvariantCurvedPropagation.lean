import PhysicsSM.Draft.NullEdge.HiggsCurvedStrictPastPropagation
import PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantMeasuredPropagation

/-!
# Gauge-invariant curvature-dependent Higgs propagation

This module lifts the curvature-dependent strict-past Higgs response to the
leading gauge-invariant Froehlich--Morchio--Strocchi radial observable. The
FMS coefficient changes amplitudes but preserves the exact two-sided curved
resolvent and, at nonzero vacuum, every entrywise zero of the elementary
radial kernel.

The nonconstant-curvature three-event control is nonvacuous: the primitive
endpoint hop is zero, the elementary curved response is `-9`, and the leading
one-component FMS response is `-36` in the supplied unnormalized radial
coordinate.

This is finite leading-response algebra. Curvature, measure, primitive kernel,
bare mass, coupling, and vacuum are supplied. No continuum curved-space pole,
FMS truncation estimate, LSZ normalization, or observed Higgs mass is claimed.
Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantCurvedPropagation

open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
open PhysicsSM.Draft.NullEdge.HiggsCurvatureMassIdentifiability
open PhysicsSM.Draft.NullEdge.HiggsCurvedStrictPastPropagation
open PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable
open PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantRetardedPropagation
open PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries

variable {N V : Type*} [Fintype N] [Fintype V] [DecidableEq V]

/-- The leading gauge-invariant radial response obeys the same exact two-sided
curvature-dependent resolvent as the elementary radial field. -/
theorem strictPast_fmsLeading_curved_two_sided_resolvent
    [Nonempty V] (vacuum : N -> Complex)
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (bareMassSq xi : Real) (curvature vertexMeasure : V -> Real) :
    let K := weightedPastKernelMatrix C weight
    let M := effectiveMassMatrix bareMassSq xi curvature vertexMeasure
    let G := HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
      K M (Fintype.card V)
    let ALeft := 1 + K * M
    let ARight := 1 + M * K
    ALeft * fmsLeadingKernel vacuum G = fmsLeadingKernel vacuum K ∧
      fmsLeadingKernel vacuum G * ARight = fmsLeadingKernel vacuum K := by
  dsimp
  obtain ⟨hLeft, hRight⟩ :=
    strictPast_curvedHiggs_two_sided_resolvent
      C weight bareMassSq xi curvature vertexMeasure
  constructor
  · exact fmsLeadingKernel_resolvent vacuum _ _ _ hLeft
  · unfold fmsLeadingKernel
    rw [Matrix.smul_mul, hRight]

/-- At nonzero vacuum, the leading gauge-invariant curved kernel has exactly
the same entrywise causal support as the elementary curved response. -/
theorem strictPast_fmsLeading_curved_entry_eq_zero_iff
    (vacuum : N -> Complex) (hVacuum : vacuum ≠ 0)
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (bareMassSq xi : Real) (curvature vertexMeasure : V -> Real) (i j : V) :
    fmsLeadingKernel vacuum
        (HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
          (weightedPastKernelMatrix C weight)
          (effectiveMassMatrix bareMassSq xi curvature vertexMeasure)
          (Fintype.card V)) i j = 0 ↔
      HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
          (weightedPastKernelMatrix C weight)
          (effectiveMassMatrix bareMassSq xi curvature vertexMeasure)
          (Fintype.card V) i j = 0 := by
  exact fmsLeadingKernel_entry_eq_zero_iff vacuum _ hVacuum i j

/-- Exact gauge-invariant nonconstant-curvature three-event control. The
primitive endpoint entry vanishes, the elementary curved response is `-9`,
and its leading one-component FMS response is `-36`. -/
theorem threeLink_fmsLeading_curved_intermediate_witness :
    fmsRadialResidue (oneComponentVacuum 1) = 4 ∧
      fmsLeadingKernel (oneComponentVacuum 1) threeLinkKernel 2 0 = 0 ∧
      HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries threeLinkKernel
          (effectiveMassMatrix 1 1 threeLinkCurvature threeLinkMeasure)
          3 2 0 = -9 ∧
      fmsLeadingKernel (oneComponentVacuum 1)
          (HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
            threeLinkKernel
            (effectiveMassMatrix 1 1 threeLinkCurvature threeLinkMeasure) 3)
          2 0 = -36 := by
  obtain ⟨hPrimitive, _, hCurved⟩ := threeLink_curved_intermediate_witness
  refine ⟨by norm_num [oneComponent_fmsRadialResidue_eq], ?_, hCurved, ?_⟩
  · simp [fmsLeadingKernel, hPrimitive]
  · change fmsRadialResidue (oneComponentVacuum 1) *
      HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries threeLinkKernel
        (effectiveMassMatrix 1 1 threeLinkCurvature threeLinkMeasure)
        3 2 0 = -36
    rw [oneComponent_fmsRadialResidue_eq, hCurved]
    norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantCurvedPropagation.strictPast_fmsLeading_curved_two_sided_resolvent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictPast_fmsLeading_curved_two_sided_resolvent

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantCurvedPropagation.threeLink_fmsLeading_curved_intermediate_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms threeLink_fmsLeading_curved_intermediate_witness

end PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantCurvedPropagation

end
