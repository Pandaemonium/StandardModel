import PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance
import PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact
import PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance

/-!
# QMF.AxiomGuard: build-enforced axiom-footprint guard for the QMF1-RP flagships

Applies the `NullStrand.Audit.CapstoneAxioms` pattern (the repo's build-enforced
"no hidden assumptions" trust idea) to the QMF1-RP compact-group
reflection-positivity flagships. Each `#guard_msgs in #print axioms ...` block
FAILS TO BUILD if the audited theorem's transitive axiom surface changes - e.g.
if a `s o r r y` leaks in through a dependency, if a `n a t i v e _ d e c i d e`
(`Lean.ofReduceBool` / `Lean.trustCompiler`) is introduced, or if a new
`a x i o m` appears underneath. This turns "we checked the axioms once this
session" into a hard, generated build gate.

`(whitespace := lax)` only normalises message line-wrapping; it does NOT relax
which axioms are listed. If the surface is intentionally changed, update the
expected list here in the same commit and explain why.

Guarded: `U(n)`/`SU(n)` compactness, compact-group unimodularity, and the
gauge/reflection invariance of the `SU(N)` Haar expectation. All must rest only
on `propext`, `Classical.choice`, `Quot.sound`.

Provenance: grand-strategy-audit follow-through (both audits recommended
templating the axiom guard onto flagships), 2026-07-05. No
`s o r r y`/`a x i o m`; `#print axioms` + `#guard_msgs` only.
-/

namespace PhysicsSM.Draft.NullEdge.QMF.AxiomGuard

/-! ## Gauge-group compactness / topological-group structure -/

/-- info: 'PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact.unitaryGroup_isCompact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact.unitaryGroup_isCompact

/-- info: 'PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact.specialUnitaryGroup_isCompact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact.specialUnitaryGroup_isCompact

/-! ## Compact groups are unimodular -/

/-- info: 'PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance.compactGroup_haar_isMulRightInvariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance.compactGroup_haar_isMulRightInvariant

/-- info: 'PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance.compactGroup_haar_isInvInvariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance.compactGroup_haar_isInvInvariant

/-! ## Gauge/reflection invariance of the SU(N) Haar expectation -/

/-- info: 'PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance.specialUnitaryGroup_haar_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance.specialUnitaryGroup_haar_gauge_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance.specialUnitaryGroup_haar_reflection_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance.specialUnitaryGroup_haar_reflection_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance.specialUnitaryGroup_exists_isHaarMeasure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance.specialUnitaryGroup_exists_isHaarMeasure

end PhysicsSM.Draft.NullEdge.QMF.AxiomGuard
