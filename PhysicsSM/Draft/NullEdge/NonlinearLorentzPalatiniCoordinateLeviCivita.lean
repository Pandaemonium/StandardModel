import PhysicsSM.Draft.NullEdge.CausalLeviCivita
import PhysicsSM.Draft.NullEdge.CoframeVolumeMetricVariation
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelectionCapstone

noncomputable section

/-!
# Palatini first jets select the induced Levi-Civita connection

This module closes the finite first-jet bridge between the Lorentz-link
Palatini equation and the coordinate Levi-Civita connection.

For an invertible coframe `e`, inverse coframe `eInv`, predecessor coframe jet
`v_a`, and infinitesimal Lorentz connection `omega_a`, define

`Gamma_a = eInv (hat(omega_a) e - v_a)`.

The sign reflects the project convention that predecessor coframe increments
are minus the usual forward derivative.  The induced metric and first jet are

`g = e^T eta e`,
`partial_a g = -(v_a^T eta e + e^T eta v_a)`.

The Cartan torsion equation makes `Gamma` symmetric in its two lower
coordinate indices.  Lorentz-Lie-algebra skewness makes it metric-compatible.
The finite Levi-Civita uniqueness theorem then identifies it with the
Christoffel connection of the induced metric first jet.  Composing with the
existing Palatini-residual/torsion equivalence proves that vanishing finite
connection Euler coefficients select this induced Levi-Civita connection at
first order. At the identity coframe, the existing ordinary-derivative
link-Euler capstone composes to the same result for site-uniform exponential
link variations of the actual nonlinear action.

