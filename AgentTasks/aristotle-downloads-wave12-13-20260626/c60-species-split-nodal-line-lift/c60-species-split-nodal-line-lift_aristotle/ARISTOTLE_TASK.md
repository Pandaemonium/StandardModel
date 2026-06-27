# C60: Species-splitting lift of the exact high-branch nodal curves

    Type: proof/audit

    ## Task prompt

    You are Aristotle. This job attacks the extended-nodal-curve problem exposed by C43/C44.

Context:
C43/C44 proved each high branch lies on an exact determinant-zero curve:

  q_a = 0,
  q_b = pi + t for b != a,
  p(q)^2 = 0.

This means bare minimally-doubled species-count language is unsafe without a branch-control/species-splitting term. Earlier analysis proposed a linear taste function

  T_lin(q) = 1/2 (cos q_1 + cos q_2 - cos q_3 - cos q_4)

or its signed generalization. C45/C46 proved the coefficient `r` is tunable, but did not decide the exact nodal-line lift theorem.

Your task:
1. Inspect the nodal-set and species-splitting modules.
2. Define the relevant `T_lin`/taste function if it is not already present.
3. Prove its values on the branch corners and along the exact branch lines.
4. Prove a theorem of the form: `M_split = r*T_lin` lifts/gaps the high nodal line away from the origin, under the chosen branch model and nonzero `r`, if the algebra supports that statement.
5. Be explicit about what is lifted: scalar determinant zero, branch taste degeneracy, or a modeled mass term. Do not overclaim physical ghost safety.
6. Record the moduli verdict from C45/C46: `r` remains a free modulus, so this is reconstruction/branch control, not a magnitude prediction.

Preferred output:
`PhysicsSM/Draft/NullEdgeSpeciesSplitNodalLine.lean`

If the lift theorem is false or underspecified, produce a no-go/audit report with exact counterexample conditions.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean`
- `PhysicsSM/Draft/NullEdgeSymmetryForcedSpeciesSplit.lean`
- `PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-spectral-graph-nodal-classification-plan.md`
- `AgentTasks/null-edge-weber-flavored-qcd-splitting-audit.md`
