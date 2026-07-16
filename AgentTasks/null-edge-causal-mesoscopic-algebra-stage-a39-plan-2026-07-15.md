# Null-edge Stage A39 mesoscopic-algebra preregistration

**Status:** preregistered; no result claimed
**Date:** 2026-07-15

## Objective

Test the first basis-independent mesoscopic function algebra on which the
count-normalized causal operator could converge as a second-order Lorentzian
operator. This is the graph-side prerequisite for the A38 weak Hessian and
`Gamma2` curvature route.

This stage does not estimate curved Ricci, derive dimension or absolute scale,
or claim continuum convergence.

## Candidate algebra

Let `V_L` be the rank-four generator subspace supplied by the simultaneous
Johnston interval embedding. The selected algebra envelope is

\[
  \mathcal A_L^{(2)}=\operatorname{span}
  \{1,V_L,\operatorname{Sym}^2V_L\}.
\]

The object under test is the subspace projector onto this 15-dimensional
envelope, not an ordered coordinate basis. An invertible affine or `GL(4)`
change of generators leaves the envelope unchanged. Orthonormal bases used in
the implementation are numerical gauges only.

The Johnston generator subspace uses only causal order and interval counts
after supplying dimension four, density, interval endpoints, spatial rank
three, and duration. Those supplied inputs remain open debts and prevent this
stage from being a bare-order G2 pass.

## Operator and intrinsic evaluation region

- Use the project-sign smeared four-dimensional causal operator.
- Use the shrinking schedule `L = cL * sqrt(ell * T)`.
- Define the evaluation region from order alone by retaining events with the
  largest values of `min(past_count, future_count)`. Include every event tied
  at the selected boundary, so no label order breaks covariance.
- Remove the multiplication potential by `Box = B - M_(B1)`.

## Diagnostics

For an orthonormal gauge of `V_L` and `A_L^(2)`, report:

1. envelope rank and conditioning;
2. exact generator-product closure into `A_L^(2)`;
3. full envelope-product projection defect;
4. `Box A_L^(2)` projection defect;
5. `Gamma(V_L,V_L)` projection defect;
6. restricted double-commutator multiplication defect on
   `{1,V_L}` test fields;
7. restricted triple-commutator defect on `{1,V_L}`;
8. signature of the evaluation-region mean `Gamma` matrix and the fraction of
   eventwise Lorentzian matrices;
9. determinant-volume variation on the Lorentzian subset;
10. covariance of the envelope projector under an independent `GL(4)` change.

All closure/locality residuals are aggregate relative `L2` norms on the
order-selected evaluation region. Near-zero denominators are reported rather
than silently counted as passes.

## Development split

Use independent flat Minkowski sprinklings at `N=300` and `N=600`, seed
`20261390`, with two realizations per density. Select only:

- `cL` from `{0.45, 0.60, 0.75}`;
- interior retained fraction from `{0.15, 0.25, 0.35}`.

Selection uses the oracle coordinate-generator algebra only. Johnston and
random-subspace scores remain closed. Minimize the worst high/low-density
tuple `(operator closure, Gamma closure, double defect, triple defect)`, after
requiring a rank-15 envelope, Lorentzian mean pairing, and at least 30
evaluation events.

If no setting satisfies the structural requirements, freeze the minimax
failure and report it; do not tune on Johnston results.

## Held-out evaluation

With the setting frozen, use fresh seed `20261400`, four realizations at each
of `N=300` and `N=600`. Evaluate three generator sectors on the same causal
operator and region:

- oracle coordinates, as an implementation/operator control;
- the order-derived Johnston rank-four generator subspace;
- an isotropic random rank-four subspace, as a negative control.

The random control seed is derived from the realization seed and fixed before
any score is opened.

## Pass conditions

All conditions are required for a **conditional A39 algebra pass**:

1. Every oracle and Johnston envelope has rank 15, generator-product closure
   below `1e-10`, and `GL(4)` projector error below `1e-10`.
2. The oracle mean pairing is Lorentzian in every realization and its median
   operator, `Gamma`, double, and triple defects do not worsen when density
   doubles.
3. The Johnston mean pairing is Lorentzian in at least three of four
   realizations at each density, with a nondecreasing eventwise Lorentzian
   fraction.
4. At high density, Johnston beats the random control in median operator,
   `Gamma`, double, and triple defects.
5. At least three of the four Johnston closure/locality medians improve with
   density, and every high-density median is below `0.75`.

## Kill conditions

Kill this degree-two Johnston algebra if the oracle control fails, if the
envelope is rank-deficient or noncovariant, if Johnston is indistinguishable
from the random subspace, or if its locality/closure residuals worsen without
a compensating metric-signature gain. A failure does not kill operator-first
geometry; it kills this generator/envelope/region combination.

Do not enlarge polynomial degree, alter the Johnston rank, fit to the target
metric, or tune the operator on held-out Johnston scores in this stage.

## Successor

Only after a conditional A39 pass may the projected causal `Gamma` field be
fed back through `Box` to form a graph-side weak Hessian and `Gamma2`. The next
stage must first reproduce A38's zero-Ricci nonlinear flat controls before any
curved target or comparison with `-2 B 1` is opened.
