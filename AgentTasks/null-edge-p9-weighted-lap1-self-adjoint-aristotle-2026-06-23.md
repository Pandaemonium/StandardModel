# Aristotle focused job: P9 weighted 1-Laplacian self-adjointness

```yaml
job_name: null-edge-p9-weighted-lap1-self-adjoint-20260623
status: integrated
project_id: bfbb0923-97d7-4966-9051-53e69c3b4d75
task_id: 7f89b5ce-8d1c-44fa-bf55-f401a69cdc3e
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-weighted-lap1-self-adjoint-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-weighted-lap1-self-adjoint-20260623-project
target_module: NullEdgeP9WeightedLap1SelfAdjoint.Core
target_file: NullEdgeP9WeightedLap1SelfAdjoint/Core.lean
expected_check: lake env lean NullEdgeP9WeightedLap1SelfAdjoint/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9WeightedLap1SelfAdjoint/Core.lean`
without changing definitions or theorem statements.

Scientific target: the P9 spectral/Hodge coarse-mode strategy needs the
explicit weighted 1-Laplacian to be self-adjoint for the weighted degree-1
pairing. This converts the existing weighted-adjoint and energy identities into
the finite algebra needed before using spectral projectors as observer-channel
coarse maps.

## Targets

```lean
dotW_lap1_bilinear_eq_down_plus_up
weighted_lap1_selfAdjoint
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9WeightedLap1SelfAdjoint/Core.lean
```

## Proof sketch

For the bilinear identity, expand the `lap1` sum into the down and up terms.
Use `weighted_adjoint_coboundary_codiff` on the down term and again, with
`dotW_comm`, on the up term. The self-adjointness theorem then follows by
rewriting both sides with the bilinear identity and commuting the two resulting
weighted pairings.

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission

Submitted 2026-06-23 as Aristotle project
`bfbb0923-97d7-4966-9051-53e69c3b4d75`, task
`7f89b5ce-8d1c-44fa-bf55-f401a69cdc3e`.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-weighted-lap1-self-adjoint-20260623/NullEdgeP9WeightedLap1SelfAdjoint/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-weighted-lap1-self-adjoint-20260623-project/NullEdgeP9WeightedLap1SelfAdjoint/Core.lean
```

Both Lean preflight checks passed with exactly two intended proof-hole warnings.
The non-ASCII and escape-hatch scans were clean.

## Integration

Integrated into `PhysicsSM/Draft/NullEdgeP9WeightedLap1SelfAdjoint.lean` and
imported from `PhysicsSMDraft.lean`.

Aristotle completion report:

- solved targets: `dotW_lap1_bilinear_eq_down_plus_up` and
  `weighted_lap1_selfAdjoint`;
- unchanged theorem statements: yes;
- remaining proof holes: none;
- assumptions or escape hatches: none;
- axiom check in the focused package reported only the standard axioms
  `propext`, `Classical.choice`, and `Quot.sound`.

The dry-run helper downloaded the result but hit the same Windows
extraction-path issue on a bundled task-note path seen in adjacent focused
jobs. The target `Core.lean` was still extracted, so integration used
`git diff --no-index` against the staged source. Only proof bodies changed. The
returned file had console/display encoding artifacts around left-arrow tokens,
so the live module was integrated manually using ASCII Lean syntax.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedLap1SelfAdjoint.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedLap1SelfAdjoint
lake env lean PhysicsSMDraft.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" PhysicsSM/Draft/NullEdgeP9WeightedLap1SelfAdjoint.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9WeightedLap1SelfAdjoint.lean
```

All targeted checks passed. The first root check was run in parallel with the
module build and failed because the `.olean` had not yet been written; the
sequential rerun passed.
