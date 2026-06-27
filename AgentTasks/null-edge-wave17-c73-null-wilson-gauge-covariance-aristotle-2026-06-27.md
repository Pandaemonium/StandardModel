# Aristotle task C73: gauge-covariant null-Wilson link dressing

```yaml
aristotle:
  project_id: 852e9a44-de95-4bb4-ab53-c4fa87e0653f
  task_id: 3793d153-e466-4d39-8cf3-d9bcf1f820bd
  target_file: PhysicsSM/Draft/NullEdgeNullWilsonGaugeCovariance.lean
  expected_module: PhysicsSM.Draft.NullEdgeNullWilsonGaugeCovariance
  submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/852e9a44-de95-4bb4-ab53-c4fa87e0653f
  status: submitted
```

Context pack:

- `AgentTasks/context-packs/null-edge-gate-c-null-wilson-20260627-063900.md`

Goal: prove or scaffold the gauge-covariant link-dressed Wilson regulator.

Target expression:

```text
R_W^A = (r / (2h)) sum_a (2 - T_a^A - (T_a^A)^sharp)
```

Requested theorem package:

```text
nullWilson_gaugeCovariant:
  the link-dressed regulator is gauge-covariant when the shifts/parallel
  transports transform by the usual source/target gauge action.

nullWilson_selfAdjoint_or_KreinAdjoint:
  state exactly which adjointness property is true: Hilbert self-adjoint,
  Krein self-adjoint, or paired retarded/advanced adjointness.

nullWilson_flat_symbol:
  in the trivial flat gauge, recover (r/h) sum_a (1 - cos q_a).
```

If the proof is too dependent on missing local definitions, return a clean API
module with precisely stated structures and assumptions rather than weakening
the claim.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 852e9a44-de95-4bb4-ab53-c4fa87e0653f
task_id: 3793d153-e466-4d39-8cf3-d9bcf1f820bd
submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
target: PhysicsSM/Draft/NullEdgeNullWilsonGaugeCovariance.lean
```
