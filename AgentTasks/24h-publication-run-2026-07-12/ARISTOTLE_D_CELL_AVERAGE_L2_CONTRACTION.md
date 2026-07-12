# Aristotle: finite cell-average `L2` contraction

Fill all six proof holes in
`codex_24h_d_cell_average_l2_contraction.lean` without changing any statement.
The target proves the analytic heart of the repaired arbitrary-`L2` route:
cellwise Cauchy/Jensen, exact finite projection energy, disjoint input-energy
decomposition, global contraction, AE-zero spike control, and nonzero constant
normalization.

Run the narrow target first. Preserve the finite-cell normalization and all
negative/nonvacuity controls. If a statement needs one missing integrability
hypothesis, report it explicitly rather than silently changing the theorem.

```yaml
aristotle:
  project_id: 9ffa5c89-bca2-405d-8398-caf2034f4d99
  task_id: 6e4d7306-407c-4aea-a9ad-83dad0eb8476
  target_file: AgentTasks/aristotle-targets/codex_24h_d_cell_average_l2_contraction.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionL2
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-cell-average-l2-contraction-20260712-project
  output_dir: AgentTasks/aristotle-output/9ffa5c89-bca2-405d-8398-caf2034f4d99
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Harvest and integration

All six statements returned unchanged, with no added integrability hypotheses,
and the candidate compiled under the repository toolchain. The proof was
landed as
`PhysicsSM/Draft/NullEdge/ChangingMomentumCellProjectionL2.lean`, including
the cellwise energy inequality, exact finite energy decompositions, global
`L2` contraction, AE-zero spike control, and nonzero constant witness.

This closes the contraction gate for the normalized finite projection. Strong
convergence under mesh refinement and live-walk composition remain separate
analytic steps.
