# Aristotle: finite center phase as an additive-character kernel

Run lane: Jordan-Clifford JC5 successor. Owner: Codex.

Close every declaration in
`AgentTasks/aristotle-targets/codex_24h_jc5_finite_phase_character.lean`
without changing statements. The hostile audit correctly observed that the
landed finite object was a phase-triviality set, not formally the kernel of a
homomorphism. This target packages the phase as an additive homomorphism from
`Fin 3 x Fin 2 x Fin 6` to sixth-root exponents on every actual even five-mode
occupation and proves its kernel is exactly the six standard powers.

The source theorem `evenFockCentralKernel_eq_standardPowers` and the unique
trusted covering-family witness are already landed. Use finite extensionality
and kernel `decide` where appropriate, but no compiled evaluation. Preserve the
even-occupation subtype; it is load-bearing. Do not upgrade the result to a
complex Lie-group representation or claim the full covering-group action has
been transported.

Witness: `(1,1,1)` has zero character. Mixed control: `(1,0,1)` does not.

```yaml
aristotle:
  project_id: a0eeda90-1207-4cbd-8d02-3a8748866ce5
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_24h_jc5_finite_phase_character.lean
  expected_module: none-handoff
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc5-finite-phase-character-20260711-project
  output_dir: AgentTasks/aristotle-output/a0eeda90-1207-4cbd-8d02-3a8748866ce5
  status: submitted
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
