# Null-edge checkerboard scoped operator-norm stability Aristotle job

Date: 2026-07-02
Status: integrated.

## Purpose

Ask Aristotle to use the newly added scoped `Matrix.Norms.Operator` bridge to
prove the next stability/exponential estimates in a norm with identity size `1`.
This job complements the already running exponential-bridge job by giving it the
new local norm lemmas from cycle 07.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-checkerboard-linftyop-stability-20260702.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-checkerboard-linftyop-stability-20260702-project`
- Source root:
  `NullEdgeStandalone`

## Aristotle metadata

```yaml
aristotle:
  project_id: ea714e8e-1187-45db-8e8a-c6c1a250c59e
  task_id: a22264f8-33ef-4a2d-8018-3bd77bfc4e04
  target_file: PhysicsSM/Draft/CheckerboardDiracScaling.lean
  expected_module: PhysicsSM
  submission_project: AgentTasks/aristotle-submit/null-edge-checkerboard-linftyop-stability-20260702-project
  output_dir: AgentTasks/aristotle-output/ea714e8e-1187-45db-8e8a-c6c1a250c59e
  status: integrated
```

## Preflight

Local work before submission:

- identified Mathlib's scoped `Matrix.Norms.Operator` norm as the likely
  long-product stability norm;
- added `linftyOpNorm_one`, `linftyOpNorm_mul_le`, and
  `linftyOpNorm_le_matrixL1Norm`;
- converted the finite-step first-order remainder estimate to
  `linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq`;
- recorded cycle-07 literature/tooling notes.

## Submission result

Submitted on 2026-07-02.

```text
Project created: ea714e8e-1187-45db-8e8a-c6c1a250c59e
Task: a22264f8-33ef-4a2d-8018-3bd77bfc4e04
Initial status: QUEUED
```

The Aristotle CLI warned that the focused package has no `.lake` folder. This
is intentional for the focused package; it includes Lake metadata and Lean
source but not the local dependency cache.

## Cycle-07 local verification

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

- `norm_expMat_sub_one_sub_self_le`
- `linftyOpNorm_continuumStepBridgeRemainder_isBigO_sq`
- `linftyOpNorm_pow_sub_pow_le`
- `linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq`

During integration, Codex made summability witnesses explicit in the abstract
exponential-remainder proof to match the live standalone environment. The
statement and proof idea remain Aristotle's scoped-operator-norm bridge.
