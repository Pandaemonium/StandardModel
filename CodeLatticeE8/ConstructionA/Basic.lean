import CodeLatticeE8.Code.Binary

/-!
# Construction A, integer model

This module defines the integer preimage used in Construction A.

Given a binary linear code `C <= (ZMod 2)^n`, Construction A is the additive
subgroup of `Z^n`

```text
{ z : Z^n | z mod 2 belongs to C }.
```

This is the raw integer model.  Later modules add norm estimates and, for the
extended Hamming code, the bridge to the E8 normalization.  In particular, this
file does not identify any lattice with E8 and does not introduce real scaling.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace CodeLatticeE8.ConstructionA

open CodeLatticeE8.Code

/-! ## Reduction modulo two -/

/-- Reduce an integer vector coordinatewise modulo two. -/
def reduceModTwo {n : ℕ} (z : Fin n → ℤ) : BinaryVector n :=
  fun i => (z i : ZMod 2)

@[simp]
theorem reduceModTwo_apply {n : ℕ} (z : Fin n → ℤ) (i : Fin n) :
    reduceModTwo z i = (z i : ZMod 2) := rfl

@[simp]
theorem reduceModTwo_zero {n : ℕ} :
    reduceModTwo (0 : Fin n → ℤ) = 0 := by
  ext i
  simp [reduceModTwo]

@[simp]
theorem reduceModTwo_add {n : ℕ} (a b : Fin n → ℤ) :
    reduceModTwo (a + b) = reduceModTwo a + reduceModTwo b := by
  ext i
  simp [reduceModTwo, Pi.add_apply, Int.cast_add]

@[simp]
theorem reduceModTwo_neg {n : ℕ} (a : Fin n → ℤ) :
    reduceModTwo (-a) = -reduceModTwo a := by
  ext i
  simp [reduceModTwo, Pi.neg_apply, Int.cast_neg]

/-! ## Construction A subgroup -/

/-- The underlying set of the Construction A integer model. -/
def set {n : ℕ} (C : BinaryLinearCode n) : Set (Fin n → ℤ) :=
  { z | reduceModTwo z ∈ C }

/-- Construction A as an additive subgroup of `Z^n`. -/
def lattice {n : ℕ} (C : BinaryLinearCode n) : AddSubgroup (Fin n → ℤ) where
  carrier := set C
  zero_mem' := by
    simp only [set, Set.mem_setOf_eq, reduceModTwo_zero]
    exact C.zero_mem
  add_mem' := by
    intro a b ha hb
    simp only [set, Set.mem_setOf_eq] at *
    rw [reduceModTwo_add]
    exact C.add_mem ha hb
  neg_mem' := by
    intro a ha
    simp only [set, Set.mem_setOf_eq] at *
    rw [reduceModTwo_neg]
    exact C.neg_mem ha

/-- Membership in Construction A is exactly membership after reduction mod two. -/
@[simp]
theorem mem_lattice_iff {n : ℕ} (C : BinaryLinearCode n) (z : Fin n → ℤ) :
    z ∈ lattice C ↔ reduceModTwo z ∈ C := Iff.rfl

/-- Every coordinatewise-even integer vector belongs to any Construction A lattice. -/
theorem even_vector_mem {n : ℕ} (C : BinaryLinearCode n)
    (z : Fin n → ℤ) (hz : ∀ i, 2 ∣ z i) :
    z ∈ lattice C := by
  rw [mem_lattice_iff]
  have hzero : reduceModTwo z = 0 := by
    ext i
    simp only [reduceModTwo_apply, Pi.zero_apply]
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd (z i) 2).mpr (hz i)
  rw [hzero]
  exact C.zero_mem

end CodeLatticeE8.ConstructionA
