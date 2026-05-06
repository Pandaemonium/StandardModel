import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Data.Fintype.Fin

/-!
# Algebra.Octonion.Basic

Octonion type, basis labeling, and multiplication convention for this project.

## Basis labeling (XOR convention)

The project uses 3-bit binary labels for the eight basis elements:

| Label   | Role           | Decimal |
|---------|----------------|---------|
| `e000`  | unit element 1 | 0       |
| `e001`  | imaginary unit | 1       |
| `e010`  | imaginary unit | 2       |
| `e011`  | imaginary unit | 3       |
| `e100`  | imaginary unit | 4       |
| `e101`  | imaginary unit | 5       |
| `e110`  | imaginary unit | 6       |
| `e111`  | imaginary unit | 7       |

## Multiplication rule

For two imaginary basis elements `eₐ * e_b`:
- The **index** of the product is `a XOR b` (bitwise).
- The **sign** is determined by the Fano plane orientation below.
- `e000` is the unit: `e000 * eₐ = eₐ * e000 = eₐ`.
- Each imaginary unit squares to `-1`: `eₐ * eₐ = -e000` for `a ≠ 0`.

## Fano plane orientation — positive triples

The seven positive cyclic triples `(eₐ, e_b, e_c)` satisfy `eₐ * e_b = e_c`:

```
e001 * e010 = e011      (anchors the e111-free face)
e001 * e101 = e100
e001 * e110 = e111
e010 * e100 = e110
e010 * e101 = e111
e011 * e101 = e110
e011 * e111 = e100      ← user-specified anchor
```

Each triple `(eₐ, e_b, e_c)` with `eₐ * e_b = e_c` also gives:
- `e_b * e_c = eₐ`  (cyclic)
- `e_c * eₐ = e_b`  (cyclic)
- `e_b * eₐ = -e_c` (reversed)
- etc.

This orientation has been machine-validated: Fano incidence and all 512
Moufang checks pass. See `Scripts/oracle/validate_octonion.py`.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## Fano triples -/

/-- The seven lines of the Fano plane as positive cyclic triples,
    in the project XOR basis. Each entry `(a, b, c)` records `eₐ * e_b = e_c`,
    with indices given as natural numbers matching the 3-bit XOR labels. -/
def fanoTriples : List (Fin 8 × Fin 8 × Fin 8) :=
  [ (⟨1, by omega⟩, ⟨2, by omega⟩, ⟨3, by omega⟩)
  , (⟨1, by omega⟩, ⟨5, by omega⟩, ⟨4, by omega⟩)
  , (⟨1, by omega⟩, ⟨6, by omega⟩, ⟨7, by omega⟩)
  , (⟨2, by omega⟩, ⟨4, by omega⟩, ⟨6, by omega⟩)
  , (⟨2, by omega⟩, ⟨5, by omega⟩, ⟨7, by omega⟩)
  , (⟨3, by omega⟩, ⟨5, by omega⟩, ⟨6, by omega⟩)
  , (⟨3, by omega⟩, ⟨7, by omega⟩, ⟨4, by omega⟩)
  ]

/-! ## Sign lookup table -/

/-- Sign of the basis product `eᵢ * eⱼ`. The product lands on `e_{i ⊕ j}`. -/
def lookupSign (i j : Fin 8) : ℤ :=
  match i.val, j.val with
  | 0, _ =>  1
  | _, 0 =>  1
  | 1, 1 => -1 | 1, 2 =>  1 | 1, 3 => -1
  | 1, 4 => -1 | 1, 5 =>  1 | 1, 6 =>  1 | 1, 7 => -1
  | 2, 1 => -1 | 2, 2 => -1 | 2, 3 =>  1
  | 2, 4 =>  1 | 2, 5 =>  1 | 2, 6 => -1 | 2, 7 => -1
  | 3, 1 =>  1 | 3, 2 => -1 | 3, 3 => -1
  | 3, 4 => -1 | 3, 5 =>  1 | 3, 6 => -1 | 3, 7 =>  1
  | 4, 1 =>  1 | 4, 2 => -1 | 4, 3 =>  1
  | 4, 4 => -1 | 4, 5 => -1 | 4, 6 =>  1 | 4, 7 => -1
  | 5, 1 => -1 | 5, 2 => -1 | 5, 3 => -1
  | 5, 4 =>  1 | 5, 5 => -1 | 5, 6 =>  1 | 5, 7 =>  1
  | 6, 1 => -1 | 6, 2 =>  1 | 6, 3 =>  1
  | 6, 4 => -1 | 6, 5 => -1 | 6, 6 => -1 | 6, 7 =>  1
  | 7, 1 =>  1 | 7, 2 =>  1 | 7, 3 => -1
  | 7, 4 =>  1 | 7, 5 => -1 | 7, 6 => -1 | 7, 7 => -1
  | _, _ =>  0

