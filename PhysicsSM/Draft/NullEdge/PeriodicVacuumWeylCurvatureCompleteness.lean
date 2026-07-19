import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompletenessData

noncomputable section

/-!
# Curvature completeness of the two-site linearized null wave

This module upgrades the exact-rational Hessian oracle for the two-site
null-wave carrier to kernel-checked curvature identities.  The target is to
prove that every jointly stationary linearized perturbation has additive
curvature in the displayed plus/cross span.

Claim label: finite linearized curvature-completeness theorem.  Originality
tag: `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompleteness

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompletenessData
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-- Sparse coordinate table for the complementary Palatini face derivative at
the identity coframe. -/
def identityCoframeFaceVariationCoordinates
    (variation : Matrix (Fin 4) (Fin 4) Real) :
    Fin 4 -> Fin 4 -> Fiber 6 :=
  ![
    ![
      0,
      ![-variation 0 2, -variation 0 3, 0,
        variation 2 2 + variation 3 3, -variation 1 2, -variation 1 3],
      ![variation 0 1, 0, -variation 0 3, -variation 2 1,
        variation 1 1 + variation 3 3, -variation 2 3],
      ![0, variation 0 1, variation 0 2, -variation 3 1,
        -variation 3 2, variation 1 1 + variation 2 2]
    ],
    ![
      ![variation 0 2, variation 0 3, 0,
        -variation 2 2 - variation 3 3, variation 1 2, variation 1 3],
      0,
      ![-variation 0 0 - variation 3 3, variation 2 3,
        -variation 1 3, variation 2 0, -variation 1 0, 0],
      ![variation 3 2, -variation 0 0 - variation 2 2,
        variation 1 2, variation 3 0, 0, -variation 1 0]
    ],
    ![
      ![-variation 0 1, 0, variation 0 3, variation 2 1,
        -variation 1 1 - variation 3 3, variation 2 3],
      ![variation 0 0 + variation 3 3, -variation 2 3,
        variation 1 3, -variation 2 0, variation 1 0, 0],
      0,
      ![-variation 3 1, variation 2 1,
        -variation 0 0 - variation 1 1, 0, variation 3 0, -variation 2 0]
    ],
    ![
      ![0, -variation 0 1, -variation 0 2, variation 3 1,
        variation 3 2, -variation 1 1 - variation 2 2],
      ![-variation 3 2, variation 0 0 + variation 2 2,
        -variation 1 2, -variation 3 0, 0, variation 1 0],
      ![variation 3 1, -variation 2 1,
        variation 0 0 + variation 1 1, 0, -variation 3 0, variation 2 0],
      0
    ]
  ]

set_option maxHeartbeats 3000000 in
/-- The sparse face-variation table is exactly the complementary Palatini
coframe derivative at the identity matrix. -/
theorem complementaryPalatiniFaceWeightFirstVariation_one_eq_coordinates
    (variation : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation 1 variation a b =
      identityCoframeFaceVariationCoordinates variation a b := by
  funext component
  fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [identityCoframeFaceVariationCoordinates,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      Fin.sum_univ_four, Fin.sum_univ_six, Matrix.one_apply] <;>
    ring

/-- Fieldwise form of the exact identity-coframe face-variation table. -/
theorem coframeFaceWeightFirstVariation_identity_eq_coordinates
    (coframeVariation : CoframeField NullWaveSite)
    (site : NullWaveSite) (a b : Fin 4) :
    coframeFaceWeightFirstVariation
        (identityCoframeField NullWaveSite) coframeVariation site a b =
      identityCoframeFaceVariationCoordinates (coframeVariation site) a b := by
  simpa [coframeFaceWeightFirstVariation, identityCoframeField] using
    complementaryPalatiniFaceWeightFirstVariation_one_eq_coordinates
      (coframeVariation site) a b

/-- Read one coordinate of a combined link/coframe tangent. -/
def nullWaveJointTangentCoordinate
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite) :
    NullWaveJointIndex -> Real
  | .link site direction component =>
      linkVariation site direction component
  | .coframe site internal direction =>
      coframeVariation site internal direction

/-- Evaluate a sparse exact-rational row on a combined tangent. -/
def evaluateNullWaveTangentTerms
    (terms : List (NullWaveJointIndex × Real))
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite) : Real :=
  terms.foldr (fun term value =>
    term.2 * nullWaveJointTangentCoordinate
      linkVariation coframeVariation term.1 + value) 0

/-- Concrete coordinate of the action's joint linearized Euler map. -/
def nullWaveActualJointEulerCoordinate
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite) :
    NullWaveJointIndex -> Real
  | .link site direction component =>
      linearizedLinkEulerCoefficient nullWaveShift
        linkVariation coframeVariation site direction component
  | .coframe site internal direction =>
      linearizedCoframeEulerCoefficient nullWaveShift
        linkVariation site internal direction

/-- Sparse generated coordinate of the exact 80 by 80 joint Hessian. -/
def nullWaveExplicitJointEulerCoordinate
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite)
    (row : NullWaveJointIndex) : Real :=
  evaluateNullWaveTangentTerms (nullWaveJointHessianTerms row)
    linkVariation coframeVariation

set_option maxHeartbeats 20000000 in
/-- Every sparse generated Hessian row is exactly the corresponding concrete
Euler-map derivative coordinate. -/
theorem nullWaveActualJointEulerCoordinate_eq_explicit
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite)
    (row : NullWaveJointIndex) :
    nullWaveActualJointEulerCoordinate linkVariation coframeVariation row =
      nullWaveExplicitJointEulerCoordinate linkVariation coframeVariation row := by
  cases row with
  | link site direction component =>
      simp only [nullWaveActualJointEulerCoordinate]
      unfold linearizedLinkEulerCoefficient
      rw [linearizedLinkEulerFunctional_eq_coordinates]
      unfold linearizedLinkEulerFunctionalCoordinates
      simp_rw [linearizedGeneratorFaceResponse_eq_pairs,
        coframeFaceWeight_identity_eq_coordinates,
        coframeFaceWeightFirstVariation_identity_eq_coordinates]
      fin_cases site <;> fin_cases direction <;> fin_cases component <;>
        simp +decide [nullWaveExplicitJointEulerCoordinate,
          evaluateNullWaveTangentTerms, nullWaveJointHessianTerms,
          nullWaveLinkHessianTerms, nullWaveJointTangentCoordinate,
          lorentzTriplePair, identityPalatiniFaceCoordinates,
          identityCoframeFaceVariationCoordinates,
          additivePlaquetteCurl, nullWaveShift, toggleFinTwo,
          kreinPair_lorentzBivector_eq_explicit, Fin.sum_univ_four] <;>
        ring
  | coframe site internal direction =>
      simp only [nullWaveActualJointEulerCoordinate]
      unfold linearizedCoframeEulerCoefficient
      rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
      unfold palatiniDensityFirstVariation
      simp_rw [complementaryPalatiniFaceWeightFirstVariation_one_eq_coordinates]
      fin_cases site <;> fin_cases internal <;> fin_cases direction <;>
        simp +decide [nullWaveExplicitJointEulerCoordinate,
          evaluateNullWaveTangentTerms, nullWaveJointHessianTerms,
          nullWaveCoframeHessianTerms, nullWaveJointTangentCoordinate,
          identityCoframeFaceVariationCoordinates,
          additivePlaquetteCurl, nullWaveShift, toggleFinTwo,
          kreinPair_lorentzBivector_eq_explicit, Fin.sum_univ_four] <;>
        ring

/-- The plus coefficient read from the first polarization coordinate of an
arbitrary additive curvature. -/
def nullWaveCurvaturePlusScale
    (linkVariation : LinkVariation NullWaveSite) : Real :=
  -(1 / 2 : Real) *
    additivePlaquetteCurl nullWaveShift linkVariation 0 0 1 1

/-- The cross coefficient read from the second polarization coordinate of an
arbitrary additive curvature. -/
def nullWaveCurvatureCrossScale
    (linkVariation : LinkVariation NullWaveSite) : Real :=
  (1 / 2 : Real) *
    additivePlaquetteCurl nullWaveShift linkVariation 0 0 1 2

/-- Curvature left after subtracting the plus/cross combination selected by
the two distinguished polarization coordinates. -/
def nullWaveCurvatureResidual
    (linkVariation : LinkVariation NullWaveSite)
    (site : NullWaveSite) (a b : Fin 4) (component : Fin 6) : Real :=
  additivePlaquetteCurl nullWaveShift linkVariation site a b component -
    additivePlaquetteCurl nullWaveShift
      (plusCrossLinkCombination
        (nullWaveCurvaturePlusScale linkVariation)
        (nullWaveCurvatureCrossScale linkVariation)) site a b component

/-- Evaluate a sparse row-space certificate against the explicit joint Euler
coordinates. -/
def evaluateNullWaveEulerTerms
    (terms : List (NullWaveJointIndex × Real))
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite) : Real :=
  terms.foldr (fun term value =>
    term.2 * nullWaveExplicitJointEulerCoordinate
      linkVariation coframeVariation term.1 + value) 0

set_option maxHeartbeats 20000000 in
/-- Every curvature residual coordinate is the certified displayed linear
combination of exact joint-Hessian rows. -/
theorem nullWaveCurvatureResidual_eq_certificate
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite)
    (site : NullWaveSite) (a b : Fin 4) (component : Fin 6) :
    nullWaveCurvatureResidual linkVariation site a b component =
      evaluateNullWaveEulerTerms
        (nullWaveCurvatureCertificateTerms site a b component)
        linkVariation coframeVariation := by
  fin_cases site <;> fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [nullWaveCurvatureResidual,
      nullWaveCurvaturePlusScale, nullWaveCurvatureCrossScale,
      evaluateNullWaveEulerTerms, nullWaveExplicitJointEulerCoordinate,
      evaluateNullWaveTangentTerms, nullWaveJointHessianTerms,
      nullWaveLinkHessianTerms, nullWaveCoframeHessianTerms,
      nullWaveCurvatureCertificateTerms, nullWaveJointTangentCoordinate,
      plusCrossLinkCombination, plusBackreactionLinkVariation,
      crossBackreactionLinkVariation, additivePlaquetteCurl,
      nullWaveShift, toggleFinTwo, nullWaveAmplitude, nullWavePotential,
      nullWavePolarizationOne, nullWavePolarizationTwo] <;>
    ring

/-- A sparse Euler-row combination vanishes whenever every explicit Euler
coordinate vanishes. -/
theorem evaluateNullWaveEulerTerms_eq_zero
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite)
    (hEuler : forall row, nullWaveExplicitJointEulerCoordinate
      linkVariation coframeVariation row = 0)
    (terms : List (NullWaveJointIndex × Real)) :
    evaluateNullWaveEulerTerms terms linkVariation coframeVariation = 0 := by
  induction terms with
  | nil => rfl
  | cons term terms ih =>
      unfold evaluateNullWaveEulerTerms at ih
      simp only [evaluateNullWaveEulerTerms, List.foldr_cons]
      rw [hEuler term.1, ih]
      ring

/-- **Exact curvature completeness.** Every perturbation in the full
80-coordinate joint linearized Palatini kernel has additive curvature equal to
the displayed plus/cross combination selected by two curvature coordinates. -/
theorem jointStationary_additivePlaquetteCurl_eq_plusCross
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite)
    (hStationary : LinearizedJointStationary nullWaveShift
      linkVariation coframeVariation) :
    additivePlaquetteCurl nullWaveShift linkVariation =
      additivePlaquetteCurl nullWaveShift
        (plusCrossLinkCombination
          (nullWaveCurvaturePlusScale linkVariation)
          (nullWaveCurvatureCrossScale linkVariation)) := by
  have hActual : forall row, nullWaveActualJointEulerCoordinate
      linkVariation coframeVariation row = 0 := by
    intro row
    cases row with
    | link site direction component =>
        exact hStationary.1 site direction component
    | coframe site internal direction =>
        exact hStationary.2 site internal direction
  have hExplicit : forall row, nullWaveExplicitJointEulerCoordinate
      linkVariation coframeVariation row = 0 := by
    intro row
    rw [<- nullWaveActualJointEulerCoordinate_eq_explicit]
    exact hActual row
  funext site a b component
  have hCertificate := nullWaveCurvatureResidual_eq_certificate
    linkVariation coframeVariation site a b component
  rw [evaluateNullWaveEulerTerms_eq_zero
    linkVariation coframeVariation hExplicit] at hCertificate
  exact sub_eq_zero.mp hCertificate

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompleteness.complementaryPalatiniFaceWeightFirstVariation_one_eq_coordinates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complementaryPalatiniFaceWeightFirstVariation_one_eq_coordinates

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompleteness.nullWaveActualJointEulerCoordinate_eq_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveActualJointEulerCoordinate_eq_explicit

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompleteness.nullWaveCurvatureResidual_eq_certificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveCurvatureResidual_eq_certificate

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompleteness.jointStationary_additivePlaquetteCurl_eq_plusCross' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms jointStationary_additivePlaquetteCurl_eq_plusCross

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompleteness
