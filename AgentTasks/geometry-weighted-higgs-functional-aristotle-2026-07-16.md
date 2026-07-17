# Aristotle job: geometry-weighted finite Higgs functional

Date: 2026-07-16
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated

Semantic context pack:
`AgentTasks/context-packs/geometry-weighted-higgs-functional-20260716-20260716-221843.md`
(SHA-256 `A757D2FE9E8D31F90E36C1DAC2AA4C18358142CD334F0C73B568EDB6F677656A`).

## Objective

Prove the exact finite algebra for a complex vertex Higgs field coupled to a
`U(1)` edge connection and supplied real edge/vertex weights:

- source-endpoint covariance of the edge difference;
- gauge invariance of the full weighted kinetic-plus-potential functional;
- nonnegativity under nonnegative weights and quartic coupling;
- exact frozen-modulus reduction to weighted link mismatch;
- zero cost for a covariantly constant frozen-modulus vacuum.

## Exact target

`AgentTasks/aristotle-standalone/geometry-weighted-higgs-functional-20260716/GeometryWeightedHiggsFunctional/Core.lean`

Preserve every public definition and theorem statement. Small private helpers
are welcome. Do not replace exact equalities with asymptotic statements or add
new assumptions.

## Scope boundary

The edge and vertex weights are supplied real background data. This target
does not derive a graph metric, coframe, volume element, causal-set continuum
limit, Higgs propagator, Higgs pole mass, electroweak doublet, stress tensor,
Einstein equation, or conservation law. The functional is a finite Abelian
control model and must not be promoted as the Standard Model Higgs action.

## Preflight

`lake env lean` accepts the focused source under the pinned toolchain with
exactly five intended proof-hole warnings and no errors. Source SHA-256:
`B0970652B68B980570EB7FD52A1FC936C5A660E47FCC3F4DF1C579030AE2E8DA`.

## Submission metadata

```yaml
aristotle:
  project_id: f0ffff98-a4f2-4a0f-b970-a73c0fd4c1f7
  task_id: d64c4711-647a-4014-a252-4b2b99e553b9
  target_file: GeometryWeightedHiggsFunctional/Core.lean
  expected_module: GeometryWeightedHiggsFunctional.Core
  source_root: AgentTasks/aristotle-standalone/geometry-weighted-higgs-functional-20260716
  submission_project: AgentTasks/aristotle-submit/geometry-weighted-higgs-functional-20260716-project
  integration_target: PhysicsSM/Draft/NullEdge/GeometryWeightedHiggsFunctional.lean
  output_dir: AgentTasks/aristotle-output/f0ffff98-a4f2-4a0f-b970-a73c0fd4c1f7
  status: integrated
```

Submitted as a focused Mathlib package. Aristotle reported the project as
created and the task as `QUEUED`; no wait loop was started.

## Integration

The completed return preserved all five public statements, contained no proof
holes, and replayed locally under the pinned toolchain. The proofs were adapted
to the production namespace in
`PhysicsSM/Draft/NullEdge/GeometryWeightedHiggsFunctional.lean`. The production
module additionally composes the returned finite functional with
`FiniteMatterWeightVariation`, proving the exact supplied-weight derivative and
gauge invariance of that geometry response.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/GeometryWeightedHiggsFunctional.lean
lake build PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional
```

Both passed. Four build-enforced headline guards and the Lean MCP audit report
only `propext`, `Classical.choice`, and `Quot.sound`, with no suspicious source
patterns. The broader `PhysicsSMDraft` build reached 9,315 jobs but remains
blocked by the unrelated deletion of
`PhysicsSM/Draft/NullEdge/SpinCornerBargmannAristotle.lean`.
