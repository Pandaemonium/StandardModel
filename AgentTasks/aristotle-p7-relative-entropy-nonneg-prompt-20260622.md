# Aristotle prompt: P7 relative-entropy nonnegativity (finite Gibbs)

Please fill the proof holes in:

```text
NullEdgeP7RelativeEntropyNonneg/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Prove (or refute with a counterexample):

```lean
kl_nonneg
kl_self
```

`kl p q = sum_i p i * log (p i / q i)`. Use the standard bound
`Real.log x <= x - 1` (equivalently `Real.add_one_le_exp`), applied to
`log (q i / p i)`, to show `-kl p q <= sum_i (q i - p i) = 1 - 1 = 0`, hence
`kl p q >= 0`. Mind the `Real.log 0 = 0` convention for zero-probability cells.
`kl_self` is immediate since `log (p i / p i) = log 1 = 0`.

## Constraints

- Preserve theorem statements exactly unless genuinely false.
- If false, give the explicit counterexample and corrected hypotheses.
- Do not add assumptions, axioms, or escape hatches.
- Keep the package standalone: Mathlib plus the definitions already in the file.

## Completion report

End with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
