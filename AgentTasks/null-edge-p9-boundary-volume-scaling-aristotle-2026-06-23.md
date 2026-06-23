# Aristotle focused job: P9 boundary-over-volume scaling

```yaml
job_name: null-edge-p9-boundary-volume-scaling-20260623
status: integrated
project_id: e831cb23-db32-4cf6-b2ad-6f03c0908f15
task_id: d83def02-f759-483e-b0a8-c0fc7cb66fcf
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-boundary-volume-scaling-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-boundary-volume-scaling-20260623-project
target_module: NullEdgeP9BoundaryVolumeScaling.Core
target_file: NullEdgeP9BoundaryVolumeScaling/Core.lean
expected_check: lake env lean NullEdgeP9BoundaryVolumeScaling/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9BoundaryVolumeScaling/Core.lean` without
changing definitions or theorem statements.

Scientific target: this is the arithmetic scaffold behind the P9 area-vs-volume
source-visibility route. If the source-visible sector is bounded by a boundary
count while the observer volume grows one dimension faster, the trace-density
readout scales like `C / L` and can become small at large scale.

## Targets

```lean
boundaryDensity4_eq_C_div_L
boundaryDensity4_le_eps_of_scale_ge
boundaryDensity4_double_scale
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9BoundaryVolumeScaling/Core.lean
```

## Proof sketch

The first and third targets are algebraic simplifications using `L != 0`.
For the epsilon bound, rewrite the density as `C / L`; since `C`, `L`, and
`eps` are nonnegative with `eps > 0`, the hypothesis `C / eps <= L` implies
`C / L <= eps`.

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
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-boundary-volume-scaling-20260623/NullEdgeP9BoundaryVolumeScaling/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-boundary-volume-scaling-20260623-project/NullEdgeP9BoundaryVolumeScaling/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" AgentTasks/aristotle-standalone/null-edge-p9-boundary-volume-scaling-20260623/NullEdgeP9BoundaryVolumeScaling/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-boundary-volume-scaling-20260623/NullEdgeP9BoundaryVolumeScaling/Core.lean AgentTasks/null-edge-p9-boundary-volume-scaling-aristotle-2026-06-23.md
```

The Lean preflight found exactly the three intended proof-hole warnings and no
other errors. Non-ASCII scan was clean after converting theorem statements to
ASCII notation. The focused package helper reported three proof-hole lines,
zero proof-escape tokens, and zero unsafe tokens.

Submitted as Aristotle project `e831cb23-db32-4cf6-b2ad-6f03c0908f15`, task
`d83def02-f759-483e-b0a8-c0fc7cb66fcf`.

## Completion and integration

Aristotle completed all three targets with no statement or definition changes,
no remaining proof holes, and no added assumptions or nonstandard constructs.

Integrated live module:

```text
PhysicsSM.Draft.NullEdgeP9BoundaryVolumeScaling
```

Live verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9BoundaryVolumeScaling.lean
lake build PhysicsSM.Draft.NullEdgeP9BoundaryVolumeScaling
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9BoundaryVolumeScaling.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9BoundaryVolumeScaling.lean
```

All targeted checks passed. The integrated proof keeps ASCII syntax; the
nonnegative coefficient hypothesis is retained because it documents the
physical boundary-size regime, even though the algebraic proof does not need
it. The first draft-root check raced the targeted build and failed before the
`.olean` existed; rerunning after the targeted build passed.
