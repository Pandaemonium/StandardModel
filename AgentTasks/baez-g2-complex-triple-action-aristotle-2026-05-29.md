# Aristotle task: fixed-e111 maps act complex-linearly on C3

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Integrated**: 2026-05-29
**Aristotle job ID**: `ba3a8b2d-25f5-45d3-8ed5-bc3a21091713`
**Submission project**: `AgentTasks/aristotle-submit/baez-next-c3-action-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-g2-complex-triple-action-20260529-extracted`
**Type**: Baez fixed-complex-line action / complex-linearity theorem

## Goal

Upgrade the existing `G2ComplexLine` scaffold by defining the induced action
of a multiplication-preserving real-linear map fixing `e111` on the complement
coordinates, and prove that this induced action is complex-linear.

The project already has:

- `PhysicsSM.Algebra.Octonion.G2ComplexLine`
- `PhysicsSM.Algebra.Octonion.ComplexTripleModule`
- `FixingE111MulLinear`
- `preserves_chosen_complex_complement`
- `commutes_with_left_e111`
- `ComplexTriple.complexSmul`
- `ComplexTriple.complexSmul_I_eq_J`

This job should make precise the safe algebraic part of Baez's statement:

```text
Maps fixing the chosen imaginary unit act complex-linearly on the C^3
complement.
```

## Sources and claim boundary

Source motivation:

- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
- Baez, "The Octonions", Bull. Amer. Math. Soc. 2002.

Claim boundary:

- Do not claim `Stab_G2(e111) ~= SU(3)`.
- Do not introduce a `G2` group definition.
- Work only with the existing local record `FixingE111MulLinear`.
- This is a coordinate and linearity theorem about the induced action on
  `ComplexTriple`.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Octonion/G2ComplexTripleAction.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2ComplexLine
import PhysicsSM.Algebra.Octonion.ComplexTripleModule
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

First prove the missing complement projection helper if needed:

```lean
theorem toComplexTriple_toOctonion_of_inComplement
    {x : Octonion} (hx : InChosenComplexComplement x) :
    x.toComplexTriple.toOctonion = x
```

Define the induced complement action:

```lean
noncomputable def FixingE111MulLinear.onComplexTriple
    (g : FixingE111MulLinear) (w : ComplexTriple) : ComplexTriple :=
  (g.toFun w.toOctonion).toComplexTriple
```

Prove that it really reconstructs the action on the octonion complement:

```lean
theorem FixingE111MulLinear.onComplexTriple_toOctonion
    (g : FixingE111MulLinear) (w : ComplexTriple) :
    (g.onComplexTriple w).toOctonion = g.toFun w.toOctonion
```

Prove real-linearity:

```lean
theorem FixingE111MulLinear.onComplexTriple_add
    (g : FixingE111MulLinear) (u v : ComplexTriple) :
    g.onComplexTriple (u + v) =
      g.onComplexTriple u + g.onComplexTriple v

theorem FixingE111MulLinear.onComplexTriple_real_smul
    (g : FixingE111MulLinear) (r : Real) (w : ComplexTriple) :
    g.onComplexTriple (r • w) =
      r • g.onComplexTriple w
```

Then prove complex-linearity. A useful helper is:

```lean
theorem ComplexTriple.complexSmul_eq_real_add_I
    (z : Complex) (w : ComplexTriple) :
    ComplexTriple.complexSmul z w =
      z.re • w + z.im • ComplexTriple.complexSmul Complex.I w
```

Main target:

```lean
theorem FixingE111MulLinear.onComplexTriple_complex_smul
    (g : FixingE111MulLinear) (z : Complex) (w : ComplexTriple) :
    g.onComplexTriple (ComplexTriple.complexSmul z w) =
      ComplexTriple.complexSmul z (g.onComplexTriple w)
```

At minimum, prove the `Complex.I` case:

```lean
theorem FixingE111MulLinear.onComplexTriple_I_smul
    (g : FixingE111MulLinear) (w : ComplexTriple) :
    g.onComplexTriple (ComplexTriple.complexSmul Complex.I w) =
      ComplexTriple.complexSmul Complex.I (g.onComplexTriple w)
```

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken the `FixingE111MulLinear` hypotheses.
- Do not claim the final `SU(3)` stabilizer theorem.
- Preserve the existing `ComplexTriple` convention.
- Prefer reconstruction via `toOctonion` plus extensionality.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2ComplexTripleAction.lean
lake build PhysicsSM.Algebra.Octonion.G2ComplexTripleAction
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free,
and exact verification commands run.
