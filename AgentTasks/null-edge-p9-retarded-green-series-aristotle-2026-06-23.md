# Aristotle focused job: P9 retarded Green series

```yaml
job_name: null-edge-p9-retarded-green-series-20260623
status: integrated
project_id: 5f79548b-1c36-473a-8780-7ef254b090c8
task_id: 8c0c3b2b-2a54-49be-bcba-3614fabcb9ee
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-retarded-green-series-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-retarded-green-series-20260623-project
target_module: NullEdgeP9RetardedGreenSeries.Core
target_file: NullEdgeP9RetardedGreenSeries/Core.lean
expected_check: lake env lean NullEdgeP9RetardedGreenSeries/Core.lean
```

## Task

Fill the four proof holes in `NullEdgeP9RetardedGreenSeries/Core.lean` without
changing definitions or theorem statements.

This is a finite response-law scaffold for P9. Once a finite retarded kernel is
nilpotent on a diamond, the formal retarded response series terminates. The
target proves the finite algebraic Green identity:

```text
(I - K) (sum_{m < H} K^m x) = x
```

whenever `K^H x = 0`.

## Targets

```lean
applyKernel_vecSum_range
applyKernel_iterateApply
oneMinusK_retardedSeries_eq_of_nilpotent
retardedSeries_is_right_inverse_on_nilpotent_vector
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9RetardedGreenSeries/Core.lean
```

## Proof sketch

`applyKernel_vecSum_range` is finite linearity of `applyKernel` over a finite
range sum. `applyKernel_iterateApply` is definitional after unfolding the
successor case. The Green-series theorem is a telescoping identity:

```text
sum_{m < H} K^m x - K (sum_{m < H} K^m x)
  = x - K^H x
  = x.
```

The positive-height assumption `0 < H` supplies the initial `x` term, and
`hNil` kills the terminal term.

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission note

Staged on 2026-06-23.

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-retarded-green-series-20260623/NullEdgeP9RetardedGreenSeries/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-retarded-green-series-20260623/NullEdgeP9RetardedGreenSeries/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-retarded-green-series-20260623/NullEdgeP9RetardedGreenSeries/Core.lean
```

The Lean preflight found exactly the four intended proof-hole warnings and no
other errors. Non-ASCII scan was clean. The focused package helper reported four
proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

Submitted on 2026-06-23 as Aristotle project
`5f79548b-1c36-473a-8780-7ef254b090c8`, task
`8c0c3b2b-2a54-49be-bcba-3614fabcb9ee`.

## Completion and integration

Aristotle completed the focused package with all four target proof holes filled,
no statement or definition changes, no remaining proof holes, and no added
assumptions or nonstandard constructs.

Integrated live module:

```text
PhysicsSM.Draft.NullEdgeP9RetardedGreenSeries
```

Live verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9RetardedGreenSeries.lean
lake build PhysicsSM.Draft.NullEdgeP9RetardedGreenSeries
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9RetardedGreenSeries.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9RetardedGreenSeries.lean
```

All targeted checks passed. The live integration uses ASCII Lean syntax and
keeps the theorem as a finite terminating response-law identity, not as a claim
of continuum Green-function behavior.
