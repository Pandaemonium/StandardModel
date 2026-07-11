# Aristotle audit task: harvested full-Bloch helper base

Adversarially audit the included harvested `NullEdgeBlochDet/Determinants.lean`
that now feeds separate plus/minus determinant proof jobs.

Check:

- `det_fin_four` against Mathlib determinant conventions and all 24 signs;
- `factor_alpha1/2/3` and `factor_beta` against the source Clifford matrices;
- every row/column and multiplication order in the huge `splitStep_eq`;
- whether any increased heartbeat/depth setting masks a semantic or trust issue;
- whether the helpers preserve the original split-step and zero/pi polynomial
  conventions rather than proving a corrected-but-different object;
- exact placeholder and axiom footprint.

Use independent symbolic or finite-entry checks where useful.  Return findings
ordered by severity, the exact declaration/entry for any mismatch, and whether
the plus/minus proof jobs may safely rely on the helper base.  Do not edit or
weaken the source.

```yaml
aristotle:
  project_id: d7f9f742-6ec0-4b2c-9126-59ced5e17929
  task_id: 4b2768bd-ed64-4961-b59e-3bc460ad7cde
  target_file: FullBlochHelperAudit/Main.lean
  expected_module: FullBlochHelperAudit.Main
  submission_project: AgentTasks/aristotle-submit/full-bloch-helper-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/d7f9f742-6ec0-4b2c-9126-59ced5e17929
  status: completed-invalid-scope
```

## Disposition

The completed audit inspected the old standalone
`null-edge-full-bloch-determinants-only-20260710` source, not the preserved
snapshot copied into the plus/minus submission packages. Its S1/S2 findings
are correct for that old file but do not apply to the helpers used by projects
`d13856aa` and `5337cc9e`. Those projects contain a different
`NullEdgeBlochDet/Determinants.lean` with proved `det_fin_four`, four factor
lemmas, and `splitStep_eq`. Do not cite this audit as validation or rejection
of the split-job helper base. A replacement audit against the exact submitted
file is required.
