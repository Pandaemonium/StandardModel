# Aristotle prompt: P9 finite BF-closure / no-bulk source core

You are working in a focused Lean 4 package, not the full `PhysicsSM` repo.

Target file:

```text
NullEdgeP9BFClosure/Finite.lean
```

Please fill the three proof holes in that file. The mathematical goal is the
finite chain-complex identity behind the P9 source-visibility program:
successive boundary maps compose to zero, so a twice-boundary source is invisible
to all finite bulk pairings.

Important constraints:

- Do not weaken theorem statements.
- Do not change definitions unless you discover a real mathematical or Lean API
  problem; if so, explain the issue before changing anything.
- Do not add fake assumptions or escape-hatch declarations.
- Prefer small helper lemmas if they make the proof stable.
- The intended command is:

```text
lake env lean NullEdgeP9BFClosure/Finite.lean
```

At the end, please include a short report with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
