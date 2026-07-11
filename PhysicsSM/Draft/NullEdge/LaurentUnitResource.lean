import Mathlib

/-!
# Units of a finite Laurent-polynomial ring

This module supplies a focused algebraic resource theorem for strict
translation-invariant finite-range walks.  Every unit over a Laurent-polynomial
ring over a field is a nonzero scalar times one Laurent monomial.  The exponent
is unique, and a genuine two-term Laurent polynomial is therefore not a unit.

For a square invertible Laurent matrix, the determinant is consequently a
unique monomial.  This is the algebraic shape needed by a one-dimensional QCA
flow-index argument.

Scope: the determinant corollary is purely ring-level.  It does not by itself
identify a physical GNVW index, prove a no-doubling theorem, remove aliases, or
extend to the full three-dimensional null-edge walk.  Those steps require a
separate representation/locality theorem connecting a strict QCA to this
Laurent matrix.

Provenance: Aristotle project `ea501e65-70a2-42f1-b19e-1aa59da775f2`,
downloaded from an in-progress proof-complete snapshot and independently
compiled against the pinned repository toolchain on 2026-07-11.  Clean-room
formalization from standard Laurent-polynomial algebra; no external code was
copied.

Lean 4.28.0.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.LaurentUnitResource

variable {K : Type*} [Field K]

/-- Every invertible finite Laurent polynomial over a field is a nonzero
coefficient times one Laurent monomial. -/
theorem isUnit_iff_exists_C_mul_T (p : LaurentPolynomial K) :
    IsUnit p <->
      Exists fun c : K => Ne c 0 /\
        Exists fun n : Int => p = LaurentPolynomial.C c * LaurentPolynomial.T n := by
  constructor
  · intro hp
    obtain ⟨q, hq⟩ : Exists fun q : LaurentPolynomial K => p * q = 1 := by
      exact hp.exists_right_inv
    obtain ⟨n, f', hf'⟩ := LaurentPolynomial.exists_T_pow p
    obtain ⟨m, g', hg'⟩ := LaurentPolynomial.exists_T_pow q
    have hfg : f' * g' = Polynomial.X ^ (n + m) := by
      have hfg : Polynomial.toLaurent (f' * g') =
          LaurentPolynomial.T (n + m : Int) := by
        grind +suggestions
      exact Polynomial.toLaurent_injective (by simpa using hfg)
    obtain ⟨c, i, hc, hi⟩ : Exists fun c : K => Exists fun i : Nat =>
        f' = Polynomial.C c * Polynomial.X ^ i := by
      have h_div : f' ∣ Polynomial.X ^ (n + m) := by
        exact hfg ▸ dvd_mul_right _ _
      rw [dvd_prime_pow] at h_div
      · obtain ⟨i, hi, h⟩ := h_div
        obtain ⟨u, hu⟩ := h.symm
        rcases Polynomial.isUnit_iff.mp u.isUnit with ⟨c, hc⟩
        exact ⟨c, i, by rw [← hu, hc.2, mul_comm]⟩
      · exact Polynomial.prime_X
    refine ⟨c, ?_, i - n, ?_⟩
    · intro hc
      simp_all +decide [pow_add]
    · convert congrArg (fun x => x * LaurentPolynomial.T (-n : Int)) hf' using 1
      · rw [hf', mul_assoc, ← LaurentPolynomial.T_add]
        norm_num
      · rw [← hf']
        simp +decide only [Polynomial.toLaurent_C_mul_eq, Polynomial.toLaurent_X_pow,
          LaurentPolynomial.mul_T_assoc, mul_eq_mul_left_iff, map_eq_zero]
        exact Or.inl rfl
  · rintro ⟨c, hc, n, rfl⟩
    exact IsUnit.mul
      (IsUnit.map LaurentPolynomial.C (isUnit_iff_ne_zero.mpr hc))
      (LaurentPolynomial.isUnit_T _)

/-- The exponent of a unit Laurent polynomial is unique. -/
theorem unit_monomial_exponent_unique
    {c d : K} (hc : Ne c 0) (hd : Ne d 0) {m n : Int}
    (h : LaurentPolynomial.C c * LaurentPolynomial.T m =
      LaurentPolynomial.C d * LaurentPolynomial.T n) :
    m = n := by
  have h_deg : (LaurentPolynomial.C c * LaurentPolynomial.T m).degree =
      (LaurentPolynomial.C d * LaurentPolynomial.T n).degree := by
    rw [h]
  rw [LaurentPolynomial.degree_C_mul_T m c hc,
    LaurentPolynomial.degree_C_mul_T n d hd] at h_deg
  exact_mod_cast h_deg

/-- A two-term Laurent polynomial with distinct exponents and nonzero
coefficients is not a unit. -/
theorem two_term_not_isUnit
    {c d : K} (hc : Ne c 0) (hd : Ne d 0) {m n : Int} (hmn : Ne m n) :
    Not (IsUnit (LaurentPolynomial.C c * LaurentPolynomial.T m +
      LaurentPolynomial.C d * LaurentPolynomial.T n)) := by
  intro hu
  obtain ⟨e, he, k, hk⟩ := (isUnit_iff_exists_C_mul_T _).1 hu
  rw [← LaurentPolynomial.single_eq_C_mul_T, ← LaurentPolynomial.single_eq_C_mul_T,
    ← LaurentPolynomial.single_eq_C_mul_T] at hk
  have hm : (Finsupp.single m c + Finsupp.single n d) m =
      Finsupp.single k e m := by
    rw [hk]
  have hn : (Finsupp.single m c + Finsupp.single n d) n =
      Finsupp.single k e n := by
    rw [hk]
  rw [Finsupp.add_apply, Finsupp.single_eq_same,
    Finsupp.single_eq_of_ne (by omega : Ne m n), add_zero,
    Finsupp.single_apply] at hm
  rw [Finsupp.add_apply, Finsupp.single_eq_of_ne (by omega : Ne n m),
    Finsupp.single_eq_same, zero_add, Finsupp.single_apply] at hn
  by_cases hkm : k = m
  · rw [if_neg (by omega : Not (k = n))] at hn
    exact hd hn
  · rw [if_neg hkm] at hm
    exact hc hm

/-- The determinant of an invertible finite Laurent matrix is a nonzero scalar
times a unique Laurent monomial. -/
theorem qca_det_is_unique_monomial
    {r : Nat} (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K)) (hM : IsUnit M) :
    ExistsUnique fun n : Int => Exists fun c : K =>
      Ne c 0 /\ M.det = LaurentPolynomial.C c * LaurentPolynomial.T n := by
  have hdet : IsUnit M.det := (Matrix.isUnit_iff_isUnit_det M).1 hM
  obtain ⟨c, hc, n, hn⟩ := (isUnit_iff_exists_C_mul_T M.det).1 hdet
  refine ⟨n, ⟨c, hc, hn⟩, ?_⟩
  rintro n' ⟨c', hc', hn'⟩
  exact unit_monomial_exponent_unique hc' hc (hn'.symm.trans hn)

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentUnitResource.isUnit_iff_exists_C_mul_T' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms isUnit_iff_exists_C_mul_T

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentUnitResource.unit_monomial_exponent_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unit_monomial_exponent_unique

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentUnitResource.two_term_not_isUnit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms two_term_not_isUnit

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentUnitResource.qca_det_is_unique_monomial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms qca_det_is_unique_monomial

end PhysicsSM.Draft.NullEdge.LaurentUnitResource
