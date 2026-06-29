# Aristotle task C232: branchKernel_chiralIndex_zero dependency audit

Date: 2026-06-28

Purpose:

```text
Audit the dependency surface for the C226 bridge theorem before attempting a
live proof of branchKernel_chiralIndex_zero.
```

Prompt:

```text
AgentTasks/aristotle-prompts/gate-c1-branch-kernel-bridge-dependency-audit-c232.prompt.md
```

Submission project:

```text
AgentTasks/aristotle-submit/gate-c1-branch-kernel-bridge-dependency-audit-c232
```

Status:

```text
submitted.
```

Aristotle metadata:

```yaml
aristotle:
  project_id: d203d5a8-f63e-444c-899b-3c7bbeced0ee
  task_id: 754f50f3-1669-4575-845e-b6640d909ff5
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/gate-c1-branch-kernel-bridge-dependency-audit-c232
  output_dir: AgentTasks/aristotle-output/d203d5a8-f63e-444c-899b-3c7bbeced0ee
  status: integrated
```

Submission note:

```text
Aristotle warned that the focused package has Lean files but no local
lean-toolchain or .lake directory. This job audits dependencies and theorem
shape; any returned code must be reviewed and checked locally.
```

Integration, 2026-06-28:

```text
Fetched and archived the project output.
Ported the generic branch-kernel zero-index core into:
PhysicsSM/Draft/NullEdge/GateC1/BranchKernelChiralIndexZero.lean

Adjusted import:
ProjectorPersistence ->
PhysicsSM.Draft.NullEdge.GateC1.ProjectorPersistence

Important live correction:
C232's request package lacked the live geometry file. Current live search found
PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean, and C235 was submitted
with that file included for the actual branchP specialization.

No local Lean checks were run.
```
