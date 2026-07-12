# Aristotle task: exact changing-spacing R3 momentum-cell isometry

Status: landed locally; submitted task canceled because its packaged initial
cell definition used product-order `Set.Ico`, which kernel checking exposed as
the wrong set. The landed source uses the corrected coordinatewise product of
scalar half-open intervals.

Target:
`AgentTasks/aristotle-targets/codex_24h_d_r3_cell_isometry.lean`.

Run the target first and close every proof hole without weakening statements or
adding assumptions. This is a Mathlib-only finite-support theorem. It defines
half-open momentum cells of side length `h > 0`, the reciprocal-square-root
cell normalization, and a piecewise-constant embedding of finite `Z^3`
coefficient families into functions on `R^3`.

Required payload:

- exact cell volume `h^3`;
- exact disjointness for distinct integer labels;
- normalized one-cell squared-norm integral;
- unnormalized wrong-scaling control with factor `h^3`;
- exact finite-support isometry;
- the explicit nonzero one-cell witness.

Scope: no walk dynamics, Fourier transform, PDE generator, or continuum limit.
Do not replace actual Lebesgue integrals with a discrete proxy.

```yaml
aristotle:
  project_id: 9e72caad-393c-4f5d-8f46-d007d50f0ea9
  target_file: codex_24h_d_r3_cell_isometry.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChangingMomentumCellIsometry
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-r3-cell-isometry-20260711-project
  output_dir: AgentTasks/aristotle-output/9e72caad-393c-4f5d-8f46-d007d50f0ea9
  task_id: 42ddd20a-f879-4416-948b-520b90315bfb
  status: canceled after corrected local landing
```
