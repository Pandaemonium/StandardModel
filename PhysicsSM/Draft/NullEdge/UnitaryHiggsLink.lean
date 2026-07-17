import Mathlib

/-!
# Generic finite unitary Higgs link algebra

This module generalizes the one-component Abelian control to a complex finite
multiplet acted on by a `U(n)` edge connection. It proves the exact finite gauge
algebra: unitary preservation of the component norm, endpoint covariance of the
transported difference, invariance of arbitrary real weighted link kinetics,
and zero kinetic cost for parallel sections.

This is not yet the Standard Model electroweak doublet representation. It does
not construct an `SU(2) x U(1)` embedding, a scalar potential, electroweak
vacuum, gauge-boson mass matrix, stress tensor, or continuum propagator. The
five finite proofs were produced by Aristotle project
`49e42dc1-40d2-44e2-8183-760dc7d62b61`, replayed under the pinned toolchain,
and ported here without statement weakening. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.UnitaryHiggsLink

open scoped BigOperators

variable {N V E : Type*} [Fintype N] [DecidableEq N] [Fintype E]

/-- Component norm squared of a finite complex multiplet. -/
def vectorNormSq (v : N -> Complex) : Real :=
  ∑ i, Complex.normSq (v i)

/-- Gauge-covariant endpoint difference on one directed edge. -/
def covariantDifference
    (s t : E -> V) (phi : V -> N -> Complex)
    (U : E -> Matrix.unitaryGroup N Complex) (e : E) : N -> Complex :=
  Matrix.mulVec (U e : Matrix N N Complex) (phi (t e)) - phi (s e)

/-- Local unitary transformation of a vertex multiplet. -/
def gaugeTransformField
    (g : V -> Matrix.unitaryGroup N Complex)
    (phi : V -> N -> Complex) : V -> N -> Complex :=
  fun x => Matrix.mulVec (g x : Matrix N N Complex) (phi x)

/-- Endpoint transformation of a directed-edge unitary connection. -/
def gaugeTransformConnection
    (s t : E -> V) (g : V -> Matrix.unitaryGroup N Complex)
    (U : E -> Matrix.unitaryGroup N Complex) :
    E -> Matrix.unitaryGroup N Complex :=
  fun e => g (s e) * U e * (g (t e))⁻¹

/-- Weighted finite kinetic functional for a complex unitary multiplet. -/
def weightedKinetic
    (s t : E -> V) (edgeWeight : E -> Real)
    (phi : V -> N -> Complex)
    (U : E -> Matrix.unitaryGroup N Complex) : Real :=
  ∑ e, edgeWeight e * vectorNormSq (covariantDifference s t phi U e)

/-- A unitary matrix preserves the finite component norm squared. -/
theorem vectorNormSq_unitary
    (g : Matrix.unitaryGroup N Complex) (v : N -> Complex) :
    vectorNormSq (Matrix.mulVec (g : Matrix N N Complex) v) = vectorNormSq v := by
  have hUnitary : g.val.conjTranspose * g.val = 1 := g.2.1
  have hInnerProduct :
      ∑ i, (g.val.mulVec v i) * starRingEnd ℂ (g.val.mulVec v i) =
        ∑ i, starRingEnd ℂ (v i) *
          (∑ j, g.val.conjTranspose i j * (g.val.mulVec v) j) := by
    simp +decide [Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, mul_assoc,
      mul_comm, mul_left_comm]
    simp +decide only [Finset.sum_mul, mul_assoc]
    rw [Finset.sum_comm]
  have hMulVec : forall i,
      ∑ j, g.val.conjTranspose i j * (g.val.mulVec v) j = v i := by
    intro i
    have hProduct :
        ∑ j, g.val.conjTranspose i j * (g.val.mulVec v) j =
          (g.val.conjTranspose * g.val).mulVec v i := by
      simp +decide [Matrix.mulVec, dotProduct]
      simp +decide [Matrix.mul_apply, Finset.mul_sum _ _ _]
      exact Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ => by
        rw [Finset.sum_mul _ _ _]
        exact Finset.sum_congr rfl fun _ _ => by ring)
    aesop
  simp +decide [vectorNormSq]
  simp_all +decide [Complex.normSq, Complex.ext_iff]

omit [Fintype E] in
/-- Every multiplet edge difference transforms only at its source endpoint. -/
theorem covariantDifference_gauge_transform
    (s t : E -> V) (phi : V -> N -> Complex)
    (U : E -> Matrix.unitaryGroup N Complex)
    (g : V -> Matrix.unitaryGroup N Complex) (e : E) :
    covariantDifference s t (gaugeTransformField g phi)
        (gaugeTransformConnection s t g U) e =
      Matrix.mulVec (g (s e) : Matrix N N Complex)
        (covariantDifference s t phi U e) := by
  unfold covariantDifference gaugeTransformField gaugeTransformConnection
  simp +decide [Matrix.mulVec_sub, Matrix.mul_assoc]

/-- Arbitrary fixed real edge weights preserve local unitary gauge
invariance. -/
theorem weightedKinetic_gauge_invariant
    (s t : E -> V) (edgeWeight : E -> Real)
    (phi : V -> N -> Complex)
    (U : E -> Matrix.unitaryGroup N Complex)
    (g : V -> Matrix.unitaryGroup N Complex) :
    weightedKinetic s t edgeWeight (gaugeTransformField g phi)
        (gaugeTransformConnection s t g U) =
      weightedKinetic s t edgeWeight phi U := by
  refine Finset.sum_congr rfl ?_
  intro e _
  rw [covariantDifference_gauge_transform s t phi U g e, vectorNormSq_unitary]

/-- Every covariantly constant section has zero weighted edge kinetic cost. -/
theorem weightedKinetic_eq_zero_of_parallel
    (s t : E -> V) (edgeWeight : E -> Real)
    (phi : V -> N -> Complex)
    (U : E -> Matrix.unitaryGroup N Complex)
    (hParallel : forall e,
      Matrix.mulVec (U e : Matrix N N Complex) (phi (t e)) = phi (s e)) :
    weightedKinetic s t edgeWeight phi U = 0 := by
  unfold weightedKinetic covariantDifference vectorNormSq
  aesop

/-- A vacuum obtained by transporting one fixed multiplet vector with a local
unitary section is parallel and has exactly zero weighted kinetic cost. -/
theorem weightedKinetic_groupGeneratedVacuum_zero
    (s t : E -> V) (edgeWeight : E -> Real)
    (sigma : V -> Matrix.unitaryGroup N Complex)
    (vacuumVector : N -> Complex) :
    weightedKinetic s t edgeWeight
        (fun x => Matrix.mulVec (sigma x : Matrix N N Complex) vacuumVector)
        (fun e => sigma (s e) * (sigma (t e))⁻¹) = 0 := by
  apply weightedKinetic_eq_zero_of_parallel
  intro e
  have hUnitary := (sigma (t e)).2
  simp_all +decide [Matrix.mul_assoc, Matrix.mulVec_mulVec]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryHiggsLink.vectorNormSq_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms vectorNormSq_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryHiggsLink.covariantDifference_gauge_transform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms covariantDifference_gauge_transform

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryHiggsLink.weightedKinetic_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weightedKinetic_gauge_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryHiggsLink.weightedKinetic_eq_zero_of_parallel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weightedKinetic_eq_zero_of_parallel

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryHiggsLink.weightedKinetic_groupGeneratedVacuum_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weightedKinetic_groupGeneratedVacuum_zero

end PhysicsSM.Draft.NullEdge.UnitaryHiggsLink

end
