# Aristotle task: P9 projected noise-kernel positivity

```yaml
aristotle:
  project_id: 914a99b2-b1b7-4721-9cf0-c7f50558bd39
  target_file: NullEdgeP9ProjectedNoiseKernel/Core.lean
  expected_module: NullEdgeP9ProjectedNoiseKernel.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-projected-noise-kernel-20260623-project
  output_dir: AgentTasks/aristotle-output/914a99b2-b1b7-4721-9cf0-c7f50558bd39
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: prove the finite algebra that projecting the observer/noise
kernel preserves positive-semidefinite response. This is the first bridge from
generic finite noise positivity to a projected harmonic/source-visible channel.

## Submission note

Submitted as focused Aristotle project
`914a99b2-b1b7-4721-9cf0-c7f50558bd39`.

## Integration note

Integrated into `PhysicsSM/Draft/NullEdgeP9ProjectedNoiseKernel.lean` and
imported by `PhysicsSMDraft.lean`. Verified with:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9ProjectedNoiseKernel.lean
lake build PhysicsSM.Draft.NullEdgeP9ProjectedNoiseKernel
lake env lean PhysicsSMDraft.lean
```
