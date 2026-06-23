# Aristotle focused job: P9 two-cell trace separation

```yaml
job_name: null-edge-p9-two-cell-trace-separation-20260623
status: integrated
project_id: 99cd5c39-15f2-445c-a065-2e7a05555ea8
task_id: 6c7310c0-9ea8-4345-81aa-b8a6a0219985
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-two-cell-trace-separation-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-two-cell-trace-separation-20260623-project
target_module: NullEdgeP9TwoCellTraceSeparation.Core
target_file: NullEdgeP9TwoCellTraceSeparation/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9TwoCellTraceSeparation
integrated_file: PhysicsSM/Draft/NullEdgeP9TwoCellTraceSeparation.lean
expected_check: lake env lean NullEdgeP9TwoCellTraceSeparation/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9TwoCellTraceSeparation/Core.lean` without
changing definitions or theorem statements.

This is a small non-vacuity theorem for the C4 P9 route. It proves that a fixed
two-cell coarse readout can distinguish two explicit diagonal kernels, so the
trace statistic can move when the finite kernel weights move.

## Targets

```lean
trace_diagonalKernel2
identityR2_coarse_diagonal_trace
two_cell_trace_separates
two_cell_trace_strict_mono
```

## Constraints

- Do not weaken, rename, or restate the theorems.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9TwoCellTraceSeparation/Core.lean
```

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Integration

Integrated on 2026-06-23 into
`PhysicsSM.Draft.NullEdgeP9TwoCellTraceSeparation`.

Aristotle reported all four targets solved, with no statement or definition
changes and no remaining proof holes. Statement-identity review against the
staged standalone source showed only proof-body changes.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9TwoCellTraceSeparation.lean
lake build PhysicsSM.Draft.NullEdgeP9TwoCellTraceSeparation
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9TwoCellTraceSeparation.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9TwoCellTraceSeparation.lean
```

The targeted file check, module build, draft-root import check, placeholder
scan, and non-ASCII scan passed.
