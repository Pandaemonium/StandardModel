# D19: D0 symbol contract implementation plan after positive proxy

    Type: proof/strategy

    ## Task prompt

    You are Aristotle. This is the next Gate D0 proof-strategy job after the integrated D18 positive proxy.

Context:
D18 proved positive proxy scaffolding: scalar inverse-Gram nonnegativity, connection Laplacian nonnegativity, Euclidean edge energy nonnegativity, and stated open D0 obligations as structures/contracts such as `D0SymbolContract` for `[D_h, M_f] = c(df) + O(h)`. It did not claim continuum, Lorentzian, Krein, or retarded convergence.

Your task:
1. Inspect D18, the finite Lichnerowicz bridge, and scalar/gauge quadrature modules.
2. Identify the smallest next Lean theorem that turns one D0 contract into an implemented finite estimate or algebraic identity.
3. Keep the target positive/Euclidean/Hodge-Dirac; do not smuggle in Lorentzian or retarded claims.
4. Propose theorem statements for the step from finite commutator identity to local symbol approximation.
5. If feasible, implement a draft module; otherwise produce a precise proof plan and missing API list.

Possible output:
`PhysicsSM/Draft/NullEdgeD0SymbolContractStep.lean`

Deliverables:
- A D0 next-theorem plan.
- Lean statements for `[D_h, M_f]` style finite symbol identities.
- A clear list of what remains before Gate D proper.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeD0PositiveProxy.lean`
- `PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean`
- `PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
