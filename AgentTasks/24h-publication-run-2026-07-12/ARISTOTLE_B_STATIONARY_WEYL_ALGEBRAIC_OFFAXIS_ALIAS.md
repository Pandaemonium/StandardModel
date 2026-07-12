# Aristotle: exact algebraic fully off-axis stationary-Weyl alias

Fill all eight proof holes in
`codex_24h_b_stationary_weyl_algebraic_offaxis_alias.lean` without changing any
statement. Exact tangent-half-angle elimination produced the quintic

`480 t^5 - 575 t^4 - 1026 t^2 + 1440 t - 575`,

with a real root in `(149/100, 3/2)`. The other tangent coordinates are the
displayed quartic rational functions. Preserve the actual live `weylStep`
matrix identity and all three nonzero/off-origin controls.

Use the intermediate value theorem for root existence and exact ring/field
normalization for the elimination certificate. If the full matrix identity is
too large, return all proved lemmas plus the exact smallest remaining
polynomial identity; do not weaken the statements silently.

```yaml
aristotle:
  project_id: 5c45a7f6-98de-4974-9feb-4b5acee6a208
  task_id: f61cb46d-360a-4e61-af96-c676001bd83e
  target_file: AgentTasks/aristotle-targets/codex_24h_b_stationary_weyl_algebraic_offaxis_alias.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlgebraicOffAxisAlias
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-stationary-weyl-algebraic-offaxis-alias-20260712-project
  output_dir: AgentTasks/aristotle-output/5c45a7f6-98de-4974-9feb-4b5acee6a208
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Harvest and integration

All eight statements returned unchanged and the standalone candidate compiled
under the repository toolchain. The returned isolation package duplicated the
matrix fixture, so it was not landed verbatim: its proof body was adapted into
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylAlgebraicOffAxisAlias.lean`
with the actual live `StationaryAmplitudeWeylTangent` and
`StationaryAmplitudeProjectorWalk` declarations imported. The adapted live
module directly passes Lean and pins the standard axiom footprint.

The exact matrix identity landed in full. The separate real-root
classification module proves that this same quintic has exactly one real root.
This remains a single fully off-axis branch theorem, not a complete torus
census.
