import Mathlib

/-!
# Aristotle target: scalar equality core for quantum Klein strictness

This file isolates the scalar doubly-stochastic equality lemma from the stalled
general matrix quantum-Klein job. It is the strictness core needed before the
separate eigenvector-overlap reconstruction can prove `rho = sigma`.
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

/-- **Scalar Klein equality core.** Let `lam` and `mu` be probability vectors,
with `mu` strictly positive, and let `p` be doubly stochastic. If the scalar
relative-entropy expression vanishes, every nonzero overlap joins equal
eigenvalues. Zero entries of `lam` are allowed. -/
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
  sorry

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

end PhysicsSM.Draft.NullEdge.ScalarKleinEqualityCore
