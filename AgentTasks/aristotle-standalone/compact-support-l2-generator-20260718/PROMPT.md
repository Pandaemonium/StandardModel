# Task: strong Lp derivative of the exact momentum-multiplier orbit (Paper D)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper D
(changing-lattice continuum limit) lane. Self-contained package (24 modules
of the landed changing-cell / momentum-multiplier analysis layer).

## Target

`PhysicsSM/Draft/NullEdge/CompactSupportL2Generator.lean` - the single
theorem ending in a hole:

`orbit_slope_tendsto`: for `f` in `Lp Spinor 2` with bounded momentum
support `R`, and any real sequence `u n → 0` through nonzero values, the
`Lp` difference quotients `(u n)⁻¹ • (momMultL2Isometry m (u n) f - f)`
converge in `Lp` norm to the packaged generator element
`genRepr m R f hf`.

## Landed infrastructure to use (all in the package, PROVEN)

- `momMultL2Isometry` - the exact unitary momentum-multiplier orbit.
- `genMult`, `genRepr`, `genMult_apply_memLp`, `genRepr_coeFn` (items 1-3
  of this file) - the generator multiplier, its membership, and its a.e.
  representation.
- `HermitianExpLipschitz` - Lipschitz/derivative bounds for the pointwise
  matrix exponential; `MomMultL2StrongContinuity` - the strong-continuity
  layer; `SobolevTailRate` and the bounded-support lemmas for domination.

Intended route (standard, but the details are the work): on the bounded
support the pointwise difference quotient converges to `genMult m k (f k)`
with a UNIFORM Lipschitz/second-order bound (from the Hermitian exponential
layer), so dominated convergence in `L2` over the finite-measure support
region gives the `Lp` limit; outside the support everything vanishes.
Prove through `Lp` coercion lemmas (`Lp.tendsto_iff` style / `snorm`
convergence); the a.e. representative equalities are already packaged.

## Pre-registered honesty license

If the statement needs a strengthened hypothesis (e.g. a specific
measurability side condition already derivable in the package), derive it
rather than adding it; if a genuine gap in the packaged API blocks the
route, prove the strongest partial result (e.g. convergence along the
specific sequence classes needed downstream) and report the exact missing
lemma precisely.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Do not modify the other included modules.
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/CompactSupportL2Generator.lean`
  first; avoid a full `lake build` until the hole is closed.

## Success criteria

`orbit_slope_tendsto` proven with zero holes (or the strongest partial
with a precise missing-lemma report), plus a completion report: route
taken, helper lemmas added, axioms used.
