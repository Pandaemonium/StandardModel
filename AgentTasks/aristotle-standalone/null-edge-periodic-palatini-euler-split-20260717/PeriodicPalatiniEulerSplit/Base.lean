import Mathlib

/-!
# Focused periodic Palatini Euler-coefficient target

This standalone file mirrors the definitions used by
`PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation` closely enough
that a proof of the final theorem can be transferred back to the live module.
-/

noncomputable section

namespace PeriodicPalatiniEuler

open scoped BigOperators
open Matrix

abbrev DirectedConnection (Site : Type*) :=
  Site -> Fin 4 -> Fin 4 -> Fin 4 -> Real

def periodicTarget {Site : Type*} (shift : Fin 4 -> Equiv Site Site) :
    Site -> Fin 4 -> Site :=
  fun site direction => shift direction site

def edgeDifference {Site : Type*}
    (target : Site -> Fin 4 -> Site) (field : Site -> Real)
    (site : Site) (direction : Fin 4) : Real :=
  field (target site direction) - field site

def connectionFirstJet {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection : DirectedConnection Site)
    (site : Site) (direction upper left right : Fin 4) : Real :=
  edgeDifference target (fun nextSite => connection nextSite upper left right)
    site direction

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

def connectionRawRicciFirstVariation {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site) (site : Site) :
    Matrix (Fin 4) (Fin 4) Real :=
  fun lower right => Finset.sum Finset.univ (fun upper =>
    connectionRiemannFirstVariation target connection variation site upper
      lower upper right)

def metricVariationPairing
    (tensor variation : Matrix (Fin 4) (Fin 4) Real) : Real :=
  Matrix.trace (tensor.transpose * variation)

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

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

def backwardDifference
    (shift : Fin 4 -> Equiv Site Site)
    (field : Site -> Real) (site : Site) (direction : Fin 4) : Real :=
  field ((shift direction).symm site) - field site

def connectionComponentProbe
    (site : Site) (upper left right : Fin 4) : DirectedConnection Site :=
  Pi.single site
    (Pi.single upper (Pi.single left (Pi.single right (1 : Real))))

def densitizedInverseMetric
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (site : Site) (left right : Fin 4) : Real :=
  volume site * inverseMetric site left right

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

def connectionEulerCoefficient
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) : Real :=
  directedPalatiniConnectionResponse (periodicTarget shift) volume
    inverseMetric connection (connectionComponentProbe site upper left right)

/-
Proof handoff:
Expand the matrix trace and Ricci response.  The two first-jet terms are
periodic summation-by-parts identities; reindex each forward-shift sum with
`Equiv.sum_comp`.  The four algebraic terms are finite-index renamings.  Keep
the exact ordered indices and do not impose symmetry on the connection.
-/
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
  sorry

end PeriodicPalatiniEuler
