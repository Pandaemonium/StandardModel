# Aristotle target: complete massless Bloch crossing classification

Close every proof hole without changing statements. Prove the exact
sum-of-nonnegative-terms factorizations and classify all zero- and pi-mode
crossings of the actual live ordered walk at `theta=0`:

- the common body-center cosine locus `(0,0,0)`;
- zero-mode cube corners with `x=y*z`;
- pi-mode cube corners with `x=-y*z`.

Preserve the included corner-parity witness and exclusion control. Do not claim
local Jacobian signs, a total charge sum, or a continuum theorem. The output is
an exact crossing-set census only.

```yaml
aristotle:
  project_id: 30627d07-edbf-449a-b199-39aa4a96b257
  task_id: f224372f-cf80-4d1b-9e7f-6553e2752c30
  target_file: PhysicsSM/Draft/NullEdge/MasslessBlochCrossingClassification.lean
  expected_module: PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-massless-bloch-crossings-20260711-project
  output_dir: AgentTasks/aristotle-output/30627d07-edbf-449a-b199-39aa4a96b257
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Integrated 2026-07-11. Both full biconditionals for the live massless `4x4`
zero/pi determinant sets and the parity control pass direct Lean, targeted
build, and the aggregate axiom guard. This is not the branch-resolved positive
Weyl census.

Direct target typecheck PASS with seven isolated proof holes before submission.
