# Null-edge Einstein action variation audit

## Objective

Design the smallest honest next theorem package that could connect a
graph-native interval-count gravitational action to
`EinsteinEquationVariation.actionMetricStationary_iff_finiteEinsteinEquation`.
The requested result is a strategy and statement audit, not permission to
rename an existing finite avatar as a derivation.

## Current exact endpoint

`EinsteinEquationVariation.lean` proves:

1. vanishing of the normalized Einstein-matter pairing against every symmetric
   component variation is equivalent to
   `G + Lambda g = kappa T` for nonzero `kappa`;
2. if an actual finite action has that pairing as every symmetric directional
   derivative, ordinary action stationarity is equivalent to the same tensor
   equation;
3. the explicit finite contracted Bianchi identity plus a differentiated field
   equation forces source conservation.

The derivative formula remains a premise. No graph action presently discharges
it.

## Non-solutions

- `EinsteinHilbertTerm.lean` is a two-by-two rational spectral polynomial in one
  decoration. Its own module calls it a finite avatar rather than a genuine
  heat-kernel coefficient. It must not be promoted to a graph-derived
  Einstein-Hilbert action.
- The FLRW action is imported continuum minisuperspace input. It is a physical
  control, not the sought graph derivation.
- A scalar residual or one-parameter stationarity equation cannot identify a
  rank-two tensor.
- A Benincasa-Dowker operator formula alone is not an action-variation theorem.

## Required output

Create `ARISTOTLE_ACTION_VARIATION_AUDIT.md` with the following sections.

1. **Verdict.** State whether the current repository contains any action that
   can honestly discharge `HasEinsteinMetricFirstVariation`. Cite exact files
   and declarations.
2. **Minimal finite architecture.** Specify the primitive finite data, the
   interval-count action, boundary data, cosmological term, matter coupling,
   and independent variation variable. Explain how the operator-derived metric
   enters without introducing a second metric.
3. **Lean-ready theorem ladder.** Give precise proposed definitions and theorem
   signatures for:
   - a finite graph action and its genuine directional derivative;
   - identification of that derivative with a finite Einstein coefficient;
   - the matter first variation on the same geometry;
   - action stationarity implying the existing finite Einstein equation;
   - convergence of the action;
   - convergence of first variations or a theorem interchanging variation and
     refinement limit.
   Keep finite algebra, probabilistic convergence, and continuum reconstruction
   in separate statements.
4. **First executable target.** Select one theorem small enough to formalize
   next without assuming the desired Einstein tensor. Include its exact success
   criterion and a nonvacuity witness.
5. **Kill conditions.** List conditions that would show the chosen finite
   action or variation variable is incapable of producing the full tensor
   equation.
6. **Literature alignment.** Use the supplied context pack to identify which
   claims are imported from causal-set action literature and which would be new
   to this program. Do not rely on an abstract alone for a technical claim.

## Review constraints

- Preserve the mostly-minus convention and the sign convention in
  `EinsteinEquationVariation.lean`.
- Treat the causal-operator metric as the sole physical metric candidate.
- Make boundary terms and the cosmological term explicit.
- Distinguish manifold-conditioned convergence from dynamical selection of a
  manifoldlike phase.
- Flag any theorem that would require an unstated analytic or probabilistic
  assumption.
- Finish with a concise recommendation: implement, preregister an experiment,
  seek a missing literature theorem, or stop because the proposed bridge is
  structurally circular.
