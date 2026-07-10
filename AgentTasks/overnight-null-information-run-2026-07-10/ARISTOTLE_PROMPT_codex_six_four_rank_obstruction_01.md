# Codex proof job: six D4 channels versus four Dirac components

Close every proof in `SixFour/Core.lean` without changing definitions or
statements. Prove the exact finite-rank obstruction: a six-channel D4 direction
coin space cannot be directly identified with a four-component Dirac spinor by
an invertible complex-linear map, and the rank gap is exactly two.

This is a required no-go control for the running finite D4 walk. A successful
proof forces the next architecture to use a constrained invariant subspace,
partial isometry plus two ancillary/gauge channels, or successive two-state axis
walks; it prevents prose from silently equating six directions with four spinor
components.

Do not claim this rules out every D4-to-Dirac construction. It rules out only a
direct linear equivalence of the full spaces.

Run `lake env lean SixFour/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/six-four-rank-obstruction-20260710-20260710-023352.md`.

```yaml
aristotle:
  project_id: c02c2e61-2300-4dae-a072-98db92940a67
  target_file: SixFour/Core.lean
  expected_module: SixFour.Core
  submission_project: AgentTasks/aristotle-submit/codex-six-four-rank-obstruction-20260710-project
  output_dir: AgentTasks/aristotle-output/c02c2e61-2300-4dae-a072-98db92940a67
  status: idle; harvested and integrated
```
