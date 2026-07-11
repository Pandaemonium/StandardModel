# Aristotle audit: positive quadratic channel-selector family

Name this project `codex-pub-quadratic-selector-audit-20260711`.

Perform a hostile review-only semantic audit of the supplied exact Lean module
and Paper F claim/gate/program excerpts. Do not edit files and do not build the
full repository.

Check:

1. Re-derive `weighted_completion_identity` and verify every coefficient.
2. Verify that `selected_unique_of_cost_le` really proves unique global
   minimization on the fixed-total fibre for all strictly positive weights,
   without a hidden differentiability, nonzero-total, or sign assumption.
3. Check the exact equal-weight and `1,2,3` witnesses and confirm both totals
   equal one and the selected triples differ.
4. Audit the interpretation: the theorem may say strict convexity selects a
   unique decomposition after a metric is supplied. It may not say the metric,
   physical channels, or information resource was derived.
5. Test vacuity, hollow telescoping, false shape, and docstring-overreach.
6. Return PASS/FAIL, severity-ranked findings, the strongest safe one-sentence
   result, and the precise theorem needed to lift the result to a finite real
   inner-product operator space.

```yaml
aristotle:
  project_id: f6905c13-63fa-454b-a6ff-2d2a54dd6fde
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-quadratic-selector-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/f6905c13-63fa-454b-a6ff-2d2a54dd6fde
  status: harvested-pass
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Live instruction

After submission, the live module gained proved adjacent-swap invariance iff
weight-equality theorems, their full-permutation conjunction, and the exact
equal-thirds corollary. The current source was uploaded with an instruct message
asking for a separate addendum and explicit policing of the conditional
channel-exchange-symmetry interpretation.

## Harvest disposition

PASS, including the symmetry addendum. The audit independently rederived the
completion identity, unique global minimizer, concrete metric-disagreement
witnesses, and adjacent-swap iff weight-equality theorems. It correctly noted
that the equal-thirds algebraic formula only needs a nonzero common weight,
while the minimizer interpretation needs positivity. The live module now makes
that distinction executable via `positive_symmetric_unique_equal_thirds` and
adds individual guards. Report:
`AgentTasks/aristotle-output/f6905c13-63fa-454b-a6ff-2d2a54dd6fde/result/output-final_aristotle/AUDIT_codex-pub-quadratic-selector-audit-20260711.md`.
