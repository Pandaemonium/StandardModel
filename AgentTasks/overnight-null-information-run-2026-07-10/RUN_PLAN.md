# Overnight finite null-information run (2026-07-10): RUN PLAN

Planner: Codex, 2026-07-09 evening.
Executors: **Claude (Opus) + Codex, co-equal**, coordinating only through the
append-only `LEDGER.md` in this directory. Aristotle is the primary proof and
proof-strategy fleet. The Lean kernel remains the source of truth.

This plan inherits the successful technique of the 2026-07-09 all-mass run:
harvest first, focused standalone Aristotle packages, exact nondegeneracy
fixtures, frequent literature passes, public Lean packages as clean-room
references, explicit kill conditions, independent semantic audits, and a hard
dawn switch from building to audit.

**Hard cutoff: at 07:00 America/Los_Angeles, both agents stop theorem expansion
and switch to audit, verification, manuscript honesty, benchmark review, and
morning reporting.** From 06:30 onward, submit no broad new proof job; only
small closers for work already substantially complete are allowed.

## 0. Mission

The run has two coupled goals.

### Non-negotiable ambition: propose a full theory

This is not a cleanup run and not an anthology of attractive finite lemmas. The
target is a **candidate complete theory of finite null information**: a single,
opinionated framework that says what reality is made of, how states and
observables are constructed, how time evolution and interactions work, how
massive particles and spacetime arise, how known physics is recovered, and what
new observations could refute the framework.

By dawn, the manuscript must read as one theory with a derivation spine, not as
bits and pieces connected by suggestive prose. The whole architecture must be
stated even where a bridge remains conditional. Every major layer must identify:

1. its primitive data or postulate;
2. what is derived from earlier layers;
3. its exact mathematical law and finite witness;
4. its relation to known physics and units;
5. its simulation or empirical test;
6. the exact open bridge and falsifier, if closure is incomplete.

Precision labels are not apologies and must not become rhetorical brakes. State
the proposed mechanism and strongest justified conclusion first; attach the
grade and boundary immediately afterward. Do not use `may`, `might`, `could`,
`suggests`, or `is consistent with` as a substitute for deciding what the
theory claims. When evidence is incomplete, replace vague hedging with the exact
missing theorem, input, scale limit, or experiment.

### Goal 1: make the manuscript formidable

Strengthen
`Sources/Null_Edge_Mass_Rank_Defect_Manuscript_2026-07-09.tex` into a bold,
opinionated, comprehensive **candidate full theory** whose headline statements
form one causal and mathematical derivation from primitive null information to
observable physics. Back that architecture with exact theorem anchors, explicit
assumptions, nondegenerate examples, simulations, and falsifiers. Keep
`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` as the full program
record and
`Sources/Null_Edge_General_Audience_Manuscript_2026-07-09.tex` as the public
companion. Do not spend overnight time on final PDF typography; content,
proof alignment, simulation evidence, and scientific positioning come first.

Boldness means taking a clear position and stating what would kill it. It does
not mean laundering a finite identity into a continuum or Standard Model
claim. Every headline must be one of:

- a source-verified theorem (`T`);
- a displayed conditional theorem (`T|H`);
- a kernel-verified finite result (`M`);
- a pre-registered conjecture (`C`) with a gate and kill condition;
- an explicit interpretation (`[interp]`) separated from the theorem.

### Goal 2: formalize the complete null-information program

Systematically develop the proof-ready finite content of:

- `Sources/A_broader_physics_of_finite_null_information.md`;
- `Sources/A_moduli_theory_of_self-decoding_null_information.md`;
- `Sources/Toward_a_complete_finite_null-information_theory.md`.

The three source essays are idea sources, not theorem inventories. Convert each
claim into one of four outputs: a theorem, a counterexample/no-go, a sharpened
missing assumption/API, or an explicitly deferred analytic/refinement program.

### Coupling between the goals

The manuscript and simulation engine must not be separate showcases. Every
simulation family points to a theorem or stated physical input; every manuscript
claim that has an executable finite avatar points to a reproducible benchmark.
The central product is an **evidence spine**:

