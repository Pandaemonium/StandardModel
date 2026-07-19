import PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinResponse

noncomputable section

/-!
# Lorentz-coordinate Einstein contraction

`LorentzCoordinateCurvatureBridge` identifies the curvature of the coordinate
connection induced by a coframe and Lorentz connection with

`R(Gamma)_ab = eInv * hat(F_ab) * e`.

The nonlinear Palatini action, however, contracts the six bivector coordinates
of `F_ab` directly with inverse coframes.  This module proves that those two
contraction procedures give exactly the same mixed Ricci tensor, scalar
curvature, and Einstein tensor.

The final capstone composes the contraction identity with finite Levi-Civita
selection.  Vanishing affine connection residuals and stationarity of the local
Palatini density imply that the induced coordinate connection is Christoffel
and its coordinate curvature satisfies the mixed vacuum Einstein equation.

These are exact first- and second-jet identities on supplied coframe and
connection data.  They do not identify a finite plaquette holonomy with this
differential curvature, derive the jets from a bare causal graph, or prove a
refinement/convergence theorem.  Claim label: finite jet-level Palatini-to-
Einstein theorem.  The tetrad contractions are standard `[import]`; their exact
normalization in the project's six-component ordering is `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.LorentzCoordinateEinsteinContraction

open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.CausalLeviCivita
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

set_option maxHeartbeats 3000000

/-- Real coordinate matrices in four spacetime dimensions. -/
abbrev Matrix4R := Matrix (Fin 4) (Fin 4) Real

/-- A coordinate curvature matrix for every ordered pair of directions.  A
matrix entry is ordered as `upper, lower`. -/
abbrev LocalCoordinateCurvature := Fin 4 -> Fin 4 -> Matrix4R

/-- The six action coordinates for every ordered pair of directions. -/
abbrev LocalBivectorCurvature := Fin 4 -> Fin 4 -> Fiber 6

/-- Coordinate curvature reconstructed from the six bivector coordinates by
the tetrad dictionary `R_ab = eInv * hat(F_ab) * e`. -/
def coordinateCurvatureFromBivector
    (coframe inverseCoframe : Matrix4R)
    (curvature : LocalBivectorCurvature) : LocalCoordinateCurvature :=
  fun left right =>
    inverseCoframe * lorentzGenerator (curvature left right) * coframe

/-- Raw coordinate Ricci contraction
`Ric_lower,right = sum_upper R_upper,right^upper_lower`. -/
def coordinateRawRicci (curvature : LocalCoordinateCurvature) : Matrix4R :=
  fun lower right =>
    Finset.sum Finset.univ (fun upper => curvature upper right upper lower)

/-- Mixed coordinate Ricci tensor with the first Ricci index raised.  The
arguments are ordered to match `mixedRicciCurvature`: lower direction first,
raised direction second. -/
def coordinateMixedRicci
    (inverseMetric : Matrix4R) (curvature : LocalCoordinateCurvature)
    (coframeDirection raisedDirection : Fin 4) : Real :=
  Finset.sum Finset.univ (fun lower =>
    inverseMetric raisedDirection lower *
      coordinateRawRicci curvature lower coframeDirection)

/-- Coordinate scalar curvature as the trace of the mixed Ricci tensor. -/
def coordinateScalarCurvature
    (inverseMetric : Matrix4R) (curvature : LocalCoordinateCurvature) : Real :=
  Finset.sum Finset.univ (fun direction =>
    coordinateMixedRicci inverseMetric curvature direction direction)

/-- Standard mixed Einstein tensor
`G^raised_lower = Ric^raised_lower - (1/2) delta^raised_lower R`. -/
def coordinateMixedEinstein
    (inverseMetric : Matrix4R) (curvature : LocalCoordinateCurvature)
    (coframeDirection raisedDirection : Fin 4) : Real :=
  coordinateMixedRicci inverseMetric curvature coframeDirection
      raisedDirection -
    (1 / 2 : Real) * (1 : Matrix4R) raisedDirection coframeDirection *
      coordinateScalarCurvature inverseMetric curvature

