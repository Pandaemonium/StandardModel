# Aristotle prompt: P9 finite boundary-source invisibility core

You are working in a focused Lean 4 package, not the full `PhysicsSM` repo.

Target file:

```text
NullEdgeP9BoundarySource/Finite.lean
```

Please fill the five proof holes in that file. The mathematical goal is a
finite integration-by-parts lemma and its first source-visibility corollaries:
boundary-generated source data should pair trivially with every bulk test whose
adjoint divergence vanishes.

Important constraints:

- Do not weaken theorem statements.
- Do not change definitions unless you discover a real mathematical or Lean API
  problem; if so, explain the issue before changing anything.
- Do not add fake assumptions or escape-hatch declarations.
- Prefer small helper lemmas if they make the proof stable.
- The intended command is:

```text
lake env lean NullEdgeP9BoundarySource/Finite.lean
```

At the end, please include a short report with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
