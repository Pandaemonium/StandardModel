# Codex proof job: finite Fourier lift of uniform walk convergence

Close every proof in `FiniteFourier/Core.lean` without changing definitions,
statements, coefficients, or the two-mode fixture. Prove the explicit
cardinality-factor norm bound and the resulting convergence theorem from a
uniform `D/n` modewise estimate on a fixed finite momentum grid.

This is the exact next rung after `BoundedMomentumManyStepContinuum`: it lifts
bounded-symbol convergence to finite position-space Fourier synthesis. It is
not an infinite-volume inverse Fourier theorem, an `L2` continuum propagator,
or a Dirac PDE theorem.

Mathlib reference declarations found in the 00:35 pass:
`FourierTransform.fourier_sum`,
`SchwartzMap.norm_fourier_toBoundedContinuousFunction_le_toLp_one`, and
`Fourier.norm_fourierIntegral_le_integral_norm`. Use their theorem shapes as
help, but keep this target finite and Mathlib-only.

Run `lake env lean FiniteFourier/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/finite-fourier-continuum-lift-20260710-20260710-003855.md`.

```yaml
aristotle:
  project_id: 92331c27-1f0a-40c3-824e-28c432756f8e
  target_file: FiniteFourier/Core.lean
  expected_module: FiniteFourier.Core
  submission_project: AgentTasks/aristotle-submit/codex-finite-fourier-continuum-lift-20260710-project
  output_dir: AgentTasks/aristotle-output/92331c27-1f0a-40c3-824e-28c432756f8e
  status: running
```
