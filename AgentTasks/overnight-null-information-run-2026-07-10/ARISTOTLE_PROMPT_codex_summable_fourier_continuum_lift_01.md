# Codex proof job: summable-envelope infinite Fourier lift

Close every proof in `SummableFourier/Core.lean` without changing definitions,
statements, factors, or the geometric witness. Prove the infinite-series norm
bound under a summable nonnegative mode envelope, then prove convergence when
the relative error tends to zero. Close the geometric envelope fixture with
total sum one and nonzero first mode.

This is the next analytic rung after `FiniteFourierContinuumLift`. It gives an
infinite countable synthesis theorem under explicit summability assumptions;
it does not prove that the walk error admits such an envelope, establish an
`L2` Dirac propagator, remove a momentum cutoff, or derive a PDE.

Mathlib references from the 01:24 pass:
`tendstoUniformly_tsum`,
`MeasureTheory.hasSum_setToFun_of_dominated_convergence`, and general `tsum`
norm bounds. Use the lightest theorem shape that closes the exact statements.

Run `lake env lean SummableFourier/Core.lean`; return the complete file and any
missing summability hypothesis.

Context pack:
`AgentTasks/context-packs/summable-fourier-continuum-lift-20260710-20260710-012840.md`.

```yaml
aristotle:
  project_id: 30a9b761-a905-427f-a989-41afe9dc0a83
  target_file: SummableFourier/Core.lean
  expected_module: SummableFourier.Core
  submission_project: AgentTasks/aristotle-submit/codex-summable-fourier-continuum-lift-20260710-project
  output_dir: AgentTasks/aristotle-output/30a9b761-a905-427f-a989-41afe9dc0a83
  status: idle; harvested and integrated
```
