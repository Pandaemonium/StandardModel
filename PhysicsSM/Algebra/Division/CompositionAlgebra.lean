import Mathlib

/-!
# Algebra.Division.CompositionAlgebra

A **Euclidean composition algebra** over `ℝ` is a finite-dimensional real
algebra (not necessarily associative) with a positive-definite quadratic form
`normSq` satisfying the **composition law**

  `normSq (x * y) = normSq x * normSq y`

for all `x y`.  The classical examples are `ℝ`, `ℂ`, `ℍ`, and `𝕆`.
Hurwitz's theorem says these are the *only* such algebras (up to isomorphism),
but the classification is **not** proved in this file.

## Purpose

This module provides the algebraic record and a thin API layer that future
modules (Clifford relation, norm-form identities, Hurwitz classification) can
build on.  It deliberately stays close to the axioms and avoids importing
heavyweight analysis.

## Main definitions

* `EuclideanCompAlg` — a mixin class packaging the composition axiom and
  positivity of `normSq` on top of Mathlib's `NonAssocRing`, `Module ℝ`,
  and `Star` typeclasses.
* `EuclideanCompAlg.normSq` — the quadratic norm, supplied as a field.
* Helper projections: `normSq_one`, `normSq_star`, `normSq_mul`,
  `normSq_nonneg`, `normSq_eq_zero`.

## Handoff for future Clifford-relation job

A successor module should:
1. Define `rePartOf x := (1 / 2) * (x + star x)` and `imPartOf`.
2. Show `x * star x = normSq x • 1` (the "norm-form identity").
3. Derive the Clifford relation `x * x = 2 * rePartOf x * x - normSq x • 1`
   for purely imaginary elements.
4. Prove that the imaginary subspace with the Clifford relation is a Clifford
   algebra for the restriction of the norm form.

These steps would connect this record to `Mathlib.LinearAlgebra.CliffordAlgebra.Basic`.

Provenance: clean-room formalization from Baez, "The Octonions",
Bull. Amer. Math. Soc. 39 (2002) 145-205, §1.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Division

/-! ### The composition-algebra class -/

/-- A **Euclidean composition algebra** over `ℝ`.

The carrier type `A` is assumed to be a (possibly non-associative) unital ring
with an `ℝ`-module structure and a star (conjugation) operation.  The class
adds a quadratic norm `normSq` together with axioms asserting
* **Composition**: `normSq (x * y) = normSq x * normSq y`.
* **Positivity**: `0 ≤ normSq x` for all `x`.
* **Faithfulness**: `normSq x = 0 ↔ x = 0`.
* **Unit normalisation**: `normSq 1 = 1`.
* **Star–norm compatibility**: `normSq (star x) = normSq x`.
-/
class EuclideanCompAlg (A : Type*) [NonAssocRing A] [Module ℝ A] [Star A]
    where
  /-- The squared norm / quadratic form. -/
  normSq : A -> ℝ
  /-- Composition law. -/
  normSq_mul : ∀ x y : A, normSq (x * y) = normSq x * normSq y
  /-- Non-negativity. -/
  normSq_nonneg : ∀ x : A, 0 ≤ normSq x
  /-- Faithfulness (positive-definiteness). -/
  normSq_eq_zero : ∀ x : A, normSq x = 0 ↔ x = 0
  /-- Unit is normalised. -/
  normSq_one : normSq 1 = 1
  /-- Conjugation preserves the norm. -/
  normSq_star : ∀ x : A, normSq (star x) = normSq x

variable {A : Type*} [NonAssocRing A] [Module ℝ A] [Star A]
  [EuclideanCompAlg A]

open EuclideanCompAlg

/-! ### Basic API lemmas -/

/-- `normSq` respects multiplication (term-mode projection). -/
theorem compAlg_normSq_mul (x y : A) :
    normSq (x * y) = normSq x * normSq y :=
  EuclideanCompAlg.normSq_mul x y

/-
The norm of a nonzero element is strictly positive.
-/
theorem compAlg_normSq_pos {x : A} (hx : x ≠ 0) : 0 < normSq x := by
  rename_i h;
  exact lt_of_le_of_ne ( h.normSq_nonneg x ) ( Ne.symm ( by simpa [ h.normSq_eq_zero ] using hx ) )

/-
`normSq` of `0` is `0`.
-/
theorem compAlg_normSq_zero : normSq (0 : A) = 0 := by
  exact ( ‹EuclideanCompAlg A›.normSq_eq_zero 0 ).mpr rfl

/-
`normSq (x * y) = 0` iff one factor is zero (no zero-divisors for the
norm).
-/
theorem compAlg_normSq_mul_eq_zero {x y : A} :
    normSq (x * y) = 0 ↔ x = 0 ∨ y = 0 := by
  have := @EuclideanCompAlg.normSq_mul A;
  rename_i h;
  have := @h.normSq_eq_zero;
  grind

/-
In a Euclidean composition algebra there are no zero divisors:
`x * y = 0 → x = 0 ∨ y = 0`.
-/
theorem compAlg_no_zero_divisors {x y : A} (h : x * y = 0) :
    x = 0 ∨ y = 0 :=
  compAlg_normSq_mul_eq_zero.mp (by rw [h, compAlg_normSq_zero])

end PhysicsSM.Algebra.Division
