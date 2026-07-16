import Mathlib

/-!
# Pinsker's inequality (finite)

Aristotle target. Prove `pinsker`: relative entropy dominates the squared total
variation distance, `relEntropy p q ≥ (1/2) (∑ |p_i - q_i|)^2`. This is the
quantitative sharpening of Gibbs' inequality (relative entropy nonnegativity),
and the metric-control lemma the information-resource / gravity-DPI program needs
to turn entropy statements into distance statements.

Standalone, pure `Real`/`Finset`. `relEntropy p q = ∑ i, p i * log (p i / q i)`.

Route (suggested): reduce to the two-point (Bernoulli) case by a data-processing
/ partition argument, then prove the scalar inequality
`p log (p/q) + (1-p) log ((1-p)/(1-q)) ≥ 2 (p - q)^2` on `[0,1]` by calculus
(second derivative bound) -- Mathlib `Real.add_pow_le_pow_mul_pow_of_sq_le_sq` is
not it; use `Real.log_le_sub_one_of_pos` refinements or the `inner_le` route. If
the constant `1/2` is hard, first prove the qualitative
`relEntropy p q = 0 → ∑ |p_i - q_i| = 0`.

Run: `lake env lean Pinsker.lean`. Close only the hole; keep the statement
byte-identical.
-/

noncomputable section

namespace Pinsker

open scoped BigOperators

variable {k : Type*} [Fintype k]

/-- Finite relative entropy `∑ i, p i * log (p i / q i)`. -/
def relEntropy (p q : k → ℝ) : ℝ :=
  ∑ i, p i * Real.log (p i / q i)

/-- Total variation distance (`ℓ¹`), `∑ i, |p i - q i|`. -/
def totalVariation (p q : k → ℝ) : ℝ :=
  ∑ i, |p i - q i|

/-- **TARGET (the hole): Pinsker's inequality.**  Relative entropy dominates the
squared total variation distance. -/
theorem pinsker (p q : k → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hps : ∑ i, p i = 1) (hqs : ∑ i, q i = 1) :
    (1 / 2) * (totalVariation p q) ^ 2 ≤ relEntropy p q := by
  sorry

end Pinsker
