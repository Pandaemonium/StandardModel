import Mathlib

/-!
# Purity bounds for a finite density matrix: 1/d <= Tr(rho^2) <= 1

Aristotle target (resource-measure companion to the von Neumann entropy ceiling).
For a density matrix `rho` (Hermitian, PSD, unit trace) on a finite nonempty
Hilbert space of dimension `d = card n`, the purity `Tr(rho^2) = sum_i lambda_i^2`
(over eigenvalues) is bounded by `1/d <= purity <= 1`: the upper bound (`= 1`) is
attained by pure states, the lower bound (`= 1/d`) by the maximally-mixed state.
This is the purity dual of `VonNeumannEntropyBound` (`S(rho) <= log d`) and a
basic resource monotone for the mass-as-entanglement / information-resource
program. CFC-free: purity is the sum of squared eigenvalues, no matrix functional
calculus.

Route (suggested): the eigenvalue vector `p i = hrho.eigenvalues i` is a finite
probability vector -- nonnegative (`Matrix.PosSemidef.eigenvalues_nonneg`) and
summing to one (`Matrix.IsHermitian.trace_eq_sum_eigenvalues` with `htr`). Then
`sum p_i^2 <= (sum p_i)^2 = 1` because the cross terms are nonnegative
(`Finset.inner_mul_le_norm_mul_norm` is overkill; `sq_sum_le` style, or
`Finset.sum_sq_le_sq_sum_of_nonneg` / expand `(sum p)^2 = sum p^2 + cross >= sum p^2`),
and `1 = (sum p_i)^2 <= d * sum p_i^2` by Cauchy-Schwarz
(`Finset.sq_sum_le_card_mul_sum_sq` / `Finset.inner_mul_le_norm_mul_norm`).

Run: `lake env lean PurityBounds.lean`. Close only the holes; keep the definition
and statements byte-identical.
-/

noncomputable section

namespace PurityBounds

open Matrix
open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Purity of a Hermitian matrix, as the sum of squared eigenvalues
(`= Tr(rho^2)` for Hermitian `rho`). -/
def purity (ρ : Matrix n n ℂ) (hρ : ρ.IsHermitian) : ℝ :=
  ∑ i, (hρ.eigenvalues i) ^ 2

/-- **TARGET (hole 1): purity ceiling.**  A density matrix has purity at most `1`
(attained by pure states). -/
theorem purity_le_one (ρ : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hpsd : ρ.PosSemidef) (htr : ρ.trace = 1) :
    purity ρ hρ ≤ 1 := by
  sorry

/-- **TARGET (hole 2): purity floor.**  A density matrix on a `d`-dimensional
space has purity at least `1/d` (attained by the maximally-mixed state). -/
theorem inv_card_le_purity [Nonempty n] (ρ : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hpsd : ρ.PosSemidef) (htr : ρ.trace = 1) :
    1 / (Fintype.card n : ℝ) ≤ purity ρ hρ := by
  sorry

end PurityBounds
