# Null-edge Stage A41c fully segmented quadrature preregistration

**Status:** preregistered after A41b quadrature-only failure; no A41c result claimed

## Locked change

A41c changes only the deterministic integration partition. Retain all A41b
physics settings, fields, cutoffs, scales, quadrature orders, targets, and pass
thresholds exactly.

For each frozen cutoff depth `d` in `{d0,d1}`, split the outer retarded-time
integral at the analytic intersections

```text
u_null(d) = (R/2) [1 - sqrt(d)],
u_axis(d) = R [1 - d^(1/4)],
```

together with `u=0`, `R/2`, and `R`. Continue to split every inner proper-
variable integral at the exact `d0,d1` surfaces. Apply orders `160` and `240`
separately on every resulting analytic cell.

No output from A41b selects or changes these intersections; they follow
algebraically from the already frozen endpoint-depth cutoff.

## Frozen settings and gates

```text
cutoffs:            (0.02,0.08), (0.04,0.12)
L/R:                0.16, 0.125, 0.10, 0.08, 0.065
quadrature orders:  160, 240 per analytic cell
w cutoff:           20
metric error:       < 0.06
response ratio:     < 0.10
Delta_ps:           < 0.05
max zero residual:  < 0.15
minimum reductions: 50%
quadrature:         relative 2e-5 or absolute 2e-6 near zero
```

The live coefficient error must remain below `1e-12`, every final metric must
have signature `(+---)`, and no fitted correction is permitted.

## Branching rule

- If every gate passes, the deterministic normalization stage closes and A42
  may test the same moments on random flat marked diamonds.
- If physical moments pass but quadrature still fails, do not claim closure;
  move to adaptive or higher-precision integration.
- If converged quadrature violates `Delta_ps` or the metric target, kill the
  scalar-normalization route for this kernel/germ family.

No curved or GR-dynamics data are opened in A41c.
