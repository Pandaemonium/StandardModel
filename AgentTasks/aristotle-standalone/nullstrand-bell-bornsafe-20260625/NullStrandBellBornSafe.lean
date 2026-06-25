import Mathlib

/-!
# NullStrand Bell denominator safety (manifest node BELL-002)

`zeroBornWeight_implies_noOutgoingCurrent`: if a configuration has zero Born weight
— i.e. its (Hermitian) projector annihilates the state, `P ψ = 0` — then every Bell
current term sourced there vanishes. This is the lemma that makes the minimal Bell
rates (`current / Born weight`) denominator-safe without relying on division
conventions (improved roadmap §18.1, W11).

Bell current convention: `2 · Im(⟪ψ, (P · X) ψ⟫)`. Mathlib-only; focused Aristotle
target.
-/

namespace NullStrand.BellQFT

open Matrix Complex
open scoped BigOperators

/-- BELL-002. If the Hermitian configuration projector `P` annihilates the state
`ψ` (zero Born weight), then the Bell current `2·Im⟪ψ, (P·X) ψ⟫` sourced at that
configuration is zero, for any operator `X`. -/
theorem zeroBornWeight_implies_noOutgoingCurrent {Q : Type*} [Fintype Q]
    (P X : Matrix Q Q ℂ) (ψ : Q → ℂ) (hP : P.IsHermitian) (hborn : P.mulVec ψ = 0) :
    2 * (star ψ ⬝ᵥ (P * X).mulVec ψ).im = 0 := by
  sorry

end NullStrand.BellQFT
