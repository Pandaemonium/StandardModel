# Build, toolchain, and verification

Detailed build and verification procedure for the PhysicsSM Lean project. The
constant-awareness summary lives in [`../AGENTS.md`](../AGENTS.md); this file
holds the infrequent details (toolchain pin, the one-time Windows fix, the full
command list).

## Toolchain freeze

The project is pinned to `leanprover/lean4:v4.28.0` (`lean-toolchain`) for
compatibility with:

- Aristotle (Harmonic proof agent), which targets v4.28.0
- math-inc/Sphere-Packing-Lean (E8 lattice + sphere packing formalization)

Do not upgrade the toolchain unless all three build cleanly under the target
version: (1) mathlib, (2) SpherePacking, (3) the Aristotle workflow.

## Windows: ProofWidgets fix (one-time per cache wipe)

Mathlib injects an `errorOnBuild` flag into ProofWidgets that blocks `lake build`
on Windows. Build the widget JS from inside the ProofWidgets package directory
(where it is the root package and `errorOnBuild` is not set):

```bash
cd .lake/packages/proofwidgets && lake build widgetJsAll
```

After this one-time step, `lake build <module>` works normally on Windows.
Re-run it after `lake clean` or after a full `lake exe cache get!` wipes the
build directory. `lake env lean <file>` works without this fix.

## Targeted checks (run first)

```bash
# Works on Windows after the one-time widgetJsAll fix above:
lake build PhysicsSM.Path.To.Module

# Works on Windows without any fix (no ProofWidgets dependency):
lake env lean PhysicsSM/Path/To/File.lean
```

## Full build (before claiming a trusted change complete)

```bash
lake build
```

If configured, also run:

```bash
lake exe index
lake exe oracle-check
lake build PhysicsSM:docs
```

## No-sorry / placeholder scan

If there is a no-sorry checker, run it before finalizing trusted work.
Otherwise inspect suspicious tokens:

```bash
grep -R "sorry\|admit\|axiom\|unsafe" PhysicsSM
```

A grep hit is not automatically a failure in comments, generated files, or draft
files, but it must be inspected.

Do not claim a command passed unless it was actually run.
