/-
Copyright (c) 2026 PhysicsSM Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib

/-!
# Cocycle and Quadratic-Phase Extraction for Sedenions

This module formalizes the Cayley-Dickson sign function ω(a,b) for the
16-dimensional sedenion algebra and analyzes its restriction to the
zero-product plaquette complex.

## Convention

We use the recursive Cayley-Dickson convention documented in
`Sedenions/CayleyDickson_Convention.md`:

- Basis labels are 4-bit indices in `Fin 16`.
- Product index follows XOR: `e_a * e_b = ω(a,b) · e_{a ⊕ b}`.
- Signs are determined by the recursive Cayley-Dickson pair rule.

This convention differs from `PhysicsSM.Algebra.Octonion.Basic`; the two
must never be silently identified.

## Main definitions

- `cdMulBasis` : recursive Cayley-Dickson basis multiplication
- `omega` : ω : Fin 16 → Fin 16 → ℤ, the sedenion sign function
- `plaquetteOmegaProd` : four-fold ω-product on a mixed plaquette
- `isZeroProdSupport` : predicate for zero-product supports
- `sameStrutList` : the 63 same-strut mixed supports
- `zeroProdSupportList` : the 42 zero-product supports

## Main results

- `omega_values` : ω(a,b) ∈ {-1, 1}
- `cdMulIdx_eq_xor` : product index = bitwise XOR
- `omega_zero_left/right` : normalization at identity
- `omega_antisym` : ω(a,b) = -ω(b,a) for distinct nonzero a, b
- `omega_sq` : ω(a,b)² = 1
- `sameStrutList_length` : exactly 63 same-strut supports
- `zeroProdSupportList_length` : exactly 42 zero-product supports
- `extraStrutList_length` : exactly 21 extra same-strut supports
- `zeroProd_iff_linearPhase` : **main theorem** — a same-strut support is a
  zero-product support iff its four-fold ω-product = +1 (linear phase)
- `plaquetteOmegaProd_on_zeroProd` : ω-product = +1 on all 42 supports
- `plaquetteOmegaProd_on_extra` : ω-product = -1 on all 21 extras
- `omega_quaternion_cocycle` : ω restricted to quaternion subalgebra is a 2-cocycle

## Mathematical significance

The four-fold ω-product `ω(lo₁,lo₂) · ω(lo₁,hi₂) · ω(hi₁,lo₂) · ω(hi₁,hi₂)`
on a same-strut plaquette `{lo₁, lo₂, hi₁, hi₂}` measures whether the
Cayley-Dickson sign restriction to the plaquette is **linear** (product = +1)
or **quadratic but not linear** (product = -1) on the affine 2-plane.

The main theorem establishes: a same-strut mixed support admits a sedenion
zero-product relation if and only if this obstruction vanishes. This cleanly
characterizes the 42 zero-product supports as the "linear-phase" plaquettes,
and is the first step toward a Z₄/quadratic refinement in the
Albuquerque-Majid twisted-group-algebra framework.
-/

set_option linter.style.nativeDecide false

namespace CocycleQuadraticPhase

/-! ### Recursive Cayley-Dickson multiplication -/

/-- Conjugation sign for basis element `a`: +1 if a = 0, -1 otherwise. -/
def conjSign (a : Nat) : Int :=
  if a == 0 then 1 else -1

/-- Recursive Cayley-Dickson basis multiplication.
Returns `(sign, product_index)` for `e_a * e_b` in the `2^n`-dimensional
Cayley-Dickson algebra. Implements the pair rule
`(a, b)(c, d) = (ac - d̄b, da + bc̄)`. -/
def cdMulBasis : Nat → Nat → Nat → Int × Nat
  | 0, _, _ => (1, 0)
  | n + 1, a, b =>
    let half := 2 ^ n
    let ah := a / half
    let al := a % half
    let bh := b / half
    let bl := b % half
    if ah == 0 then
      if bh == 0 then
        -- (e_al, 0) * (e_bl, 0) = (e_al * e_bl, 0)
        let (s, k) := cdMulBasis n al bl
        (s, k)
      else
        -- (e_al, 0) * (0, e_bl) = (0, e_bl * e_al)
        let (s, k) := cdMulBasis n bl al
        (s, half + k)
    else
      if bh == 0 then
        -- (0, e_al) * (e_bl, 0) = (0, e_al * conj(e_bl))
        let (s, k) := cdMulBasis n al bl
        (s * conjSign bl, half + k)
      else
        -- (0, e_al) * (0, e_bl) = (-conj(e_bl) * e_al, 0)
        let (s, k) := cdMulBasis n bl al
        (-conjSign bl * s, k)

/-- The Cayley-Dickson sign function for sedenions.
`omega a b` is the sign ω(a,b) in `e_a * e_b = ω(a,b) · e_{a⊕b}`. -/
def omega (a b : Fin 16) : Int :=
  (cdMulBasis 4 a.val b.val).1

/-- The product index for sedenion basis multiplication. -/
def cdMulIdx (a b : Fin 16) : Nat :=
  (cdMulBasis 4 a.val b.val).2

/-! ### XOR helper for Fin 16 -/

private lemma xor_fin16_lt (a b : Fin 16) : a.val ^^^ b.val < 16 := by
  have ha := a.isLt; have hb := b.isLt
  interval_cases a.val <;> interval_cases b.val <;> simp_all

/-- XOR operation on `Fin 16`, matching the sedenion product index rule. -/
def fin16Xor (a b : Fin 16) : Fin 16 :=
  ⟨a.val ^^^ b.val, xor_fin16_lt a b⟩

/-! ### Basic properties of omega -/

/-- Product index equals bitwise XOR. -/
theorem cdMulIdx_eq_xor (a b : Fin 16) :
    cdMulIdx a b = (a.val ^^^ b.val) := by native_decide +revert

/-- ω(0, b) = 1 for all b (left normalization). -/
theorem omega_zero_left (b : Fin 16) : omega 0 b = 1 := by native_decide +revert

/-- ω(a, 0) = 1 for all a (right normalization). -/
theorem omega_zero_right (a : Fin 16) : omega a 0 = 1 := by native_decide +revert

/-- ω takes values in {-1, 1}. -/
theorem omega_values (a b : Fin 16) :
    omega a b = 1 ∨ omega a b = -1 := by native_decide +revert

/-- ω(a,b)² = 1. -/
theorem omega_sq (a b : Fin 16) : omega a b * omega a b = 1 := by native_decide +revert

/-- ω(a,b) = -ω(b,a) for distinct nonzero a, b (skew-symmetry of
imaginary unit products). -/
theorem omega_antisym (a b : Fin 16) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b) :
    omega a b = -omega b a := by native_decide +revert

/-- ω(a,a) = -1 for all nonzero a (imaginary units square to -1). -/
theorem omega_self_neg (a : Fin 16) (ha : a ≠ 0) :
    omega a a = -1 := by native_decide +revert

/-! ### Associator and non-associativity -/

/-- The associator ratio measuring non-associativity:
`assoc(a,b,c) = ω(a,b) · ω(a⊕b,c) · ω(b,c) · ω(a,b⊕c)`.
When the algebra is associative, this product equals 1. -/
def associatorVal (a b c : Fin 16) : Int :=
  omega a b * omega (fin16Xor a b) c * omega b c * omega a (fin16Xor b c)

/-- The sedenion algebra is NOT associative. -/
theorem sedenion_not_associative :
    ¬ (∀ a b c : Fin 16, associatorVal a b c = 1) := by native_decide +revert

/-- The associator takes values in {-1, 1}. -/
theorem associator_values (a b c : Fin 16) :
    associatorVal a b c = 1 ∨ associatorVal a b c = -1 := by native_decide +revert

/-- ω restricted to the quaternion subalgebra {0,1,2,3} IS a 2-cocycle
(quaternions are associative). -/
theorem omega_quaternion_cocycle :
    ∀ a b c : Fin 4,
      omega ⟨a.val, by omega⟩ ⟨b.val, by omega⟩ *
      omega (fin16Xor ⟨a.val, by omega⟩ ⟨b.val, by omega⟩) ⟨c.val, by omega⟩ =
      omega ⟨a.val, by omega⟩ (fin16Xor ⟨b.val, by omega⟩ ⟨c.val, by omega⟩) *
      omega ⟨b.val, by omega⟩ ⟨c.val, by omega⟩ := by native_decide

/-! ### Same-strut mixed supports -/

/-- Check whether `(lo₁, lo₂, hi₁, hi₂)` is a valid same-strut mixed support
in canonical form (lo₁ < lo₂, hi₁ < hi₂).

A same-strut support has:
- `lo₁, lo₂ ∈ {1,...,7}` (nonzero low-octonion indices)
- `hi₁, hi₂ ∈ {9,...,15}` (nonzero high-octonion indices + 8)
- Same strut: `lo₁ ⊕ (hi₁ - 8) = lo₂ ⊕ (hi₂ - 8)` -/
def isSameStrutSupport (lo₁ lo₂ hi₁ hi₂ : Fin 16) : Bool :=
  (1 ≤ lo₁.val) && (lo₁.val ≤ 7) &&
  (1 ≤ lo₂.val) && (lo₂.val ≤ 7) &&
  (9 ≤ hi₁.val) && (hi₁.val ≤ 15) &&
  (9 ≤ hi₂.val) && (hi₂.val ≤ 15) &&
  (lo₁.val < lo₂.val) && (hi₁.val < hi₂.val) &&
  ((lo₁.val ^^^ (hi₁.val - 8)) == (lo₂.val ^^^ (hi₂.val - 8)))

/-- The list of all 63 same-strut mixed supports in canonical form. -/
def sameStrutList : List (Fin 16 × Fin 16 × Fin 16 × Fin 16) :=
  (List.finRange 16).flatMap fun lo₁ =>
  (List.finRange 16).flatMap fun lo₂ =>
  (List.finRange 16).flatMap fun hi₁ =>
  (List.finRange 16).flatMap fun hi₂ =>
    if isSameStrutSupport lo₁ lo₂ hi₁ hi₂ then [(lo₁, lo₂, hi₁, hi₂)] else []

/-- There are exactly 63 same-strut mixed supports. -/
theorem sameStrutList_length : sameStrutList.length = 63 := by native_decide

/-! ### Zero-product detection -/

/-- Coefficient of `e_k` in the sedenion product `(e_a + σ · e_b) · (e_c + τ · e_d)`.
Expands to four terms at the XOR indices `a⊕c`, `a⊕d`, `b⊕c`, `b⊕d`. -/
def assessorProdCoeff (a b c d : Fin 16) (σ τ : Int) (k : Fin 16) : Int :=
  (if (a.val ^^^ c.val) = k.val then omega a c else 0) +
  (if (a.val ^^^ d.val) = k.val then τ * omega a d else 0) +
  (if (b.val ^^^ c.val) = k.val then σ * omega b c else 0) +
  (if (b.val ^^^ d.val) = k.val then σ * τ * omega b d else 0)

/-- Check if the assessor product `(e_a + σ · e_b) · (e_c + τ · e_d) = 0`. -/
def isProductZero (a b c d : Fin 16) (σ τ : Int) : Bool :=
  (List.finRange 16).all fun k => assessorProdCoeff a b c d σ τ k == 0

/-- A canonical support `{lo₁, lo₂, hi₁, hi₂}` is a zero-product support if
there exist signs σ, τ ∈ {±1} and a pairing of the four indices into two
assessor pairs `(low, high)` such that the product of the two signed assessor
vectors vanishes in the sedenion algebra. -/
def isZeroProdSupport (lo₁ lo₂ hi₁ hi₂ : Fin 16) : Bool :=
  let signs : List Int := [1, -1]
  signs.any fun σ => signs.any fun τ =>
    -- Pairing 1: (lo₁, hi₁) × (lo₂, hi₂) and its reverse
    isProductZero lo₁ hi₁ lo₂ hi₂ σ τ ||
    isProductZero lo₂ hi₂ lo₁ hi₁ σ τ ||
    -- Pairing 2: (lo₁, hi₂) × (lo₂, hi₁) and its reverse
    isProductZero lo₁ hi₂ lo₂ hi₁ σ τ ||
    isProductZero lo₂ hi₁ lo₁ hi₂ σ τ

/-- The list of 42 zero-product supports. -/
def zeroProdSupportList : List (Fin 16 × Fin 16 × Fin 16 × Fin 16) :=
  sameStrutList.filter fun t => isZeroProdSupport t.1 t.2.1 t.2.2.1 t.2.2.2

/-- There are exactly 42 zero-product supports. -/
theorem zeroProdSupportList_length : zeroProdSupportList.length = 42 := by native_decide

/-- The list of 21 extra same-strut supports (not zero-product supports). -/
def extraStrutList : List (Fin 16 × Fin 16 × Fin 16 × Fin 16) :=
  sameStrutList.filter fun t => !isZeroProdSupport t.1 t.2.1 t.2.2.1 t.2.2.2

/-- There are exactly 21 extra same-strut supports. -/
theorem extraStrutList_length : extraStrutList.length = 21 := by native_decide

/-! ### Plaquette omega product and the linear-phase theorem -/

/-- The four-fold omega product on a mixed plaquette `{lo₁, lo₂, hi₁, hi₂}`:

  `ω(lo₁, lo₂) · ω(lo₁, hi₂) · ω(hi₁, lo₂) · ω(hi₁, hi₂)`

This is the product of ω over the four cross-pairing products between
the two "halves" of the support. It equals +1 when the phase restriction
to the affine 2-plane is linear, and -1 when it is quadratic but not
linear. -/
def plaquetteOmegaProd (lo₁ lo₂ hi₁ hi₂ : Fin 16) : Int :=
  omega lo₁ lo₂ * omega lo₁ hi₂ * omega hi₁ lo₂ * omega hi₁ hi₂

/-- **Main characterization theorem**: A same-strut mixed support is a
zero-product support if and only if its plaquette omega product equals +1
(i.e., the Cayley-Dickson phase restriction is linear on the affine 2-plane).

This theorem provides a clean algebraic characterization: the 42 zero-product
supports are exactly the same-strut supports with product +1, and the 21
extras all have product -1. -/
theorem zeroProd_iff_linearPhase :
    ∀ t ∈ sameStrutList,
      isZeroProdSupport t.1 t.2.1 t.2.2.1 t.2.2.2 = true ↔
      plaquetteOmegaProd t.1 t.2.1 t.2.2.1 t.2.2.2 = 1 := by native_decide

/-- On all 42 zero-product supports, the plaquette omega product is +1. -/
theorem plaquetteOmegaProd_on_zeroProd :
    ∀ t ∈ zeroProdSupportList,
      plaquetteOmegaProd t.1 t.2.1 t.2.2.1 t.2.2.2 = 1 := by native_decide

/-- On all 21 extra same-strut supports, the plaquette omega product is -1. -/
theorem plaquetteOmegaProd_on_extra :
    ∀ t ∈ extraStrutList,
      plaquetteOmegaProd t.1 t.2.1 t.2.2.1 t.2.2.2 = -1 := by native_decide

/-! ### Explicit zero-product examples -/

/-- `(e₁ + e₁₂)(e₂ + e₁₅) = 0` in the sedenion algebra. -/
theorem example_zeroProd_1_12_2_15 :
    isProductZero 1 12 2 15 1 1 = true := by native_decide

/-- `(e₁ - e₁₂)(e₂ - e₁₅) = 0` in the sedenion algebra. -/
theorem example_zeroProd_1_12_2_15_neg :
    isProductZero 1 12 2 15 (-1) (-1) = true := by native_decide

/-- `(e₁ + e₁₅)(e₂ - e₁₂) = 0` in the sedenion algebra. -/
theorem example_zeroProd_1_15_2_12 :
    isProductZero 1 15 2 12 1 (-1) = true := by native_decide

/-- `(e₄ + e₁₀)(e₅ + e₁₁) = 0` — a zero product from support {4,5,10,11}. -/
theorem example_zeroProd_4_10_5_11 :
    isProductZero 4 10 5 11 1 1 = true := by native_decide

/-! ### Phase pattern classification -/

/-- The phase pattern of a support: the 4-tuple of omega values. -/
def phasePattern (lo₁ lo₂ hi₁ hi₂ : Fin 16) : Int × Int × Int × Int :=
  (omega lo₁ lo₂, omega lo₁ hi₂, omega hi₁ lo₂, omega hi₁ hi₂)

/-- The distinct phase patterns on zero-product supports. -/
def zeroProdPhasePatterns : List (Int × Int × Int × Int) :=
  (zeroProdSupportList.map fun t => phasePattern t.1 t.2.1 t.2.2.1 t.2.2.2).dedup

/-- There are exactly 8 distinct phase patterns on the 42 zero-product supports.
All have product +1 (linear phase). -/
theorem zeroProdPhasePatterns_length : zeroProdPhasePatterns.length = 8 := by native_decide

/-- All zero-product phase patterns have product +1. -/
theorem zeroProdPhasePatterns_product_one :
    ∀ p ∈ zeroProdPhasePatterns, p.1 * p.2.1 * p.2.2.1 * p.2.2.2 = 1 := by native_decide

/-- The distinct phase patterns on the 21 extra supports. -/
def extraPhasePatterns : List (Int × Int × Int × Int) :=
  (extraStrutList.map fun t => phasePattern t.1 t.2.1 t.2.2.1 t.2.2.2).dedup

/-- There are exactly 2 distinct phase patterns on the extras:
`(+,-,-,-)` and `(-,+,+,+)`, both with product -1. -/
theorem extraPhasePatterns_length : extraPhasePatterns.length = 2 := by native_decide

/-- All extra phase patterns have product -1 (quadratic but non-linear phase). -/
theorem extraPhasePatterns_product_neg :
    ∀ p ∈ extraPhasePatterns, p.1 * p.2.1 * p.2.2.1 * p.2.2.2 = -1 := by native_decide

/-! ### Signed zero-product pair count -/

/-- Count of ordered signed zero-product pairs `(assessor, sign) × (assessor, sign)`.
Each assessor is `(lo, hi)` with `lo ∈ {1,...,7}`, `hi ∈ {9,...,15}`. -/
def signedZeroProdPairCount : Nat :=
  (List.finRange 16).flatMap (fun lo₁ =>
  (List.finRange 16).flatMap (fun hi₁ =>
  (List.finRange 16).flatMap (fun lo₂ =>
  (List.finRange 16).flatMap (fun hi₂ =>
    ([1, -1] : List Int).flatMap (fun σ =>
    ([1, -1] : List Int).flatMap (fun τ =>
      if (1 ≤ lo₁.val) && (lo₁.val ≤ 7) &&
         (9 ≤ hi₁.val) && (hi₁.val ≤ 15) &&
         (1 ≤ lo₂.val) && (lo₂.val ≤ 7) &&
         (9 ≤ hi₂.val) && (hi₂.val ≤ 15) &&
         ((lo₁ != lo₂) || (hi₁ != hi₂)) &&
         isProductZero lo₁ hi₁ lo₂ hi₂ σ τ
      then [()] else []))))))
  |>.length

/-- There are exactly 336 ordered signed zero-product pairs. -/
theorem signedZeroProdPairCount_eq : signedZeroProdPairCount = 336 := by native_decide

/-! ### Omega table

The complete 16×16 omega table for reference and verification:

```
      0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
 0: [ +   +   +   +   +   +   +   +   +   +   +   +   +   +   +   +]
 1: [ +   -   +   -   +   -   -   +   +   -   -   +   -   +   +   -]
 2: [ +   -   -   +   +   +   -   -   +   +   -   -   -   -   +   +]
 3: [ +   +   -   -   +   -   +   -   +   -   +   -   -   +   -   +]
 4: [ +   -   -   -   -   +   +   +   +   +   +   +   -   -   -   -]
 5: [ +   +   -   +   -   -   -   +   +   -   +   -   +   -   +   -]
 6: [ +   +   +   -   -   +   -   -   +   -   -   +   +   -   -   +]
 7: [ +   -   +   +   -   -   +   -   +   +   -   -   +   +   -   -]
 8: [ +   -   -   -   -   -   -   -   -   +   +   +   +   +   +   +]
 9: [ +   +   -   +   -   +   +   -   -   -   -   +   -   +   +   -]
10: [ +   +   +   -   -   -   +   +   -   +   -   -   -   -   +   +]
11: [ +   -   +   +   -   +   -   +   -   -   +   -   -   +   -   +]
12: [ +   +   +   +   +   -   -   -   -   +   +   +   -   -   -   -]
13: [ +   -   +   -   +   +   +   -   -   -   +   -   +   -   +   -]
14: [ +   -   -   +   +   -   +   +   -   -   -   +   +   -   -   +]
15: [ +   +   -   -   +   +   -   +   -   +   -   -   +   +   -   -]
```
-/

end CocycleQuadraticPhase
