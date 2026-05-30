# Aristotle task: Furey color operators as a representation package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `df06124f-f541-4f32-a81c-1e6272e72250`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-big-targets-20260530-min-project`
**Output**: `AgentTasks/aristotle-output/furey-su3-color-representation-package-20260530`
**Type**: Furey operator algebra / color representation

## Integration result

Integrated 2026-05-30 into:

```text
PhysicsSM/Algebra/Furey/ColorRepresentation.lean
```

The merged module adds the finite `ColorGen` index type, maps the color
generators to complex-linear endomorphisms, repackages the available
commutator table on `J`, and records diagonal/root commutator identities using
the sign conventions already proved in `OperatorAlgebra`.

## Goal

Build the next abstraction layer over the existing finite Furey color-operator
theorems. The current project already has many transition tables, commutators,
charge-conservation facts, and invariant color-subspace facts in
`OperatorAlgebra.lean`. This job should package those facts into a cleaner
representation API on the minimal ideal `J`.

## Current context

Use:

```text
PhysicsSM.Algebra.Furey.OperatorRepresentations
PhysicsSM.Algebra.Furey.OperatorAlgebra
```

Important declarations include:

- `J`
- `J_basis`
- `EqOnJ`
- `opComm`
- `T12_op`, `T21_op`, `T13_op`, `T31_op`, `T23_op`, `T32_op`
- `H12_op`, `H23_op`, `H13_op`
- `comm_T12_T21_eq_neg_H12`
- `comm_T13_T31_eq_neg_H13`
- `comm_T23_T32_eq_neg_H23`
- `comm_T12_T23_eq_T13`
- `comm_T21_T32_eq_neg_T31`
- charge-conservation theorems
- `J_up_color`, `J_down_color`, `J_singlet_low`, `J_singlet_high`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Furey/ColorRepresentation.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.OperatorAlgebra
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.MinimalLeftIdeal
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define a finite index type for the eight color generators:

```lean
inductive ColorGen where
  | E12 | E21 | E13 | E31 | E23 | E32 | H12 | H23
```

Map each generator to a linear endomorphism:

```lean
noncomputable def ColorGen.toEnd :
    ColorGen -> (ComplexOctonion ->L[Complex] ComplexOctonion) := ...
```

Define equality on `J` for the bracket table, reusing `EqOnJ` and `opComm`.

Then prove as much of the finite bracket table as feasible. Priority:

```lean
theorem color_bracket_E12_E21 :
    EqOnJ (opComm ColorGen.E12.toEnd ColorGen.E21.toEnd) (-H12_op) := ...

theorem color_bracket_E23_E32 :
    EqOnJ (opComm ColorGen.E23.toEnd ColorGen.E32.toEnd) (-H23_op) := ...

theorem color_bracket_E12_E23 :
    EqOnJ (opComm ColorGen.E12.toEnd ColorGen.E23.toEnd) T13_op := ...
```

Then add missing diagonal-action identities such as:

```lean
EqOnJ (opComm H12_op T12_op) (c • T12_op)
EqOnJ (opComm H23_op T23_op) (c • T23_op)
```

Use the signs already present in `OperatorAlgebra.lean`; do not "fix" them to
match a paper convention without proving a convention conversion.

## Stretch targets

1. Define the color sector as a direct sum of two triplet-like submodules plus
   two singlet lines, using the existing `J_up_color`, `J_down_color`, and
   singlet definitions.
2. Prove `ColorGen.toEnd` preserves `J`.
3. Define induced endomorphisms of the subtype/submodule `J`.
4. Package the representation as an action of the generated Lie subalgebra
   if mathlib makes this lightweight.

## Claim boundary

This file should not claim the full Standard Model gauge group. It is the
finite operator-representation layer for Furey's color algebra on `J`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Respect the non-associative convention: use composed `Lmul` operators, never
  pre-multiplied octonion products for gauge actions.
- Keep sign differences explicit and documented.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/ColorRepresentation.lean
lake build PhysicsSM.Algebra.Furey.ColorRepresentation
lake build PhysicsSM
```
