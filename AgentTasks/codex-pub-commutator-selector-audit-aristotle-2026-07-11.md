# Aristotle audit: commutator-blind selector classification

Name this project `codex-pub-commutator-selector-audit-20260711`.

Perform a hostile review-only semantic and proof audit of the supplied complete
`ChannelCommutatorSelector/Main.lean`. Do not weaken statements and do not edit
the source.

Check independently:

1. Both matrix-unit commutator identities, including the off-diagonal sign.
2. The deduction that a commutator-blind linear functional vanishes on all
   off-diagonal units and is constant on diagonal units.
3. The exact normalization `f X = (f 1 / 4) * trace X` for arbitrary `4 x 4`
   rational matrices, not merely diagonal matrices.
4. The explicit nonzero trace-zero witness and the no-injectivity corollary.
5. Whether `CommutatorBlind` is vacuous or incorrectly conflated with every
   conceivable conjugation-invariant, spectral, nonlinear, vector-valued,
   locality, positivity, or information-theoretic selector.
6. Proof hygiene and assumption footprint. Report any statement change,
   hidden hypothesis, false-shape issue, or overclaim.

Return PASS/FAIL, severity-ranked findings, and the strongest safe
publication sentence.

```yaml
aristotle:
  project_id: dfe5e4dc-ef6a-4ac9-a469-7375d452e1fb
  target_file: ChannelCommutatorSelector/Main.lean
  expected_module: ChannelCommutatorSelector.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-commutator-selector-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/dfe5e4dc-ef6a-4ac9-a469-7375d452e1fb
  status: audited-pass
  run: overnight-publication-run-2026-07-11
  owner: Codex
```
