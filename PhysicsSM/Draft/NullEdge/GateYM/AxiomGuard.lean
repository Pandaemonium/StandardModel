import PhysicsSM.Draft.NullEdge.GateYM.RectTreeGauge
import PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryExpectation
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel
import PhysicsSM.Draft.NullEdge.GateYM.WilsonVacuumDominance
import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2Sector
import PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector
import PhysicsSM.Draft.NullEdge.GateYM.CenterOneFormLine
import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion

/-!
# GateYM.AxiomGuard: build-enforced axiom-footprint guard for the GateYM spine

Applies the `NullStrand.Audit.CapstoneAxioms` pattern (the repo's build-enforced
"no hidden assumptions" trust idea) to the STABLE, `s o r r y`-free flagships of
the GateYM Yang-Mills draft spine. Both grand-strategy audits (2026-07-05)
recommended templating this guard onto flagship theorems; this is the GateYM
instance (the four-day run left it as a `TODO` for the codex lane; landed here
under the overnight run's tree custody).

Each `#guard_msgs in #print axioms ...` block FAILS TO BUILD if the audited
theorem's transitive axiom surface changes - a leaked `s o r r y`, an introduced
`n a t i v e _ d e c i d e` (`Lean.ofReduceBool` / `Lean.trustCompiler`), or a
new `a x i o m` underneath. This turns "we checked the axioms once" into a hard
build gate.

IMPORTANT scope note: the GateYM AGGREGATOR is NOT `s o r r y`-free - it
transitively imports the three Q6/KP cruxes in `PolymerKPConclusion.lean`
(`pairSum_le_expBound`, `kp_convergence_bound_of_selfIncompatible`,
`kp_tail_bound`). This guard therefore pins only the SPECIFIC `s o r r y`-free
flagships, NOT the aggregator. In particular it guards
`kp_convergence_bound_false` - the kernel-checked DISPROOF of the naive bare-KP
bound - which is `s o r r y`-free and is one of the highest-value verified
artifacts in the tree; it must never silently acquire a `s o r r y`.

`(whitespace := lax)` only normalises message line-wrapping; it does NOT relax
which axioms are listed. If a surface is intentionally changed, update the
expected list here in the same commit and explain why.

Guarded (all rest only on `[propext, Classical.choice, Quot.sound]`):
YM1 exact finite-group area law (bulk + boundary), Elitzur volume-uniform bound,
the reflection-positivity kernel nonnegativity, Q5 Wilson vacuum dominance
(normalized-gamma bound + nonneg string tension), the honest center-flux gap
witness, and the verified-negative bare-KP disproof.

Provenance: grand-strategy-audit follow-through, overnight all-mass run
2026-07-06. No `s o r r y`/`a x i o m`; `#print axioms` + `#guard_msgs` only.
-/

namespace PhysicsSM.Draft.NullEdge.GateYM.AxiomGuard

/-! ## YM1: exact finite-group Wilson-loop area law (bulk and boundary) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.RectTreeGauge.rect_wilson_loop_expectation_area_law' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.RectTreeGauge.rect_wilson_loop_expectation_area_law

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryExpectation.rect_boundary_wilson_loop_expectation_area_law' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryExpectation.rect_boundary_wilson_loop_expectation_area_law

/-! ## Elitzur: no gauge-invariant single-link expectation (volume-uniform) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice.elitzur_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice.elitzur_bound

/-! ## Reflection-positivity kernel: reflection form is nonnegative -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel.reflectionForm_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel.reflectionForm_nonneg

/-! ## Q5: Wilson vacuum dominance (unconditional forms) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.WilsonVacuumDominance.norm_wilsonNormalizedGamma_le_one'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.WilsonVacuumDominance.norm_wilsonNormalizedGamma_le_one'

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.WilsonVacuumDominance.wilsonStringTension_nonneg'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.WilsonVacuumDominance.wilsonStringTension_nonneg'

/-! ## Honest center-flux gap witness (NOT within-trivial-sector local gap) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2Sector.fluxGapWitness_gap_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2Sector.fluxGapWitness_gap_pos

/-! ## Generic electric-sector non-vacuity witness -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.ShiftSystem.one_inElectricSector_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.ShiftSystem.one_inElectricSector_nonzero

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.ShiftSystem.boolSign_nontrivialElectricSector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.ShiftSystem.boolSign_nontrivialElectricSector

/-! ## Finite torus center-shift action laws -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xFluxShift_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xFluxShift_one

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xFluxShift_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xFluxShift_mul

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.yFluxShift_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.yFluxShift_one

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.yFluxShift_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.yFluxShift_mul

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xFluxShift_yFluxShift_comm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xFluxShift_yFluxShift_comm

/-! ## Finite one-form center-shadow line charge identities -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xLineHol_xFluxShift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xLineHol_xFluxShift

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xLineHol_yFluxShift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.xLineHol_yFluxShift

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.yLineHol_yFluxShift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.yLineHol_yFluxShift

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.yLineHol_xFluxShift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector.yLineHol_xFluxShift

/-! ## Verified NEGATIVE: the naive bare-KP bound is false -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion.kp_convergence_bound_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion.kp_convergence_bound_false

end PhysicsSM.Draft.NullEdge.GateYM.AxiomGuard
