# Aristotle proof task: six-channel full-Bloch relaxed witness

Prove every unchanged theorem in `AxisBlockBloch/Main.lean`. Start with:

`lake env lean AxisBlockBloch/Main.lean`

The target is the exact Bloch symbol of the existing six-direction finite-range
axis-block walk. Prove both determinant product formulas over all real momenta,
the global nonvanishing consequences, and the exact origin/body-center
controls. Do not replace the full-zone statements with corner sampling or a
numerical test. Small determinant/block-factorization helpers are encouraged.

Semantic boundary: this is a relaxed alias-free QCA witness only. It must not
be relabeled as the desired Dirac successor; the live theorem
`axisBlockCoin_has_no_complex_clifford_block` rules out a four-component
Clifford restriction for this particular coin. If either determinant formula
has a phase-sign error, return the exact counterexample and corrected formula
instead of silently changing the statement.

```yaml
aristotle:
  project_id: 7e4e9f45-5a63-4120-9dad-cd90d43c9733
  task_id: 452a69b1-c73b-4c85-a56d-e05c464ee59f
  target_file: AxisBlockBloch/Main.lean
  expected_module: AxisBlockBloch.Main
  submission_project: AgentTasks/aristotle-submit/axis-block-full-bloch-20260710-project
  output_dir: AgentTasks/aristotle-output/7e4e9f45-5a63-4120-9dad-cd90d43c9733
  status: submitted
```
