import Mathlib
import PhysicsSM.Algebra.Division.CompositionAlgebra

/-!
# Norm-form mixin and Clifford-type square relation for composition algebras

This module provides a **norm-form mixin** (`NormFormCompAlg`) that
strengthens `EuclideanCompAlg` with the classical composition-algebra
norm-form identity

  `x * star x = normSq x • 1`

together with linearity properties of `star`, and derives from these:
1. Basic real/imaginary decomposition API.
2. Star compatibility with real and imaginary projections.
3. The **first Clifford-type square relation**: for pure imaginary `x`,
   `x * x = -(normSq x • 1)`.

This Clifford relation is the algebraic foundation for viewing the imaginary
subspace of a composition algebra as a Clifford module — a key step toward
building Clifford algebras from division algebra data.

## Why the norm-form identity is an *added hypothesis*

`EuclideanCompAlg` records only the *real-valued* composition law:
  `normSq (x * y) = normSq x * normSq y`

together with positivity, faithfulness, unit normalisation, and star–norm
compatibility (`normSq (star x) = normSq x`).

The composition law alone does **not** imply `x * star x = normSq x • 1`.
To see why: the composition law constrains the ℝ-valued function `normSq`
on products, but says nothing about the *A-valued* product `x * star x`.
One can construct models of `EuclideanCompAlg` where the composition law
holds but `x * star x ≠ normSq x • 1` (e.g. by choosing a non-standard
`star` that preserves `normSq` pointwise but does not satisfy the norm-form
identity). The classical proof that the norm-form identity holds in Hurwitz
algebras (ℝ, ℂ, ℍ, 𝕆) uses linearisation arguments *plus* the Hurwitz
classification theorem; since `EuclideanCompAlg` deliberately stops short
of Hurwitz classification, the identity is not derivable there.

`NormFormCompAlg` therefore adds the norm-form identity as an explicit field.
Any future Hurwitz-classification proof will *discharge* this field as a
consequence of the stronger structural theorem; until then, it is an axiom
of the interface.

## Why star linearity properties are added explicitly

Standard Mathlib typeclasses `StarAddMonoid`, `InvolutiveStar`, and
`StarModule` would supply star linearity, but `EuclideanCompAlg` already
takes `[Star A]` as a bare parameter. Introducing `[StarAddMonoid A]` as
a new typeclass would create a second `Star A` instance (a typeclass diamond
with the existing `[Star A]`). To avoid this fragility, we state the three
needed star properties — involutivity, additivity, and ℝ-linearity — as
plain fields inside the mixin. This keeps the interface clean at the cost of
slight verbosity.

## Typing note — `normSq x • (1 : A)`

`EuclideanCompAlg` already requires `[Module ℝ A]`, which provides
`SMul ℝ A`. Since `normSq x : ℝ` and `(1 : A) : A`, the expression
`normSq x • (1 : A)` is well-typed without any further assumptions.
We deliberately do *not* require `Algebra ℝ A` (which would add `algebraMap`
and commutativity conditions that non-associative algebras like 𝕆 typically
fail to satisfy). Plain `Module ℝ A` is the minimal assumption already
present in `EuclideanCompAlg`.

## Main definitions

* `NormFormCompAlg` — mixin extending `EuclideanCompAlg A` with the
  norm-form identity and star-linearity axioms.
* `rePartOf x` — real part projection `(1/2) • (x + star x)`.
* `imPartOf x` — imaginary part projection `(1/2) • (x - star x)`.
* `IsPureImaginary x` — predicate `star x = -x`.

## Main results

* `rePart_add_imPart` : `rePartOf x + imPartOf x = x`
* `star_rePartOf` : `star (rePartOf x) = rePartOf x`
* `star_imPartOf` : `star (imPartOf x) = -imPartOf x`
* `rePartOf_star` : `rePartOf (star x) = rePartOf x`
* `imPartOf_star` : `imPartOf (star x) = -imPartOf x`
* **`pureIm_sq`** : for pure imaginary `x`, `x * x = -(normSq x • 1)`
* `pureIm_sq'` : variant form `x * x = (-normSq x) • 1`

## Future directions

* Build a `CliffordAlgebra`-instance from the imaginary subspace.
* Prove the norm-form identity for ℝ, ℂ, ℍ, 𝕆 as a consequence of
  Hurwitz classification (once that is formalized).
