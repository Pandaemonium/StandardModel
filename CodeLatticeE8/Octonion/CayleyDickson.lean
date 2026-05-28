import Mathlib.Tactic

/-!
# Cayley-Dickson octonion convention

This module fixes the octonion convention used by `CodeLatticeE8`.

The basis is indexed by `Fin 8`, identified with three-bit labels.  The product
of basis indices is bitwise XOR:

```text
e_i * e_j = (plus or minus) e_(i xor j).
```

The sign is the recursive Cayley-Dickson sign determined by the ordered basis

```text
000 = 1, 001 = i, 010 = j, 011 = ij,
100 = ell, 101 = i ell, 110 = j ell, 111 = ij ell.
```

Equivalently, the seven positive Fano triples are

```text
(001,010,011), (001,100,101), (001,111,110),
(010,100,110), (010,101,111),
(011,100,111), (011,110,101).
```

The convention is stated here as part of the standalone package.  Downstream
modules use this sign table to define the finite coordinate multiplication
needed for the octavian/E8 short-shell bridge.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Octonion

/-! ## Basis-index data -/

/-- The seven positive Fano triples for the package Cayley-Dickson convention. -/
def fanoTriples : List (Fin 8 × Fin 8 × Fin 8) :=
  [(1, 2, 3), (1, 4, 5), (1, 7, 6),
   (2, 4, 6), (2, 5, 7),
   (3, 4, 7), (3, 6, 5)]

/-- Bitwise XOR of the two three-bit basis labels. -/
def xorIndex (i j : Fin 8) : Fin 8 :=
  Fin.ofNat 8 (Nat.xor i.val j.val)

/-- Cayley-Dickson sign of the basis product `e_i * e_j`.

The product itself lands on `e_(xorIndex i j)`.  The sign table is written
explicitly so that later proofs reduce to small kernel-checked finite
computations rather than depending on an external oracle script. -/
def sign (i j : Fin 8) : ℤ :=
  match i.val, j.val with
  | 0, _ => 1
  | _, 0 => 1
  | 1, 1 => -1 | 1, 2 => 1  | 1, 3 => -1 | 1, 4 => 1
  | 1, 5 => -1 | 1, 6 => -1 | 1, 7 => 1
  | 2, 1 => -1 | 2, 2 => -1 | 2, 3 => 1  | 2, 4 => 1
  | 2, 5 => 1  | 2, 6 => -1 | 2, 7 => -1
  | 3, 1 => 1  | 3, 2 => -1 | 3, 3 => -1 | 3, 4 => 1
  | 3, 5 => -1 | 3, 6 => 1  | 3, 7 => -1
  | 4, 1 => -1 | 4, 2 => -1 | 4, 3 => -1 | 4, 4 => -1
  | 4, 5 => 1  | 4, 6 => 1  | 4, 7 => 1
  | 5, 1 => 1  | 5, 2 => -1 | 5, 3 => 1  | 5, 4 => -1
  | 5, 5 => -1 | 5, 6 => -1 | 5, 7 => 1
  | 6, 1 => 1  | 6, 2 => 1  | 6, 3 => -1 | 6, 4 => -1
  | 6, 5 => 1  | 6, 6 => -1 | 6, 7 => -1
  | 7, 1 => -1 | 7, 2 => 1  | 7, 3 => 1  | 7, 4 => -1
  | 7, 5 => -1 | 7, 6 => 1  | 7, 7 => -1
  | _, _ => 1

/-- The sign table only contains `+1` and `-1`. -/
theorem sign_eq_one_or_neg_one (i j : Fin 8) :
    sign i j = 1 ∨ sign i j = -1 := by
  fin_cases i <;> fin_cases j <;> simp [sign]

/-- The scalar basis element is a two-sided positive unit at the sign level. -/
@[simp]
theorem sign_zero_left (i : Fin 8) : sign 0 i = 1 := by
  fin_cases i <;> rfl

/-- The scalar basis element is a two-sided positive unit at the sign level. -/
@[simp]
theorem sign_zero_right (i : Fin 8) : sign i 0 = 1 := by
  fin_cases i <;> rfl

/-- A non-scalar basis unit squares with sign `-1`. -/
theorem sign_self_of_ne_zero {i : Fin 8} (hi : i ≠ 0) : sign i i = -1 := by
  fin_cases i <;> simp [sign] at hi ⊢

/-- The package Fano triples are positive basis products. -/
theorem fanoTriples_positive :
    fanoTriples.Forall (fun t => sign t.1 t.2.1 = 1 ∧ xorIndex t.1 t.2.1 = t.2.2) := by
  decide

end CodeLatticeE8.Octonion
