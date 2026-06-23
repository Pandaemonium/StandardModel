# Aristotle focused job: P9 coarse boundary-invariance core

```yaml
job_name: null-edge-p9-coarse-boundary-invariance-20260623
status: integrated
project_id: e9a2ef62-0ab6-4db5-97a8-b2c904585fae
task_id: 8318fbeb-3689-4698-9528-2cc3128ff1a2
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-coarse-boundary-invariance-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-coarse-boundary-invariance-20260623-project
target_module: NullEdgeP9CoarseBoundaryInvariance.Core
target_file: NullEdgeP9CoarseBoundaryInvariance/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9CoarseBoundaryInvariance
integrated_file: PhysicsSM/Draft/NullEdgeP9CoarseBoundaryInvariance.lean
expected_check: lake env lean NullEdgeP9CoarseBoundaryInvariance/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9CoarseBoundaryInvariance/Core.lean` without
changing definitions or theorem statements.

This is the boundary-artifact guardrail for the C4 P9 route: if the fixed
coarse-graining map annihilates a boundary-exact perturbation, the coarse
source and any quadratic coarse response are unchanged.

## Targets

```lean
pushforward_boundary_invariant
response_boundary_invariant
pushforward_boundary_invariant_pointwise
```

## Constraints

- Do not weaken, rename, or restate the theorems.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9CoarseBoundaryInvariance/Core.lean
```

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Integration

Integrated on 2026-06-23 into
`PhysicsSM.Draft.NullEdgeP9CoarseBoundaryInvariance`.

Aristotle reported all three targets solved, with no statement or definition
changes and no remaining proof holes. Statement-identity review against the
staged standalone source showed only proof-body changes.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9CoarseBoundaryInvariance.lean
lake build PhysicsSM.Draft.NullEdgeP9CoarseBoundaryInvariance
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9CoarseBoundaryInvariance.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9CoarseBoundaryInvariance.lean
```

The targeted file check, module build, draft-root import check, placeholder
scan, and non-ASCII scan passed. The helper hit an extraction edge case on the
focused package archive, so integration used direct archive inspection and a
`git diff --no-index` review of the returned `Core.lean`.
