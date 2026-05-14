import Mathlib
import PhysicsSM.Coding.ConstructionA
import PhysicsSM.Coding.HammingE8

/-!
# Construction A lattice: evenness and full-rank precursors

This module proves structural properties of Construction A subgroups that move
them toward being geometric lattices, without overclaiming identification with
any particular named lattice (e.g. E8).

## Main results

* `constructionA_contains_twoBasisVec` — every doubled standard basis vector
  `2 · eᵢ` lies in `constructionA C`, for any binary linear code `C`.
* `constructionA_contains_twoZBasis` — the full set of doubled basis vectors
  is contained, witnessing a full-rank precursor.
* `sq_mod_four_of_even` / `sq_mod_four_of_odd` — elementary mod-4 facts for
  squares of even/odd integers.
* `sqNorm_mod_four_eq_hammingWeight_mod_four` — the squared norm of an integer
  vector equals the Hamming weight of its mod-2 reduction, modulo 4.
* `constructionA_sqNorm_dvd_four_of_doublyEven` — if the code is doubly even,
  then every lattice vector has squared norm divisible by 4.
* `hammingConstructionALattice_sqNorm_dvd_four` — specialisation to the
  extended Hamming code.

## Claim boundary

These results do not prove unimodularity, do not identify the lattice as E8,
and do not prove any Gram-matrix or isometry statement.

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Chapter 7.
- Aristotle job PR1 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding

/-! ## Full-rank precursor: doubled basis vectors -/

/-- The doubled standard basis vector `2 · eᵢ` as an integer vector. -/
def twoBasisVec {n : ℕ} (i : Fin n) : Fin n → ℤ :=
  fun j => if j = i then 2 else 0

/-- Every coordinate of `twoBasisVec i` is even. -/
theorem twoBasisVec_even {n : ℕ} (i : Fin n) (j : Fin n) :
    2 ∣ twoBasisVec i j := by
  simp [twoBasisVec]
  split <;> omega

/-- The doubled standard basis vector `2 · eᵢ` belongs to `constructionA C`
for any binary linear code `C`. This follows immediately from the fact that
all its coordinates are even, so its mod-2 reduction is zero. -/
theorem constructionA_contains_twoBasisVec {n : ℕ} (C : BinaryLinearCode n)
    (i : Fin n) : twoBasisVec i ∈ constructionA C :=
  even_vector_mem_constructionA C (twoBasisVec i) (twoBasisVec_even i)

/-- Every doubled standard basis vector lies in `constructionA C`.
This is a full-rank precursor: the `n` vectors `{2·e₀, …, 2·eₙ₋₁}`
are linearly independent in `ℤⁿ`, so `constructionA C` spans `ℤⁿ` over `ℚ`
(equivalently, it has full rank as a lattice). -/
theorem constructionA_contains_twoZBasis {n : ℕ} (C : BinaryLinearCode n)
    (i : Fin n) : twoBasisVec i ∈ constructionA C :=
  constructionA_contains_twoBasisVec C i

/-! ## Parity of squares mod 4 -/

/-
If `a` is even, then `a ^ 2 ≡ 0 (mod 4)`.
-/
theorem sq_mod_four_of_even (a : ℤ) (h : 2 ∣ a) : a ^ 2 % 4 = 0 := by
  exact Int.emod_eq_zero_of_dvd ( pow_dvd_pow_of_dvd h 2 )

/-
If `a` is odd, then `a ^ 2 ≡ 1 (mod 4)`.
-/
theorem sq_mod_four_of_odd (a : ℤ) (h : ¬ 2 ∣ a) : a ^ 2 % 4 = 1 := by
  rcases Int.even_or_odd' a with ⟨ b, rfl | rfl ⟩ <;> ring_nf <;> norm_num at *

/-- An integer is even iff its cast to `ZMod 2` is zero. -/
theorem even_iff_zmod2_eq_zero (a : ℤ) :
    2 ∣ a ↔ (a : ZMod 2) = 0 := by
  constructor
  · intro h; exact (ZMod.intCast_zmod_eq_zero_iff_dvd a 2).mpr h
  · intro h; rwa [ZMod.intCast_zmod_eq_zero_iff_dvd] at h

/-! ## sqNorm mod 4 equals Hamming weight mod 4 -/

/-
The squared norm of an integer vector is congruent to the Hamming weight of
its mod-2 reduction, modulo 4. Each even coordinate contributes `0 mod 4` and
each odd coordinate contributes `1 mod 4` to the sum of squares.
-/
theorem sqNorm_mod_four_eq_hammingWeight_mod_four {n : ℕ} (z : Fin n → ℤ) :
    sqNorm z % 4 = (hammingWeight (reduceModTwo z) : ℤ) % 4 := by
  unfold hammingWeight;
  -- By definition of sqNorm and hammingWeight, we can rewrite the goal using the properties of modular arithmetic.
  have h_mod_four : ∀ i, (z i) ^ 2 % 4 = if (reduceModTwo z i) = 0 then 0 else 1 := by
    intro i;
    rcases Int.even_or_odd' ( z i ) with ⟨ k, hk | hk ⟩ <;> rw [ hk ] <;> ring_nf <;> norm_num;
    · aesop;
    · simp +decide [ hk, ZMod ];
      grind;
  unfold sqNorm; rw [ Finset.sum_int_mod ] ; simp +decide [ *, Finset.sum_ite ] ;

/-! ## Doubly-even codes yield 4-divisible squared norms -/

/-
If `C` is a doubly-even code, then every vector in `constructionA C` has
squared norm divisible by 4.
-/
theorem constructionA_sqNorm_dvd_four_of_doublyEven {n : ℕ}
    (C : BinaryLinearCode n) (hde : IsDoublyEven C)
    (z : Fin n → ℤ) (hz : z ∈ constructionA C) :
    (4 : ℤ) ∣ sqNorm z := by
  exact Int.dvd_of_emod_eq_zero ( sqNorm_mod_four_eq_hammingWeight_mod_four z ▸ Int.emod_eq_zero_of_dvd ( mod_cast hde _ ( mem_constructionA_iff _ _ |>.1 hz ) ) )

/-! ## Specialisation to `hammingConstructionALattice` -/

/-- Every doubled standard basis vector belongs to `hammingConstructionALattice`. -/
theorem hammingConstructionALattice_contains_twoBasisVec (i : Fin 8) :
    twoBasisVec i ∈ hammingConstructionALattice :=
  constructionA_contains_twoBasisVec extendedHamming8 i

/-- The extended Hamming code is doubly even (wrapper for the existing theorem,
cast to the `IsDoublyEven` predicate). -/
theorem extendedHamming8_isDoublyEven : IsDoublyEven extendedHamming8 :=
  fun v hv => extendedHamming8_doublyEven' v hv

/-- Every vector in `hammingConstructionALattice` has squared norm divisible
by 4. This is an evenness property of the lattice, following from the
doubly-even property of the extended Hamming code. -/
theorem hammingConstructionALattice_sqNorm_dvd_four
    (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionALattice) :
    (4 : ℤ) ∣ sqNorm z :=
  constructionA_sqNorm_dvd_four_of_doublyEven extendedHamming8
    extendedHamming8_isDoublyEven z hz

/-! ## Real-span full-rank statement -/

/-
The ℤ-linear span of `hammingConstructionALattice` contains `2ℤ⁸`, which
has full rank. Equivalently, the real span of the lattice is all of `ℝ⁸`.
We state this as: for every standard basis vector `eᵢ`, the doubled version
`2·eᵢ` lies in the lattice, and these are ℤ-linearly independent.

This is a corollary of `constructionA_contains_twoZBasis` and the fact
that the `twoBasisVec` vectors are linearly independent over `ℤ`.
-/
theorem twoBasisVec_linearIndependent (n : ℕ) :
    LinearIndependent ℤ (fun i : Fin n => (twoBasisVec i : Fin n → ℤ)) := by
  refine Fintype.linearIndependent_iff.2 ?_
  intro g hg i
  replace hg := congr_fun hg i
  simp_all +decide [twoBasisVec]

end PhysicsSM.Coding
