import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylMeanObstruction

noncomputable section

/-!
# A periodically exact null-wave vacuum-Weyl curvature

The periodic mean and Bianchi obstruction rules out a site-independent Weyl
tensor and every site-varying member of the fixed-eigenplane diagonal family.
This module gives the first constructive escape at additive order.

The carrier has two sites.  The time and longitudinal directions use the same
period-two shift, while the two transverse directions act trivially.  A link
potential in the transverse directions uses two null-rotation bivectors.  Its
additive curl is the plus-polarized null-wave tensor

`R = amplitude * (P1_lower tensor P1_upper - P2_lower tensor P2_upper)`

in repository coordinates.  The amplitude is a periodic forward difference,
so it is nonzero at both sites with opposite signs and has zero mean.

At each site the resulting curvature is nonzero, face-antisymmetric,
metric-lowered pair symmetric, algebraic-first-Bianchi, and exactly Ricci,
scalar, and mixed-Einstein flat at the identity coframe.  It is also, by
definition, the additive curl of the displayed periodic link potential and
therefore obeys the discrete differential Bianchi identity.

This is a finite linearized curvature witness.  It is not yet a jointly
stationary nonlinear proper-Lorentz plaquette solution, a Levi-Civita
connection of a varying coframe, or a graph-derived refinement.  The null-wave
ansatz and its Ricci-flat tensor structure are standard `[import]`; the exact
two-site realization and convention-locked Lean audit are `[orig/comp]`.
Claim label: finite identity and linearized consistency witness.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave

open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylMeanObstruction
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement
open PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget

/-- Minimal period-two carrier for the null-wave amplitude. -/
abbrev NullWaveSite := Fin 2

/-- Time and the longitudinal direction advance the same null coordinate;
the two transverse shifts are identities. -/
def nullWaveShift : Fin 4 -> Equiv NullWaveSite NullWaveSite :=
  ![toggleFinTwo, Equiv.refl _, Equiv.refl _, toggleFinTwo]

/-- The four null-wave carrier shifts commute. -/
theorem nullWaveShift_commute : ShiftsCommute nullWaveShift := by
  intro site a b
  fin_cases site <;> fin_cases a <;> fin_cases b <;>
    simp [nullWaveShift, toggleFinTwo]

/-- A period-two scalar potential with values zero and one. -/
def nullWavePotential (site : NullWaveSite) : Real :=
  if site = 0 then 0 else 1

/-- First null-rotation bivector, with nonzero contravariant entries
`P1^(01)=P1^(13)=-1`. -/
def nullWavePolarizationOne : Fiber 6 :=
  ![0, -1, 0, -1, 0, 0]

/-- Minus the second null-rotation bivector, implementing plus polarization;
its nonzero contravariant entries are `-P2^(02)=-P2^(23)=1`. -/
def nullWavePolarizationTwo : Fiber 6 :=
  ![0, 0, 1, 0, 1, 0]

/-- Periodic transverse link potential. -/
def nullWaveLinkVariation : LinkVariation NullWaveSite :=
  fun site direction =>
    if direction = 1 then
      nullWavePotential site • nullWavePolarizationOne
    else if direction = 2 then
      nullWavePotential site • nullWavePolarizationTwo
    else 0

/-- Periodic forward-difference amplitude. -/
def nullWaveAmplitude (site : NullWaveSite) : Real :=
  nullWavePotential (toggleFinTwo site) - nullWavePotential site

/-- Lower-index spacetime face bivector for the first transverse
polarization. -/
def nullWaveFaceOne : Matrix (Fin 4) (Fin 4) Real :=
  !![0, 1, 0, 0;
     -1, 0, 0, -1;
     0, 0, 0, 0;
     0, 1, 0, 0]

/-- Lower-index spacetime face bivector for the second transverse
polarization. -/
def nullWaveFaceTwo : Matrix (Fin 4) (Fin 4) Real :=
  !![0, 0, 1, 0;
     0, 0, 0, 0;
     -1, 0, 0, -1;
     0, 0, 1, 0]

/-- Explicit plus-polarized null-wave curvature.  The second stored internal
bivector already carries the minus sign between the two polarizations. -/
def nullWaveCurvature :
    NullWaveSite -> Fin 4 -> Fin 4 -> Fiber 6 :=
  fun site a b component =>
    nullWaveAmplitude site *
      (nullWaveFaceOne a b * nullWavePolarizationOne component +
        nullWaveFaceTwo a b * nullWavePolarizationTwo component)

set_option maxHeartbeats 1000000 in
/-- The null-wave curvature is exactly periodically additive-realized. -/
theorem nullWaveCurvature_hasPeriodicAdditiveLinkRealization :
    HasPeriodicAdditiveLinkRealization nullWaveShift nullWaveCurvature := by
  refine ⟨nullWaveLinkVariation, ?_⟩
  intro site a b
  funext component
  fin_cases a <;> fin_cases b <;>
    simp [nullWaveCurvature, nullWaveAmplitude, nullWaveFaceOne,
      nullWaveFaceTwo, additivePlaquetteCurl, nullWaveShift,
      nullWaveLinkVariation, nullWavePolarizationOne,
      nullWavePolarizationTwo, toggleFinTwo] <;> ring

/-- The wave has opposite unit amplitudes at the two sites and is nonzero at
both. -/
theorem nullWaveCurvature_ne_zero (site : NullWaveSite) :
    nullWaveCurvature site ≠ 0 := by
  intro hZero
  have hEntry := congrFun (congrFun (congrFun hZero 0) 1) 3
  fin_cases site <;>
    norm_num [nullWaveCurvature, nullWaveAmplitude, nullWaveFaceOne,
      nullWaveFaceTwo, nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo, toggleFinTwo] at hEntry
  all_goals simp at hEntry

/-- Face orientation reversal negates the null-wave curvature. -/
theorem nullWaveCurvature_antisymmetric (site : NullWaveSite) :
    forall a b component,
      nullWaveCurvature site b a component =
        -nullWaveCurvature site a b component := by
  intro a b component
  fin_cases a <;> fin_cases b <;>
    norm_num [nullWaveCurvature, nullWaveFaceOne, nullWaveFaceTwo]

/-- Raw contravariant internal matrix of the null-wave curvature. -/
theorem bivectorMatrix_nullWaveCurvature
    (site : NullWaveSite) (a b i j : Fin 4) :
    bivectorMatrix (nullWaveCurvature site a b) i j =
      nullWaveAmplitude site *
        (nullWaveFaceOne a b *
            bivectorMatrix nullWavePolarizationOne i j +
          nullWaveFaceTwo a b *
            bivectorMatrix nullWavePolarizationTwo i j) := by
  fin_cases i <;> fin_cases j <;>
    simp +decide [nullWaveCurvature, bivectorMatrix,
      nullWavePolarizationOne, nullWavePolarizationTwo]

set_option maxHeartbeats 1000000 in
/-- After lowering both internal indices, the curvature is the difference of
two symmetric rank-one bivector tensors. -/
theorem loweredBivectorMatrix_nullWaveCurvature
    (site : NullWaveSite) (a b i j : Fin 4) :
    loweredBivectorMatrix (nullWaveCurvature site a b) i j =
      nullWaveAmplitude site *
        (nullWaveFaceOne a b * nullWaveFaceOne i j -
          nullWaveFaceTwo a b * nullWaveFaceTwo i j) := by
  rw [loweredBivectorMatrix_apply]
  rw [bivectorMatrix_nullWaveCurvature]
  fin_cases i <;> fin_cases j <;>
    simp +decide [nullWaveFaceOne, nullWaveFaceTwo,
      nullWavePolarizationOne, nullWavePolarizationTwo, bivectorMatrix,
      MinkowskiConvention.eta]

/-- The null-wave curvature has metric-correct Riemann pair exchange at each
site. -/
theorem nullWaveCurvature_pairExchange (site : NullWaveSite) :
    CurvaturePairExchangeSymmetric (nullWaveCurvature site) := by
  intro a b i j
  rw [loweredBivectorMatrix_nullWaveCurvature,
    loweredBivectorMatrix_nullWaveCurvature]
  ring

set_option maxHeartbeats 3000000 in
/-- The null-wave curvature obeys algebraic first Bianchi at each site. -/
theorem nullWaveCurvature_firstBianchi (site : NullWaveSite) :
    CurvatureFirstBianchi (nullWaveCurvature site) := by
  intro a b c d
  rw [loweredBivectorMatrix_nullWaveCurvature,
    loweredBivectorMatrix_nullWaveCurvature,
    loweredBivectorMatrix_nullWaveCurvature]
  fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
    norm_num [nullWaveFaceOne, nullWaveFaceTwo]

/-- At identity coframe, the mixed Ricci contraction keeps only the diagonal
internal/spacetime contraction. -/
theorem mixedRicciCurvature_identity
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (coframeDirection raisedDirection : Fin 4) :
    mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
        curvature coframeDirection raisedDirection =
      Finset.sum Finset.univ (fun b =>
        bivectorMatrix (curvature coframeDirection b) raisedDirection b) := by
  simp [mixedRicciCurvature, Matrix.one_apply, Fin.sum_univ_four]

/-- The two null polarizations cancel under the Ricci contraction. -/
theorem nullWaveRicciContraction_cancel
    (coframeDirection raisedDirection : Fin 4) :
    Finset.sum Finset.univ (fun b =>
      nullWaveFaceOne coframeDirection b *
          bivectorMatrix nullWavePolarizationOne raisedDirection b +
        nullWaveFaceTwo coframeDirection b *
          bivectorMatrix nullWavePolarizationTwo raisedDirection b) = 0 := by
  fin_cases coframeDirection <;> fin_cases raisedDirection <;>
    simp +decide [nullWaveFaceOne, nullWaveFaceTwo,
      nullWavePolarizationOne, nullWavePolarizationTwo, bivectorMatrix,
      Fin.sum_univ_four]

/-- Every mixed Ricci entry of the null wave vanishes at the identity inverse
coframe. -/
theorem nullWaveCurvature_mixedRicci_zero
    (site : NullWaveSite) (coframeDirection raisedDirection : Fin 4) :
    mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
        (nullWaveCurvature site) coframeDirection raisedDirection = 0 := by
  rw [mixedRicciCurvature_identity]
  simp_rw [bivectorMatrix_nullWaveCurvature]
  rw [<- Finset.mul_sum, nullWaveRicciContraction_cancel]
  ring

/-- The null-wave scalar curvature vanishes at the identity inverse coframe.
-/
theorem nullWaveCurvature_scalar_zero (site : NullWaveSite) :
    inverseCoframeScalarCurvature
        (1 : Matrix (Fin 4) (Fin 4) Real) (nullWaveCurvature site) = 0 := by
  rw [show inverseCoframeScalarCurvature
        (1 : Matrix (Fin 4) (Fin 4) Real) (nullWaveCurvature site) =
      Finset.sum Finset.univ (fun direction =>
        mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
          (nullWaveCurvature site) direction direction) by
    simp [inverseCoframeScalarCurvature, mixedRicciCurvature,
      Matrix.one_apply, Fin.sum_univ_four]]
  simp [nullWaveCurvature_mixedRicci_zero]

/-- Hence all mixed vacuum Einstein entries vanish pointwise for the null
wave. -/
theorem nullWaveCurvature_mixedVacuum
    (site : NullWaveSite) (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (nullWaveCurvature site) coframeDirection raisedDirection = 0 := by
  rw [mixedVacuumEinsteinEntry, nullWaveCurvature_mixedRicci_zero,
    nullWaveCurvature_scalar_zero]
  ring

/-- Each wave site packages a nonzero algebraic vacuum-Riemann target. -/
def nullWaveVacuumRiemannTarget
    (site : NullWaveSite) : IdentityCoframeVacuumRiemannTarget where
  curvature := nullWaveCurvature site
  nonzero := nullWaveCurvature_ne_zero site
  face_antisymmetric := nullWaveCurvature_antisymmetric site
  pair_exchange := nullWaveCurvature_pairExchange site
  first_bianchi := nullWaveCurvature_firstBianchi site
  ricci_zero := nullWaveCurvature_mixedRicci_zero site
  scalar_zero := nullWaveCurvature_scalar_zero site
  mixed_vacuum := nullWaveCurvature_mixedVacuum site

/-- Every ordered face/component of the wave has zero total over the periodic
carrier. -/
theorem nullWaveCurvature_face_sum_zero
    (a b : Fin 4) (component : Fin 6) :
    Finset.sum Finset.univ (fun site =>
      nullWaveCurvature site a b component) = 0 :=
  periodicAdditiveLinkRealization_face_sum_zero
    nullWaveShift nullWaveCurvature
    nullWaveCurvature_hasPeriodicAdditiveLinkRealization a b component

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave.nullWaveCurvature_pairExchange' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveCurvature_pairExchange

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave.nullWaveCurvature_mixedVacuum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveCurvature_mixedVacuum

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave.nullWaveVacuumRiemannTarget' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveVacuumRiemannTarget

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
