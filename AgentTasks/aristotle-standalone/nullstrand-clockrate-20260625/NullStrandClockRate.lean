import Mathlib

/-!
# NullStrand flux-averaged strand clock rate (manifest node KIN-009)

`finiteFluxMean_dsdt_eq_invGamma`: under flux weighting `π w = ν w · (n·k w)/(n·U)`,
the expected intrinsic strand rate `E[1/(n·k)]` equals `1/(n·U) = 1/γ`. The flux
factor `(n·k w)` cancels the strand-rate denominator pointwise, leaving the total
intrinsic weight `∑ ν w = 1`. This is a one-time KINEMATIC expectation identity
(improved roadmap W8) — it is NOT the pathwise/long-run clock theorem, which needs
a separate ergodic argument.

Mathlib-only; intended as a focused Aristotle target.
-/

namespace NullStrand.ClockRate

open scoped BigOperators
open Finset

/-- Minkowski `(+---)` inner product on real 4-vectors. -/
def minkowskiInner (p q : Fin 4 → ℝ) : ℝ :=
  p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-- KIN-009. The flux-weighted mean of the strand rate `1/(n·k)` is `1/(n·U)`. -/
theorem finiteFluxMean_dsdt_eq_invGamma
    {Ω : Type*} [Fintype Ω]
    (n U : Fin 4 → ℝ) (ν : Ω → ℝ) (k : Ω → (Fin 4 → ℝ))
    (hνsum : ∑ w, ν w = 1)
    (hnU : minkowskiInner n U ≠ 0)
    (hnk : ∀ w, minkowskiInner n (k w) ≠ 0) :
    (∑ w, (ν w * minkowskiInner n (k w) / minkowskiInner n U)
        * (1 / minkowskiInner n (k w)))
      = 1 / minkowskiInner n U := by
  sorry

end NullStrand.ClockRate
