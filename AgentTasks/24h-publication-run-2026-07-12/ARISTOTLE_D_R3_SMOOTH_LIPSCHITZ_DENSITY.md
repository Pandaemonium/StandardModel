# Aristotle: D-R3 smooth Lipschitz density bridge

Prove all four declarations in
`codex_24h_d_r3_smooth_lipschitz_density.lean` without changing any statement.
This closes the analytic hinge between arbitrary complex `L2(R^3)` data and
the landed compact-support Lipschitz cell sampler.

Use Mathlib's
`MeasureTheory.MemLp.exists_hasCompactSupport_integral_rpow_sub_le` or
`MeasureTheory.MemLp.exist_eLpNorm_sub_le` for density.  The hard core is the
finite-dimensional theorem that compact support plus `ContDiff` gives one
global Lipschitz constant.  The quadratic-axis control must remain and must
prove that compact support cannot simply be omitted.

```yaml
aristotle:
  project_id: f39b6a29-5fbc-4cc2-9a6f-606591339941
  task_id: 48a84b2a-5c40-4612-9904-92885229ca9f
  target_file: AgentTasks/aristotle-targets/codex_24h_d_r3_smooth_lipschitz_density.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-r3-smooth-lipschitz-density-20260711-project
  output_dir: AgentTasks/aristotle-output/f39b6a29-5fbc-4cc2-9a6f-606591339941
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Manuscript consequence: once composed with
`ChangingMomentumCellSampling.sampleFinite_tendsto_sq_error_zero`, the dense
core is no longer restricted to a fixed Lipschitz input.  This job does not yet
compose the live multiplier or identify the inverse-Fourier Dirac PDE.

Context-pack note: `make_context_pack.py` was attempted and timed out waiting
for the local semantic index.  The focused Spark API report
`SPARK_LEAN_L2_DENSITY_2026-07-11.md` was included as the documented fallback.

## Integrated result

All four submitted statements landed unchanged.  Aristotle used
`MemLp.exists_hasCompactSupport_integral_rpow_sub_le`,
`ContDiff.lipschitzWith_of_hasCompactSupport`, and an explicit `L+1` axis
witness for the noncompact quadratic control.  The extracted file and live
module both passed direct Lean; targeted build passed.

Local composition then added the correctly typed standard-smooth
`MemLp.exist_eLpNorm_sub_le` specialization and packaged an arbitrary-`L2`
compact-smooth globally Lipschitz approximant.  Uniform sampler boundedness and
the three-epsilon convergence theorem remain the next gate.
