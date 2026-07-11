# Help needed: the hardest open problems in the null-edge publication program

A standalone collaborator brief, July 11, 2026. No repository access is
required to understand the questions. Paths and theorem names are included for
collaborators who want to inspect or rebuild the formal sources.

> **Status addendum (07:50 PDT, same morning - Fable).** Expert responses to
> this brief arrived within hours and three sections moved materially; read
> them with these updates (details: run ledger + MORNING_REPORT.md):
> **H5** is substantially answered - the machine-checked positional law
> landed (`HalfPeriodInvariant.selfadj_iff_protected` + `protected_modes`),
> the half-period timeframe pair and mirror-graded winding are proven
> blind/ill-defined here, and exact computation closed the full 16-field
> mechanistic taxonomy (blocks are exact involutions; blind singletons are
> certified by the mirror axis through the same engine); the open residue is
> the CGGSVWZ real-space-index match and chart-wise stability (job in
> flight). **H2** now has an exact kernel-checked free-theory phase-defect
> spectrum: the equal-modulus two-site Hamiltonian has a transported-mismatch
> polynomial, exact zero-gap locus, common-phase conjugacy, and an explicit
> unequal-modulus failure control. The sector-resolved window half-charge
> remains in flight. **H7** is closed as an exact negative for
> every degree-1 homogeneous decimation (Euler/dilatation;
> `FiniteHomogeneousScaleNoGo` kernel-checked): scale selection requires
> homogeneity breaking, so the ask is retargeted to refining families with
> running couplings. **H1** gained the abstract quotient theorem, the concrete
> Ward contraction realization, quantitative finite-range homotopy bounds,
> and a complete automorphism/exact-shear quotient for the Ward witness. The
> full decorated carrier remains the ask. **H4**'s real obstruction is now known to
> be the exponential momentum-growth of the landed box constant (repair in
> flight), and **H6** now has an exact pairwise-disjoint circuit-layer cone:
> each local layer consumes one graph-neighborhood expansion and a finite
> schedule is bounded by layer depth.

## 1. What the project is trying to establish

The null-edge program studies a finite, exactly computable architecture in
which primitive propagation is lightlike and a massive Dirac rest term is
derived from the failure of occupied null-spinor directions to align.

For spinors `psi_i in C^2`, define the positive momentum matrix

```text
P = sum_i psi_i psi_i^dagger.
```

The kernel-checked finite identity is

```text
det P = sum_{i<j} |psi_i wedge psi_j|^2.
```

For two spinors, the complex area `z = psi_1 wedge psi_2` determines the odd
Hermitian rest operator

```text
B_z = [[0, z], [conj z, 0]],
B_z^2 = det(P) I,
(k sigma_z + B_z)^2 = (k^2 + det P) I.
```

Thus the rest gap is fixed by supplied null-spinor geometry, with no second
mass parameter inside the finite model. This does **not** yet predict an
observed mass value: the spinors and their scale are still inputs.

The larger program asks whether the same finite carrier can support a strict
local `3+1` regulator, a continuum limit, a local many-fermion dynamics,
topological defects, a principled channel decomposition, and eventually
measured scales.

## 2. Evidence and trust conventions

We distinguish four levels:

- **Machine result (`M`)**: an exact finite Lean theorem, with its assumptions
  and axiom footprint checked.
- **Established result (`T`)**: an imported theorem from the literature, with
  conventions checked.
- **Conditional bridge (`T|H`)**: a theorem under displayed analytic or
  physical hypotheses not yet derived from the finite carrier.
- **Conjecture (`C`)**: an open identification with a stated gate and kill
  condition.

The publication verifier currently rebuilds 43 direct headline modules, an
aggregate axiom guard, and two deterministic numerical fixtures. It passes.
Most headline modules use only the standard Mathlib logical footprint. A small
set of explicitly identified finite defect fixtures uses compiler-trusting
evaluation and is reported at that weaker draft-trust level.

Kernel verification establishes that a formal statement follows from its
formal assumptions. It does not establish that the statement is the correct
physical abstraction. Semantic and literature audits are therefore separate
release gates.

## 3. What is already unusually strong

The following are landed rather than proposed:

1. The null-spinor area determines the complete two-channel odd Hermitian rest
   operator and its exact relativistic energy square.
2. The rest operator exponentiates to exact unitary finite dynamics; directed
   histories retain `z` and `conj z` separately.
3. Local phase variation induces exact endpoint link data, while constant phase
   produces no link. An explicit primitive-spinor field has winding one and no
   global real phase lift.
4. The minimal ordered `3+1` architecture has exact all-zone determinant
   formulas and a complete zero/pi crossing classification. Several tempting
   strict-local escape routes are ruled out.
5. Finite CAR signs, determinant-minor second quantization, an even quartic pair
   transfer, and a phase-sensitive pair kick are formalized. The pair kick is
   neither a number-preserving one-body generator nor a determinant-minor
   exterior lift.
6. The four-channel carrier-square expansion is exact, but type information
   alone does not make the named even-channel refinement unique.
7. The complete live chirality-even, Krein-self-adjoint carrier sector has a
   six-coordinate normal form with signature `(4,2)`. Positive complements to
   the three named even channels are classified by a rational open disk and a
   unique nonzero scale.

These results make the remaining questions narrower. The program no longer
needs suggestions that a null sum can be timelike, that Dirac walks exist, or
that indefinite spaces have many positive subspaces. It needs the exact bridges
below.

## 4. Ranked help requests

### H1. Define the physical equivalence relation for channel decompositions

**Why this is first.** The decomposition-classification paper now has a complete
negative mathematical spine, but it cannot yet say which distinct refinements
are physically inequivalent.

**Landed frontier.** For a fixed total even carrier contribution, all
type-compatible three-channel refinements form a zero-sum additive torsor.
Several selector results are exact:

- a selector rigidifies the fibre exactly when it is injective on the shift
  group;
- a source-level selector descends to represented operators exactly when it
  preserves the evaluation kernel;
- raw solder degree fails to descend because a nonzero represented idempotent
  has degree-two and degree-four presentations;
- every commutator-blind rational-linear scalar selector is a multiple of trace
  and is noninjective;
- positive quadratic minimization has a unique answer only after a metric is
  supplied, and different positive metrics select different answers;
- the natural Krein form has signature `(4,2)`, not a canonical positive metric;
- even after requiring a positive family to contain aperture, closure, and turn,
  a rational open disk of positive complements remains.

**What we need.** Define a carrier datum and an equivalence relation that retain
exactly the structures a physical decomposition should preserve. Candidate
data include the full carrier operator, Krein form, chirality, Clifford
soldering, edge locality, gauge action, and observable response. Then prove an
example/control triple:

1. two refinements that are inequivalent under the relation;
2. one nontrivially transformed pair that is equivalent;
3. invariance of at least one justified selector or response under that
  equivalence.

A concrete mathematical quotient is now proved.  If the carrier supplies a
nilpotent constraint `Q` with finite contraction data `(i,p,s)`, an even chain
map represents a physical operator modulo null homotopies
`QH+HQ`.  The central finite target is

```text
p X i = 0  <->  exists H, X = Q H + H Q,
```

The formalization also proves every physical endomorphism has the lift `ifp`
and includes a rational witness/control triple.  This makes exact shifts
canonical rather than selector-chosen.  The existing positive Ward/descent
witness now supplies an explicit `Q`, contraction, and one-dimensional physical
line realizing this theorem.  Derivation from the full null-edge carrier, the
full carrier-automorphism group, and graph-local construction of the supplied
data remain the physical part of the gate. The abstract locality bound is now
proved: finite matrix ranges add, the explicit homotopy has a displayed radius,
and a distant-projector control shows projector locality is load-bearing.
On the concrete positive Ward witness, the automorphism quotient is now fully
classified: the physical response is one complex phase coordinate, the
physical-identity kernel is exact, an imaginary shear is a nontrivial exact
automorphism, and a physical `i` phase is not exact. The initially proposed
`U^*G*U=1` law was false and has been replaced by `U^*G*U=G`.

**What would close the gate.** A theorem identifying the quotient or a sharp
no-go showing that the retained carrier data collapse all current candidates.

**What does not count.** Quotienting by a selector chosen for the purpose,
reading preassigned matrix coordinates, declaring the named channels fixed, or
invoking the abstract `O(4,2)` orbit without checking the full carrier datum.

**Best-fit expertise.** Finite spectral triples, generalized Lichnerowicz
decompositions, Krein/Pontryagin geometry, operator-algebraic moduli, quiver
representations, and categorical gauge quotients.

**Formal anchors.** `ChannelRefinementTorsor.lean`,
`ChannelSelectorDescent.lean`, `ChannelCommutatorSelectorClassification.lean`,
`ChannelKreinSectorSignature.lean`, `ChannelPositiveSectorModuli.lean`, and
`ChannelPositiveComplementDisk.lean` under `PhysicsSM/Draft/NullEdge/`, plus
`Carrier/WardPhysicalCohomology.lean` for the concrete finite Ward realization.

### H2. Derive an operational Pluecker-phase consequence from the same dynamics

**Why this matters.** At constant modulus, `B_z` is unitarily conjugate to the
real-mass rest operator. The one-particle rest spectrum therefore cannot
distinguish a constant phase. Without a further consequence, a skeptical reader
can call the construction a geometric reparametrization of an assigned Dirac
mass.

**Landed frontier.** The phase determines directed turn weights, induces exact
links when it varies, and enters a finite two-particle interference experiment.
Equal-modulus witnesses give exact survival probabilities `4/5` and `1` in a
supplied pair-kick sector. Independently, an exact symbolic two-site free
Hamiltonian has a spectrum controlled by the transported mismatch
`Delta = zR - (conj w)^2 zL`, an exact zero-gap locus, and common-phase unitary
conjugacy; a concrete unequal-modulus witness proves that the principal
identity's equal-modulus hypothesis is load-bearing. These results prove
phase-sensitive finite observables. They do not yet prove topological
protection, perturbation-stable localization, or that the free carrier forces
the quartic interaction.

**What we need.** One of the following would be decisive:

1. derive the quartic pair interaction from the same local carrier/action;
2. derive a protected defect mode from patched Pluecker phase data;
3. compute a phase-sensitive scattering amplitude or selection rule;
4. derive a held-out coefficient that cannot be absorbed into `|z|` or a basis
   choice.

**What would close the gate.** An observable stated before fitting, invariant
under the declared gauge/basis equivalence, and different for two equal-modulus
Pluecker fields.

**Kill condition.** If every gauge-invariant observable of the completed theory
depends only on `|z|`, the phase is assembly bookkeeping rather than new
physics.

**Best-fit expertise.** Topological quantum walks, lattice defects, fermionic
Gaussian/non-Gaussian dynamics, finite-volume scattering, and chiral phase
anomalies.

**Formal anchors.** `PlueckerPhaseDefectSpectrum.lean`,
`PlueckerPhaseObservable.lean`,
`PlueckerWindingDerived.lean`, `VariablePlueckerPhaseConnection.lean`,
`PlueckerPairKickNonQuasiFree.lean`, and `PlueckerQuarticNotOneBody.lean`.

### H3. Find the minimal strict-local `3+1` Dirac walk, or prove the resource lower bound

**Why this is hard.** Exact unitarity, finite propagation range, the desired
Dirac tangent, isotropy, small internal dimension, and the absence of unwanted
high-momentum copies compete with one another.

**Landed frontier.** In the current ordered degree-one architecture:

- the complete massive zero/pi crossing set is known over the full Brillouin
  zone;
- every momentum-independent onsite coin retains the even aliases;
- the massive body-center keeps `+1/-1` modes for every mass angle;
- no normalized degree-one nearest-neighbor factor can carry the required
  stationary term;
- integer-frequency finite harmonics in the current commutator-Wilson family
  retain the aliases, while the exact de-aliasing control uses a noninteger
  frequency and is not strict finite range.

The six-direction D4 control is exactly local and unitary but its current mixing
does not contain the required four-component Dirac sector. A Wilson Hamiltonian
removes sampled copies but its exponential is not a finite-range one-step QCA.

**What we need.** Either:

1. an explicit alias-controlled strict QCA with a full all-momentum proof; or
2. a cross-architecture theorem quantifying the minimum extra range, substeps,
   cell size, memory, or internal dimension required.

**What would close the gate.** Full determinant/mass-shell classification, not
corner sampling; exact locality, not a local Hamiltonian whose exponential has
tails; and a nondegenerate Dirac tangent at the intended low-energy point.

The algebraic precursor is now landed. Every unit of the finite Laurent-
polynomial ring over a field is a nonzero coefficient times a unique monomial,
a genuine two-term polynomial is not a unit, and the determinant of every
invertible finite Laurent matrix is a unique monomial. This isolates the exact
one-dimensional ring-level flow resource. It is not a three-dimensional
no-doubling theorem. The physical corollary must separately show which
index-preserving local deformations can or cannot remove aliases.
The unique determinant exponent is also now packaged as an additive algebraic
invariant: composition adds exponents, identity has exponent zero, pure shift
`T^n` has exponent `n`, and a one-channel two-shift symbol is not invertible.
The remaining bridge is explicitly physical/representational, not ring algebra.

**Best-fit expertise.** Quantum cellular automata, discrete-time quantum walks,
fermion doubling, Clifford QCAs, filter banks, and algebraic topology of
unitary matrix Laurent polynomials.

**Formal anchors.** `FullBlochZeroClassification.lean`,
`StrictQCAMinimalArchitecture.lean`,
`CommutatorWilsonStrictnessKill.lean`, `LaurentUnitResource.lean`, and the D4
walk modules, with `LaurentFlowIndex.lean` for the additive precursor.

### H4. Complete the changing-lattice position-space continuum theorem

**Why this matters.** Fixed-momentum convergence is not a continuum field
theory. A genuine result must compare changing finite state spaces with one
continuum Hilbert space under explicit physical scaling.

**Landed frontier.** We have uniform `O(1/n)` many-step bounds on bounded
momentum boxes; exact finite three-dimensional DFT, Parseval, symbol conjugacy,
and all-finite-time spectral evolution; restriction and zero-padding maps for
expanding `Z^3` mode boxes; strong coefficient-tail convergence; an explicit
Sobolev-type tail rate; and compact-support `L2` multiplier convergence.

The present explicit `3+1` box constant grows as
`16 (3K+M)^2 exp(3K+M)`.  Therefore it cannot simply be combined with a cutoff
`K(a) -> infinity` using a polynomial balancing argument.  The underlying
one-step proof is sharper before its final simplification: it contains
`exp(|epsilon| B4)`, with `epsilon=t/n`.  Retaining that small-step dependence
is the immediate quantitative gate.

**What we need.** Define the lattice spacing, physical torus/box, sampling map,
interpolation map, momentum scaling, and continuum Dirac flow in one theorem.
Prove a quantitative norm estimate on a stated Sobolev class and time window,
with an ultraviolet-tail term and normalization constants visible.  First
prove a growing-window estimate with `exp(|t| B4/n)` rather than `exp(B4)`;
only then optimize the cutoff against `SobolevTailRate` using the actual power
of `B4`.

**What would close the gate.** A bound of the schematic form

```text
|| I_a U_a^[t/a] S_a psi - exp(-i t H_D) psi || <= explicit error(a,t,psi),
```

where `S_a` and `I_a` are actual sampling/interpolation maps and the error tends
to zero as `a -> 0`.

**What does not count.** Another fixed-symbol telescope, integer-mode exhaustion
without physical scaling, or a fitted dispersion plot.

**Best-fit expertise.** Numerical analysis of hyperbolic PDEs, strong/operator
convergence, lattice Dirac operators, Shannon interpolation, and quantum-walk
continuum limits.

**Formal anchors.** `FixedMomentumManyStepContinuum.lean`,
`ChangingModeEmbedding.lean`, `SobolevTailRate.lean`,
`Compact3Plus1DiracRate.lean`, `Finite3Plus1FourierBridge.lean`, and
`LiveDFTComposition.lean`.

### H5. Identify the correct defect invariant after winding-only protection failed

**Why the question changed.** A complete four-site sign-family audit produced
two fields with the same total turning `2*pi` but different compression
signatures. Winding and wall count alone are therefore insufficient in the live
finite compression.

**Landed frontier.** The corrected finite criterion also depends on wall
position relative to reflection-fixed sites. We have exact displayed `+1/-1`
mode witnesses, localized probabilities in a second family, and complete
zero-/four-wall no-mode controls for the displayed walks. Some finite family
facts use explicitly disclosed compiler-trusting evaluation.

**What we need.** A non-winding-only invariant derived from the full walk and
its symmetry data, followed by a theorem of the form

```text
index/invariant = signed pinned-mode count,
```

with a perturbation class that preserves the invariant and a localization or
spectral-gap estimate. Promising structures include reflection/chiral symmetry
at fixed sites, relative indices, transfer-matrix stable subspaces, and
real-space quantum-walk indices. The invariant must be derived from the
Pluecker carrier rather than introduced solely to classify the fixtures.

**Kill condition.** If the pinned modes disappear under every natural local
perturbation preserving the claimed carrier symmetries, they are exact finite
resonances rather than protected defect states.

**Best-fit expertise.** Chiral/Floquet indices, transfer matrices, real-space
topological invariants, symmetry-protected defects, and constructive rational
matrix certificates.

**Formal anchors.** `HalfWindingFieldPositionClassification.lean`,
`ModeInvariantHalfWinding.lean`, `HalfWindingFullWalkControls.lean`, and
`WallModeWitness.lean`.

### H6. Upgrade declared-set CAR support to geometric many-body causality and dynamics

**Landed frontier.** The Pluecker pair kick is an even quartic CAR operation on
an embedded four-mode set. Disjoint embedded sets commute. Strong CAR support
propagates through a finite schedule, and a graph-metric successor now proves
that a sequential list of `BlockLocal` gates enlarges support only inside the
iterated neighborhood.  A contiguous block is a nontrivial witness and a far
block explicitly fails the locality premise.

**What remains open.** The exact cone counts sequential gates.  It does not yet
package pairwise-disjoint gates into parallel layers or bound radius by circuit
depth.  It also does not compose the interaction with the free spatial walk,
derive the gate from a local Hamiltonian/action, or produce scattering or
binding data.

**What we need.** An exact layer type with pairwise-disjoint finite-range
supports and a theorem bounding evolved support by one neighborhood expansion
per layer. The result must handle fermionic parity explicitly: ordinary
commutators are appropriate when one side is even; odd-odd observables require
graded locality or a controlled Jordan-Wigner map.

The next dynamical step is to derive the gate from a local quartic Hamiltonian
or action and compute a binding energy, scattering phase, or selection rule.

**What would close the next gate.** A proof-complete radius-versus-layer-depth
theorem with pairwise-disjoint layer supports and an outside-cone graded
commutation corollary.  Algebraic involutivity must not be relabeled as
Hilbert-space unitarity, and the existing nonzero boundary transfer must not be
relabeled as cone sharpness.

**Best-fit expertise.** CAR nets, fermionic QCAs, Lieb-Robinson methods, graded
tensor products, local quantum circuits, and finite-volume interacting dynamics.

**Formal anchors.** `FiniteCARFockBasic.lean`,
`FiniteCARSecondQuantization.lean`, `PlueckerQuarticInteraction.lean`,
`PlueckerPairKickNonQuasiFree.lean`, `PlueckerQuarticNotOneBody.lean`,
`PlueckerCausalCone.lean`, and `PlueckerGeometricCone.lean`.

### H7. Select a nonzero physical scale without hiding the answer in an input

**Why this is fundamental.** The area identity explains the form and
gap-closing locus of mass. It does not explain why the electron, muon, Higgs,
or any other excitation has its observed scale.

**Landed frontier.** The no-go is now generic: any positive finite action that
is exactly homogeneous of positive natural degree has a strictly positive
radial derivative at unit scale and therefore cannot select a nonzero stationary
configuration. Degree zero is exactly flat. The original Pluecker action is the
quartic instance, and a supplied-scale potential merely relocates the input. A
discrete one-loop model does exhibit exact dimensional transmutation and an
RG-invariant exponential scale, but no Standard Model beta function or matching
condition has been derived from the carrier. The live three-channel map also
has an exact nonzero period-two marginal line, killing the proposed doubled-map
cubic-drift mechanism on that line.

**What we need.** A stated local action, ensemble, or coarse-graining map whose
dimensionless microscopic data generate a stable nonzero scale and fluctuation
spectrum. The mechanism should produce at least one held-out ratio or
coefficient and disclose every matching input.

For the Higgs sector, success requires more than calling a scalar collective:
derive a vacuum, radial mode, couplings, and a stable mass relation. For gravity,
the analogous gate is a continuum soldering action and field equation, not
finite coframe covariance alone.

**Kill condition.** If every stable nonzero solution requires inserting a
dimensionful constant equivalent to the desired mass, the program explains
mass kinematics but not mass values.

**Best-fit expertise.** Renormalization, constructive statistical mechanics,
dimensional transmutation, lattice scalar sectors, spectral actions, and
nonperturbative effective actions.

**Formal anchors.** `FiniteHomogeneousScaleNoGo.lean`,
`Carrier/PluckerScaleSelectionNoGo.lean`, `Goal3MarginalLine.lean`,
`TemporalBlockingRG.lean`, the finite action/dynamics modules, and the canonical
ensemble roadmap.

## 5. Closed or misleading routes

Please do not spend collaborator time on the following unless proposing a
strictly stronger hypothesis that escapes the stated result.

1. **A constant `z` spectrum as new physics.** It is unitarily equivalent to a
   standard constant-mass rest operator at the same modulus.
2. **Winding alone protects the displayed finite defect mode.** The complete
   four-site counterexample disproves this.
3. **Retardedness or corner sampling proves no doubling.** The determinant or
   mass shell must be classified over the full Brillouin zone.
4. **A Wilson Hamiltonian exponential is a strict finite-range QCA step.** It
   is not.
5. **Transition footprint is operator locality.** A global number-operator
   counterexample has empty transition footprint but fails strong CAR support.
6. **Positivity canonically chooses the named channel split.** The live sector
   has signature `(4,2)` and an open disk of positive complements.
7. **Trace or any commutator-blind scalar-linear score classifies refinements.**
   Such scores factor through trace and retain a nonzero kernel.
8. **A positive fixed finite homogeneous action selects a nonzero mass.** Every
   positive-degree member has a nonzero radial derivative; degree zero is flat.
9. **Finite exact identities imply continuum spacetime or the Standard Model.**
   Every continuum and reconstruction bridge must be a separate theorem.

## 6. How collaborators can help most efficiently

For one selected problem, please provide:

1. a precise proposed theorem or counterexample;
2. all hypotheses, conventions, and equivalence relations;
3. the closest primary literature and the exact lemma/section that matters;
4. a nonzero witness and a degenerate or wrong-sign control;
5. a kill condition;
6. a suggested finite Lean statement or proof ladder;
7. a clear statement of what the result would **not** prove.

Partial negative answers are valuable. A proof that a desired selector,
regulator, invariant, or action cannot exist under a natural hypothesis is a
publishable narrowing result if the scope and first escape resource are exact.

## 7. Reproducibility and contact surface

The main technical draft is
`Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`.
The publication portfolio is
`Sources/Null_Edge_Publication_Portfolio_2026-07-10.md`. The theorem-to-prose
matrix, paper gates, and deterministic artifact manifest are in
`AgentTasks/overnight-publication-run-2026-07-11/`.

The Lean toolchain is pinned. The authoritative publication verifier is:

```text
python Scripts/publication/verify_null_edge_paper_a.py
```

It rebuilds the declared headline modules, checks the aggregate axiom guards,
and reruns the numerical fixtures against pinned hashes. Draft-trust exceptions
and open theorem gates are part of the report rather than hidden failures.
