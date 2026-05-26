import Mathlib

/-!
# Construction A: Binary codes to integer additive subgroups

This module defines the Construction A map from binary linear codes to integer
additive subgroups. Given a binary linear code `C ⊆ F₂ⁿ`, Construction A
produces the subgroup

  `Λ(C) = { z ∈ ℤⁿ : z mod 2 ∈ C }`

This is an additive subgroup of `Z^n` that always contains `2Z^n`. The usual
geometric lattice interpretation, rank/full-span statements, scaling by
`1 / sqrt 2`, evenness, and unimodularity are downstream structural theorems.
Do not treat the raw `AddSubgroup` returned here as an already-proved geometric
lattice unless those extra properties have been established in the importing
module.

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Chapter 7.
- Mizoguchi-Oikawa, arXiv:2602.16269.
- Error Correction Zoo, E8 entry: <https://errorcorrectionzoo.org/c/eeight>.
- Aristotle job for PhysicsSM, 2026-05-06.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding

/-! ## Binary vector and code foundations -/

/-- A binary vector of length `n` is a function from `Fin n` to `ZMod 2`. -/
abbrev BinaryVector (n : ℕ) := Fin n → ZMod 2

/-- A binary linear code of length `n` is a `ZMod 2`-submodule of `(ZMod 2)ⁿ`. -/
abbrev BinaryLinearCode (n : ℕ) := Submodule (ZMod 2) (BinaryVector n)

/-- The Hamming weight of a binary vector: the number of nonzero coordinates. -/
def hammingWeight {n : ℕ} (v : BinaryVector n) : ℕ :=
  Finset.card (Finset.univ.filter (fun i => v i ≠ 0))

/-- A code is *doubly even* if every codeword has weight divisible by 4. -/
def IsDoublyEven {n : ℕ} (C : BinaryLinearCode n) : Prop :=
  ∀ v ∈ C, 4 ∣ hammingWeight v

/-! ## Binary dot product -/

/-- The binary dot product (inner product over `ZMod 2`): the sum of
coordinate-wise products. Two binary vectors are orthogonal when
`binaryDot v w = 0`. -/
def binaryDot {n : ℕ} (v w : BinaryVector n) : ZMod 2 :=
  ∑ i, v i * w i

@[simp]
theorem binaryDot_zero_left {n : ℕ} (w : BinaryVector n) :
    binaryDot 0 w = 0 := by
  simp [binaryDot]

@[simp]
theorem binaryDot_zero_right {n : ℕ} (v : BinaryVector n) :
    binaryDot v 0 = 0 := by
  simp [binaryDot]

theorem binaryDot_add_left {n : ℕ} (u v w : BinaryVector n) :
    binaryDot (u + v) w = binaryDot u w + binaryDot v w := by
  simp [binaryDot, add_mul, Finset.sum_add_distrib]

theorem binaryDot_comm {n : ℕ} (v w : BinaryVector n) :
    binaryDot v w = binaryDot w v := by
  simp [binaryDot, mul_comm]

theorem binaryDot_smul_left {n : ℕ} (c : ZMod 2) (v w : BinaryVector n) :
    binaryDot (c • v) w = c * binaryDot v w := by
  simp [binaryDot, Pi.smul_apply, smul_eq_mul, mul_assoc, Finset.mul_sum]

/-! ## Reduction mod 2 -/

/-- Reduce an integer vector mod 2 to get a binary vector. -/
def reduceModTwo {n : ℕ} (z : Fin n → ℤ) : BinaryVector n :=
  fun i => (z i : ZMod 2)

@[simp]
theorem reduceModTwo_apply {n : ℕ} (z : Fin n → ℤ) (i : Fin n) :
    reduceModTwo z i = (z i : ZMod 2) := rfl

@[simp]
theorem reduceModTwo_zero {n : ℕ} : reduceModTwo (0 : Fin n → ℤ) = 0 := by
  ext i; simp [reduceModTwo]

@[simp]
theorem reduceModTwo_add {n : ℕ} (a b : Fin n → ℤ) :
    reduceModTwo (a + b) = reduceModTwo a + reduceModTwo b := by
  ext i; simp [reduceModTwo, Pi.add_apply, Int.cast_add]

@[simp]
theorem reduceModTwo_neg {n : ℕ} (a : Fin n → ℤ) :
    reduceModTwo (-a) = -reduceModTwo a := by
  ext i; simp [reduceModTwo, Pi.neg_apply, Int.cast_neg]

/-! ## Construction A -/

/-- The Construction A set: integer vectors whose mod-2 reduction lies in
the code `C`. -/
def constructionASet {n : ℕ} (C : BinaryLinearCode n) : Set (Fin n → ℤ) :=
  { z | reduceModTwo z ∈ C }

/-- Construction A produces an additive subgroup of `ℤⁿ`. -/
def constructionA {n : ℕ} (C : BinaryLinearCode n) : AddSubgroup (Fin n → ℤ) where
  carrier := constructionASet C
  zero_mem' := by simp only [constructionASet, Set.mem_setOf_eq, reduceModTwo_zero]; exact C.zero_mem
  add_mem' := by
    intro a b ha hb
    simp only [constructionASet, Set.mem_setOf_eq] at *
    rw [reduceModTwo_add]; exact C.add_mem ha hb
  neg_mem' := by
    intro a ha
    simp only [constructionASet, Set.mem_setOf_eq] at *
    rw [reduceModTwo_neg]; exact C.neg_mem ha

/-- Membership in the Construction A lattice is determined by mod-2
reduction. -/
@[simp]
theorem mem_constructionA_iff {n : ℕ} (C : BinaryLinearCode n)
    (z : Fin n → ℤ) :
    z ∈ constructionA C ↔ reduceModTwo z ∈ C := Iff.rfl

/-- Every vector in `2ℤⁿ` belongs to any Construction A lattice,
since even integers reduce to 0 mod 2. -/
theorem even_vector_mem_constructionA {n : ℕ} (C : BinaryLinearCode n)
    (z : Fin n → ℤ) (hz : ∀ i, 2 ∣ z i) :
    z ∈ constructionA C := by
  rw [mem_constructionA_iff]
  have : reduceModTwo z = 0 := by
    ext i
    simp only [reduceModTwo_apply, Pi.zero_apply]
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd (z i) 2).mpr (hz i)
  rw [this]; exact C.zero_mem

/-! ## Squared norm -/

/-- The squared norm (sum of squares of coordinates) of an integer vector. -/
def sqNorm {n : ℕ} (z : Fin n → ℤ) : ℤ :=
  ∑ i, z i ^ 2

/-- The squared norm is nonnegative. -/
theorem sqNorm_nonneg {n : ℕ} (z : Fin n → ℤ) : 0 ≤ sqNorm z :=
  Finset.sum_nonneg (fun _ _ => sq_nonneg _)

/-- The squared norm is zero iff the vector is zero. -/
theorem sqNorm_eq_zero_iff {n : ℕ} (z : Fin n → ℤ) :
    sqNorm z = 0 ↔ z = 0 := by
  constructor
  · intro h
    ext i
    have h1 := (Finset.sum_eq_zero_iff_of_nonneg
      (fun j _ => sq_nonneg (z j))).mp h i (Finset.mem_univ _)
    exact pow_eq_zero_iff (by omega : 2 ≠ 0) |>.mp h1
  · intro h; subst h; simp [sqNorm]

/-! ## Minimum norm lower bound from code weight -/

/-
If an integer is odd (nonzero mod 2), then its square is at least 1.
-/
theorem sq_ge_one_of_odd (a : ℤ) (h : (a : ZMod 2) ≠ 0) : 1 ≤ a ^ 2 := by
  contrapose! h;
  norm_num [ show a = 0 by nlinarith ]

/-
If an integer is even and nonzero, its square is at least 4.
-/
theorem sq_ge_four_of_even_ne_zero (a : ℤ) (ha : (a : ZMod 2) = 0)
    (hne : a ≠ 0) : 4 ≤ a ^ 2 := by
  erw [ ZMod.intCast_zmod_eq_zero_iff_dvd ] at ha;
  rcases ha with ⟨ k, rfl ⟩ ; norm_num at * ; nlinarith [ mul_self_pos.2 hne ]

/-
The squared norm of an integer vector is at least the Hamming weight
of its mod-2 reduction. Each odd coordinate contributes `≥ 1`.
-/
theorem sqNorm_ge_weight {n : ℕ} (z : Fin n → ℤ) :
    (hammingWeight (reduceModTwo z) : ℤ) ≤ sqNorm z := by
  unfold hammingWeight sqNorm reduceModTwo
  refine le_trans ?_ (Finset.sum_le_sum fun i _ =>
    show z i ^ 2 ≥ if (z i : ZMod 2) = 0 then 0 else 1 from ?_)
  · simp +decide [Finset.sum_ite]
  · split_ifs <;> [norm_num; exact sq_ge_one_of_odd _ (by aesop)]
    positivity

/-
If an integer vector has all even coordinates and is nonzero, its squared
norm is at least 4.
-/
theorem sqNorm_ge_four_of_all_even {n : ℕ} (z : Fin n → ℤ)
    (heven : reduceModTwo z = 0) (hne : z ≠ 0) :
    4 ≤ sqNorm z := by
  obtain ⟨ i, hi ⟩ := Function.ne_iff.mp hne;
  exact le_trans ( sq_ge_four_of_even_ne_zero _ ( by simpa using congr_fun heven i ) hi ) ( Finset.single_le_sum ( fun a _ => sq_nonneg ( z a ) ) ( Finset.mem_univ i ) )

/-
**Main minimum-norm bound**: If a binary code has minimum weight `≥ 4`,
then every nonzero vector in the Construction A lattice has squared norm
`≥ 4`.

This follows because:
- If the mod-2 reduction is zero, all coordinates are even, and any nonzero
  even integer has square `≥ 4`.
- If the mod-2 reduction is a nonzero codeword of weight `≥ 4`, there are at
  least 4 odd coordinates each contributing `≥ 1` to the squared norm.
-/
theorem constructionA_sqNorm_ge_four {n : ℕ} (C : BinaryLinearCode n)
    (hmin : ∀ v ∈ C, v ≠ 0 → 4 ≤ hammingWeight v)
    (z : Fin n → ℤ) (hz : z ∈ constructionA C) (hne : z ≠ 0) :
    4 ≤ sqNorm z := by
  by_cases h : reduceModTwo z = 0
  · exact sqNorm_ge_four_of_all_even z h hne
  · exact le_trans (mod_cast hmin _ ((mem_constructionA_iff C z).mp hz) h) (sqNorm_ge_weight _)

end PhysicsSM.Coding
