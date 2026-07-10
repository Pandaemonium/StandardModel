# Codex proof job: Pluecker oscillator energy conservation

Close every proof in `PluckerOscillator/Core.lean` without changing definitions,
statements, signs, coefficients, or controls. Prove exact conservation of
`p^2 + m^2 q^2` under the displayed normalized oscillator rotation, compose the
frequency-squared coefficient with an arbitrary spinor pair's Pluecker
invariant, and preserve the nontrivial rational `m=2/5`, `c=3/5`, `s=4/5`,
`(q,p)=(1,2)` witness.

This is the first conservation-law successor to the landed finite Pluecker
action/Hessian, modeled clean-room on PhysLean's harmonic-oscillator energy
conservation theorem shape. It does not derive the oscillator step, the action,
the spinor pair, physical time units, damping/interactions, or an ensemble.

Run `lake env lean PluckerOscillator/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/plucker-oscillator-conservation-20260710-20260710-030155.md`.

```yaml
aristotle:
  project_id: 52ffa150-41b6-495f-82d5-c733c478cba7
  target_file: PluckerOscillator/Core.lean
  expected_module: PluckerOscillator.Core
  submission_project: AgentTasks/aristotle-submit/codex-plucker-oscillator-conservation-20260710-project
  output_dir: AgentTasks/aristotle-output/52ffa150-41b6-495f-82d5-c733c478cba7
  status: integrated
```
