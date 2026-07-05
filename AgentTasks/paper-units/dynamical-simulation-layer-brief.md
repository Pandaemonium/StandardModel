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
verify, and implement the actual finite dynamical object. The right first
candidate is a concrete one-step Euclidean transfer kernel on a specified
finite lattice, tied to the existing Wilson ensemble, reflection-positive
Hilbert-space construction, sector labels, observables, and spectral-gap
bookkeeping. A Markov chain is a later performance layer, not the first
dynamical model.

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

## Recommended first dynamical model

The first true dynamical model should be a finite Wilson slab transfer model.
This stays inside the current project boundary: it uses finite groups, finite
Euclidean lattices, Wilson plaquette weights, reflection/transfer structure,
and finite spectral data. It does not require a Hamiltonian limit, real-time
evolution, or stochastic sampling.

The standard lattice-gauge route supports this choice: transfer-matrix
formalisms relate Wilson's Euclidean lattice formulation to Hamiltonian lattice
gauge theory, while reflection positivity is the structural input that makes
the transfer construction positive. One useful historical reference is Creutz
1977, "Gauge fixing, the transfer matrix, and confinement on a lattice,"
which explicitly describes using transfer-matrix formalism to relate Wilson's
lattice approach and the Kogut-Susskind Hamiltonian approach.

For the first implementation, use the finite group Z2 with elements encoded as
`+1` and `-1`. Later examples can move to Z3, S3, or a general finite group.

Choose:

- a finite spatial lattice `Lambda_s`;
- a finite Euclidean time direction `t = 0, ..., T - 1`;
- explicit periodic or open boundary conditions;
- oriented link variables `U_l in G`;
- Wilson plaquette weight `w_beta(U_p) = exp(beta * chi(U_p))`.

For Z2, take `chi(+1) = +1` and `chi(-1) = -1`, so the plaquette weight is
`exp(beta * U_p)`. The finite Euclidean measure is therefore:

```text
W(U) = prod_p exp(beta * U_p)
Z    = sum_U W(U)
mu(U) = W(U) / Z
```

This is still Euclidean and finite. Its dynamical content enters when the
lattice is split into adjacent time slabs.

Implementation status as of 2026-07-05:

- `Scripts/oracle/z2_transfer_oracle.py` implements the first Z2 1+1D slab
  transfer oracle.
- `Scripts/oracle/validate_lgt_core.py` v0.6 contains the regression checks:
  transfer-kernel symmetry/PSD, `Tr(K^T)` against exact spacetime enumeration,
  time-zero spatial-flux insertion against exact enumeration, center-shift
  projector commutation, tiny finite spectral gaps, and a guard that raw
  magnetic spatial flux is not a preserved block label for the unprojected
  slab kernel.
- The v0.5 extension adds two-time Euclidean flux correlations, validates
  them against both full spacetime enumeration and the transfer-kernel
  eigendecomposition formula, and extracts center-shift sector blocks whose
  positive spectra reconstruct the full positive transfer spectrum on the
  checked tiny examples.
- The v0.7 extension makes the Z2 slab oracle descriptor-driven: it defines
  schema `z2_1p1d_wilson_slab_transfer.v1`, validates supported observable
  and sector labels, accepts `--descriptor <json>`, can write a descriptor
  template with `--write-template`, records numerical tolerances, and can emit
  the transfer and sector matrices with `--include-matrices`. The command
  `python Scripts/oracle/z2_transfer_oracle.py --L 3 --T 3 --beta 0.7 --json`
  still emits the convention record, partition and observable checks,
  two-time correlation check, spectra, and explicit numerical error fields.
  The descriptor-file path is checked by
  `python Scripts/oracle/z2_transfer_oracle.py --descriptor <json> --json`.
- The v0.8 extension adds a `lean_surfaces` provenance section to the JSON
  record. It names the Lean modules and theorem surfaces the oracle evidence
  is meant to inform, while explicitly recording that the JSON output is not
  itself a Lean proof.
- The v0.9 extension adds the one-link Lean bridge
  `TwoStateTransferZ2L1.lean` to that provenance list, pairing the executable
  `L = 1` slab kernel with the kernel-checked two-state descriptor surface.
- The v0.10 extension records the one-link spectral-ratio theorem surfaces:
  the descriptor and witness contraction factors are identified in Lean as
  `tanh beta`.
- The v0.11 extension records the one-link flux-insertion theorem surfaces:
  the `L = 1` spatial-flux insertion is Hermitian, squares to the identity,
  and swaps the vacuum and local/flux eigenvectors in Lean.
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferSpectrum.lean` adds the
  first small Lean-facing spectral payload for this dynamics lane: the complex
  `2 x 2` matrix `!![a,b;b,a]`, its vacuum and local/flux eigenvector
  equations, positive ordered eigenvalue facts when `0 < b < a`, and the
  corresponding D12 spectral-ratio gap/contraction-factor identities. This is
  a descriptor bridge for the smallest transfer shape, not the full Wilson
  slab transfer operator.
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferWitness.lean` now wraps
  that payload as a `Module.End`, proves a toy full-endomorphism cyclicity
  prerequisite on `Fin 2 -> C`, and instantiates `FiniteGapSpectralWitness`
  for any positive two-state descriptor. This makes the witness interface
  non-vacuous on a tiny finite model while keeping the full Wilson slab,
  physical sector, and cyclicity problem separate.
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferZ2L1.lean` formalizes the
  smallest concrete slab case from the Z2 oracle: the `L = 1` gauge-summed
  Wilson slab transfer matrix is exactly the two-state payload with
  diagonal weight `2 * exp beta` and off-diagonal weight `2 * exp (-beta)`.
  For `beta > 0`, it instantiates the positive descriptor and finite-gap
  witness, with contraction factor `tanh beta`. It also proves the explicit
  slab eigenvector equations and formalizes the one-link spatial-flux
  insertion as a Hermitian involution swapping the vacuum and local/flux
  eigenvectors. This is a one-link bridge only, not the full Wilson slab
  operator.
- `PhysicsSM/Draft/NullEdge/GateYM/ObservableSupportBridge.lean` adds the
  conservative Q8 support-bookkeeping adapter requested by the audit verdict:
  a local observable exposes finite plaquette/polymer support, that support is
  identified with the abstract `LocalObservableSupportData` support, and the
  existing support-tail/cardinality/empty-support/uniform-energy lemmas are
  restated in observable-support terms. This is only an interface layer; decay,
  concrete observable expansion, and volume-uniform KP estimates remain
  explicit hypotheses.
- `PhysicsSM/Draft/NullEdge/GateYM/FermionicReflection.lean` now names the
  RP-F reflected-boundary-coupling slot as `ReflectedBoundaryCoupling`, defines
  plus/minus reflected projector blocks, and proves those blocks PSD for any
  instantiated coupling using the lifted Wilson-projector Gram lemmas. This
  parks the exact open interface: the concrete Wilson boundary-coupling matrix
  and the temporal reflection-hermiticity hypothesis still have to be supplied.

## Current artifact map

This table separates kernel-checked Lean surfaces, executable oracle evidence,
and collaborator-facing synthesis. The point is to show what can be relied on
now and what still needs a bridge.

| Artifact | Role in the dynamics layer | Current status |
| --- | --- | --- |
| `Scripts/oracle/z2_transfer_oracle.py` | Exact Z2 1+1D finite slab transfer engine | Descriptor-driven oracle evidence: transfer traces, observables, two-time correlations, spectra, sector blocks, and optional matrix output. |
| `Scripts/oracle/validate_lgt_core.py` | Regression harness for finite LGT/oracle identities | Checks the Z2 transfer oracle against exact enumeration, matrix identities, descriptor validation, and the JSON `lean_surfaces` provenance record; this is executable evidence, not a Lean proof. |
| `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferSpectrum.lean` | Smallest Lean spectral payload | Kernel-checked finite identities for the `2 x 2` transfer-shape eigenvectors, ordered eigenvalues, spectral ratio, and contraction factor. |
| `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferWitness.lean` | Tiny consumer of the finite-gap witness API | Kernel-checked toy `Module.End` witness for the two-state descriptor; deliberately not the full Wilson slab transfer operator. |
| `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferZ2L1.lean` | One-link Z2 slab bridge | Kernel-checked proof that the executable oracle's `L = 1` slab formula has the two-state transfer shape, explicit vacuum/local eigenvectors, a flux insertion swapping them, and a positive finite-gap witness for `beta > 0`. |
| `PhysicsSM/Draft/NullEdge/GateYM/FiniteGapAssembly.lean` | Abstract finite spectral-gap witness package | Kernel-checked packaging of the spectral parameters, transfer endomorphism, eigenvectors, sector preservation, and ratio/log identities. |
| `PhysicsSM/Draft/NullEdge/GateYM/TransferHilbert*.lean` | Finite OS/GNS range and sector infrastructure | Kernel-checked finite algebraic range, block, shift, and Z2 electric-sector bookkeeping; no physical transfer matrix is constructed. |
| `PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean` and Wilson RP files | Positivity engine for reflection-positive weights | Kernel-checked PSD/reflection-form algebra and cut-plaquette Wilson factors; the connected Wilson slab remains open. |
| `PhysicsSM/Draft/NullEdge/GateYM/FermionicReflection.lean` | RP-F finite reflection/projector scaffold | Kernel-checked reflection unitary, lifted projector PSD, and named boundary-coupling slot; concrete Wilson boundary coupling remains open. |
| `PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean` | Q7 polymer/support-counting surface | Kernel-checked finite support/combinatorial interfaces and one-plaquette Z2 fixture; no volume-uniform KP estimate. |
| `PhysicsSM/Draft/NullEdge/GateYM/ExponentialClustering.lean` and `ObservableSupportBridge.lean` | Q8 observable support and clustering bridge | Kernel-checked conditional bridge from explicit tail hypotheses to clustering-style bounds; no concrete decay theorem. |
| `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` | Q6 corrected KP/convergence handoff | Draft layer with known proof handoffs; current bottleneck is the `pairSum_le_expBound` combinatorial estimate. |

## Status by claim type

| Claim type | What we can say now | What remains open |
| --- | --- | --- |
| Kernel-checked finite algebra | Finite gauge, reflection-positivity, OS/GNS range, sector, spectral-ratio, two-state witness, and support-bookkeeping identities are represented in Lean and build through the GateYM aggregate. | Some files are draft-trust and Q6 still has documented proof handoffs. |
| Executable finite evidence | The Z2 1+1D oracle exactly cross-checks transfer traces, observable insertions, two-time correlations, and sector block spectra against enumeration/matrix identities. | The oracle is not a proof, and it is currently specialized to the small Z2 1+1D descriptor family. |
| Dynamical simulation layer | A first finite transfer object exists as executable exact oracle evidence, with a tiny Lean spectral shape that demonstrates the intended theorem interface. | The concrete Wilson slab transfer operator has not yet been constructed in Lean or connected to the OS/GNS sector APIs. |
| Strong-coupling clustering | The KP and observable-clustering theorem surfaces are precise and claim-honest: decay remains an explicit hypothesis. | Q6 metric-tail closure, Q7 volume-uniform support counting, and Q8 concrete observable expansion are still open. |
| Physical mass gap | The project has finite, theorem-shaped prerequisites and exact finite evidence. | There is no infinite-volume, continuum, Hamiltonian, or physical Yang-Mills mass-gap theorem. |

## One-step slab kernel

Let `u` and `v` be spatial link configurations on adjacent time slices, and
let `a` be the temporal-link configuration connecting those slices. Define:

```text
K(u, v) =
  sum_{a in G^{V_s}}
    exp((beta_s / 2) * S_s(u)
        + beta_t * S_t(u, a, v)
        + (beta_s / 2) * S_s(v))
```

Here `S_s(u)` is the within-slice spatial plaquette action, and
`S_t(u, a, v)` is the action of plaquettes crossing the time slab. The
half-spatial weights are included so that, under the usual symmetric Wilson
setup, `K(u, v) = K(v, u)`. That symmetry is useful for positivity and spectral
checks.

For a 1+1 dimensional Z2 model on a spatial circle with `L` spatial links,
write:

```text
u_i, v_i, a_i in {+1, -1}
```

where `u_i` is the spatial link at time `t`, `v_i` is the corresponding link
at time `t + 1`, and `a_i` is the temporal link at site `i`. With periodic
spatial boundary conditions, `a_L = a_0`. The temporal plaquette is:

```text
P_i(u, a, v) = a_i * v_i * inv(a_{i+1}) * inv(u_i)
```

For Z2, inversion is trivial, so:

```text
P_i(u, a, v) = a_i * v_i * a_{i+1} * u_i
```

The first transfer kernel is therefore:

```text
K(u, v) =
  sum_{a_0, ..., a_{L-1} in {+1, -1}}
    exp(beta * sum_{i=0}^{L-1} a_i * v_i * a_{i+1} * u_i)
```

This is the smallest honest finite dynamical object for the simulation layer.
Its state space is finite, its matrix entries are explicit, and its partition
function on `T` time slices is:

```text
Z_T = Tr(K^T)
```

The crucial validation identity is:

```text
Tr(K^T) =
  sum_{periodic spacetime fields U} prod_p exp(beta * U_p)
```

If this fails, the time-slicing convention is wrong.

## Observables and transfer expectations

A time-local observable `O` becomes a diagonal matrix:

```text
M_O(u, v) = O(u) if u = v, and 0 otherwise.
```

Finite-volume expectations become:

```text
<O>_T = Tr(M_O K^T) / Tr(K^T)
```

Two-time Euclidean correlations become:

```text
<A(0) B(tau)>_T =
  Tr(M_A K^tau M_B K^(T - tau)) / Tr(K^T)
```

If the eigenvalues in a chosen sector satisfy
`lambda_0 >= lambda_1 >= ... > 0`, then the finite-volume gap estimate is:

```text
Delta_1 = -log(lambda_1 / lambda_0)
```

This connects directly to the existing `FiniteGapAssembly` API, but only after
the concrete transfer object, sector preservation, and relevant cyclicity
hypotheses have been supplied.

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
local gap. The successor `FiniteGapSpectralWitness` package now names the
extra finite evidence needed to make those spectral parameters non-vacuous:
an explicit sector-preserving transfer endomorphism together with vacuum and
local excitation eigenvector equations. It still does not itself build that
transfer object. The new `TwoStateTransferSpectrum` module supplies the first
tiny kernel-checked spectral payload that could feed such a witness after the
missing cyclicity, sector, and Wilson-slab identification hypotheses are
separately supplied. The follow-on `TwoStateTransferWitness` module carries
this one step further for a deliberately toy whole-space sector: it proves
full-endomorphism cyclicity and fills the `FiniteGapSpectralWitness` fields
from the two-state descriptor. It is useful as an API test, not as evidence
that the physical Wilson slab sector has been constructed.

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

The minimal useful package has two parts: an exact oracle and a transfer
matrix builder. The exact oracle should be implemented first because it is the
validation target for the transfer matrix.

Exact-oracle deliverable:

1. Z2 finite-lattice descriptor for a rectangular 2D torus or rectangle.
2. Exact enumeration of all link fields.
3. Wilson plaquette action and rectangular Wilson loop observable.
4. Partition function and Wilson-loop expectation calculation.
5. Comparison against the proved area-law expectation theorem in the rectangle
   setting where the theorem applies.
6. A simple report generator that prints the model conventions, raw sums,
   normalized expectations, and theorem comparison.

First dynamical deliverable:

```text
Z2_1p1D_transfer_oracle
```

Specification:

```text
Group:        Z2 = {+1, -1}
Space:        L-site circle
Time:         T slices
State:        spatial links u in {+1, -1}^L
Kernel:       K(u,v) = sum_a exp(beta * sum_i a_i * v_i * a_{i+1} * u_i)
Partition:    Z_T = Tr(K^T)
Observables:  global flux Phi(u) = prod_i u_i
Spectra:      eigenvalues of K, optionally by Phi-sector
Gap:          Delta = -log(lambda_1 / lambda_0)
Validation:   compare Tr(K^T) with full spacetime enumeration
```

This would not be "full dynamics," but it would be the first honest finite
Euclidean transfer model. It would also be a good debugging tool for the
remaining Wilson slab-kernel and sector-decomposition design.

## Serializable descriptor sketch

Use a deterministic JSON-like model descriptor. For the first model:

```json
{
  "model": "finite_group_lattice_gauge",
  "group": "Z2",
  "dimensions": {
    "space": [4],
    "time": 6
  },
  "boundary": {
    "space": "periodic",
    "time": "periodic"
  },
  "couplings": {
    "beta_s": 0.0,
    "beta_t": 0.4
  },
  "links": "oriented_canonical",
  "plaquettes": "right_hand_temporal_first",
  "kernel": "wilson_slab_half_spatial",
  "observables": [
    {
      "name": "spatial_holonomy",
      "type": "product",
      "links": "all_spatial_links_at_time_0"
    }
  ],
  "sectors": [
    {
      "name": "global_flux",
      "label": "product_spatial_links"
    }
  ]
}
```

The descriptor is part of the scientific object: it fixes the group,
orientation, boundary, weight, kernel, observables, and sector labels.

## Suggested implementation API

```python
class FiniteGroup:
    elements: list
    identity: object

    def mul(self, a, b): ...
    def inv(self, a): ...
    def character(self, a): ...


class LatticeDescriptor:
    group: FiniteGroup
    spatial_shape: tuple[int, ...]
    time_extent: int
    boundary_space: str
    boundary_time: str
    beta_s: float
    beta_t: float


class TransferModel:
    descriptor: LatticeDescriptor

    def spatial_states(self):
        """Enumerate spatial link fields."""

    def temporal_links(self):
        """Enumerate temporal link fields for one slab."""

    def temporal_plaquette(self, u, a, v, i):
        """Return plaquette holonomy for one temporal plaquette."""

    def slab_weight(self, u, v):
        """Return K[u,v]."""

    def transfer_matrix(self):
        """Build finite matrix K."""

    def observable_matrix(self, observable):
        """Build diagonal insertion matrix M_O."""

    def partition_from_transfer(self, T):
        """Return Tr(K^T)."""

    def expectation_from_transfer(self, observable, T):
        """Return Tr(M_O K^T)/Tr(K^T)."""

    def sector_blocks(self, projectors):
        """Return P_s K P_s blocks after checking commutation."""
```

For the first pass, `sector_blocks` can use numerical projection matrices. For
the Z2 spatial-circle model, a simple gauge-invariant label is global spatial
flux:

```text
Phi(u) = prod_i u_i
```

Before using sector spectra, check:

```text
P_s K = K P_s
```

for each candidate sector projector `P_s`.

## First numerical tests

Use these tests before doing anything larger:

```text
Test 1: L=1, T=1
Compare full enumeration against Tr(K).

Test 2: L=2, T=2
Compare full enumeration against Tr(K^2).

Test 3: gauge invariance
Apply random vertex gauge transformations and verify W(U) is unchanged.

Test 4: kernel symmetry
Verify K[u,v] = K[v,u].

Test 5: positivity
Verify all eigenvalues of K are nonnegative up to numerical tolerance.

Test 6: sector preservation
For each candidate projector P_s, verify ||P_s K - K P_s|| = 0.

Test 7: observable insertion
Compare transfer expectation with full enumeration expectation.

Test 8: spectral correlation
Compute C(tau) from transfer traces and compare against eigendecomposition.

Test 9: sector-block spectrum
Build orthonormal bases for the center-shift +/- projectors, compress K to
each block, and check that the combined positive block spectra reconstruct
the positive spectrum of K.
```

## Milestones toward true dynamics

### Milestone 1: exact finite Euclidean oracle

Deliverables:

- `Scripts/oracle/` module for finite lattice enumeration;
- JSON or CSV output with conventions;
- fixtures for Z2 and Z3;
- tests comparing exact enumeration to current Lean-proved identities;
- tests comparing full spacetime enumeration to transfer-trace formulas once
  the transfer builder exists.

Exit criterion:

- exact small-lattice expectations match the Lean-predicted finite identities.

### Milestone 2: concrete transfer kernel

Deliverables:

- one fixed time-sliced lattice shape;
- definition of the one-step kernel;
- numerical matrix construction;
- statement mapping the kernel to existing `TransferHilbert*` abstractions;
- trace validation against exact spacetime enumeration.

Exit criterion:

- the transfer kernel is positive in the expected sense, preserves the selected
  sectors, and reproduces exact enumeration through `Tr(K^T)` and inserted
  trace identities.

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
  package apply to an actual transfer operator. The new spectral-witness
  package names the required operator/eigenvector evidence but does not
  construct the operator.

These are proof and design blockers, not software-only blockers.

## Main engineering blockers

The engineering blockers are:

- no general canonical serialized finite-lattice descriptor yet;
- no unified exact enumerator for link fields and observables;
- no fixture format tying oracle output back to Lean theorem names;
- no general descriptor-driven transfer-matrix builder;
- no general descriptor-driven sector-block matrix extraction;
- no sampling code or detailed-balance test harness.

These can be developed in parallel with the proof work, provided the
simulation code stays explicitly labeled as oracle/evidence rather than proof.
The transfer-specific blockers now have a narrow Z2 1+1D prototype in
`Scripts/oracle/z2_transfer_oracle.py`, including a JSON-ready descriptor and
summary record, descriptor-file loading, supported-label validation, optional
matrix emission, and a tiny Lean spectral descriptor bridge in
`TwoStateTransferSpectrum.lean`, with `TwoStateTransferWitness.lean` proving
that the finite-gap witness API can be instantiated on a tiny whole-sector
model. The remaining engineering task is to extend that descriptor-driven
prototype beyond the current Z2 1+1D model and connect its concrete Wilson
slab matrices back to Lean theorem surfaces.

## Suggested first collaborator project

Build the Z2 finite Euclidean transfer oracle.

Start with:

- exact enumeration of spacetime link fields valued in Z2;
- plaquette product and Wilson weights;
- Wilson weight `exp(beta * plaquette)`, or the existing tanh-normalized
  strong-coupling convention if matching the Q7 fixtures;
- a 1+1 dimensional spatial-circle slab transfer kernel;
- `Tr(K^T)` comparison to full spacetime enumeration;
- diagonal observable insertion comparison;
- global-flux sector projection tests;
- output of partition function, raw numerator, normalized expectation,
  transfer spectrum, and convention metadata.

Then compare:

- trivial small volumes by hand;
- current Python oracle conventions;
- Lean area-law theorem surfaces in `RectBoundaryExpectation.lean` and related
  YM1 files where applicable;
- Lean transfer/gap prerequisite names in `TransferHilbert*` and
  `FiniteGapAssembly.lean`, without claiming those APIs are already
  instantiated by the oracle.

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

The right next step is to build the exact finite enumerator and the Z2
one-step transfer model together, with enumeration as the validation oracle for
the transfer kernel. Only after that should sector spectra, gap packaging, or
large stochastic simulation be attempted.

## Reference note

- Creutz, M. "Gauge fixing, the transfer matrix, and confinement on a
  lattice. [Hamiltonian]." Physical Review D 15:4, 1977.
  DOI: 10.1103/PhysRevD.15.1128. OSTI record:
  https://www.osti.gov/biblio/7118049
