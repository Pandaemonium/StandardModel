import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveConformalNoGo

noncomputable section

/-!
# Axial-coframe no-go for the periodic vacuum null wave

The diagonal mixed vacuum Einstein equations for the two-site null wave select
the axial tetrad shape `diag(A,B,B,A)`: equal scales on the time/longitudinal
pair and on the two transverse directions.  This module studies that complete
four-parameter Einstein-compatible diagonal family.

Every pointwise nondegenerate axial coframe is exactly stationary in the
finite coframe/Einstein sector.  It nevertheless cannot satisfy the
independent connection equation at nonzero area.  Two transverse link
coefficients first compare the sitewise products `A*B` and then leave the
uncancelled condition `area * A(1)^2 = 0`.

This is a finite no-go for Einstein-compatible diagonal variation, not for a
general coframe with off-diagonal shear or local Lorentz rotation.
`Scripts/oracle/null_wave_diagonal_euler.py` independently audits all link and
Einstein components but is not trusted proof.  Claim labels: finite identity
and finite no-go.  Originality tag: `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveAxialNoGo

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-- Sitewise axial coframe preserving the null longitudinal plane and equal
transverse scales. -/
def nullWaveAxialCoframe
    (longitudinal transverse : NullWaveSite -> Real) :
    CoframeField NullWaveSite :=
  fun site =>
    !![longitudinal site, 0, 0, 0;
       0, transverse site, 0, 0;
       0, 0, transverse site, 0;
       0, 0, 0, longitudinal site]

/-- Pointwise inverse candidate for a nondegenerate axial coframe. -/
def nullWaveAxialInverseCoframe
    (longitudinal transverse : NullWaveSite -> Real) :
    CoframeField NullWaveSite :=
  fun site =>
    !![(longitudinal site)⁻¹, 0, 0, 0;
       0, (transverse site)⁻¹, 0, 0;
       0, 0, (transverse site)⁻¹, 0;
       0, 0, 0, (longitudinal site)⁻¹]

/-- The inverse candidate is exact when both axial scales are pointwise
nonzero. -/
theorem nullWaveAxialInverseCoframe_mul
    (longitudinal transverse : NullWaveSite -> Real)
    (hLongitudinal : forall site, Not (longitudinal site = 0))
    (hTransverse : forall site, Not (transverse site = 0)) :
    forall site,
      nullWaveAxialInverseCoframe longitudinal transverse site *
          nullWaveAxialCoframe longitudinal transverse site = 1 := by
  intro site
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nullWaveAxialInverseCoframe, nullWaveAxialCoframe,
      Matrix.mul_apply, Fin.sum_univ_four, hLongitudinal site,
      hTransverse site]

set_option maxHeartbeats 5000000 in
/-- The plus-polarized null-wave curvature is mixed vacuum Einstein for every
axial inverse coframe. -/
theorem nullWaveCurvature_axial_mixedVacuum
    (longitudinal transverse : NullWaveSite -> Real)
    (site : NullWaveSite) (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (nullWaveAxialInverseCoframe longitudinal transverse site)
        (nullWaveCurvature site) coframeDirection raisedDirection = 0 := by
  fin_cases site <;> fin_cases coframeDirection <;>
    fin_cases raisedDirection <;>
    simp +decide [mixedVacuumEinsteinEntry, mixedRicciCurvature,
      inverseCoframeScalarCurvature, nullWaveAxialInverseCoframe,
      nullWaveCurvature, nullWaveAmplitude, nullWaveFaceOne,
      nullWaveFaceTwo, nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo, bivectorMatrix,
      Fin.sum_univ_four]

/-- Every finite extracted proper-Lorentz null-wave curvature is mixed vacuum
Einstein for the axial inverse coframe. -/
theorem nullWaveAxial_mixedVacuum
    (area : Nat -> Real) (n : Nat)
    (longitudinal transverse : NullWaveSite -> Real)
    (site : NullWaveSite) (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (nullWaveAxialInverseCoframe longitudinal transverse site)
        (extractedPlaquetteCurvature nullWaveShift
          (nullWaveLorentzConnection area n) site)
        coframeDirection raisedDirection = 0 := by
  rw [show extractedPlaquetteCurvature nullWaveShift
      (nullWaveLorentzConnection area n) site =
        area n • nullWaveCurvature site by
    funext a b component
    exact congrFun
      (extractedPlaquetteCurvature_nullWaveLorentzConnection
        area n site a b) component]
  change mixedVacuumEinsteinEntryLinear
      (nullWaveAxialInverseCoframe longitudinal transverse site)
      coframeDirection raisedDirection
      (area n • nullWaveCurvature site) = 0
  rw [map_smul]
  change area n * mixedVacuumEinsteinEntry
      (nullWaveAxialInverseCoframe longitudinal transverse site)
      (nullWaveCurvature site) coframeDirection raisedDirection = 0
  rw [nullWaveCurvature_axial_mixedVacuum]
  ring

/-- Every pointwise nondegenerate axial coframe is exactly stationary in the
finite coframe/Einstein sector. -/
theorem nullWaveAxial_coframeStationary
    (area : Nat -> Real) (n : Nat)
    (longitudinal transverse : NullWaveSite -> Real)
    (hLongitudinal : forall site, Not (longitudinal site = 0))
    (hTransverse : forall site, Not (transverse site = 0)) :
    NonlinearCoframePlaquetteCoframeStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveAxialCoframe longitudinal transverse) := by
  apply (nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
    nullWaveShift (nullWaveLorentzConnection area n)
    (nullWaveAxialCoframe longitudinal transverse)
    (nullWaveAxialInverseCoframe longitudinal transverse)
    (nullWaveAxialInverseCoframe_mul longitudinal transverse
      hLongitudinal hTransverse)).2
  intro site coframeDirection raisedDirection
  change mixedVacuumEinsteinEntry
      (nullWaveAxialInverseCoframe longitudinal transverse site)
      (extractedPlaquetteCurvature nullWaveShift
        (nullWaveLorentzConnection area n) site)
      coframeDirection raisedDirection = 0
  exact nullWaveAxial_mixedVacuum area n longitudinal transverse site
    coframeDirection raisedDirection

set_option maxHeartbeats 5000000 in
/-- The first transverse equation at site `0` compares the two sitewise axial
area products. -/
theorem nullWaveAxial_linkEulerCoefficient_zero_one
    (area : Nat -> Real) (n : Nat)
    (longitudinal transverse : NullWaveSite -> Real) :
    nonlinearLinkEulerCoefficient nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveAxialCoframe longitudinal transverse) 0 1 1 =
      2 * (longitudinal 1 * transverse 1 -
        longitudinal 0 * transverse 0) := by
  simp only [nonlinearLinkEulerCoefficient,
    nonlinearLinkEulerFunctional, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    twoStepUnit, twoStepTransport, unitMatrix_mul, mul_inv_rev]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit,
    unitMatrix_inv_nullWavePlaquetteUnit]
  simp +decide [nullWaveAxialCoframe, coframeFaceWeight,
    complementaryPalatiniFaceWeight, palatiniFaceWeight, coframeWedge,
    spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
    lorentzGenerator, bivectorMatrix, nullWaveShift, toggleFinTwo,
    nullWaveLinkCoefficientOne, nullWaveLinkCoefficientTwo,
    nullWaveAmplitude, nullWaveFaceOne, nullWaveFaceTwo,
    nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, nullWavePlaneExponentialMatrix,
    LorentzBivectorKreinBridge.bivectorFirst,
    LorentzBivectorKreinBridge.bivectorSecond,
    MinkowskiConvention.eta, Matrix.trace, Matrix.diag,
    Matrix.mul_apply, Matrix.of_apply, Matrix.one_apply,
    Fin.sum_univ_four, Fin.sum_univ_six,
    Finset.sum_range_succ, pow_succ]
  norm_num
  ring

set_option maxHeartbeats 5000000 in
/-- The matching transverse equation at site `1` contains the uncancelled
null-wave area term. -/
theorem nullWaveAxial_linkEulerCoefficient_one_one
    (area : Nat -> Real) (n : Nat)
    (longitudinal transverse : NullWaveSite -> Real) :
    nonlinearLinkEulerCoefficient nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveAxialCoframe longitudinal transverse) 1 1 1 =
      2 * (longitudinal 0 * transverse 0 -
        longitudinal 1 * transverse 1 -
        area n * longitudinal 1 ^ 2) := by
  simp only [nonlinearLinkEulerCoefficient,
    nonlinearLinkEulerFunctional, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    twoStepUnit, twoStepTransport, unitMatrix_mul, mul_inv_rev]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit,
    unitMatrix_inv_nullWavePlaquetteUnit]
  simp +decide [nullWaveAxialCoframe, coframeFaceWeight,
    complementaryPalatiniFaceWeight, palatiniFaceWeight, coframeWedge,
    spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
    lorentzGenerator, bivectorMatrix, nullWaveShift, toggleFinTwo,
    nullWaveLinkCoefficientOne, nullWaveLinkCoefficientTwo,
    nullWaveAmplitude, nullWaveFaceOne, nullWaveFaceTwo,
    nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, nullWavePlaneExponentialMatrix,
    LorentzBivectorKreinBridge.bivectorFirst,
    LorentzBivectorKreinBridge.bivectorSecond,
    MinkowskiConvention.eta, Matrix.trace, Matrix.diag,
    Matrix.mul_apply, Matrix.of_apply, Matrix.one_apply,
    Fin.sum_univ_four, Fin.sum_univ_six,
    Finset.sum_range_succ, pow_succ]
  norm_num
  ring

/-- Connection stationarity in the axial family forces the area-weighted
squared longitudinal scale at site `1` to vanish. -/
theorem nullWaveAxial_connectionStationary_imp_area_mul_longitudinal_sq_zero
    (area : Nat -> Real) (n : Nat)
    (longitudinal transverse : NullWaveSite -> Real)
    (hStationary : NonlinearCoframePlaquetteConnectionStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveAxialCoframe longitudinal transverse)) :
    area n * longitudinal 1 ^ 2 = 0 := by
  have hCoefficients :=
    (nonlinearCoframePlaquetteConnectionStationary_iff_coefficients
      nullWaveShift (nullWaveLorentzConnection area n)
      (nullWaveAxialCoframe longitudinal transverse)).1 hStationary
  have hSiteZero := hCoefficients 0 1 1
  have hSiteOne := hCoefficients 1 1 1
  rw [nullWaveAxial_linkEulerCoefficient_zero_one] at hSiteZero
  rw [nullWaveAxial_linkEulerCoefficient_one_one] at hSiteOne
  nlinarith

/-- No axial coframe with nonzero site-`1` longitudinal scale can satisfy the
connection equation at nonzero area. -/
theorem nullWaveAxial_not_connectionStationary
    (area : Nat -> Real) (n : Nat)
    (longitudinal transverse : NullWaveSite -> Real)
    (hArea : Not (area n = 0))
    (hLongitudinal : Not (longitudinal 1 = 0)) :
    Not (NonlinearCoframePlaquetteConnectionStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveAxialCoframe longitudinal transverse)) := by
  intro hStationary
  have hZero :=
    nullWaveAxial_connectionStationary_imp_area_mul_longitudinal_sq_zero
      area n longitudinal transverse hStationary
  exact (mul_ne_zero hArea (pow_ne_zero 2 hLongitudinal)) hZero

/-- Every nondegenerate axial coframe remains coframe-stationary but fails
connection and joint stationarity at nonzero area. -/
theorem nullWaveAxial_sectorSplit
    (area : Nat -> Real) (n : Nat)
    (longitudinal transverse : NullWaveSite -> Real)
    (hArea : Not (area n = 0))
    (hLongitudinal : forall site, Not (longitudinal site = 0))
    (hTransverse : forall site, Not (transverse site = 0)) :
    NonlinearCoframePlaquetteCoframeStationary nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveAxialCoframe longitudinal transverse) /\
      Not (NonlinearCoframePlaquetteConnectionStationary nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveAxialCoframe longitudinal transverse)) /\
      Not (NonlinearCoframePlaquetteJointStationary nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveAxialCoframe longitudinal transverse)) := by
  have hNotConnection := nullWaveAxial_not_connectionStationary
    area n longitudinal transverse hArea (hLongitudinal 1)
  refine And.intro
    (nullWaveAxial_coframeStationary area n longitudinal transverse
      hLongitudinal hTransverse) (And.intro hNotConnection ?_)
  intro hJoint
  exact hNotConnection hJoint.1

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveAxialNoGo.nullWaveCurvature_axial_mixedVacuum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveCurvature_axial_mixedVacuum

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveAxialNoGo.nullWaveAxial_linkEulerCoefficient_zero_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveAxial_linkEulerCoefficient_zero_one

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveAxialNoGo.nullWaveAxial_linkEulerCoefficient_one_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveAxial_linkEulerCoefficient_one_one

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveAxialNoGo.nullWaveAxial_sectorSplit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveAxial_sectorSplit

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveAxialNoGo
