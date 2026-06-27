# C43/C44: Spectral-graph nodal classification for Gate C Route B

    Type: proof/strategy

    ## Task prompt

    You are Aristotle, the strongest Lean proof assistant we have. This is a large Gate C Route B job for the null-edge program.

Context:
Wave 10 integrated C22, proving modeled branch-projector algebra and Krein signatures. C21, the actual tetrahedral Clifford-symbol decider, is still running. Meanwhile Pro and Claude identified a sharper Route B target: before treating high-momentum branches as isolated species, classify the determinant-zero/nodal set. In particular, Pro found an exact candidate nodal line through each high branch:

  q_a = 0,
  q_b = pi + t for b != a,
  p(q)^2 = 0.

Claude's literature review flags Yumoto-Misumi arXiv:2112.13501, Lattice fermions as spectral graphs, as a method source for classifying zero-eigenvalue loci by spectral-graph / DFT methods.

Your task:
1. Read the included Gate C modules and planning notes.
2. Determine the cleanest Lean theorem package for determinant-zero/nodal classification of the flat tetrahedral null-edge symbol.
3. If feasible, implement a new draft module, preferably `PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean`, proving the exact branch-line theorem and any stronger finite zero-locus lemmas available from the existing scalar qform definitions.
4. If the existing definitions are insufficient, produce a precise proof plan with theorem statements and the missing definitions.
5. Use the spectral-graph/DFT literature as strategy guidance, but keep the Lean theorem self-contained.

Desired theorem targets:
- `branchLine_pSq_eq_zero`: for each high branch a, q_a = 0 and q_b = pi + t for b != a implies p(q)^2 = 0.
- `threePiBranch_on_branchLine`: the three-pi corner is the t = 0 point.
- `origin_on_branchLine`: the origin is the t = pi point, if represented by the chosen coordinate convention.
- A local or global classification lemma if feasible: are these lines all determinant-zero components, or merely certified components?
- A report explaining whether Gate C should treat the high branches as isolated species, extended nodal curves, or unresolved.

Important:
Do not depend on C21. Do not assume bare `OperatorForcesAlignment`. Route B is expected. If you prove the determinant zeros form extended nodal curves, say that clearly and explain what branch-control term would be required before species-count language is safe.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeFlavoredChirality.lean`
- `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean`
- `PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean`
- `PhysicsSM/Draft/NullEdgePointSplitProjectors.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md`

## Missing requested files

- `PhysicsSM/Draft/NullEdgePointSplitProjectors.lean`
