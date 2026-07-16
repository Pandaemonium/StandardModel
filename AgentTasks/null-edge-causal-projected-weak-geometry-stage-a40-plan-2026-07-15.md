# Null-edge Stage A40 projected weak-geometry preregistration

**Status:** preregistered; no result claimed
**Date:** 2026-07-15

## Objective

Test whether A39 failed because it demanded strong eventwise locality where the
causal operator supports only a projected weak calculus at current density.
Construct weak Hessian, `Gamma2`, and Ricci entirely inside the same rank-15
degree-two algebra envelope.

No curved target is opened in this stage.

## Frozen algebra

Retain

\[
  \mathcal A_L^{(2)}=\operatorname{span}
  \{1,V_L,\operatorname{Sym}^2V_L\}
\]

from A39. Do not increase polynomial degree, change supplied rank, or select an
ordered coordinate basis. Let `P_L` be its count-`L2` orthogonal projector on
the order-depth region.

Define

\[
\begin{aligned}
  \Box_L^w f &=P_L\Box_L f,\\
  \Gamma_L^w(f,h)&=P_L\Gamma_L(f,h),\\
  H_f^w(g,h)&=\frac12\left[
    \Gamma^w(g,\Gamma^w(f,h))
    +\Gamma^w(h,\Gamma^w(f,g))
    -\Gamma^w(f,\Gamma^w(g,h))\right],\\
  \Gamma_{2,L}^w(f,h)&=\frac12\left[
    \Box^w\Gamma^w(f,h)
    -\Gamma^w(f,\Box^w h)
    -\Gamma^w(h,\Box^w f)\right].
\end{aligned}
\]

When the weak `Gamma` matrix is Lorentzian, contract Hessians with its inverse
and define the weak Ricci remainder by the polarized Bochner identity.

## Intrinsic evaluation orbit

Within the A39 order-depth region, evaluate on every event maximizing
`min(past_count,future_count)`. Average over the full tied orbit. This selects
no event by label and is exactly relabeling-covariant.

## Flat chart controls

Use three supplied generator sectors on the same flat sprinkling:

- affine Minkowski coordinates;
- temporal quadratic coordinates with `Q^0_00=0.8`;
- shear quadratic coordinates with `Q^0_11=1.5`.

The nonlinear charts have nonzero weak-Hessian/connection signals but exactly
zero continuum Ricci curvature. Returning zero Hessian is not an admissible
pass.

## Development split

Use `N=300,600`, two realizations per density, seed `20261410`, the A39 grids

```text
cL in {0.45, 0.60, 0.75}
retained depth fraction in {0.15, 0.25, 0.35}
```

and all three oracle flat charts. Johnston and random-subspace scores remain
closed. Require rank 15, a Lorentzian weak metric on the deepest orbit, and a
nonzero Hessian in both nonlinear charts. Among structurally admissible
settings, minimize the worst tuple

```text
(weak Ricci cancellation residual,
 weak triple-commutator defect,
 weak double-multiplication defect,
 strong Gamma-closure defect).
```

If none is admissible, freeze the minimax failure without opening Johnston.

## Held-out evaluation

Use fresh seed `20261420`, four realizations at both densities. Evaluate:

- the three oracle flat charts;
- the order-derived Johnston generator subspace;
- an isotropic random rank-four negative control.

Report strong A39 diagnostics beside weak double/triple defects, weak metric
signature and conditioning, Hessian norm, `Gamma2` norm, weak Ricci norm and
relative cancellation residual, and weak scalar curvature.

## Pass conditions

All are required for a **conditional A40 weak-calculus pass**:

1. Every oracle and Johnston envelope has rank 15 and affine `GL(4)` projector
   error below `1e-10`.
2. Every oracle chart has a Lorentzian deepest-orbit weak metric in at least
   three of four realizations at each density.
3. Both nonlinear oracle charts have nonzero median Hessian norm, and every
   high-density oracle weak-Ricci cancellation median is below `0.50`.
4. The worst oracle weak-Ricci median improves when density doubles.
5. Oracle weak double and triple defects are below their strong counterparts
   at both densities, and both high-density weak medians are below `0.50`.
6. Johnston has a Lorentzian weak metric in at least three of four
   high-density realizations, a high-density weak-Ricci median below `0.75`,
   and beats the random sector in strong `Gamma` closure, weak double defect,
   weak triple defect, and weak Ricci cancellation.

## Kill conditions

Kill the projected degree-two weak calculus if oracle nonlinear flat charts
produce spurious Ricci, if weak projection does not improve commutator
locality, if Hessians collapse to zero, or if Johnston remains
indistinguishable from random fields. Such a failure leaves A38 as a supplied-
operator identity and sends the graph-side program to a genuinely local germ
or analytic kernel-normalization construction.

## Successor

Only after this flat gate passes may a curved weak-Ricci target be opened and
compared with the scalar causal-operator channel `-2 B 1`. Holonomy curvature
remains an independent later leg.
