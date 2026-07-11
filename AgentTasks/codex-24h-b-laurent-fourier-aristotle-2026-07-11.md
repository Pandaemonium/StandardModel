# Aristotle proof job: one-particle Laurent/Fourier flow bridge

Name this project `codex-24h-b-laurent-fourier-20260711`.

Run the narrow target first:

```text
lake env lean LaurentFourierBridge/Main.lean
```

Close the two proof holes in `LaurentFourierBridge/Main.lean` without changing
any public statement. The positive Fourier convention is load-bearing:
`T n` evaluates to `exp(i n q)`. Prove the determinant phase theorem from the
existing unique monomial exponent and use pointwise unitarity at `q=0` to prove
the constant has norm one. Prove the scalar-shift witness directly.

Do not weaken Laurent-ring invertibility to pointwise invertibility. Do not call
the exponent the many-body GNVW index, a three-dimensional invariant, or a
no-doubling theorem. If an API name differs, add a small local helper rather
than changing the theorem.

Required completion report: solved declarations, exact statement changes
(expected: none), remaining holes, assumption footprint, and the command run.

```yaml
aristotle:
  project_id: 3fdb1077-8420-427b-9cbf-9dbee2ed55b3
  task_id: pending
  target_file: LaurentFourierBridge/Main.lean
  expected_module: LaurentFourierBridge.Main
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-laurent-fourier-20260711-project
  output_dir: AgentTasks/aristotle-output/3fdb1077-8420-427b-9cbf-9dbee2ed55b3
  status: landed
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
