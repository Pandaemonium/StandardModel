# Aristotle task: G2 fixing-e111 maps give GUT-square block consequences

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `48c1c6f7-eb3f-4ca6-afff-1a10b9604b93`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260601-project`
**Output**: `AgentTasks/aristotle-output/g2-fixing-e111-gut-square-20260601`
**Integrated**: 2026-06-01
**Type**: Baez octonion-to-GUT-square bridge

## Goal

Use the newly integrated theorem
`fixingE111MulLinear_preservesHermitian` to remove the explicit Hermitian
preservation hypothesis from the G2-to-GUT-square block consequences.

Earlier files prove consequences for a `FixingE111MulLinear` map assuming
`PreservesComplexTripleHermitian g`. The new Hermitian-preservation theorem
proves this assumption for every `FixingE111MulLinear`, so we should expose
paper-facing theorems directly in terms of `g : FixingE111MulLinear`.

## Requested file

Create:

```text
PhysicsSM/Algebra/Octonion/G2FixingE111GUTSquare.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2HermitianPreservation
import PhysicsSM.Algebra.Octonion.G2C3GUTPaperPackage
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `FixingE111MulLinear`
- `FixingE111MulLinear.onComplexVecMatrix`
- `fixingE111MulLinear_preservesHermitian`
- `c3MatrixAsGUTBlock`
- `preservesComplexTripleHermitian_gutBlock_patiSalam`
- `preservesComplexTripleHermitian_gutBlock_smBlock_of_det`
- `preservesComplexTripleHermitian_gutBlock_su5_of_det`
- `preservesComplexTripleHermitian_gutBlock_smBlock_iff_su5`
- `PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate`
- `PhysicsSM.Gauge.GUTSquare.SMBlockPredicate`
- `PhysicsSM.Gauge.GUTSquare.SU5Predicate`

## Target declarations

Prove the Pati-Salam block consequence without a separate Hermitian
preservation hypothesis:

```lean
theorem fixingE111MulLinear_gutBlock_patiSalam
    (g : FixingE111MulLinear) :
    PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) := ...
```

Prove determinant-explicit SM and SU(5) consequences:

```lean
theorem fixingE111MulLinear_gutBlock_smBlock_of_det
    (g : FixingE111MulLinear)
    (hdet : g.onComplexVecMatrix.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) := ...

theorem fixingE111MulLinear_gutBlock_su5_of_det
    (g : FixingE111MulLinear)
    (hdet : g.onComplexVecMatrix.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) := ...
```

Prove the SM/SU(5) equivalence for the block:

```lean
theorem fixingE111MulLinear_gutBlock_smBlock_iff_su5
    (g : FixingE111MulLinear) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
        (c3MatrixAsGUTBlock g.onComplexVecMatrix) <->
      PhysicsSM.Gauge.GUTSquare.SU5Predicate
        (c3MatrixAsGUTBlock g.onComplexVecMatrix) := ...
```

Add a bundled package:

```lean
structure G2FixingE111GUTSquarePackage where
  pati_salam :
    forall g : FixingE111MulLinear,
      PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
        (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  sm_block_of_det :
    forall g : FixingE111MulLinear,
      g.onComplexVecMatrix.det = 1 ->
        PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  su5_of_det :
    forall g : FixingE111MulLinear,
      g.onComplexVecMatrix.det = 1 ->
        PhysicsSM.Gauge.GUTSquare.SU5Predicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix)

theorem g2FixingE111GUTSquarePackage :
    G2FixingE111GUTSquarePackage := ...
```

## Claim boundary

This removes the Hermitian-preservation hypothesis but keeps the determinant
one hypothesis explicit for SM/SU(5). It does not prove determinant one,
`Stab_G2(e111) ~= SU(3)`, or a Lie group isomorphism.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change `ActsAsSU3OnC3`.
- Do not claim determinant one.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2FixingE111GUTSquare.lean
lake build PhysicsSM.Algebra.Octonion.G2FixingE111GUTSquare
```
