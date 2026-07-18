import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveFullNoGo

noncomputable section

/-!
# Joint-stationarity no-go for the fixed periodic vacuum null wave

This module completes the full-coframe audit begun in
`PeriodicVacuumWeylNullWaveFullNoGo`.  On the complete ten-parameter kernel of
the coframe/Einstein equation, two exact connection Euler coefficients force
an area-weighted factor of the coframe determinant to vanish.  The converse
kernel theorem then rules out every invertible coframe, including arbitrary
off-diagonal shear, for the fixed nonzero null-wave connection.

The theorem is a finite ansatz no-go.  It does not rule out simultaneous link
and coframe deformation, a larger carrier, or a different finite dual-cell
weighting.  Claim label: finite no-go.  Originality tag: `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveFullNoGo
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

set_option maxHeartbeats 5000000 in
/-- At site `0`, one transverse connection equation compares the two sitewise
products `e * (i - j)` on the complete coframe-Einstein family. -/
theorem nullWaveEinsteinCoframe_linkEulerCoefficient_zero_one
    (area : Nat -> Real) (n : Nat)
    (parameters : NullWaveEinsteinCoframeParameters) :
    nonlinearLinkEulerCoefficient nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveEinsteinCoframe parameters) 0 1 1 =
      2 * (parameters.e 0 * (parameters.i 0 - parameters.j 0) -
        parameters.e 1 * (parameters.i 1 - parameters.j 1)) := by
  simp only [nonlinearLinkEulerCoefficient,
    nonlinearLinkEulerFunctional, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    twoStepUnit, twoStepTransport, unitMatrix_mul, mul_inv_rev]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit,
    unitMatrix_inv_nullWavePlaquetteUnit]
  simp +decide [nullWaveEinsteinCoframe, coframeFaceWeight,
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
/-- At site `1`, the matching transverse equation contains the uncancelled
area times determinant-factor contribution. -/
theorem nullWaveEinsteinCoframe_linkEulerCoefficient_one_one
    (area : Nat -> Real) (n : Nat)
    (parameters : NullWaveEinsteinCoframeParameters) :
    nonlinearLinkEulerCoefficient nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveEinsteinCoframe parameters) 1 1 1 =
      2 * (area n *
          (parameters.a 1 + parameters.i 1) *
          (parameters.i 1 - parameters.j 1) -
        parameters.e 0 * (parameters.i 0 - parameters.j 0) +
        parameters.e 1 * (parameters.i 1 - parameters.j 1)) := by
  simp only [nonlinearLinkEulerCoefficient,
    nonlinearLinkEulerFunctional, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    twoStepUnit, twoStepTransport, unitMatrix_mul, mul_inv_rev]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit,
    unitMatrix_inv_nullWavePlaquetteUnit]
  simp +decide [nullWaveEinsteinCoframe, coframeFaceWeight,
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

/-- Connection stationarity on the complete coframe-Einstein family forces
the area-weighted longitudinal determinant factor to vanish. -/
theorem nullWaveEinsteinCoframe_connectionStationary_imp_factor_zero
    (area : Nat -> Real) (n : Nat)
    (parameters : NullWaveEinsteinCoframeParameters)
    (hStationary : NonlinearCoframePlaquetteConnectionStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveEinsteinCoframe parameters)) :
    area n * (parameters.a 1 + parameters.i 1) *
      (parameters.i 1 - parameters.j 1) = 0 := by
  have hCoefficients :=
    (nonlinearCoframePlaquetteConnectionStationary_iff_coefficients
      nullWaveShift (nullWaveLorentzConnection area n)
      (nullWaveEinsteinCoframe parameters)).1 hStationary
  have hSiteZero := hCoefficients 0 1 1
  have hSiteOne := hCoefficients 1 1 1
  rw [nullWaveEinsteinCoframe_linkEulerCoefficient_zero_one] at hSiteZero
  rw [nullWaveEinsteinCoframe_linkEulerCoefficient_one_one] at hSiteOne
  linarith

/-- No member of the complete coframe-Einstein family with invertible site-`1`
coframe can satisfy the connection equation at nonzero area. -/
theorem nullWaveEinsteinCoframe_not_connectionStationary
    (area : Nat -> Real) (n : Nat)
    (parameters : NullWaveEinsteinCoframeParameters)
    (hArea : Not (area n = 0))
    (hDet : Not ((nullWaveEinsteinCoframe parameters 1).det = 0)) :
    Not (NonlinearCoframePlaquetteConnectionStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveEinsteinCoframe parameters)) := by
  have hFactorOne : Not (parameters.a 1 + parameters.i 1 = 0) := by
    intro hZero
    apply hDet
    rw [nullWaveEinsteinCoframe_det]
    rw [hZero]
    ring
  have hFactorTwo : Not (parameters.i 1 - parameters.j 1 = 0) := by
    intro hZero
    apply hDet
    rw [nullWaveEinsteinCoframe_det]
    rw [hZero]
    ring
  intro hStationary
  exact (mul_ne_zero (mul_ne_zero hArea hFactorOne) hFactorTwo)
    (nullWaveEinsteinCoframe_connectionStationary_imp_factor_zero
      area n parameters hStationary)

/-- Canonical coordinates of an arbitrary coframe in the displayed
ten-parameter Einstein kernel. -/
def nullWaveEinsteinCoframeParametersOf
    (coframe : CoframeField NullWaveSite) :
    NullWaveEinsteinCoframeParameters where
  a := fun site => coframe site 0 0
  b := fun site => coframe site 0 1
  c := fun site => coframe site 0 2
  d := fun site => coframe site 1 0
  e := fun site => coframe site 1 1
  f := fun site => coframe site 1 2
  g := fun site => coframe site 2 0
  h := fun site => coframe site 2 1
  i := fun site => coframe site 3 0
  j := fun site => coframe site 3 3

/-- **Complete coframe-kernel theorem.**  At nonzero area, every coframe that
satisfies all sixteen finite Einstein equations is exactly a member of the
displayed ten-parameter family. -/
theorem nullWave_coframeStationary_eq_einsteinCoframe
    (area : Nat -> Real) (n : Nat)
    (coframe : CoframeField NullWaveSite)
    (hArea : Not (area n = 0))
    (hStationary : NonlinearCoframePlaquetteCoframeStationary nullWaveShift
      (nullWaveLorentzConnection area n) coframe) :
    coframe = nullWaveEinsteinCoframe
      (nullWaveEinsteinCoframeParametersOf coframe) := by
  have hCoefficients :=
    (nonlinearCoframePlaquetteCoframeStationary_iff_coefficients
      nullWaveShift (nullWaveLorentzConnection area n) coframe).1 hStationary
  have hResponse : forall site internal direction,
      nullWaveCoframeEinsteinResponse (coframe site) internal direction = 0 := by
    intro site internal direction
    have hCoefficient := hCoefficients site internal direction
    rw [nullWave_coframeEulerCoefficient] at hCoefficient
    have hAmplitude : Not (nullWaveAmplitude site = 0) := by
      fin_cases site <;>
        norm_num [nullWaveAmplitude, nullWavePotential, toggleFinTwo]
    exact (mul_eq_zero.mp hCoefficient).resolve_left
      (mul_ne_zero hArea hAmplitude)
  funext site internal direction
  have hTransverse := hResponse site 0 0
  have hRowOne := hResponse site 0 1
  have hRowTwo := hResponse site 0 2
  have hColumnOne := hResponse site 1 0
  have hColumnTwo := hResponse site 2 0
  have hLongitudinal := hResponse site 1 1
  simp [nullWaveCoframeEinsteinResponse] at hTransverse hRowOne hRowTwo
  simp [nullWaveCoframeEinsteinResponse] at hColumnOne hColumnTwo hLongitudinal
  fin_cases internal <;> fin_cases direction <;>
    simp [nullWaveEinsteinCoframe,
      nullWaveEinsteinCoframeParametersOf] <;>
    linarith

/-- **Full fixed-connection no-go.**  At nonzero area, the exact proper-Lorentz
two-site null-wave connection admits no jointly stationary coframe whose
site-`1` tetrad is invertible.  No diagonal or no-shear hypothesis remains. -/
theorem nullWave_not_jointStationary_of_invertible_siteOne
    (area : Nat -> Real) (n : Nat)
    (coframe : CoframeField NullWaveSite)
    (hArea : Not (area n = 0))
    (hDet : Not ((coframe 1).det = 0)) :
    Not (NonlinearCoframePlaquetteJointStationary nullWaveShift
      (nullWaveLorentzConnection area n) coframe) := by
  intro hJoint
  have hCoframe := nullWave_coframeStationary_eq_einsteinCoframe
    area n coframe hArea hJoint.2
  have hConnection :
      NonlinearCoframePlaquetteConnectionStationary nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveEinsteinCoframe
          (nullWaveEinsteinCoframeParametersOf coframe)) := by
    rw [<- hCoframe]
    exact hJoint.1
  have hEinsteinDet : Not
      ((nullWaveEinsteinCoframe
        (nullWaveEinsteinCoframeParametersOf coframe) 1).det = 0) := by
    rw [<- hCoframe]
    exact hDet
  exact (nullWaveEinsteinCoframe_not_connectionStationary area n
    (nullWaveEinsteinCoframeParametersOf coframe) hArea hEinsteinDet)
    hConnection

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo.nullWaveEinsteinCoframe_linkEulerCoefficient_zero_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveEinsteinCoframe_linkEulerCoefficient_zero_one

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo.nullWaveEinsteinCoframe_linkEulerCoefficient_one_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveEinsteinCoframe_linkEulerCoefficient_one_one

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo.nullWave_coframeStationary_eq_einsteinCoframe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWave_coframeStationary_eq_einsteinCoframe

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo.nullWave_not_jointStationary_of_invertible_siteOne' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWave_not_jointStationary_of_invertible_siteOne

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo
