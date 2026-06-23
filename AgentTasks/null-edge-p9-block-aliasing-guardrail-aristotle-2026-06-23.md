# Aristotle focused job: P9 block-aliasing guardrail

```yaml
job_name: null-edge-p9-block-aliasing-guardrail-20260623
status: integrated
project_id: ec32c1bf-13b1-43f8-a749-9455d7c15265
task_id: 8282c6c5-e622-46c6-a476-c129ced5ca69
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-block-aliasing-guardrail-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-block-aliasing-guardrail-20260623-project
target_module: NullEdgeP9BlockAliasingGuardrail.Core
target_file: NullEdgeP9BlockAliasingGuardrail/Core.lean
expected_check: lake env lean NullEdgeP9BlockAliasingGuardrail/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9BlockAliasingGuardrail/Core.lean` without
changing definitions or theorem statements.

Scientific target: this formalizes the P9 offset-sweep warning. A fixed
block-average coarse map can annihilate a mode purely because the mode has zero
sum inside the block. Such a zero is a coarse-map alignment fact, not by itself
a physical source-visibility signal.

## Targets

```lean
blockAverageCoarseTrace4_eq_average_sq
blockAverage4_eq_zero_of_sum_zero
blockAverageCoarseTrace4_eq_zero_of_sum_zero
blockAverageCoarseTrace4_nonneg
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9BlockAliasingGuardrail/Core.lean
```

## Proof sketch

`blockAverageCoarseTrace4` is definitionally `blockAverage4 x *
blockAverage4 x`, and over `Real` this equals the square. If the block sum is
zero, `blockAverage4 x = 0 / 2 = 0`; substituting into the rank-one coarse trace
gives zero. Nonnegativity follows from the square form.

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
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-block-aliasing-guardrail-20260623/NullEdgeP9BlockAliasingGuardrail/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-block-aliasing-guardrail-20260623-project/NullEdgeP9BlockAliasingGuardrail/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-block-aliasing-guardrail-20260623/NullEdgeP9BlockAliasingGuardrail/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-block-aliasing-guardrail-20260623/NullEdgeP9BlockAliasingGuardrail/Core.lean AgentTasks/null-edge-p9-block-aliasing-guardrail-aristotle-2026-06-23.md
```

The Lean preflight found exactly the four intended proof-hole warnings and no
other errors. Non-ASCII scan was clean. The focused package helper reported
four proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

Submitted as Aristotle project `ec32c1bf-13b1-43f8-a749-9455d7c15265`, task
`8282c6c5-e622-46c6-a476-c129ced5ca69`.

## Completion and integration

Aristotle completed all four targets with no statement or definition changes,
no remaining proof holes, and no added assumptions or nonstandard constructs.

Integrated live module:

```text
PhysicsSM.Draft.NullEdgeP9BlockAliasingGuardrail
```

Live verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9BlockAliasingGuardrail.lean
lake build PhysicsSM.Draft.NullEdgeP9BlockAliasingGuardrail
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9BlockAliasingGuardrail.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9BlockAliasingGuardrail.lean
```

All targeted checks passed. The first draft-root check raced the targeted build
and failed before the `.olean` existed; rerunning after the targeted build
passed.
