# Aristotle: exact phase-minus-one boundary census

Fill all nine proof holes in
`codex_24h_b_stationary_weyl_boundary_census.lean` without changing any
statement. The first eight statements are finite/rational chart theorems. The
ninth upgrades them using the exact real tangent parametrization of every unit
complex phase other than `-1`.

Use the exact numerator equations and Groebner verdicts in
`B_STATIONARY_WEYL_TANGENT_BOUNDARY_ORACLE_2026-07-12.md`. Work against the
imported live `weylStep`; do not introduce a copied fixture. If the capstone
blocks, return all eight chart theorems plus the precise tangent-surjectivity
lemma still needed. Do not weaken any chart statement.

```yaml
aristotle:
  project_id: 02983c7d-af9e-442d-b12e-54f8964fa902
  task_id: 495d4873-51a3-430c-9f44-24831e55ced7
  target_file: AgentTasks/aristotle-targets/codex_24h_b_stationary_weyl_boundary_census.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylBoundaryCensus
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-stationary-weyl-boundary-census3-20260712-project
  output_dir: AgentTasks/aristotle-output/02983c7d-af9e-442d-b12e-54f8964fa902
  status: canceled-after-two-hour-stall-partial-harvest
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Partial harvest: exact tangent surjectivity, explicit `-1` axis walks,
`no_xy_boundary_identity`, `no_yz_boundary_identity`,
`all_neg_one_not_identity`, and `weylStep_neg_one_one_neg_one` were recovered,
verified locally, and promoted to
`StationaryAmplitudeWeylBoundaryScaffold.lean`. The three single-boundary
exclusions and the `xz` iff were resubmitted separately; the unit-circle
capstone will compose them after landing.
