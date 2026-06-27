# C58: Construct the projected branch/Weyl selector and prove alignment after projection

    Type: proof

    ## Task prompt

    You are Aristotle, the top Lean proof assistant for this project. This is the main Wave 12 Gate C job.

Context:
C21 proved the actual tetrahedral Clifford symbol has two-dimensional, chirality-balanced branch kernels and refuted bare single-chirality assignment. C43/C44 proved the bare determinant branches include exact nodal curves, so species splitting or projection is required. K2 proved a physical-sector projector `Pphys = Pbranch 0 + Pbranch 2` is the maximal Krein-positive sector for the modeled branch/Krein grading. C47/C48 proved a flavored index alone never releases Gate C; ghost safety is a separate hard clause. C45/C46 proved the species-splitting coefficient is tunable, so prediction language remains off at the level of `r`.

The single remaining Gate C obligation is now:

  OperatorForcesAlignmentAfterProjection

meaning: construct an explicit energy/Krein/Weyl/branch projector that cuts each relevant 2-dimensional branch kernel from C21 to the desired 1-dimensional `g5 a` line, and prove the projected chirality statement.

Your task:
1. Inspect the included C21, C22/K2, ghost-safety, nodal-set, and splitting modules.
2. Define a concrete projected branch selector, if the existing API supports it. It may be a Weyl projector, an energy/Krein selector, a point-split/taste selector, or a composition of these, but it must be explicit.
3. Prove, if feasible, the projected-kernel theorem:
   - projected branch survivor is one-dimensional;
   - `gamma5` or the correct `Gamma_f = gamma5*T` acts by `g5 a` on that survivor;
   - this theorem is stated as projection-level alignment, not bare alignment.
4. If no such projector can be built from current definitions, produce a precise no-go or missing-API report identifying the exact definition needed.
5. Do not hide Krein or ghost obligations. If the theorem proves chirality only, state that K2 and C47/C48 remain separate release clauses.

Preferred output:
`PhysicsSM/Draft/NullEdgeProjectedBranchChirality.lean`

Desired theorem names, adjusted to the local API if necessary:
- `projectedKernel_finrank_one`
- `projectedBranch_chirality_aligned`
- `operatorForcesAlignmentAfterProjection`
- `gateC_projected_chirality_clause`

Acceptance:
A successful theorem closes the chirality-alignment part of Gate C only. It should not claim Gate C full release unless it explicitly imports or interfaces with Krein-positive and ghost-safe predicates.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean`
- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean`
- `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean`
- `PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean`
- `PhysicsSM/Draft/NullEdgeSymmetryForcedSpeciesSplit.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md`
- `AgentTasks/null-edge-c21-actual-clifford-symbol-note.md`
- `AgentTasks/null-edge-k2-krein-positive-release-criterion-note.md`
- `AgentTasks/null-edge-golterman-shamir-ghost-zero-audit.md`
