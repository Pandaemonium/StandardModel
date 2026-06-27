# Aristotle task C71: null-Wilson operator-placement audit

```yaml
aristotle:
  project_id: 6c68f266-8c43-47be-b960-6cb5f6f91b69
  task_id: 1e4197e1-bec4-4aba-ae4c-e3389f35548b
  target_file: AgentTasks/null-edge-null-wilson-operator-placement-audit-report.md
  expected_module: report-only
  submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/6c68f266-8c43-47be-b960-6cb5f6f91b69
  status: integrated
```

Context pack:

- `AgentTasks/context-packs/null-edge-gate-c-null-wilson-20260627-063900.md`

Goal: decide the correct mathematical placement of the null-Wilson regulator.

Audit questions:

```text
1. Is D_NW = i D_N + Gamma_s R_W the correct object, or should R_W enter as a
   scalar Wilson kernel, an overlap/domain-wall kernel, or a projected-sector
   regulator?

2. What grading hypotheses are required so the Gate A sign convention is not
   corrupted?

3. Does R_W break ordinary chirality, and if so should the release theorem move
   immediately to overlap/domain-wall/flavored chirality?

4. Does R_W belong in the same zero-order block as Phi_H, or must it be treated
   separately as a branch-control regulator/counterterm?

5. Which minimal Lean API should be used by C72/C73?
```

Deliverable:

```text
AgentTasks/null-edge-null-wilson-operator-placement-audit-report.md
```


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 6c68f266-8c43-47be-b960-6cb5f6f91b69
task_id: 1e4197e1-bec4-4aba-ae4c-e3389f35548b
submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
target: AgentTasks/null-edge-null-wilson-operator-placement-audit-report.md
```

## Integration record, 2026-06-27

Integrated into the live repo by Codex.

```text
project_id: 6c68f266-8c43-47be-b960-6cb5f6f91b69
task_id: 1e4197e1-bec4-4aba-ae4c-e3389f35548b
copied_files:
  - AgentTasks/null-edge-null-wilson-operator-placement-audit-report.md
  - PhysicsSM/Draft/NullEdgeNullWilsonPlacement.lean
  - PhysicsSMDraft.lean
summary: AgentTasks/aristotle-output/6c68f266-8c43-47be-b960-6cb5f6f91b69/ARISTOTLE_SUMMARY.md
```

No local Lean build or pre-commit was run during this integration pass.
