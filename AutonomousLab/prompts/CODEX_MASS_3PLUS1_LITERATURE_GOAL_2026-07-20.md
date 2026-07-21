# Codex goal: origin of mass, strict 3+1 dynamics, and literature closure

Date: 2026-07-20
Accountable lead: Codex
Co-executor and independent reviewer: interactive Claude Code / Opus
Proof specialist: Aristotle
Operating context: Autonomous Fundamental Physics Lab (AFPL)

## Mission

Advance the Null-Edge program on its two most consequential physical gates:

1. turn the current collection of finite mass mechanisms into the strongest
   honest and systematically classified origin-of-mass account;
2. complete, sharply narrow, or decisively refute a local unitary `3+1`
   microscopic dynamics with the correct relativistic infrared sector;
3. make primary-source literature and external Lean-library search a continuous
   input to theorem selection, not a retrospective citation exercise.

The desired outcome is not a larger collection of suggestive finite examples.
It is a theorem-backed architecture with explicit scope, reconstruction maps,
continuum obligations, counterexamples, and kill conditions. Every work unit
must return a theorem, a counterexample/no-go, a classified obstruction, a
source-validated theorem statement, or a precisely sharpened missing axiom.

## Scientific thesis to test

The program's candidate thesis is:

> Physical mass is not one universal Pluecker formula. The principal mass
> mechanisms may instead be classified as distinct obstructions to gapless
> null transport, generated within one finite causal/action architecture and
> connected to physical rest mass through explicit spectral and continuum
> reconstruction maps.

The corresponding `3+1` thesis is:

> A finite-depth local unitary may recover one physical Weyl or Dirac sector in
> `3+1` when ordered micromotion, quasienergy topology, internal registers, and
> controlled substep stay sectors are treated as physical resources rather
> than forbidden artifacts.

Both theses are conjectural at the physical level. The job is to determine
exactly how much can be proved, which assumptions are necessary, and where the
program fails.

## Non-negotiable claim boundary

Do not claim that all observed masses have been derived. Do not claim absolute
mass scales, flavor ratios, the Standard Model Yukawa matrices, `Lambda_QCD`,
the continuum Yang-Mills mass gap, the physical Higgs pole, or the observed
neutrino branch unless a new result actually supplies them.

The target claim, once its gates are met, is:

> Within a declared Standard Model plus neutrino and bound-state scope, the
> principal mass mechanisms are reconstructed as classified obstructions to
> gapless null transport from common causal/action data. Absolute scales,
> flavor ratios, and the continuum Yang-Mills gap remain open.

Until the classification, shared-data, QCD, and gap-to-pole gates below are
closed, use the weaker wording:

> We have a common finite architecture and kernel-checked representatives for
> several principal ways a mass gap can arise; complete realization as the
> physical Standard Model mass budget remains conditional.

## Track A: origin-of-mass closure

### A0. Scope and exhaustive classification

State the universe of mechanisms before proving exhaustiveness. The preferred
initial scope is:

- renormalizable Standard Model fermion and gauge-boson masses;
- Higgs radial excitation;
- the leading neutrino extensions: right-handed Dirac, Majorana/Weinberg, and
  seesaw effective mass;
- composite and binding mass represented by finite gauge/transfer dynamics;
- inertial and gravitational response as a separate equivalence gate.

Construct a mechanism matrix that records, for each row: primitive data,
symmetry, operator/action block, positivity notion, gap observable, continuum
bridge, physical input, prediction, formal anchor, literature anchor, and kill
condition. Prove exhaustiveness only relative to a displayed action/operator
class. Prove non-overlap or an explicit overlap law so that Higgs, Yukawa,
binding, and Pluecker language do not double-count one contribution.

### A1. One Higgs datum, three mass sectors

Formalize a shared-data theorem in which one supplied vacuum datum `H0` and one
supplied potential generate, in the same convention-locked model:

- fermion maps `M_f = Y_f H0`;
- gauge-orbit stiffness `X |-> X H0`, including the unbroken photon stabilizer
  and positive broken directions;
- the radial Hessian governing the scalar excitation;
- the Goldstone/radial decomposition and degree-of-freedom accounting.

This is a reconstruction theorem, not a derivation of `H0`, `Y_f`, gauge
couplings, or the Higgs potential. Make the shared input and every free
parameter visible in the statement.

### A2. Pluecker-to-Yukawa legality and selection

Classify the gauge-equivariant, grading-compatible maps from right- to
left-chiral sectors. Prove which blocks are forbidden and whether the surviving
turn map is uniquely represented by the Pluecker rest operator under stated
symmetries. Include explicit nonzero witnesses and forbidden-channel controls.

Success is either a uniqueness theorem, a moduli/classification theorem, or a
counterexample showing that additional physical input is unavoidable. A freely
supplied arbitrary matrix relabeled as derived does not count.

### A3. QCD and composite mass bridge

Replace the current finite toy controls with the smallest honest nonabelian
`SU(3)` finite bridge that can support:

- gauge-invariant Wilson/closure observables;
- a positive transfer operator or reflection-positive finite analogue;
- a precise relation among correlation decay, a transfer spectral gap, and a
  finite composite mass observable;
- at least one nontrivial glueball- or hadron-like finite sector;
- a control separating constituent rest inputs from binding/field energy.

The continuum Yang-Mills mass gap and real-world confinement may remain open.
The finite result must state exactly what survives and what additional limit is
owed. Consult PhysLean, lattice-gauge formalizations, and primary lattice-QCD
sources before fixing the API.

### A4. Gap-to-pole reconstruction

Prove the missing semantics between an internal finite spectral gap and a
physical mass claim. The ladder should make explicit:

1. the self-adjoint or unitary evolution and positive physical sector;
2. a resolvent or two-point response with the appropriate spectral feature;
3. the dispersion relation near the selected sector;
4. a changing-lattice limit with stated regularity and normalization;
5. the condition under which the limiting pole/rest energy is called mass.

If a literal pole theorem is analytically premature, land the strongest exact
finite spectral-measure theorem and name the one missing analytic lemma.

### A5. Neutrino and scale stress tests

Give one operator classification covering:

- why the minimal supplied Standard Model field content has no neutrino mass
  map of the requested form;
- what an added right-handed singlet permits;
- the Majorana/Weinberg branch and its symmetry cost;
- the finite seesaw Schur complement and controlled approximation.

Separately connect the already proved abstract transmutation mechanism to an
actual beta function only when its coefficients and domain are source-audited.
Do not infer observed scales from an arbitrary recurrence.

### A6. Inertial/gravitational consistency

Test whether the same action that produces or reconstructs a gap also produces
the corresponding inertial response and a channel-blind gravitational source.
Keep equivalence-principle identities, finite coframe variation, continuum GR,
and phenomenology as separate grades.

## Track B: `3+1` closure

### B0. Work from the strongest live architecture

Treat the HNU/Floquet construction as the principal candidate and the simple
separable cubic and tetrahedral constructions as controls. Begin from the live
anchors in:

- `PhysicsSM/Draft/NullEdge/HNUExactCore.lean`;
- `PhysicsSM/Draft/NullEdge/HNURealSpaceBridge.lean`;
- `PhysicsSM/Draft/NullEdge/HNUStayCoverage.lean`;
- `PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean`;
- `PhysicsSM/Draft/NullEdge/HNUManyStepContinuumLive.lean`;
- `AutonomousLab/work/NE-3PLUS1/`.

Do not restart from the already refuted zero-stay, range-one, four-channel
ansatz.

### B1. Define what stay means

Relax the demand that every coarse substep translate every component. Permit a
conditioned shift that moves one sector while its complement stays, provided
the full schedule is local and unitary and satisfies a quantitative movement
or no-global-stasis theorem.

Classify three meanings separately:

- true microscopic identity/stasis;
- internal evolution at fixed coarse position;
- coarse stay produced by nontrivial motion on a cover or enlarged cell.

Determine whether the HNU stay sector is fundamental, eliminable by a finite
null-edge dilation, or necessarily accompanied by extra physical sectors. A
cover construction counts only with an invariant encoding, full-spectrum
census, and an honest account of the complement.

### B2. Complete the global spectral and topological ledger

Prove or refute, across the full Brillouin zone:

- every zero- and pi-quasienergy crossing;
- the chirality/charge of each crossing;
- absence or classification of off-corner residual modes;
- the global Floquet/micromotion invariant that balances the endpoint charge;
- stability under the intended massive Pluecker perturbation.

Corner samples and endpoint-only effective Hamiltonians are insufficient.
Every existential result needs a nondegenerate exact witness; every claimed
absence needs a complete classification argument or a stated compactness
reduction.

### B3. Position-space continuum theorem

Compose the live fixed-momentum result with explicit sampling and interpolation,
Fourier normalization, a compact-momentum estimate, and an ultraviolet-tail
bound on a displayed Sobolev or Schwartz domain. The target is convergence of
the changing-lattice evolution to the Weyl/Dirac flow for finite physical time,
not merely agreement of a Taylor coefficient.

Track `QCA-3PLUS1-001` and `CONT-FOURIER-001` together. A `3+1` walk without
this theorem is a regulator candidate, not recovered relativistic physics.

### B4. Massive and many-particle completion

Show that the Pluecker turn gives the intended massive Dirac tangent while
preserving exact locality, unitarity, the global quasienergy gap, and the
physical-sector encoding. Then test whether second quantization preserves
locality and whether the residual/topological sectors destabilize the vacuum
or interactions.

### B5. Hard kill conditions

Stop promoting the HNU route if any of the following survives exact audit:

- an unaccounted low-energy mirror or residual mode;
- no valid full-zone topological balance;
- no stable physical sector under the intended perturbations;
- no changing-lattice continuum convergence;
- a required projection that is nonlocal or not dynamically invariant;
- an all-moving dilation whose complement reintroduces the excluded physics.

A scoped no-go theorem that identifies the minimum extra register, range,
micromotion, or stay resource is a successful outcome.

## Track C: literature and external formalization

Literature work is continuous research, not background overhead.

### Cadence

- Before introducing a new physics object or theorem API, search the project,
  Mathlib, and PhysLean via `lean-explore` (`packages=["Physlib"]`).
- At least once every 60 minutes of active scientific work, run one focused
  primary-source literature pass. Alternate among origin-of-mass mechanisms,
  `3+1` QCA/Floquet/no-go results, and analytic reconstruction bridges.
- Run an immediate search whenever a theorem statement depends on a convention,
  claimed novelty, published no-go, or physical interpretation.
- Every three hours, synthesize what the newest sources change about the proof
  queue. Searches that do not alter a theorem, control, priority, or kill
  condition are not complete work products.

### Search pipeline

1. Search Zotero and Neo4j exact metadata first to avoid duplicates.
2. Use `neo4j_paper_search.py --query` for abstract-level triage.
3. Use `neo4j_paper_search.py --chunks` before relying on a paper's internal
   theorem, derivation, assumptions, or convention.
4. Search online scholarly sources for missing or current primary literature.
5. Read the primary paper; do not treat reviews or abstracts as theorem proof.
6. Add high-value, deduplicated sources to Zotero with normalized DOI/arXiv ID.
7. Refresh Neo4j paper/doc indexes after meaningful ingestion or project edits.
8. Record query, ranked hits, exact pages/sections, convention mismatch,
   theorem consequence, and resulting queue action in a dated literature memo.

At mission start on 2026-07-20, both Zotero and Neo4j were reachable by live
read queries. Record outages honestly and continue with the remaining search
paths rather than silently skipping the cadence.

### Standing source questions

- Is there an accepted classification of mass terms by representation,
  symmetry breaking, spectral response, or operator algebra that can define A0?
- Which rigorous lattice-QCD and transfer-matrix results provide the minimum
  honest finite composite-mass bridge?
- What is the cleanest spectral-measure or Euclidean-correlation theorem that
  connects a finite gap to a physical pole mass?
- Which QCA/Floquet classifications include stay sectors, full-zone charge,
  anomalous micromotion, interactions, or convergence estimates?
- Can quotient/cover quantum walks realize effective stay without hidden mirror
  sectors, and what invariant-subspace hypotheses are required?
- Which Mathlib, PhysLean, SciLean, lean-quantum, or other public Lean APIs can
  be clean-room adapted instead of locally reinvented?

## Division of labor

### Codex

- Own lab state, exact theorem statements, Lean integration, builds, axiom
  guards, simulations, source-to-code provenance, and manuscript anchor audits.
- Maintain the dependency graph between mass closure, `3+1`, and continuum work.
- Package narrow Aristotle jobs and harvest them before submitting duplicates.
- Keep all claims within the declared evidence grade.

### Opus through interactive Claude Code

- Lead broad physical synthesis, primary-source interpretation, alternative
  architectures, theorem-design criticism, and manuscript consequence maps.
- Independently audit Codex landings for vacuity, hidden inputs, false shape,
  convention drift, and physics overclaim.
- Propose the cheapest decisive theorem or counterexample when a route stalls.
- Use the AFPL mailbox and leases; do not overwrite a live Codex path.

Suggested Opus startup instruction:

> Read `AutonomousLab/prompts/CLAUDE_LAB_GOAL.md` and
> `AutonomousLab/prompts/CODEX_MASS_3PLUS1_LITERATURE_GOAL_2026-07-20.md`.
> Join as co-executor, prioritize source-grounded synthesis and independent
> review, inspect the mailbox and leases, and claim a nonduplicative lane.

### Aristotle

- Prove isolated hard lemmas, search for counterexamples, classify finite
  cases, and run adversarial strategy/audit jobs.
- Receive a semantic context pack, exact definitions, intended reading,
  nondegenerate witnesses, and explicit success/failure criteria.
- Never promote its own output. Codex integrates and audits semantics; Opus
  supplies independent cross-family review for headline landings.

## Operating loop

At startup:

1. follow `AutonomousLab/prompts/CODEX_LAB_GOAL.md`;
2. validate AFPL state and inspect mode, status, queue, jobs, leases, mail, and
   overdue roles;
3. inspect the newest mass, `3+1`, continuum, and literature artifacts;
4. harvest completed Aristotle work before submitting new jobs;
5. claim or create the smallest dependency-ready work item through lab state.

During execution:

1. select one exact gate from A or B;
2. complete the literature and Lean-API search needed to state it correctly;
3. preregister witnesses, controls, conventions, and kill conditions;
4. formalize the smallest meaningful theorem or counterexample;
5. run targeted Lean checks and the relevant axiom guard;
6. request cross-family review before headline promotion;
7. update the mechanism matrix, claim registry, literature memo, work item,
   ledger, and handoff;
8. choose the next dependency-ready gate based on information gain.

Honor the AFPL periodic roles. Use Visionary activations to challenge the whole
architecture, Archivist activations to maintain the source graph, Impact
Strategist activations to identify the result that would matter externally,
and Skeptic/Reproducer gates to prevent self-certification.

## Priority order

Unless a new theorem or source changes the dependency graph:

1. finish the HNU full-zone zero/pi and topology ledger;
2. close the changing-lattice position-space continuum theorem;
3. write the scoped origin-of-mass mechanism matrix and exhaustiveness target;
4. prove the shared-Higgs-data theorem;
5. prove or refute the Pluecker-to-Yukawa classification;
6. build the finite `SU(3)` transfer/correlation mass bridge;
7. prove the finite gap-to-pole reconstruction ladder;
8. complete neutrino, scale, many-particle, and gravity consistency gates.

This order is flexible only when a cheaper decisive counterexample, returned
Aristotle proof, or source-discovered theorem changes expected information gain.

## Required durable outputs

- a dated origin-of-mass mechanism and claim matrix;
- a living `3+1` theorem/no-go ledger with full-zone and continuum gates;
- dated literature memos with Zotero keys, Neo4j/index status, and proof impact;
- small guarded Lean modules or documented draft handoffs for each exact gate;
- independent review records for every promoted headline;
- manuscript edits only after the relevant formal and source anchors are green;
- a final handoff naming exact files, commands, Aristotle jobs, claim grades,
  unresolved assumptions, and the next cheapest decisive actions.

## Definition of success

The mission succeeds when it produces one of the following, with honest scope:

1. a classified, shared-data, finite-to-spectral origin-of-mass architecture
   covering the declared mechanisms, with QCD and continuum debts explicit;
2. a local unitary `3+1` regulator whose full-zone spectrum, topology, massive
   extension, and changing-lattice continuum limit are all proved;
3. a decisive no-go/classification theorem showing which assumption or resource
   must change;
4. a sharply reduced set of open lemmas whose hypotheses and physical meaning
   are source-validated and ready for expert collaboration.

Volume is not success. A smaller theorem that closes a semantic bridge or kills
a favored but false architecture outranks many disconnected identities.
