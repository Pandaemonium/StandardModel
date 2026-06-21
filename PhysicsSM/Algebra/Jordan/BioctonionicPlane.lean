import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexOctonion

/-!
# Algebra.Jordan.BioctonionicPlane

A counterexample to the projective-plane uniqueness a x i o m in the bioctonionic
(complexified octonionic) setting.

## Overview

The bioctonions ℂ ⊗ 𝕆 are the complexification of the octonion algebra.
Unlike the octonions (which form a normed division algebra), the bioctonions
contain **zero divisors**: nonzero elements whose product is zero. This has
geometric consequences—when one attempts to build a projective plane over the
bioctonions, the standard a x i o m that two distinct lines meet in at most one
point fails.

## The counterexample

We exhibit two explicit zero divisors `p, q ∈ ℂ ⊗ 𝕆` with `p * q = 0`,
`p ≠ 0`, `q ≠ 0`, and use them to construct:

- **Line L₁**: the "x-axis" `{(x, 0) | x ∈ ℂ⊗𝕆}` (slope 0, intercept 0)
- **Line L₂**: `{(x, p·x) | x ∈ ℂ⊗𝕆}` (slope p, intercept 0)

These are distinct lines (since `p ≠ 0`), yet both pass through
the points `(0, 0)` and `(q, 0)` (since `p · q = 0`). This gives two
distinct intersection points, violating the projective plane a x i o m.

## Source

- Baez, "Octonions and the Standard Model (Part 12)",
  https://math.ucr.edu/home/baez/standard/
- The role of zero divisors in ℂ ⊗ 𝕆 for projective geometry is
  discussed in Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), §4.3.
-/

namespace PhysicsSM.Algebra.Jordan.BioctonionicPlane

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion

/-! ## Bioctonion abbreviation -/

/-- The bioctonion algebra `ℂ ⊗_ℝ 𝕆`, using the project's `ComplexOctonion` type. -/
abbrev Bioctonion := ComplexOctonion

/-! ## Zero divisors in the bioctonions -/

/-- First zero divisor: `e₁ + i · 1` in ℂ ⊗ 𝕆.
    Here `e₁` is the first imaginary octonion unit and `i` is the complex unit. -/
def zeroDivisorP : Bioctonion :=
  ⟨⟨0, 1, 0, 0, 0, 0, 0, 0⟩, ⟨1, 0, 0, 0, 0, 0, 0, 0⟩⟩

/-- Second zero divisor: `1 + i · e₁` in ℂ ⊗ 𝕆. -/
def zeroDivisorQ : Bioctonion :=
  ⟨⟨1, 0, 0, 0, 0, 0, 0, 0⟩, ⟨0, 1, 0, 0, 0, 0, 0, 0⟩⟩

/-- The product `p · q = 0` in the bioctonions. This is the key algebraic
    fact: bioctonions have zero divisors. -/
theorem zeroDivisorP_mul_zeroDivisorQ :
    zeroDivisorP * zeroDivisorQ = 0 := by
  ext <;> simp [zeroDivisorP, zeroDivisorQ,
    Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2, Octonion.mul_c3,
    Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6, Octonion.mul_c7]

/-- `p` is nonzero. -/
theorem zeroDivisorP_ne_zero : zeroDivisorP ≠ 0 := by
  exact ne_of_apply_ne ( fun x => x.re.c1 ) ( by simp +decide [ zeroDivisorP ] )

/-- `q` is nonzero. -/
theorem zeroDivisorQ_ne_zero : zeroDivisorQ ≠ 0 := by
  exact ne_of_apply_ne ( fun x => x.re.c0 ) ( by simp +decide [ zeroDivisorQ ] )

/-! ## Bioctonionic affine plane model -/

/-- A point in the bioctonionic affine plane: a pair of bioctonions. -/
@[ext]
structure BioctonionicPoint where
  x : Bioctonion
  y : Bioctonion

