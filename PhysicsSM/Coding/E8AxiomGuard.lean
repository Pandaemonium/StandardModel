import PhysicsSM.Coding.E8ShortVectors

/-!
# Coding.E8AxiomGuard: honest build-enforced axiom guard for the E8 short-vector flagships

Both grand-strategy audits (2026-07-05) flagged that the headline E8 facts
(`shortHammingE8Vector_count_eq_240` and the completeness theorems) are proved by
`n a t i v e _ d e c i d e`, so their transitive axiom surface includes
`Lean.ofReduceBool` and `Lean.trustCompiler` (compiler trust) IN ADDITION to the
three foundational axioms `propext`, `Classical.choice`, `Quot.sound`. The
project lead has accepted `n a t i v e _ d e c i d e` here as a deliberate
build-speed choice over a slow `decide`.

This module makes that trust boundary an HONEST, build-enforced, documented fact
rather than an unaudited surprise: each `#guard_msgs in #print axioms` block below
pins the flagship's ACTUAL footprint - including the two native-trust tokens - and
FAILS TO BUILD if it changes. So:

* if a `s o r r y` ever leaks in through a dependency, the build breaks;
* if a new `a x i o m` appears underneath, the build breaks;
* if the flagship is ever DE-NATIVED to kernel-trust (the `native_decide`
  replaced by a kernel-checked enumeration - the ideal), the expected list here
  must be shrunk to the three foundational axioms in the SAME commit, which
  documents the promotion.

This is the "axiom-footprint regression guard" pattern from
`NullStrand.Audit.CapstoneAxioms`, applied here to the most publicly-advertised
artifact so that "240 short vectors, native-trust" can never silently drift into
either a `s o r r y`-tainted claim or an un-flagged kernel-trust upgrade.

`(whitespace := lax)` only normalises message line-wrapping. Provenance:
grand-strategy-audit follow-through, 2026-07-05. No `s o r r y`/`a x i o m`;
`#print axioms` + `#guard_msgs` only.
-/

namespace PhysicsSM.Coding.E8AxiomGuard

/-- info: 'PhysicsSM.Coding.shortHammingE8Vector_count_eq_240' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Coding.shortHammingE8Vector_count_eq_240

/-- info: 'PhysicsSM.Coding.shortHammingE8VectorList_complete' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Coding.shortHammingE8VectorList_complete

/-- info: 'PhysicsSM.Coding.shortHammingE8VectorList_complete_bounded' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Coding.shortHammingE8VectorList_complete_bounded

end PhysicsSM.Coding.E8AxiomGuard
