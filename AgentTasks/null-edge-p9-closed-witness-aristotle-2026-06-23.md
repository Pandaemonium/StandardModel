# Aristotle task: P9 closed-test witness

```yaml
aristotle:
  project_id: 24bc10a1-69f5-4402-aca1-7d703ea6c0ae
  target_file: NullEdgeP9ClosedWitness/Core.lean
  expected_module: NullEdgeP9ClosedWitness.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-closed-witness-20260623-project
  output_dir: AgentTasks/aristotle-output/24bc10a1-69f5-4402-aca1-7d703ea6c0ae
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: prove the finite witness direction of the P9
source-visibility API. A closed bulk test with nonzero source pairing certifies
bulk visibility and rules out boundary-exact bookkeeping in this finite model.

## Submission note

Submitted as focused Aristotle project
`24bc10a1-69f5-4402-aca1-7d703ea6c0ae`.

## Integration note

Integrated into `PhysicsSM/Draft/NullEdgeP9ClosedWitness.lean` and imported by
`PhysicsSMDraft.lean`. Verified with:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9ClosedWitness.lean
lake build PhysicsSM.Draft.NullEdgeP9ClosedWitness
lake env lean PhysicsSMDraft.lean
```
