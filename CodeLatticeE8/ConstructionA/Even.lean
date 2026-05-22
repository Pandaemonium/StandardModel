import CodeLatticeE8.ConstructionA.Norm

/-!
# Evenness facts for Construction A

This module records the elementary parity argument behind the E8 normalization:
for an integer vector `z`, the squared norm of `z` is congruent modulo `4` to
the Hamming weight of its mod-two reduction.  Consequently, a doubly-even
binary code has a Construction A integer model whose squared norms are all
divisible by `4`.

This is still purely integral.  No real scaling, theta series, or named E8
lattice identification is used here.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.ConstructionA

open CodeLatticeE8.Code

/-! ## Doubled coordinate vectors -/

/-- The doubled standard coordinate vector `2 e_i`. -/
def twoBasisVec {n : ℕ} (i : Fin n) : Fin n → ℤ :=
  fun j => if j = i then 2 else 0

/-- Every coordinate of `twoBasisVec i` is even. -/
theorem twoBasisVec_even {n : ℕ} (i : Fin n) (j : Fin n) :
    2 ∣ twoBasisVec i j := by
  simp [twoBasisVec]
  split <;> omega

/-- Every doubled standard coordinate vector belongs to every Construction A lattice. -/
theorem twoBasisVec_mem_lattice {n : ℕ} (C : BinaryLinearCode n) (i : Fin n) :
    twoBasisVec i ∈ lattice C :=
  even_vector_mem C (twoBasisVec i) (twoBasisVec_even i)

/-! ## Squares modulo four -/

/-- An even integer has square congruent to `0` modulo `4`. -/
theorem sq_mod_four_of_even (a : ℤ) (h : 2 ∣ a) : a ^ 2 % 4 = 0 :=
  Int.emod_eq_zero_of_dvd (pow_dvd_pow_of_dvd h 2)

/-- An odd integer has square congruent to `1` modulo `4`. -/
theorem sq_mod_four_of_odd (a : ℤ) (h : ¬ 2 ∣ a) : a ^ 2 % 4 = 1 := by
  rcases Int.even_or_odd' a with ⟨k, hk | hk⟩
  · exact False.elim (h ⟨k, hk⟩)
  · rw [hk]
    ring_nf
    norm_num

/-- An integer is even exactly when its cast to `ZMod 2` is zero. -/
theorem even_iff_zmod2_eq_zero (a : ℤ) :
    2 ∣ a ↔ (a : ZMod 2) = 0 := by
  constructor
  · intro h
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd a 2).mpr h
  · intro h
    rwa [ZMod.intCast_zmod_eq_zero_iff_dvd] at h

/-! ## Norm modulo four -/

/--
The squared norm of an integer vector is congruent modulo `4` to the Hamming
weight of its mod-two reduction.
-/
theorem sqNorm_mod_four_eq_hammingWeight_mod_four {n : ℕ} (z : Fin n → ℤ) :
    sqNorm z % 4 = (hammingWeight (reduceModTwo z) : ℤ) % 4 := by
  unfold hammingWeight
  have hmod :
      ∀ i, (z i) ^ 2 % 4 = if reduceModTwo z i = 0 then 0 else 1 := by
    intro i
    by_cases h : 2 ∣ z i
    · have hzmod : reduceModTwo z i = 0 := by
        exact (ZMod.intCast_zmod_eq_zero_iff_dvd (z i) 2).mpr h
      rw [sq_mod_four_of_even _ h, if_pos hzmod]
    · have hzmod : reduceModTwo z i ≠ 0 := by
        intro hzmod
        exact h ((ZMod.intCast_zmod_eq_zero_iff_dvd (z i) 2).mp hzmod)
      rw [sq_mod_four_of_odd _ h, if_neg hzmod]
  unfold sqNorm
  rw [Finset.sum_int_mod]
  simp +decide [hmod, Finset.sum_ite]

/-! ## Doubly-even codes -/

/--
If `C` is doubly even, then every vector in its Construction A integer model has
squared norm divisible by `4`.
-/
theorem sqNorm_dvd_four_of_doublyEven {n : ℕ}
    (C : BinaryLinearCode n) (hde : IsDoublyEven C)
    (z : Fin n → ℤ) (hz : z ∈ lattice C) :
    (4 : ℤ) ∣ sqNorm z := by
  refine Int.dvd_of_emod_eq_zero ?_
  rw [sqNorm_mod_four_eq_hammingWeight_mod_four z]
  exact Int.emod_eq_zero_of_dvd
    (by exact_mod_cast hde _ ((mem_lattice_iff C z).mp hz))

end CodeLatticeE8.ConstructionA