/-! ## Matrix contraction identities -/

/-- Raising the Ricci index can be written as a matrix product against the
transpose of each direction-dependent curvature matrix. -/
theorem coordinateMixedRicci_eq_sum_mul_transpose
    (inverseMetric : Matrix4R) (curvature : LocalCoordinateCurvature)
    (coframeDirection raisedDirection : Fin 4) :
    coordinateMixedRicci inverseMetric curvature coframeDirection
        raisedDirection =
      Finset.sum Finset.univ (fun upper =>
        (inverseMetric * (curvature upper coframeDirection).transpose)
          raisedDirection upper) := by
  unfold coordinateMixedRicci coordinateRawRicci
  simp only [Matrix.mul_apply, Matrix.transpose_apply, Finset.mul_sum]
  rw [Finset.sum_comm]

/-- The antisymmetric bivector matrix is linear under negation. -/
theorem bivectorMatrix_neg (bivector : Fiber 6) :
    bivectorMatrix (-bivector) = -(bivectorMatrix bivector) := by
  ext left right
  fin_cases left <;> fin_cases right <;> simp [bivectorMatrix]

/-- After raising the coordinate Ricci index, coframe cancellation and Lorentz
skewness reduce the conjugated generator to minus the contravariant bivector
matrix between two inverse coframes. -/
theorem inverseMetric_mul_coordinateCurvatureFromBivector_transpose
    (coframe inverseCoframe : Matrix4R)
    (curvature : LocalBivectorCurvature)
    (hRight : coframe * inverseCoframe = 1)
    (left right : Fin 4) :
    inverseCoframeMetric inverseCoframe *
        (coordinateCurvatureFromBivector coframe inverseCoframe curvature
          left right).transpose =
      -(inverseCoframe * bivectorMatrix (curvature left right) *
        inverseCoframe.transpose) := by
  have hTransposeInverse :
      inverseCoframe.transpose * coframe.transpose = 1 := by
    rw [<- Matrix.transpose_mul, hRight, Matrix.transpose_one]
  have hGeneratorTranspose :
      MinkowskiConvention.eta.transpose *
          (bivectorMatrix (curvature left right)).transpose =
        -(MinkowskiConvention.eta *
          bivectorMatrix (curvature left right)) := by
    rw [minkowskiEta_isSymm.eq, bivectorMatrix_transpose]
    noncomm_ring
  unfold inverseCoframeMetric coordinateCurvatureFromBivector lorentzGenerator
  simp only [Matrix.transpose_mul]
  calc
    _ = inverseCoframe * MinkowskiConvention.eta *
        (inverseCoframe.transpose * coframe.transpose) *
        (MinkowskiConvention.eta.transpose *
          (bivectorMatrix (curvature left right)).transpose) *
        inverseCoframe.transpose := by simp only [Matrix.mul_assoc]
    _ = inverseCoframe * MinkowskiConvention.eta *
        (MinkowskiConvention.eta.transpose *
          (bivectorMatrix (curvature left right)).transpose) *
        inverseCoframe.transpose := by rw [hTransposeInverse]; simp
    _ = inverseCoframe * MinkowskiConvention.eta *
        (-(MinkowskiConvention.eta *
          bivectorMatrix (curvature left right))) *
        inverseCoframe.transpose := by rw [hGeneratorTranspose]
    _ = inverseCoframe *
        (MinkowskiConvention.eta * MinkowskiConvention.eta) *
        (-(bivectorMatrix (curvature left right))) *
        inverseCoframe.transpose := by noncomm_ring
    _ = -(inverseCoframe * bivectorMatrix (curvature left right) *
        inverseCoframe.transpose) := by
      rw [minkowskiEta_mul_self]
      noncomm_ring

