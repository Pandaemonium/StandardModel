# Aristotle task: G2 fixing e111 acts as special unitary on C3

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-critical
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `18e4c351-dcaa-4466-9e8c-81c0eabde30e`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave9-20260601-project`
**Output**:
**Integrated**:
**Type**: Baez octonion SU(3) bridge

## Goal

Package the Baez bridge from octonion automorphisms fixing a chosen imaginary
unit to special-unitary action on the complementary `C^3`.

The repo already has:

- complex-line/complement splitting;
- `FixingE111MulLinear.onComplexVecMatrix`;
- Hermitian preservation in `G2HermitianPreservation`;
- determinant-one in `G2FixingE111DetOne`;
- composition/matrix functoriality in `G2FixingE111Composition`.

This task should combine those into a clean paper-facing theorem: every
`FixingE111MulLinear` induces a `3 x 3` complex matrix that is unitary and has
determinant `1`, and this assignment is compatible with identity and
composition.

## Requested file

Create:

```text
PhysicsSM/Algebra/Octonion/G2FixingE111SU3Package.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111DetOne
import PhysicsSM.Algebra.Octonion.G2FixingE111Composition
import PhysicsSM.Algebra.Octonion.G2C3GUTUnitary
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Do not edit `PhysicsSM.lean`; Codex will add imports during integration.

## Target declarations

Define a strong predicate if no convenient mathlib `SpecialUnitaryGroup`
interface is available:

```lean
structure MatrixActsAsSU3OnC3 (M : Matrix (Fin 3) (Fin 3) Complex) : Prop where
  unitary : MatrixActsUnitaryOnC3 M
  det_one : M.det = 1
```

Then prove:

```lean
theorem FixingE111MulLinear.onComplexVecMatrix_actsAsSU3
    (g : FixingE111MulLinear) :
    MatrixActsAsSU3OnC3 g.onComplexVecMatrix := ...
```

Also prove identity and multiplication compatibility:

```lean
@[simp] theorem FixingE111MulLinear.one_onComplexVecMatrix :
    (1 : FixingE111MulLinear).onComplexVecMatrix = 1 := ...

theorem FixingE111MulLinear.mul_onComplexVecMatrix
    (g h : FixingE111MulLinear) :
    (g * h).onComplexVecMatrix =
      g.onComplexVecMatrix * h.onComplexVecMatrix := ...
```

If these already exist, re-export or wrap them without duplicating names.

Optionally, if straightforward, define a subtype and monoid hom:

```lean
abbrev SU3Matrix := { M : Matrix (Fin 3) (Fin 3) Complex //
  MatrixActsAsSU3OnC3 M }

noncomputable def fixingE111ToSU3Matrix :
    FixingE111MulLinear ->* SU3Matrix := ...
```

If the subtype hom is awkward because the subtype lacks a monoid instance,
package identity/multiplication as theorem fields instead.

## Package

Add:

```lean
structure G2FixingE111SU3Package where
  acts_as_su3 :
    forall g : FixingE111MulLinear,
      MatrixActsAsSU3OnC3 g.onComplexVecMatrix
  matrix_one :
    (1 : FixingE111MulLinear).onComplexVecMatrix = 1
  matrix_mul :
    forall g h : FixingE111MulLinear,
      (g * h).onComplexVecMatrix =
        g.onComplexVecMatrix * h.onComplexVecMatrix

noncomputable def g2FixingE111SU3Package :
    G2FixingE111SU3Package := ...
```

## Claim boundary

This is the action-to-SU(3)-matrix side of Baez's stabilizer story. It does not
prove surjectivity onto all of `SU(3)`, connectedness of `G2`, or an
isomorphism `Stab_G2(e111) ~= SU(3)`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not alter octonion multiplication conventions.
- Do not edit `PhysicsSM.lean`.
- Prefer wrappers over changing existing theorem names.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Octonion.G2FixingE111SU3Package
```
