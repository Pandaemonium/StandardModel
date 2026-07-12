# Gate B quintic-fibre and finite-chart census

## Objective

Prove the exact uniqueness of the two reconstructed tangent coordinates over
the stationary-Weyl quintic branch, then compose the already landed live bridge,
elimination capstone, zero-coordinate slice, and excluded-sextic positivity into
a complete identity-crossing census on the finite real tangent chart.

Target:
`AgentTasks/aristotle-targets/codex_24h_b_quintic_fiber_census.lean`.

The theorem statements and all imported conventions are frozen. The hard core
is `quintic_fiber_unique`; downstream theorems are composition and nonvacuity
controls. Exact SymPy 1.14 arithmetic gives the reduced lexicographic basis
recorded in the target docstring. No floating-point evidence is used.

```yaml
aristotle:
  project_id: 8673372d-92c5-4f00-aeb8-83a4cb4513fd
  task_id: f2fb6b01-06e6-4d59-aff7-2d8ab6af016e
  target_file: AgentTasks/aristotle-targets/codex_24h_b_quintic_fiber_census.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylQuinticFiberCensus
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-quintic-fiber-census-20260712-project
  output_dir: AgentTasks/aristotle-output/8673372d-92c5-4f00-aeb8-83a4cb4513fd
  status: landed-and-guarded
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Harvest: `quintic_fiber_unique`, `live_identity_finite_chart_census`, and the
fully off-axis nonvacuity witness were preserved exactly and proved with the
standard axiom footprint. Direct Lean and targeted module build pass. The
result is exhaustive on the finite real tangent chart; the seven phase-minus-
one boundary strata remain a separate formal gate.
