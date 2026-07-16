# Aristotle focused proof: SU(2) fixed-vector rigidity and HNU census

```yaml
aristotle:
  project_id: c626cb61-f1db-49ff-aa41-a9d96e9152ad
  task_id: 29712ef5-7778-455e-b9b8-416d9ec25ac7
  target_file: HNUSU2FixedVectorCensus.lean
  expected_module: HNUSU2FixedVectorCensus
  output_dir: AgentTasks/aristotle-output/c626cb61-f1db-49ff-aa41-a9d96e9152ad
  status: integrated
```

## Exact target

Using the uploaded Mathlib-only `HNUExactCore.lean`, prove:

1. for `M : Matrix (Fin 2) (Fin 2) Complex`, if `M` is unitary,
   `det M = 1`, and there exists `v != 0` with `M *v v = v`, then `M = 1`;
2. equivalently package the no-fixed-vector contrapositive when `M != 1`;
3. for the exact HNU endpoint on the closed cube `[-pi,pi]^3`, existence of a
   nonzero `+1` eigenvector is equivalent to `k = 0` coordinatewise;
4. include an explicit nonzero fixed vector at the origin and a non-origin
   control with no nonzero fixed vector;
5. add standard-three axiom guards.

The theorem must concern a nonzero eigenvector, not merely reuse the existing
matrix-equality census as its conclusion. Do not assume diagonalizability or a
spectral theorem unless its exact finite hypotheses are discharged. No proof
placeholders, compiled evaluation, or new assumptions.

## Scope

This upgrades the exact finite HNU zero-quasienergy census. It does not prove a
winding number, chirality, a real-space QCA, primitive-null support, or bulk-edge
correspondence.

## 2026-07-13 harvest

Task `29712ef5-7778-455e-b9b8-416d9ec25ac7` completed with no proof
placeholders and standard-three guards. The returned module proves an actual
nonzero `+1` eigenvector rigidity theorem for determinant-one unitary `2 x 2`
matrices and composes it with the existing HNU endpoint matrix census.

The result was adapted for the live import path and module documentation at
`PhysicsSM/Draft/NullEdge/HNUSU2FixedVectorCensus.lean`. Direct replay passed.
Interactive Claude approved the semantic alignment in
`CLAUDE_REVIEW_HNUSU2FixedVectorCensus_2026-07-13.md`; aggregate imports and
central standard-three guards now include the result.
