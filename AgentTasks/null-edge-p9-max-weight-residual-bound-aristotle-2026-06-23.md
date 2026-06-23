# Aristotle task: P9 max-weight residual bound

```yaml
aristotle:
  project_id: 043ce3f9-580d-4a65-a817-cdbb156ed28f
  target_file: NullEdgeP9MaxWeightResidualBound/Core.lean
  expected_module: NullEdgeP9MaxWeightResidualBound.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-max-weight-residual-bound-20260623-project
  output_dir: AgentTasks/aristotle-output/043ce3f9-580d-4a65-a817-cdbb156ed28f
  status: integrated
```

Prove `weightSqSum_le_eps_mul_weightSum` without changing definitions or theorem
statements. This is the reusable residual-noise bound: if every cell weight is
at most `eps`, the squared-weight sum is at most `eps` times total weight.