* Derive `star_mul_self` (`star x * x = normSq x • 1`) as a consequence
  of the fields here plus alternativity.

## Provenance

Clean-room formalization of standard composition-algebra identities.
See Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002) 145–205, §1
for the mathematical background; predecessor module:
`PhysicsSM.Algebra.Division.CompositionAlgebra`.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Division

open EuclideanCompAlg

/-! ## The norm-form composition algebra mixin -/

/-- A **norm-form composition algebra** over ℝ.

This mixin extends `EuclideanCompAlg` with four explicit hypotheses that
hold in all classical Hurwitz algebras (ℝ, ℂ, ℍ, 𝕆) but are *not*
derivable from `EuclideanCompAlg` alone (see module docstring).

**Fields:**

1. `mul_star_self` — the *right* norm-form identity:
   `x * star x = normSq x • 1`.
   In words: the product of any element with its conjugate equals the scalar
   `normSq x` times the unit. This is the A-valued lift of the composition
   law `normSq(x * star x) = normSq x * normSq(star x) = normSq x ^ 2`.

2. `star_star` — star is an involution: `star (star x) = x`.
   Standard for composition-algebra conjugation; corresponds to double
   complex/quaternionic/octonionic conjugation returning the original.

3. `star_add` — star distributes over addition: `star (x + y) = star x + star y`.
   Star is ℝ-linear; additivity is the first part.

4. `star_real_smul` — star commutes with real scalar multiplication:
   `star (r • x) = r • star x`.
   This completes ℝ-linearity of star.

**Not included here** (but derivable from these + further structure):
- The *left* norm-form identity `star x * x = normSq x • 1` (needs
  alternativity or a symmetric argument).
- `star 1 = 1` (follows from `mul_star_self 1` and `normSq_one`).
-/
class NormFormCompAlg (A : Type*) [NonAssocRing A] [Module ℝ A] [Star A]
    extends EuclideanCompAlg A where
  /-- The right norm-form identity: `x * star x = normSq x • 1`.
      The A-valued version of the composition law. -/
  mul_star_self : ∀ x : A, x * star x = normSq x • (1 : A)
  /-- Star is an involution: `star (star x) = x`. -/
  star_star : ∀ x : A, star (star x) = x
  /-- Star distributes over addition: `star (x + y) = star x + star y`. -/
  star_add : ∀ x y : A, star (x + y) = star x + star y
  /-- Star commutes with real scalar multiplication: `star (r • x) = r • star x`. -/
  star_real_smul : ∀ (r : ℝ) (x : A), star (r • x) = r • star x

variable {A : Type*} [NonAssocRing A] [Module ℝ A] [Star A] [NormFormCompAlg A]

/-! ## Derived star properties

From the two linearity fields (`star_add`, `star_real_smul`) we can derive
star's behavior on zero, negation, and subtraction. These are standard
consequences of ℝ-linearity.
-/

/-- `star 0 = 0`.

Proof: `star 0 = star (0 + 0) = star 0 + star 0` forces `star 0 = 0`
by left-cancellation in the additive group. -/
theorem nfca_star_zero : star (0 : A) = 0 := by
  have h := NormFormCompAlg.star_add (0 : A) (0 : A)
  rw [add_zero] at h  -- h : star 0 = star 0 + star 0
  -- star 0 + 0 = star 0 + star 0, so 0 = star 0 by add_left_cancel
  have h2 : star (0 : A) + 0 = star (0 : A) + star (0 : A) := by
    rw [add_zero]; exact h
  exact (add_left_cancel h2).symm

/-- `star (-x) = -star x`.

Proof: from `star (x + (-x)) = star x + star (-x)` and `star 0 = 0`,
we get `star (-x) = -star x`. -/
theorem nfca_star_neg (x : A) : star (-x) = -star x := by
  have h := NormFormCompAlg.star_add x (-x)
  rw [add_neg_cancel, nfca_star_zero] at h
  exact eq_neg_of_add_eq_zero_right h.symm

/-- `star (x - y) = star x - star y`.

Follows from additivity of star and `star (-y) = -star y`. -/
theorem nfca_star_sub (x y : A) : star (x - y) = star x - star y := by
  rw [sub_eq_add_neg, NormFormCompAlg.star_add, nfca_star_neg, ← sub_eq_add_neg]

/-! ## Real and imaginary part projections

