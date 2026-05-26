/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib

set_option linter.style.nativeDecide false

/-!
# Reed-Muller Code RM(2,4) and Sedenion Zero-Divisor Code

This file formalizes the finite code theorem for the sedenion zero-divisor
code C_ZD, connecting it to the second-order Reed-Muller code RM(2,4):

* **C_ZD** = F₂-span of the 42 signed zero-product support indicators
* **C_ZD** = {c ∈ RM(2,4) : c₀ = 0 ∧ c₈ = 0}  (the "shortened" RM(2,4))
* dim C_ZD = 9,  |C_ZD| = 512
* Weight enumerator: 1 + 77y⁴ + 168y⁶ + 203y⁸ + 56y¹⁰ + 7y¹²
* span(42 zero-product supports) = span(63 same-strut supports)

## Convention

This file uses the recursive Cayley-Dickson convention documented in
`Sedenions/CayleyDickson_Convention.md`.  Sedenion basis labels are
`abcd ↔ i^d j^c ℓ^b m^a`, with `a,b,c,d ∈ {0,1}`.

## Representation

Codewords of length 16 over F₂ are represented as natural numbers
(bitmasks in {0, …, 65535}).  Bit i of the word `w` corresponds to
coordinate i.  The F₂ linear span is computed by iterative XOR closure.

## Main results

* `cZD_card_eq` : |C_ZD| = 512
* `cZD_rank_eq` : rank C_ZD = 9 (the span has rank 9 over F₂)
* `cZD_eq_shortRM24` : C_ZD = ShortRM24
* `sameStrutSpan_eq_cZD` : span(63 same-strut) = span(42 zero-product)
* `cZD_weightEnum` : the weight distribution is as stated
* `rm24_card_eq` : |RM(2,4)| = 2048

## References

* Oracle script: `Scripts/sedenions/explore_zero_divisor_geometry.py`
* Research proposal: `Sedenions/SedenionZeroDivisors_ResearchProposal.md`
-/

namespace ReedMuller

/-! ### Bit-level utilities -/

/-- Extract bit `i` from a natural number, returning 0 or 1. -/
def getBit (w : Nat) (i : Nat) : Nat := (w >>> i) &&& 1

/-- Hamming weight of a 16-bit word. -/
def hammingWt (w : Nat) : Nat :=
  (List.range 16).countP (fun i => getBit w i = 1)

/-! ### F₂ linear span -/

/-- The F₂ linear span of a list of words (as bit patterns).
    Computed by iteratively extending the span with each generator:
    `S ← S ∪ {s ⊕ g : s ∈ S}` for each generator `g`. -/
def spanF2 (words : List Nat) : Finset Nat :=
  words.foldl (fun acc w => acc ∪ acc.image (· ^^^ w)) {0}

/-- Rank of a set of binary vectors: the log₂ of the span size. -/
def rankF2 (words : List Nat) : Nat :=
  Nat.log 2 (spanF2 words).card

/-! ### Cayley-Dickson sedenion multiplication -/

/-- Recursive Cayley-Dickson basis multiplication for the 2ⁿ-dimensional
    algebra.  Returns `(sign, index)` for `eₐ * e_b`.

    Convention: `(a, 0) * (b, 0) = (a*b, 0)`;
    `(a, 0) * (0, b) = (0, b*a)`;
    `(0, a) * (b, 0) = (0, a * conj(b))`;
    `(0, a) * (0, b) = (- conj(b) * a, 0)`. -/
def cdMulBasis : Nat → Nat → Nat → Int × Nat
  | 0, _, _ => (1, 0)
  | n + 1, a, b =>
    let half := 2 ^ n
    let ah := a / half; let al := a % half
    let bh := b / half; let bl := b % half
    let conjBl : Int := if bl = 0 then 1 else -1
    if ah = 0 then
      if bh = 0 then cdMulBasis n al bl
      else -- (al, 0) * (0, bl) = (0, bl * al)
        let (s, k) := cdMulBasis n bl al; (s, half + k)
    else
      if bh = 0 then -- (0, al) * (bl, 0) = (0, al * conj(bl))
        let (s, k) := cdMulBasis n al bl; (s * conjBl, half + k)
      else -- (0, al) * (0, bl) = (- conj(bl) * al, 0)
        let (s, k) := cdMulBasis n bl al; (-conjBl * s, k)

/-- Multiply sparse sedenion vectors represented as `List (Int × Nat)`.
    Each element `(c, i)` represents `c · eᵢ`. -/
