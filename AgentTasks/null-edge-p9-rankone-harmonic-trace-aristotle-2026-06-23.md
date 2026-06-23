# Aristotle focused job: P9 rank-one harmonic trace toy model

```yaml
job_name: null-edge-p9-rankone-harmonic-trace-20260623
status: integrated
project_id: a775c905-af53-4cba-8b49-81d5822fdc10
task_id: 7b2b43ad-55dd-4f36-9a30-270b746ffbba
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-rankone-harmonic-trace-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-rankone-harmonic-trace-20260623-project
target_module: NullEdgeP9RankOneHarmonicTrace.Core
target_file: NullEdgeP9RankOneHarmonicTrace/Core.lean
expected_check: lake env lean NullEdgeP9RankOneHarmonicTrace/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9RankOneHarmonicTrace
integrated_file: PhysicsSM/Draft/NullEdgeP9RankOneHarmonicTrace.lean
```

## Task

Fill the proof holes in
`NullEdgeP9RankOneHarmonicTrace/Core.lean` without changing the definitions or
the theorem statements.

The target formalizes a toy finite P9 observation: the rank-one mean projector
onto constant 1-cochains has coordinate trace `1`, hence trace density
`1 / n`. This is the algebraic version of the cycle-pilot signal that a
harmonic-channel trace can stay `O(1)` while the number of cells grows.

## Targets

```lean
meanProjector_basis_diag
meanProjector_trace_eq_one
meanProjector_trace_density
```

## Constraints

- Do not weaken, rename, or restate the theorems.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9RankOneHarmonicTrace/Core.lean
```

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Integration note

Integrated on 2026-06-23 as
`PhysicsSM.Draft.NullEdgeP9RankOneHarmonicTrace`.

The integrated theorems are:

- `meanProjector_basis_diag`
- `meanProjector_trace_eq_one`
- `meanProjector_trace_density`

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9RankOneHarmonicTrace.lean
lake build PhysicsSM.Draft.NullEdgeP9RankOneHarmonicTrace
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9RankOneHarmonicTrace.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9RankOneHarmonicTrace.lean
```

All targeted checks passed. One Unicode not-equal symbol in the returned proof
was converted to ASCII `Not (...)`. The first umbrella import check raced the
targeted build and failed before the `.olean` existed; rerunning after the
targeted build passed.
