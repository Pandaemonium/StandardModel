# Aristotle focused job: P9 offset-window guardrail

```yaml
job_name: null-edge-p9-offset-window-guardrail-20260623
status: integrated
project_id: f9b645e7-80d3-464b-95ba-ce79a91fe374
task_id: 93422773-9511-4e4a-867a-87c52aa2f7f0
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-offset-window-guardrail-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-offset-window-guardrail-20260623-project
target_module: NullEdgeP9OffsetWindowGuardrail.Core
target_file: NullEdgeP9OffsetWindowGuardrail/Core.lean
expected_check: lake env lean NullEdgeP9OffsetWindowGuardrail/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9OffsetWindowGuardrail/Core.lean` without
changing definitions or theorem statements.

Scientific target: formalize the P9 offset-sweep warning. A block-average
coarse map can annihilate modes because of arithmetic alignment. Even all
cyclic offsets can annihilate nonzero high-frequency modes, so P9 needs an
intrinsic or observer-forced coarse map rather than an after-the-fact block
choice.

## Targets

```lean
single_window_zero_not_offset_invariant
nonzero_mode_all_window_traces_zero
all_window_sums_zero_implies_all_traces_zero
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9OffsetWindowGuardrail/Core.lean
```

## Proof sketch

For the existential examples, use explicit vectors. The single-window theorem
can use `(1, -1, 1, -1, 0, 0, 0, 0)`. The all-window theorem can use the
periodic mode `(1, -1, 1, -1, 1, -1, 1, -1)`: every four-cell cyclic window
sum is zero, but the first coordinate is nonzero. The final theorem is direct
substitution into the trace definitions.

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
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-offset-window-guardrail-20260623/NullEdgeP9OffsetWindowGuardrail/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-offset-window-guardrail-20260623-project/NullEdgeP9OffsetWindowGuardrail/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" AgentTasks/aristotle-standalone/null-edge-p9-offset-window-guardrail-20260623/NullEdgeP9OffsetWindowGuardrail/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-offset-window-guardrail-20260623/NullEdgeP9OffsetWindowGuardrail/Core.lean AgentTasks/null-edge-p9-offset-window-guardrail-aristotle-2026-06-23.md
```

The Lean preflight found exactly the three intended proof-hole warnings and no
other errors. Non-ASCII scan was clean after converting theorem statements to
ASCII notation. The focused package helper reported three proof-hole lines,
zero proof-escape tokens, and zero unsafe tokens.

Submitted as Aristotle project `f9b645e7-80d3-464b-95ba-ce79a91fe374`, task
`93422773-9511-4e4a-867a-87c52aa2f7f0`.

## Completion and integration

Aristotle completed all three targets with no statement or definition changes,
no remaining proof holes, and no added assumptions or nonstandard constructs.

Integrated live module:

```text
PhysicsSM.Draft.NullEdgeP9OffsetWindowGuardrail
```

Live verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9OffsetWindowGuardrail.lean
lake build PhysicsSM.Draft.NullEdgeP9OffsetWindowGuardrail
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9OffsetWindowGuardrail.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9OffsetWindowGuardrail.lean
```

All targeted checks passed. The integrated proof was translated from
Aristotle's Unicode proof syntax to ASCII Lean syntax. The first draft-root
check raced the targeted build and failed before the `.olean` existed; rerunning
after the targeted build passed.
