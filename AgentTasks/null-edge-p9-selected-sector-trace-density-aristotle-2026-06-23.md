# Aristotle focused job: P9 selected-sector trace density

```yaml
job_name: null-edge-p9-selected-sector-trace-density-20260623
status: integrated
project_id: 28e0de6b-bf59-4e3e-ac0c-4c1a92669e3c
task_id: 4aa6de33-bd9c-407f-9395-9e16092a067c
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-selected-sector-trace-density-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-selected-sector-trace-density-20260623-project
target_module: NullEdgeP9SelectedSectorTraceDensity.Core
target_file: NullEdgeP9SelectedSectorTraceDensity/Core.lean
expected_check: lake env lean NullEdgeP9SelectedSectorTraceDensity/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9SelectedSectorTraceDensity/Core.lean` without
changing definitions or theorem statements.

Scientific target: this is the finite algebra behind the P9 area-vs-volume
gate. If a visible/projected sector contains only `k` Boolean-selected
coordinate modes out of `n`, then the coordinate trace is `k`, the trace
density is `k/n`, and a boundary-size bound on `k` gives the corresponding
density bound.

## Targets

```lean
selectedProjector_basis_diag_mem
selectedProjector_basis_diag_not_mem
selectedProjector_trace_eq_count
selectedProjector_trace_density_eq_count_div
selectedProjector_trace_density_le_boundary_div
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9SelectedSectorTraceDensity/Core.lean
```

## Proof sketch

The diagonal of `selectedProjector sel` on the coordinate basis is the Boolean
indicator `sel`. Summing indicators over `Fin n` gives `selectedCount sel`. The
density theorem follows by division, and the boundary inequality follows by
casting `selectedCount sel <= boundary` to `Real` and dividing by the positive
real number `n`.

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission note

Staged and submitted on 2026-06-23.

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-selected-sector-trace-density-20260623/NullEdgeP9SelectedSectorTraceDensity/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-selected-sector-trace-density-20260623-project/NullEdgeP9SelectedSectorTraceDensity/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-selected-sector-trace-density-20260623/NullEdgeP9SelectedSectorTraceDensity/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-selected-sector-trace-density-20260623/NullEdgeP9SelectedSectorTraceDensity/Core.lean AgentTasks/null-edge-p9-selected-sector-trace-density-aristotle-2026-06-23.md
```

The Lean preflight found exactly the five intended proof-hole warnings and no
other errors. Non-ASCII scan was clean. The focused package helper reported
five proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

Submitted as Aristotle project `28e0de6b-bf59-4e3e-ac0c-4c1a92669e3c`, task
`4aa6de33-bd9c-407f-9395-9e16092a067c`.

## Completion and integration

Aristotle completed all five targets with no statement or definition changes,
no remaining proof holes, and no added assumptions or nonstandard constructs.
The integration helper hit an archive extraction issue on the task-note path,
so the target file was reviewed manually by diffing the returned
`NullEdgeP9SelectedSectorTraceDensity/Core.lean` against the staged source.

Integrated live module:

```text
PhysicsSM.Draft.NullEdgeP9SelectedSectorTraceDensity
```

Live verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9SelectedSectorTraceDensity.lean
lake build PhysicsSM.Draft.NullEdgeP9SelectedSectorTraceDensity
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9SelectedSectorTraceDensity.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9SelectedSectorTraceDensity.lean
```

All targeted checks passed. The integrated proof uses ASCII Lean syntax.
