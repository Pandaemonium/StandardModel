# Aristotle prompt: P9 non-collinear visible mass no-go

Please fill the proof holes in:

```text
NullEdgeP9NoncollinearMassNogo/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Prove the finite no-go theorem ranked by the P9 source-visibility audit:
visible non-collinearity gives nonzero mass and a visible source.

The targets are:

```lean
visibleFan_mass_nonneg
visiblePluckerMass_nonzero_of_noncollinear
visiblePluckerMass_source_visible_of_noncollinear
```

For a finite visible fan, `momentMassSq = (E^2 - |C|^2) / 4`, with `E` the total
energy and `C` the weighted closure vector. The key identity is

```text
E^2 - |C|^2 = sum_{i,j} weight i * weight j * (1 - <dir i, dir j>).
```

For unit directions each term is nonnegative by Cauchy-Schwarz, so the moment
mass square is nonnegative. If two cells with positive weight point in different
unit directions, their off-diagonal term is strictly positive, because
`|dir i - dir j|^2 = 2 (1 - <dir i, dir j>) > 0`, so the whole moment mass square
is strictly positive.

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