/-- The action's mixed Ricci contraction is a sum of inverse-coframe matrix
conjugations of its contravariant bivector curvature. -/
theorem mixedRicciCurvature_eq_sum_matrix
    (inverseCoframe : Matrix4R) (curvature : LocalBivectorCurvature)
    (coframeDirection raisedDirection : Fin 4) :
    mixedRicciCurvature inverseCoframe curvature coframeDirection
        raisedDirection =
      Finset.sum Finset.univ (fun otherDirection =>
        (inverseCoframe * bivectorMatrix
            (curvature coframeDirection otherDirection) *
          inverseCoframe.transpose) raisedDirection otherDirection) := by
  unfold mixedRicciCurvature
  simp only [Matrix.mul_apply, Matrix.transpose_apply, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro otherDirection _
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro internalRight _
  apply Finset.sum_congr rfl
  intro internalLeft _
  ring

/-! ## Ricci, scalar, and Einstein identification -/

/-- The coordinate mixed Ricci tensor of the tetrad-conjugated Lorentz
curvature is exactly the mixed Ricci contraction used by the Palatini action.
Only antisymmetry in the ordered spacetime face is required. -/
theorem coordinateMixedRicci_fromBivector_eq
    (coframe inverseCoframe : Matrix4R)
    (curvature : LocalBivectorCurvature)
    (hRight : coframe * inverseCoframe = 1)
    (hAntisymmetric : forall left right component,
      curvature left right component = -curvature right left component)
    (coframeDirection raisedDirection : Fin 4) :
    coordinateMixedRicci (inverseCoframeMetric inverseCoframe)
        (coordinateCurvatureFromBivector coframe inverseCoframe curvature)
        coframeDirection raisedDirection =
      mixedRicciCurvature inverseCoframe curvature coframeDirection
        raisedDirection := by
  rw [coordinateMixedRicci_eq_sum_mul_transpose]
  simp_rw [inverseMetric_mul_coordinateCurvatureFromBivector_transpose
    coframe inverseCoframe curvature hRight]
  rw [mixedRicciCurvature_eq_sum_matrix]
  apply Finset.sum_congr rfl
  intro otherDirection _
  have hCurvature :
      curvature otherDirection coframeDirection =
        -curvature coframeDirection otherDirection := by
    funext component
    exact hAntisymmetric otherDirection coframeDirection component
  rw [hCurvature, bivectorMatrix_neg]
  simp

/-- The action scalar is the trace of its mixed Ricci contraction. -/
theorem inverseCoframeScalarCurvature_eq_sum_mixedRicci
    (inverseCoframe : Matrix4R) (curvature : LocalBivectorCurvature) :
    inverseCoframeScalarCurvature inverseCoframe curvature =
      Finset.sum Finset.univ (fun direction =>
        mixedRicciCurvature inverseCoframe curvature direction direction) := by
  unfold inverseCoframeScalarCurvature mixedRicciCurvature
  apply Finset.sum_congr rfl
  intro direction _
  rw [Finset.sum_comm]

/-- The coordinate scalar curvature of the tetrad-conjugated Lorentz curvature
is exactly the scalar contraction used by the Palatini action. -/
theorem coordinateScalarCurvature_fromBivector_eq
    (coframe inverseCoframe : Matrix4R)
    (curvature : LocalBivectorCurvature)
    (hRight : coframe * inverseCoframe = 1)
    (hAntisymmetric : forall left right component,
      curvature left right component = -curvature right left component) :
    coordinateScalarCurvature (inverseCoframeMetric inverseCoframe)
        (coordinateCurvatureFromBivector coframe inverseCoframe curvature) =
      inverseCoframeScalarCurvature inverseCoframe curvature := by
  unfold coordinateScalarCurvature
  simp_rw [coordinateMixedRicci_fromBivector_eq coframe inverseCoframe
    curvature hRight hAntisymmetric]
  exact (inverseCoframeScalarCurvature_eq_sum_mixedRicci
    inverseCoframe curvature).symm

/-- Twice the standard coordinate Einstein tensor is exactly the
normalization used by the coframe Euler equation. -/
theorem two_mul_coordinateMixedEinstein_fromBivector_eq
    (coframe inverseCoframe : Matrix4R)
    (curvature : LocalBivectorCurvature)
    (hRight : coframe * inverseCoframe = 1)
    (hAntisymmetric : forall left right component,
      curvature left right component = -curvature right left component)
    (coframeDirection raisedDirection : Fin 4) :
    2 * coordinateMixedEinstein (inverseCoframeMetric inverseCoframe)
        (coordinateCurvatureFromBivector coframe inverseCoframe curvature)
        coframeDirection raisedDirection =
      2 * mixedRicciCurvature inverseCoframe curvature coframeDirection
          raisedDirection -
        (1 : Matrix4R) raisedDirection coframeDirection *
          inverseCoframeScalarCurvature inverseCoframe curvature := by
  unfold coordinateMixedEinstein
  rw [coordinateMixedRicci_fromBivector_eq coframe inverseCoframe curvature
      hRight hAntisymmetric,
    coordinateScalarCurvature_fromBivector_eq coframe inverseCoframe curvature
      hRight hAntisymmetric]
  ring

/-- Contracting the action's coframe-index Euler coefficient with the coframe
gives twice the standard coordinate mixed Einstein tensor. -/
theorem coframe_contract_mixedEinsteinCoframeCoefficient_eq_coordinateEinstein
    (coframe inverseCoframe : Matrix4R)
    (curvature : LocalBivectorCurvature)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hAntisymmetric : forall left right component,
      curvature left right component = -curvature right left component)
    (coframeDirection raisedDirection : Fin 4) :
    Finset.sum Finset.univ (fun internal =>
        coframe internal coframeDirection *
          mixedEinsteinCoframeCoefficient inverseCoframe curvature
            internal raisedDirection) =
      2 * coordinateMixedEinstein (inverseCoframeMetric inverseCoframe)
        (coordinateCurvatureFromBivector coframe inverseCoframe curvature)
        coframeDirection raisedDirection := by
  rw [coframe_contract_mixedEinsteinCoframeCoefficient coframe inverseCoframe
    curvature hLeft]
  rw [two_mul_coordinateMixedEinstein_fromBivector_eq coframe inverseCoframe
    curvature hRight hAntisymmetric]

