import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita

noncomputable section

/-!
# Lorentz curvature equals induced coordinate curvature

This module closes the finite second-jet algebra behind the tetrad/connection
curvature dictionary.  In the project's predecessor convention, write

`Gamma_a = eInv (omega_a e - V_a)`,

where `V_a = -partial_a e`.  The corresponding derivative uses

`partial_a eInv = eInv V_a eInv`.

The module first derives this inverse first-jet formula from the differentiated
two-sided inverse relation; it is not an extra hidden convention.

Given first jets of `omega` and `V`, the exact noncommutative calculation proves

`R(Gamma)_{ab} = eInv F(omega)_{ab} e`,

provided the mixed predecessor coframe second jets commute.  Both curvatures
include their quadratic commutator terms.  A convention bridge then specializes
the generic matrix identity to the six-component Lorentz connection used by
the null-edge Palatini action.

This is a finite second-jet identity.  It does not construct second jets from a
graph, prove mixed-derivative convergence, or identify a finite plaquette
holonomy with the displayed differential curvature.  Combining it with local
Palatini-to-Levi-Civita selection requires the selection equation on a
compatible neighborhood/refinement, not only at one isolated point.  Claim
label: finite Lorentz-to-coordinate curvature identity.  Originality tag:
`[comp/orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge

open PhysicsSM.Draft.NullEdge.CausalLeviCivita
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-- A four-dimensional real matrix, used for coframes and connection matrices.
-/
abbrev Matrix4R := Matrix (Fin 4) (Fin 4) Real

/-- A matrix-valued connection at one point. -/
abbrev MatrixConnection := Fin 4 -> Matrix4R

/-- First jet of a matrix-valued connection.  The indices are ordered as
`derivativeDirection, connectionDirection`. -/
abbrev MatrixConnectionFirstJet := Fin 4 -> Fin 4 -> Matrix4R

/-- First jet of the six-component Lorentz connection. -/
abbrev LorentzConnectionFirstJet := Fin 4 -> LorentzConnectionVelocity

/-- First jet of the predecessor coframe velocity, equivalently minus the
coframe second jet. -/
abbrev PredecessorCoframeSecondJet := Fin 4 -> CoframeVelocity

/-- Numerator in the predecessor-convention tetrad postulate. -/
def predecessorConnectionNumerator
    (coframe : Matrix4R) (omega : MatrixConnection)
    (velocity : CoframeVelocity) (direction : Fin 4) : Matrix4R :=
  omega direction * coframe - velocity direction

/-- Coordinate connection matrix induced from a coframe and a matrix Lorentz
connection in the predecessor convention. -/
def predecessorInducedConnectionMatrix
    (coframe inverseCoframe : Matrix4R) (omega : MatrixConnection)
    (velocity : CoframeVelocity) : MatrixConnection :=
  fun direction => inverseCoframe *
    predecessorConnectionNumerator coframe omega velocity direction

/-- Differentiating the inverse-coframe relation derives the predecessor-sign
inverse first jet.  Here `inverseFirstJet` is a supplied derivative of `eInv`
and `hProduct` is the product-rule derivative of `e * eInv = 1` under
`partial_a e = -V_a`. -/
theorem inverseCoframeFirstJet_eq
    (coframe inverseCoframe velocityAt inverseFirstJet : Matrix4R)
    (hLeft : inverseCoframe * coframe = 1)
    (hProduct : (-velocityAt) * inverseCoframe +
      coframe * inverseFirstJet = 0) :
    inverseFirstJet = inverseCoframe * velocityAt * inverseCoframe := by
  have hDerivative : coframe * inverseFirstJet =
      velocityAt * inverseCoframe := by
    calc
      coframe * inverseFirstJet =
          -((-velocityAt) * inverseCoframe) :=
        eq_neg_of_add_eq_zero_right hProduct
      _ = velocityAt * inverseCoframe := by noncomm_ring
  calc
    inverseFirstJet = 1 * inverseFirstJet := by simp
    _ = (inverseCoframe * coframe) * inverseFirstJet := by rw [hLeft]
    _ = inverseCoframe * (coframe * inverseFirstJet) := by noncomm_ring
    _ = inverseCoframe * (velocityAt * inverseCoframe) := by rw [hDerivative]
    _ = inverseCoframe * velocityAt * inverseCoframe := by noncomm_ring

/-- First jet of the induced coordinate connection.  This is the product-rule
derivative of `eInv (omega_b e - V_b)` using
`partial_a eInv = eInv V_a eInv` and `partial_a e = -V_a`. -/
def predecessorInducedConnectionFirstJet
    (coframe inverseCoframe : Matrix4R) (omega : MatrixConnection)
    (velocity : CoframeVelocity) (omegaFirstJet : MatrixConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet) :
    MatrixConnectionFirstJet :=
  fun derivative direction =>
    inverseCoframe * velocity derivative * inverseCoframe *
        predecessorConnectionNumerator coframe omega velocity direction +
      inverseCoframe *
        (omegaFirstJet derivative direction * coframe -
          omega direction * velocity derivative -
          velocityFirstJet derivative direction)

/-- Curvature matrix of a matrix-valued connection and its supplied first jet.
-/
def matrixConnectionCurvature
    (connection : MatrixConnection)
    (connectionFirstJet : MatrixConnectionFirstJet)
    (left right : Fin 4) : Matrix4R :=
  connectionFirstJet left right - connectionFirstJet right left +
    connection left * connection right - connection right * connection left

/-- Differential Lorentz curvature `d omega + omega wedge omega`. -/
def lorentzCurvatureMatrix
    (omega : MatrixConnection) (omegaFirstJet : MatrixConnectionFirstJet)
    (left right : Fin 4) : Matrix4R :=
  omegaFirstJet left right - omegaFirstJet right left +
    omega left * omega right - omega right * omega left

/-- The cancellation pair used in the tetrad curvature identity. -/
lemma velocity_mul_inverse_mul_numerator_add_numerator_mul_inverse_mul_numerator
    (coframe inverseCoframe : Matrix4R) (omega : MatrixConnection)
    (velocity : CoframeVelocity) (hRight : coframe * inverseCoframe = 1)
    (left right : Fin 4) :
    velocity left * inverseCoframe *
          predecessorConnectionNumerator coframe omega velocity right +
        predecessorConnectionNumerator coframe omega velocity left *
          inverseCoframe *
            predecessorConnectionNumerator coframe omega velocity right =
      omega left *
        predecessorConnectionNumerator coframe omega velocity right := by
  calc
    velocity left * inverseCoframe *
          predecessorConnectionNumerator coframe omega velocity right +
        predecessorConnectionNumerator coframe omega velocity left *
          inverseCoframe *
            predecessorConnectionNumerator coframe omega velocity right =
        omega left * coframe * inverseCoframe *
          predecessorConnectionNumerator coframe omega velocity right := by
      unfold predecessorConnectionNumerator
      noncomm_ring
    _ = omega left * (coframe * inverseCoframe) *
          predecessorConnectionNumerator coframe omega velocity right := by
      noncomm_ring
    _ = omega left *
          predecessorConnectionNumerator coframe omega velocity right := by
      rw [hRight]
      simp

/-- **Exact finite tetrad curvature identity.**  The curvature of the
coordinate connection induced by the predecessor-convention tetrad postulate
is the coframe conjugate of the Lorentz curvature. -/
theorem predecessorInducedConnection_curvature_eq_conjugate
    (coframe inverseCoframe : Matrix4R) (omega : MatrixConnection)
    (velocity : CoframeVelocity) (omegaFirstJet : MatrixConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hRight : coframe * inverseCoframe = 1)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (left right : Fin 4) :
    matrixConnectionCurvature
        (predecessorInducedConnectionMatrix coframe inverseCoframe omega
          velocity)
        (predecessorInducedConnectionFirstJet coframe inverseCoframe omega
          velocity omegaFirstJet velocityFirstJet) left right =
      inverseCoframe * lorentzCurvatureMatrix omega omegaFirstJet left right *
        coframe := by
  have hPairLeft :=
    velocity_mul_inverse_mul_numerator_add_numerator_mul_inverse_mul_numerator
      coframe inverseCoframe omega velocity hRight left right
  have hPairRight :=
    velocity_mul_inverse_mul_numerator_add_numerator_mul_inverse_mul_numerator
      coframe inverseCoframe omega velocity hRight right left
  unfold matrixConnectionCurvature predecessorInducedConnectionMatrix
    predecessorInducedConnectionFirstJet lorentzCurvatureMatrix
  rw [hMixed left right]
  calc
    (inverseCoframe * velocity left * inverseCoframe *
            predecessorConnectionNumerator coframe omega velocity right +
          inverseCoframe *
            (omegaFirstJet left right * coframe -
              omega right * velocity left - velocityFirstJet right left)) -
        (inverseCoframe * velocity right * inverseCoframe *
            predecessorConnectionNumerator coframe omega velocity left +
          inverseCoframe *
            (omegaFirstJet right left * coframe -
              omega left * velocity right - velocityFirstJet right left)) +
        inverseCoframe *
            predecessorConnectionNumerator coframe omega velocity left *
          (inverseCoframe *
            predecessorConnectionNumerator coframe omega velocity right) -
        inverseCoframe *
            predecessorConnectionNumerator coframe omega velocity right *
          (inverseCoframe *
            predecessorConnectionNumerator coframe omega velocity left) =
      inverseCoframe *
        ((velocity left * inverseCoframe *
              predecessorConnectionNumerator coframe omega velocity right +
            predecessorConnectionNumerator coframe omega velocity left *
              inverseCoframe *
                predecessorConnectionNumerator coframe omega velocity right) -
          (velocity right * inverseCoframe *
              predecessorConnectionNumerator coframe omega velocity left +
            predecessorConnectionNumerator coframe omega velocity right *
              inverseCoframe *
                predecessorConnectionNumerator coframe omega velocity left) +
          (omegaFirstJet left right * coframe -
            omega right * velocity left - velocityFirstJet right left) -
          (omegaFirstJet right left * coframe -
            omega left * velocity right - velocityFirstJet right left)) := by
        noncomm_ring
    _ = inverseCoframe *
        (omega left *
            predecessorConnectionNumerator coframe omega velocity right -
          omega right *
            predecessorConnectionNumerator coframe omega velocity left +
          (omegaFirstJet left right * coframe -
            omega right * velocity left - velocityFirstJet right left) -
          (omegaFirstJet right left * coframe -
            omega left * velocity right - velocityFirstJet right left)) := by
      rw [hPairLeft, hPairRight]
    _ = inverseCoframe *
        (omegaFirstJet left right - omegaFirstJet right left +
          omega left * omega right - omega right * omega left) * coframe := by
      unfold predecessorConnectionNumerator
      noncomm_ring

/-- Matrix connection obtained from the project's six Lorentz coordinates. -/
def generatedLorentzConnection
    (connection : LorentzConnectionVelocity) : MatrixConnection :=
  fun direction => lorentzGenerator (connection direction)

/-- Matrix first jet obtained from six-component Lorentz-connection first jets.
-/
def generatedLorentzConnectionFirstJet
    (connectionFirstJet : LorentzConnectionFirstJet) :
    MatrixConnectionFirstJet :=
  fun derivative direction =>
    lorentzGenerator (connectionFirstJet derivative direction)

/-- The Lorentz Lie-algebra condition is closed under addition. -/
theorem isLorentzLieAlgebra_add
    {left right : Matrix4R}
    (hLeft : IsLorentzLieAlgebra left)
    (hRight : IsLorentzLieAlgebra right) :
    IsLorentzLieAlgebra (left + right) := by
  unfold IsLorentzLieAlgebra at hLeft hRight
  unfold IsLorentzLieAlgebra
  calc
    (left + right).transpose * MinkowskiConvention.eta +
        MinkowskiConvention.eta * (left + right) =
      (left.transpose * MinkowskiConvention.eta +
          MinkowskiConvention.eta * left) +
        (right.transpose * MinkowskiConvention.eta +
          MinkowskiConvention.eta * right) := by
      rw [Matrix.transpose_add, Matrix.add_mul, Matrix.mul_add]
      abel
    _ = 0 := by rw [hLeft, hRight]; simp

/-- The Lorentz Lie-algebra condition is closed under subtraction. -/
theorem isLorentzLieAlgebra_sub
    {left right : Matrix4R}
    (hLeft : IsLorentzLieAlgebra left)
    (hRight : IsLorentzLieAlgebra right) :
    IsLorentzLieAlgebra (left - right) := by
  unfold IsLorentzLieAlgebra at hLeft hRight
  unfold IsLorentzLieAlgebra
  calc
    (left - right).transpose * MinkowskiConvention.eta +
        MinkowskiConvention.eta * (left - right) =
      (left.transpose * MinkowskiConvention.eta +
          MinkowskiConvention.eta * left) -
        (right.transpose * MinkowskiConvention.eta +
          MinkowskiConvention.eta * right) := by
      rw [Matrix.transpose_sub, Matrix.sub_mul, Matrix.mul_sub]
      abel
    _ = 0 := by rw [hLeft, hRight]; simp

/-- The commutator of two Lorentz Lie-algebra matrices is again Lorentz. -/
theorem isLorentzLieAlgebra_commutator
    {left right : Matrix4R}
    (hLeft : IsLorentzLieAlgebra left)
    (hRight : IsLorentzLieAlgebra right) :
    IsLorentzLieAlgebra (left * right - right * left) := by
  unfold IsLorentzLieAlgebra at hLeft hRight
  unfold IsLorentzLieAlgebra
  have hLeftTranspose :
      left.transpose * MinkowskiConvention.eta =
        -(MinkowskiConvention.eta * left) :=
    eq_neg_of_add_eq_zero_left hLeft
  have hRightTranspose :
      right.transpose * MinkowskiConvention.eta =
        -(MinkowskiConvention.eta * right) :=
    eq_neg_of_add_eq_zero_left hRight
  rw [Matrix.transpose_sub, Matrix.transpose_mul, Matrix.transpose_mul,
    Matrix.sub_mul, Matrix.mul_sub]
  calc
    (right.transpose * left.transpose) * MinkowskiConvention.eta -
          (left.transpose * right.transpose) * MinkowskiConvention.eta +
        (MinkowskiConvention.eta * (left * right) -
          MinkowskiConvention.eta * (right * left)) =
      right.transpose *
          (left.transpose * MinkowskiConvention.eta) -
        left.transpose *
          (right.transpose * MinkowskiConvention.eta) +
        (MinkowskiConvention.eta * (left * right) -
          MinkowskiConvention.eta * (right * left)) := by
      noncomm_ring
    _ = right.transpose * (-(MinkowskiConvention.eta * left)) -
        left.transpose * (-(MinkowskiConvention.eta * right)) +
        (MinkowskiConvention.eta * (left * right) -
          MinkowskiConvention.eta * (right * left)) := by
      rw [hLeftTranspose, hRightTranspose]
    _ = -(right.transpose * MinkowskiConvention.eta) * left +
        (left.transpose * MinkowskiConvention.eta) * right +
        (MinkowskiConvention.eta * (left * right) -
          MinkowskiConvention.eta * (right * left)) := by
      noncomm_ring
    _ = -(-(MinkowskiConvention.eta * right)) * left +
        (-(MinkowskiConvention.eta * left)) * right +
        (MinkowskiConvention.eta * (left * right) -
          MinkowskiConvention.eta * (right * left)) := by
      rw [hLeftTranspose, hRightTranspose]
    _ = 0 := by noncomm_ring

/-- The full differential curvature of generated six-component connection
jets remains in the Lorentz Lie algebra. -/
theorem generatedLorentzCurvature_mem
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (left right : Fin 4) :
    IsLorentzLieAlgebra
      (lorentzCurvatureMatrix (generatedLorentzConnection connection)
        (generatedLorentzConnectionFirstJet connectionFirstJet) left right) := by
  unfold lorentzCurvatureMatrix generatedLorentzConnection
    generatedLorentzConnectionFirstJet
  rw [show
    lorentzGenerator (connectionFirstJet left right) -
          lorentzGenerator (connectionFirstJet right left) +
        lorentzGenerator (connection left) * lorentzGenerator (connection right) -
          lorentzGenerator (connection right) * lorentzGenerator (connection left) =
      (lorentzGenerator (connectionFirstJet left right) -
          lorentzGenerator (connectionFirstJet right left)) +
        (lorentzGenerator (connection left) * lorentzGenerator (connection right) -
          lorentzGenerator (connection right) * lorentzGenerator (connection left)) by
    noncomm_ring]
  exact isLorentzLieAlgebra_add
    (isLorentzLieAlgebra_sub
      (lorentzGenerator_mem (connectionFirstJet left right))
      (lorentzGenerator_mem (connectionFirstJet right left)))
    (isLorentzLieAlgebra_commutator
      (lorentzGenerator_mem (connection left))
      (lorentzGenerator_mem (connection right)))

/-- Six action coordinates of the full differential Lorentz curvature. -/
def generatedLorentzCurvatureCoordinates
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (left right : Fin 4) : Fiber 6 :=
  lorentzGeneratorCoordinates
    (lorentzCurvatureMatrix (generatedLorentzConnection connection)
      (generatedLorentzConnectionFirstJet connectionFirstJet) left right)

/-- Recovering the matrix generator from the six action coordinates returns the
full differential Lorentz curvature exactly. -/
theorem lorentzGenerator_generatedLorentzCurvatureCoordinates
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (left right : Fin 4) :
    lorentzGenerator
        (generatedLorentzCurvatureCoordinates connection connectionFirstJet
          left right) =
      lorentzCurvatureMatrix (generatedLorentzConnection connection)
        (generatedLorentzConnectionFirstJet connectionFirstJet) left right := by
  exact lorentzGenerator_lorentzGeneratorCoordinates _
    (generatedLorentzCurvature_mem connection connectionFirstJet left right)

/-- The generic predecessor-induced matrix connection is exactly the matrix
form already used by the Palatini-to-Levi-Civita bridge. -/
theorem predecessorInducedConnectionMatrix_generated_eq
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    predecessorInducedConnectionMatrix coframe inverseCoframe
        (generatedLorentzConnection connection) velocity =
      fun direction => inducedCoordinateConnectionMatrix coframe inverseCoframe
        connection velocity direction := by
  rfl

/-- **Null-edge Lorentz curvature bridge.**  Specialization of the exact
second-jet curvature identity to the six-component Lorentz connection used by
the null-edge action. -/
theorem inducedCoordinateConnection_curvature_eq_generatedLorentzCurvature
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hRight : coframe * inverseCoframe = 1)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (left right : Fin 4) :
    matrixConnectionCurvature
        (fun direction => inducedCoordinateConnectionMatrix coframe
          inverseCoframe connection velocity direction)
        (predecessorInducedConnectionFirstJet coframe inverseCoframe
          (generatedLorentzConnection connection) velocity
          (generatedLorentzConnectionFirstJet connectionFirstJet)
          velocityFirstJet) left right =
      inverseCoframe *
          lorentzCurvatureMatrix (generatedLorentzConnection connection)
            (generatedLorentzConnectionFirstJet connectionFirstJet) left right *
        coframe := by
  exact predecessorInducedConnection_curvature_eq_conjugate
    coframe inverseCoframe (generatedLorentzConnection connection) velocity
      (generatedLorentzConnectionFirstJet connectionFirstJet)
      velocityFirstJet hRight hMixed left right

/-- The induced coordinate curvature is the coframe conjugate of the Lorentz
generator reconstructed from the same six curvature coordinates used by the
Palatini action. -/
theorem inducedCoordinateConnection_curvature_eq_actionCoordinates
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hRight : coframe * inverseCoframe = 1)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (left right : Fin 4) :
    matrixConnectionCurvature
        (fun direction => inducedCoordinateConnectionMatrix coframe
          inverseCoframe connection velocity direction)
        (predecessorInducedConnectionFirstJet coframe inverseCoframe
          (generatedLorentzConnection connection) velocity
          (generatedLorentzConnectionFirstJet connectionFirstJet)
          velocityFirstJet) left right =
      inverseCoframe *
          lorentzGenerator
            (generatedLorentzCurvatureCoordinates connection connectionFirstJet
              left right) *
        coframe := by
  rw [lorentzGenerator_generatedLorentzCurvatureCoordinates]
  exact inducedCoordinateConnection_curvature_eq_generatedLorentzCurvature
    coframe inverseCoframe connection velocity connectionFirstJet
      velocityFirstJet hRight hMixed left right

/-- **Palatini-selected Levi-Civita connection with its curvature bridge.**
Vanishing affine Palatini residuals select the Christoffel connection at first
jet order, while compatible symmetric second coframe jets identify the induced
coordinate curvature with the coframe conjugate of the full Lorentz curvature.
The conjunction keeps the two required jet orders explicit. -/
theorem affinePalatiniResidual_vanish_implies_leviCivita_and_curvatureBridge
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
    (left right : Fin 4) :
    inducedCoordinateConnection coframe inverseCoframe connection velocity =
        christoffelSecondKind (inverseCoframeMetric inverseCoframe)
          (inducedMetricFirstJet coframe velocity) /\
      matrixConnectionCurvature
          (fun direction => inducedCoordinateConnectionMatrix coframe
            inverseCoframe connection velocity direction)
          (predecessorInducedConnectionFirstJet coframe inverseCoframe
            (generatedLorentzConnection connection) velocity
            (generatedLorentzConnectionFirstJet connectionFirstJet)
            velocityFirstJet) left right =
        inverseCoframe *
            lorentzCurvatureMatrix (generatedLorentzConnection connection)
              (generatedLorentzConnectionFirstJet connectionFirstJet) left
              right *
          coframe := by
  exact And.intro
    (affinePalatiniResidual_vanish_implies_inducedLeviCivita
      coframe inverseCoframe connection velocity hLeft hRight hPalatini)
    (inducedCoordinateConnection_curvature_eq_generatedLorentzCurvature
      coframe inverseCoframe connection velocity connectionFirstJet
        velocityFirstJet hRight hMixed left right)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge.predecessorInducedConnection_curvature_eq_conjugate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms predecessorInducedConnection_curvature_eq_conjugate

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge.inducedCoordinateConnection_curvature_eq_generatedLorentzCurvature' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inducedCoordinateConnection_curvature_eq_generatedLorentzCurvature

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge.inducedCoordinateConnection_curvature_eq_actionCoordinates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inducedCoordinateConnection_curvature_eq_actionCoordinates

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge.affinePalatiniResidual_vanish_implies_leviCivita_and_curvatureBridge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms affinePalatiniResidual_vanish_implies_leviCivita_and_curvatureBridge

end PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge
