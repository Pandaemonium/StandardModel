import PhysicsSM.Draft.NullEdge.LorentzCoordinateEinsteinContraction
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit

noncomputable section

open scoped Matrix.Norms.Frobenius

/-!
# Sampled actual-action limit in coordinate Einstein form

`NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit` samples one
differentiable Lorentz connection and tetrad on common changing finite
carriers.  Vanishing first derivatives of both Euler maps of the concrete
nonlinear null-edge Palatini action then gives the identity-background mixed
vacuum equation for `dA` together with covariant Cartan torsion.

This module closes the coordinate-tensor endpoint of that result.  It proves
that the action equation is exactly twice the standard coordinate mixed
Einstein tensor of the tetrad-reconstructed linearized curvature.  The joint
capstone then combines sampled actual-action stationarity with finite
Levi-Civita uniqueness: the induced linearized coordinate connection is
Christoffel, while the coordinate linearized curvature reconstructed from the
same action-visible `dA` obeys `G^raised_lower = 0`.

The theorem is conditional on a supplied pointed chart, two-sided affine
stencil, differentiable connection and tetrad fields, and finite derivative
stationarity at every refinement level.  It remains linearized at the identity
link/coframe background.  It does not replace `dA` by the nonlinear curvature
`dA + A wedge A`, derive the sampling data from bare causal order, identify a
finite plaquette with the differential curvature, or prove an unconditional
refinement theorem.  It also does not identify the reconstructed `dA` tensor
with the full curvature of the selected Christoffel connection; that bridge
requires a compatible second tetrad jet and the nonlinear commutator term.

