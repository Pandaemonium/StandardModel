# Codex proof job: full-window discrete-flow stability

The earlier stability proofs in `DiscreteFlowStability/Core.lean` are complete.
Close only the four remaining handoff proofs without changing their statements.

Use
`stabilityCoefficient mu = min(mu,4-mu)/2` and the weighted-square
decomposition to prove a positive coordinate bound on the full elliptic window
`0 < mu < 4`, then transport it to every iterate by exact conservation. The
`mu=3` witness must close the real gap beyond the previous `mu<=2` theorem;
retain `mu=5` as the indefinite failure control.

This is finite Lyapunov stability for the selected recurrence. It does not
derive the action, interactions, or a continuum field limit. Run
`lake env lean DiscreteFlowStability/Core.lean`.

```yaml
aristotle:
  project_id: deaaa176-f9a0-4818-b53d-b4ccabf0879c
  target_file: DiscreteFlowStability/Core.lean
  expected_module: DiscreteFlowStability.Core
  submission_project: AgentTasks/aristotle-submit/codex-discrete-flow-full-window-20260710-project
  output_dir: AgentTasks/aristotle-output/deaaa176-f9a0-4818-b53d-b4ccabf0879c
  status: idle; harvested and integrated
```
