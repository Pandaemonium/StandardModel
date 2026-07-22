# Forward-cone PSD Aristotle task

## Objective

Close the analytic direction of the null-edge kinematic completeness theorem:
a future-pointing non-spacelike real four-vector has a positive-semidefinite
Pauli representative, hence a finite rank-one null-spinor decomposition.

## Result

Aristotle proved the requested Mathlib-only theorem and supporting `2 x 2` PSD
criterion. The final artifact is byte-identical to the locally verified
in-progress snapshot. Its main theorems use only `propext`,
`Classical.choice`, and `Quot.sound`.

The proof was clean-room integrated into
`PhysicsSM/Draft/NullEdge/PluckerMassKinematicCompleteness.lean`, where it was
composed with the existing Pauli round trip, PSD decomposition, and finite
Cauchy-Binet identity to prove
`forwardCone_complete_nullEdge_representation`.

## Aristotle metadata

```yaml
aristotle:
  project_id: fab399da-0f62-4c01-ac3d-61c94365a01a
  task_id: 5c939e95-ed2c-4957-bf05-dadd64c29bb8
  expected_module: Main
  output_dir: AgentTasks/aristotle-output/fab399da-0f62-4c01-ac3d-61c94365a01a
  final_artifact: AgentTasks/aristotle-output/fab399da-0f62-4c01-ac3d-61c94365a01a/completed-20260721
  status: integrated
```

## Verification

- `lake env lean` on the final Aristotle `RequestProject/Main.lean`
- `lake env lean PhysicsSM/Draft/NullEdge/PluckerMassKinematicCompleteness.lean`
- `lake build PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness`

All passed. No proof placeholders or project-specific assumptions were added.
