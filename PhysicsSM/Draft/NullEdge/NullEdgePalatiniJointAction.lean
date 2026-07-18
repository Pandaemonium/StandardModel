import PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein
import PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation

/-!
# Joint null-edge Palatini action

This module composes the two previously separate finite variation channels:

1. aggregate null-edge weights vary the coframe determinant and inverse
   metric with full symmetric metric reach;
2. an independent directed connection varies the Ricci contraction through
   the exact finite curvature formula.

The resulting displayed action is a genuine function of both fields.  At the
null-edge Levi-Civita base connection, its aggregate-weight partial
stationarity is equivalent to the finite Einstein equation.  Its independent
connection partial stationarity is equivalent to vanishing of the explicit
Palatini connection response derived in
`FiniteDirectedPalatiniConnectionVariation`.

This closes the bookkeeping gap between the metric and connection channels,
but not the principal dynamical gap.  A general theorem identifying the
finite connection equation with metric compatibility and the null-edge
Levi-Civita connection remains open.  The periodic flat canonical chart is an
exact stationary control.  The inverse-metric chart and matter term retain the
first-order architecture of `FinitePalatiniCoframeChartAction`; no continuum
or refinement claim is made.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.NullEdgePalatiniJointAction

open scoped BigOperators

open Matrix
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open FiniteEinsteinHilbertActionResponse
open CoframeVolumeMetricVariation
open FinitePalatiniCoframeChartAction
open NullEdgeCoframeEinsteinBridge
open DirectedNullEdgeLeviCivitaEinstein
open NullEdgeAggregateCoframeEinstein
open FiniteDirectedPalatiniConnectionVariation

variable {Site : Type*} [Fintype Site]

/-- Scalar curvature chart obtained by contracting the Ricci tensor of an
independent directed connection with the aggregate-generated inverse metric.
-/
def jointScalarCurvature
    (chart : DirectedNullEdgeChart Site)
    (connection : DirectedConnection Site)
    (generator : LocalTensor (Site := Site)) : Site -> Real :=
  fun site =>
    metricVariationPairing
      (connectionRawRicci chart.target connection site)
      (chartInverseMetric
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
        generator site)

