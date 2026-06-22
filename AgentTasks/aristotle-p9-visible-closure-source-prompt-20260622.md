# Aristotle prompt: P9 finite visible-closure source guardrail

You are working in a focused Lean 4 package, not the full `PhysicsSM` repo.

Target file:

```text
NullEdgeP9VisibleClosureSource/Finite.lean
```

Please fill the four proof holes in that file. The mathematical goal is a small
finite guardrail for the P9 cosmological-constant/source-visibility branch:

- two opposite unit celestial directions have zero visible closure;
- nevertheless their celestial moment mass square is `1`;
- using that mass as a one-face source gives a visible positive source pairing.

This should remain a finite toy theorem. It prevents us from confusing visible
momentum closure with source invisibility.

Important constraints:

- Do not weaken theorem statements.
- Do not change definitions unless you discover a real mathematical or Lean API
  problem; if so, explain the issue before changing anything.
- Do not add fake assumptions or escape-hatch declarations.
- Prefer small helper lemmas if they make the proof stable.
- The intended command is:

```text
lake env lean NullEdgeP9VisibleClosureSource/Finite.lean
```

At the end, please include a short report with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
