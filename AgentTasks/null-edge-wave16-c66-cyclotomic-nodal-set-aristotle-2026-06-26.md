# Wave 16 C66: cyclotomic nodal-set classification

Date: 2026-06-26.

Aristotle metadata:

```yaml
aristotle:
  project_id: 69eeea7d-c900-40ab-bc2c-041199181144
  task_id: 197fa034-2759-4317-acde-797880b74589
  target_file: PhysicsSM/Draft/NullEdgeNodalSetCyclotomic.lean
  expected_module: PhysicsSM.Draft.NullEdgeNodalSetCyclotomic
  submission_project: AgentTasks/aristotle-submit/null-edge-wave16-furey-gatec-followups-20260626-project
  output_dir: AgentTasks/aristotle-output/69eeea7d-c900-40ab-bc2c-041199181144
  status: integrated
```

Context sources for this Wave 16 job:

- Returned strategy report: `AgentTasks/null-edge-furey-gauge-integration-strategy-report.md`
- Context pack: `AgentTasks/context-packs/null-edge-wave16-furey-gatec-followups-20260626-222118.md`
- Working plan: `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- Roadmap: `Sources/NullStrand_Lean_Roadmap_Improved.md`

Please finish with a short report: solved targets, changed statements, remaining blockers, proof holes or handoff markers, and exact files changed. Do not weaken statements silently. If a statement is false or too ambiguous, say so and return the strongest useful no-go/counterexample or API proposal.

## Prompt to Aristotle

This is a hard Gate C Lean proof/strategy job. C64 found an explicit off-branch determinant zero `q_star = (2*pi/3, 0, 0, 4*pi/3)` not on the certified branch lines and not gapped by the natural `g5` split. We need to stop discovering off-branch zeros one at a time and classify as much of the full determinant-zero locus as possible.

Goal: create `PhysicsSM/Draft/NullEdgeNodalSetCyclotomic.lean` with the strongest useful theorem about the cyclotomic/off-branch family of determinant zeros.

Relevant modules:

```text
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean
PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean
PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean
PhysicsSM/Draft/NullEdgeSpeciesSplitNodalLine.lean
PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean
```

Preferred targets, in descending priority:

```text
1. Generalize the C64 q_star witness to a finite orbit/family under obvious coordinate permutations, conjugation, or tetrahedral symmetries.
2. Prove a theorem characterizing a nontrivial cyclotomic family of zeros.
3. Prove that the current `T_lin`/g5 species split fails on that whole family, not just q_star.
4. If full classification is within reach, state and prove a theorem of the form:
   mink(pCov(phaseU q)) = 0 iff q belongs to an explicit branch-line plus
   cyclotomic/nodal family.
5. If full classification is too hard, return a proof-backed partial family and a precise strategy for the remaining cases.
```

This job may use the spectral-graph/DFT intuition from Yumoto-Misumi but should not rely on unverified literature claims. Keep Gate C release language honest: this is about nodal control, not Furey/internal legality.


## Integration note, 2026-06-27: C66

Project `69eeea7d-c900-40ab-bc2c-041199181144` returned complete and was integrated.

Integrated files:

- `PhysicsSM/Draft/NullEdgeNodalSetCyclotomic.lean`
- `AgentTasks/null-edge-wave16-c66-cyclotomic-nodal-set-REPORT.md`
- `AgentTasks/aristotle-output/69eeea7d-c900-40ab-bc2c-041199181144/ARISTOTLE_SUMMARY.md`

The draft aggregator imports `PhysicsSM.Draft.NullEdgeNodalSetCyclotomic`.
