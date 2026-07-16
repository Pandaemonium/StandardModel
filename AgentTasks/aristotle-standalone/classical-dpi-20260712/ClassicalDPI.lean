import Mathlib

/-!
# Classical data-processing inequality (Q1 gravity-DPI gate, finite)

Aristotle target. Prove `relEntropy_dpi`: the finite relative entropy is monotone
non-increasing under a stochastic (coarse-graining) map. This is the classical
data-processing inequality -- the exact finite content the NERD roadmap flags as
the Q1 "gravity is data-processing" gate, and the monotonicity backbone of the
information-resource program.

For probability vectors `p, q : m → ℝ` and a row-stochastic map
`T : n → m → ℝ` (`T i j ≥ 0`, each row sums to one), pushing forward via
`(T • p) i = ∑ j, T i j * p j` cannot increase relative entropy:
`relEntropy (T • p) (T • q) ≤ relEntropy p q`.

Route (suggested): the log-sum inequality, or joint convexity of relative
entropy. The scalar log-sum inequality
`(∑ a_j) log ((∑ a_j)/(∑ b_j)) ≤ ∑ a_j log (a_j / b_j)` (for `a_j, b_j > 0`)
applied per output coordinate `i` with `a_j = T i j p j`, `b_j = T i j q j`, then
summed over `i` using `∑ i, T i j = 1`. The log-sum inequality follows from
convexity of `x ↦ x log x` (`Real.strictConvexOn_mul_log`) / Jensen. Handle zero
entries by the `0 * log 0 = 0` convention.

Run: `lake env lean ClassicalDPI.lean`. Close only the hole; keep the definitions
and hypotheses byte-identical.
-/

noncomputable section

namespace ClassicalDPI

open scoped BigOperators

variable {m n : Type*} [Fintype m] [Fintype n]

/-- Finite relative entropy `∑ j, p j * log (p j / q j)`. -/
def relEntropy (p q : m → ℝ) : ℝ :=
  ∑ j, p j * Real.log (p j / q j)

/-- Push-forward of a distribution through a stochastic map:
`(pushforward T p) i = ∑ j, T i j * p j`. -/
def pushforward (T : n → m → ℝ) (p : m → ℝ) : n → ℝ :=
  fun i => ∑ j, T i j * p j

/-- **TARGET (the hole): classical data-processing inequality.**  A stochastic
map cannot increase relative entropy. -/
theorem relEntropy_dpi (T : n → m → ℝ) (p q : m → ℝ)
    (hT : ∀ i j, 0 ≤ T i j) (hTrow : ∀ j, ∑ i, T i j = 1)
    (hp : ∀ j, 0 ≤ p j) (hq : ∀ j, 0 < q j)
    (hps : ∑ j, p j = 1) (hqs : ∑ j, q j = 1) :
    relEntropy (pushforward T p) (pushforward T q) ≤ relEntropy p q := by
  sorry

end ClassicalDPI
