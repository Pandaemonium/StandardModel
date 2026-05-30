# Aristotle task: Furey Jbar Q_op eigenvalue bridge

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `4c9271c4-e53b-43e7-a037-757b825bfc37`
**Submission project**: `AgentTasks/aristotle-submit/furey-qop-jbar-eigen-bridge-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-qop-jbar-eigen-bridge-20260529`
**Extracted output**: `AgentTasks/aristotle-output/furey-qop-jbar-eigen-bridge-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Furey/QopJbarEigenBridge.lean`
**Type**: finite theorem bridge / operator eigenvalue table

## Goal

Connect the trusted finite table in
`PhysicsSM.Algebra.Furey.ElectroweakBridge.rawQop` back to the actual
operator-eigenvalue theorems in `PhysicsSM.Algebra.Furey.AnomalyBridge`.

The current electroweak bridge intentionally uses a finite rational table for
the raw Jbar charges. This job should prove that the table is exactly the
one obtained from the kernel-checked `Q_op` eigenvalue theorems.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/QopJbarEigenBridge.lean
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.QopJbarEigenBridge
```

Suggested imports:

```lean
import Mathlib.Tactic
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.ElectroweakBridge
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Existing declarations

Useful names include:

```lean
PhysicsSM.Algebra.Furey.AnomalyBridge.JbarBasisState
PhysicsSM.Algebra.Furey.AnomalyBridge.Q_op_omega_bar
PhysicsSM.Algebra.Furey.AnomalyBridge.Q_op_vbar1
PhysicsSM.Algebra.Furey.AnomalyBridge.Q_op_vbar2
PhysicsSM.Algebra.Furey.AnomalyBridge.Q_op_vbar3
PhysicsSM.Algebra.Furey.AnomalyBridge.Q_op_vbar4
PhysicsSM.Algebra.Furey.AnomalyBridge.Q_op_vbar5
PhysicsSM.Algebra.Furey.AnomalyBridge.Q_op_vbar6
PhysicsSM.Algebra.Furey.AnomalyBridge.Q_op_nu_bar
PhysicsSM.Algebra.Furey.ElectroweakBridge.JbarState
PhysicsSM.Algebra.Furey.ElectroweakBridge.rawQop
PhysicsSM.Algebra.Furey.MinimalLeftIdeal.Q_op
```

The theorem `Q_op_omega_bar` has type:

```lean
Q_op omega_bar = (0 : Complex) • omega_bar
```

and similarly for the other seven Jbar basis states.

## Target statements

Define a small bridge function if helpful:

```lean
def rawQopComplex (s : ElectroweakBridge.JbarState) : Complex :=
  (ElectroweakBridge.rawQop s : Complex)
```

Then prove the all-state theorem:

```lean
theorem Q_op_JbarBasisState_eigen :
    forall s : ElectroweakBridge.JbarState,
      MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState s) =
        rawQopComplex s • AnomalyBridge.JbarBasisState s := by
  ...
```

If namespace qualification is awkward, use `open` statements, but keep the
statement semantically equivalent.

It is also useful to prove named per-state corollaries:

```lean
theorem Q_op_JbarBasisState_zero : ...
theorem Q_op_JbarBasisState_one : ...
...
theorem Q_op_JbarBasisState_seven : ...
```

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not reprove the coordinate eigenvalue calculations; reuse the existing
  `AnomalyBridge` theorems.
- Do not change the definitions of `Q_op`, `JbarBasisState`, or `rawQop`.
- This is an operator/table consistency theorem, not a weak-isospin theorem.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/QopJbarEigenBridge.lean
lake env lean PhysicsSM.lean
```

## Deliverable

Return files changed, theorem names proved, whether the output is sorry-free,
and exact verification commands run.

## Integration result

Integrated on 2026-05-29 into trusted code as
`PhysicsSM.Algebra.Furey.QopJbarEigenBridge`.

Theorems added:

- `rawQopComplex`
- `Q_op_JbarBasisState_zero`
- `Q_op_JbarBasisState_one`
- `Q_op_JbarBasisState_two`
- `Q_op_JbarBasisState_three`
- `Q_op_JbarBasisState_four`
- `Q_op_JbarBasisState_five`
- `Q_op_JbarBasisState_six`
- `Q_op_JbarBasisState_seven`
- `Q_op_JbarBasisState_eigen`

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Furey\QopJbarEigenBridge.lean
lake build PhysicsSM.Algebra.Furey.QopJbarEigenBridge PhysicsSM.Algebra.Furey.TrialityTripleModule PhysicsSM.Algebra.Furey.TrialityRolePermutation
lake build PhysicsSM
```

Status: sorry-free trusted integration. The root build passed with pre-existing
warnings in older modules.