/-! ## Octonion type -/

/-- An octonion, represented by its 8 real coefficients in the XOR basis.
    `c0` is the real (scalar) part; `c1`–`c7` are imaginary. -/
@[ext]
structure Octonion where
  c0 : ℝ
  c1 : ℝ
  c2 : ℝ
  c3 : ℝ
  c4 : ℝ
  c5 : ℝ
  c6 : ℝ
  c7 : ℝ
  deriving Inhabited

/-! ### Algebraic operations -/

instance : Neg Octonion where
  neg a := ⟨-a.c0, -a.c1, -a.c2, -a.c3, -a.c4, -a.c5, -a.c6, -a.c7⟩

/-- Octonion multiplication following the XOR-basis Fano convention. -/
instance : Mul Octonion where
  mul a b :=
  { c0 := a.c0*b.c0 - a.c1*b.c1 - a.c2*b.c2 - a.c3*b.c3
         - a.c4*b.c4 - a.c5*b.c5 - a.c6*b.c6 - a.c7*b.c7
    c1 := a.c0*b.c1 + a.c1*b.c0 + a.c2*b.c3 - a.c3*b.c2
         - a.c4*b.c5 + a.c5*b.c4 + a.c6*b.c7 - a.c7*b.c6
    c2 := a.c0*b.c2 + a.c2*b.c0 - a.c1*b.c3 + a.c3*b.c1
         + a.c4*b.c6 - a.c6*b.c4 + a.c5*b.c7 - a.c7*b.c5
    c3 := a.c0*b.c3 + a.c3*b.c0 + a.c1*b.c2 - a.c2*b.c1
         - a.c4*b.c7 + a.c7*b.c4 + a.c5*b.c6 - a.c6*b.c5
    c4 := a.c0*b.c4 + a.c4*b.c0 + a.c1*b.c5 - a.c5*b.c1
         - a.c2*b.c6 + a.c6*b.c2 + a.c3*b.c7 - a.c7*b.c3
    c5 := a.c0*b.c5 + a.c5*b.c0 - a.c1*b.c4 + a.c4*b.c1
         - a.c2*b.c7 + a.c7*b.c2 - a.c3*b.c6 + a.c6*b.c3
    c6 := a.c0*b.c6 + a.c6*b.c0 - a.c1*b.c7 + a.c7*b.c1
         + a.c2*b.c4 - a.c4*b.c2 + a.c3*b.c5 - a.c5*b.c3
    c7 := a.c0*b.c7 + a.c7*b.c0 + a.c1*b.c6 - a.c6*b.c1
         + a.c2*b.c5 - a.c5*b.c2 - a.c3*b.c4 + a.c4*b.c3 }

/-! ### Basis elements -/

/-- The basis element `eᵢ` as an octonion. -/
def basisElem (i : Fin 8) : Octonion :=
  { c0 := if i = 0 then 1 else 0
    c1 := if i = 1 then 1 else 0
    c2 := if i = 2 then 1 else 0
    c3 := if i = 3 then 1 else 0
    c4 := if i = 4 then 1 else 0
    c5 := if i = 5 then 1 else 0
    c6 := if i = 6 then 1 else 0
    c7 := if i = 7 then 1 else 0 }

/-- Product of two basis elements. -/
def basisMul (i j : Fin 8) : Octonion := basisElem i * basisElem j

/-! ### Component-wise simp lemmas -/

@[simp] theorem Octonion.neg_c0 (a : Octonion) : (-a).c0 = -a.c0 := rfl
@[simp] theorem Octonion.neg_c1 (a : Octonion) : (-a).c1 = -a.c1 := rfl
@[simp] theorem Octonion.neg_c2 (a : Octonion) : (-a).c2 = -a.c2 := rfl
@[simp] theorem Octonion.neg_c3 (a : Octonion) : (-a).c3 = -a.c3 := rfl
@[simp] theorem Octonion.neg_c4 (a : Octonion) : (-a).c4 = -a.c4 := rfl
@[simp] theorem Octonion.neg_c5 (a : Octonion) : (-a).c5 = -a.c5 := rfl
@[simp] theorem Octonion.neg_c6 (a : Octonion) : (-a).c6 = -a.c6 := rfl
@[simp] theorem Octonion.neg_c7 (a : Octonion) : (-a).c7 = -a.c7 := rfl

@[simp] theorem Octonion.mul_c0 (a b : Octonion) :
    (a * b).c0 = a.c0*b.c0 - a.c1*b.c1 - a.c2*b.c2 - a.c3*b.c3
    - a.c4*b.c4 - a.c5*b.c5 - a.c6*b.c6 - a.c7*b.c7 := rfl
@[simp] theorem Octonion.mul_c1 (a b : Octonion) :
    (a * b).c1 = a.c0*b.c1 + a.c1*b.c0 + a.c2*b.c3 - a.c3*b.c2
    - a.c4*b.c5 + a.c5*b.c4 + a.c6*b.c7 - a.c7*b.c6 := rfl
@[simp] theorem Octonion.mul_c2 (a b : Octonion) :
    (a * b).c2 = a.c0*b.c2 + a.c2*b.c0 - a.c1*b.c3 + a.c3*b.c1
    + a.c4*b.c6 - a.c6*b.c4 + a.c5*b.c7 - a.c7*b.c5 := rfl
@[simp] theorem Octonion.mul_c3 (a b : Octonion) :
    (a * b).c3 = a.c0*b.c3 + a.c3*b.c0 + a.c1*b.c2 - a.c2*b.c1
    - a.c4*b.c7 + a.c7*b.c4 + a.c5*b.c6 - a.c6*b.c5 := rfl
@[simp] theorem Octonion.mul_c4 (a b : Octonion) :
    (a * b).c4 = a.c0*b.c4 + a.c4*b.c0 + a.c1*b.c5 - a.c5*b.c1
    - a.c2*b.c6 + a.c6*b.c2 + a.c3*b.c7 - a.c7*b.c3 := rfl
@[simp] theorem Octonion.mul_c5 (a b : Octonion) :
    (a * b).c5 = a.c0*b.c5 + a.c5*b.c0 - a.c1*b.c4 + a.c4*b.c1
    - a.c2*b.c7 + a.c7*b.c2 - a.c3*b.c6 + a.c6*b.c3 := rfl
@[simp] theorem Octonion.mul_c6 (a b : Octonion) :
    (a * b).c6 = a.c0*b.c6 + a.c6*b.c0 - a.c1*b.c7 + a.c7*b.c1
    + a.c2*b.c4 - a.c4*b.c2 + a.c3*b.c5 - a.c5*b.c3 := rfl
@[simp] theorem Octonion.mul_c7 (a b : Octonion) :
    (a * b).c7 = a.c0*b.c7 + a.c7*b.c0 + a.c1*b.c6 - a.c6*b.c1
    + a.c2*b.c5 - a.c5*b.c2 - a.c3*b.c4 + a.c4*b.c3 := rfl

instance : Add Octonion where
  add a b := ⟨a.c0+b.c0, a.c1+b.c1, a.c2+b.c2, a.c3+b.c3,
               a.c4+b.c4, a.c5+b.c5, a.c6+b.c6, a.c7+b.c7⟩

instance : Zero Octonion where
  zero := ⟨0,0,0,0,0,0,0,0⟩

instance : Sub Octonion where
  sub a b := ⟨a.c0-b.c0, a.c1-b.c1, a.c2-b.c2, a.c3-b.c3,
               a.c4-b.c4, a.c5-b.c5, a.c6-b.c6, a.c7-b.c7⟩

instance : One Octonion where
  one := ⟨1,0,0,0,0,0,0,0⟩

instance : SMul ℝ Octonion where
  smul r a := ⟨r*a.c0, r*a.c1, r*a.c2, r*a.c3, r*a.c4, r*a.c5, r*a.c6, r*a.c7⟩

/-!
The component simp lemmas below are intentionally explicit and somewhat
mechanical.  Later Furey and convention-bridge proofs reduce non-associative
octonion identities to real coordinate arithmetic; naming every projection of
addition, subtraction, the unit, and scalar multiplication lets `simp` expose
those real goals without guessing through typeclass abstractions.
-/

@[simp] theorem Octonion.add_c0 (a b : Octonion) : (a + b).c0 = a.c0 + b.c0 := rfl
@[simp] theorem Octonion.add_c1 (a b : Octonion) : (a + b).c1 = a.c1 + b.c1 := rfl
@[simp] theorem Octonion.add_c2 (a b : Octonion) : (a + b).c2 = a.c2 + b.c2 := rfl
@[simp] theorem Octonion.add_c3 (a b : Octonion) : (a + b).c3 = a.c3 + b.c3 := rfl
@[simp] theorem Octonion.add_c4 (a b : Octonion) : (a + b).c4 = a.c4 + b.c4 := rfl
@[simp] theorem Octonion.add_c5 (a b : Octonion) : (a + b).c5 = a.c5 + b.c5 := rfl
@[simp] theorem Octonion.add_c6 (a b : Octonion) : (a + b).c6 = a.c6 + b.c6 := rfl
@[simp] theorem Octonion.add_c7 (a b : Octonion) : (a + b).c7 = a.c7 + b.c7 := rfl

@[simp] theorem Octonion.zero_c0 : (0 : Octonion).c0 = 0 := rfl
@[simp] theorem Octonion.zero_c1 : (0 : Octonion).c1 = 0 := rfl
@[simp] theorem Octonion.zero_c2 : (0 : Octonion).c2 = 0 := rfl
@[simp] theorem Octonion.zero_c3 : (0 : Octonion).c3 = 0 := rfl
@[simp] theorem Octonion.zero_c4 : (0 : Octonion).c4 = 0 := rfl
@[simp] theorem Octonion.zero_c5 : (0 : Octonion).c5 = 0 := rfl
@[simp] theorem Octonion.zero_c6 : (0 : Octonion).c6 = 0 := rfl
@[simp] theorem Octonion.zero_c7 : (0 : Octonion).c7 = 0 := rfl

@[simp] theorem Octonion.sub_c0 (a b : Octonion) : (a - b).c0 = a.c0 - b.c0 := rfl
@[simp] theorem Octonion.sub_c1 (a b : Octonion) : (a - b).c1 = a.c1 - b.c1 := rfl
@[simp] theorem Octonion.sub_c2 (a b : Octonion) : (a - b).c2 = a.c2 - b.c2 := rfl
@[simp] theorem Octonion.sub_c3 (a b : Octonion) : (a - b).c3 = a.c3 - b.c3 := rfl
@[simp] theorem Octonion.sub_c4 (a b : Octonion) : (a - b).c4 = a.c4 - b.c4 := rfl
@[simp] theorem Octonion.sub_c5 (a b : Octonion) : (a - b).c5 = a.c5 - b.c5 := rfl
@[simp] theorem Octonion.sub_c6 (a b : Octonion) : (a - b).c6 = a.c6 - b.c6 := rfl
@[simp] theorem Octonion.sub_c7 (a b : Octonion) : (a - b).c7 = a.c7 - b.c7 := rfl

@[simp] theorem Octonion.one_c0 : (1 : Octonion).c0 = 1 := rfl
@[simp] theorem Octonion.one_c1 : (1 : Octonion).c1 = 0 := rfl
@[simp] theorem Octonion.one_c2 : (1 : Octonion).c2 = 0 := rfl
@[simp] theorem Octonion.one_c3 : (1 : Octonion).c3 = 0 := rfl
@[simp] theorem Octonion.one_c4 : (1 : Octonion).c4 = 0 := rfl
@[simp] theorem Octonion.one_c5 : (1 : Octonion).c5 = 0 := rfl
@[simp] theorem Octonion.one_c6 : (1 : Octonion).c6 = 0 := rfl
@[simp] theorem Octonion.one_c7 : (1 : Octonion).c7 = 0 := rfl

@[simp] theorem Octonion.smul_c0 (r : ℝ) (a : Octonion) : (r • a).c0 = r * a.c0 := rfl
@[simp] theorem Octonion.smul_c1 (r : ℝ) (a : Octonion) : (r • a).c1 = r * a.c1 := rfl
@[simp] theorem Octonion.smul_c2 (r : ℝ) (a : Octonion) : (r • a).c2 = r * a.c2 := rfl
@[simp] theorem Octonion.smul_c3 (r : ℝ) (a : Octonion) : (r • a).c3 = r * a.c3 := rfl
@[simp] theorem Octonion.smul_c4 (r : ℝ) (a : Octonion) : (r • a).c4 = r * a.c4 := rfl
@[simp] theorem Octonion.smul_c5 (r : ℝ) (a : Octonion) : (r • a).c5 = r * a.c5 := rfl
@[simp] theorem Octonion.smul_c6 (r : ℝ) (a : Octonion) : (r • a).c6 = r * a.c6 := rfl
@[simp] theorem Octonion.smul_c7 (r : ℝ) (a : Octonion) : (r • a).c7 = r * a.c7 := rfl

/-! ### Alternativity -/

/-- Left alternativity: `a * (a * b) = (a * a) * b` for all octonions. -/
theorem left_alternative (a b : Octonion) :
    a * (a * b) = (a * a) * b := by
  ext <;> simp <;> ring

/-- Right alternativity: `(a * b) * b = a * (b * b)` for all octonions. -/
theorem right_alternative (a b : Octonion) :
    (a * b) * b = a * (b * b) := by
  ext <;> simp <;> ring

/-! ### Anticommutativity of imaginary basis elements -/

/-- Distinct nonzero basis elements anticommute:
    `eᵢ * eⱼ = -(eⱼ * eᵢ)` for `i ≠ 0`, `j ≠ 0`, `i ≠ j`. -/
theorem mul_anticomm_imag (i j : Fin 8)
    (hi : i ≠ 0) (hj : j ≠ 0) (hij : i ≠ j) :
    basisMul i j = -(basisMul j i) := by
  fin_cases i <;> fin_cases j <;>
    simp (config := { decide := true }) only
      [basisMul, basisElem,
       Octonion.neg_c0, Octonion.neg_c1, Octonion.neg_c2, Octonion.neg_c3,
       Octonion.neg_c4, Octonion.neg_c5, Octonion.neg_c6, Octonion.neg_c7,
       Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2, Octonion.mul_c3,
       Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6, Octonion.mul_c7,
       Octonion.ext_iff, ite_true, ite_false] <;>
    (try norm_num) <;> (first | omega | contradiction)

/-! ### Fano plane and Hamming-code skeleton -/

/--
Each positive Fano triple is closed under the project XOR labelling.

This is the finite combinatorial bridge between the octonion multiplication
table and the usual parity-check picture of the `[7,4,3]` Hamming code.  A line
of the Fano plane contains three nonzero binary labels whose bitwise XOR is
zero; with the chosen orientation this is recorded as `a XOR b = c`.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`, reviewed and
integrated as a finite `decide` proof against the project XOR convention.
-/
theorem fanoTriple_xor_closure :
    ∀ t ∈ fanoTriples, t.1.val ^^^ t.2.1.val = t.2.2.val := by
  decide

/--
The project Fano triples satisfy the bitwise parity equations used by the
`[7,4,3]` Hamming parity-check matrix.

For each Fano line `(a, b, c)`, every bit of `a` is the XOR of the
corresponding bits of `b` and `c`.  This theorem does not yet define a full
linear code in Lean; it records the exact finite parity skeleton that later
Construction A work can use as its starting point.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`.
-/
theorem fano_lines_are_hamming_parity_rows :
    ∀ t ∈ fanoTriples,
    (Nat.testBit t.1.val 0 : Bool) =
        xor (Nat.testBit t.2.1.val 0) (Nat.testBit t.2.2.val 0) ∧
    (Nat.testBit t.1.val 1 : Bool) =
        xor (Nat.testBit t.2.1.val 1) (Nat.testBit t.2.2.val 1) ∧
    (Nat.testBit t.1.val 2 : Bool) =
        xor (Nat.testBit t.2.1.val 2) (Nat.testBit t.2.2.val 2) := by
  decide

/--
The seven Fano triples cover every ordered pair of distinct nonzero labels.

This is the finite projective-plane incidence fact needed before treating the
Fano plane as the combinatorial support of the `[7,4,3]` Hamming code.  The
six disjuncts say that the ordered pair may occur in either order and in any
two of the three positions of the stored oriented triple.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`.
-/
theorem fano_covers_all_ordered_pairs :
    ∀ (a b : Fin 8), a ≠ 0 → b ≠ 0 → a ≠ b →
    ∃ t ∈ fanoTriples,
      (t.1 = a ∧ t.2.1 = b) ∨ (t.1 = b ∧ t.2.1 = a) ∨
      (t.2.1 = a ∧ t.2.2 = b) ∨ (t.2.1 = b ∧ t.2.2 = a) ∨
      (t.1 = a ∧ t.2.2 = b) ∨ (t.1 = b ∧ t.2.2 = a) := by
  decide

end PhysicsSM.Algebra.Octonion
