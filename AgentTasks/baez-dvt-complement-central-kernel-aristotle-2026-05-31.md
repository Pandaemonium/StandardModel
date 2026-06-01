# Aristotle task: DVT complement central scalar kernel

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium-High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `a643d85e-feaa-4e7b-9924-ec005dd28fe0`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-family-z6-next-20260531-project`
**Output**: `AgentTasks/aristotle-output/baez-dvt-complement-central-kernel-20260531`
**Result bundle**: `AgentTasks/aristotle-output/baez-dvt-complement-central-kernel-20260531-result`
**Extracted result**: `AgentTasks/aristotle-output/baez-dvt-complement-central-kernel-20260531-extracted/octonion-sm-family-z6-next-20260531-project_aristotle`
**Type**: DVT/Yokota central-kernel scaffold

## Goal

Package the central-scalar cancellation theorem from
`DVTComplementTwoSidedAction.lean` as a reusable central-kernel API.

This is a safe algebraic step toward the Yokota/Dubois-Violette-Todorov
quotient-by-center story: central pairs `(z I, z^-1 I)` act trivially on the
complement model. We are not proving a quotient group theorem here.

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Jordan/DVTComplementCentralKernel.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTComplementTwoSidedAction
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target declarations

Define the central scalar pair action:

```lean
noncomputable def h3oComplementCentralScalarAction (z : Complex) :
    H3OComplement ->+ H3OComplement :=
  h3oComplementTwoSidedAction
    (z • (1 : Matrix (Fin 3) (Fin 3) Complex))
    (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) Complex))
```

Prove wrappers:

```lean
theorem h3oComplementCentralScalarAction_eq_id
    {z : Complex} (hz : z != 0) :
    h3oComplementCentralScalarAction z =
      AddMonoidHom.id H3OComplement := ...

theorem h3oComplementCentralScalarAction_apply
    {z : Complex} (hz : z != 0) (w : H3OComplement) :
    h3oComplementCentralScalarAction z w = w := ...
```

Use the actual Lean spelling for inequality (`≠`) in final code.

Then prove an order-three/root-of-unity variant useful for the later `Z3`
kernel story:

```lean
theorem ne_zero_of_cube_eq_one {z : Complex} (hz : z ^ 3 = 1) :
    z != 0 := ...

theorem h3oComplementCentralScalarAction_eq_id_of_cube_eq_one
    {z : Complex} (hz : z ^ 3 = 1) :
    h3oComplementCentralScalarAction z =
      AddMonoidHom.id H3OComplement := ...

theorem h3oComplementCentralScalarAction_apply_of_cube_eq_one
    {z : Complex} (hz : z ^ 3 = 1) (w : H3OComplement) :
    h3oComplementCentralScalarAction z w = w := ...
```

Optional but useful: prove composition of two central scalar actions is again
trivial when both scalars are nonzero, either as equality to identity or as a
pointwise theorem.

## Claim boundary

This file proves only an additive-action central-kernel fact on the DVT
complement scaffold. It does not define a quotient group, a `Z3` subgroup, the
full Yokota action, or the DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the row convention inherited from `H3OComplexMatrix`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTComplementCentralKernel.lean
lake build PhysicsSM.Algebra.Jordan.DVTComplementCentralKernel
```

## Integration

Integrated by Codex on 2026-05-31.

Live file:

```text
PhysicsSM/Algebra/Jordan/DVTComplementCentralKernel.lean
```

Root import added to `PhysicsSM.lean`.

Verification run during integration:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTComplementCentralKernel.lean
lake build PhysicsSM.Algebra.Jordan.DVTComplementCentralKernel
```

The integrated module is trusted code and contains no `sorry`, `admit`,
`axiom`, `opaque`, or `unsafe` declarations.
