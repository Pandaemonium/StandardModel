# Aristotle: pointwise unitarity implies a finite Laurent inverse

Run lane: Paper B, second wave. Owner: Codex.

Prove the declarations in
`AgentTasks/aristotle-targets/codex_24h_b_pointwise_unitary_finite_inverse.lean`
without changing their statements. The central target removes the separate
`IsUnit` hypothesis from the landed one-particle determinant-phase theorem.

Mathematical route: prove the scalar rigidity statement for a finite Laurent
polynomial of modulus one at every unit-circle angle, then apply it to the
determinant of the pointwise-unitary matrix and use
`Matrix.isUnit_iff_isUnit_det`. Search Mathlib for trigonometric-polynomial,
polynomial root, reciprocal-polynomial, or Fourier uniqueness lemmas. A clean
algebraic proof after clearing the lowest Laurent exponent is welcome.

Success: all four declarations compile with no proof holes and only the
standard Mathlib axiom footprint. Failure is also valuable if and only if you
return an explicit finite Laurent counterexample and explain why it is
pointwise unitary. Do not weaken `forall q : Real`, replace it by sampled
angles, or assume the desired finite inverse.

Witness: `scalarShift n`. Negative control: `1 + T` at angle zero.

```yaml
aristotle:
  project_id: 4644f3df-cda8-411d-84dc-dc3c7536b058
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_24h_b_pointwise_unitary_finite_inverse.lean
  expected_module: none-handoff
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-pointwise-unitary-finite-inverse-20260711-project
  output_dir: AgentTasks/aristotle-output/4644f3df-cda8-411d-84dc-dc3c7536b058
  status: submitted
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
