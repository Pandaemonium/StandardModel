# C47/C48: Golterman-Shamir ghost-zero audit for Gate C Route B

    Type: strategy/audit

    ## Task prompt

    You are Aristotle. This is a Gate C safety audit job.

Context:
Route B can produce flavored branch signs by point-split projectors, taste operators, or species-splitting terms. But Claude's literature review flags Golterman-Shamir arXiv:2311.12790, Propagator Zeros and Lattice Chiral Gauge Theories: propagator zeros can behave as gauge-coupled ghost states, with wrong-sign effects and unitarity hazards, even while anomaly-like behavior survives.

C22 has already shown another safety split: modeled branch chirality and modeled Krein signature are not the same. Gate C therefore cannot release from flavored signs alone.

Your task:
1. Convert the Golterman-Shamir hazard into a precise null-edge Gate C checklist.
2. Propose a Lean-facing predicate or theorem API for ghost-zero safety, compatible with the existing Gate C release criterion and c22 Krein-signature module.
3. Distinguish physical poles, physical doublers, kinematical zeros, composite-field removable zeros, Krein artifacts, and fatal ghost zeros.
4. State what would need to be proven after weak gauge coupling for Route B to remain physically safe.
5. If possible, draft a new module skeleton `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean` with definitions and theorem statements, without adding unproved assumptions as trusted facts.

Deliverables:
- A report `AgentTasks/null-edge-golterman-shamir-ghost-zero-audit.md`.
- Optional Lean draft/module skeleton.
- Clear release/downgrade language for Gate C.

Important:
Do not let a computed flavored index release Gate C unless ghost-zero safety and Krein-positive physical-sector safety are separately accounted for.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean`
- `PhysicsSM/Draft/NullEdgeD0PositiveProxy.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md`
