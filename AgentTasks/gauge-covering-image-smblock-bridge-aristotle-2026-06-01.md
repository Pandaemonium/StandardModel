# Aristotle task: Covering image bridge to SMBlockPredicate

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `86fc0f73-f51f-437b-abc1-b0f9cb2a2cd3`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave3-20260601`
**Output**: `AgentTasks/aristotle-output/gauge-covering-image-smblock-20260601`
**Type**: Bridge from Z6 image subgroup to S(U(2)×U(3)) predicate

## Goal

Create a new trusted file:

```text
PhysicsSM/Gauge/StandardModelCoverageImageSMBlock.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelUnitZ6QuotientGroup
import PhysicsSM.Gauge.StandardModelGroupStructure
import PhysicsSM.Gauge.GUTSquare
```

and namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

## Mathematical context

The `StandardModelUnitZ6QuotientGroup` module proves that the quotient
`StandardModelUnitCoveringQuotient ≃* standardModelUnitCoveringImageSubgroup`,
where `standardModelUnitCoveringImageSubgroup` is the image of the covering
group homomorphism into `UnitCoveringImageCodomain` (pairs of invertible
complex matrices).

The Standard Model group `S(U(2) × U(3))` is identified via `SMBlockPredicate`
as block-diagonal matrices `fromBlocks A 0 0 B` where A is 2×2 unitary,
B is 3×3 unitary, and `det(A) * det(B) = 1`.

This file proves the **containment bridge** between these two descriptions:
the image of the covering map lands in `SMBlockPredicate`.

## Target theorems

### Part A: Image elements satisfy SMBlockPredicate (containment)

```lean
/-- The image of any UnitCoveringTriple under the covering map satisfies
    SMBlockPredicate (when viewed as a GUTMatrix via the block embedding). -/
theorem unitCoveringTriple_image_satisfiesSMBlock
    (x : UnitCoveringTriple) :
    SMBlockPredicate (unitCoveringTripleToGUTMatrix x) :=
```

where `unitCoveringTripleToGUTMatrix` packages the image into a `GUTMatrix`
via `fromBlocks`:

```lean
/-- Convert the image of a UnitCoveringTriple to a GUTMatrix block. -/
noncomputable def unitCoveringTripleToGUTMatrix
    (x : UnitCoveringTriple) : GUTMatrix :=
  fromBlocks (x.image.1.val) 0 0 (x.image.2.val)
```

**Proof strategy**: By definition, `x.image = (α³ · g, α⁻² · h)` for some
unit phase `α`, 2×2 unitary `g`, and 3×3 unitary `h`. Use `smBlock_iff_su5_and_patiSalam`
and:

- **Pati-Salam**: block structure holds by construction.
- **SU(5)**: need `(α³ · g)† · (α³ · g) = 1` (from unitarity of g and α³ · I₂
  being unitary) and `det(α³ · g) * det(α⁻² · h) = α⁶ · det(g) · α⁻⁶ · det(h)
  = det(g) · det(h)`. If `g ∈ U(2)` and `h ∈ U(3)`, then `|det(g)| = |det(h)| = 1`
  but the product need not be 1 in general.

**Correction**: the `UnitCoveringTriple` does not require `g ∈ SU(2)` or
`det(g) * det(h) = 1`. The constraint comes from the **image** landing in a
specific subgroup. The correct statement is:

For any `(α, g, h) ∈ UnitCoveringTriple`, the image pair
`(α³ · g, α⁻² · h)` has determinant product:
`det(α³ · g) * det(α⁻² · h) = α^(3·2) · det(g) · α^(-2·3) · det(h)
  = α⁶ · det(g) · α⁻⁶ · det(h) = det(g) · det(h)`.

The determinant-one condition thus holds iff `det(g) * det(h) = 1`.
This is NOT automatic for all UnitCoveringTriples.

**Revised target**: prove the following weaker but honest statement:

```lean
/-- For any UnitCoveringTriple whose components satisfy the SM block
    predicate, the image also satisfies it. Specifically, the
    determinant of the image pair equals det(g) * det(h). -/
theorem unitCoveringTriple_image_det_product
    (x : UnitCoveringTriple) :
    (x.image.1 : Matrix (Fin 2) (Fin 2) ℂ).det *
    (x.image.2 : Matrix (Fin 3) (Fin 3) ℂ).det =
    (x.su2Part : Matrix (Fin 2) (Fin 2) ℂ).det *
    (x.su3Part : Matrix (Fin 3) (Fin 3) ℂ).det
```

Then add a specific SM covering predicate on triples:

```lean
/-- A UnitCoveringTriple is an SM covering triple if the su2Part is
    unitary and the su3Part is unitary and their determinant product = 1. -/
structure SMCoveringTriple extends UnitCoveringTriple where
  su2_unitary : IsUnitary su2Part.val
  su3_unitary : IsUnitary su3Part.val
  det_product_one :
    su2Part.val.det * su3Part.val.det = 1
```

And prove:

```lean
/-- An SMCoveringTriple maps to an element satisfying SMBlockPredicate. -/
theorem smCoveringTriple_image_satisfiesSMBlock
    (x : SMCoveringTriple) :
    SMBlockPredicate (fromBlocks x.image.1.val 0 0 x.image.2.val)
```

### Part B: Covering map multiplicativity on GUTMatrix level

```lean
/-- The block embedding of the covering image is compatible with
    matrix multiplication. -/
theorem unitCoveringTripleToGUTMatrix_mul
    (x y : UnitCoveringTriple) :
    unitCoveringTripleToGUTMatrix (x * y) =
      unitCoveringTripleToGUTMatrix x * unitCoveringTripleToGUTMatrix y
```

This uses `fromBlocks_multiply` and `UnitCoveringTriple.image_mul`.

## Claim boundary

This file proves the algebraic bridge between the unit-level covering map
image and the SM block predicate. It does **not** prove surjectivity of
the covering map onto all of `S(U(2) × U(3))`, the full first-isomorphism
group theorem, or any topological quotient structure.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Prefer to state the strongest honest theorems over weakened ones.
- If the full containment fails, prove the determinant identity precisely
  and document why.
- Add to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Gauge/StandardModelCoverageImageSMBlock.lean
lake build PhysicsSM.Gauge.StandardModelCoverageImageSMBlock
```
