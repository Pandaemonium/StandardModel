# Aristotle target: actual live Weyl Jacobian extraction

Close every proof hole without changing statements. First prove the exact Pauli
decomposition of the ordered product built from the live restricted Pauli
generators. Then prove that the displayed real `3 x 3` matrix is the actual
complete Frechet derivative of its Pauli vector, factor its determinant exactly,
and connect the origin and rank-deficient controls to the existing charge API.

This is the missing live-symbol-to-supplied-Jacobian bridge. Do not claim the
crossing set is complete or that the global charge sum vanishes; those are
separate targets.

```yaml
aristotle:
  project_id: 6a25f9f7-4036-47ea-95a6-d677f0b812ce
  task_id: 6d1262ee-0b05-45ee-90f7-3ab927e6edb1
  target_file: PhysicsSM/Draft/NullEdge/LiveWeylJacobian.lean
  expected_module: PhysicsSM.Draft.NullEdge.LiveWeylJacobian
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-live-weyl-jacobian-20260711-project
  output_dir: AgentTasks/aristotle-output/6a25f9f7-4036-47ea-95a6-d677f0b812ce
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Direct target typecheck PASS with seven isolated proof holes before submission.
The exact determinant factor and sample signs were independently checked by
SymPy; the oracle is recorded separately and is not proof.

Integrated 2026-07-11. The Pauli decomposition, complete Frechet derivative,
determinant factor, origin charge, and rank-deficient control pass direct Lean,
targeted build, and the aggregate axiom guard. The exact bridge to the census
was subsequently landed in `LiveMasslessWeylCensusBridge`.
