# Aristotle prompt: diamond source visibility core proof fill

You are working in a focused Lean package. This is now a proof-fill job, not a
strategy job.

## Target

Fill the remaining proof holes in:

```text
PhysicsSM/Draft/NullEdgeDiamondSourceVisibilityRoadmap.lean
```

The file imports only Mathlib and is a standalone scaffold produced by the P9
source-visibility API design job. It already elaborates locally in the main
repo environment with exactly three proof-hole warnings.

## Intended targets

Please try to prove these declarations without changing their mathematical
content:

```lean
diamondSource_additive_iff_orthogonal
closed_visibleFan_mass_eq_restEnergy
visiblePluckerMass_sources_bulkTerm
```

The first theorem is the highest priority. The second and third are useful if
they can be proved from the scaffold definitions; if either statement is false
or underspecified, return a counterexample or explain the missing hypothesis
instead of weakening the statement silently.

## Constraints

- Do not change definitions, theorem names, or theorem statements unless the
  current statement is false or ill-typed; if you must change one, explain why.
- Do not import the full `PhysicsSM` repository.
- Do not add new assumptions merely to make a proof pass.
- You may add small helper lemmas in the same file.
- Keep this finite and algebraic. No continuum source-visibility or
  cosmological-constant claims.

## Verification

Run the narrow command first:

```text
lake env lean PhysicsSM/Draft/NullEdgeDiamondSourceVisibilityRoadmap.lean
```

Return the completed target file and a short summary of which statements were
proved, which were changed, and which remain blocked.
