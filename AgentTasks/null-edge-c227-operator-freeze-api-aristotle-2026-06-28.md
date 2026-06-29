# Aristotle task C227: Gate C1 operator-freeze API and strategy

Date: 2026-06-28

Purpose:

```text
Design the smallest Lean/API layer for H_ref, H_ne, transport, and the
kappa/omega/rho/alpha/beta budget, with CKM restricted to internal
branch/flavor texture and Wilson/Neuberger carrying spacetime doubler
resolution.
```

Prompt:

```text
AgentTasks/aristotle-prompts/gate-c1-operator-freeze-api-c227.prompt.md
```

Submission project:

```text
AgentTasks/aristotle-submit/gate-c1-operator-freeze-api-c227
```

Included files:

```text
CKMWilsonWindow.lean
GappedHomotopy.lean
SignStability.lean
ARISTOTLE_TASK.md
```

Status:

```text
submitted.
```

Aristotle metadata:

```yaml
aristotle:
  project_id: e007804c-78a6-4da1-a61f-e70d5006e30e
  task_id: 9c93b268-b8ae-461b-b7d8-a1d805dcc142
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/gate-c1-operator-freeze-api-c227
  output_dir: AgentTasks/aristotle-output/e007804c-78a6-4da1-a61f-e70d5006e30e
  status: integrated
```

Submission note:

```text
Aristotle warned that the focused package has Lean files but no local
lean-toolchain or .lake directory. This is acceptable for a focused API/strategy
job, but any returned code must be checked in the live repo before use.
```

Integration, 2026-06-28:

```text
Ported OperatorFreeze.lean into:
PhysicsSM/Draft/NullEdge/GateC1/OperatorFreeze.lean

Adjusted imports from standalone module names to live repo module paths:
PhysicsSM.Draft.NullEdge.GateC1.CKMWilsonWindow;
PhysicsSM.Draft.NullEdge.GateC1.GappedHomotopy;
PhysicsSM.Draft.NullEdge.GateC1.SignStability.

No local Lean checks were run in the live repo.
```
