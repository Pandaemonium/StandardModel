# Aristotle task: chosen complex line action on C3

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Integrated**: 2026-05-29
**Aristotle job ID**: `7ba6461e-4eac-4d04-a8dc-dade003a64b1`
**Submission project**: `AgentTasks/aristotle-submit/baez-next-c3-action-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-complex-line-action-on-c3-20260529-extracted`
**Type**: Baez `O = C + C^3` / coordinate multiplication theorem

## Goal

Prove that left multiplication by an element of the chosen complex line acts on
the complement as ordinary complex scalar multiplication on the `C^3`
coordinates.

This is the next precise theorem behind the informal statement:

```text
After choosing i = e111, the six remaining real dimensions form C^3.
```

The project already has:

- `PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra`
- `PhysicsSM.Algebra.Octonion.ComplexTripleModule`
- `ChosenComplex.toOctonion`
- `ComplexTriple.toOctonion`
- `ComplexTriple.complexSmul`
- `ComplexTriple.complexSmul_I_eq_J`

## Sources and claim boundary

Source motivation:

- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
- Dubois-Violette and Todorov, arXiv:1806.09450.

Claim boundary:

- This proves an explicit coordinate multiplication theorem.
- It does not claim the stabilizer is `SU(3)` or derive the Standard Model
  gauge group.
- Use the project XOR basis and existing `ComplexTriple` coordinate convention.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Octonion/ComplexLineAction.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra
import PhysicsSM.Algebra.Octonion.ComplexTripleModule
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define the action of the chosen complex line on the complement by complex
scalar multiplication:

```lean
noncomputable def ChosenComplex.smulComplexTriple
    (z : ChosenComplex) (w : ComplexTriple) : ComplexTriple :=
  ComplexTriple.complexSmul z.toComplex w
```

Prove coordinate compatibility:

```lean
theorem ChosenComplex.toComplex_smulComplexTriple
    (z : ChosenComplex) (w : ComplexTriple) :
    (z.smulComplexTriple w).toComplexVec =
      fun k => z.toComplex * w.toComplexVec k
```

Prove the main octonion theorem:

```lean
theorem ChosenComplex.smulComplexTriple_toOctonion
    (z : ChosenComplex) (w : ComplexTriple) :
    (z.smulComplexTriple w).toOctonion =
      z.toOctonion * w.toOctonion
```

Also prove the projected-coordinate version:

```lean
theorem ChosenComplex.left_mul_complement_toComplexTriple
    (z : ChosenComplex) (w : ComplexTriple) :
    (z.toOctonion * w.toOctonion).toComplexTriple =
      z.smulComplexTriple w
```

Useful additional lemmas if easy:

```lean
theorem ChosenComplex.one_smulComplexTriple (w : ComplexTriple) :
    (1 : ChosenComplex).smulComplexTriple w = w

theorem ChosenComplex.mul_smulComplexTriple
    (z1 z2 : ChosenComplex) (w : ComplexTriple) :
    (z1 * z2).smulComplexTriple w =
      z1.smulComplexTriple (z2.smulComplexTriple w)
```

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the `ComplexTriple` coordinate convention exactly.
- Do not use associative algebra abstractions for octonions.
- Prove by coordinate expansion where needed.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/ComplexLineAction.lean
lake build PhysicsSM.Algebra.Octonion.ComplexLineAction
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free,
and exact verification commands run.
