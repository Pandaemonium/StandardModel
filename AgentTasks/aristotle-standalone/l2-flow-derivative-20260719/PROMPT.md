# Task: the exact L2 orbit is differentiable at every time (Paper D successor)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper D
(changing-lattice continuum) lane. Self-contained package (25 modules).
The predecessor theorem landed TONIGHT and is included PROVEN + guarded:
`CompactSupportL2Generator.orbit_slope_tendsto` /
`momMultL2Isometry_hasDerivAt_zero` - the strong `Lp` derivative AT ZERO
for bounded-momentum-support elements, by dominated convergence.

## Target

`PhysicsSM/Draft/NullEdge/CompactSupportL2FlowDerivative.lean` - four
theorems ending in a hole:

1. `momMult_add` - pointwise one-parameter group law. `momMult` wraps the
   pointwise matrix exponential family (`ExactFlowGenerator`); the group
   law should follow from the included exponential/flow API (if it already
   exists under another name in the chain, prove by citation and say so).
2. `momMultL2Isometry_add` - the lifted `L2` group law (a.e. representative
   argument through the packaged coeFn lemmas).
3. `boundedSupport_momMultL2Isometry` - the orbit preserves bounded
   momentum support (the multiplier acts fibrewise; support cannot grow).
4. `orbit_slope_tendsto_at` - THE target: the derivative at arbitrary
   `t₀`, by conjugating the landed `t = 0` theorem through the group:
   `U(t₀ + u) f - U(t₀) f = U(t₀) (U(u) f - f)` (group law), then
   continuity/isometry of `U(t₀)` carries the `t = 0` limit to
   `U(t₀) (genRepr ...)`. Mind the smul-commutation through `U(t₀)`
   (complex-linear, so real scalars commute).

## Pre-registered honesty license

If the bounded-support hypothesis must travel differently (e.g. the
`genRepr` of the translated orbit point vs the isometry image of
`genRepr f`), prove the honest variant, rename, and record the change
prominently - the two forms differ by exactly the statement of a
generator-flow commutation, which is itself a fine bonus lemma. A
counterexample to any stated law is a first-class outcome.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Do not modify the included modules.
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/CompactSupportL2FlowDerivative.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

All four theorems (or honestly-corrected versions) proven, zero holes, and
a completion report: solved targets, citations vs new proofs, statement
changes, axioms used.
