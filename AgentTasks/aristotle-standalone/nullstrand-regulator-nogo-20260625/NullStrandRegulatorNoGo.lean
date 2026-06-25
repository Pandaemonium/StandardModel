import Mathlib

/-!
# NullStrand regulator no-go (manifest node KIN-010)

`uniformComponent_bounds_meanNorm`: a finite probability law on unit directions
that contains an `ε`-fraction of a mean-zero uniform component cannot have a
mean-direction norm exceeding `1 - ε`. This is the finite, kernel-checkable core
of the "exact mean matching is incompatible with a uniform positive floor"
guardrail (improved roadmap §7.1).

Convention: directions live in a real normed space `E`; the law is given as an
explicit convex combination `ε • u + (1 - ε) • q` of two finite probability
weight functions `u, q : Ω → ℝ`, where `u` is the uniform/floor component with
zero mean.

Proof strategy (manifest): the mean splits as
`ε • (∑ u ω • dir ω) + (1 - ε) • (∑ q ω • dir ω)`; the first term vanishes by
`hu_mean`, and `‖(1 - ε) • ∑ q ω • dir ω‖ ≤ (1 - ε) • ∑ q ω • ‖dir ω‖ = 1 - ε`
by the triangle inequality and `‖dir ω‖ = 1`, `∑ q ω = 1`, `0 ≤ q ω`.

This file imports only Mathlib and is intended as a focused Aristotle target.
-/

namespace NullStrand.RegulatorNoGo

open scoped BigOperators
open Finset

/-- KIN-010. A finite probability law on unit directions with a mean-zero
`ε`-uniform component has mean-direction norm at most `1 - ε`. -/
theorem uniformComponent_bounds_meanNorm
    {Ω : Type*} [Fintype Ω] {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (dir : Ω → E) (hdir : ∀ ω, ‖dir ω‖ = 1)
    (u q : Ω → ℝ) (ε : ℝ) (hε0 : 0 ≤ ε) (hε1 : ε ≤ 1)
    (hu_mean : ∑ ω, u ω • dir ω = 0)
    (hq_nonneg : ∀ ω, 0 ≤ q ω) (hq_sum : ∑ ω, q ω = 1) :
    ‖∑ ω, (ε * u ω + (1 - ε) * q ω) • dir ω‖ ≤ 1 - ε := by
  sorry

end NullStrand.RegulatorNoGo