/-- The sixteen coframe-index Euler coefficients vanish exactly when the
ordinary coordinate mixed Einstein tensor vanishes. -/
theorem mixedEinsteinCoframeCoefficient_vanish_iff_coordinateEinstein
    (coframe inverseCoframe : Matrix4R)
    (curvature : LocalBivectorCurvature)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hAntisymmetric : forall left right component,
      curvature left right component = -curvature right left component) :
    (forall internal direction,
      mixedEinsteinCoframeCoefficient inverseCoframe curvature
        internal direction = 0) <->
    (forall coframeDirection raisedDirection,
      coordinateMixedEinstein (inverseCoframeMetric inverseCoframe)
        (coordinateCurvatureFromBivector coframe inverseCoframe curvature)
        coframeDirection raisedDirection = 0) := by
  rw [mixedEinsteinCoframeCoefficient_vanish_iff coframe inverseCoframe
    curvature hLeft hRight]
  constructor
  · intro hAction coframeDirection raisedDirection
    have hTwice := two_mul_coordinateMixedEinstein_fromBivector_eq
      coframe inverseCoframe curvature hRight hAntisymmetric
        coframeDirection raisedDirection
    rw [hAction coframeDirection raisedDirection] at hTwice
    linarith
  · intro hEinstein coframeDirection raisedDirection
    rw [<- two_mul_coordinateMixedEinstein_fromBivector_eq coframe
      inverseCoframe curvature hRight hAntisymmetric]
    rw [hEinstein coframeDirection raisedDirection]
    ring

/-! ## Variational and Levi-Civita capstones -/

