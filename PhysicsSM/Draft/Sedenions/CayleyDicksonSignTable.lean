import Mathlib

/-!
# Cayley–Dickson Sign Table

This module formalizes the recursive bit-sign convention used by the sedenion
research branch, as documented in `Sedenions/CayleyDickson_Convention.md`.

## Convention

Basis labels use bits `abcd ↔ i^d j^c ℓ^b m^a`.  The product of basis
elements satisfies

  `e_a * e_b = cdSign(n, a, b) · e_{a ⊕ b}`

where the sign is computed recursively via the Cayley–Dickson pair rule:

  `(a, b)(c, d) = (ac − d̄ b, da + b c̄)`.

## Main definitions

* `CayleyDicksonSign.cdMul n a b` — returns `(sign, index)` for `e_a * e_b`
  in the `2^n`-dimensional Cayley–Dickson algebra.
* `CayleyDicksonSign.cdSign n a b` — the sign component (±1).
* `CayleyDicksonSign.cdIdx n a b` — the index component (equals `a ^^^ b`).

## Main results

### Kernel-checked (`decide`, no `native_decide`)
* `cdIdx_eq_xor_dim8` — product index equals XOR in dimension 8.
* `octonion_triple_{1..7}` — the seven reference octonion triples are positive.
* `octonion_triples_positive` — combined statement.
* `cdSign_unit_dim8` — the octonion sign is always ±1.

### Finite verified enumeration (`native_decide`)
* `cdIdx_eq_xor_dim16` — product index equals XOR in dimension 16.
* `sedenion_low_low` / `sedenion_low_high` / `sedenion_high_low` /
  `sedenion_high_high` — structural recursion rules for sedenion products.
* `cdSign_unit_dim16` — the sedenion sign is always ±1.
* `sedenion_anticommute` — distinct imaginary units anticommute.
* `sedenion_square_neg` — imaginary units square to −1.
* `cdMul_zero_{left,right}_dim16` — `e_0` is the identity.

## References

* `Sedenions/CayleyDickson_Convention.md`
* `Scripts/sedenions/explore_zero_divisor_geometry.py`
-/

-- Draft module: native_decide is used for finite verified enumeration
-- in dimension 16. Dimension 8 results use kernel decide only.
set_option linter.style.nativeDecide false

namespace CayleyDicksonSign

/-! ### Core definitions -/

/-- Conjugation sign: `+1` for the identity element, `−1` for all imaginary units. -/
def conjSign (a : ℕ) : Int :=
  if a = 0 then 1 else -1

/-- The recursive Cayley–Dickson basis product in dimension `2^n`.
Returns `(sign, index)` where `e_a * e_b = sign · e_index`.

The recursion implements the pair rule `(a,b)(c,d) = (ac − d̄ b, da + b c̄)`,
decomposing each label into a high bit and a `(n-1)`-bit remainder. -/
def cdMul : ℕ → ℕ → ℕ → Int × ℕ
  | 0, _, _ => (1, 0)
  | n + 1, a, b =>
    let half := 2 ^ n
    let al := a % half
    let ah := a / half
    let bl := b % half
    let bh := b / half
    if ah = 0 then
      if bh = 0 then
        -- (e_al, 0) * (e_bl, 0) = (e_al * e_bl, 0)
        cdMul n al bl
      else
        -- (e_al, 0) * (0, e_bl) = (0, e_bl * e_al)
        let p := cdMul n bl al
        (p.1, half + p.2)
    else
      if bh = 0 then
        -- (0, e_al) * (e_bl, 0) = (0, e_al * conj(e_bl))
        let p := cdMul n al bl
        (p.1 * conjSign bl, half + p.2)
      else
        -- (0, e_al) * (0, e_bl) = (−conj(e_bl) * e_al, 0)
        let p := cdMul n bl al
        (-conjSign bl * p.1, p.2)

/-- The sign component of the Cayley–Dickson product. -/
def cdSign (n a b : ℕ) : Int := (cdMul n a b).1

/-- The index component of the Cayley–Dickson product. -/
def cdIdx (n a b : ℕ) : ℕ := (cdMul n a b).2

/-! ### Basic properties of `conjSign` -/

theorem conjSign_zero : conjSign 0 = 1 := rfl

theorem conjSign_pos {a : ℕ} (ha : a ≠ 0) : conjSign a = -1 := if_neg ha

theorem conjSign_sq (a : ℕ) : conjSign a * conjSign a = 1 := by
  unfold conjSign; split <;> norm_num

theorem conjSign_unit (a : ℕ) : conjSign a = 1 ∨ conjSign a = -1 := by
  unfold conjSign; split <;> simp

/-! ### Product index equals XOR — dimension 8 (octonions)

Kernel-checked: uses `decide`, no `native_decide`. -/

/-- In the 8-dimensional Cayley–Dickson algebra, the product index is XOR. -/
theorem cdIdx_eq_xor_dim8 :
    ∀ a b : Fin 8, cdIdx 3 a.val b.val = a.val ^^^ b.val := by decide

/-! ### Seven reference octonion triples are positive

Kernel-checked: uses `decide`, no `native_decide`.

These are the standard positive triples for the recursive Cayley–Dickson
octonion convention:

  001 * 010 = +011,  001 * 100 = +101,  001 * 111 = +110,
  010 * 100 = +110,  010 * 101 = +111,  011 * 100 = +111,
  011 * 110 = +101.
-/

theorem octonion_triple_1 : cdMul 3 1 2 = (1, 3) := by decide
theorem octonion_triple_2 : cdMul 3 1 4 = (1, 5) := by decide
theorem octonion_triple_3 : cdMul 3 1 7 = (1, 6) := by decide
theorem octonion_triple_4 : cdMul 3 2 4 = (1, 6) := by decide
theorem octonion_triple_5 : cdMul 3 2 5 = (1, 7) := by decide
theorem octonion_triple_6 : cdMul 3 3 4 = (1, 7) := by decide
theorem octonion_triple_7 : cdMul 3 3 6 = (1, 5) := by decide

/-- All seven reference octonion triples have positive sign (kernel-checked). -/
theorem octonion_triples_positive :
    cdSign 3 1 2 = 1 ∧ cdSign 3 1 4 = 1 ∧ cdSign 3 1 7 = 1 ∧
    cdSign 3 2 4 = 1 ∧ cdSign 3 2 5 = 1 ∧
    cdSign 3 3 4 = 1 ∧ cdSign 3 3 6 = 1 := by decide

/-- In the octonion algebra, the product sign is ±1 (kernel-checked). -/
theorem cdSign_unit_dim8 :
    ∀ a b : Fin 8, cdSign 3 a.val b.val = 1 ∨ cdSign 3 a.val b.val = -1 := by decide

/-! ### Product index equals XOR — dimension 16 (sedenions)

The following results use `native_decide` for finite verified enumeration
over `Fin 16 × Fin 16` (256 cases, each with depth-4 recursion). -/

/-- In the 16-dimensional Cayley–Dickson algebra, the product index is XOR. -/
theorem cdIdx_eq_xor_dim16 :
    ∀ a b : Fin 16, cdIdx 4 a.val b.val = a.val ^^^ b.val := by native_decide

/-! ### Structural recursion rules for sedenion products

For octonion labels `q, r : Fin 8`, the sedenion product decomposes as:

* `e_q * e_r = cdMul 3 q r`  (pure octonion part)
* `e_q * e_{8+r} = (cdSign 3 r q, 8 + cdIdx 3 r q)`
* `e_{8+q} * e_r = (cdSign 3 q r * conjSign r, 8 + cdIdx 3 q r)`
* `e_{8+q} * e_{8+r} = (−conjSign r * cdSign 3 r q, cdIdx 3 r q)`
-/

/-- Low × Low: the octonion subalgebra is preserved. -/
theorem sedenion_low_low :
    ∀ q r : Fin 8,
      cdMul 4 q.val r.val = cdMul 3 q.val r.val := by native_decide

/-- Low × High: `e_q * e_{8+r} = (cdSign 3 r q) · e_{8 + (r ⊕ q)}`. -/
theorem sedenion_low_high :
    ∀ q r : Fin 8,
      cdMul 4 q.val (8 + r.val) =
        ((cdMul 3 r.val q.val).1, 8 + (cdMul 3 r.val q.val).2) := by native_decide

/-- High × Low: `e_{8+q} * e_r = (cdSign 3 q r · conjSign r) · e_{8 + (q ⊕ r)}`. -/
theorem sedenion_high_low :
    ∀ q r : Fin 8,
      cdMul 4 (8 + q.val) r.val =
        ((cdMul 3 q.val r.val).1 * conjSign r.val, 8 + (cdMul 3 q.val r.val).2) := by
  native_decide

/-- High × High: `e_{8+q} * e_{8+r} = (−conjSign r · cdSign 3 r q) · e_{r ⊕ q}`. -/
theorem sedenion_high_high :
    ∀ q r : Fin 8,
      cdMul 4 (8 + q.val) (8 + r.val) =
        (-conjSign r.val * (cdMul 3 r.val q.val).1, (cdMul 3 r.val q.val).2) := by
  native_decide

/-! ### Sign is always ±1 -/

/-- In the sedenion algebra, the product sign is ±1. -/
theorem cdSign_unit_dim16 :
    ∀ a b : Fin 16, cdSign 4 a.val b.val = 1 ∨ cdSign 4 a.val b.val = -1 := by native_decide

/-! ### Identity element properties -/

/-- `e_0` is a left identity in the sedenion algebra. -/
theorem cdMul_zero_left_dim16 :
    ∀ b : Fin 16, cdMul 4 0 b.val = (1, b.val) := by native_decide

/-- `e_0` is a right identity in the sedenion algebra. -/
theorem cdMul_zero_right_dim16 :
    ∀ a : Fin 16, cdMul 4 a.val 0 = (1, a.val) := by native_decide

/-! ### Anticommutativity for imaginary units -/

/-- Distinct imaginary basis units anticommute in the sedenion algebra:
`e_a * e_b = −(e_b * e_a)` when `a ≠ b`, `a ≠ 0`, `b ≠ 0`, and `a ⊕ b ≠ 0`. -/
theorem sedenion_anticommute :
    ∀ a b : Fin 16,
      a.val ≠ 0 → b.val ≠ 0 → a.val ^^^ b.val ≠ 0 →
        cdSign 4 a.val b.val = -cdSign 4 b.val a.val := by native_decide

/-! ### Squaring: imaginary units square to −1 -/

/-- Every imaginary basis unit squares to `−e_0` in the sedenion algebra. -/
theorem sedenion_square_neg :
    ∀ a : Fin 16, a.val ≠ 0 →
      cdMul 4 a.val a.val = (-1, 0) := by native_decide

end CayleyDicksonSign
