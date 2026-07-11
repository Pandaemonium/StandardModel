# Aristotle audit: Paper D quantitative-tail and DFT round-trip prefixes

Perform a hostile review-only audit of `SobolevTailRate.lean` and
`LiveDFTComposition.lean` against the Paper D gate and claim matrix supplied.
Do not edit files.

Check:

1. the exact exponent and off-by-one constant in the `(N+2)^(-s)` squared-tail
   estimate;
2. whether `weightedModeEnergy`, `modeEnergy`, and the residual identity have
   the claimed coefficient-space meaning;
3. whether the boundary delta control is genuinely nonzero and sharp at the
   pointwise weight level;
4. both DFT round trips under the exact positive-character and
   `1/sqrt(siteCard)` convention;
5. whether `fourier_modeState` has the correct momentum orientation and
   normalization;
6. any hidden use of finite-dimensionality, positivity, or a continuum
   identification absent from the statements;
7. every phrase that would falsely upgrade these results to Parseval, live
   operator conjugacy, Shannon interpolation, physical scaling, or Dirac PDE
   convergence.

Return `FATAL`, `MAJOR`, `MINOR`, and `CLEAR` findings, exact replacement
language for any mismatch, a declaration-by-declaration verdict table, and a
final `PASS`, `PASS WITH WORDING`, or `FAIL`. Treat missing imports in this
flattened no-build packet as a packaging limitation, not evidence against a
live declaration unless the theorem statement itself is malformed.

```yaml
aristotle:
  project_id: 5351a06b-d451-4025-bff4-2f93aee75889
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-paper-d-prefix-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/5351a06b-d451-4025-bff4-2f93aee75889
  status: harvested/integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

Aristotle returned `PASS WITH WORDING`. The coefficient-space tail exponent,
off-by-one constant, boundary control, both DFT round trips, and plane-wave
orientation were accepted. The source now says `max-coordinate polynomial
weighted` rather than implying a Euclidean Sobolev norm, and the DFT
normalization docstring now explicitly leaves Parseval/unitarity to successor
theorems. No continuum, operator-conjugacy, or PDE claim was promoted.
