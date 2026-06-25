import Mathlib

/-!
# NullStrand boundary no-go (manifest node KIN-011)

`meanNorm_eq_one_implies_support_collinear`: a finite probability law on unit
directions in a real inner-product space whose mean has norm exactly `1` must be
supported on a single direction — every pair of directions with positive weight
coincides. This is the equality/strict-convexity companion to KIN-010
(`uniformComponent_bounds_meanNorm`): the massless limit can only be reached by a
Dirac (single-direction) law, not by a uniformly elliptic family.

Proof strategy (manifest): expand `‖∑ p ω • dir ω‖² = ∑_{ω,ω'} p ω p ω' ⟪dir ω, dir ω'⟫`
and `1 = (∑ p ω)²`; Cauchy–Schwarz gives `⟪dir ω, dir ω'⟫ ≤ 1` with equality iff
`dir ω = dir ω'` (unit vectors), so `1 = ∑∑ p p ⟪,⟫ ≤ ∑∑ p p = 1` forces
`⟪dir ω, dir ω'⟫ = 1` on the positive-weight support, hence equality of directions.

Mathlib-only; intended as a focused Aristotle target.
-/

namespace NullStrand.BoundaryNoGo

open scoped BigOperators RealInnerProductSpace
open Finset

/-- KIN-011. A finite unit-direction probability law with mean-norm one is
supported on a single direction. -/
theorem meanNorm_eq_one_implies_support_collinear
    {Ω : Type*} [Fintype Ω] {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (dir : Ω → E) (hdir : ∀ ω, ‖dir ω‖ = 1)
    (p : Ω → ℝ) (hp : ∀ ω, 0 ≤ p ω) (hsum : ∑ ω, p ω = 1)
    (hmean : ‖∑ ω, p ω • dir ω‖ = 1) :
    ∀ ω ω', 0 < p ω → 0 < p ω' → dir ω = dir ω' := by
  sorry

end NullStrand.BoundaryNoGo
