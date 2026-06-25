# Improved Lean roadmap for the null-strand Bohm–Bell program

**Revision date:** 2026-06-25  
**Purpose:** convert the existing roadmap into an implementation-grade formalization blueprint with explicit proof contracts, critical paths, stop conditions, and claim boundaries.

## 1. Executive changes

The earlier roadmap has the right conceptual decomposition, but it still mixes four things that must be tracked separately:

1. whether a declaration is reported to exist or has actually been rebuilt and audited;
2. whether a node is a theorem, a conditional theorem, a conjecture, a computation, or a no-go result;
3. whether a result is kinematic, dynamical, interpretive, or a genuine new-physics gate;
4. whether a result is an ensemble identity, a one-time expectation, or a pathwise almost-sure theorem.

This revision makes the following changes.

- **Reported banked results are not called verified.** They become `REPORTED_EXISTING` until a clean build, import audit, and axiom audit pass.
- **The first complete pathwise model is i.i.d. and finite.** This uses the existing Banach-valued strong law and avoids making a new finite Markov-chain ergodic theorem a hidden prerequisite.
- **The exact checkerboard Bohm model is a separate capstone.** It proves null steps and Born equivariance, while the i.i.d. capstone proves a single-history timelike coarse limit.
- **Discrete-time kernels, continuous-time jump generators, and continuum drifts are different APIs.** The old plan occasionally treated them as one object.
- **Flux theorems are abstracted from the sphere measure.** First prove them for any finite or measurable null law with barycenter `U`; only later construct the canonical covariant measure.
- **Finite least action is stated as a minimum-energy edge-current problem.** It produces an antisymmetric probability current and rates; it is not described as a continuous angular velocity on a finite set.
- **Expectation and ergodicity are split.** `E[ds/dt]=1/(n·U)` is kinematic; long-run clock convergence requires a separate mixing theorem.
- **Synchronization curvature is rule-dependent.** A Bell-pair calculation must name the hidden transport selector. No unconditional entanglement-curvature equivalence is proposed.
- **The graph-operator gate is split into support, symbol, square, and scaling.** The support-transfer lemma is easy; exhibiting one operator satisfying all four requirements is the actual physics problem.
- **The theorem manifest includes definitions, assumptions, proof strategies, mathlib gaps, stop conditions, and gate assignments.**

## 2. Two-axis status system

Do not encode theorem maturity and scientific meaning in one label.

### 2.1 Formal state

| State | Meaning |
|---|---|
| `REPORTED_EXISTING` | Named in the supplied inventory but not rebuilt in the present audit |
| `READY_TO_RUN` | An engineering or computation task can be run immediately |
| `STATEMENT_DESIGNED` | The intended Lean contract is sufficiently precise to write |
| `READY_TO_PROVE` | Dependencies and a credible proof strategy are identified |
| `READY_AFTER_DEPS` | Proof is routine once named dependencies are complete |
| `BLOCKED_ON_SPIKE` | A small API experiment must settle feasibility first |
| `BLOCKED_ON_MODEL` | The mathematical object or physical rule is not yet fixed |
| `BLOCKED_ON_LIBRARY` | The statement is clear, but substantial library infrastructure is missing |
| `LIBRARY_PROJECT` | Valuable general mathematics, larger than this project’s immediate needs |
| `DEFERRED` | Correct but not on a critical path |
| `DO_NOT_STATE_AS_THEOREM` | Current wording is too strong or not well posed |

### 2.2 Claim kind and physics role

A node is separately classified as a definition, theorem, conditional theorem, no-go theorem, computation, audit, library project, or conjecture. Its physics role is separately marked as kinematic, equivariant, ontological, dynamical, interpretive, phenomenological, or a new-physics gate.

This prevents a perfectly correct kinematic identity from being presented as a derived dynamics.

## 3. Formalization gates

### Gate G0 — verified finite bank

Required outputs:

- clean pinned build;
- generated import audit for every reported theorem;
- convention and normalization map;
- no unapproved `sorry`, `admit`, or axiom dependencies in public capstones.

No later “banked” claim should be used before G0.

### Gate G1 — exact finite null-strand models

Two independent capstones:

1. `finiteIIDNullStrand_master`: every increment is null and one actual history has a timelike coarse limit almost surely;
2. `checkerboardBohmBell_master`: the exact 1+1 pilot-wave process is Born-equivariant and moves one null step per tick.