```text
claim -> exact statement -> Lean anchor -> assumption footprint -> finite witness
      -> simulation invariant -> known-physics benchmark -> falsifier
```

The evidence spine must also compose vertically. Maintain
`THEORY_COMPLETION_MATRIX.md` as the whole-theory control surface and close its
highest-leverage arrows before accumulating more isolated results. A theorem is
high priority when it completes a derivation, fixes a physical dictionary,
enables a benchmark, or kills an entire route.

## 1. Standing state and startup P0

### 1a. Documents of record

Read in this order:

1. `AGENTS.md` and `docs/NULLSTRAND.md`.
2. This `RUN_PLAN.md`.
3. `Sources/Null_Edge_Mass_Rank_Defect_Manuscript_2026-07-09.tex`.
4. `Sources/Null_Edge_Future_Directions.md`, especially Pro rounds 7-9.
5. The three source essays named in Goal 2.
6. `docs/DOCUMENT_MAP.md` and the most recent tail of
   `AgentTasks/overnight-allmass-run-2026-07-09/LEDGER.md`.
7. Run-local `MANUSCRIPT_CLAIM_MATRIX.md` and `SIMULATION_BENCHMARKS.md`.

Update during the run:

- `LEDGER.md`: append-only coordination and scientific decisions;
- `LIT_SEARCH_LOG.md`: every literature/package pass;
- `FOLLOWUP_JOBS.md`: open proof tails and harvest metadata;
- `MANUSCRIPT_CLAIM_MATRIX.md`: every headline claim and its evidence chain;
- `THEORY_COMPLETION_MATRIX.md`: every layer of the proposed theory and its
  compositional closure status;
- `SIMULATION_BENCHMARKS.md`: every executable benchmark and validation tier;
- `HONEST_SCORECARD.md`: dawn claim audit;
- `MORNING_REPORT.md`: final handoff.

### 1b. Landed theorem base to build on

Do not re-prove these. Compose or audit them:

- **Mass and information:** `GateI1.Core`, `MassNullDecomposition`,
  `DetPUniqueness`, `PluckerMassCovariance`, `MassEntropyDictionary`,
  `TwoEdgeMassConcurrence`, `KraftCompressionMass`,
  `MassCoherencePathEquivalence`.
- **Positive Hodge/decoder:** `Carrier.KugoOjima`,
  `KreinPositiveSectorWitness`, `PositiveHodgeDecoder`,
  `GenericFiniteHodge`, `KreinHodgeNoGo`, `DecoderChainHomotopy`,
  `PositiveSectorClassification`.
- **Dynamics and causality:** `ExactCheckerboardPathSum`,
  `QuantitativeDiracWalkContinuum`, `ExactQuantumWalkDispersion`,
  `CayleyHamiltonianGenerator`, `CarrierDynamicsCapstone`,
  `LowerOrderChannelCausality`, `SubluminalBound`,
  `TetrahedralNullHistory`, `TetrahedralSpinProjectorPath`.
- **Four channels and geometry:** `CarrierKreinSquare`, `CarrierRigidity`,
  `FourChannelRigidityCapstone`, `FourChannelPathActionCapstone`,
  `HistoryLocalFourChannelAction`, `U1HistoryClosureHolonomy`,
  `SolderingLocalFrameCovariance`, `NondegenerateSolderingGeometry`,
  `ESlotGeometry`, `UnifiedActionVariation`.
- **Binding, many-body, and QCD-shaped structure:** `CarrierClosurePlane`,
  `BindingDefect`, `BindingInformationInvariant`,
  `BindingEntanglementDeficit`, `DerivedInteraction`, `FockMassGap`,
  `ConfinementPositivity`, `WindingLowModes`.
- **Gauge, Higgs, spin, flavor:** `GaugeMassGram`, `HiggsDofConservation`,
  `HiggsLongitudinalMode`, `FiniteKMCP`, `KMPhaseCounting`, `KMFlagship`,
  `FamilyRankNoGo`, `GenerationPermutationNoGo`, `BargmannCP`.
