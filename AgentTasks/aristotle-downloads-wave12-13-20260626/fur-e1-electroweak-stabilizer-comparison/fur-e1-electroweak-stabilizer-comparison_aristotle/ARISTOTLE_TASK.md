# FUR-E1: Compare Furey/Hughes electromagnetic stabilizer with finite FMS photon stabilizer

    Type: proof/audit

    ## Task prompt

    You are Aristotle. This is a Furey/null-edge electroweak stabilizer comparison job.

Context:
The null-edge FMS finite composite modules isolate the photon direction as the stabilizer of the Higgs reference section and recover W/Z leading terms. Furey/Hughes-style algebraic constructions emphasize an unbroken `SU(3)_C x U(1)_EM` subalgebra or electromagnetic operator `Q` selected by the internal algebra.

Task:
1. Inspect the included Furey electroweak/operator modules and null-edge EW/FMS modules.
2. Determine whether the Furey electromagnetic generator/stabilizer can be related to the null-edge FMS photon stabilizer `span{Q}`.
3. If feasible, implement a bridge theorem in `PhysicsSM/Draft/NullEdgeFureyEWStabilizerComparison.lean`.
4. If not feasible, produce exact theorem statements and missing API definitions.
5. Preserve scope: this is stabilizer/orbit-stiffness compatibility, not a W/Z pole theorem and not mass prediction.

Desired output:
- Lean bridge if possible.
- Otherwise `AgentTasks/null-edge-furey-ew-stabilizer-comparison.md`.

    ## Included context files

- `PhysicsSM/Algebra/Furey/ElectroweakBridge.lean`
- `PhysicsSM/Algebra/Furey/ElectroweakCompletePackage.lean`
- `PhysicsSM/Algebra/Furey/OperatorElectroweakIdentity.lean`
- `PhysicsSM/Algebra/Furey/QopElectroweakConsistency.lean`
- `PhysicsSM/Draft/NullEdgeElectroweakStabilizer.lean`
- `PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean`
- `PhysicsSM/Draft/NullEdgeFMSCompositeObservableNext.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
