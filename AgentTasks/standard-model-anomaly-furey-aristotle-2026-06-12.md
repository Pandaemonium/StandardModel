# Aristotle task: Standard Model Anomaly Package & Furey Charge/Hypercharge Table

Date: 2026-06-12

## Goal

Fill the 17 `sorry`s in

```text
PhysicsSM/Draft/StandardModelAnomalyPackage.lean
```

establishing local/Witten anomaly cancellation for the Standard Model fermions, and verifying the Furey charge/hypercharge coordinate eigenvalues:

- `standardModelOneGeneration_localAnomalyFree`
- `standardModelOneGeneration_wittenAnomalyFree`
- `standardModelOneGeneration_anomalyFree`
- `JbarBasisState_linearIndependent`
- `Q_op_*_target` (8 theorems)
- `T3_op`, `Y_op` definitions
- `T3_op_omega_target`, `T3_op_nu_target`
- `Y_op_omega_target`, `Y_op_nu_target`
- `furey_realizes_anomalyFreeStandardModelGeneration`

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
- Do not change definitions or sign conventions. Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/StandardModelAnomalyPackage.lean
```

Axiom check on each finished theorem: only `[propext, Classical.choice, Quot.sound]`.

## Submission

**Status**: integrated
**Job ID**: `37617b88-09ed-4e11-b30d-117c23a49e19`
**Submitted**: 2026-06-12
**Submission project**: `AgentTasks/aristotle-submit/wave7-20260612-project`
**Output**: `AgentTasks/aristotle-output/standard-model-anomaly-furey-20260612/`
