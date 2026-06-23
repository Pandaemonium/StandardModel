# Aristotle focused job: P9 weighted projector Pythagorean identity

```yaml
job_name: null-edge-p9-weighted-projector-pythagorean-20260623
status: integrated
project_id: 4e23c58d-5c87-4a94-aa27-e728babc395e
task_id: 87e7ba4d-9b7a-4a81-bfd8-9f43fbcd664c
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-weighted-projector-pythagorean-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-weighted-projector-pythagorean-20260623-project
target_module: NullEdgeP9WeightedProjectorPythagorean.Core
target_file: NullEdgeP9WeightedProjectorPythagorean/Core.lean
expected_check: lake env lean NullEdgeP9WeightedProjectorPythagorean/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9WeightedProjectorPythagorean/Core.lean`
without changing definitions or theorem statements.

Scientific target: this is the norm/noise companion to the weighted
projector-residual orthogonality theorem. It should prove that a weighted
self-adjoint idempotent projector splits source energy into projected/coarse
and residual pieces, giving P9 a finite observer-channel energy decomposition.

## Targets

```lean
weighted_residual_orthogonal_to_projected
source_eq_projected_plus_residual
weighted_projector_pythagorean
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9WeightedProjectorPythagorean/Core.lean
```

## Proof sketch

Reuse the weighted residual-orthogonality argument from the previous focused
job. For the Pythagorean theorem, first rewrite `source` as
`lin Pi source + (source - lin Pi source)`, expand the weighted dot product,
and use residual orthogonality with `test := source` plus `dotW_comm` to kill
the cross terms.

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission

Submitted 2026-06-23 as Aristotle project
`4e23c58d-5c87-4a94-aa27-e728babc395e`, task
`87e7ba4d-9b7a-4a81-bfd8-9f43fbcd664c`.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-weighted-projector-pythagorean-20260623/NullEdgeP9WeightedProjectorPythagorean/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-weighted-projector-pythagorean-20260623-project/NullEdgeP9WeightedProjectorPythagorean/Core.lean
```

Both Lean preflight checks passed with exactly three intended proof-hole
warnings. The non-ASCII and escape-hatch scans were clean.

## Completion and integration

Aristotle completed all three targets with no statement or definition changes,
no remaining proof holes, and no added assumptions or nonstandard constructs.
The returned report says `#print axioms` confirmed only standard axioms
(`propext`, `Classical.choice`, and `Quot.sound`) after Aristotle repaired an
initial stale-proof issue during its own verification.

Integrated live module:

```text
PhysicsSM.Draft.NullEdgeP9WeightedProjectorPythagorean
```

Live verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedProjectorPythagorean.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedProjectorPythagorean
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9WeightedProjectorPythagorean.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9WeightedProjectorPythagorean.lean
```

All targeted checks passed. The first draft-root check raced the targeted build
and failed before the `.olean` existed; rerunning after the targeted build
passed. The extracted Aristotle file contained mojibake around left-arrow
tokens, so the live integration used equivalent ASCII Lean syntax.