This is a finite first-jet theorem.  It does not assert nonlinear fixed-spacing
selection, graph-derived coframes, or refinement convergence.  Claim label:
finite Palatini-to-Levi-Civita selection identity.  Originality tag:
`[comp/orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita

open PhysicsSM.Draft.NullEdge.CausalLeviCivita
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.CoframeVolumeMetricVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-- The mostly-minus internal metric is symmetric. -/
theorem minkowskiEta_isSymm :
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) Real).IsSymm := by
  ext left right
  fin_cases left <;> fin_cases right <;> simp [MinkowskiConvention.eta]

/-- The mostly-minus internal metric is its own matrix inverse. -/
theorem minkowskiEta_mul_self :
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) Real) *
        MinkowskiConvention.eta = 1 := by
  ext left right
  fin_cases left <;> fin_cases right <;>
    simp [MinkowskiConvention.eta, Matrix.mul_apply, Fin.sum_univ_four]

/-- Covariant coordinate metric induced by the coframe. -/
def coframeCovariantMetric
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 4) (Fin 4) Real :=
  coframe.transpose * MinkowskiConvention.eta * coframe

/-- Contravariant coordinate metric induced by an inverse coframe. -/
def inverseCoframeMetric
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 4) (Fin 4) Real :=
  inverseCoframe * MinkowskiConvention.eta * inverseCoframe.transpose

/-- A two-sided inverse coframe induces mutually inverse covariant and
contravariant coordinate metrics. -/
theorem coframeMetric_mul_inverseCoframeMetric
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1) :
    coframeCovariantMetric coframe * inverseCoframeMetric inverseCoframe = 1 := by
  have hTranspose : inverseCoframe.transpose * coframe.transpose = 1 := by
    rw [<- Matrix.transpose_mul, hRight, Matrix.transpose_one]
  unfold coframeCovariantMetric inverseCoframeMetric
  calc
    (coframe.transpose * MinkowskiConvention.eta * coframe) *
          (inverseCoframe * MinkowskiConvention.eta * inverseCoframe.transpose) =
        coframe.transpose * MinkowskiConvention.eta *
          (coframe * inverseCoframe) * MinkowskiConvention.eta *
            inverseCoframe.transpose := by
              simp [Matrix.mul_assoc]
    _ = coframe.transpose *
          (MinkowskiConvention.eta * MinkowskiConvention.eta) *
            inverseCoframe.transpose := by rw [hRight]; simp [Matrix.mul_assoc]
    _ = coframe.transpose * inverseCoframe.transpose := by
      rw [minkowskiEta_mul_self]
      simp
    _ = (inverseCoframe * coframe).transpose := by
      rw [Matrix.transpose_mul]
    _ = 1 := by rw [hLeft, Matrix.transpose_one]

/-- The metric induced by a coframe is symmetric. -/
theorem coframeCovariantMetric_isSymm
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    (coframeCovariantMetric coframe).IsSymm := by
  unfold coframeCovariantMetric
  exact inducedCovariantMetric_isSymm
    MinkowskiConvention.eta coframe minkowskiEta_isSymm

/-- Coordinate metric first jet induced by predecessor coframe increments.
The minus sign converts the predecessor increment into the usual forward
metric derivative. -/
def inducedMetricFirstJet
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) :
    Fin 4 -> Matrix (Fin 4) (Fin 4) Real :=
  fun derivative =>
    -(velocity derivative).transpose * MinkowskiConvention.eta * coframe -
      coframe.transpose * MinkowskiConvention.eta * velocity derivative

/-- Every induced metric first-jet matrix is symmetric in its metric indices.
-/
theorem inducedMetricFirstJet_symmetric
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) :
    MetricFirstJetSymmetric (inducedMetricFirstJet coframe velocity) := by
  intro derivative left right
  let firstTerm :=
    (velocity derivative).transpose * MinkowskiConvention.eta * coframe
  have hTranspose : firstTerm.transpose =
      coframe.transpose * MinkowskiConvention.eta * velocity derivative := by
    dsimp [firstTerm]
    rw [Matrix.transpose_mul, Matrix.transpose_mul,
      Matrix.transpose_transpose, minkowskiEta_isSymm.eq]
    simp [Matrix.mul_assoc]
  have hSymmetric : (-(firstTerm + firstTerm.transpose)).IsSymm :=
    (Matrix.isSymm_add_transpose_self firstTerm).neg
  have hJet : inducedMetricFirstJet coframe velocity derivative =
      -(firstTerm + firstTerm.transpose) := by
    unfold inducedMetricFirstJet
    rw [show -(velocity derivative).transpose * MinkowskiConvention.eta *
        coframe = -firstTerm by simp [firstTerm]]
    rw [<- hTranspose]
    abel
  rw [hJet]
  exact hSymmetric.apply right left

/-- Matrix of induced coordinate-connection coefficients at one derivative
direction. -/
def inducedCoordinateConnectionMatrix
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (derivative : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  inverseCoframe *
    (lorentzGenerator (connection derivative) * coframe - velocity derivative)

/-- Coordinate connection induced by the coframe, its first jet, and the
Lorentz connection. -/
def inducedCoordinateConnection
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    Fin 4 -> Fin 4 -> Fin 4 -> Real :=
  fun upper derivative right =>
    inducedCoordinateConnectionMatrix coframe inverseCoframe connection
      velocity derivative upper right

/-- Cartan torsion freedom makes the induced coordinate connection symmetric
in its two lower indices. -/
theorem inducedCoordinateConnection_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (hTorsion : LinearizedCovariantTorsionFree coframe connection velocity) :
    forall upper derivativeLeft derivativeRight,
      inducedCoordinateConnection coframe inverseCoframe connection velocity
          upper derivativeLeft derivativeRight =
        inducedCoordinateConnection coframe inverseCoframe connection velocity
          upper derivativeRight derivativeLeft := by
  intro upper derivativeLeft derivativeRight
  unfold inducedCoordinateConnection inducedCoordinateConnectionMatrix
  simp only [Matrix.mul_apply]
  apply Finset.sum_congr rfl
  intro internal _
  have hComponent := hTorsion internal derivativeLeft derivativeRight
  rw [linearizedCovariantCartanTorsion_eq] at hComponent
  simp only [Matrix.sub_apply]
  congr 1
  linarith

/-- Lorentz skewness gives the matrix metric-compatibility identity for the
induced coordinate connection. -/
theorem inducedMetricFirstJet_eq_connection_metric_terms
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (hRight : coframe * inverseCoframe = 1)
    (derivative : Fin 4) :
    inducedMetricFirstJet coframe velocity derivative =
      (inducedCoordinateConnectionMatrix coframe inverseCoframe connection
          velocity derivative).transpose * coframeCovariantMetric coframe +
        coframeCovariantMetric coframe *
          inducedCoordinateConnectionMatrix coframe inverseCoframe connection
            velocity derivative := by
  have hTranspose : inverseCoframe.transpose * coframe.transpose = 1 := by
    rw [<- Matrix.transpose_mul, hRight, Matrix.transpose_one]
  have hLorentz := lorentzGenerator_mem (connection derivative)
  unfold IsLorentzLieAlgebra at hLorentz
  unfold inducedMetricFirstJet inducedCoordinateConnectionMatrix
    coframeCovariantMetric
  rw [Matrix.transpose_mul, Matrix.transpose_sub, Matrix.transpose_mul]
  have hReassociate :
      ((coframe.transpose *
              (lorentzGenerator (connection derivative)).transpose -
            (velocity derivative).transpose) * inverseCoframe.transpose) *
            (coframe.transpose * MinkowskiConvention.eta * coframe) +
          (coframe.transpose * MinkowskiConvention.eta * coframe) *
            (inverseCoframe *
              (lorentzGenerator (connection derivative) * coframe -
                velocity derivative)) =
        (coframe.transpose *
              (lorentzGenerator (connection derivative)).transpose -
            (velocity derivative).transpose) *
            (inverseCoframe.transpose * coframe.transpose) *
              MinkowskiConvention.eta * coframe +
          coframe.transpose * MinkowskiConvention.eta *
            (coframe * inverseCoframe) *
              (lorentzGenerator (connection derivative) * coframe -
                velocity derivative) := by
    noncomm_ring
  rw [hReassociate, hTranspose, hRight]
  simp only [Matrix.mul_one]
  have hExpand :
      (coframe.transpose *
              (lorentzGenerator (connection derivative)).transpose -
            (velocity derivative).transpose) *
            MinkowskiConvention.eta * coframe +
          coframe.transpose * MinkowskiConvention.eta *
            (lorentzGenerator (connection derivative) * coframe -
              velocity derivative) =
        coframe.transpose *
            ((lorentzGenerator (connection derivative)).transpose *
                MinkowskiConvention.eta +
              MinkowskiConvention.eta *
                lorentzGenerator (connection derivative)) * coframe -
          ((velocity derivative).transpose * MinkowskiConvention.eta *
              coframe +
            coframe.transpose * MinkowskiConvention.eta *
              velocity derivative) := by
    noncomm_ring
  rw [hExpand, hLorentz]
  simp [sub_eq_add_neg, add_comm]

/-- The induced coordinate connection has vanishing covariant derivative of
the coframe-induced metric and metric first jet. -/
theorem inducedCoordinateConnection_metricCompatible
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (hRight : coframe * inverseCoframe = 1) :
    forall derivative left right,
      covariantMetricDerivative (coframeCovariantMetric coframe)
        (inducedMetricFirstJet coframe velocity)
        (inducedCoordinateConnection coframe inverseCoframe connection velocity)
        derivative left right = 0 := by
  intro derivative left right
  have hMatrix := inducedMetricFirstJet_eq_connection_metric_terms
    coframe inverseCoframe connection velocity hRight derivative
  have hEntry := congrFun (congrFun hMatrix left) right
  have hSymmetric := coframeCovariantMetric_isSymm coframe
  have hTransposeTerm :
      ((inducedCoordinateConnectionMatrix coframe inverseCoframe connection
          velocity derivative).transpose * coframeCovariantMetric coframe)
          left right =
        (coframeCovariantMetric coframe *
          inducedCoordinateConnectionMatrix coframe inverseCoframe connection
            velocity derivative) right left := by
    simp only [Matrix.mul_apply, Matrix.transpose_apply]
    apply Finset.sum_congr rfl
    intro upper _
    rw [hSymmetric.apply]
    ring
  unfold covariantMetricDerivative loweredConnection
  change inducedMetricFirstJet coframe velocity derivative left right -
      (coframeCovariantMetric coframe *
        inducedCoordinateConnectionMatrix coframe inverseCoframe connection
          velocity derivative) left right -
      (coframeCovariantMetric coframe *
        inducedCoordinateConnectionMatrix coframe inverseCoframe connection
          velocity derivative) right left = 0
  rw [hEntry, Matrix.add_apply, hTransposeTerm]
  ring

/-- **Cartan-to-Levi-Civita bridge.** For an invertible coframe, every
torsion-free Lorentz connection induces exactly the Christoffel connection of
the coframe metric and its predecessor-derived first jet. -/
theorem inducedCoordinateConnection_eq_christoffel_of_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hTorsion : LinearizedCovariantTorsionFree coframe connection velocity) :
    inducedCoordinateConnection coframe inverseCoframe connection velocity =
      christoffelSecondKind (inverseCoframeMetric inverseCoframe)
        (inducedMetricFirstJet coframe velocity) := by
  apply connection_eq_christoffelSecondKind_of_torsionFree_metricCompatible
    (coframeCovariantMetric coframe) (inverseCoframeMetric inverseCoframe)
      (inducedMetricFirstJet coframe velocity)
      (inducedCoordinateConnection coframe inverseCoframe connection velocity)
  · exact coframeMetric_mul_inverseCoframeMetric
      coframe inverseCoframe hLeft hRight
  · exact inducedCoordinateConnection_torsionFree
      coframe inverseCoframe connection velocity hTorsion
  · exact inducedCoordinateConnection_metricCompatible
      coframe inverseCoframe connection velocity hRight

/-- **Finite Palatini connection equation selects Levi-Civita at first
order.** Vanishing of all affine Lorentz-link Palatini residuals forces the
coordinate connection induced by the same coframe and link first jets to be
the unique Levi-Civita connection of the induced metric first jet. -/
theorem affinePalatiniResidual_vanish_implies_inducedLeviCivita
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hPalatini : forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0) :
    inducedCoordinateConnection coframe inverseCoframe connection velocity =
      christoffelSecondKind (inverseCoframeMetric inverseCoframe)
        (inducedMetricFirstJet coframe velocity) := by
  apply inducedCoordinateConnection_eq_christoffel_of_torsionFree
    coframe inverseCoframe connection velocity hLeft hRight
  exact (linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft connection velocity).mp hPalatini

/-- **Actual-action first jets select the induced Levi-Civita connection.** At
the identity coframe and connection, a site-uniform exponential-link variation
whose ordinary nonlinear link-Euler derivatives all vanish induces the unique
Christoffel connection of the metric first jet determined by the same backward
coframe variation. -/
theorem nonlinearLinkEulerCoefficient_derivatives_vanish_implies_inducedLeviCivita
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (hLinkConstant : forall x y, linkVariation x = linkVariation y)
    (hEuler : forall site direction component,
      deriv (fun t => nonlinearLinkEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site) linkVariation t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction component) 0 = 0)
    (site : Site) :
    inducedCoordinateConnection 1 1
        (fun direction => linkVariation site direction)
        (backwardCoframeVelocity shift coframeVariation site) =
      christoffelSecondKind (inverseCoframeMetric 1)
        (inducedMetricFirstJet 1
          (backwardCoframeVelocity shift coframeVariation site)) := by
  apply inducedCoordinateConnection_eq_christoffel_of_torsionFree
    (1 : Matrix (Fin 4) (Fin 4) Real) 1
      (fun direction => linkVariation site direction)
      (backwardCoframeVelocity shift coframeVariation site) (by simp) (by simp)
  exact (nonlinearLinkEulerCoefficient_derivatives_vanish_iff_torsionFree
    shift linkVariation coframeVariation hLinkConstant).mp hEuler site

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita.inducedCoordinateConnection_eq_christoffel_of_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inducedCoordinateConnection_eq_christoffel_of_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita.affinePalatiniResidual_vanish_implies_inducedLeviCivita' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms affinePalatiniResidual_vanish_implies_inducedLeviCivita

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita.nonlinearLinkEulerCoefficient_derivatives_vanish_implies_inducedLeviCivita' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_derivatives_vanish_implies_inducedLeviCivita

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita
