# Aristotle task: P9 orthogonal projector core

```yaml
aristotle:
  project_id: a0dadc4c-2ea3-4741-b96b-508a795d1e1b
  target_file: NullEdgeP9OrthogonalProjectorCore/Core.lean
  expected_module: NullEdgeP9OrthogonalProjectorCore.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-orthogonal-projector-core-20260623-project
  output_dir: AgentTasks/aristotle-output/a0dadc4c-2ea3-4741-b96b-508a795d1e1b
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: strengthen the P9 source-visibility algebra by proving that a
finite self-adjoint idempotent projector makes the residual `source - Pi source`
invisible to harmonic tests. This is the abstract finite algebra that an
explicit diamond Hodge projector should later instantiate.

## Local preflight

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-orthogonal-projector-core-20260623/NullEdgeP9OrthogonalProjectorCore/Core.lean
```

The target typechecks with only the intended proof-hole warnings.

## Submission note

Submitted as focused Aristotle project
`a0dadc4c-2ea3-4741-b96b-508a795d1e1b`.

## Integration note

Integrated into `PhysicsSM/Draft/NullEdgeP9OrthogonalProjectorCore.lean` and
imported by `PhysicsSMDraft.lean`. Verified with:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9OrthogonalProjectorCore.lean
lake build PhysicsSM.Draft.NullEdgeP9OrthogonalProjectorCore
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9OrthogonalProjectorCore.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9OrthogonalProjectorCore.lean
```
