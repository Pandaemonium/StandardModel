import PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation

/-!
# Local finite Palatini equation on periodic directed carriers

The independent-connection action has an exact global directional response.
This module localizes that response on a finite carrier whose four directed
shifts are equivalences.  It supplies:

1. an exact backward-difference summation-by-parts identity;
2. a linear functional of the connection variation;
3. site-and-component probes forming a complete stationarity test;
4. the resulting local Euler coefficient.

The next layer computes that coefficient in densitized inverse-metric and
connection components and compares its unrestricted and torsion-free
projections.  No claim of continuum convergence or general Levi-Civita
uniqueness is made.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation

open scoped BigOperators

open Matrix
open StressEnergyPhysicalControls
open CoframeVolumeMetricVariation
open FinitePalatiniCoframeChartAction
open NullEdgeCoframeEinsteinBridge
open NullEdgeSpinorSoldering
open FiniteDirectedPalatiniConnectionVariation
open DirectedNullEdgeLeviCivitaEinstein
open CausalLeviCivita

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

/-- Backward difference dual to the forward edge difference on a periodic
carrier. -/
def backwardDifference
    (shift : Fin 4 -> Equiv Site Site)
    (field : Site -> Real) (site : Site) (direction : Fin 4) : Real :=
  field ((shift direction).symm site) - field site

omit [DecidableEq Site] in
/-- Exact periodic summation by parts for one connection component. -/
theorem sum_weight_mul_connectionFirstJet_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (weight : Site -> Real)
    (variation : DirectedConnection Site)
    (direction upper left right : Fin 4) :
    (Finset.sum Finset.univ (fun site =>
      weight site *
        connectionFirstJet (periodicTarget shift) variation site direction
          upper left right)) =
      Finset.sum Finset.univ (fun site =>
        backwardDifference shift weight site direction *
          variation site upper left right) := by
  unfold connectionFirstJet edgeDifference periodicTarget backwardDifference
  rw [show (Finset.sum Finset.univ (fun site =>
      weight site *
        (variation (shift direction site) upper left right -
          variation site upper left right))) =
      Finset.sum Finset.univ (fun site =>
          weight site * variation (shift direction site) upper left right) -
        Finset.sum Finset.univ (fun site =>
          weight site * variation site upper left right) by
    simp only [mul_sub, Finset.sum_sub_distrib]]
  have hReindex := Equiv.sum_comp (shift direction)
    (fun site =>
      weight ((shift direction).symm site) *
        variation site upper left right)
  have hShifted :
      (Finset.sum Finset.univ (fun site =>
        weight site * variation (shift direction site) upper left right)) =
        Finset.sum Finset.univ (fun site =>
          weight ((shift direction).symm site) *
            variation site upper left right) := by
    simpa using hReindex
  rw [hShifted]
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro site _
  ring

/-- A connection variation supported at one site and one ordered component. -/
def connectionComponentProbe
    (site : Site) (upper left right : Fin 4) : DirectedConnection Site :=
  Pi.single site
    (Pi.single upper (Pi.single left (Pi.single right (1 : Real))))

