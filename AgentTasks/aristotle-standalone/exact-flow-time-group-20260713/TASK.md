# Aristotle target: exact-flow time-group law

## Objective

Prove the three unchanged declarations in `ExactFlowTimeGroup.lean`:

- `exactFlow_add_time`;
- `exactFlow_mul_neg_time`;
- `exactFlow_neg_time_mul`.

The likely route is to expand `exactFlow`, rewrite the exponent at `s+t` as the
sum of two scalar multiples of the same generator, prove those two matrices
commute, and apply `Matrix.exp_add_of_commute` or
`NormedSpace.exp_add_of_commute`. The inverse controls may follow from the group
law and the existing zero-time theorem.

## Scientific boundary

This is the pointwise finite-dimensional matrix time-group law only. Do not
claim an `L2` group, strong time continuity, Stone's theorem, a generator
identity, Fourier transport, or the Dirac PDE.

## Trust and statement discipline

Preserve all target signatures. Do not add hypotheses or assumptions, use
trust-expanding evaluators, introduce unsafe declarations, or replace the live
`exactFlow` with a surrogate.
