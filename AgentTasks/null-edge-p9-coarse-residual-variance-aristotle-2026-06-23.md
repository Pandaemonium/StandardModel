# Aristotle task: P9 coarse residual-variance identity

```yaml
aristotle:
  project_id: 5626ed17-206a-4c75-8073-a1aec026a458
  target_file: NullEdgeP9CoarseResidualVariance/Core.lean
  expected_module: NullEdgeP9CoarseResidualVariance
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-coarse-residual-variance-20260623-project
  output_dir: AgentTasks/aristotle-output/5626ed17-206a-4c75-8073-a1aec026a458
  status: integrated
  integrated_file: PhysicsSM/Draft/NullEdgeP9CoarseResidualVariance.lean
  integrated_module: PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance
```

Focused standalone proof job.

Scientific role: prove a finite coarse-graining identity for the P9 residual
noise branch. A block map from fine cells to coarse cells should preserve total
residual variance when coarse block variance is defined as the sum of fine
variances in the block. This gives the corrected discrete-first P9 gate a small
formal spine: stable large-scale statistics should be defined by explicit
coarse-graining maps.

## Submission note

Submitted as Aristotle project `5626ed17-206a-4c75-8073-a1aec026a458`.

## Integration note

Integrated on 2026-06-23 as
`PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance`.

The integrated theorems are:

- `blockVariance_nonneg`
- `coarseVariance_eq_amplitudeSqSum`
- `coarseVariance_density_eq_amplitudeSqSum_div_scale`

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9CoarseResidualVariance.lean
lake build PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9CoarseResidualVariance.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9CoarseResidualVariance.lean
```

All targeted checks passed. The first umbrella import attempt timed out at
180 seconds; rerunning with a longer timeout passed.
