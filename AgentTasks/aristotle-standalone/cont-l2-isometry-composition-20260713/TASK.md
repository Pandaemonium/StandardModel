# Aristotle target: variable pointwise L2 composition

## Objective

Prove the three immutable declarations in
`VariablePointwiseL2Composition.lean`:

- `variablePointwiseL2Isometry_comp`;
- `variablePointwiseL2Isometry_comp_id_control`;
- `variablePointwiseL2Isometry_comp_neg_control`.

The completed foundational lift is included in the file. Preserve every target
signature. Use representative-safe `Lp.ext` and almost-everywhere coercion
lemmas; do not assert pointwise equality of arbitrary `Lp` classes.

## Scientific role

This is a generic functional-analytic rung for the null-edge continuum program.
Once the finite-dimensional exact multiplier satisfies its pointwise time-group
law, this theorem lifts that law to the momentum-space `L2` evolution without
choosing representatives. It does not itself prove the multiplier group law,
Fourier transport, a generator identity, or a position-space PDE.

## Non-degeneracy controls

The identity/identity and negative-identity/negative-identity specializations
must both reduce to the identity on `L2`. These controls ensure the theorem
tracks the supplied operator families and their order.

## Trust boundary

No new assumptions, `native_decide`, unsafe declarations, or statement
weakening. The final file should use only ordinary Mathlib axioms.