def vecMul (x y : List (Int × Nat)) : List (Int × Nat) :=
  let raw := x.flatMap fun (ca, a) => y.map fun (cb, b) =>
    let (s, k) := cdMulBasis 4 a b; (ca * cb * s, k)
  let indices := (raw.map Prod.snd).eraseDups
  indices.filterMap fun k =>
    let coeff := (raw.filter (fun p => p.2 = k)).foldl (fun acc (c, _) => acc + c) 0
    if coeff = 0 then none else some (coeff, k)

/-! ### Assessor pairs and zero-product supports -/

/-- The 42 assessor pairs `(i, 8+j)` for `i, j ∈ {1,…,7}`, `i ≠ j`.
    Each pair indexes a mixed low/high basis pair in the sedenion algebra. -/
def assessorPairs : List (Nat × Nat) :=
  (List.range 7).flatMap fun i0 => (List.range 7).filterMap fun j0 =>
    let i := i0 + 1; let j := j0 + 1
    if i ≠ j then some (i, 8 + j) else none

/-- The 42 zero-product support words.  A support is `{i, 8+j, p, 8+q}` where
    `(eᵢ + σ·e_{8+j}) * (e_p + τ·e_{8+q}) = 0` in the sedenion algebra
    for some choice of signs `σ, τ ∈ {±1}`.  We collect distinct 4-element
    supports as 16-bit indicator words. -/
def zeroProductSupportWords : List Nat := Id.run do
  let mut seen : Std.HashSet Nat := {}
  let mut result : Array Nat := #[]
  for (low1, high1) in assessorPairs do
    for sigma in ([1, -1] : List Int) do
      let v1 : List (Int × Nat) := [(1, low1), (sigma, high1)]
      for (low2, high2) in assessorPairs do
        if (low1, high1) = (low2, high2) then continue
        for tau in ([1, -1] : List Int) do
          let v2 : List (Int × Nat) := [(1, low2), (tau, high2)]
          if (vecMul v1 v2).isEmpty then
            let word := (1 <<< low1) ||| (1 <<< high1) ||| (1 <<< low2) ||| (1 <<< high2)
            if ¬(seen.contains word) then
              seen := seen.insert word
              result := result.push word
  return result.toList

/-- The 63 same-strut mixed affine-plane support words.
    The same-strut condition: `{i, 8+j, p, 8+q}` where
    `i ⊕ j = p ⊕ q` (same XOR "strut") with all indices in `{1,…,7}`,
    `i ≠ j`, `p ≠ q`, `(p,q) ≠ (i,j)`. -/
def sameStrutSupportWords : List Nat := Id.run do
  let mut seen : Std.HashSet Nat := {}
  let mut result : Array Nat := #[]
  for i in List.range 7 do
    let i := i + 1
    for j in List.range 7 do
      let j := j + 1
      if i = j then continue
      let s := i ^^^ j
      for p in List.range 7 do
        let p := p + 1
        for q in List.range 7 do
          let q := q + 1
          if p = q then continue
          if (p, q) = (i, j) then continue
          if (p ^^^ q) = s then
            let word := (1 <<< i) ||| (1 <<< (8 + j)) ||| (1 <<< p) ||| (1 <<< (8 + q))
            if ¬(seen.contains word) then
              seen := seen.insert word
              result := result.push word
  return result.toList

/-! ### Reed-Muller code RM(2,4)

RM(2,4) is the second-order Reed-Muller code of length 16.  It consists of
all evaluations of Boolean polynomials of degree ≤ 2 on F₂⁴.  Its dimension
is `1 + 4 + 6 = 11` and its size is `2^11 = 2048`.

We define it by its 11 basis vectors:
- 1 constant vector (all ones)
- 4 linear evaluation vectors `xᵢ` for `i ∈ {0,1,2,3}`
- 6 quadratic evaluation vectors `xᵢ·xⱼ` for `i < j`

Point `x ∈ {0,…,15}` is identified with `(x₀, x₁, x₂, x₃) ∈ F₂⁴`
where `xᵢ = (x >>> i) &&& 1`.
-/

/-- The 11 basis vectors of RM(2,4), as 16-bit indicator words.

    - `65535` = constant 1 (all 16 positions)
    - `43690` = x₀ (positions where bit 0 is set)
    - `52428` = x₁ (positions where bit 1 is set)
    - `61680` = x₂ (positions where bit 2 is set)
    - `65280` = x₃ (positions where bit 3 is set)
    - `34952` = x₀·x₁
    - `41120` = x₀·x₂
    - `43520` = x₀·x₃
    - `49344` = x₁·x₂
    - `52224` = x₁·x₃
    - `61440` = x₂·x₃ -/
def rm24Basis : List Nat :=
  [65535, 43690, 52428, 61680, 65280, 34952, 41120, 43520, 49344, 52224, 61440]

/-- The F₂ span of the RM(2,4) basis = the full RM(2,4) code. -/
def rm24Code : Finset Nat := spanF2 rm24Basis

/-- Basis for the shortened RM(2,4): {c ∈ RM(2,4) : c₀ = 0 ∧ c₈ = 0}.

    Constraining `c₀ = 0` forces the constant coefficient to 0 (since all
    linear and quadratic monomials vanish at `x = 0`).  Then `c₈ = 0`
    forces the `x₃` coefficient to 0 (since at `x = 8 = (0,0,0,1)` only
    `x₃` is nonzero among the remaining basis functions).  This leaves
    9 = 11 - 2 basis vectors. -/
def shortRM24Basis : List Nat :=
  [43690, 52428, 61680, 34952, 41120, 43520, 49344, 52224, 61440]

/-- The shortened RM(2,4) code. -/
def shortRM24Code : Finset Nat := spanF2 shortRM24Basis

/-- The code C_ZD: F₂ span of the 42 zero-product support indicators. -/
def cZD : Finset Nat := spanF2 zeroProductSupportWords

/-- The code spanned by the 63 same-strut support indicators. -/
def sameStrutSpan : Finset Nat := spanF2 sameStrutSupportWords

/-! ### Verified properties of the RM(2,4) basis

We first verify that our 11 claimed basis vectors actually equal the
evaluation of the corresponding Boolean monomials on F₂⁴.
-/

/-- Evaluate the Boolean monomial given by `mask ⊆ {0,1,2,3}` at point `x`.
    The monomial is `∏_{i ∈ mask} xᵢ`; the constant monomial has `mask = 0`. -/
def evalMonomial (mask : Nat) (x : Nat) : Nat :=
  if mask = 0 then 1
  else if (List.range 4).all (fun i => getBit mask i = 0 ∨ getBit x i = 1) then 1
  else 0

/-- The evaluation vector of a monomial: bit `x` is set iff the monomial
    evaluates to 1 at point `x`. -/
def evalVector (mask : Nat) : Nat :=
  (List.range 16).foldl (fun acc x => acc ||| (evalMonomial mask x <<< x)) 0

/-- The RM(2,4) basis vectors match the evaluation of degree ≤ 2 monomials. -/
theorem rm24Basis_eq_eval :
    rm24Basis = [evalVector 0,   -- constant
                 evalVector 1,   -- x₀
                 evalVector 2,   -- x₁
                 evalVector 4,   -- x₂
                 evalVector 8,   -- x₃
                 evalVector 3,   -- x₀x₁
                 evalVector 5,   -- x₀x₂
                 evalVector 9,   -- x₀x₃
                 evalVector 6,   -- x₁x₂
                 evalVector 10,  -- x₁x₃
                 evalVector 12]  -- x₂x₃
    := by native_decide

/-! ### Main theorems -/

/-- RM(2,4) has 2048 = 2¹¹ codewords. -/
theorem rm24_card_eq : rm24Code.card = 2048 := by native_decide

/-- The shortened code has 512 = 2⁹ codewords. -/
theorem shortRM24_card_eq : shortRM24Code.card = 512 := by native_decide

/-- There are exactly 42 zero-product support words. -/
theorem zeroProductSupports_count : zeroProductSupportWords.length = 42 := by native_decide

/-- There are exactly 63 same-strut support words. -/
theorem sameStrutSupports_count : sameStrutSupportWords.length = 63 := by native_decide

/-- The zero-product code C_ZD has 512 elements. -/
theorem cZD_card_eq : cZD.card = 512 := by native_decide

/-- The rank of C_ZD over F₂ is 9. -/
theorem cZD_rank_eq : rankF2 zeroProductSupportWords = 9 := by native_decide

/-- **Main theorem**: C_ZD equals the shortened RM(2,4) code. -/
theorem cZD_eq_shortRM24 : cZD = shortRM24Code := by native_decide

/-- The same-strut span equals C_ZD. -/
theorem sameStrutSpan_eq_cZD : sameStrutSpan = cZD := by native_decide

/-- Every zero-product support word is also a same-strut support word. -/
theorem zeroProduct_subset_sameStrut :
    ∀ w ∈ zeroProductSupportWords, w ∈ sameStrutSupportWords := by native_decide

/-- The shortened RM(2,4) is a subset of RM(2,4). -/
theorem shortRM24_subset_rm24 : shortRM24Code ⊆ rm24Code := by native_decide

/-- Every codeword in ShortRM24 has bit 0 = 0 and bit 8 = 0. -/
theorem shortRM24_bits_zero :
    ∀ w ∈ shortRM24Code, getBit w 0 = 0 ∧ getBit w 8 = 0 := by native_decide

/-- Every codeword of RM(2,4) with bit 0 = 0 and bit 8 = 0 is in ShortRM24. -/
theorem rm24_shortened_complete :
    ∀ w ∈ rm24Code, getBit w 0 = 0 → getBit w 8 = 0 → w ∈ shortRM24Code := by native_decide

/-! ### Weight enumerator

The weight enumerator of C_ZD = ShortRM24:
  W(y) = 1 + 77·y⁴ + 168·y⁶ + 203·y⁸ + 56·y¹⁰ + 7·y¹²

We verify each coefficient individually.
-/

/-- Number of weight-0 codewords in C_ZD. -/
theorem cZD_wt0 : (cZD.filter (fun w => hammingWt w = 0)).card = 1 := by native_decide

/-- Number of weight-4 codewords in C_ZD. -/
theorem cZD_wt4 : (cZD.filter (fun w => hammingWt w = 4)).card = 77 := by native_decide

/-- Number of weight-6 codewords in C_ZD. -/
theorem cZD_wt6 : (cZD.filter (fun w => hammingWt w = 6)).card = 168 := by native_decide

/-- Number of weight-8 codewords in C_ZD. -/
theorem cZD_wt8 : (cZD.filter (fun w => hammingWt w = 8)).card = 203 := by native_decide

/-- Number of weight-10 codewords in C_ZD. -/
theorem cZD_wt10 : (cZD.filter (fun w => hammingWt w = 10)).card = 56 := by native_decide

/-- Number of weight-12 codewords in C_ZD. -/
theorem cZD_wt12 : (cZD.filter (fun w => hammingWt w = 12)).card = 7 := by native_decide

/-- No codewords of odd weight exist in C_ZD. -/
theorem cZD_no_odd_weight :
    ∀ w ∈ cZD, hammingWt w % 2 = 0 := by native_decide

/-- The minimum distance of C_ZD is 4. -/
theorem cZD_minDist :
    (∀ w ∈ cZD, w ≠ 0 → 4 ≤ hammingWt w) ∧
    (∃ w ∈ cZD, w ≠ 0 ∧ hammingWt w = 4) := by native_decide

/-- The weight enumerator accounts for all 512 codewords. -/
theorem cZD_weight_partition :
    1 + 77 + 168 + 203 + 56 + 7 = 512 := by norm_num

/-! ### Relationship between RM(2,4) and its shortened code

The following theorems establish that ShortRM24 is precisely the
subcode of RM(2,4) obtained by puncturing (setting to zero) coordinates
0 and 8.
-/

/-- ShortRM24 = {c ∈ RM(2,4) : c₀ = 0 ∧ c₈ = 0}, as a Finset equality. -/
theorem shortRM24_eq_rm24_punctured :
    shortRM24Code = rm24Code.filter (fun w => getBit w 0 = 0 ∧ getBit w 8 = 0) := by
  native_decide

/-! ### Additional structural results -/

/-- All 42 zero-product support words are codewords of weight 4. -/
theorem zeroProductSupports_weight4 :
    ∀ w ∈ zeroProductSupportWords, hammingWt w = 4 := by native_decide

/-- All 42 zero-product support words lie in the code C_ZD. -/
theorem zeroProductSupports_in_cZD :
    ∀ w ∈ zeroProductSupportWords, w ∈ cZD := by native_decide

/-- All 63 same-strut support words are codewords of weight 4. -/
theorem sameStrutSupports_weight4 :
    ∀ w ∈ sameStrutSupportWords, hammingWt w = 4 := by native_decide

/-- All 63 same-strut support words lie in the code C_ZD. -/
theorem sameStrutSupports_in_cZD :
    ∀ w ∈ sameStrutSupportWords, w ∈ cZD := by native_decide

/-- The 77 weight-4 codewords in C_ZD include but are not exhausted by
    the 63 same-strut supports.  There are 77 - 63 = 14 additional
    weight-4 words that arise as F₂ sums but are not individual supports. -/
theorem weight4_count_vs_supports :
    (cZD.filter (fun w => hammingWt w = 4)).card = 77 ∧
    sameStrutSupportWords.length = 63 := by
  exact ⟨cZD_wt4, sameStrutSupports_count⟩

end ReedMuller
