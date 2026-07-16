import Mathlib

/-!
# Aristotle target: scalar equality core for quantum Klein strictness

This file isolates the scalar doubly-stochastic equality lemma from the stalled
general matrix quantum-Klein job. It is the strictness core needed before the
separate eigenvector-overlap reconstruction can prove `rho = sigma`.

Provenance: the immutable target statement was prepared in-project. Aristotle
project `be3e675b-9c6e-47d3-aa40-ae51042cc427` returned the completed proof on
2026-07-13. The result was replayed locally under Lean 4.28 before this draft
integration. Cross-family semantic review remains required before manuscript
promotion.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.ScalarKleinEqualityCore

/-- Scalar logarithmic tangent bound. -/
lemma term_bound (a b : Real) (ha : 0 < a) (hb : 0 < b) :
    a - b ≤ a * (Real.log a - Real.log b) := by
  have h := Real.log_le_sub_one_of_pos (x := b / a) (by positivity)
  rw [Real.log_div hb.ne' ha.ne'] at h
  nlinarith [mul_le_mul_of_nonneg_left h (le_of_lt ha),
    mul_div_cancel₀ b ha.ne']

/-- Equality in the scalar logarithmic tangent bound forces equal arguments. -/
lemma term_eq (a b : Real) (ha : 0 < a) (hb : 0 < b)
    (heq : a - b = a * (Real.log a - Real.log b)) : a = b := by
  by_contra hne
  have hne' : b / a ≠ 1 := fun h => hne (by field_simp at h; linarith)
  have h := Real.log_lt_sub_one_of_pos (x := b / a) (by positivity) hne'
  rw [Real.log_div hb.ne' ha.ne'] at h
  nlinarith [mul_lt_mul_of_pos_left h ha, mul_div_cancel₀ b ha.ne']

/-
Per-term weighted scalar Klein gap is nonnegative, allowing `a = 0`.
-/
lemma klein_term_nonneg (a b q : Real) (ha : 0 ≤ a) (hb : 0 < b) (hq : 0 ≤ q) :
    0 ≤ a * q * (Real.log a - Real.log b) - q * (a - b) := by
  by_cases ha' : a = 0 <;> simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ];
  nlinarith [ term_bound a b ( lt_of_le_of_ne ha ( Ne.symm ha' ) ) hb ]

/-
If the weighted scalar Klein gap vanishes with positive weight, the
arguments are equal. The `a = 0` case is excluded because it forces the gap to
be `q * b > 0`.
-/
lemma klein_term_eq (a b q : Real) (ha : 0 ≤ a) (hb : 0 < b) (hq : 0 < q)
    (h0 : a * q * (Real.log a - Real.log b) - q * (a - b) = 0) : a = b := by
  by_cases ha0 : a = 0 <;> by_cases hb0 : b = 0 <;> simp_all +decide [ sub_eq_iff_eq_add ];
  exact term_eq a b ( lt_of_le_of_ne ha ( Ne.symm ha0 ) ) hb ( by nlinarith )

/-
**Scalar Klein equality core.** Let `lam` and `mu` be probability vectors,
with `mu` strictly positive, and let `p` be doubly stochastic. If the scalar
relative-entropy expression vanishes, every nonzero overlap joins equal
eigenvalues. Zero entries of `lam` are allowed.
-/
theorem scalar_klein_eq {n m : Type*} [Fintype n] [Fintype m]
    (lam : n -> Real) (mu : m -> Real) (p : n -> m -> Real)
    (hlam : ∀ i, 0 ≤ lam i) (hmu : ∀ j, 0 < mu j)
    (hp : ∀ i j, 0 ≤ p i j)
    (hrow : ∀ i, ∑ j, p i j = 1)
    (hcol : ∀ j, ∑ i, p i j = 1)
    (hlamsum : ∑ i, lam i = 1)
    (hmusum : ∑ j, mu j = 1)
    (heq : (∑ i, lam i * Real.log (lam i)) -
      ∑ i, ∑ j, lam i * p i j * Real.log (mu j) = 0) :
    ∀ i j, p i j ≠ 0 -> mu j = lam i := by
  -- Weighted scalar Klein gap for each pair `(i, j)`.
  set g : n → m → Real :=
    fun i j => lam i * p i j * (Real.log (lam i) - Real.log (mu j))
      - p i j * (lam i - mu j) with hg
  -- Each summand is nonnegative.
  have hnonneg : ∀ i j, 0 ≤ g i j := by
    intro i j
    exact klein_term_nonneg (lam i) (mu j) (p i j) (hlam i) (hmu j) (hp i j)
  -- Nonnegative summands summing to zero are individually zero; the total gap
  -- equals the vanishing entropy expression `heq`.
  have hzero : ∀ i j, g i j = 0 := by
    -- From heq, show the total sum of g equals the entropy expression in heq.
    have hsum : ∑ i, ∑ j, g i j = (∑ i, lam i * Real.log (lam i)) - (∑ i, ∑ j, lam i * p i j * Real.log (mu j)) - (∑ i, ∑ j, p i j * lam i) + (∑ j, mu j * (∑ i, p i j)) := by
      simp +decide [ g, mul_sub, Finset.mul_sum _ _ _, Finset.sum_mul, mul_assoc, mul_comm, mul_left_comm, hrow, hcol ] ; ring;
      simp +decide only [mul_assoc, ← Finset.mul_sum _ _ _, ← Finset.sum_mul, hrow, mul_one, ← Finset.sum_comm,
          hcol] ; ring;
    simp_all +decide [ ← Finset.mul_sum _ _ _, ← Finset.sum_mul ];
    exact fun i j => le_antisymm ( by simpa [ * ] using Finset.single_le_sum ( fun i _ => Finset.sum_nonneg fun j _ => sub_nonneg.mpr ( hnonneg i j ) ) ( Finset.mem_univ i ) |> le_trans ( Finset.single_le_sum ( fun j _ => sub_nonneg.mpr ( hnonneg i j ) ) ( Finset.mem_univ j ) ) ) ( sub_nonneg.mpr ( hnonneg i j ) )
  intro i j hpij
  have hp' : 0 < p i j := lt_of_le_of_ne (hp i j) (Ne.symm hpij)
  exact (klein_term_eq (lam i) (mu j) (p i j) (hlam i) (hmu j) hp' (hzero i j)).symm

/-- One-state control: the conclusion specializes to the unique normalized
probability vectors. -/
theorem scalar_klein_eq_subsingleton_control
    (lam mu : Fin 1 -> Real) (p : Fin 1 -> Fin 1 -> Real)
    (hlam : ∀ i, 0 ≤ lam i) (hmu : ∀ j, 0 < mu j)
    (hp : ∀ i j, 0 ≤ p i j)
    (hrow : ∀ i, ∑ j, p i j = 1)
    (hcol : ∀ j, ∑ i, p i j = 1)
    (hlamsum : ∑ i, lam i = 1)
    (hmusum : ∑ j, mu j = 1)
    (heq : (∑ i, lam i * Real.log (lam i)) -
      ∑ i, ∑ j, lam i * p i j * Real.log (mu j) = 0) :
    mu 0 = lam 0 := by
  have hlam0 : lam 0 = 1 := by
    simpa using hlamsum
  have hmu0 : mu 0 = 1 := by
    simpa using hmusum
  rw [hlam0, hmu0]

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ScalarKleinEqualityCore.scalar_klein_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scalar_klein_eq

/-- info: 'PhysicsSM.Draft.NullEdge.ScalarKleinEqualityCore.scalar_klein_eq_subsingleton_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scalar_klein_eq_subsingleton_control

end PhysicsSM.Draft.NullEdge.ScalarKleinEqualityCore
