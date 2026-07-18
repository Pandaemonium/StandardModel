import PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein

/-!
# Finite directed Palatini connection variation

The directed-null-edge curvature module constructs a Levi-Civita connection
from four decorated null directions and then evaluates its coordinate
curvature.  This module separates the curvature formula from that particular
connection so that the connection can be varied independently, as required by
the Palatini architecture.

For a directed carrier map `target`, a connection field `connection`, and an
arbitrary connection variation `variation`, the module proves directly from
the displayed finite formulas that

```text
d R(connection + t variation) / dt at t = 0
  = Delta variation + connection * variation + variation * connection.
```

The same calculation is contracted to Ricci and then to a genuine finite
weighted action.  Thus its connection Euler-Lagrange functional is derived,
not postulated.  Substitution of the null-edge Levi-Civita connection recovers
the earlier directed-null-edge Riemann and Ricci tensors exactly.

This is a finite decorated-chart theorem with globally synchronized direction
labels.  It does not yet prove that connection stationarity is equivalent to
metric compatibility, that the directed difference is locally Lorentz
covariant, or that this curvature converges to continuum curvature.  Signature
conventions enter only through a supplied inverse metric; the null-edge chart
uses mostly-minus `(+,-,-,-)` elsewhere in the program.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation

open scoped BigOperators

open Matrix
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open CoframeVolumeMetricVariation
open FinitePalatiniCoframeChartAction
open NullEdgeCoframeEinsteinBridge
open DirectedNullEdgeLeviCivitaEinstein

/-- A real coordinate connection field on a finite directed carrier.  The
indices are ordered as `Gamma^upper_(left,right)`. -/
abbrev DirectedConnection (Site : Type*) :=
  Site -> Fin 4 -> Fin 4 -> Fin 4 -> Real

/-- Forward directed difference of an independently supplied connection. -/
def connectionFirstJet {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection : DirectedConnection Site)
    (site : Site) (direction upper left right : Fin 4) : Real :=
  edgeDifference target
    (fun next => connection next upper left right) site direction

/-- Coordinate Riemann curvature of an arbitrary directed connection. -/
def connectionRiemann {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection : DirectedConnection Site)
    (site : Site)
    (upper lower directionLeft directionRight : Fin 4) : Real :=
  connectionFirstJet target connection site directionLeft upper
      directionRight lower
    - connectionFirstJet target connection site directionRight upper
        directionLeft lower
    + Finset.sum Finset.univ (fun middle =>
        connection site upper directionLeft middle *
            connection site middle directionRight lower
          - connection site upper directionRight middle *
            connection site middle directionLeft lower)

/-- Raw Ricci contraction of an arbitrary directed connection. -/
def connectionRawRicci {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection : DirectedConnection Site) (site : Site) :
    Matrix (Fin 4) (Fin 4) Real :=
  fun lower right => Finset.sum Finset.univ (fun upper =>
    connectionRiemann target connection site upper lower upper right)

/-- Symmetric Ricci response visible to symmetric inverse-metric variations. -/
def connectionSymmetricRicci {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection : DirectedConnection Site) (site : Site) :
    Matrix (Fin 4) (Fin 4) Real :=
  symmetricPart (connectionRawRicci target connection site)

/-! ## Exact specialization to the null-edge Levi-Civita connection -/

/-- Generic connection differences specialize to the existing null-edge
Levi-Civita first jet. -/
theorem connectionFirstJet_nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site)
    (site : Site) (direction upper left right : Fin 4) :
    connectionFirstJet chart.target (nullEdgeChristoffel chart) site direction
        upper left right =
      nullEdgeConnectionFirstJet chart site direction upper left right := by
  rfl

/-- Generic connection curvature specializes exactly to the existing
directed-null-edge curvature. -/
theorem connectionRiemann_nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site)
    (site : Site) (upper lower left right : Fin 4) :
    connectionRiemann chart.target (nullEdgeChristoffel chart) site upper lower
        left right =
      nullEdgeRiemann chart site upper lower left right := by
  rfl

/-- The generic raw Ricci contraction specializes exactly to the existing raw
null-edge Ricci tensor. -/
theorem connectionRawRicci_nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    connectionRawRicci chart.target (nullEdgeChristoffel chart) site =
      nullEdgeRawRicci chart site := by
  rfl

