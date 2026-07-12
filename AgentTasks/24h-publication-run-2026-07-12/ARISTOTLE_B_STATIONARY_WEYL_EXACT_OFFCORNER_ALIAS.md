# Aristotle: exact `9-40-41` stationary-Weyl alias

Prove all seven declarations in
`codex_24h_b_stationary_weyl_exact_offcorner_alias.lean` without changing any
statement.  The target promotes the first numerical off-corner root of the
stationary-amplitude Weyl fixture to an exact Gaussian-rational witness.

The phase pair is
`z_x=(-9-40i)/41`, `z_y=(-9+40i)/41`, `z_z=1`.  Exact symbolic reduction of
the Pauli equations on `q_y=-q_x`, `q_z=0` produced the common factor
`-4c+5s+4`; together with `c^2+s^2=1`, its non-origin solution is
`c=-9/41`, `s=-40/41`.

The wrong-orientation control must remain: with `(z_x,z_x,1)`, matrix entry
`(0,1)` is exactly `-1104/1681`, so conjugate pairing is load-bearing.

```yaml
aristotle:
  project_id: 40759331-ef58-4e67-9e0f-cfa1f71009e3
  task_id: 5633e105-7eac-442c-ac08-1e5edf00c04d
  target_file: AgentTasks/aristotle-targets/codex_24h_b_stationary_weyl_exact_offcorner_alias.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-stationary-weyl-exact-offcorner-alias-20260711-project
  output_dir: AgentTasks/aristotle-output/40759331-ef58-4e67-9e0f-cfa1f71009e3
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Manuscript consequence: the explicit stationary-amplitude fixture has at least
three exact identity crossings (origin, exact corner alias, and this distinct
off-corner alias).  The complete root census and the second fully off-axis
oracle candidate remain open.

Harvested 2026-07-11 23:52 PDT. Aristotle preserved every statement and filled
all seven proof holes. The result was integrated as
`PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias`; direct
Lean verification passed with the standard draft axiom footprint.
