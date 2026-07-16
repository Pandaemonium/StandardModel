# Evidence, readiness, and claim promotion

## 1. Claim grades

AFPL inherits the repository claim calculus and makes it operational:

- `T`: source-verified external theorem or established empirical result;
- `T|H`: external result conditional on displayed hypotheses not yet derived;
- `M`: machine-verified program-internal theorem;
- `M+E`: machine-verified with disclosed evaluator trust;
- `S`: deterministic simulation or exact external computation;
- `C`: preregistered conjecture with gate and kill condition;
- `I`: interpretation or ontology;
- `X`: killed, contradicted, or withdrawn claim retained for provenance.

Originality tags remain `[orig]`, `[comp]`, `[import]`, and `[interp]`.

Mapping to run-report vocabulary: "oracle-exact" (exact rational/integer
computation by an external tool) is grade `S`; a floating-point "run-record"
is **not** `S` -- it is an operational note that cannot support an indicative
claim at any grade.

## 2. Scientific readiness levels

The lab uses Scientific Readiness Levels (SRL), inspired by technology
readiness schemes but adapted to fundamental theory:

| SRL | Meaning |
| --- | --- |
| 0 | Intuition only; no precise claim |
| 1 | Question, definitions, and kill condition stated |
| 2 | Primary literature and nearest-work map complete |
| 3 | Toy calculation, theorem shape, or counterexample |
| 4 | Nondegenerate finite model with controls and formal proof |
| 5 | General finite theorem or reproducible simulation family |
| 6 | Controlled asymptotic/continuum or reconstruction bridge |
| 7 | Recovers a nontrivial established physical benchmark |
| 8 | Distinctive held-out prediction or exclusion |
| 9 | Independent external replication or empirical confirmation |

SRL is attached to a specific claim, not an entire theory. A large manuscript
does not inherit the level of its strongest theorem.

## 3. Work-item states

```text
PROPOSED
-> TRIAGED
-> LITERATURE_MAPPED
-> SPECIFIED
-> PREREGISTERED
-> EXECUTING
-> VERIFYING
-> RED_TEAM
-> REPLICATING
-> INTEGRATED
-> RELEASE_CANDIDATE
-> RELEASED
```

Terminal or side states:

```text
BLOCKED, KILLED, SUPERSEDED, PARKED, RETRACTED
```

No item jumps from idea to manuscript. A negative result follows the same
verification and release path as a positive result.

Trust upgrades are first-class: when an `M+E` claim is retrofitted to bare
kernel (`M`), the item does not leave `INTEGRATED`; instead the claim's grade
changes in the claim registry with a ledger entry citing the new footprint
check, and the relevant guard file is updated. Retrofits earn the same flow
credit as new landings at equal rigor.

## 4. Promotion gates

### To `M`

- intended theorem stated correctly;
- direct Lean check and appropriate build;
- standard axiom footprint pinned;
- nonzero witness and boundary/wrong-shape control;
- semantic review by a different model;
- provenance and convention audit.

Solo mode does not remove the different-model semantic-review gate. A newly
checked theorem may be recorded as a kernel-accepted internal draft with its
build and guard evidence attached, but grade `M` promotion waits whenever the
registered independent family is paused. Results promoted before solo mode keep
their grade; the lab does not retroactively erase completed review.

### To SRL 6

- changing spaces/maps are explicit;
- topology and function class are stated;
- convergence rate or mode of convergence is proved;
- ultraviolet and boundary effects are controlled;
- inverse/reconstruction map is included;
- no finite-to-continuum name inflation.

### To SRL 7

- benchmark selected before tuning;
- units and observable dictionary are explicit;
- baseline method is run on the same benchmark;
- error bars or exact discrepancies are reported;
- fitted and held-out quantities are separated.

### To SRL 8

- prediction is not used to select the model or fit its coefficient;
- uncertainty and parameter sensitivity are disclosed;
- competing frameworks are compared;
- feasible observation or experiment is identified;
- prediction is timestamped before result access.

## 5. Mandatory overclaim audit

Every promotion checks:

- vacuity;
- hollow telescoping;
- docstring outruns kernel;
- false mathematical shape;
- convention drift;
- source laundering;
- finite-to-continuum slippage;
- fitted-to-predicted relabeling;
- common-shape-to-common-origin inflation;
- arithmetic consistency presented as dynamics.

The Skeptic can block promotion, not exploration. A block must cite the failed
gate and the smallest evidence that would clear it.

## 6. Claim registry

`state/CLAIMS.json` is the canonical per-claim record: id, statement, grade,
SRL, Lean declaration anchors, guard file, and manuscript uses. It
operationalizes the mechanical claim-level layer proven in the 2026-07-12 run
(HONEST_SCORECARD): every indicative sentence in a manuscript must map to a
registry row of the sentence's claimed grade; sentences without a row must be
subjunctive or explicitly oracle/conjecture-labeled. `labctl.py validate`
checks registry well-formedness (grades, SRL range, `M`/`M+E` rows must cite
declarations); the Skeptic checks the sentence-to-row mapping at promotion.

## 7. Evidence graph

`state/WORK_ITEMS.json` connects execution to the claim registry. Every item
records:

- `parent_id` for an atomic rung of a larger work item;
- `depends_on` for scientific or procedural prerequisites;
- `nearest_work` for the closest stronger claim not established by the item;
- `deliverables` for the artifacts whose failures can be judged separately;
- `evidence_paths` for proofs, reports, source maps, simulations, or audits;
- `claim_ids` for claim-registry rows supported or modified by the item;
- `verification_commands` for clean-context replay.

The graph is intentionally file-backed and inspectable. Unknown dependencies,
dependency cycles, and unknown claim links are validation failures. A work item
with several independently falsifiable deliverables should be split into a
parent and atomic children before execution rather than marked partially done.

## 8. Reproduction manifests

`labctl.py repro-manifest WORK-ID` renders a deterministic packet from the
work item. The Reproducer may add environment details and raw outputs, but may
not silently change the claim, artifacts, or commands. A successful replay
checks execution reproducibility; it does not replace semantic review of what
the theorem or simulation means.
