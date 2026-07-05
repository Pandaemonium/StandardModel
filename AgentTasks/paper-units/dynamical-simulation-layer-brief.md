# Dynamical simulation layer brief

Status date: 2026-07-05

Audience: collaborators who know lattice gauge theory or scientific computing,
but have not followed the internal four-day Yang-Mills run terminology.

## Executive summary

The project has not yet built a true dynamical simulation engine. What it has
built is a verified finite lattice-gauge scaffold that is strong enough to
support one.

The current Lean development can represent finite link fields, plaquette
weights, gauge-invariant Wilson observables, finite expectations, reflection
structures, sector decompositions, and several transfer/gap prerequisite
identities. The Python oracle layer already performs small exact checks for
convention-sensitive finite examples. This is enough to start a principled
finite-volume computation layer based on exact enumeration and small matrix
models.

The missing step is not "run a Monte Carlo." The missing step is to define,
verify, and implement the actual finite dynamical object: a concrete transfer
kernel or Markov transition kernel on a specified finite lattice, with a clear
relationship to the existing Wilson ensemble, reflection-positive Hilbert-space
construction, sector labels, observables, and spectral-gap bookkeeping.

## What has been demonstrated

The project has demonstrated a substantial finite, machine-checked skeleton for
Yang-Mills style lattice gauge theory:

- Finite lattice gauge configurations can be modeled as link fields, with
  holonomy, plaquette holonomy, Wilson local weights, and gauge-invariant
  expectations.
- The exact two-dimensional finite-group area-law lane is now strong. The
  rectangular-boundary Wilson loop expectation has been related to the
  independent-plaquette area law for arbitrary finite groups in the current
  draft stack.
- Reflection-positivity infrastructure exists at finite level: reflection
  forms, positive semidefinite kernels, cut-plaquette Wilson factors, and finite
  product/kernel algebra have verified components.
- The finite OS/GNS-style transfer-Hilbert-space range model exists at an
  abstract level, with Z2 electric-sector decomposition and selected-vs-other
  finite-dimensional range and finrank APIs.
- The eigenvalue and gap-prerequisite algebra is cleaner than before:
  unitarizability, real/ordered normalized Wilson eigenvalue facts, local
  spectral-ratio packaging, logarithmic gap identities, contraction-factor
  identities, and nondegeneracy bookkeeping are in place.
- The strong-coupling/KP route has been stated precisely enough to expose the
  remaining hard bottleneck: finite rooted-tree/species counting plus older
  corrected convergence and metric-tail handoffs. This is not yet a closed
  cluster-expansion theorem.

All of these are draft GateYM results. They are useful, but they are not a
claim of a physical continuum mass gap or a production simulation package.

## What can be simulated now

With modest engineering, the current state supports small finite-volume
computations of the following kind:

- Exact enumeration for tiny lattices and finite groups such as Z2, Z3, and
  small nonabelian groups.
- Direct partition-function and expectation calculations for Wilson loop
  observables.
- Verification of convention-sensitive formulas, such as fusion ordering,
  reflection-kernel signs, and small-lattice KP constants.
- Small transfer-matrix experiments once a concrete transfer kernel is chosen.
- Sector-resolved finite linear algebra experiments, especially for Z2 electric
  sector labels.

These are best described as exact finite-volume Euclidean computations or
oracle fixtures. They are valuable because they can be cross-checked against
Lean statements, and because they can falsify bad conjectures quickly.

## What is not yet available

The project does not yet have:

- A concrete physical transfer matrix wired end-to-end from the Wilson lattice
  ensemble to the finite OS Hilbert space.
- A Hamiltonian evolution model.
- A Markov-chain Monte Carlo implementation with a verified target measure.
- A validated real-time or Euclidean-time dynamics API.
- A Wilson slab-kernel construction connected to the Q2/Q3 sector API.
- A numerical mass-gap extraction pipeline.
- Infinite-volume or continuum extrapolation machinery.

The current finite-gap API should be read as prerequisite algebra: if a future
finite transfer object supplies ordered eigenvalue data and the required cyclic
sector hypotheses, the package already knows how to name and manipulate the
local gap. It does not itself build that transfer object.

## Three meanings of "simulation"

To avoid talking past each other, collaborators should separate three layers.

### Layer A: exact Euclidean enumeration

This is the closest milestone.

Inputs:

- finite group G;
- finite lattice shape;
- beta or local Wilson-weight parameters;
- finite list of observables.

Outputs:

- partition function;
- Wilson loop expectations;
- correlation functions on small volumes;
- sector-labeled sums where available.

This can be implemented first as Python oracle code, then tied back to Lean
through generated fixtures and theorem-shaped checks.

### Layer B: finite transfer dynamics

This is the layer needed before "dynamical simulation" is an honest phrase in
the project.

Inputs:

- a time slicing of the finite lattice;
- positive transfer kernel or reflection-positive construction;
- Hilbert-space quotient/range model;
- sector decomposition;
- local algebra or observable action.

Outputs:

- finite transfer operator;
- sector-preserving transfer blocks;
- finite spectra;
- correlation decay in Euclidean time;
- local gap estimates in named sectors.

This is not yet complete. The Lean project has pieces of the required
reflection positivity, Hilbert-space range construction, and sector algebra,
but the concrete Wilson slab transfer kernel has not been assembled.

### Layer C: stochastic or real-time simulation

This is later.

For Euclidean Monte Carlo, the target measure must be matched to the verified
finite ensemble, and update moves must be shown to preserve the measure or have
the correct detailed balance.

For Hamiltonian or real-time evolution, the project needs a separately defined
Hamiltonian or transfer-to-Hamiltonian construction. Current results do not
provide this.

## Proposed architecture

The simulation layer should be split into five components.

### 1. Model specification

A concrete finite model descriptor should specify:

- group;
- lattice dimensions and boundary convention;
- oriented link set;
- plaquette list and orientation;
- reflection plane or time slicing;
- Wilson local weight;
- observable definitions;
- sector-label functions.

This should be deterministic and serializable, so exact oracle runs can be
reproduced and compared to Lean declarations.

### 2. Exact finite engine

The first executable engine should enumerate configurations for small examples.

Responsibilities:

- enumerate link fields;
- compute plaquette holonomies;
- compute weights and partition functions;
- compute observables and correlations;
- optionally quotient or average over gauge orbits for tiny examples;
- emit machine-readable fixtures with full convention metadata.

This is the safest first step because enumeration is slow but transparent.

### 3. Transfer-matrix engine

The second engine should build matrices after a time slicing is fixed.

Responsibilities:

- construct the one-step transfer kernel;
- check positivity numerically;
- decompose by sector projections;
- compute eigenvalues by sector;
- compare spectral ratios with the Lean `FiniteGapAssembly` API.

This engine should initially target tiny Z2 and Z3 lattices. It should not
start with SU(2), SU(3), or continuum language.

### 4. Sampling engine

Only after the exact engine is reliable should we add stochastic sampling.

Responsibilities:

- implement local link or plaquette updates;
- prove or test detailed balance against the exact finite measure;
- compare sampled observables with exact enumeration on small volumes;
- measure autocorrelation and effective sample size;
- record seeds and run metadata.

The sampling engine is a performance layer, not a source of mathematical
authority.

### 5. Lean/oracle validation bridge

Every simulation milestone should have a verification companion:

- Lean statement or theorem name, when available;
- Python oracle fixture for the same finite model;
- exact command used to generate results;
- convention metadata;
- expected numerical identities;
- tolerance policy for floating-point computations.

The rule should be: exact small cases first, approximate large cases second.

## Minimal viable simulation layer

The minimal useful package would be:

1. Z2 finite-lattice descriptor for a rectangular 2D torus or rectangle.
2. Exact enumeration of all link fields.
3. Wilson plaquette action and rectangular Wilson loop observable.
4. Partition function and Wilson-loop expectation calculation.
5. Comparison against the proved area-law expectation theorem in the rectangle
   setting where the theorem applies.
6. A simple report generator that prints the model conventions, raw sums,
   normalized expectations, and theorem comparison.

This would not be "full dynamics," but it would be the first honest
simulation-facing artifact. It would also be a good debugging tool for the
remaining transfer-kernel design.

## Milestones toward true dynamics

### Milestone 1: exact finite Euclidean oracle

Deliverables:

- `Scripts/oracle/` module for finite lattice enumeration;
- JSON or CSV output with conventions;
- fixtures for Z2 and Z3;
- tests comparing exact enumeration to current Lean-proved identities.

Exit criterion:

- exact small-lattice expectations match the Lean-predicted finite identities.

### Milestone 2: concrete transfer kernel

Deliverables:

- one fixed time-sliced lattice shape;
- definition of the one-step kernel;
- numerical matrix construction;
- statement mapping the kernel to existing `TransferHilbert*` abstractions.

Exit criterion:

- the transfer kernel is positive in the expected sense, preserves the selected
  sectors, and reproduces exact enumeration for one-step observables.

### Milestone 3: sector-resolved spectrum

Deliverables:

- finite-dimensional sector blocks;
- eigenvalue computations by sector;
- comparison to `FiniteGapAssembly` ratio/log/contraction identities.

Exit criterion:

- vacuum and first local-sector eigenvalue slots are unambiguously identified
  in at least one small finite example.

### Milestone 4: Euclidean-time correlations

Deliverables:

- local observable basis;
- correlation functions as transfer-matrix matrix elements;
- decay-rate fits on finite volumes;
- exact checks on tiny volumes.

Exit criterion:

- measured finite-volume decay rates agree with transfer-matrix spectral data
  on small examples.

### Milestone 5: Monte Carlo layer

Deliverables:

- update moves;
- detailed-balance documentation;
- exact-enumeration comparison tests;
- reproducible run metadata.

Exit criterion:

- sampling recovers exact enumeration within statistical error on small
  volumes before being used on larger volumes.

## Main mathematical blockers

The current blockers are:

- Q6: finite rooted-tree/species counting and the corrected KP convergence and
  metric-tail handoffs.
- Q7: volume-uniform support counting and coefficient-smallness estimates for
  strong-coupling polymers.
- Q8: concrete observable bridge from the Q7 polymer map into the current
  support-tail clustering interface.
- Q2/Q3: concrete Wilson slab-kernel construction connecting the finite
  reflection-positive ensemble to the transfer-Hilbert and sector APIs.
- Q9: physical transfer/cyclicity hypotheses that would make the finite gap
  package apply to an actual transfer operator.

These are proof and design blockers, not software-only blockers.

## Main engineering blockers

The engineering blockers are:

- no canonical serialized finite-lattice descriptor yet;
- no unified exact enumerator for link fields and observables;
- no fixture format tying oracle output back to Lean theorem names;
- no transfer-matrix builder;
- no sector-block matrix extraction;
- no sampling code or detailed-balance test harness.

These can be developed in parallel with the proof work, provided the
simulation code stays explicitly labeled as oracle/evidence rather than proof.

## Suggested first collaborator project

Build the exact finite Euclidean oracle for a Z2 rectangular lattice.

Start with:

- link fields valued in Z2;
- plaquette product;
- Wilson weight `exp(beta * plaquette)`, or the existing tanh-normalized
  strong-coupling convention if matching the Q7 fixtures;
- rectangular Wilson loop;
- exact enumeration;
- output of partition function, raw numerator, expectation, and area.

Then compare:

- trivial small volumes by hand;
- current Python oracle conventions;
- Lean area-law theorem surfaces in `RectBoundaryExpectation.lean` and related
  YM1 files.

This project has high diagnostic value and low conceptual risk.

## Suggested first Lean-facing simulation theorem

The first theorem should not assert a physical mass gap. A good target is a
finite correctness bridge:

```text
For the chosen finite Z2 lattice descriptor, the executable oracle's
configuration sum is extensionally the same finite sum as the Lean
`PlaquetteEnsemble.expectation` definition for the same Wilson observable.
```

This statement would make the simulation layer a checked consumer of the
formal model rather than a parallel implementation with similar notation.

## Claim boundary for collaborators

Safe claim:

```text
We have a kernel-checked finite lattice-gauge scaffold and enough exact
finite-model infrastructure to begin building a verified simulation layer for
small finite groups and small volumes.
```

Unsafe claim:

```text
We have a full dynamical Yang-Mills simulator, a Hamiltonian evolution, an
infinite-volume mass-gap computation, or continuum physics predictions.
```

The right next step is to build the small exact simulator deliberately, then
use it to validate the transfer-kernel and sector-decomposition design before
any large stochastic simulation is attempted.
