# Aristotle task: SMBlockPredicate subgroup structure

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `7f6955f8-c55f-4ecd-a151-09e2915002d6`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave2-20260531`
**Output**: `AgentTasks/aristotle-output/gauge-smblock-subgroup-20260531`
**Type**: Group structure advance toward Z6 first-isomorphism theorem

## Goal

Prove that the Standard Model block predicate `SMBlockPredicate` defines a
subgroup: it is closed under multiplication, contains the identity, and is
closed under inverses.

Create a new trusted file:

```text
PhysicsSM/Gauge/StandardModelGroupStructure.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelSubgroup
import PhysicsSM.Gauge.GUTSquare
import PhysicsSM.Gauge.BlockEmbeddings
```

and namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

## Main declarations to prove

```lean
-- The 5×5 block type used throughout the gauge section
abbrev GUTMatrix := Matrix (Sum (Fin 2) (Fin 3)) (Sum (Fin 2) (Fin 3)) ℂ

/-- The identity matrix satisfies SMBlockPredicate. -/
theorem SMBlockPredicate_one :
    SMBlockPredicate (1 : GUTMatrix)

/-- SMBlockPredicate is closed under matrix multiplication. -/
theorem SMBlockPredicate_mul
    {A B : GUTMatrix}
    (hA : SMBlockPredicate A) (hB : SMBlockPredicate B) :
    SMBlockPredicate (A * B)

/-- If A satisfies SMBlockPredicate, so does its inverse. -/
theorem SMBlockPredicate_inv
    {A : GUTMatrix}
    (hA : SMBlockPredicate A) :
    SMBlockPredicate A⁻¹
```

Then package these as a `Subgroup` (or at least a `Submonoid`) if the
Lean infrastructure allows it:

```lean
/-- The set of matrices satisfying `SMBlockPredicate` forms a subgroup
    of GL(5, ℂ). -/
def standardModelBlockSubgroup : Subgroup (Matrix.GeneralLinearGroup
    (Sum (Fin 2) (Fin 3)) ℂ) where
  carrier := { A | SMBlockPredicate A.val }
  mul_mem' := ...
  one_mem' := ...
  inv_mem' := ...
```

If packaging as a `Subgroup` of `GL` is too infrastructure-heavy, the
three closure theorems above are the priority.

## Context and existing infrastructure

From `PhysicsSM/Gauge/GUTSquare.lean`:

```lean
/-- A matrix satisfies the SM block predicate iff it simultaneously
    satisfies the SU(5) and Pati-Salam predicates. -/
theorem smBlock_iff_su5_and_patiSalam
    {M : GUTMatrix} :
    SMBlockPredicate M ↔ SU5Predicate M ∧ PatiSalamPredicate M
```

So `SMBlockPredicate M` means:
- `SU5Predicate M`: M is unitary with determinant 1 in the SU(5) sense,
  i.e., `M.conjTranspose * M = 1` and `M.det = 1` (or equivalent).
- `PatiSalamPredicate M`: M decomposes into a 2×2 block and 3×3 block,
  i.e., preserves the sum structure `Sum (Fin 2) (Fin 3)`.

From `PhysicsSM/Gauge/BlockEmbeddings.lean`:
- `c3MatrixAsGUTBlock`, `smBlockDiagonal` and related embeddings.

## Informal proof strategy

**For `SMBlockPredicate_one`**: The identity matrix satisfies both
`SU5Predicate` (identity is unitary with det 1) and `PatiSalamPredicate`
(identity preserves block structure). Use `smBlock_iff_su5_and_patiSalam`.

**For `SMBlockPredicate_mul`**: Both `SU5Predicate` and `PatiSalamPredicate`
are preserved under multiplication:
- `SU5Predicate (A * B)`: `(A*B)† * (A*B) = B† * (A† * A) * B = B† * B = 1`;
  `det(A*B) = det(A) * det(B) = 1 * 1 = 1`.
- `PatiSalamPredicate (A*B)`: block structure is preserved under block
  multiplication.

**For `SMBlockPredicate_inv`**: `A⁻¹ = A†` for unitary matrices, and the
Hermitian adjoint of a block matrix is block.

## Additional theorem to prove

If there is time, also prove the covering map is a group homomorphism:

```lean
/-- The covering map from `U(1) × SU(2) × SU(3)` to `GUTMatrix` is a
    group homomorphism onto `SMBlockPredicate`. -/
theorem coveringMap_mulHom :
    ∀ φ₁ φ₂ A₁ A₂ B₁ B₂,
      coveringMap (φ₁ * φ₂) (A₁ * A₂) (B₁ * B₂) =
        coveringMap φ₁ A₁ B₁ * coveringMap φ₂ A₂ B₂
```

This is a prerequisite for applying Mathlib's first-isomorphism theorem
to obtain `(U(1) × SU(2) × SU(3)) / ℤ₆ ≅ S(U(2) × U(3))`.

## Claim boundary

This file proves finite algebraic group-closure properties for the
`SMBlockPredicate` subset of matrices. It does **not**:
- Prove the full topological first-isomorphism theorem.
- Prove that `S(U(2) × U(3))` is exactly the image of the covering map
  (that would require more surjectivity work).
- Claim any geometric interpretation of the Standard Model gauge group.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- If exact definitions of `SU5Predicate`, `PatiSalamPredicate`, and
  `SMBlockPredicate` differ slightly from what is described here, use the
  actual definitions in the project files.
- Add the new file to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Gauge/StandardModelGroupStructure.lean
lake build PhysicsSM.Gauge.StandardModelGroupStructure
```
