# Aristotle task: G₂ stabilizer MonoidHom to SU(3) matrices

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `e951d68e-818f-434e-bf17-2dc6a5afecc0`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave3-20260601`
**Output**: `AgentTasks/aristotle-output/g2-monoidhom-su3-20260601`
**Type**: Functoriality package — G₂ stabilizer → SU(3) as MonoidHom

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Octonion/G2FixingE111MonoidHom.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111SU3Package
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

## Mathematical context

The `G2FixingE111SU3Package` proves that every `FixingE111MulLinear` map
induces a matrix in SU(3). The `G2FixingE111Composition` proves that
`onComplexVecMatrix` is compatible with composition (matrix multiplication)
and sends the identity to the identity matrix.

This file packages these facts as a `MonoidHom` from the monoid of
`FixingE111MulLinear` maps (under composition) to the monoid of 3×3
complex matrices.

## Existing infrastructure

From `G2FixingE111SU3Package.lean` / `G2FixingE111Composition.lean`:

```lean
-- Available (re-exported or proved):
FixingE111MulLinear.one_onComplexVecMatrix :
    (1 : FixingE111MulLinear).onComplexVecMatrix = 1

FixingE111MulLinear.mul_onComplexVecMatrix (g h : FixingE111MulLinear) :
    (g * h).onComplexVecMatrix =
      g.onComplexVecMatrix * h.onComplexVecMatrix

FixingE111MulLinear.onComplexVecMatrix_actsAsSU3 (g : FixingE111MulLinear) :
    MatrixActsAsSU3OnC3 g.onComplexVecMatrix
```

`FixingE111MulLinear` already has `Mul` and `One` instances from
`G2FixingE111Composition` (as `comp` and `id`), giving it a monoid
structure.

## Target declarations

### Monoid instance on FixingE111MulLinear

```lean
/-- The composition of FixingE111MulLinear maps is a monoid. -/
instance : Monoid FixingE111MulLinear where
  mul := FixingE111MulLinear.comp
  one := FixingE111MulLinear.id
  mul_assoc a b c := by ext; rfl
  one_mul a := by ext; rfl
  mul_one a := by ext; rfl
```

### MonoidHom to 3×3 complex matrices

```lean
/-- The assignment `g ↦ g.onComplexVecMatrix` is a monoid homomorphism
    from `FixingE111MulLinear` to `Matrix (Fin 3) (Fin 3) ℂ`. -/
noncomputable def fixingE111MulLinearToMatrixHom :
    FixingE111MulLinear →* Matrix (Fin 3) (Fin 3) ℂ where
  toFun g := g.onComplexVecMatrix
  map_one' := FixingE111MulLinear.one_onComplexVecMatrix
  map_mul' g h := FixingE111MulLinear.mul_onComplexVecMatrix g h
```

### Image lands in SU(3) predicate

```lean
/-- The image of `fixingE111MulLinearToMatrixHom` lands in the SU(3)
    predicate: every image matrix is unitary with determinant 1. -/
theorem fixingE111MulLinearToMatrixHom_image_actsAsSU3
    (g : FixingE111MulLinear) :
    MatrixActsAsSU3OnC3 (fixingE111MulLinearToMatrixHom g) :=
  FixingE111MulLinear.onComplexVecMatrix_actsAsSU3 g
```

### Restriction to SU(3) submonoid (optional)

If the `SpecialUnitaryGroup` or a suitable SU(3) subtype is available,
restrict the homomorphism to land in SU(3):

```lean
/-- The `FixingE111MulLinear → SU(3)` map as a monoid hom into the
    SU(3) submonoid. -/
noncomputable def fixingE111MulLinearToSU3Hom :
    FixingE111MulLinear →* {M : Matrix (Fin 3) (Fin 3) ℂ //
        MatrixActsAsSU3OnC3 M} where
  toFun g := ⟨g.onComplexVecMatrix,
              FixingE111MulLinear.onComplexVecMatrix_actsAsSU3 g⟩
  map_one' := by
    ext1
    exact FixingE111MulLinear.one_onComplexVecMatrix
  map_mul' g h := by
    ext1
    exact FixingE111MulLinear.mul_onComplexVecMatrix g h
```

### Bundled package

```lean
/-- Bundled record collecting the G₂ → SU(3) monoid homomorphism results. -/
structure G2FixingE111MonoidHomPackage where
  /-- The monoid hom to matrices. -/
  toMatrixHom : FixingE111MulLinear →* Matrix (Fin 3) (Fin 3) ℂ
  /-- Every image lies in SU(3). -/
  image_actsAsSU3 :
    ∀ g : FixingE111MulLinear,
      MatrixActsAsSU3OnC3 (toMatrixHom g)
  /-- The homomorphism is injective (optional — if provable). -/
  -- injective : Function.Injective toMatrixHom

/-- The canonical G₂-to-SU(3) monoid hom package. -/
noncomputable def g2FixingE111MonoidHomPackage :
    G2FixingE111MonoidHomPackage where
  toMatrixHom := fixingE111MulLinearToMatrixHom
  image_actsAsSU3 := fixingE111MulLinearToMatrixHom_image_actsAsSU3
```

## Claim boundary

This file packages the G₂-stabilizer-to-SU(3) assignment as a monoid
homomorphism. It does **not** prove:
- Surjectivity of `fixingE111MulLinearToMatrixHom` onto SU(3).
- Injectivity (which would require that two distinct automorphisms of 𝕆
  fixing e111 cannot induce the same matrix on ℂ³).
- The full isomorphism `Stab_{G₂}(e111) ≅ SU(3)`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- If the `Monoid FixingE111MulLinear` instance conflicts with existing
  instances, use `noncomputable instance` or wrap in a new type synonym.
- Add the new file to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2FixingE111MonoidHom.lean
lake build PhysicsSM.Algebra.Octonion.G2FixingE111MonoidHom
```
