# Aristotle task: H3O complement bridge to DVT scaffold

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `898f8fd2-486a-4eb3-a3ff-85bc5bfcb445`
**Retry job ID**: `e613d45c-ed3b-4fa5-a64f-5dfbcf999980`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-raft-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-h3o-complement-dvt-bridge-20260530`
**Retry output**: `AgentTasks/aristotle-output/baez-h3o-complement-dvt-bridge-20260530-retry`
**Downloaded retry output**: `AgentTasks/aristotle-output/baez-h3o-complement-dvt-bridge-20260530-retry-result`
**Extracted retry output**: `AgentTasks/aristotle-output/baez-h3o-complement-dvt-bridge-20260530-retry-extracted`
**Integrated file**: `PhysicsSM/Algebra/Jordan/DVTComplementBridge.lean`
**Type**: DVT/Yokota complement model unification

## Job history

- `898f8fd2-486a-4eb3-a3ff-85bc5bfcb445` failed with an Aristotle internal
  error before producing an artifact.
- `e613d45c-ed3b-4fa5-a64f-5dfbcf999980` resubmitted on 2026-05-30 after
  refreshing the submission project with the integrated complement matrix
  action files.

## Goal

Unify the older DVT complement scaffold

```text
PhysicsSM.Algebra.Jordan.DVTAction.H3OComplement
```

with the newer trusted complement subtype

```text
PhysicsSM.Algebra.Jordan.H3O.complementAddSubgroup
```

and its matrix coordinate model

```text
Matrix (Fin 3) (Fin 3) Complex.
```

This removes a duplicated representation of the 18-real-dimensional
complement and makes later DVT/Yokota action jobs easier to state.

## Current context

Use:

```text
PhysicsSM.Algebra.Jordan.DVTAction
PhysicsSM.Algebra.Jordan.H3OComplexMatrixLinear
```

Important declarations include:

- `DVTAction.H3OComplement`
- `DVTAction.H3OComplement.toH3O`
- `DVTAction.extractComplement`
- `DVTAction.H3OComplement.roundtrip`
- `DVTAction.InH3OComplement`
- `InComplementOfB`
- `complementAddSubgroup`
- `complementLinearEquivM3C`
- `complementToM3C`
- `m3CToComplement`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Jordan/DVTComplementBridge.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTAction
import PhysicsSM.Algebra.Jordan.H3OComplexMatrixLinear
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Prove that the two complement predicates agree:

```lean
theorem inH3OComplement_iff_inComplementOfB
    (a : H3O.H3O) :
    InH3OComplement a <-> H3O.InComplementOfB a := ...
```

Then prove round-trip and membership bridge lemmas:

```lean
theorem H3OComplement.toH3O_inComplementOfB
    (w : H3OComplement) :
    H3O.InComplementOfB w.toH3O := ...

theorem extractComplement_toH3O_of_inComplementOfB
    {a : H3O.H3O} (ha : H3O.InComplementOfB a) :
    (extractComplement a).toH3O = a := ...
```

Package the older scaffold as an additive equivalence with the new complement
subgroup:

```lean
noncomputable def h3oComplementAddEquivComplementSubgroup :
    H3OComplement ~=+ H3O.complementAddSubgroup := ...
```

If the additive-group instance on `H3OComplement` is missing, it is acceptable
to add a small coordinatewise `AddCommGroup H3OComplement` instance in this
file, using the existing fieldwise definitions from `DVTAction`.

Finally, package the matrix coordinate equivalence:

```lean
noncomputable def h3oComplementEquivM3C :
    H3OComplement ~= Matrix (Fin 3) (Fin 3) Complex := ...
```

Optional stretch:

```lean
theorem h3oComplementEquivM3C_apply
    (w : H3OComplement) :
    h3oComplementEquivM3C w = H3O.complementToM3C w.toH3O := ...
```

## Claim boundary

This is only a coordinate/model bridge. Do not claim the DVT stabilizer theorem
`(SU(3) x SU(3)) / Z3` and do not prove Jordan-product preservation.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the row convention from `H3OComplexMatrix`: rows are `x`, `y`, `z`.
- Do not alter existing DVT scaffold definitions unless a tiny typeclass
  instance is necessary.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTComplementBridge.lean
lake build PhysicsSM.Algebra.Jordan.DVTComplementBridge
lake build PhysicsSM
```

## Integration result

Integrated on 2026-05-30.

Aristotle produced a trusted theorem package containing:

- `inH3OComplement_iff_inComplementOfB`
- `H3OComplement.toH3O_inComplementOfB`
- `extractComplement_toH3O_of_inComplementOfB`
- `AddCommGroup H3OComplement`
- `h3oComplementAddEquivComplementSubgroup`
- `h3oComplementEquivM3C`
- `h3oComplementEquivM3C_apply`

During integration, a literal proof-placeholder token in the module docstring
was removed without changing theorem statements.
