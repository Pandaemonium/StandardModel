import PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantCurvedPropagation
import PhysicsSM.Draft.NullEdge.MassiveRetardedLinkSeries

/-!
# Strict-past support of finite Higgs responses

This module proves the entrywise causal-support statement that complements the
finite Higgs resolvent identities. A matrix is supported in a supplied strict
past when its target-source entry vanishes unless the source strictly precedes
the target. Such support is preserved by matrix multiplication because the
relation is transitive, and by scalar multiplication and finite sums.

Consequently all of the following are supported in the same supplied strict
past:

1. the primitive weighted kernel;
2. the uniform massive retarded series;
3. the nonuniform measured-mass series;
4. the curvature-dependent Higgs series; and
5. its leading gauge-invariant FMS radial lift.

This is stronger than nilpotence or a resolvent identity alone: it states
exactly where every response matrix must vanish. It still does not select the
primitive weights, prove they arise from null links, or establish a continuum
light-cone theorem. Claim grade: `M [orig/comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsStrictPastCausalSupport

open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
open PhysicsSM.Draft.NullEdge.HiggsCurvatureMassIdentifiability
open PhysicsSM.Draft.NullEdge.HiggsCurvedStrictPastPropagation
open PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable
open PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries
open PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent
open PhysicsSM.Draft.NullEdge.MassiveRetardedLinkSeries

variable {V : Type*} [Fintype V]

/-- A target-source response matrix is supported in the strict past when an
entry vanishes unless the source strictly precedes the target. -/
def MatrixSupportedInStrictPast
    (C : FiniteStrictRelation V) (A : Matrix V V Real) : Prop :=
  forall target source, Not (C.before source target) -> A target source = 0

/-- Products of two strict-past-supported matrices remain supported there. -/
theorem matrixSupportedInStrictPast_mul
    (C : FiniteStrictRelation V) {A B : Matrix V V Real}
    (hA : MatrixSupportedInStrictPast C A)
    (hB : MatrixSupportedInStrictPast C B) :
    MatrixSupportedInStrictPast C (A * B) := by
  classical
  intro target source hNot
  rw [Matrix.mul_apply]
  apply Finset.sum_eq_zero
  intro middle hMiddle
  by_cases hSource : C.before source middle
  · by_cases hTarget : C.before middle target
    · exact False.elim (hNot (C.transitive hSource hTarget))
    · rw [hA target middle hTarget, zero_mul]
  · rw [hB middle source hSource, mul_zero]

/-- Scalar multiplication does not enlarge strict-past support. -/
theorem matrixSupportedInStrictPast_smul
    (C : FiniteStrictRelation V) {A : Matrix V V Real}
    (r : Real) (hA : MatrixSupportedInStrictPast C A) :
    MatrixSupportedInStrictPast C (r • A) := by
  intro target source hNot
  simp [hA target source hNot]

/-- A finite sum of matrices with common strict-past support retains that
support. -/
theorem matrixSupportedInStrictPast_sum
    {I : Type*} (C : FiniteStrictRelation V) (s : Finset I)
    (A : I -> Matrix V V Real)
    (hA : forall i, i ∈ s -> MatrixSupportedInStrictPast C (A i)) :
    MatrixSupportedInStrictPast C (∑ i ∈ s, A i) := by
  intro target source hNot
  simp only [Matrix.sum_apply]
  apply Finset.sum_eq_zero
  intro i hi
  exact hA i hi target source hNot

variable [DecidableEq V]

/-- Every positive power of a strict-past-supported matrix remains supported
in the same transitive strict past. -/
theorem matrixSupportedInStrictPast_pow_succ
    (C : FiniteStrictRelation V) {A : Matrix V V Real}
    (hA : MatrixSupportedInStrictPast C A) (n : Nat) :
    MatrixSupportedInStrictPast C (A ^ (n + 1)) := by
  induction n with
  | zero => simpa using hA
  | succ n ih =>
      rw [Nat.succ_add, pow_succ]
      exact matrixSupportedInStrictPast_mul C ih hA

/-- The primitive weighted strict-past matrix has the advertised entrywise
support. -/
theorem weightedPastKernelMatrix_supported
    (C : FiniteStrictRelation V) (weight : V -> V -> Real) :
    MatrixSupportedInStrictPast C (weightedPastKernelMatrix C weight) := by
  intro target source hNotBefore
  classical
  have h := congrFun
    (weightedPastKernelMatrix_mulVec C weight
      (fun x => if x = source then 1 else 0)) target
  simp [Matrix.mulVec, dotProduct, weightedPastOperator] at h
  rw [h]
  apply Finset.sum_eq_zero
  intro x hx
  by_cases hxs : x = source
  · subst x
    simp [hNotBefore]
  · simp [hxs]

/-- The uniform massive retarded series has no entry outside the supplied
strict-past relation. -/
theorem strictPast_massiveRetardedSeries_supported
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (H : Nat) :
    MatrixSupportedInStrictPast C
      (massiveRetardedSeries
        (weightedPastKernelMatrix C weight) massSq H) := by
  unfold massiveRetardedSeries
  apply matrixSupportedInStrictPast_sum C (Finset.range H) _
  intro k hk
  exact matrixSupportedInStrictPast_smul C _
    (matrixSupportedInStrictPast_pow_succ C
      (weightedPastKernelMatrix_supported C weight) k)

/-- A measured local diagonal insertion changes strict-past amplitudes but
does not enlarge support. -/
theorem strictPast_measuredMassRetardedSeries_supported
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) (H : Nat) :
    MatrixSupportedInStrictPast C
      (HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
        (weightedPastKernelMatrix C weight)
        (localMassMatrix massSq vertexMeasure) H) := by
  let K := weightedPastKernelMatrix C weight
  let M := localMassMatrix massSq vertexMeasure
  have hK : MatrixSupportedInStrictPast C K :=
    weightedPastKernelMatrix_supported C weight
  have hKM : MatrixSupportedInStrictPast C (K * M) := by
    dsimp [K, M]
    rw [weightedPastKernelMatrix_mul_localMassMatrix]
    exact weightedPastKernelMatrix_supported C _
  have hTerm : forall k : Nat,
      MatrixSupportedInStrictPast C ((K * M) ^ k * K) := by
    intro k
    induction k with
    | zero => simpa using hK
    | succ k ih =>
        rw [pow_succ', mul_assoc]
        exact matrixSupportedInStrictPast_mul C hKM ih
  unfold HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
  apply matrixSupportedInStrictPast_sum C (Finset.range H) _
  intro k hk
  exact matrixSupportedInStrictPast_smul C _ (hTerm k)

/-- The curvature-dependent measured Higgs response remains supported in the
same strict past for every supplied curvature and measure profile. -/
theorem strictPast_curvedHiggsSeries_supported
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (bareMassSq xi : Real) (curvature vertexMeasure : V -> Real) (H : Nat) :
    MatrixSupportedInStrictPast C
      (HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
        (weightedPastKernelMatrix C weight)
        (effectiveMassMatrix bareMassSq xi curvature vertexMeasure) H) := by
  rw [effectiveMassMatrix_eq_localMassMatrix]
  exact strictPast_measuredMassRetardedSeries_supported
    C weight 1 _ H

/-- The leading gauge-invariant FMS radial lift of the curved response has no
entry outside the supplied strict past. -/
theorem strictPast_fmsLeading_curvedSeries_supported
    {N : Type*} [Fintype N] (vacuum : N -> Complex)
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (bareMassSq xi : Real) (curvature vertexMeasure : V -> Real) (H : Nat) :
    MatrixSupportedInStrictPast C
      (fmsLeadingKernel vacuum
        (HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
          (weightedPastKernelMatrix C weight)
          (effectiveMassMatrix bareMassSq xi curvature vertexMeasure) H)) := by
  unfold fmsLeadingKernel
  exact matrixSupportedInStrictPast_smul C _
    (strictPast_curvedHiggsSeries_supported
      C weight bareMassSq xi curvature vertexMeasure H)

/-- Entrywise headline form: if the source does not strictly precede the
target, the leading gauge-invariant curved Higgs response is exactly zero. -/
theorem strictPast_fmsLeading_curvedSeries_eq_zero_of_not_before
    {N : Type*} [Fintype N] (vacuum : N -> Complex)
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (bareMassSq xi : Real) (curvature vertexMeasure : V -> Real) (H : Nat)
    (target source : V) (hNotBefore : Not (C.before source target)) :
    fmsLeadingKernel vacuum
        (HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
          (weightedPastKernelMatrix C weight)
          (effectiveMassMatrix bareMassSq xi curvature vertexMeasure) H)
        target source = 0 := by
  exact strictPast_fmsLeading_curvedSeries_supported vacuum C weight
    bareMassSq xi curvature vertexMeasure H target source hNotBefore

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsStrictPastCausalSupport.weightedPastKernelMatrix_supported' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weightedPastKernelMatrix_supported

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsStrictPastCausalSupport.strictPast_measuredMassRetardedSeries_supported' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictPast_measuredMassRetardedSeries_supported

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsStrictPastCausalSupport.strictPast_fmsLeading_curvedSeries_eq_zero_of_not_before' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictPast_fmsLeading_curvedSeries_eq_zero_of_not_before

end PhysicsSM.Draft.NullEdge.HiggsStrictPastCausalSupport

end
