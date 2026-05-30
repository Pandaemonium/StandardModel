# Aristotle task: H3O complement as M3(C)

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `65b3e071-2e61-4352-aef7-3519da95fe7e`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-big-targets-20260530-min-project`
**Output**: `AgentTasks/aristotle-output/baez-h3o-complement-m3c-equivalence-20260530`
**Type**: DVT/Yokota/Baez `h3(O) = h3(C) + M3(C)` scaffold

## Integration result

Integrated 2026-05-30 into:

```text
PhysicsSM/Algebra/Jordan/H3OComplexMatrix.lean
```

The merged module defines the coordinate bridge from the complement of
`h3(C)` inside `h3(O)` to `Matrix (Fin 3) (Fin 3) C`, proves both round trips,
packages the subtype equivalence `complementEquivM3C`, and adds additive and
negation compatibility lemmas for both coordinate directions.

## Goal

Formalize the coordinate-level bridge behind the DVT/Yokota splitting:

```text
h3(O) = h3(C) + h3(C)^perp
h3(C)^perp ~= M3(C)
```

The trusted project already has the trace-form orthogonal splitting and the
`ComplexTriple ~= C^3` equivalence. This job should package the complement of
`h3(C)` as a complex 3-by-3 matrix space.

## Current context

Use:

```text
PhysicsSM.Algebra.Jordan.H3O
PhysicsSM.Algebra.Jordan.TraceForm
PhysicsSM.Algebra.Octonion.ComplexTripleLinear
```

Important declarations include:

- `H3O`
- `InStandardB`
- `InComplementOfB`
- `toH3CPart`
- `toComplementPart`
- `decomp_sum`
- `toComplementPart_inComplementOfB`
- `standardB_inter_complementOfB_eq_zero`
- `ComplexTriple.toComplexVec`
- `ComplexTriple.ofComplexVec`
- `ComplexTriple.linearEquivComplexVec`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Jordan/H3OComplexMatrix.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.TraceForm
import PhysicsSM.Algebra.Octonion.ComplexTripleLinear
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define a coordinate map from an `H3O` complement element to a complex matrix.
One reasonable convention is:

- row `0` is the `x` octonion complement coordinate,
- row `1` is the `y` octonion complement coordinate,
- row `2` is the `z` octonion complement coordinate,
- columns are the `Fin 3` complex coordinates of `ComplexTriple`.

Possible declarations:

```lean
noncomputable def complementToM3C
    (a : H3O) : Matrix (Fin 3) (Fin 3) Complex := ...

noncomputable def m3CToComplement
    (M : Matrix (Fin 3) (Fin 3) Complex) : H3O := ...
```

Prove:

```lean
theorem m3CToComplement_inComplementOfB
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    InComplementOfB (m3CToComplement M) := ...

theorem complementToM3C_m3CToComplement
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    complementToM3C (m3CToComplement M) = M := ...

theorem m3CToComplement_complementToM3C_of_inComplementOfB
    {a : H3O} (ha : InComplementOfB a) :
    m3CToComplement (complementToM3C a) = a := ...
```

If feasible, package this as an equivalence on the subtype:

```lean
noncomputable def complementEquivM3C :
    {a : H3O // InComplementOfB a} ~= Matrix (Fin 3) (Fin 3) Complex := ...
```

If module instances for the subtype are practical, make this a complex-linear
equivalence. Otherwise deliver the round-trip equivalence and add linearity
lemmas for `complementToM3C` and `m3CToComplement`.

## Claim boundary

This job is only a coordinate/vector-space bridge. Do not claim the full
Yokota/DVT theorem that the stabilizer is `(SU(3) x SU(3)) / Z3`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the `H3O` coordinate convention.
- Document the row/column convention clearly.
- Keep the result independent of compact Lie group claims.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/H3OComplexMatrix.lean
lake build PhysicsSM.Algebra.Jordan.H3OComplexMatrix
lake build PhysicsSM
```
