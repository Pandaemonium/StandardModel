# Null-edge checkerboard row-sum bounds Aristotle job

Date: 2026-07-02
Status: integrated.

## Purpose

Ask Aristotle for a narrow proof of the scoped L-infinity row-sum bounds for
the isotropic checkerboard mass step and the raw finite momentum step. This is
split off from the broader accumulated-Trotter job so the local row-sum
coercion work can proceed independently.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-checkerboard-row-sum-bounds-20260702.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-checkerboard-row-sum-bounds-20260702-project`
- Source root:
  `NullEdgeStandalone`
- Target file:
  `PhysicsSM/Draft/CheckerboardDiracScaling.lean`

## Aristotle metadata

```yaml
aristotle:
  project_id: afac9485-654c-45fa-85cf-5ef81f103b69
  task_id: d883535a-4236-4985-90dd-fa7395fa7969
  target_file: PhysicsSM/Draft/CheckerboardDiracScaling.lean
  expected_module: PhysicsSM
  submission_project: AgentTasks/aristotle-submit/null-edge-checkerboard-row-sum-bounds-20260702-project
  output_dir: AgentTasks/aristotle-output/afac9485-654c-45fa-85cf-5ef81f103b69
  status: integrated
```

## Preflight

Local work before submission:

- `linftyOpNorm_nullShiftSymbol_le_one` is already proved locally.
- A direct local attempt at the isotropic row-sum bound reached `NNReal`/row-sum
  coercion bookkeeping; rather than churn, this narrow job isolates it for
  Aristotle.

## Submission result

Submitted on 2026-07-02.

```text
Project created: afac9485-654c-45fa-85cf-5ef81f103b69
Task: d883535a-4236-4985-90dd-fa7395fa7969
Initial status: QUEUED
```

The Aristotle CLI warned that the focused package has no `.lake` folder. This
is intentional for the slim standalone package; it includes Lake metadata and
Lean source but not the local dependency cache.

## Integration result

Integrated on 2026-07-02 into
`NullEdgeStandalone/PhysicsSM/Draft/CheckerboardDiracScaling.lean`.

Kernel-checked results incorporated:

- `linftyOpNorm_isotropicStep_le_abs_cos_add_abs_sin`
- `linftyOpNorm_isotropicStep_le_one_add_abs`
- `linftyOpNorm_momentumStepSymbolRaw_le_one_add_abs`

These combine with the local `linftyOpNorm_nullShiftSymbol_le_one` theorem to
complete the finite row-sum factor-bound layer needed by the accumulated
Trotter estimate.