/-- The generic symmetric Ricci response specializes exactly to the existing
null-edge symmetric Ricci response. -/
theorem connectionSymmetricRicci_nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    connectionSymmetricRicci chart.target (nullEdgeChristoffel chart) site =
      nullEdgeSymmetricRicci chart site := by
  rfl

/-! ## Independent connection variation -/

/-- Affine line through a connection in an arbitrary connection direction. -/
def connectionLine {Site : Type*}
    (connection variation : DirectedConnection Site) (t : Real) :
    DirectedConnection Site :=
  fun site upper left right =>
    connection site upper left right + t * variation site upper left right

/-- First variation of coordinate Riemann curvature.  It contains the
directed difference of the connection variation and the four cross terms from
the quadratic connection contribution. -/
def connectionRiemannFirstVariation {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site)
    (site : Site)
    (upper lower directionLeft directionRight : Fin 4) : Real :=
  connectionFirstJet target variation site directionLeft upper
      directionRight lower
    - connectionFirstJet target variation site directionRight upper
        directionLeft lower
    + Finset.sum Finset.univ (fun middle =>
        variation site upper directionLeft middle *
              connection site middle directionRight lower
          + connection site upper directionLeft middle *
              variation site middle directionRight lower
          - variation site upper directionRight middle *
              connection site middle directionLeft lower
          - connection site upper directionRight middle *
              variation site middle directionLeft lower)

/-- First variation of the raw Ricci contraction. -/
def connectionRawRicciFirstVariation {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site) (site : Site) :
    Matrix (Fin 4) (Fin 4) Real :=
  fun lower right => Finset.sum Finset.univ (fun upper =>
    connectionRiemannFirstVariation target connection variation site upper
      lower upper right)

/-- Each component of the affine connection line has the expected
derivative. -/
theorem hasDerivAt_connectionLine_component {Site : Type*}
    (connection variation : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) :
    HasDerivAt
      (fun t : Real => connectionLine connection variation t site upper left right)
      (variation site upper left right) 0 := by
  simpa [connectionLine] using
    (((hasDerivAt_id (𝕜 := Real) 0).mul_const
      (variation site upper left right)).const_add
        (connection site upper left right))

/-- The derivative of a directed connection difference is the corresponding
directed difference of the variation. -/
theorem hasDerivAt_connectionFirstJet_line {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site)
    (site : Site) (direction upper left right : Fin 4) :
    HasDerivAt
      (fun t : Real =>
        connectionFirstJet target (connectionLine connection variation t)
          site direction upper left right)
      (connectionFirstJet target variation site direction upper left right) 0 := by
  unfold connectionFirstJet edgeDifference
  exact
    (hasDerivAt_connectionLine_component connection variation
      (target site direction) upper left right).sub
      (hasDerivAt_connectionLine_component connection variation
        site upper left right)

/-- **Exact finite Palatini curvature variation.**  Differentiating the
displayed directed coordinate-curvature formula gives precisely the linear
response `Delta variation + connection * variation + variation * connection`.
-/
theorem hasDerivAt_connectionRiemann_line {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site)
    (site : Site) (upper lower left right : Fin 4) :
    HasDerivAt
      (fun t : Real =>
        connectionRiemann target (connectionLine connection variation t)
          site upper lower left right)
      (connectionRiemannFirstVariation target connection variation site upper
        lower left right) 0 := by
  unfold connectionRiemann connectionRiemannFirstVariation
  apply HasDerivAt.add
  · exact
      (hasDerivAt_connectionFirstJet_line target connection variation site left
        upper right lower).sub
        (hasDerivAt_connectionFirstJet_line target connection variation site
          right upper left lower)
  · apply HasDerivAt.fun_sum
    intro middle _
    convert
      ((hasDerivAt_connectionLine_component connection variation site upper
          left middle).mul
        (hasDerivAt_connectionLine_component connection variation site middle
          right lower)).sub
        ((hasDerivAt_connectionLine_component connection variation site upper
            right middle).mul
          (hasDerivAt_connectionLine_component connection variation site middle
            left lower)) using 1
    all_goals simp [connectionLine]
    all_goals ring