G1 is the first realistic publication-grade endpoint.

### Gate G2 — covariant one-particle kinematics and finite nonlocality tests

Adds:

- intrinsic null measure and Lorentz covariance;
- observer flux measure and mass-ratio variance theorem;
- finite product-null separability obstruction;
- synchronization-defect framework and baseline computations;
- finite Bell current/rates.

### Gate G3 — selected finite dynamics and finite QFT interfaces

Adds:

- minimum-energy angular current;
- finite refresh-chain mixing diagnostics;
- finite Fock-sector Bell forward equation;
- flatness/path-independence theorem on a finite cut complex;
- reviewed super-Dirac block algebra.

### Gate G4 — continuum and many-particle conditional theory

Adds explicit hypotheses for:

- continuum process existence and nonexplosion;
- spectral/mixing certificates;
- one-particle covariant pathwise limit;
- foliated many-particle equivariance;
- concrete local-symbol theorem.

G4 results must remain conditional unless every analytic structure is constructed.

### Gate G5 — graph-derived candidate dynamics

Requires one concrete first-order operator with all of:

- primitive null-continuation support;
- correct local Dirac/null symbol;
- square yielding the desired Laplacian, curvature, and Yukawa blocks without double-counting mass;
- controlled continuum or scaling limit;
- at least one nontrivial constraint or prediction not inserted by hand.

Only G5 changes the status from an empirically equivalent ontology/unravelling to a candidate new dynamics.

## 4. Critical path

The project should not begin with continuum diffusion, multi-time Dirac PDEs, or causal-set scaling.

```text
G0 audit
  -> canonical conventions
  -> finite PMF kernels
  -> null fiber + octahedral finite resolution
  -> abstract finite flux theorem
  -> trajectory measure + i.i.d. strong law
  -> finiteIIDNullStrand_master

parallel:
  checkerboard bank
  -> two-state minimal coupling
  -> one-step and n-step equivariance
  -> checkerboardBohmBell_master
```

Everything in this path is finite except the already available strong law. It proves the core conceptual possibility with no continuum stochastic geometry.

The next critical path is:

```text
finite jump generator
  -> residual antisymmetric current
  -> exact finite null lift
  -> minimum-energy current selector
  -> refresh-chain diagnostics
  -> finiteEquivariantNullLift_master
```

The covariant sphere measure, Bell-pair synchronization pilot, finite Fock theory, and graph operator are parallel research tracks rather than blockers for G1.

## 5. Repository and import architecture

```text
PhysicsSM/
  NullStrand/
    Audit/
      Build.lean
      Inventory.lean
      Axioms.lean
    Conventions.lean
    Lorentz4.lean
    Probability/
      FiniteKernel.lean
      JumpGenerator.lean
      Trajectory.lean
    NullFiber/
      Basic.lean
      Barycentric.lean
      FiniteDesign.lean
      FluxFinite.lean
      MassRatio.lean
      RegulatorNoGo.lean
      BarycentricMeasure.lean
      IntrinsicMeasure.lean
      FluxMeasure.lean
      ExplicitKernel.lean
    ZigZag/
      ChiralCurrent.lean
      TransferCurrent.lean
      MinimalRates.lean
      TwoStateCoupling.lean
      LatticeBeable.lean
      Dispersion.lean
      DiracContinuity.lean
    NullLift/
      ExtendedLaw.lean
      ResidualCurrent.lean
      FiniteEquivariance.lean
      LeastActionMatrix.lean
      LeastActionRates.lean
    Ergodic/
      IIDNullSteps.lean
      RefreshChain.lean
      SpectralGap.lean
      FiniteMarkovStrongLaw.lean
    Clock/
      StrandParameterFinite.lean
      IIDReadout.lean
      InternalHolonomy.lean
      Operational.lean
    Entanglement/
      DirectionProjector.lean
      ProductNullRepresentation.lean
      SeparabilityObstruction.lean
    Synchronization/
      HiddenRule.lean
      DiamondDefect.lean
      FlatConnection.lean
      BellPairPilot.lean
    BellQFT/
      FiniteCurrent.lean
      MinimalRates.lean
      Support.lean
      FockCutoff.lean
      PathConstruction.lean
    Graph/
      NullContinuation.lean
      BellSupport.lean
      Support.lean
      LayeredWalk.lean
      SuperDirac.lean
      Symbol.lean
      LocalityAudit.lean
      NullDilation.lean
    Continuum/
      AbstractPoisson.lean
      SpectralCertificate.lean
      SpherePoisson.lean
      SphereDiffusion.lean
      Process.lean
    Master/
      FiniteIID.lean
      Checkerboard.lean
      FiniteLift.lean
      OneParticleContinuum.lean
      FoliatedManyParticle.lean
      GraphDerived.lean
```

### Import firewall

- `Master.FiniteIID` and `Master.Checkerboard` must not import any continuum, manifold, PDE, causal-set, or QFT module.
- `NullFiber.FluxFinite` must not import `IntrinsicMeasure`; it is generic over a finite barycentric law.
- `BellQFT` may import the finite null-lift API, never the converse.
- `Graph.Symbol` may import the banked static Dirac/Pluecker bridge; static spinor modules must not import graph ontology.
- Draft/conjectural modules must never be imported by trusted finite capstones.

## 6. Core public interfaces

The exact syntax should follow the repository’s existing types, but the contracts should have this shape.

### 6.1 Finite null resolution

```lean
structure FiniteNullResolution
    (Omega : Type*) [Fintype Omega] (U : Minkowski4) where
  law : PMF Omega
  k : Omega -> Minkowski4
  futureNull : forall w, IsFutureNull (k w)
  normalized : forall w, minkowskiInner U (k w) = 1
  barycenter : expectation law k = U
```

The public type should use a probability object, not raw weights plus a collection of normalization hypotheses.

### 6.2 Measurable barycentric null law

```lean
structure NullBarycentricMeasure (U : Minkowski4) where
  measure : Measure (NullFiber U)
  probability : IsProbabilityMeasure measure
  integrable_id : Integrable (fun k => (k : Minkowski4)) measure
  barycenter : integral (fun k => (k : Minkowski4)) measure = U
```

Every continuum flux theorem should assume only this interface. The sphere/Haar construction is one instance, not part of the theorem’s proof.

### 6.3 Discrete-time and continuous-time dynamics

```lean
abbrev FiniteKernel (A B : Type*) := A -> PMF B

structure FiniteJumpGenerator (A : Type*) [Fintype A] where
  rate : A -> A -> Real
  offdiag_nonneg : ...
  row_sum_zero : ...
```

Do not use the word “kernel” for a continuous-time rate matrix, and do not use “drift” for a probability current on a finite direction graph.

### 6.4 Hidden transport rule

```lean
structure HiddenTransportRule where
  hiddenState : Type
  equilibrium : QuantumState -> PMF hiddenState
  kernel : QuantumState -> LocalUpdate -> FiniteKernel hiddenState hiddenState
  equivariant : ...
  covariance : ...
```

Synchronization curvature is a property of an instance of this structure. It is not a state-only invariant.

### 6.5 Operator support

```lean
def SupportedOn (D : Matrix Q Q Complex) (R : Q -> Q -> Prop) : Prop :=
  forall q q', not (R q q') -> D q q' = 0
```

Separate the relation into spacetime-changing null propagation and zero-displacement internal events. The final ontology claim should not call a same-vertex chirality change a spacetime null segment.

## 7. Workstream details

### W0 — audit and source of truth

**Objective:** verify the current theorem bank and prevent plan/code drift.

Deliverables:

- `Audit.Inventory` imports and `#check`s every claimed declaration;
- `Audit.Axioms` records approved axiom dependencies of capstones;
- machine-readable theorem manifest generated from annotations;
- human-readable blueprint with stable node IDs;
- one command regenerates CSV/JSON/DOT status artifacts.

Use a blueprint tool, but keep Lean declarations as the source of truth. A manually maintained CSV should be treated as generated output after the project begins.

**Exit criterion:** G0.

### W1 — finite Lorentz and null-fiber core

Prove `nullFiber_equiv_restSphere` and the octahedral finite resolution first. Delay abstract Lorentz-group manifold structure.

Two implementation routes should coexist:

- **MVP coordinate route:** standard rest vector and explicit rational directions;
- **canonical route:** arbitrary `U`, abstract rest-space fiber, and Lorentz transport.

The MVP route unlocks G1. The canonical route unlocks G2.

### W2 — abstract flux theorem

Prove finite and measurable versions from only a barycenter hypothesis.

The key cancellation is:

```text
pi(w) proportional to (n·k(w)) nu(w)
observerDirection(k) = k/(n·k) - n
```

so the weighted mean depends only on `integral k dnu = U`. This factorization is the main proof simplification in the entire kinematic branch.

Required theorem split:

- normalization of flux law;
- observer direction is unit and spatial;
- mean equals relative velocity;
- variance equals inverse gamma squared;
- expected strand rate equals inverse gamma;
- mass-ratio/determinant wrapper.

### W3 — exact checkerboard Bohm process

Do not begin from continuum jump rates. Build the exact discrete coupling through each coin.

The reusable theorem is the unique minimum-off-diagonal coupling between two two-state Born distributions. Then:

1. coin coupling has the correct target marginal;
2. deterministic conditional shift preserves the target wave distribution;
3. every actual shift is null;
4. finite induction gives n-step equivariance;
5. Ionescu–Tulcea supplies an infinite trajectory measure.

This capstone proves an actual Bohmian null-step theory, not merely a current decomposition.

### W4 — generic finite null lift

Use two separate formulations.

- **Discrete-time:** construct a coupling from the current extended law to the next extended law.
- **Continuous-time:** construct an antisymmetric residual current and derive positive-part jump rates.

The old single “finiteNullLift_equivariant” node should be split accordingly.

Every theorem must state whether it proves:

- a marginal identity;
- a forward/master equation;
- a finite-step kernel;
- an actual infinite trajectory measure.

### W5 — canonical finite least action

On a finite direction set, the canonical object is an edge probability current, not a continuous tangent vector.

Let `B` be an incidence matrix, `W` positive conductances, and `G` a zero-sum residual. Solve:

```text
minimize 1/2 J^T W^{-1} J
subject to B J = -G.
```

The minimizer is a weighted gradient current, found through a weighted graph Laplacian. Prove:

- kernel equals constants on a connected graph;
- zero-sum sources lie in the range;
- unique gauge-fixed potential;
- unique minimum-energy current;
- induced positive-part jump rates preserve the target law.

This is the finite theorem corresponding to the continuum weighted Poisson proposal.

### W6 — pathwise coarse motion

The roadmap now has three tiers.

1. **i.i.d. finite null increments:** complete first using the existing vector-valued strong law;
2. **refresh chain:** prove exact invariant law, L2 contraction, spectral gap, and correlation; pathwise SLLN may be added by a dedicated construction;
3. **general finite Markov chain:** a useful probability-library project, not a prerequisite for G1.

This tiering prevents the static ensemble theorem from being mistaken for a single-history theorem while keeping the first endpoint practical.

### W7 — chiral zig-zag and Dirac transfer

Separate three levels:

- pointwise nullity of Weyl currents;
- abstract signed transfer and minimal rates;
- PDE derivation of the transfer current from the Weyl equations.

The first two are finite/algebraic. The third is an analytic instantiation and may be stated under the Weyl equations before formalizing a full Dirac solution theory.

Mass as an actual symmetric traffic or angular mixing scale remains an additional selection law. Formalize consequences of named traffic rules, not a universal identification.

### W8 — proper-time readout and internal holonomy

Maintain three claims separately:

- `E[ds/dt]=1/(n·U)`: finite or measure-theoretic kinematics;
- long-run average clock rate: strong law or ergodic theorem;
- internal holonomy is an operational clock: open until a readout coupling is specified.

A passive absolute phase should not be declared a physical clock.

### W9 — entanglement obstruction

Begin with finite convex combinations of product rank-one qubit projectors. Prove the easy direction first:

```text
positive product-direction representation -> separable.
```

Then add the converse only after the project’s definition of separability and pure-qubit/Bloch parametrization are aligned.

The no-go theorem constrains local positive ontologies. It does not rule out contextual or nonlocally guided Bohmian directions.

### W10 — synchronization curvature

Define a hidden-transport rule before defining curvature. Run at least two Bell-pair pilots:

- final-state redraw baseline;
- minimum-transport or least-action rule.

A zero result for one rule does not establish foliation independence; a nonzero result does not prove entanglement always forces curvature.

The stronger finite theorem to target is:

```text
zero elementary diamond defect + path-homotopy generation
  -> path-independent hidden transport.
```

This makes synchronization curvature a genuine holonomy problem over the finite space of cuts.

### W11 — finite Bell QFT

Formalize the finite current and master equation before continuous-time sample paths.

Required safety lemma:

```text
zero Born weight at q -> projected state at q is zero -> no outgoing Bell current.
```

This prevents division-by-zero from being handled by convention alone.

A bounded finite continuous-time jump-process construction is a separate probability project. The exact checkerboard model already supplies an actual infinite trajectory for G1.

### W12 — graph operator

Use the following staged audit.

1. generic support-transfer theorem;
2. `support(D^2) subset R composed R`;
3. concrete checkerboard operator instance;
4. reviewed super-Dirac block square;
5. local symbol/soldering theorem;
6. null-support theorem for the concrete operator;
7. continuum/scaling theorem;
8. Bell histories and prediction.

Do not let the easy support-transfer lemma stand in for steps 5–7.

### W13 — continuum analysis

Use an abstract-first strategy.

- Prove a project wrapper around Lax–Milgram now.
- Define explicit spectral/mixing certificate structures now.
- Treat the sphere Sobolev space, weighted Laplace–Beltrami, sphere diffusion, and nonexplosion as separate library/analysis projects.
- Keep the finite graph least-action model as the certified substitute.

No theorem should claim a universal gap as `m -> 0`; degeneration at the massless boundary is expected.

### W14 — causal-set locality and dilation

Do not encode a blanket theorem that Lorentz-covariant causal-set boxes must be nonlocal. Compare candidate operators under a common property matrix:

- retardedness;
- intrinsic locality;
- primitive null support;
- covariance in law;
- stability;
- continuum convergence.

Also test whether an effective operator can be realized as the projected square of a natural null-local operator on an enlarged state space. Add naturality and dimension controls so trivial encodings do not count.

## 8. The first exact master theorems

### 8.1 Finite i.i.d. null-strand master

```lean
theorem finiteIIDNullStrand_master :
  (forall n, IsFutureNull (X (n+1) - X n))
  and
  AlmostSurely (Tendsto
    (fun N => (N : Real)^(-1) • (X N - X 0))
    atTop
    (nhds U))
```

The actual Lean statement will use a trajectory probability space and the project’s vector type. It proves that one actual history can be everywhere null microscopically and timelike macroscopically.

### 8.2 Checkerboard Bohm–Bell master

```lean
theorem checkerboardBohmBell_master :
  EveryStepNull model
  and BornEquivariant model
  and HasTrajectoryMeasure model
```

This is the cleanest formal answer to the original physical intuition.

### 8.3 Generic finite lift master

```lean
theorem finiteEquivariantNullLift_master
    (base : FiniteBaseProcess)
    (resolution : NullResolution base)
    (compatibility : ResidualCompatibility base resolution) :
  ExistsEquivariantNullLift base resolution
```

Its docstring must explicitly say that this is an existence/unravelling theorem and is not unique.

## 9. Open theorem search registry

### O1 — full covariant mixing gap

Incorrect target:

```text
comptonLockedGenerator_spectralGap
```

Correct search program:

1. define the exact generator and invariant law;
2. prove existence/closability;
3. identify reversible or hypocoercive structure;
4. state a Poincare/absolute-contraction theorem under explicit bounds;
5. separately derive or postulate the relation between mass and the gap.

### O2 — continuum process near nodes and the massless boundary

Search for a stopped-process theorem first. A global theorem should not hide exclusion of spatial nodes or support collapse.

### O3 — entanglement and synchronization curvature

Do not seek an unconditional iff. Seek theorem families parameterized by locality, positivity, covariance, and regularity axioms on `HiddenTransportRule`.

### O4 — operational internal clock

Specify a gauge-invariant record variable and a coupling from relative holonomy to that record. Without this, internal phase is not an observable clock.

### O5 — graph super-Dirac symbol

This is the highest-value operator theorem. The search object is a concrete `D`, not another abstract square identity.

### O6 — null-local/covariant/continuum-correct operator

Keep regular layered graphs and causal-set candidates as separate instances of one property audit. A theorem may be positive, negative, or a tradeoff result, but its axioms must be explicit.

### O7 — natural null dilation

Rule out trivial hidden-state encodings by requiring bounded local dimension, functoriality under graph embeddings, covariance, and a controlled continuum limit.

### O8 — observed mass spectrum

Nothing in the current null-lift or Pluecker identities derives the Yukawa spectrum. Keep this outside all near-term capstones.

## 10. Lean/mathlib feasibility map

### Available and directly useful

- finite and countable probability kernels;
- Ionescu–Tulcea infinite trajectory measures;
- Banach-valued strong law of large numbers;
- finite-dimensional inner-product and spectral linear algebra;
- Lax–Milgram in an abstract Hilbert space;
- analytic manifold structure on spheres;
- Haar and general measure-theory infrastructure;
- matrix exponential and broad finite matrix algebra.

### Likely project-local work

- time-oriented Lorentz group wrappers;
- observer rest-space API;
- finite stochastic matrices/jump generators with the project’s conventions;
- graph incidence/weighted-flow theorem;
- qubit separability API specialized to finite convex mixtures;
- cut-complex and hidden-kernel holonomy.

### Likely mathlib-facing or long-horizon work

- finite Markov-chain strong law in a convenient kernel API;
- Sobolev/weak-gradient theory on the sphere suitable for weighted Poisson equations;
- manifold-valued SDEs and nonexplosion;
- continuous-time finite jump-process path construction if no suitable API appears;
- multi-time relativistic PDE/QFT infrastructure.

## 11. CI and proof-quality policy

Every trusted PR should run:

```text
lake build
source scan for sorry/admit/axiom
public capstone axiom audit
blueprint/manifest consistency check
lint/documentation check
selected example evaluation
import and compile-time regression check
```

Additional rules:

- Pin Lean and mathlib revisions.
- Use one declaration per conceptual claim; avoid giant conjunction theorems except final capstones.
- Package recurring assumptions as named structures.
- Keep `simp` attributes conservative and benchmark broad API changes.
- Provide module docstrings with exact conventions and claim boundaries.
- Use deprecation aliases during API consolidation.
- Keep numerical or symbolic scripts as conjecture generators and regression tests, never trusted proof oracles.

## 12. Blueprint and project governance

Use stable node IDs from the improved manifest. The blueprint should include definitions as nodes, not only theorems. Each node should link to:

- the Lean declaration;
- the informal statement;
- assumptions;
- dependencies;
- proof status;
- physics role;
- failure condition.

The generated dependency graph should have separate colors for layers G0–G5 and separate shapes for theorem kinds. Cycles should fail CI.

Each PR should close one coherent dependency cluster and update:

- theorem manifest;
- claim traceability table;
- blueprint state;
- falsification/stop condition if the statement changed.

## 13. Stop/go rules

- **If G0 fails:** stop adding new theory until the bank and conventions are reconciled.
- **If the abstract finite flux theorem fails:** the revised covariant null-lift mathematics is wrong; this is a foundational stop.
- **If the sphere-measure implementation is costly:** continue with exact finite designs; do not block G1.
- **If the Bell-pair defect depends strongly on tie-breakers:** report rule dependence rather than searching for a universal curvature slogan.
- **If no concrete super-Dirac symbol exists:** freeze the graph branch as related finite algebra, not a unified theory.
- **If support and scaling cannot coexist:** retain the ontology as an interpretation and record the tradeoff as a no-go or model-selection result.
- **If continuum mixing assumptions exclude nodes and near-massless states:** state only stopped/local theorems; do not advertise a global continuum process.

## 14. Deliverables in this planning pack

- `NullStrand_Lean_Theorem_Manifest_Improved.csv` — detailed theorem/definition registry;
- `NullStrand_Lean_Theorem_Manifest_Improved.json` — machine-readable equivalent;
- `NullStrand_Lean_PR_Backlog.csv` — dependency-ordered implementation backlog;
- `NullStrand_Lean_Claim_Traceability.csv` — physics claim to formal gate map;
- `NullStrand_Lean_Blueprint_DAG.dot` — initial dependency graph source;
- `NullStrand_Lean_Theorem_Charter.md` — required charter for every physics-facing cluster.

## 15. Recommended immediate sequence

1. Run G0 audit and reconcile the reported theorem bank.
2. Formalize finite PMF kernels and the canonical convention wrapper.
3. Prove the null-fiber/rest-sphere equivalence and octahedral resolution.
4. Prove the abstract finite flux mean, variance, clock-rate, and regulator no-go theorems.
5. Build the two-state checkerboard hidden coupling and exact equivariance theorem.
6. Wrap Ionescu–Tulcea and the existing strong law for actual finite trajectories.
7. Close `finiteIIDNullStrand_master` and `checkerboardBohmBell_master`.
8. Only then begin the generic residual-current lift, least-action selector, and covariant sphere measure.

