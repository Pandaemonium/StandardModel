import PhysicsSM.Draft.NullEdge.GateYM.Z2GaugeCore
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurCore
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice
import PhysicsSM.Draft.NullEdge.GateYM.TorusEvenCover
import PhysicsSM.Draft.NullEdge.GateYM.FusionConvolution
import PhysicsSM.Draft.NullEdge.GateYM.GaugeCoreGeneral
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore
import PhysicsSM.Draft.NullEdge.GateYM.LatticeEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity
import PhysicsSM.Draft.NullEdge.GateYM.TransferPositivity
import PhysicsSM.Draft.NullEdge.GateYM.TransferGapDefinition
import PhysicsSM.Draft.NullEdge.GateYM.BanksCasherShadow

/-!
# Gate YM aggregator: the Yang-Mills / confinement ladder

Pure import aggregator for the Gate YM draft tree - the lattice gauge theory
formalization ladder of `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`
(Track A), with statements and finite-level proofs frozen in
`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`. One command
kernel-checks the layer:

    lake build PhysicsSM.Draft.NullEdge.GateYM

Current contents: `Z2GaugeCore` (YM0 gauge-invariance core; Z2/Bool, core
Lean only, axiom footprint empty-to-[Quot.sound]); `ElitzurCore` (YM1
Elitzur pairing bound, abstract core; axiom footprint
[propext, Classical.choice, Quot.sound]); `ElitzurLattice` (PKG-YM1-lattice:
the abstract bound instantiated at the one-site Z2 gauge flip, giving the
full quantitative volume-uniform Elitzur theorem; axiom footprint
[propext, Classical.choice, Quot.sound]); `TorusEvenCover` (YM1 T2
kernel-checked finite-grid connectivity and boundary-bit cores for the Z2
torus even-cover argument: locally constant plaquette subsets are empty or
universal, and equal-boundary subsets differ by nothing or by complement);
`FusionConvolution` (YM1 T2/T2-C abstract finite-group convolution
iteration core in the oracle-pinned argument order);
`GaugeCoreGeneral` (YM0/T3 general oriented-link gauge core: typed walks,
inverse convention for reverse traversal, telescoping holonomy covariance,
closed-walk class-function gauge invariance, gauge action laws);
`PlaquetteCore` (YM0/T3 abstract D5/D7 bridge: a plaquette is a typed
closed 4-walk, class functions of plaquette holonomy are gauge invariant,
and finite plaquette action sums/product weights inherit gauge invariance);
`LatticeEnsemble` (YM0/T3 finite ensemble skeleton: partition function,
weighted numerator, expectation, positivity for strictly positive finite
weights, and gauge change-of-variables for partition/numerator/expectation;
no reflection, cut structure, or transfer matrix yet);
`PlaquetteEnsemble` (YM0/T3 finite product-plaquette ensemble skeleton:
partition/numerator/expectation for arbitrary local class-function plaquette
weights, positivity for positive local weights, and observable-gauge
invariance under those weights);
`TransferGapDefinition` (YM0/T3 D12 definition shell: explicit
Gauss-invariant/zero-momentum/trivial-flux vacuum-sector predicate and
finite real spectral-ratio gap `-log(lambda1/lambda0)` with elementary
nonnegativity/positivity lemmas; no transfer matrix construction yet);
`WilsonWeightPositivity` (YM3: Route B, the character-theory-free path to
the reflection-positivity kernel-PSD engine - all three handoffs closed
in-repo, zero `s o r r y`, axiom footprint
[propext, Classical.choice, Quot.sound]; includes `hadamard_posSemidef`,
a genuinely reusable Schur-product-theorem lemma this repo's pinned
Mathlib lacks under any name); `TransferPositivity` (YM3, single-link
PSD congruence/compression engine, RENAMED and re-scoped 2026-07-04
after Aristotle red-team `cb437537`'s finding that the original
"Corollary 3b"/"transfer matrix" framing overstated what is indexed:
`transferMatrix_posSemidef`/`compression_posSemidef` are abstract
congruence/compression facts over ANY finite index type - no lattice
ensemble, tensor-product kernel, or Gauss projector exists yet;
`singleLinkWilsonKernel_diagCongruence_posSemidef` instantiates the
former at one temporal link's Wilson kernel; axiom footprint
[propext, Classical.choice, Quot.sound]); `BanksCasherShadow`
(T4/QCD1: the GW-circle structural fact on this repo's existing C1/C2
overlap machinery - the shifted overlap `Dov - 1` is unitary and
`gamma5 * Dov` is Hermitian, given gamma5/eps both Hermitian involutions,
instantiated at the certified sign `epsCFC H`; axiom footprint
[propext, Classical.choice, Quot.sound]. QCD1-i/ii proper - the
condensate identity and chiral-pairing lemma - are NOT claimed by this
file; see its docstring for the honestly-scoped remaining work). Not
part of the default trusted build target. Adding a new YM module?
Import it here.
-/
