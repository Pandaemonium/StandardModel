# Aristotle prompt: P7 stochastic L1 contraction (data processing)

Please fill the proof hole in:

```text
NullEdgeP7StochasticContraction/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Prove:

```lean
l1_contracts_under_stochastic
```

For a column-stochastic `T` (nonnegative entries, columns summing to one),
`|sum_j T i j x j| <= sum_j T i j |x j|` by the triangle inequality, and summing
over `i` and swapping the order gives `sum_j (sum_i T i j) |x j| = sum_j |x j|`,
so `l1 (applyMap T x) <= l1 x`.

## Constraints

- Preserve the theorem statement exactly unless it is genuinely false.
- If false, give the explicit counterexample.
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
