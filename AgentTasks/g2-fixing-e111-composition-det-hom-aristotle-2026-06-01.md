# Aristotle task: G2 fixing-e111 composition and determinant homomorphism

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `8cee4e53-4f7a-4f49-80a9-edafadd9b31c`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260601-project`
**Output**: `AgentTasks/aristotle-output/g2-fixing-e111-composition-det-hom-20260601`
**Integrated**: 2026-06-01
**Type**: Baez octonion-to-C3 functoriality API

## Goal

Turn `FixingE111MulLinear` into a composition monoid and prove that the
associated `C^3` matrix representation is compatible with composition. Then
package the determinant unit as a monoid homomorphism.

This is a key algebraic step toward treating the fixing-`e111` maps as a
concrete subgroup acting on `C^3`, while still avoiding the unproved
`Stab_G2(e111) = SU(3)` claim.

## Requested file

Create:

```text
PhysicsSM/Algebra/Octonion/G2FixingE111Composition.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111Determinant
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `FixingE111MulLinear`
- fields: `toFun`, `map_add`, `map_smul`, `map_one`, `map_mul`,
  `fixes_e111`, `map_conj`
- `FixingE111MulLinear.onComplexTriple`
- `FixingE111MulLinear.onComplexVecLinear`
- `FixingE111MulLinear.onComplexVecMatrix`
- `FixingE111MulLinear.onComplexVecMatrix_mulVec`
- `FixingE111MulLinear.detUnit`
- `FixingE111MulLinear.detUnit_val`

## Target declarations

Define identity and composition:

```lean
def FixingE111MulLinear.id : FixingE111MulLinear := ...

def FixingE111MulLinear.comp
    (g h : FixingE111MulLinear) : FixingE111MulLinear := ...

instance : One FixingE111MulLinear := ...
instance : Mul FixingE111MulLinear := ...
```

Add useful simp/apply lemmas:

```lean
@[simp] theorem FixingE111MulLinear.one_apply (x : Octonion) :
    (1 : FixingE111MulLinear).toFun x = x := ...

@[simp] theorem FixingE111MulLinear.mul_apply
    (g h : FixingE111MulLinear) (x : Octonion) :
    (g * h).toFun x = g.toFun (h.toFun x) := ...

@[simp] theorem FixingE111MulLinear.one_onComplexVecMatrix :
    (1 : FixingE111MulLinear).onComplexVecMatrix = 1 := ...

theorem FixingE111MulLinear.mul_onComplexVecMatrix
    (g h : FixingE111MulLinear) :
    (g * h).onComplexVecMatrix =
      g.onComplexVecMatrix * h.onComplexVecMatrix := ...
```

If the exact orientation of composition in the matrix theorem differs, use the
orientation forced by `mul_apply`, and document it in the module docstring.

Prove monoid laws:

```lean
instance FixingE111MulLinear.instMonoid : Monoid FixingE111MulLinear := ...
```

Then package the determinant unit as a monoid hom:

```lean
noncomputable def fixingE111MulLinearDetUnitMonoidHom :
    FixingE111MulLinear ->* Units Complex := ...

@[simp] theorem fixingE111MulLinearDetUnitMonoidHom_apply
    (g : FixingE111MulLinear) :
    fixingE111MulLinearDetUnitMonoidHom g = g.detUnit := ...
```

Add a bundled package:

```lean
structure G2FixingE111CompositionPackage where
  fixing_monoid : Monoid FixingE111MulLinear
  matrix_mul :
    forall g h : FixingE111MulLinear,
      (g * h).onComplexVecMatrix =
        g.onComplexVecMatrix * h.onComplexVecMatrix
  det_unit_hom : FixingE111MulLinear ->* Units Complex

noncomputable def g2FixingE111CompositionPackage :
    G2FixingE111CompositionPackage := ...
```

## Claim boundary

This proves functoriality of the current multiplicative-linear fixing-`e111`
record. It does not prove that this record is exactly `G2`, that every element
has determinant one, connectedness, or a Lie group isomorphism with `SU(3)`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the definition of `FixingE111MulLinear`.
- Do not claim determinant one.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2FixingE111Composition.lean
lake build PhysicsSM.Algebra.Octonion.G2FixingE111Composition
```
