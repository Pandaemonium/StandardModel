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

- **Reported banked results are not called verified.** They become `REPORTED_EXISTING` until a clean build, import audit, and assumption audit pass.
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
- generated declaration inventory that `#check`s every banked public name;
- public-capstone assumption audit with an explicit whitelist;
- convention and normalization map;
- no proof-hole or unapproved assumption dependencies in public capstones;
- one canonical definition for each core API object used downstream.

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
  -> duplicate-definition cleanup
  -> generated declaration inventory + assumption audit
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
- Every trusted public capstone must have a transitive import audit: either the
  depended-on draft core is promoted to a trusted namespace, or the capstone's
  transitive closure is checked by an assumption/proof-hole guard before the
  theorem is counted as banked.

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
- `Audit.Axioms` records approved kernel dependencies of capstones;
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
4. reviewed super-Dirac block square with explicit `D = i D_N + Γ₅ Φ` decomposition;
5. local symbol/soldering theorem:
   `nullDirac_commutator_mul_eq_edgeDifferences` (first-order symbol identity),
   then `localNullSymbol_sq_eq_weightedPluckerMass` (Plücker kinetic scalar);
6. frame/curvature decomposition on one diamond:
   `superDirac_sq_eq_finiteLichnerowicz` in the two-direction case:
   `-□_null - curvature - frame defect + Φ^2 - i Γ₅ d_Φ`;
7. null-support theorem for the concrete operator;
8. continuum/scaling theorem;
9. Bell histories and prediction.

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

Status update from the 2026-06-25 Aristotle wave-3 integration: the named
declaration `finiteIIDNullStrand_master` now exists in
`PhysicsSM.NullStrand.Master.FiniteModel` and builds in the live tree. Treat it
as a first concrete G1 capstone candidate, not as final publication closure,
until its hypotheses, construction fields, and assumption surface have been
reviewed against the intended physical claim.

Wave-4 semantic-audit update: Aristotle strengthened this capstone with explicit
null-step, barycenter, and process-nullity conclusions plus an octahedral
i.i.d. witness family. The remaining publication gate is now mechanical and
semantic rather than existential: generate the assumption whitelist, regenerate
the manifest from Lean declarations, and quote the exact finite hypotheses in
any paper.

### 8.2 Checkerboard Bohm–Bell master

```lean
theorem checkerboardBohmBell_master :
  EveryStepNull model
  and BornEquivariant model
  and HasTrajectoryMeasure model
```

This is the cleanest formal answer to the original physical intuition.

Status update from the 2026-06-25 Aristotle wave-3 integration: the named
declaration `checkerboardBohmBell_master` now exists in
`PhysicsSM.NullStrand.Master.Checkerboard` and builds in the live tree. It should
be read as the first finite checkerboard master theorem candidate. The next
review step is semantic: confirm that the finite trajectory measure,
Born-equivariance statement, and null-step statement are the intended ones and
are not only a renamed one-step shell.

Wave-4 semantic-audit update: the module now documents the precise checkerboard
caveat rather than hiding it. The theorem is a real finite checkerboard capstone
for the current model, but the plan should keep the stronger full Minkowski
nullity formulation as a separate closure task until the statement and witness
are aligned.

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

Do not seek an unconditional iff. Seek theorem families parameterized by locality, positivity, covariance, and regularity assumptions on `HiddenTransportRule`.

### O4 — operational internal clock

Specify a gauge-invariant record variable and a coupling from relative holonomy to that record. Without this, internal phase is not an observable clock.

### O5 — graph super-Dirac symbol

This is the highest-value operator theorem. The search object is a concrete `D`, not another abstract square identity.
Priority target (from the 2026-06-25 super-Dirac proposal):

```text
D = i Σ_i c(ℓ_i)(T_i - P_i) + Γ₅ Φ
```

with graded oddness, locality, and exact finite decomposition:

```text
D^2 = -□_null - 𝒞_diamond - 𝒯_frame + Φ^2
      - i Γ₅ Σ_i c(ℓ_i)[∇_i, Φ]
```

where the first three terms are finite geometric data and no additional
Plücker term is added to `Φ^2`.

### O6 — null-local/covariant/continuum-correct operator

Keep regular layered graphs and causal-set candidates as separate instances of one property audit. A theorem may be positive, negative, or a tradeoff result, but its assumptions must be explicit.

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
source scan for proof holes and unapproved assumptions
public capstone assumption audit
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

### Gate G0 — verified finite bank: build-green, audit still to generate

`lake build` succeeds under the pinned toolchain (exit 0, 8292 jobs in the
2026-06-25 integration pass). The live `PhysicsSM/NullStrand/` tree compiles,
and the previously documented `Clock/InternalHolonomy.lean` handoffs have now
been closed:

- HOL-002 `internalSegment_unitary_of_hermitian`;
- HOL-003 `internalHolonomy_gaugeCovariant_path`;
- helper lemma `internalSegment_conj`.

Do not treat this as the full G0 audit until the generated import inventory and
public-capstone assumption-whitelist reports are committed. The current status is
"build green and targeted proof integrations checked"; the remaining G0 work is
mechanical but still required for publication-grade claims.

The 2026-06-25 Aristotle hardening review also makes G0 include three concrete
cleanup gates before G2/G3 reuse: de-duplicate `FiniteNullResolution`, unify the
`minkowskiInner` convention surface, and keep only one public proof of
`uniformComponent_bounds_meanNorm`; generate the declaration inventory from Lean
rather than treating the hand-maintained manifest as authoritative.

### Nodes proven and integrated into the live tree (Aristotle, verified clean)

Each was proved as a focused standalone Aristotle job, verified with
`lake env lean`, token scans, and a `git diff` confirming the statement was not
weakened, then integrated and rebuilt green:

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
| HOL-002/HOL-003 | `internalSegment_unitary_of_hermitian`, `internalSegment_conj`, `internalHolonomy_gaugeCovariant_path` | `Clock/InternalHolonomy.lean` |
| CONT-001 | `coerciveWeightedPoisson_exists_unique` | `Continuum/AbstractPoisson.lean` |
| DEF-004, KIN-004 | `FiniteNullResolution`, `octahedralResolution` | `NullFiber/Barycentric.lean` |
| BELL-002 | `zeroBornWeight_implies_noOutgoingCurrent` | `BellQFT/BornSafety.lean` |
| TRAJ-001 | `iidTrajMeasure_isProbability` | `Probability/Trajectory.lean` |
| KIN-003 | `octa_secondMoment_isotropic` | `NullFiber/OctaSecondMoment.lean` |

### Additional in-tree verified jobs (documented in ledger)

This cycle also completed the following follow-on job IDs as verified and integrated:

| project_id | primary node(s) |
|---|---|
| `eea53903-3816-424b-8344-341b014e8ed0` | `CONT-001` |
| `43e6ddc9-dc11-49cf-a5bf-0f843da02247` | `KIN-003` |
| `e675d945-d923-4298-807b-4f0c74f52b9e` | `DEF-004`, `KIN-004` |
| `cdfbad1c-bd1d-44e3-89a5-4ea7c821b29c` | `BELL-002` |
| `2ccba4dc-906b-43d2-b1e9-bd51760c1499` | `TRAJ-001` |

Additionally already present/proven in the live tree from the prior wave:
KIN-001 `nullFiber_equiv_restSphere`, KIN-003 `octaNull_mean_eq_timelike`,
ZZ-002 `minimalRates_netTransfer`, ZZ-006..009 lattice-beable equivariance,
LA-001 `weightedLaplacian_kernel_eq_constants`, REF-001..004 refresh-chain
(invariant, mean-zero eigenvalue, spectral gap, correlation),
LIFT-001 `residualCurrent_divergence_eq`, GRAPH-001
`operatorSupport_implies_bellCurrentSupport`, and (via the finite-core proof job)
`quantumCurrent_antisymm`, `minimalBellRate_masterEquation`,
`productDirectionRepresentation_iff_separable`.

