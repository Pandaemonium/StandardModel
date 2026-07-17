import PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence

/-!
# Matrix form of finite strict-past nilpotence

`FiniteStrictPastNilpotence` proves nilpotence for a weighted causal-past
linear operator. Finite Green-series calculations are naturally stated for
matrices. This module transports that result through the standard function
basis and proves that the resulting matrix acts on samples exactly as the
original strict-past operator.

This is finite order algebra. It does not choose physical edge weights,
construct a continuum Green function, or prove a continuum limit.

Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix

open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Standard-basis matrix of a weighted strict-past operator. Matrix rows are
targets and columns are sources. -/
def weightedPastKernelMatrix
    (C : FiniteStrictRelation V) (weight : V -> V -> Real) :
    Matrix V V Real :=
  LinearMap.toMatrix (Pi.basisFun Real V) (Pi.basisFun Real V)
    (weightedPastOperator C weight)

/-- The matrix kernel acts on every sample function exactly as the original
weighted strict-past linear operator. -/
theorem weightedPastKernelMatrix_mulVec
    (C : FiniteStrictRelation V) (weight : V -> V -> Real) (f : V -> Real) :
    (weightedPastKernelMatrix C weight).mulVec f =
      weightedPastOperator C weight f := by
  simp [weightedPastKernelMatrix]

/-- On a nonempty finite strict order, the standard-basis past kernel is
nilpotent by the event-cardinality power. -/
theorem weightedPastKernelMatrix_pow_card_eq_zero
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real) :
    weightedPastKernelMatrix C weight ^ Fintype.card V = 0 := by
  rw [weightedPastKernelMatrix, LinearMap.toMatrix_pow,
    weightedPastOperator_pow_card_eq_zero]
  simp

/-- One further power also vanishes. This is the exponent used by a retarded
series truncated at the event cardinality. -/
theorem weightedPastKernelMatrix_pow_card_add_one_eq_zero
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real) :
    weightedPastKernelMatrix C weight ^ (Fintype.card V + 1) = 0 := by
  rw [pow_succ, weightedPastKernelMatrix_pow_card_eq_zero C weight, zero_mul]

end PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix.weightedPastKernelMatrix_mulVec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix.weightedPastKernelMatrix_mulVec

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix.weightedPastKernelMatrix_pow_card_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix.weightedPastKernelMatrix_pow_card_eq_zero
