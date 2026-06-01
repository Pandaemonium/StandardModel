# Aristotle task: Baez G2-C3 GUT paper package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `7cefa6ce-8341-4b39-a59f-9e971a0f0ef5`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-paper-goals-20260531-project`
**Output**: `AgentTasks/aristotle-output/baez-g2-c3-gut-paper-package-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/baez-g2-c3-gut-paper-package-20260531-extracted`
**Type**: Baez/GUT-square paper-facing package

## Goal

Bundle the existing G2-C3 block-embedding results into a single paper-facing
package: preserving the complex triple Hermitian form gives the Pati-Salam
block predicate, and with an explicit determinant-one hypothesis it gives the
SU(5)/Standard-Model block predicates.

The key point is to make the determinant boundary explicit and reviewable.

## Requested file

Create:

```text
PhysicsSM/Algebra/Octonion/G2C3GUTPaperPackage.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2C3GUTSU5Bridge
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations:

- `FixingE111MulLinear`
- `PreservesComplexTripleHermitian`
- `MatrixActsUnitaryOnC3`
- `c3MatrixAsGUTBlock`
- `matrixActsUnitaryOnC3_gutBlock_patiSalam`
- `matrixActsUnitaryOnC3_gutBlock_smBlock_of_det`
- `matrixActsUnitaryOnC3_gutBlock_su5_of_det`
- `matrixActsUnitaryOnC3_gutBlock_smBlock_iff_su5`
- `preservesComplexTripleHermitian_gutBlock_patiSalam`
- `preservesComplexTripleHermitian_gutBlock_smBlock_iff_su5`
- `PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate`
- `PhysicsSM.Gauge.GUTSquare.SMBlockPredicate`
- `PhysicsSM.Gauge.GUTSquare.SU5Predicate`

## Target declarations

Prove determinant-explicit consequences for a Hermitian-preserving `g`:

```lean
theorem preservesComplexTripleHermitian_gutBlock_smBlock_of_det
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g)
    (hdet : g.onComplexVecMatrix.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) := ...

theorem preservesComplexTripleHermitian_gutBlock_su5_of_det
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g)
    (hdet : g.onComplexVecMatrix.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) := ...
```

Then bundle the three paper-facing facts:

```lean
structure G2C3GUTPaperPackage where
  pati_salam :
    forall {g : FixingE111MulLinear},
      PreservesComplexTripleHermitian g ->
        PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  sm_block_of_det :
    forall {g : FixingE111MulLinear},
      PreservesComplexTripleHermitian g ->
        g.onComplexVecMatrix.det = 1 ->
          PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
            (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  su5_of_det :
    forall {g : FixingE111MulLinear},
      PreservesComplexTripleHermitian g ->
        g.onComplexVecMatrix.det = 1 ->
          PhysicsSM.Gauge.GUTSquare.SU5Predicate
            (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  smBlock_iff_su5 :
    forall {g : FixingE111MulLinear},
      PreservesComplexTripleHermitian g ->
        (PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix) <->
         PhysicsSM.Gauge.GUTSquare.SU5Predicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix))

theorem g2C3GUTPaperPackage : G2C3GUTPaperPackage := ...
```

Use Lean's actual iff notation in the generated file if needed.

## Claim boundary

This package does not prove that every Hermitian-preserving map has determinant
one. It also does not prove a full `G2` stabilizer theorem or a Lie group
identification. The determinant-one hypothesis must remain explicit.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not hide or infer the determinant-one assumption.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2C3GUTPaperPackage.lean
lake build PhysicsSM.Algebra.Octonion.G2C3GUTPaperPackage
```

## Integration result

Integrated on 2026-05-31 from Aristotle job
`7cefa6ce-8341-4b39-a59f-9e971a0f0ef5`.

Live file:

```text
PhysicsSM/Algebra/Octonion/G2C3GUTPaperPackage.lean
```

Root import added to `PhysicsSM.lean`:

```lean
import PhysicsSM.Algebra.Octonion.G2C3GUTPaperPackage
```

The result bundles the Pati-Salam, Standard-Model block, SU(5), and
SM-block iff SU(5) consequences of the current `G2`-on-`C3` bridge. The
determinant-one hypothesis remains explicit.

Verification run during integration:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2C3GUTPaperPackage.lean
```
