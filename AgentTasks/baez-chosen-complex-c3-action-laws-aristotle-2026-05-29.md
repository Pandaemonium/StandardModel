# Aristotle task: chosen complex action laws on C3

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Integrated**: 2026-05-29
**Aristotle job ID**: `50a34f32-5d71-4f17-97a0-72fe123eb0bb`
**Submission project**: `AgentTasks/aristotle-submit/baez-next-linear-coordinate-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-chosen-complex-c3-action-laws-20260529-extracted`
**Type**: Baez chosen complex line / action law infrastructure

## Goal

Fill out the algebraic laws for the action of the chosen complex line on the
complement `C^3`.

The current file `ComplexLineAction.lean` proves the key multiplication
compatibility:

```lean
(z.smulComplexTriple w).toOctonion = z.toOctonion * w.toOctonion
```

This job should prove the remaining action laws that make the chosen complex
line behave like scalar multiplication on the complement.

## Current context

The project already has:

- `PhysicsSM.Algebra.Octonion.ChosenComplexRing`
- `PhysicsSM.Algebra.Octonion.ComplexLineAction`
- `ChosenComplex.smulComplexTriple`
- `ChosenComplex.one_smulComplexTriple`
- `ChosenComplex.mul_smulComplexTriple`
- `ComplexTriple.toComplexVec_complexSmul`
- `ChosenComplex.toComplex_smulComplexTriple`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Octonion/ChosenComplexC3ActionLaws.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.ChosenComplexRing
import PhysicsSM.Algebra.Octonion.ComplexLineAction
```

If the result is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Please prove coordinate-level action laws for `ChosenComplex.smulComplexTriple`.
Useful target names include:

```lean
theorem ChosenComplex.zero_smulComplexTriple ...
theorem ChosenComplex.add_smulComplexTriple ...
theorem ChosenComplex.smulComplexTriple_zero ...
theorem ChosenComplex.smulComplexTriple_add ...
theorem ChosenComplex.neg_smulComplexTriple ...
theorem ChosenComplex.sub_smulComplexTriple ...
```

Suggested statement shapes:

```lean
(0 : ChosenComplex).smulComplexTriple w = 0
(z1 + z2).smulComplexTriple w =
  z1.smulComplexTriple w + z2.smulComplexTriple w
z.smulComplexTriple (0 : ComplexTriple) = 0
z.smulComplexTriple (u + v) =
  z.smulComplexTriple u + z.smulComplexTriple v
(-z).smulComplexTriple w = -(z.smulComplexTriple w)
(z1 - z2).smulComplexTriple w =
  z1.smulComplexTriple w - z2.smulComplexTriple w
```

If `Sub ComplexTriple` is not yet available in this project copy, either add a
local trusted instance in this file or omit the subtraction theorem and record
that omission in the summary.

Also add `toComplexVec` versions if they are short and useful.

## Constraints

- This job should be independent of the parallel `ComplexTripleLinear` job.
- Do not rely on modules that are only being requested in this same wave.
- Do not introduce `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not alter octonion multiplication conventions.
- Do not claim a group action theorem for `SU(3)`.

## Verification

Run at least:

```bash
lake build PhysicsSM.Algebra.Octonion.ChosenComplexC3ActionLaws
lake env lean PhysicsSM/Algebra/Octonion/ChosenComplexC3ActionLaws.lean
```
