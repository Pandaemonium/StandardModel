# Aristotle task: P9 boundary-visible decomposition

```yaml
aristotle:
  project_id: 3f39ceda-a85a-4c36-bda7-908cf513215d
  target_file: NullEdgeP9BoundaryVisibleDecomp/Core.lean
  expected_module: NullEdgeP9BoundaryVisibleDecomp.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-boundary-visible-decomp-20260623-project
  output_dir: AgentTasks/aristotle-output/3f39ceda-a85a-4c36-bda7-908cf513215d
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: prove the finite Hodge-style decomposition algebra needed by
P9. Closed bulk tests see only the residual visible source component; adding a
boundary-exact source cannot change closed-test visibility.

## Submission note

Submitted as focused Aristotle project
`3f39ceda-a85a-4c36-bda7-908cf513215d`.

## Integration note

Integrated into `PhysicsSM/Draft/NullEdgeP9BoundaryVisibleDecomp.lean` and
imported by `PhysicsSMDraft.lean`. Verified with:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9BoundaryVisibleDecomp.lean
lake build PhysicsSM.Draft.NullEdgeP9BoundaryVisibleDecomp
lake env lean PhysicsSMDraft.lean
```
