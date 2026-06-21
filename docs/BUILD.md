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

## Placeholder scan

Run the comment-aware Lean-code checker before finalizing trusted work:

```bash
python Scripts/check_forbidden_lean_tokens.py
```

For draft or focused files, pass paths explicitly and include draft directories:

```bash
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/Example.lean
```

For Aristotle outputs or packages that must avoid compiled-evaluator proofs,
add the strict finite-computation flag:

```bash
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/Example.lean
```

This checker ignores Lean comments, docstrings, and strings, so it is much
quieter than raw grep while still catching kernel-relevant placeholders and
escape hatches in executable Lean code.

Do not claim a command passed unless it was actually run.
