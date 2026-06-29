# Aristotle task C226: branchKernel_chiralIndex_zero theorem design

Date: 2026-06-28

Purpose:

```text
Translate the known C21 chirality-balanced branch-kernel obstruction into the
projector/chiral-index vocabulary without claiming Gate C1 release.
```

Prompt:

```text
AgentTasks/aristotle-prompts/gate-c1-branch-kernel-chiral-index-zero-c226.prompt.md
```

Submission project:

```text
AgentTasks/aristotle-submit/gate-c1-branch-kernel-chiral-index-zero-c226
```

Included files:

```text
NullEdgeActualCliffordSymbol.lean
NullEdgeBranchClassifierAPI.lean
ProjectorPersistence.lean
ARISTOTLE_TASK.md
```

Status:

```text
submitted.
```

Aristotle metadata:

```yaml
aristotle:
  project_id: 2a4c821b-a71b-4906-8654-e1509ffe818d
  task_id: 64ec5b68-15ff-4bbb-9372-2f38118e17f4
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/gate-c1-branch-kernel-chiral-index-zero-c226
  output_dir: AgentTasks/aristotle-output/2a4c821b-a71b-4906-8654-e1509ffe818d
  status: integrated
```

Submission note:

```text
Aristotle warned that the focused package has Lean files but no local
lean-toolchain or .lake directory. This job is primarily theorem-design and
bridge-planning; any returned Lean must be reviewed and checked locally before
promotion.
```

Integration, 2026-06-28:

```text
Integrated the two returned GateC1-side obstruction lemmas into
PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean:

  chiralIndex_zero_of_rank_balanced;
  chiralIndex_zero_of_trace_zero.

Recorded the proposed future theorem branchKernel_chiralIndex_zero in the docs.
No local Lean checks were run in the live repo.
```
