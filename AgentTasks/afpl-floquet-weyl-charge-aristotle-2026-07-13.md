# Aristotle target: local Weyl orientation charge

Prove every target in `FloquetWeylCharge/Charge.lean` without changing any
statement. Keep the determinant convention exactly as written. The key output
is the proper-frame invariance and reflection sign flip, not merely the
identity-matrix witness. Run the narrow file first and return the completed
source with its exact axiom footprint. This is AF2 of the anomalous-Floquet
3+1 route; it is a local crossing theorem, not a global crossing census.

```yaml
aristotle:
  project_id: c22b5827-3041-410f-935b-b61a0f4f805e
  target_file: FloquetWeylCharge/Charge.lean
  expected_module: FloquetWeylCharge.Charge
  submission_project: AgentTasks/aristotle-submit/afpl-floquet-weyl-charge-20260713-project
  output_dir: AgentTasks/aristotle-output/c22b5827-3041-410f-935b-b61a0f4f805e
  status: submitted
```

## Semantic correction and replay

The first submitted target used Boolean inequality through a coercion in
`Nondegenerate`. It was rejected before integration. The intended
propositional inequality is now explicit, every theorem is proved locally,
and the corrected proof-complete package is under independent replay:

```yaml
aristotle_v2:
  project_id: 4d78ebba-67b7-4b1c-86fc-72a8e21ef6ba
  target_file: FloquetWeylCharge/Charge.lean
  submission_project: AgentTasks/aristotle-submit/afpl-floquet-weyl-charge-20260713-v2-project
  output_dir: AgentTasks/aristotle-output/4d78ebba-67b7-4b1c-86fc-72a8e21ef6ba
  status: submitted
```
