import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection

noncomputable section

/-!
# Exact exponential-link torsion selection

This module replaces the affine Lorentz-link tangent in the preceding local
Palatini theorem by the exact matrix-exponential link.  The exterior-square
transport is differentiated entrywise, then conjugated into the Hodge-dual
Palatini face coordinates.  Its derivative at the identity is exactly the
six-component physical transport tangent used by the affine theorem.

The main local result differentiates one exactly backward-transported
predecessor face while the predecessor coframe varies.  The resulting first
jet is the complementary Palatini response to

`V - lorentzGenerator(omega) * e`.

Thus the connection term selected by an exact proper Lorentz exponential is
the same covariant coframe jet that the affine calculation identified.  This
is an exact curve-level first-variation identity.  It does not yet identify
the derivative of the full nonidentity nonlinear link Euler coefficient,
prove nonlinear Levi-Civita uniqueness, supply metric dual-cell weights, or
establish a graph continuum limit.

Provenance: clean-room finite differentiation of the repository's exact
matrix-exponential Lorentz link and Hodge-conjugated exterior-square
transport.  The continuum comparator is the standard first-order Palatini
equation `D(e wedge e) = 0`; the nearest discrete action comparator remains
Kur and Glasser, *Discrete Gravity with Local Lorentz Invariance*
(arXiv:2202.02486).  Conventions are mostly-minus signature, orientation
`0123`, and ordered bivectors `(12,13,23,01,02,03)`.  Claim label: finite
identity.  Originality tag: `[orig]`.
-/

open scoped Matrix.Norms.Frobenius

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniExponentialConnectionTorsionSelection

open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-! ## Finite-dimensional derivative calculus -/

/-- Product rule for a matrix curve acting on a finite fiber curve. -/
theorem hasDerivAt_transportApply {n : Nat}
    (matrixCurve : Real -> Matrix (Fin n) (Fin n) Real)
    (matrixDerivative : Matrix (Fin n) (Fin n) Real)
    (fieldCurve : Real -> Fiber n) (fieldDerivative : Fiber n)
    (hMatrix : HasDerivAt matrixCurve matrixDerivative 0)
    (hField : HasDerivAt fieldCurve fieldDerivative 0) :
    HasDerivAt
      (fun t => transportApply (matrixCurve t) (fieldCurve t))
      (transportApply matrixDerivative (fieldCurve 0) +
        transportApply (matrixCurve 0) fieldDerivative) 0 := by
  rw [hasDerivAt_pi]
  intro row
  have hMatrixRow := hasDerivAt_pi.mp (hasDerivAt_pi.mp hMatrix row)
  have hFieldComponent := hasDerivAt_pi.mp hField
  have hSum := HasDerivAt.sum (u := Finset.univ) fun column _ =>
    (hMatrixRow column).mul (hFieldComponent column)
  simp only [transportApply, Pi.add_apply]
  convert hSum using 1
  · funext t
    simp
  · rw [Finset.sum_add_distrib]

/-- Product rule for a matrix curve acting through the Euclidean adjoint. -/
theorem hasDerivAt_transportAdjointApply {n : Nat}
    (matrixCurve : Real -> Matrix (Fin n) (Fin n) Real)
    (matrixDerivative : Matrix (Fin n) (Fin n) Real)
    (fieldCurve : Real -> Fiber n) (fieldDerivative : Fiber n)
    (hMatrix : HasDerivAt matrixCurve matrixDerivative 0)
    (hField : HasDerivAt fieldCurve fieldDerivative 0) :
    HasDerivAt
      (fun t => transportAdjointApply (matrixCurve t) (fieldCurve t))
      (transportAdjointApply matrixDerivative (fieldCurve 0) +
        transportAdjointApply (matrixCurve 0) fieldDerivative) 0 := by
  rw [hasDerivAt_pi]
  intro column
  have hMatrixComponent (row : Fin n) :=
    hasDerivAt_pi.mp (hasDerivAt_pi.mp hMatrix row) column
  have hFieldComponent := hasDerivAt_pi.mp hField
  have hSum := HasDerivAt.sum (u := Finset.univ) fun row _ =>
    (hMatrixComponent row).mul (hFieldComponent row)
  simp only [transportAdjointApply, Pi.add_apply]
  convert hSum using 1
  · funext t
    simp
  · rw [Finset.sum_add_distrib]

