import PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge
import PhysicsSM.Draft.NullEdge.CausalLeviCivita

/-!
# Directed null-edge Levi-Civita curvature and Einstein action

This module closes the next shared-data gap in the finite GR lane.  A
`DirectedNullEdgeChart` contains, at every site, four independent Weyl-spinor
null edges and the target site of each edge.  The same data now determines:

1. the null coframe, Gram metric, inverse metric, and volume;
2. forward differences of that metric along the four graph edges;
3. the finite Levi-Civita Christoffel coefficients;
4. coordinate Riemann curvature and its Ricci contraction;
5. the symmetric Ricci response seen by symmetric metric variations;
6. the nonlinear Palatini chart action and its finite Einstein equation.

Thus the final action theorem no longer accepts an independently supplied
coframe, metric, inverse metric, volume, or Ricci tensor.  It accepts a
decorated directed null-edge chart, stress, and couplings.

The remaining caveats are substantial and explicit.  Direction labels are
globally synchronized; the forward-difference curvature has not yet been
proved locally Lorentz covariant or equivalent to plaquette holonomy; the
Ricci tensor used by the metric variation is the symmetric projection of the
raw discrete contraction; connection stationarity is not yet derived; and no
refinement or continuum convergence theorem is claimed.  The action parameter
is still an unrestricted coframe generator around the null-edge base.  By
`zeroDiagonalMetricDerivative_not_full`, a tangent that preserves all four
null columns cannot alone supply the full stationarity theorem.  Signature is
mostly-minus `(+,-,-,-)`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein

open scoped BigOperators

open Matrix
open CausalLeviCivita
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open NullEdgeCoframeEinsteinBridge

/-- A four-direction decorated carrier chart.  `target site direction` is the
endpoint of the selected null edge with that direction label. -/
structure DirectedNullEdgeChart (Site : Type*) extends
    NondegenerateNullEdgeFrame Site where
  target : Site -> Fin 4 -> Site

/-- Forward difference of a scalar field along one selected graph edge. -/
def edgeDifference {Site : Type*}
    (target : Site -> Fin 4 -> Site) (field : Site -> Real)
    (site : Site) (direction : Fin 4) : Real :=
  field (target site direction) - field site

/-- Forward graph differences annihilate constant fields exactly. -/
theorem edgeDifference_const {Site : Type*}
    (target : Site -> Fin 4 -> Site) (value : Real)
    (site : Site) (direction : Fin 4) :
    edgeDifference target (fun _ => value) site direction = 0 := by
  simp [edgeDifference]