That sequence produces a coherent, certified answer to the central question before the program takes on its hardest continuum and graph-dynamics obligations.

## 16. Implementation progress (2026-06-25)

This section records the state of the Lean implementation against the manifest.
Live tree: `PhysicsSM/NullStrand/`, built under the pinned toolchain
`leanprover/lean4:v4.28.0`. Ledger: `AgentTasks/null-strand-overnight-ledger-2026-06-25.md`.

### Gate G0 — verified finite bank: ACHIEVED

`lake build PhysicsSM.NullStrand` succeeds (exit 0, 8064 jobs). The full
NullStrand module set compiles. The only remaining `sorry`s are two documented
Aristotle handoffs in `Clock/InternalHolonomy.lean`: HOL-002
`internalSegment_unitary_of_hermitian` (matrix-exponential unitarity, blocked by a
`NormedAlgebra` instance diamond) and HOL-003 `internalHolonomy_gaugeCovariant_path`
(matrix-exp conjugation). All other modules are `sorry`/`axiom`-free.

### Nodes proven and integrated into the live tree (Aristotle, verified clean)

Each was proved as a focused standalone Aristotle job, verified
`sorry`/`admit`/`axiom`-free with `lake env lean` and a `git diff` confirming the
statement was not weakened, then integrated and rebuilt green:

| node | declaration | live module |
|---|---|---|
| KIN-006 | `finiteFluxDirectionMean_eq_relativeVelocity` | `NullFiber/FluxFinite.lean` |
| KIN-009 | `finiteFluxMean_dsdt_eq_invGamma` | `NullFiber/FluxFinite.lean` |
| KIN-010 | `uniformComponent_bounds_meanNorm` | `NullFiber/RegulatorMeanNorm.lean` |
| KIN-011 | `meanNorm_eq_one_implies_support_collinear` | `NullFiber/BoundaryNoGo.lean` |
| DEF-006/007, STO-001/002 | `FiniteKernel`, `FiniteJumpGenerator`, `pushforward_comp`, `masterEquation_mass_conserved` | `Probability/Finite.lean` |
| ERG-001 | `iidNullSteps_empiricalMean_tendsto` (pathwise SLLN) | `Ergodic/IIDStrongLaw.lean` |
| ENT-001 | `pureDirectionProjector` (+trace/Hermitian/idempotent) | `Entanglement/DirectionProjector.lean` |
| BELL-004 | `operatorBlockZero_implies_currentZero` | `BellQFT/BlockSupport.lean` |
| GRAPH-002 | `support_square_subset_relComp` | `Graph/Support.lean` |

Additionally already present/proven in the live tree from the prior wave:
KIN-001 `nullFiber_equiv_restSphere`, KIN-003 `octaNull_mean_eq_timelike`,
ZZ-002 `minimalRates_netTransfer`, ZZ-006..009 lattice-beable equivariance,
LA-001 `weightedLaplacian_kernel_eq_constants`, REF-001..004 refresh-chain
(invariant, mean-zero eigenvalue, spectral gap, correlation),
LIFT-001 `residualCurrent_divergence_eq`, GRAPH-001
`operatorSupport_implies_bellCurrentSupport`, and (via the finite-core proof job)
`quantumCurrent_antisymm`, `minimalBellRate_masterEquation`,
`productDirectionRepresentation_iff_separable`.

### Open / remaining

- READY/CONDITIONAL nodes not yet attempted are tracked in the ledger's
  next-wave list (e.g. ZZ-005 two-state coupling, SYNC-001/002 synchronization
  defect, LA-002/003 least-action range/uniqueness, CONT-001 Lax-Milgram wrapper,
  DEF-004 PMF null-resolution, MASTER-001/002 finite capstones).
- The G4-G5 OPEN registry nodes (O1-O8: full covariant mixing gap, continuum
  process near nodes, entanglement-vs-curvature, operational internal clock,
  graph super-Dirac symbol GRAPH-004, null-local/continuum-correct operator,
  natural null dilation, observed mass spectrum) remain research questions, not
  theorems to assume; per this roadmap they are completed only by exhibiting a
  concrete construction or a precise impossibility result, and are intentionally
  left open rather than discharged.
