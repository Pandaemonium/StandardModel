# FUR-H3: Formalize conjugate ideal J* and close FureyRightHandedSectorOpen

    Type: proof/strategy

    ## Task prompt

    You are Aristotle. This is a major Furey bridge job focused on the formal right-handed sector.

Context:
Claude's audit says the formal Furey pillar currently covers the left-handed doublet side, roughly 8 of the 15 Weyl states, while the 7 right-handed singlets are still open in the formalization and are appended by the conventional one-generation table. It specifically points to a conjugate ideal `J*` route.

Task:
1. Inspect the included `Jbar` and `J` Furey modules.
2. Determine whether the conjugate ideal/right-handed sector is already partially formalized under `Jbar*` files.
3. Produce the strongest next theorem package to close or reduce `FureyRightHandedSectorOpen`.
4. If feasible, implement `PhysicsSM/Algebra/Furey/ConjugateIdeal.lean` or a draft bridge module proving the missing singlet charges/representation data.
5. If not feasible, produce exact theorem statements, state which existing `Jbar` facts can be reused, and identify the minimum missing definitions.

Desired theorem targets:
- conjugate ideal basis and nonzero/linear independence facts;
- charge/hypercharge assignments for `u_R`, `d_R`, `e_R` or their all-left conjugates;
- compatibility with the all-left anomaly convention;
- statement closing or narrowing `FureyRightHandedSectorOpen`.

Do not claim three generations. Do not claim mass values.

    ## Included context files

- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`
- `PhysicsSM/Algebra/Furey/JbarActionTable.lean`
- `PhysicsSM/Algebra/Furey/JbarCoordinateEquiv.lean`
- `PhysicsSM/Algebra/Furey/JbarElectroweakAnomaly.lean`
- `PhysicsSM/Algebra/Furey/JbarLinearIndependence.lean`
- `PhysicsSM/Algebra/Furey/QopJbarEigenBridge.lean`
- `PhysicsSM/Algebra/Furey/QopJEigenBridge.lean`
- `PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
