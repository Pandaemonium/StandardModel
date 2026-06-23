# Aristotle prompt: P9 visible-fan mass characterization

Please fill the proof holes in:

```text
NullEdgeP9VisibleFanMassCharacterization/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Complete the finite characterization of visible-fan rest mass. Targets:

```lean
momentMassSq_ge_pair_term
visibleFan_massless_of_collinear
visibleFan_massless_imp_collinear
```

The key identity is

```text
E^2 - |C|^2 = sum_{i,j} weight i * weight j * (1 - <dir i, dir j>),
```

a sum of nonnegative terms for unit directions and nonnegative weights. Hence the
moment mass square dominates any single pair term, and it is zero iff every pair
of positively-weighted cells has `dir i = dir j` (use
`|dir i - dir j|^2 = 2 (1 - <dir i, dir j>)`, so `1 - <dir i, dir j> = 0` iff
`dir i = dir j` for unit vectors; and a sum of nonnegative reals is zero iff each
term is zero).

## Constraints

- Preserve theorem statements exactly unless a statement is genuinely false.
- Do not add assumptions, axioms, or escape hatches.
- Keep the package standalone: Mathlib plus the definitions already in the file.
- You may add local helper lemmas inside the file if helpful.
- If a target is false, explain the counterexample instead of weakening it.

## Completion report

End with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
