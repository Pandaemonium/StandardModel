# Codex proof job: D4 null rays to explicit spinor decorations

Close every proof in `D4Spinor/Core.lean` without changing the six roots,
projective scales, spinors, Pauli convention, metric signature, statements, or
control. Prove that all six future axial D4 null rays have the displayed
Gaussian-integer rank-one spinor factorization, with positive scale, and that
the `+x` and `+y` spinors have nonzero wedge.

This is the first explicit arrow from selected primitive D4 null directions to
the spinor decorations used by the Gram/Pluecker mass layer. It does not derive
the time-axis selection, choose amplitudes or gates, prove Lorentz covariance
of the finite alphabet, or cover arbitrary continuum null directions.

PhysLean references from the 01:24 pass: `PauliMatrix.pauliMatrix`,
`PauliMatrix.pauliBasis`, and Pauli Lorentz-tensor declarations. Use their
conventions as checks only; keep this file Mathlib-only and clean-room.

Run `lake env lean D4Spinor/Core.lean`; return the complete file and any Pauli
sign/normalization mismatch.

Context pack:
`AgentTasks/context-packs/d4-null-ray-spinor-factorization-20260710-20260710-012840.md`.

```yaml
aristotle:
  project_id: a7666500-fdf4-4b4a-9872-4325eb958ae7
  target_file: D4Spinor/Core.lean
  expected_module: D4Spinor.Core
  submission_project: AgentTasks/aristotle-submit/codex-d4-null-ray-spinor-factorization-20260710-project
  output_dir: AgentTasks/aristotle-output/a7666500-fdf4-4b4a-9872-4325eb958ae7
  status: running
```