/-- Differentiation commutes with the finite Ricci contraction. -/
theorem hasDerivAt_connectionRawRicci_line {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site)
    (site : Site) (lower right : Fin 4) :
    HasDerivAt
      (fun t : Real =>
        connectionRawRicci target (connectionLine connection variation t)
          site lower right)
      (connectionRawRicciFirstVariation target connection variation site lower
        right) 0 := by
  unfold connectionRawRicci connectionRawRicciFirstVariation
  apply HasDerivAt.fun_sum
  intro upper _
  exact hasDerivAt_connectionRiemann_line target connection variation site
    upper lower upper right

/-! ## Finite weighted Palatini connection action -/

variable {Site : Type*} [Fintype Site]

/-- Finite Palatini curvature action with fixed volume and inverse metric but
an independently variable directed connection. -/
def directedPalatiniConnectionAction
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Real :=
  Finset.sum Finset.univ (fun site =>
    volume site *
      metricVariationPairing (connectionRawRicci target connection site)
        (inverseMetric site))

/-- Explicit first-variation functional of the finite Palatini connection
action. -/
def directedPalatiniConnectionResponse
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) : Real :=
  Finset.sum Finset.univ (fun site =>
    volume site *
      metricVariationPairing
        (connectionRawRicciFirstVariation target connection variation site)
        (inverseMetric site))

omit [Fintype Site] in
/-- Pairing the varying Ricci contraction with a fixed inverse metric has the
expected derivative. -/
theorem hasDerivAt_connectionRawRicciPairing_line
    (target : Site -> Fin 4 -> Site)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) (site : Site) :
    HasDerivAt
      (fun t : Real =>
        metricVariationPairing
          (connectionRawRicci target (connectionLine connection variation t)
            site)
          (inverseMetric site))
      (metricVariationPairing
        (connectionRawRicciFirstVariation target connection variation site)
        (inverseMetric site)) 0 := by
  unfold metricVariationPairing Matrix.trace
  apply HasDerivAt.fun_sum
  intro right _
  change HasDerivAt
    (fun t : Real => Finset.sum Finset.univ (fun lower =>
      connectionRawRicci target (connectionLine connection variation t) site
          lower right * inverseMetric site lower right))
    (Finset.sum Finset.univ (fun lower =>
      connectionRawRicciFirstVariation target connection variation site
          lower right * inverseMetric site lower right)) 0
  apply HasDerivAt.fun_sum
  intro lower _
  exact
    (hasDerivAt_connectionRawRicci_line target connection variation site lower
      right).mul_const (inverseMetric site lower right)

/-- **Exact derivative of the finite Palatini connection action.** -/
theorem directedPalatiniConnectionAction_directionalDerivative
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) :
    HasDerivAt
      (fun t : Real =>
        directedPalatiniConnectionAction target volume inverseMetric
          (connectionLine connection variation t))
      (directedPalatiniConnectionResponse target volume inverseMetric connection
        variation) 0 := by
  unfold directedPalatiniConnectionAction directedPalatiniConnectionResponse
  apply HasDerivAt.fun_sum
  intro site _
  exact (hasDerivAt_connectionRawRicciPairing_line target inverseMetric
    connection variation site).const_mul (volume site)

/-- Stationarity of the finite action under all independent connection
variations. -/
def ConnectionStationary
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Prop :=
  forall variation : DirectedConnection Site,
    HasDerivAt
      (fun t : Real =>
        directedPalatiniConnectionAction target volume inverseMetric
          (connectionLine connection variation t)) 0 0

/-- Vanishing of the explicit connection Euler-Lagrange functional. -/
def ConnectionEulerLagrange
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Prop :=
  forall variation : DirectedConnection Site,
    directedPalatiniConnectionResponse target volume inverseMetric connection
      variation = 0

/-- Stationarity is equivalent to vanishing of the derived finite connection
Euler-Lagrange functional. -/
theorem connectionStationary_iff_eulerLagrange
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    ConnectionStationary target volume inverseMetric connection <->
      ConnectionEulerLagrange target volume inverseMetric connection := by
  constructor
  · intro hStationary variation
    exact
      (directedPalatiniConnectionAction_directionalDerivative target volume
        inverseMetric connection variation).unique (hStationary variation)
  · intro hEuler variation
    simpa [hEuler variation] using
      directedPalatiniConnectionAction_directionalDerivative target volume
        inverseMetric connection variation

