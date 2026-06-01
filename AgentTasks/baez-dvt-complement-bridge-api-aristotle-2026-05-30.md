# Aristotle task: DVT complement bridge simp API

**Agent**: Aristotle
**Status**: Resubmitted
**Priority**: Medium
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `ae121fbb-d447-40d0-9b2b-2eaa61162c42`
**Retry job ID**: `c275a90f-511d-4a21-944a-482a3e300aa6`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-raft-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-dvt-complement-bridge-api-20260530`
**Type**: Bridge usability and future-proofing

## Job history

- `ae121fbb-d447-40d0-9b2b-2eaa61162c42` failed with an Aristotle internal
  error before producing an artifact.
- `c275a90f-511d-4a21-944a-482a3e300aa6` was resubmitted on 2026-05-30 after
  refreshing the submission project from the live tree.

## Goal

Add a small, trusted simp/API layer for the equivalences introduced in
`DVTComplementBridge.lean`.

The purpose is to make later DVT/Yokota jobs less fragile by exposing the
forward and inverse maps in theorem form, instead of forcing every proof to
unfold the bridge definitions.

## Current context

Use:

```text
PhysicsSM.Algebra.Jordan.DVTComplementBridge
```

Important declarations include:

- `h3oComplementAddEquivComplementSubgroup`
- `h3oComplementEquivM3C`
- `h3oComplementEquivM3C_apply`
- `H3O.complementLinearEquivM3C`
- `H3O.complementToM3C`
- `H3O.m3CToComplement`
- `extractComplement_toH3O_of_inComplementOfB`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Jordan/DVTComplementBridgeAPI.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTComplementBridge
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Add forward-map API lemmas:

```lean
@[simp] theorem h3oComplementAddEquivComplementSubgroup_apply_val
    (w : H3OComplement) :
    (h3oComplementAddEquivComplementSubgroup w).val = w.toH3O := ...

@[simp] theorem h3oComplementAddEquivComplementSubgroup_symm_apply
    (a : H3O.complementAddSubgroup) :
    h3oComplementAddEquivComplementSubgroup.symm a =
      extractComplement a.val := ...

@[simp] theorem h3oComplementAddEquivComplementSubgroup_symm_apply_toH3O
    (a : H3O.complementAddSubgroup) :
    (h3oComplementAddEquivComplementSubgroup.symm a).toH3O = a.val := ...
```

Add matrix-coordinate API lemmas. Equivalent statement shapes are acceptable
if the existing definitions make these exact names inconvenient:

```lean
@[simp] theorem h3oComplementEquivM3C_symm_apply
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    h3oComplementEquivM3C.symm M =
      h3oComplementAddEquivComplementSubgroup.symm
        (H3O.complementLinearEquivM3C.symm M) := ...

@[simp] theorem h3oComplementEquivM3C_symm_apply_toH3O
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    (h3oComplementEquivM3C.symm M).toH3O =
      H3O.m3CToComplement M := ...

@[simp] theorem h3oComplementEquivM3C_symm_apply_roundtrip
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    h3oComplementEquivM3C (h3oComplementEquivM3C.symm M) = M := ...
```

Optional stretch:

```lean
@[simp] theorem h3oComplementEquivM3C_apply_symm_roundtrip
    (w : H3OComplement) :
    h3oComplementEquivM3C.symm (h3oComplementEquivM3C w) = w := ...
```

## Claim boundary

This file should contain only API lemmas for existing equivalences. Do not
introduce new mathematics, new action definitions, unitarity claims, quotient
claims, or Jordan-product preservation claims.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the bridge equivalence definitions unless a theorem statement
  is impossible without a harmless local API adjustment.
- Keep theorem names descriptive and grep-friendly.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTComplementBridgeAPI.lean
lake build PhysicsSM.Algebra.Jordan.DVTComplementBridgeAPI
lake build PhysicsSM
```
