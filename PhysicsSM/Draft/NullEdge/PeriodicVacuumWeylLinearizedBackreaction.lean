import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo

noncomputable section

/-!
# Linearized link/coframe backreaction of the periodic vacuum null wave

The fixed proper-Lorentz null-wave links have no invertible jointly stationary
coframe at nonzero area.  This module therefore linearizes both independent
Euler sectors simultaneously at the identity connection and identity coframe.
The link perturbation is a six-component Lorentz-algebra field and the coframe
perturbation is an arbitrary tetrad matrix field.

Two explicit coupled perturbations solve all forty-eight link equations and
all thirty-two coframe equations while carrying independent nonzero additive
curvatures modulo the injective twelve-parameter infinitesimal local Lorentz
orbit.  They are finite two-site analogues of the plus and cross null-wave
polarizations.  This is a kernel-checked linearized existence theorem, not yet
a nonlinear jointly stationary branch, Levi-Civita selection, gauge-reduced
degree-of-freedom count, or continuum-limit theorem.

The standard linearized Palatini architecture is `[import]`; the exact
two-site witnesses and convention-locked finite verification are
`[orig/comp]`.  Claim label: finite linearized existence theorem.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-- First variation, at identity transport and holonomy, of one weighted
adjoint face response.  The four terms respectively vary the face, the left
transport, its inverse, and the plaquette holonomy. -/
def linearizedWeightedAdjointFaceResponse
    (face faceVariation : Fiber 6)
    (transportVariation : Matrix (Fin 4) (Fin 4) Real)
    (probe : Fiber 6)
    (holonomyVariation : Matrix (Fin 4) (Fin 4) Real) : Real :=
  -(1 / 2 : Real) * Matrix.trace
    (lorentzGenerator faceVariation * lorentzGenerator probe +
      lorentzGenerator face *
        (transportVariation * lorentzGenerator probe -
          lorentzGenerator probe * transportVariation +
          lorentzGenerator probe * holonomyVariation))

/-- First-order local link Euler functional for simultaneous Lorentz-link and
coframe perturbations around identity fields. -/
def linearizedLinkEulerFunctional
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) : Real :=
  let identityLinks := identityConnection Site
  let identityCoframe := identityCoframeField Site
  Finset.sum Finset.univ (fun b =>
      linearizedWeightedAdjointFaceResponse
        (coframeFaceWeight identityCoframe site direction b)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation site direction b)
        (linkMatrixVariation identityLinks linkVariation site direction)
        probe
        (plaquetteMatrixVariation shift identityLinks linkVariation
          site direction b)) +
    Finset.sum Finset.univ (fun a =>
      let predecessor := (shift a).symm site
      linearizedWeightedAdjointFaceResponse
        (coframeFaceWeight identityCoframe predecessor a direction)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation predecessor a direction)
        (twoStepMatrixVariation shift identityLinks linkVariation
          predecessor a direction)
        probe
        (plaquetteMatrixVariation shift identityLinks linkVariation
          predecessor a direction)) -
    Finset.sum Finset.univ (fun a =>
      linearizedWeightedAdjointFaceResponse
        (coframeFaceWeight identityCoframe site a direction)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation site a direction)
        (plaquetteMatrixVariation shift identityLinks linkVariation
            site a direction +
          linkMatrixVariation identityLinks linkVariation site direction)
        probe
        (plaquetteMatrixVariation shift identityLinks linkVariation
          site a direction)) -
    Finset.sum Finset.univ (fun b =>
      let predecessor := (shift b).symm site
      linearizedWeightedAdjointFaceResponse
        (coframeFaceWeight identityCoframe predecessor direction b)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation predecessor direction b)
        (twoStepMatrixVariation shift identityLinks linkVariation
          predecessor direction b)
        probe
        (plaquetteMatrixVariation shift identityLinks linkVariation
          predecessor direction b))

/-- Forty-eight coordinate coefficients of the linearized link equation. -/
def linearizedLinkEulerCoefficient
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) : Real :=
  linearizedLinkEulerFunctional shift linkVariation coframeVariation
    site direction (Pi.single component (1 : Real))

/-- First-order local coframe Euler functional around the identity fields.
The variation of the coframe coefficient itself multiplies the zero identity
plaquette action and therefore drops out; only the additive plaquette tangent
remains. -/
def linearizedCoframeEulerFunctional
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      orderedPlaquetteActionFirstResponse
        (complementaryPalatiniFaceWeightFirstVariation
          (1 : Matrix (Fin 4) (Fin 4) Real) probe a b)
        (plaquetteMatrixVariation shift (identityConnection Site)
          linkVariation site a b)))

/-- Thirty-two coordinate coefficients of the linearized coframe equation. -/
def linearizedCoframeEulerCoefficient
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (internal direction : Fin 4) : Real :=
  linearizedCoframeEulerFunctional shift linkVariation site
    (Matrix.single internal direction 1)

/-- Vanishing of all linearized connection equations. -/
def LinearizedLinkStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site) : Prop :=
  forall site direction component,
    linearizedLinkEulerCoefficient shift linkVariation coframeVariation
      site direction component = 0

/-- Vanishing of all linearized coframe/Einstein equations. -/
def LinearizedCoframeStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) : Prop :=
  forall site internal direction,
    linearizedCoframeEulerCoefficient shift linkVariation
      site internal direction = 0

/-- Simultaneous first-order stationarity of both independent Palatini
variables. -/
def LinearizedJointStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site) : Prop :=
  LinearizedLinkStationary shift linkVariation coframeVariation /\
    LinearizedCoframeStationary shift linkVariation

/-- Link tangent induced at the identity by a site-local infinitesimal
Lorentz gauge parameter. -/
def infinitesimalGaugeLinkVariation
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (parameter : Site -> Fiber 6) : LinkVariation Site :=
  fun site direction => parameter site - parameter (shift direction site)

/-- Coframe tangent induced at the identity by the same site-local
infinitesimal Lorentz gauge parameter. -/
def infinitesimalGaugeCoframeVariation
    {Site : Type*} (parameter : Site -> Fiber 6) : CoframeField Site :=
  fun site => lorentzGenerator (parameter site)

