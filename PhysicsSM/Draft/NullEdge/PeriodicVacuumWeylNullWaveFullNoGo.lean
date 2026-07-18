import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveDiagonalNoGo

noncomputable section

/-!
# Full coframe reduction for the fixed periodic vacuum null wave

For the exact proper-Lorentz two-site null-wave connection, the finite coframe
Euler equation has rank six at each site.  Its complete ten-parameter solution
space is displayed below.  Two exact link Euler coefficients then force a
factor that also divides the coframe determinant to vanish at nonzero area.
The successor `PeriodicVacuumWeylNullWaveJointNoGo` uses this reduction to
prove that the fixed null-wave links have no pointwise invertible jointly
stationary coframe, including coframes with arbitrary off-diagonal shear.

This is a no-go for this fixed two-site connection/refinement ansatz, not for
null-wave curvature or for the general null-edge Palatini program.  The next
escape must deform the links together with the coframe, enlarge the carrier,
or change the finite face/dual-cell weighting.  The symbolic reduction in
`Scripts/oracle/null_wave_joint_stationary_search.py` is an external
cross-check only.  Claim labels: finite identity and finite no-go.
Originality tag: `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveFullNoGo

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
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-- Six-rank linear coframe-Einstein response of the unit-amplitude null-wave
curvature at one site. -/
def nullWaveCoframeEinsteinResponse
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 4) (Fin 4) Real :=
  let longitudinal :=
    coframe 0 0 - coframe 0 3 + coframe 3 0 - coframe 3 3
  !![2 * (coframe 1 1 - coframe 2 2),
      -2 * (coframe 1 0 - coframe 1 3),
      2 * (coframe 2 0 - coframe 2 3),
      -2 * (coframe 1 1 - coframe 2 2);
     -2 * (coframe 0 1 + coframe 3 1),
      2 * longitudinal,
      0,
      2 * (coframe 0 1 + coframe 3 1);
     2 * (coframe 0 2 + coframe 3 2),
      0,
      -2 * longitudinal,
      -2 * (coframe 0 2 + coframe 3 2);
     2 * (coframe 1 1 - coframe 2 2),
      -2 * (coframe 1 0 - coframe 1 3),
      2 * (coframe 2 0 - coframe 2 3),
      -2 * (coframe 1 1 - coframe 2 2)]

set_option maxHeartbeats 5000000 in
/-- Exact sixteen-entry coframe Euler response for the proper-Lorentz null
wave.  The site amplitude is `+1` or `-1`, and the extracted curvature adds
the finite area factor. -/
theorem nullWave_coframeEulerCoefficient
    (area : Nat -> Real) (n : Nat) (coframe : CoframeField NullWaveSite)
    (site : NullWaveSite) (internal direction : Fin 4) :
    nonlinearCoframeEulerCoefficient nullWaveShift
        (nullWaveLorentzConnection area n) coframe site internal direction =
      area n * nullWaveAmplitude site *
        nullWaveCoframeEinsteinResponse (coframe site) internal direction := by
  change nonlinearCoframeLocalEulerFunctional nullWaveShift
      (nullWaveLorentzConnection area n) coframe site
      (Matrix.single internal direction 1) = _
  rw [nonlinearCoframeLocalEulerFunctional_eq_palatiniDensityFirstVariation]
  rw [show extractedPlaquetteCurvature nullWaveShift
      (nullWaveLorentzConnection area n) site =
        area n • nullWaveCurvature site by
    funext a b component
    exact congrFun
      (extractedPlaquetteCurvature_nullWaveLorentzConnection
        area n site a b) component]
  fin_cases site <;> fin_cases internal <;> fin_cases direction <;>
    simp +decide [palatiniDensityFirstVariation,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      nullWaveCoframeEinsteinResponse, nullWaveCurvature,
      nullWaveAmplitude, nullWaveFaceOne, nullWaveFaceTwo,
      nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo, Matrix.single_apply,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar,
      kreinPair_lorentzBivector_eq_explicit, transportApply,
      Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- Ten independent sitewise parameters for the complete kernel of the
null-wave coframe Euler response. -/
structure NullWaveEinsteinCoframeParameters where
  a : NullWaveSite -> Real
  b : NullWaveSite -> Real
  c : NullWaveSite -> Real
  d : NullWaveSite -> Real
  e : NullWaveSite -> Real
  f : NullWaveSite -> Real
  g : NullWaveSite -> Real
  h : NullWaveSite -> Real
  i : NullWaveSite -> Real
  j : NullWaveSite -> Real

/-- Explicit ten-parameter kernel of the rank-six null-wave coframe Euler
response.  The parameters are independent at the two sites. -/
def nullWaveEinsteinCoframe
    (parameters : NullWaveEinsteinCoframeParameters) :
    CoframeField NullWaveSite :=
  fun site =>
    !![parameters.a site, parameters.b site, parameters.c site,
        parameters.a site + parameters.i site - parameters.j site;
       parameters.d site, parameters.e site, parameters.f site,
        parameters.d site;
       parameters.g site, parameters.h site, parameters.e site,
        parameters.g site;
       parameters.i site, -parameters.b site, -parameters.c site,
        parameters.j site]

/-- Every member of the displayed ten-parameter family is exactly stationary
in the coframe/Einstein sector. -/
theorem nullWaveEinsteinCoframe_coframeStationary
    (area : Nat -> Real) (n : Nat)
    (parameters : NullWaveEinsteinCoframeParameters) :
    NonlinearCoframePlaquetteCoframeStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveEinsteinCoframe parameters) := by
  rw [nonlinearCoframePlaquetteCoframeStationary_iff_coefficients]
  intro site internal direction
  rw [nullWave_coframeEulerCoefficient]
  fin_cases site <;> fin_cases internal <;> fin_cases direction <;>
    simp [nullWaveEinsteinCoframe, nullWaveCoframeEinsteinResponse,
      nullWaveAmplitude, nullWavePotential, toggleFinTwo]
  all_goals ring_nf <;> simp

/-- Determinant factorization on the complete coframe-Einstein family. -/
theorem nullWaveEinsteinCoframe_det
    (parameters : NullWaveEinsteinCoframeParameters)
    (site : NullWaveSite) :
    (nullWaveEinsteinCoframe parameters site).det =
      -(parameters.a site + parameters.i site) *
        (parameters.e site ^ 2 -
          parameters.f site * parameters.h site) *
        (parameters.i site - parameters.j site) := by
  rw [Matrix.det_succ_row_zero, Fin.sum_univ_four]
  simp only [Matrix.det_fin_three, Matrix.submatrix_apply]
  simp [Fin.succAbove, Fin.lt_def, nullWaveEinsteinCoframe]
  ring

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveFullNoGo.nullWave_coframeEulerCoefficient' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWave_coframeEulerCoefficient

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveFullNoGo.nullWaveEinsteinCoframe_coframeStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveEinsteinCoframe_coframeStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveFullNoGo.nullWaveEinsteinCoframe_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveEinsteinCoframe_det

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveFullNoGo
