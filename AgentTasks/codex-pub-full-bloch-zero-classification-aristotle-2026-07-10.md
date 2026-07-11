# Aristotle proof task: complete massive full-Bloch zero sets

Prove both exact bounded real-polynomial zero-set classifications in
`FullBlochZeroClassification/Main.lean` without changing their statements.

The determinant identities are already kernel-checked elsewhere.  This task is
the remaining real-algebra theorem: for momentum cosines in `[-1,1]` and
`0 < |c| < 1`, each determinant polynomial vanishes exactly when all three
cosines vanish.  Preserve the absolute-value hypotheses because they cover
both signs of the mass-angle cosine.  Do not replace the theorem by corner
sampling, strict positivity away from an epsilon ball, or a finite grid.

You may add helper lemmas giving a sum-of-squares decomposition, AM-GM bound,
or reduce `piPoly` to `zeroPoly` by a sign change.  The exact body-center and
`3/5` nonzero controls must remain.

If the statement is false, return an exact rational/algebraic counterexample in
the displayed domain.  Numerical evidence is not a proof.

Manuscript consequence: success upgrades the body-center witness to a complete
all-zone classification of zero- and pi-quasienergy modes on the principal
massive branch.  It does not construct an alias-free successor.

```yaml
aristotle:
  project_id: efc99053-8082-4063-9d33-c4cc4a68106f
  target_file: FullBlochZeroClassification/Main.lean
  expected_module: FullBlochZeroClassification.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-full-bloch-zero-classification-20260710-project
  output_dir: AgentTasks/aristotle-output/efc99053-8082-4063-9d33-c4cc4a68106f
  status: submitted
  run: overnight-publication-run-2026-07-11
  owner: Codex
```
