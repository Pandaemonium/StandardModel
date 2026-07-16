# Null-edge Stage A44N regional covariance implementation control

**Status:** implementation control passed; random benchmark unopened

## Claim boundary

This control constructs a relabeling-covariant set of count-deep pivots for
the compact tapered causal operator and gives exact same-graph covariance
bookkeeping. It does not open a random development or held-out schedule,
compare with continuum targets, prove concentration, or select a physical
probe algebra.

## Order-only pivot selector

For every eligible event, define its global count depth by

\[
  d(x)=\min\{|J^-(x)|,|J^+(x)|\}.
\]

The selector takes the threshold at the requested minimum pivot rank and
retains every event at or above it. All threshold ties are retained. Thus the
selected set depends only on strict order counts and is equivariant under
event relabeling; no coordinate or label tie-break enters.

`Scripts/experiments/causal_regional_operator_covariance.py` computes global
counts in blocks, evaluates the existing A42 compact row at every selected
pivot, and recenters the six polynomial oracle probes at that pivot. The
coordinates evaluate oracle fields but do not select pivots.

## Exact covariance identity

For pivot residuals `r_i`,

\[
  \left(\frac1m\sum_i r_i\right)^2
  =\frac1{m^2}\sum_i r_i^2
   +\frac1{m^2}\sum_i\sum_{j\ne i}r_i r_j.
\]

`PhysicsSM/Draft/NullEdge/RegionalCovariance.lean` proves this finite identity
with the off-diagonal term represented as literal ordered pairs. No
independence, sign, or probabilistic hypothesis is assumed.

The Python ledger uses the equal-realization grand mean, applies the same
identity to every graph, and reports the averaged diagonal, off-diagonal, and
direct regional-mean second moments. Synthetic controls show:

- perfectly shared rows: diagonal `0.5`, off-diagonal `0.5`, total `1.0`,
  effective pivot count `1`;
- perfectly anticorrelated pairs: diagonal `0.5`, off-diagonal `-0.5`, total
  `0`.

These controls ensure that averaging cannot receive independent-row error
bars by construction.

## Verification

- threshold ties are retained;
- global count selection is relabeling covariant;
- the full regional row/field pipeline is relabeling covariant;
- positive and negative off-diagonal controls are preserved;
- a small compact-germ fixture returns finite responses at at least the
  requested pivot count;
- every covariance decomposition closes to below `1e-15`.

Commands:

```text
lake env lean PhysicsSM/Draft/NullEdge/RegionalCovariance.lean
python -m pytest Scripts/experiments/test_causal_regional_operator_covariance.py -q
```

Both passed; the Python suite contains 8 tests.

## Next gate

After the Aristotle variance audit is harvested, append one frozen development
schedule to the A44 protocol and run the compact regional branch on the same
flat polynomial controls intended for the local branch. Report the literal
off-diagonal contribution, effective pivot count, signature, finite-target
bias, and computational cost. No held-out seed may be opened at this control
stage.
