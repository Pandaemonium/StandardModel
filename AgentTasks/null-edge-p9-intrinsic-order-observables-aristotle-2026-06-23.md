# Aristotle focused job: P9 intrinsic order observables

```yaml
job_name: null-edge-p9-intrinsic-order-observables-20260623
status: integrated
project_id: e71998cf-0c45-4dba-8677-639cf47576af
task_id: 29e79cdc-dcca-4536-b3b4-61b8147221d1
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-intrinsic-order-observables-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-intrinsic-order-observables-20260623-project
target_module: NullEdgeP9IntrinsicOrderObservables.Core
target_file: NullEdgeP9IntrinsicOrderObservables/Core.lean
expected_check: lake env lean NullEdgeP9IntrinsicOrderObservables/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9IntrinsicOrderObservables/Core.lean` without
changing definitions or theorem statements.

Scientific target: after the P9 block-aliasing and offset-window guardrails,
the program needs observables that are intrinsic to the finite causal order.
This file formalizes two low-level invariance facts inspired by the causal-set
graph-observable literature: interval abundance and degree histograms do not
depend on arbitrary relabeling of the finite vertex set.

## Targets

```lean
intervalCard_transportRel
intervalAbundance_transportRel
outDegree_transportRel
outDegreeHistogram_transportRel
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9IntrinsicOrderObservables/Core.lean
```

## Proof sketch

Use the equivalence `e : A equiv B` to map the relevant filtered finite sets.
For interval cardinality, map `x : A` to `e x` and use `e.symm_apply_apply`.
For interval abundance and degree histograms, map ordered pairs or points
through the equivalence and use the pointwise cardinality invariance lemmas.

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission note

Staged and submitted on 2026-06-23.

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-intrinsic-order-observables-20260623/NullEdgeP9IntrinsicOrderObservables/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-intrinsic-order-observables-20260623-project/NullEdgeP9IntrinsicOrderObservables/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" AgentTasks/aristotle-standalone/null-edge-p9-intrinsic-order-observables-20260623/NullEdgeP9IntrinsicOrderObservables/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-intrinsic-order-observables-20260623/NullEdgeP9IntrinsicOrderObservables/Core.lean AgentTasks/null-edge-p9-intrinsic-order-observables-aristotle-2026-06-23.md
```

The Lean preflight found exactly the four intended proof-hole warnings and no
other errors. Non-ASCII scan was clean after rewriting relation equivalence and
product types with ASCII names. The focused package helper reported four
proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

Submitted as Aristotle project `e71998cf-0c45-4dba-8677-639cf47576af`, task
`29e79cdc-dcca-4536-b3b4-61b8147221d1`.

## Integration

Integrated into `PhysicsSM/Draft/NullEdgeP9IntrinsicOrderObservables.lean` and
imported from `PhysicsSMDraft.lean`.

Aristotle returned `COMPLETE_WITH_ERRORS`, but the reported error was not a
proof failure. Completion report:

- solved targets: `intervalCard_transportRel`,
  `intervalAbundance_transportRel`, `outDegree_transportRel`,
  `outDegreeHistogram_transportRel`;
- unchanged theorem statements: yes;
- remaining proof holes: none;
- assumptions or escape hatches: none;
- only benign linter warnings about unused decidable hypotheses.

The dry-run helper downloaded the result but hit the same Windows
extraction-path issue on a bundled task-note path seen in adjacent focused
jobs. The target `Core.lean` was still extracted, so integration used
`git diff --no-index` against the staged source. Only proof bodies changed.

The live module adds targeted linter suppressions for unused section variables
and unused decidable hypotheses. These warnings are not useful signal for this
finite relabeling module.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9IntrinsicOrderObservables.lean
lake build PhysicsSM.Draft.NullEdgeP9IntrinsicOrderObservables
lake env lean PhysicsSMDraft.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" PhysicsSM/Draft/NullEdgeP9IntrinsicOrderObservables.lean
```

All targeted checks passed. The first root check was run in parallel with the
module build and failed because the `.olean` had not yet been written; the
sequential rerun passed.
