import Mathlib
import PhysicsSM.Algebra.Division.CayleyDickson
import PhysicsSM.Algebra.Octonion.Basic

/-!
# Algebra.Division.CayleyDicksonOctonionBridge

Explicit bridge between `CayleyDickson.CD3` (the third Cayley–Dickson
doubling of ℝ) and the project's trusted XOR-basis `Octonion`.

## Convention mismatch

The Cayley–Dickson construction with the Baez sign convention
  `(a, b) * (c, d) = (a·c − conj(d)·b, d·a + b·conj(c))`
produces a multiplication table that differs from the project's XOR-Fano
table by sign flips on the basis elements e₅ and e₇. Specifically, defining
the *corrected* map
  `φ(x) = (c₀, c₁, c₂, c₃, c₄, −c₅, c₆, −c₇)`
(where cᵢ are the flat real coordinates of the nested pair) yields a
multiplicative isomorphism `CD3 ≅ Octonion`.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), §2.2.

## Main definitions

* `CD3.toOctonion` / `CD3.ofOctonion` — naive (unsigned) coordinate maps
* `CD3.toOctonion_ofOctonion` / `CD3.ofOctonion_toOctonion` — roundtrip proofs
* `cd3Basis` — the 8 standard basis elements of `CD3`
* `cd3Sign` — the CD3 multiplication sign table
* `CD3.toOctonionIso` / `CD3.ofOctonionIso` — sign-corrected maps
* `CD3.toOctonionIso_ofOctonionIso` / `CD3.ofOctonionIso_toOctonionIso`
* `CD3.toOctonionIso_mul` — the corrected map preserves multiplication

Prerequisites:
- `PhysicsSM.Algebra.Division.CayleyDickson`
- `PhysicsSM.Algebra.Octonion.Basic`

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Division.CayleyDicksonOctonionBridge

open PhysicsSM.Algebra.Division.CayleyDickson
open PhysicsSM.Algebra.Octonion

/-! ## Part 1: Naive coordinate maps -/

/-- Map a `CD3` element to an `Octonion` by reading off the 8 nested-pair
    coordinates in the natural order:
    `(fst.fst.fst, fst.fst.snd, fst.snd.fst, fst.snd.snd,
     snd.fst.fst, snd.fst.snd, snd.snd.fst, snd.snd.snd)`. -/
def CD3.toOctonion (x : CD3) : Octonion where
  c0 := x.fst.fst.fst
  c1 := x.fst.fst.snd
  c2 := x.fst.snd.fst
  c3 := x.fst.snd.snd
  c4 := x.snd.fst.fst
  c5 := x.snd.fst.snd
  c6 := x.snd.snd.fst
  c7 := x.snd.snd.snd

/-- Map an `Octonion` back to `CD3` by packing the 8 coordinates into nested
    pairs. Inverse of `CD3.toOctonion`. -/
def CD3.ofOctonion (o : Octonion) : CD3 :=
  ⟨⟨⟨o.c0, o.c1⟩, ⟨o.c2, o.c3⟩⟩, ⟨⟨o.c4, o.c5⟩, ⟨o.c6, o.c7⟩⟩⟩

/-! ## Part 2: Roundtrip proofs -/

theorem CD3.toOctonion_ofOctonion (o : Octonion) :
    CD3.toOctonion (CD3.ofOctonion o) = o := by
  simp [CD3.toOctonion, CD3.ofOctonion]

theorem CD3.ofOctonion_toOctonion (x : CD3) :
    CD3.ofOctonion (CD3.toOctonion x) = x := by
  simp [CD3.toOctonion, CD3.ofOctonion]

/-! ## Part 3: Basis elements -/

/-- The 8 standard basis elements of `CD3`, indexed by `Fin 8`.
    `cd3Basis i` has a `1` in coordinate position `i` and `0` elsewhere. -/
def cd3Basis : Fin 8 → CD3
  | ⟨0, _⟩ => ⟨⟨⟨1,0⟩,⟨0,0⟩⟩, ⟨⟨0,0⟩,⟨0,0⟩⟩⟩
  | ⟨1, _⟩ => ⟨⟨⟨0,1⟩,⟨0,0⟩⟩, ⟨⟨0,0⟩,⟨0,0⟩⟩⟩
  | ⟨2, _⟩ => ⟨⟨⟨0,0⟩,⟨1,0⟩⟩, ⟨⟨0,0⟩,⟨0,0⟩⟩⟩
  | ⟨3, _⟩ => ⟨⟨⟨0,0⟩,⟨0,1⟩⟩, ⟨⟨0,0⟩,⟨0,0⟩⟩⟩
  | ⟨4, _⟩ => ⟨⟨⟨0,0⟩,⟨0,0⟩⟩, ⟨⟨1,0⟩,⟨0,0⟩⟩⟩
  | ⟨5, _⟩ => ⟨⟨⟨0,0⟩,⟨0,0⟩⟩, ⟨⟨0,1⟩,⟨0,0⟩⟩⟩
  | ⟨6, _⟩ => ⟨⟨⟨0,0⟩,⟨0,0⟩⟩, ⟨⟨0,0⟩,⟨1,0⟩⟩⟩
  | ⟨7, _⟩ => ⟨⟨⟨0,0⟩,⟨0,0⟩⟩, ⟨⟨0,0⟩,⟨0,1⟩⟩⟩

/-- The naive coordinate map sends each CD3 basis element to the
    corresponding Octonion basis element. -/
theorem cd3Basis_toOctonion (i : Fin 8) :
    CD3.toOctonion (cd3Basis i) = basisElem i := by
  fin_cases i <;> simp [cd3Basis, CD3.toOctonion, basisElem]

/-! ## Part 4: CD3 multiplication sign table

The Cayley–Dickson construction produces its own sign table for imaginary
basis products. We define it explicitly and prove it matches the CD3
multiplication. The table is computed from the Baez convention
  `(a, b) * (c, d) = (a·c − conj(d)·b, d·a + b·conj(c))`.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), §2.2. -/

/-- The sign of the product `cd3Basis i * cd3Basis j` in the CD3 algebra.
    The product lands on `cd3Basis (i XOR j)` with this sign.
    For `i = 0` or `j = 0`, the sign is `+1` (unit element).
    For `i = j ≠ 0`, the sign is `-1` (imaginary units square to `-1`). -/
def cd3Sign (i j : Fin 8) : ℤ :=
  match i.val, j.val with
  | 0, _ =>  1
  | _, 0 =>  1
  | 1, 1 => -1 | 1, 2 =>  1 | 1, 3 => -1
  | 1, 4 =>  1 | 1, 5 => -1 | 1, 6 => -1 | 1, 7 =>  1
  | 2, 1 => -1 | 2, 2 => -1 | 2, 3 =>  1
  | 2, 4 =>  1 | 2, 5 =>  1 | 2, 6 => -1 | 2, 7 => -1
  | 3, 1 =>  1 | 3, 2 => -1 | 3, 3 => -1
  | 3, 4 =>  1 | 3, 5 => -1 | 3, 6 =>  1 | 3, 7 => -1
  | 4, 1 => -1 | 4, 2 => -1 | 4, 3 => -1
  | 4, 4 => -1 | 4, 5 =>  1 | 4, 6 =>  1 | 4, 7 =>  1
  | 5, 1 =>  1 | 5, 2 => -1 | 5, 3 =>  1
  | 5, 4 => -1 | 5, 5 => -1 | 5, 6 => -1 | 5, 7 =>  1
  | 6, 1 =>  1 | 6, 2 =>  1 | 6, 3 => -1
  | 6, 4 => -1 | 6, 5 =>  1 | 6, 6 => -1 | 6, 7 => -1
  | 7, 1 => -1 | 7, 2 =>  1 | 7, 3 =>  1
  | 7, 4 => -1 | 7, 5 => -1 | 7, 6 =>  1 | 7, 7 => -1
  | _, _ =>  0

/-! ## Part 5: Sign comparison

The difference between the CD3 signs and the XOR-Fano signs is captured
by a sign-correction vector `ε = (+1, +1, +1, +1, +1, −1, +1, −1)` on the
basis elements. The corrected map negates coordinates c₅ and c₇. -/

/-- The sign-correction vector: `signCorrection i = -1` for `i ∈ {5, 7}` and
    `+1` otherwise. Negating these basis elements converts the CD3 convention
    to the project XOR-Fano convention. -/
def signCorrection (i : Fin 8) : ℤ :=
  match i.val with
  | 5 => -1
  | 7 => -1
  | _ =>  1

/-- Helper: XOR of two `Fin 8` values stays in `Fin 8`. -/
private theorem xor_fin8_lt (i j : Fin 8) : i.val ^^^ j.val < 8 :=
  Nat.lt_of_lt_of_le
    (Nat.xor_lt_two_pow (n := 3) (by omega) (by omega))
    (by norm_num)

/-- The sign-correction intertwines the two sign tables:
    `lookupSign i j = signCorrection i * signCorrection j *
                      cd3Sign i j * signCorrection (i ^^^ j)`. -/
theorem sign_comparison (i j : Fin 8) :
    (lookupSign i j : ℤ) =
      signCorrection i * signCorrection j * cd3Sign i j *
      signCorrection ⟨i.val ^^^ j.val, xor_fin8_lt i j⟩ := by
  fin_cases i <;> fin_cases j <;> simp [lookupSign, cd3Sign, signCorrection]

/-! ## Part 6: Sign-corrected coordinate maps -/

/-- The sign-corrected map from `CD3` to `Octonion`. Negates coordinates
    c₅ and c₇ so that multiplication is preserved.

    Explicitly:
    `φ(x) = (c₀, c₁, c₂, c₃, c₄, −c₅, c₆, −c₇)`.

    Source: sign correction derived from comparing the Baez Cayley–Dickson
    table with the project XOR-Fano table. -/
def CD3.toOctonionIso (x : CD3) : Octonion where
  c0 := x.fst.fst.fst
  c1 := x.fst.fst.snd
  c2 := x.fst.snd.fst
  c3 := x.fst.snd.snd
  c4 := x.snd.fst.fst
  c5 := -x.snd.fst.snd
  c6 := x.snd.snd.fst
  c7 := -x.snd.snd.snd

/-- The inverse of the sign-corrected map. -/
def CD3.ofOctonionIso (o : Octonion) : CD3 :=
  ⟨⟨⟨o.c0, o.c1⟩, ⟨o.c2, o.c3⟩⟩, ⟨⟨o.c4, -o.c5⟩, ⟨o.c6, -o.c7⟩⟩⟩

theorem CD3.toOctonionIso_ofOctonionIso (o : Octonion) :
    CD3.toOctonionIso (CD3.ofOctonionIso o) = o := by
  simp [CD3.toOctonionIso, CD3.ofOctonionIso]

theorem CD3.ofOctonionIso_toOctonionIso (x : CD3) :
    CD3.ofOctonionIso (CD3.toOctonionIso x) = x := by
  simp [CD3.toOctonionIso, CD3.ofOctonionIso]

/-! ## Part 7: Multiplication preservation

The sign-corrected map is an algebra isomorphism: it preserves multiplication.
This is the key result that connects the abstract Cayley–Dickson construction
to the project's concrete XOR-basis octonion arithmetic. -/

set_option maxHeartbeats 3200000 in
-- 8 coordinate identities, each a degree-2 polynomial in 16 variables,
-- after unfolding 3 levels of Cayley–Dickson nesting.
theorem CD3.toOctonionIso_mul (x y : CD3) :
    CD3.toOctonionIso (x * y) =
      CD3.toOctonionIso x * CD3.toOctonionIso y := by
  ext <;> simp [CD3.toOctonionIso, star_trivial] <;> ring

/-! ## Part 8: Basis multiplication comparison (explicit)

These theorems verify representative Fano-triple products in the two
conventions, making the sign mismatch machine-auditable. -/

set_option maxHeartbeats 800000 in
-- Cayley–Dickson basis product: e₁ · e₂ = +e₃ (matches XOR convention)
theorem cd3_e1_mul_e2 :
    cd3Basis 1 * cd3Basis 2 = cd3Basis 3 := by
  unfold cd3Basis; ext <;> simp [star_trivial]

set_option maxHeartbeats 800000 in
-- Cayley–Dickson basis product: e₁ · e₄ = +e₅ (XOR convention gives −e₅)
theorem cd3_e1_mul_e4 :
    cd3Basis 1 * cd3Basis 4 = cd3Basis 5 := by
  unfold cd3Basis; ext <;> simp [star_trivial]

set_option maxHeartbeats 800000 in
-- Cayley–Dickson basis product: e₂ · e₄ = +e₆ (matches XOR convention)
theorem cd3_e2_mul_e4 :
    cd3Basis 2 * cd3Basis 4 = cd3Basis 6 := by
  unfold cd3Basis; ext <;> simp [star_trivial]

set_option maxHeartbeats 800000 in
-- Cayley–Dickson basis product: e₃ · e₇ = −e₄ (XOR convention gives +e₄)
theorem cd3_e3_mul_e7 :
    cd3Basis 3 * cd3Basis 7 = -cd3Basis 4 := by
  unfold cd3Basis; ext <;> simp [star_trivial]

/-! ## Part 9: Additive structure preservation -/

theorem CD3.toOctonionIso_add (x y : CD3) :
    CD3.toOctonionIso (x + y) =
      CD3.toOctonionIso x + CD3.toOctonionIso y := by
  ext <;> simp [CD3.toOctonionIso] <;> ring

theorem CD3.toOctonionIso_zero :
    CD3.toOctonionIso 0 = 0 := by
  ext <;> simp [CD3.toOctonionIso]

theorem CD3.toOctonionIso_neg (x : CD3) :
    CD3.toOctonionIso (-x) = -CD3.toOctonionIso x := by
  ext <;> simp [CD3.toOctonionIso]

theorem CD3.toOctonionIso_one :
    CD3.toOctonionIso 1 = 1 := by
  ext <;> simp [CD3.toOctonionIso]

end PhysicsSM.Algebra.Division.CayleyDicksonOctonionBridge
