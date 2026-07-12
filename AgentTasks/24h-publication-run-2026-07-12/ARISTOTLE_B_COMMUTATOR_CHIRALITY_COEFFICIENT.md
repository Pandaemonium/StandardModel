# Aristotle target: commutator chirality coefficient

Close every proof hole without changing statements. Prove the general
even/odd commutator algebra, then instantiate it on the live
`Xi/alpha1/beta` Clifford matrices with a genuinely nonzero fixture. Preserve
the commuting-generator zero control.

This target identifies only the algebraic Lie coefficient expected at mixed
second order. Do not claim an analytic Taylor theorem, exact Laurent
realization, or root exclusion.

```yaml
aristotle:
  project_id: 88d35131-fb77-4e3b-9c83-03c26f907b6f
  task_id: 125bcd8d-3b1c-46d7-b8e7-09f3c1df8a57
  target_file: AgentTasks/aristotle-targets/codex_24h_b_commutator_chirality_coefficient.lean
  expected_module: PhysicsSM.Draft.NullEdge.CommutatorChiralityCoefficient
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-commutator-chirality-coefficient-20260711-project
  output_dir: AgentTasks/aristotle-output/88d35131-fb77-4e3b-9c83-03c26f907b6f
  status: landed
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Direct target typecheck PASS with eight isolated proof holes before submission.

Aristotle closed all eight proof holes without statement changes. Promoted as
`PhysicsSM/Draft/NullEdge/CommutatorChiralityCoefficient.lean`; direct Lean and
targeted build PASS (8,031 jobs). Aggregate guard verification is pending the
next joint guard build.
