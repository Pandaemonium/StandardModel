# Aristotle target: four-dimensional two-minor cofactor identity

Run this narrow command first:

```text
lake env lean PalatiniTwoMinor/Target.lean
```

Prove `PalatiniTwoMinor.alternating_coframe_two_minor` exactly as stated.
Do not weaken or change the theorem, definitions, index order, orientation,
sign, determinant factor, or inverse hypotheses. Do not add assumptions or
new declarations that bypass the proof obligation.

This is the sole remaining helper in a larger Palatini-density proof. The
target is the standard four-dimensional complementary-minor identity for an
invertible matrix, written with explicit finite sums and the polynomial
alternating symbol normalized by `epsilon 0 1 2 3 = +1`.

Promising routes include:

1. a Jacobi complementary-minor or adjugate identity after deriving the
   supplied matrix as the nonsingular inverse;
2. determinant multilinearity or an exterior-square/Cauchy-Binet argument;
3. a fixed-`Fin 4` exhaustive proof using determinant expansion and the two
   inverse equations.

Small reusable helper lemmas are welcome. Keep every proof kernel-checked and
finish by running the narrow command. Report the proof route and any remaining
diagnostics.