/-- Commuting carrier shifts make every infinitesimal gauge-link tangent
additively flat. -/
theorem additivePlaquetteCurl_infinitesimalGaugeLinkVariation
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (hCommute : ShiftsCommute shift) (parameter : Site -> Fiber 6)
    (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift
        (infinitesimalGaugeLinkVariation shift parameter) site a b = 0 := by
  funext component
  unfold additivePlaquetteCurl infinitesimalGaugeLinkVariation
  simp only [Pi.sub_apply, Pi.zero_apply]
  rw [hCommute site a b]
  ring

/-- Reversing an ordered face negates every additive plaquette curl. -/
theorem additivePlaquetteCurl_antisymmetric_local
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (variation : LinkVariation Site) (site : Site)
    (a b : Fin 4) (component : Fin 6) :
    additivePlaquetteCurl shift variation site a b component =
      -additivePlaquetteCurl shift variation site b a component := by
  unfold additivePlaquetteCurl
  ring

/-- Plus-like link perturbation selected by the exact joint Hessian. -/
def plusBackreactionLinkVariation : LinkVariation NullWaveSite :=
  fun site direction =>
    if direction = 1 then
      (-nullWaveAmplitude site) • nullWavePolarizationOne
    else if direction = 2 then
      (-nullWaveAmplitude site) • nullWavePolarizationTwo
    else 0

/-- Plus-like transverse diagonal shear, supported at site zero. -/
def plusBackreactionCoframeVariation : CoframeField NullWaveSite :=
  fun site =>
    if site = 0 then
      !![0, 0, 0, 0;
         0, -1, 0, 0;
         0, 0, 1, 0;
         0, 0, 0, 0]
    else 0

/-- Integer-scaled cross-like link perturbation selected by the exact joint
Hessian. -/
def crossBackreactionLinkVariation : LinkVariation NullWaveSite :=
  fun site direction =>
    if direction = 0 then
      nullWaveAmplitude site • ![-1, 0, 0, 0, 0, 0]
    else if direction = 1 then
      (-nullWaveAmplitude site) • nullWavePolarizationTwo
    else if direction = 2 then
      nullWaveAmplitude site • nullWavePolarizationOne
    else
      nullWaveAmplitude site • ![-1, 0, 0, 0, 0, 0]

/-- Integer-scaled cross-like transverse shear, supported at site zero. -/
def crossBackreactionCoframeVariation : CoframeField NullWaveSite :=
  fun site =>
    if site = 0 then
      !![0, 0, 0, 0;
         0, 0, 2, 0;
         0, 0, 0, 0;
         0, 0, 0, 0]
    else 0

/-- Explicit cross-polarized curvature carried by the integer-scaled cross
backreaction mode. -/
def crossBackreactionCurvature :
    NullWaveSite -> Fin 4 -> Fin 4 -> Fiber 6 :=
  fun site a b component =>
    2 * nullWaveAmplitude site *
      (nullWaveFaceOne a b * nullWavePolarizationTwo component -
        nullWaveFaceTwo a b * nullWavePolarizationOne component)

/-- Linear combination of the two curved link modes. -/
def plusCrossLinkCombination (plusScale crossScale : Real) :
    LinkVariation NullWaveSite :=
  plusScale • plusBackreactionLinkVariation +
    crossScale • crossBackreactionLinkVariation

/-- Linear combination of the matching coframe modes. -/
def plusCrossCoframeCombination (plusScale crossScale : Real) :
    CoframeField NullWaveSite :=
  plusScale • plusBackreactionCoframeVariation +
    crossScale • crossBackreactionCoframeVariation

/-- At identity links, the linearized coframe equation is exactly the first
Palatini coframe response paired with the additive plaquette curl. -/
theorem linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) :
    linearizedCoframeEulerFunctional shift linkVariation site probe =
      palatiniDensityFirstVariation 1 probe
        (additivePlaquetteCurl shift linkVariation site) := by
  unfold linearizedCoframeEulerFunctional palatiniDensityFirstVariation
    orderedPlaquetteActionFirstResponse
  simp_rw [plaquetteMatrixVariation_identity,
    normalizedTracePair_eq_kreinPair]

/-- Additive flatness makes every infinitesimal gauge-link tangent satisfy the
linearized coframe/Einstein sector. -/
theorem infinitesimalGauge_coframeStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (parameter : Site -> Fiber 6) :
    LinearizedCoframeStationary shift
      (infinitesimalGaugeLinkVariation shift parameter) := by
  intro site internal direction
  unfold linearizedCoframeEulerCoefficient
  rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
  have hCurl :
      additivePlaquetteCurl shift
          (infinitesimalGaugeLinkVariation shift parameter) site = 0 := by
    funext a b
    exact additivePlaquetteCurl_infinitesimalGaugeLinkVariation
      shift hCommute parameter site a b
  rw [hCurl]
  simp [palatiniDensityFirstVariation,
    kreinPair_lorentzBivector_eq_explicit]

set_option maxHeartbeats 1000000 in
/-- The plus-like link perturbation carries exactly twice the previously
verified periodic vacuum-Weyl curvature. -/
theorem additivePlaquetteCurl_plusBackreactionLinkVariation
    (site : NullWaveSite) (a b : Fin 4) :
    additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation
        site a b =
      (2 : Real) • nullWaveCurvature site a b := by
  funext component
  fin_cases site <;> fin_cases a <;> fin_cases b <;>
    simp [additivePlaquetteCurl, plusBackreactionLinkVariation,
      nullWaveCurvature, nullWaveShift, toggleFinTwo,
      nullWaveAmplitude, nullWavePotential, nullWaveFaceOne,
      nullWaveFaceTwo, nullWavePolarizationOne,
      nullWavePolarizationTwo] <;>
    ring

set_option maxHeartbeats 1000000 in
/-- The cross-like link perturbation realizes the displayed cross-polarized
curvature exactly. -/
theorem additivePlaquetteCurl_crossBackreactionLinkVariation
    (site : NullWaveSite) (a b : Fin 4) :
    additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation
        site a b =
      crossBackreactionCurvature site a b := by
  funext component
  fin_cases site <;> fin_cases a <;> fin_cases b <;>
    simp [additivePlaquetteCurl, crossBackreactionLinkVariation,
      crossBackreactionCurvature, nullWaveShift, toggleFinTwo,
      nullWaveAmplitude, nullWavePotential, nullWaveFaceOne,
      nullWaveFaceTwo, nullWavePolarizationOne,
      nullWavePolarizationTwo] <;>
    ring

/-- Face reversal negates the cross-polarized curvature. -/
theorem crossBackreactionCurvature_antisymmetric (site : NullWaveSite) :
    forall a b component,
      crossBackreactionCurvature site a b component =
        -crossBackreactionCurvature site b a component := by
  intro a b component
  fin_cases a <;> fin_cases b <;>
    simp [crossBackreactionCurvature, nullWaveFaceOne,
      nullWaveFaceTwo]

