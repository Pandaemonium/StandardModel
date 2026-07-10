# Codex proof job: nondegenerate quartet closed-sector positivity

Close every proof in `QuartetPositive/Core.lean` without changing definitions,
statements, coefficients, or fixture vectors. Prove that the nondegenerate
indefinite quartet has a globally positive-semidefinite decoder pairing
`B x (S x) = (4/25)(x 2)^2`, and use it to prove every normalized closed
eigenvector has nonnegative eigenvalue. Preserve the exact/nonclosed pairing,
the positive physical direction, and the negative Krein control.

This closes the conditional-positivity gap identified by the physical-mass
audit for the explicit quartet. It does not prove positivity for every carrier
or derive the decoder from primitive histories.

PhysLean reference: `QuadraticForm.posDef_no_neg_weights` and the finite metric
quadratic-form APIs found in the 00:35 package pass. Use as theorem-shape
references only; the submitted file is Mathlib-only.

Run `lake env lean QuartetPositive/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/quartet-closed-sector-positivity-20260710-20260710-003855.md`.

```yaml
aristotle:
  project_id: 8bac8cce-0a1d-4744-a0b7-3f7e6e5731cb
  target_file: QuartetPositive/Core.lean
  expected_module: QuartetPositive.Core
  submission_project: AgentTasks/aristotle-submit/codex-quartet-closed-sector-positivity-20260710-project
  output_dir: AgentTasks/aristotle-output/8bac8cce-0a1d-4744-a0b7-3f7e6e5731cb
  status: running
```