- **Self-consistency, recovery, and cosmology:** `SelfConsistentDecoder`,
  the P7 recovery/data-processing stack, `SpectralDistance`,
  `ComptonBoundSq`, `LambdaUnimodular`, `LambdaEdgeCount`, and the landed
  finite Lambda arithmetic modules.

This list is a navigation aid, not an assertion that every module carries the
same trust or physical grade. Read declarations and guards before citing them.

### 1c. Aristotle P0: harvest before submitting

First command for both agents:

```text
aristotle list --limit 40
```

Inspect task notes and download available output before launching replacements.
At plan creation, the high-priority frontier was:

- `17674ce6-b10a-474a-931f-d0237d539f0b`: finite Kraus no-signaling;
- `13b40077-16df-4e15-b662-37a84ac51edb`: two-region tensor microcausality;
- `af7eb850-5998-430e-9e11-4e2d15ae7685`: finite SSB degeneracy gate;
- `3ea09edf-0206-4b6c-94b5-d3e618ba8ec2`: one-loop dimensional transmutation;
- `3906ed40-adf5-4d47-a46b-bd979c70cfba`: four-hole many-step walk tail;
- `ccff7fc8-bba7-4260-a335-25597d622551`: null-factorization spin fiber;
- `2687b7bb-68d7-4511-9f4d-e7b27e30e31c`: Krein chain equivalence;
- `be5c5929-b9ca-4763-a103-4e9c79cab5db`: positive-Hodge Rayleigh/attainment;
- `63170980-2893-416c-b36b-a412de5f70a8`: vacuum-shift ensemble;
- `8066248d-d28b-4262-ab65-94a0696a893c`: spectral-monodromy dichotomy;
- `f001c5e8-58e6-41b6-8f62-87058d9249cb`: rapidity-information distance;
- `e4aad67f-5c4d-48d6-81fe-1793cdf42c7b`: geometry-register Lambda;
- `7895c97a-60e0-4a98-9f8f-efca607086a6`: chain spectral distance.

Status labels in this snapshot will stale. The CLI and downloaded source are
authoritative. Do not duplicate an idle/complete job just because it has not
yet been integrated.

### 1d. Dirty-worktree rule

This repository contains extensive same-day work. Never revert changes you did
not make. Claim a lane in the ledger before touching shared manuscripts or
`PhysicsSMDraft.lean`. Re-read a file immediately before editing it.

## 2. Flagship A: manuscript evidence spine

Claude is draft lead; Codex is audit lead. Both may write, but only after a
ledger claim.

### A0. Write a theory, not a results report

The manuscript must have an explicit whole-theory architecture:

1. **Foundational declaration:** primitive null events/edges, composition,
   gauge redundancy, positivity selection, and the finite action/evolution law.
2. **Derivation spine:** histories to quotient/cohomology to positive decoder to
   mass, particles, interactions, geometry, and macroscopic observables.
3. **Physics dictionary:** precise maps to relativistic kinematics, quantum
   states and measurements, gauge/Higgs/flavor structure, many-body physics,
   gravity, thermodynamics, cosmology, and continuum QFT.
4. **Executable realization:** one simulation API implementing the same objects
   and testing the same invariants used by the formal statements.
5. **Empirical confrontation:** reproduced benchmarks, disclosed imported
   inputs, parameter count, candidate novel predictions, and decisive failures.

No major domain may appear only as an isolated future-direction paragraph. If a
domain is not derived, state the exact bridge principle the proposed theory
needs, give its finite avatar, launch the strongest tractable composition job,
and explain what observation or no-go would reject it. The narrative must make
clear which small set of postulates generates the program and which principles
are still imported from known physics.

### A1. Freeze the headline thesis

Working central thesis:

> Mass is a positive-sector spectral rank defect of coherently composed null
> information; the finite carrier realizes this defect through constrained
> Hodge decoding, exact null-history dynamics, and four second-order obstruction
> types.

This is the theory's central claim. Support it by composing the separately
graded claims in `MANUSCRIPT_CLAIM_MATRIX.md`, rather than weakening it into a
mere metaphor:

