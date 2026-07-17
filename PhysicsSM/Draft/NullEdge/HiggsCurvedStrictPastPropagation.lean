import PhysicsSM.Draft.NullEdge.HiggsCurvatureConventionBridge
import PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent

/-!
# Curvature-dependent strict-past Higgs propagation

This module lets the local scalar insertion vary over a finite strict order as

```text
M_xx = (bareMassSq + xi * curvature x) * vertexMeasure x.
```

The diagonal profile still preserves strict-past support in both insertion
orders. It is therefore nilpotent at the event-cardinality power and produces
an exact two-sided finite measured resolvent. A three-event control with
nonconstant supplied curvature changes the endpoint amplitude from the flat
nonuniform control's `-3` to `-9` while leaving the direct endpoint hop zero.

This is finite conditional algebra. Curvature, measure, primitive kernel,
bare mass, and coupling are supplied. The result does not derive a graph
curvature, select a physical coupling, prove a continuum curved-space scalar
equation, or predict a Higgs pole mass.

Provenance: project-internal composition of the curvature-profile and
strict-past measured-resolvent modules. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsCurvedStrictPastPropagation

open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
open PhysicsSM.Draft.NullEdge.HiggsCurvatureMassIdentifiability
open PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries
open PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent

variable {V : Type*} [Fintype V] [DecidableEq V]

omit [Fintype V] in
/-- A curvature-dependent effective insertion is the generic measured local
mass matrix with unit scalar prefactor and combined profile-measure weight. -/
theorem effectiveMassMatrix_eq_localMassMatrix
    (bareMassSq xi : Real) (curvature vertexMeasure : V -> Real) :
    effectiveMassMatrix bareMassSq xi curvature vertexMeasure =
      localMassMatrix 1 (fun vertex =>
        effectiveLocalMassSq bareMassSq xi curvature vertex *
          vertexMeasure vertex) := by
  ext i j
  simp [effectiveMassMatrix, localMassMatrix]

/-- Source-side insertion by the curvature-dependent diagonal profile remains
nilpotent on every nonempty finite strict order. -/
theorem kernel_mul_effectiveMassMatrix_pow_card_eq_zero
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (bareMassSq xi : Real) (curvature vertexMeasure : V -> Real) :
    (weightedPastKernelMatrix C weight *
        effectiveMassMatrix bareMassSq xi curvature vertexMeasure) ^
      Fintype.card V = 0 := by
  rw [effectiveMassMatrix_eq_localMassMatrix]
  exact kernel_mul_localMassMatrix_pow_card_eq_zero C weight 1 _

/-- Target-side insertion by the curvature-dependent profile is nilpotent as
well. -/
theorem effectiveMassMatrix_mul_kernel_pow_card_eq_zero
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (bareMassSq xi : Real) (curvature vertexMeasure : V -> Real) :
    (effectiveMassMatrix bareMassSq xi curvature vertexMeasure *
        weightedPastKernelMatrix C weight) ^ Fintype.card V = 0 := by
  rw [effectiveMassMatrix_eq_localMassMatrix]
  exact localMassMatrix_mul_kernel_pow_card_eq_zero C weight 1 _

/-- The curvature-dependent measured Higgs response obeys exact left and right
finite resolvent equations. -/
theorem strictPast_curvedHiggs_two_sided_resolvent
    [Nonempty V] (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (bareMassSq xi : Real) (curvature vertexMeasure : V -> Real) :
    let K := weightedPastKernelMatrix C weight
    let M := effectiveMassMatrix bareMassSq xi curvature vertexMeasure
    let G :=
      HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries K M
        (Fintype.card V)
    (1 + K * M) * G = K ∧ G * (1 + M * K) = K := by
  dsimp
  rw [effectiveMassMatrix_eq_localMassMatrix]
  exact strictPast_measuredSeries_two_sided_resolvent C weight 1 _

/-- Nonconstant curvature used by the explicit three-event control. -/
def threeLinkCurvature : Fin 3 -> Real := ![0, 2, 0]

set_option linter.unusedSimpArgs false in
/-- Exact curved three-event control. The primitive endpoint remains zero;
the intermediate effective profile is `1 + 2 = 3`, and with intermediate
measure `3` the endpoint response is `-9`. -/
theorem threeLink_curved_intermediate_witness :
    threeLinkKernel 2 0 = 0 ∧
      effectiveMassMatrix 1 1 threeLinkCurvature threeLinkMeasure =
        localMassMatrix 1 ![(2 : Real), 9, 5] ∧
      HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries threeLinkKernel
          (effectiveMassMatrix 1 1 threeLinkCurvature threeLinkMeasure)
          3 2 0 = -9 := by
  have hMatrix :
      effectiveMassMatrix 1 1 threeLinkCurvature threeLinkMeasure =
        localMassMatrix 1 ![(2 : Real), 9, 5] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [effectiveMassMatrix, effectiveLocalMassSq,
        threeLinkCurvature, threeLinkMeasure, localMassMatrix]
  refine ⟨rfl, hMatrix, ?_⟩
  rw [hMatrix]
  unfold threeLinkKernel localMassMatrix
    HiggsMeasuredMassRetardedSeries.measuredMassRetardedSeries
  simp +decide [Finset.sum_range_succ, pow_succ', Matrix.mul_apply,
    Fin.sum_univ_succ]
  simp +decide [Matrix.vecMul, Matrix.vecHead, Matrix.vecTail,
    Matrix.mul_apply, Fin.sum_univ_succ]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCurvedStrictPastPropagation.strictPast_curvedHiggs_two_sided_resolvent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictPast_curvedHiggs_two_sided_resolvent

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCurvedStrictPastPropagation.threeLink_curved_intermediate_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms threeLink_curved_intermediate_witness

end PhysicsSM.Draft.NullEdge.HiggsCurvedStrictPastPropagation

end
