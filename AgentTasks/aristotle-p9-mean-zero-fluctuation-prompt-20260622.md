# Aristotle prompt: P9 finite mean-zero fluctuation core

You are working in a focused Lean 4 package, not the full `PhysicsSM` repo.

Target file:

```text
NullEdgeP9MeanZeroFluctuation/Finite.lean
```

Please fill the four proof holes in that file. The mathematical goal is a small
finite source-fluctuation core for the P9 cosmological-constant branch:

- antisymmetry under a finite bijective relabeling forces zero total source;
- the two-point sign source is mean-zero but has nonzero second moment.

This is intended as a guardrail for later source-fluctuation pilots. It should
not be inflated into a cosmology claim.

Important constraints:

- Do not weaken theorem statements.
- Do not change definitions unless you discover a real mathematical or Lean API
  problem; if so, explain the issue before changing anything.
- Do not add fake assumptions or escape-hatch declarations.
- Prefer small helper lemmas if they make the proof stable.
- The intended command is:

```text
lake env lean NullEdgeP9MeanZeroFluctuation/Finite.lean
```

At the end, please include a short report with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
