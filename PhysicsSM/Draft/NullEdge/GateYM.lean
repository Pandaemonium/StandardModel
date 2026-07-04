import PhysicsSM.Draft.NullEdge.GateYM.Z2GaugeCore
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurCore
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice
import PhysicsSM.Draft.NullEdge.GateYM.TorusEvenCover
import PhysicsSM.Draft.NullEdge.GateYM.FusionConvolution
import PhysicsSM.Draft.NullEdge.GateYM.Theorem2AreaLaw
import PhysicsSM.Draft.NullEdge.GateYM.GaugeCoreGeneral
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCutExample
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionWalk
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflection
import PhysicsSM.Draft.NullEdge.GateYM.LatticeEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight
import PhysicsSM.Draft.NullEdge.GateYM.TransferPositivity
import PhysicsSM.Draft.NullEdge.GateYM.TransferGapDefinition
import PhysicsSM.Draft.NullEdge.GateYM.BanksCasherShadow
import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPCriterion

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
`FusionConvolution` (YM1 T2/T2-C finite-group fusion-by-convolution:
Aristotle-integrated Lemma 2a character fusion in the oracle-pinned
`h^-1 * A` argument order, division-free iteration of that fusion identity,
and the abstract convolution iteration core;
axiom footprint [propext, Classical.choice, Quot.sound]);
`Theorem2AreaLaw` (YM1 T2/T2-C Wilson-weight specialization of the
fusion/iteration layer: complex-cast Wilson local weight is a class function,
`wilson_gamma` divides the one-step fusion identity by `chi_R(1)` with an
explicit nonzero proof, and `wilson_iterConv_eigen_at_one` gives the
`chi_R(1) * gamma^n` iteration shape - a division-based counterpart to
`FusionConvolution.iterConv_character_fusion_cross`'s division-free
cross-multiplied form, specialized to the concrete Wilson weight rather than
an arbitrary class function; `wilson_iterConv_normalized_at_one` divides the
raw convolution by an explicit one-plaquette scalar, with nonzero supplied by
positivity of the real Wilson weights. This still does not prove the
tree-gauge/ensemble expectation bridge or partition-function prefactor; axiom footprint
[propext, Classical.choice, Quot.sound]);
`GaugeCoreGeneral` (YM0/T3 general oriented-link gauge core: typed walks,
inverse convention for reverse traversal, telescoping holonomy covariance,
closed-walk class-function gauge invariance, gauge action laws);
`ReflectionCore` (YM3, first-pass cross-reviewed scaffolding: abstract
reflection of an oriented lattice - vertex/edge involutions with no
on-plane vertices, positive/negative/cut link classification, and the
pullback reflection action on link fields, proved an involution; includes
single-step `Step.fwd`/`Step.rev` compatibility lemmas and resolves
`design:reflection-cut-layer`'s three open questions as documented
judgment calls, not silent assumptions; no Wilson action, expectation, or
RP inequality lives here yet); `ReflectionCutExample` (YM3 sanity-check
model: a two-layer link-reflection lattice with all links crossing the
reflection plane, proving the abstract `Reflection` structure is inhabited
by the no-on-plane link-reflection geometry); `ReflectionWalk` (YM3
walk-level reflection transport: mirrored typed walks reverse step order,
and noncommutative order reversal is recorded by the opposite-group identity
`op (hol (theta U) w) = hol (op U) (mirrorWalk w)`);
`ReflectionEnsemble` (YM3 finite reflection change-of-variables:
`reflectLinkField` is an equivalence of finite configuration space, so
partition functions, numerators, and expectations inherit reflection
change-of-variables identities under reflection-invariant weights);
`PlaquetteCore` (YM0/T3 abstract D5/D7 bridge: a plaquette is a typed
closed 4-walk, class functions of plaquette holonomy are gauge invariant,
and finite plaquette action sums/product weights inherit gauge invariance);
`PlaquetteReflection` (YM3 finite identity: reflecting an abstract plaquette
is definitionally the reflected/reversed boundary walk, and plaquette holonomy
inherits the opposite-group reflection identity from `ReflectionWalk`; includes
the induced product-weight identity for mirrored plaquette families and the
reflection-invariance bookkeeping for mirror-stable families under an explicit
local opposite-compatibility hypothesis, but still no Wilson action reflection
covariance, cut factorization, or RP inequality);
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
Mathlib lacks under any name); `WilsonLocalWeight` (YM0/YM3 connector:
the Wilson local weight `exp(beta Re chi(h))` is a class function -
needing only multiplicativity of `rho`, not unitarity - so the T3
`PlaquetteEnsemble` skeleton is gauge invariant for the ACTUAL Wilson
weight, not just an abstract placeholder; axiom footprint
[propext, Classical.choice, Quot.sound]); `TransferPositivity` (YM3, single-link
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
file; see its docstring for the honestly-scoped remaining work);
`PolymerKPCriterion` (YM4/T5: STATEMENT FREEZE ONLY, no proof attempted
- the abstract finite polymer system and the Kotecky-Preiss condition
`sum_{incompatible} |weight| exp(energy) <= energy`, cross-confirmed
against three independent secondary sources during tonight's lit
sprint since primary-source PDF text could not be extracted; the KP
CONCLUSION - cluster expansion convergence - needs new Ursell/cluster
combinatorial infrastructure not yet designed, documented as a handoff
rather than guessed at). Not part of the default trusted build target.
Adding a new YM module? Import it here.
-/
