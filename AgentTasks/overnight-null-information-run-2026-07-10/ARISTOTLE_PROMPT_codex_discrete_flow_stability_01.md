# Codex proof job: stability of the discrete Pluecker flow

Close every proof in `DiscreteFlowStability/Core.lean` without changing the
recurrence, first integral, parameter intervals, iterate statement, or controls.
Prove the sum-of-squares decomposition, positive definiteness for `0 < mu < 4`,
exact conservation for every iterate, and the explicit coordinate bound for
`0 < mu <= 2`. Keep `mu=4/25` as the nonzero stable witness and `mu=5`,
`(1,-1)` as the outside-stability negative control.

This supplies the stability theorem needed after the adjacent-link variational
flow lands. It does not derive the finite action from primitive data.

```yaml
aristotle:
  project_id: 04affe6e-0743-465f-bd70-179795f8f827
  target_file: DiscreteFlowStability/Core.lean
  expected_module: DiscreteFlowStability.Core
  submission_project: AgentTasks/aristotle-submit/codex-discrete-flow-stability-20260710-project
  output_dir: AgentTasks/aristotle-output/04affe6e-0743-465f-bd70-179795f8f827
  status: idle; harvested and integrated
```
