# Build

This is a standalone Lake package pinned to the same Lean toolchain as the main
repository:

```text
leanprover/lean4:v4.28.0
```

From `NullEdgeStandalone/`:

```powershell
lake build NullEdgeStandalone
lake env lean NullEdgeStandalone.lean
```

The package reuses the parent repo's dependency cache through:

```toml
packagesDir = "../.lake/packages"
```

For a fully detached copy, remove that line and run `lake update` in the copied
directory.

The package is Mathlib-only. It does not import the main `PhysicsSM` Lake package
or the optional Sphere-Packing-Lean bridge.
