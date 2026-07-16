# Null-edge Stage A44t off-center continuum-target preregistration

**Status:** deterministic target audit passed; per-pivot targets required

## Question

Can the A41d center finite target be reused for order-selected regional pivots,
or must A44N compute a coordinate-oracle finite target for every selected
pivot?

This stage contains no sprinkling data. Coordinates specify deterministic
continuum audit points only and may not later select graph pivots.

## Frozen settings

- marked diamond radius: `1`;
- compact profile: primary `(0.02,0.08)`;
- `L/R=0.20`;
- pivots:
  `center`, `time-0.05`, `time+0.05`, `space-0.05`, `space-0.10`,
  `space-0.15`, `mixed-0.05+0.10`, `mixed+0.05+0.10`;
- low quadrature orders: `(28,36,10,12)`;
- high quadrature orders: `(40,52,14,16)`;
- proper-separation cutoff: `20`.

## Controls and decision rule

Every target must retain signature `(1,3,0)`. Low/high maximum operator
difference must be below `0.02`, and metric Frobenius difference below `0.02`.
The six A42 channels are compared with the high-order center target using the
same normalized RMS score as A42.

The center target is reusable through displacement `0.05` only if every
corresponding pure-time and pure-space audit point has normalized six-field
shift below `0.05` and relative metric shift below `0.05`. Otherwise A44N must
use a per-pivot finite target and report the difference from the center target
as finite boundary bias.

Passing quadrature is only a target-generation control. It is not graph
concentration, intrinsic reconstruction, or GR.

## Verdict

All quadrature and Lorentzian-signature controls pass. The center target fails
the frozen reuse rule. At temporal shifts `-0.05` and `+0.05`, the normalized
six-channel shifts are respectively `0.09` and `0.34`; the corresponding
metric shifts are `0.02` and `0.12`. A spatial shift `0.05` gives shifts
`0.01` and `0.03`. The retarded finite boundary response is therefore strongly
time-asymmetric, and A44N must compute a finite target for every selected
pivot.
