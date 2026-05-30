# Aristotle task: Q_op electroweak table consistency

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `b29d7fb2-d8a7-4a40-968f-1194445e213e`
**Submission project**: `AgentTasks/aristotle-submit/furey-qop-electroweak-consistency-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-qop-electroweak-consistency-20260529`
**Extracted output**: `AgentTasks/aristotle-output/furey-qop-electroweak-consistency-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Furey/QopElectroweakConsistency.lean`
**Type**: finite table bridge / charge bookkeeping

## Goal

Connect the newly integrated operator-eigenvalue bridge to the electroweak
bookkeeping table in a small, trusted finite module.

The project now proves:

- `Q_op_JbarBasisState_eigen`: the raw `Q_op` eigenvalue on every Jbar basis
  state agrees with `ElectroweakBridge.rawQop`;
- `ElectroweakBridge`: physical electric charge, target weak isospin, computed
  hypercharge, and Standard Model multiplet matching.

This job should add table-consistency lemmas that make the sign bridge and
finite electroweak assignments easy to reuse downstream.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/QopElectroweakConsistency.lean
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.QopElectroweakConsistency
```

Suggested imports:

```lean
import Mathlib.Tactic
import PhysicsSM.Algebra.Furey.QopJbarEigenBridge
import PhysicsSM.Algebra.Furey.ElectroweakBridge
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Prove explicit table lemmas:

```lean
theorem rawQop_values :
    (List.finRange 8).map ElectroweakBridge.rawQop =
      [0, -1 / 3, -1 / 3, -1 / 3, -2 / 3, -2 / 3, -2 / 3, -1]

theorem physicalQ_values :
    (List.finRange 8).map ElectroweakBridge.physicalQ =
      [0, -1 / 3, -1 / 3, -1 / 3, 2 / 3, 2 / 3, 2 / 3, -1]

theorem targetT3_values :
    (List.finRange 8).map ElectroweakBridge.targetT3 =
      [1 / 2, -1 / 2, -1 / 2, -1 / 2, 1 / 2, 1 / 2, 1 / 2, -1 / 2]
```

Define a finite sign correction if useful:

```lean
def physicalQFromRawQop (s : ElectroweakBridge.JbarState) : Rat := ...
```

and prove:

```lean
theorem physicalQ_eq_physicalQFromRawQop :
    forall s : ElectroweakBridge.JbarState,
      ElectroweakBridge.physicalQ s = physicalQFromRawQop s
```

Prove a named theorem combining the operator bridge and the electroweak table,
for example:

```lean
theorem Q_op_eigenvalue_matches_electroweak_raw_table
    (s : ElectroweakBridge.JbarState) :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState s) =
      QopJbarEigenBridge.rawQopComplex s • AnomalyBridge.JbarBasisState s
```

This theorem may simply re-export `Q_op_JbarBasisState_eigen` under a table
bookkeeping namespace, but it should give downstream files one obvious import.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not claim weak isospin is derived from `Q_op`; keep the target `T3` table
  explicitly documented as conventional electroweak input.
- Keep proofs finite by `decide`, `fin_cases`, `simp`, and `norm_num`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/QopElectroweakConsistency.lean
lake build PhysicsSM.Algebra.Furey.QopElectroweakConsistency
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the output is sorry-free,
and exact verification commands run.

## Integration result

Integrated on 2026-05-29 into trusted code as
`PhysicsSM.Algebra.Furey.QopElectroweakConsistency`.

Main declarations added:

- `rawQop_values`
- `physicalQ_values`
- `targetT3_values`
- `physicalQFromRawQop`
- `physicalQ_eq_physicalQFromRawQop`
- `Q_op_eigenvalue_matches_electroweak_raw_table`

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Furey\QopElectroweakConsistency.lean
lake build PhysicsSM.Algebra.Furey.QopElectroweakConsistency PhysicsSM.Algebra.Furey.TrialityActionPermutation PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude
pre-commit run --all-files
lake build
```

Status: sorry-free trusted integration. The full build passed with pre-existing
warnings in older modules.