/-- Finite two-field Palatini action in aggregate coframe generators and an
independent directed connection. -/
def nullEdgePalatiniJointAction
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (generator : LocalTensor (Site := Site))
    (connection : DirectedConnection Site) : Real :=
  (1 / (2 * kappa)) *
      finiteEinsteinHilbertBulk
        (chartVolume (nullEdgeCoframe chart.edges) generator)
        (jointScalarCurvature chart connection generator)
        cosmologicalConstant +
    chartMatterAction (nullEdgeCoframe chart.edges)
      (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
      stress generator

/-! ## Metric partial equation -/

omit [Fintype Site] in
/-- The aggregate inverse-metric chart remains symmetric at every parameter
value. -/
theorem chartInverseMetric_nullEdge_isSymm
    (chart : DirectedNullEdgeChart Site)
    (generator : LocalTensor (Site := Site)) (site : Site) :
    (chartInverseMetric
      (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
      generator site).IsSymm := by
  unfold chartInverseMetric localInverseMetricVariation
  exact
    (nullEdgeInverseMetric_symmetric
      chart.toNondegenerateNullEdgeFrame site).add
      (inverseMetricVariation_isSymm
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site)
        (generator site)
        (nullEdgeInverseMetric_symmetric
          chart.toNondegenerateNullEdgeFrame site))

omit [Fintype Site] in
/-- At the null-edge Levi-Civita connection, the joint scalar curvature is
exactly the fixed-connection scalar chart already used in the aggregate
Einstein theorem. -/
theorem jointScalarCurvature_nullEdgeChristoffel
    (chart : DirectedNullEdgeChart Site)
    (generator : LocalTensor (Site := Site)) :
    jointScalarCurvature chart (nullEdgeChristoffel chart) generator =
      chartScalarCurvature (nullEdgeSymmetricRicci chart)
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
        generator := by
  funext site
  unfold jointScalarCurvature chartScalarCurvature
  rw [connectionRawRicci_nullEdgeChristoffel]
  exact
    (metricVariationPairing_symmetricPart
      (nullEdgeRawRicci chart site)
      (chartInverseMetric
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
        generator site)
      (chartInverseMetric_nullEdge_isSymm chart generator site)).symm

/-- Restricting the joint action to the derived null-edge Levi-Civita
connection recovers the aggregate null-edge action exactly. -/
theorem nullEdgePalatiniJointAction_at_nullEdgeChristoffel
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (generator : LocalTensor (Site := Site)) :
    nullEdgePalatiniJointAction kappa chart stress cosmologicalConstant
        generator (nullEdgeChristoffel chart) =
      aggregateNullEdgeAction kappa chart stress cosmologicalConstant
        generator := by
  unfold nullEdgePalatiniJointAction aggregateNullEdgeAction
    directedNullEdgeChartAction nullEdgeChartTotalAction chartTotalAction
    chartGravityAction
  rw [jointScalarCurvature_nullEdgeChristoffel]

/-- Partial stationarity of the joint action in aggregate-weight directions.
-/
def JointMetricStationary
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (connection : DirectedConnection Site) : Prop :=
  ParameterStationary
    (fun generator =>
      nullEdgePalatiniJointAction kappa chart stress cosmologicalConstant
        generator connection) 0

/-- **Metric partial of the joint Palatini action.**  At the derived
null-edge Levi-Civita connection, aggregate-weight stationarity is equivalent
to the pointwise finite Einstein equation. -/
theorem jointMetricStationary_nullEdgeChristoffel_iff_einstein
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    JointMetricStationary kappa chart stress cosmologicalConstant
        (nullEdgeChristoffel chart) <->
      LocalFiniteEinsteinEquation kappa
        (nullEdgeSymmetricRicci chart)
        (directedNullEdgeScalarCurvature chart)
        (nullEdgeMetric chart.edges) cosmologicalConstant stress := by
  have hAction :
      (fun generator =>
        nullEdgePalatiniJointAction kappa chart stress cosmologicalConstant
          generator (nullEdgeChristoffel chart)) =
        aggregateNullEdgeAction kappa chart stress cosmologicalConstant := by
    funext generator
    exact nullEdgePalatiniJointAction_at_nullEdgeChristoffel kappa chart stress
      cosmologicalConstant generator
  unfold JointMetricStationary
  rw [hAction]
  exact aggregateNullEdgeAction_stationary_iff_einstein kappa chart stress
    cosmologicalConstant hStress hKappa

/-! ## Connection partial equation -/

/-- Partial stationarity of the joint action in independent connection
directions, with the aggregate generator held fixed at the chart origin. -/
def JointConnectionStationary
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (connection : DirectedConnection Site) : Prop :=
  forall variation : DirectedConnection Site,
    HasDerivAt
      (fun t : Real =>
        nullEdgePalatiniJointAction kappa chart stress cosmologicalConstant 0
          (connectionLine connection variation t)) 0 0

/-- The connection derivative of the joint action is the normalized explicit
Palatini connection response. -/
theorem nullEdgePalatiniJointAction_connectionDirectionalDerivative
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (connection variation : DirectedConnection Site) :
    HasDerivAt
      (fun t : Real =>
        nullEdgePalatiniJointAction kappa chart stress cosmologicalConstant 0
          (connectionLine connection variation t))
      ((1 / (2 * kappa)) *
        directedPalatiniConnectionResponse chart.target
          (chartBaseVolume (nullEdgeCoframe chart.edges))
          (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
          connection variation) 0 := by
  have hGravity :
      HasDerivAt
        (fun t : Real =>
          (1 / (2 * kappa)) *
            finiteEinsteinHilbertBulk
              (chartVolume (nullEdgeCoframe chart.edges) 0)
              (jointScalarCurvature chart
                (connectionLine connection variation t) 0)
              cosmologicalConstant)
        ((1 / (2 * kappa)) *
          directedPalatiniConnectionResponse chart.target
            (chartBaseVolume (nullEdgeCoframe chart.edges))
            (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
            connection variation) 0 := by
    unfold finiteEinsteinHilbertBulk
    apply HasDerivAt.const_mul
    apply HasDerivAt.fun_sum
    intro site _
    have hScalar :
        HasDerivAt
          (fun t : Real =>
            jointScalarCurvature chart
              (connectionLine connection variation t) 0 site)
          (metricVariationPairing
            (connectionRawRicciFirstVariation chart.target connection variation
              site)
            (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site)) 0 := by
      simpa [jointScalarCurvature, chartInverseMetric,
        localInverseMetricVariation, inverseMetricVariation] using
        hasDerivAt_connectionRawRicciPairing_line chart.target
          (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
          connection variation site
    have hVolume := hasDerivAt_const (x := (0 : Real))
      (chartVolume (nullEdgeCoframe chart.edges) 0 site)
    convert hVolume.mul (hScalar.sub_const (2 * cosmologicalConstant)) using 1
    all_goals simp [chartVolume, chartBaseVolume]
  have hMatter := hasDerivAt_const (x := (0 : Real))
    (chartMatterAction (nullEdgeCoframe chart.edges)
      (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame) stress 0)
  unfold nullEdgePalatiniJointAction
  convert hGravity.add hMatter using 1
  all_goals simp

/-- **Connection partial of the joint Palatini action.**  For nonzero
gravitational coupling, connection stationarity is equivalent to vanishing of
the exact finite Palatini connection functional. -/
theorem jointConnectionStationary_iff_eulerLagrange
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (connection : DirectedConnection Site)
    (hKappa : Not (kappa = 0)) :
    JointConnectionStationary kappa chart stress cosmologicalConstant
        connection <->
      ConnectionEulerLagrange chart.target
        (chartBaseVolume (nullEdgeCoframe chart.edges))
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
        connection := by
  constructor
  · intro hStationary variation
    have hUnique :=
      (nullEdgePalatiniJointAction_connectionDirectionalDerivative kappa chart
        stress cosmologicalConstant connection variation).unique
        (hStationary variation)
    have hScale : (1 / (2 * kappa) : Real) ≠ 0 := by
      exact one_div_ne_zero (mul_ne_zero (by norm_num) hKappa)
    exact (mul_eq_zero.mp hUnique).resolve_left hScale
  · intro hEuler variation
    simpa [hEuler variation] using
      nullEdgePalatiniJointAction_connectionDirectionalDerivative kappa chart
        stress cosmologicalConstant connection variation

/-! ## Two-field endpoint -/

/-- Both partial stationarity equations of the joint finite Palatini action at
the null-edge Levi-Civita base connection. -/
def JointPalatiniStationary
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) : Prop :=
  JointMetricStationary kappa chart stress cosmologicalConstant
      (nullEdgeChristoffel chart) /\
    JointConnectionStationary kappa chart stress cosmologicalConstant
      (nullEdgeChristoffel chart)

/-- **Joint finite null-edge Palatini endpoint.**  The two partial
Euler-Lagrange equations are exactly the finite Einstein equation and the
independent finite connection equation. -/
theorem jointPalatiniStationary_iff_fieldEquations
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    JointPalatiniStationary kappa chart stress cosmologicalConstant <->
      LocalFiniteEinsteinEquation kappa
          (nullEdgeSymmetricRicci chart)
          (directedNullEdgeScalarCurvature chart)
          (nullEdgeMetric chart.edges) cosmologicalConstant stress /\
        ConnectionEulerLagrange chart.target
          (chartBaseVolume (nullEdgeCoframe chart.edges))
          (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
          (nullEdgeChristoffel chart) := by
  unfold JointPalatiniStationary
  rw [jointMetricStationary_nullEdgeChristoffel_iff_einstein kappa chart stress
    cosmologicalConstant hStress hKappa]
  rw [jointConnectionStationary_iff_eulerLagrange kappa chart stress
    cosmologicalConstant (nullEdgeChristoffel chart) hKappa]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgePalatiniJointAction.nullEdgePalatiniJointAction_at_nullEdgeChristoffel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgePalatiniJointAction_at_nullEdgeChristoffel

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgePalatiniJointAction.nullEdgePalatiniJointAction_connectionDirectionalDerivative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgePalatiniJointAction_connectionDirectionalDerivative

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgePalatiniJointAction.jointPalatiniStationary_iff_fieldEquations' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms jointPalatiniStationary_iff_fieldEquations

end PhysicsSM.Draft.NullEdge.NullEdgePalatiniJointAction
