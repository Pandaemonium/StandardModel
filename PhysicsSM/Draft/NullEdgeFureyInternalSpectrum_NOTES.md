# FUR-H1 — Computed Furey internal spectrum bridge: status notes

## Summary

`PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean` upgrades the null-edge
internal-spectrum bridge from a *posited* Standard Model charge table to charges
**computed from the Furey minimal-left-ideal `J` states**, and re-derives the
realization and anomaly-inheritance results against that computed data.

Delivered theorems (all `sorry`-free, axiom-clean — only `propext`,
`Classical.choice`, `Quot.sound`, plus `Lean.ofReduceBool`/`Lean.trustCompiler`
for the `native_decide` lattice computations):

- `fureyJChargeMultiset_eq` — the eight `J`-state electric charges, **computed**
  from the occupation lattice, equal `{0,-1/3,-1/3,-1/3,-2/3,-2/3,-2/3,-1}`.
- `fureyJ_gravitational_sum`, `fureyJ_cubic_sum`,
  `fureyJ_combined_gravitational_cancels`, `fureyJ_combined_cubic_cancels` —
  computed per-ideal abelian charge sums and their cancellation against the
  charge-conjugate ideal.
- `fureyJ_realizes_nullEdgeInternalSpectrum` — the computed instance realizes the
  `NullEdgeInternalSpectrum` predicate (`RealizesOneGeneration`).
- `fureyJ_localAnomalyFree`, `fureyJ_wittenAnomalyFree`, `fureyJ_anomalyFree` —
  anomaly freedom inherited via the existing inheritance theorems.
- `fureyStyleRealization_eq_computedJ` (and `…multiplets_eq_computedJ`) — the
  earlier bookkeeping instance coincides with the computed instance.

## Import boundary and build

The foundational Furey/octonion modules are **present** in the project
(`PhysicsSM.Algebra.Octonion.ComplexOctonion`,
`PhysicsSM.Algebra.Furey.LadderOperators`,
`PhysicsSM.Algebra.Furey.OperatorRepresentations`,
`PhysicsSM.Algebra.Furey.MinimalLeftIdeal`,
`PhysicsSM.Algebra.Furey.AnomalyBridge`,
`PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge` and its deps
(`ElectroweakCompletePackage`, `ElectroweakPaperPackage`,
`OneGenerationPackage`, `JbarElectroweakAnomaly`, `QopElectroweakConsistency`),
`PhysicsSM.StandardModel.AnomalyPackage`,
`PhysicsSM.StandardModel.OneGenerationTable`, …), and the octonion-coordinate
eigenvalue theorems (`AnomalyBridge.Q_op_omega_bar`, `Q_op_vbar1`, …) are
available there.

`PhysicsSM/StandardModel/AnomalyPackage.lean` is the shared, Mathlib-only,
pure list/rational combinatorial anomaly package; it is the same module
imported by the live Furey bridge (`AnomalyBridge.lean`,
`OneGenerationPackage.lean`, `FureyRealizesOneGeneration.lean`) and by the
null-edge API (`NullEdgeInternalSpectrum.lean`). This draft intentionally
models the Furey `J` states at the **number-operator / occupation level** — the
exact level on which `Q_op` is diagonal — reproducing the same charge multiset
the coordinate theorems prove, without importing the heavier stack.

Build the bridge DAG explicitly:

```
lake build PhysicsSM.StandardModel.AnomalyPackage
lake build PhysicsSM.Draft.NullEdgeInternalSpectrum
lake build PhysicsSM.Draft.NullEdgeFureyInternalSpectrum
```

## Scope preserved

Internal spectrum and anomaly inheritance only. No `Φ_H`, no Yukawa/mass data,
no kinetic ("Gate C") content. The all-left anomaly basis recorded in the
multiplet list is kept distinct from the physical Dirac `E_L ⊕ E_R` basis
(related by charge conjugation), as required.