/-- Matrix conversion of the cross-polarized curvature. -/
theorem bivectorMatrix_crossBackreactionCurvature
    (site : NullWaveSite) (a b i j : Fin 4) :
    bivectorMatrix (crossBackreactionCurvature site a b) i j =
      2 * nullWaveAmplitude site *
        (nullWaveFaceOne a b *
            bivectorMatrix nullWavePolarizationTwo i j -
          nullWaveFaceTwo a b *
            bivectorMatrix nullWavePolarizationOne i j) := by
  fin_cases i <;> fin_cases j <;>
    simp +decide [crossBackreactionCurvature, bivectorMatrix,
      nullWavePolarizationOne, nullWavePolarizationTwo]

/-- The quarter-turned null polarizations cancel under Ricci contraction. -/
theorem crossBackreactionRicciContraction_cancel
    (coframeDirection raisedDirection : Fin 4) :
    Finset.sum Finset.univ (fun b =>
      nullWaveFaceOne coframeDirection b *
          bivectorMatrix nullWavePolarizationTwo raisedDirection b -
        nullWaveFaceTwo coframeDirection b *
          bivectorMatrix nullWavePolarizationOne raisedDirection b) = 0 := by
  fin_cases coframeDirection <;> fin_cases raisedDirection <;>
    simp +decide [nullWaveFaceOne, nullWaveFaceTwo,
      nullWavePolarizationOne, nullWavePolarizationTwo, bivectorMatrix,
      Fin.sum_univ_four]

/-- Every mixed Ricci entry of the cross-polarized curvature vanishes at the
identity inverse coframe. -/
theorem crossBackreactionCurvature_mixedRicci_zero
    (site : NullWaveSite) (coframeDirection raisedDirection : Fin 4) :
    mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        coframeDirection raisedDirection = 0 := by
  rw [mixedRicciCurvature_identity]
  simp_rw [bivectorMatrix_crossBackreactionCurvature]
  rw [<- Finset.mul_sum,
    crossBackreactionRicciContraction_cancel]
  ring

/-- The cross-polarized scalar curvature vanishes at the identity inverse
coframe. -/
theorem crossBackreactionCurvature_scalar_zero (site : NullWaveSite) :
    inverseCoframeScalarCurvature
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site) = 0 := by
  rw [show inverseCoframeScalarCurvature
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site) =
      Finset.sum Finset.univ (fun direction =>
        mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
          (crossBackreactionCurvature site) direction direction) by
    simp [inverseCoframeScalarCurvature, mixedRicciCurvature,
      Matrix.one_apply, Fin.sum_univ_four]]
  simp [crossBackreactionCurvature_mixedRicci_zero]

/-- All mixed vacuum Einstein entries of the cross-polarized curvature vanish
pointwise. -/
theorem crossBackreactionCurvature_mixedVacuum
    (site : NullWaveSite) (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        coframeDirection raisedDirection = 0 := by
  rw [mixedVacuumEinsteinEntry,
    crossBackreactionCurvature_mixedRicci_zero,
    crossBackreactionCurvature_scalar_zero]
  ring

/-- The plus-like link perturbation satisfies all thirty-two linearized
coframe/Einstein equations. -/
theorem plusBackreaction_coframeStationary :
    LinearizedCoframeStationary nullWaveShift
      plusBackreactionLinkVariation := by
  intro site internal direction
  unfold linearizedCoframeEulerCoefficient
  rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
  have hCurl :
      additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation site =
        (2 : Real) • nullWaveCurvature site := by
    funext a b
    exact additivePlaquetteCurl_plusBackreactionLinkVariation site a b
  rw [hCurl]
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (inverseCoframe := (1 : Matrix (Fin 4) (Fin 4) Real))]
  · have hMixed : forall coframeDirection raisedDirection,
        2 * mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
              ((2 : Real) • nullWaveCurvature site)
              coframeDirection raisedDirection -
            (1 : Matrix (Fin 4) (Fin 4) Real)
                raisedDirection coframeDirection *
              inverseCoframeScalarCurvature
                (1 : Matrix (Fin 4) (Fin 4) Real)
                ((2 : Real) • nullWaveCurvature site) = 0 := by
      intro coframeDirection raisedDirection
      change mixedVacuumEinsteinEntry
          (1 : Matrix (Fin 4) (Fin 4) Real)
          ((2 : Real) • nullWaveCurvature site)
          coframeDirection raisedDirection = 0
      change mixedVacuumEinsteinEntryLinear
          (1 : Matrix (Fin 4) (Fin 4) Real)
          coframeDirection raisedDirection
          ((2 : Real) • nullWaveCurvature site) = 0
      rw [map_smul]
      change (2 : Real) * mixedVacuumEinsteinEntry
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (nullWaveCurvature site) coframeDirection raisedDirection = 0
      rw [nullWaveCurvature_mixedVacuum]
      ring
    have hCoefficient :=
      (mixedEinsteinCoframeCoefficient_vanish_iff
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (1 : Matrix (Fin 4) (Fin 4) Real)
        ((2 : Real) • nullWaveCurvature site)
        (by simp) (by simp)).2 hMixed
    simp only [Matrix.det_one, one_mul]
    apply Finset.sum_eq_zero
    intro coefficientInternal _
    apply Finset.sum_eq_zero
    intro coefficientDirection _
    rw [hCoefficient coefficientInternal coefficientDirection]
    ring
  · simp
  · intro a b component
    simp only [Pi.smul_apply, smul_eq_mul]
    rw [nullWaveCurvature_antisymmetric site a b component]
    ring

/-- The cross-like link perturbation satisfies all thirty-two linearized
coframe/Einstein equations. -/
theorem crossBackreaction_coframeStationary :
    LinearizedCoframeStationary nullWaveShift
      crossBackreactionLinkVariation := by
  intro site internal direction
  unfold linearizedCoframeEulerCoefficient
  rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
  have hCurl :
      additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation site =
        crossBackreactionCurvature site := by
    funext a b
    exact additivePlaquetteCurl_crossBackreactionLinkVariation site a b
  rw [hCurl]
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (inverseCoframe := (1 : Matrix (Fin 4) (Fin 4) Real))]
  · have hMixed : forall coframeDirection raisedDirection,
        2 * mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
              (crossBackreactionCurvature site)
              coframeDirection raisedDirection -
            (1 : Matrix (Fin 4) (Fin 4) Real)
                raisedDirection coframeDirection *
              inverseCoframeScalarCurvature
                (1 : Matrix (Fin 4) (Fin 4) Real)
                (crossBackreactionCurvature site) = 0 := by
      intro coframeDirection raisedDirection
      simpa [mixedVacuumEinsteinEntry] using
        crossBackreactionCurvature_mixedVacuum
          site coframeDirection raisedDirection
    have hCoefficient :=
      (mixedEinsteinCoframeCoefficient_vanish_iff
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        (by simp) (by simp)).2 hMixed
    simp only [Matrix.det_one, one_mul]
    apply Finset.sum_eq_zero
    intro coefficientInternal _
    apply Finset.sum_eq_zero
    intro coefficientDirection _
    rw [hCoefficient coefficientInternal coefficientDirection]
    ring
  · simp
  · exact crossBackreactionCurvature_antisymmetric site

