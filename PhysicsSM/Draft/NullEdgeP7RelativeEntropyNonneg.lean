import Mathlib.Tactic

/-!
# P7 relative-entropy nonnegativity (finite Gibbs inequality)

The cornerstone of the P7 relative-entropy / recoverability program: the finite
Kullback-Leibler divergence of two probability vectors is nonnegative, and zero
only when they agree. This is the discrete Gibbs inequality, the positivity that
makes relative entropy a genuine distinguishability measure for observer
channels.

```text
sum_i p i * log (p i / q i) >= 0      (p, q finite probability vectors, q > 0).
```

Uses the convention `Real.log 0 = 0`, so zero-probability cells contribute zero.

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7RelativeEntropyNonneg

open BigOperators

/-- Finite Kullback-Leibler divergence. -/
def kl {n : Nat} (p q : Fin n -> Real) : Real :=
  Finset.univ.sum fun i => p i * Real.log (p i / q i)

/-
The finite relative entropy of two probability vectors is nonnegative.
-/
theorem kl_nonneg {n : Nat} (p q : Fin n -> Real)
    (hp : forall i, 0 <= p i) (hq : forall i, 0 < q i)
    (hsp : Finset.univ.sum p = 1) (hsq : Finset.univ.sum q = 1) :
    0 <= kl p q := by
  have h_kl_nonneg : ∀ i, p i * Real.log (p i / q i) ≥ p i - q i := by
    intro i
    by_cases hpi : p i = 0
    · simpa [hpi] using le_of_lt (hq i)
    · have hpos := lt_of_le_of_ne (hp i) (Ne.symm hpi)
      have hlog := Real.log_le_sub_one_of_pos (div_pos (hq i) hpos)
      rw [show p i / q i = (q i / p i)⁻¹ by rw [inv_div], Real.log_inv]
      nlinarith [hp i, hq i, mul_div_cancel₀ (q i) hpi]
  exact le_trans (by norm_num [hsp, hsq]) (Finset.sum_le_sum fun i _ => h_kl_nonneg i)

/-
Relative entropy of a distribution with itself vanishes.
-/
theorem kl_self {n : Nat} (p : Fin n -> Real)
    (hp : forall i, 0 < p i) :
    kl p p = 0 := by
  exact Finset.sum_eq_zero fun i _ => by simp [ne_of_gt (hp i)]

end PhysicsSM.Draft.NullEdgeP7RelativeEntropyNonneg
