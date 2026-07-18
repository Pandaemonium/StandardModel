import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift

noncomputable section

/-!
# Conformal-coframe no-go for the periodic vacuum null wave

The exact proper-Lorentz null wave satisfies the finite vacuum Einstein sector
at the identity coframe but fails the independent connection equation.  This
module tests the smallest varying-coframe escape: each of the two sites may
rescale the identity coframe independently.

The complete connection system has no nondegenerate solution in
this ansatz at nonzero plaquette area.  Two explicit coefficients suffice:
one forces the two squared scales to agree, while a transverse coefficient
then forces area times the squared scale at site `1` to vanish.  The result is
a finite no-go for sitewise conformal variation, not a no-go for general
anisotropic or Lorentz-rotated coframes.

The coefficient formulas are proved directly from the nonlinear Palatini
Euler definitions.  `Scripts/oracle/null_wave_conformal_euler.py` provides an
independent exact symbolic audit of all 48 coefficients but is not trusted
proof.  Claim labels: finite identity and finite no-go.  Originality tag:
`[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveConformalNoGo

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

/-- Independent scalar rescaling of the identity coframe at each null-wave
site. -/
def nullWaveConformalCoframe
    (scale : NullWaveSite -> Real) : CoframeField NullWaveSite :=
  fun site => scale site • (1 : Matrix (Fin 4) (Fin 4) Real)

/-- Pointwise inverse candidate for a nonzero conformal coframe. -/
def nullWaveConformalInverseCoframe
    (scale : NullWaveSite -> Real) : CoframeField NullWaveSite :=
  fun site => (scale site)⁻¹ • (1 : Matrix (Fin 4) (Fin 4) Real)

/-- The displayed inverse candidate is a left inverse whenever both site
scales are nonzero. -/
theorem nullWaveConformalInverseCoframe_mul
    (scale : NullWaveSite -> Real)
    (hScale : forall site, Not (scale site = 0)) :
    forall site,
      nullWaveConformalInverseCoframe scale site *
          nullWaveConformalCoframe scale site = 1 := by
  intro site
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nullWaveConformalInverseCoframe, nullWaveConformalCoframe,
      Matrix.mul_apply, Fin.sum_univ_four, hScale site]

/-- Rescaling the inverse identity coframe rescales every mixed Einstein
entry quadratically. -/
theorem mixedVacuumEinsteinEntry_smul_one
    (factor : Real) (curvature : LocalCurvature)
    (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (factor • (1 : Matrix (Fin 4) (Fin 4) Real)) curvature
        coframeDirection raisedDirection =
      factor ^ 2 * mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real) curvature
        coframeDirection raisedDirection := by
  unfold mixedVacuumEinsteinEntry mixedRicciCurvature
    inverseCoframeScalarCurvature
  simp [Matrix.smul_apply, Matrix.one_apply, Fin.sum_univ_four]
  split_ifs <;> ring

/-- Every invertible two-site conformal coframe still sees the exact
proper-Lorentz null wave as a finite mixed vacuum Einstein field. -/
theorem nullWaveConformal_mixedVacuum
    (area : Nat -> Real) (n : Nat) (scale : NullWaveSite -> Real)
    (site : NullWaveSite) (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (nullWaveConformalInverseCoframe scale site)
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
      (nullWaveConformalInverseCoframe scale site)
      coframeDirection raisedDirection
      (area n • nullWaveCurvature site) = 0
  rw [map_smul]
  change area n * mixedVacuumEinsteinEntry
      ((scale site)⁻¹ • (1 : Matrix (Fin 4) (Fin 4) Real))
      (nullWaveCurvature site) coframeDirection raisedDirection = 0
  rw [mixedVacuumEinsteinEntry_smul_one,
    nullWaveCurvature_mixedVacuum]
  ring

/-- Every pointwise nonzero conformal coframe is exactly stationary in the
finite coframe/Einstein sector. -/
theorem nullWaveConformal_coframeStationary
    (area : Nat -> Real) (n : Nat) (scale : NullWaveSite -> Real)
    (hScale : forall site, Not (scale site = 0)) :
    NonlinearCoframePlaquetteCoframeStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveConformalCoframe scale) := by
  apply (nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
    nullWaveShift (nullWaveLorentzConnection area n)
    (nullWaveConformalCoframe scale)
    (nullWaveConformalInverseCoframe scale)
    (nullWaveConformalInverseCoframe_mul scale hScale)).2
  intro site coframeDirection raisedDirection
  change mixedVacuumEinsteinEntry
      (nullWaveConformalInverseCoframe scale site)
      (extractedPlaquetteCurvature nullWaveShift
        (nullWaveLorentzConnection area n) site)
      coframeDirection raisedDirection = 0
  exact nullWaveConformal_mixedVacuum area n scale site
    coframeDirection raisedDirection

set_option maxHeartbeats 5000000 in
/-- A longitudinal link equation measures only the difference of the two
squared conformal scales. -/
theorem nullWaveConformal_linkEulerCoefficient_zero_five
    (area : Nat -> Real) (n : Nat) (scale : NullWaveSite -> Real) :
    nonlinearLinkEulerCoefficient nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveConformalCoframe scale) 0 0 5 =
      -2 * (scale 0 ^ 2 - scale 1 ^ 2) := by
  simp only [nonlinearLinkEulerCoefficient,
    nonlinearLinkEulerFunctional, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    twoStepUnit, twoStepTransport, unitMatrix_mul, mul_inv_rev]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit,
    unitMatrix_inv_nullWavePlaquetteUnit]
  simp +decide [nullWaveConformalCoframe, coframeFaceWeight,
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
    Matrix.smul_apply, Fin.sum_univ_four,
    Fin.sum_univ_six, Finset.sum_range_succ, pow_succ]
  norm_num
  ring

set_option maxHeartbeats 5000000 in
/-- After transport around the wave, one transverse link equation also sees
the area-weighted squared scale at site `1`. -/
theorem nullWaveConformal_linkEulerCoefficient_one_one
    (area : Nat -> Real) (n : Nat) (scale : NullWaveSite -> Real) :
    nonlinearLinkEulerCoefficient nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveConformalCoframe scale) 1 1 1 =
      -2 * (area n * scale 1 ^ 2 - scale 0 ^ 2 + scale 1 ^ 2) := by
  simp only [nonlinearLinkEulerCoefficient,
    nonlinearLinkEulerFunctional, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    twoStepUnit, twoStepTransport, unitMatrix_mul, mul_inv_rev]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit,
    unitMatrix_inv_nullWavePlaquetteUnit]
  simp +decide [nullWaveConformalCoframe, coframeFaceWeight,
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
    Matrix.smul_apply, Fin.sum_univ_four, Fin.sum_univ_six,
    Finset.sum_range_succ, pow_succ]
  norm_num
  ring

/-- Connection stationarity within the two-site conformal ansatz forces the
area-weighted squared scale at site `1` to vanish. -/
theorem nullWaveConformal_connectionStationary_imp_area_mul_scale_sq_zero
    (area : Nat -> Real) (n : Nat) (scale : NullWaveSite -> Real)
    (hStationary : NonlinearCoframePlaquetteConnectionStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveConformalCoframe scale)) :
    area n * scale 1 ^ 2 = 0 := by
  have hCoefficients :=
    (nonlinearCoframePlaquetteConnectionStationary_iff_coefficients
      nullWaveShift (nullWaveLorentzConnection area n)
      (nullWaveConformalCoframe scale)).1 hStationary
  have hLongitudinal := hCoefficients 0 0 5
  have hTransverse := hCoefficients 1 1 1
  rw [nullWaveConformal_linkEulerCoefficient_zero_five] at hLongitudinal
  rw [nullWaveConformal_linkEulerCoefficient_one_one] at hTransverse
  nlinarith

/-- At nonzero area, every connection-stationary conformal coframe is
degenerate at site `1`. -/
theorem nullWaveConformal_not_connectionStationary
    (area : Nat -> Real) (n : Nat) (scale : NullWaveSite -> Real)
    (hArea : Not (area n = 0)) (hScale : Not (scale 1 = 0)) :
    Not (NonlinearCoframePlaquetteConnectionStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveConformalCoframe scale)) := by
  intro hStationary
  have hZero :=
    nullWaveConformal_connectionStationary_imp_area_mul_scale_sq_zero
      area n scale hStationary
  exact (mul_ne_zero hArea (pow_ne_zero 2 hScale)) hZero

/-- The same nondegenerate conformal ansatz cannot be jointly stationary at
nonzero area. -/
theorem nullWaveConformal_not_jointStationary
    (area : Nat -> Real) (n : Nat) (scale : NullWaveSite -> Real)
    (hArea : Not (area n = 0)) (hScale : Not (scale 1 = 0)) :
    Not (NonlinearCoframePlaquetteJointStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveConformalCoframe scale)) := by
  intro hJoint
  exact (nullWaveConformal_not_connectionStationary
    area n scale hArea hScale) hJoint.1

/-- The nondegenerate conformal family remains exactly coframe-stationary but
cannot satisfy the connection or joint equation at nonzero area. -/
theorem nullWaveConformal_sectorSplit
    (area : Nat -> Real) (n : Nat) (scale : NullWaveSite -> Real)
    (hArea : Not (area n = 0))
    (hScale : forall site, Not (scale site = 0)) :
    NonlinearCoframePlaquetteCoframeStationary nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveConformalCoframe scale) /\
      Not (NonlinearCoframePlaquetteConnectionStationary nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveConformalCoframe scale)) := by
  exact And.intro
    (nullWaveConformal_coframeStationary area n scale hScale)
    (nullWaveConformal_not_connectionStationary
      area n scale hArea (hScale 1))

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveConformalNoGo.nullWaveConformal_linkEulerCoefficient_zero_five' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveConformal_linkEulerCoefficient_zero_five

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveConformalNoGo.nullWaveConformal_linkEulerCoefficient_one_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveConformal_linkEulerCoefficient_one_one

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveConformalNoGo.nullWaveConformal_coframeStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveConformal_coframeStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveConformalNoGo.nullWaveConformal_sectorSplit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveConformal_sectorSplit

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveConformalNoGo
