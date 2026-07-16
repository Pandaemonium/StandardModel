# Claude adversarial review: MarkedPoissonConfigurationInvariance (0775680f)

- Reviewer: interactive Claude Code (claude family), adversarial
- Work item: `L0-DIST-001`; Source sha256 f528dd6d... verified (127 lines)
- Date: 2026-07-13

## Verdict: ACCEPT

Marked/equivariant extension: an equivariant deterministic mark upgrades base-law
invariance to invariance of the whole marked mixed-Poisson configuration law.

## The six checks

1. **`Measure.map` composition orientation in `markedPointLaw_measurePreserving`.**
   `(P.map (markPoint d)).map (pointProductMap T S) = P.map (pointProductMap ∘
   markPoint d)` (`map_map`); then `hcomp : pointProductMap T S ∘ markPoint d =
   markPoint d ∘ T` (needs equivariance); then `= (P.map T).map (markPoint d) =
   P.map (markPoint d)` via `hT.map_eq`. Left-to-right `map_map` orientation
   correct.
2. **Explicit equivariance sufficient and genuinely used.** `heq : d (T x) = S
   (d x)` is the pivot of `hcomp` (`(T x, S(d x)) = (T x, d(T x))`); without it
   the composition identity fails. Sufficient (proof closes with `heq` + `hT` +
   measurability) and load-bearing. Docstring correctly stresses it is an
   explicit REQUIRED hypothesis ("invariance of the unmarked point process does
   not manufacture an invariant decoration").
3. **`IsProbabilityMeasure` of the pushed-forward graph law.** `hprob` via
   `Measure.isProbabilityMeasure_map (measurable_markPoint d hd).aemeasurable`.
   Correct.
4. **Whole Poisson count mixture, not one-point.** `markedConfigLaw_invariant`
   applies `FinitePoissonConfigurationInvariance.configLaw_invariant` to the
   marked-point law and the `pointProductMap` measure-preservation. `configLaw`
   is `poissonMeasure.bind (...)`; `configLaw_invariant` transports the ENTIRE
   mixture (count + i.i.d. marked points), not just a one-point marginal.
5. **Non-vacuity of the Boolean witness.** `bool_product_action_nontrivial`:
   `pointProductMap Bool.not Bool.not (false,false) = (true,true)` by `rfl` (the
   action genuinely moves a point); axiom-free. Plus `identity_decoration_equivariant`
   (identity control).
6. **Overclaim modes + boundary.** Docstring: "finite-volume and distributional;
   it does not construct an infinite-volume process, a Lorentz action, or a
   physical frame field." Vacuity/hollow/overreach/false-shape all clear.

## Verification

- `lake build ...MarkedPoissonConfigurationInvariance`: exit 0 (8027 jobs).
  Three `#guard_msgs` fired; two `[propext, Classical.choice, Quot.sound]`, and
  `bool_product_action_nontrivial` correctly pinned as depending on NO axioms.

## Narrowest claim

For a base probability law `P` with a measure-preserving symmetry `T`, a
measurable mark action `S`, and a measurable EQUIVARIANT decoration `d`
(`d(T x) = S(d x)`), the induced product action preserves the entire marked
mixed-Poisson finite configuration law in distribution (including the Poisson
count mixture). Finite-volume, distributional; no infinite-volume process,
Lorentz action, or physical frame field.
