# Aristotle prompt: P9 closed fan positive source

Please fill the proof holes in:

```text
NullEdgeP9ClosedFanPositiveSource/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Prove the finite no-go theorem that visible closure is a rest-frame condition,
not source invisibility:

```lean
closed_visibleFan_mass_pos_of_nonzero_energy
closed_visibleFan_massSource_visible_of_nonzero_energy
```

If the visible closure vector vanishes but total energy is nonzero, the moment
mass square is positive, and the induced one-face source is visible to the unit
test.

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