/-- Stationarity of the local Palatini density under every coframe variation
is equivalent to the ordinary coordinate mixed vacuum Einstein equation for
the tetrad-conjugated curvature. -/
theorem palatiniDensity_stationary_iff_coordinateVacuumEinstein
    (coframe inverseCoframe : Matrix4R)
    (curvature : LocalBivectorCurvature)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hAntisymmetric : forall left right component,
      curvature left right component = -curvature right left component) :
    (forall variation,
      palatiniDensityFirstVariation coframe variation curvature = 0) <->
    (forall coframeDirection raisedDirection,
      coordinateMixedEinstein (inverseCoframeMetric inverseCoframe)
        (coordinateCurvatureFromBivector coframe inverseCoframe curvature)
        coframeDirection raisedDirection = 0) := by
  rw [<- mixedEinsteinCoframeCoefficient_vanish_iff_coordinateEinstein
    coframe inverseCoframe curvature hLeft hRight hAntisymmetric]
  constructor
  · intro hStationary internal direction
    have hResponse := palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
      coframe inverseCoframe (Matrix.single internal direction 1) curvature
        hLeft hAntisymmetric
    rw [hStationary] at hResponse
    have hDet : coframe.det ≠ 0 :=
      Matrix.det_ne_zero_of_left_inverse hLeft
    have hCoordinateSum :
        Finset.sum Finset.univ (fun coefficientInternal =>
          Finset.sum Finset.univ (fun coefficientDirection =>
            mixedEinsteinCoframeCoefficient inverseCoframe curvature
                coefficientInternal coefficientDirection *
              Matrix.single internal direction 1 coefficientInternal
                coefficientDirection)) =
          mixedEinsteinCoframeCoefficient inverseCoframe curvature
            internal direction := by
      fin_cases internal <;> fin_cases direction <;>
        simp +decide [Matrix.single_apply, Fin.sum_univ_four]
    have hProduct :
        coframe.det * mixedEinsteinCoframeCoefficient inverseCoframe curvature
          internal direction = 0 := by
      rw [hCoordinateSum] at hResponse
      exact hResponse.symm
    exact (mul_eq_zero.mp hProduct).resolve_left hDet
  · intro hCoefficient variation
    rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein coframe
      inverseCoframe variation curvature hLeft hAntisymmetric]
    simp_rw [hCoefficient]
    simp

/-- Curvature of the coordinate connection induced from the supplied coframe,
Lorentz connection, and compatible first jets. -/
def inducedCoordinateCurvature
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet) :
    LocalCoordinateCurvature :=
  fun left right =>
    matrixConnectionCurvature
      (fun direction => inducedCoordinateConnectionMatrix coframe
        inverseCoframe connection velocity direction)
      (predecessorInducedConnectionFirstJet coframe inverseCoframe
        (generatedLorentzConnection connection) velocity
        (generatedLorentzConnectionFirstJet connectionFirstJet)
        velocityFirstJet) left right

/-- Differential Lorentz curvature is antisymmetric in its two derivative
directions. -/
theorem lorentzCurvatureMatrix_swap
    (connection : MatrixConnection)
    (connectionFirstJet : MatrixConnectionFirstJet)
    (left right : Fin 4) :
    lorentzCurvatureMatrix connection connectionFirstJet left right =
      -(lorentzCurvatureMatrix connection connectionFirstJet right left) := by
  unfold lorentzCurvatureMatrix
  noncomm_ring

/-- Lorentz generator coordinate extraction commutes with negation. -/
theorem lorentzGeneratorCoordinates_neg (generator : Matrix4R) :
    lorentzGeneratorCoordinates (-generator) =
      -(lorentzGeneratorCoordinates generator) := by
  funext component
  unfold lorentzGeneratorCoordinates
  simp only [Matrix.neg_mul, Matrix.neg_apply, Pi.neg_apply]