omit [Fintype Site] [DecidableEq Site] in
/-- A directed connection first jet is additive in its connection field. -/
theorem connectionFirstJet_add
    (target : Site -> Fin 4 -> Site)
    (variation variation' : DirectedConnection Site)
    (site : Site) (direction upper left right : Fin 4) :
    connectionFirstJet target (variation + variation') site direction upper
        left right =
      connectionFirstJet target variation site direction upper left right +
        connectionFirstJet target variation' site direction upper left right := by
  simp [connectionFirstJet, edgeDifference]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- A directed connection first jet is homogeneous in its connection field. -/
theorem connectionFirstJet_smul
    (target : Site -> Fin 4 -> Site)
    (variation : DirectedConnection Site) (scalar : Real)
    (site : Site) (direction upper left right : Fin 4) :
    connectionFirstJet target (scalar • variation) site direction upper left
        right =
      scalar * connectionFirstJet target variation site direction upper left
        right := by
  simp [connectionFirstJet, edgeDifference]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- The Riemann first response is additive in the connection variation. -/
theorem connectionRiemannFirstVariation_add
    (target : Site -> Fin 4 -> Site)
    (connection variation variation' : DirectedConnection Site)
    (site : Site) (upper lower left right : Fin 4) :
    connectionRiemannFirstVariation target connection
        (variation + variation') site upper lower left right =
      connectionRiemannFirstVariation target connection variation site upper
          lower left right +
        connectionRiemannFirstVariation target connection variation' site upper
          lower left right := by
  unfold connectionRiemannFirstVariation
  rw [connectionFirstJet_add, connectionFirstJet_add]
  rw [show Finset.sum Finset.univ (fun middle =>
      (variation + variation') site upper left middle *
              connection site middle right lower
          + connection site upper left middle *
              (variation + variation') site middle right lower
          - (variation + variation') site upper right middle *
              connection site middle left lower
          - connection site upper right middle *
              (variation + variation') site middle left lower) =
      Finset.sum Finset.univ (fun middle =>
        variation site upper left middle * connection site middle right lower +
          connection site upper left middle * variation site middle right lower -
          variation site upper right middle * connection site middle left lower -
          connection site upper right middle * variation site middle left lower) +
      Finset.sum Finset.univ (fun middle =>
        variation' site upper left middle * connection site middle right lower +
          connection site upper left middle * variation' site middle right lower -
          variation' site upper right middle * connection site middle left lower -
          connection site upper right middle * variation' site middle left lower) by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro middle _
    simp only [Pi.add_apply]
    ring]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- The Riemann first response is homogeneous in the connection variation. -/
theorem connectionRiemannFirstVariation_smul
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site) (scalar : Real)
    (site : Site) (upper lower left right : Fin 4) :
    connectionRiemannFirstVariation target connection (scalar • variation)
        site upper lower left right =
      scalar * connectionRiemannFirstVariation target connection variation site
        upper lower left right := by
  unfold connectionRiemannFirstVariation
  rw [connectionFirstJet_smul, connectionFirstJet_smul]
  rw [show Finset.sum Finset.univ (fun middle =>
      (scalar • variation) site upper left middle *
              connection site middle right lower
          + connection site upper left middle *
              (scalar • variation) site middle right lower
          - (scalar • variation) site upper right middle *
              connection site middle left lower
          - connection site upper right middle *
              (scalar • variation) site middle left lower) =
      scalar * Finset.sum Finset.univ (fun middle =>
        variation site upper left middle * connection site middle right lower +
          connection site upper left middle * variation site middle right lower -
          variation site upper right middle * connection site middle left lower -
          connection site upper right middle * variation site middle left lower) by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro middle _
    simp only [Pi.smul_apply, smul_eq_mul]
    ring]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- The raw Ricci first response is additive in the connection variation. -/
theorem connectionRawRicciFirstVariation_add
    (target : Site -> Fin 4 -> Site)
    (connection variation variation' : DirectedConnection Site)
    (site : Site) :
    connectionRawRicciFirstVariation target connection
        (variation + variation') site =
      connectionRawRicciFirstVariation target connection variation site +
        connectionRawRicciFirstVariation target connection variation' site := by
  ext lower right
  unfold connectionRawRicciFirstVariation
  simp only [Matrix.add_apply]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro upper _
  exact connectionRiemannFirstVariation_add target connection variation
    variation' site upper lower upper right

omit [Fintype Site] [DecidableEq Site] in
/-- The raw Ricci first response is homogeneous in the connection variation. -/
theorem connectionRawRicciFirstVariation_smul
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site) (scalar : Real)
    (site : Site) :
    connectionRawRicciFirstVariation target connection
        (scalar • variation) site =
      scalar • connectionRawRicciFirstVariation target connection variation
        site := by
  ext lower right
  unfold connectionRawRicciFirstVariation
  simp only [Matrix.smul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro upper _
  exact connectionRiemannFirstVariation_smul target connection variation scalar
    site upper lower upper right

omit [Fintype Site] [DecidableEq Site] in
/-- The Frobenius pairing is additive in its tensor argument. -/
theorem metricVariationPairing_add_left
    (tensor tensor' variation : Matrix (Fin 4) (Fin 4) Real) :
    metricVariationPairing (tensor + tensor') variation =
      metricVariationPairing tensor variation +
        metricVariationPairing tensor' variation := by
  unfold metricVariationPairing
  rw [Matrix.transpose_add, Matrix.add_mul, Matrix.trace_add]

omit [Fintype Site] [DecidableEq Site] in
/-- The Frobenius pairing is homogeneous in its tensor argument. -/
theorem metricVariationPairing_smul_left
    (tensor variation : Matrix (Fin 4) (Fin 4) Real) (scalar : Real) :
    metricVariationPairing (scalar • tensor) variation =
      scalar * metricVariationPairing tensor variation := by
  unfold metricVariationPairing
  rw [Matrix.transpose_smul, Matrix.smul_mul, Matrix.trace_smul]
  rfl

omit [DecidableEq Site] in
/-- The finite Palatini response is additive in the connection variation. -/
theorem directedPalatiniConnectionResponse_add
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation variation' : DirectedConnection Site) :
    directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection (variation + variation') =
      directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection variation +
      directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection variation' := by
  classical
  unfold directedPalatiniConnectionResponse
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro site _
  rw [connectionRawRicciFirstVariation_add,
    metricVariationPairing_add_left]
  ring

omit [DecidableEq Site] in
/-- The finite Palatini response is homogeneous in the connection variation.
-/
theorem directedPalatiniConnectionResponse_smul
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) (scalar : Real) :
    directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection (scalar • variation) =
      scalar *
        directedPalatiniConnectionResponse (periodicTarget shift) volume
          inverseMetric connection variation := by
  classical
  unfold directedPalatiniConnectionResponse
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro site _
  rw [connectionRawRicciFirstVariation_smul,
    metricVariationPairing_smul_left]
  ring

/-- The connection response bundled as a real linear functional. -/
def directedPalatiniConnectionResponseLinear
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    DirectedConnection Site →ₗ[Real] Real where
  toFun := directedPalatiniConnectionResponse (periodicTarget shift) volume
    inverseMetric connection
  map_add' := directedPalatiniConnectionResponse_add shift volume inverseMetric
    connection
  map_smul' scalar variation := by
    rw [directedPalatiniConnectionResponse_smul shift volume inverseMetric
      connection variation scalar]
    rfl

/-- The volume-weighted inverse metric that is natural in the Palatini
connection equation. -/
def densitizedInverseMetric
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (site : Site) (left right : Fin 4) : Real :=
  volume site * inverseMetric site left right

/-- Closed local coefficient of an ordered connection variation
`H^upper_left right`.  The first two terms are the periodic backward-divergence
response and the remaining four are the connection cross terms. -/
def explicitConnectionEulerCoefficient
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) : Real :=
  backwardDifference shift
      (fun nextSite =>
        densitizedInverseMetric volume inverseMetric nextSite right left)
      site upper
    - (if upper = left then
        Finset.sum Finset.univ (fun direction =>
          backwardDifference shift
            (fun nextSite =>
              densitizedInverseMetric volume inverseMetric nextSite right
                direction)
            site direction)
      else 0)
    + (if upper = left then
        Finset.sum Finset.univ (fun metricLeft =>
          Finset.sum Finset.univ (fun metricRight =>
            densitizedInverseMetric volume inverseMetric site metricLeft
                metricRight *
              connection site right metricRight metricLeft))
      else 0)
    + densitizedInverseMetric volume inverseMetric site right left *
        Finset.sum Finset.univ (fun traced =>
          connection site traced traced upper)
    - Finset.sum Finset.univ (fun metricLeft =>
        densitizedInverseMetric volume inverseMetric site metricLeft left *
          connection site right upper metricLeft)
    - Finset.sum Finset.univ (fun metricRight =>
        densitizedInverseMetric volume inverseMetric site right metricRight *
          connection site left metricRight upper)

/-- Sitewise ordered-component Euler coefficient, defined by evaluating the
derived response on the corresponding unit connection probe. -/
def connectionEulerCoefficient
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) : Real :=
  directedPalatiniConnectionResponse (periodicTarget shift) volume
    inverseMetric connection (connectionComponentProbe site upper left right)

def derivativeRiemannResponse
    (target : Site -> Fin 4 -> Site) (variation : DirectedConnection Site)
    (site : Site) (upper lower left right : Fin 4) : Real :=
  connectionFirstJet target variation site left upper right lower -
    connectionFirstJet target variation site right upper left lower

def algebraicRiemannResponse
    (connection variation : DirectedConnection Site)
    (site : Site) (upper lower left right : Fin 4) : Real :=
  Finset.sum Finset.univ (fun middle =>
    variation site upper left middle * connection site middle right lower +
      connection site upper left middle * variation site middle right lower -
      variation site upper right middle * connection site middle left lower -
      connection site upper right middle * variation site middle left lower)

theorem connectionRiemannFirstVariation_split
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site)
    (site : Site) (upper lower left right : Fin 4) :
    connectionRiemannFirstVariation target connection variation site upper
        lower left right =
      derivativeRiemannResponse target variation site upper lower left right +
        algebraicRiemannResponse connection variation site upper lower left
          right := by
  rfl

def derivativeRawRicciResponse
    (target : Site -> Fin 4 -> Site) (variation : DirectedConnection Site)
    (site : Site) : Matrix (Fin 4) (Fin 4) Real :=
  fun lower right => Finset.sum Finset.univ (fun upper =>
    derivativeRiemannResponse target variation site upper lower upper right)

def algebraicRawRicciResponse
    (connection variation : DirectedConnection Site)
    (site : Site) : Matrix (Fin 4) (Fin 4) Real :=
  fun lower right => Finset.sum Finset.univ (fun upper =>
    algebraicRiemannResponse connection variation site upper lower upper right)

def derivativePalatiniResponse
    (target : Site -> Fin 4 -> Site) (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (variation : DirectedConnection Site) : Real :=
  Finset.sum Finset.univ (fun site =>
    volume site *
      metricVariationPairing (derivativeRawRicciResponse target variation site)
        (inverseMetric site))

def algebraicPalatiniResponse
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) : Real :=
  Finset.sum Finset.univ (fun site =>
    volume site *
      metricVariationPairing
        (algebraicRawRicciResponse connection variation site)
        (inverseMetric site))

theorem directedPalatiniConnectionResponse_split
    (target : Site -> Fin 4 -> Site) (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) :
    directedPalatiniConnectionResponse target volume inverseMetric connection
        variation =
      derivativePalatiniResponse target volume inverseMetric variation +
        algebraicPalatiniResponse volume inverseMetric connection variation := by
  unfold directedPalatiniConnectionResponse derivativePalatiniResponse
    algebraicPalatiniResponse
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro site _
  have hRaw :
      connectionRawRicciFirstVariation target connection variation site =
        derivativeRawRicciResponse target variation site +
          algebraicRawRicciResponse connection variation site := by
    ext lower right
    unfold connectionRawRicciFirstVariation derivativeRawRicciResponse
      algebraicRawRicciResponse
    change
      (Finset.sum Finset.univ (fun upper =>
          connectionRiemannFirstVariation target connection variation site
            upper lower upper right)) =
        Finset.sum Finset.univ (fun upper =>
            derivativeRiemannResponse target variation site upper lower upper
              right) +
          Finset.sum Finset.univ (fun upper =>
            algebraicRiemannResponse connection variation site upper lower
              upper right)
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro upper _
    exact connectionRiemannFirstVariation_split target connection variation
      site upper lower upper right
  rw [hRaw]
  unfold metricVariationPairing
  rw [Matrix.transpose_add, Matrix.add_mul, Matrix.trace_add]
  ring

def derivativeEulerCoefficient
    (shift : Fin 4 -> Equiv Site Site) (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (site : Site) (upper left right : Fin 4) : Real :=
  derivativePalatiniResponse (periodicTarget shift) volume inverseMetric
    (connectionComponentProbe site upper left right)

def algebraicEulerCoefficient
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) : Real :=
  algebraicPalatiniResponse volume inverseMetric connection
    (connectionComponentProbe site upper left right)

def explicitDerivativeCoefficient
    (shift : Fin 4 -> Equiv Site Site) (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (site : Site) (upper left right : Fin 4) : Real :=
  backwardDifference shift
      (fun nextSite =>
        densitizedInverseMetric volume inverseMetric nextSite right left)
      site upper -
    (if upper = left then
      Finset.sum Finset.univ (fun direction =>
        backwardDifference shift
          (fun nextSite =>
            densitizedInverseMetric volume inverseMetric nextSite right
              direction)
          site direction)
    else 0)

def explicitAlgebraicCoefficient
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) : Real :=
  (if upper = left then
      Finset.sum Finset.univ (fun metricLeft =>
        Finset.sum Finset.univ (fun metricRight =>
          densitizedInverseMetric volume inverseMetric site metricLeft
              metricRight *
            connection site right metricRight metricLeft))
    else 0) +
    densitizedInverseMetric volume inverseMetric site right left *
      Finset.sum Finset.univ (fun traced =>
        connection site traced traced upper) -
    Finset.sum Finset.univ (fun metricLeft =>
      densitizedInverseMetric volume inverseMetric site metricLeft left *
        connection site right upper metricLeft) -
    Finset.sum Finset.univ (fun metricRight =>
      densitizedInverseMetric volume inverseMetric site right metricRight *
        connection site left metricRight upper)

/-- Scalar site-probe summation by parts returned by the first Aristotle run.
It is included here so the derivative target starts from the proved periodic
reindexing step. -/
lemma periodic_sum_probe_edgeDifference
    (shift : Fin 4 -> Equiv Site Site) (weight : Site -> Real)
    (site : Site) (direction : Fin 4) :
    Finset.sum Finset.univ (fun x =>
        weight x * edgeDifference (periodicTarget shift)
          (Pi.single site (1 : Real)) x direction) =
      backwardDifference shift weight site direction := by
  unfold edgeDifference backwardDifference periodicTarget
  simp +decide [Pi.single_apply, sub_eq_add_neg]
  simp +decide [mul_add, Finset.sum_add_distrib]
  rw [Finset.sum_eq_single ((shift direction).symm site)] <;> aesop

/-- A weighted ordered-component probe collapses to its unique supporting
site and component. -/
lemma sum_weight_mul_connectionComponentProbe
    (weight : Site -> Real) (site : Site) (upper left right : Fin 4)
    (probeUpper probeLeft probeRight : Fin 4) :
    Finset.sum Finset.univ (fun nextSite =>
        weight nextSite *
          connectionComponentProbe site upper left right nextSite probeUpper
            probeLeft probeRight) =
      if probeUpper = upper ∧ probeLeft = left ∧ probeRight = right then
        weight site
      else 0 := by
  rw [Finset.sum_eq_single site]
  · by_cases hUpper : probeUpper = upper <;>
      by_cases hLeft : probeLeft = left <;>
      by_cases hRight : probeRight = right <;>
      simp [connectionComponentProbe, hUpper, hLeft, hRight]
  · intro nextSite _ hSite
    simp [connectionComponentProbe, hSite]
  · simp

/-- Pointwise evaluation of the ordered component probe. -/
lemma connectionComponentProbe_apply_eq
    (site nextSite : Site) (upper left right : Fin 4)
    (probeUpper probeLeft probeRight : Fin 4) :
    connectionComponentProbe site upper left right nextSite probeUpper
        probeLeft probeRight =
      if probeUpper = upper ∧ probeLeft = left ∧ probeRight = right then
        (Pi.single site (1 : Real) : Site -> Real) nextSite
      else 0 := by
  by_cases hSite : nextSite = site <;>
  by_cases hUpper : probeUpper = upper <;>
    by_cases hLeft : probeLeft = left <;>
    by_cases hRight : probeRight = right <;>
    simp [connectionComponentProbe, Pi.single_apply, hSite, hUpper, hLeft,
      hRight]

/-- The first jet of an ordered component probe is the scalar site probe when
the three ordered indices match, and vanishes otherwise. -/
lemma connectionFirstJet_connectionComponentProbe
    (shift : Fin 4 -> Equiv Site Site)
    (site nextSite : Site) (upper left right direction : Fin 4)
    (probeUpper probeLeft probeRight : Fin 4) :
    connectionFirstJet (periodicTarget shift)
        (connectionComponentProbe site upper left right) nextSite direction
        probeUpper probeLeft probeRight =
      if probeUpper = upper ∧ probeLeft = left ∧ probeRight = right then
        edgeDifference (periodicTarget shift) (Pi.single site (1 : Real))
          nextSite direction
      else 0 := by
  unfold connectionFirstJet edgeDifference
  change
    connectionComponentProbe site upper left right
          (periodicTarget shift nextSite direction) probeUpper probeLeft
          probeRight -
        connectionComponentProbe site upper left right nextSite probeUpper
          probeLeft probeRight = _
  rw [connectionComponentProbe_apply_eq,
    connectionComponentProbe_apply_eq]
  by_cases hIndices :
      probeUpper = upper ∧ probeLeft = left ∧ probeRight = right <;>
    simp [hIndices]

/-- The first Ricci-derivative contraction selects the probe's three ordered
indices. -/
lemma sum_connectionFirstJet_probe_firstRicciBranch
    (shift : Fin 4 -> Equiv Site Site)
    (site nextSite : Site) (upper left right metricRight metricLeft : Fin 4) :
    Finset.sum Finset.univ (fun contractedUpper =>
        connectionFirstJet (periodicTarget shift)
          (connectionComponentProbe site upper left right) nextSite
          contractedUpper contractedUpper metricRight metricLeft) =
      if metricRight = left ∧ metricLeft = right then
        edgeDifference (periodicTarget shift) (Pi.single site (1 : Real))
          nextSite upper
      else 0 := by
  simp_rw [connectionFirstJet_connectionComponentProbe]
  by_cases hMetricRight : metricRight = left <;>
    by_cases hMetricLeft : metricLeft = right <;>
    simp [hMetricRight, hMetricLeft]

/-- The traced Ricci-derivative contraction survives exactly when the probe's
upper and derivative-direction indices agree. -/
lemma sum_connectionFirstJet_probe_secondRicciBranch
    (shift : Fin 4 -> Equiv Site Site)
    (site nextSite : Site) (upper left right metricRight metricLeft : Fin 4) :
    Finset.sum Finset.univ (fun contractedUpper =>
        connectionFirstJet (periodicTarget shift)
          (connectionComponentProbe site upper left right) nextSite metricRight
          contractedUpper contractedUpper metricLeft) =
      if upper = left ∧ metricLeft = right then
        edgeDifference (periodicTarget shift) (Pi.single site (1 : Real))
          nextSite metricRight
      else 0 := by
  simp_rw [connectionFirstJet_connectionComponentProbe]
  by_cases hUpperLeft : upper = left
  · subst left
    by_cases hMetricLeft : metricLeft = right <;>
      simp [hMetricLeft]
  · have hNoCommon : forall contractedUpper,
        ¬(contractedUpper = upper ∧ contractedUpper = left) := by
      intro contractedUpper hBoth
      exact hUpperLeft (hBoth.1.symm.trans hBoth.2)
    by_cases hMetricLeft : metricLeft = right <;>
      simp [hUpperLeft, hMetricLeft, hNoCommon]

/-- Pointwise contraction of the two derivative branches against the
densitized inverse metric. -/
lemma derivativeProbe_localContraction
    (shift : Fin 4 -> Equiv Site Site) (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (site nextSite : Site) (upper left right : Fin 4) :
    volume nextSite *
        Finset.sum Finset.univ (fun metricRight =>
          Finset.sum Finset.univ (fun metricLeft =>
            ((if metricRight = left ∧ metricLeft = right then
                edgeDifference (periodicTarget shift)
                  (Pi.single site (1 : Real)) nextSite upper
              else 0) -
              (if upper = left ∧ metricLeft = right then
                edgeDifference (periodicTarget shift)
                  (Pi.single site (1 : Real)) nextSite metricRight
              else 0)) *
              inverseMetric nextSite metricLeft metricRight)) =
      densitizedInverseMetric volume inverseMetric nextSite right left *
          edgeDifference (periodicTarget shift) (Pi.single site (1 : Real))
            nextSite upper -
        (if upper = left then
          Finset.sum Finset.univ (fun direction =>
            densitizedInverseMetric volume inverseMetric nextSite right
                direction *
              edgeDifference (periodicTarget shift)
                (Pi.single site (1 : Real)) nextSite direction)
      else 0) := by
  by_cases hUpperLeft : upper = left
  · subst left
    simp only [densitizedInverseMetric, true_and, ite_and]
    rw [Finset.mul_sum]
    simp_rw [Finset.mul_sum]
    have hPointwise (metricRight metricLeft : Fin 4) :
        (volume nextSite *
              (if metricRight = upper then
                if metricLeft = right then
                  edgeDifference (periodicTarget shift)
                    (Pi.single site (1 : Real)) nextSite upper
                else 0
              else 0)) *
              inverseMetric nextSite metricLeft metricRight -
            (volume nextSite *
              (if metricLeft = right then
                edgeDifference (periodicTarget shift)
                  (Pi.single site (1 : Real)) nextSite metricRight
              else 0)) *
              inverseMetric nextSite metricLeft metricRight =
          (if metricRight = upper then
            if metricLeft = right then
              volume nextSite *
                edgeDifference (periodicTarget shift)
                  (Pi.single site (1 : Real)) nextSite upper *
                inverseMetric nextSite metricLeft metricRight
            else 0
          else 0) -
            (if metricLeft = right then
              volume nextSite *
                edgeDifference (periodicTarget shift)
                  (Pi.single site (1 : Real)) nextSite metricRight *
                inverseMetric nextSite metricLeft metricRight
            else 0) := by
      by_cases hMetricRight : metricRight = upper <;>
        by_cases hMetricLeft : metricLeft = right <;>
        simp [hMetricRight, hMetricLeft]
    ring_nf
    simp_rw [hPointwise]
    simp_rw [Finset.sum_sub_distrib]
    simp
    have hCommute :
        Finset.sum Finset.univ (fun metricRight =>
          volume nextSite *
              edgeDifference (periodicTarget shift)
                (Pi.single site (1 : Real)) nextSite metricRight *
            inverseMetric nextSite right metricRight) =
          Finset.sum Finset.univ (fun metricRight =>
            volume nextSite * inverseMetric nextSite right metricRight *
              edgeDifference (periodicTarget shift)
                (Pi.single site (1 : Real)) nextSite metricRight) := by
      apply Finset.sum_congr rfl
      intro metricRight _
      ring
    rw [hCommute]
    ring
  · simp [hUpperLeft, densitizedInverseMetric, ite_and]
    ring

/-
Proof handoff 1:
Use periodic summation by parts for the two first-jet terms.  Preserve the
ordered indices; in particular the trace subtraction occurs only when
`upper = left`.
-/
theorem derivativeEulerCoefficient_eq_explicit
    (shift : Fin 4 -> Equiv Site Site) (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (site : Site) (upper left right : Fin 4) :
    derivativeEulerCoefficient shift volume inverseMetric site upper left
        right =
      explicitDerivativeCoefficient shift volume inverseMetric site upper left
        right := by
  classical
  unfold derivativeEulerCoefficient derivativePalatiniResponse
    derivativeRawRicciResponse metricVariationPairing
    explicitDerivativeCoefficient derivativeRiemannResponse
  simp only [Matrix.trace, Matrix.diag_apply, Matrix.mul_apply,
    Matrix.transpose_apply]
  simp_rw [Finset.sum_sub_distrib,
    sum_connectionFirstJet_probe_firstRicciBranch,
    sum_connectionFirstJet_probe_secondRicciBranch,
    derivativeProbe_localContraction]
  by_cases hUpperLeft : upper = left
  · rw [if_pos hUpperLeft]
    rw [Finset.sum_sub_distrib]
    rw [periodic_sum_probe_edgeDifference]
    congr 1
    simp only [if_pos hUpperLeft]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro direction _
    exact periodic_sum_probe_edgeDifference shift
      (fun nextSite =>
        densitizedInverseMetric volume inverseMetric nextSite right direction)
      site direction
  · rw [if_neg hUpperLeft]
    simp only [if_neg hUpperLeft, sub_zero]
    exact periodic_sum_probe_edgeDifference shift
      (fun nextSite =>
        densitizedInverseMetric volume inverseMetric nextSite right left)
      site upper

/-
Proof handoff 2:
Expand the four local connection cross terms.  This target has no shifted site
sum and should reduce to finite component-probe/index renaming.
-/

/-- The `H Gamma` branch with the Ricci-contracted upper index survives only
when the probe's upper and left indices agree. -/
lemma algebraicProbe_firstBranch
    (connection : DirectedConnection Site) (site nextSite : Site)
    (upper left right metricRight metricLeft : Fin 4) :
    Finset.sum Finset.univ (fun contractedUpper =>
      Finset.sum Finset.univ (fun middle =>
        if contractedUpper = upper ∧ contractedUpper = left ∧ middle = right
        then
          (Pi.single site (1 : Real) : Site -> Real) nextSite *
            connection nextSite middle metricRight metricLeft
        else 0)) =
      if upper = left then
        (Pi.single site (1 : Real) : Site -> Real) nextSite *
          connection nextSite right metricRight metricLeft
      else 0 := by
  by_cases hUpperLeft : upper = left
  · subst left
    simp [ite_and]
  · have hNoTriple : forall contractedUpper middle,
        ¬(contractedUpper = upper ∧ contractedUpper = left ∧ middle = right) := by
      intro contractedUpper middle hBoth
      exact hUpperLeft (hBoth.1.symm.trans hBoth.2.1)
    simp [hUpperLeft, hNoTriple]

/-- The `Gamma H` branch selects the metric pair and leaves the connection
trace over its contracted upper index. -/
lemma algebraicProbe_secondBranch
    (connection : DirectedConnection Site) (site nextSite : Site)
    (upper left right metricRight metricLeft : Fin 4) :
    Finset.sum Finset.univ (fun contractedUpper =>
      Finset.sum Finset.univ (fun middle =>
        if middle = upper ∧ metricRight = left ∧ metricLeft = right then
          connection nextSite contractedUpper contractedUpper middle *
            (Pi.single site (1 : Real) : Site -> Real) nextSite
        else 0)) =
      if metricRight = left ∧ metricLeft = right then
        Finset.sum Finset.univ (fun traced =>
          connection nextSite traced traced upper) *
            (Pi.single site (1 : Real) : Site -> Real) nextSite
      else 0 := by
  by_cases hMetricRight : metricRight = left <;>
    by_cases hMetricLeft : metricLeft = right <;>
    simp [hMetricRight, hMetricLeft, Finset.sum_mul]

/-- The two positive algebraic branches share the same pair of contracted
indices in the expanded curvature response. -/
lemma algebraicProbe_positiveBranches
    (connection : DirectedConnection Site) (site nextSite : Site)
    (upper left right metricRight metricLeft : Fin 4) :
    Finset.sum Finset.univ (fun contractedUpper =>
      Finset.sum Finset.univ (fun middle =>
        (if contractedUpper = upper ∧ contractedUpper = left ∧ middle = right
        then
          (Pi.single site (1 : Real) : Site -> Real) nextSite *
            connection nextSite middle metricRight metricLeft
        else 0) +
        (if middle = upper ∧ metricRight = left ∧ metricLeft = right then
          connection nextSite contractedUpper contractedUpper middle *
            (Pi.single site (1 : Real) : Site -> Real) nextSite
        else 0))) =
      (if upper = left then
        (Pi.single site (1 : Real) : Site -> Real) nextSite *
          connection nextSite right metricRight metricLeft
      else 0) +
      (if metricRight = left ∧ metricLeft = right then
        Finset.sum Finset.univ (fun traced =>
          connection nextSite traced traced upper) *
            (Pi.single site (1 : Real) : Site -> Real) nextSite
      else 0) := by
  simp_rw [Finset.sum_add_distrib]
  rw [algebraicProbe_firstBranch, algebraicProbe_secondBranch]

/-- The first negative algebraic branch selects the probe upper, left, and
right indices, leaving one metric-left contraction. -/
lemma algebraicProbe_thirdBranch
    (connection : DirectedConnection Site) (site nextSite : Site)
    (upper left right metricRight metricLeft : Fin 4) :
    Finset.sum Finset.univ (fun contractedUpper =>
      Finset.sum Finset.univ (fun middle =>
        if contractedUpper = upper ∧ metricRight = left ∧ middle = right then
          (Pi.single site (1 : Real) : Site -> Real) nextSite *
            connection nextSite middle contractedUpper metricLeft
        else 0)) =
      if metricRight = left then
        (Pi.single site (1 : Real) : Site -> Real) nextSite *
          connection nextSite right upper metricLeft
      else 0 := by
  by_cases hMetricRight : metricRight = left <;>
    simp [hMetricRight, ite_and]

/-- The second negative algebraic branch leaves one metric-right
contraction. -/
lemma algebraicProbe_fourthBranch
    (connection : DirectedConnection Site) (site nextSite : Site)
    (upper left right metricRight metricLeft : Fin 4) :
    Finset.sum Finset.univ (fun contractedUpper =>
      Finset.sum Finset.univ (fun middle =>
        if middle = upper ∧ contractedUpper = left ∧ metricLeft = right then
          connection nextSite contractedUpper metricRight middle *
            (Pi.single site (1 : Real) : Site -> Real) nextSite
        else 0)) =
      if metricLeft = right then
        connection nextSite left metricRight upper *
          (Pi.single site (1 : Real) : Site -> Real) nextSite
      else 0 := by
  by_cases hMetricLeft : metricLeft = right <;>
    simp [hMetricLeft, ite_and]

/-- Contraction of the four local algebraic branches against the inverse
metric, before the scalar site probe is summed. -/
lemma algebraicProbe_metricContraction
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) (site nextSite : Site)
    (upper left right : Fin 4) :
    Finset.sum Finset.univ (fun metricRight =>
      Finset.sum Finset.univ (fun metricLeft =>
        ((((if upper = left then
              (Pi.single site (1 : Real) : Site -> Real) nextSite *
                connection nextSite right metricRight metricLeft
            else 0) +
            (if metricRight = left ∧ metricLeft = right then
              Finset.sum Finset.univ (fun traced =>
                  connection nextSite traced traced upper) *
                (Pi.single site (1 : Real) : Site -> Real) nextSite
            else 0)) -
          (if metricRight = left then
            (Pi.single site (1 : Real) : Site -> Real) nextSite *
              connection nextSite right upper metricLeft
          else 0)) -
          (if metricLeft = right then
            connection nextSite left metricRight upper *
              (Pi.single site (1 : Real) : Site -> Real) nextSite
          else 0)) *
          inverseMetric nextSite metricLeft metricRight)) =
      (Pi.single site (1 : Real) : Site -> Real) nextSite *
        ((if upper = left then
            Finset.sum Finset.univ (fun metricLeft =>
              Finset.sum Finset.univ (fun metricRight =>
                inverseMetric nextSite metricLeft metricRight *
                  connection nextSite right metricRight metricLeft))
          else 0) +
          inverseMetric nextSite right left *
            Finset.sum Finset.univ (fun traced =>
              connection nextSite traced traced upper) -
          Finset.sum Finset.univ (fun metricLeft =>
            inverseMetric nextSite metricLeft left *
              connection nextSite right upper metricLeft) -
          Finset.sum Finset.univ (fun metricRight =>
            inverseMetric nextSite right metricRight *
              connection nextSite left metricRight upper)) := by
  by_cases hUpperLeft : upper = left
  · subst left
    simp [ite_and, Finset.mul_sum, Finset.sum_mul]
    ring_nf
    simp_rw [Finset.sum_add_distrib, Finset.sum_sub_distrib]
    simp
    simp_rw [Finset.mul_sum, Finset.sum_mul]
    ring_nf
    have hDoubleCommute :
        Finset.sum Finset.univ (fun metricRight =>
          Finset.sum Finset.univ (fun metricLeft =>
            (Pi.single site (1 : Real) : Site -> Real) nextSite *
                connection nextSite right metricRight metricLeft *
              inverseMetric nextSite metricLeft metricRight)) =
          Finset.sum Finset.univ (fun metricRight =>
            Finset.sum Finset.univ (fun metricLeft =>
              (Pi.single site (1 : Real) : Site -> Real) nextSite *
                  inverseMetric nextSite metricLeft metricRight *
                connection nextSite right metricRight metricLeft)) := by
      apply Finset.sum_congr rfl
      intro metricRight _
      apply Finset.sum_congr rfl
      intro metricLeft _
      ring
    have hThirdCommute :
        Finset.sum Finset.univ (fun metricLeft =>
          (Pi.single site (1 : Real) : Site -> Real) nextSite *
              connection nextSite right upper metricLeft *
            inverseMetric nextSite metricLeft upper) =
          Finset.sum Finset.univ (fun metricLeft =>
            (Pi.single site (1 : Real) : Site -> Real) nextSite *
                inverseMetric nextSite metricLeft upper *
              connection nextSite right upper metricLeft) := by
      apply Finset.sum_congr rfl
      intro metricLeft _
      ring
    have hFourthCommute :
        Finset.sum Finset.univ (fun metricRight =>
          (Pi.single site (1 : Real) : Site -> Real) nextSite *
              connection nextSite upper metricRight upper *
            inverseMetric nextSite right metricRight) =
          Finset.sum Finset.univ (fun metricRight =>
            (Pi.single site (1 : Real) : Site -> Real) nextSite *
                inverseMetric nextSite right metricRight *
              connection nextSite upper metricRight upper) := by
      apply Finset.sum_congr rfl
      intro metricRight _
      ring
    rw [hDoubleCommute, hThirdCommute, hFourthCommute]
    have hDoubleSwap :
        Finset.sum Finset.univ (fun metricRight =>
          Finset.sum Finset.univ (fun metricLeft =>
            (Pi.single site (1 : Real) : Site -> Real) nextSite *
                inverseMetric nextSite metricLeft metricRight *
              connection nextSite right metricRight metricLeft)) =
          Finset.sum Finset.univ (fun metricLeft =>
            Finset.sum Finset.univ (fun metricRight =>
              (Pi.single site (1 : Real) : Site -> Real) nextSite *
                  inverseMetric nextSite metricLeft metricRight *
                connection nextSite right metricRight metricLeft)) := by
      exact Finset.sum_comm
    rw [hDoubleSwap]
    ring
  · simp [hUpperLeft, ite_and, Finset.mul_sum, Finset.sum_mul]
    ring_nf
    simp_rw [Finset.sum_add_distrib, Finset.sum_sub_distrib]
    simp
    simp_rw [Finset.mul_sum, Finset.sum_mul]
    ring_nf
    have hThirdCommute :
        Finset.sum Finset.univ (fun metricLeft =>
          (Pi.single site (1 : Real) : Site -> Real) nextSite *
              connection nextSite right upper metricLeft *
            inverseMetric nextSite metricLeft left) =
          Finset.sum Finset.univ (fun metricLeft =>
            (Pi.single site (1 : Real) : Site -> Real) nextSite *
                inverseMetric nextSite metricLeft left *
              connection nextSite right upper metricLeft) := by
      apply Finset.sum_congr rfl
      intro metricLeft _
      ring
    have hFourthCommute :
        Finset.sum Finset.univ (fun metricRight =>
          (Pi.single site (1 : Real) : Site -> Real) nextSite *
              connection nextSite left metricRight upper *
            inverseMetric nextSite right metricRight) =
          Finset.sum Finset.univ (fun metricRight =>
            (Pi.single site (1 : Real) : Site -> Real) nextSite *
                inverseMetric nextSite right metricRight *
              connection nextSite left metricRight upper) := by
      apply Finset.sum_congr rfl
      intro metricRight _
      ring
    rw [hThirdCommute, hFourthCommute]
    ring

theorem algebraicEulerCoefficient_eq_explicit
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) :
    algebraicEulerCoefficient volume inverseMetric connection site upper left
        right =
      explicitAlgebraicCoefficient volume inverseMetric connection site upper
        left right := by
  classical
  unfold algebraicEulerCoefficient algebraicPalatiniResponse
    algebraicRawRicciResponse metricVariationPairing
    explicitAlgebraicCoefficient algebraicRiemannResponse
  simp only [Matrix.trace, Matrix.diag_apply, Matrix.mul_apply,
    Matrix.transpose_apply]
  simp_rw [connectionComponentProbe_apply_eq]
  simp_rw [mul_ite, ite_mul]
  simp only [zero_mul, mul_zero]
  simp_rw [Finset.sum_sub_distrib]
  simp_rw [algebraicProbe_positiveBranches]
  simp_rw [algebraicProbe_thirdBranch]
  simp_rw [algebraicProbe_fourthBranch]
  simp_rw [algebraicProbe_metricContraction]
  rw [Finset.sum_eq_single site]
  · by_cases hUpperLeft : upper = left
    · simp [hUpperLeft, densitizedInverseMetric,
        Finset.mul_sum]
      have hDoubleVolume :
          volume site * Finset.sum Finset.univ (fun metricLeft =>
            Finset.sum Finset.univ (fun metricRight =>
              inverseMetric site metricLeft metricRight *
                connection site right metricRight metricLeft)) =
            Finset.sum Finset.univ (fun metricLeft =>
              Finset.sum Finset.univ (fun metricRight =>
                volume site * inverseMetric site metricLeft metricRight *
                  connection site right metricRight metricLeft)) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro metricLeft _
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro metricRight _
        ring
      have hTraceVolume :
          volume site * Finset.sum Finset.univ (fun traced =>
            inverseMetric site right left * connection site traced traced left) =
            Finset.sum Finset.univ (fun traced =>
              volume site * inverseMetric site right left *
                connection site traced traced left) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro traced _
        ring
      have hThirdVolume :
          volume site * Finset.sum Finset.univ (fun metricLeft =>
            inverseMetric site metricLeft left *
              connection site right left metricLeft) =
            Finset.sum Finset.univ (fun metricLeft =>
              volume site * inverseMetric site metricLeft left *
                connection site right left metricLeft) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro metricLeft _
        ring
      have hFourthVolume :
          volume site * Finset.sum Finset.univ (fun metricRight =>
            inverseMetric site right metricRight *
              connection site left metricRight left) =
            Finset.sum Finset.univ (fun metricRight =>
              volume site * inverseMetric site right metricRight *
                connection site left metricRight left) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro metricRight _
        ring
      ring_nf
      rw [hDoubleVolume, hTraceVolume, hThirdVolume, hFourthVolume]
    · simp [hUpperLeft, densitizedInverseMetric,
        Finset.mul_sum]
      have hTraceVolume :
          volume site * Finset.sum Finset.univ (fun traced =>
            inverseMetric site right left * connection site traced traced upper) =
            Finset.sum Finset.univ (fun traced =>
              volume site * inverseMetric site right left *
                connection site traced traced upper) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro traced _
        ring
      have hThirdVolume :
          volume site * Finset.sum Finset.univ (fun metricLeft =>
            inverseMetric site metricLeft left *
              connection site right upper metricLeft) =
            Finset.sum Finset.univ (fun metricLeft =>
              volume site * inverseMetric site metricLeft left *
                connection site right upper metricLeft) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro metricLeft _
        ring
      have hFourthVolume :
          volume site * Finset.sum Finset.univ (fun metricRight =>
            inverseMetric site right metricRight *
              connection site left metricRight upper) =
            Finset.sum Finset.univ (fun metricRight =>
              volume site * inverseMetric site right metricRight *
                connection site left metricRight upper) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro metricRight _
        ring
      ring_nf
      rw [hTraceVolume, hThirdVolume, hFourthVolume]
  · intro nextSite _ hNextSite
    simp [hNextSite]
  · simp

theorem explicitConnectionEulerCoefficient_split
    (shift : Fin 4 -> Equiv Site Site) (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) :
    explicitConnectionEulerCoefficient shift volume inverseMetric connection
        site upper left right =
      explicitDerivativeCoefficient shift volume inverseMetric site upper left
          right +
        explicitAlgebraicCoefficient volume inverseMetric connection site upper
          left right := by
  unfold explicitConnectionEulerCoefficient explicitDerivativeCoefficient
    explicitAlgebraicCoefficient
  ring

/-- The original unsplit theorem, now reduced to the two focused coefficient
targets above. -/
theorem connectionEulerCoefficient_eq_explicit_via_split
    (shift : Fin 4 -> Equiv Site Site) (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) :
    connectionEulerCoefficient shift volume inverseMetric connection site
        upper left right =
      explicitConnectionEulerCoefficient shift volume inverseMetric connection
        site upper left right := by
  unfold connectionEulerCoefficient
  rw [directedPalatiniConnectionResponse_split]
  change
    derivativeEulerCoefficient shift volume inverseMetric site upper left
          right +
        algebraicEulerCoefficient volume inverseMetric connection site upper
          left right =
      explicitConnectionEulerCoefficient shift volume inverseMetric connection
        site upper left right
  rw [derivativeEulerCoefficient_eq_explicit,
    algebraicEulerCoefficient_eq_explicit,
    ← explicitConnectionEulerCoefficient_split]


/-- The probe-defined Euler coefficient equals its local
densitized-inverse-metric formula. -/
theorem connectionEulerCoefficient_eq_explicit
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) :
    connectionEulerCoefficient shift volume inverseMetric connection site
        upper left right =
      explicitConnectionEulerCoefficient shift volume inverseMetric connection
        site upper left right := by
  exact connectionEulerCoefficient_eq_explicit_via_split shift volume
    inverseMetric connection site upper left right

/-- Vanishing of all local ordered-component coefficients is equivalent to
the full independent-connection Euler-Lagrange equation. -/
theorem connectionEulerLagrange_iff_coefficients
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    ConnectionEulerLagrange (periodicTarget shift) volume inverseMetric
        connection <->
      forall site upper left right,
        connectionEulerCoefficient shift volume inverseMetric connection site
          upper left right = 0 := by
  constructor
  · intro hEuler site upper left right
    exact hEuler (connectionComponentProbe site upper left right)
  · intro hCoefficient variation
    let response := directedPalatiniConnectionResponseLinear shift volume
      inverseMetric connection
    have hResponse : response = 0 := by
      apply LinearMap.pi_ext'
      intro site
      change response.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site) = 0
      apply LinearMap.pi_ext'
      intro upper
      change (response.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper) = 0
      apply LinearMap.pi_ext'
      intro left
      change ((response.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Fin 4 → Real) left) = 0
      apply LinearMap.pi_ext'
      intro right
      change (((response.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Fin 4 → Real) left)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Real) right) = 0
      apply LinearMap.ext
      intro scalar
      change response
        (Pi.single site
          (Pi.single upper (Pi.single left (Pi.single right scalar)))) = 0
      have hProbe :
          Pi.single site
              (Pi.single upper (Pi.single left (Pi.single right scalar))) =
            scalar • connectionComponentProbe site upper left right := by
        ext nextSite nextUpper nextLeft nextRight
        by_cases hSite : nextSite = site <;>
          by_cases hUpper : nextUpper = upper <;>
          by_cases hLeft : nextLeft = left <;>
          by_cases hRight : nextRight = right <;>
          simp [connectionComponentProbe, hSite, hUpper,
            hLeft, hRight]
      rw [hProbe, map_smul]
      change scalar * connectionEulerCoefficient shift volume inverseMetric
        connection site upper left right = 0
      rw [hCoefficient]
      simp
    change response variation = 0
    rw [hResponse]
    rfl

/-! ## Torsion-free variation sector -/

/-- Symmetry of the two lower indices of a connection variation. -/
def LowerIndexSymmetric (variation : DirectedConnection Site) : Prop :=
  forall site upper left right,
    variation site upper left right = variation site upper right left

/-- Projection of an arbitrary ordered connection variation onto its
lower-index-symmetric part. -/
def lowerIndexSymmetrize (variation : DirectedConnection Site) :
    DirectedConnection Site :=
  fun site upper left right =>
    (variation site upper left right + variation site upper right left) / 2

omit [Fintype Site] [DecidableEq Site] in
/-- Lower-index symmetrization produces a torsion-free variation. -/
theorem lowerIndexSymmetrize_symmetric (variation : DirectedConnection Site) :
    LowerIndexSymmetric (lowerIndexSymmetrize variation) := by
  intro site upper left right
  simp only [lowerIndexSymmetrize]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- Symmetrization fixes every lower-index-symmetric variation. -/
theorem lowerIndexSymmetrize_eq_of_symmetric
    (variation : DirectedConnection Site)
    (hSymmetric : LowerIndexSymmetric variation) :
    lowerIndexSymmetrize variation = variation := by
  funext site upper left right
  rw [lowerIndexSymmetrize, hSymmetric site upper right left]
  ring

/-- Lower-index symmetrization as a real linear map. -/
def lowerIndexSymmetrizeLinear :
    DirectedConnection Site →ₗ[Real] DirectedConnection Site where
  toFun := lowerIndexSymmetrize
  map_add' variation variation' := by
    ext site upper left right
    simp only [lowerIndexSymmetrize, Pi.add_apply]
    ring
  map_smul' scalar variation := by
    ext site upper left right
    simp only [lowerIndexSymmetrize, Pi.smul_apply, smul_eq_mul,
      RingHom.id_apply]
    ring

omit [Fintype Site] in
/-- Symmetrizing a component probe adds its lower-index transpose with the
standard factor `1 / 2`. -/
theorem lowerIndexSymmetrize_componentProbe
    (site : Site) (upper left right : Fin 4) :
    lowerIndexSymmetrize (connectionComponentProbe site upper left right) =
      (1 / 2 : Real) •
        (connectionComponentProbe site upper left right +
          connectionComponentProbe site upper right left) := by
  ext nextSite nextUpper nextLeft nextRight
  by_cases hSame : left = right <;>
    by_cases hSite : nextSite = site <;>
    by_cases hUpper : nextUpper = upper <;>
    by_cases hLeftLeft : nextLeft = left <;>
    by_cases hRightRight : nextRight = right <;>
    by_cases hLeftRight : nextLeft = right <;>
    by_cases hRightLeft : nextRight = left <;>
    simp_all [lowerIndexSymmetrize, connectionComponentProbe]
  all_goals ring

/-- Stationarity under all torsion-free (lower-index-symmetric) connection
variations. -/
def TorsionFreeConnectionEulerLagrange
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Prop :=
  forall variation : DirectedConnection Site,
    LowerIndexSymmetric variation ->
      directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection variation = 0

omit [DecidableEq Site] in
/-- Testing all torsion-free variations is equivalent to testing the
symmetrization of every ordered variation. -/
theorem torsionFreeConnectionEulerLagrange_iff_symmetrized
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    TorsionFreeConnectionEulerLagrange shift volume inverseMetric connection <->
      forall variation : DirectedConnection Site,
        directedPalatiniConnectionResponse (periodicTarget shift) volume
          inverseMetric connection (lowerIndexSymmetrize variation) = 0 := by
  constructor
  · intro hEuler variation
    exact hEuler (lowerIndexSymmetrize variation)
      (lowerIndexSymmetrize_symmetric variation)
  · intro hEuler variation hSymmetric
    rw [← lowerIndexSymmetrize_eq_of_symmetric variation hSymmetric]
    exact hEuler variation

/-- A linear functional on directed connections vanishes identically exactly
when it vanishes on every site-and-component probe. -/
theorem linearFunctional_eq_zero_iff_componentProbes
    (functional : DirectedConnection Site →ₗ[Real] Real) :
    (forall variation, functional variation = 0) <->
      forall site upper left right,
        functional (connectionComponentProbe site upper left right) = 0 := by
  constructor
  · intro hFunctional site upper left right
    exact hFunctional (connectionComponentProbe site upper left right)
  · intro hProbe variation
    have hFunctional : functional = 0 := by
      apply LinearMap.pi_ext'
      intro site
      change functional.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site) = 0
      apply LinearMap.pi_ext'
      intro upper
      change (functional.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper) = 0
      apply LinearMap.pi_ext'
      intro left
      change ((functional.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Fin 4 → Real) left) = 0
      apply LinearMap.pi_ext'
      intro right
      change (((functional.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Fin 4 → Real) left)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Real) right) = 0
      apply LinearMap.ext
      intro scalar
      change functional
        (Pi.single site
          (Pi.single upper (Pi.single left (Pi.single right scalar)))) = 0
      have hScaledProbe :
          Pi.single site
              (Pi.single upper (Pi.single left (Pi.single right scalar))) =
            scalar • connectionComponentProbe site upper left right := by
        ext nextSite nextUpper nextLeft nextRight
        by_cases hSite : nextSite = site <;>
          by_cases hUpper : nextUpper = upper <;>
          by_cases hLeft : nextLeft = left <;>
          by_cases hRight : nextRight = right <;>
          simp [connectionComponentProbe, hSite, hUpper, hLeft, hRight]
      rw [hScaledProbe, map_smul, hProbe]
      simp
    rw [hFunctional]
    rfl

/-- The torsion-free connection equation is the lower-index-symmetric
projection of the unrestricted local Euler coefficient. -/
theorem torsionFreeConnectionEulerLagrange_iff_symmetricCoefficients
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    TorsionFreeConnectionEulerLagrange shift volume inverseMetric connection <->
      forall site upper left right,
        connectionEulerCoefficient shift volume inverseMetric connection site
              upper left right +
            connectionEulerCoefficient shift volume inverseMetric connection
              site upper right left = 0 := by
  rw [torsionFreeConnectionEulerLagrange_iff_symmetrized]
  let response := directedPalatiniConnectionResponseLinear shift volume
    inverseMetric connection
  let symmetrizedResponse := response.comp lowerIndexSymmetrizeLinear
  change (forall variation, symmetrizedResponse variation = 0) <-> _
  rw [linearFunctional_eq_zero_iff_componentProbes]
  constructor
  · intro hProbe site upper left right
    have h := hProbe site upper left right
    change response
      (lowerIndexSymmetrize
        (connectionComponentProbe site upper left right)) = 0 at h
    rw [lowerIndexSymmetrize_componentProbe, map_smul, map_add] at h
    change (1 / 2 : Real) *
      (connectionEulerCoefficient shift volume inverseMetric connection site
          upper left right +
        connectionEulerCoefficient shift volume inverseMetric connection site
          upper right left) = 0 at h
    linarith
  · intro hCoefficient site upper left right
    change response
      (lowerIndexSymmetrize
        (connectionComponentProbe site upper left right)) = 0
    rw [lowerIndexSymmetrize_componentProbe, map_smul, map_add]
    change (1 / 2 : Real) *
      (connectionEulerCoefficient shift volume inverseMetric connection site
          upper left right +
        connectionEulerCoefficient shift volume inverseMetric connection site
          upper right left) = 0
    rw [hCoefficient]
    norm_num

/-! ## Exact finite conformal obstruction -/

/-- The forward three-cycle used by the finite conformal witness. -/
def conformalCycle3 : Equiv (Fin 3) (Fin 3) where
  toFun := ![1, 2, 0]
  invFun := ![2, 0, 1]
  left_inv site := by fin_cases site <;> rfl
  right_inv site := by fin_cases site <;> rfl

/-- Every coordinate direction uses the same periodic shift in the minimal
three-site witness. -/
def conformalTestShift (_ : Fin 4) : Equiv (Fin 3) (Fin 3) :=
  conformalCycle3

/-- Sitewise conformal factors induced by real spinor scales `1`, `2`, and
`3`: a spinor scale `r` gives the metric scale `r^4`. -/
def conformalTestScale : Fin 3 -> Real := ![1, 16, 81]

/-- Real sitewise scale of each canonical Weyl spinor. -/
def conformalTestSpinorScale : Fin 3 -> Real := ![1, 2, 3]

/-- Sitewise scaled canonical Weyl-spinor null edges underlying the conformal
witness. -/
def conformalTestEdges : NullEdgeDecoration (Fin 3) :=
  fun site edge component =>
    (conformalTestSpinorScale site : Complex) * canonicalNullEdges edge component

/-- Gram metric of the canonical four-null-edge coframe. -/
def canonicalNullEdgeMetricMatrix : Matrix (Fin 4) (Fin 4) Real :=
  !![0, 1 / 2, 1 / 2, 1 / 2;
     1 / 2, 0, 1 / 2, 1 / 2;
     1 / 2, 1 / 2, 0, 1;
     1 / 2, 1 / 2, 1, 0]

/-- Inverse of `canonicalNullEdgeMetricMatrix`. -/
def canonicalNullEdgeInverseMetricMatrix : Matrix (Fin 4) (Fin 4) Real :=
  !![-2, 0, 1, 1;
     0, -2, 1, 1;
     1, 1, -1, 0;
     1, 1, 0, -1]

/-- The displayed covariant matrix is exactly the Gram metric soldered from
the canonical four Weyl-spinor null edges. -/
theorem canonicalNullEdgeMetricMatrix_eq :
    nullEdgeMetricAt canonicalNullEdges = canonicalNullEdgeMetricMatrix := by
  rw [nullEdgeMetricAt, inducedCovariantMetric,
    canonicalNullEdgeCoframe_eq]
  ext left right
  fin_cases left <;> fin_cases right <;>
    norm_num [canonicalNullEdgeMetricMatrix, canonicalCoframe,
      minkowskiMetric, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The soldered coframe scales quadratically under the real spinor scales in
the conformal witness. -/
theorem conformalTestCoframe_eq (site : Fin 3) :
    nullEdgeCoframeAt (conformalTestEdges site) =
      (conformalTestSpinorScale site ^ 2) • canonicalCoframe := by
  ext coordinate edge
  change
    nullEdgeVector
        (fun component =>
          (conformalTestSpinorScale site : Complex) *
            canonicalNullEdges edge component)
        coordinate = _
  rw [nullEdgeVector_smul]
  change Complex.normSq (conformalTestSpinorScale site : Complex) *
      nullEdgeCoframeAt canonicalNullEdges coordinate edge =
    conformalTestSpinorScale site ^ 2 * canonicalCoframe coordinate edge
  rw [canonicalNullEdgeCoframe_eq]
  fin_cases site <;>
    norm_num [conformalTestSpinorScale, Complex.normSq_apply]

/-- The metric scale is the fourth power of the underlying real spinor scale.
-/
theorem conformalTestScale_eq_spinorScale_fourth (site : Fin 3) :
    conformalTestScale site = conformalTestSpinorScale site ^ 4 := by
  fin_cases site <;>
    norm_num [conformalTestScale, conformalTestSpinorScale]

/-- Conformally varying covariant metric in the three-site witness. -/
def conformalTestMetric (site : Fin 3) : Matrix (Fin 4) (Fin 4) Real :=
  conformalTestScale site • canonicalNullEdgeMetricMatrix

/-- The covariant metric in the obstruction is derived from the displayed
sitewise scaled null edges. -/
theorem conformalTestMetric_eq_nullEdgeMetric (site : Fin 3) :
    conformalTestMetric site = nullEdgeMetricAt (conformalTestEdges site) := by
  rw [nullEdgeMetricAt, conformalTestCoframe_eq, conformalTestMetric,
    conformalTestScale_eq_spinorScale_fourth,
    ← canonicalNullEdgeMetricMatrix_eq]
  simp only [nullEdgeMetricAt, inducedCovariantMetric]
  rw [canonicalNullEdgeCoframe_eq]
  ext left right
  simp only [Matrix.transpose_smul, Matrix.smul_mul, Matrix.mul_smul,
    Matrix.smul_apply, smul_eq_mul]
  ring

/-- Exact inverse metric of the conformal witness. -/
def conformalTestInverseMetric (site : Fin 3) :
    Matrix (Fin 4) (Fin 4) Real :=
  (conformalTestScale site)⁻¹ • canonicalNullEdgeInverseMetricMatrix

/-- The displayed canonical matrices are exact two-sided inverses. -/
theorem canonicalNullEdgeMetricMatrix_mul_inverse :
    canonicalNullEdgeMetricMatrix * canonicalNullEdgeInverseMetricMatrix = 1 := by
  ext left right
  fin_cases left <;> fin_cases right <;>
    norm_num [canonicalNullEdgeMetricMatrix,
      canonicalNullEdgeInverseMetricMatrix, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- The conformally scaled inverse is an exact inverse of the conformal Gram
metric at every site. -/
theorem conformalTestMetric_mul_inverse (site : Fin 3) :
    conformalTestMetric site * conformalTestInverseMetric site = 1 := by
  fin_cases site <;>
    ext left right <;>
    fin_cases left <;> fin_cases right <;>
    norm_num [conformalTestMetric, conformalTestInverseMetric,
      conformalTestScale, canonicalNullEdgeMetricMatrix,
      canonicalNullEdgeInverseMetricMatrix, Matrix.mul_apply,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Fin.sum_univ_succ]

/-- The scaled canonical spinors remain a nondegenerate null-edge frame. -/
def conformalTestFrame : NondegenerateNullEdgeFrame (Fin 3) where
  edges := conformalTestEdges
  det_ne_zero site := by
    change (nullEdgeCoframeAt (conformalTestEdges site)).det ≠ 0
    rw [conformalTestCoframe_eq, Matrix.det_smul, canonicalCoframe_det]
    fin_cases site <;>
      norm_num [conformalTestSpinorScale]

/-- Oriented coframe volume of the conformal witness. -/
def conformalTestVolume (site : Fin 3) : Real :=
  (1 / 2) * (conformalTestScale site) ^ 2

/-- The displayed volume is exactly the oriented volume reconstructed from
the scaled null-edge coframe. -/
theorem conformalTestVolume_eq_chartBaseVolume (site : Fin 3) :
    conformalTestVolume site =
      chartBaseVolume (nullEdgeCoframe conformalTestFrame.edges) site := by
  unfold conformalTestVolume chartBaseVolume coframeVolume nullEdgeCoframe
    conformalTestFrame
  rw [conformalTestCoframe_eq, Matrix.det_smul, canonicalCoframe_det]
  fin_cases site <;>
    norm_num [conformalTestScale, conformalTestSpinorScale]

/-- The displayed inverse is the inverse metric reconstructed by the
nondegenerate null-edge-frame API. -/
theorem conformalTestInverseMetric_eq_nullEdgeInverseMetric (site : Fin 3) :
    conformalTestInverseMetric site =
      nullEdgeInverseMetric conformalTestFrame site := by
  have hMetricInverse := conformalTestMetric_mul_inverse site
  have hInverseMetric :=
    nullEdgeInverseMetric_mul_metric conformalTestFrame site
  change nullEdgeInverseMetric conformalTestFrame site *
      nullEdgeMetricAt (conformalTestEdges site) = 1 at hInverseMetric
  rw [← conformalTestMetric_eq_nullEdgeMetric] at hInverseMetric
  calc
    conformalTestInverseMetric site =
        1 * conformalTestInverseMetric site := by rw [Matrix.one_mul]
    _ = (nullEdgeInverseMetric conformalTestFrame site *
          conformalTestMetric site) * conformalTestInverseMetric site := by
      rw [hInverseMetric]
    _ = nullEdgeInverseMetric conformalTestFrame site *
          (conformalTestMetric site * conformalTestInverseMetric site) := by
      rw [Matrix.mul_assoc]
    _ = nullEdgeInverseMetric conformalTestFrame site * 1 := by
      rw [hMetricInverse]
    _ = nullEdgeInverseMetric conformalTestFrame site := by rw [Matrix.mul_one]

/-- Directed null-edge chart underlying the conformal witness. -/
def conformalTestChart : DirectedNullEdgeChart (Fin 3) where
  toNondegenerateNullEdgeFrame := conformalTestFrame
  target := periodicTarget conformalTestShift

/-- Forward metric jet used by the current finite Christoffel construction. -/
def conformalTestMetricFirstJet (site : Fin 3) :
    Fin 4 -> Matrix (Fin 4) (Fin 4) Real :=
  fun direction left right =>
    edgeDifference (periodicTarget conformalTestShift)
      (fun nextSite => conformalTestMetric nextSite left right) site direction

/-- The displayed forward metric jet is the jet reconstructed by the directed
null-edge chart. -/
theorem conformalTestMetricFirstJet_eq_nullEdgeMetricFirstJet (site : Fin 3) :
    conformalTestMetricFirstJet site =
      nullEdgeMetricFirstJet conformalTestChart site := by
  funext direction left right
  unfold conformalTestMetricFirstJet nullEdgeMetricFirstJet edgeDifference
    conformalTestChart conformalTestFrame
  change
    conformalTestMetric
          (periodicTarget conformalTestShift site direction) left right -
        conformalTestMetric site left right =
      nullEdgeMetricAt
          (conformalTestEdges
            (periodicTarget conformalTestShift site direction)) left right -
        nullEdgeMetricAt (conformalTestEdges site) left right
  rw [conformalTestMetric_eq_nullEdgeMetric,
    conformalTestMetric_eq_nullEdgeMetric]

/-- Forward-difference Levi-Civita candidate of the conformal witness. -/
def conformalTestChristoffel : DirectedConnection (Fin 3) :=
  fun site => christoffelSecondKind (conformalTestInverseMetric site)
    (conformalTestMetricFirstJet site)

/-- The displayed connection is exactly the current forward-difference
Christoffel field reconstructed by the directed null-edge chart. -/
theorem conformalTestChristoffel_eq_nullEdgeChristoffel :
    conformalTestChristoffel = nullEdgeChristoffel conformalTestChart := by
  funext site upper left right
  unfold conformalTestChristoffel nullEdgeChristoffel
  change christoffelSecondKind (conformalTestInverseMetric site)
      (conformalTestMetricFirstJet site) upper left right =
    christoffelSecondKind (nullEdgeInverseMetric conformalTestFrame site)
      (nullEdgeMetricFirstJet conformalTestChart site) upper left right
  rw [conformalTestInverseMetric_eq_nullEdgeInverseMetric,
    conformalTestMetricFirstJet_eq_nullEdgeMetricFirstJet]

/-- **Exact finite obstruction.**  The ordered local Palatini coefficient of
the current forward-difference Christoffel candidate is nonzero on a simple
three-site conformal geometry. -/
theorem conformalTest_explicitCoefficient_0000 :
    explicitConnectionEulerCoefficient conformalTestShift conformalTestVolume
      conformalTestInverseMetric conformalTestChristoffel 0 0 0 0 = -95 := by
  norm_num [explicitConnectionEulerCoefficient, backwardDifference,
    densitizedInverseMetric, conformalTestShift, conformalCycle3,
    conformalTestScale, conformalTestVolume, conformalTestInverseMetric,
    conformalTestChristoffel, conformalTestMetricFirstJet,
    conformalTestMetric, canonicalNullEdgeMetricMatrix,
    canonicalNullEdgeInverseMetricMatrix, periodicTarget, edgeDifference,
    christoffelSecondKind, christoffelFirstKind, Matrix.of_apply,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Fin.sum_univ_succ]

/-- The forward-difference Christoffel candidate fails even the torsion-free
connection equation on the conformal witness. -/
theorem conformalTestChristoffel_not_torsionFreeEuler :
    ¬ TorsionFreeConnectionEulerLagrange conformalTestShift
      conformalTestVolume conformalTestInverseMetric
      conformalTestChristoffel := by
  intro hEuler
  have hLocal :=
    (torsionFreeConnectionEulerLagrange_iff_symmetricCoefficients
      conformalTestShift conformalTestVolume conformalTestInverseMetric
      conformalTestChristoffel).mp hEuler 0 0 0 0
  have hCoefficient :
      connectionEulerCoefficient conformalTestShift conformalTestVolume
        conformalTestInverseMetric conformalTestChristoffel 0 0 0 0 = -95 := by
    rw [connectionEulerCoefficient_eq_explicit]
    exact conformalTest_explicitCoefficient_0000
  rw [hCoefficient] at hLocal
  norm_num at hLocal

/-- **Null-edge Palatini no-go for the current finite difference.**  The
Christoffel field reconstructed from a nondegenerate directed null-edge chart
is not stationary under torsion-free connection variations on this exact
three-site conformal witness. -/
theorem conformalNullEdgeChristoffel_not_torsionFreeEuler :
    ¬ TorsionFreeConnectionEulerLagrange conformalTestShift
      (chartBaseVolume (nullEdgeCoframe conformalTestFrame.edges))
      (nullEdgeInverseMetric conformalTestFrame)
      (nullEdgeChristoffel conformalTestChart) := by
  intro hEuler
  have hVolume :
      chartBaseVolume (nullEdgeCoframe conformalTestFrame.edges) =
        conformalTestVolume := by
    funext site
    exact (conformalTestVolume_eq_chartBaseVolume site).symm
  have hInverseMetric :
      nullEdgeInverseMetric conformalTestFrame =
        conformalTestInverseMetric := by
    funext site
    exact (conformalTestInverseMetric_eq_nullEdgeInverseMetric site).symm
  have hConnection :
      nullEdgeChristoffel conformalTestChart =
        conformalTestChristoffel :=
    conformalTestChristoffel_eq_nullEdgeChristoffel.symm
  rw [hVolume, hInverseMetric, hConnection] at hEuler
  exact conformalTestChristoffel_not_torsionFreeEuler hEuler

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation.sum_weight_mul_connectionFirstJet_periodic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sum_weight_mul_connectionFirstJet_periodic

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation.connectionEulerLagrange_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionEulerLagrange_iff_coefficients

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation.connectionEulerCoefficient_eq_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionEulerCoefficient_eq_explicit

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation.torsionFreeConnectionEulerLagrange_iff_symmetricCoefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms torsionFreeConnectionEulerLagrange_iff_symmetricCoefficients

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation.conformalTest_explicitCoefficient_0000' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conformalTest_explicitCoefficient_0000

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation.conformalNullEdgeChristoffel_not_torsionFreeEuler' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conformalNullEdgeChristoffel_not_torsionFreeEuler

end PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation
