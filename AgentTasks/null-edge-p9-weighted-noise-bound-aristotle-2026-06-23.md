# Aristotle task: P9 weighted noise bound

```yaml
aristotle:
  project_id: 9812606b-fbd9-4207-8833-3fc79a33e1bf
  target_file: NullEdgeP9WeightedNoiseBound/Core.lean
  expected_module: NullEdgeP9WeightedNoiseBound.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-weighted-noise-bound-20260623-project
  output_dir: AgentTasks/aristotle-output/9812606b-fbd9-4207-8833-3fc79a33e1bf
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: connect weighted residual-noise suppression to observer test
visibility. If test amplitudes are bounded and each cell weight is at most
`eps`, then the weighted diagonal noise response is bounded by
`T * eps * ampSqSum`.

## Submission note

Submitted as focused Aristotle project
`9812606b-fbd9-4207-8833-3fc79a33e1bf`.

## Integration note

Integrated into `PhysicsSM/Draft/NullEdgeP9WeightedNoiseBound.lean` and imported
by `PhysicsSMDraft.lean`. Verified with:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedNoiseBound.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedNoiseBound
lake env lean PhysicsSMDraft.lean
```