In any Hurwitz algebra, every element decomposes uniquely as a sum of a
"real" part (fixed by star) and an "imaginary" part (negated by star):

  `x = rePartOf x + imPartOf x`
  `rePartOf x = (1/2) • (x + star x)`  (fixed by star: `star(rePartOf x) = rePartOf x`)
  `imPartOf x = (1/2) • (x - star x)`  (negated by star: `star(imPartOf x) = -imPartOf x`)

The decomposition identity holds in any type with `[Module ℝ B]` and `[Star B]`,
without needing the full `NormFormCompAlg` structure.
-/

/-- The **real part** of `x`: `(1/2) • (x + star x)`.

The real part is the component fixed by star: `star (rePartOf x) = rePartOf x`
(proved below). In the classical composition algebras:
- ℝ: `rePartOf r = r` (since `star r = r`).
- ℂ: `rePartOf (a + bi) = a` (the usual real part).
- ℍ: `rePartOf q = q.re` (the scalar part).
- 𝕆: the scalar part times the unit.
-/
noncomputable def rePartOf (x : A) : A := (1 / 2 : ℝ) • (x + star x)

/-- The **imaginary part** of `x`: `(1/2) • (x - star x)`.

The imaginary part is the component negated by star: `star (imPartOf x) = -imPartOf x`
(proved below). This makes `imPartOf x` purely imaginary in the sense of `IsPureImaginary`.
-/
noncomputable def imPartOf (x : A) : A := (1 / 2 : ℝ) • (x - star x)

/-- An element is **purely imaginary** when `star x = -x`.

This is equivalent to `rePartOf x = 0` (proved below as `IsPureImaginary.rePartOf_eq_zero`),
but we take the conjugation characterisation as the definition because it is
simpler to state and to use in proofs. -/
def IsPureImaginary (x : A) : Prop := star x = -x

/-! ### Decomposition identity (no NormFormCompAlg needed)

The decomposition identity `rePartOf x + imPartOf x = x` and the pure-imaginary
corollaries hold in any `[Module ℝ B] [Star B]` context. We state them in a
general `section` to make this independence explicit.
-/
section decomposition
variable {B : Type*} [NonAssocRing B] [Module ℝ B] [Star B]

/-- **Decomposition identity**: every element is the sum of its real and
imaginary parts.

  `rePartOf x + imPartOf x = x`

This is purely linear: `(1/2)(x + star x) + (1/2)(x - star x) = (1/2)(2x) = x`. -/
@[simp]
theorem rePartOf_add_imPartOf (x : B) : rePartOf x + imPartOf x = x := by
  unfold rePartOf imPartOf
  rw [← smul_add]
  rw [show x + star x + (x - star x) = (2 : ℝ) • x from by rw [two_smul]; abel]
  rw [smul_smul]; norm_num

/-- A purely imaginary element has zero real part: `rePartOf x = 0`. -/
theorem IsPureImaginary.rePartOf_eq_zero {x : B} (hx : IsPureImaginary x) :
    rePartOf x = 0 := by
  unfold rePartOf IsPureImaginary at *
  rw [hx, add_neg_cancel, smul_zero]

/-- A purely imaginary element equals its own imaginary part: `imPartOf x = x`. -/
theorem IsPureImaginary.imPartOf_eq_self {x : B} (hx : IsPureImaginary x) :
    imPartOf x = x := by
  have h := rePartOf_add_imPartOf x
  rw [hx.rePartOf_eq_zero, zero_add] at h
  exact h

end decomposition

/-! ### Star compatibility with the projections (needs NormFormCompAlg) -/

/-- `star (rePartOf x) = rePartOf x` — the real part is star-fixed.

Proof: `star((1/2)(x + star x)) = (1/2)(star x + star(star x)) = (1/2)(star x + x)
= rePartOf x` (using star-linearity and involutivity). -/
@[simp]
theorem star_rePartOf (x : A) : star (rePartOf x) = rePartOf x := by
  unfold rePartOf
  rw [NormFormCompAlg.star_real_smul, NormFormCompAlg.star_add,
      NormFormCompAlg.star_star, add_comm]

/-- `star (imPartOf x) = -imPartOf x` — the imaginary part is pure imaginary.

Proof: `star((1/2)(x - star x)) = (1/2)(star x - x) = -(1/2)(x - star x) = -imPartOf x`
(using star-linearity, involutivity, and `star(x-y) = star x - star y`). -/
@[simp]
theorem star_imPartOf (x : A) : star (imPartOf x) = -imPartOf x := by
  unfold imPartOf
  rw [NormFormCompAlg.star_real_smul, nfca_star_sub, NormFormCompAlg.star_star,
      ← neg_sub, ← smul_neg]

/-- `rePartOf (star x) = rePartOf x` — the real part of a conjugate equals
the real part of the original.

Proof: `(1/2)(star x + star(star x)) = (1/2)(star x + x) = rePartOf x`. -/
@[simp]
theorem rePartOf_star (x : A) : rePartOf (star x) = rePartOf x := by
  unfold rePartOf
  rw [NormFormCompAlg.star_star, add_comm]

/-- `imPartOf (star x) = -imPartOf x` — conjugating negates the imaginary part.

Proof: `(1/2)(star x - star(star x)) = (1/2)(star x - x) = -(1/2)(x - star x)`. -/
@[simp]
theorem imPartOf_star (x : A) : imPartOf (star x) = -imPartOf x := by
  unfold imPartOf
  rw [NormFormCompAlg.star_star, ← neg_sub, ← smul_neg]

/-- The imaginary part of any element is purely imaginary.

Proof: `star(imPartOf x) = -imPartOf x` (by `star_imPartOf`), which is
the definition of `IsPureImaginary`. -/
theorem imPartOf_isPureImaginary (x : A) : IsPureImaginary (imPartOf x) :=
  star_imPartOf x

/-- Zero is purely imaginary: `star 0 = -0 = 0`. -/
theorem isPureImaginary_zero : IsPureImaginary (0 : A) := by
  unfold IsPureImaginary
  rw [nfca_star_zero, neg_zero]

/-! ## The Clifford-type square relation

The main result of this module: for a purely imaginary element `x`, the
square `x * x` is a negative real scalar times the unit.

This is the **first Clifford relation**: it identifies the imaginary subspace
of a composition algebra as a Clifford module for the restriction of the norm
form, with the "Clifford generator" relation `e² = -‖e‖² · 1`.

**Proof** (elementary):
1. From `mul_star_self`: `x * star x = normSq x • 1`.
2. Substituting `star x = -x` (pure imaginary): `x * (-x) = normSq x • 1`.
3. By `mul_neg`: `-(x * x) = normSq x • 1`.
4. Negating: `x * x = -(normSq x • 1)`.

The proof uses only the right norm-form identity (`mul_star_self`) and the
pure-imaginary hypothesis. It does NOT require associativity (and therefore
applies to octonions) and does NOT require the left norm-form identity.
-/

/-- **First Clifford relation (norm-form version).** For a pure imaginary
element `x` in a norm-form composition algebra,

  `x * x = -(normSq x • 1)`.

This is the fundamental "Clifford-generator" relation: the square of a
unit-norm purely imaginary element is `-1`, just as `i² = -1` for the
imaginary unit of ℂ, or `e₁² = -1` for a Clifford generator.

More generally, for any purely imaginary `x` of norm `r`, we have
`x * x = -r • 1` (since `normSq x • 1` is scalar `normSq x` times unit,
and `-normSq x` is negative).

**Key consequence for Clifford algebras**: The imaginary subspace of a
Hurwitz algebra, equipped with the restriction of the norm form, generates
a Clifford algebra via this relation. The `pureIm_sq` theorem is the
algebraic certificate that this works. -/
theorem pureIm_sq (x : A) (hx : IsPureImaginary x) :
    x * x = -(normSq x • (1 : A)) := by
  -- From mul_star_self: x * star x = normSq x • 1
  have h := NormFormCompAlg.mul_star_self x
  -- Substitute star x = -x (pure imaginary hypothesis)
  rw [hx, mul_neg] at h
  -- h : -(x * x) = normSq x • 1; negate both sides
  exact neg_eq_iff_eq_neg.mp h

/-- **Variant form** of the first Clifford relation: `x * x = (-normSq x) • 1`.

This is the same as `pureIm_sq` but with the negation inside the scalar
rather than outside the smul. Useful when working with scalar-valued
computations where `(-normSq x) • 1` is more convenient than `-(normSq x • 1)`. -/
theorem pureIm_sq' (x : A) (hx : IsPureImaginary x) :
    x * x = (-normSq x) • (1 : A) := by
  rw [pureIm_sq x hx, neg_smul]

end PhysicsSM.Algebra.Division