Claim label: conditional changing-carrier actual-action linearized
Palatini-to-coordinate-Einstein theorem.  Originality tag: `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniSampledCoordinateEinsteinLimit

open Filter Topology
open PhysicsSM.Draft.NullEdge.CausalLeviCivita
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzCoordinateEinsteinContraction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit

set_option maxHeartbeats 3000000

/-- Coordinate linearized curvature reconstructed from the six action
coordinates of the sampled exterior derivative `dA`. -/
def sampledCoordinateLinearizedCurvature
    {Chart : Type*} [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (connectionDerivative :
      Chart →L[Real] LorentzConnectionVelocity)
    (tangent : Fin 4 -> Chart) : LocalCoordinateCurvature :=
  coordinateCurvatureFromBivector
    (1 : Matrix (Fin 4) (Fin 4) Real)
    (1 : Matrix (Fin 4) (Fin 4) Real)
    (sampledLinearizedCurvatureLimit connectionDerivative tangent)

/-- At the identity coframe, the action's mixed vacuum entry is exactly twice
the ordinary coordinate mixed Einstein tensor of the reconstructed curvature.
-/
theorem two_mul_coordinateEinstein_identity_eq_mixedVacuumEinstein
    (curvature : LocalCurvature)
    (hAntisymmetric : forall left right component,
      curvature left right component = -curvature right left component)
    (coframeDirection raisedDirection : Fin 4) :
    2 * coordinateMixedEinstein
        (inverseCoframeMetric (1 : Matrix (Fin 4) (Fin 4) Real))
        (coordinateCurvatureFromBivector
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (1 : Matrix (Fin 4) (Fin 4) Real) curvature)
        coframeDirection raisedDirection =
      mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real) curvature
        coframeDirection raisedDirection := by
  simpa only [mixedVacuumEinsteinEntry] using
    two_mul_coordinateMixedEinstein_fromBivector_eq
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (1 : Matrix (Fin 4) (Fin 4) Real) curvature (by simp)
      hAntisymmetric coframeDirection raisedDirection

/-- At the identity coframe, vanishing of every action mixed vacuum entry is
equivalent to the standard coordinate mixed vacuum Einstein equation. -/
theorem mixedVacuumEinstein_identity_iff_coordinateEinstein
    (curvature : LocalCurvature)
    (hAntisymmetric : forall left right component,
      curvature left right component = -curvature right left component) :
    (forall coframeDirection raisedDirection,
      mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real) curvature
        coframeDirection raisedDirection = 0) <->
    (forall coframeDirection raisedDirection,
      coordinateMixedEinstein
        (inverseCoframeMetric (1 : Matrix (Fin 4) (Fin 4) Real))
        (coordinateCurvatureFromBivector
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (1 : Matrix (Fin 4) (Fin 4) Real) curvature)
        coframeDirection raisedDirection = 0) := by
  constructor
  · intro hAction coframeDirection raisedDirection
    have hTwice :=
      two_mul_coordinateEinstein_identity_eq_mixedVacuumEinstein
        curvature hAntisymmetric coframeDirection raisedDirection
    rw [hAction coframeDirection raisedDirection] at hTwice
    linarith
  · intro hCoordinate coframeDirection raisedDirection
    rw [<- two_mul_coordinateEinstein_identity_eq_mixedVacuumEinstein
      curvature hAntisymmetric coframeDirection raisedDirection]
    rw [hCoordinate coframeDirection raisedDirection]
    ring

/-- **Changing-carrier actual-action endpoint in standard coordinate form.**
Sample one differentiable Lorentz connection and tetrad on a common two-sided
affine stencil.  If the first derivatives of both Euler maps of the same
concrete finite null-edge Palatini action vanish at every refinement level,
then the limiting linearized coordinate connection is Christoffel and the
standard mixed Einstein tensor of the coordinate curvature reconstructed from
the same action-visible `dA` vanishes.
-/
theorem sampledActualActionLinearizedStationary_christoffel_and_coordinateEinstein
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    {Chart : Type*} [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (inverseSpacing : Nat -> Real) (tangent : Fin 4 -> Chart)
    (connectionField : Chart -> LorentzConnectionVelocity)
    (connectionDerivative : Chart →L[Real] LorentzConnectionVelocity)
    (tetrad : Chart -> Matrix (Fin 4) (Fin 4) Real)
    (tetradDerivative : Chart →L[Real] Matrix (Fin 4) (Fin 4) Real)
    (hConnection : HasFDerivAt connectionField connectionDerivative point)
    (hTetrad : HasFDerivAt tetrad tetradDerivative point)
    (hInverseSpacing : Tendsto (fun n => ‖inverseSpacing n‖) atTop atTop)
    (hStencil : PointedAffineTwoSidedStencil shift position center point
      inverseSpacing tangent)
    (hJointStationary : forall n,
      ActualActionLinearizedJointStationary (shift n)
        (sampledLinkVariation connectionField position n)
        (sampledScaledCoframeVariation inverseSpacing tetrad position point n)) :
    inducedCoordinateConnection
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (connectionField point)
        (sampledCoframeVelocityLimit tetradDerivative
          (fun direction => -tangent direction)) =
      christoffelSecondKind
        (inverseCoframeMetric (1 : Matrix (Fin 4) (Fin 4) Real))
        (inducedMetricFirstJet
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (sampledCoframeVelocityLimit tetradDerivative
            (fun direction => -tangent direction))) /\
    forall coframeDirection raisedDirection,
      coordinateMixedEinstein
        (inverseCoframeMetric (1 : Matrix (Fin 4) (Fin 4) Real))
        (sampledCoordinateLinearizedCurvature connectionDerivative tangent)
        coframeDirection raisedDirection = 0 := by
  have hEinsteinCartan := sampledLinearizedJointStationary_einstein_and_cartan
    shift position center point inverseSpacing tangent connectionField
    connectionDerivative tetrad tetradDerivative hConnection hTetrad
    hInverseSpacing hStencil hJointStationary
  constructor
  · exact inducedCoordinateConnection_eq_christoffel_of_torsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (connectionField point)
      (sampledCoframeVelocityLimit tetradDerivative
        (fun direction => -tangent direction))
      (by simp) (by simp) hEinsteinCartan.2
  · apply (mixedVacuumEinstein_identity_iff_coordinateEinstein
      (sampledLinearizedCurvatureLimit connectionDerivative tangent)
      (sampledLinearizedCurvatureLimit_antisymmetric
        connectionDerivative tangent)).mp
    exact hEinsteinCartan.1

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniSampledCoordinateEinsteinLimit.two_mul_coordinateEinstein_identity_eq_mixedVacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms two_mul_coordinateEinstein_identity_eq_mixedVacuumEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniSampledCoordinateEinsteinLimit.mixedVacuumEinstein_identity_iff_coordinateEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mixedVacuumEinstein_identity_iff_coordinateEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniSampledCoordinateEinsteinLimit.sampledActualActionLinearizedStationary_christoffel_and_coordinateEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sampledActualActionLinearizedStationary_christoffel_and_coordinateEinstein

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniSampledCoordinateEinsteinLimit
