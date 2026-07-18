import PeriodicPalatiniEulerSplit.Base

/-!
# Split periodic Palatini Euler-coefficient targets

This focused successor separates the first-jet and algebraic connection
responses before asking for the local probe coefficients.  The imported file
contains the original unsplit target; this module must prove the same statement
without changing any definition or index convention.
-/

noncomputable section

namespace PeriodicPalatiniEulerSplit

open scoped BigOperators
open Matrix
open PeriodicPalatiniEuler

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

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
      simp [connectionComponentProbe, Pi.single_apply, hUpper, hLeft, hRight]
  · intro nextSite _ hSite
    simp [connectionComponentProbe, Pi.single_apply, hSite]
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
      hRight, eq_comm]

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
    simp only [densitizedInverseMetric, if_pos rfl, true_and, ite_and]
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
  · simp [hUpperLeft, densitizedInverseMetric, ite_and, Finset.mul_sum]
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
    simp [hMetricRight, hMetricLeft, ite_and, Finset.sum_mul]

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
    · simp [hUpperLeft, Pi.single_apply, densitizedInverseMetric,
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
    · simp [hUpperLeft, Pi.single_apply, densitizedInverseMetric,
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
    simp [Pi.single_apply, hNextSite]
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

end PeriodicPalatiniEulerSplit
