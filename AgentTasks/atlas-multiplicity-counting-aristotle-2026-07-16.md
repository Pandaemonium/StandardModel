# Aristotle job: atlas multiplicity double counting

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`

```yaml
aristotle:
  project_id: 373f6045-f479-454c-9ba8-4ae8a85e8789
  task_id: fb940e21-243c-497f-8468-421e8ce5fc7b
  target_file: AtlasMultiplicityCounting/AtlasMultiplicityCounting.lean
  expected_module: AtlasMultiplicityCounting.AtlasMultiplicityCounting
  submission_project: AgentTasks/aristotle-submit/atlas-multiplicity-counting-20260716-project
  source_root: AgentTasks/aristotle-standalone/atlas-multiplicity-counting-20260716
  output_dir: AgentTasks/aristotle-output/373f6045-f479-454c-9ba8-4ae8a85e8789
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/AtlasMultiplicityCounting.lean
```

## Exact target

Prove all four displayed theorem statements without changing their types:

- the chart-event incidence double-counting identity;
- the total-volume bound under a pointwise multiplicity cap;
- the selected-cardinality/minimum-chart-size coverage constraint; and
- the pairwise-disjoint multiplicity-one boundary control.

Small helper lemmas are welcome. Keep the package Mathlib-only and do not use
the compiled evaluator or add new assumptions.

## Scientific boundary

These are finite set-system theorems. They explain why a uniform eventwise
overlap cap turns total chart volume into a lower bound on union capacity. They
do not establish that the causal-atlas selector meets such a cap, that a nerve
converges, or that continuum geometry exists.

## Submission

- Focused source preflight: the exact file typechecks with only the four
  intentional proof handoff warnings.
- Submitted as Aristotle project
  `373f6045-f479-454c-9ba8-4ae8a85e8789`.

## Integration

- Dry-run extraction found the expected focused module with no placeholders.
- The diff changed only the four proof bodies; every submitted theorem
  statement remained unchanged.
- The extracted candidate passed `lake env lean` locally.
- Proofs were integrated into
  `PhysicsSM/Draft/NullEdge/AtlasMultiplicityCounting.lean` with four
  build-enforced standard-three axiom guards.
- `lake env lean PhysicsSM/Draft/NullEdge/AtlasMultiplicityCounting.lean`
  passed. Two warnings report the intentionally retained, signature-preserving
  redundant `[DecidableEq Chart]` section assumption.
- `lake build PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting` passed.
- No proof holes or compiled-evaluator proof steps remain in the integrated
  module.
