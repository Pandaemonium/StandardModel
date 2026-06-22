# Aristotle task: finite P9 diamond-source visibility API

Date: 2026-06-22

## Objective

Prove the first small observer-facing P9 source-visibility API:

```text
boundary-exact source -> invisible to closed bulk tests
one-face unit source  -> visible and not boundary-exact
```

This combines the boundary-source theorem with a sanity check that the
vocabulary can still recognize genuinely bulk-visible sources.

Prompt:

```text
AgentTasks/aristotle-p9-diamond-visibility-api-prompt-20260622.md
```

Target:

```text
NullEdgeP9DiamondVisibility/Finite.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 4b710873-4cce-4c84-b55f-52ac55c92669
  task_id: 900767fa-32e0-4ebe-967c-baa187cf9adc
  target_file: PhysicsSM/Draft/NullEdgeP9DiamondVisibility.lean
  expected_module: PhysicsSM.Draft.NullEdgeP9DiamondVisibility
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-diamond-visibility-api-20260622-project
  output_dir: AgentTasks/aristotle-output/4b710873-4cce-4c84-b55f-52ac55c92669
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. The target is intended
to elaborate with five proof holes before submission.

Submitted 2026-06-22. `aristotle submit` created project
`4b710873-4cce-4c84-b55f-52ac55c92669`; `aristotle tasks` reported task
`900767fa-32e0-4ebe-967c-baa187cf9adc` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-diamond-visibility-api-20260622/NullEdgeP9DiamondVisibility/Finite.lean
lake exe cache get
lake env lean NullEdgeP9DiamondVisibility/Finite.lean
```

The final two commands were run inside
`AgentTasks/aristotle-submit/null-edge-p9-diamond-visibility-api-20260622-project`.

## Result

Integrated 2026-06-22 as
`PhysicsSM.Draft.NullEdgeP9DiamondVisibility`. Aristotle closed all five focused
proof targets without statement changes, new assumptions, or escape-hatch
declarations. The integrated repo version keeps the same theorem content but
uses clean docstrings and the `PhysicsSM.Draft` namespace.

The proved declarations are:

```text
boundaryExact_invisible_to_closed_tests
unitTest_closed_emptyBoundary
unitSource_pairing_unitTest_eq_one
unitSource_not_boundaryExact_emptyBoundary
exists_bulkVisible_not_boundaryExact
```

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9DiamondVisibility.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9DiamondVisibility.lean
git diff --check
lake build PhysicsSM.Draft.NullEdgeP9DiamondVisibility
```
