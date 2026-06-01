# Aristotle task: G2 C3 matrix unitarity equation

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `cbd34104-6c94-46e0-b791-1c2ce5709e07`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-raft-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-g2-c3-unitarity-equation-20260530`
**Extracted output**: `AgentTasks/aristotle-output/baez-g2-c3-unitarity-equation-20260530-extracted`
**Integrated file**: `PhysicsSM/Algebra/Octonion/G2C3Unitary.lean`
**Type**: Baez `Stab_G2(e111)` coordinate matrix unitarity bridge

## Goal

Upgrade the coordinate Hermitian-preservation predicate from
`G2C3Matrix.lean` into the standard matrix equation:

```text
M.conjTranspose * M = 1
```

This is the next clean step from "acts by a Hermitian-preserving map on C^3"
toward "acts through U(3)", without claiming the full determinant-one
`SU(3)` theorem.

## Current context

Use:

```text
PhysicsSM.Algebra.Octonion.G2C3Matrix
PhysicsSM.Algebra.Octonion.ComplexTripleHermitian
PhysicsSM.Algebra.Octonion.ComplexTripleLinear
```

Important declarations include:

- `ComplexTriple.hermitian`
- `ComplexTriple.ofComplexVec`
- `ComplexTriple.toComplexVec_ofComplexVec`
- `FixingE111MulLinear.onComplexVecMatrix`
- `FixingE111MulLinear.onComplexVecMatrix_mulVec`
- `MatrixActsUnitaryOnC3`
- `PreservesComplexTripleHermitian.matrixActsUnitary`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Octonion/G2C3Unitary.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2C3Matrix
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

First prove a coordinate formula for the Hermitian form:

```lean
theorem ComplexTriple.hermitian_ofComplexVec
    (u v : Fin 3 -> Complex) :
    ComplexTriple.hermitian
      (ComplexTriple.ofComplexVec u)
      (ComplexTriple.ofComplexVec v) =
    sum (fun k : Fin 3 => starRingEnd Complex (u k) * v k) := ...
```

Use the actual Mathlib finite-sum notation that typechecks locally.

Then prove the key equivalence:

```lean
theorem matrixActsUnitaryOnC3_iff_conjTranspose_mul
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    MatrixActsUnitaryOnC3 M <-> M.conjTranspose * M = 1 := ...
```

Useful one-way wrappers are welcome:

```lean
theorem MatrixActsUnitaryOnC3.conjTranspose_mul
    {M : Matrix (Fin 3) (Fin 3) Complex}
    (hM : MatrixActsUnitaryOnC3 M) :
    M.conjTranspose * M = 1 := ...

theorem PreservesComplexTripleHermitian.onComplexVecMatrix_conjTranspose_mul
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    g.onComplexVecMatrix.conjTranspose * g.onComplexVecMatrix = 1 := ...
```

Optional stretch, only if short and clean:

```lean
theorem MatrixActsUnitaryOnC3.det_normSq_eq_one
    {M : Matrix (Fin 3) (Fin 3) Complex}
    (hM : MatrixActsUnitaryOnC3 M) :
    Complex.normSq M.det = 1 := ...
```

## Claim boundary

Do not claim `Stab_G2(e111) ~= SU(3)` and do not claim determinant one.
This job only identifies the Hermitian-preservation predicate with the usual
unitary matrix equation.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the project XOR octonion convention and chosen unit `e111`.
- Preserve the `mulVec` matrix orientation from `G2C3Matrix`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2C3Unitary.lean
lake build PhysicsSM.Algebra.Octonion.G2C3Unitary
lake build PhysicsSM
```

## Integration result

Integrated on 2026-05-30.

Aristotle produced a trusted theorem package containing:

- `ComplexTriple.hermitian_ofComplexVec`
- `matrixActsUnitaryOnC3_iff_star_dotProduct`
- `star_dotProduct_iff_conjTranspose_mul`
- `matrixActsUnitaryOnC3_iff_conjTranspose_mul`
- `MatrixActsUnitaryOnC3.conjTranspose_mul`
- `PreservesComplexTripleHermitian.onComplexVecMatrix_conjTranspose_mul`
- `MatrixActsUnitaryOnC3.det_normSq_eq_one`

During integration, unused simp arguments were removed from one proof to avoid
new warning noise. The theorem statements were not changed.
