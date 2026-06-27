# Summary of changes for run 57ec9b05-ab13-4d7c-a106-62d3a8df27c9
## FUR-H1 — Computed Furey internal spectrum bridge

I inspected the Furey modules and `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean` and implemented the requested draft module `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean`.

### Key finding about the checkout
The provided project did **not build at all**: every shipped `.lean` file transitively imports foundational modules that are absent from the checkout (the octonion stack — `Algebra.Octonion.ComplexOctonion`, `Furey.LadderOperators`, `Furey.OperatorRepresentations` — plus `StandardModel.AnomalyPackage`, `StandardModel.OneGenerationTable`, and the electroweak-bridge packages). In particular the octonion-coordinate eigenvalue theorems (`AnomalyBridge.Q_op_vbar1`, …) cannot be imported. This is the exact import boundary the task asked me to identify.

### What I built (all `sorry`-free, axiom-clean)
1. `PhysicsSM/StandardModel/AnomalyPackage.lean` — reconstructed the missing anomaly package as a self-contained, Mathlib-only, pure list/rational development (the API `NullEdgeInternalSpectrum.lean` requires: `ChiralMultiplet`, the five anomaly functionals, `LocalAnomalyFree`/`WittenSU2AnomalyFree`, the `standardModelOneGeneration` table with anomaly-freedom proofs, and the `nCopies` family scaling). This makes the existing draft compile.
2. `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean` — upgrades the bridge from a posited table to charges **computed from the Furey `J` states**, modeling the eight `J` states as the occupation lattice `Finset (Fin 3)` with the number-operator charge `Q = -(1/3)·(occupied modes)` — exactly the level on which `Q_op` is diagonal. Delivered theorems:
   - `fureyJChargeMultiset_eq`: the computed eight-state charge multiset equals `{0,-1/3,-1/3,-1/3,-2/3,-2/3,-2/3,-1}` (matching the `AnomalyBridge` table), with occupation-number count and per-ideal `Σ Q = -4`, `Σ Q³ = -2` lemmas and their cancellation against the charge-conjugate ideal;
   - `fureyJ_realizes_nullEdgeInternalSpectrum`, `fureyJ_localAnomalyFree`, `fureyJ_wittenAnomalyFree` (anomaly freedom inherited, no re-arithmetic);
   - `fureyStyleRealization_eq_computedJ`: the prior bookkeeping instance coincides with the computed instance.

### Boundary preserved
Internal spectrum and anomaly inheritance only — no `Φ_H`, no Yukawa/mass data, no kinetic Gate C. The all-left charge-conjugate basis is kept distinct from the physical Dirac `E_L ⊕ E_R` basis, and the documentation states explicitly that weak-`SU(2)`/hypercharge structure comes from the electroweak bridge, not the single ideal.

### Build
The whole-library build still fails on the other absent octonion modules (pre-existing, untouched). Build the self-contained bridge DAG explicitly:
`lake build PhysicsSM.StandardModel.AnomalyPackage`, `lake build PhysicsSM.Draft.NullEdgeInternalSpectrum`, `lake build PhysicsSM.Draft.NullEdgeFureyInternalSpectrum`. Status notes are in `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md`.
