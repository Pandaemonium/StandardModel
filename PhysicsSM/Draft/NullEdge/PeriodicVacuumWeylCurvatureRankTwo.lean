import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompleteness

noncomputable section

/-!
# Exact rank-two stationary curvature image

This module packages curvature completeness with the explicit plus/cross
stationary witnesses.  The complete curvature image of the two-site joint
linearized Palatini kernel is parametrized injectively by two real numbers.

Claim label: exact finite linearized curvature-image theorem.  Originality
tag: `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureRankTwo

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompleteness
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-- The plus/cross coefficient pair is recovered uniquely from curvature. -/
theorem plusCross_additivePlaquetteCurl_injective :
    Function.Injective (fun scales : Real × Real =>
      additivePlaquetteCurl nullWaveShift
        (plusCrossLinkCombination scales.1 scales.2)) := by
  intro left right hCurvature
  have hPlus := congrFun (congrFun (congrFun (congrFun hCurvature 0) 0) 1) 1
  have hCross := congrFun (congrFun (congrFun (congrFun hCurvature 0) 0) 1) 2
  apply Prod.ext
  · simp +decide [plusCrossLinkCombination,
      plusBackreactionLinkVariation, crossBackreactionLinkVariation,
      additivePlaquetteCurl, nullWaveShift, toggleFinTwo,
      nullWaveAmplitude, nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo] at hPlus
    linarith
  · simp +decide [plusCrossLinkCombination,
      plusBackreactionLinkVariation, crossBackreactionLinkVariation,
      additivePlaquetteCurl, nullWaveShift, toggleFinTwo,
      nullWaveAmplitude, nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo] at hCross
    linarith

/-- Every jointly stationary curvature has a unique plus/cross coordinate
pair. -/
theorem jointStationary_additivePlaquetteCurl_existsUnique_plusCross
    (linkVariation : LinkVariation NullWaveSite)
    (coframeVariation : CoframeField NullWaveSite)
    (hStationary : LinearizedJointStationary nullWaveShift
      linkVariation coframeVariation) :
    ∃! scales : Real × Real,
      additivePlaquetteCurl nullWaveShift linkVariation =
        additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination scales.1 scales.2) := by
  refine ⟨(nullWaveCurvaturePlusScale linkVariation,
      nullWaveCurvatureCrossScale linkVariation),
    jointStationary_additivePlaquetteCurl_eq_plusCross
      linkVariation coframeVariation hStationary, ?_⟩
  intro scales hScales
  apply plusCross_additivePlaquetteCurl_injective
  calc
    additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination scales.1 scales.2) =
        additivePlaquetteCurl nullWaveShift linkVariation := hScales.symm
    _ = additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination
            (nullWaveCurvaturePlusScale linkVariation)
            (nullWaveCurvatureCrossScale linkVariation)) :=
      jointStationary_additivePlaquetteCurl_eq_plusCross
        linkVariation coframeVariation hStationary

/-- The set of curvatures carried by the full joint stationary kernel is
exactly the range of the injective two-parameter plus/cross curvature map. -/
theorem jointStationary_curvature_image_eq_plusCross_range :
    {curvature |
      exists linkVariation coframeVariation,
        LinearizedJointStationary nullWaveShift
          linkVariation coframeVariation /\
        additivePlaquetteCurl nullWaveShift linkVariation = curvature} =
      Set.range (fun scales : Real × Real =>
        additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination scales.1 scales.2)) := by
  ext curvature
  constructor
  · rintro ⟨linkVariation, coframeVariation, hStationary, rfl⟩
    exact ⟨(nullWaveCurvaturePlusScale linkVariation,
        nullWaveCurvatureCrossScale linkVariation),
      (jointStationary_additivePlaquetteCurl_eq_plusCross
        linkVariation coframeVariation hStationary).symm⟩
  · rintro ⟨scales, rfl⟩
    exact ⟨plusCrossLinkCombination scales.1 scales.2,
      plusCrossCoframeCombination scales.1 scales.2,
      plusCrossCombination_jointStationary scales.1 scales.2, rfl⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureRankTwo.plusCross_additivePlaquetteCurl_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusCross_additivePlaquetteCurl_injective

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureRankTwo.jointStationary_additivePlaquetteCurl_existsUnique_plusCross' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms jointStationary_additivePlaquetteCurl_existsUnique_plusCross

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureRankTwo.jointStationary_curvature_image_eq_plusCross_range' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms jointStationary_curvature_image_eq_plusCross_range

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureRankTwo
