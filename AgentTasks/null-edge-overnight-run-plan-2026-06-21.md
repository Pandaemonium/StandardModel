# Null-edge overnight Aristotle / literature / manuscript run plan

Date: 2026-06-21

## Objective

Run an overnight autonomous loop that advances the null-edge program without
turning the workspace into soup. The loop should interleave:

- Aristotle proof integration and new focused proof submissions;
- semantic literature and repo searches;
- strategy/scaffold jobs when definitions are not mature enough for proofs;
- light manuscript work on the publication plan, especially P1, P3, P7, and
  the P9 gate.

The overnight goal is not to maximize the number of jobs. It is to end the run
with a cleaner theorem spine, better source provenance, and one or two
manuscript skeletons that expose what is already publishable.

## Current queue state

These jobs are complete and should be handled before submitting new work:

| job | project | status | first action |
|---|---|---|---|
| spinor-network closure | `f1be6e52-31cc-411b-86b7-a841b1cfd318` | COMPLETE | download, inspect, integrate if statement unchanged |
| celestial scalar channel | `d2ffbd94-bb7c-4582-94b5-1bafdc2ab481` | COMPLETE_WITH_ERRORS | download, inspect carefully, verify target locally before integration |
| grand strategy v2 | `ba66d47f-68d3-4752-b6a0-ac1f10830f5d` | COMPLETE | download, harvest roadmap; do not import scaffold Lean |
| physics audit/comments | `51bf086e-37da-441c-9657-75f15f6036c7` | COMPLETE | download, review audit report and comment-only patches |

Already integrated before this plan:

- `PhysicsSM.Draft.NullEdgeQubitConcurrence`;
- `PhysicsSM.Draft.NullEdgePathPairInterchange`.

## Non-negotiable loop rules

1. Reconcile `aristotle list` and task notes at the start of every cycle.
2. Prefer semantic searches over keyword searches:
   - use the Neo4j doc index for repo context;
   - use the scoped paper embedding index for literature;
   - use keyword search only for exact declarations, file paths, and final
     patch locations.
3. Keep two to four active Aristotle jobs. Do not flood the queue.
4. Prefer focused standalone proof packages. Use full-repo packages only for
   strategy/audit jobs or when project imports are genuinely required.
5. Do not submit a proof job until the target theorem elaborates locally with
   a single intended proof body placeholder.
6. Do not integrate strategy scaffolds as Lean. Treat them as design notes unless
   they are converted into compiling files locally.
7. For every integrated proof:
   - inspect the extracted file;
   - scan executable Lean for proof holes and escape hatches;
   - run `lake env lean <file>`;
   - run `lake build <module>`;
   - update task note and ledger in the same pass.
8. Run manuscript edits only after the theorem/status ledger is current.

## Cycle structure

Repeat roughly once per hour overnight.

### Cycle A: reconcile and integrate

1. Run:

   ```text
   aristotle list --limit 20
   aristotle tasks <project-id> --limit 10
   ```

2. Download completed projects one at a time.
3. Integrate in this order:
   - spinor-network closure identity;
   - celestial scalar-channel identity;
   - audit comment-only patches, if they are truly comment-only;
   - strategy roadmap as an `AgentTasks` report only.
4. After each integration, update:
   - the task note;
   - `AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`;
   - the relevant publication/research plan status if the result changes a
     readiness label.

### Cycle B: semantic search and source triage

Run semantic searches before drafting new theorem statements.

Core P9 queries:

```text
diamond source visibility closure Plucker flux relative entropy ANEC cosmological constant
spinor-network closure moment map twisted geometry Plucker mass source visibility
causal diamond thermodynamics relative entropy modular Hamiltonian ANEC QNEC
everpresent Lambda causal set source visibility fluctuation sqrt volume
Petz recovery approximate Markov chain source visibility observer channel
Sorkin Johnston causal set entropy diamond relative entropy truncation
```

Publication queries:

```text
Plucker mass null spinor bundle Gr(2,n) Cauchy-Binet formalization
causal diamond holonomy finite gauge curvature path-pair interchange
Dirac slash bundle momentum Plucker mass finite square root
```

Actions:

- Add genuinely useful missing papers to Zotero/Neo4j.
- Prefer sources already in the null-edge collections.
- Record why each paper matters in the relevant plan section.
- Do not cite a source as supporting a theorem until conventions are checked.

### Cycle C: submit next Aristotle batch

Keep the active queue to two proof jobs plus one strategy/audit job.

Proof jobs to prepare first:

1. `NullEdgeSpinorNetworkClosure` integration follow-up.

   Goal: convert the standalone completed identity into the repo API, with the
   guardrail theorem:

   ```lean
   closed_visibleFan_mass_eq_restEnergy
   ```

   Claim boundary: visible closure is rest-frame, not source invisibility.

2. `NullEdgeDiamondSourceToy`.

   Goal: a finite toy source API:

   ```lean
   boundaryExact_source_eq_zero
   bfClosure_implies_no_bulkDivergence
   visibleBulkSource_additive_under_diamondGluing
   ```

   This should be a design/proof split if definitions are not yet stable.

3. `NullEdgeRelativeEntropyObserver`.

   Goal: finite data-processing scaffold for observer maps:

   ```lean
   relativeEntropyDataProcessing_for_finitePartition
   diamondObserver_monotonicity_handoff
   visibleObserver_concurrence_monotonicity_handoff
   sjDiamondReferenceState_def
   petzRecoverabilityGap_controls_sourceVisibility
   ```

   If exact quantum relative entropy is too heavy, ask for an API and proof
   dependency graph first. ANEC/QNEC and SJ area-law behavior are cited
   continuum targets, not proof obligations for this finite job.

4. `NullEdgeKleinQuadricSimplicity`.

   Goal: pairwise simplicity / Klein-quadric wrapper, not the full spin-foam
   sector:

   ```lean
   massless_iff_repeated_principal_spinor
   bivector_massDefect_eq_plucker
   ```

Strategy jobs to submit if proof definitions are immature:

- P9 source-visibility API design:
  "Define the smallest finite diamond source API that can distinguish visible
  momentum closure, BF/surface closure, and observer invisibility."
- Publication triage:
  "Given current theorem inventory, produce a P1/P3/P7 manuscript skeleton and
  exact theorem-to-section mapping."
- Semantic audit follow-up:
  "Audit `NullEdgeDecoherenceChannelAristotle` and the Gram-weighted cluster for
  density-matrix and partial-coherence convention drift."

### Cycle D: manuscript sketches

Spend short blocks on writing, not proof search.

1. P1 manuscript skeleton:
   - theorem statement;
   - convention table;
   - relation to massive spinor-helicity and `Gr(2,n)`;
   - Lean artifact section;
   - claim boundary.

2. P3 manuscript skeleton:
   - causal diamonds vs plaquettes;
   - Abelian invariance;
   - non-Abelian endpoint covariance;
   - path-pair composition and interchange;
   - higher-gauge outlook.

3. P7 synthesis note:
   - one data-processing spine;
   - visible/internal concurrence channel;
   - diamond/source ANEC channel;
   - what is finite theorem vs imported QFT.

4. P9 gate note:
   - visible closure is rest-frame, not invisible;
   - BF/boundary closure is the source-invisibility candidate;
   - finite API and falsification thresholds.

## P9-specific advancement path

P9 should advance through four gates.

### Gate 1: closure identity banked

The completed spinor-network closure proof gives:

```text
pairwise angular mass = ((sum_i w_i)^2 - |C|^2) / 4.
```

Integrate this, but state the lesson correctly: `C = 0` is rest-frame visible
closure, not no source.

### Gate 2: finite diamond source API

Define the finite objects:

```text
Diamond
Screen
VisibleFanOnScreen
BFBoundaryData
DiamondSourceFunctional
BoundaryExact
BulkSource
ObserverChannel
```

No cosmology theorem is allowed before this API exists.

### Gate 3: source-invisibility lemmas

The first theorem should be about what the source functional cannot see:

```lean
boundaryExact_source_eq_zero
bfClosure_implies_no_bulkDivergence
```

The complementary theorem should say visible Plucker mass is still seen:

```lean
visiblePluckerMass_sources_bulkTerm
closed_visibleFan_mass_eq_restEnergy
```

### Gate 4: positivity / relative entropy audit

The diamond source must pass an ANEC/QNEC-style positivity check:

```lean
relativeEntropyDataProcessing_for_diamondObserver
visiblePluckerFlux_satisfies_discreteANEC
diamondRelativeEntropy_secondDifference_nonnegative
relativeEntropyLoss_zero_iff_exactObserverRecovery
```

If this fails, or if hidden bookkeeping is not recoverable from the observer
algebra in examples advertised as invisible, demote P9 before making continuum
claims.

## Literature plan

Prioritize these clusters:

1. Spinor networks / twisted geometries:
   Dupuis-Speziale-Tambornino `1201.2120`.
2. Everpresent Lambda:
   Sorkin original; Das-Nasiri-Yazdi `2304.03819`, `2307.13743`.
3. ANEC/QNEC and relative entropy:
   Faulkner-Leigh-Parrikar-Wang `1605.08072`; Ceyhan-Faulkner `1812.04683`;
   Casini `0804.2182`; Fawzi-Renner `1410.0664`; Jacobson entanglement
   equilibrium `1505.04753`.
4. Sorkin-Johnston causal-set entropy:
   Saravani-Sorkin-Yazdi `1311.7146`; Sorkin-Yazdi `1611.10281`; track
   Pauli-Jordan truncation whenever area-law behavior is invoked.
5. Causal diamond thermodynamics:
   Jacobson `gr-qc/9504004`, non-equilibrium spacetime thermodynamics, causal
   diamond thermodynamics in (A)dS.
6. Causal-set gauge/source observables:
   Sverdlov gauge fields, Benincasa-Dowker curvature, Johnston propagators.

Every literature block should end with one of:

- a source added to Zotero/Neo4j with a note;
- a theorem target refined;
- a source explicitly rejected as not relevant.

## Stop / escalation conditions

Stop submitting new jobs and report if:

- a completed Aristotle result changed theorem statements;
- a proof works only by weakening the physics content;
- P9 definitions conflate visible closure with BF closure;
- the source functional sees boundary-exact/internal bookkeeping as a bulk
  volume term;
- the residual source has no plausible way around the everpresent-Lambda
  amplitude tension;
- more than four Aristotle jobs are active;
- local verification fails after integration.

## Desired morning state

By morning, aim for:

- spinor-network closure integrated or rejected with a precise blocker;
- scalar-channel proof integrated or rejected with a precise blocker;
- strategy v2 and audit outputs downloaded and summarized;
- one P9 source-visibility design job submitted or ready to submit;
- one relative-entropy observer-channel design job submitted or ready to submit;
- at least one semantic literature update recorded;
- P1 or P3 manuscript skeleton started.
