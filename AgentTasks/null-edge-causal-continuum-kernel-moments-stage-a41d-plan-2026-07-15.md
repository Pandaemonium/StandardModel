# Null-edge Stage A41d finite-target extension preregistration

**Status:** preregistered before A41d execution and before any A42 data

## Purpose

Generate the two finite continuum targets required by the already frozen A42
discrete-germ protocol. The passing A41c artifact omitted `L/R=0.20`; therefore
A41d evaluates exactly `L/R=0.20,0.16` for both frozen smooth cutoff profiles.

This is a numerical target-generation task, not a new asymptotic physics gate.
The A41c pass remains the evidence for small-scale convergence.

## Frozen computation

Use the A41c continuum code, project sign, Poisson-averaged kernel, marked flat
diamond, six polynomial fields, exact outer cutoff-intersection segments, and
inner proper-variable segments. Use Gauss-Legendre orders `160,240` and the
frozen primary `(0.02,0.08)` and robustness `(0.04,0.12)` profiles.

## Pass gate

A41d passes exactly when:

1. the live project coefficient relative error is at most `1e-12`;
2. low/high quadrature agreement passes for both ratios and both profiles.

Metric accuracy, principal-symbol accuracy, lower-order residuals, and
small-scale reduction are reported but are not A41d gates. Those quantities
were tested by A41c and would be inappropriate target-generation filters here.

The resulting order-`240` values may be read by A42 only if the artifact is
marked `target_only` and passes this gate.
