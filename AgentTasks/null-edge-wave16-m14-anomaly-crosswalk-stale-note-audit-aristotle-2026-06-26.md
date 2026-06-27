# Wave 16 M14: anomaly crosswalk and stale-note audit

Date: 2026-06-26.

Aristotle metadata:

```yaml
aristotle:
  project_id: ec05debe-65e4-452a-ba35-8b8c30a8dc80
  task_id: bafd7ff0-c4b8-40da-a25c-8d00bbcc54f1
  target_file: AgentTasks/null-edge-anomaly-crosswalk-stale-note-audit-report.md
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/null-edge-wave16-furey-gatec-followups-20260626-project
  output_dir: AgentTasks/aristotle-output/ec05debe-65e4-452a-ba35-8b8c30a8dc80
  status: integrated
```

Context sources for this Wave 16 job:

- Returned strategy report: `AgentTasks/null-edge-furey-gauge-integration-strategy-report.md`
- Context pack: `AgentTasks/context-packs/null-edge-wave16-furey-gatec-followups-20260626-222118.md`
- Working plan: `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- Roadmap: `Sources/NullStrand_Lean_Roadmap_Improved.md`

Please finish with a short report: solved targets, changed statements, remaining blockers, proof holes or handoff markers, and exact files changed. Do not weaken statements silently. If a statement is false or too ambiguous, say so and return the strongest useful no-go/counterexample or API proposal.

## Prompt to Aristotle

This is a no-build audit/manuscript-crosswalk job. The returned strategy report flagged a possible documentation bug: null-edge Furey notes may still say the octonion stack was absent and that a self-contained anomaly package was reconstructed, but the real octonion/Furey/anomaly stack is now present.

Goal: produce a report at `AgentTasks/null-edge-anomaly-crosswalk-stale-note-audit-report.md` identifying stale notes and exact patch recommendations.

Relevant files:

```text
PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean
PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md
PhysicsSM/StandardModel/AnomalyPackage.lean
PhysicsSM/StandardModel/AnomalyCancellation.lean
PhysicsSM/Algebra/Furey/AnomalyBridge.lean
PhysicsSM/Algebra/Furey/OneGenerationPackage.lean
PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean
PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean
PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md
Sources/NullStrand_Lean_Roadmap_Improved.md
```

Please answer:

```text
1. Do the null-edge and Furey islands use the same `standardModelOneGeneration` and anomaly predicates?
2. Which notes/docstrings are now stale or misleading?
3. What exact local edits should be made to replace "octonion stack absent" language with the current bridge status?
4. What is the safest canonical theorem citation for one-generation anomaly freedom?
5. What is the safest canonical theorem citation for the Furey-to-anomaly bridge?
```

Do not edit broad manuscripts unless the changes are tiny and clearly local. Prefer a patch plan and exact replacement snippets.

## Integration record, 2026-06-27

Integrated into the live repo by Codex.

```text
project_id: ec05debe-65e4-452a-ba35-8b8c30a8dc80
task_id: bafd7ff0-c4b8-40da-a25c-8d00bbcc54f1
copied_files:
  - AgentTasks/null-edge-anomaly-crosswalk-stale-note-audit-report.md
  - PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean
  - PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md
summary: AgentTasks/aristotle-output/ec05debe-65e4-452a-ba35-8b8c30a8dc80/ARISTOTLE_SUMMARY.md
```

No local Lean build or pre-commit was run during this integration pass.
