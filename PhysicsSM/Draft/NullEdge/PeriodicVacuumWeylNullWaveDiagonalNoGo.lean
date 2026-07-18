import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveAxialNoGo

noncomputable section

/-!
# Diagonal-coframe no-go for the periodic vacuum null wave

This module closes the complete invertible diagonal ansatz for the exact
proper-Lorentz two-site null wave.  Four displayed mixed Einstein entries force
each sitewise diagonal tetrad into the axial shape `diag(A,B,B,A)`.  The axial
connection no-go then proves that no nonzero-area member can be jointly
stationary.

The result is exact and finite.  It does not exclude off-diagonal shear or
local Lorentz-rotated coframes.  The all-component symbolic audit in
`Scripts/oracle/null_wave_diagonal_euler.py` is an external cross-check only;
the declarations here are proved independently in Lean.  Claim labels: finite
identity and finite no-go.  Originality tag: `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveDiagonalNoGo

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveAxialNoGo

/-- General diagonal coframe on the two-site null-wave carrier. -/
def nullWaveDiagonalCoframe
    (scale : NullWaveSite -> Fin 4 -> Real) : CoframeField NullWaveSite :=
  fun site => Matrix.diagonal (scale site)

/-- Pointwise inverse candidate for a nondegenerate diagonal coframe. -/
def nullWaveDiagonalInverseCoframe
    (scale : NullWaveSite -> Fin 4 -> Real) : CoframeField NullWaveSite :=
  fun site => Matrix.diagonal (fun direction => (scale site direction)⁻¹)

/-- The inverse candidate is exact when every diagonal entry is nonzero. -/
theorem nullWaveDiagonalInverseCoframe_mul
    (scale : NullWaveSite -> Fin 4 -> Real)
    (hScale : forall site direction, Not (scale site direction = 0)) :
    forall site,
      nullWaveDiagonalInverseCoframe scale site *
          nullWaveDiagonalCoframe scale site = 1 := by
  intro site
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nullWaveDiagonalInverseCoframe, nullWaveDiagonalCoframe,
      Matrix.mul_apply, Fin.sum_univ_four, hScale site]

/-- Site `0`, `00` mixed Einstein entry for a diagonal inverse coframe. -/
theorem nullWaveDiagonal_mixedEinstein_zero_zero_site_zero
    (scale : NullWaveSite -> Fin 4 -> Real) :
    mixedVacuumEinsteinEntry
        (nullWaveDiagonalInverseCoframe scale 0)
        (nullWaveCurvature 0) 0 0 =
      2 * (scale 0 3)⁻¹ * ((scale 0 2)⁻¹ - (scale 0 1)⁻¹) := by
  simp +decide [mixedVacuumEinsteinEntry, mixedRicciCurvature,
    inverseCoframeScalarCurvature, nullWaveDiagonalInverseCoframe,
    nullWaveCurvature, nullWaveAmplitude, nullWaveFaceOne,
    nullWaveFaceTwo, nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, bivectorMatrix, Fin.sum_univ_four]
  ring

/-- Site `0`, `11` mixed Einstein entry for a diagonal inverse coframe. -/
theorem nullWaveDiagonal_mixedEinstein_one_one_site_zero
    (scale : NullWaveSite -> Fin 4 -> Real) :
    mixedVacuumEinsteinEntry
        (nullWaveDiagonalInverseCoframe scale 0)
        (nullWaveCurvature 0) 1 1 =
      2 * (scale 0 2)⁻¹ * ((scale 0 3)⁻¹ - (scale 0 0)⁻¹) := by
  simp +decide [mixedVacuumEinsteinEntry, mixedRicciCurvature,
    inverseCoframeScalarCurvature, nullWaveDiagonalInverseCoframe,
    nullWaveCurvature, nullWaveAmplitude, nullWaveFaceOne,
    nullWaveFaceTwo, nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, bivectorMatrix, Fin.sum_univ_four]
  ring

/-- Site `1`, `00` mixed Einstein entry for a diagonal inverse coframe. -/
theorem nullWaveDiagonal_mixedEinstein_zero_zero_site_one
    (scale : NullWaveSite -> Fin 4 -> Real) :
    mixedVacuumEinsteinEntry
        (nullWaveDiagonalInverseCoframe scale 1)
        (nullWaveCurvature 1) 0 0 =
      -2 * (scale 1 3)⁻¹ * ((scale 1 2)⁻¹ - (scale 1 1)⁻¹) := by
  simp +decide [mixedVacuumEinsteinEntry, mixedRicciCurvature,
    inverseCoframeScalarCurvature, nullWaveDiagonalInverseCoframe,
    nullWaveCurvature, nullWaveAmplitude, nullWaveFaceOne,
    nullWaveFaceTwo, nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, bivectorMatrix, Fin.sum_univ_four]
  ring

/-- Site `1`, `11` mixed Einstein entry for a diagonal inverse coframe. -/
theorem nullWaveDiagonal_mixedEinstein_one_one_site_one
    (scale : NullWaveSite -> Fin 4 -> Real) :
    mixedVacuumEinsteinEntry
        (nullWaveDiagonalInverseCoframe scale 1)
        (nullWaveCurvature 1) 1 1 =
      -2 * (scale 1 2)⁻¹ * ((scale 1 3)⁻¹ - (scale 1 0)⁻¹) := by
  simp +decide [mixedVacuumEinsteinEntry, mixedRicciCurvature,
    inverseCoframeScalarCurvature, nullWaveDiagonalInverseCoframe,
    nullWaveCurvature, nullWaveAmplitude, nullWaveFaceOne,
    nullWaveFaceTwo, nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, bivectorMatrix, Fin.sum_univ_four]
  ring

private theorem eq_of_area_mul_inv_difference_eq_zero
    (area coefficient left right : Real)
    (hArea : Not (area = 0)) (hCoefficient : Not (coefficient = 0))
    (hZero : area * (coefficient * (left⁻¹ - right⁻¹)) = 0) :
    left = right := by
  have hProduct := (mul_eq_zero.mp hZero).resolve_left hArea
  have hDifference :=
    (mul_eq_zero.mp hProduct).resolve_left hCoefficient
  exact inv_injective (sub_eq_zero.mp hDifference)

/-- Coframe stationarity at nonzero area forces every invertible diagonal
coframe into the axial shape selected by the null wave. -/
theorem nullWaveDiagonal_coframeStationary_imp_axial
    (area : Nat -> Real) (n : Nat)
    (scale : NullWaveSite -> Fin 4 -> Real)
    (hArea : Not (area n = 0))
    (hScale : forall site direction, Not (scale site direction = 0))
    (hStationary : NonlinearCoframePlaquetteCoframeStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveDiagonalCoframe scale)) :
    forall site,
      scale site 0 = scale site 3 /\ scale site 1 = scale site 2 := by
  have hEinstein :=
    (nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
      nullWaveShift (nullWaveLorentzConnection area n)
      (nullWaveDiagonalCoframe scale)
      (nullWaveDiagonalInverseCoframe scale)
      (nullWaveDiagonalInverseCoframe_mul scale hScale)).1 hStationary
  have h00SiteZero := hEinstein 0 0 0
  have h11SiteZero := hEinstein 0 1 1
  have h00SiteOne := hEinstein 1 0 0
  have h11SiteOne := hEinstein 1 1 1
  have hExtracted : forall site,
      extractedPlaquetteCurvature nullWaveShift
          (nullWaveLorentzConnection area n) site =
        area n • nullWaveCurvature site := by
    intro site
    funext a b component
    exact congrFun
      (extractedPlaquetteCurvature_nullWaveLorentzConnection
        area n site a b) component
  rw [hExtracted] at h00SiteZero h11SiteZero h00SiteOne h11SiteOne
  change mixedVacuumEinsteinEntryLinear
      (nullWaveDiagonalInverseCoframe scale 0) 0 0
      (area n • nullWaveCurvature 0) = 0 at h00SiteZero
  change mixedVacuumEinsteinEntryLinear
      (nullWaveDiagonalInverseCoframe scale 0) 1 1
      (area n • nullWaveCurvature 0) = 0 at h11SiteZero
  change mixedVacuumEinsteinEntryLinear
      (nullWaveDiagonalInverseCoframe scale 1) 0 0
      (area n • nullWaveCurvature 1) = 0 at h00SiteOne
  change mixedVacuumEinsteinEntryLinear
      (nullWaveDiagonalInverseCoframe scale 1) 1 1
      (area n • nullWaveCurvature 1) = 0 at h11SiteOne
  rw [map_smul] at h00SiteZero h11SiteZero h00SiteOne h11SiteOne
  change area n * mixedVacuumEinsteinEntry
      (nullWaveDiagonalInverseCoframe scale 0)
      (nullWaveCurvature 0) 0 0 = 0 at h00SiteZero
  change area n * mixedVacuumEinsteinEntry
      (nullWaveDiagonalInverseCoframe scale 0)
      (nullWaveCurvature 0) 1 1 = 0 at h11SiteZero
  change area n * mixedVacuumEinsteinEntry
      (nullWaveDiagonalInverseCoframe scale 1)
      (nullWaveCurvature 1) 0 0 = 0 at h00SiteOne
  change area n * mixedVacuumEinsteinEntry
      (nullWaveDiagonalInverseCoframe scale 1)
      (nullWaveCurvature 1) 1 1 = 0 at h11SiteOne
  rw [nullWaveDiagonal_mixedEinstein_zero_zero_site_zero] at h00SiteZero
  rw [nullWaveDiagonal_mixedEinstein_one_one_site_zero] at h11SiteZero
  rw [nullWaveDiagonal_mixedEinstein_zero_zero_site_one] at h00SiteOne
  rw [nullWaveDiagonal_mixedEinstein_one_one_site_one] at h11SiteOne
  have hTransverseZero : scale 0 1 = scale 0 2 :=
    (eq_of_area_mul_inv_difference_eq_zero
      (area n) (2 * (scale 0 3)⁻¹) (scale 0 2) (scale 0 1)
      hArea (mul_ne_zero (by norm_num) (inv_ne_zero (hScale 0 3)))
      h00SiteZero).symm
  have hLongitudinalZero : scale 0 0 = scale 0 3 :=
    (eq_of_area_mul_inv_difference_eq_zero
      (area n) (2 * (scale 0 2)⁻¹) (scale 0 3) (scale 0 0)
      hArea (mul_ne_zero (by norm_num) (inv_ne_zero (hScale 0 2)))
      h11SiteZero).symm
  have hTransverseOne : scale 1 1 = scale 1 2 :=
    (eq_of_area_mul_inv_difference_eq_zero
      (area n) (-2 * (scale 1 3)⁻¹) (scale 1 2) (scale 1 1)
      hArea (mul_ne_zero (by norm_num) (inv_ne_zero (hScale 1 3)))
      h00SiteOne).symm
  have hLongitudinalOne : scale 1 0 = scale 1 3 :=
    (eq_of_area_mul_inv_difference_eq_zero
      (area n) (-2 * (scale 1 2)⁻¹) (scale 1 3) (scale 1 0)
      hArea (mul_ne_zero (by norm_num) (inv_ne_zero (hScale 1 2)))
      h11SiteOne).symm
  intro site
  fin_cases site
  · exact And.intro hLongitudinalZero hTransverseZero
  · exact And.intro hLongitudinalOne hTransverseOne

/-- A diagonal coframe satisfying the axial equalities is exactly the
corresponding axial coframe field. -/
theorem nullWaveDiagonalCoframe_eq_axial
    (scale : NullWaveSite -> Fin 4 -> Real)
    (hAxial : forall site,
      scale site 0 = scale site 3 /\ scale site 1 = scale site 2) :
    nullWaveDiagonalCoframe scale =
      nullWaveAxialCoframe (fun site => scale site 0)
        (fun site => scale site 1) := by
  funext site i j
  have hSite := hAxial site
  fin_cases i <;> fin_cases j <;>
    simp [nullWaveDiagonalCoframe, nullWaveAxialCoframe,
      hSite.1, hSite.2]

/-- **Complete diagonal no-go.** No pointwise invertible diagonal coframe is
jointly stationary with the exact proper-Lorentz null wave at nonzero area. -/
theorem nullWaveDiagonal_not_jointStationary
    (area : Nat -> Real) (n : Nat)
    (scale : NullWaveSite -> Fin 4 -> Real)
    (hArea : Not (area n = 0))
    (hScale : forall site direction, Not (scale site direction = 0)) :
    Not (NonlinearCoframePlaquetteJointStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (nullWaveDiagonalCoframe scale)) := by
  intro hJoint
  have hAxial := nullWaveDiagonal_coframeStationary_imp_axial
    area n scale hArea hScale hJoint.2
  have hCoframe := nullWaveDiagonalCoframe_eq_axial scale hAxial
  have hConnection :
      NonlinearCoframePlaquetteConnectionStationary nullWaveShift
        (nullWaveLorentzConnection area n)
        (nullWaveAxialCoframe (fun site => scale site 0)
          (fun site => scale site 1)) := by
    rw [<- hCoframe]
    exact hJoint.1
  exact (nullWaveAxial_not_connectionStationary area n
    (fun site => scale site 0) (fun site => scale site 1)
    hArea (hScale 1 0)) hConnection

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveDiagonalNoGo.nullWaveDiagonal_coframeStationary_imp_axial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveDiagonal_coframeStationary_imp_axial

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveDiagonalNoGo.nullWaveDiagonal_not_jointStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveDiagonal_not_jointStationary

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveDiagonalNoGo
