# FUR-H1: Computed Furey internal spectrum bridge from actual J states

    Type: proof

    ## Task prompt

    You are Aristotle, the strongest Lean proof assistant for this project. This is a Furey/null-edge bridge job.

Context:
The null-edge internal-spectrum API currently has a thin `fureyStyleRealization` layer that bookkeeps the Standard Model one-generation charge table. Claude's latest audit says the repo already has a substantial kernel-checked Furey pillar: the minimal left ideal J in `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`, quantum-number modules, one-generation bridge modules, and anomaly bridge modules.

Task:
1. Inspect the included Furey modules and `NullEdgeInternalSpectrum.lean`.
2. Determine the smallest theorem/API that upgrades the null-edge bridge from a posited charge table to charges computed from the actual Furey `J` states.
3. If feasible, implement a new draft module:
   `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean`.
4. Prove that the computed Furey data realizes the relevant `NullEdgeInternalSpectrum` predicate, or explain exactly which existing theorem/import boundary prevents it.
5. Preserve the boundary: this is internal spectrum and anomaly inheritance only, not mass values and not kinetic Gate C.

Desired theorem names, adapted to existing APIs:
- `fureyJ_realizes_nullEdgeInternalSpectrum`
- `fureyJ_localAnomalyFree`
- `fureyJ_wittenAnomalyFree`
- `fureyStyleRealization_eq_computedJ`, if a comparison with the current bookkeeping instance is possible.

Be especially careful about the all-left convention and charge conjugation. Do not silently identify the all-left anomaly basis with the physical Dirac L/R basis.

    ## Included context files

- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`
- `PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean`
- `PhysicsSM/Algebra/Furey/AnomalyBridge.lean`
- `PhysicsSM/Algebra/Furey/QuantumNumbers.lean`
- `PhysicsSM/Algebra/Furey/SMStates.lean`
- `PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean`
- `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-furey-internal-spectrum-bridge.md`
