# Aristotle prompt: P9 uniform residual-source suppression

Please fill the proof holes in:

```text
NullEdgeP9UniformSuppression/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Prove the finite uniform-amplitude suppression theorem:

```lean
normalizedUniformSecondMoment_eq_totalSq_div_card
```

If a fixed total source scale `A` is spread uniformly over `N` independent
two-sign cells, each cell has amplitude `A / N`; the normalized second moment
should be `A^2 / N`. This is the finite algebraic version of a large-`N`
suppression mechanism for the P9 cosmological-constant/source-visibility branch.

## Constraints

- Preserve theorem statements exactly unless a statement is genuinely false.
- Do not add assumptions, axioms, or escape hatches.
- Keep the package standalone: Mathlib plus the definitions already in the file.
- You may add local helper lemmas inside the file if helpful.

## Completion report

End with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