/-- The Lorentz-generator coordinate map is additive. -/
theorem lorentzGenerator_add_local (left right : Fiber 6) :
    lorentzGenerator (left + right) =
      lorentzGenerator left + lorentzGenerator right := by
  unfold lorentzGenerator
  rw [bivectorMatrix_add, Matrix.add_mul]

/-- Six-vector coordinates of the Lorentz Lie bracket in the fixed bivector
basis. -/
def lorentzBracketCoordinates (left right : Fiber 6) : Fiber 6 :=
  ![
    left 1 * right 2 - left 2 * right 1 - left 3 * right 4 +
      left 4 * right 3,
    -left 0 * right 2 + left 2 * right 0 - left 3 * right 5 +
      left 5 * right 3,
    left 0 * right 1 - left 1 * right 0 - left 4 * right 5 +
      left 5 * right 4,
    -left 0 * right 4 - left 1 * right 5 + left 4 * right 0 +
      left 5 * right 1,
    left 0 * right 3 - left 2 * right 5 - left 3 * right 0 +
      left 5 * right 2,
    left 1 * right 3 + left 2 * right 4 - left 3 * right 1 -
      left 4 * right 2
  ]

/-- A right-trivialized link tangent at the identity is its Lorentz
generator. -/
theorem linkMatrixVariation_identity_local
    {Site : Type*} (variation : LinkVariation Site)
    (site : Site) (direction : Fin 4) :
    linkMatrixVariation (identityConnection Site) variation site direction =
      lorentzGenerator (variation site direction) := by
  simp [linkMatrixVariation, identityConnection, unitMatrix]

/-- A two-link tangent at the identity is the generator of the sum of its
two six-vector tangents. -/
theorem twoStepMatrixVariation_identity_local
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (variation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    twoStepMatrixVariation shift (identityConnection Site) variation
        site a b =
      lorentzGenerator
        (variation site a + variation (shift a site) b) := by
  rw [lorentzGenerator_add_local]
  simp [twoStepMatrixVariation, linkMatrixVariation,
    identityConnection, unitMatrix]

/-- Six-vector form of one identity-background response branch. -/
def linearizedGeneratorFaceResponse
    (face faceVariation transportVariation probe holonomyVariation : Fiber 6) :
    Real :=
  -(1 / 2 : Real) * Matrix.trace
    (lorentzGenerator faceVariation * lorentzGenerator probe +
      lorentzGenerator face *
        (lorentzGenerator transportVariation * lorentzGenerator probe -
          lorentzGenerator probe * lorentzGenerator transportVariation +
          lorentzGenerator probe * lorentzGenerator holonomyVariation))

/-- Convention-locked cubic trace invariant of three Lorentz bivectors. -/
def lorentzTriplePair (left middle right : Fiber 6) : Real :=
  (1 / 2 : Real) *
    (left 0 * middle 1 * right 2 - left 0 * middle 2 * right 1 -
      left 0 * middle 3 * right 4 + left 0 * middle 4 * right 3 -
      left 1 * middle 0 * right 2 + left 1 * middle 2 * right 0 -
      left 1 * middle 3 * right 5 + left 1 * middle 5 * right 3 +
      left 2 * middle 0 * right 1 - left 2 * middle 1 * right 0 -
      left 2 * middle 4 * right 5 + left 2 * middle 5 * right 4 +
      left 3 * middle 0 * right 4 + left 3 * middle 1 * right 5 -
      left 3 * middle 4 * right 0 - left 3 * middle 5 * right 1 -
      left 4 * middle 0 * right 3 + left 4 * middle 2 * right 5 +
      left 4 * middle 3 * right 0 - left 4 * middle 5 * right 2 -
      left 5 * middle 1 * right 3 - left 5 * middle 2 * right 4 +
      left 5 * middle 3 * right 1 + left 5 * middle 4 * right 2)

/-- The cubic coordinate formula is exactly the normalized trace of three
Lorentz generators in the fixed mostly-minus convention. -/
theorem normalizedTraceTriple_eq_lorentzTriplePair
    (left middle right : Fiber 6) :
    -(1 / 2 : Real) * Matrix.trace
        (lorentzGenerator left * lorentzGenerator middle *
          lorentzGenerator right) =
      lorentzTriplePair left middle right := by
  simp [lorentzTriplePair, Matrix.trace, lorentzGenerator,
    bivectorMatrix, MinkowskiConvention.eta, Fin.sum_univ_four]
  ring

/-- Closed six-coordinate formula for one linearized response branch. -/
theorem linearizedGeneratorFaceResponse_eq_pairs
    (face faceVariation transportVariation probe holonomyVariation : Fiber 6) :
    linearizedGeneratorFaceResponse face faceVariation transportVariation
        probe holonomyVariation =
      kreinPair lorentzBivectorFundamentalSymmetry faceVariation probe +
        lorentzTriplePair face transportVariation probe -
        lorentzTriplePair face probe transportVariation +
        lorentzTriplePair face probe holonomyVariation := by
  unfold linearizedGeneratorFaceResponse
  simp only [Matrix.mul_add, Matrix.mul_sub, Matrix.trace_add,
    Matrix.trace_sub]
  simp_rw [<- Matrix.mul_assoc]
  calc
    _ = -(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator faceVariation * lorentzGenerator probe) +
        (-(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator face * lorentzGenerator transportVariation *
            lorentzGenerator probe)) -
        (-(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator face * lorentzGenerator probe *
            lorentzGenerator transportVariation)) +
        (-(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator face * lorentzGenerator probe *
            lorentzGenerator holonomyVariation)) := by ring
    _ = _ := by
      rw [normalizedTracePair_eq_kreinPair,
        normalizedTraceTriple_eq_lorentzTriplePair,
        normalizedTraceTriple_eq_lorentzTriplePair,
        normalizedTraceTriple_eq_lorentzTriplePair]

/-- Coordinate-only form of the identity-background linearized link Euler
functional. -/
def linearizedLinkEulerFunctionalCoordinates
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) : Real :=
  let identityCoframe := identityCoframeField Site
  Finset.sum Finset.univ (fun b =>
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe site direction b)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation site direction b)
        (linkVariation site direction) probe
        (additivePlaquetteCurl shift linkVariation site direction b)) +
    Finset.sum Finset.univ (fun a =>
      let predecessor := (shift a).symm site
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe predecessor a direction)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation predecessor a direction)
        (linkVariation predecessor a +
          linkVariation (shift a predecessor) direction)
        probe
        (additivePlaquetteCurl shift linkVariation predecessor a direction)) -
    Finset.sum Finset.univ (fun a =>
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe site a direction)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation site a direction)
        (additivePlaquetteCurl shift linkVariation site a direction +
          linkVariation site direction)
        probe
        (additivePlaquetteCurl shift linkVariation site a direction)) -
    Finset.sum Finset.univ (fun b =>
      let predecessor := (shift b).symm site
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe predecessor direction b)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation predecessor direction b)
        (linkVariation predecessor direction +
          linkVariation (shift direction predecessor) b)
        probe
        (additivePlaquetteCurl shift linkVariation predecessor direction b))

/-- The matrix-valued linearized link equation at identity is exactly its
six-vector coordinate form. -/
theorem linearizedLinkEulerFunctional_eq_coordinates
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) :
    linearizedLinkEulerFunctional shift linkVariation coframeVariation
        site direction probe =
      linearizedLinkEulerFunctionalCoordinates shift linkVariation
        coframeVariation site direction probe := by
  unfold linearizedLinkEulerFunctional
    linearizedLinkEulerFunctionalCoordinates
    linearizedWeightedAdjointFaceResponse
    linearizedGeneratorFaceResponse
  simp_rw [linkMatrixVariation_identity_local,
    twoStepMatrixVariation_identity_local,
    plaquetteMatrixVariation_identity,
    <- lorentzGenerator_add_local]

/-- Sparse six-vector table of the complementary face weights at the identity
coframe. -/
def identityPalatiniFaceCoordinates : Fin 4 -> Fin 4 -> Fiber 6 :=
  ![
    ![0, ![0, 0, 0, 1, 0, 0], ![0, 0, 0, 0, 1, 0],
      ![0, 0, 0, 0, 0, 1]],
    ![![0, 0, 0, -1, 0, 0], 0, ![-1, 0, 0, 0, 0, 0],
      ![0, -1, 0, 0, 0, 0]],
    ![![0, 0, 0, 0, -1, 0], ![1, 0, 0, 0, 0, 0], 0,
      ![0, 0, -1, 0, 0, 0]],
    ![![0, 0, 0, 0, 0, -1], ![0, 1, 0, 0, 0, 0],
      ![0, 0, 1, 0, 0, 0], 0]
  ]

/-- Sparse six-vector table of the plus shear's complementary face first
variation at its supported site. -/
def plusBackreactionFaceVariationCoordinates :
    NullWaveSite -> Fin 4 -> Fin 4 -> Fiber 6 :=
  fun site =>
    if site = 0 then
      ![
        ![0, ![0, 0, 0, 1, 0, 0], ![0, 0, 0, 0, -1, 0], 0],
        ![![0, 0, 0, -1, 0, 0], 0, 0, ![0, -1, 0, 0, 0, 0]],
        ![![0, 0, 0, 0, 1, 0], 0, 0, ![0, 0, 1, 0, 0, 0]],
        ![0, ![0, 1, 0, 0, 0, 0], ![0, 0, -1, 0, 0, 0], 0]
      ]
    else 0

/-- Sparse six-vector table of the cross shear's complementary face first
variation at its supported site. -/
def crossBackreactionFaceVariationCoordinates :
    NullWaveSite -> Fin 4 -> Fin 4 -> Fiber 6 :=
  fun site =>
    if site = 0 then
      ![
        ![0, ![0, 0, 0, 0, -2, 0], 0, 0],
        ![![0, 0, 0, 0, 2, 0], 0, 0, ![0, 0, 2, 0, 0, 0]],
        ![0, 0, 0, 0],
        ![0, ![0, 0, -2, 0, 0, 0], 0, 0]
      ]
    else 0

