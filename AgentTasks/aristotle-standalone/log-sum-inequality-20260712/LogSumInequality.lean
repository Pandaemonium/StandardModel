import Mathlib

/-!
# The log-sum inequality (finite)

Aristotle target (information-theory foundation for the null-edge program; not yet
in-repo). For finite nonnegative `a` and strictly positive `b`,
`(sum a) * log((sum a)/(sum b)) <= sum_i a_i * log(a_i / b_i)`, with the
convention `0 * log 0 = 0` inherited from `Real.log 0 = 0`. This underpins Gibbs'
inequality, the data-processing inequality, and subadditivity.

Route: the map `x |-> x * log x` (`- Real.negMulLog`) is convex on `[0, inf)`;
apply Jensen with weights `b_i / (sum b)` to the points `a_i / b_i`, or use the
tangent/`Real.add_one_le_exp` (`Real.log_le_sub_one_of_pos`) bound on
`(a_i/b_i) / ((sum a)/(sum b))` summed against the `b_i`. Handle `a_i = 0` by the
`0 * log 0 = 0` convention. Do NOT use native_decide.

Run: `lake env lean LogSumInequality.lean`. Close the hole; keep the statement
byte-identical.
-/

noncomputable section

namespace LogSumInequality

open scoped BigOperators

variable {k : Type*} [Fintype k]

/-- **TARGET: the log-sum inequality.** -/
theorem log_sum_inequality (a b : k → ℝ)
    (ha : ∀ i, 0 ≤ a i) (hb : ∀ i, 0 < b i) (hA : 0 < ∑ i, a i) :
    (∑ i, a i) * Real.log ((∑ i, a i) / (∑ i, b i))
      ≤ ∑ i, a i * Real.log (a i / b i) := by
  sorry

end LogSumInequality
