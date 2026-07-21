import PhysicsSM.Draft.NullEdge.FiniteTransferPositivity
import PhysicsSM.Draft.NullEdge.FiniteHamiltonianTransferPole
import PhysicsSM.Draft.NullEdge.PlueckerPositiveEnergyTransfer
import PhysicsSM.Draft.NullEdge.PlueckerOSHankelKernel
import PhysicsSM.Draft.NullEdge.FiniteOSReflectionPositivity
import PhysicsSM.Draft.NullEdge.SU3PlaquetteObservable
import PhysicsSM.Draft.NullEdge.GapPoleGeneralObstruction
import PhysicsSM.Draft.NullEdge.NeutrinoMassClassification
import PhysicsSM.Draft.NullEdge.MixedPseudoDiracBranch
import PhysicsSM.Draft.NullEdge.MixedPseudoDiracPhysicalMass
import PhysicsSM.Draft.NullEdge.ObservableGapLinkage
import PhysicsSM.Draft.NullEdge.CorrectedReadingsAudit
import PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial

/-!
# Origin-of-mass batch axiom guards

Build-enforced assumption-footprint pins for the finite transfer, observable,
readout-obstruction, and neutrino-classification modules landed in the
2026-07-20/21 origin-of-mass campaign.
-/

/-- info: 'FiniteTransfer.gram_posDef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteTransfer.gram_posDef

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteHamiltonianTransferPole.visible_mode_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteHamiltonianTransferPole.visible_mode_chain

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPositiveEnergyTransfer.pluecker_positive_mode_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerPositiveEnergyTransfer.pluecker_positive_mode_chain

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPositiveEnergyTransfer.negativeRestFactor_gt_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerPositiveEnergyTransfer.negativeRestFactor_gt_one

/-- info: 'PlueckerOSHankelKernel.plueckerDecayKernel_posSemidef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PlueckerOSHankelKernel.plueckerDecayKernel_posSemidef

/-- info: 'PlueckerOSHankelKernel.twoTimeNullVector_quadratic_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PlueckerOSHankelKernel.twoTimeNullVector_quadratic_zero

/-- info: 'FiniteReflectionPositivity.reflectionPositive_induces_quotient_innerProduct' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteReflectionPositivity.reflectionPositive_induces_quotient_innerProduct

/-- info: 'FiniteReflectionPositivity.positiveDefinite_not_reflectionPositive_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteReflectionPositivity.positiveDefinite_not_reflectionPositive_witness

/-- info: 'FiniteReflectionPositivity.reflectionPositive_not_positiveDefinite_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteReflectionPositivity.reflectionPositive_not_positiveDefinite_witness

/-- info: 'SU3Plaquette.wilson_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SU3Plaquette.wilson_gauge_invariant

/-- info: 'GapWeightObstruction.eigenvalue_weight_obstruction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GapWeightObstruction.eigenvalue_weight_obstruction

/-- info: 'PhysicsSM.Draft.NullEdge.NeutrinoMassClassification.complete_four_branch_classification' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NeutrinoMassClassification.complete_four_branch_classification

/-- info: 'MixedPseudoDirac.mixed_branch_closes_A5' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MixedPseudoDirac.mixed_branch_closes_A5

/-- info: 'MixedPseudoDirac.real_eigenvalue_eq_squaredMass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MixedPseudoDirac.real_eigenvalue_eq_squaredMass

/-- info: 'MixedPseudoDirac.nilpotentControl_only_eigenvalue_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MixedPseudoDirac.nilpotentControl_only_eigenvalue_zero

/-- info: 'MixedPseudoDirac.nilpotentControl_star_mul_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MixedPseudoDirac.nilpotentControl_star_mul_ne_zero

/-- info: 'CorrectedReadingsAudit.norm_pow_sub_pow_le_telescoping' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms CorrectedReadingsAudit.norm_pow_sub_pow_le_telescoping

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial.exists_squared_singular_basis' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial.exists_squared_singular_basis

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial.exists_autonneTakagi_of_phase_pairing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial.exists_autonneTakagi_of_phase_pairing

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial.takagi_squared_mass_identity_corrected' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial.takagi_squared_mass_identity_corrected

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial.not_forall_takagi_squared_mass_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial.not_forall_takagi_squared_mass_identity
