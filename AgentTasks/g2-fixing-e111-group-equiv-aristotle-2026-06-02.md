# Aristotle task: G₂ stabilizer Group structure and GroupEquiv

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `d8f56748-29a5-4a53-a024-b7090c47e8ba`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave4-20260602`
**Output**: `AgentTasks/aristotle-output/g2-fixing-e111-group-equiv-20260602`
**Type**: Upgrade the moonshot MulEquiv to a Group equivalence

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Octonion/G2FixingE111GroupEquiv.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111SU3Equiv
import PhysicsSM.Algebra.Jordan.DVTTwoSidedSU3QuotientStabilizer
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

## Mathematical context

The moonshot `G2FixingE111SU3Equiv` proved:

```lean
fixingE111MulLinearEquivSU3 : MulEquiv FixingE111MulLinear su3Submonoid
```

This is a monoid equivalence. However, `su3Submonoid` consists of unitary
matrices with determinant 1 — these are invertible, so `su3Submonoid` is
actually a **group**. Similarly, `FixingE111MulLinear` maps bijectively to an
invertible group, so it should also carry an inverse operation.

This file establishes the group structure on both sides and upgrades the
`MulEquiv` to a proper group isomorphism.

## Existing infrastructure

From `DVTTwoSidedSU3QuotientStabilizer.lean`:
- `SU3MatrixUnit` — structure with `Inv` and `Group` instances already proved.
- `SU3MatrixUnit.instGroup`

From `G2FixingE111SU3Equiv.lean`:
- `fixingE111MulLinearEquivSU3 : MulEquiv FixingE111MulLinear su3Submonoid`
- `matrixActsAsSU3OnC3.toFixingE111MulLinear` — the extension map (converse)

From `G2FixingE111MonoidHom.lean`:
- `su3Submonoid : Submonoid (Matrix (Fin 3) (Fin 3) ℂ)`
- `matrixActsAsSU3OnC3_mul` — product of SU3 matrices is SU3

## Target declarations

### Part A: `su3Submonoid` is a subgroup

```lean
/-- The inverse of an SU(3) matrix is again an SU(3) matrix. -/
theorem matrixActsAsSU3OnC3_inv
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsAsSU3OnC3 M) :
    MatrixActsAsSU3OnC3 M⁻¹

/-- The SU(3) matrices form a subgroup of GL(n, ℂ). -/
noncomputable def su3Subgroup :
    Subgroup (Matrix (Fin 3) (Fin 3) ℂ) where
  carrier := {M | MatrixActsAsSU3OnC3 M}
  mul_mem' := matrixActsAsSU3OnC3_mul
  one_mem' := matrixActsAsSU3OnC3_one
  inv_mem' := matrixActsAsSU3OnC3_inv
```

**Proof of `matrixActsAsSU3OnC3_inv`**:
- Unitarity: if `M† * M = 1`, then `M⁻¹ = M†` (from `isUnitary_inv_eq_conjTranspose`
  in `StandardModelGroupStructure`), so `(M⁻¹)† * M⁻¹ = M * M† = 1` (using
  `mul_conjTranspose_self`).
- Determinant: `det(M⁻¹) = 1 / det(M) = 1 / 1 = 1`.

### Part B: `FixingE111MulLinear` has inverses

```lean
/-- The inverse of a FixingE111MulLinear map, defined via the SU(3) equivalence. -/
noncomputable def FixingE111MulLinear.inv
    (g : FixingE111MulLinear) : FixingE111MulLinear :=
  matrixActsAsSU3OnC3.toFixingE111MulLinear
    (matrixActsAsSU3OnC3_inv (fixingE111MulLinearToSU3Hom g).property)

/-- `FixingE111MulLinear` forms a group under composition. -/
noncomputable instance FixingE111MulLinear.instGroup :
    Group FixingE111MulLinear where
  inv := FixingE111MulLinear.inv
  inv_mul_cancel g := ...
```

**Proof sketch for `inv_mul_cancel`**: The inverse is defined via the SU(3)
equivalence. Since `fixingE111MulLinearEquivSU3` is a bijection that respects
multiplication, it maps the `inv` to the SU(3) matrix inverse. Then:
`(inv g) * g` maps to `M⁻¹ * M = 1` in `su3Submonoid`, so by injectivity it
equals `1` in `FixingE111MulLinear`.

### Part C: Upgrade to group isomorphism

```lean
/-- The MulEquiv between FixingE111MulLinear and su3Submonoid respects
    the group (inverse) structure. -/
theorem fixingE111MulLinearEquivSU3_map_inv
    (g : FixingE111MulLinear) :
    (fixingE111MulLinearEquivSU3 g⁻¹ : Matrix (Fin 3) (Fin 3) ℂ) =
    (fixingE111MulLinearEquivSU3 g : Matrix (Fin 3) (Fin 3) ℂ)⁻¹

/-- The full G₂ stabilizer ≅ SU(3) isomorphism as a MulEquiv of groups. -/
noncomputable def fixingE111MulLinearGroupEquivSU3 :
    FixingE111MulLinear ≃* su3Subgroup
```

### Bundled package

```lean
/-- Package documenting G₂ stabilizer ≅ SU(3) as a group isomorphism. -/
structure G2FixingE111GroupEquivPackage where
  /-- The group isomorphism. -/
  group_equiv : FixingE111MulLinear ≃* su3Subgroup
  /-- The underlying MulEquiv agrees with the monoid hom. -/
  agrees_with_hom :
    ∀ g, (group_equiv g : Matrix (Fin 3) (Fin 3) ℂ) = g.onComplexVecMatrix
```

## Claim boundary

This proves the algebraic group isomorphism between `FixingE111MulLinear` and
`SU(3)` as subgroup of matrices. It does **not** prove:
- Lie group structure or smooth isomorphism.
- That `FixingE111MulLinear` is exactly `Stab_{G₂}(e111)` (that requires G₂ group theory).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- If `FixingE111MulLinear.instGroup` causes typeclass conflicts with the existing
  `Monoid` instance, rename or use a different approach.
- Add the new file to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2FixingE111GroupEquiv.lean
lake build PhysicsSM.Algebra.Octonion.G2FixingE111GroupEquiv
```
