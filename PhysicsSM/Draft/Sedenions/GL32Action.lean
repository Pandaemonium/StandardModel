/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: PhysicsSM Contributors
-/
import Mathlib

/-! # GL(3,2) Signed Action on Sedenion Supports

This module defines GL(3,2) ≅ PSL(2,7) as the group of invertible F₂-linear
maps on F₂³, proves it has 168 elements, and shows that it acts on the
assessor and same-strut support families arising from the Cayley-Dickson
sedenion construction.

## Main results

* `gl32_card` : |GL(3,2)| = 168
* `zpSupportSet_card` : there are exactly 42 zero-product supports
* `sameStrutSupportSet_card` : there are exactly 63 same-strut supports
* `zpSupports_subset_sameStrut` : the 42 are a subset of the 63
* `gl32_preserves_zpSupports` : GL(3,2) preserves the 42 zero-product supports
* `gl32_preserves_sameStrutSupports` : GL(3,2) preserves the 63 same-strut
  supports
* `sign_not_globally_preserved` : the Cayley-Dickson sign cocycle is **not**
  exactly preserved by GL(3,2) — concrete counterexample: swapping basis
  elements 1 ↔ 2 changes `sedSign 1 2` from `+1` to `−1`
* `octonion_gauge_all_gl32` : every GL(3,2) element admits an octonion-level
  sign gauge (the cocycle is a coboundary on the Fano plane)

## Convention

We follow the recursive Cayley-Dickson convention documented in
`Sedenions/CayleyDickson_Convention.md`. Basis labels are 4-bit indices
`abcd ↔ i^d j^c ℓ^b m^a`, and the product index is always XOR.
-/

-- All theorems use certified finite computation (`native_decide`),
-- with raised heartbeat limits for heavy Finset enumeration.
set_option linter.style.setOption false
set_option linter.style.nativeDecide false
set_option linter.style.maxHeartbeats false

namespace GL32Action

-- ============================================================
-- § 1. XOR on Fin 8
-- ============================================================

/-- XOR bound: `a ^^^ b < 8` for `a b : Fin 8`. -/
private theorem xor_val_lt_8 (a b : Fin 8) : a.val ^^^ b.val < 8 := by
  have := a.isLt; have := b.isLt
  interval_cases a.val <;> interval_cases b.val <;> decide

/-- XOR operation on `Fin 8`, modelling F₂³ addition. -/
def xorF8 (a b : Fin 8) : Fin 8 :=
  ⟨a.val ^^^ b.val, xor_val_lt_8 a b⟩

-- ============================================================
-- § 2. GL(3,2) as basis-image triples
-- ============================================================

/-- Extend an F₂-linear map from basis `{1, 2, 4}` to all of `Fin 8`.
    The map is `f(a) = ⊕_{bit i set in a} vᵢ`. -/
def extendLinear (v1 v2 v4 : Fin 8) (a : Fin 8) : Fin 8 :=
  xorF8 (xorF8
    (if a.val &&& 1 ≠ 0 then v1 else 0)
    (if a.val &&& 2 ≠ 0 then v2 else 0))
    (if a.val &&& 4 ≠ 0 then v4 else 0)

/-- A basis triple is *valid* for GL(3,2) if the extended map is injective
    (equivalently, all 8 images are distinct). -/
def isValidGL32 (t : Fin 8 × Fin 8 × Fin 8) : Bool :=
  (List.ofFn (extendLinear t.1 t.2.1 t.2.2)).Nodup

/-- The set of valid GL(3,2) basis triples. Each triple `(v₁, v₂, v₄)`
    represents the unique F₂-linear bijection sending `1 ↦ v₁, 2 ↦ v₂,
    4 ↦ v₄`. -/
def gl32Triples : Finset (Fin 8 × Fin 8 × Fin 8) :=
  Finset.univ.filter fun t => isValidGL32 t = true

/-- GL(3,2) has exactly 168 = 7 × 6 × 4 elements (the order of GL₃(F₂)). -/
theorem gl32_card : gl32Triples.card = 168 := by native_decide

-- ============================================================
-- § 3. Cayley-Dickson sign cocycle
-- ============================================================

/-- Recursive Cayley-Dickson multiplication sign.
    In the `2^n`-dimensional Cayley-Dickson algebra,
    `e_a * e_b = cdSign n a b • e_{a ^^^ b}`. -/
def cdSign : ℕ → ℕ → ℕ → Int
  | 0, _, _ => 1
  | n + 1, a, b =>
    let half := 2 ^ n
    let al := a % half; let bl := b % half
    if a / half = 0 then
      if b / half = 0 then cdSign n al bl
      else cdSign n bl al
    else
      if b / half = 0 then
        cdSign n al bl * (if bl = 0 then 1 else -1)
      else
        -(if bl = 0 then 1 else -1) * cdSign n bl al

/-- Sedenion sign for basis elements `e_a * e_b` (4-bit labels). -/
abbrev sedSign (a b : Fin 16) : Int := cdSign 4 a.val b.val

