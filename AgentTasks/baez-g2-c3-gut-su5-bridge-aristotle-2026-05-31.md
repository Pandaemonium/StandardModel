# Aristotle task: G2 C3 GUT-square SU5 bridge

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium-High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `b5e6096d-77b6-4314-b3be-868460450ad1`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Type**: Baez G2/C3 block bridge strengthening

## Goal

Strengthen the current `G2C3GUTBlockBridge` by adding explicit SU(5) and
SM-block consequences for the block-diagonal embedding of a unitary `C3`
matrix.

The determinant-one hypothesis should remain explicit. This task must not
claim determinant one for the octonionic `G2` action.

## Requested file

Create:

```text
PhysicsSM/Algebra/Octonion/G2C3GUTSU5Bridge.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2C3GUTBlockBridge
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target declarations

Prove a direct SU(5) wrapper under the determinant-one hypothesis:

```lean
theorem matrixActsUnitaryOnC3_gutBlock_su5_of_det
    {M : Matrix (Fin 3) (Fin 3) Complex}
    (hM : MatrixActsUnitaryOnC3 M)
    (hdet : M.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock M) := ...
```

Prove that, once the C3 block is known unitary, the SM block predicate is
equivalent to the SU(5) determinant predicate:

```lean
theorem matrixActsUnitaryOnC3_gutBlock_smBlock_iff_su5
    {M : Matrix (Fin 3) (Fin 3) Complex}
    (hM : MatrixActsUnitaryOnC3 M) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock M) <->
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock M) := ...
```

Specialize the equivalence to the octonion-side action matrix:

```lean
theorem preservesComplexTripleHermitian_gutBlock_smBlock_iff_su5
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) <->
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) := ...
```

Package them:

```lean
structure G2C3GUTSU5BridgePackage where
  smBlock_iff_su5 :
    forall {M : Matrix (Fin 3) (Fin 3) Complex},
      MatrixActsUnitaryOnC3 M ->
        (PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
          (c3MatrixAsGUTBlock M) <->
         PhysicsSM.Gauge.GUTSquare.SU5Predicate
          (c3MatrixAsGUTBlock M))

theorem g2C3GUTSU5BridgePackage :
    G2C3GUTSU5BridgePackage := ...
```

## Claim boundary

This proves only block-predicate consequences from unitarity and an explicit
determinant-one hypothesis. It does not prove determinant one for the `G2`
action, the full `G2` stabilizer theorem, or a compact Lie group theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the 2+3 block convention from `GUTSquare`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2C3GUTSU5Bridge.lean
lake build PhysicsSM.Algebra.Octonion.G2C3GUTSU5Bridge
```

## Integration result

**Completed**: 2026-05-31
**Result bundle**: `AgentTasks/aristotle-output/baez-g2-c3-gut-su5-bridge-20260531-result`
**Extracted project**: `AgentTasks/aristotle-output/baez-g2-c3-gut-su5-bridge-20260531-extracted/octonion-sm-next-wave-20260531-project_aristotle`
**Integrated file**: `PhysicsSM/Algebra/Octonion/G2C3GUTSU5Bridge.lean`
**Root import**: `PhysicsSM.Algebra.Octonion.G2C3GUTSU5Bridge`

Aristotle proved the SU5/SM-block consequences for the block-diagonal C3
embedding. The determinant-one hypothesis remains explicit; no determinant
claim is made for the full octonionic `G2` action.

Verification run during integration:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2C3GUTSU5Bridge.lean
lake build PhysicsSM.Algebra.Octonion.G2C3GUTSU5Bridge
```
