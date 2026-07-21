# Null-edge publication portfolio

Updated: 2026-07-12.

This document supersedes the June P1-P12 publication plan. The older topic IDs
remain useful for provenance, but they no longer define the paper portfolio.
The current program has a much clearer scientific spine:

```text
null spinors
-> complex Pluecker field
-> canonical Hermitian rest operator
-> exact local unitary dynamics
-> locality, topology, continuum, and many-body consequences
```

The publication strategy should follow that spine. A subsystem becomes a paper
only when it supports one memorable claim that a skeptical reader can test.
Formalization is a major strength and a reproducibility standard, but it is not
a substitute for the paper's physics or mathematics headline.

## Portfolio at a glance

| Order | Working paper | Current state | Submit when | Primary venue lane |
| --- | --- | --- | --- | --- |
| A | Null-spinor area as a canonical Dirac rest gap | Active flagship draft | full-Bloch claims close or are scoped; release audit passes | J. Phys. A / J. Math. Phys.; PRResearch or Quantum after one upgrade gate |
| B | Locality, doubling, and mass in strict 3+1 Dirac QCAs | Active theorem program | exact all-zone classification plus a sharp no-go or viable successor | Phys. Rev. Research / Phys. Rev. A / J. Phys. A |
| C | Winding insufficiency and exact compression modes in spinor-derived walks | Exact finite core; general protection gated | derived winding alone underdetermines the mode-pinning compression; a positional compatibility condition repairs the four-site bridge | J. Phys. A / Phys. Rev. A; Quantum / SciPost / PRR only after general-length stability |
| D | A changing-lattice continuum limit for unitary Dirac walks | Analytic core landed; main bridge open | explicit sampling/interpolation and position-space PDE convergence close | Ann. Henri Poincare / J. Math. Phys. / J. Phys. A |
| E | Finite CAR lifting and Pluecker-phase two-particle dynamics | Active | Fock lift is unitary and local; one operational two-particle quantity is calculated | Quantum / Phys. Rev. Research / J. Math. Phys. |
| F | Moduli and natural selection of finite carrier decompositions | Classification program activated | type-only moduli plus a necessary-and-sufficient selector theorem or sharp residual-ambiguity no-go | Ann. Henri Poincare / J. Math. Phys. / J. Phys. A |
| G | Machine-checked finite relativistic quantum dynamics in Lean 4 | Library paper, not yet mature | reusable APIs, trusted promotion, and proof-engineering lessons are packaged | Journal of Automated Reasoning; ITP/CPP conference-first |
| H | Finite null information: a synthesis and research program | Deferred synthesis | at least three core research papers exist and the synthesis makes new cross-paper deductions | invited/presubmission Perspective, review, or monograph |

The practical order is `A`, then whichever of `B` or `C` closes first. Papers
`D` and `E` should follow as independent technical contributions. Papers `F`
and `G` need consolidation rather than more theorem accumulation. Paper `H` is
earned by the preceding series; it should not be used to introduce claims that
the theorem papers have not established.

### Overnight gate movements (2026-07-19, saturation run; kernel-verified)

- **Paper D**: the strong `Lp` derivative at zero for the exact
  momentum-multiplier orbit on bounded-support elements is PROVEN
  (`CompactSupportL2Generator.orbit_slope_tendsto`, zero holes, guarded).
  The whole-orbit flow-derivative successor is in flight (`ce693fe2`).
- **Paper E**: the canonical-bridge gap is CLOSED - the canonical pair
  evolution is kernel-certified as the exact matrix exponential of the
  canonical generator (`PairExponentialCanonicalBridge`, three theorems, no
  mismatch factors, guarded). The operational two-particle transition law
  (Rabi probability + Pluecker-phase pairing) is staged for submission.
- **Hurwitz** (feeds the audit-paper lane): stage-4a ladder ALL PROVEN
  (5/7 hole-independent); the stage-5 saturation endgame
  (`finrank ∈ {1,2,4,8}`) is in flight (`d315d977`), with the Moufang
  intermediate course-corrected (sign error found by the prover, honest
  rename in progress).
- **Spin(10) selector lane**: S1 transitivity REFUTED as stated (diagonal
  stratum defect; kernel counterexample active); repaired scaffolding
  (`ProjectivelyDistinct`, `StandardizablePair`, conditional reduction)
  integrated; corrected S1 in flight (`215bd4d5`). S2/S4 defect analysis
  archived with the proof plan.
- **A / B / C / audit lanes**: odd-`n` ring-holonomy witness, zero-or-pi
  combined doubling gate, kernel-only four-site certificates, and the
  three division-algebra audit jobs (colour isospin, census table, grading
  family no-go) all in flight; first-wave returns pending.
- Fleet record and per-job metadata:
  `AgentTasks/overnight-aristotle-saturation-2026-07-18.md`.

### Final overnight movements (2026-07-19 ~05:00; post-budget-kill harvest)

The Aristotle key ran OUT_OF_BUDGET ~04:10 and all 13 in-flight jobs were
killed; every artifact was harvested and dispositioned (same fleet record).
Net paper-facing movements, all kernel-verified at the pin:

- **Paper A**: the ring-holonomy spectral chain now holds at EVERY ring
  length `n > 2` - `RingHolonomyAllN` hole-free (even-`n` trace formula
  with the `n C(n, n/2)` constant; all-`n` discriminator; all-`n`
  half-link witness; standard-three axiom audit). The paper's abstract
  chain no longer needs the parity hypothesis.
- **Audit paper**: (1) S2b weak-isospin doublet - all seven B-ladder su(2)
  targets returned proven with exact +-1/2 eigenvalues and coefficient-1
  ladder maps; (2) eq-39/40 colour census REFUTED-as-defined (colour
  single-excitation slots exactly zero; wrong side of the idempotent -
  convention finding + rebuild queued); (3) Chevalley incidence basis
  case + equivariance landed with the normal-form transport bridge;
  (4) `creationRootEnd_mem` - creation-root operators proven inside the
  even Clifford group (the exp(B) membership gate).
- **Paper C**: kernel-only certificates full success at the true clearing
  scale 5; the full-walk census remains open (returned docstring
  over-claim corrected at harvest - discipline case study for the paper).
- **YM lane**: polymer-KP module closed hole-free with corrected
  conditional shapes + a new two-polymer kernel refutation.
- **Hurwitz**: Moufang closure attempt found CIRCULAR at audit; the
  hole-free merge stays gated (Artin-linearization route pre-scoped for
  the next budget window).
- **Service state**: no further submissions possible until budget is
  restored; staged packages + registry make restart one command per job.

## Paper A: the flagship now

### Working title

**From Null-Spinor Area to a Dirac Gap: Exact Unitary Dynamics from a Complex
Pluecker Mass**

### One-sentence claim

A pair of primitive null spinors canonically determines a complex Pluecker
coordinate whose modulus is the rest gap, whose transported relative phase
changes the free spectrum, and whose associated finite walk is exactly
unitary.

### Core theorem package

- finite Cauchy-Binet/Pluecker mass identity and exact collinearity boundary;
- the canonical odd Hermitian rest operator `B_z`, with `B_z^2 = |z|^2 I`;
- exact rest eigenvectors, phase covariance, and no independent mass parameter;
- exact unitary walk and direct complex-weight history expansion;
- position-dependent `z(x,t)`, exact local unitarity, causal cone, and induced
  endpoint connection under local phase rotation;
- an exact equal-modulus two-site phase-defect spectrum with transported
  mismatch splitting, zero-gap locus, common-phase conjugacy, and an
  unequal-modulus failure control;
- the fixed-momentum many-step continuum estimate, stated at its actual scope;
- exact regulator/no-go consequences and the preregistered high-momentum
  benchmark;
- explicit negative results: constant `z` is spectrally equivalent to an
  assigned mass, no positive fixed finite homogeneous action of positive
  natural degree selects a nonzero stationary radial scale,
  and the bare split family is not closed under temporal blocking.

### Mandatory submission gates

1. Complete or remove every advertised full-Bloch determinant formula.
2. Keep the Hamiltonian Wilson regulator distinct from a strict finite-range
   one-step QCA.
3. State that no observed mass value is predicted; `|z|` is not dynamically
   selected by the current homogeneous action.
4. State that changing-lattice position-space PDE convergence is Paper D, not a
   result of Paper A.
5. Include a baseline theorem showing exactly where constant `z` is only a
   reparametrized Dirac mass.
6. Release a clean Lean artifact, benchmark inputs/results, commit identifier,
   theorem-to-prose audit, and data/code availability statement.
7. For the higher-impact lane, close the generator-level dynamical covariance
   classification, promote the transported phase from the landed two-site
   identity to a genuine ring-holonomy spectral witness, and land the
   changing-lattice position-space PDE theorem. These are theorem gates, not
   prose upgrades.

### Venue decision

- **Core submission:** *Journal of Physics A* or *Journal of Mathematical
  Physics*. Both fit a substantial mathematical-physics paper with exact
  quantum-walk constructions and formal verification.
- **Upgrade submission:** *Physical Review Research* or *Quantum* if the
  position-space PDE limit, dynamical covariance classification, and a
  nonconstant free ring-holonomy observable land as one focused chain. A strict
  alias-free `3+1` successor from Paper B or protected defect theorem from Paper
  C would be an additional, independent upgrade.
- Do not send the current broad version to a prestige venue merely because it
  is ambitious. The upgrade is a theorem, not stronger adjectives.

## Paper B: strict 3+1 QCA theorem

### Working title

**Locality, Doubling, and Onsite Mass in Three-Dimensional Dirac Quantum
Cellular Automata**

### One-sentence claim

Exact unitarity, a live `3+1` Dirac tangent, onsite mass, finite propagation,
and absence of zero/pi aliases cannot all be achieved in the minimal
four-channel degree-one factorized architecture; the paper identifies the
smallest proved escape or the sharpest surviving lower bound.

### Already available

- the scoped stationary-amplitude obstruction;
- the exact even-parity alias theorem for every momentum-independent onsite
  coin in the live factorized class;
- determinant-to-Floquet-mode criteria;
- finite-range six-channel and D4/BCC/tetrahedral comparison candidates;
- a Wilson-Hamiltonian benchmark with explicit negative controls.

### Submission gate

The paper needs an exact full-zone result, not corner sampling. It must end in
one of two scientifically complete forms:

1. a concrete successor with exact all-momentum unitarity, finite-range inverse,
   Dirac tangent, Pluecker mass compatibility, and no unintended zero/pi modes;
   or
2. a genuinely sharp lower-bound theorem specifying which resource must grow:
   internal dimension, unit cell, range, or substep count, plus a witness at the
   first relaxed architecture.

### Venue lane

*Physical Review Research* or *Physical Review A* if the result materially
changes QCA construction practice; *Journal of Physics A* if the main result is
a mathematical classification/no-go theorem.

## Paper C: winding insufficiency and exact defect fixtures

### Working title

**Winding Is Not Enough: Involutive Compression and Exact Defect Modes in a
Spinor-Derived Unitary Quantum Walk**

### One-sentence claim

The phase discarded by a scalar mass description becomes exact derived lattice
data, but winding alone does not classify mode-pinning compressions: over all
16 four-site sign fields, the exact repaired criterion also depends on wall
position relative to the reflection-fixed sites.

### Already available

- exact local phase covariance and endpoint link term;
- constant-phase cancellation;
- a theorem that a global real phase lift has zero winding;
- an explicit winding-one link field with no global lift;
- an existing finite winding/index spine elsewhere in the repository.
- an exact involutive-compression engine and displayed two-wall `+1/-1` modes;
- complete displayed zero-wall and four-wall no-mode controls;
- an exhaustive 16-field four-site discriminant;
- a same-winding counterexample: both fields turn by `2*pi`, but only one
  compression is self-adjoint, while the other compressed sector has neither
  sign mode.

### Submission gate

For the exact finite obstruction paper, replace compiled family decisions by
kernel-only certificates and prove the full-walk status of the same-winding
counterexample. For the prestige topology lane, generalize the positional
discriminant beyond four sites, derive the reflection structure from the
Pluecker carrier, construct a genuine operator index that sees the needed
position data, and prove stability under a displayed perturbation class.
Winding-only protection language is now refuted, not merely unproved.

### Venue lane

The finite classification/obstruction paper fits *Journal of Physics A* or
*Physical Review A*. A general-length index/localization/stability theorem can
still plausibly target *Quantum*, *SciPost Physics*, or *Physical Review
Research*. The exact counterexample is now the design constraint for that
successor, not an inconvenience to omit.

## Paper D: changing-lattice continuum analysis

### Working title

**A Changing-Lattice Strong Continuum Limit for Exactly Unitary Dirac Walks**

### One-sentence claim

Explicit sampling and interpolation maps carry the finite-range lattice walk
to the position-space Dirac flow uniformly on compact time intervals, with
quantified ultraviolet control.

### Already available

- one-step and fixed-momentum many-step estimates;
- a refined live `3+1` fixed-time estimate with error
  `2 B4^2 t^2/n * exp(|t| B4/n)`, retaining the small-step exponent required
  for growing-window analysis;
- finite-torus Fourier infrastructure;
- exact modewise unitarity, normalized DFT round trips, Parseval, complete mode
  expansion, live-walk factorization, and all-finite-time block evolution;
- exact conversion from the positive-character finite block to the analytic
  ordered block at negative lattice momentum, with a quarter-zone sign control;
- compact-support multiplier bridges;
- an abstract bulk/tail split;
- qualitative `L2` tail convergence over exhausting measurable bands.

### Submission gate

Define the changing Hilbert spaces, Fourier normalization, `S_a`, `I_a`, and
the limiting generator. Prove strong `L2` convergence for a stated Sobolev
class and identify the multiplier with the position-space Dirac PDE. Variable
`z(x)` is an extension, not a requirement for the first paper. Do not advertise
operator-norm convergence unless it is actually proved.

### Venue lane

*Annales Henri Poincare* is a stretch target if the analysis is general and
technically substantial. *Journal of Mathematical Physics* and *Journal of
Physics A* are the natural core venues.

## Paper E: second quantization and interaction

### Working title

**Finite CAR Dynamics from a Pluecker Dirac Walk**

### One-sentence claim

The Pluecker pair update is an even-CAR automorphism with exact support on its
declared four-mode set and exact propagation through finite gate schedules,
while its complex phase controls a two-particle process
invisible in the one-particle sector and not representable as either the
exterior lift of a one-particle matrix or a number-preserving one-body
generator.

### Already available

- generic finite CAR creation/annihilation algebra;
- determinant-minor `Gamma(U)`, vacuum and one-particle agreement, linearity,
  number/parity conservation, exact functoriality, adjoint/unitary laws, and
  both creation and annihilation covariance with relation-filtered coefficient
  support;
- a Hermitian Pluecker-weighted quartic pair transfer;
- an exact unitary rank-two pair kick that fixes every one-particle basis state
  and changes an explicit two-particle state;
- a no-go theorem that this kick is not `Gamma(U)` for any one-particle matrix:
  singleton agreement would force `U = 1`, contradicting the pair witness.
- a generator-level no-go: every standard number-preserving one-body CAR
  generator `sum A_ij a_i^* a_j` has zero matrix element between the two
  disjoint occupied pairs, while the Hermitian Pluecker quartic transfer has
  the exact nonzero unit-phase matrix element.
- an exact spatial placement on any embedded four-mode block of a finite
  linearly ordered fermionic chain.  The placed kick is an even quartic CAR
  polynomial, is involutive at unit phase, and gates on disjoint blocks commute
  exactly;
- exact finite scheduled support propagation using the strong even-CAR support
  predicate: an operator supported in `R` commutes with every
  creation and annihilation generator outside `R`.  A nonzero `3+4i` phase
  transfer acts nontrivially inside the declared set, while an exact disjoint-block control
  commutes.  The weaker occupation-transition footprint is explicitly demoted
  because globally dependent diagonal multipliers can satisfy it;
- an exact graph-neighborhood cone for sequential gates: if every four-mode
  block lies within one supplied reflexive neighborhood step, support after a
  gate list lies in the corresponding iterated neighborhood.  A contiguous
  `Fin 8` block is a nontrivial local witness, while `{0,1,2,7}` is an explicit
  nonlocal control;
- an exact circuit-layer upgrade: pairwise-disjoint local blocks consume one
  graph-neighborhood expansion per layer, and an arbitrary finite layer
  schedule is bounded by its layer depth.

### Submission gate

The generic finite exterior-lift API, exact coefficient-support laws, placed
pair layer, finite scheduled support theorem, sequential finite-range graph
cone, and pairwise-disjoint circuit-layer depth theorem are now closed.
The remaining gate is physical rather than algebraic: compose this interacting
layer with the spatial one-particle walk, derive it from an action or exact
operator exponential, and calculate a scattering phase, bound-state energy,
threshold, or selection rule. The scheduled support theorem and `4/5` interference
discriminator are rigorous finite results, not yet a continuum many-body
physics paper.

### Venue lane

*Quantum* or *Physical Review Research* if the operational consequence and
locality theorem are strong; *Journal of Mathematical Physics* or *Journal of
Physics A* for a finite CAR/operator theorem.

## Paper F: decomposition moduli and carrier classification

### Working title

**Moduli and Selector Obstructions for Channel Decompositions in Finite
Krein--Dirac Carriers**

The exact carrier square has a displayed aperture/closure/turn/solder
expansion, and its chirality-even/odd split is canonical. The finer naming is
not canonical from chirality and adjoint type alone: aperture, closure, and
turn share the even sector, while the explicit rational presentation becomes
coefficient-rigid only after support/coordinate selectors are supplied. That
tension is the paper's classification problem, not an embarrassment to hide.

As of the overnight theorem pass, this lane has a structural scalar-selector
classification core but not yet a complete positive or information-theoretic
classification. The complete type-only fibre is
an additive torsor, several selector obstructions are exact, and selector
descent has a necessary-and-sufficient kernel criterion. Raw solder degree has
now been killed on the live concrete representation by an explicit mixed-degree
relation: the nonzero operator `P=c1*c1#` is idempotent, so its degree-two word
and degree-four square evaluate identically and no additive represented selector
can assign both weights. Componentwise matrix trace passes the presentation
test but still fails to rigidify: an explicit nonzero trace-zero shear preserves
all three component traces. This now supports two honest publication routes.
The negative-classification route treats underdetermination as the result:
retained chirality/Krein structure, commutator-blind scalar data, and supplied
positive variational structure do not canonically select the named refinement.
That theorem spine is coherent enough for a standalone no-go/classification
paper once its carrier category, equivalence relation, examples, and
nearest-work confrontation are packaged. The stronger positive-selection route
still requires a surviving selector defined without desired channel coordinates
and a comparison with an information-theoretic selector on the same examples.

The scalar linear commutator-blind branch is now closed, not merely sampled.
Every rational-linear functional on the represented `4 x 4` carrier that
annihilates all commutators is exactly a scalar multiple of trace, and the
explicit nonzero trace-zero direction makes every such selector noninjective.
Thus no scalar linear selector satisfying this strong algebraic intrinsicity
condition can recover the channel refinement. This is not a no-go for nonlinear
spectral data, vector-valued invariants, locality, a derived positive physical
sector, or information monotones; those are now the precise surviving routes.

There is now also a positive variational classification. For scalar channels,
every positive diagonal quadratic resource cost has a unique
weighted-barycentric minimizer. The theorem simultaneously exposes the missing
physics: equal weights choose `(1/3,1/3,1/3)`, whereas positive weights
`(1,2,3)` choose `(6/11,3/11,2/11)` for the same unit total. Convex minimization
therefore selects a decomposition only after a channel metric is supplied; the
next gate is to derive that metric from locality, positivity, dynamics, or an
information monotone rather than naming it by hand.
The variational theorem now holds in every real inner-product channel space,
not only for scalar coordinates: the exact completion of squares, sharp lower
bound, and global unique weighted-barycentric minimizer require neither finite
dimension nor differentiability. Distinct positive metrics still select
distinct decompositions of every nonzero vector total. This makes the theorem
usable for finite operator spaces while preserving the central limitation that
the inner product and channel weights are inputs.
The same theorem family classifies one genuine naturality principle: invariance
under both adjacent exchanges of the three unresolved channel labels holds
exactly when all three diagonal weights agree, hence selects equal thirds. That
principle is mathematically clean but physically conditional, because the
channels need not remain interchangeable once edge, locality, or positivity
data are retained.

The most obvious carrier-derived metric also fails exactly. The live Krein
adjoint defines `trace(A# B)`, but the retained chirality-even,
Krein-self-adjoint sector contains a nonzero direction with self-pairing `-2`.
Thus the adjoint alone does not supply the positive metric needed by the
variational selector. A positive physical-sector restriction could still work,
but selecting the span of the desired channels by hand would be circular.
The obstruction now has a complete normal form. Every even Krein-self-adjoint
operator in the live `4 x 4` rational carrier has six unique coordinates and
self-pairing `a^2+d^2+e^2+g^2-2b^2-2f^2`: four positive square directions and
two negative ones. The diagonal four-coordinate sector is positive definite,
but the carrier data used here does not yet explain why that sector, rather
than another fundamental decomposition, should be physical.
An explicit rational Krein-boost theorem now strengthens this boundary. A
second injective four-coordinate positive family has the same exact quadratic
form as the diagonal family, and an exact norm-one member lies outside it. This
proves positive-sector nonuniqueness concretely; it does not classify the full
positive Grassmannian or derive a physical fundamental symmetry. The stronger
companion classification now also lands: all positive complement rays
orthogonal to the three named even channels have a unique nonzero scale and
rational open-disk coordinate, and every disk point generates a distinct
four-coordinate positive family containing those channels. Both results are
carrier-specific realizations of standard Krein orbit geometry, not claims to
invent the underlying positive-Grassmannian theory.

The first two rungs are now formalized. `ChannelRefinementTorsor` classifies
the complete type-only fixed-total fibre: after choosing a base refinement,
every ordered three-channel refinement is reached by a unique zero-sum
admissible shift. `ChannelShearModuli` exhibits a faithful determinant-one
rational subgroup and an explicit nondegeneracy witness.
`ChannelSelectorUniqueness` proves the complementary conditional result: two
shared sign gradings with four distinct joint eigenvalues force the internal
decomposition to be unique. `ChannelNaturalityNoGo` adds the sharp negative
boundary: any score invariant under every residual zero-sum translation is
constant, and no fully invariant predicate can uniquely prefer a refinement
when the type space has a nonzero ambiguity direction. Thus the open problem is
no longer the type-only affine ambiguity. `ChannelSelectorRigidity` supplies the
exact additive criterion: rigidity is equivalent to injectivity on the shift
group, and a nonzero rational ambiguity cannot be resolved by any finite-valued
additive selector. The abstract quotient is now exact:
`ChannelSelectorQuotient` takes any supplied selector, quotients the ambiguity
group by its kernel, proves class equality is exactly selector
indistinguishability, and gives the canonical equivalence to the selector
range. This closes the mathematical definition but not the physical gate. The
remaining task is to derive a separating selector for intrinsic physical or
information-theoretic reasons and only then instantiate the quotient.

There is now a second, better-motivated quotient theorem for a constrained
carrier. `ChannelPhysicalCohomology` proves constructively that, given finite
contraction data for a nilpotent constraint `Q`, a chain map has zero induced
action on physical cohomology exactly when it is null-homotopic, and every
physical endomorphism has the lift `i f p`. A rational three-dimensional
fixture contains a nonzero exact map, a nonzero physical response, and a
zero-compression non-chain-map control. This makes quotienting by `QH+HQ`
canonical once a physical constraint complex is supplied. It does not yet
construct that complex for the full carrier or quotient by carrier
automorphisms preserving geometry and locality. A new finite-range theorem now
shows that bounded contraction and projector data give the explicit homotopy a
closed radius bound, with a sharp path witness and a distant-projector control.
The
existing positive Ward/descent witness now supplies a concrete intermediate
realization: its explicit charge, contraction, and physical line satisfy the
full packet, so zero physical action is exactly null homotopy there and every
physical endomorphism lifts.
The same finite Ward sector now has a complete automorphism quotient. Charge
commutation forces a five-parameter normal form; preserving the Krein Gram
gives four exact coordinate equations; compression reads exactly one physical
phase. The physical-identity kernel is constraint-exact, with a nonidentity
imaginary shear witness, while a physical `i` phase is provably not exact. This
closes the quotient on the finite Ward model, not on the full carrier.

`ChannelSelectorDescent` now sharpens what “intrinsic” must mean. For a
surjective source-to-operator evaluation, a source-level grading descends to a
unique represented selector exactly when it preserves every relation in the
evaluation kernel; one relation moved out of the kernel is a complete
obstruction. This is a generic quotient theorem, not the missing physical
selector. `ChannelSolderDegreeNoGo` supplies the decisive negative live test for
raw solder degree. `ChannelTraceSelectorNoGo` separately proves that the
intrinsic, conjugation-invariant component trace profile is not injective on the
shift fibre. The next positive candidate is a fuller spectral, edge-exchange,
locality, positivity, or information selector defined without channel names and
proved to preserve the full live kernel and remove the displayed residual
moduli.

The paper should classify admissible decompositions and their equivalence
orbits, then determine which additional structures select a preferred orbit or
prove that the retained structures cannot do so. It should absorb the best
positive-carrier, Hodge, cohomology, decoder, and moduli material only when
those structures act as invariants or selectors.

The negative-classification version becomes publishable when it has:

- a live carrier constraint and contraction, a bounded-range exact-shift
  relation, and carrier automorphisms covering gauge, geometry, locality, and
  edge relabeling;
- a classification of the type-only moduli: unique odd soldering component and
  the full residual family of even-sector refinements;
- a necessary-and-sufficient theorem for uniqueness under candidate selectors
  together with the landed descent, trace-factorization, positive-metric, and
  Krein-signature obstructions;
- at least two inequivalent nonzero examples, one equivalence control, and one
  sharp underdetermination/no-go result;
- a direct comparison with generalized Lichnerowicz/Dirac-operator moduli and
  Krein fundamental-symmetry literature, without claiming invention of either.

The stronger positive-selection version additionally requires a noncircular
physical selector, an information-theoretic selector with a displayed
data-processing/refinement law, comparison of their selected orbits, and
stability of the selected class.

If every reasonable selector leaves multiple inequivalent refinements, that is
a publishable underdetermination theorem. If the selection works only after
adding coordinate readers equivalent to the desired channel labels, it is not
a natural uniqueness result.

The likely venues are *Annales Henri Poincare* and *Journal of Mathematical
Physics*. Standard Model names, generation counts, and cosmology should remain
applications or future gates unless the classification forces them.

## Paper G: formalization and reusable library

### Working title

**Machine-Checked Finite Relativistic Quantum Dynamics in Lean 4**

This is not a dump of all project theorems. It should present a reusable Lean
library and the scientific lessons exposed by formalization:

- separation of null support from Clifford soldering;
- determinant-level versus coefficient-level doubling tests;
- Hamiltonian locality versus strict QCA locality;
- monomial determinant flow versus multi-shift noninvertibility in one
  Laurent variable, with the physical QCA-index bridge still explicit;
- global phase lifts versus patched winding data;
- one-particle unitarity versus CAR/Fock automorphisms;
- benchmark/oracle outputs validated against kernel-checked identities.

Submit only after the central APIs are documented, examples build from a clean
checkout, flagship declarations have axiom pins, and project-specific names are
factored away from reusable abstractions. *Journal of Automated Reasoning* is a
good journal target because it explicitly welcomes formal proof assistants and
scientific applications as case studies. An ITP or CPP paper can precede the
journal version if it tells a focused proof-engineering story.

## Paper H: synthesis, later

### Working title

**Finite Null Information: Dynamics, Defects, and Mass from Local Decoding**

This is the eventual paradigm paper, review, or monograph. It should synthesize
published results rather than ask one referee to validate the entire ontology
at once. A reasonable gate is three accepted or mature core papers, including
at least one of B/C and at least one of D/E.

Possible homes are an invited review or a presubmission proposal for a
Perspective. *Physical Review Research* accepts Perspective proposals but
normally invites them; it does not treat an opinion-only white paper as a
research article. Until the gate is met, maintain the synthesis documents as
internal research maps and public preprints only when every claim is graded.

## What is no longer a standalone publication target

The old P1-P12 plan encouraged fragmentation. The following material should be
merged or deferred:

| Old lane | New disposition |
| --- | --- |
| P1 Pluecker mass, P2 finite Dirac square root, P4 checkerboard dynamics | merge into Paper A |
| P3 causal-diamond holonomy | later application paper only after coupling to a variable walk/complex and refinement law |
| P5 quantum measure and P7 observer channels | infrastructure in A, E, or G; standalone only after a new operational theorem |
| P6 flavor overlaps | defer until a rank/mixing theorem or numerical constraint exists |
| P8 ontology manifesto | becomes Paper H after the research series exists |
| P9 source visibility/cosmological constant | defer; no cosmology submission without a calibrated continuum source-response theorem |
| P10 generations/triality | defer until multiplicity is forced rather than supplied |
| P11 stable particle sectors | fold into E when a genuine interacting spectral sector is proved |
| P12 exterior-history grade-2 capacity | supporting algebra in A or F |
| standalone RG or scale-selection paper | not yet; temporal nonclosure and homogeneous scale no-go are strong boundary results inside A/B |
| general-audience manuscript | outreach companion after Paper A is stable, not a research submission |

The mass-rank-defect and complete-null-information manuscripts remain valuable
research notebooks. They should not be submitted as claims of a completed
Standard Model, gravity theory, Higgs mechanism, or cosmology until downstream
prediction gates exist.

## Anti-fragmentation and authorship rules

1. One paper, one sentence that survives deletion of the Lean discussion.
2. A theorem used only as infrastructure belongs in the paper whose consequence
   it enables.
3. Do not publish both a formalization paper and a physics paper with the same
   theorem inventory unless each has a genuinely different contribution.
4. Each paper gets its own claim matrix, nearest-work comparison, negative
   control, falsifier, artifact manifest, and exact dependency list.
5. Resolve authorship, affiliations, ORCIDs, AI-use disclosure, and contributor
   roles before submission. The archival artifact must identify human
   responsibility for scientific claims and semantic review.

## Venue policy checked 2026-07-10

- [Quantum](https://quantum-journal.org/) is a community-run open-access venue
  for quantum science; use it for C or E only when the consequence matters to
  that community beyond this model.
- [Physical Review Research](https://journals.aps.org/prresearch/about) seeks
  significant developments across physics and emerging interdisciplinary work;
  it is an upgrade lane for A/B/C/E, not the default home for an internally
  consistent construction.
- [SciPost Physics](https://scipost.org/SciPostPhys/about) requires a
  breakthrough, a new research pathway, a cross-field link, or progress on a
  recognized stumbling block. C is the best fit if the defect/index theorem
  closes.
- [Journal of Mathematical Physics](https://pubs.aip.org/aip/jmp) explicitly
  covers mathematical methods applied to physics and formulation of physical
  theories; it is a natural home for A, D, E, or F at theorem-paper scope.
- [Journal of Physics A](https://publishingsupport.iopscience.iop.org/journals/journal-of-physics-a-mathematical-and-theoretical/about-journal-physics-mathematical-theoretical/)
  explicitly covers lattice models, cellular automata, mathematical physics,
  quantum information, and relativistic quantum mechanics; it is the broadest
  core fit for A, B, D, or E.
- [Annales Henri Poincare](https://link.springer.com/journal/23/aims-and-scope)
  emphasizes analytical theoretical and mathematical physics, including
  quantum dynamics and spectral analysis; reserve it for a genuinely general D
  or F theorem.
- [Journal of Automated Reasoning](https://link.springer.com/journal/10817/aims-and-scope)
  covers proof assistants and formalized scientific applications; it is the
  clearest journal target for G after the library is reusable.

Venue scopes and policies can change. Recheck them at submission time, along
with article types, length limits, open-access costs, and AI-use policies.
