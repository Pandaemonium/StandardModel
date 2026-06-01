# Aristotle task: G2 C3 matrix GUTSquare unitarity wrappers

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `e9bb1c85-b367-4036-8d12-b207f0416bc3`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-raft-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-g2-c3-gut-unitary-wrapper-20260530`
**Result bundle**: `AgentTasks/aristotle-output/baez-g2-c3-gut-unitary-wrapper-20260530-result`
**Extracted result**: `AgentTasks/aristotle-output/baez-g2-c3-gut-unitary-wrapper-20260530-extracted/octonion-sm-next-raft-20260530-project_aristotle`
**Type**: Baez G2 stabilizer action bridge to `GUTSquare.IsUnitary`

## Goal

Connect the new `G2C3Unitary` matrix theorem to the existing
`PhysicsSM.Gauge.GUTSquare.IsUnitary` predicate.

This gives downstream GUT-square and Standard Model files a shared matrix
unitarity language instead of maintaining a parallel octonion-specific
predicate.

## Current context

Use:

```text
PhysicsSM.Algebra.Octonion.G2C3Unitary
PhysicsSM.Gauge.GUTSquare
```

Important declarations include:

- `MatrixActsUnitaryOnC3`
- `matrixActsUnitaryOnC3_iff_conjTranspose_mul`
- `MatrixActsUnitaryOnC3.conjTranspose_mul`
- `PreservesComplexTripleHermitian.onComplexVecMatrix_conjTranspose_mul`
- `MatrixActsUnitaryOnC3.det_normSq_eq_one`
- `PhysicsSM.Gauge.GUTSquare.IsUnitary`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Octonion/G2C3GUTUnitary.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2C3Unitary
import PhysicsSM.Gauge.GUTSquare
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Prove the equivalence between the octonion-side predicate and the shared
GUT-square unitarity predicate:

```lean
theorem matrixActsUnitaryOnC3_iff_gutSquare_isUnitary
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    MatrixActsUnitaryOnC3 M <->
      PhysicsSM.Gauge.GUTSquare.IsUnitary M := ...
```

Useful one-way wrappers:

```lean
theorem MatrixActsUnitaryOnC3.gutSquare_isUnitary
    {M : Matrix (Fin 3) (Fin 3) Complex}
    (hM : MatrixActsUnitaryOnC3 M) :
    PhysicsSM.Gauge.GUTSquare.IsUnitary M := ...

theorem PreservesComplexTripleHermitian.onComplexVecMatrix_gutSquare_isUnitary
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    PhysicsSM.Gauge.GUTSquare.IsUnitary g.onComplexVecMatrix := ...
```

Optional determinant wrappers, only if clean:

```lean
theorem MatrixActsUnitaryOnC3.det_normSq_eq_one_gutSquare
    {M : Matrix (Fin 3) (Fin 3) Complex}
    (hM : MatrixActsUnitaryOnC3 M) :
    Complex.normSq M.det = 1 := ...
```

and, if mathlib makes it short:

```lean
theorem MatrixActsUnitaryOnC3.det_ne_zero
    {M : Matrix (Fin 3) (Fin 3) Complex}
    (hM : MatrixActsUnitaryOnC3 M) :
    M.det != 0 := ...
```

Use the actual Lean spelling for inequality (`≠`) in the final code.

## Claim boundary

Do not claim `Stab_G2(e111) ~= SU(3)` and do not claim determinant one.
This file only unifies the predicate language and carries over already-proved
unitary consequences.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the matrix orientation from `G2C3Matrix`.
- Do not weaken `GUTSquare.IsUnitary`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2C3GUTUnitary.lean
lake build PhysicsSM.Algebra.Octonion.G2C3GUTUnitary
lake build PhysicsSM
```

## Integration

Integrated by Codex on 2026-05-31.

Live file:

```text
PhysicsSM/Algebra/Octonion/G2C3GUTUnitary.lean
```

Root import added to `PhysicsSM.lean`.

Verification run during integration:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2C3GUTUnitary.lean
lake build PhysicsSM.Algebra.Octonion.G2C3GUTUnitary
```

The integrated module is trusted code and contains no `sorry`, `admit`,
`axiom`, `opaque`, or `unsafe` declarations.