set_option maxHeartbeats 1000000 in
/-- The displayed identity-face table is exact. -/
theorem coframeFaceWeight_identity_eq_coordinates
    {Site : Type*} (site : Site) (a b : Fin 4) :
    coframeFaceWeight (identityCoframeField Site) site a b =
      identityPalatiniFaceCoordinates a b := by
  funext component
  fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [coframeFaceWeight, identityCoframeField,
      identityPalatiniFaceCoordinates,
      complementaryPalatiniFaceWeight, palatiniFaceWeight, coframeWedge,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.one_apply, Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

set_option maxHeartbeats 2000000 in
/-- The first variation of an identity-coframe face along an infinitesimal
Lorentz gauge orbit is the Lorentz bracket with that face. -/
theorem coframeFaceWeightFirstVariation_gauge_eq_bracket
    {Site : Type*} (parameter : Site -> Fiber 6)
    (site : Site) (a b : Fin 4) :
    coframeFaceWeightFirstVariation
        (identityCoframeField Site)
        (infinitesimalGaugeCoframeVariation parameter) site a b =
      lorentzBracketCoordinates (parameter site)
        (identityPalatiniFaceCoordinates a b) := by
  funext component
  fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [coframeFaceWeightFirstVariation, identityCoframeField,
      infinitesimalGaugeCoframeVariation,
      identityPalatiniFaceCoordinates, lorentzBracketCoordinates,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      lorentzGenerator, bivectorMatrix, MinkowskiConvention.eta,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.mul_apply, Matrix.one_apply,
      Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

set_option maxHeartbeats 2000000 in
/-- The displayed plus-shear face-variation table is exact. -/
theorem coframeFaceWeightFirstVariation_plus_eq_coordinates
    (site : NullWaveSite) (a b : Fin 4) :
    coframeFaceWeightFirstVariation
        (identityCoframeField NullWaveSite)
        plusBackreactionCoframeVariation site a b =
      plusBackreactionFaceVariationCoordinates site a b := by
  funext component
  fin_cases site <;> fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [coframeFaceWeightFirstVariation, identityCoframeField,
      plusBackreactionCoframeVariation,
      plusBackreactionFaceVariationCoordinates,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.one_apply, Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

set_option maxHeartbeats 2000000 in
/-- The displayed cross-shear face-variation table is exact. -/
theorem coframeFaceWeightFirstVariation_cross_eq_coordinates
    (site : NullWaveSite) (a b : Fin 4) :
    coframeFaceWeightFirstVariation
        (identityCoframeField NullWaveSite)
        crossBackreactionCoframeVariation site a b =
      crossBackreactionFaceVariationCoordinates site a b := by
  funext component
  fin_cases site <;> fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [coframeFaceWeightFirstVariation, identityCoframeField,
      crossBackreactionCoframeVariation,
      crossBackreactionFaceVariationCoordinates,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.one_apply, Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- The combined plus/cross coframe mode has the corresponding linear
combination of the two sparse face-variation tables. -/
theorem coframeFaceWeightFirstVariation_plusCross_eq_coordinates
    (plusScale crossScale : Real) (site : NullWaveSite) (a b : Fin 4) :
    coframeFaceWeightFirstVariation
        (identityCoframeField NullWaveSite)
        (plusCrossCoframeCombination plusScale crossScale) site a b =
      plusScale • plusBackreactionFaceVariationCoordinates site a b +
        crossScale • crossBackreactionFaceVariationCoordinates site a b := by
  unfold plusCrossCoframeCombination coframeFaceWeightFirstVariation
  simp only [Pi.add_apply, Pi.smul_apply]
  rw [complementaryPalatiniFaceWeightFirstVariation_add,
    complementaryPalatiniFaceWeightFirstVariation_smul,
    complementaryPalatiniFaceWeightFirstVariation_smul]
  change plusScale •
        coframeFaceWeightFirstVariation
          (identityCoframeField NullWaveSite)
          plusBackreactionCoframeVariation site a b +
      crossScale •
        coframeFaceWeightFirstVariation
          (identityCoframeField NullWaveSite)
          crossBackreactionCoframeVariation site a b = _
  rw [coframeFaceWeightFirstVariation_plus_eq_coordinates,
    coframeFaceWeightFirstVariation_cross_eq_coordinates]

set_option maxHeartbeats 5000000 in
/-- The plus-like link/coframe pair satisfies all forty-eight linearized
connection equations. -/
theorem plusBackreaction_linkStationary :
    LinearizedLinkStationary nullWaveShift plusBackreactionLinkVariation
      plusBackreactionCoframeVariation := by
  intro site direction component
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs]
  simp_rw [coframeFaceWeight_identity_eq_coordinates,
    coframeFaceWeightFirstVariation_plus_eq_coordinates]
  fin_cases site <;> fin_cases direction <;> fin_cases component <;>
    simp +decide [lorentzTriplePair, plusBackreactionLinkVariation,
      identityPalatiniFaceCoordinates,
      plusBackreactionFaceVariationCoordinates,
      additivePlaquetteCurl, nullWaveShift, toggleFinTwo, nullWaveAmplitude,
      nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo,
      kreinPair_lorentzBivector_eq_explicit,
      Fin.sum_univ_four] <;>
    ring

set_option maxHeartbeats 5000000 in
/-- The cross-like link/coframe pair satisfies all forty-eight linearized
connection equations. -/
theorem crossBackreaction_linkStationary :
    LinearizedLinkStationary nullWaveShift crossBackreactionLinkVariation
      crossBackreactionCoframeVariation := by
  intro site direction component
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs]
  simp_rw [coframeFaceWeight_identity_eq_coordinates,
    coframeFaceWeightFirstVariation_cross_eq_coordinates]
  fin_cases site <;> fin_cases direction <;> fin_cases component <;>
    simp +decide [lorentzTriplePair, crossBackreactionLinkVariation,
      identityPalatiniFaceCoordinates,
      crossBackreactionFaceVariationCoordinates,
      additivePlaquetteCurl, nullWaveShift, toggleFinTwo, nullWaveAmplitude,
      nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo,
      kreinPair_lorentzBivector_eq_explicit,
      Fin.sum_univ_four] <;>
    ring

set_option maxHeartbeats 5000000 in
/-- Every real plus/cross combination satisfies all forty-eight linearized
connection equations. -/
theorem plusCrossCombination_linkStationary
    (plusScale crossScale : Real) :
    LinearizedLinkStationary nullWaveShift
      (plusCrossLinkCombination plusScale crossScale)
      (plusCrossCoframeCombination plusScale crossScale) := by
  intro site direction component
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs]
  simp_rw [coframeFaceWeight_identity_eq_coordinates,
    coframeFaceWeightFirstVariation_plusCross_eq_coordinates]
  fin_cases site <;> fin_cases direction <;> fin_cases component <;>
    simp +decide [lorentzTriplePair, plusCrossLinkCombination,
      plusBackreactionLinkVariation, crossBackreactionLinkVariation,
      identityPalatiniFaceCoordinates,
      plusBackreactionFaceVariationCoordinates,
      crossBackreactionFaceVariationCoordinates,
      additivePlaquetteCurl, nullWaveShift, toggleFinTwo, nullWaveAmplitude,
      nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo,
      kreinPair_lorentzBivector_eq_explicit,
      Fin.sum_univ_four] <;>
    ring

set_option maxHeartbeats 5000000 in
/-- Every site-local infinitesimal Lorentz gauge parameter on the two-site
carrier lies in the linearized connection-equation kernel. -/
theorem nullWave_infinitesimalGauge_linkStationary
    (parameter : NullWaveSite -> Fiber 6) :
    LinearizedLinkStationary nullWaveShift
      (infinitesimalGaugeLinkVariation nullWaveShift parameter)
      (infinitesimalGaugeCoframeVariation parameter) := by
  intro site direction component
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs,
    coframeFaceWeight_identity_eq_coordinates,
    coframeFaceWeightFirstVariation_gauge_eq_bracket,
    additivePlaquetteCurl_infinitesimalGaugeLinkVariation
      nullWaveShift nullWaveShift_commute parameter]
  fin_cases site <;> fin_cases direction <;> fin_cases component <;>
    simp +decide [lorentzTriplePair, lorentzBracketCoordinates,
      infinitesimalGaugeLinkVariation, identityPalatiniFaceCoordinates,
      nullWaveShift, toggleFinTwo,
      kreinPair_lorentzBivector_eq_explicit, Fin.sum_univ_four] <;>
    ring

/-- Every site-local infinitesimal Lorentz gauge parameter on the two-site
carrier lies in the full joint Hessian kernel. -/
theorem nullWave_infinitesimalGauge_jointStationary
    (parameter : NullWaveSite -> Fiber 6) :
    LinearizedJointStationary nullWaveShift
      (infinitesimalGaugeLinkVariation nullWaveShift parameter)
      (infinitesimalGaugeCoframeVariation parameter) :=
  ⟨nullWave_infinitesimalGauge_linkStationary parameter,
    infinitesimalGauge_coframeStationary
      nullWaveShift nullWaveShift_commute parameter⟩

/-- Combined link/coframe tangent of the infinitesimal gauge orbit. -/
def nullWaveInfinitesimalGaugePair
    (parameter : NullWaveSite -> Fiber 6) :
    LinkVariation NullWaveSite × CoframeField NullWaveSite :=
  (infinitesimalGaugeLinkVariation nullWaveShift parameter,
    infinitesimalGaugeCoframeVariation parameter)

/-- The coframe component makes the twelve-parameter infinitesimal gauge
family injective, so none of its parameter directions is silently lost. -/
theorem nullWaveInfinitesimalGaugePair_injective :
    Function.Injective nullWaveInfinitesimalGaugePair := by
  intro left right hPair
  have hCoframe :
      infinitesimalGaugeCoframeVariation left =
        infinitesimalGaugeCoframeVariation right :=
    congrArg Prod.snd hPair
  funext site
  apply lorentzGenerator_injective
  exact congrFun hCoframe site

/-- The plus-like link perturbation has nonzero additive curvature at both
sites. -/
theorem plusBackreaction_curvature_ne_zero (site : NullWaveSite) :
    additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation site ≠
      0 := by
  have hCurl :
      additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation site =
        (2 : Real) • nullWaveCurvature site := by
    funext a b
    exact additivePlaquetteCurl_plusBackreactionLinkVariation site a b
  rw [hCurl]
  exact smul_ne_zero (by norm_num) (nullWaveCurvature_ne_zero site)

/-- The cross-like link perturbation has nonzero additive curvature at both
sites. -/
theorem crossBackreaction_curvature_ne_zero (site : NullWaveSite) :
    additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation site ≠
      0 := by
  have hCurl :
      additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation site =
        crossBackreactionCurvature site := by
    funext a b
    exact additivePlaquetteCurl_crossBackreactionLinkVariation site a b
  rw [hCurl]
  intro hZero
  have hEntry := congrFun (congrFun (congrFun hZero 0) 1) 2
  fin_cases site <;>
    norm_num [crossBackreactionCurvature, nullWaveAmplitude,
      nullWavePotential, toggleFinTwo, nullWaveFaceOne,
      nullWaveFaceTwo, nullWavePolarizationOne,
      nullWavePolarizationTwo] at hEntry
  all_goals simp at hEntry

/-- The explicit plus-like pair is a jointly stationary, curved solution of
the identity-background linearized Palatini equations. -/
theorem plusBackreaction_jointStationary :
    LinearizedJointStationary nullWaveShift plusBackreactionLinkVariation
      plusBackreactionCoframeVariation :=
  ⟨plusBackreaction_linkStationary,
    plusBackreaction_coframeStationary⟩

/-- The explicit cross-like pair is a jointly stationary, curved solution of
the identity-background linearized Palatini equations. -/
theorem crossBackreaction_jointStationary :
    LinearizedJointStationary nullWaveShift crossBackreactionLinkVariation
      crossBackreactionCoframeVariation :=
  ⟨crossBackreaction_linkStationary,
    crossBackreaction_coframeStationary⟩

/-- The additive curvature map takes the combined link mode to the matching
combination of plus and cross curvatures. -/
theorem additivePlaquetteCurl_plusCrossLinkCombination
    (plusScale crossScale : Real) (site : NullWaveSite) :
    additivePlaquetteCurl nullWaveShift
        (plusCrossLinkCombination plusScale crossScale) site =
      plusScale •
          additivePlaquetteCurl nullWaveShift
            plusBackreactionLinkVariation site +
        crossScale •
          additivePlaquetteCurl nullWaveShift
            crossBackreactionLinkVariation site := by
  funext a b component
  simp [plusCrossLinkCombination, additivePlaquetteCurl]
  ring

/-- Every plus/cross curvature combination satisfies the mixed vacuum Einstein
equation at the identity inverse coframe. -/
theorem plusCrossCombinationCurvature_mixedVacuum
    (plusScale crossScale : Real) (site : NullWaveSite)
    (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination plusScale crossScale) site)
        coframeDirection raisedDirection = 0 := by
  rw [additivePlaquetteCurl_plusCrossLinkCombination]
  change mixedVacuumEinsteinEntryLinear
      (1 : Matrix (Fin 4) (Fin 4) Real)
      coframeDirection raisedDirection
      (plusScale •
          additivePlaquetteCurl nullWaveShift
            plusBackreactionLinkVariation site +
        crossScale •
          additivePlaquetteCurl nullWaveShift
            crossBackreactionLinkVariation site) = 0
  rw [map_add, map_smul, map_smul]
  have hPlusCurl :
      additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation site =
        (2 : Real) • nullWaveCurvature site := by
    funext a b
    exact additivePlaquetteCurl_plusBackreactionLinkVariation site a b
  have hCrossCurl :
      additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation site =
        crossBackreactionCurvature site := by
    funext a b
    exact additivePlaquetteCurl_crossBackreactionLinkVariation site a b
  rw [hPlusCurl, hCrossCurl]
  change plusScale *
        (mixedVacuumEinsteinEntryLinear
          (1 : Matrix (Fin 4) (Fin 4) Real)
          coframeDirection raisedDirection
          ((2 : Real) • nullWaveCurvature site)) +
      crossScale * mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        coframeDirection raisedDirection = 0
  rw [map_smul]
  change plusScale *
        ((2 : Real) * mixedVacuumEinsteinEntry
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (nullWaveCurvature site)
          coframeDirection raisedDirection) +
      crossScale * mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        coframeDirection raisedDirection = 0
  rw [nullWaveCurvature_mixedVacuum,
    crossBackreactionCurvature_mixedVacuum]
  ring

