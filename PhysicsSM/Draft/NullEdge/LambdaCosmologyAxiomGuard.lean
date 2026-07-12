/-
# Axiom guard for the null-edge cosmological-constant (Lambda) program

Build-enforced trust footprint for the theorems cited by the manuscript
`Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex`.

Each `#guard_msgs (whitespace := lax) in #print axioms ...` block pins the
kernel-checked axiom footprint of a headline Lambda theorem. The intended
footprint for every pin below is the standard kernel base
`[propext, Classical.choice, Quot.sound]` -- in particular, NO
`Lean.ofReduceBool` / `Lean.trustCompiler` (i.e. no `native_decide`) and no
`sorryAx`. If any dependency of a pinned theorem ever regresses (a `sorry`, an
`axiom`, or a `native_decide` sneaks into the transitive proof), the recorded
`info:` string stops matching and THIS FILE FAILS TO BUILD.

This closes release gate (i) of the manuscript: "the capstones are kernel-clean
but not yet build-guarded." Once this module builds green, they are
build-guarded.

Guarded modules (twelve), grouped by the manuscript section they support:
  * Sec 2  spectral grading / magnitude dissolution:
      `LambdaMomentHierarchy`, `LambdaMagnitudeCapstone`, `LambdaUnimodular`
  * Sec 3  everpresent scaling law:
      `PhysicsSM.Draft.NullEdgeP9EverpresentLambdaScaling`, `LambdaEdgeCount`,
      `PhysicsSM.Draft.NullEdgeP9EverpresentLambdaTension`
  * Sec 5  pre-registered dichotomy + exponent:
      `LambdaSusceptibility`, `LambdaCountDichotomy`, `LambdaExponentFork`,
      `LambdaFermionicFork` (fork RESOLVED on fermionic states)
  * Sec 6  finite Fourier / volume conjugacy:
      `LambdaConjugacy`, `LambdaUncertaintyGeneralN` (general-N Donoho--Stark)

Draft-trust: the guarded modules are draft/experimental Lean; the guard certifies
their axiom footprint only, not their semantic alignment with the physics
interpretation (that is the manuscript's job, stated at each claim's point of
use). See `PhysicsSM/Draft/NullEdge/OvernightTheoryAxiomGuard.lean` for the
sibling aggregate guard and the pattern.
-/
import PhysicsSM.Draft.NullEdge.LambdaMomentHierarchy
import PhysicsSM.Draft.NullEdge.LambdaMagnitudeCapstone
import PhysicsSM.Draft.NullEdge.LambdaUnimodular
import PhysicsSM.Draft.NullEdgeP9EverpresentLambdaScaling
import PhysicsSM.Draft.NullEdgeP9EverpresentLambdaTension
import PhysicsSM.Draft.NullEdge.LambdaEdgeCount
import PhysicsSM.Draft.NullEdge.LambdaSusceptibility
import PhysicsSM.Draft.NullEdge.LambdaCountDichotomy
import PhysicsSM.Draft.NullEdge.LambdaExponentFork
import PhysicsSM.Draft.NullEdge.LambdaConjugacy
import PhysicsSM.Draft.NullEdge.LambdaUncertaintyGeneralN
import PhysicsSM.Draft.NullEdge.LambdaFermionicFork

namespace PhysicsSM.Draft.NullEdge.LambdaCosmologyAxiomGuard

/-! ## Section 2 -- spectral grading and order-0 magnitude dissolution -/

/-- info: 'LambdaMomentHierarchy.parts_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaMomentHierarchy.parts_nonzero

/-- info: 'LambdaMomentHierarchy.moment_hierarchy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaMomentHierarchy.moment_hierarchy

/-- info: 'LambdaMomentHierarchy.order0_deformation_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaMomentHierarchy.order0_deformation_invariant

/-- info: 'LambdaMomentHierarchy.only_count_touches_lambda' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaMomentHierarchy.only_count_touches_lambda

/-- info: 'LambdaMomentHierarchy.hierarchy_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaMomentHierarchy.hierarchy_verdict

/-- info: 'LambdaMagnitudeCapstone.lambda_magnitude_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaMagnitudeCapstone.lambda_magnitude_capstone

/-- info: 'LambdaMagnitudeCapstone.lambda_nonvacuity_witnesses' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaMagnitudeCapstone.lambda_nonvacuity_witnesses

/-- info: 'LambdaMagnitudeCapstone.lambda_only_count_can_move_order0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaMagnitudeCapstone.lambda_only_count_can_move_order0

/-- info: 'LambdaUnimodular.multiplier_field_equation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaUnimodular.multiplier_field_equation

/-- info: 'LambdaUnimodular.vacuum_shift_is_gauge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaUnimodular.vacuum_shift_is_gauge

/-- info: 'LambdaUnimodular.gauge_solution_map' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaUnimodular.gauge_solution_map

/-- info: 'LambdaUnimodular.trace_one_eq_dim' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaUnimodular.trace_one_eq_dim

/-- info: 'LambdaUnimodular.trace_channel_blind' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaUnimodular.trace_channel_blind

/-- info: 'LambdaUnimodular.order0_operator_blind' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaUnimodular.order0_operator_blind

/-- info: 'LambdaUnimodular.unimodular_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaUnimodular.unimodular_verdict

/-! ## Section 3 -- the everpresent scaling law -/

/-- info: 'PhysicsSM.Draft.NullEdgeP9EverpresentLambdaScaling.everpresentLambda_secondMoment_eq_inv_volume' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdgeP9EverpresentLambdaScaling.everpresentLambda_secondMoment_eq_inv_volume

/-- info: 'PhysicsSM.Draft.NullEdgeP9EverpresentLambdaScaling.everpresentLambda_rms_eq_inv_sqrt_volume' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdgeP9EverpresentLambdaScaling.everpresentLambda_rms_eq_inv_sqrt_volume

/-- info: 'LambdaEdgeCount.edgecount_extensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaEdgeCount.edgecount_extensive

-- `edgecount_mono` is `Finset.card_le_card` on a subset relation: no
-- `Classical.choice` is pulled in, so its footprint is `[propext, Quot.sound]`.
/-- info: 'LambdaEdgeCount.edgecount_mono' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaEdgeCount.edgecount_mono

/-- info: 'LambdaEdgeCount.lambda_secondMoment_eq_inv_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaEdgeCount.lambda_secondMoment_eq_inv_count

/-- info: 'LambdaEdgeCount.lambda_rms_eq_inv_sqrt_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaEdgeCount.lambda_rms_eq_inv_sqrt_count

/-- info: 'LambdaEdgeCount.everpresent_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaEdgeCount.everpresent_verdict

-- The suppression comparison machinery (cited in the manuscript's everpresent
-- section as the bridge into Section 5): a uniform residual `A^2/N` beats the
-- `sqrt N` fluctuation iff the scale is sub-extensive.
/-- info: 'PhysicsSM.Draft.NullEdgeP9EverpresentLambdaTension.uniformSecondMoment_antitone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdgeP9EverpresentLambdaTension.uniformSecondMoment_antitone

/-- info: 'PhysicsSM.Draft.NullEdgeP9EverpresentLambdaTension.uniformSuppression_below_everpresent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdgeP9EverpresentLambdaTension.uniformSuppression_below_everpresent

/-! ## Section 5 -- the pre-registered dichotomy and its exponent -/

/-- info: 'LambdaSusceptibility.expect_Ncount' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaSusceptibility.expect_Ncount

/-- info: 'LambdaSusceptibility.var_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaSusceptibility.var_count

/-- info: 'LambdaSusceptibility.bernoulli_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaSusceptibility.bernoulli_bound

/-- info: 'LambdaCountDichotomy.free_variance_extensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaCountDichotomy.free_variance_extensive

/-- info: 'LambdaCountDichotomy.constrained_variance_hard' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaCountDichotomy.constrained_variance_hard

/-- info: 'LambdaCountDichotomy.soft_variance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaCountDichotomy.soft_variance

/-- info: 'LambdaCountDichotomy.free_extensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaCountDichotomy.free_extensive

/-- info: 'LambdaCountDichotomy.hard_subextensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaCountDichotomy.hard_subextensive

/-- info: 'LambdaCountDichotomy.soft_subextensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaCountDichotomy.soft_subextensive

/-- info: 'LambdaExponentFork.lamExp_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaExponentFork.lamExp_closed

/-- info: 'LambdaExponentFork.everpresent_value' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaExponentFork.everpresent_value

/-- info: 'LambdaExponentFork.hyperuniform_faster' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaExponentFork.hyperuniform_faster

/-- info: 'LambdaExponentFork.superextensive_slower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaExponentFork.superextensive_slower

/-- info: 'LambdaExponentFork.fork_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaExponentFork.fork_iff

/-- info: 'LambdaExponentFork.exponent_fork_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaExponentFork.exponent_fork_verdict

-- The fork RESOLVED on the framework's own fermionic states (harvested 2026-07-12,
-- Aristotle 9be8f014): the fermionic number-variance identity Var = tr K_A - tr K_A^2,
-- an explicit boundary-bond PROJECTION kernel (K^2 = K) with Var = k/4 and region size
-- tunable to k^2 (alpha = 1/2, sub-extensive AND unbounded), and the two-branch verdict.
/-- info: 'LambdaFermionicFork.bondProj_isProjection' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaFermionicFork.bondProj_isProjection

/-- info: 'LambdaFermionicFork.bondProj_numberVariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaFermionicFork.bondProj_numberVariance

/-- info: 'LambdaFermionicFork.fork_subextensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaFermionicFork.fork_subextensive

/-- info: 'LambdaFermionicFork.fermionic_fork_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaFermionicFork.fermionic_fork_verdict

/-! ## Section 6 -- finite Fourier / volume conjugacy -/

/-- info: 'LambdaConjugacy.delta_maps_to_uniform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaConjugacy.delta_maps_to_uniform

/-- info: 'LambdaConjugacy.uniform_maps_to_delta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaConjugacy.uniform_maps_to_delta

/-- info: 'LambdaConjugacy.support_uncertainty' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaConjugacy.support_uncertainty

/-- info: 'LambdaConjugacy.delta_saturates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaConjugacy.delta_saturates

/-- info: 'LambdaConjugacy.conjugacy_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaConjugacy.conjugacy_verdict

-- The general-`N` successor (harvested 2026-07-12, Aristotle e22d0fe7): the
-- Donoho--Stark support bound `N <= |supp f| * |supp (dft f)|` over `ZMod N`,
-- retiring the manuscript Section 6 "ZMod 4 witness only" scope caveat.
/-- info: 'LambdaUncertaintyGeneralN.plancherel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaUncertaintyGeneralN.plancherel

/-- info: 'LambdaUncertaintyGeneralN.support_uncertainty' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LambdaUncertaintyGeneralN.support_uncertainty

end PhysicsSM.Draft.NullEdge.LambdaCosmologyAxiomGuard
