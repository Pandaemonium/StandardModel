# Aristotle task: P4 visible determinant invariant

```yaml
aristotle:
  project_id: 5b9efeba-acde-470a-9b66-812acb8f488e
  target_file: NullEdgeP4VisibleDetInvariant/Core.lean
  expected_module: NullEdgeP4VisibleDetInvariant.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p4-visible-det-invariant-20260623-project
  output_dir: AgentTasks/aristotle-output/5b9efeba-acde-470a-9b66-812acb8f488e
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: prove the finite invariant bridge demanded by the sharpened
P4 conjecture: the unnormalized visible determinant is invariant under
determinant-one visible boosts, while trace-normalized determinant formulas are
frame-normalized readouts.

## Submission note

Submitted as focused Aristotle project
`5b9efeba-acde-470a-9b66-812acb8f488e`.

## Integration note

Integrated as `PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP4VisibleDetInvariant.lean
lake build PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP4VisibleDetInvariant.lean
```

The theorem statements were unchanged relative to the focused package. The
placeholder scan was clean.
