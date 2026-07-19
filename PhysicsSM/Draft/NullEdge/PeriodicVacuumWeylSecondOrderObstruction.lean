import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureRankTwo
import PhysicsSM.Draft.NullEdge.LorentzMatrixSecondJet

noncomputable section

/-!
# Second-order obstruction for the two-site vacuum-wave sector

The exact two-site joint Hessian has a two-real-dimensional curved image, but
a linearized solution need not be tangent to a nonlinear stationary branch.
This module evaluates the next formal exponential-link Taylor coefficient of
the same concrete Palatini coframe Euler map.

For link tangent `A`, the coefficient of `t^2` in a plaquette built from
`exp(t A)` is represented by `exponentialPlaquetteSecondJet`.  Pairing that
coefficient with the identity coframe response, and pairing the first
plaquette coefficient with the first coframe perturbation, gives the exact
quadratic coframe-Euler coefficient.  An arbitrary second-order link
correction contributes one half of the ordinary joint Hessian row.  The
sum of the time-time coframe equations over the two periodic sites annihilates
that Hessian contribution, but evaluates to

`-8 * (plusScale^2 + crossScale^2)`

on the complete curved stationary sector.  Hence no nonzero plus/cross mode
passes this formal second-order continuation condition on the two-site
periodic carrier.

This is a kernel-checked finite Taylor-jet obstruction.  It is analogous to a
Taub-charge or linearization-instability constraint on a compact background,
but this module does not identify it with the continuum Taub integral or prove
an analytic theorem about arbitrary twice-differentiable curves.  The latter
requires a separate second-derivative bridge from matrix exponentials to this
formal jet.

