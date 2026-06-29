# Aristotle task C225: Gate C1 promoted Draft leaf static audit

Date: 2026-06-28

Purpose:

```text
Audit the four locally promoted Draft leaves for namespace/import collision
risks and identify the smallest safe aggregator strategy.
```

Prompt:

```text
AgentTasks/aristotle-prompts/gate-c1-promoted-draft-static-audit-c225.prompt.md
```

Submission project:

```text
AgentTasks/aristotle-submit/gate-c1-promoted-draft-static-audit-c225
```

Included files:

```text
CKMWilsonWindow.lean
GappedHomotopy.lean
SignStability.lean
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
  project_id: b4ed5032-770d-4684-8d64-626e089b45bb
  task_id: a1e1c9a7-46d0-4f48-8a87-4c801ea93f82
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/gate-c1-promoted-draft-static-audit-c225
  output_dir: AgentTasks/aristotle-output/b4ed5032-770d-4684-8d64-626e089b45bb
  status: integrated
```

Submission note:

```text
Aristotle warned that the focused package has Lean files but no local
lean-toolchain or .lake directory. This was accepted for a static-audit job; do
not treat any returned result as locally verified until checked in the live repo.
```

Integration, 2026-06-28:

```text
Dry-run helper downloaded the project but found no candidate Lean file to apply.
The task transcript and AUDIT_C225.md reported the real issue:
leading module docstrings before import Mathlib.

Applied the safe local fix to the four Draft leaves:
/-! -> /- at the first token only.

No local Lean checks were run in the live repo.
```
