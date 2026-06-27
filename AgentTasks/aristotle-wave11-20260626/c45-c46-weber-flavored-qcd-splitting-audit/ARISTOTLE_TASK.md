# C45/C46: Weber flavored-QCD no-fine-tuning audit for Route B splitting

    Type: strategy/audit

    ## Task prompt

    You are Aristotle. This is a no-build but highly technical Route B strategy/audit job.

Context:
The null-edge Gate C program now expects Route B: the bare four-component Clifford symbol likely has chiral-paired branch kernels, while meaningful signs arise from point-split/taste/species-split structure. The worry is that a splitting term such as

  M_split = r T
  or
  M_split = r T_lin

could be a freely tunable Wilson-like branch-control modulus. If so, Gate F prediction language remains off.

Claude's literature review identified Weber arXiv:1611.08388, QCD with Flavored Minimally Doubled Fermions, as potentially important: it introduces a non-singlet flavored mass term for Karsten-Wilczek fermions, identifies the finite-lattice-spacing SU(2) flavor representation, and argues taste-breaking can be avoided without fine-tuning via a C/reflection-symmetry argument on the quark determinant.

Your task:
1. Analyze whether Weber's mechanism can be adapted to the tetrahedral null-edge Route B setting.
2. Determine what symmetry data would be needed to make the sign pattern (+,+,-,-), the taste operator T, and the coefficient r symmetry-forced rather than freely tuned.
3. Propose a Lean-facing theorem/API for a symmetry-forced species splitting, if plausible.
4. If not plausible, produce a clear no-go/audit showing that the splitting remains a modulus.
5. Explain how this affects Gate F prediction language.

Deliverables:
- A report `AgentTasks/null-edge-weber-flavored-qcd-splitting-audit.md`.
- Optional Lean sketch/theorem signatures for `PhysicsSM/Draft/NullEdgeSymmetryForcedSpeciesSplit.lean`.
- A classification table: forced, constrained, tunable, or fatal.

Do not claim prediction unless the symmetry argument really fixes the relevant data. Be adversarial about hidden tunable parameters.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeFlavoredChirality.lean`
- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean`
- `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md`
