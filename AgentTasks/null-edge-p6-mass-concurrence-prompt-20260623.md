# Aristotle focused job: concurrence and mass-determinant relation

```yaml
job_name: null-edge-p6-mass-concurrence-20260623
status: integrated
project_id: f8caf89b-6245-489d-b5b3-ae3e0a9ebf80
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p6-mass-concurrence
prepared_project: AgentTasks/aristotle-submit/null-edge-p6-mass-concurrence-project
target_module: NullEdgeP6MassConcurrence.Core
target_file: NullEdgeP6MassConcurrence/Core.lean
expected_check: lake env lean NullEdgeP6MassConcurrence/Core.lean
```

## Task

Prove `concurrence_sq_eq_four_mul_det` in `NullEdgeP6MassConcurrence/Core.lean` without changing the definitions or the theorem statement.

```lean
theorem concurrence_sq_eq_four_mul_det (a b c d : Real) :
    concurrence a b c d ^ 2 = 4 * (rho a b c d).det := by
```

This theorem connects the Wootters entanglement concurrence of a two-qubit pure state to the determinant of the visible reduced density matrix, providing the exact algebraic spine for the P6 concurrence/mass-ratio interpretation.

## Constraints

- Do not weaken or rename the theorem.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP6MassConcurrence/Core.lean
```

## Completion report requested

Please end with a brief report listing:
- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.
