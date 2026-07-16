# Aristotle target: strong continuity of the exact L2 multiplier orbit

## Objective

Prove the three unchanged declarations in `MomMultL2StrongContinuity.lean`:

- `momMult_zero_time`;
- `momMultL2Isometry_zero_time`;
- `momMultL2Orbit_continuous`.

The first two are exact identity controls. The third is the main analytic gate.
It states strong continuity for each fixed `L2` state, not operator-norm
continuity. A likely route is pointwise time continuity of `exactFlow`, exact
norm preservation, and `Lp` dominated convergence.

## Scope

Do not strengthen the statement to operator-norm continuity on the full
momentum space. Do not claim a time-group law, generator theorem, Fourier
transport, position-space PDE, continuum limit, or Lorentz restoration.

## Trust discipline

Preserve all signatures and use the live `momMult`/`momMultL2Isometry`
definitions. Do not add assumptions, trust-expanding evaluators, or unsafe
declarations.
