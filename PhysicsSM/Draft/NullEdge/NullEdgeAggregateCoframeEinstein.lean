import PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein

/-!
# Aggregate null-edge coframes and Einstein variation

Four primitive null edges cannot remain null while generating all ten metric
variations: their Gram tangent has zero diagonal.  The physically natural
completion is to distinguish primitive propagation edges from coframe
directions.  A coframe direction may be an aggregate of primitive null edges.

For a nondegenerate null-edge coframe `E` and aggregate-weight matrix `A`, set

```text
e(A) = E A.
```

Every column of `e(A)` is a linear combination of the four soldered null-edge
vectors.  Since `E` is invertible, `A |-> E A` is a bijection onto all real
coframes, with inverse `C |-> E^{-1} C`.  The existing action path
`E (1 + t X)` is therefore exactly a path of null-edge aggregate weights, not
an unexplained coframe perturbation.

The induced inverse-metric tangent is

```text
h(X) = -(X gInv + gInv X^T).
```

It reaches every symmetric metric variation.  The explicit metric-active
generator is `X = -(1/2) h g`; generators of the form `K g`, with `K` skew,
are metric-invisible frame-gauge directions.  This supplies a precise escape
from the null-column tangent no-go while retaining null edges as the primitive
spanning directions.

The final theorem re-expresses the directed-null-edge action endpoint in these
aggregate variables.  It is still a finite first-order Palatini chart: the
aggregate weights have not yet been derived from bare order/count data, the
inverse-metric chart is tangent rather than a global exact inverse, and the
connection equation and continuum limit remain open.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein

open scoped BigOperators

open Matrix
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open LayerWeightMetricRankNoGo
open CoframeVolumeMetricVariation
open FinitePalatiniCoframeChartAction
open NullEdgeCoframeEinsteinBridge
open DirectedNullEdgeLeviCivitaEinstein

/-- Aggregate a primitive coframe with a matrix of edge weights.  The row of
`weights` labels a primitive null edge and the column labels the resulting
coframe direction. -/
def aggregateCoframeAt
    (primitive weights : Tensor (I := Fin 4)) : Tensor (I := Fin 4) :=
  primitive * weights

/-- Sitewise coframe obtained by aggregating one nondegenerate null-edge
frame. -/
def aggregateNullEdgeCoframe {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site)
    (weights : LocalTensor (Site := Site)) :
    Site -> RealCoframe (I := Fin 4) :=
  fun site => aggregateCoframeAt
    (nullEdgeCoframe frame.edges site) (weights site)

/-- Each aggregate coframe column is the displayed linear combination of the
four primitive soldered null-edge vectors. -/
theorem aggregateNullEdgeCoframe_apply {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site)
    (weights : LocalTensor (Site := Site))
    (site : Site) (coordinate direction : Fin 4) :
    aggregateNullEdgeCoframe frame weights site coordinate direction =
      Finset.sum Finset.univ (fun primitiveDirection =>
        nullEdgeCoframe frame.edges site coordinate primitiveDirection *
          weights site primitiveDirection direction) := by
  rfl

/-- Identity aggregate weights recover the primitive null-edge coframe. -/
theorem aggregateNullEdgeCoframe_one {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    aggregateNullEdgeCoframe frame (fun _ => 1) site =
      nullEdgeCoframe frame.edges site := by
  simp [aggregateNullEdgeCoframe, aggregateCoframeAt]

/-- Every real coframe is an aggregate of a nondegenerate primitive null-edge
frame. -/
theorem aggregateNullEdgeCoframe_surjective_at {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site)
    (coframe : RealCoframe (I := Fin 4)) :
    ∃ weights : Tensor (I := Fin 4),
      aggregateCoframeAt (nullEdgeCoframe frame.edges site) weights =
        coframe := by
  refine ⟨inverseCoframe frame site * coframe, ?_⟩
  unfold aggregateCoframeAt
  rw [← Matrix.mul_assoc, mul_inverseCoframe frame site, Matrix.one_mul]

/-- Aggregate weights are unique for a fixed nondegenerate primitive
null-edge frame. -/
theorem aggregateNullEdgeCoframe_injective_at {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    Function.Injective
      (aggregateCoframeAt (nullEdgeCoframe frame.edges site)) := by
  intro weights weights' hEqual
  have hLeft := congrArg (fun coframe => inverseCoframe frame site * coframe)
    hEqual
  simpa [aggregateCoframeAt, ← Matrix.mul_assoc,
    inverseCoframe_mul frame site] using hLeft

/-- Unique aggregate weights of a displayed target coframe relative to the
primitive null-edge frame. -/
def aggregateWeightsForCoframe {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site)
    (coframe : RealCoframe (I := Fin 4)) : Tensor (I := Fin 4) :=
  inverseCoframe frame site * coframe

/-- Reaggregating the unique weights of a target coframe recovers that
coframe exactly. -/
theorem aggregateWeightsForCoframe_exact {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site)
    (coframe : RealCoframe (I := Fin 4)) :
    aggregateCoframeAt (nullEdgeCoframe frame.edges site)
        (aggregateWeightsForCoframe frame site coframe) = coframe := by
  unfold aggregateWeightsForCoframe aggregateCoframeAt
  rw [← Matrix.mul_assoc, mul_inverseCoframe frame site, Matrix.one_mul]

/-- The aggregate-weight path is exactly the affine coframe tangent used in
the determinant variation theorem. -/
theorem aggregateNullEdgeCoframe_line {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site)
    (direction : LocalTensor (Site := Site))
    (site : Site) (t : Real) :
    aggregateNullEdgeCoframe frame
        (fun next => 1 + t • direction next) site =
      nullEdgeCoframe frame.edges site +
        t • (nullEdgeCoframe frame.edges site * direction site) := by
  unfold aggregateNullEdgeCoframe aggregateCoframeAt
  rw [Matrix.mul_add, Matrix.mul_one, Matrix.mul_smul]

/-- The nonlinear determinant in the coframe-chart action is exactly the
volume of the aggregate null-edge coframe with displacement `generator`. -/
theorem chartVolume_eq_aggregateNullEdgeVolume {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site)
    (generator : LocalTensor (Site := Site)) (site : Site) :
    chartVolume (nullEdgeCoframe frame.edges) generator site =
      coframeVolume
        (aggregateNullEdgeCoframe frame
          (fun next => 1 + generator next) site) := by
  rfl

/-- Metric induced by aggregate weights over the primitive null-edge frame. -/
def aggregateNullEdgeMetricAt {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site)
    (weights : Tensor (I := Fin 4)) : Tensor (I := Fin 4) :=
  inducedCovariantMetric minkowskiMetric
    (aggregateCoframeAt (nullEdgeCoframe frame.edges site) weights)

/-- Aggregate weights act on the primitive null-edge Gram metric by
congruence: `g(A) = A^T g A`. -/
theorem aggregateNullEdgeMetricAt_eq {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site)
    (weights : Tensor (I := Fin 4)) :
    aggregateNullEdgeMetricAt frame site weights =
      weights.transpose * nullEdgeMetric frame.edges site * weights := by
  unfold aggregateNullEdgeMetricAt aggregateCoframeAt nullEdgeMetric
    nullEdgeMetricAt inducedCovariantMetric
  rw [Matrix.transpose_mul]
  noncomm_ring

/-- At identity aggregate weights, the aggregate metric is the primitive
null-edge Gram metric. -/
theorem aggregateNullEdgeMetricAt_one {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    aggregateNullEdgeMetricAt frame site 1 =
      nullEdgeMetric frame.edges site := by
  rw [aggregateNullEdgeMetricAt_eq]
  simp

/-- **One-metric bridge.** If a target coframe is a factor of an independently
reconstructed metric, its unique null-edge aggregate weights reproduce that
metric exactly.  The remaining reconstruction debt is therefore the coframe
factorization, not a second choice of metric. -/
theorem aggregateWeightsForCoframe_realizesMetric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site)
    (coframe : RealCoframe (I := Fin 4))
    (targetMetric : Tensor (I := Fin 4))
    (hFactorization :
      inducedCovariantMetric minkowskiMetric coframe = targetMetric) :
    aggregateNullEdgeMetricAt frame site
        (aggregateWeightsForCoframe frame site coframe) = targetMetric := by
  unfold aggregateNullEdgeMetricAt
  rw [aggregateWeightsForCoframe_exact]
  exact hFactorization

/-- Explicit aggregate generator producing a requested inverse-metric
variation. -/
def metricActiveAggregateGenerator
    (metric variation : Tensor (I := Fin 4)) : Tensor (I := Fin 4) :=
  (-1 / 2 : Real) • (variation * metric)

/-- The explicit aggregate generator realizes every symmetric inverse-metric
variation for a symmetric two-sided inverse pair. -/
theorem inverseMetricVariation_metricActiveAggregateGenerator
    (metric inverseMetric variation : Tensor (I := Fin 4))
    (hMetric : metric.IsSymm) (hVariation : variation.IsSymm)
    (hLeft : inverseMetric * metric = 1)
    (hRight : metric * inverseMetric = 1) :
    inverseMetricVariation inverseMetric
        (metricActiveAggregateGenerator metric variation) = variation := by
  unfold metricActiveAggregateGenerator inverseMetricVariation
  rw [Matrix.smul_mul, Matrix.mul_assoc, hRight, Matrix.mul_one,
    Matrix.transpose_smul, Matrix.transpose_mul, hVariation.eq, hMetric.eq,
    Matrix.mul_smul, ← Matrix.mul_assoc, hLeft, Matrix.one_mul]
  module

/-- A familiar metric-invisible aggregate generator: a skew matrix followed
by the covariant metric. -/
def frameGaugeAggregateGenerator
    (metric skew : Tensor (I := Fin 4)) : Tensor (I := Fin 4) :=
  skew * metric

/-- Skew frame generators lie in the kernel of the inverse-metric response. -/
theorem inverseMetricVariation_frameGaugeAggregateGenerator
    (metric inverseMetric skew : Tensor (I := Fin 4))
    (hMetric : metric.IsSymm)
    (hLeft : inverseMetric * metric = 1)
    (hRight : metric * inverseMetric = 1)
    (hSkew : skew.transpose = -skew) :
    inverseMetricVariation inverseMetric
        (frameGaugeAggregateGenerator metric skew) = 0 := by
  have hFirst : (skew * metric) * inverseMetric = skew := by
    rw [Matrix.mul_assoc, hRight, Matrix.mul_one]
  have hSecond :
      inverseMetric * (skew * metric).transpose = -skew := by
    rw [Matrix.transpose_mul, hMetric.eq, hSkew, ← Matrix.mul_assoc,
      hLeft, Matrix.one_mul]
  unfold frameGaugeAggregateGenerator inverseMetricVariation
  rw [hFirst, hSecond]
  simp

/-- Aggregate-weight generators over a nondegenerate null-edge frame reach
every local symmetric inverse-metric variation. -/
theorem aggregateWeightMetricDerivative_isFull
    {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) :
    IsFullLocalSymmetricMetricDerivative
      (localInverseMetricVariationLinear (nullEdgeInverseMetric frame)) := by
  exact localInverseMetricVariationLinear_isFull
    (nullEdgeMetric frame.edges) (nullEdgeInverseMetric frame)
    (nullEdgeMetric_symmetric frame)
    (nullEdgeInverseMetric_symmetric frame)
    (nullEdgeInverseMetric_mul_metric frame)
    (nullEdgeMetric_mul_inverseMetric frame)

/-! ## Einstein action in aggregate null-edge variables -/

variable {Site : Type*} [Fintype Site]

/-- The directed-null-edge action, now explicitly interpreted as a function
of aggregate-weight displacements over the primitive null-edge frame. -/
def aggregateNullEdgeAction
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) :
    LocalTensor (Site := Site) -> Real :=
  directedNullEdgeChartAction kappa chart stress cosmologicalConstant

/-- Identity aggregate weights at every site. -/
def identityAggregateWeights : LocalTensor (Site := Site) :=
  fun _ => 1

/-- The same action in absolute aggregate weights rather than displacements
from identity. -/
def absoluteAggregateNullEdgeAction
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (weights : LocalTensor (Site := Site)) : Real :=
  aggregateNullEdgeAction kappa chart stress cosmologicalConstant
    (weights - identityAggregateWeights)

/-- The aggregate-weight action is definitionally the directed-null-edge
coframe-chart action. -/
theorem aggregateNullEdgeAction_eq_directed
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) :
    aggregateNullEdgeAction kappa chart stress cosmologicalConstant =
      directedNullEdgeChartAction kappa chart stress
        cosmologicalConstant := rfl

/-- Translating absolute weights by identity identifies stationarity at
`A = 1` with displacement stationarity at `X = 0`. -/
theorem absoluteAggregateStationary_iff_displacementStationary
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) :
    ParameterStationary
        (absoluteAggregateNullEdgeAction kappa chart stress
          cosmologicalConstant)
        identityAggregateWeights <->
      ParameterStationary
        (aggregateNullEdgeAction kappa chart stress cosmologicalConstant) 0 := by
  unfold ParameterStationary absoluteAggregateNullEdgeAction
    identityAggregateWeights
  constructor <;> intro h direction
  · have hDirection := h direction
    convert hDirection using 1
    funext t
    congr 1
    funext site
    simp
  · have hDirection := h direction
    convert hDirection using 1
    funext t
    congr 1
    funext site
    simp

/-- **Aggregate-null-edge Einstein theorem.**  The primitive geometric data
are four independent spinor null edges and their directed targets.  Arbitrary
coframe and metric variations are realized by changing their aggregate
weights.  Stationarity of the resulting nonlinear finite action is equivalent
to the pointwise finite Einstein equation with geometry reconstructed from the
same directed null-edge chart. -/
theorem aggregateNullEdgeAction_stationary_iff_einstein
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    ParameterStationary
        (aggregateNullEdgeAction kappa chart stress cosmologicalConstant) 0
      <->
      LocalFiniteEinsteinEquation kappa
        (nullEdgeSymmetricRicci chart)
        (directedNullEdgeScalarCurvature chart)
        (nullEdgeMetric chart.edges) cosmologicalConstant stress := by
  exact directedNullEdgeChartAction_stationary_iff_einstein
    kappa chart stress cosmologicalConstant hStress hKappa

