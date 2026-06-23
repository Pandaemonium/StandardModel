# Aristotle focused job: P9 coarse-grained noise-kernel PSD

```yaml
job_name: null-edge-p9-coarse-kernel-psd-20260623
status: integrated
project_id: 6d1abbf8-7cdd-4e8b-a74f-9b2be12e35f3
task_id: bd1b57d2-df97-47fa-aba2-002cb92e2466
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-coarse-kernel-psd-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-coarse-kernel-psd-20260623-project
target_module: NullEdgeP9CoarseKernelPSD.Core
target_file: NullEdgeP9CoarseKernelPSD/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9CoarseKernelPSD
integrated_file: PhysicsSM/Draft/NullEdgeP9CoarseKernelPSD.lean
expected_check: lake env lean NullEdgeP9CoarseKernelPSD/Core.lean
```

## Task

Fill the proof holes in `NullEdgeP9CoarseKernelPSD/Core.lean` without changing
definitions or theorem statements.

This is the first finite theorem package for the C4 P9 route recommended by the
discrete coarse-graining strategy job. It formalizes the statement that a fixed
coarse-graining map pushes a positive noise kernel to a positive coarse kernel,
and that coarse response is exactly fine response against the pulled-back test.

## Targets

```lean
response_coarseKernel_eq_response_pullback
coarseKernel_psd
psd_diag_nonneg
trace_coarseKernel_nonneg
```

## Constraints

- Do not weaken, rename, or restate the theorems.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9CoarseKernelPSD/Core.lean
```

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Integration

Integrated on 2026-06-23 into
`PhysicsSM.Draft.NullEdgeP9CoarseKernelPSD`.

Aristotle reported all four targets solved, with no statement or definition
changes and no remaining proof holes. Statement-identity review against the
staged standalone source showed only proof-body changes plus cosmetic comment
changes. The integrated version keeps ASCII Lean syntax and project namespace
conventions.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9CoarseKernelPSD.lean
lake build PhysicsSM.Draft.NullEdgeP9CoarseKernelPSD
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9CoarseKernelPSD.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9CoarseKernelPSD.lean
```

The targeted file check, module build, draft-root import check, placeholder
scan, and non-ASCII scan passed. The first draft-root import check raced the
targeted build and failed before the `.olean` existed; rerunning after the
targeted build passed.
