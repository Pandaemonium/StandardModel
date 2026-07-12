# Aristotle: point-sampler `L2` no-go and cell-average control

Prove all seven declarations in
`codex_24h_d_point_sampler_l2_nogo.lean` without changing any statement.  The
result must show that the landed center sampler cannot extend directly to an
operator on `L2` equivalence classes, because a singleton spike is zero almost
everywhere but samples to one.

The normalized `cellAverage` is the repair control: it must respect AE equality,
send the point spike to zero, and send the constant-one function to one for
positive cell size.  Use the exact half-open-cell volume theorem already in
`ChangingMomentumCellIsometry`.

```yaml
aristotle:
  project_id: 2bd9af0c-e60b-4e09-97ac-884eab04976c
  task_id: 9b1be343-b604-4d1d-b972-779d730c4892
  target_file: AgentTasks/aristotle-targets/codex_24h_d_point_sampler_l2_nogo.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-point-sampler-l2-nogo-20260711-project
  output_dir: AgentTasks/aristotle-output/2bd9af0c-e60b-4e09-97ac-884eab04976c
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Harvested 2026-07-12 00:31 PDT. Aristotle preserved all seven statements and
discharged every proof hole. Integrated as
`PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo`; direct Lean PASS.
The result proves the center sampler cannot descend to `L2` and establishes
the first normalized one-cell average controls. Finite-projection contraction
and strong convergence remain successor theorems.

Manuscript consequence: the arbitrary-`L2` extension cannot use point values;
it must replace center sampling by cell averages or another bounded projection.
This is a sharpened missing axiom/architecture result, not a failure of the
landed Lipschitz dense-core theorem.
