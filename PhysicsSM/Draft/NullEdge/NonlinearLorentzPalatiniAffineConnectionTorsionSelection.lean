import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection

noncomputable section

/-!
# Connection-dependent torsion selection from an affine Lorentz-link tangent

This module introduces the first connection-dependent torsion theorem in the
null-edge Palatini chain.  A six-component Lorentz connection velocity
`omega_b` supplies an infinitesimal four-vector generator and, through the
exterior-square/Hodge transport, an infinitesimal Palatini-face transport.
The Krein adjoint reverses the sign of that generator.  Consequently the
linear coefficient of the backward transported face difference is the
ordinary Palatini coframe response evaluated on

`V_b - lorentzGenerator(omega_b) * e`.

With predecessor increments `V_b = -partial_b e`, vanishing of the resulting
Cartan torsion is the usual equation `de + omega wedge e = 0` up to one overall
sign.  At every coframe with a supplied inverse, the twenty-four affine
connection equations therefore vanish exactly when this connection-dependent
torsion vanishes.

The exact finite affine residual has terms through order three in the spacing:

`h * linear + h^2 * quadratic - h^3 * cubic`.

This is a finite affine-tangent identity and a conditional shrinking-spacing
theorem.  The affine six-fiber transport is not yet an exact exponential
Lorentz link, and this module does not prove equivalence with the full
nonidentity nonlinear link Euler coefficients, nonlinear Levi-Civita
uniqueness, metric compatibility at finite spacing, graph refinement, or a
continuum limit.

Provenance: clean-room finite implementation of the standard first-order
Palatini connection equation `D(e wedge e) = 0 => de + omega wedge e = 0`,
with Kur and Glasser, *Discrete Gravity with Local Lorentz Invariance*
(arXiv:2202.02486, especially their continuum equation (14) and discrete
connection equations (28)-(29)), as the closest action/Euler-equation
comparator.  The definitions are specialized to the repository's
mostly-minus, orientation-`0123`, ordered-bivector, and
predecessor-difference conventions; no source implementation text is copied.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-! ## Infinitesimal Palatini transport -/

/-- Polarized first variation at the identity of the quadratic Palatini
bivector transport. -/
def palatiniBivectorTransportFirstVariation
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  palatiniBivectorTransport (1 + generator) -
    palatiniBivectorTransport 1 - palatiniBivectorTransport generator

/-- Polarized first variation at the identity of the exterior-square
four-vector transport. -/
def wedgeTwoTransportFirstVariation
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  wedgeTwoTransport (1 + generator) -
    wedgeTwoTransport 1 - wedgeTwoTransport generator

/-- Hodge conjugation commutes with taking the polarized first variation. -/
theorem palatiniBivectorTransportFirstVariation_eq_hodgeConjugate
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    palatiniBivectorTransportFirstVariation generator =
      -(lorentzHodgeStar * wedgeTwoTransportFirstVariation generator *
        lorentzHodgeStar) := by
  unfold palatiniBivectorTransportFirstVariation
    wedgeTwoTransportFirstVariation palatiniBivectorTransport
  noncomm_ring

/-- The conjugated Palatini transport of the identity matrix is the identity
on the six-component face fiber. -/
theorem palatiniBivectorTransport_one :
    palatiniBivectorTransport (1 : Matrix (Fin 4) (Fin 4) Real) = 1 := by
  have hWedge :
      wedgeTwoTransport (1 : Matrix (Fin 4) (Fin 4) Real) = 1 := by
    ext row column
    fin_cases row <;> fin_cases column <;>
      simp +decide [wedgeTwoTransport, bivectorFirst, bivectorSecond]
  unfold palatiniBivectorTransport
  rw [hWedge, Matrix.mul_one, lorentzHodgeStar_sq]
  simp

/-- Transport is linear in its matrix argument. -/
theorem transportApply_matrix_sub
    (left right : Matrix (Fin 6) (Fin 6) Real) (field : Fiber 6) :
    transportApply (left - right) field =
      transportApply left field - transportApply right field := by
  funext component
  simp [transportApply, Finset.sum_sub_distrib, sub_mul]