1. mass as the canonical determinant/Pluecker disagreement;
2. entropy and concurrence dictionaries at stated normalization;
3. positive cohomology and a separate spectral decoder;
4. four obstruction types and concrete coefficient rigidity;
5. exact checkerboard dynamics, dispersion, and speed boundary;
6. first 3+1 tetrahedral kinematic/spin-path lift;
7. signed closure binding and positive-sector stability;
8. gauge/Higgs/flavor finite avatars and their explicit exceptions;
9. soldering geometry, variational response, and gravity boundary;
10. event-count/Lambda finite arithmetic and cosmology boundary;
11. local process theory and continuum QFT as open reconstruction layers.

### A2. Independent anchor sweep

For every theorem named in the manuscript:

- grep the actual declaration;
- inspect the exact statement and wrapped definitions;
- inspect `#print axioms` or the guard;
- verify the module builds under Lean 4.28.0;
- classify whether the prose says exactly that statement;
- record the result in the claim matrix.

Capstone conjunctions are navigation interfaces. Cite payload declarations in
the scientific prose whenever possible.

### A3. Bold interpretation with kill conditions

Each major section ends with:

- **What the theorem proves.** One exact paragraph.
- **What we think it means.** Opinionated interpretation, visibly labeled.
- **What would kill that reading.** A measurable, mathematical, or refinement
  failure.
- **Executable test.** Simulation benchmark ID when one exists.

Do not bury the Higgs scalar exception, continuum gap, Born-rule input,
absolute-scale gap, local-QFT gap, or initial-state gap in footnotes.

### A4. Complete architecture with an explicit proof frontier

Use the three Pro essays to add one compact architecture figure/table mapping:

```text
null histories -> gauge quotient -> Hilbert-Hodge representative
              -> chosen invariant positive sector -> spectral decoder
              -> channels/refinement/recovery -> geometry and observables
```

Mark each arrow `M`, `T|H`, `C`, imported, or open. Comprehensive means the
candidate theory specifies every major physics domain, all load-bearing
postulates, and every derivation needed for closure. It does not permit an open
arrow to masquerade as proved, but neither does an open arrow justify omitting
the theory around it. Turn each open arrow into a bounded theorem program with a
statement, witness, benchmark, and kill condition.

### A5. Scientific positioning

Strengthen related work and contrasts against:

- Feynman/Jacobson checkerboards and Dirac quantum walks;
- finite spectral triples and noncommutative geometry;
- BRST/Kugo-Ojima and positive cohomology;
- quantum information/resource theories and QEC;
- lattice gauge theory, Schur/Feshbach methods, and RG;
- AQFT/local nets and no-signaling channels;
- Jacobson/entanglement-equilibrium gravity;
- causal sets/event-count Lambda proposals;
- verified physics in Lean, especially PhysLean and current constructive-QFT
  formalization.

Verify primary sources before citation. No decorative bibliography.

## 3. Flagship B: executable null-information laboratory

Claude leads simulation architecture and physical benchmarks. Codex leads
proof-linked invariants, regression tests, and honesty audit.

### B1. Deliverable architecture

Build or extend a reusable simulation package under `Scripts/sim/` with a clear
entry point such as:

```text
Scripts/sim/null_information_lab.py
```

Prefer the repository's existing `carrier_dynamics_harness.py` and oracle
patterns. The laboratory should support declarative experiment configurations,
fixed random seeds, JSON/CSV outputs, and optional plots. Keep external numeric
code outside the trusted Lean layer.

Minimum components:

- spinor/null-bundle kinematics;
- density, entropy, concurrence, and compression diagnostics;
- exact 1+1 checkerboard/path-sum evolution;
- exact lattice dispersion and unitary/Cayley evolution;
- tetrahedral 3+1 kinematics and ordered projectors;
- carrier-square spectrum, positive-sector selection, and binding defects;
- Hodge quotient and descended spectral decoder;
- Schur/RG/seesaw and self-consistent decoder iterations;
- local channel/partial-trace/no-signaling tests;
- thermal/ensemble and event-count/Lambda exploratory models.

### B2. Validation ladder

Every numerical output receives exactly one tier:

- **V0 - arithmetic fixture:** exact rational/Gaussian-rational oracle.
- **V1 - theorem regression:** numerical evaluation of a landed Lean identity.
- **V2 - imported-physics reproduction:** reproduces a standard physics formula
  after its physical parameters and dictionary are supplied.
- **V3 - calibrated model:** parameters fitted to data; fit inputs and held-out
  tests are explicit.
- **V4 - prediction:** parameter-free or trained-before-unblinding output with a
  stated uncertainty and kill threshold.

Do not call V2 or V3 a prediction. A fit that can match arbitrary data is not a
success unless identifiability and held-out performance are tested.

### B3. Required benchmark families

Land at least five end-to-end benchmark families, prioritized as follows:

1. **Relativistic kinematics:** `E^2=p^2+m^2`, null decomposition, group speed,
   rest/massless endpoints, Lorentz-invariant determinant.
2. **Dirac/checkerboard dynamics:** exact path-sum kernel, recursion, lattice
   dispersion, norm/energy conservation, one-step and many-step error when the
   theorem lands.
3. **Information mass:** purity/linear entropy, concurrence, pinching/decoherence
   response, compression witnesses.
4. **Positive spectral decoding:** closed/exact/harmonic decomposition,
   positive/negative Krein controls, spectral gap, chain-homotopy invariance.
5. **Binding and effective theory:** closure-controlled gap shift, Schur
   complement, seesaw suppression, threshold comparison.

Stretch families:

6. tensor-factor microcausality and Kraus no-signaling;
7. gauge-mass Gram and Higgs degree-of-freedom transfer;
8. tetrahedral 3+1 ordered path amplitudes and D4 quotient structure;
9. self-consistent decoder fixed points and one-loop transmutation;
10. event-count/Lambda Fourier coherence and fluctuation scaling.

### B4. Units, calibration, and known physics

Create an explicit dictionary layer between dimensionless finite quantities and
physical units. For every benchmark state whether scale is:

- derived from the model;
- imported from a standard constant;
- fitted from one datum;
- arbitrary because only ratios are meaningful.

The laboratory may reproduce any known physics within the model's represented
regime by importing the accepted Hamiltonian/couplings. That demonstrates
machinery and consistency, not derivation. A stronger claim requires the
dictionary and parameters to be forced by the null-information structure.

### B5. Reproducibility and tests

Each benchmark records:

- theorem/source anchor;
- configuration and seed;
- units and conventions;
- expected invariant and tolerance;
- whether arithmetic is exact or floating point;
- software versions;
- generated artifact path;
- pass/fail and scientific interpretation.

Add automated tests for invariants and failure controls. Floating-point evidence
never promotes a Lean claim.

## 4. Flagship C: local operational process theory

This flagship formalizes the QM/QFT/process portions of the Pro essays.

### C1. Immediate harvest rungs

- finite Kraus no-signaling;
- two-region tensor microcausality;
- null-factorization spin fiber;
- many-step fixed-momentum continuum tail.

### C2. Next proof-ready rungs

After C1 lands, submit the smallest honest extensions:

1. a finite region poset with isotony and disjoint-region commutativity;
2. gluing/associativity for a finite null-history amplitude functor;
3. finite measurement instruments with normalized outcome probabilities and a
   no-disturbance marginal theorem;
4. explicit contextuality or global-valuation finite fixture, if the statement
   is nontrivial and not a toy dressed as Gleason;
5. open-channel resolvent/pole fixture only after a complex-resolvent API exists.

### C3. Boundaries

Do not claim a Haag-Kastler net, LSZ, S-matrix analyticity, OPE, a Born-rule
derivation, or continuum QFT from a two-factor matrix theorem. Each is a named
future API with prerequisites in `DOCUMENT_INTAKE_MAP.md`.

## 5. Flagship D: decoder moduli, recovery, and dynamics

This flagship formalizes the moduli/self-decoding essay.

### D1. Immediate harvest rungs

- Krein chain equivalence;
- positive-Hodge Rayleigh/attainment and its negative control;
- rapidity-information distance;
- spectral-monodromy Hermitian/complexified dichotomy;
- self-consistent decoder and geometry-register Lambda follow-ons;
- vacuum-shift ensemble.

### D2. Next proof-ready rungs

1. recovery-Compton bridge: a finite resolvent/Combes-Thomas bound before any
   slogan `recovery length = inverse gap`;
2. Hessian/mass bridge for the finite action at a nondegenerate stationary point;
3. channel-equivalence invariance for spectra restricted to physical
   cohomology, with a counterexample for full prephysical spectra;
4. fixed-point stability and bifurcation for self-consistent decoder feedback;
5. finite variational Ward identity connecting soldering response and universal
   source coupling.

### D3. Boundaries

The full moduli stack, geometry sum, vacuum selection, Born rule, and continuum
backreaction remain open. A scalar fixed-point witness is not quantum gravity.

## 6. Flagship E: Standard Model and scale interfaces

This flagship develops the broader-physics dictionary where finite theorem
shapes already exist.

### E1. Immediate harvest rungs

- one-loop dimensional transmutation;
- finite SSB degeneracy gate;
- gauge-mass Gram;
- null-factorization spin fiber;
- spectral-monodromy generation test.

### E2. Next proof-ready rungs

1. constructive finite WAY/Higgs reservoir with exact charge conservation;
2. local gauge automorphism group of a finite decoder, with explicit stabilizer
   and anomaly/descent controls;
3. finite resonance lifetime from a non-Hermitian effective Schur block;
4. finite detailed-balance/path-reversal fluctuation theorem;
5. three-generation forcing candidates only through the standing
   `FamilyRankNoGo` test.

### E3. Boundaries

No theorem may claim the Standard Model gauge group, measured Yukawas, the Higgs
self-mass, three generations, asymptotic freedom, confinement continuum, or an
absolute GeV scale unless those exact objects are present in the statement.

## 7. Run hygiene: binding rules

### 7a. The four over-claim modes

Review every landing and manuscript paragraph for:

1. **Vacuity:** hypotheses have no explicit model witness.
2. **Hollow telescoping:** a definition is restated as a grand theorem.
3. **Docstring outruns kernel:** prose claims a mechanism absent from the type.
4. **False shape:** the statement is proved but is not the intended mathematics.

### 7b. Mandatory nondegeneracy

Every existential or mechanism theorem ships with:

- a nonzero exact witness, preferably rational or Gaussian-rational;
- a degenerate control or kill fixture;
- a theorem that instantiates the general statement on the witness;
- a manuscript sentence naming the scope.

### 7c. Trusted/draft boundary

No new assumption, fake placeholder, or proof escape hatch enters trusted code.
Draft handoffs may contain documented `s o r r y`; they are not landings. Draft
finite computation may use `n a t i v e _ d e c i d e` only under the repository's
expanded-trust rules and never in a trusted promotion.

### 7d. Landing checklist

A proof is landed only when:

1. the intended statement survives semantic review;
2. the target builds under Lean 4.28.0;
3. the source is placeholder-clean;
4. the assumption footprint is pinned for a flagship;
5. an explicit witness/control is present when relevant;
6. `PhysicsSMDraft.lean` imports it when appropriate;
7. the ledger, claim matrix, manuscript, future directions, and provenance are
   updated in the same work unit.

## 8. Aristotle fleet discipline

### 8a. Fleet size and lanes

- Prefix every Codex job `codex-` and every Claude job `claude-`.
- Keep approximately 5-7 useful jobs per agent as a cap, not a quota.
- Harvest immediately when a slot frees; do not submit filler.
- Prefer focused Mathlib-only packages with exact copied seed definitions.
- Use full-repo packages only when the theorem genuinely needs the import graph.

### 8b. Strategy and audit jobs

- Each agent runs at least one **grand strategy** Aristotle job every 90 minutes.
  It receives the entire run mission, manuscript claims, simulation objective,
  theory-completion matrix, source-document map, current landings/no-gos, and
  asks for the shortest coherent route to a complete physical theory plus the
  highest-value killable theorem rungs.
- Smaller focused strategy jobs should run more frequently when statement shape
  or API design is unclear.
- After startup harvest, prioritize **composition jobs** that close an arrow in
  `THEORY_COMPLETION_MATRIX.md`: primitive-to-dynamics, dynamics-to-observable,
  finite-to-continuum, or theory-to-benchmark. An isolated lemma must identify
  which whole-theory arrow it enables.
- Keep at least **one audit job per agent** in flight whenever capacity permits;
  target 1-2 each. Audits inspect semantics, hidden assumptions, convention
  drift, vacuity, manuscript alignment, and simulation overinterpretation.

### 8c. Stall rule

At two hours, inspect a running job. Download any proof-complete subset, preserve
the snapshot, cancel/abandon the stalled remainder, and resubmit only the narrow
tail. Log the decision. Never let one monolithic build consume the night.

### 8d. Submission context

Before nontrivial jobs, generate a semantic context pack when memory permits.
If paper embeddings fail or Spark is unavailable/out of budget/unresponsive,
continue with direct literature search and repo/Lean-only context. Record the
fallback; literature work must not block proofs.

## 9. Literature and Lean-reference cadence

Each agent runs at least one literature/package pass every 30 minutes and logs
it. Spark subagents are preferred for parallel searches; direct searching is an
explicit fallback and requires no apology.

Standing topics:

- finite AQFT/local nets, tensor factorization, and no-signaling;
- checkerboard/quantum-walk continuum limits and lattice artifacts;
- BRST/Kugo-Ojima, finite Hodge theory, and Krein positivity;
- quantum channels, recovery, QEC, and resource monotones;
- SSB thermodynamic limits, Goldstone/Higgs mechanism, and WAY reservoirs;
- RG, asymptotic freedom, dimensional transmutation, and effective theories;
- resonance poles, Feshbach/Schur methods, and scattering;
- causal/spectral geometry, soldering, Jacobson, and entanglement equilibrium;
- causal sets, event count, unimodular/Lambda conjugacy, and volume statistics;
- verified physics and existing formalizations.

Public Lean packages to consult before local API invention:

- PhysLean (`lean-explore`, package `Physlib`): physics conventions and theorem
  shapes; reference/clean-room only because of version pinning.
- lean-quantum: density operators, channels, Kraus/Stinespring/Choi, partial
  trace, entropy, and data processing.
- SciLean: variational calculus, gradients, ODEs, optimization, simulation APIs.
- Kraft: source coding and compression bounds.
- testing-lower-bounds: KL/Renyi/f-divergence, TV, DPI, estimation risk.
- Plausible: finite counterexample workflow.
- CSLib: automata and path semantics.
- LeanCamCombi and Sphere-Packing-Lean: finite combinatorics and designs.

Record package, module/file, license, Lean-version gap, and convention mismatch
when theorem shapes are borrowed. Do not silently add dependencies overnight.

## 10. Division of labor

### Claude default lane

- manuscript draft lead, central theory declaration, and narrative architecture;
- simulation architecture, known-physics benchmark selection, and executable
  experiment workflow;
- local process/QFT lane (Flagship C);
- literature synthesis and external Fable/Opus reviews;
- harvest `claude-` jobs and cross-audit Codex landings.

### Codex default lane

- proof/composition lead, audit lead, and independent anchor sweep;
- proof-linked simulation invariants and test harness;
- decoder moduli/recovery/dynamics lane (Flagship D);
- Standard Model/scale finite interfaces where statements are algebraic;
- harvest `codex-` jobs and cross-audit Claude landings.

### Shared

- P0 harvest;
- claim matrix and simulation benchmark matrix;
- manuscript evidence spine;
- no-go publication and morning report;
- switch lanes when load inverts, but claim first in the ledger.

## 11. Phases and cadence

| Time (PDT) | Phase | Required output |
|---|---|---|
| 22:30-23:00 | P0 harvest and claim freeze | job inventory, downloaded outputs, lane claims, first grand-strategy jobs |
| 23:00-01:30 | Proof and simulation foundations | integrate strongest harvests; simulation package skeleton; exact V0/V1 tests |
| 01:30-04:30 | Flagship build | local-process/moduli/scale rungs; five benchmark families advancing |
| 04:30-06:30 | Composition | manuscript evidence spine, related work, benchmark results, focused closers |
| 06:30-07:00 | Landing freeze | no broad new jobs; harvest, build, guard, provenance, claim matrix |
| 07:00-08:30 | HARD AUDIT | semantic/assumption/anchor/simulation audits, honest scorecard, morning report |

At least every 30 minutes: literature/package pass. At least every 90 minutes:
one grand-strategy job per agent. Each cycle: harvest, integrate, verify, refill,
update evidence matrices.

## 12. Dawn audit

At 07:00, both agents become auditors.

### 12a. Lean audit

- targeted builds for every landed module;
- placeholder and expanded-trust scan;
- guard and assumption-footprint check;
- `PhysicsSMDraft` import-edge check;
- convention and definition audit;
- explicit model/nonvacuity check.

### 12b. Manuscript audit

- grep every cited declaration independently;
- verify theorem text against prose;
- inspect all `T`, `T|H`, `M`, `C`, and interpretation labels;
- verify the manuscript states one identifiable theory rather than a collection
  of analogies, correspondences, and local results;
- verify every layer in `THEORY_COMPLETION_MATRIX.md` appears in the derivation
  spine or is named as an exact open bridge;
- verify every bold slogan has a precise evidence grade and falsifier;
- remove defensive hedging that merely conceals an undecided claim;
- check references and provenance;
- record open gaps and kills in the scorecard.

### 12c. Simulation audit

- rerun benchmark suite from a clean command;
- verify fixed seeds and machine-readable outputs;
- distinguish exact arithmetic from floating point;
- inspect tolerance sensitivity and failure controls;
- verify all fitted parameters and held-out tests are disclosed;
- ensure no V2/V3 benchmark is described as a prediction;
- compare numerical results to theorem fixtures independently.

No final PDF visual polish is required unless content changes make the document
unreadable or uncompilable.

## 13. Success criteria

In priority order:

1. **Whole-theory synthesis:** the focused paper presents one explicit candidate
   theory from primitive ontology through dynamics, observables, matter,
   interactions, spacetime, continuum recovery, and empirical confrontation.
   The reader can identify the minimal postulates and trace every major output
   through a single derivation spine.
2. **Decisive scientific voice:** the manuscript states what the theory says,
   why it is a better organizing principle, what it explains, and what would
   defeat it. Evidence grades sharpen those claims instead of dissolving them
   into vague possibility language.
3. **Honesty:** zero headline claims outrun their statements or simulations, and
   every incomplete bridge is exact enough to become a proof or experiment.
4. **Manuscript machinery:** the focused paper has a complete theory matrix,
   evidence matrix, theorem-backed architecture, explicit falsifiers, and
   simulation references.
5. **Simulation:** a reproducible laboratory runs at least five benchmark
   families, with at least three V1 theorem regressions and two V2
   standard-physics reproductions.
6. **Formalization:** at least three substantial source-document rungs reach a
   landed theorem/no-go, or return a precise missing API with a typechecking
   handoff.
7. **Composition:** at least one new result closes a cross-layer arrow rather
   than merely extending a layer in isolation.
8. **Harvest:** all available high-value Aristotle outputs are reviewed and no
   proof-complete result is left idle without explanation.
9. **Audit:** scorecard and morning report state what landed, died, remains
   conditional, and was only simulated.

Stretch success:

- many-step walk convergence lands and enters the benchmark suite;
- a finite local net extends beyond two tensor factors;
- an exact recovery-gap or resonance-lifetime theorem lands;
- dimensional transmutation or SSB gate lands with a simulation;
- one manuscript conjecture is upgraded to `M` without weakening its intended
  statement;
- an end-to-end chain from null-history primitives to a known-physics observable
  is theorem-linked and executed through the common simulation API;
- the theory yields at least one pre-registered V4 candidate whose inputs and
  failure threshold are fixed before comparison with data.

## 14. Definition of done

Every active rung must end the night in one of four states:

1. **Landed:** proof, guard, build, witness, docs, benchmark where applicable.
2. **Killed:** exact counterexample/no-go, documented as loudly as a win.
3. **Sharpened:** precise missing assumption/API and a typechecking handoff.
4. **Deferred:** explicitly analytic/refinement-scale, with prerequisites and no
   misleading finite substitute.

Churn is not a fifth state.
