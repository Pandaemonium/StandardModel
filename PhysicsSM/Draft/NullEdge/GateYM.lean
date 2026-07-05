import PhysicsSM.Draft.NullEdge.GateYM.Z2GaugeCore
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurCore
import PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice
import PhysicsSM.Draft.NullEdge.GateYM.TorusEvenCover
import PhysicsSM.Draft.NullEdge.GateYM.FusionConvolution
import PhysicsSM.Draft.NullEdge.GateYM.Theorem2AreaLaw
import PhysicsSM.Draft.NullEdge.GateYM.IndependentPlaquetteEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.TreeGaugeBridge
import PhysicsSM.Draft.NullEdge.GateYM.RectTreeGauge
import PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryLasso
import PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryExpectation
import PhysicsSM.Draft.NullEdge.GateYM.FusionTransferSpectrum
import PhysicsSM.Draft.NullEdge.GateYM.FDRepUnitarizable
import PhysicsSM.Draft.NullEdge.GateYM.WilsonVacuumDominance
import PhysicsSM.Draft.NullEdge.GateYM.EnsembleComplexBridge
import PhysicsSM.Draft.NullEdge.GateYM.GaugeCoreGeneral
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionDouble
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCutExample
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionWalk
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflection
import PhysicsSM.Draft.NullEdge.GateYM.MirrorHolonomyConjugation
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflectionEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.MirrorHolonomyResolution
import PhysicsSM.Draft.NullEdge.GateYM.LatticeEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight
import PhysicsSM.Draft.NullEdge.GateYM.WilsonReflectionCompatibility
import PhysicsSM.Draft.NullEdge.GateYM.HermitianFromRealQuadraticForm
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel
import PhysicsSM.Draft.NullEdge.GateYM.WilsonReflectionPositivity
import PhysicsSM.Draft.NullEdge.GateYM.WilsonCutPlaquettePositivity
import PhysicsSM.Draft.NullEdge.GateYM.TransferPositivity
import PhysicsSM.Draft.NullEdge.GateYM.TransferHilbert
import PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertBlock
import PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertBlockShift
import PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertZ2Electric
import PhysicsSM.Draft.NullEdge.GateYM.TransferGapDefinition
import PhysicsSM.Draft.NullEdge.GateYM.CyclicityPrereq
import PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector
import PhysicsSM.Draft.NullEdge.GateYM.FluxSectorGeneral
import PhysicsSM.Draft.NullEdge.GateYM.FluxSectorZ2
import PhysicsSM.Draft.NullEdge.GateYM.BanksCasherShadow
import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPCriterion
import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
import PhysicsSM.Draft.NullEdge.GateYM.StrongCouplingPolymerMap
import PhysicsSM.Draft.NullEdge.GateYM.ExponentialClustering

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
has unitarity-dependent inversion symmetry,
`wilson_gamma` divides the one-step fusion identity by `chi_R(1)` with an
explicit nonzero proof, and `wilson_iterConv_eigen_at_one` gives the
`chi_R(1) * gamma^n` iteration shape - a division-based counterpart to
`FusionConvolution.iterConv_character_fusion_cross`'s division-free
cross-multiplied form, specialized to the concrete Wilson weight rather than
an arbitrary class function; `wilson_iterConv_normalized_at_one` divides the
raw convolution by an explicit one-plaquette scalar, with nonzero supplied by
positivity of the real Wilson weights, and `wilsonNormalizedGamma` names the
resulting area-law scalar for downstream statements; the cross-multiplied
`wilson_iterConv_normalizedGamma_cross_at_one` restates the named-scalar identity
without division. This still does not prove the tree-gauge/ensemble expectation
bridge or partition-function prefactor; axiom footprint
[propext, Classical.choice, Quot.sound]);
`IndependentPlaquetteEnsemble` (YM1 Lemma 2b, independent-plaquette form:
the ordered plaquette-tuple sum IS the iterated convolution
(`sum_weight_orderedProdInv_eq_iterConv`, no hypotheses; inversion-symmetric
`w` removes the observable inversion), out-of-region plaquettes integrate out
of the loop numerator (`loopNumerator_factor`, proved by transporting along a
`Fin m + complement ~ nu` sum-type enumeration), the partition function is the
`card nu`-th power of the one-plaquette sum, and the headline
`wilson_loop_expectation_area_law`: the Wilson-loop expectation in the
independent-plaquette Wilson ensemble is EXACTLY
`chi_R(1) * wilsonNormalizedGamma^m` for a region of `m` distinct plaquettes,
with norm form `norm_wilson_loop_expectation` giving exponential area decay
whenever `|gamma| < 1`. The remaining layer of freeze Theorem 2 is geometric:
the tree-gauge change of variables from the 2D open-rectangle LINK ensemble to
this independent-plaquette ensemble; axiom footprint
[propext, Classical.choice, Quot.sound]);
`TreeGaugeBridge` (YM1 generic tree-gauge bridge: the abstract
`PlaquetteCoordinatization` interface - link fields equivalent to plaquette
coordinates times residual coordinates, with plaquette holonomies AS the
plaquette coordinates - under which the complex link-ensemble expectation of
`chi(orderedProd of in-region plaquette holonomies)` collapses to
`IndependentPlaquetteEnsemble.loopExpectation` with the `|G|^(card tau)`
residual factors cancelling, and the Wilson specialization
`wilson_link_loop_expectation_area_law` gives `chi_R(1) * gamma^m` at the
link-ensemble level. Remaining geometric gap, stated in the module docstring:
constructing a coordinatization for the concrete 2D open rectangle and the
comb-ordering lasso identification of the boundary-circuit Wilson loop with
the ordered plaquette-holonomy product; axiom footprint
[propext, Classical.choice, Quot.sound]);
`RectTreeGauge` (YM1, Aristotle `1d9b5b19` integrated: the concrete
`Lx x Ly` open-rectangle lattice with counterclockwise plaquettes
(holonomy formula kernel-pinned by a `rfl` lemma), the comb-gauge
`PlaquetteCoordinatization` (forward map = holonomies + tree restriction,
bijectivity by per-row `Fin.induction` injectivity + cardinality), and
`rect_wilson_loop_expectation_area_law`: the Wilson area law
`chi_R(1) * gamma^m` as a link-ensemble expectation on a CONCRETE lattice.
The remaining boundary-circuit observable bridge is closed by
`RectBoundaryExpectation`; dependency footprint
[propext, Classical.choice, Quot.sound]);
`RectBoundaryLasso` (YM1/T11: typed full-rectangle boundary walk on
`RectTreeGauge.rectLattice`, with the boundary holonomy order pinned as bottom,
right, inverse top, inverse left, plus the tree-slice lasso identity identifying
the boundary holonomy with the reversed-row-major plaquette product on the comb
tree slice);
`RectBoundaryExpectation` (YM1/T11, Aristotle `acedaea2` integrated: expectation-
level gauge-orbit bridge from the full rectangular boundary-circuit Wilson
observable to the independent-plaquette area law, proving
`rect_boundary_wilson_loop_expectation_area_law` with area exponent `Lx * Ly`
for arbitrary finite groups. It deliberately avoids the false pointwise
boundary-vs-plaquette-product identity at general link fields);
`FusionTransferSpectrum` (YM1/gap lane: the fusion convolution as a linear
endomorphism of `G -> C` with kernel-checked `Module.End` spectrum - the
constant function is the vacuum eigenvector with eigenvalue the one-plaquette
sum, and characters of simple complex `FDRep`s are eigenvectors with the
fusion eigenvalue, for ANY class-function weight; plus the string-tension
restatement `|<W_R>| = |chi_R(1)| exp(-sigma * area)` of the
independent-plaquette area law under an explicit `gamma != 0` hypothesis.
Also `character_inv_eq_conj` (UNCONDITIONAL `chi(g^-1) = conj(chi(g))` for
every `FDRep`, via `FDRepUnitarizable`) and `wilsonNormalizedGamma_conj_eq_self`
(reality of `wilsonNormalizedGamma` for unitary gauge `rho` - queue item Q5's
reality half, closed). Deliberately NOT (yet) claimed: strict positivity or
the full spectral-gap assembly, and any identification with
`TransferGapDefinition.finiteMassGap` - those are the next honest gap-lane
targets; axiom footprint [propext, Classical.choice, Quot.sound]);
`FDRepUnitarizable` (YM1/gap lane, Aristotle `d4a9bd1f` integrated: every
finite-dimensional complex representation of a finite group admits a
unitary matrix model - Weyl's unitarian trick in pure matrix algebra
(Weyl-averaged Gram matrix, its `M h`-intertwining identity, conjugation
by its `CFC.sqrt`), holding for EVERY `FDRep`, not just simple ones;
axiom footprint [propext, Classical.choice, Quot.sound]);
`WilsonVacuumDominance` (YM1/gap lane: vacuum dominance for unitary matrix
models - diagonal entries of a unitary matrix have modulus at most 1, hence
`|tr M| <= n`, hence `|wilsonNormalizedGamma| <= 1` and NONNEGATIVE string
tension, under an explicit `R.character g = tr (rho' g)` unitary
matrix-model hypothesis, PLUS the UNCONDITIONAL forms
`norm_wilsonNormalizedGamma_le_one'` / `wilsonStringTension_nonneg'` for
every simple `R` (queue item Q4 closed, via `FDRepUnitarizable`), and
`wilsonNormalizedGamma_re_mem_Icc` (queue item Q5's ordering half closed:
combining reality with vacuum dominance gives `gamma.re in [-1, 1]`,
ordering the fusion spectrum below the vacuum eigenvalue `1`); axiom
footprint [propext, Classical.choice, Quot.sound]);
`EnsembleComplexBridge` (YM0/YM1 connector: the complex Wilson link
partition/numerator/expectation of `TreeGaugeBridge` are literally the casts
of the real T3 `PlaquetteEnsemble` ones, and the complex Wilson link
partition function is NONZERO by real positivity - making the complex Wilson
`linkExpectation` non-vacuous for every `beta`, `rho`, finite lattice,
independent of any coordinatization; axiom footprint
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
RP inequality lives here yet); `ReflectionDouble` (YM3 Q1 substrate: the
"doubled lattice" - given ANY oriented lattice `L0`, glue a `true`
(positive) copy with `L0`'s own orientation to a `false` (negative) copy
with REVERSED orientation into one lattice carrying a canonical, always-
valid `Reflection` (side-bit flip, no cut links). Resolves a genuine
construction finding (`design:q1-reflection-orientation` in the four-day
run's `DISCUSSION.md`): a naive single-orientation reflection of a 2D
rectangular lattice through either coordinate axis fails
`ReflectionCore.Reflection`'s endpoint-swap axioms for every edge
transverse to the reflected direction. `doubleLinkFieldEquiv` gives the
mirror-coordinate split `LinkField ~ L0.LinkField x L0.LinkField` that
`ReflectionPositivityKernel`'s factorized class consumes with `C := PUnit`;
threading a genuine gauge-invariant plaquette-based Wilson weight through
it (via `PlaquetteReflection.mirrorPlaquette` +
`WilsonReflectionCompatibility.rhoOppositeInv`, not a naive per-side lift)
is recorded as the concrete next step, not yet done); `ReflectionCutExample`
(YM3 sanity-check model: a two-layer link-reflection lattice with all links
crossing the reflection plane, proving the abstract `Reflection` structure
is inhabited by the no-on-plane link-reflection geometry); `ReflectionWalk` (YM3
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
local opposite-compatibility hypothesis, plus a paired-family constructor for
families explicitly split into mirror partners, but still no Wilson action
reflection covariance, cut factorization, or RP inequality);
`PlaquetteReflectionEnsemble` (YM3 finite ensemble lift: under the same
mirror-stability and explicit local opposite-compatibility hypotheses, the
plaquette-product weight is reflection-invariant and reflecting only the
observable preserves numerator/expectation, with paired-family specializations;
still no concrete Wilson opposite-compatibility, cut factorization, or RP
inequality);
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
`CyclicityPrereq` (YM4/T9 statement-only prerequisite: names the abstract
finite algebraic condition that the local plaquette/operator algebra
cyclically spans the chosen sector from the vacuum; includes elementary
support lemmas that the vacuum lies in the generated cyclic submodule and
that a sector preserved by the algebra contains that generated submodule;
no transfer matrix or gap theorem is claimed);
`CenterFluxSector` (T3/Q3 Fable-redesign spine: abstract finite
center-shift/electric-sector API over a configuration space with shift
permutations; electric sectors as shift eigenconditions; shift-invariant
diagonal observables preserve sectors; shift-invariant finite kernels preserve
sectors by finite reindexing. It also adds a concrete finite-group torus
link-field model with x/y center-shift permutations and proves that all
plaquette holonomies, hence all observables factoring through the plaquette
field, are invariant under those shifts and preserve the abstract electric
sectors. This is non-vacuous electric-sector bookkeeping; it does not yet
construct the Q2 transfer matrix);
`FluxSectorGeneral` (T3/Q3 abstract finite sector-support API: sector label
maps, sector support predicates, diagonal sector projections, label-preserving
finite transfer kernels, pointwise projection behavior,
support iff projection-fixes, projection idempotence/orthogonality, finite
decomposition as a sum over sector projections, and the theorem that
label-preserving kernels preserve sector-supported wavefunctions and commute
with sector projections. This is definition/support bookkeeping only: no
physical finite-G flux labels, transfer-matrix construction, or spectral claim
is made here);
`FluxSectorZ2` (T3/Q3 first Z2-torus sector layer: names the two winding
flux bits, builds the trivial-flux predicate into the D12
`SymmetrySector`, records abstract quantum-number preservation lemmas, and
separates `fluxGap` from `localGlueballGap`; it also starts the concrete
Bool-array base-cycle winding-label realization, proves concrete Z2
vertex-gauge updates preserve winding labels, and proves diagonal local
observable multiplication preserves winding-sector support. The concrete Z2
projection API proves winding-sector projection idempotence/orthogonality,
pointwise projection behavior, support iff projection-fixes, decomposition as
the sum over all four winding labels, and that any winding-label-preserving
finite kernel preserves sectors and commutes with the winding-sector
projection. After Fable Q3 review the original support
layer is explicitly scoped as magnetic bookkeeping; arbitrary plaquette flips
are not claimed to preserve `windingLabel`, `QuantumNumbers` uses a sector
predicate instead of a total label on states, and the flux/local gap names are
marked irreducible to avoid silent definitional conflation. The file now also
starts the corrected electric/center-shift Z2 layer: concrete x/y center
shifts, plaquette-bit invariance under those shifts, electric sectors as base
shift eigenconditions, and preservation of those sectors by plaquette-bit
observables. It also proves the four-term electric-sector projections land in
the requested sectors, are idempotent, and sum to the identity over the four
Z2 electric sectors; any finite kernel invariant under the base center shifts
preserves every electric sector by finite reindexing. The actual Q2 transfer
matrix construction remains future work, but `TransferHilbertZ2Electric` now
connects the concrete Z2 shifts to the block OS range model);
`WilsonWeightPositivity` (YM3: Route B, the character-theory-free path to
the reflection-positivity kernel-PSD engine - all three handoffs closed
in-repo, zero `s o r r y`, axiom footprint
[propext, Classical.choice, Quot.sound]; includes `hadamard_posSemidef`,
a genuinely reusable Schur-product-theorem lemma this repo's pinned
Mathlib lacks under any name); `WilsonLocalWeight` (YM0/YM3 connector:
the Wilson local weight `exp(beta Re chi(h))` is a class function -
needing only multiplicativity of `rho`, not unitarity - so the T3
`PlaquetteEnsemble` skeleton is gauge invariant for the ACTUAL Wilson
weight, not just an abstract placeholder; also records unitarity-dependent
inversion symmetry as a prerequisite for later orientation/opposite-group
compatibility work; axiom footprint
[propext, Classical.choice, Quot.sound]); `WilsonReflectionCompatibility`
(YM3 connector, N3-corrected: after Aristotle `e6e46e9f`,
`ReflectionCore.reflectLinkField` carries the group inverse, so the old
`MulOpposite`/`rhoOppositeInv` bridge is gone. The Wilson reflection wrappers
now use the same-group identity `hol_mirrorPlaquette_eq_inv` plus the local
inversion-invariance hypothesis `hinv`, yielding Wilson-specialized reflected
single-plaquette/product-weight/ensemble-weight identities for mirrored
plaquette families and Wilson-language mirror-stable and paired-family
wrappers. This still does not prove cut-plaquette RP-LINK; the nontrivial
cut-kernel PSD assembly remains a separate Q1 shocking-tier target);
`ReflectionPositivityKernel` (YM3 RP-KER, the master finite
reflection-positivity assembly theorem: in mirror coordinates
`(positive, cut, mirrored-negative)`, if the reflected weight kernel at each
cut configuration is `Matrix.PosSemidef`, the Osterwalder-Seiler form is
nonnegative on all positive-side observables (`reflectionForm_nonneg`), with
end-to-end RP for factorized (no-cut-plaquette) and nonnegative-mixture
weight classes. It also includes `cutKernel_mul`,
`cutKernel_mul_posSemidef`, and `cutKernel_finset_prod_posSemidef`, the
connectors showing that pointwise products of reflected weights become
Hadamard products of cut kernels and that finite products preserve
cut-kernel PSD by complex Schur product closure. This reduces RP-LINK to
a kernel-PSD check in the Route B
engine's language; the remaining RP-LINK work is the geometric
mirror-coordinate parametrization from the T3 reflection stack and the
Wilson cut-plaquette kernel-PSD assembly via `wilsonKernel_posSemidef` +
Schur products - see the program document work queue. Mathlib-only imports
by design; axiom footprint [propext, Classical.choice, Quot.sound]);
`WilsonReflectionPositivity` (YM3 Q1 zero-cut instance: RP-KER meets a
GENUINE Wilson local weight function. `ReflectionDouble.doubleLattice`'s
mirror coordinates plus `doubledWilsonWeight` (the same Wilson weight
function applied independently to both mirror coordinates) instantiate
`ReflectionPositivityKernel.reflectionForm_nonneg_of_factorized` directly
(`doubled_wilson_reflectionForm_nonneg`), for any finite group, base
lattice, plaquette, and representation. After the N3 Route-B correction,
`mirrorPlaquette_liftPlaquettePos_hol` is now the general
independent-configuration bridge at `mirrorConfig a b`, and
`doubledWilsonWeight_eq_ensembleWeight_mirrorConfig` identifies the
factorized weight with the GENUINE two-plaquette
`PlaquetteEnsemble.weight` at those mirror-coordinate configurations. This
closes the zero-cut baseline plus ensemble-identification tier; the named
corollary `doubled_wilson_ensembleWeight_reflectionForm_nonneg` states the
RP inequality directly for that genuine ensemble weight. It is still not
the nontrivial cut-plaquette RP-LINK theorem: `doubleLattice` has no cut
links/plaquettes, and the shocking tier still needs an actual cut geometry
and a mirror-coordinate proof that the genuine cut-lattice weight has the
cut-factor form supplied by `WilsonCutPlaquettePositivity`; dependency footprint
[propext, Classical.choice, Quot.sound]);
`WilsonCutPlaquettePositivity` (YM3/Q1 cut kernel-algebra layer from Aristotle
`8271a64b`: proves the real-to-complex PSD bridge `posSemidef_map_ofReal`,
single Wilson cut-factor PSD `cutKernel_posSemidef_of_wilsonFactor`, and
reflection-positivity wrappers `reflectionForm_nonneg_of_wilsonFactor` and
`reflectionForm_nonneg_of_wilsonFactor_prod`. This closes the abstract
single-factor and finite-product kernel bridge by viewing each cut factor as a
principal submatrix of the Wilson one-plaquette kernel; it does not yet provide
the concrete cut-plaquette lattice, mirror-coordinate equivalence, or genuine
ensemble-weight identification. Dependency footprint
[propext, Classical.choice, Quot.sound]);
`TransferPositivity` (YM3, single-link
PSD congruence/compression engine, RENAMED and re-scoped 2026-07-04
after Aristotle red-team `cb437537`'s finding that the original
"Corollary 3b"/"transfer matrix" framing overstated what is indexed:
`transferMatrix_posSemidef`/`compression_posSemidef` are abstract
congruence/compression facts over ANY finite index type - no lattice
ensemble, tensor-product kernel, or Gauss projector exists yet;
`singleLinkWilsonKernel_diagCongruence_posSemidef` instantiates the
former at one temporal link's Wilson kernel; axiom footprint
[propext, Classical.choice, Quot.sound]); `TransferHilbert` (YM3/Q2 finite
OS/GNS statement layer: `reflectionPairing`, `rpHilbertSpace = range
(CFC.sqrt K)`, shift permutation matrices, proved shift/`CFC.sqrt`
commutation, preservation of the OS range under center shifts,
OS-form transfer symmetry/positivity, and the auxiliary
square-root-conjugated `compressedTransfer` facts. It is finite algebraic
infrastructure only: no physical transfer matrix, Hamiltonian, continuum
Hilbert space, or spectral gap is claimed; dependency footprint
[propext, Classical.choice, Quot.sound]); `TransferHilbertBlock` (YM3/Q2
block-instantiation layer from Aristotle `50024abf`: builds
`rpBlockMatrix W : Matrix (C x A) (C x A) Complex`, block diagonal in the
cut coordinate and agreeing with `ReflectionPositivityKernel.cutKernel W c`
on each block; proves same-cut/off-cut entry lemmas, the
`reflectionPairingVec` bridge from the block matrix's OS pairing to
`reflectionForm W`, and `rpBlockMatrix_posSemidef_of_reflectionPositive`.
This makes the finite OS/GNS range model concrete for reflection-positive
weights while still claiming no physical transfer matrix, Hamiltonian, or
gap); `TransferHilbertBlockShift` (YM3/Q2-Q3 bridge from Aristotle
`8e1e11b0`: product shift systems on block indices `C x A`, simultaneous
shift-invariance of the block weight `W a c b`, entrywise block-kernel
invariance, matrix commutation with block shifts, and preservation of
`rpHilbertSpace (rpBlockMatrix W)` under those shifts. This is still an
abstract finite algebraic bridge for later torus/Z2 instantiation, not a
physical transfer matrix, Hamiltonian, or spectral-gap theorem);
`TransferHilbertZ2Electric` (YM3/Q2-Q3 concrete adapter: the base Z2 electric
center-shift generators from `FluxSectorZ2` form the `ShiftSystem` used by
`TransferHilbertBlockShift`; any block weight depending on positive, cut, and
mirror configurations only through their full plaquette-bit fields is invariant
under simultaneous base shifts, so its `rpBlockMatrix` commutes with the block
shifts and the finite OS range is preserved. The file also defines the
four-term block electric-sector projection, proves that it lands in the
requested block electric sector, fixes vectors in that sector, is idempotent,
and preserves the finite OS range for plaquette-field block weights. This is
still a finite identity, not a physical transfer matrix or gap claim);
`BanksCasherShadow`
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
rather than guessed at); `PolymerKPConclusion` (YM4/T6 statement-freeze
layer after strategy job `2427a253` and review thread `review:q6-kp-freeze`:
ordered finite clusters, the cluster incompatibility graph on distinct slots,
the concrete direct finite definitions `spanningTreeCount` and `ursellSum`
recommended by Aristotle job `34d675b8`, an abstract `ClusterCoeffData`
interface with tree-graph-bound hypothesis, bare-KP absolute summability
reduced to a new partial-sum crux, and the Aristotle `071d1370` formal
counterexample showing the old bare-KP convergence target is false without
self-incompatibility. The corrected C2 target is
`kp_convergence_bound_of_selfIncompatible`, and the metric tail bound now
carries the same self-incompatibility plus explicit energy-distance coercivity.
The hard parked theorem is Penrose's concrete tree-graph inequality
`treeGraphBound_ursell`, not the count definition itself). Not part of the
default trusted build target; `StrongCouplingPolymerMap` (YM4/T7 statement
layer: finite plaquette polymers as nonempty connected finite supports with
support-indexed nontrivial labels, conservative overlap-or-touching
incompatibility, weights as products of absolute normalized label coefficients,
energy `alpha * area`, and the Z2 specialization `|tanh beta| ^ area` pinned to
the v0.3 oracle fixture. The support-localization API names the closed
touch-neighborhood of a root support and characterizes overlap-or-touch
incompatible supports as exactly those meeting it, including intersection and
positive-cardinality forms for finite counting filters, plus a generic
anchor-overcount inequality that bounds any nonnegative incompatible-support sum
by summing over anchors in the closed neighborhood and its direct specialization
to the explicit plaquette KP sum. It also names the explicit finite plaquette KP sum
`plaquetteKPSum`, the bound predicate `PlaquetteKPBound`, and the adapter
`kpCondition_of_plaquetteKPBound` from that explicit bound to
`PolymerKPCriterion.KPCondition`, plus the bundled handoff theorem
`kpCondition_and_selfIncompatible_of_plaquetteKPBound`; the draft connector
`plaquetteKP_convergence_bound_of_plaquetteKPBound` routes this explicit bound,
plus Q7 self-incompatibility, into the corrected Q6 convergence statement and
therefore has the same parked-Q6 proof dependency. No volume-uniform KP proof
or general finite-irrep coefficient map is claimed); `ExponentialClustering` (YM4/T8 statement bridge:
abstract connected-correlator data, named cluster-tail contribution, and the
kernel-checked implication from an explicit Q6-style tail bound plus an
observable-to-cluster bridge to exponential clustering, with `supportTail`
empty/singleton lemmas for finite-support specialization. No concrete plaquette
geometry, KP proof, or transfer-Hilbert statement is claimed).
Adding a new YM module? Import it here.
-/