/-! ## Closed periodic flat control -/

/-- Target map induced by four invertible shifts of a finite carrier. -/
def periodicTarget
    (shift : Fin 4 -> Equiv Site Site) : Site -> Fin 4 -> Site :=
  fun site direction => shift direction site

/-- Every forward difference sums to zero on a finite periodic carrier. -/
theorem sum_edgeDifference_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (field : Site -> Real) (direction : Fin 4) :
    (Finset.sum Finset.univ (fun site =>
      edgeDifference (periodicTarget shift) field site direction)) = 0 := by
  unfold edgeDifference periodicTarget
  rw [Finset.sum_sub_distrib]
  have hShift := Equiv.sum_comp (shift direction) field
  rw [hShift]
  exact sub_self _

/-- Consequently every independently supplied connection component has zero
total first directed difference on a periodic carrier. -/
theorem sum_connectionFirstJet_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (connection : DirectedConnection Site)
    (direction upper left right : Fin 4) :
    (Finset.sum Finset.univ (fun site =>
      connectionFirstJet (periodicTarget shift) connection site direction
        upper left right)) = 0 := by
  exact sum_edgeDifference_periodic shift
    (fun site => connection site upper left right) direction

/-- At the zero connection, every component of the first Ricci response sums
to zero on a periodic carrier. -/
theorem sum_connectionRawRicciFirstVariation_zero_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (variation : DirectedConnection Site) (lower right : Fin 4) :
    (Finset.sum Finset.univ (fun site =>
      connectionRawRicciFirstVariation (periodicTarget shift) 0 variation site
        lower right)) = 0 := by
  unfold connectionRawRicciFirstVariation
  rw [Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro upper _
  simp only [connectionRiemannFirstVariation, Pi.zero_apply, zero_mul, mul_zero,
    add_zero, sub_zero, Finset.sum_const_zero]
  rw [Finset.sum_sub_distrib,
    sum_connectionFirstJet_periodic shift variation upper upper right lower,
    sum_connectionFirstJet_periodic shift variation right upper upper lower]
  exact sub_self 0

/-- The Frobenius pairing commutes with a finite sum in its tensor argument. -/
theorem sum_metricVariationPairing_left
    (tensor : Site -> Matrix (Fin 4) (Fin 4) Real)
    (variation : Matrix (Fin 4) (Fin 4) Real) :
    (Finset.sum Finset.univ (fun site =>
      metricVariationPairing (tensor site) variation)) =
      metricVariationPairing (Finset.sum Finset.univ tensor) variation := by
  unfold metricVariationPairing
  rw [Matrix.transpose_sum, Finset.sum_mul, Matrix.trace_sum]

/-- With constant volume and inverse metric, the zero connection satisfies the
derived connection Euler-Lagrange equation on every finite periodic carrier.
-/
theorem zeroConnection_eulerLagrange_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Real) (inverseMetric : Matrix (Fin 4) (Fin 4) Real) :
    ConnectionEulerLagrange (periodicTarget shift) (fun _ => volume)
      (fun _ => inverseMetric) 0 := by
  intro variation
  unfold directedPalatiniConnectionResponse
  rw [← Finset.mul_sum]
  rw [sum_metricVariationPairing_left]
  have hRicciSum :
      Finset.sum Finset.univ (fun site =>
        connectionRawRicciFirstVariation (periodicTarget shift) 0 variation
          site) = 0 := by
    ext lower right
    rw [Matrix.sum_apply]
    simp only [Matrix.zero_apply]
    exact sum_connectionRawRicciFirstVariation_zero_periodic shift variation
      lower right
  rw [hRicciSum]
  simp [metricVariationPairing]

/-- The zero connection is therefore an actual stationary point of the finite
Palatini connection action on a periodic constant background. -/
theorem zeroConnection_stationary_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Real) (inverseMetric : Matrix (Fin 4) (Fin 4) Real) :
    ConnectionStationary (periodicTarget shift) (fun _ => volume)
      (fun _ => inverseMetric) 0 := by
  exact (connectionStationary_iff_eulerLagrange
    (periodicTarget shift) (fun _ => volume) (fun _ => inverseMetric) 0).2
      (zeroConnection_eulerLagrange_periodic shift volume inverseMetric)

