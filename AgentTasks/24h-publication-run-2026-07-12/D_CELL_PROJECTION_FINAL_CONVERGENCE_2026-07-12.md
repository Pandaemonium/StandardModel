# Gate D final cell-projection convergence

## Objective

Close the final two exact theorem statements in
`AgentTasks/aristotle-targets/codex_24h_d_cell_projection_final_convergence.lean`.
The target composes the landed compact-support geometry and exact three-term
estimate into arbitrary-`L2(R^3)` strong convergence for the explicit Gate D
cell-average projections.

## Semantic boundaries

- This is representative-safe cell-average projection convergence.
- It does not identify projection coefficients with the live walk's evolved
  mode coefficients.
- It does not perform inverse Fourier transport or prove a position-space
  Dirac PDE limit.
- The complete scheduled box has unbounded volume; only active-cell volume is
  uniformly localized.

## Landed inputs

- `ChangingMomentumCellProjectionStrongScaffold`
- `ChangingMomentumCellProjectionGeometry`
- `ChangingMomentumCellProjectionThreeTerm`

## Aristotle metadata

```yaml
aristotle:
  project_id: b7405f03-7bf4-47c2-9b3a-71ce9040df3f
  task_id: c1bc10b3-55d2-496c-bd44-306cdc73bec4
  reproducer_task_id: b85a9613-d45b-463e-a984-ea3d0f2af4ad
  target_file: AgentTasks/aristotle-targets/codex_24h_d_cell_projection_final_convergence.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionFinalConvergence
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-cell-projection-final-20260712-project
  output_dir: AgentTasks/aristotle-output/b7405f03-7bf4-47c2-9b3a-71ce9040df3f
  status: integrated-after-independent-replay
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Final-run snapshot audit: both requested theorems retain their original proof
holes (`compact_lipschitz_projectAt_tendsto_sq_error_zero` and
`projectAt_tendsto_strong_L2`). No result has been integrated or claimed. The
landed D result remains the geometry, contraction, and quantitative three-term
machinery only. Snapshot:
`AgentTasks/aristotle-output/b7405f03-7bf4-47c2-9b3a-71ce9040df3f/final-snapshot.zip`.

AFPL disposition (2026-07-12): a fresh snapshot still contained both original
proof holes. Codex factored the missing active-cell glue and density transfer,
then landed the exact statements without weakening as
`ChangingMomentumCellProjectionCompactCore` and
`ChangingMomentumCellProjectionStrongL2`. Direct Lean checks, targeted builds,
and the aggregate axiom guard pass. Aristotle task `c1bc10b3` was canceled
after snapshot preservation under the two-hour stall rule. Claude-family
semantic audit then co-signed the exact scope. Fresh Aristotle task `b85a9613`
independently replayed both narrow Lean checks and the guarded standard axiom
footprints. Its returned files are SHA-256 identical to the live modules:

- Compact core: `0b6e5b2b4f48445ff2ebe1376a54cc880622fabfbd62cb0e840ad2962d773ccd`
- Strong L2 transfer: `3870c5ebedfef13835b93de24dd5292509eee09bdf19102b68f1ff6e07f4a352`

The full repository build also passed with 8,319 jobs. AFPL work item
`CONT-PROJ-001` is integrated at grade M / SRL 5.

## Overclaim audit

- Vacuity: pass; compact smooth and arbitrary `L2` witnesses exist.
- Hollow telescoping: pass; active-cell localization is load-bearing.
- Docstring outruns kernel: pass; the landed modules state projection
  convergence and explicitly disclaim live-walk and PDE convergence.
- False shape: pass; the conclusion is the global squared `L2` error for the
  concrete schedule.