/-- Every real plus/cross combination satisfies all thirty-two linearized
coframe/Einstein equations. -/
theorem plusCrossCombination_coframeStationary
    (plusScale crossScale : Real) :
    LinearizedCoframeStationary nullWaveShift
      (plusCrossLinkCombination plusScale crossScale) := by
  intro site internal direction
  unfold linearizedCoframeEulerCoefficient
  rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (inverseCoframe := (1 : Matrix (Fin 4) (Fin 4) Real))]
  · have hMixed : forall coframeDirection raisedDirection,
        2 * mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
              (additivePlaquetteCurl nullWaveShift
                (plusCrossLinkCombination plusScale crossScale) site)
              coframeDirection raisedDirection -
            (1 : Matrix (Fin 4) (Fin 4) Real)
                raisedDirection coframeDirection *
              inverseCoframeScalarCurvature
                (1 : Matrix (Fin 4) (Fin 4) Real)
                (additivePlaquetteCurl nullWaveShift
                  (plusCrossLinkCombination plusScale crossScale) site) = 0 := by
      intro coframeDirection raisedDirection
      simpa [mixedVacuumEinsteinEntry] using
        plusCrossCombinationCurvature_mixedVacuum
          plusScale crossScale site coframeDirection raisedDirection
    have hCoefficient :=
      (mixedEinsteinCoframeCoefficient_vanish_iff
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination plusScale crossScale) site)
        (by simp) (by simp)).2 hMixed
    simp only [Matrix.det_one, one_mul]
    apply Finset.sum_eq_zero
    intro coefficientInternal _
    apply Finset.sum_eq_zero
    intro coefficientDirection _
    rw [hCoefficient coefficientInternal coefficientDirection]
    ring
  · simp
  · exact additivePlaquetteCurl_antisymmetric_local
      nullWaveShift (plusCrossLinkCombination plusScale crossScale) site

/-- The plus/cross span is a two-parameter family in the full joint
linearized Palatini kernel. -/
theorem plusCrossCombination_jointStationary
    (plusScale crossScale : Real) :
    LinearizedJointStationary nullWaveShift
      (plusCrossLinkCombination plusScale crossScale)
      (plusCrossCoframeCombination plusScale crossScale) :=
  ⟨plusCrossCombination_linkStationary plusScale crossScale,
    plusCrossCombination_coframeStationary plusScale crossScale⟩

/-- At site zero, the plus and cross curvatures have independent coordinate
projections, so a zero combination has zero coefficients. -/
theorem plusCrossCurvature_coefficients_zero
    (plusScale crossScale : Real)
    (hZero :
      plusScale •
          additivePlaquetteCurl nullWaveShift
            plusBackreactionLinkVariation 0 +
        crossScale •
          additivePlaquetteCurl nullWaveShift
            crossBackreactionLinkVariation 0 = 0) :
    plusScale = 0 ∧ crossScale = 0 := by
  have hPlus := congrFun (congrFun (congrFun hZero 0) 1) 1
  have hCross := congrFun (congrFun (congrFun hZero 0) 1) 2
  simp +decide [additivePlaquetteCurl, plusBackreactionLinkVariation,
    crossBackreactionLinkVariation, nullWaveShift, toggleFinTwo,
    nullWaveAmplitude, nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo] at hPlus hCross
  norm_num at hPlus
  exact ⟨hPlus, hCross⟩

/-- No nonzero plus/cross curvature combination belongs to the flat
infinitesimal local Lorentz orbit. This is the exact gauge-quotient
independence statement for the two displayed polarizations. -/
theorem plusCrossCombination_not_infinitesimalGauge
    (plusScale crossScale : Real)
    (hNonzero : plusScale ≠ 0 ∨ crossScale ≠ 0)
    (parameter : NullWaveSite -> Fiber 6) :
    nullWaveInfinitesimalGaugePair parameter ≠
      (plusCrossLinkCombination plusScale crossScale,
        plusCrossCoframeCombination plusScale crossScale) := by
  intro hPair
  have hLink :
      infinitesimalGaugeLinkVariation nullWaveShift parameter =
        plusCrossLinkCombination plusScale crossScale :=
    congrArg Prod.fst hPair
  have hGaugeCurl :
      additivePlaquetteCurl nullWaveShift
          (infinitesimalGaugeLinkVariation nullWaveShift parameter) 0 = 0 := by
    funext a b
    exact additivePlaquetteCurl_infinitesimalGaugeLinkVariation
      nullWaveShift nullWaveShift_commute parameter 0 a b
  have hCombinationCurl :
      additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination plusScale crossScale) 0 = 0 := by
    rw [<- hLink]
    exact hGaugeCurl
  rw [additivePlaquetteCurl_plusCrossLinkCombination] at hCombinationCurl
  have hCoefficients := plusCrossCurvature_coefficients_zero
    plusScale crossScale hCombinationCurl
  exact hNonzero.elim (fun h => h hCoefficients.1)
    (fun h => h hCoefficients.2)

/-- The curved plus-like stationary mode survives quotienting by the
infinitesimal local Lorentz orbit. -/
theorem plusBackreaction_not_infinitesimalGauge
    (parameter : NullWaveSite -> Fiber 6) :
    nullWaveInfinitesimalGaugePair parameter ≠
      (plusBackreactionLinkVariation,
        plusBackreactionCoframeVariation) := by
  intro hPair
  have hLink :
      infinitesimalGaugeLinkVariation nullWaveShift parameter =
        plusBackreactionLinkVariation :=
    congrArg Prod.fst hPair
  have hGaugeCurl :
      additivePlaquetteCurl nullWaveShift
          (infinitesimalGaugeLinkVariation nullWaveShift parameter) 0 = 0 := by
    funext a b
    exact additivePlaquetteCurl_infinitesimalGaugeLinkVariation
      nullWaveShift nullWaveShift_commute parameter 0 a b
  have hPlusCurl :
      additivePlaquetteCurl nullWaveShift
          plusBackreactionLinkVariation 0 = 0 := by
    rw [<- hLink]
    exact hGaugeCurl
  exact plusBackreaction_curvature_ne_zero 0 hPlusCurl

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusBackreaction_curvature_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusBackreaction_curvature_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusBackreaction_jointStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusBackreaction_jointStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.nullWave_infinitesimalGauge_jointStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWave_infinitesimalGauge_jointStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.nullWaveInfinitesimalGaugePair_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveInfinitesimalGaugePair_injective

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusBackreaction_not_infinitesimalGauge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusBackreaction_not_infinitesimalGauge

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.crossBackreactionCurvature_mixedVacuum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms crossBackreactionCurvature_mixedVacuum

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.crossBackreaction_jointStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms crossBackreaction_jointStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusCrossCombination_not_infinitesimalGauge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusCrossCombination_not_infinitesimalGauge

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusCrossCombination_jointStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusCrossCombination_jointStationary

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction
