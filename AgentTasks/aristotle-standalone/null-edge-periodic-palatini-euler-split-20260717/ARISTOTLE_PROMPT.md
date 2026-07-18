# Aristotle target: split periodic Palatini Euler coefficient

Prove the two remaining theorems in `PeriodicPalatiniEulerSplit/Target.lean`:

1. `derivativeEulerCoefficient_eq_explicit`
2. `algebraicEulerCoefficient_eq_explicit`

The final theorem `connectionEulerCoefficient_eq_explicit_via_split` must then
compile unchanged. Run this narrow check first:

```text
lake env lean PeriodicPalatiniEulerSplit/Target.lean
```

The previous unsplit job proved a useful periodic site-probe summation lemma
but stalled after expanding the full response. This successor has already
proved that the response splits exactly into derivative and algebraic parts.
Use small probe-sum or finite-index helpers as needed.

Do not alter definitions, theorem statements, or index order. Do not assume
metric symmetry, torsion-freeness, connection symmetry, continuum product
rules, or extra geometry. Do not use new assumptions or unresolved proof
placeholders. Finish with a concise report listing solved targets, statement
changes (expected: none), and the narrow verification command run.
