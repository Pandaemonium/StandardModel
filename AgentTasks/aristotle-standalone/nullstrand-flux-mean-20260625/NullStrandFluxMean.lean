import Mathlib

/-!
# NullStrand abstract finite flux mean (manifest node KIN-006)

`finiteFluxDirectionMean_eq_relativeVelocity`: for any finite null resolution with
barycenter `U` (weights `ν`, null directions `k`), the flux-reweighted mean
observer direction equals the relative velocity `U/(n·U) − n`. This is the key
kinematic theorem (improved roadmap W2): the flux factor `(n·k)` cancels
pointwise, so the weighted mean depends only on the barycenter `∑ ν w • k w = U`.

Convention: Minkowski `(+---)` inner product on `Fin 4 → ℝ`. The flux weight is
`ν w * (n·k w) / (n·U)` and the observer direction is `k w / (n·k w) − n`.
No probability hypotheses are needed for the algebraic identity — only the
barycenter and the nonvanishing of the energy denominators.

Mathlib-only; intended as a focused Aristotle target.
-/

namespace NullStrand.Flux

open scoped BigOperators
open Finset

/-- Minkowski `(+---)` inner product on real 4-vectors. -/
def minkowskiInner (p q : Fin 4 → ℝ) : ℝ :=
  p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-- KIN-006. The flux-weighted mean observer direction equals `U/(n·U) − n`.

The flux factor `(n·k w)` cancels the energy denominator in the observer
direction `k w/(n·k w) − n`, reducing the sum to `(1/(n·U)) • (∑ ν w • k w) − n`,
and `∑ ν w • k w = U` by `hbary` (the inner-product version
`∑ ν w * (n·k w) = n·U` follows by bilinearity of `minkowskiInner` in its second
slot). -/
theorem finiteFluxDirectionMean_eq_relativeVelocity
    {Ω : Type*} [Fintype Ω]
    (n U : Fin 4 → ℝ) (ν : Ω → ℝ) (k : Ω → (Fin 4 → ℝ))
    (hbary : ∑ w, ν w • k w = U)
    (hnU : minkowskiInner n U ≠ 0)
    (hnk : ∀ w, minkowskiInner n (k w) ≠ 0) :
    (∑ w, (ν w * minkowskiInner n (k w) / minkowskiInner n U) •
        (fun i => k w i / minkowskiInner n (k w) - n i))
      = (fun i => U i / minkowskiInner n U - n i) := by
  sorry

end NullStrand.Flux
