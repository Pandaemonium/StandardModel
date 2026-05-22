import CodeLatticeE8.ConstructionA.Basic

/-!
# Norm estimates for Construction A

This module proves the basic integer norm estimates used by the Hamming-to-E8
development.  The squared norm is the unscaled integer sum of coordinate
squares.  For the extended Hamming code, the E8 root normalization is obtained
later by the conventional scale factor `1 / sqrt 2`.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.ConstructionA

open CodeLatticeE8.Code

/-! ## Squared norm -/

/-- The unscaled squared norm on integer vectors. -/
def sqNorm {n : ℕ} (z : Fin n → ℤ) : ℤ :=
  ∑ i, z i ^ 2

/-- The squared norm is nonnegative. -/
theorem sqNorm_nonneg {n : ℕ} (z : Fin n → ℤ) : 0 ≤ sqNorm z :=
  Finset.sum_nonneg (fun _ _ => sq_nonneg _)

/-- The squared norm is zero exactly at the zero vector. -/
theorem sqNorm_eq_zero_iff {n : ℕ} (z : Fin n → ℤ) :
    sqNorm z = 0 ↔ z = 0 := by
  constructor
  · intro h
    ext i
    have hcoord := (Finset.sum_eq_zero_iff_of_nonneg
      (fun j _ => sq_nonneg (z j))).mp h i (Finset.mem_univ _)
    exact pow_eq_zero_iff (by omega : 2 ≠ 0) |>.mp hcoord
  · intro h
    subst h
    simp [sqNorm]

/-! ## Coordinate estimates -/

/-- An odd integer has square at least one. -/
theorem sq_ge_one_of_odd (a : ℤ) (h : (a : ZMod 2) ≠ 0) : 1 ≤ a ^ 2 := by
  contrapose! h
  norm_num [show a = 0 by nlinarith]

/-- A nonzero even integer has square at least four. -/
theorem sq_ge_four_of_even_ne_zero (a : ℤ) (ha : (a : ZMod 2) = 0)
    (hne : a ≠ 0) : 4 ≤ a ^ 2 := by
  erw [ZMod.intCast_zmod_eq_zero_iff_dvd] at ha
  rcases ha with ⟨k, rfl⟩
  norm_num at *
  nlinarith [mul_self_pos.2 hne]

/-- The squared norm bounds below the Hamming weight of the mod-two reduction. -/
theorem sqNorm_ge_weight {n : ℕ} (z : Fin n → ℤ) :
    (hammingWeight (reduceModTwo z) : ℤ) ≤ sqNorm z := by
  unfold hammingWeight sqNorm reduceModTwo
  refine le_trans ?_ (Finset.sum_le_sum fun i _ =>
    show z i ^ 2 ≥ if (z i : ZMod 2) = 0 then 0 else 1 from ?_)
  · simp +decide [Finset.sum_ite]
  · split_ifs with hi
    · positivity
    · exact sq_ge_one_of_odd _ hi

/-- A nonzero vector with all coordinates even has squared norm at least four. -/
theorem sqNorm_ge_four_of_all_even {n : ℕ} (z : Fin n → ℤ)
    (heven : reduceModTwo z = 0) (hne : z ≠ 0) :
    4 ≤ sqNorm z := by
  obtain ⟨i, hi⟩ := Function.ne_iff.mp hne
  exact le_trans
    (sq_ge_four_of_even_ne_zero _ (by simpa using congr_fun heven i) hi)
    (Finset.single_le_sum (fun a _ => sq_nonneg (z a)) (Finset.mem_univ i))

/-! ## Construction A minimum norm -/

/--
If a binary code has minimum Hamming weight at least four, then every nonzero
vector in its Construction A integer model has squared norm at least four.
-/
theorem lattice_sqNorm_ge_four {n : ℕ} (C : BinaryLinearCode n)
    (hmin : ∀ v ∈ C, v ≠ 0 → 4 ≤ hammingWeight v)
    (z : Fin n → ℤ) (hz : z ∈ lattice C) (hne : z ≠ 0) :
    4 ≤ sqNorm z := by
  by_cases hzero : reduceModTwo z = 0
  · exact sqNorm_ge_four_of_all_even z hzero hne
  · exact le_trans
      (mod_cast hmin _ ((mem_lattice_iff C z).mp hz) hzero)
      (sqNorm_ge_weight z)

end CodeLatticeE8.ConstructionA
