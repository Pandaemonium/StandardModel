# Aristotle focused job: P9 weighted projector residual orthogonality

```yaml
job_name: null-edge-p9-weighted-projector-residual-orthogonal-20260623
status: integrated
project_id: d9318fe9-73b3-4e86-9553-95cbf3b4cc9b
task_id: 4024001a-7719-4981-a2f3-68d89a814945
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-weighted-projector-residual-orthogonal-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-weighted-projector-residual-orthogonal-20260623-project
target_module: NullEdgeP9WeightedProjectorResidualOrthogonal.Core
target_file: NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean
expected_check: lake env lean NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean
```

## Task

Fill the proof holes in
`NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean` without changing
definitions or theorem statements.

Scientific target: Aristotle's P9 intrinsic coarse-map strategy recommends
spectral Hodge coarse modes as the most publishable first route. This target
adds the weighted projector decomposition law needed for that route: a weighted
self-adjoint idempotent projector makes residual source components invisible to
projected/coarse tests.

## Targets

```lean
weighted_projected_pairing_eq
weighted_residual_orthogonal_to_projected
weighted_projected_test_pairing_decomposition
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean
```

## Proof sketch

Use weighted self-adjointness with `test := lin Pi test`, then use idempotence
to rewrite `lin Pi (lin Pi test)` as `lin Pi test`. The residual theorem follows
by expanding `subCochain` and using the projected-pairing equality. The
decomposition theorem follows by the residual theorem.

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission

Submitted 2026-06-23 as Aristotle project
`d9318fe9-73b3-4e86-9553-95cbf3b4cc9b`, task
`4024001a-7719-4981-a2f3-68d89a814945`.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-weighted-projector-residual-orthogonal-20260623/NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-weighted-projector-residual-orthogonal-20260623-project/NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-weighted-projector-residual-orthogonal-20260623/NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean AgentTasks/null-edge-p9-weighted-projector-residual-orthogonal-aristotle-2026-06-23.md
rg -n "\b(admit|axiom|opaque|unsafe\s+def|native_decide)\b" AgentTasks/aristotle-standalone/null-edge-p9-weighted-projector-residual-orthogonal-20260623/NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean
```

Both Lean preflight checks passed with exactly the three intended proof-hole
warnings. The non-ASCII and escape-hatch scans were clean.

## Integration

Integrated into
`PhysicsSM/Draft/NullEdgeP9WeightedProjectorResidualOrthogonal.lean` and
imported from `PhysicsSMDraft.lean`.

Aristotle completion report:

- solved targets: `weighted_projected_pairing_eq`,
  `weighted_residual_orthogonal_to_projected`,
  `weighted_projected_test_pairing_decomposition`;
- unchanged theorem statements: yes;
- remaining proof holes: none;
- assumptions or escape hatches: none.

The dry-run helper downloaded the result but hit a Windows extraction-path issue
on a bundled task-note path. The target `Core.lean` was still extracted, so the
integration used the low-token `git diff --no-index` surface between the staged
file and the returned target file. Only proof bodies changed. The returned file
had a console/display encoding artifact around the left-arrow token, so the live
module was integrated manually using ASCII Lean syntax.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedProjectorResidualOrthogonal.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedProjectorResidualOrthogonal
lake env lean PhysicsSMDraft.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" PhysicsSM/Draft/NullEdgeP9WeightedProjectorResidualOrthogonal.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9WeightedProjectorResidualOrthogonal.lean
```

All targeted checks passed. The first root check was run in parallel with the
module build and failed because the `.olean` had not yet been written; the
sequential rerun passed.