/-- The Levi-Civita connection of the constant canonical null-edge chart is
stationary on every periodic carrier with constant Palatini coefficients. -/
theorem canonicalNullEdgeChristoffel_stationary_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Real) (inverseMetric : Matrix (Fin 4) (Fin 4) Real) :
    ConnectionStationary (periodicTarget shift) (fun _ => volume)
      (fun _ => inverseMetric)
      (nullEdgeChristoffel
        (canonicalDirectedChart Site (periodicTarget shift))) := by
  have hConnection :
      nullEdgeChristoffel
          (canonicalDirectedChart Site (periodicTarget shift)) = 0 := by
    funext site
    exact canonicalDirectedChart_christoffel_zero (periodicTarget shift) site
  rw [hConnection]
  exact zeroConnection_stationary_periodic shift volume inverseMetric

/-- Constant inverse metric reconstructed from the canonical null-edge
coframe. -/
def canonicalNullEdgeInverseMetric : Matrix (Fin 4) (Fin 4) Real :=
  inducedCovariantMetric minkowskiMetric canonicalCoframe⁻¹.transpose

omit [Fintype Site] in
/-- The canonical null-edge chart has constant oriented volume `1 / 2`. -/
theorem canonicalFrame_chartBaseVolume
    (site : Site) :
    chartBaseVolume (nullEdgeCoframe (canonicalFrame Site).edges) site =
      (1 / 2 : Real) := by
  unfold chartBaseVolume coframeVolume nullEdgeCoframe canonicalFrame
  rw [canonicalNullEdgeCoframe_eq, canonicalCoframe_det]

omit [Fintype Site] in
/-- The canonical null-edge chart reconstructs the same constant inverse
metric at every site. -/
theorem canonicalFrame_inverseMetric
    (site : Site) :
    nullEdgeInverseMetric (canonicalFrame Site) site =
      canonicalNullEdgeInverseMetric := by
  unfold nullEdgeInverseMetric inverseCoframe nullEdgeCoframe canonicalFrame
    canonicalNullEdgeInverseMetric
  rw [canonicalNullEdgeCoframe_eq]

/-- **Geometric flat control.**  The Levi-Civita connection reconstructed from
the canonical null edges is stationary for the connection partial action with
the volume and inverse metric reconstructed from those same null edges. -/
theorem canonicalNullEdgeGeometry_stationary_periodic
    (shift : Fin 4 -> Equiv Site Site) :
    ConnectionStationary (periodicTarget shift)
      (chartBaseVolume (nullEdgeCoframe (canonicalFrame Site).edges))
      (nullEdgeInverseMetric (canonicalFrame Site))
      (nullEdgeChristoffel
        (canonicalDirectedChart Site (periodicTarget shift))) := by
  have hVolume :
      chartBaseVolume (nullEdgeCoframe (canonicalFrame Site).edges) =
        (fun _ => (1 / 2 : Real)) := by
    funext site
    exact canonicalFrame_chartBaseVolume site
  have hInverseMetric :
      nullEdgeInverseMetric (canonicalFrame Site) =
        (fun _ => canonicalNullEdgeInverseMetric) := by
    funext site
    exact canonicalFrame_inverseMetric site
  rw [hVolume, hInverseMetric]
  exact canonicalNullEdgeChristoffel_stationary_periodic shift (1 / 2)
    canonicalNullEdgeInverseMetric

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.connectionRiemann_nullEdgeChristoffel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionRiemann_nullEdgeChristoffel

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.hasDerivAt_connectionRiemann_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_connectionRiemann_line

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.directedPalatiniConnectionAction_directionalDerivative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms directedPalatiniConnectionAction_directionalDerivative

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.connectionStationary_iff_eulerLagrange' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionStationary_iff_eulerLagrange

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.canonicalNullEdgeChristoffel_stationary_periodic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalNullEdgeChristoffel_stationary_periodic

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.canonicalNullEdgeGeometry_stationary_periodic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalNullEdgeGeometry_stationary_periodic

end PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation
