# Wave 16 FUR-G1: octonion Q_op to occupation-spectrum bridge

Date: 2026-06-26.

Aristotle metadata:

```yaml
aristotle:
  project_id: 2ccea9b0-9781-4994-9a96-8a258303efed
  task_id: aff5c1a0-e708-4c45-bebf-3449cd2fbcc1
  target_file: PhysicsSM/Draft/NullEdgeFureyOctonionBridge.lean
  expected_module: PhysicsSM.Draft.NullEdgeFureyOctonionBridge
  submission_project: AgentTasks/aristotle-submit/null-edge-wave16-furey-gatec-followups-20260626-project
  output_dir: AgentTasks/aristotle-output/2ccea9b0-9781-4994-9a96-8a258303efed
  status: submitted
```

Context sources for this Wave 16 job:

- Returned strategy report: `AgentTasks/null-edge-furey-gauge-integration-strategy-report.md`
- Context pack: `AgentTasks/context-packs/null-edge-wave16-furey-gatec-followups-20260626-222118.md`
- Working plan: `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- Roadmap: `Sources/NullStrand_Lean_Roadmap_Improved.md`

Please finish with a short report: solved targets, changed statements, remaining blockers, proof holes or handoff markers, and exact files changed. Do not weaken statements silently. If a statement is false or too ambiguous, say so and return the strongest useful no-go/counterexample or API proposal.

## Prompt to Aristotle

This is a focused Lean proof/API job. The returned strategy report says the null-edge Furey files currently use an occupation-lattice stand-in, while the real Furey octonion stack and `Q_op_*` eigenvalue theorems are present. Please close that gap.

Goal: create `PhysicsSM/Draft/NullEdgeFureyOctonionBridge.lean` importing both the real Furey octonion/anomaly bridge and the null-edge Furey occupation-spectrum file. Prove a theorem, with the best exact name you can support, of the following form:

```text
fureyJChargeMultiset_eq_Qop_spectrum:
  the null-edge occupation charge multiset equals the multiset of charges
  computed from the real octonion/Furey Q_op eigenvalue theorems.
```

Relevant modules to inspect:

```text
PhysicsSM/Algebra/Furey/AnomalyBridge.lean
PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean
PhysicsSM/Algebra/Furey/OperatorAlgebra.lean
PhysicsSM/Algebra/Furey/QuantumNumbers.lean
PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean
PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md
```

Preferred deliverables:

```text
1. A theorem linking the occupation-lattice charges to the real octonion Q_op spectrum.
2. A small wrapper theorem saying the occupation realization is now backed by the octonion/Furey spectrum.
3. If the stale `_NOTES.md` claim that the octonion stack is absent can be safely patched, propose exact replacement text in the report. Do not edit large docs unless it is very small and local.
```

This job should avoid broad refactors. If exact equality of multisets is awkward, return the closest clean theorem plus an explanation of what representation coercion or rational-normalization bridge is missing.
