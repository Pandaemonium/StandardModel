# Wave 16 FUR-G3: null-edge/Furey involution distinctness

Date: 2026-06-26.

Aristotle metadata:

```yaml
aristotle:
  project_id: 6e18cb1e-59ce-4150-83ca-1943c667287c
  task_id: 193cb6d9-18e2-4c35-89c6-a736408bf47d
  target_file: PhysicsSM/Draft/NullEdgeInvolutionDistinctness.lean
  expected_module: PhysicsSM.Draft.NullEdgeInvolutionDistinctness
  submission_project: AgentTasks/aristotle-submit/null-edge-wave16-furey-gatec-followups-20260626-project
  output_dir: AgentTasks/aristotle-output/6e18cb1e-59ce-4150-83ca-1943c667287c
  status: submitted
```

Context sources for this Wave 16 job:

- Returned strategy report: `AgentTasks/null-edge-furey-gauge-integration-strategy-report.md`
- Context pack: `AgentTasks/context-packs/null-edge-wave16-furey-gatec-followups-20260626-222118.md`
- Working plan: `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- Roadmap: `Sources/NullStrand_Lean_Roadmap_Improved.md`

Please finish with a short report: solved targets, changed statements, remaining blockers, proof holes or handoff markers, and exact files changed. Do not weaken statements silently. If a statement is false or too ambiguous, say so and return the strongest useful no-go/counterexample or API proposal.

## Prompt to Aristotle

This is a focused Lean consolidation job. Multiple two-valued structures are active in the null-edge/Furey program, and reviewers or future agents may accidentally identify them. Please create a small defensive module collecting theorem-level non-identification witnesses.

Target file:

```text
PhysicsSM/Draft/NullEdgeInvolutionDistinctness.lean
```

Structures to keep separate where the current repo supports it:

```text
Gamma_s;
chi_E / occupation parity;
Furey or Krasnov complex structure;
Krein J / branch Krein sign;
branch/taste sign;
edge orientation;
charge conjugation;
incoming/outgoing dualization.
```

Relevant modules:

```text
PhysicsSM/Draft/NullEdgeFureyPhiH.lean
PhysicsSM/Draft/NullEdgeFureyChiE.lean
PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean
PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean
PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean
```

Preferred deliverables:

```text
1. Re-export or prove existing distinctness facts such as gammaS_internal_ne_chiE, complexStructure_ne_grading / chiEParity_not_complexStructure, and krein/chirality nonidentification.
2. Add clear docstrings stating what is proved and what is only a convention boundary.
3. If some distinctions cannot be formalized because the two structures live on different carriers, provide a type-level separation theorem or a report entry saying so.
```

This is not meant to solve physics. It is a guardrail module to prevent accidental identification of different involutions.