/-- **Absolute aggregate-null-edge Einstein theorem.** Stationarity at
identity aggregate weights, where each coframe column initially equals one
primitive soldered null edge, is equivalent to the pointwise finite Einstein
equation. -/
theorem absoluteAggregateNullEdgeAction_stationary_iff_einstein
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    ParameterStationary
        (absoluteAggregateNullEdgeAction kappa chart stress
          cosmologicalConstant)
        identityAggregateWeights <->
      LocalFiniteEinsteinEquation kappa
        (nullEdgeSymmetricRicci chart)
        (directedNullEdgeScalarCurvature chart)
        (nullEdgeMetric chart.edges) cosmologicalConstant stress := by
  rw [absoluteAggregateStationary_iff_displacementStationary]
  exact aggregateNullEdgeAction_stationary_iff_einstein
    kappa chart stress cosmologicalConstant hStress hKappa

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein.aggregateNullEdgeCoframe_surjective_at' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms aggregateNullEdgeCoframe_surjective_at

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein.aggregateWeightsForCoframe_realizesMetric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms aggregateWeightsForCoframe_realizesMetric

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein.inverseMetricVariation_metricActiveAggregateGenerator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inverseMetricVariation_metricActiveAggregateGenerator

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein.inverseMetricVariation_frameGaugeAggregateGenerator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inverseMetricVariation_frameGaugeAggregateGenerator

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein.aggregateNullEdgeAction_stationary_iff_einstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms aggregateNullEdgeAction_stationary_iff_einstein

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein.absoluteAggregateNullEdgeAction_stationary_iff_einstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms absoluteAggregateNullEdgeAction_stationary_iff_einstein

end PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein
