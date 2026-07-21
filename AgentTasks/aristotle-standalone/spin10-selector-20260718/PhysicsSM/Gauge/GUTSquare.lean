import Mathlib
import PhysicsSM.Gauge.BlockEmbeddings

/-!
# Gauge.GUTSquare

Matrix-predicate formalization of the Baez–Huerta grand-unification
intersection square.

## Mathematical context

Baez and Huerta ("The Algebra of Grand Unified Theories", Bull. AMS 2010)
describe a commutative square of Lie group inclusions inside `U(5)`:

```
        G_SM ———→ SU(5)
         |          |
         ↓          ↓
     U(2)×U(3) ——→ U(5)
```

where `G_SM = S(U(2) × U(3))` is the Standard Model gauge group.
The key intersection theorem at the group level is:

  `G_SM = SU(5) ∩ (U(2) × U(3))`

i.e., the Standard Model group is exactly the intersection of the
Georgi–Glashow GUT group SU(5) with the block-diagonal subgroup
U(2) × U(3) inside U(5).

## What this module proves

This module formalizes the intersection at the **matrix-predicate level**:
we define three predicates on `Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ`
and prove that the Standard Model predicate is equivalent to the conjunction
of the SU(5) and block-diagonal (Pati-Salam-style) predicates.

**Claim boundary**: we prove predicate-level intersection and inclusion
facts for 5×5 complex matrices. We do NOT claim compact Lie group topology,
group homomorphism properties, or Spin(10) embeddings.

### Convention compatibility

The 2+3 block decomposition matches the `BlockEmbeddings.lean` convention:
- Upper-left 2×2 block: SU(2)_L factor
- Lower-right 3×3 block: U(3) factor (containing SU(3)_c and U(1)_Y)

Source: Baez–Huerta, "The Algebra of Grand Unified Theories",
  Bull. Amer. Math. Soc. 47 (2010), 483–552.
  https://math.ucr.edu/home/baez/guts.pdf

Status: trusted — s o r r y-free predicate-level intersection/inclusion theorems.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Gauge.GUTSquare

open Matrix Complex

/-! ## Unitarity predicate -/

/--
A square complex matrix is unitary when `Mᴴ * M = 1`.
This is a predicate wrapper used to state the GUT square cleanly.
-/
def IsUnitary {n : Type*} [Fintype n] [DecidableEq n]
    (M : Matrix n n ℂ) : Prop :=
  M.conjTranspose * M = 1

/-! ## The three GUT-square predicates -/

/--
**SU(5) predicate**: `M` is a 5×5 unitary matrix with determinant 1.

This characterizes membership in `SU(5)` at the matrix level,
using the 2+3 block index type `Fin 2 ⊕ Fin 3`.
-/
def SU5Predicate (M : Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ) : Prop :=
  IsUnitary M ∧ M.det = 1

/--
**Pati-Salam-style (block-diagonal unitary) predicate**: `M` is block-diagonal
with a unitary 2×2 upper-left block and a unitary 3×3 lower-right block.

This characterizes membership in the block-diagonal subgroup `U(2) × U(3)`
inside `U(5)`. (We call it "Pati-Salam-style" because this block structure
corresponds to the symmetry-breaking pattern `SU(5) → G_SM`, which is the
Georgi–Glashow side of the Baez–Huerta square. The Pati-Salam group
`SU(2) × SU(2) × SU(4)` has a compatible block decomposition in higher
dimension.)
-/
def PatiSalamPredicate (M : Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ) : Prop :=
  ∃ (A : Matrix (Fin 2) (Fin 2) ℂ) (B : Matrix (Fin 3) (Fin 3) ℂ),
    M = fromBlocks A 0 0 B ∧ IsUnitary A ∧ IsUnitary B

/--
**Standard Model block predicate**: `M` is block-diagonal with unitary blocks
whose combined determinant is 1. This characterizes `S(U(2) × U(3))`, the
true Standard Model gauge group.
-/
def SMBlockPredicate (M : Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ) : Prop :=
  ∃ (A : Matrix (Fin 2) (Fin 2) ℂ) (B : Matrix (Fin 3) (Fin 3) ℂ),
    M = fromBlocks A 0 0 B ∧ IsUnitary A ∧ IsUnitary B ∧ A.det * B.det = 1

/-! ## Helper lemmas -/

/--
Block-diagonal matrices with zero off-diagonal blocks multiply block-wise.
-/
theorem fromBlocks_mul_zero_off_diag
    (A₁ A₂ : Matrix (Fin 2) (Fin 2) ℂ) (B₁ B₂ : Matrix (Fin 3) (Fin 3) ℂ) :
    fromBlocks A₁ 0 0 B₁ * fromBlocks A₂ 0 0 B₂ =
    fromBlocks (A₁ * A₂) 0 0 (B₁ * B₂) := by
  ext (i | i) (j | j) <;>
    simp [fromBlocks, mul_apply, Fintype.sum_sum_type]

/--
The conjugate transpose of a block-diagonal matrix (with zero off-diagonal
blocks) is block-diagonal with conjugate-transposed blocks.
-/
theorem fromBlocks_conjTranspose_zero_off_diag
    (A : Matrix (Fin 2) (Fin 2) ℂ) (B : Matrix (Fin 3) (Fin 3) ℂ) :
    (fromBlocks A 0 0 B).conjTranspose =
    fromBlocks A.conjTranspose 0 0 B.conjTranspose := by
  simp only [fromBlocks_conjTranspose, conjTranspose_zero]

/--
A block-diagonal matrix with unitary blocks is unitary.
-/
theorem isUnitary_fromBlocks
    (A : Matrix (Fin 2) (Fin 2) ℂ) (B : Matrix (Fin 3) (Fin 3) ℂ)
    (hA : IsUnitary A) (hB : IsUnitary B) :
    IsUnitary (fromBlocks A 0 0 B) := by
  unfold IsUnitary
  rw [fromBlocks_conjTranspose_zero_off_diag,
      fromBlocks_mul_zero_off_diag, hA, hB, fromBlocks_one]

/--
The determinant of a block-diagonal matrix (with zero off-diagonal blocks)
is the product of the block determinants.
-/
theorem det_fromBlocks_zero_off_diag
    (A : Matrix (Fin 2) (Fin 2) ℂ) (B : Matrix (Fin 3) (Fin 3) ℂ) :
    (fromBlocks A 0 0 B).det = A.det * B.det :=
  det_fromBlocks_zero₁₂ A 0 B

/-! ## Inclusion lemmas -/

/--
**SM ⊂ SU(5)**: every matrix satisfying the Standard Model block predicate
satisfies the SU(5) predicate.

A block-diagonal unitary matrix with `det(A) · det(B) = 1` is unitary
(from block unitarity) and has determinant 1 (since `det = det(A) · det(B)`).
-/
theorem smBlock_implies_su5
    (M : Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ)
    (h : SMBlockPredicate M) : SU5Predicate M := by
  obtain ⟨A, B, hM, hA, hB, hdet⟩ := h
  subst hM
  exact ⟨isUnitary_fromBlocks A B hA hB,
         (det_fromBlocks_zero_off_diag A B).trans hdet⟩

/--
**SM ⊂ U(2) × U(3)**: every matrix satisfying the Standard Model block
predicate satisfies the Pati-Salam (block-diagonal unitary) predicate.

This is immediate: just forget the determinant-one condition.
-/
theorem smBlock_implies_patiSalam
    (M : Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ)
    (h : SMBlockPredicate M) : PatiSalamPredicate M := by
  obtain ⟨A, B, hM, hA, hB, _⟩ := h
  exact ⟨A, B, hM, hA, hB⟩

/-! ## The intersection theorem -/

/--
**Baez–Huerta intersection at the matrix-predicate level**:

  `SMBlockPredicate M ↔ SU5Predicate M ∧ PatiSalamPredicate M`

In words: a 5×5 complex matrix belongs to `S(U(2) × U(3))` (the Standard
Model gauge group) if and only if it simultaneously belongs to `SU(5)` and
to the block-diagonal subgroup `U(2) × U(3)`.

This is the predicate-level shadow of the Baez–Huerta group-theoretic
intersection theorem `G_SM = SU(5) ∩ (U(2) × U(3))`.
-/
theorem smBlock_iff_su5_and_patiSalam
    (M : Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ) :
    SMBlockPredicate M ↔ SU5Predicate M ∧ PatiSalamPredicate M := by
  constructor
  · exact fun h => ⟨smBlock_implies_su5 M h, smBlock_implies_patiSalam M h⟩
  · rintro ⟨⟨_, hdet⟩, A, B, hM, hA, hB⟩
    exact ⟨A, B, hM, hA, hB, by rwa [← det_fromBlocks_zero_off_diag, ← hM]⟩

/-! ## Determinant compatibility with BlockEmbeddings -/

/--
The `su4Block` from `BlockEmbeddings` satisfies the Pati-Salam-style block
structure when restricted to the 3+1 sub-decomposition of the lower-right
3×3 factor.

More precisely: the slide map `(α, g, h) ↦ (g, block_diag(α·h, α⁻³))`
produces a matrix whose SU(4) component has the expected determinant.
This links the block-embedding arithmetic to the GUT-square predicates.
-/
theorem slideMap_det_compat (α : ℂ) (hα : α ≠ 0)
    (h : Matrix (Fin 3) (Fin 3) ℂ) (hdet : h.det = 1) :
    (PhysicsSM.Gauge.BlockEmbeddings.su4Block α h).det = 1 :=
  PhysicsSM.Gauge.BlockEmbeddings.det_su4Block_eq_one α hα h hdet

/-! ## Stretch: draft lift statement

The predicate-level theorem `smBlock_iff_su5_and_patiSalam` is the
matrix-level shadow of the following compact Lie group theorem:

  **Baez–Huerta (2010)**: As compact Lie groups,
    `G_SM ≅ SU(5) ∩ (U(2) × U(3))`
  where the intersection is taken inside `U(5)`.

A full formalization of this statement would require:
1. Topological group structures on `SU(5)`, `U(2) × U(3)`, and `G_SM`.
2. The embedding of `G_SM ≅ S(U(2) × U(3))` into `U(5)`.
3. A proof that the intersection is a closed subgroup, hence a Lie subgroup.
4. An isomorphism of Lie groups, not just a set-theoretic bijection.

The predicate-level theorem above establishes step (2) at the level of
matrix conditions. Steps (1), (3), (4) require compact Lie group machinery
beyond the current project scope.
-/

end PhysicsSM.Gauge.GUTSquare