/-- A fixed finite transport carries derivatives through its fiber action. -/
theorem hasDerivAt_transportApply_const {n : Nat}
    (matrix : Matrix (Fin n) (Fin n) Real)
    (fieldCurve : Real -> Fiber n) (fieldDerivative : Fiber n)
    (hField : HasDerivAt fieldCurve fieldDerivative 0) :
    HasDerivAt (fun t => transportApply matrix (fieldCurve t))
      (transportApply matrix fieldDerivative) 0 := by
  have h := hasDerivAt_transportApply (fun _ : Real => matrix) 0
    fieldCurve fieldDerivative (hasDerivAt_const (x := (0 : Real)) matrix)
      hField
  convert h using 1
  funext component
  simp [transportApply]

/-- Product rule for a matrix curve acting through a fixed Krein adjoint. -/
theorem hasDerivAt_kreinAdjointApply {n : Nat}
    (fundamental : FundamentalSymmetry n)
    (matrixCurve : Real -> Matrix (Fin n) (Fin n) Real)
    (matrixDerivative : Matrix (Fin n) (Fin n) Real)
    (fieldCurve : Real -> Fiber n) (fieldDerivative : Fiber n)
    (hMatrix : HasDerivAt matrixCurve matrixDerivative 0)
    (hField : HasDerivAt fieldCurve fieldDerivative 0) :
    HasDerivAt
      (fun t => kreinAdjointApply fundamental
        (matrixCurve t) (fieldCurve t))
      (kreinAdjointApply fundamental matrixDerivative (fieldCurve 0) +
        kreinAdjointApply fundamental (matrixCurve 0) fieldDerivative) 0 := by
  have hInner := hasDerivAt_transportApply_const fundamental.matrix
    fieldCurve fieldDerivative hField
  have hMiddle := hasDerivAt_transportAdjointApply matrixCurve
    matrixDerivative
    (fun t => transportApply fundamental.matrix (fieldCurve t))
    (transportApply fundamental.matrix fieldDerivative) hMatrix hInner
  have hOuter := hasDerivAt_transportApply_const fundamental.matrix
    (fun t => transportAdjointApply (matrixCurve t)
      (transportApply fundamental.matrix (fieldCurve t)))
    (transportAdjointApply matrixDerivative
        (transportApply fundamental.matrix (fieldCurve 0)) +
      transportAdjointApply (matrixCurve 0)
        (transportApply fundamental.matrix fieldDerivative)) hMiddle
  unfold kreinAdjointApply
  convert hOuter using 1
  funext component
  simp only [Pi.add_apply]
  unfold transportApply
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro index _
  rw [Pi.add_apply]
  ring

/-! ## Exact exterior-square and Palatini transport tangents -/