/-- The six action coordinates of differential Lorentz curvature inherit face
antisymmetry. -/
theorem generatedLorentzCurvatureCoordinates_antisymmetric
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (left right : Fin 4) :
    generatedLorentzCurvatureCoordinates connection connectionFirstJet
        left right =
      -(generatedLorentzCurvatureCoordinates connection connectionFirstJet
        right left) := by
  unfold generatedLorentzCurvatureCoordinates
  rw [lorentzCurvatureMatrix_swap, lorentzGeneratorCoordinates_neg]

/-- The induced coordinate curvature is exactly the tetrad reconstruction of
the six differential curvature coordinates seen by the Palatini action. -/
theorem inducedCoordinateCurvature_eq_coordinateCurvatureFromBivector
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hRight : coframe * inverseCoframe = 1)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left) :
    inducedCoordinateCurvature coframe inverseCoframe connection velocity
        connectionFirstJet velocityFirstJet =
      coordinateCurvatureFromBivector coframe inverseCoframe
        (generatedLorentzCurvatureCoordinates connection
          connectionFirstJet) := by
  funext left right
  exact inducedCoordinateConnection_curvature_eq_actionCoordinates
    coframe inverseCoframe connection velocity connectionFirstJet
      velocityFirstJet hRight hMixed left right

/-- **Jet-level Palatini derivation of the vacuum Einstein equation.**
Vanishing affine connection residuals select the Levi-Civita connection.
Stationarity of the same local Palatini density in every coframe direction
then gives the ordinary mixed vacuum Einstein equation for the curvature of
that induced coordinate connection. -/
theorem affinePalatini_and_coframeStationarity_imply_leviCivita_vacuumEinstein
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hPalatini : forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (hCoframeStationary : forall variation,
      palatiniDensityFirstVariation coframe variation
        (generatedLorentzCurvatureCoordinates connection connectionFirstJet) =
          0) :
    inducedCoordinateConnection coframe inverseCoframe connection velocity =
        christoffelSecondKind (inverseCoframeMetric inverseCoframe)
          (inducedMetricFirstJet coframe velocity) /\
      forall coframeDirection raisedDirection,
        coordinateMixedEinstein (inverseCoframeMetric inverseCoframe)
          (inducedCoordinateCurvature coframe inverseCoframe connection velocity
            connectionFirstJet velocityFirstJet)
          coframeDirection raisedDirection = 0 := by
  constructor
  · exact affinePalatiniResidual_vanish_implies_inducedLeviCivita
      coframe inverseCoframe connection velocity hLeft hRight hPalatini
  · have hAntisymmetric : forall left right component,
        generatedLorentzCurvatureCoordinates connection connectionFirstJet
            left right component =
          -generatedLorentzCurvatureCoordinates connection connectionFirstJet
            right left component := by
      intro left right component
      exact congrFun
        (generatedLorentzCurvatureCoordinates_antisymmetric
          connection connectionFirstJet left right) component
    have hEinstein :=
      (palatiniDensity_stationary_iff_coordinateVacuumEinstein coframe
        inverseCoframe
        (generatedLorentzCurvatureCoordinates connection connectionFirstJet)
        hLeft hRight hAntisymmetric).mp hCoframeStationary
    rw [inducedCoordinateCurvature_eq_coordinateCurvatureFromBivector
      coframe inverseCoframe connection velocity connectionFirstJet
        velocityFirstJet hRight hMixed]
    exact hEinstein

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoordinateEinsteinContraction.two_mul_coordinateMixedEinstein_fromBivector_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms two_mul_coordinateMixedEinstein_fromBivector_eq

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoordinateEinsteinContraction.palatiniDensity_stationary_iff_coordinateVacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms palatiniDensity_stationary_iff_coordinateVacuumEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoordinateEinsteinContraction.affinePalatini_and_coframeStationarity_imply_leviCivita_vacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms affinePalatini_and_coframeStationarity_imply_leviCivita_vacuumEinstein

end PhysicsSM.Draft.NullEdge.LorentzCoordinateEinsteinContraction
