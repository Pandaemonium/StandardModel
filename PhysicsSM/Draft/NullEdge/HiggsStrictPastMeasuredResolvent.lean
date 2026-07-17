import PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
import PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries

/-!
# Strict-past measured Higgs resolvent

A diagonal local Higgs mass insertion does not spoil strict-past support. Right
multiplication rescales the source weight of a weighted past kernel, while left
multiplication rescales its target weight. Both insertion orders are therefore
nilpotent at the finite event-cardinality power, and the measured retarded
series satisfies exact left and right resolvent identities without a terminal
remainder.

This is finite order and matrix algebra. It does not select a physical kernel,
derive the vertex measure, prove a continuum Klein--Gordon equation, or predict
a Higgs mass.

Provenance: project-internal composition of
`FiniteStrictPastKernelMatrix.lean` and
`HiggsMeasuredMassRetardedSeries.lean`. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent

open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
open PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Right multiplication by the local mass matrix rescales each strict-past
source weight. -/
theorem weightedPastKernelMatrix_mul_localMassMatrix
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    weightedPastKernelMatrix C weight *
        localMassMatrix massSq vertexMeasure =
      weightedPastKernelMatrix C
        (fun source target =>
          weight source target * (massSq * vertexMeasure source)) := by
  apply Matrix.ext_iff_mulVec.mpr
  intro field
  rw [← Matrix.mulVec_mulVec field]
  rw [weightedPastKernelMatrix_mulVec, weightedPastKernelMatrix_mulVec]
  funext target
  simp [weightedPastOperator, localMassMatrix, Matrix.mulVec_diagonal]
  apply Finset.sum_congr rfl
  intro source _
  split_ifs
  · ring
  · rfl

/-- Left multiplication by the local mass matrix rescales each strict-past
target weight. -/
theorem localMassMatrix_mul_weightedPastKernelMatrix
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    localMassMatrix massSq vertexMeasure *
        weightedPastKernelMatrix C weight =
      weightedPastKernelMatrix C
        (fun source target =>
          (massSq * vertexMeasure target) * weight source target) := by
  apply Matrix.ext_iff_mulVec.mpr
  intro field
  rw [← Matrix.mulVec_mulVec field]
  rw [weightedPastKernelMatrix_mulVec, weightedPastKernelMatrix_mulVec]
  funext target
  simp [weightedPastOperator, localMassMatrix, Matrix.mulVec_diagonal,
    Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro source _
  split_ifs
  · ring
  · rfl

/-- The source-measured insertion order remains strict-past and nilpotent. -/
theorem kernel_mul_localMassMatrix_pow_card_eq_zero
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    (weightedPastKernelMatrix C weight *
        localMassMatrix massSq vertexMeasure) ^ Fintype.card V = 0 := by
  rw [weightedPastKernelMatrix_mul_localMassMatrix]
  exact weightedPastKernelMatrix_pow_card_eq_zero C _

/-- The target-measured insertion order remains strict-past and nilpotent. -/
theorem localMassMatrix_mul_kernel_pow_card_eq_zero
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    (localMassMatrix massSq vertexMeasure *
        weightedPastKernelMatrix C weight) ^ Fintype.card V = 0 := by
  rw [localMassMatrix_mul_weightedPastKernelMatrix]
  exact weightedPastKernelMatrix_pow_card_eq_zero C _

/-- The measured Higgs series is an exact left finite resolvent on every
nonempty finite strict order. -/
theorem strictPast_measuredSeries_left_resolvent
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    (1 + weightedPastKernelMatrix C weight *
        localMassMatrix massSq vertexMeasure) *
      measuredMassRetardedSeries
        (weightedPastKernelMatrix C weight)
        (localMassMatrix massSq vertexMeasure) (Fintype.card V) =
      weightedPastKernelMatrix C weight := by
  exact one_add_kernel_mass_mul_series_of_nilpotent _ _ _
    (kernel_mul_localMassMatrix_pow_card_eq_zero C weight massSq vertexMeasure)

/-- The same measured Higgs series is an exact right finite resolvent. -/
theorem strictPast_measuredSeries_right_resolvent
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    measuredMassRetardedSeries
        (weightedPastKernelMatrix C weight)
        (localMassMatrix massSq vertexMeasure) (Fintype.card V) *
      (1 + localMassMatrix massSq vertexMeasure *
        weightedPastKernelMatrix C weight) =
      weightedPastKernelMatrix C weight := by
  exact series_mul_one_add_mass_kernel_of_nilpotent _ _ _
    (localMassMatrix_mul_kernel_pow_card_eq_zero C weight massSq vertexMeasure)

/-- Both exact finite resolvent equations hold for one measured strict-past
Higgs propagator. -/
theorem strictPast_measuredSeries_two_sided_resolvent
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    (1 + weightedPastKernelMatrix C weight *
        localMassMatrix massSq vertexMeasure) *
        measuredMassRetardedSeries
          (weightedPastKernelMatrix C weight)
          (localMassMatrix massSq vertexMeasure) (Fintype.card V) =
        weightedPastKernelMatrix C weight ∧
      measuredMassRetardedSeries
          (weightedPastKernelMatrix C weight)
          (localMassMatrix massSq vertexMeasure) (Fintype.card V) *
        (1 + localMassMatrix massSq vertexMeasure *
          weightedPastKernelMatrix C weight) =
        weightedPastKernelMatrix C weight := by
  exact ⟨strictPast_measuredSeries_left_resolvent C weight massSq vertexMeasure,
    strictPast_measuredSeries_right_resolvent C weight massSq vertexMeasure⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent.kernel_mul_localMassMatrix_pow_card_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kernel_mul_localMassMatrix_pow_card_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent.strictPast_measuredSeries_two_sided_resolvent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictPast_measuredSeries_two_sided_resolvent

end PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent

end
