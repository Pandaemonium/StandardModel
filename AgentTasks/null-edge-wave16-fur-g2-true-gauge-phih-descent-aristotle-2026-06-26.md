# Wave 16 FUR-G2: true-gauge quotient descent for Phi_H

Date: 2026-06-26.

Aristotle metadata:

```yaml
aristotle:
  project_id: 102e5d55-2e9c-4fd3-acf1-277d67c28844
  task_id: 67470909-c75a-45ac-85cc-70ea3317d1d9
  target_file: PhysicsSM/Draft/NullEdgeFureyTrueGaugePhiH.lean
  expected_module: PhysicsSM.Draft.NullEdgeFureyTrueGaugePhiH
  submission_project: AgentTasks/aristotle-submit/null-edge-wave16-furey-gatec-followups-20260626-project
  output_dir: AgentTasks/aristotle-output/102e5d55-2e9c-4fd3-acf1-277d67c28844
  status: integrated
```

Context sources for this Wave 16 job:

- Returned strategy report: `AgentTasks/null-edge-furey-gauge-integration-strategy-report.md`
- Context pack: `AgentTasks/context-packs/null-edge-wave16-furey-gatec-followups-20260626-222118.md`
- Working plan: `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- Roadmap: `Sources/NullStrand_Lean_Roadmap_Improved.md`

Please finish with a short report: solved targets, changed statements, remaining blockers, proof holes or handoff markers, and exact files changed. Do not weaken statements silently. If a statement is false or too ambiguous, say so and return the strongest useful no-go/counterexample or API proposal.

## Prompt to Aristotle

This is a full-repo Lean proof/API job. The returned strategy report identified a central gap: `NullEdgeFureyPhiH` proves gauge covariance over an arbitrary `Monoid G`, but it has not been instantiated over the true Standard Model gauge quotient or the `S(U(2) x U(3))` block units.

Goal: create `PhysicsSM/Draft/NullEdgeFureyTrueGaugePhiH.lean` with the strongest useful theorem connecting the legal `Phi_H` interface to the true gauge-group quotient surface.

Relevant modules to inspect:

```text
PhysicsSM/Draft/NullEdgeFureyPhiH.lean
PhysicsSM/Draft/NullEdgeFureyAlmostCommutativeProduct.lean
PhysicsSM/Gauge/StandardModelProductCoveringTrueQuotientSMBlock.lean
PhysicsSM/Gauge/StandardModelProductCoveringTrueZ6Kernel.lean
PhysicsSM/Gauge/StandardModelUnitZ6QuotientGroup.lean
PhysicsSM/Gauge/QunitQubitQutritQuotientRepresentation.lean
PhysicsSM/Gauge/StandardModelGroup.lean
PhysicsSM/Gauge/StandardModelGroupStructure.lean
```

Target theorem shape, adjusted to existing APIs:

```text
phiH_descends_trueQuotient:
  a `GaugeCovariantPhiH` whose carriers are acted on through the quotient
  representation is covariant for the true Standard Model quotient, not merely
  the product cover.
```

If a direct theorem over `Phi_H` is not yet possible, produce a clean API layer:

```text
1. a definition naming the true quotient/group action surface to use;
2. a kernel-triviality/descent theorem for the internal fiber action;
3. a theorem saying any `Phi_H` intertwiner for this quotient gives a proper
   null-edge Furey `Phi_H`;
4. a precise handoff explaining the missing representation bridge.
```

Please be adversarial about overclaiming: if the existing quotient action is only on qubit-plus-qutrit and not yet on the Furey ideal/occupation carrier, return that as the main blocker and state the exact missing theorem.

## Integration record, 2026-06-27

Integrated into the live repo by Codex.

```text
project_id: 102e5d55-2e9c-4fd3-acf1-277d67c28844
task_id: 67470909-c75a-45ac-85cc-70ea3317d1d9
copied_files:
  - PhysicsSM/Draft/NullEdgeFureyTrueGaugePhiH.lean
summary: AgentTasks/aristotle-output/102e5d55-2e9c-4fd3-acf1-277d67c28844/ARISTOTLE_SUMMARY.md
```

No local Lean build or pre-commit was run during this integration pass.
