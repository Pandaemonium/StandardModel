# Aristotle task: Covering map surjectivity onto SMBlockPredicate

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `49425993-af9b-433f-ad4e-df25978073ce`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave4-20260602`
**Output**: `AgentTasks/aristotle-output/49425993-output`
**Integrated**: `PhysicsSM/Gauge/StandardModelCoveringMapSurjective.lean`
**Type**: Full covering map isomorphism — surjectivity side

## Goal

Create a new trusted file:

```text
PhysicsSM/Gauge/StandardModelCoveringMapSurjective.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelCoverageImageSMBlock
import PhysicsSM.Gauge.StandardModelGroupStructure
```

and namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

## Mathematical context

The `StandardModelCoverageImageSMBlock` module proves that every `SMCoveringTriple`
maps to an element satisfying `SMBlockPredicate` (forward direction). This file
proves the reverse: every element of `SMBlockPredicate` is in the image of some
`SMCoveringTriple` (surjectivity / converse direction).

Together with the forward direction, this establishes that the SM covering triples
exactly characterize `S(U(2) × U(3))` at the algebraic level.

## Key proof sketch

Given `M : GUTMatrix` with `SMBlockPredicate M`, obtain the block decomposition
`M = fromBlocks A 0 0 B` where `A : Matrix (Fin 2) (Fin 2) ℂ` is unitary,
`B : Matrix (Fin 3) (Fin 3) ℂ` is unitary, and `det(A) * det(B) = 1`.

Construct an `SMCoveringTriple` with:
- `phase := Units.mk0 1 one_ne_zero` — trivial unit phase
- `su2Part := (A as a unit matrix)` — A is invertible since unitary
- `su3Part := (B as a unit matrix)`
- `phase_norm_one := norm_one` — `‖(1 : ℂ)‖ = 1`
- `su2_unitary := A_unitary`
- `su3_unitary := B_unitary`
- `det_product_one := det(A) * det(B) = 1`

The image of this triple under the covering map is:
`(1³ · A, 1⁻² · B) = (A, B)`, so
`fromBlocks image.1.val 0 0 image.2.val = fromBlocks A 0 0 B = M`.

## Declarations to prove

```lean
/-- Every element satisfying SMBlockPredicate is in the image of an
    SMCoveringTriple under the covering map. -/
theorem smBlock_isCovering
    {M : GUTMatrix} (hM : SMBlockPredicate M) :
    ∃ x : SMCoveringTriple,
      fromBlocks x.image.1.val 0 0 x.image.2.val = M
```

The key helper needed is lifting a unitary matrix to a unit of the matrix type:

```lean
/-- A unitary matrix is invertible (it is a unit). -/
noncomputable def IsUnitary.toUnit {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℂ} (hM : IsUnitary M) :
    Units (Matrix n n ℂ) :=
  ⟨M, M.conjTranspose, hM, by rw [← mul_eq_one_comm]; exact hM⟩
```

Then package as:

```lean
/-- Bundled surjectivity result. -/
structure SMBlockCoveringSurjectivePackage where
  /-- Every SMBlock element is covered. -/
  is_covering :
    ∀ M : GUTMatrix, SMBlockPredicate M →
      ∃ x : SMCoveringTriple,
        fromBlocks x.image.1.val 0 0 x.image.2.val = M
  /-- The determinant product of any SMBlock element is 1. -/
  det_product :
    ∀ {A : Matrix (Fin 2) (Fin 2) ℂ} {B : Matrix (Fin 3) (Fin 3) ℂ},
      SMBlockPredicate (fromBlocks A 0 0 B) →
      A.det * B.det = 1

/-- The SMBlock surjectivity package. -/
noncomputable def smBlockCoveringSurjectivePackage :
    SMBlockCoveringSurjectivePackage
```

## Claim boundary

This proves algebraic surjectivity. It does **not** prove topological quotient
structure, smooth Lie group isomorphism, or uniqueness of the covering triple
(the preimage fibre is the Z₆ kernel, proved separately).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- The `IsUnitary.toUnit` helper (or equivalent) is the key ingredient.
- Add the new file to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Gauge/StandardModelCoveringMapSurjective.lean
lake build PhysicsSM.Gauge.StandardModelCoveringMapSurjective
```
