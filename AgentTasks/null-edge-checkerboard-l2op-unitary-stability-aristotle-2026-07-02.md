# Null-edge checkerboard L2-operator/unitary stability Aristotle job

Date: 2026-07-02
Status: integrated.

## Purpose

Ask Aristotle to investigate the scoped `Matrix.Norms.L2Operator` route for
unitary stability of the checkerboard one-step symbol. This is independent of
the running L-infinity operator-norm jobs and may give the cleanest stability
fact: unitary one-step evolution should have operator norm `1`.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-checkerboard-l2op-unitary-stability-20260702.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-checkerboard-l2op-unitary-stability-20260702-project`
- Source root:
  `NullEdgeStandalone`

## Aristotle metadata

```yaml
aristotle:
  project_id: f1c3744c-9f21-43bd-94b0-930afc1e76e3
  task_id: 95c32ecd-3698-470a-8e9c-2962e6c554e3
  target_file: PhysicsSM/Draft/CheckerboardDiracScaling.lean
  expected_module: PhysicsSM
  submission_project: AgentTasks/aristotle-submit/null-edge-checkerboard-l2op-unitary-stability-20260702-project
  output_dir: AgentTasks/aristotle-output/f1c3744c-9f21-43bd-94b0-930afc1e76e3
  status: integrated
```

## Preflight

Local work before submission:

- checked Mathlib's `Matrix.Norms.L2Operator` scoped norm in
  `Mathlib.Analysis.CStarAlgebra.Matrix`;
- confirmed the L-infinity route locally but noted that L2 operator norm may be
  more semantically faithful for unitary quantum walks;
- recorded cycle-07/08 tooling notes.

## Submission result

Submitted on 2026-07-02.

```text
Project created: f1c3744c-9f21-43bd-94b0-930afc1e76e3
Task: 95c32ecd-3698-470a-8e9c-2962e6c554e3
Initial status: QUEUED
```

The Aristotle CLI warned that the focused package has no `.lake` folder. This
is intentional for the focused package; it includes Lake metadata and Lean
source but not the local dependency cache.

## Cycle-08 local verification

Verification after submission:

```text
lake env lean PhysicsSM/Draft/CheckerboardDiracScaling.lean
lake env lean PhysicsSM.lean
lake build NullEdgeStandalone
prose placeholder-token scan on touched Markdown files
python Scripts/check_forbidden_lean_tokens.py --include-draft <touched-checkerboard-lean-files>
pre-commit run --all-files
```

All commands passed on 2026-07-02.

## Integration result

Integrated on 2026-07-02 into
`NullEdgeStandalone/PhysicsSM/Draft/CheckerboardDiracScaling.lean`.

Kernel-checked results incorporated:

- `l2OpNorm_one`
- `l2OpNorm_mul_le`
- `l2OpNorm_of_mem_unitaryGroup`
- `nullShiftSymbol_mem_unitaryGroup`
- `isotropicStep_mem_unitaryGroup`
- `momentumStepSymbolRaw_mem_unitaryGroup`
- `momentumStepSymbol_mem_unitaryGroup`
- `l2OpNorm_momentumStepSymbolRaw`
- `l2OpNorm_momentumStepSymbol`

Codex follow-up, after integration, added the finite-product results
`momentumEvolution_mem_unitaryGroup` and `l2OpNorm_momentumEvolution`.
