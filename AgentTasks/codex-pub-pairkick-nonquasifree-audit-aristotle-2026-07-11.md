# Aristotle audit: finite Pluecker pair kick versus quasi-free lifts

Name this project `codex-pub-pairkick-nonquasifree-audit-20260711`.

Perform a hostile review-only semantic audit. Do not edit files and do not spend
time building the full repository. Read the exact supplied Lean sources:
`PlueckerPairKickNonQuasiFree.lean`, `PlueckerQuarticInteraction.lean`, and
`FiniteCARSecondQuantization.lean`, plus `MANUSCRIPT_CLAIM_MATRIX.md`.

Audit these questions:

1. Does agreement of `pairKick` and `Gamma U` on every singleton basis state
   really force the displayed matrix `U` to equal the identity, with row/column
   orientation checked against `Gamma_apply_singleton`?
2. Does the final two-particle contradiction use the equality in the correct
   direction, or does it silently assume extensionality/linearity not present
   in the theorem?
3. Is “not quasi-free” scientifically standard and exact for the theorem
   `not exists U, pairKick = Gamma U`, or should the manuscript say the narrower
   “not the number-preserving determinant-minor exterior lift of any
   one-particle matrix”? Identify possible Bogoliubov/affine/general Gaussian
   transformations not excluded by this statement.
4. Audit vacuity, hidden hypotheses, basis dependence, number preservation,
   phase normalization, and whether the kick is genuinely nontrivial only on a
   two-particle sector.
5. State the strongest safe paper sentence and every prohibited upgrade to a
   local interaction Hamiltonian, non-Gaussian quantum channel, scattering
   result, or continuum QFT.
6. Propose the single highest-value exact successor theorem that would turn
   this finite separation into a publishable interaction result.

Return severity-ranked findings, a PASS/FAIL verdict, exact replacement
language, and the successor theorem statement. The Lean kernel already accepts
the theorem; this audit is about semantic alignment and scientific scope.

```yaml
aristotle:
  project_id: 4204b732-02bb-404d-8d21-e28410fc1ece
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-pairkick-nonquasifree-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/4204b732-02bb-404d-8d21-e28410fc1ece
  status: harvested-wording-fix-integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Harvest verdict

Task `1a5943a7-cd73-4749-86dc-f4a221318bcc` returned PASS for the exact
`not Gamma(U)` theorem and verified the singleton row/column orientation and
two-particle contradiction. It conditionally failed unqualified
"not quasi-free" wording: the theorem does not exclude number-nonconserving
Bogoliubov transformations, affine maps, or general Gaussian channels.

Integrated response: added the scope-explicit declaration
`witnessPairKick_not_oneParticleExteriorLift`, changed manuscript-facing labels
to number-preserving determinant-minor exterior lifts, and retained the older
declaration name only for compatibility. The report is preserved under this
project's `result/` extraction.
