# FUR-H2: Identify chi_E with Furey/Krasnov internal complex-structure data

    Type: proof/strategy

    ## Task prompt

    You are Aristotle. This job asks whether the abstract internal grading `chi_E` in the null-edge super-Dirac layer can be discharged by existing Furey/Krasnov complex-structure data.

Context:
The super-Dirac square requires a `Phi_H` that is `chi_E`-odd and `Gamma_s`-even. Claude reports that the Furey/Baez/DVT pillar includes Krasnov-style complex structure: right multiplication by `e111` acts as multiplication by `i`, plus DVT/Jordan scaffolding. The working plan now asks whether this supplies the internal grading `chi_E`.

Task:
1. Inspect the included Furey/Jordan/null-edge files.
2. Identify existing definitions/theorems corresponding to the internal complex structure, grading, or involution on the Furey ideal `J`.
3. Propose and, if feasible, implement `PhysicsSM/Draft/NullEdgeFureyChiE.lean` proving a clean bridge to the `NullEdgeInternalSpectrum` grading field.
4. State exactly whether this is a Z/2 grading, a complex structure, or both. Do not conflate complex multiplication by `i` with a chirality grading unless a theorem converts one to the other.
5. Explain how this `chi_E` would interact with `Phi_H` oddness and the Gate A sign theorem.

Desired output:
- Lean module if feasible.
- Otherwise a precise report with theorem statements and missing APIs.

Guardrail:
Keep `Gamma_s`, `chi_E`, and any form-degree grading separate.

    ## Included context files

- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`
- `PhysicsSM/Algebra/Furey/CliffordConnection.lean`
- `PhysicsSM/Algebra/Furey/OperatorAlgebra.lean`
- `PhysicsSM/Algebra/Furey/OperatorRepresentations.lean`
- `PhysicsSM/Algebra/Jordan`
- `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean`
- `PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean`
- `PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
