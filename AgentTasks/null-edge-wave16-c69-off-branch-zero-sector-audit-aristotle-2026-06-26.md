# Wave 16 C69: off-branch zero sector audit

Date: 2026-06-26.

Aristotle metadata:

```yaml
aristotle:
  project_id: b779fab8-584e-4401-9fd5-2367ae5ff624
  task_id: 910a387c-aa68-463a-815c-bfd4ddd3a2d9
  target_file: AgentTasks/null-edge-off-branch-zero-sector-audit-report.md
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/null-edge-wave16-furey-gatec-followups-20260626-project
  output_dir: AgentTasks/aristotle-output/b779fab8-584e-4401-9fd5-2367ae5ff624
  status: integrated
```

Context sources for this Wave 16 job:

- Returned strategy report: `AgentTasks/null-edge-furey-gauge-integration-strategy-report.md`
- Context pack: `AgentTasks/context-packs/null-edge-wave16-furey-gatec-followups-20260626-222118.md`
- Working plan: `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- Roadmap: `Sources/NullStrand_Lean_Roadmap_Improved.md`

Please finish with a short report: solved targets, changed statements, remaining blockers, proof holes or handoff markers, and exact files changed. Do not weaken statements silently. If a statement is false or too ambiguous, say so and return the strongest useful no-go/counterexample or API proposal.

## Prompt to Aristotle

This is a Gate C audit job with optional small Lean additions if they are natural. C64 showed that the full bare determinant-zero locus contains off-branch zeros not controlled by the existing branch-line split. We need to know whether these zeros are fatal, discardable, or removable after projection/composite interpretation.

Goal: produce `AgentTasks/null-edge-off-branch-zero-sector-audit-report.md`. If a small theorem is natural, propose or add it in `PhysicsSM/Draft/NullEdgeOffBranchZeroSector.lean`, but the report is the main artifact.

Relevant modules:

```text
PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean
PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean
PhysicsSM/Draft/NullEdgeProjectedBranchChirality.lean
PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean
PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean
PhysicsSM/Draft/NullEdgeCanonicalSpeciesSelector.lean
PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean
PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean
PhysicsSM/Draft/NullEdgeProjectedGhostSafety.lean
PhysicsSM/Draft/NullEdgeCompositeZeroEscape.lean
PhysicsSM/Draft/NullEdgeGaugeCovariantBranchProjectors.lean
```

Questions to answer:

```text
1. For the C64 off-branch zero q_star, what data do we currently have: branch label, projected-sector membership, Krein sign, chirality, residue/ghost classification?
2. Is q_star outside the currently modeled branch projectors, or does it survive any projected physical sector?
3. Can Gate C Clause 1 be safely rewritten as projected-sector nodal control, or would that hide a fatal bare ghost?
4. What exact theorem would prove that all off-branch zeros are discarded, Krein-negative, composite-removable, or ghost-safe?
5. Which of the existing Gate C release clauses remain unaffected, and which must be strengthened?
```

Please be adversarial. A maximal flavored index, projected chirality, and gauge covariance do not imply ghost safety. If the data are insufficient, say exactly what additional symbol/projector/residue computation is missing.

## Integration record, 2026-06-27

Integrated into the live repo by Codex.

```text
project_id: b779fab8-584e-4401-9fd5-2367ae5ff624
task_id: 910a387c-aa68-463a-815c-bfd4ddd3a2d9
copied_files:
  - AgentTasks/null-edge-off-branch-zero-sector-audit-report.md
  - PhysicsSM/Draft/NullEdgeOffBranchZeroSector.lean
summary: AgentTasks/aristotle-output/b779fab8-584e-4401-9fd5-2367ae5ff624/ARISTOTLE_SUMMARY.md
```

No local Lean build or pre-commit was run during this integration pass.
