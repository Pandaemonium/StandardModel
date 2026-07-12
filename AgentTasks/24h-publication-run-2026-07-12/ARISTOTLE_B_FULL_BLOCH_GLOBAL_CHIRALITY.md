# Aristotle target: full Bloch global chirality boundary

## Objective

Close every proof hole in the typechecking target without changing statements.
The flagship theorem is the exact all-momentum criterion

```text
[Xi, splitStep(qx,qy,qz,theta)] = 0 iff sin(theta) = 0.
```

This uses the actual live ordered Bloch step and the same constant chirality as
the landed cubic Weyl-sector tangent. Preserve the explicit quarter-mass
noncommuting control. The result establishes when a global sector split exists;
it does not prove a sector charge sum or no doubling.

Run the target directly first. Do not alter the walk, reorder factors, weaken
the iff, or replace the nonzero control with an assumption. Return the current
target immediately if a broad build is slow.

```yaml
aristotle:
  project_id: d9517f33-6fc6-4c5e-a9c9-556fedefc5ad
  task_id: dc9dc4fa-88ef-4ba8-ad12-e4f1aec0bf41
  target_file: AgentTasks/aristotle-targets/codex_24h_b_full_bloch_global_chirality.lean
  expected_module: PhysicsSM.Draft.NullEdge.FullBlochGlobalChirality
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-full-bloch-global-chirality-20260711-project
  output_dir: AgentTasks/aristotle-output/d9517f33-6fc6-4c5e-a9c9-556fedefc5ad
  status: landed
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Context pack:
`AgentTasks/context-packs/full-bloch-global-chirality-20260711-170311.md`.
The target directly typechecks with nine isolated proof holes before
submission.

Aristotle closed every theorem without statement changes. Promoted as
`PhysicsSM/Draft/NullEdge/FullBlochGlobalChirality.lean`; direct Lean PASS and
targeted build PASS (8,031 jobs). The flagship exact iff and quarter-mass
control use only the standard axiom footprint. Aggregate guard PASS (8,297
jobs).
