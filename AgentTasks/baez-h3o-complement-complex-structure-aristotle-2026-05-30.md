# Aristotle task: H3O complement complex structure

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `83d266db-8e67-4185-8d48-5f0a36bbbc97`
**Previous job ID**: `0191a0de-f498-4f5e-ae18-9578f69d6103` (failed with
Aristotle internal error; no proof artifact was available)
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-h3o-complement-complex-structure-20260530-retry-result`
**Extracted output**: `AgentTasks/aristotle-output/baez-h3o-complement-complex-structure-20260530-retry-extracted`
**Type**: DVT/Yokota/Baez `h3(O)` complement complex-vector-space scaffold

## Goal

Upgrade the newly integrated coordinate equivalence

```text
{a : H3O // InComplementOfB a} ~= Matrix (Fin 3) (Fin 3) Complex
```

to a reusable complex-structure API on the complement. This is the next safe
step toward the DVT/Yokota statement that the complement behaves like
`M3(C)`.

## Current context

Use:

```text
PhysicsSM.Algebra.Jordan.H3OComplexMatrix
PhysicsSM.Algebra.Jordan.TraceForm
PhysicsSM.Algebra.Octonion.ComplexTripleLinear
```

Important declarations include:

- `InComplementOfB`
- `complementToM3C`
- `m3CToComplement`
- `m3CToComplement_inComplementOfB`
- `complementToM3C_m3CToComplement`
- `m3CToComplement_complementToM3C_of_inComplementOfB`
- `complementEquivM3C`
- `complementToM3C_add`
- `complementToM3C_neg`
- `m3CToComplement_add`
- `m3CToComplement_neg`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Jordan/H3OComplexMatrixLinear.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.H3OComplexMatrix
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define complex scalar multiplication on the complement by transporting the
ordinary scalar multiplication on `Matrix (Fin 3) (Fin 3) Complex`:

```lean
noncomputable def complexSmulComplement (z : Complex) (a : H3O) : H3O :=
  m3CToComplement (z • complementToM3C a)
```

Then prove the safe coordinate facts:

```lean
theorem complexSmulComplement_inComplementOfB
    (z : Complex) (a : H3O) :
    InComplementOfB (complexSmulComplement z a)

theorem complexSmulComplement_m3CToComplement
    (z : Complex) (M : Matrix (Fin 3) (Fin 3) Complex) :
    complexSmulComplement z (m3CToComplement M) =
      m3CToComplement (z • M)

theorem complementToM3C_complexSmulComplement
    (z : Complex) (a : H3O) :
    complementToM3C (complexSmulComplement z a) =
      z • complementToM3C a
```

On elements already known to be in the complement, prove the transported module
laws:

```lean
theorem complexSmulComplement_one_of_inComplementOfB
    {a : H3O} (ha : InComplementOfB a) :
    complexSmulComplement 1 a = a

theorem complexSmulComplement_mul_of_inComplementOfB
    (z w : Complex) {a : H3O} (ha : InComplementOfB a) :
    complexSmulComplement z (complexSmulComplement w a) =
      complexSmulComplement (z * w) a

theorem complexSmulComplement_add_scalar
    (z w : Complex) (a : H3O) :
    complexSmulComplement (z + w) a =
      complexSmulComplement z a + complexSmulComplement w a

theorem complexSmulComplement_add_vector
    (z : Complex) (a b : H3O) :
    complexSmulComplement z (a + b) =
      complexSmulComplement z a + complexSmulComplement z b
```

If feasible, package the complement subtype as a complex module by transported
structure and define a complex-linear equivalence:

```lean
noncomputable def complementLinearEquivM3C :
    {a : H3O // InComplementOfB a} ~=l[Complex]
      Matrix (Fin 3) (Fin 3) Complex := ...
```

If the `Module` instance is awkward, do not force it; deliver the named scalar
transport lemmas above.

## Claim boundary

This is only a vector-space/coordinate API. Do not claim the DVT stabilizer
theorem `(SU(3) x SU(3)) / Z3`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the `H3O` or `ComplexTriple` coordinate conventions.
- Keep the row convention from `H3OComplexMatrix`: rows are `x`, `y`, `z`;
  columns are the three complex complement coordinates.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/H3OComplexMatrixLinear.lean
lake build PhysicsSM.Algebra.Jordan.H3OComplexMatrixLinear
lake build PhysicsSM
```

## Integration result

Integrated on 2026-05-30.

Added trusted module:

```text
PhysicsSM/Algebra/Jordan/H3OComplexMatrixLinear.lean
```

Main declarations:

- `complexSmulComplement`
- `complexSmulComplement_inComplementOfB`
- `complexSmulComplement_m3CToComplement`
- `complementToM3C_complexSmulComplement`
- `complexSmulComplement_one_of_inComplementOfB`
- `complexSmulComplement_mul_of_inComplementOfB`
- `complexSmulComplement_add_scalar`
- `complexSmulComplement_add_vector`
- `complementAddSubgroup`
- `complementLinearEquivM3C`

The module was added to `PhysicsSM.lean`.