/-- Arbitrary internal basis covariance of an unpolarized Hodge-dual
Palatini face. -/
theorem palatiniFaceWeight_mul_arbitrary
    (matrix coframe : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    palatiniFaceWeight (matrix * coframe) first second =
      transportApply (palatiniBivectorTransport matrix)
        (palatiniFaceWeight coframe first second) := by
  unfold palatiniFaceWeight
  rw [coframeWedge_mul]
  simp only [transportApply_eq_mulVec, Matrix.mulVec_mulVec]
  rw [palatiniBivectorTransport_mul_lorentzHodgeStar]

/-- Arbitrary internal basis covariance of the complementary Palatini face. -/
theorem complementaryPalatiniFaceWeight_mul_arbitrary
    (matrix coframe : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    complementaryPalatiniFaceWeight (matrix * coframe) first second =
      transportApply (palatiniBivectorTransport matrix)
        (complementaryPalatiniFaceWeight coframe first second) := by
  rw [complementaryPalatiniFaceWeight_eq_double_sum,
    complementaryPalatiniFaceWeight_eq_double_sum]
  simp_rw [palatiniFaceWeight_mul_arbitrary]
  exact (transportApply_weightedDoubleSum_fin4
    (palatiniBivectorTransport matrix)
    (fun left right => (1 / 2 : Real) *
      spacetimeAlternatingSymbol left right first second)
    (fun left right => palatiniFaceWeight coframe left right)).symm

/-- The infinitesimal Palatini transport acting on a background face equals
the polarized face response generated by the corresponding internal coframe
change. -/
theorem transportApply_palatiniBivectorTransportFirstVariation
    (generator coframe : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    transportApply (palatiniBivectorTransportFirstVariation generator)
        (complementaryPalatiniFaceWeight coframe first second) =
      complementaryPalatiniFaceWeightFirstVariation coframe
        (generator * coframe) first second := by
  unfold palatiniBivectorTransportFirstVariation
  rw [transportApply_matrix_sub, transportApply_matrix_sub]
  rw [<- complementaryPalatiniFaceWeight_mul_arbitrary,
    <- complementaryPalatiniFaceWeight_mul_arbitrary,
    <- complementaryPalatiniFaceWeight_mul_arbitrary]
  have hMatrix :
      ((1 : Matrix (Fin 4) (Fin 4) Real) + generator) * coframe =
        coframe + generator * coframe := by
    simp [Matrix.add_mul]
  rw [hMatrix, Matrix.one_mul]
  have hLine := complementaryPalatiniFaceWeight_line coframe
    (generator * coframe) first second 1
  norm_num at hLine
  rw [hLine]
  module

/-- A first connection jet: one six-component Lorentz generator coordinate
for each null-edge direction. -/
abbrev LorentzConnectionVelocity := Fin 4 -> Fiber 6

/-- Physical infinitesimal action of one Lorentz connection coordinate on
the Hodge-dual Palatini face fiber. -/
def physicalPalatiniTransportTangent (connection : Fiber 6) :
    Matrix (Fin 6) (Fin 6) Real :=
  palatiniBivectorTransportFirstVariation (lorentzGenerator connection)

/-- Explicit matrix of the infinitesimal Palatini-face representation in the
ordered rotation-then-boost basis.  Displaying this matrix makes the physical
connection convention and every sign in the Krein audit reviewable. -/
def explicitPhysicalPalatiniTransportTangent (connection : Fiber 6) :
    Matrix (Fin 6) (Fin 6) Real :=
  !![0, -connection 2, connection 1, connection 4, -connection 3, 0;
     connection 2, 0, -connection 0, connection 5, 0, -connection 3;
     -connection 1, connection 0, 0, 0, connection 5, -connection 4;
     connection 4, connection 5, 0, 0, -connection 0, -connection 1;
     -connection 3, 0, connection 5, connection 0, 0, -connection 2;
     0, -connection 3, -connection 4, connection 1, connection 2, 0]

/-- The first variation of the exterior-square transport at a physical
Lorentz generator is the displayed six-dimensional generator. -/
theorem wedgeTwoTransportFirstVariation_lorentzGenerator
    (connection : Fiber 6) :
    wedgeTwoTransportFirstVariation (lorentzGenerator connection) =
      explicitPhysicalPalatiniTransportTangent connection := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp +decide [wedgeTwoTransportFirstVariation,
      explicitPhysicalPalatiniTransportTangent, lorentzGenerator,
      bivectorMatrix, wedgeTwoTransport,
      bivectorFirst, bivectorSecond, MinkowskiConvention.eta]

set_option maxHeartbeats 1000000 in
/-- The displayed six-dimensional Lorentz generator commutes with the
Lorentzian Hodge star. -/
theorem lorentzHodgeStar_mul_explicitPhysicalPalatiniTransportTangent
    (connection : Fiber 6) :
    lorentzHodgeStar * explicitPhysicalPalatiniTransportTangent connection =
      explicitPhysicalPalatiniTransportTangent connection * lorentzHodgeStar := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp +decide [explicitPhysicalPalatiniTransportTangent,
      lorentzHodgeStar]

/-- The transport tangent obtained by polarizing the quadratic Hodge/exterior
square construction is exactly the displayed Lorentz-algebra matrix. -/
theorem physicalPalatiniTransportTangent_eq_explicit
    (connection : Fiber 6) :
    physicalPalatiniTransportTangent connection =
      explicitPhysicalPalatiniTransportTangent connection := by
  unfold physicalPalatiniTransportTangent
  rw [palatiniBivectorTransportFirstVariation_eq_hodgeConjugate,
    wedgeTwoTransportFirstVariation_lorentzGenerator]
  rw [lorentzHodgeStar_mul_explicitPhysicalPalatiniTransportTangent,
    Matrix.mul_assoc, lorentzHodgeStar_sq]
  simp

/-- The physical Palatini transport tangent is skew for the derived Krein
metric.  This pins the minus sign in the backward adjoint connection term. -/
theorem physicalPalatiniTransportTangent_kreinSkew
    (connection : Fiber 6) :
    lorentzBivectorFundamentalSymmetry.matrix *
        (physicalPalatiniTransportTangent connection).transpose *
          lorentzBivectorFundamentalSymmetry.matrix =
      -physicalPalatiniTransportTangent connection := by
  rw [lorentzBivectorFundamentalSymmetry_matrix,
    physicalPalatiniTransportTangent_eq_explicit]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp +decide [explicitPhysicalPalatiniTransportTangent,
      splitSixMatrix, splitSixSign, Matrix.mul_apply,
      Matrix.transpose_apply, Fin.sum_univ_six]

/-- The Krein adjoint of an affine physical transport has the opposite
infinitesimal generator. -/
theorem kreinAdjointApply_one_add_physicalTangent
    (connection : Fiber 6) (spacing : Real) (field : Fiber 6) :
    kreinAdjointApply lorentzBivectorFundamentalSymmetry
        (1 + spacing • physicalPalatiniTransportTangent connection) field =
      field - spacing •
        transportApply (physicalPalatiniTransportTangent connection) field := by
  have hMatrix :
      lorentzBivectorFundamentalSymmetry.matrix *
          (1 + spacing • physicalPalatiniTransportTangent connection).transpose *
            lorentzBivectorFundamentalSymmetry.matrix =
        1 - spacing • physicalPalatiniTransportTangent connection := by
    rw [Matrix.transpose_add, Matrix.transpose_one, Matrix.transpose_smul]
    simp only [Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul,
      Matrix.mul_smul]
    rw [show lorentzBivectorFundamentalSymmetry.matrix *
          (1 : Matrix (Fin 6) (Fin 6) Real) *
            lorentzBivectorFundamentalSymmetry.matrix = 1 by
      simp only [Matrix.mul_one]
      rw [lorentzBivectorFundamentalSymmetry_matrix,
        splitSixMatrix_mul_self]]
    rw [physicalPalatiniTransportTangent_kreinSkew]
    module
  unfold kreinAdjointApply
  rw [transportApply_eq_mulVec, transportAdjointApply_eq_transpose_mulVec,
    transportApply_eq_mulVec]
  simp only [Matrix.mulVec_mulVec]
  rw [<- Matrix.mul_assoc]
  rw [hMatrix, Matrix.sub_mulVec, Matrix.one_mulVec, Matrix.smul_mulVec]
  rfl

/-! ## Connection-dependent linear residual and torsion -/

/-- Coframe first jet after subtracting the infinitesimal forward Lorentz
transport.  With predecessor increments this is minus the usual covariant
coframe derivative. -/
def covariantCoframeVelocity
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    CoframeVelocity :=
  fun direction =>
    velocity direction - lorentzGenerator (connection direction) * coframe

/-- Cartan torsion including the first-order Lorentz connection term. -/
def linearizedCovariantCartanTorsion
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (internal first second : Fin 4) : Real :=
  linearizedCartanTorsion
    (covariantCoframeVelocity coframe connection velocity)
      internal first second

/-- Every component of the connection-dependent linearized Cartan torsion
vanishes. -/
def LinearizedCovariantTorsionFree
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity)
    (velocity : CoframeVelocity) : Prop :=
  forall internal first second,
    linearizedCovariantCartanTorsion coframe connection velocity
      internal first second = 0

/-- Explicit component shape of `de + omega wedge e`, with the overall sign
fixed by predecessor rather than forward coframe increments. -/
theorem linearizedCovariantCartanTorsion_eq
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (internal first second : Fin 4) :
    linearizedCovariantCartanTorsion coframe connection velocity
        internal first second =
      velocity first internal second - velocity second internal first -
        (lorentzGenerator (connection first) * coframe) internal second +
          (lorentzGenerator (connection second) * coframe) internal first := by
  unfold linearizedCovariantCartanTorsion covariantCoframeVelocity
    linearizedCartanTorsion
  simp only [Matrix.sub_apply]
  ring

/-- Linear coefficient of the affine Krein-backward Palatini residual. -/
def linearizedAffineCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeightFirstVariation coframe
          (velocity backwardDirection) direction backwardDirection component -
        transportApply
          (physicalPalatiniTransportTangent (connection backwardDirection))
          (complementaryPalatiniFaceWeight coframe direction backwardDirection)
          component)

/-- The connection term combines with the coframe first jet into the ordinary
Palatini residual of the covariant coframe velocity. -/
theorem linearizedAffineCovariantPalatiniResidual_eq
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) :
    linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction =
      linearizedPalatiniConnectionResidual coframe
        (covariantCoframeVelocity coframe connection velocity) direction := by
  funext component
  unfold linearizedAffineCovariantPalatiniResidual
    linearizedPalatiniConnectionResidual covariantCoframeVelocity
  apply Finset.sum_congr rfl
  intro backwardDirection _
  unfold physicalPalatiniTransportTangent
  rw [transportApply_palatiniBivectorTransportFirstVariation]
  rw [show velocity backwardDirection -
          lorentzGenerator (connection backwardDirection) * coframe =
        velocity backwardDirection +
          (-1 : Real) •
            (lorentzGenerator (connection backwardDirection) * coframe) by
      module]
  rw [complementaryPalatiniFaceWeightFirstVariation_add,
    complementaryPalatiniFaceWeightFirstVariation_smul]
  simp
  ring

/-- **Affine connection-dependent Palatini equation equals zero torsion.**
At every coframe with a supplied inverse, all twenty-four first-order
Krein-backward connection coefficients vanish exactly when
`de + omega wedge e` vanishes. -/
theorem linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    (forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0) <->
      LinearizedCovariantTorsionFree coframe connection velocity := by
  rw [show LinearizedCovariantTorsionFree coframe connection velocity =
      LinearizedTorsionFree
        (covariantCoframeVelocity coframe connection velocity) by rfl]
  simp_rw [linearizedAffineCovariantPalatiniResidual_eq]
  exact linearizedPalatiniConnectionResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft
      (covariantCoframeVelocity coframe connection velocity)

/-! ## Exact affine finite-spacing residual -/

/-- Quadratic coefficient in the affine-link finite residual.  Its second
term is the mixed action of the connection tangent on the polarized coframe
face. -/
def quadraticAffineCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeight (velocity backwardDirection)
          direction backwardDirection component -
        transportApply
          (physicalPalatiniTransportTangent (connection backwardDirection))
          (complementaryPalatiniFaceWeightFirstVariation coframe
            (velocity backwardDirection) direction backwardDirection)
          component)

/-- Cubic coefficient in the affine-link finite residual.  This is the
connection tangent acting on the face quadratic in the coframe jet. -/
def cubicAffineCovariantPalatiniResidual
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      transportApply
        (physicalPalatiniTransportTangent (connection backwardDirection))
        (complementaryPalatiniFaceWeight (velocity backwardDirection)
          direction backwardDirection) component)

/-- Exact local backward Palatini residual for affine physical link transport
`1 + h A(omega_b)` and predecessor coframe `e + h V_b`. -/
def finiteAffineCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Real) (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      kreinAdjointApply lorentzBivectorFundamentalSymmetry
          (1 + spacing • physicalPalatiniTransportTangent
            (connection backwardDirection))
          (complementaryPalatiniFaceWeight
            (coframe + spacing • velocity backwardDirection)
            direction backwardDirection) component -
        complementaryPalatiniFaceWeight coframe direction backwardDirection
          component)

/-- One transported predecessor face has an exact cubic expansion. -/
theorem affineTransportedComplementaryFace_scaled
    (coframe velocity : Matrix (Fin 4) (Fin 4) Real)
    (connection : Fiber 6) (spacing : Real) (first second : Fin 4) :
    kreinAdjointApply lorentzBivectorFundamentalSymmetry
          (1 + spacing • physicalPalatiniTransportTangent connection)
          (complementaryPalatiniFaceWeight
            (coframe + spacing • velocity) first second) -
        complementaryPalatiniFaceWeight coframe first second =
      spacing •
          (complementaryPalatiniFaceWeightFirstVariation coframe velocity
              first second -
            transportApply (physicalPalatiniTransportTangent connection)
              (complementaryPalatiniFaceWeight coframe first second)) +
        spacing ^ 2 •
          (complementaryPalatiniFaceWeight velocity first second -
            transportApply (physicalPalatiniTransportTangent connection)
              (complementaryPalatiniFaceWeightFirstVariation coframe velocity
                first second)) -
        spacing ^ 3 •
          transportApply (physicalPalatiniTransportTangent connection)
            (complementaryPalatiniFaceWeight velocity first second) := by
  rw [kreinAdjointApply_one_add_physicalTangent,
    complementaryPalatiniFaceWeight_line]
  rw [transportApply_add_local, transportApply_add_local,
    transportApply_smul_local, transportApply_smul_local]
  funext component
  simp only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  ring

/-- Exact affine lattice product rule.  Simultaneously varying the quadratic
coframe face and the affine link produces linear, quadratic, and cubic
spacing coefficients and no higher terms. -/
theorem finiteAffineCovariantPalatiniResidual_scaled
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Real) (direction : Fin 4) :
    finiteAffineCovariantPalatiniResidual coframe connection velocity spacing
        direction =
      spacing • linearizedAffineCovariantPalatiniResidual coframe connection
          velocity direction +
        spacing ^ 2 • quadraticAffineCovariantPalatiniResidual coframe
          connection velocity direction -
        spacing ^ 3 • cubicAffineCovariantPalatiniResidual connection velocity
          direction := by
  funext component
  unfold finiteAffineCovariantPalatiniResidual
    linearizedAffineCovariantPalatiniResidual
    quadraticAffineCovariantPalatiniResidual
    cubicAffineCovariantPalatiniResidual
  have hTerm (backwardDirection : Fin 4) :
      kreinAdjointApply lorentzBivectorFundamentalSymmetry
            (1 + spacing • physicalPalatiniTransportTangent
              (connection backwardDirection))
            (complementaryPalatiniFaceWeight
              (coframe + spacing • velocity backwardDirection)
              direction backwardDirection) component -
          complementaryPalatiniFaceWeight coframe direction backwardDirection
            component =
        spacing *
            (complementaryPalatiniFaceWeightFirstVariation coframe
                (velocity backwardDirection) direction backwardDirection
                  component -
              transportApply
                (physicalPalatiniTransportTangent
                  (connection backwardDirection))
                (complementaryPalatiniFaceWeight coframe direction
                  backwardDirection) component) +
          spacing ^ 2 *
            (complementaryPalatiniFaceWeight (velocity backwardDirection)
                direction backwardDirection component -
              transportApply
                (physicalPalatiniTransportTangent
                  (connection backwardDirection))
                (complementaryPalatiniFaceWeightFirstVariation coframe
                  (velocity backwardDirection) direction backwardDirection)
                component) -
          spacing ^ 3 *
            transportApply
              (physicalPalatiniTransportTangent
                (connection backwardDirection))
              (complementaryPalatiniFaceWeight (velocity backwardDirection)
                direction backwardDirection) component := by
    have hFace := congrFun
      (affineTransportedComplementaryFace_scaled coframe
      (velocity backwardDirection) (connection backwardDirection) spacing
        direction backwardDirection) component
    simpa only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
      using hFace
  simp_rw [hTerm]
  simp only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib]
  simp_rw [<- Finset.mul_sum]
  simp only [Finset.sum_sub_distrib]

/-- Exact affine residuals vanishing along nonzero spacings tending to zero
force the connection-dependent linear coefficient to vanish. -/
theorem finiteAffineCovariantPalatiniResidual_scaled_limit
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Nat -> Real) (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finiteAffineCovariantPalatiniResidual coframe connection velocity
        (spacing n) direction component = 0) :
    forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0 := by
  intro direction component
  let linear := linearizedAffineCovariantPalatiniResidual coframe connection
    velocity direction component
  let quadratic := quadraticAffineCovariantPalatiniResidual coframe connection
    velocity direction component
  let cubic := cubicAffineCovariantPalatiniResidual connection velocity
    direction component
  have hFactor (n : Nat) :
      linear + spacing n * quadratic - spacing n ^ 2 * cubic = 0 := by
    have h := hResidual n direction component
    rw [finiteAffineCovariantPalatiniResidual_scaled] at h
    change spacing n * linear + spacing n ^ 2 * quadratic -
      spacing n ^ 3 * cubic = 0 at h
    have hProduct :
        spacing n *
            (linear + spacing n * quadratic - spacing n ^ 2 * cubic) = 0 := by
      calc
        spacing n *
            (linear + spacing n * quadratic - spacing n ^ 2 * cubic) =
          spacing n * linear + spacing n ^ 2 * quadratic -
            spacing n ^ 3 * cubic := by ring
        _ = 0 := h
    exact (mul_eq_zero.mp hProduct).resolve_left (hNonzero n)
  have hLimit :
      Tendsto
        (fun n => linear + spacing n * quadratic - spacing n ^ 2 * cubic)
        atTop (nhds linear) := by
    simpa [pow_two] using
      (tendsto_const_nhds.add (hToZero.mul tendsto_const_nhds)).sub
        ((hToZero.mul hToZero).mul tendsto_const_nhds)
  have hZero :
      Tendsto
        (fun n => linear + spacing n * quadratic - spacing n ^ 2 * cubic)
        atTop (nhds 0) := by
    convert tendsto_const_nhds using 1
    funext n
    exact hFactor n
  exact tendsto_nhds_unique hLimit hZero

/-- **Affine connection-dependent shrinking-spacing endpoint.**  At a fixed
invertible coframe, exact affine local connection equations along nonzero
shrinking spacings force `de + omega wedge e = 0` for the fixed first jet. -/
theorem finiteAffineCovariantPalatiniResidual_invertible_limit_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Nat -> Real) (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finiteAffineCovariantPalatiniResidual coframe connection velocity
        (spacing n) direction component = 0) :
    LinearizedCovariantTorsionFree coframe connection velocity := by
  rw [<- linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft connection velocity]
  exact finiteAffineCovariantPalatiniResidual_scaled_limit coframe connection
    velocity spacing hNonzero hToZero hResidual

/-! ## Explicit nonvacuity family -/

/-- A coframe jet generated entirely by the supplied Lorentz connection has
zero covariant coframe velocity. -/
theorem covariantCoframeVelocity_connectionGenerated
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) :
    covariantCoframeVelocity coframe connection
        (fun direction => lorentzGenerator (connection direction) * coframe) =
      0 := by
  funext direction
  simp [covariantCoframeVelocity]

/-- The connection-generated jet is an explicit family satisfying all
connection-dependent Cartan torsion equations. -/
theorem connectionGeneratedVelocity_covariantTorsionFree
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) :
    LinearizedCovariantTorsionFree coframe connection
      (fun direction => lorentzGenerator (connection direction) * coframe) := by
  rw [show LinearizedCovariantTorsionFree coframe connection
        (fun direction => lorentzGenerator (connection direction) * coframe) =
      LinearizedTorsionFree
        (covariantCoframeVelocity coframe connection
          (fun direction =>
            lorentzGenerator (connection direction) * coframe)) by rfl]
  rw [covariantCoframeVelocity_connectionGenerated]
  intro internal first second
  simp [linearizedCartanTorsion]

/-- At every supplied invertible coframe, the connection-generated jet gives
an explicit solution of all twenty-four affine linearized Palatini equations.
-/
theorem connectionGeneratedVelocity_affineResidual_zero
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) :
    forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection
        (fun backwardDirection =>
          lorentzGenerator (connection backwardDirection) * coframe)
        direction component = 0 := by
  rw [linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft]
  exact connectionGeneratedVelocity_covariantTorsionFree coframe connection

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.physicalPalatiniTransportTangent_kreinSkew' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physicalPalatiniTransportTangent_kreinSkew

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.finiteAffineCovariantPalatiniResidual_scaled' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteAffineCovariantPalatiniResidual_scaled

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.finiteAffineCovariantPalatiniResidual_invertible_limit_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteAffineCovariantPalatiniResidual_invertible_limit_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.connectionGeneratedVelocity_affineResidual_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionGeneratedVelocity_affineResidual_zero

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
