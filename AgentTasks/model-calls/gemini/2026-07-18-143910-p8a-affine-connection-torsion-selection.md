# Gemini model call log

## Metadata

- Provider: `Gemini REST API`
- Model: `gemini-3.1-pro-preview`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-18T14:38:10`
- Finished: `2026-07-18T14:39:10`
- Timeout seconds: `600`
- Max output tokens: `8192`

## Endpoint

```text
https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent
```

The API key is intentionally not logged.

## Prompt

```text
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


You are a hostile semantic reviewer of a Lean 4 formalization in a speculative null-edge Palatini gravity program. The entire source file under review appears verbatim above. It compiles under Lean 4.28.0. Intended reading: a six-component Lorentz connection velocity omega_b induces the first variation of four-vector and Hodge-dual bivector transport. The backward predecessor convention makes the covariant coframe velocity V_b - omega_b e, with V_b = -partial_b e. Therefore the 24 linearized independent-connection equations should vanish iff de + omega wedge e = 0 at any coframe with a supplied left inverse. The exact affine finite residual should equal h L + h^2 Q - h^3 C. Exact residuals at nonzero h_n tending to zero should force L = 0 and hence torsion-free. The connection-generated velocity V_b = omega_b e should be a genuine nonvacuity family.

Audit against: (1) vacuity or hidden hypotheses, (2) hollow telescoping, (3) prose outrunning the kernel, (4) false mathematical shape, (5) wrong Lorentz/Hodge/Krein sign, (6) a theorem that only repackages the torsion conclusion as a premise, (7) invalid limit reasoning, (8) an incorrect claim of nonlinear or exact group-valued link transport. Distinguish imported standard Palatini architecture from the exact finite contribution. Give findings ordered by severity with exact theorem/definition names, then a final verdict of ACCEPT, ACCEPT WITH DOC FIXES, or REJECT. Do not assume repository context not present in the source.
```

## Extracted response text

```text
An audit of the `NonlinearLorentzPalatiniAffineConnectionTorsionSelection` module has been completed against the specified criteria. The formalization is mathematically sound, elegantly structured, and correctly implements the first-order Palatini connection equations in the discrete setting.

Here is the detailed breakdown of the findings:

1. **Vacuity or hidden hypotheses**: **Clear.** The theorems correctly assume invertibility of the coframe (`inverseCoframe * coframe = 1`) where required, which is the standard non-degeneracy condition for spacetime. The module explicitly constructs a nonvacuous solution family in `connectionGeneratedVelocity_covariantTorsionFree` and `connectionGeneratedVelocity_affineResidual_zero`, proving that the torsion-free condition is satisfiable and not a vacuous implication.
2. **Hollow telescoping**: **Clear.** The expansion of the finite affine residual into linear, quadratic, and cubic terms (`h * L + h^2 * Q - h^3 * C`) in `finiteAffineCovariantPalatiniResidual_scaled` is mathematically rigorous. It correctly arises from the interaction between the quadratic nature of the Palatini face (`complementaryPalatiniFaceWeight`) and the linear affine transport `1 + h * A`. There is no hollow tautology here; it is a genuine polynomial expansion of the discrete action.
3. **Prose outrunning the kernel**: **Clear.** The documentation is exceptionally precise about the scope of the module. It explicitly disclaims full nonlinear exponential transport, continuum limits, and metric compatibility, accurately describing the contribution as an exact finite affine-tangent
```

## Raw response JSON

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "An audit of the `NonlinearLorentzPalatiniAffineConnectionTorsionSelection` module has been completed against the specified criteria. The formalization is mathematically sound, elegantly structured, and correctly implements the first-order Palatini connection equations in the discrete setting.\n\nHere is the detailed breakdown of the findings:\n\n1. **Vacuity or hidden hypotheses**: **Clear.** The theorems correctly assume invertibility of the coframe (`inverseCoframe * coframe = 1`) where required, which is the standard non-degeneracy condition for spacetime. The module explicitly constructs a nonvacuous solution family in `connectionGeneratedVelocity_covariantTorsionFree` and `connectionGeneratedVelocity_affineResidual_zero`, proving that the torsion-free condition is satisfiable and not a vacuous implication.\n2. **Hollow telescoping**: **Clear.** The expansion of the finite affine residual into linear, quadratic, and cubic terms (`h * L + h^2 * Q - h^3 * C`) in `finiteAffineCovariantPalatiniResidual_scaled` is mathematically rigorous. It correctly arises from the interaction between the quadratic nature of the Palatini face (`complementaryPalatiniFaceWeight`) and the linear affine transport `1 + h * A`. There is no hollow tautology here; it is a genuine polynomial expansion of the discrete action.\n3. **Prose outrunning the kernel**: **Clear.** The documentation is exceptionally precise about the scope of the module. It explicitly disclaims full nonlinear exponential transport, continuum limits, and metric compatibility, accurately describing the contribution as an exact finite affine-tangent",
            "thoughtSignature": "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"
          }
        ],
        "role": "model"
      },
      "finishReason": "MAX_TOKENS",
      "index": 0
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 8430,
    "candidatesTokenCount": 327,
    "totalTokenCount": 16618,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 8430
      }
    ],
    "thoughtsTokenCount": 7861,
    "serviceTier": "standard"
  },
  "modelVersion": "gemini-3.1-pro-preview",
  "responseId": "QvJbat3dMcut1MkPlImbqAg"
}
```

## Error

```text

```
