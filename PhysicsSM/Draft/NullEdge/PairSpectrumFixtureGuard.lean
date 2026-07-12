import PhysicsSM.Draft.NullEdge.PairSpectrumFixture
import PhysicsSM.Draft.NullEdge.PairSpectrumFixtureC
import PhysicsSM.Draft.NullEdge.PairCharpolyBridge
import PhysicsSM.Draft.NullEdge.FaithfulKernel

/-!
# On-demand heavy guard for the E-paper spectrum fixture

DO NOT import this from the draft root or the aggregate
`OvernightTheoryAxiomGuard`. The theorems below include native_decide
steps over the 28x28 Gaussian-integer twin (`Vz^28`, the 28x28 charpoly)
that OOM a 34 GB machine. They were verified in Aristotle's build
environment; the axiom footprints recorded here are transcribed from
those jobs' `#print axioms`. Rebuild only on a high-memory machine:

  lake build PhysicsSM.Draft.NullEdge.PairSpectrumFixtureGuard

Kernel (light) theorems - these DO build locally and are also pinned in
the aggregate guard's sibling records:
-/

namespace PhysicsSM.Draft.NullEdge.PairSpectrumFixtureGuard

/-- info: 'PhysicsSM.Draft.NullEdge.PairSpectrumFixture.charpoly_factorization' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PairSpectrumFixture.charpoly_factorization

/-- info: 'PhysicsSM.Draft.NullEdge.PairSpectrumFixture.p12_palindromic_reduction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PairSpectrumFixture.p12_palindromic_reduction

/-- info: 'PhysicsSM.Draft.NullEdge.PairSpectrumFixture.Vz_eigenvector_plus_0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PairSpectrumFixture.Vz_eigenvector_plus_0

/-! Heavy native_decide theorems (Aristotle-verified; +2 footprint): -/

/-- info: 'PhysicsSM.Draft.NullEdge.PairSpectrumFixture.faithful' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PairSpectrumFixture.faithful

/-- info: 'PhysicsSM.Draft.NullEdge.PairSpectrumFixture.V_annihilated' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PairSpectrumFixture.V_annihilated

/-- info: 'PhysicsSM.Draft.NullEdge.PairCharpolyBridge.V_charpoly_eq' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PairCharpolyBridge.V_charpoly_eq

/-- info: 'FaithfulKernel.faithful' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FaithfulKernel.faithful

end PhysicsSM.Draft.NullEdge.PairSpectrumFixtureGuard