/-- Octonion sign for basis elements `e_a * e_b` (3-bit labels). -/
abbrev octSign (a b : Fin 8) : Int := cdSign 3 a.val b.val

-- ============================================================
-- § 4. GL(3,2) action on sedenion labels
-- ============================================================

/-- Lift a `Fin 8 → Fin 8` map to `Fin 16 → Fin 16` by acting on the
    lower 3 bits (the octonion part), preserving the high bit (the `m`-flag).
    Concretely: for `x < 8`, `lift(f)(x) = f(x)`; for `x ≥ 8`,
    `lift(f)(x) = 8 + f(x − 8)`. -/
def liftToSed (f : Fin 8 → Fin 8) (x : Fin 16) : Fin 16 :=
  if h : x.val < 8 then
    ⟨(f ⟨x.val, h⟩).val, by omega⟩
  else
    ⟨8 + (f ⟨x.val - 8, by omega⟩).val, by omega⟩

/-- GL(3,2) action on `Fin 16` sedenion labels via a basis triple. -/
def gl32ActF16 (t : Fin 8 × Fin 8 × Fin 8) : Fin 16 → Fin 16 :=
  liftToSed (extendLinear t.1 t.2.1 t.2.2)

-- ============================================================
-- § 5. Assessor supports
-- ============================================================

/-- An *assessor pair* `(i, j)` with `i, j ∈ {1,…,7}` and `i ≠ j`
    represents the sedenion pair `(eᵢ, e_{8+j})`. -/
def isAssessorPair (i j : Fin 8) : Bool :=
  i ≠ 0 && j ≠ 0 && decide (i ≠ j)

/-- There are exactly 42 assessor pairs. -/
theorem assessorPair_card :
    (Finset.univ.filter fun t : Fin 8 × Fin 8 =>
      isAssessorPair t.1 t.2 = true).card = 42 := by
  native_decide

/-- Encode the support `{i, 8+j, k, 8+l}` as a `Finset (Fin 16)`. -/
def mkSupport (i j k l : Fin 8) : Finset (Fin 16) :=
  {⟨i.val, by omega⟩, ⟨8 + j.val, by omega⟩,
   ⟨k.val, by omega⟩, ⟨8 + l.val, by omega⟩}

/-- Same-strut quadruple check (Bool version for decidability).
    A quadruple `(i, j, k, l)` satisfies the *same-strut* condition if
    `i ⊕ j = k ⊕ l`, all are nonzero, and the two pairs are distinct. -/
def isSameStrutQuadB (t : Fin 8 × Fin 8 × Fin 8 × Fin 8) : Bool :=
  let i := t.1; let j := t.2.1; let k := t.2.2.1; let l := t.2.2.2
  i ≠ 0 && j ≠ 0 && k ≠ 0 && l ≠ 0 &&
  decide (i ≠ j) && decide (k ≠ l) && decide ((i, j) ≠ (k, l)) &&
  decide (xorF8 i j = xorF8 k l)

/-- Sign-compatibility condition for the Cayley-Dickson cocycle.
    When this holds jointly with the same-strut condition, there exist
    signs `σ, τ ∈ {±1}` making `(eᵢ + σ e_{8+j})(eₖ + τ e_{8+l}) = 0`. -/
def isSignCompatB (t : Fin 8 × Fin 8 × Fin 8 × Fin 8) : Bool :=
  let i := t.1; let j := t.2.1; let k := t.2.2.1; let l := t.2.2.2
  decide (cdSign 4 i.val k.val *
            cdSign 4 (8 + j.val) (8 + l.val) =
          cdSign 4 (8 + j.val) k.val *
            cdSign 4 i.val (8 + l.val))

/-- Zero-product quadruple: same-strut AND sign-compatible. -/
def isZPQuadB (t : Fin 8 × Fin 8 × Fin 8 × Fin 8) : Bool :=
  isSameStrutQuadB t && isSignCompatB t

/-- The set of zero-product four-point supports in `{0,…,15}`. -/
def zpSupportSet : Finset (Finset (Fin 16)) :=
  (Finset.univ.filter fun t => isZPQuadB t = true).image
    fun t => mkSupport t.1 t.2.1 t.2.2.1 t.2.2.2

/-- The set of same-strut four-point supports in `{0,…,15}`. -/
def sameStrutSupportSet : Finset (Finset (Fin 16)) :=
  (Finset.univ.filter fun t => isSameStrutQuadB t = true).image
    fun t => mkSupport t.1 t.2.1 t.2.2.1 t.2.2.2

-- Certified finite enumeration of support families
set_option maxHeartbeats 800000 in
/-- There are exactly 42 zero-product supports. -/
theorem zpSupportSet_card : zpSupportSet.card = 42 := by native_decide

set_option maxHeartbeats 800000 in
/-- There are exactly 63 same-strut supports. -/
theorem sameStrutSupportSet_card :
    sameStrutSupportSet.card = 63 := by native_decide

set_option maxHeartbeats 800000 in
/-- The 42 zero-product supports are a subset of the 63 same-strut supports. -/
theorem zpSupports_subset_sameStrut :
    zpSupportSet ⊆ sameStrutSupportSet := by native_decide

set_option maxHeartbeats 800000 in
/-- The 21 extra same-strut supports not selected by signs. -/
theorem extra_sameStrut_count :
    (sameStrutSupportSet \ zpSupportSet).card = 21 := by native_decide

set_option maxHeartbeats 800000 in
/-- Cross-check: 42 + 21 = 63. -/
theorem support_partition :
    zpSupportSet.card +
      (sameStrutSupportSet \ zpSupportSet).card =
    sameStrutSupportSet.card := by native_decide

-- ============================================================
-- § 6. GL(3,2) preserves supports
-- ============================================================

/-- Apply a GL(3,2) element (given by a basis triple) to a support. -/
def gl32ActSupport (t : Fin 8 × Fin 8 × Fin 8)
    (s : Finset (Fin 16)) : Finset (Fin 16) :=
  s.image (gl32ActF16 t)

set_option maxHeartbeats 3200000 in
/-- GL(3,2) preserves the set of 63 same-strut supports. -/
theorem gl32_preserves_sameStrutSupports :
    ∀ t ∈ gl32Triples, ∀ s ∈ sameStrutSupportSet,
      gl32ActSupport t s ∈ sameStrutSupportSet := by
  native_decide

set_option maxHeartbeats 3200000 in
/-- GL(3,2) preserves the set of 42 zero-product supports. -/
theorem gl32_preserves_zpSupports :
    ∀ t ∈ gl32Triples, ∀ s ∈ zpSupportSet,
      gl32ActSupport t s ∈ zpSupportSet := by
  native_decide

-- ============================================================
-- § 7. GL(3,2) preserves assessor pairs
-- ============================================================

set_option maxHeartbeats 800000 in
/-- GL(3,2) acts on the 42 assessor pairs: if `(i, j)` is an assessor pair
    then so is `(g(i), g(j))` for any `g ∈ GL(3,2)`. -/
theorem gl32_preserves_assessorPairs :
    ∀ t ∈ gl32Triples, ∀ p : Fin 8 × Fin 8,
      isAssessorPair p.1 p.2 = true →
      isAssessorPair (extendLinear t.1 t.2.1 t.2.2 p.1)
                     (extendLinear t.1 t.2.1 t.2.2 p.2) = true := by
  native_decide

-- ============================================================
-- § 8. Sign non-preservation counterexample
-- ============================================================

/-- The swap `1 ↔ 2` (with `4` fixed) is a valid GL(3,2) element. -/
theorem swap12_valid : isValidGL32 (2, 1, 4) = true := by native_decide

/-- Concrete counterexample: swapping basis elements 1 and 2 changes the
    sedenion sign of the product `e₁ · e₂`.
    Specifically, `sedSign 1 2 = 1` but `sedSign (g 1) (g 2) = sedSign 2 1 = -1`. -/
theorem sign_not_globally_preserved :
    ∃ t ∈ gl32Triples, ∃ a b : Fin 16,
      sedSign (gl32ActF16 t a) (gl32ActF16 t b) ≠ sedSign a b := by
  exact ⟨(2, 1, 4), by native_decide, 1, 2, by native_decide⟩

-- ============================================================
-- § 9. Octonion-level sign gauge
-- ============================================================

/-- An *octonion gauge* for a GL(3,2) element `g` is a function
    `η : Fin 8 → {±1}` (encoded as 7 bits for the imaginary units,
    with `η(0) = 1`) such that on the imaginary octonion indices
    `{1,…,7}`:
    ```
    octSign(g(a), g(b)) = η(a) · η(b) · η(a ⊕ b) · octSign(a, b)
    ```
    This says the cocycle change under `g` is a coboundary. -/
def isOctGauge (t : Fin 8 × Fin 8 × Fin 8) (ηBits : Fin 128) : Bool :=
  let f := extendLinear t.1 t.2.1 t.2.2
  let η : Fin 8 → Int := fun a =>
    if a = 0 then 1
    else if (ηBits.val >>> (a.val - 1)) &&& 1 = 0 then 1 else -1
  (List.finRange 8).all fun a =>
    (List.finRange 8).all fun b =>
      a.val = 0 || b.val = 0 ||
      decide (cdSign 3 (f a).val (f b).val =
        η a * η b * η (xorF8 a b) * cdSign 3 a.val b.val)

set_option maxHeartbeats 6400000 in
/-- Every GL(3,2) element admits an octonion-level sign gauge.
    That is, the Cayley-Dickson 2-cocycle on the Fano plane is always
    cohomologous to its image under any GL(3,2) relabelling. -/
theorem octonion_gauge_all_gl32 :
    ∀ t ∈ gl32Triples, ∃ η : Fin 128,
      isOctGauge t η = true := by
  native_decide

end GL32Action
