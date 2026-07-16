import Mathlib

/-!
# Classical maximum-entropy theorem: uniform maximizes Shannon entropy (S2 core)

Aristotle target (DYN-MODULAR-001 successor S2; the classical scalar core of the
Gibbs max-entropy uniqueness / quantum Klein program). Together with Gibbs'
inequality (`relEntropy_nonneg`, already landed) this is the variational
characterization of the maximum-entropy state: among all finite probability
vectors, Shannon entropy is maximized exactly by the uniform distribution, with
value `log d`.

For a probability vector `p : k → ℝ` (nonnegative, summing to one) on a finite
nonempty index type with `d = card k`:
`shannonEntropy p ≤ log d`, with equality iff `p` is uniform (`p i = 1/d`).

Route (suggested): this is Gibbs' inequality against the uniform reference
`q i = 1/d`. Indeed `relEntropy p q = ∑ p_i log(p_i · d) = log d - shannonEntropy p`,
so `0 ≤ relEntropy p q` gives `shannonEntropy p ≤ log d`, and the equality case
of Gibbs (`p = q`) gives uniformity. Concretely: bound each term with the tangent
line `log x ≤ x - 1` (`Real.log_le_sub_one_of_pos`) applied to `1/(d · p_i)`, or
use concavity of `negMulLog` (`Real.strictConcaveOn_negMulLog`) with Jensen. The
`0 * log 0 = 0` convention is handled by `Real.negMulLog` at `0`.

Run: `lake env lean MaxEntropyUniform.lean`. Close only the holes; keep the
definitions and statements byte-identical.
-/

noncomputable section

namespace MaxEntropyUniform

open scoped BigOperators

variable {k : Type*} [Fintype k]

/-- Shannon entropy of a finite distribution `r`, `∑ i, negMulLog (r i)`
(`negMulLog x = -x log x`, so `0 * log 0 = 0` is built in). -/
def shannonEntropy (r : k → ℝ) : ℝ :=
  ∑ i, Real.negMulLog (r i)

/-- **TARGET (hole 1): maximum-entropy bound.**  Shannon entropy of any finite
probability vector is at most `log d`, where `d = card k`. -/
theorem entropy_le_log_card [Nonempty k] (p : k → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hps : ∑ i, p i = 1) :
    shannonEntropy p ≤ Real.log (Fintype.card k) := by
  sorry

/-- **TARGET (hole 2): equality case (uniqueness of the maximizer).**  Entropy
attains the maximum `log d` iff the distribution is uniform. -/
theorem entropy_eq_log_card_iff [Nonempty k] (p : k → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hps : ∑ i, p i = 1) :
    shannonEntropy p = Real.log (Fintype.card k)
      ↔ ∀ i, p i = (Fintype.card k : ℝ)⁻¹ := by
  sorry

end MaxEntropyUniform
