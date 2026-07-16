# Null-edge Stage A41b small-scale continuum moment preregistration

**Status:** preregistered after the frozen A41 revise result; no A41b result claimed

## Question

After resolving the known cutoff branch surfaces exactly, do both fixed smooth
Alexandrov germs enter the asymptotic scalar-operator window at smaller `L/R`,
with vanishing lower moments and a common Lorentzian quadratic normalization?

## Locked implementation

- Use the same exact Poisson-averaged kernel, project sign, marked interval,
  polynomial classes, and cutoff profiles as A41.
- The discrete/continuum coefficient test must agree to `1e-12` relative and
  absolute tolerance before quadrature is evaluated.
- Split the transformed proper-variable integral exactly where each frozen
  cutoff changes between zero, transition, and one. This changes only the
  deterministic integration partition.
- Do not fit or apply a scalar, rank-one, drift, or potential correction.
- Use the high-order result as the reported value; the low order is an
  independent convergence check.

## Frozen settings

```text
primary cutoff:    (d0,d1) = (0.02,0.08)
robustness cutoff: (d0,d1) = (0.04,0.12)
L/R:               0.16, 0.125, 0.10, 0.08, 0.065
quadrature orders: 160, 240 per analytic segment
proper variable:   w <= 20
```

The no-cutoff interval indicator remains a diagnostic negative/boundary
control and cannot establish the smooth compact-support theorem interface.

## Principal-symbol gate

For direct quadratic responses `Btt = B(t^2)` and `Bxx = B(x1^2)`, define

```text
Delta_ps = |Btt + Bxx| / (|Btt| + |Bxx|).
```

This is the sign-independent scalar-normalization obstruction derived in the
Aristotle audit. If `Delta_ps` has a positive asymptotic floor, no scalar can
match temporal and spatial responses simultaneously. The direct project
normalization is stronger: it should approach `(2,-2)` without rescaling.

## Pass gate

Both smooth profiles must satisfy all conditions:

1. every low/high field comparison passes relative tolerance `2e-5` or
   absolute tolerance `2e-6` near zero;
2. the final induced metric has signature `(+---)`;
3. final relative metric error is below `0.06`;
4. final temporal/spatial response-ratio error is below `0.10`;
5. final `Delta_ps` is below `0.05`;
6. final constant, affine-time, and both nontrivial cubic residuals are each
   below `0.15`;
7. metric error and maximum zero-target residual decrease by at least `50%`
   from `L/R=0.16` to `L/R=0.065`;
8. the live coefficient convention test remains exact and no fitted
   correction appears in the artifact.

## Branching rule

- If quadrature still fails, stop physics interpretation and replace the
  deterministic integration method or use controlled higher precision.
- If quadrature passes but `Delta_ps` or the direct metric has a nonzero wrong
  limit, kill scalar normalization for this kernel/germ family.
- If the tensor passes but lower moments fail to decay, retain the principal
  symbol only and reject weak Hessian/Ricci use at this scale schedule.
- If all gates pass, open A42 on random flat sprinklings with the exact marked-
  diamond count-depth cutoff and protected-core API. Curved data remain closed.

No A41b outcome is a graph reconstruction or continuum-GR derivation.
