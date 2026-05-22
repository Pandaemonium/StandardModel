# PhysicsSM and CodeLatticeE8

This repository contains Lean 4 formalizations around Standard Model
mathematics, octonions, exceptional Lie theory, and the Hamming-code
Construction A route to the E8 lattice.

The polished publication artifact is the `CodeLatticeE8` package.  It proves,
from an explicit extended binary Hamming `[8,4,4]` code, the Construction A
integer lattice, the E8 normalization, the short-vector count `240`, the
doubled-coordinate E8 root list, the root bridge, Cartan data, Weyl reflection
closure, and finite theta-series coefficient checks.  The optional
`CodeLatticeE8SPL` root connects the package to Sphere-Packing-Lean and carries
the SPL-facing `Theta_E8 = E4` theorem chain.

## Recommended Checks

The monorepo root includes the optional Sphere-Packing-Lean dependency because
the `CodeLatticeE8SPL` target imports it:

```powershell
lake build CodeLatticeE8
lake build CodeLatticeE8SPL
```

Reviewers who want the standalone, mathlib-only `CodeLatticeE8` core without
resolving Sphere-Packing-Lean should use the wrapper package:

```powershell
cd CodeLatticeE8Standalone
lake build CodeLatticeE8
```

Both package roots are pinned to Lean 4.28.0.  The build passes `-s65536` to
Lean because several finite root-list and matrix proofs need a larger stack
than Lean's default.

On Windows, after a cache wipe, Mathlib's ProofWidgets package may need its
JavaScript assets built once from inside the dependency package:

```powershell
cd .lake/packages/proofwidgets
lake build widgetJsAll
```

After that one-time step, return to the repository root and run the Lean build
commands above.

## Main Files

- `CodeLatticeE8.lean`: standalone reviewer-facing root.
- `CodeLatticeE8/Publication/TheoremIndex.lean`: compile-checked theorem index.
- `CodeLatticeE8SPL.lean`: optional Sphere-Packing-Lean-facing root.
- `Sources/Hamming_ConstructionA_E8_Manuscript_Revision.md`: manuscript draft.
- `Sources/CodeLatticeE8_Publication_Theorem_Map.md`: theorem map.
- `Sources/CodeLatticeE8_Trust_Report.md`: trust and verification report.
