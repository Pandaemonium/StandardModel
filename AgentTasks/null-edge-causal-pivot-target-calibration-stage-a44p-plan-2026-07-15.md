# Null-edge Stage A44p selected-pivot target calibration preregistration

**Status:** target gate passed; one-graph residual remains large

## Question

For the measured-feasible `N=100000` regional backend, how far do the actual
order-selected pivots lie from the marked center, how much do their certified
finite continuum targets vary, and what residual remains after comparing each
row with its own target?

This is one development graph. It calibrates target construction and cannot
establish variance, concentration, or a branch pass.

## Frozen settings

- seed: `20261550`;
- random events: `100000` in the duration-`2` flat diamond;
- primary compact cutoff `(0.02,0.08)`;
- `L/R=0.20`;
- minimum 16 tied-depth order-selected pivots;
- packed relation blocks `32 x 4096`, popcount block `128`;
- expanded row fields: constant, all four affine coordinates, all ten
  symmetric quadratic products, `t^3`, and `t*x^2`;
- low target orders `(28,36,10,12)`;
- high target orders `(40,52,14,16)`;
- proper-separation cutoff `20`.

## Target gate

1. Every expanded row and target is finite.
2. Every high target has signature `(1,3,0)`.
3. Per-pivot low/high maximum operator difference is below `0.02`, and metric
   Frobenius difference is below `0.02`.
4. Packed file size remains exact and the selected set contains at least 16
   pivots.

Operator residuals have no pass threshold in this calibration. The artifact
must report per-pivot coordinate displacement, count depth, continuum depth,
center-target shift, full metric/signature, expanded normalized error, and the
literal diagonal/off-diagonal decomposition of each within-graph residual
mean. The temporary packed relation is deleted after the run.

No held-out seed or `N=400000` run is authorized.

## Verdict

The target gate passes. Sixteen tied-depth pivots are selected, all finite
targets are Lorentzian, and the worst low/high target differences are `0.0107`
for an operator channel and `0.00081` for the metric. Selected spatial offsets
reach `0.177R`, confirming that per-pivot targets are load-bearing.

The one-graph regional mean is Lorentzian but has full metric error `0.546` and
expanded operator error `1.370`. Fourteen of sixteen individual row metrics are
Lorentzian. Major residual channels have empirical effective pivot counts only
around `4-12`, so the nominal 16-pivot average does not behave independently.
No physical pass is claimed; a multi-graph development covariance stage is the
next statistical gate.
