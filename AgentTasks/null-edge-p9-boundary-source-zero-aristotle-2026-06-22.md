# Aristotle task: finite P9 boundary-source invisibility

Date: 2026-06-22

## Objective

Prove the first finite P9 source-visibility core: a boundary-generated source
pairs trivially with every closed bulk test by discrete adjointness.

This is deliberately a toy theorem. Its role is to give the cosmological-
constant/source-visibility lane a non-prose mechanism:

```text
boundary bookkeeping + closed bulk observer -> zero bulk source pairing
```

It should later be specialized by the `DiamondSourceVisibility` API rather than
being advertised as a standalone physics solution.

Prompt:

```text
AgentTasks/aristotle-p9-boundary-source-zero-prompt-20260622.md
```

Target:

```text
NullEdgeP9BoundarySource/Finite.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: ea84d10d-e796-4393-8a9d-7d252007fd27
  task_id: e609f1a1-aa8b-42a3-8101-c39f0245d805
  target_file: PhysicsSM/Draft/NullEdgeP9BoundarySource.lean
  expected_module: PhysicsSM.Draft.NullEdgeP9BoundarySource
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-boundary-source-zero-20260622-project
  output_dir: AgentTasks/aristotle-output/ea84d10d-e796-4393-8a9d-7d252007fd27
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. Local elaboration of
the source file passed with exactly five intended proof-hole warnings.

Submitted 2026-06-22. `aristotle submit` created project
`ea84d10d-e796-4393-8a9d-7d252007fd27`; `aristotle tasks` reported task
`e609f1a1-aa8b-42a3-8101-c39f0245d805` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-boundary-source-zero-20260622/NullEdgeP9BoundarySource/Finite.lean
lake exe cache get
lake env lean NullEdgeP9BoundarySource/Finite.lean
```

The final two commands were run inside
`AgentTasks/aristotle-submit/null-edge-p9-boundary-source-zero-20260622-project`.

## Result

Integrated 2026-06-22 as
`PhysicsSM.Draft.NullEdgeP9BoundarySource`. Aristotle closed all five focused
proof targets without statement changes, new assumptions, or escape-hatch
declarations. The integrated repo version keeps the same theorem content but
uses ASCII spelling for finite sums and variable names.

The proved declarations are:

```text
boundarySource_pairing_eq_boundary_potential_pairing
boundaryExact_source_eq_zero
sourcePairing_eq_of_boundary_difference
sourcePairing_add_left
sourcePairing_add_right
```

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9BoundarySource.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9BoundarySource.lean
git diff --check
```
