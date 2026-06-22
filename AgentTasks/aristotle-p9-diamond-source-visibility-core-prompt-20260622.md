# Aristotle prompt: P9 unified diamond-source visibility core

You are working in a focused Lean 4 package, not the full `PhysicsSM` repo.

Target file:

```text
NullEdgeP9DiamondSourceVisibility/Core.lean
```

Please fill the six proof holes in that file. This is the next P9 consolidation
target after the strategy/audit report:

- consolidate the source-visibility grammar into one API;
- bank the already-proved adjoint, boundary-exact, chain-complex, and mean-zero
  lemmas once;
- prove the general visible-fan theorem
  `closed_visibleFan_mass_eq_restEnergy`, upgrading the hardcoded two-ray
  example to a weighted finite fan statement.

Important constraints:

- Do not weaken theorem statements.
- Do not change definitions unless you discover a real mathematical or Lean API
  problem; if so, explain the issue before changing anything.
- Do not add fake assumptions or escape-hatch declarations.
- Prefer small helper lemmas if they make the proof stable.
- The intended command is:

```text
lake env lean NullEdgeP9DiamondSourceVisibility/Core.lean
```

At the end, please include a short report with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