### Standalone proof jobs integrated but not yet promoted

The 2026-06-25 next-wave Aristotle batch also produced focused standalone proofs
that were locally checked and staged under `AgentTasks/aristotle-standalone/`.
Some are intentionally not yet promoted because their standalone contracts use a
simplified API or need a deliberate live-module home:

- KIN-007 `weighted_variance_eq_one_sub_normSq`;
- KIN-008 `massRatioSq_eq_invGammaSq`, `invGammaSq_eq_massRatioSq`;
- ZZ-005 `minimalTwoStateCoupling_unique`, `minimalTwoStateCoupling_net`;
- LA-002 `lapMatrix_range_eq_zeroSum`;
- SYNC-001/002 `applyKernel_applyKernel`,
  `defect_zero_iff_all_initial_laws`;
- BELL/Fock `preservesDirectionMarginal_comp`;
- ENT-003 standalone finite separable marginal probability lemmas;
- TRAJ/MASTER standalone stochastic-iterate probability preservation;
- GRAPH support-powers lemmas.

Promotion order should favor the Mathlib-only or API-stable results first; the
Laplacian range theorem needs a live module placement decision, while KIN-008
and GRAPH square/decomposition claims retain a bank/audit dependency.
The Fock/BELL lane naming audit has now been resolved in the live tree:
`fockNullLift_total_mass_preserved` is the honest total-mass theorem, while
`fockNullLift_preserves_direction_marginal` records the stronger direction-law
preservation under the explicit direction-equivariance hypothesis. The old
`fockNullLift_equivariant` name is retained only as a deprecated alias.

### Open / remaining

- READY/CONDITIONAL nodes advanced by the wave-4 integration include
  least-action uniqueness, refresh-chain invariance/iteration facts,
  synchronization path-independence and defect lemmas, graph support powers, and
  Fock/Bell direction-marginal preservation. The next useful jobs should now
  combine these lemmas into selected finite dynamics, a concrete graph
  super-Dirac data structure, and script-level audit automation.
- MASTER-001/002 are declaration-complete and semantically audited as first
  candidates: `finiteIIDNullStrand_master` and `checkerboardBohmBell_master`
  now exist, compile, and have wave-4 audit notes. They still need generated
  assumption-whitelist and manifest reports before papers should call G1 fully
  publication-closed.
- G0 hardening remains partly open: a lightweight in-tree audit scaffold now
  exists under `PhysicsSM.NullStrand.Audit`, `CapstoneAxioms`, and
  `DuplicateNames`; the duplicate theorem in `RegulatorNoGo.lean` was renamed
  to `expectation_uniformComponent_bounds_meanNorm`; and the newly intentional
  `comp`/`iterate` method-name collisions are classified. Remaining work
  includes script-level generated inventory, public-capstone assumption audit,
  transitive draft-import guard automation, and manifest regeneration from Lean
  annotations. The wave-4 audit-automation archive did not include the scripts
  and docs named in its completion summary, so that recovery is an explicit
  next-wave job.
- The G4-G5 OPEN registry nodes (O1-O8: full covariant mixing gap, continuum
  process near nodes, entanglement-vs-curvature, operational internal clock,
  graph super-Dirac symbol GRAPH-004, null-local/continuum-correct operator,
  natural null dilation, observed mass spectrum) remain research questions, not
  theorems to assume; per this roadmap they are completed only by exhibiting a
  concrete construction or a precise impossibility result, and are intentionally
  left open rather than discharged.

### Aristotle roadmap-review integration note

Aristotle project `aa4a545c-e992-4744-bf2f-d38b662cd695` reviewed the roadmap
package and returned `AgentTasks/nullstrand-roadmap-review-report-aristotle-2026-06-25.md`.
The review package contained planning files rather than the full repository, so
its strongest headline claim that "no Lean tree exists" is a package-scope
artifact and is not true of this checkout. The following recommendations remain
valid and are adopted here:

- keep G0 split into build-green, import-inventory, and assumption-whitelist stages;
- do not put the `Clock/InternalHolonomy` lane on the G1 capstone critical path;
- mark KIN-008, GRAPH-005, GRAPH-007, and mass-spectrum claims as depending on
  the audited bank and convention map;
- expand `MASTER-001` and `MASTER-002` as real trajectory-measure /
  `infinitePi` plumbing tasks rather than one-line assemblies;
- reconcile manifest status, declaration-name drift, entanglement scope, and
  node-count drift by generated metadata rather than prose edits.

### Aristotle roadmap-hardening integration note

Aristotle project `219d6dc6-c805-41ec-a907-b763e3701bee` performed the
full-tree roadmap-hardening review and returned
`AgentTasks/null-strand-roadmap-hardening-report-aristotle-2026-06-25.md`.
Unlike the earlier package-limited review, this pass inspected the live
`PhysicsSM/NullStrand/` Lean tree. The adopted corrections are:

- the live finite tree is materially clean, but G1 is not substantively reached
  until `finiteIIDNullStrand_master` and `checkerboardBohmBell_master` exist as
  concrete-hypothesis theorems with constructed instances;
- `finiteNullStrand_master` is a projection shell, and
  `foliatedManyParticleNullStrand_master` is an acceptable conditional G4
  schema, not evidence that G1 has been assembled;
- BELL-005/Fock claims must be scoped as total-mass preservation unless a true
  direction-marginal equivariance theorem is stated and proved;
- duplicate core APIs (`FiniteNullResolution`, `minkowskiInner`,
  `uniformComponent_bounds_meanNorm`) are G0 blockers before downstream import;
- the manifest, backlog, and traceability tables should become generated
  artifacts from Lean declaration tags and audits.


## New Lean target: Exterior-history mass/measure layer

### Module bundle to add next

- `PhysicsSM/NullStrand/Histories/ExteriorMassMeasure.lean`
- `PhysicsSM/NullStrand/Histories/ExteriorRankMeasure.lean`

### Minimal theorem surface

1. `massCapacity_eq_sum_pairWeights`
2. `massCapacity_mono`
3. `massCapacity_singleton_eq_zero`
4. `massCapacity_i2_eq_crossPlucker`
5. `massCapacity_i3_eq_zero`
6. `massCapacity_mobius_support_eq_pairs`
7. `massBimeasure_diag_eq_massCapacity`
8. `stronglyPositive_zeroDiagonal_row`
9. `massCapacity_not_stronglyPositiveDiagonal_of_noncollinear`
10. `pairLift_recovers_massCapacity`
11. `pairLift_unique`
12. `pairPullback_support_card_le_four`

### Dependencies

- `PhysicsSM/Spinor/PluckerMass`
- `PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle`

### Publication alignment

This is the first formal package where finite Plücker mass and Sorkin-style set functions are combined as a single theorem cluster with ontology-level consequences (pair-history observables and controlled higher-order edge interference pullback).

## Analysis integration note: frontier answers to open questions (2026-06-25)

Two attached frontier-model analyses were reviewed against
`NullStrand_Open_Questions_For_Frontier_Models.md` and this roadmap. They do not
promote any G4/G5 question to a completed theorem, but they sharpen the next
Lean targets.

### Updated scientific status

- **Q5 super-Dirac finite identity:** upgraded from vague OPEN to
  `STATEMENT_DESIGNED / READY_TO_PROVE` for the finite algebraic square, provided
  the grading, shift, projector, and Yukawa compatibility hypotheses are stated
  explicitly.
- **Q5 no-double-counting mass:** resolved at the conceptual level. `Phi^2` is
  the zero-order mass block; Pluecker mass is the kinetic principal-symbol
  invariant. The equality `P(xi)^2 = m^2` is an on-shell dispersion relation, not
  a second additive mass term.
- **Q5 true blockers:** the decisive audits are now the grading/sign convention,
  the residual Lichnerowicz endomorphism, and the symbol/soldering obstruction.
  Positive hidden-process Markov weights cannot also serve as continuum Dirac
  coefficients, because their second-moment tensor is positive semidefinite on
  covectors and cannot reconstruct the indefinite Lorentz metric.
- **Q6/Q7 locality and dilation:** keep as `BLOCKED_ON_MODEL`, but replace broad
  no-go language with a sharper property matrix. The strongest current negative
  target is "primitive-null-only + positive finite-valence coefficients +
  continuum Dirac symbol" rather than all causal-set locality/covariance
  combinations.
- **Q1/Q2 continuum dynamics:** remain conditional G4 targets. Q1 should pursue
  finite irreducible-chain and hypocoercive estimates with explicit degeneration
  hypotheses. Q2 should pursue stopped/local weighted Dirichlet-form statements
  near nodes, with capacity or Muckenhoupt-type assumptions before any global
  theorem is advertised.
- **Q3 synchronization curvature:** the flatness theorem is now a clean
  groupoid/2-cell holonomy target. Entanglement-forces-curvature remains
  rule-dependent and conditional.
- **Q4 operational clock:** internal holonomy needs a relational pointer/readout
  coupling before it can be called a clock. Microscopic null segments carry zero
  proper time, so the readout tracks affine count or relative phase first, and
  proper time only after calibration plus an ergodic theorem.
- **Q8 mass spectrum:** still out of near-term scope. Quantum-marginal or
  entanglement-polytope methods can yield inequalities or allowed regions, not
  observed Yukawa ratios without extra structure.

### New immediate Lean targets from the synthesis

1. **Finite Krein API (`F4`)**

   Add a small finite-dimensional API before claiming Lorentzian honesty for the
   graph operator:

   ```text
   fundamental symmetry J, J = J^dagger, J^2 = 1
   indefinite form [u,v] = <J u, v>
   J-adjoint A^sharp = J A^dagger J
   J-self-adjointness A^sharp = A
   closure lemmas for sums, block matrices, Clifford symbols, and D^2 expansions
   ```

   Proposed module home: `PhysicsSM/NullStrand/Graph/Krein.lean` or a more
   general `PhysicsSM/LinearAlgebra/KreinFinite.lean` if other workstreams will
   reuse it.

2. **Super-Dirac data and square**

   State a trusted finite structure for the decorated graph operator, separating
   three gradings that must not be conflated:

   ```text
   order-complex/form degree
   internal left/right chirality Gamma_5
   any additional finite internal grading under which Phi is odd
   ```

   The first theorem should be the algebraic square

   ```text
   (i D_N + Gamma_5 Phi)^2
     = -D_N^2 + Phi^2 - i Gamma_5 [D_N, Phi]
   ```

   under explicit hypotheses. Do not yet claim continuum soldering.

3. **Residual-endomorphism audit**

   For each finite super-Dirac candidate, define a computable residual:

   ```text
   residualE = D^2 - kineticNullSquare - curvatureDiamond - frameDefect - Phi^2
   ```

   Then prove basic trace/block-support facts and compute small examples. This is
   the finite analogue of checking whether a Lichnerowicz scalar/endomorphism is
   forced beyond `Phi^2`.

4. **Positive-soldering obstruction**

   Prove the linear-algebra obstruction as a standalone theorem:

   ```text
   A(q,q) = sum_i a_i * (q dot ell_i)^2, with a_i >= 0
   -> A is positive semidefinite on real covectors
   ```

   Then record the corollary that such an `A` cannot equal the Lorentz inverse
   metric on a space containing both timelike and spacelike covectors. This is the
   clean theorem that separates hidden-variable probabilities from Dirac-symbol
   coefficients.

5. **Signed/dual/Krein soldering alternatives**

   After the obstruction, try one positive construction:

   ```text
   signed or complex edge coefficients
   dual null coframes rather than raw edge vectors
   doubled advanced/retarded Krein construction
   ```

   The success criterion is a local symbol theorem, not another abstract square
   identity.

6. **Stopped continuum process charter**

   Update the continuum charter so Q2 first targets an exit-time theorem on
   `{rho >= epsilon}` and treats global node avoidance as a separate capacity or
   polarity assumption.

7. **Finite Markov-chain SLLN route**

   For F1, prefer the Poisson-equation proof plan on the zero-mean subspace:

   ```text
   (I - P) g = f - pi f
   additive sums = martingale difference + telescoping boundary
   spectral gap + Borel-Cantelli -> strong law
   ```

   This is likely easier to formalize than importing a broad ergodic theorem.

### Updated stop/go refinement

Do not freeze the graph branch merely because positive Markov weights cannot be
the Dirac soldering coefficients. Instead, mark that as a failed soldering
attempt and try signed/complex coefficients, dual null coframes, or a
Krein-doubled construction. Freeze the branch only if all Lorentzian-honest
soldering attempts fail or require hiding continuum data in an unconstrained
ancilla.

### Second Q5 refinement from attached analysis (2026-06-25)

A later analysis makes the Q5 graph-operator gate sharper. The diagonal null
operator

```text
D_N = sum_i b_i c(ell_i) nabla_i
```

is not merely hard to solder to the continuum Dirac symbol; it is algebraically
impossible as written. Its continuum symbol induces

```text
A xi = sum_i b_i xi(ell_i) ell_i^flat,
```

and `tr(A) = sum_i b_i g(ell_i, ell_i) = 0`, while the identity on `T^*V` has
trace `4`. This kills the diagonal `c(ell_i) nabla_{ell_i}` soldering target even
with signed or complex scalar coefficients.

The corrected target keeps primitive null finite differences but uses dual or
cross-soldered Clifford coefficients:

```text
NullSolderFrame:
  ell   : finite family of null directions
  alpha : finite family of covectors
  dual  : xi = sum_a xi(ell_a) alpha^a

D_sol = sum_a c(alpha^a) nabla_a.
```

A concrete tetrahedral frame has four future-null directions `ell_A = (1, n_A)`
with regular tetrahedron spatial parts. If `G_AB = g(ell_A, ell_B)`, then

```text
G_AA = 0,
G_AB = 4/3 for A != B,
G^AA = -1/2,
G^AB = 1/4 for A != B,
alpha^A = sum_B G^AB ell_B^flat,
D_tet = sum_A,B G^AB c(ell_B^flat) nabla_A.
```

This should replace the previous diagonal super-Dirac symbol in the roadmap. The
support remains primitive-null; the soldering is carried by the inverse Gram
matrix.

Updated Lean target order:

1. Prove `diagonal_null_symbol_trace_zero` for sums of null rank-one soldering
   terms, and record the trace obstruction to the identity symbol.
2. Define `NullSolderFrame` with null directions, dual covectors, and the dual
   identity `xi = sum_a xi(ell_a) alpha^a`.
3. Prove `dual_solder_commutator` for `sum_a clifford (alpha a) * nabla a` at the
   principal-symbol level.
4. Specialize to the tetrahedral null frame and inverse Gram coefficients.
5. Prove the corrected finite square with `C_a = c(alpha^a)`:

   ```text
   D^2 =
     -Box_null
     -C_diamond
     -T_frame
     +Phi^2
     -i Gamma_5 sum_a C_a [nabla_a, Phi].
   ```

6. Audit the retarded/advanced doubled operator

   ```text
   D_double = [[0, D_-],
               [D_+, 0]]
   ```

   as the bounded-dimension, blockwise-null, functorial natural-dilation
   candidate for Q6/Q7.

This changes the graph branch stop rule. Do not freeze the branch because the
diagonal symbol fails. Freeze only if the dual/cross-soldered or Krein-doubled
operators fail the Lorentzian symbol, square, and naturality audits.

The same analysis also sharpens two non-graph targets:

- F1/Q1: finite continuous-time Markov-chain SLLN should use the Poisson equation
  `-Q g = f - pi f`, martingale decomposition, bounded endpoint term, and
  quadratic-variation growth `O(t)`.
- Q2: stopped weighted diffusion near nodes should record the Bessel-dimension
  heuristic `delta = d_perp + alpha`; the node is inaccessible in the radial
  approximation when `delta >= 2`.
### Physical consequence map from earlier analysis (2026-06-26)
+
+An earlier attached analysis is useful, but mostly downstream of the immediate
+dual-soldering task. It should be treated as a consequence map for what the
+super-Dirac operator could buy us after the symbol and square are trusted.
+
+#### Consequences now worth adding to the roadmap
+
+1. **Null-pair mass-area theorem**
+
+   Exact finite target: for null `p` and `q`, pair mass and simple bivector area
+   are not independent. The scalar Clifford projection gives the Pluecker mass
+   contribution; the antisymmetric projection preserves oriented pair-area data.
+
+   Proposed module home: `PhysicsSM/NullStrand/Graph/NullPairGeometry.lean` or a
+   spinor/Clifford-adjacent module if it should reuse existing Pluecker code.
+
+   First declarations:
+
+   ```text
+   nullPair_massSq_eq_two_inner
+   nullPair_bivectorNormSq_eq_neg_half_massFourth
+   nullPair_bivector_dualPairing_eq_zero
+   nullPair_cliffordProduct_eq_scalar_add_bivector
+   ```
+
+2. **Universal principal symbol as an equivalence-principle statement**
+
+   Once the dual-soldered principal symbol is trusted, prove that internal
+   species share the same one-edge support and characteristic cone when only the
+   lower-order Yukawa block varies by species. This is a clean finite statement
+   of universal microscopic causal support.
+
+   First declarations:
+
+   ```text
+   principalSymbol_independentOfInternalState
+   characteristicSet_eq_nullCone
+   speciesUniversal_oneEdgeSupport
+   equivalenceViolation_requires_nonuniversalPrincipalData
+   ```
+
+3. **Spectral mass-shell matching**
+
+   In a flat/constant-`Phi` finite envelope, if
+   `D^2 = -K tensor I + I tensor M^2`, then on-shell states are exactly matching
+   eigenspaces of `K` and `M^2`. This is exact finite linear algebra and may be a
+   promising bridge from assigned masses to constrained spectral compatibility.
+
+   First declarations:
+
+   ```text
+   kernel_tensorDifference_eq_matchingEigenspaces
+   massShellMultiplicity_eq_sum_matchingMultiplicities
+   ```
+
+4. **Supersymmetric-quantum-mechanics envelope**
+
+   The block operator `Q = [[0, A^dagger], [A, 0]]` gives nonzero spectral
+   pairing and zero-mode imbalance equal to the index of `A`. This gives a
+   finite topological sector without claiming spacetime supersymmetry.
+
+   First declarations:
+
+   ```text
+   superDirac_nonzeroSpectrum_paired
+   superDirac_zeroModeImbalance_eq_index
+   wittenIndex_eq_chiralKernelDifference
+   ```
+
+5. **Defect and Weitzenbock zero-mode pilots**
+
+   A sign-changing finite mass/Yukawa field should be modeled first on a finite
+   chain as a domain-wall pilot. Separately, a positive-envelope Weitzenbock form
+   `H = nabla^dagger nabla + V` gives gap/zero-mode tests by finite Rayleigh
+   inequalities.
+
+   First declarations:
+
+   ```text
+   zeroMode_absent_of_positiveWeitzenbockPotential
+   zeroMode_requires_nonpositiveEffectivePotential
+   finiteChain_domainWall_zeroMode_draft
+   ```
+
+6. **Local dilation and Schur complement**
+
+   A sparse local microscopic operator on visible plus hidden sheets can yield a
+   dense effective visible operator after eliminating the hidden sector:
+
+   ```text
+   D_eff = D_vis - B D_hid^{-1} C.
+   ```
+
+   This gives a concrete algebraic mechanism for reconciling microscopic null
+   locality with nonlocal effective chirality or causal-set-like tails.
+
+   First declarations:
+
+   ```text
+   localBlockOperator_schurComplement
+   localDilation_effectiveOperator_eq_schurComplement
+   sparseMicroscopicOperator_canYield_denseEffectiveOperator
+   ```
+
+7. **Spectral action and superconnection curvature**
+
+   After the square theorem, the dynamical upgrade is a finite spectral action
+   from `H = D^sharp D`, with trace identities for curvature squares, Higgs
+   kinetic terms, and Higgs quartics. The `[nabla, Phi]` term should be treated
+   as superconnection curvature, not a leftover.
+
+   First declarations:
+
+   ```text
+   trace_superDiracSq_decomposition
+   trace_superDiracFourth_curvatureSq
+   trace_superDiracFourth_higgsKinetic
+   trace_superDiracFourth_higgsQuartic
+   spectralAction_gaugeInvariant
+   ```
+
+8. **Octonionic 3-cell associator track**
+
+   Ordinary curvature is two-step diamond disagreement. Octonionic
+   nonassociativity first appears in triple products, so any exceptional-sector
+   extension should attach associator data to oriented triples or 3-cells. Keep
+   this separate from the immediate super-Dirac proof path.
+
+   First declarations:
+
+   ```text
+   octonionicThreePathAssociator_def
+   octonionicThreePathAssociator_alternating
+   octonionicThreePathAssociator_vanishes_onAssociativeSector
+   ```
+
+9. **Spectral dimension diagnostic**
+
+   Use the positive envelope heat trace `Z(t) = Tr exp(-tH)` to define a finite
+   scale-dependent spectral dimension. This is a model-selection diagnostic for
+   graph families, not yet a theorem about the physical continuum.
+
+#### Priority order
+
+Keep the dual-soldered Q5 core first. After that, prioritize exact finite
+algebra in this order:
+
+```text
+null-pair mass-area
+spectral mass-shell matching
+SUSY-QM spectral pairing
+Schur-complement local dilation
+Weitzenbock gap/zero-mode inequalities
+spectral-action trace decomposition
+octonionic 3-cell associator
+spectral dimension diagnostics
+```
+
+This analysis is physically useful because it turns the operator work into a
+larger testable architecture: one-edge data gives universal propagation;
+two-edge data gives mass, area, spin coupling, and curvature; defects and
+spectral flow give protected matter; and triples may carry octonionic higher
+flux.
### ChatGPT Pro refinement incorporated (2026-06-26)

A ChatGPT Pro answer confirms the dual-soldered path and sharpens the next Lean
jobs.

#### Implementation-critical refinements

1. **Canonical tetrahedral convention**

   Formalize the observer-normalized unit tetrahedron first:

   ```text
   ell_A = (1, n_A),  n_A = s_A / sqrt(3)
   G_AA = 0, G_AB = 4/3 for A != B
   G^{-1}_AA = -1/2, G^{-1}_AB = 1/4 for A != B
   alpha^A = (1/4) dt + (3/4) n_A . d x
   alpha^A(ell_B) = delta^A_B
   ```

   The scaled directions `L_A = (sqrt(3), s_A)` are acceptable only with scaled
   dual covectors `beta^A = alpha^A / sqrt(3)`. Mixing the unit and scaled
   conventions silently rescales the Dirac symbol.

2. **Higgs grading/sign guardrail**

   In the theorem for `D = i D_N + Gamma_s Phi`, require:

   ```text
   Gamma_s^2 = 1
   {Gamma_s, C_a} = 0
   [Gamma_s, nabla_a] = 0
   [Gamma_s, Phi] = 0
   [C_a, Phi] = 0
   ```

   Then `+Phi^2` is correct. If `Phi` anticommutes with `Gamma_s`, the square
   gives `-Phi^2`. Therefore `Phi` can be odd only with respect to a separate
   internal grading `chi_E`, not the spacetime chirality `Gamma_s` used in the
   displayed product formula.

3. **Mass-shell sign convention**

   Decide and document whether `Box_null` is the kinetic mass-shell operator or
   the analytic d'Alembertian. In mostly-minus signature, the desired equation
   `P^2 = m^2` from `-Box_null + Phi^2 = 0` requires the plane-wave symbol of
   `Box_null` to be `P^2`.

4. **Frame term audit**

   The exact finite frame term

   ```text
   T_frame = sum_a,b C_a [nabla_a, C_b] nabla_b
   ```

   vanishes under `[nabla_a, C_b] = 0`. It is physical if it represents the
   discrete spin-connection/tetrad variation; it is contamination if frame
   variation is not transported covariantly.

#### New Aristotle wave direction

The next large Lean jobs should be constructive and proof-heavy:

```text
A. Tetrahedral `NullSolderFrame` and unit/scaled normalization audit.
B. Dual-soldered commutator and kinetic quadratic form.
C. Graded super-Dirac square with explicit `Gamma_s`, `chi_E`, and sign guards.
D. Finite Krein API plus retarded/advanced doubled operator.
E. Spectral mass-shell matching and Schur-complement local dilation.
F. Finite Markov-chain Poisson-equation SLLN and stopped-node proxy lemmas.
```

#### Literature leads for the super-Dirac wave (2026-06-26)

A Neo4j + arXiv/INSPIRE search pass curated concrete prior art for these jobs
(full mapping in `Sources/NullStrand_Open_Questions_For_Frontier_Models.md`
section 6.10; all items in Zotero collection `9W59V3K9` and the Neo4j paper
graph, semantically searchable via `Scripts/lit/neo4j_paper_search.py`):

- Jobs A-C (square structure, grading, g=2): Bianconi *Dirac gauge theory for
  topological spinors in 3+1 networks* (arXiv:2212.05621) -- the closest
  existing construction, with `{D,D}`/`[D,D]` giving metric/curvature and
  magnetic-field terms and the right gyromagnetic moment in the
  non-relativistic limit.
- Job D (Krein doubled / index): Post *First order approach and index theorems
  for discrete and metric graphs* (arXiv:0708.3707, supersymmetric doubled
  graph Dirac with decorated `C^d` vertex spaces and a graph index theorem);
  van den Dungen *Krein spectral triples and the fermionic action*
  (arXiv:1505.01939); Bizi thesis (arXiv:1812.00038).
- Finite-Clifford Lean API: Casiday-Contreras et al. *Laplace and Dirac
  Operators on Graphs* (arXiv:2203.02782, graph Clifford algebras + gluing
  identities).
- D^2 forced-term audit: Ackermann-Tolksdorf generalized Lichnerowicz formula
  (arXiv:hep-th/9503153, already curated).
- Continuum-limit caution (Job E / G5 scaling): Aslanbeigi-Saravani-Sorkin
  *Generalized causal-set d'Alembertians* (arXiv:1403.1622, already curated) --
  the 4D causet d'Alembertian is unstable; use as a falsification probe and a
  motivation for the retarded/advanced doubling. Pairs with Sorkin
  arXiv:1107.0698.
- Prediction gate (G5): Chamseddine-Connes-Marcolli (arXiv:hep-th/0610241) --
  the canonical spectral-action prediction precedent and its cautionary Higgs
  miss.

### Prediction-gate clarification incorporated (2026-06-26)

A prediction-focused discussion clarifies how to state G5 without undervaluing a
successful null-edge reconstruction of known physics.

#### Revised G5 split

```text
G5a -- reconstruction gate:
  one concrete dual-soldered null-edge/Krein super-Dirac architecture reproduces
  the known Dirac, gauge, Higgs/Yukawa, and Born-equivariant structures with
  exact finite algebra and controlled scaling.

G5b -- rigidity/prediction gate:
  the finite null/spectral axioms force a proper lower-dimensional image in
  continuum EFT parameter space, yielding at least one relation, exclusion, or
  correction not inserted by hand.
```

G5a is already scientifically worthwhile. G5b is the stronger new-dynamics gate.
This avoids making the project look unsuccessful merely because an exactly
Born-equivariant hidden-variable reconstruction reproduces ordinary quantum
statistics.

#### Prediction certificate

A claimed prediction must be a parameter-free or lower-parameter relation in the
continuum EFT image of the finite model, stable under field redefinitions and RG,
and not absorbable into the spectral function, cutoff, Yukawa block, internal
algebra choice, graph ensemble, holonomy normalization, or hidden-sector data.

Checklist:

```text
frozen input;
parameter deficit;
field-redefinition audit;
RG survival;
no hidden absorption;
falsifiable width.
```

This should be used before promoting any finite algebra theorem into a physics
prediction.

#### Prediction ledger for current claims

```text
kinematic representation:
  timelike motion as averaged null motion
  Pluecker mass identity

architecture/consistency:
  diagonal null-symbol obstruction
  dual-soldered Dirac symbol
  super-Dirac square
  Phi^2 as sole zero-order mass block
  P(xi)^2 = m^2 as mass-shell matching

normalization tests:
  g = 2 from Clifford square, unless independent Pauli terms are forbidden
  frame-term scaling and tetrad-postulate audit

potential rigidity/prediction tracks:
  absence of O(E/Lambda) Lorentz-violation terms
  fixed gauge-coupling or Higgs relations from a spectral action
  anomaly/index constraints on internal sectors
  forced gauge group or representation content
  forced dimension or generation count
```

#### Moduli-count gate

Before phenomenology, define the continuous finite knobs:

```text
edge weights, frame choices, holonomy normalizations, Phi, spectral function f,
cutoff Lambda, internal algebra moduli, hidden-sector couplings, graph ensemble.
```

Compare with target EFT parameters. If the finite moduli have enough local
freedom to fit all Standard Model parameters, the program is a reconstruction or
reparametrization, not a prediction. A rigidity theorem should show that the
rank of the finite-to-EFT parameter map is deficient.

#### Nielsen-Ninomiya and chirality pressure test

Put the lattice-chirality obstruction near the front of G5. The corrected
operator is local, first-order, graph-based, and wants chirality. The program
should state explicitly which Nielsen-Ninomiya assumption it evades:

```text
ordinary Hermiticity;
translation invariance;
strict locality after projection;
exact chiral symmetry;
single-layer visible Hilbert space.
```

Likely exits are Krein/non-Hilbert self-adjointness, retarded/advanced doubling,
domain-wall or overlap mechanisms, nonlocal effective visible operators, or
finite causal graphs without lattice translation symmetry.

#### Cheapest decisive tests

Prioritize these symbolic/finite tests before expensive phenomenology:

```text
1. flat-symbol / doubling test;
2. graded square sign audit;
3. Pauli coefficient normalization on one U(1) diamond;
4. minimal spectral-action trace on a periodic null-diamond complex;
5. frame-term scaling test;
6. anomaly cancellation of the proposed internal sector;
7. parameter-moduli audit;
8. Lorentz-dispersion expansion through O(h^2);
9. finite-N equivariance correction estimate;
10. domain-wall zero-mode pilot.
```

This reframing should guide future claims: a formalism that exactly reproduces
known physics is a valid G5a endpoint; new predictions require the additional
G5b rigidity certificate.

### Commuting-square and finite-core refinement (2026-06-26)

A further ChatGPT Pro analysis sharpens the roadmap around a publishable finite
core. The super-Dirac track should be decomposed into four commuting tests rather
than one omnibus theorem:

```text
finite operator -> finite square -> finite spectral facts
continuum symbol -> continuum Lichnerowicz limit -> physical EFT/prediction
```

Equivalently:

```text
D_h  --finite square-->  D_h^2
 |                         |
 h -> 0                    h -> 0
 v                         v
D_cont --Lichnerowicz--> D_cont^2
```

Use the following names and statuses:

```text
finiteSuperDiracSquare    -- near-term trusted finite algebra;
dualSolderedSymbolLimit   -- symbol/asymptotic target, with finite affine proxies;
squareLimitCompatibility  -- hard G5 continuum bridge.
```

#### Publishable finite-core theorem package

A focused finite-core paper should target exactly these eight theorem clusters:

1. **Simplex null-solder frame**

   Prove the general `d`-dimensional simplex construction, with the tetrahedral
   3+1 case as a corollary:

   ```text
   sum_A xi(ell_A) alpha^A = xi.
   ```

   This prevents the false claim that the tetrahedron itself derives four
   spacetime dimensions.

2. **Diagonal trace obstruction**

   ```text
   trace (sum_a b_a ell_a^flat tensor ell_a) = 0 != d.
   ```

   This is the negative theorem that retires diagonal null soldering.

3. **Dual-soldered symbol theorem**

   ```text
   D_h = sum_a c(alpha^a) (T_a - I)/h
   [D_h, M_f] -> c(df)
   ```

   Keep trusted Lean to exact finite or affine symbol proxies unless a true
   continuum API is available.

4. **Graded square theorem**

   Under explicit hypotheses

   ```text
   {Gamma_s, C_a} = 0,
   [Gamma_s, nabla_a] = 0,
   [Gamma_s, Phi] = 0,
   [C_a, Phi] = 0,
   Gamma_s^2 = 1,
   ```

   prove

   ```text
   D^2 = -Box - C_diamond - T_frame + Phi^2
         - i Gamma_s sum_a C_a [nabla_a, Phi].
   ```

5. **Frame/tetrad-postulate theorem**

   ```text
   [nabla_a, C_b] = 0 -> T_frame = 0.
   ```

   Add metric-compatibility audits using `nabla_a {C_b, C_c} = 0`.

6. **Retarded-symbol zero theorem**

   For

   ```text
   D_+(q) = sum_a C_a (exp(i q_a) - 1)/h,
   ```

   prove that the only Brillouin-torus zero is the continuum zero, assuming the
   `alpha^a` basis and Clifford injectivity. Compare with the symmetric sine
   derivative, which has the `2^d` naive zero pattern. This is the new high-value
   Nielsen-Ninomiya pressure test.

7. **Krein doubled self-adjointness theorem**

   If `D_- = D_+^sharp`, prove

   ```text
   D_dbl = [[0, D_-], [D_+, 0]]
   ```

   is `J_dbl`-self-adjoint. This states the explicit evasion route: ordinary
   Hilbert self-adjointness is replaced by a retarded/Krein doubled structure.

8. **Spectral mass-shell matching theorem**

   ```text
   ker(-K tensor I + I tensor M^2)
     = direct sum_lambda E_lambda(K) tensor E_lambda(M^2).
   ```

   This proves no-double-counting at finite spectral level without claiming mass
   prediction.

#### Reordered near-term pressure tests

Prioritize these before phenomenology:

```text
1. dual-soldered symbol theorem;
2. graded square sign audit;
3. retarded Brillouin zero / no-naive-doubling test;
4. Krein doubled audit;
5. frame/tetrad-postulate test;
6. Pauli coefficient test on one U(1) diamond;
7. Schur-complement locality test;
8. parameter-rank ledger.
```

The first five are finite and cheap relative to continuum physics.

#### Covariance and dimension guardrails

The simplex frame generalizes to any spacetime dimension `d`, so `d = 4` remains
input unless a separate spectral-dimension, anomaly, finite-algebra, or
Lorentzian/Krein theorem selects it. For Q6, the real pressure point is whether a
finite-valence primitive-null neighbor rule can be chosen covariantly without an
extra local timelike/reference datum. A massive strand can use `U` or `n`; a
universal field operator needs a dynamical tetrad, random covariant structure,
graph-derived local data, or an explicit covariance limitation.

#### Probability route refinement

For finite Markov-chain strong laws, prefer a regenerative-cycle route before
continuous-time martingales: decompose a finite irreducible discrete-time chain
into i.i.d. return cycles and apply the existing i.i.d. strong law to rewards and
cycle lengths. Continuous-time chains can be approached later through
uniformization. This is likely lower-cost in Lean than building a new
continuous-time martingale API.
### Nielsen-Ninomiya evasion and null-frame source (2026-06-26)

A further ChatGPT Pro analysis clarifies two governance choices for the finite
operator program.

#### Declared no-go evasion route

The program should explicitly state which Nielsen-Ninomiya-type assumption it
violates:

```text
ordinary single-layer Hilbert Hermiticity / anti-Hermiticity is violated by the
retarded block D_+.
```

Retardedness is the physical reason:

```text
D_+ = sum_a C_a (T_a - I)/h.
```

Non-Hermiticity is therefore a consequence of causal support, not an ad hoc
spectrum fix. The Lorentzian audit object is the Krein double:

```text
A^sharp = J_0 A^dagger J_0,
D_- = D_+^sharp,
D_dbl = [[0, D_-], [D_+, 0]],
D_dbl^sharp = D_dbl.
```

This is not yet a solved chiral-fermion theorem. Add the following tests to the
finite-core pressure suite:

```text
1. assumption ledger for Nielsen-Ninomiya hypotheses;
2. retarded determinant branch count det D_+(omega,k)=0;
3. doubled branch count for D_dbl^2 = diag(D_-D_+, D_+D_-);
4. anomaly/index test for any claimed chiral gauge sector.
```

The slogan to keep in review notes:

```text
no naive doublers is not the same as Standard Model chirality.
```

#### Decorated null-tetrad graph as finite object

The finite formalization target should be a decorated null-tetrad graph, not a
bare graph pretending to contain a canonical Lorentz frame. At each vertex it
has:

```text
ell_A(x), alpha^A(x), spin transport U_A(x), edge scale h_A(x),
with sum_A xi(ell_A(x)) alpha^A(x) = xi.
```

The retarded operator is:

```text
D_+ = sum_A c(alpha^A(x)) (U_A T_A - I)/h_A.
```

For continuum field interpretation, these decorations should be supplied by a
dynamical tetrad and spin connection:

```text
ell_A(x) = e_0(x) + n_A^i e_i(x),
alpha^A(x) = (1/4)e^0(x) + (3/4)n_A^i e^i(x).
```

A fixed observer direction may normalize the hidden strand's null fiber, but it
should not define the universal field operator unless a preferred foliation is
explicit physical structure. A random covariant structure is the better bare
causal-set route, but it likely conflicts with canonical finite valence.

#### Review implication

When integrating Aristotle patches, check that declarations and comments do not
say or imply:

```text
Krein doubling solves chirality;
observer direction supplies the universal field frame;
bare graph data canonically gives a finite null frame;
absence of naive doublers proves anomaly consistency.
```

The correct claim is narrower and stronger:

```text
retarded D_+ explicitly violates ordinary Hermiticity, and Krein doubling is the
finite Lorentzian audit object; decorated null-tetrad graphs are the trusted
finite objects, with dynamical tetrads supplying the continuum interpretation.
```
## Strategy memo incorporated: finite-core paper target and decisive branch-count test (2026-06-26)

The latest strategy memo upgrades the roadmap in one important way: the finite core should be packaged as a **dual-soldered null-edge Dirac algebra**, not as a complete physical theory. This gives us a strong publishable reconstruction target while keeping continuum scaling, chirality, and prediction claims honestly gated.

### Roadmap correction: no-doubling is determinant-level

Retarded differences prove only that the coefficient vector

```text
p(q) = h^{-1} sum_a (exp(i q_a) - 1) alpha^a
```

has no extra zeros when the `alpha^a` form a basis. That is not enough for a Lorentzian Dirac operator, because a nonzero null Clifford vector can still have a kernel. The real test is

```text
det(i D_+(q) + Gamma_s Phi) = 0,
```

or, in the massless flat case, `p(q)^2 = 0`. The tetrahedral Brillouin point `q = (pi, pi, pi, 0)` is already a warning example: `p(q) != 0` but `p(q)^2 = 0`. This should become the next decisive finite numerical/algebraic test. Retardedness alone should no longer be described as a no-doubling proof.

### Revised finite-core theorem package

The finite-core paper should aim for this package:

1. `NullSolderFrame`: simplex null directions `ell_A` and dual covectors `alpha^A`, with exact reconstruction `xi = sum_A xi(ell_A) alpha^A`.
2. `DiagonalTraceObstruction`: diagonal null soldering cannot have the continuum Dirac symbol because its induced trace is zero.
3. `DualSolderedCommutator`: exact affine commutator theorem and separate smooth `O(h)` symbol-limit theorem.
4. `GradedSquare`: for `D = i D_N + Gamma_s Phi`, with `Phi` commuting with spacetime chirality but odd under internal grading, prove the square with `+Phi^2`.
5. `FrameTermAudit`: decompose `D_N^2` into `Box_null + C_diamond + T_frame`, and prove the finite tetrad postulate kills `T_frame`.
6. `KreinDouble`: define `A^sharp = J A^dagger J`, `D_- = D_+^sharp`, and prove the retarded/advanced block operator is `J`-self-adjoint.
7. `BranchCountProtocol`: solve determinant-zero branches over the Brillouin domain, including real high-momentum branches and complex branches.
8. `SpectralMassShellMatching`: prove the finite diagonalizable self-adjoint kernel theorem for `-K tensor I + I tensor M^2`.
9. `PauliDiamondNormalization`: verify the coefficient of `1/4 [C_a, C_b] [nabla_a, nabla_b]` and isolate all holonomy/soldering normalization factors.
10. `ClaimBoundaryLedger`: classify each result as finite identity, asymptotic theorem, reconstruction, consistency check, or prediction.

### Decorated null-tetrad graph convention

For a universal field operator, the null frame should come from a dynamical tetrad or spin frame, not from observer data. In four dimensions,

```text
ell_A(x) = e_0(x) + n_A^i e_i(x),
alpha^A(x) = 1/4 e^0(x) + 3/4 n_A^i e^i(x).
```

The finite object should be called a decorated null-tetrad graph carrying

```text
V, E, ell_a(x), alpha^a(x), h_a(x), U_a(x), J_x,
Gamma_s, chi_E, Phi_x,
```

plus compatibility laws. We should not claim that a bare graph canonically supplies the tetrad/null-frame data unless that is separately derived.

### Updated scaling sequence

The scaling and physics tests should now be ordered:

1. Flat symbol test on a fixed decorated periodic graph.
2. Flat determinant/branch-count test for real and complex branches.
3. Curved tetrad test with smooth frame and spin connection.
4. Commuting-square test: finite square then limit equals continuum Dirac then Lichnerowicz square.
5. Stochastic or covariant graph ensemble test only after the decorated deterministic case works.

The finite square can be exact but still fail the continuum square limit if the frame term survives, holonomy normalization is wrong, Pauli normalization is wrong, high-frequency branches do not decouple, or the Lichnerowicz endomorphism is wrong.

### Claim boundaries and prediction gate

The current dual-soldered square is a reconstruction and finite identity, not yet new physics. A prediction requires a rank-deficient map

```text
F : M_finite -> M_EFT
```

or another independently forced restriction. The ledger should track graph decorations, soldering choices, holonomy normalizations, `Phi`, internal algebra, spectral function, cutoff, orientations, hidden-sector couplings, and allowed counterterms. If these parameters span the EFT freely, the construction is a reparametrization.

### New high-priority jobs

- `Branch-count audit`: compute/characterize determinant-zero branches for the tetrahedral retarded operator, including the `q = (pi, pi, pi, 0)` null singularity.
- `Frame compatibility theorem`: formalize the finite tetrad postulate and classify frame, curvature, torsion, and nonmetricity defects.
- `Krein spectral warning`: separate finite `J`-self-adjointness from stronger spectral properties such as real spectrum or stability.
- `Pauli normalization diamond`: prove the finite coefficient and identify exactly where holonomy normalization enters.
- `Regenerative Markov SLLN`: use return cycles for finite irreducible chains, then reduce CTMCs by uniformization.
- `Stopped-node theorem charter`: state only stopped/local elliptic results near Born nodes until a weighted-capacity theorem is proved.

Top failure modes are now explicit: determinant-level high-momentum massless branches or complex instabilities; conflating spacetime chirality with internal Higgs parity; uncontrolled frame contamination; arbitrary tetrad decoration; full-rank finite-to-EFT reparametrization; wrong spectral-action signs; and ad hoc anomaly repair.

## Null-edge mass blocker gates update - 2026-06-26

Provenance: integrated from ChatGPT Pro feedback on Aristotle's blocker list, attachment `14004817-5927-4a53-a6a7-b159e201e4df/pasted-text.txt`. Full detail is in `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 20.

For Lean and Aristotle scheduling, resolve the unified-mass blockers through gates rather than as one flat list:

```text
Gate A: convention freeze
Gate B: finite dual-soldered algebra
Gate C: flat branch and stability audit
Gate D: continuum square limit
Gate E: physics audits
Gate F: prediction gate
```

Immediate theorem/audit order:

1. Freeze `Gamma_s`, `chi_E`, `epsilon_form`, signs, and the super-Dirac square sign audit.
2. Prove finite dual-soldered algebra targets: affine commutator symbol, square decomposition, tetrad-postulate frame-term vanishing, and scalar/gauge null kinetic reconstruction.
3. Run determinant-level flat branch-count tests using `det D_+(q) = 0`, not only coefficient-vector zeros.
4. Add Krein self-adjointness and finite-box stability audits without claiming real spectrum or physical stability from `J`-self-adjointness alone.
5. Only then attempt continuum square-limit/Lichnerowicz compatibility.
6. Keep electroweak, anomaly, and prediction claims ledgered as reconstruction, structural theorem, or prediction.

Add blocker zero to all future mass-unification handoffs:

```text
Define canonical obstruction datum and enforce the claim ledger.
```

A mass claim must identify a natural obstruction map `B` and its status. `B_Pl` is canonical and proved; `B_Y` and `B_EW` are reconstruction/structural maps once SM inputs are supplied; `B_QCD` is not yet available.

Updated stop rule:

```text
If the finite operator package works but the finite-to-EFT map is full rank,
keep the result as null-edge reconstruction rather than prediction.
```

## Gate H addendum: Furey internal-spectrum and anomaly bridge - 2026-06-26

Provenance: integrated from ChatGPT Pro feedback on the Furey/anomaly work,
attachment `ed7c2aa4-281b-4576-9f2c-b0d502052127/pasted-text.txt`. Full
detail is in `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 22.

The Furey/formal anomaly work should be routed through a separate internal-sector
gate:

```text
Gate H: internal-spectrum and anomaly gate.
```

Division of labor:

```text
Furey/formal anomaly work:
  internal Standard Model spectrum, chiral charge table, anomaly cancellation,
  and legal Yukawa bookkeeping.

Null-edge work:
  null kinetic geometry, Pluecker mass, dual soldering, super-Dirac square,
  determinant branch count, Krein audit, and continuum scaling.
```

Gate H is useful because it can make the internal `Phi_H` sector
non-arbitrary. If a null-edge internal spectrum maps to the existing
`standardModelOneGeneration` anomaly table, the program can inherit local and
Witten anomaly freedom from the existing Standard Model anomaly package.

Near-term formal target:

```text
NullEdgeInternalSpectrum.toChiralMultipletList =
  standardModelOneGeneration
```

Then prove anomaly inheritance:

```text
LocalAnomalyFree NullEdgeInternalSpectrum.toChiralMultipletList
WittenSU2AnomalyFree NullEdgeInternalSpectrum.toChiralMultipletList
```

Stronger Furey bridge:

```text
FureyInternalSpectrum realizes NullEdgeInternalSpectrum.internalFiber.
```

The `Phi_H` bridge should build the zero-order Higgs/Yukawa block only from
legal flips:

```text
Phi_H = sum over legal Yukawa flips of y_f Phi_f
```

with each `Phi_f` gauge-neutral after the correct Higgs or conjugate-Higgs
insertion.

Keep the grading convention explicit:

```text
Phi_H is odd under internal grading chi_E.
Phi_H commutes with spacetime chirality Gamma_s.
```

Claim boundary:

```text
Furey supplies a candidate anomaly-safe internal fiber.
It does not solve null-edge kinetic/symbol/square/branch/Krein/continuum/QCD
blockers and does not derive numerical Yukawa values.
```

Roadmap placement:

1. P1: mention only as future internal-sector support, if at all.
2. P1.5: legal Yukawa blocks may reference anomaly-safe internal-spectrum work,
   but should not require Furey machinery.
3. P2: use Gate H as a candidate internal fiber for the super-Dirac `Phi_H`
   block.
4. Prediction gate: use Gate H only if it constrains representations,
   generation structure, Yukawa texture, rank, or forced zeros.

Add Gate H jobs to future Aristotle waves:

```text
H1: NullEdgeInternalSpectrum record.
H2: Furey-to-SM one-generation bridge.
H3: anomaly inheritance theorem.
H4: legal Yukawa flip classification.
H5: Phi_H from legal flips.
H6: singlet-completion audit.
H7: triality/generation audit.
H8: internal-sector prediction/codimension audit.
```

## Gate C literature correction - 2026-06-26

Provenance: integrated from Claude Semantic Scholar triage supplied
2026-06-26, with source-level arXiv spot checks. Detailed integration lives in
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 23.

The branch/no-doubling gate should now be phrased as:

```text
Gate C = determinant/propagator-zero classification,
not coefficient-vector zero testing.
```

The relevant comparison class is minimally doubled fermions:

```text
Misumi 2025, arXiv:2512.22609:
  nodal structures, single-Weyl targets, species-splitting masses, and
  Ginsparg-Wilson-type protection.

Golterman-Shamir 2025, arXiv:2505.20436:
  propagator zeros as kinematical singularities and generalized no-go pressure
  for chiral spectra.

Weber 2023, arXiv:2312.08526:
  spin-taste structure and Boricci-Creutz counterterm warnings.

Weber 2025, arXiv:2502.16500:
  Karsten-Wilczek spin-taste and determinant-derived counterterm constraints.

Capitani-Weber-Wittig 2009, arXiv:0910.2597:
  one-loop counterterms and operator mixing for Boricci-Creutz and
  Karsten-Wilczek fermions on the hyperdiamond.
```

The current Gate C classification table should include, for every determinant
zero:

```text
branch location;
whether p(q) = 0 or only p(q)^2 = 0;
pole versus propagator zero;
physical doubler versus kinematical zero;
ghost-like or complex-instability warning;
species/taste interpretation;
chirality and internal grading;
Krein signature and doubled multiplicity;
whether Phi_H lifts or preserves the branch;
whether a counterterm/projection/redesign is required.
```

Counterterm rule:

```text
Any counterterm needed to control Gate C branches must be added to the
finite-to-EFT moduli ledger before prediction language is used.
```

Related chirality/anomaly source lead:

```text
Butt-Catterall-Pradhan-Toga 2021, arXiv:2101.01026:
  Kähler-Dirac anomalies and symmetric mass generation; use as a form-degree
  anomaly/flavor-count comparison for null-edge cochains.

Li-Wang-You 2024, arXiv:2412.19691:
  C-R-T and internal anomaly constraints for symmetric mass generation.
```

Support references:

```text
Feinberg-Riser 2021, arXiv:2109.09221:
  pseudo-Hermitian spectra are real or complex-conjugate paired; useful for
  Krein caution, not a stability theorem.

Franco-Eckstein 2015, arXiv:1502.04683:
  two-sheet Lorentzian spectral-triple causality; useful for two-sheet
  intuition, not a branch-count solution.
```

Add near-term jobs:

```text
C13: minimally doubled comparison audit.
C14: propagator-zero classification table.
C15: counterterm/moduli audit.
C16: high-symmetry nodal-structure Lean theorem.
H10: Kähler-Dirac anomaly comparison.
F11: counterterm-rank impact audit.
```

Gate C remains unresolved until the determinant/propagator-zero table is
classified against this literature-backed protocol.

## Additional literature leads from Codex search - 2026-06-26

Provenance: Codex literature search on 2026-06-26. Direct Semantic Scholar use
was attempted but returned HTTP 429 in this session; these leads are based on
arXiv/source-page confirmation.

### Gate D: DEC and connection-Laplacian convergence

The most important new direction is to treat Gate D as an adaptation problem
against existing Hodge-Dirac and connection-Laplacian convergence theorems.

Primary Gate D leads:

```text
Dabetic-Hiptmair 2025/2026, arXiv:2507.19405:
  convergence of Discrete Exterior Calculus for the Hodge-Dirac operator.

Ramanan 2006, arXiv:math/0609464:
  discrete connection Laplacians.

Singer-Wu 2013, arXiv:1306.1587:
  spectral convergence of connection Laplacians from random samples.

Boguna-Krioukov 2025, arXiv:2506.18745:
  local causal-set d'Alembertian and causal-set continuum-limit warnings.
```

Roadmap consequence:

```text
Gate D should first ask whether the null-edge cochain operator can be expressed
as a DEC/Hodge-Dirac operator plus controlled null-edge perturbations.
```

If yes, the continuum proof can inherit known structure. If no, the project must
state precisely which null-edge feature lies outside DEC/FEEC convergence and
why that replacement is stable.

### Gate C: graph-native species and chirality diagnostics

Additional Gate C leads:

```text
Yumoto-Misumi 2021/2022, arXiv:2112.13501:
  lattice fermions as spectral graphs.

Basak-Chakrabarti-Kishore 2025, arXiv:2501.10336:
  eigenspectra of minimally doubled fermions and modified chirality diagnostics.

Catterall 2023/2024, arXiv:2311.02487:
  reduced Kahler-Dirac fermions and chiral/mirror issues.
```

Roadmap consequence:

```text
Gate C should classify both momentum-symbol zeros and finite graph spectral
matrix nullities, with ordinary chirality and modified/flavored chirality both
audited.
```

### Gate E/F: quiver spectral action and FMS discipline

New comparison target:

```text
van Suijlekom et al. 2024, arXiv:2401.03705:
  Bratteli networks and spectral action on quivers.
```

Use this to compare null-edge finite graph claims against an existing
quiver/spectral-action reconstruction of Yang-Mills-Higgs terms. The novelty
line should be:

```text
not "finite graphs can produce Yang-Mills-Higgs",
but "null-soldered causal graph data produce the specific kinetic square,
branch behavior, Lorentzian/Krein structure, and possible moduli restrictions."
```

FMS/electroweak leads:

```text
Maas 2023, arXiv:2305.01960;
lattice weak/Higgs follow-up, arXiv:2603.12882.
```

Use these to keep electroweak wording gauge-invariant and composite-observable
first.

### Gate H and super-Dirac square source leads

Internal-sector leads:

```text
Furey 2025, arXiv:2505.07923;
Cacic 2009, arXiv:0902.2068;
Bochniak-Sitarz 2018, arXiv:1804.09482.
```

Super-Dirac/Lichnerowicz leads:

```text
Ackermann-Tolksdorf 1995, arXiv:hep-th/9503153;
Tolksdorf 1996, arXiv:hep-th/9612149.
```

Use these for generalized Dirac-square theorem templates and finite
spectral-triple moduli comparison. They support the architecture but do not by
themselves prove null-edge specificity.
