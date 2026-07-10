# Codex proof job: reversible oscillator group law

Close every proof in `OscillatorGroup/Core.lean` without changing the step
matrix, energy, parameters, or rational control. Prove determinant one,
two-sided inverse, exact angle-addition composition, and energy conservation.
This upgrades a single conserved step to a reversible finite dynamics family.

The target is tiny and self-contained; no context pack is needed.

```yaml
aristotle:
  project_id: c1093296-8fc9-45ac-9c88-20f1b5856cd3
  target_file: OscillatorGroup/Core.lean
  expected_module: OscillatorGroup.Core
  submission_project: AgentTasks/aristotle-submit/codex-oscillator-group-law-20260710-project
  output_dir: AgentTasks/aristotle-output/c1093296-8fc9-45ac-9c88-20f1b5856cd3
  status: integrated
```