/-- Differentiating the exact exterior-square exponential at the identity
gives the polarized exterior-square generator. -/
theorem hasDerivAt_wedgeTwoTransport_exponential
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    HasDerivAt
      (fun t : Real => wedgeTwoTransport
        (NormedSpace.exp (t • generator)))
      (wedgeTwoTransportFirstVariation generator) 0 := by
  rw [hasDerivAt_pi]
  intro row
  rw [hasDerivAt_pi]
  intro column
  have hExp : HasDerivAt
      (fun t : Real => NormedSpace.exp (t • generator)) generator 0 := by
    simpa using hasDerivAt_exp_smul_const (𝕂 := Real) generator 0
  have h11 := hasDerivAt_pi.mp
    (hasDerivAt_pi.mp hExp (bivectorFirst row)) (bivectorFirst column)
  have h22 := hasDerivAt_pi.mp
    (hasDerivAt_pi.mp hExp (bivectorSecond row)) (bivectorSecond column)
  have h12 := hasDerivAt_pi.mp
    (hasDerivAt_pi.mp hExp (bivectorFirst row)) (bivectorSecond column)
  have h21 := hasDerivAt_pi.mp
    (hasDerivAt_pi.mp hExp (bivectorSecond row)) (bivectorFirst column)
  have h := (h11.mul h22).sub (h12.mul h21)
  simp only [wedgeTwoTransport]
  unfold wedgeTwoTransportFirstVariation
  convert h using 1
  simp [wedgeTwoTransport, NormedSpace.exp_zero]
  ring

/-- Differentiating the exact Hodge-conjugated Palatini transport gives its
polarized first variation. -/
theorem hasDerivAt_palatiniBivectorTransport_exponential
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    HasDerivAt
      (fun t : Real => palatiniBivectorTransport
        (NormedSpace.exp (t • generator)))
      (palatiniBivectorTransportFirstVariation generator) 0 := by
  have h := (((hasDerivAt_wedgeTwoTransport_exponential generator).const_mul
    lorentzHodgeStar).mul_const lorentzHodgeStar).neg
  rw [palatiniBivectorTransportFirstVariation_eq_hodgeConjugate]
  simpa [palatiniBivectorTransport, Matrix.mul_assoc] using h

/-- Exact exponential four-vector transport, represented on the Palatini
face fiber. -/
def exponentialPhysicalPalatiniTransport
    (connection : Fiber 6) (t : Real) : Matrix (Fin 6) (Fin 6) Real :=
  palatiniBivectorTransport
    (NormedSpace.exp (t • lorentzGenerator connection))

/-- The exact physical Palatini transport is based at the identity. -/
@[simp]
theorem exponentialPhysicalPalatiniTransport_zero
    (connection : Fiber 6) :
    exponentialPhysicalPalatiniTransport connection 0 = 1 := by
  simp [exponentialPhysicalPalatiniTransport, palatiniBivectorTransport_one,
    NormedSpace.exp_zero]

/-- The exact exponential transport has the physical six-fiber Lorentz
generator as its derivative. -/
theorem hasDerivAt_exponentialPhysicalPalatiniTransport
    (connection : Fiber 6) :
    HasDerivAt (exponentialPhysicalPalatiniTransport connection)
      (physicalPalatiniTransportTangent connection) 0 := by
  simpa [exponentialPhysicalPalatiniTransport,
    physicalPalatiniTransportTangent] using
      hasDerivAt_palatiniBivectorTransport_exponential
        (lorentzGenerator connection)

/-! ## Exact backward-transported face jet -/

/-- The derivative of a complementary Palatini face along an affine coframe
line is its polarized first variation. -/
theorem hasDerivAt_complementaryPalatiniFaceWeight_line
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    HasDerivAt
      (fun t : Real => complementaryPalatiniFaceWeight
        (coframe + t • variation) first second)
      (complementaryPalatiniFaceWeightFirstVariation
        coframe variation first second) 0 := by
  have h :=
    (hasDerivAt_const (x := (0 : Real))
      (complementaryPalatiniFaceWeight coframe first second)).add
      ((hasDerivAt_id (x := (0 : Real))).smul_const
        (complementaryPalatiniFaceWeightFirstVariation
          coframe variation first second)) |>.add
      (((hasDerivAt_id (x := (0 : Real))).pow 2).smul_const
        (complementaryPalatiniFaceWeight variation first second))
  convert h using 1
  · funext t
    rw [complementaryPalatiniFaceWeight_line]
    rfl
  · simp

/-- The Krein adjoint of the physical infinitesimal transport is minus its
forward action. -/
theorem kreinAdjointApply_physicalPalatiniTransportTangent
    (connection field : Fiber 6) :
    kreinAdjointApply lorentzBivectorFundamentalSymmetry
        (physicalPalatiniTransportTangent connection) field =
      -transportApply (physicalPalatiniTransportTangent connection) field := by
  unfold kreinAdjointApply
  rw [transportApply_eq_mulVec, transportAdjointApply_eq_transpose_mulVec,
    transportApply_eq_mulVec]
  simp only [Matrix.mulVec_mulVec]
  rw [← Matrix.mul_assoc]
  rw [physicalPalatiniTransportTangent_kreinSkew]
  funext component
  change
    (∑ index, (-physicalPalatiniTransportTangent connection component index) *
      field index) =
      -(∑ index, physicalPalatiniTransportTangent connection component index *
        field index)
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro index _
  ring

/-- One predecessor face transported by an exact exponential Lorentz link. -/
def exponentialTransportedComplementaryFace
    (coframe velocity : Matrix (Fin 4) (Fin 4) Real)
    (connection : Fiber 6) (t : Real) (first second : Fin 4) : Fiber 6 :=
  kreinAdjointApply lorentzBivectorFundamentalSymmetry
    (exponentialPhysicalPalatiniTransport connection t)
    (complementaryPalatiniFaceWeight
      (coframe + t • velocity) first second)

/-- **Exact exponential local covariant face jet.**  Differentiating one
exactly backward-transported predecessor face produces the Palatini response
to the covariant coframe velocity `V - omega e`. -/
theorem hasDerivAt_exponentialTransportedComplementaryFace
    (coframe velocity : Matrix (Fin 4) (Fin 4) Real)
    (connection : Fiber 6) (first second : Fin 4) :
    HasDerivAt
      (fun t => exponentialTransportedComplementaryFace
        coframe velocity connection t first second)
      (complementaryPalatiniFaceWeightFirstVariation coframe
        (velocity - lorentzGenerator connection * coframe) first second) 0 := by
  have hTransport :=
    hasDerivAt_exponentialPhysicalPalatiniTransport connection
  have hFace := hasDerivAt_complementaryPalatiniFaceWeight_line
    coframe velocity first second
  have h := hasDerivAt_kreinAdjointApply
    lorentzBivectorFundamentalSymmetry
    (exponentialPhysicalPalatiniTransport connection)
    (physicalPalatiniTransportTangent connection)
    (fun t => complementaryPalatiniFaceWeight
      (coframe + t • velocity) first second)
    (complementaryPalatiniFaceWeightFirstVariation
      coframe velocity first second) hTransport hFace
  have hDerivative :
      kreinAdjointApply lorentzBivectorFundamentalSymmetry
          (physicalPalatiniTransportTangent connection)
          (complementaryPalatiniFaceWeight
            (coframe + (0 : Real) • velocity) first second) +
        kreinAdjointApply lorentzBivectorFundamentalSymmetry
          (exponentialPhysicalPalatiniTransport connection 0)
          (complementaryPalatiniFaceWeightFirstVariation
            coframe velocity first second) =
      complementaryPalatiniFaceWeightFirstVariation coframe
        (velocity - lorentzGenerator connection * coframe) first second := by
    simp only [zero_smul, add_zero,
      exponentialPhysicalPalatiniTransport_zero, kreinAdjointApply_one]
    rw [kreinAdjointApply_physicalPalatiniTransportTangent]
    unfold physicalPalatiniTransportTangent
    rw [transportApply_palatiniBivectorTransportFirstVariation]
    rw [show velocity - lorentzGenerator connection * coframe =
        velocity + (-1 : Real) •
          (lorentzGenerator connection * coframe) by module]
    rw [complementaryPalatiniFaceWeightFirstVariation_add,
      complementaryPalatiniFaceWeightFirstVariation_smul]
    funext component
    simp only [Pi.add_apply, Pi.neg_apply, Pi.smul_apply, smul_eq_mul]
    ring
  exact (h.congr_deriv hDerivative)

/-! ## Exact exponential residual and torsion equivalence -/

/-- Four-direction backward Palatini residual with exact exponential physical
Lorentz links and affine predecessor coframe curves. -/
def exponentialCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (t : Real) (direction : Fin 4) : Fiber 6 :=
  Finset.sum Finset.univ (fun backwardDirection =>
    exponentialTransportedComplementaryFace coframe
        (velocity backwardDirection) (connection backwardDirection) t
        direction backwardDirection -
      complementaryPalatiniFaceWeight coframe direction backwardDirection)

/-- The exact exponential residual is based at zero. -/
@[simp]
theorem exponentialCovariantPalatiniResidual_zero
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) :
    exponentialCovariantPalatiniResidual coframe connection velocity 0
        direction = 0 := by
  unfold exponentialCovariantPalatiniResidual
    exponentialTransportedComplementaryFace
  simp [kreinAdjointApply_one]

/-- **Exact exponential residual first jet.**  The derivative of the full
four-direction exact exponential residual is exactly the affine covariant
Palatini residual already shown equivalent to Cartan torsion. -/
theorem hasDerivAt_exponentialCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) :
    HasDerivAt
      (fun t => exponentialCovariantPalatiniResidual
        coframe connection velocity t direction)
      (linearizedAffineCovariantPalatiniResidual
        coframe connection velocity direction) 0 := by
  have hSum := HasDerivAt.sum (u := Finset.univ) fun backwardDirection _ =>
    (hasDerivAt_exponentialTransportedComplementaryFace coframe
      (velocity backwardDirection) (connection backwardDirection)
      direction backwardDirection).sub_const
        (complementaryPalatiniFaceWeight coframe direction backwardDirection)
  have hDerivative :
      (Finset.sum Finset.univ (fun backwardDirection =>
        complementaryPalatiniFaceWeightFirstVariation coframe
          (velocity backwardDirection -
            lorentzGenerator (connection backwardDirection) * coframe)
          direction backwardDirection)) =
        linearizedAffineCovariantPalatiniResidual
          coframe connection velocity direction := by
    rw [linearizedAffineCovariantPalatiniResidual_eq]
    funext component
    rfl
  have hAdjusted := hSum.congr_deriv hDerivative
  apply hAdjusted.congr_of_eventuallyEq
  filter_upwards with t
  rfl

/-- At a coframe with a supplied inverse, vanishing of every derivative of
the exact exponential residual is equivalent to covariant Cartan torsion
freeness. -/
theorem exponentialCovariantPalatiniResidual_derivatives_vanish_iff_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    (forall direction component,
      deriv (fun t => exponentialCovariantPalatiniResidual
        coframe connection velocity t direction) 0 component = 0) <->
      LinearizedCovariantTorsionFree coframe connection velocity := by
  have hDerivative (direction : Fin 4) :
      deriv (fun t => exponentialCovariantPalatiniResidual
        coframe connection velocity t direction) 0 =
      linearizedAffineCovariantPalatiniResidual
        coframe connection velocity direction :=
    (hasDerivAt_exponentialCovariantPalatiniResidual
      coframe connection velocity direction).deriv
  simp_rw [hDerivative]
  exact linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft connection velocity

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniExponentialConnectionTorsionSelection.hasDerivAt_palatiniBivectorTransport_exponential' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_palatiniBivectorTransport_exponential

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniExponentialConnectionTorsionSelection.hasDerivAt_exponentialTransportedComplementaryFace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_exponentialTransportedComplementaryFace

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniExponentialConnectionTorsionSelection.exponentialCovariantPalatiniResidual_derivatives_vanish_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exponentialCovariantPalatiniResidual_derivatives_vanish_iff_torsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniExponentialConnectionTorsionSelection
