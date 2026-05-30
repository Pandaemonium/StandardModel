# Aristotle task: ComplexTriple as a complex vector space

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Aristotle job ID**: `e02fccc8-1d5f-48ea-840a-665fefb07325`
**Submission project**: `AgentTasks/aristotle-submit/baez-next-linear-coordinate-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-complex-triple-linear-equivalence-20260529-extracted`
**Type**: Baez `O = C + C^3` / complex-linear infrastructure

## Goal

Promote the concrete six-real-coordinate type `ComplexTriple` to an honest
Lean complex vector space, and package its coordinate map as a complex-linear
equivalence with `Fin 3 -> Complex`.

This is the next algebraic layer behind the informal statement:

```text
After choosing e111 as i, the complement of C in O is C^3.
```

## Current context

The project already has:

- `PhysicsSM.Algebra.Octonion.ComplexTripleModule`
- `ComplexTriple.toComplexVec : ComplexTriple -> Fin 3 -> Complex`
- `ComplexTriple.ofComplexVec : (Fin 3 -> Complex) -> ComplexTriple`
- round-trip theorems for those maps
- `ComplexTriple.complexSmul : Complex -> ComplexTriple -> ComplexTriple`
- coordinate compatibility for `complexSmul`

The root build currently passes after the latest Baez/Krasnov integration.

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Octonion/ComplexTripleLinear.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexTripleModule
```

If the result is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Please prove as much of the following as is reasonable without weakening the
mathematical content.

1. Additive group structure:

```lean
instance : Sub ComplexTriple := ...
instance : AddCommGroup ComplexTriple := ...
```

Use the existing coordinate-wise `Zero`, `Add`, `Neg`, and `SMul Real`
definitions from `ComplexSplitting`.

2. Complex scalar action:

```lean
noncomputable instance : SMul Complex ComplexTriple := ...
```

The scalar action should be definitionally or propositionally the existing
`ComplexTriple.complexSmul`.

3. Complex module structure:

```lean
noncomputable instance : Module Complex ComplexTriple := ...
```

4. Coordinate linear equivalence:

```lean
noncomputable def ComplexTriple.linearEquivComplexVec :
    ComplexTriple ≃ₗ[Complex] (Fin 3 -> Complex) := ...
```

5. Useful simp lemmas:

```lean
@[simp] theorem ComplexTriple.linearEquivComplexVec_apply ...
@[simp] theorem ComplexTriple.linearEquivComplexVec_symm_apply ...
@[simp] theorem ComplexTriple.toComplexVec_smul ...
```

Use whatever exact statement shapes fit mathlib best.

## Constraints

- Do not edit the foundational coordinate convention.
- Do not introduce `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not claim anything about `SU(3)` or the Standard Model.
- Keep all new declarations inside `namespace PhysicsSM.Algebra.Octonion`.
- Keep comments clear about the project XOR basis and chosen unit `e111`.

## Verification

Run at least:

```bash
lake build PhysicsSM.Algebra.Octonion.ComplexTripleLinear
lake env lean PhysicsSM/Algebra/Octonion/ComplexTripleLinear.lean
```

If the file is imported by the root, also run:

```bash
lake build
```

## Integration result

Integrated on 2026-05-30 into:

```text
PhysicsSM/Algebra/Octonion/ComplexTripleLinear.lean
PhysicsSM.lean
```

The merged version reuses the existing `Sub ComplexTriple` instance and
field-accessor simp lemmas from `ChosenComplexC3ActionLaws`, avoiding duplicate
declarations from the raw Aristotle output.

Verified:

```bash
lake env lean PhysicsSM/Algebra/Octonion/ComplexTripleLinear.lean
lake build PhysicsSM.Algebra.Octonion.ComplexTripleLinear
```
