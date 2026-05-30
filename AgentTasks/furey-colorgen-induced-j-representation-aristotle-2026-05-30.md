# Aristotle task: Furey color generators induced on J

**Agent**: Aristotle
**Status**: Submitted
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `d8134d6a-2e95-4f3c-9b61-434068a3abd3`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260530-project`
**Output**: `AgentTasks/aristotle-output/furey-colorgen-induced-j-representation-20260530`
**Type**: Furey color representation on the minimal left ideal

## Goal

Promote the color-generator API from endomorphisms of `ComplexOctonion` with
equalities on `J` to genuine induced endomorphisms of the minimal left ideal
submodule `J`.

The current `ColorRepresentation` file gives `ColorGen.toEnd` and bracket
identities via `EqOnJ`. The next layer should prove every color generator
preserves `J` and define the induced linear maps on `J`.

## Current context

Use:

```text
PhysicsSM.Algebra.Furey.OperatorRepresentations
PhysicsSM.Algebra.Furey.OperatorAlgebra
PhysicsSM.Algebra.Furey.ColorRepresentation
```

Important declarations include:

- `J : Submodule Complex ComplexOctonion`
- `J_basis`
- `basisState`
- `EqOnJ`
- `EqOnJ_of_basis`
- `ColorGen`
- `ColorGen.toEnd`
- `T12_op`, `T21_op`, `T13_op`, `T31_op`, `T23_op`, `T32_op`
- `H12_op`, `H23_op`
- basis action tables for the `Tij_op`, `H12_op`, `H23_op`, and `H13_op`
- `J_up_color`, `J_down_color`, `J_singlet_low`, `J_singlet_high`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Furey/ColorJRepresentation.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.ColorRepresentation
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.MinimalLeftIdeal
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

First prove preservation of `J`:

```lean
theorem ColorGen.toEnd_mem_J
    (c : ColorGen) {x : ComplexOctonion} (hx : x in J) :
    c.toEnd x in J := ...
```

Use the actual Lean membership notation. A good proof route is finite
span-induction over `J`, with `fin_cases c` and the existing basis action
tables.

Then define the induced endomorphism:

```lean
noncomputable def ColorGen.toJEnd
    (c : ColorGen) : J ->L[Complex] J := ...
```

Prove apply/simp lemmas:

```lean
@[simp] theorem ColorGen.toJEnd_apply
    (c : ColorGen) (x : J) :
    (c.toJEnd x).val = c.toEnd x.val := ...
```

Then repackage at least the core bracket table on `J` as literal equality of
endomorphisms of the subtype, not merely `EqOnJ`:

```lean
theorem colorJ_bracket_E12_E21 :
    LinearMap.commutator ColorGen.E12.toJEnd ColorGen.E21.toJEnd =
      -ColorGen.H12.toJEnd := ...
```

Use the actual available commutator API. If `LinearMap.commutator` is awkward,
define a local `opCommJ` mirroring `opComm` and prove equality for that.

Priority bracket equalities:

- `[E12, E21] = -H12`
- `[E23, E32] = -H23`
- `[E12, E23] = E13`
- `[E21, E32] = -E31`

## Claim boundary

This file packages the finite color representation on `J`. It should not claim
the full Standard Model gauge group or a Lie group integration theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Respect the non-associative operator convention inherited from
  `OperatorAlgebra`: composed left multiplications mean `x |-> a * (b * x)`.
- Do not change signs from `OperatorAlgebra`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/ColorJRepresentation.lean
lake build PhysicsSM.Algebra.Furey.ColorJRepresentation
lake build PhysicsSM
```
