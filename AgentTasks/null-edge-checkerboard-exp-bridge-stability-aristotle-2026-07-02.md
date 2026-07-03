# Null-edge checkerboard exponential-bridge/stability Aristotle job

Date: 2026-07-02
Status: integrated.

## Purpose

Ask Aristotle to prove the one-step bridge between the first-order Dirac model
and the continuum exponential:

```text
continuumStepBridgeDiscrepancy eps m p = O(eps^2)
```

Then ask it to choose or build the correct long-product stability route, taking
account of the guardrail `matrixL1Norm_one = 2`.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-checkerboard-exp-bridge-stability-20260702.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-checkerboard-exp-bridge-stability-20260702-project`
- Source root:
  `NullEdgeStandalone`

## Aristotle metadata

```yaml
aristotle:
  project_id: 55f697b0-fdd4-43c9-b624-149e623df095
  task_id: 18faba2f-01fd-496e-bed7-b0abcfbc7c40
  target_file: PhysicsSM/Draft/CheckerboardDiracScaling.lean
  expected_module: PhysicsSM
  submission_project: AgentTasks/aristotle-submit/null-edge-checkerboard-exp-bridge-stability-20260702-project
  output_dir: AgentTasks/aristotle-output/55f697b0-fdd4-43c9-b624-149e623df095
  status: integrated
```

## Preflight

Local work before submission:

- integrated the per-step BigO theorem and matrix-power toolkit;
- added `matrixL1Norm_one` as a long-product stability guardrail;
- added `continuumStepSymbol`, `continuumStepBridgeRemainder`, and
  `continuumStepBridgeDiscrepancy`;
- recorded cycle-06 literature/tooling notes.

## Submission result

Submitted on 2026-07-02.

```text
Project created: 55f697b0-fdd4-43c9-b624-149e623df095
Task: 18faba2f-01fd-496e-bed7-b0abcfbc7c40
Initial status: QUEUED
```

The Aristotle CLI warned that the focused package has no `.lake` folder. This
is intentional for the focused package; it includes Lake metadata and Lean
source but not the local dependency cache.

## Cycle-06 local verification

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

- `matrixL1Norm_neg`
- `matrixL1Norm_smul_complex`
- `matrixL1Norm_diracHamiltonianSymbol`
- `matrixL1Norm_tsum_le`
- `matrixExpSeries_summable`
- `matrixExp_eq_tsum`
- `matrixExp_sub_one_sub_self_eq_tsum`
- `matrixL1Norm_tsum_expTail_le`
- `real_exp_sub_one_sub_self_eq_tsum`
- `matrixL1Norm_exp_sub_one_sub_self_le`
- `real_exp_sub_one_sub_self_le_sq`
- `continuumStepBridgeDiscrepancy_le`
- `continuumStepBridgeDiscrepancy_isBigO_sq`
- `continuumStepBridgeDiscrepancy_tendsto_zero_div_sq_bound`

The generic operator-norm plan from the Aristotle output was superseded locally
by the scoped L-infinity and L2 sections integrated from the follow-up jobs.
