# Aristotle task: G2 action matrix coordinates on C3

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `9d42234d-0414-4896-bc04-bffa48769f35`
**Previous job ID**: `a0446f57-bbc2-442c-8f23-e9d7b7a5ad8e` (failed with
Aristotle internal error; no proof artifact was available)
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-g2-c3-matrix-coordinates-20260530-retry-result`
**Extracted output**: `AgentTasks/aristotle-output/baez-g2-c3-matrix-coordinates-20260530-retry-extracted`
**Type**: Baez `Stab_G2(e111)` to coordinate matrix scaffold

## Goal

Add a matrix-coordinate package for the complex-linear action of
`FixingE111MulLinear` on the chosen `C^3` complement.

The current `G2SU3Bridge` gives a complex-linear map

```text
g.onComplexVecLinear : (Fin 3 -> Complex) ->L[Complex] (Fin 3 -> Complex)
```

This job should package that map as a concrete `3 x 3` complex matrix and
prove the apply theorem relating matrix-vector multiplication to the linear map.
This prepares the later determinant/volume-form target without claiming it yet.

## Current context

Use:

```text
PhysicsSM.Algebra.Octonion.G2SU3Bridge
PhysicsSM.Algebra.Octonion.ComplexTripleLinear
PhysicsSM.Algebra.Octonion.ComplexTripleHermitian
```

Important declarations include:

- `G2ComplexLine.FixingE111MulLinear`
- `FixingE111MulLinear.onComplexTripleLinear`
- `FixingE111MulLinear.onComplexVecLinear`
- `FixingE111MulLinear.onComplexVecLinear_apply`
- `PreservesComplexTripleNorm`
- `PreservesComplexTripleHermitian`
- `ActsAsSU3OnC3`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Octonion/G2C3Matrix.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2SU3Bridge
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define the matrix of the coordinate linear map:

```lean
noncomputable def FixingE111MulLinear.onComplexVecMatrix
    (g : FixingE111MulLinear) : Matrix (Fin 3) (Fin 3) Complex := ...
```

One standard convention is:

```lean
M i j = g.onComplexVecLinear (fun k => if k = j then 1 else 0) i
```

Document whether the matrix acts by `mulVec` or `vecMul`.

Prove the apply theorem:

```lean
theorem FixingE111MulLinear.onComplexVecMatrix_mulVec
    (g : FixingE111MulLinear) (v : Fin 3 -> Complex) :
    g.onComplexVecMatrix.mulVec v = g.onComplexVecLinear v := ...
```

Then add coordinate consequences of the existing preservation predicates:

```lean
theorem PreservesComplexTripleHermitian.matrix_preserves_dot
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g)
    (u v : Fin 3 -> Complex) :
    ComplexTriple.hermitian
      (ComplexTriple.ofComplexVec (g.onComplexVecMatrix.mulVec u))
      (ComplexTriple.ofComplexVec (g.onComplexVecMatrix.mulVec v)) =
    ComplexTriple.hermitian
      (ComplexTriple.ofComplexVec u)
      (ComplexTriple.ofComplexVec v) := ...
```

If useful, also define a conservative predicate:

```lean
def MatrixActsUnitaryOnC3 (M : Matrix (Fin 3) (Fin 3) Complex) : Prop := ...
```

but do not attempt determinant-one unless it is very lightweight.

## Claim boundary

Do not claim the full theorem `Stab_G2(e111) ~= SU(3)`. This is only the
coordinate matrix representation of the already-defined complex-linear action.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the project XOR convention and chosen unit `e111`.
- Be explicit about matrix orientation (`mulVec` vs `vecMul`).

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2C3Matrix.lean
lake build PhysicsSM.Algebra.Octonion.G2C3Matrix
lake build PhysicsSM
```

## Integration result

Integrated on 2026-05-30.

Added trusted module:

```text
PhysicsSM/Algebra/Octonion/G2C3Matrix.lean
```

Main declarations:

- `FixingE111MulLinear.onComplexVecMatrix`
- `FixingE111MulLinear.onComplexVecMatrix_mulVec`
- `PreservesComplexTripleHermitian.matrix_preserves_dot`
- `MatrixActsUnitaryOnC3`
- `PreservesComplexTripleHermitian.matrixActsUnitary`

The matrix convention is left multiplication by `mulVec`, with column `j`
defined as the image of the `j`th standard basis vector. The module was added
to `PhysicsSM.lean`.
