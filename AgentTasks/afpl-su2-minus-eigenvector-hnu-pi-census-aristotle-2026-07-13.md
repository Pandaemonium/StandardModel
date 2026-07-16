# Aristotle focused proof: SU(2) minus-eigenvector rigidity and HNU pi census

```yaml
aristotle:
  project_id: 73a1d386-9910-493b-84b2-1867bdf6ef2e
  task_id: ba73ed6f-e5dd-4c2b-b117-277bd9aeec99
  target_file: HNUSU2MinusEigenvectorCensus.lean
  expected_module: HNUSU2MinusEigenvectorCensus
  output_dir: AgentTasks/aristotle-output/73a1d386-9910-493b-84b2-1867bdf6ef2e
  status: integrated-project-reused
```

## Exact target

Using the uploaded Mathlib-only `HNUExactCore.lean`, prove:

1. for `M : Matrix (Fin 2) (Fin 2) Complex`, if `M` is unitary,
   `det M = 1`, and there exists `v != 0` with `M *v v = -v`, then `M = -1`;
2. package the no-`-1`-eigenvector contrapositive when `M != -1`;
3. for the exact HNU endpoint on `[-pi,pi]^3`, existence of a nonzero `-1`
   eigenvector is equivalent to at least one coordinate lying on the boundary
   `+pi` or `-pi`, using the existing exact `pi_census` only after the
   eigenvector-to-matrix bridge is proved;
4. include explicit nonzero boundary witnesses and an interior control;
5. add standard-three axiom guards.

Do not weaken the theorem to the existing matrix equality `endpoint k = -1`.
No proof placeholders, compiled evaluation, or new assumptions.

## Scope

This is an exact finite quasienergy-pi eigenspace census. It does not establish
a winding number, anomaly inflow, bulk-edge correspondence, real-space
locality, or primitive-null support.

## 2026-07-13 harvest and integration

The returned theorem ladder was independently approved by interactive
Claude/Opus. The live integration is
`PhysicsSM/Draft/NullEdge/HNUSU2MinusEigenvectorCensus.lean`. It replaces the
returned coordinate-level automation with the shared determinant-kernel proof
pattern used by the `+1` census, then composes the rigidity bridge with
`HNUExactCore.pi_census`. Direct replay and the targeted Lake build pass.

The Aristotle project has since been reused for the many-step continuum
successor, so the project registry remains running even though this task is
integrated.
