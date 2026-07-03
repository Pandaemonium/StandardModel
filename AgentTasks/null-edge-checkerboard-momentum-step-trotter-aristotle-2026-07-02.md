# Null-edge checkerboard momentum-step/Trotter Aristotle job

Date: 2026-07-02
Status: integrated.

## Purpose

Ask Aristotle to prove the pointwise per-step second-order estimate for the new
checkerboard momentum-symbol API:

```text
momentumStepFirstOrderDiscrepancy eps m p = O(eps^2)
```

This is the first missing analytic lemma before the commented
`checkerboard_dirac_limit_statement` can become a theorem. If that is solved,
the job asks for progress on the matrix-power/Trotter bridge.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-checkerboard-momentum-step-trotter-20260702.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-checkerboard-momentum-step-trotter-20260702-project`
- Source root:
  `NullEdgeStandalone`

## Aristotle metadata

```yaml
aristotle:
  project_id: f9231f73-14f0-48be-b5fb-d8db01cdb417
  task_id: 4ff975b1-2e29-4d9d-a4c4-1bdfe529d027
  target_file: PhysicsSM/Draft/CheckerboardDiracScaling.lean
  expected_module: PhysicsSM
  submission_project: AgentTasks/aristotle-submit/null-edge-checkerboard-momentum-step-trotter-20260702-project
  output_dir: AgentTasks/aristotle-output/f9231f73-14f0-48be-b5fb-d8db01cdb417
  status: integrated
```

## Preflight

Local work before submission:

- integrated `PhysicsSM.Draft.CheckerboardDiracScaling`;
- added raw per-step expansion API:
  `momentumStepSymbolRaw`, `momentumStepFirstOrderModel`,
  `momentumStepFirstOrderRemainder`, and
  `momentumStepFirstOrderDiscrepancy`;
- added refinement limit helpers:
  `CheckerboardDiracRefinement.timeStep_tendsto_zero`,
  `CheckerboardDiracRefinement.massAngle_tendsto_zero`, and
  `CheckerboardDiracRefinement.accumulatedAngle_tendsto`;
- recorded cycle-05 literature notes.

## Submission result

Submitted on 2026-07-02.

```text
Project created: f9231f73-14f0-48be-b5fb-d8db01cdb417
Task: 4ff975b1-2e29-4d9d-a4c4-1bdfe529d027
Initial status: QUEUED
```

The Aristotle CLI warned that the focused package has no `.lake` folder. This
is intentional for the focused package; it includes the Lake metadata and Lean
source but not the local dependency cache.

## Cycle-05 local verification

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

Integrated on 2026-07-02.

Returned Lean additions in
`PhysicsSM.Draft.CheckerboardDiracScaling`:

- `momentumStepFirstOrderRemainder_apply`;
- `momentumStepFirstOrderDiscrepancy_le`;
- `momentumStepFirstOrderDiscrepancy_isBigO_sq`;
- `momentumStepFirstOrderDiscrepancy_tendsto_zero_div_sq_bound`;
- `matrixL1Norm_mul_le`;
- `matrixL1Norm_pow_le`;
- `pow_succ_sub`;
- `matrixL1Norm_pow_sub_pow_le`.

Local integration preserved the existing definitions
`momentumStepSymbolRaw` and `diracHamiltonianSymbol`; no continuum theorem was
promoted. The remaining next pieces are per-step stability, the
matrix-exponential bridge, and final assembly of the pointwise momentum theorem.

Codex follow-up added:

- `matrixL1Norm_one`;
- `momentumStepSymbolRaw_zero`;
- `momentumStepFirstOrderModel_zero`;
- `momentumStepFirstOrderRemainder_zero`;
- `momentumStepFirstOrderDiscrepancy_zero`.

These record the zero-spacing sanity checks and the guardrail that
`matrixL1Norm` is not by itself the final long-product stability norm, since the
identity has local L1 size `2`.
