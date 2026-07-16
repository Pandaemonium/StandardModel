import Mathlib

/-!
# Gibbs free-energy variational lower bound (finite, beta = 1)

Aristotle target (the free-energy dual of the landed max-entropy principle). For
finite energies `E` and any probability vector `p`, the negative log partition
function lower-bounds the free energy:
`-log(sum_i exp(-E_i)) <= (sum_i p_i E_i) - H(p)`, where `H(p) = sum negMulLog p`.
Equivalently `H(p) - sum p_i E_i <= log Z`; equality holds at the Gibbs
distribution `p_i = exp(-E_i)/Z`.

Route: let `g_i = exp(-E_i)/Z` with `Z = sum exp(-E_i) > 0`. Then
`sum_i p_i E_i - H(p) + log Z = sum_i p_i (E_i + log Z) + sum_i p_i log p_i
= sum_i p_i log(p_i / g_i)` (since `log g_i = -E_i - log Z`), which is the
relative entropy `D(p || g) >= 0` by Gibbs' inequality
(`Real.log_le_sub_one_of_pos` termwise, summed, using `sum p = sum g = 1`;
`p_i = 0` terms vanish). Rearrange to the stated bound. Do NOT use native_decide.

Run: `lake env lean GibbsFreeEnergy.lean`. Close the hole; keep the statement
byte-identical.
-/

noncomputable section

namespace GibbsFreeEnergy

open scoped BigOperators

variable {k : Type*} [Fintype k] [Nonempty k]

/-- **TARGET: Gibbs free-energy variational lower bound (beta = 1).** -/
theorem gibbs_free_energy_lower (E : k → ℝ) (p : k → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hps : ∑ i, p i = 1) :
    -Real.log (∑ i, Real.exp (-(E i)))
      ≤ (∑ i, p i * E i) - (∑ i, Real.negMulLog (p i)) := by
  sorry

end GibbsFreeEnergy
