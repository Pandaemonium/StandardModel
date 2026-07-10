# Codex proof job: explicit countable geometric-mode convergence

Close every proof in `GeometricModes/Core.lean` without changing definitions,
statements, normalization, or the nonsummable control. Prove the exact
normalized geometric `tsum`, the nonzero synthesis formula
`synthesis n = 1/(n+1)`, norm/topological convergence to zero, and failure of a
constant envelope.

This instantiates the landed generic countable Fourier bound on an exact
infinite-mode family, so the theorem is not only an abstract implication. It is
still an enumerated mode model, not an infinite-volume Dirac PDE or a derivation
of the checkerboard walk's physical momentum envelope.

Run `lake env lean GeometricModes/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/geometric-mode-continuum-20260710-20260710-023403.md`.

```yaml
aristotle:
  project_id: 0a050dc1-051d-412b-8a86-3b061e3acaa4
  target_file: GeometricModes/Core.lean
  expected_module: GeometricModes.Core
  submission_project: AgentTasks/aristotle-submit/codex-geometric-mode-continuum-20260710-project
  output_dir: AgentTasks/aristotle-output/0a050dc1-051d-412b-8a86-3b061e3acaa4
  status: idle; harvested and integrated
```
