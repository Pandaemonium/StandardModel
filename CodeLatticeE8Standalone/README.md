# CodeLatticeE8 Standalone Wrapper

This directory is a mathlib-only Lake wrapper for the publication package.  It
exists so reviewers can build the standalone `CodeLatticeE8` theorem spine
without resolving the optional Sphere-Packing-Lean dependency declared by the
monorepo root.

Run from this directory:

```powershell
lake build CodeLatticeE8
```

The wrapper points its Lean source directory at the repository root, so it
builds the same `CodeLatticeE8.lean` and `CodeLatticeE8/*` files as the
monorepo.  It intentionally does not build `CodeLatticeE8SPL`.