/-- First graph jet of the null-edge Gram metric. -/
def nullEdgeMetricFirstJet {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    Fin 4 -> Matrix (Fin 4) (Fin 4) Real :=
  fun direction left right =>
    edgeDifference chart.target
      (fun next => nullEdgeMetric chart.edges next left right)
      site direction

/-- The graph metric first jet remains symmetric in its metric indices. -/
theorem nullEdgeMetricFirstJet_symmetric {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    MetricFirstJetSymmetric (nullEdgeMetricFirstJet chart site) := by
  intro direction left right
  have hTarget :
      nullEdgeMetric chart.edges (chart.target site direction) left right =
        nullEdgeMetric chart.edges (chart.target site direction) right left := by
    have h := congrFun
      (congrFun
        (nullEdgeMetric_symmetric chart.toNondegenerateNullEdgeFrame
          (chart.target site direction)).eq left) right
    simpa using h.symm
  have hSource :
      nullEdgeMetric chart.edges site left right =
        nullEdgeMetric chart.edges site right left := by
    have h := congrFun
      (congrFun
        (nullEdgeMetric_symmetric chart.toNondegenerateNullEdgeFrame site).eq
          left) right
    simpa using h.symm
  unfold nullEdgeMetricFirstJet edgeDifference
  change
    nullEdgeMetric chart.edges (chart.target site direction) left right -
        nullEdgeMetric chart.edges site left right =
      nullEdgeMetric chart.edges (chart.target site direction) right left -
        nullEdgeMetric chart.edges site right left
  rw [hTarget, hSource]

/-- Levi-Civita connection constructed from the null-edge metric and its
forward graph first jet. -/
def nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    Fin 4 -> Fin 4 -> Fin 4 -> Real :=
  christoffelSecondKind
    (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site)
    (nullEdgeMetricFirstJet chart site)

/-- The reconstructed connection has zero coordinate torsion. -/
theorem nullEdgeChristoffel_torsion_free {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (upper left right : Fin 4) :
    nullEdgeChristoffel chart site upper left right =
      nullEdgeChristoffel chart site upper right left := by
  exact christoffelSecondKind_swap
    (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site)
    (nullEdgeMetricFirstJet chart site)
    (nullEdgeMetricFirstJet_symmetric chart site) upper left right

/-- The reconstructed connection is compatible with the null-edge Gram
metric at the finite first-jet level. -/
theorem nullEdgeChristoffel_metric_compatible {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (direction left right : Fin 4) :
    covariantMetricDerivative
        (nullEdgeMetric chart.edges site)
        (nullEdgeMetricFirstJet chart site)
        (nullEdgeChristoffel chart site) direction left right = 0 := by
  exact covariantMetricDerivative_christoffel_eq_zero
    (nullEdgeMetric chart.edges site)
    (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site)
    (nullEdgeMetricFirstJet chart site)
    (nullEdgeMetric_mul_inverseMetric
      chart.toNondegenerateNullEdgeFrame site)
    (nullEdgeMetricFirstJet_symmetric chart site)
    direction left right

/-- Forward graph derivative of the reconstructed connection. -/
def nullEdgeConnectionFirstJet {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (direction upper left right : Fin 4) : Real :=
  edgeDifference chart.target
    (fun next => nullEdgeChristoffel chart next upper left right)
    site direction

/-- Coordinate curvature of the graph-derived Levi-Civita connection. -/
def nullEdgeRiemann {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (upper lower directionLeft directionRight : Fin 4) : Real :=
  nullEdgeConnectionFirstJet chart site directionLeft upper directionRight lower
    - nullEdgeConnectionFirstJet chart site directionRight upper directionLeft lower
    + Finset.sum Finset.univ (fun middle =>
        nullEdgeChristoffel chart site upper directionLeft middle *
            nullEdgeChristoffel chart site middle directionRight lower
          - nullEdgeChristoffel chart site upper directionRight middle *
            nullEdgeChristoffel chart site middle directionLeft lower)

/-- The discrete coordinate curvature is antisymmetric in its two curvature
directions by construction. -/
theorem nullEdgeRiemann_antisymm {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (upper lower left right : Fin 4) :
    nullEdgeRiemann chart site upper lower left right =
      -nullEdgeRiemann chart site upper lower right left := by
  unfold nullEdgeRiemann
  simp only [Finset.sum_sub_distrib]
  ring

/-- Raw Ricci contraction `R_{lower,right} = sum_upper
R^upper_{lower,upper,right}` of the graph curvature. -/
def nullEdgeRawRicci {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    Matrix (Fin 4) (Fin 4) Real :=
  fun lower right => Finset.sum Finset.univ (fun upper =>
    nullEdgeRiemann chart site upper lower upper right)

/-- Symmetric projection of a covariant rank-two tensor. -/
def symmetricPart (tensor : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 4) (Fin 4) Real :=
  (1 / 2 : Real) • (tensor + tensor.transpose)

/-- The symmetric projection is symmetric. -/
theorem symmetricPart_isSymm
    (tensor : Matrix (Fin 4) (Fin 4) Real) :
    (symmetricPart tensor).IsSymm := by
  unfold symmetricPart Matrix.IsSymm
  simp only [Matrix.transpose_smul, Matrix.transpose_add,
    Matrix.transpose_transpose]
  rw [add_comm]

/-- Symmetric projection preserves the Frobenius pairing against every
symmetric metric variation. -/
theorem metricVariationPairing_symmetricPart
    (tensor variation : Matrix (Fin 4) (Fin 4) Real)
    (hVariation : variation.IsSymm) :
    metricVariationPairing (symmetricPart tensor) variation =
      metricVariationPairing tensor variation := by
  have hTrace :
      Matrix.trace (tensor * variation) =
        Matrix.trace (tensor.transpose * variation) := by
    calc
      Matrix.trace (tensor * variation) =
          Matrix.trace (tensor * variation).transpose :=
        (Matrix.trace_transpose _).symm
      _ = Matrix.trace (variation.transpose * tensor.transpose) := by
        rw [Matrix.transpose_mul]
      _ = Matrix.trace (variation * tensor.transpose) := by
        rw [hVariation.eq]
      _ = Matrix.trace (tensor.transpose * variation) :=
        Matrix.trace_mul_comm _ _
  unfold metricVariationPairing symmetricPart
  rw [Matrix.transpose_smul, Matrix.transpose_add,
    Matrix.transpose_transpose, Matrix.smul_mul, Matrix.trace_smul,
    Matrix.add_mul, Matrix.trace_add, hTrace]
  change (1 / 2 : Real) *
      (Matrix.trace (tensor.transpose * variation) +
        Matrix.trace (tensor.transpose * variation)) =
    Matrix.trace (tensor.transpose * variation)
  ring

/-- Symmetric Ricci response derived from the directed null-edge chart.  This
is the part of the raw Ricci contraction visible to symmetric metric
variations. -/
def nullEdgeSymmetricRicci {Site : Type*}
    (chart : DirectedNullEdgeChart Site) : LocalTensor (Site := Site) :=
  fun site => symmetricPart (nullEdgeRawRicci chart site)

/-- The derived Ricci response is locally symmetric. -/
theorem nullEdgeSymmetricRicci_symmetric {Site : Type*}
    (chart : DirectedNullEdgeChart Site) :
    LocalSymmetric (nullEdgeSymmetricRicci chart) := by
  intro site
  exact symmetricPart_isSymm _

/-- Contracting the symmetric Ricci response with the derived inverse metric
is exactly the contraction of the raw graph Ricci tensor. -/
theorem nullEdgeSymmetricRicci_pairing_eq_raw {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    metricVariationPairing (nullEdgeSymmetricRicci chart site)
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site) =
      metricVariationPairing (nullEdgeRawRicci chart site)
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site) := by
  exact metricVariationPairing_symmetricPart _ _
    (nullEdgeInverseMetric_symmetric
      chart.toNondegenerateNullEdgeFrame site)

/-! ## Flat canonical control -/

/-- Constant canonical null frames on any directed carrier. -/
def canonicalDirectedChart (Site : Type*)
    (target : Site -> Fin 4 -> Site) : DirectedNullEdgeChart Site where
  edges := (canonicalFrame Site).edges
  det_ne_zero := (canonicalFrame Site).det_ne_zero
  target := target

/-- A constant canonical null frame has zero metric first jet. -/
theorem canonicalDirectedChart_metricFirstJet_zero {Site : Type*}
    (target : Site -> Fin 4 -> Site) (site : Site) :
    nullEdgeMetricFirstJet (canonicalDirectedChart Site target) site = 0 := by
  funext direction left right
  simp [nullEdgeMetricFirstJet, edgeDifference, canonicalDirectedChart,
    nullEdgeMetric, canonicalFrame]

/-- Consequently its reconstructed Levi-Civita connection vanishes. -/
theorem canonicalDirectedChart_christoffel_zero {Site : Type*}
    (target : Site -> Fin 4 -> Site) (site : Site) :
    nullEdgeChristoffel (canonicalDirectedChart Site target) site = 0 := by
  rw [nullEdgeChristoffel,
    canonicalDirectedChart_metricFirstJet_zero target site]
  funext upper left right
  simp [christoffelSecondKind, christoffelFirstKind]

/-- The constant canonical chart is an exact zero-curvature control. -/
theorem canonicalDirectedChart_riemann_zero {Site : Type*}
    (target : Site -> Fin 4 -> Site) (site : Site) :
    nullEdgeRiemann (canonicalDirectedChart Site target) site = 0 := by
  funext upper lower left right
  unfold nullEdgeRiemann nullEdgeConnectionFirstJet edgeDifference
  simp_rw [canonicalDirectedChart_christoffel_zero target]
  simp

/-- The constant canonical chart also has zero derived Ricci response. -/
theorem canonicalDirectedChart_ricci_zero {Site : Type*}
    (target : Site -> Fin 4 -> Site) :
    nullEdgeSymmetricRicci (canonicalDirectedChart Site target) = 0 := by
  funext site left right
  simp [nullEdgeSymmetricRicci, symmetricPart, nullEdgeRawRicci,
    canonicalDirectedChart_riemann_zero target site]

/-! ## Action endpoint with graph-derived Ricci -/

variable {Site : Type*} [Fintype Site]

/-- Nonlinear Palatini chart action whose geometric coefficients are derived
from a single directed null-edge chart. -/
def directedNullEdgeChartAction
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) :
    LocalTensor (Site := Site) -> Real :=
  nullEdgeChartTotalAction kappa chart.toNondegenerateNullEdgeFrame
    (nullEdgeSymmetricRicci chart) stress cosmologicalConstant

/-- Scalar curvature obtained by contracting graph-derived symmetric Ricci
with the inverse metric derived from the same null edges. -/
def directedNullEdgeScalarCurvature
    (chart : DirectedNullEdgeChart Site) : Site -> Real :=
  nullEdgeScalarCurvature chart.toNondegenerateNullEdgeFrame
    (nullEdgeSymmetricRicci chart)

/-- **Directed-null-edge Einstein-action theorem.**  Stationarity of the
explicit nonlinear action is equivalent to the finite Einstein equation in
which coframe, metric, inverse metric, volume, connection, curvature, Ricci,
and scalar curvature all come from one directed null-edge chart.  The
variation itself is the larger coframe chart, not yet a proved lift of
null-edge-preserving spinor variations. -/
theorem directedNullEdgeChartAction_stationary_iff_einstein
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    ParameterStationary
        (directedNullEdgeChartAction kappa chart stress
          cosmologicalConstant) 0 <->
      LocalFiniteEinsteinEquation kappa
        (nullEdgeSymmetricRicci chart)
        (directedNullEdgeScalarCurvature chart)
        (nullEdgeMetric chart.edges) cosmologicalConstant stress := by
  exact nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation
    kappa chart.toNondegenerateNullEdgeFrame
    (nullEdgeSymmetricRicci chart) stress cosmologicalConstant
    (nullEdgeSymmetricRicci_symmetric chart) hStress hKappa

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein.nullEdgeChristoffel_metric_compatible' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeChristoffel_metric_compatible

/-- info: 'PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein.nullEdgeRiemann_antisymm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeRiemann_antisymm

/-- info: 'PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein.canonicalDirectedChart_riemann_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalDirectedChart_riemann_zero

/-- info: 'PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein.directedNullEdgeChartAction_stationary_iff_einstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms directedNullEdgeChartAction_stationary_iff_einstein

end PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein
