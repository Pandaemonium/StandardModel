# Scientific results overview

**State of the repository: July 21, 2026**

This document gives a single scientific account of the strongest results in
the repository. It is not a file inventory and it is not a manifesto. Its job
is to answer four questions:

1. What has actually been proved?
2. What physical idea does each proof support?
3. Which results are trusted foundations, and which remain in the guarded
   draft layer?
4. What still prevents the collection from being a complete physical theory?

The repository now contains several substantial and partly independent
research programs. The flagship is the null-edge reconstruction of mass and
relativistic dynamics. It is supported by formal work on gauge theory,
chirality, finite gravity, cosmology, octonionic Standard Model algebra,
exceptional Jordan algebra, and the Hamming-code construction of E8.

## Evidence key

The evidence grade is part of every headline below.

- **T (trusted):** a theorem in the non-`Draft` Lean tree, or in the standalone
  `CodeLatticeE8` publication root, checked with the project's narrow standard
  axiom footprint.
- **M (machine-verified draft):** a kernel-checked theorem in `PhysicsSM/Draft`,
  normally with a build-enforced axiom guard. It is mathematically proved as
  stated, but remains in draft because its conventions, packaging, or physical
  interpretation still need publication review.
- **M|H (conditional machine result):** a kernel-checked implication whose
  scientific force depends on displayed hypotheses that the project has not
  yet derived.
- **C (conjecture or interpretation):** a proposed physical identification or
  open reconstruction target.
- **No-go:** a proved obstruction or counterexample. These are positive
  scientific results when they eliminate an otherwise plausible architecture.

Lean checks formal statements, not the prose used to interpret them. A result
can therefore be mathematically exact while its identification with nature is
still open. That distinction is especially important in the null-edge,
gravity, and cosmology sections.

## Executive synthesis

| Result | Evidence | Scientific content | Present boundary |
| --- | --- | --- | --- |
| Finite Pluecker mass identity | T | Invariant mass squared of a finite null-spinor bundle is exactly its total pairwise directional disagreement. | Kinematics, not mass selection. |
| Future-cone completeness | M | Every future-causal four-momentum has an explicit finite decomposition into future-pointing null spinor edges with the same mass invariant. | Representation theorem, not ontology or dynamics. |
| Pluecker-derived Dirac rest operator | M | The same complex area determines the two-channel rest operator and its relativistic gap; no second mass parameter appears in that model. | Does not determine the value of the area. |
| Null histories and proper time | M | Null microscopic steps can have timelike aggregate drift and exactly reproduce the endpoint time-dilation identity. | Aggregate observable, not a microscopic clock theorem. |
| Local-unitary 3+1 continuum regulator | M | The live massive HNU update converges strongly in position-space `L2` to the free massive Dirac flow on a refining lattice. | Free, fixed-mass, one-particle theory. |
| Phase and holonomy observables | M | The phase discarded by the rest energy reappears in oriented histories, induced links, and ring spectra at every length greater than two. | No measured phase-defect prediction yet. |
| Four-channel carrier square | M | One finite Dirac-like carrier square separates aperture, closure, turn, and soldering-gradient residues. | The physical names and positivity are not universally forced. |
| Finite gauge and chiral infrastructure | M | Exact holonomy covariance, strong-coupling Wilson area-law models, Ginsparg-Wilson chirality, and finite index machinery coexist in one formal substrate. | Not continuum Yang-Mills or the QCD mass gap. |
| Finite gravity chain | M and M|H | Coframes, Lorentz transport, curvature, Bianchi identities, Palatini responses, and a conditional vacuum-Einstein limit have been formalized. | Decorations, refinement, and Levi-Civita selection are not yet derived from a bare causal graph. |
| Cosmological-constant fork | M and M|H | A finite unimodular/count model gives the exact `1/sqrt(V)` law under Poisson fluctuations and a precise hyperuniform alternative. | The physically conjugate count and its statistics are unknown. |
| Octonionic Standard Model core | T and M | A convention-safe octonion model supports the Furey ladder construction, an algebraic `SU(3)` stabilizer, the Standard Model `Z_6` quotient, anomaly bookkeeping, and Jordan-algebra routes. | It audits algebraic proposals; it does not derive the Standard Model. |
| Real spectrum of `h3(O)` | M | Every Hermitian 3 by 3 octonionic matrix has a real triple realizing its Freudenthal invariants; its characteristic cubic has nonnegative discriminant. | This is a spectral algebra theorem, not particle phenomenology. |
| Hamming code to E8 | T | The extended Hamming code yields an even self-dual E8 lattice with minimum norm 2, 240 roots, Cartan/Weyl structure, and theta-series bridges. | The standalone root is mainly finite/combinatorial; the full analytic theta identity uses an optional dependency. |

The most consequential synthesis is this: the repository has moved beyond a
single mass identity. It now contains an exact finite kinematic classification,
a compatible rest operator and history calculus, and a genuine free 3+1
continuum theorem. At the same time, it has proved enough no-go theorems to show
that neither observed mass scales, interacting quantum field theory, nor
general relativity follows automatically from that core.

## 1. Invariant mass as null-direction disagreement

The strongest trusted result is the finite Pluecker-mass theorem in
[`PhysicsSM/Spinor/PluckerMass.lean`](PhysicsSM/Spinor/PluckerMass.lean).
Represent a future-null momentum by a two-component complex spinor `psi` and
the rank-one Hermitian matrix `psi psi^dagger`. For a finite bundle, let

```text
P = sum_i psi_i psi_i^dagger.
```

Then **T**:

```text
det P = sum_{i<j} |psi_i wedge psi_j|^2.
```

The right-hand side is a sum of nonnegative squared complex areas. The same
module proves:

- one rank-one edge has zero determinant;
- the identity holds for every finite bundle;
- the determinant is real and nonnegative;
- the mass vanishes exactly when all occupied spinor directions share one
  projective direction.

The principal anchors are `two_edge_plucker_mass_identity`,
`fin_bundle_plucker_mass_identity`, `fin_bundle_det_re_nonneg`, and
`fin_bundle_mass_zero_iff_common_direction`. The twistor-coordinate companion
is [`PhysicsSM/Spinor/TwistorPluckerMass.lean`](PhysicsSM/Spinor/TwistorPluckerMass.lean).

This gives a precise meaning to the phrase "mass from disagreeing null
directions": invariant mass squared is not merely correlated with the
disagreement; in this finite representation it is the total squared
disagreement.

### Kinematic completeness

[`PhysicsSM/Draft/NullEdge/PluckerMassKinematicCompleteness.lean`](PhysicsSM/Draft/NullEdge/PluckerMassKinematicCompleteness.lean)
closes the converse at draft-machine grade. It proves **M**:

- a complex 2 by 2 matrix is positive semidefinite exactly when it is a finite
  sum of spinor outer products;
- every nonnegative mass value has an explicit Pluecker witness;
- the Pauli map between real four-vectors and Hermitian matrices has the
  required round trips and determinant/Minkowski-square identity;
- every future-causal four-vector is represented by a finite bundle of
  explicitly future-pointing null spinor edges;
- the Minkowski mass squared of that vector is exactly the bundle's pairwise
  Pluecker mass.

The headline theorem is
`forwardCone_complete_futureNullEdge_representation`.

[`PhysicsSM/Draft/NullEdge/FiniteLorentzMassCasimir.lean`](PhysicsSM/Draft/NullEdge/FiniteLorentzMassCasimir.lean)
adds a finite symmetry audit. Within symmetric quadratic forms, invariance
under the displayed rational rotations, half-turns, and boost, together with
one normalization, forces the Minkowski metric. Its capstone
`lorentzAudited_nullEdge_mass_complete` composes that uniqueness result with
future-cone completeness. This is **M**, but it is a finite audit of a chosen
generating test set, not a formal classification of all Poincare Casimirs.

### What this establishes, and what it does not

The repository can now defend the following narrow completeness claim:

> Every mass value carried by a future-causal four-momentum can be represented
> exactly as the pairwise Pluecker area of a finite bundle of future null
> edges.

It cannot yet defend the stronger dynamical claim that all observed masses are
generated by one universal Pluecker action. The theorem does not select a
momentum, a particle state, an absolute scale, or a hierarchy of scales.

## 2. The same complex area generates a Dirac gap

For two spinors, the wedge is complex:

```text
z = psi wedge phi.
```

[`PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean`](PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean)
constructs the Hermitian odd two-channel operator

```text
B_z = [[0, z], [conj z, 0]].
```

It proves **M**:

```text
B_z^2 = |z|^2 I = det(P) I,
H(k,z)^2 = (k^2 + |z|^2) I.
```

The theorem `oddHermitian_eq_massOperator` also gives a uniqueness statement
inside the displayed two-channel Hermitian/odd symmetry class. Thus the same
quantity that measures the aperture between null directions supplies the
relativistic rest gap. The phase of `z` is retained by the operator even though
the energy spectrum sees only `|z|`.

The adjacent modules provide exact finite dynamics:

- [`PluckerMassDynamics.lean`](PhysicsSM/Draft/NullEdge/PluckerMassDynamics.lean)
  gives unitary rest evolution and conservation identities;
- [`ComplexPlueckerCheckerboardPathSum.lean`](PhysicsSM/Draft/NullEdge/ComplexPlueckerCheckerboardPathSum.lean)
  identifies repeated transfer with a sum over oriented null histories;
- [`VariablePlueckerLocalWalk.lean`](PhysicsSM/Draft/NullEdge/VariablePlueckerLocalWalk.lean)
  permits a site-dependent complex mass field while preserving exact locality
  and unitarity;
- [`VariablePlueckerPhaseConnection.lean`](PhysicsSM/Draft/NullEdge/VariablePlueckerPhaseConnection.lean)
  proves that a local phase change induces endpoint link data.

This is the repository's strongest answer to the "renamed mass" objection:
`z` is derived from null-spinor geometry and controls the rest operator,
oriented histories, and local phase transport simultaneously. The remaining
objection is dynamical: no theorem yet selects the physical value or spatial
profile of `z`.

## 3. Null microscopic support and timelike aggregate observables

The project distinguishes three notions that are often conflated:

1. primitive support on null links;
2. the front speed of the resulting evolution;
3. the subluminal drift of a massive wave packet.

[`PhysicsSM/Draft/NullEdge/NullTickProperTime.lean`](PhysicsSM/Draft/NullEdge/NullTickProperTime.lean)
gives the cleanest exact finite statement. For a 1+1 history with right- and
left-moving null tick counts, the endpoint proper time obeys **M**:

```text
tau^2 = 4 epsilon^2 n_plus n_minus
      = t^2 (1 - v^2).
```

Straight histories are null; mixed-direction histories have positive proper
time. A balanced two-tick history is an explicit nonzero witness. Proper time
is therefore an aggregate endpoint invariant in the model, not time accumulated
by each null edge.

The trusted checkerboard layer and guarded complex path-sum successors show how
mass weights turns between null propagation channels. They do not assert a
hidden classical zigzag trajectory for a quantum particle.

## 4. A local-unitary 3+1 regulator with a continuum theorem

The 3+1 program originally found several obstructions to the smallest literal
checkerboard constructions. Its successful route relaxes one assumption:
spatial transport remains local and projector-conditioned, while mass is an
onsite internal turn or "stay" operation. A stay is not a classical particle
waiting in place; it is amplitude undergoing a local internal update rather
than being assigned to a spatial shift in that substep.

[`PhysicsSM/Draft/NullEdge/HNUPlueckerMassiveStay.lean`](PhysicsSM/Draft/NullEdge/HNUPlueckerMassiveStay.lean)
builds the live four-component update from doubled opposite-chirality HNU
transport and a Pluecker mass coin. It proves **M**:

- exact unitarity of the finite step;
- exact rest reduction to the Pluecker mass coin;
- the simultaneous infrared derivative
  `-i (kinetic4(q) + mass4(z))`;
- a nondegenerate complex-mass witness.

The major analytic capstone is
[`PhysicsSM/Draft/NullEdge/HNUMassiveChangingLatticeContinuumCapstone.lean`](PhysicsSM/Draft/NullEdge/HNUMassiveChangingLatticeContinuumCapstone.lean).
For nonzero fixed complex mass `z`, fixed time, and every componentwise
square-integrable four-spinor momentum field, it proves **M** that the actual
cell-projected live HNU evolution converges strongly in position-space `L2` to
the exact free massive Dirac evolution as the lattice is refined. The proof
controls three separate errors: live versus cell-center evolution, cell-center
versus running-momentum exact flow, and projection tails. Plancherel transports
the complete estimate to position space.

[`HNUMassiveSchwartzPDE.lean`](PhysicsSM/Draft/NullEdge/HNUMassiveSchwartzPDE.lean)
identifies the continuum multiplier with the massive Dirac differential
operator on Schwartz data. `HNUMassiveMaximalMultiplier` and
`HNUFourierPositionOperator` develop the corresponding operator domains.

This is a real continuum result, not merely agreement of Taylor coefficients
at one momentum. Its present scope is still decisive:

- free one-particle evolution;
- a fixed supplied mass field rather than a dynamically selected spectrum;
- no interacting renormalized QFT limit;
- no derivation of the physical projection from a microscopic constraint;
- no Standard Model gauge and anomaly sector in the same continuum theorem.

## 5. Phase, holonomy, spin, and oriented histories

Mass energy retains `|z|` and discards the phase of `z`. The repository has
shown that the discarded phase is not automatically empty bookkeeping.

The variable-phase modules prove exact endpoint covariance and link induction.
The ring family culminates in
[`PhysicsSM/Draft/NullEdge/RingHolonomyAllN.lean`](PhysicsSM/Draft/NullEdge/RingHolonomyAllN.lean):
for every ring length `n > 2`, a change in the real holonomy produces a spectral
non-conjugacy witness. The half-link construction gives a nontrivial ring with
total turning `2 pi` and holonomy `-1` at every such length. These are **M**
finite spectral observables, not just gauge-dependent local phases.

The "spiral layer" sharpens the geometric content:

- the checkerboard corner factor `i` is derived as a quarter-turn phase;
- polygonal corner phases obey half-solid-angle laws;
- planar zigzag content is CP-inert in the formalized class;
- CP-odd terms arise from oriented volume in the finite Jarlskog toy;
- smooth closure can retain phase without a magnitude penalty, while kinks
  have an exact multiplicative cost;
- framed Wilson loops inherit the strong-coupling area-law exponent with a
  separately controlled corner factor.

These results are guard-pinned **M** statements in the `SpinCorner*`,
`Bargmann*`, `CapSquareBerry*`, and `GateYM/FramedAreaLawTransfer` modules.
They provide a coherent finite geometry of orientation, but they do not derive
the physical CKM phase or a measured topological defect spectrum.

## 6. One carrier square and four residues

The finite carrier program studies a Dirac-like operator of the schematic form

```text
D = sum_e c(alpha_e) nabla_e + Gamma phi.
```

The guard-pinned Weitzenboeck master theorem under
[`PhysicsSM/Draft/NullEdge/Carrier/`](PhysicsSM/Draft/NullEdge/Carrier/)
separates its square into four algebraically different terms:

- **aperture:** disagreement among null directions;
- **closure:** commutator or loop-transport residue;
- **turn:** conversion between graded propagation sectors;
- **soldering gradient:** variation of the map from internal directions to
  spacetime directions.

The identity is **M**. The aperture slot has an exact bridge to the trusted
Pluecker invariant, and explicit witnesses show that the blocks can be
independent. Finite McKean-Singer modules prove that an unbalanced chiral index
forces a massless surplus mode for every allowed potential and transport,
whereas a balanced witness can be fully gapped.

The important negative result is that an abstract four-term decomposition is
not unique without additional physical selectors. Concrete coefficient
rigidity can hold on a witness, but global naturalness, positivity, locality,
information monotonicity, or continuum behavior must choose among possible
decompositions. Therefore the four names are a structured physical dictionary,
not a theorem that nature has exactly four and only four mass substances.

## 7. A scoped taxonomy of mass mechanisms

The repository now separates the kinematic completeness theorem from a
mechanism grammar in
[`PhysicsSM/Draft/NullEdge/ScopedMassMechanismGrammar.lean`](PhysicsSM/Draft/NullEdge/ScopedMassMechanismGrammar.lean).
Within its deliberately finite syntax, `classified_iff_admissible` proves **M**
that every admissible expression is assembled from registered mechanism
constructors and readouts. This is syntax-level closure, not a classification
of every local action in quantum field theory.

The surrounding mechanism modules formalize these distinct sources:

- **fermion masses:** chiral maps and Pluecker/Dirac turns;
- **electroweak gauge masses:** the positive semidefinite Gram form of the
  vacuum orbit, with the photon as the stabilizer kernel;
- **Higgs mass:** the radial Hessian of a supplied scalar potential;
- **Dirac and Majorana neutrino branches:** finite matrix models and seesaw
  relations, with arbitrary-generation Takagi factorization still an active
  gate;
- **composite mass:** finite binding and constituent-energy transfer models;
- **confinement-related mass:** strong-coupling and finite spectral machinery,
  but no derivation of the proton mass.

The shared Higgs-sector capstones show how one supplied vacuum scale can feed
fermion, vector, and radial responses while independent dimensionless
couplings retain their own freedom. Consequently the project does not yet
derive absolute masses or their observed ratios. It has a strong account of
the possible readout structures, not a completed mass spectrum.

## 8. Finite many-fermion and interaction structure

The one-particle results have been lifted partway toward field theory.
`FiniteCARFockBasic` proves generic finite fermionic sign and exclusion rules.
`FiniteCARSecondQuantization` constructs the determinant-minor lift of a
one-particle update, with vacuum, one-particle, number, and parity controls.
`FiniteFermionicLocality` and related modules formalize finite locality.

`PlueckerQuarticInteraction` gives a phase-sensitive pair-transfer operator:
one-particle basis states are fixed while an explicit two-particle sector is
changed with forward/reverse amplitudes `z` and `conj z`. This is **M** evidence
that Pluecker phase can become operational in an interaction sector rather
than merely reparametrize a one-particle gap.

The missing bridge is large: a local interacting Fock update with complete
unitarity and gauge constraints, followed by scattering or bound-state
observables and a continuum limit. The current finite interaction laboratories
do not constitute a quantum field theory.

## 9. Gauge theory, confinement, and chirality

The gauge sector has three notable machine-verified components.

First, finite `U(1)` and nonabelian path transport prove the expected endpoint
covariance, closed-loop gauge invariance or conjugation, and trace invariance.
These results make the closure channel concrete.

Second, the `GateYM` program formalizes strong-coupling Wilson-loop machinery:
rectangular tree and boundary expectations with area-law behavior, reflection
positivity kernels, finite transfer gaps, center-flux sectors, and controlled
area/perimeter transport. These are **M** finite-lattice or conditional
strong-coupling results. They are not a proof of the continuum four-dimensional
Yang-Mills mass gap.

Third, the Gate C modules develop Ginsparg-Wilson and overlap chirality,
finite index identities, spectral-flow controls, and explicit doubling
obstructions. The project has a credible finite chirality substrate, but has
not yet composed it with the full interacting 3+1 regulator and the complete
Standard Model anomaly content.

## 10. Causal geometry and finite gravity

The gravity program is best read as a ladder rather than one theorem.

### Operator and coframe reconstruction

The causal-operator modules construct exact finite order-based difference
operators, corrected pairings, and nondegenerate coordinate-probe witnesses.
They show that a rank-four mostly-minus bilinear form can be recovered in a
specified finite calibration. Separately, four independent spinor null edges
produce a coframe, its Gram metric, inverse, and volume. These are **M** finite
reconstructions.

The key boundary is explicit: causal order supplies conformal information,
while a physical scale and a choice of frame still require decoration or a
separate reconstruction theorem. A bare finite graph has not been proved to
choose a canonical tetrad.

### Connection, curvature, and conservation

The finite connection chain formalizes:

- directed Levi-Civita coefficients and coordinate curvature;
- torsion and Cartan identities;
- algebraic and contracted Bianchi identities;
- source conservation conditional on the corresponding Einstein equation;
- periodic group-valued links and plaquette holonomy;
- the six-component Lorentz-bivector representation and its Krein pairing.

These are **M** exact finite geometric identities, with conventions assembled
in [`PhysicsSM/Draft/NullEdge/GRFoundations.lean`](PhysicsSM/Draft/NullEdge/GRFoundations.lean)
and the spine document
[`Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md`](Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md).

### Action and field equations

The nonlinear Palatini chain builds a finite Lorentz-holonomy/coframe action,
computes exact link and coframe variations, obtains local Euler coefficients,
and relates coframe stationarity to mixed vacuum Einstein equations. It also
constructs a nonzero algebraic vacuum-Weyl target.

The continuum capstone is **M|H**: if a refinement supplies the stated
convergence of coframes and the action-visible curvature, then finite
stationarity passes to the limiting mixed vacuum Einstein equation. This is a
substantial formal action-to-equation bridge. It is not an unconditional
derivation of general relativity from causal order.

The gravity no-go results are equally informative: a fixed affine interval
action has no nontrivial stationary point; null-column-preserving variations
do not span all metric variations; a natural forward-difference Christoffel
candidate fails stationarity on an explicit conformal witness; and several
periodic vacuum-Weyl ansatze are obstructed. These results force the live route
toward aggregate coframe variations, genuine group-valued holonomy, and weak
rather than naive pointwise continuum convergence.

## 11. The cosmological constant as a count-sensitive sector

The cosmology program isolates an exact arithmetic and finite-functional core
in the `Lambda*` modules and
[`Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex`](Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex).

It proves **M**:

- the finite order-zero spectral coefficient is blind to deformations of the
  operator, while higher moments can change;
- under the displayed finite unimodular constraint, a uniform vacuum shift is
  traded against the multiplier and is gauge-like on the constraint surface;
- if `Lambda = delta N / V` and `Var(N) = V`, then
  `Lambda_rms = 1 / sqrt(V)` exactly;
- the framework's finite edge count is additive and monotone, so the scaling
  can be stated using its own primitive count;
- for `Var(N) ~ N^alpha`, the exponent is exactly
  `alpha/2 - 1`, with the everpresent value `-1/2` if and only if `alpha = 1`;
- finite fermionic correlation models realize both an extensive diagonal
  branch and a genuinely subextensive projection-kernel branch;
- a finite Fourier register obeys support-uncertainty relations, generalized
  to all cyclic sizes in the successor module.

This yields a sharp scientific fork. A Poisson count supports everpresent
`Lambda ~ 1/sqrt(V)`. A hyperuniform physical count suppresses it and kills
that identification. The unresolved issue is not the exponent arithmetic but
which count the physical theory makes conjugate to four-volume, and what
statistics its dynamics imposes. The sign, observed value, stochastic law,
and a native Henneaux-Teitelboim conjugacy remain open.

## 12. Octonions and Standard Model algebra

The non-draft octonion foundation is one of the repository's deepest trusted
assets. Under the fixed XOR-basis convention, it proves **T** explicit
multiplication and conjugation laws, norm multiplicativity, left and right
alternativity, flexibility, and all three Moufang identities. The convention
bridge prevents formulas from Baez and Furey from being imported with silent
sign errors.

[`PhysicsSM/Algebra/Octonion/TrialityCompanions.lean`](PhysicsSM/Algebra/Octonion/TrialityCompanions.lean)
proves **T** a triality-conjugation criterion: for a unit octonion `a`, the
explicitly parenthesized map `(a*x)*conj(a)` preserves multiplication exactly
when the chosen cube of `a` is `1` or `-1`, together with the corresponding
order-three iteration result.

The Furey route proves **T/M**, depending on the module:

- the complex-octonionic ladder operators and all 27 `Cl(6)` CAR relations;
- the primitive idempotent and eight-state minimal left ideal;
- the full action table, number-operator and electric-charge eigenvalues;
- operator-level Gell-Mann-Nishijima consistency;
- weak-isospin raising/lowering packages and anomaly arithmetic;
- a one-generation realization interface with an explicit boundary around the
  conventional right-handed completion.

The Baez/DVT and gauge-group routes prove **T/M**:

- the algebraically defined octonion automorphisms fixing the chosen imaginary
  unit are multiplicatively equivalent to `SU(3)` in the precise finite model;
- the Standard Model covering has the exact six-element kernel and a quotient
  equivalence to the block group;
- the coordinate `h3(O)` model satisfies the Jordan identity;
- the complement of the chosen `h3(C)` sector carries the formalized DVT
  two-sided action and its central `Z_3` quotient structure;
- commuting family actions transport charge tables, eigenvectors, and anomaly
  sums.

The detailed claim boundary is in
[`Sources/Furey_Baez_Octonion_SM_Formalization_Manuscript_2026-07-11.tex`](Sources/Furey_Baez_Octonion_SM_Formalization_Manuscript_2026-07-11.tex).
These theorems verify and connect algebraic proposals. They do not prove that
the Standard Model is uniquely forced, derive three physical generations,
produce a Lagrangian, or calculate masses and mixings.

## 13. Exceptional Jordan algebra: an unconditional real spectrum

[`PhysicsSM/Draft/H3ORealSpectrumUnconditional.lean`](PhysicsSM/Draft/H3ORealSpectrumUnconditional.lean)
proves **M** that every element of the coordinate Hermitian 3 by 3 octonionic
Jordan algebra has real numbers `r,s,t` whose elementary symmetric functions
are exactly its trace, quadratic invariant, and Freudenthal determinant. It
then proves that the associated characteristic cubic has nonnegative
discriminant.

The proof route is notable. It replaces the off-diagonal octonion triple by a
complex Hermitian witness with the same norms and real triple product, uses
Mathlib's Hermitian spectral machinery there, and transports the invariant data
back. This is a clean formal bridge across nonassociativity rather than an
attempt to treat octonionic matrices as ordinary associative matrices.

## 14. Hamming code, Construction A, and E8

The standalone [`CodeLatticeE8.lean`](CodeLatticeE8.lean) artifact is the
repository's most publication-ready independent theorem chain. Its trusted
root proves **T**:

- the concrete extended binary Hamming `[8,4,4]` code, its self-duality,
  Type-II property, and uniqueness up to code equivalence;
- generic Construction A evenness and self-duality results;
- an explicit basis spanning the Hamming Construction A lattice;
- scaled Gram determinant `1` and minimum squared norm `2`;
- exactly 240 short vectors;
- a complete semantic list of the 240 E8 roots;
- a Hadamard-coordinate bijection between the Construction A short shell and
  the standard doubled-coordinate root list;
- the E8 Cartan determinant, Gram-Cartan congruence, and simple-root Dynkin
  data;
- closure of the roots under Weyl reflections;
- closure of the 240-unit octavian shell under multiplication;
- finite theta coefficients and the all-shell Construction A convolution.

The optional `CodeLatticeE8SPL` root composes the package with
Sphere-Packing-Lean to obtain the analytic/modular bridge to
`Theta_E8 = E4`. The standalone root intentionally distinguishes that
dependency-backed theorem from its own finite combinatorial theta results.

The audit map is
[`Sources/CodeLatticeE8_Publication_Theorem_Map.md`](Sources/CodeLatticeE8_Publication_Theorem_Map.md),
and the compile-checked index is
[`CodeLatticeE8/Publication/TheoremIndex.lean`](CodeLatticeE8/Publication/TheoremIndex.lean).

## 15. Information-theoretic readings

Several finite normalized models identify the same 2 by 2 determinant with
linear entropy, loss of visibility, distinguishability, or compression cost.
The massless rank-one locus is simultaneously the pure-direction locus, while
positive determinant records unresolved directional alternatives. The
`ParticleInformationCapstone`, `InformationResourceBridge`, and related modules
make these correspondences exact in their stated finite settings.

The correct interpretation is restrained: these are mathematically linked
readings of one invariant, not several independent confirmations that physical
mass is thermodynamic entropy. A universal resource theory of mass, with
physically justified free operations and monotonicity under the full dynamics,
remains open.

## 16. The no-go map

The repository's negative results have changed the direction of the program.
The most important are:

- **No scale from homogeneous positive Pluecker energy.** Uniform rescaling
  drives the simplest action to the zero configuration; a nonzero mass scale
  requires a competing scale, anomaly, boundary condition, or RG mechanism.
- **No canonical four-channel split from algebra alone.** Decompositions of a
  quadratic mass functional are nonunique without additional selectors.
- **No smallest naive 3+1 checkerboard with every desired property.** Minimal
  range-one/separable designs retain high-frequency copies or fail one of
  unitarity, locality, isotropy, and the Dirac tangent.
- **No stationary-amplitude shortcut.** Several constant or degree-one onsite
  repairs cannot remove the unwanted branches in the scoped architectures.
- **No no-doubling theorem from retardedness alone.** Coefficient-zero tests do
  not replace determinant-level mass-shell analysis.
- **No bare-graph tetrad for free.** Causal order controls conformal structure;
  scale and frame data remain an explicit debt.
- **No generic gap-to-particle inference.** A spectral gap does not guarantee a
  pole with nonzero observable overlap.
- **No automatic everpresent cosmological constant.** Hyperuniform count
  statistics change the exponent and can kill the Poisson mechanism.
- **No generation theorem from triality naturality alone.** Relabeling and
  anomaly preservation do not establish three inequivalent physical families.

The practical consequence is a more mature theory architecture. The surviving
program uses local internal turns rather than insisting on movement in every
substep, changing-lattice `L2` convergence rather than fixed-momentum Taylor
matching, group-valued holonomy rather than additive curvature guesses, and
explicit physical selectors rather than declaring one decomposition canonical.

## 17. What the repository can claim now

The following statements are supportable when their evidence grades are kept
visible:

1. **Complete finite mass kinematics:** every future-causal four-momentum can
   be represented by future null edges, and its invariant mass squared is their
   total Pluecker disagreement.
2. **A derived free fermion gap:** in the stated finite two-channel and 3+1
   models, the same complex Pluecker area supplies the mass operator, history
   turn, and free Dirac continuum gap.
3. **A genuine free 3+1 continuum result:** the live local-unitary HNU
   regulator converges strongly to the free massive Dirac flow under explicit
   `L2` hypotheses.
4. **A broad verified finite architecture:** gauge holonomy, chirality,
   many-fermion signs, finite gravity, cosmological count scaling, octonionic
   Standard Model algebra, exceptional Jordan spectra, and E8 coding geometry
   have all been developed far beyond sketches.
5. **A falsifiable program rather than a completed theory:** the repo states
   sharp conditions under which its physical interpretations fail.

The repository cannot yet claim:

- a derivation of all observed masses, their scales, or their ratios;
- an interacting 3+1 quantum field theory with the Standard Model content;
- the QCD mass gap or proton mass from null-edge dynamics;
- a unique derivation of the Standard Model gauge group and three generations;
- unconditional emergence of a Lorentzian manifold and Einstein dynamics from
  a bare finite causal graph;
- a derivation of the Higgs potential, cosmological constant, or dark-energy
  sign and value;
- a held-out empirical prediction not fitted by free parameters.

## 18. Highest-value next scientific gates

1. **Mass selection:** construct a natural action, ensemble, or RG flow with a
   stable nonzero Pluecker scale and a computable fluctuation spectrum.
2. **Interacting 3+1 completion:** second-quantize the live regulator, prove
   locality and leakage control, add gauge constraints, and calculate one
   scattering or bound-state observable.
3. **Physical-sector selection:** derive the continuum band/projector and its
   transport from the live update, rather than supplying the sector by hand.
4. **Mechanism completeness:** lift the scoped grammar to a theorem about a
   clearly defined class of local quadratic actions, including Dirac,
   Majorana, gauge, scalar, and composite branches.
5. **Graph-to-geometry reconstruction:** derive frame and scale data from
   causal/order/count information with refinement stability, then discharge
   the hypotheses in the finite Einstein-limit theorem.
6. **Cosmological count identification:** determine whether the conjugate count
   is Poisson, thermal, projection-weighted, or hyperuniform in the physical
   state selected by the theory.
7. **Standard Model synthesis:** close the right-handed Furey sector, arbitrary
   generation Majorana/Takagi structure, chirality/anomaly composition, and a
   nontrivial family mechanism.
8. **Empirical leverage:** identify one phase-defect, regulator, scattering,
   scaling, or cosmological observable whose coefficient is not freely fitted.

## 19. Reproducibility entry points

- Repository trust and build rules: [`AGENTS.md`](AGENTS.md),
  [`docs/BUILD.md`](docs/BUILD.md)
- Master document index: [`docs/DOCUMENT_MAP.md`](docs/DOCUMENT_MAP.md)
- Null-edge result map: [`NULL_EDGE_RESULTS.md`](NULL_EDGE_RESULTS.md)
- Concise null-edge impact statement: [`IMPACT_STATEMENT.md`](IMPACT_STATEMENT.md)
- Origin-of-mass manuscript:
  [`Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md`](Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md)
- 3+1 technical manuscript:
  [`Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`](Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex)
- GR spine:
  [`Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md`](Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md)
- Octonion/Standard Model manuscript:
  [`Sources/Furey_Baez_Octonion_SM_Formalization_Manuscript_2026-07-11.tex`](Sources/Furey_Baez_Octonion_SM_Formalization_Manuscript_2026-07-11.tex)
- E8 theorem map:
  [`Sources/CodeLatticeE8_Publication_Theorem_Map.md`](Sources/CodeLatticeE8_Publication_Theorem_Map.md)

The overview should be updated when a result changes trust level, a conditional
hypothesis is discharged, a no-go kills a listed route, or a new theorem changes
the scientific boundary rather than merely adding infrastructure.
