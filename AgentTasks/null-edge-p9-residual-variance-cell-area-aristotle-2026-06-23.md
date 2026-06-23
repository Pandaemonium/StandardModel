# Aristotle Task: P9 Residual Variance Cell Area Scaling

This is a proof-completion job for the P9 residual variance scaling theorem.

```yaml
aristotle:
  project_id: ce4d21d4-0b8d-4344-977c-db3bee6bd950
  task_id: b04f8ddf-ea0d-42e8-a2cd-fcaaec504a60
  target_file: NullEdgeP9ResidualVarianceCellArea/Core.lean
  expected_module: NullEdgeP9ResidualVarianceCellArea.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-residual-variance-cell-area-20260623-project
  output_dir: AgentTasks/aristotle-output/ce4d21d4-0b8d-4344-977c-db3bee6bd950
  status: submitted
```

## Context

Prove that the sum of squared weights is bounded by the maximum weight times the total sum of weights.
This is the algebraic core of the theorem showing that diamond residual variance scales with cell area.

## Target

Solve:
```lean
theorem weightSqSum_le_maxWeight_mul_weightSum {N : Nat} (w : Fin N -> Real)
    (hnonneg : ∀ i, 0 ≤ w i)
```
in `NullEdgeP9ResidualVarianceCellArea/Core.lean`.
