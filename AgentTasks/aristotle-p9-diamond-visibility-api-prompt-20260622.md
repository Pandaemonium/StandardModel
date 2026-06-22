# Aristotle prompt: P9 finite diamond-source visibility API

You are working in a focused Lean 4 package, not the full `PhysicsSM` repo.

Target file:

```text
NullEdgeP9DiamondVisibility/Finite.lean
```

Please fill the five proof holes in that file. The mathematical goal is a small
finite source-visibility API:

- boundary-exact source data are invisible to closed bulk tests;
- the one-face no-boundary model has a visible source that is not boundary-exact.

The second item is important: it prevents the P9 cosmological-constant branch
from becoming tautological by declaring every source invisible.

Important constraints:

- Do not weaken theorem statements.
- Do not change definitions unless you discover a real mathematical or Lean API
  problem; if so, explain the issue before changing anything.
- Do not add fake assumptions or escape-hatch declarations.
- Prefer small helper lemmas if they make the proof stable.
- The intended command is:

```text
lake env lean NullEdgeP9DiamondVisibility/Finite.lean
```

At the end, please include a short report with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
