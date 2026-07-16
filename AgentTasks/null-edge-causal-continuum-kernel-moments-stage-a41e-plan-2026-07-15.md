# Null-edge Stage A41e finite-target extension preregistration

**Status:** preregistered before A41e execution and before any A43 random data

## Purpose

Generate the finite Poisson-mean continuum targets required by A43 at exactly
`L/R=0.30,0.25` for both frozen smooth cutoff profiles. These scales were
selected from the exact diagonal variance audit, not from A43 target errors.

A41e is target generation only. A41c remains the asymptotic Lorentzian
principal-symbol gate.

## Frozen computation and gate

Use the A41c segmented continuum implementation, project sign, six polynomial
fields, primary `(0.02,0.08)` and robustness `(0.04,0.12)` profiles, and
Gauss-Legendre orders `160,240`.

A41e passes exactly when the live coefficient convention is correct to
`1e-12` and every low/high quadrature comparison passes. Finite metric,
principal-symbol, and boundary biases are retained in the targets and are not
gates.
