# C59: Post-C21 projected Gate C release theorem tying chirality, Krein, ghost, and moduli clauses

    Type: proof/api

    ## Task prompt

    You are Aristotle. This is an API/theorem-integration job for Gate C after C21.

Context:
The old bare release criterion is dead. C21 proves the bare symbol does not assign a single chirality sign. The correct release theorem must be projected/species-split and must keep separate clauses for chirality, Krein positivity, ghost-zero safety, nodal control, and moduli status.

Your task:
1. Design and, if feasible, implement `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`.
2. Define a clean projected Gate C release predicate decomposed into independent clauses:
   - `NodalSetControlled`
   - `BranchProjectorsControlled`
   - `ProjectedKernelOneDim`
   - `ProjectedChiralityAligned`
   - `ProjectedKreinPositive`
   - `GhostZeroSafe`
   - `SpeciesSplittingAudited`
3. Prove that the conjunction implies a named projected Gate C release theorem.
4. Also prove negative guardrail theorems if easy:
   - bare alignment failure does not contradict projected release;
   - flavored index alone does not imply release;
   - Krein positivity alone does not imply chirality alignment;
   - projected chirality alone does not imply ghost safety.
5. Interface with the existing C47/C48 and K2 predicates rather than duplicating their definitions where possible.

Preferred output:
`PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`

This is allowed to be an API module: it may define the release predicate and prove logical implications even if the concrete projector theorem is left to C58. But do not add fake assumptions as if they were facts.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean`
- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean`
- `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean`
- `PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean`
- `PhysicsSM/Draft/NullEdgeSymmetryForcedSpeciesSplit.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-wave11-submissions-2026-06-26.md`
