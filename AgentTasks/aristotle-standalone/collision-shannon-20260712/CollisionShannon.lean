import Mathlib

/-!
# Collision entropy <= Shannon entropy (finite Renyi hierarchy)

Aristotle target (unifies the resource-measure hierarchy: links the Shannon
entropy `VonNeumannEntropyBound`/`ClassicalSSA` line to the purity/collision
`PurityBounds` line). For a finite probability vector `p`, the collision (Renyi-2)
entropy `H_2(p) = -log (sum_i p_i^2)` is at most the Shannon entropy
`H(p) = sum_i negMulLog (p_i)`. Since `sum_i p_i^2` is the classical purity, this
is exactly `H(p) >= -log(purity)`, the order-monotonicity `H_1 >= H_2` of Renyi
entropies. CFC-free, pure `Real`/`Finset`.

Route (suggested): Jensen's inequality for the convex function `-log`. Writing the
purity `sum_i p_i^2 = sum_i p_i * p_i = E_p[p]` as the `p`-expectation of the
value `p_i`, convexity of `-log` gives
`-log (E_p[p]) <= E_p[-log p] = sum_i p_i * (-log p_i) = H(p)`. Use
`Real.strictConvexOn_...`/`ConvexOn.le_map_sum` for `x |-> -log x`, or
`Real.add_pow_le_pow_mul_pow_of_sq_le_sq` is not it; `Real.inner_le_nnorm` no.
Handle `p_i = 0` via the `0 * log 0 = 0` convention (`Real.negMulLog`) and the
`p`-weighting (zero-probability atoms drop out).

Run: `lake env lean CollisionShannon.lean`. Close only the hole; keep the
definitions and statement byte-identical.
-/

noncomputable section

namespace CollisionShannon

open scoped BigOperators

variable {n : Type*} [Fintype n]

/-- Shannon entropy `∑ i, negMulLog (p i)` (`negMulLog x = -x log x`). -/
def shannonEntropy (p : n → ℝ) : ℝ :=
  ∑ i, Real.negMulLog (p i)

/-- Collision (Renyi-2) entropy `-log (∑ i, (p i)^2)`; the argument
`∑ i, (p i)^2` is the classical purity. -/
def collisionEntropy (p : n → ℝ) : ℝ :=
  - Real.log (∑ i, (p i) ^ 2)

/-- **TARGET (the hole): collision entropy <= Shannon entropy.**  For a finite
probability vector, the Renyi-2 (collision) entropy is at most the Shannon
entropy. -/
theorem collision_le_shannon [Nonempty n] (p : n → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hps : ∑ i, p i = 1) :
    collisionEntropy p ≤ shannonEntropy p := by
  sorry

end CollisionShannon