/-- A line in the bioctonionic affine plane, given in slope-intercept form
    `y = slope · x + intercept`. This parametrization suffices for our
    counterexample (we do not need vertical lines). -/
@[ext]
structure BioctonionicAffineLine where
  slope : Bioctonion
  intercept : Bioctonion

/-- Incidence: a point `(x, y)` lies on the line `y = m · x + b`. -/
def OnLine (pt : BioctonionicPoint) (l : BioctonionicAffineLine) : Prop :=
  pt.y = l.slope * pt.x + l.intercept

/-! ## The two specific lines -/

/-- Line L₁: the "x-axis" with equation `y = 0 · x + 0`, i.e., `y = 0`. -/
def L₁ : BioctonionicAffineLine := ⟨0, 0⟩

/-- Line L₂: the line `y = p · x + 0`, i.e., `y = p · x`. -/
def L₂ : BioctonionicAffineLine := ⟨zeroDivisorP, 0⟩

/-- L₁ and L₂ are distinct lines. -/
theorem L₁_ne_L₂ : L₁ ≠ L₂ := by
  exact fun h =>
    zeroDivisorP_ne_zero
      (by simpa using congr_arg BioctonionicAffineLine.slope h.symm)

/-! ## The two intersection points -/

/-- The origin. -/
def P₁ : BioctonionicPoint := ⟨0, 0⟩

/-- The point `(q, 0)` where `q` is the zero divisor partner of `p`. -/
def P₂ : BioctonionicPoint := ⟨zeroDivisorQ, 0⟩

/-- P₁ and P₂ are distinct. -/
theorem P₁_ne_P₂ : P₁ ≠ P₂ := by
  exact fun h => zeroDivisorQ_ne_zero <| by injection h with h₁ h₂; aesop

/-- The origin lies on L₁. -/
theorem P₁_onLine_L₁ : OnLine P₁ L₁ := by
  exact Eq.symm (by ext <;> simp +decide [L₁, P₁])

/-- The origin lies on L₂. -/
theorem P₁_onLine_L₂ : OnLine P₁ L₂ := by
  exact Eq.symm (by ext <;> simp +decide [P₁, L₂])

/-- The point (q, 0) lies on L₁. -/
theorem P₂_onLine_L₁ : OnLine P₂ L₁ := by
  exact Eq.symm (by ext <;> simp +decide [P₂, L₁])

/-- The point (q, 0) lies on L₂ because p · q = 0. -/
theorem P₂_onLine_L₂ : OnLine P₂ L₂ := by
  unfold OnLine; dsimp only [P₂, L₂]
  simp [zeroDivisorP_mul_zeroDivisorQ]

/-! ## Main theorem: counterexample to the projective plane uniqueness a x i o m -/

/-- **Bioctonionic incidence counterexample.**
    In the bioctonionic affine plane, there exist two distinct lines
    that share at least two distinct points. This violates the
    projective-plane a x i o m that two distinct lines meet in at most one point.

    The counterexample exploits zero divisors in ℂ ⊗ 𝕆: the product of
    two nonzero bioctonions can vanish, allowing a nonzero point to
    simultaneously satisfy `y = 0` and `y = p · x`. -/
theorem two_distinct_lines_more_than_one_intersection_point :
    ∃ (l₁ l₂ : BioctonionicAffineLine) (p₁ p₂ : BioctonionicPoint),
      l₁ ≠ l₂ ∧ p₁ ≠ p₂ ∧
      OnLine p₁ l₁ ∧ OnLine p₁ l₂ ∧
      OnLine p₂ l₁ ∧ OnLine p₂ l₂ :=
  ⟨L₁, L₂, P₁, P₂,
    L₁_ne_L₂, P₁_ne_P₂,
    P₁_onLine_L₁, P₁_onLine_L₂, P₂_onLine_L₁, P₂_onLine_L₂⟩

end PhysicsSM.Algebra.Jordan.BioctonionicPlane
