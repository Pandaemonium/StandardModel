# Aristotle task: finite P9 visible-closure source guardrail

Date: 2026-06-22

## Objective

Prove the finite guardrail that visible closure is a rest-frame condition, not
source invisibility:

```text
two opposite unit rays -> closure zero
same fan               -> positive unit moment mass source
```

This is a toy theorem, but it is a useful check on the cosmological-constant
branch: boundary/internal invisibility must be distinguished from ordinary
visible rest energy.

Prompt:

```text
AgentTasks/aristotle-p9-visible-closure-source-prompt-20260622.md
```

Target:

```text
NullEdgeP9VisibleClosureSource/Finite.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: e3558146-26c9-4a88-9e3f-df06bc6c52d1
  task_id: dd30c3c8-0d37-43b8-b84e-c6147decd6ba
  target_file: PhysicsSM/Draft/NullEdgeP9VisibleClosureSource.lean
  expected_module: PhysicsSM.Draft.NullEdgeP9VisibleClosureSource
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-visible-closure-source-20260622-project
  output_dir: AgentTasks/aristotle-output/e3558146-26c9-4a88-9e3f-df06bc6c52d1
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. The target is intended
to elaborate with four proof holes before submission.

Submitted 2026-06-22. `aristotle submit` created project
`e3558146-26c9-4a88-9e3f-df06bc6c52d1`; `aristotle tasks` reported task
`dd30c3c8-0d37-43b8-b84e-c6147decd6ba` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-visible-closure-source-20260622/NullEdgeP9VisibleClosureSource/Finite.lean
lake exe cache get
lake env lean NullEdgeP9VisibleClosureSource/Finite.lean
```

The final two commands were run inside
`AgentTasks/aristotle-submit/null-edge-p9-visible-closure-source-20260622-project`.

## Result

Integrated 2026-06-22 as
`PhysicsSM.Draft.NullEdgeP9VisibleClosureSource`. Aristotle closed all four
focused proof targets without statement changes, new assumptions, or
escape-hatch declarations. The integrated repo version keeps the same theorem
content but uses clean encoding and the `PhysicsSM.Draft` namespace.

The proved declarations are:

```text
twoRayClosure_eq_zero
twoRayMomentMassSq_eq_one
twoRayMassSource_visible_to_unitTest
closed_visibleFan_can_be_bulkVisible
```

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9VisibleClosureSource.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9VisibleClosureSource.lean
git diff --check
lake build PhysicsSM.Draft.NullEdgeP9VisibleClosureSource
```
