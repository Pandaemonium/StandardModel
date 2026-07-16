import Mathlib

/-!
# Classical Shannon subadditivity (finite)

Aristotle target (information-theory foundation; complements the landed strong
subadditivity by giving the basic two-system bound). For a finite joint
probability distribution `p` on `k x l`, the Shannon entropy of the joint is at
most the sum of the entropies of the two marginals:
`H(p) <= H(p_1) + H(p_2)`, where `p_1 i = sum_j p (i,j)` and
`p_2 j = sum_i p (i,j)`.

Entropy is `sum negMulLog` with `negMulLog x = -x log x` and the convention
`0 log 0 = 0`. Route: `H(p_1) + H(p_2) - H(p) = sum_{i,j} p(i,j) log( p(i,j) /
(p_1 i * p_2 j) )` is the relative entropy of `p` against the product of its
marginals, which is nonnegative by Gibbs' inequality / the log-sum inequality
(the product marginal is a probability distribution). Prove the identity, then
apply Gibbs nonnegativity (`Real.log_le_sub_one_of_pos` termwise on the support,
summed, using that both `p` and the product marginal sum to 1). Do NOT use
native_decide.

Run: `lake env lean ShannonSubadditivity.lean`. Close the hole; keep the
statement byte-identical.
-/

noncomputable section

namespace ShannonSubadditivity

open scoped BigOperators

variable {k l : Type*} [Fintype k] [Fintype l]

/-- **TARGET: classical Shannon subadditivity.** -/
theorem shannon_subadditivity (p : k × l → ℝ)
    (hp : ∀ x, 0 ≤ p x) (hps : ∑ x, p x = 1) :
    (∑ x, Real.negMulLog (p x))
      ≤ (∑ i, Real.negMulLog (∑ j, p (i, j)))
        + (∑ j, Real.negMulLog (∑ i, p (i, j))) := by
  sorry

end ShannonSubadditivity
