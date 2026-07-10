# Codex proof job: discrete Pluecker variational flow

Close every proof in `DiscretePluckerFlow/Core.lean` without changing the
Lagrangian, Euler-Lagrange residual, recurrence, first integral, coefficients,
or controls. Prove that the displayed discrete action selects the recurrence,
that the resulting finite evolution satisfies the EOM and exactly conserves
the quadratic first integral, and that the `mu=4/25` witness is nontrivial.

The two `HasDerivAt` theorems must genuinely differentiate the adjacent link
actions, and `euler_lagrange_eq_adjacent_variations` must compose those exact
coefficients. The wrong-sign control must remain a genuine failure.

The target is tiny and self-contained; no context pack is needed.

```yaml
aristotle:
  project_id: 535b0922-8096-431f-84e6-7b928aa30810
  target_file: DiscretePluckerFlow/Core.lean
  expected_module: DiscretePluckerFlow.Core
  submission_project: AgentTasks/aristotle-submit/codex-discrete-plucker-variational-flow-20260710-project
  output_dir: AgentTasks/aristotle-output/535b0922-8096-431f-84e6-7b928aa30810
  status: integrated-from-running-snapshot
```
