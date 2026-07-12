# Aristotle target: quadratic chirality-mixing regulator

## Objective

Close every proof hole in the focused Mathlib-only target without changing any
statement. The central target is the exact combination:

- zero regulator at the Dirac point,
- zero complete Frechet first derivative there,
- an explicit nonzero finite-momentum fixture,
- exact chirality anticommutation and hence genuine global mixing.

This is a constructive coefficient-level escape resource only. Do not claim a
unitary walk, strict Laurent locality, root exclusion, or a no-doubling result.
Run the narrow target first and return the completed file even if a broad build
is slow.

```yaml
aristotle:
  project_id: f6609f77-513e-4315-a990-9c04e1f5f5cf
  task_id: 189ec6f8-ebf7-4ee3-abf0-56b4320bf8c5
  target_file: QuadraticChiralityRegulator.lean
  expected_module: QuadraticChiralityRegulator
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-quadratic-chirality-regulator-20260711-project
  output_dir: AgentTasks/aristotle-output/f6609f77-513e-4315-a990-9c04e1f5f5cf
  status: landed
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Aristotle closed all nine proof holes without statement changes. Promoted as
`PhysicsSM/Draft/NullEdge/QuadraticChiralityRegulator.lean`; direct Lean PASS
and targeted build PASS (8,026 jobs). Aggregate guard verification is recorded
in the ledger after the joint regulator/A4 guard build.
