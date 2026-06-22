# Aristotle task: P9 closed fan positive source

Date: 2026-06-22

## Objective

Prove the finite no-go theorem that visible closure is a rest-frame condition,
not source invisibility: if closure vanishes and total energy is nonzero, the
moment mass square and one-face source pairing are positive.

Prompt:

```text
AgentTasks/aristotle-p9-closed-fan-positive-source-prompt-20260622.md
```

Target:

```text
NullEdgeP9ClosedFanPositiveSource/Core.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 56174d52-6a0f-4e5a-9bea-bf9d3f8bb1ae
  task_id: 38e128a5-f6c3-47a0-98da-1ff7d845c2f7
  target_file: NullEdgeP9ClosedFanPositiveSource/Core.lean
  expected_module: NullEdgeP9ClosedFanPositiveSource.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-closed-fan-positive-source-20260622-project
  output_dir: AgentTasks/aristotle-output/null-edge-p9-closed-fan-positive-source-20260622-extracted
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. The target elaborates
with three intended proof holes before submission.

Verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-closed-fan-positive-source-20260622/NullEdgeP9ClosedFanPositiveSource/Core.lean
lake exe cache get
lake env lean NullEdgeP9ClosedFanPositiveSource/Core.lean
```

Integration note: Aristotle solved all three standalone targets with no
statement changes. The two new no-go corollaries were integrated directly into
`PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore` to avoid another
duplicated P9 namespace.

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9DiamondSourceVisibilityCore.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9DiamondSourceVisibilityCore.lean
git diff --check
lake build PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore
```