Claim label: exact finite second-order obstruction.  Originality tag:
`[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylSecondOrderObstruction

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzMatrixSecondJet
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompleteness
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompletenessData
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-- Lorentz-generator matrix carried by one six-component link tangent. -/
def linkTangentGenerator
    {Site : Type*} (variation : LinkVariation Site)
    (site : Site) (direction : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  lorentzGenerator (variation site direction)

/-- Formal second jet of the ordered plaquette
`U_a(x) U_b(x+a) U_a(x+b)^-1 U_b(x)^-1` for exponential links. -/
def exponentialPlaquetteSecondJet
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (variation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    MatrixSecondJet :=
  MatrixSecondJet.mul
    (MatrixSecondJet.mul
      (MatrixSecondJet.mul
        (MatrixSecondJet.exponential
          (linkTangentGenerator variation site a))
        (MatrixSecondJet.exponential
          (linkTangentGenerator variation (shift a site) b)))
      (MatrixSecondJet.inverseExponential
        (linkTangentGenerator variation (shift b site) a)))
    (MatrixSecondJet.inverseExponential
      (linkTangentGenerator variation site b))

/-- Sparse coordinates of the complementary coframe-face response to the
time-time tetrad probe. -/
def timeTimeCoframeFaceVariationCoordinates
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    Fin 4 -> Fin 4 -> Fiber 6 :=
  ![
    ![0, 0, 0, 0],
    ![
      0,
      0,
      ![-coframe 3 3, coframe 2 3, -coframe 1 3, 0, 0, 0],
      ![coframe 3 2, -coframe 2 2, coframe 1 2, 0, 0, 0]
    ],
    ![
      0,
      ![coframe 3 3, -coframe 2 3, coframe 1 3, 0, 0, 0],
      0,
      ![-coframe 3 1, coframe 2 1, -coframe 1 1, 0, 0, 0]
    ],
    ![
      0,
      ![-coframe 3 2, coframe 2 2, -coframe 1 2, 0, 0, 0],
      ![coframe 3 1, -coframe 2 1, coframe 1 1, 0, 0, 0],
      0
    ]
  ]

set_option maxHeartbeats 3000000 in
/-- The sparse time-time table is exactly the complementary Palatini face
derivative for the matrix-unit probe. -/
theorem complementaryPalatiniFaceWeightFirstVariation_timeTime
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation coframe
        (Matrix.single 0 0 1) a b =
      timeTimeCoframeFaceVariationCoordinates coframe a b := by
  funext component
  fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [timeTimeCoframeFaceVariationCoordinates,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      transportApply, lorentzHodgeStar, spacetimeAlternatingSymbol,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- Quadratic coefficient of one local coframe Euler equation along a
first-order link/coframe tangent. -/
def coframeEulerQuadraticCoefficient
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (internal direction : Fin 4) : Real :=
  let probe := Matrix.single internal direction (1 : Real)
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      -(1 / 2 : Real) * Matrix.trace
        (lorentzGenerator
            (complementaryPalatiniFaceWeightFirstVariation
              (1 : Matrix (Fin 4) (Fin 4) Real) probe a b) *
            (exponentialPlaquetteSecondJet shift linkVariation
              site a b).quadratic +
          lorentzGenerator
            (complementaryPalatiniFaceWeightFirstVariation
              (coframeVariation site) probe a b) *
            (exponentialPlaquetteSecondJet shift linkVariation
              site a b).linear)))

/-- The integrated time-time Hessian row vanishes for every second-order
link correction on the two-site periodic carrier. -/
theorem integratedTimeTime_linearizedCoframeEuler_zero
    (linkCorrection : LinkVariation NullWaveSite) :
    linearizedCoframeEulerCoefficient nullWaveShift linkCorrection 0 0 0 +
      linearizedCoframeEulerCoefficient nullWaveShift linkCorrection 1 0 0 = 0 := by
  have h0 := nullWaveActualJointEulerCoordinate_eq_explicit
    linkCorrection (0 : CoframeField NullWaveSite)
      (.coframe 0 0 0)
  have h1 := nullWaveActualJointEulerCoordinate_eq_explicit
    linkCorrection (0 : CoframeField NullWaveSite)
      (.coframe 1 0 0)
  simp only [nullWaveActualJointEulerCoordinate] at h0 h1
  rw [h0, h1]
  simp +decide [nullWaveExplicitJointEulerCoordinate,
    evaluateNullWaveTangentTerms, nullWaveJointHessianTerms,
    nullWaveCoframeHessianTerms, nullWaveJointTangentCoordinate]
  ring

/-- Integrated time-time quadratic charge of a first-order tangent. -/
def integratedTimeTimeQuadraticCharge
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite) : Real :=
  coframeEulerQuadraticCoefficient nullWaveShift
      linkVariation coframeVariation 0 0 0 +
    coframeEulerQuadraticCoefficient nullWaveShift
      linkVariation coframeVariation 1 0 0

set_option maxHeartbeats 20000000 in
/-- The complete plus/cross curved sector has a negative-definite integrated
quadratic time-time charge. -/
theorem integratedTimeTimeQuadraticCharge_plusCross
    (plusScale crossScale : Real) :
    integratedTimeTimeQuadraticCharge
        (plusCrossLinkCombination plusScale crossScale)
        (plusCrossCoframeCombination plusScale crossScale) =
      -8 * (plusScale ^ 2 + crossScale ^ 2) := by
  unfold integratedTimeTimeQuadraticCharge
  simp only [coframeEulerQuadraticCoefficient]
  simp_rw [complementaryPalatiniFaceWeightFirstVariation_timeTime]
  simp +decide [timeTimeCoframeFaceVariationCoordinates,
    exponentialPlaquetteSecondJet,
    MatrixSecondJet.mul, MatrixSecondJet.exponential,
    MatrixSecondJet.inverseExponential, linkTangentGenerator,
    plusCrossLinkCombination, plusCrossCoframeCombination,
    plusBackreactionLinkVariation, crossBackreactionLinkVariation,
    plusBackreactionCoframeVariation, crossBackreactionCoframeVariation,
    lorentzGenerator, bivectorMatrix, MinkowskiConvention.eta,
    nullWaveShift, toggleFinTwo, nullWaveAmplitude, nullWavePotential,
    nullWavePolarizationOne, nullWavePolarizationTwo,
    Matrix.trace, Fin.sum_univ_four]
  ring

/-- Formal second-order integrated charge after allowing an arbitrary
second-order link correction.  A second-order coframe correction does not
enter this coefficient because the identity plaquette increment is zero. -/
def integratedTimeTimeSecondOrderCharge
    (plusScale crossScale : Real)
    (linkCorrection : LinkVariation NullWaveSite) : Real :=
  integratedTimeTimeQuadraticCharge
      (plusCrossLinkCombination plusScale crossScale)
      (plusCrossCoframeCombination plusScale crossScale) +
    (1 / 2 : Real) *
      (linearizedCoframeEulerCoefficient nullWaveShift
          linkCorrection 0 0 0 +
        linearizedCoframeEulerCoefficient nullWaveShift
          linkCorrection 1 0 0)

/-- No second-order link correction changes the integrated charge of the
plus/cross tangent. -/
theorem integratedTimeTimeSecondOrderCharge_eq
    (plusScale crossScale : Real)
    (linkCorrection : LinkVariation NullWaveSite) :
    integratedTimeTimeSecondOrderCharge plusScale crossScale linkCorrection =
      -8 * (plusScale ^ 2 + crossScale ^ 2) := by
  rw [integratedTimeTimeSecondOrderCharge,
    integratedTimeTimeQuadraticCharge_plusCross,
    integratedTimeTime_linearizedCoframeEuler_zero]
  ring

/-- **Second-order continuation obstruction.** If the formal integrated
second-order coframe Euler charge vanishes after an arbitrary link correction,
then both curved first-order amplitudes were zero. -/
theorem integratedTimeTimeSecondOrderCharge_zero_iff
    (plusScale crossScale : Real)
    (linkCorrection : LinkVariation NullWaveSite) :
    integratedTimeTimeSecondOrderCharge plusScale crossScale linkCorrection = 0 <->
      plusScale = 0 /\ crossScale = 0 := by
  rw [integratedTimeTimeSecondOrderCharge_eq]
  constructor
  · intro hCharge
    have hSquares : plusScale ^ 2 + crossScale ^ 2 = 0 := by linarith
    constructor <;> nlinarith [sq_nonneg plusScale, sq_nonneg crossScale]
  · rintro ⟨rfl, rfl⟩
    norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylSecondOrderObstruction.integratedTimeTime_linearizedCoframeEuler_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms integratedTimeTime_linearizedCoframeEuler_zero

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylSecondOrderObstruction.integratedTimeTimeQuadraticCharge_plusCross' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms integratedTimeTimeQuadraticCharge_plusCross

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylSecondOrderObstruction.integratedTimeTimeSecondOrderCharge_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms integratedTimeTimeSecondOrderCharge_zero_iff

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylSecondOrderObstruction
