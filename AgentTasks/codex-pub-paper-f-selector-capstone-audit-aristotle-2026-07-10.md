# Aristotle audit: Paper F selector capstone

Perform a hostile review-only audit of the supplied Paper F torsor,
naturality-no-go, selector-rigidity, conditional two-grading uniqueness, and
classification program. Do not edit files.

Check declaration by declaration:

1. whether the fixed-total fibre is genuinely the complete type-only fibre
   under the stated common linear constraints;
2. whether `invariant_selector_constant` and
   `no_unique_type_invariant_refinement` say exactly what the prose claims and
   use nontriviality essentially;
3. whether `selector_rigid_iff_injective` is a substantive iff rather than a
   definitional restatement;
4. whether the rational-module hypothesis and explicit nonzero witness are
   sufficient and essential in `rationalShift_injective` and
   `no_finite_selector_rigidifies`;
5. whether any finite-target, full-invariance, physical-selector, quotient, or
   canonicity claim is overgeneralized;
6. whether the combined results earn a standalone classification theorem
   section and what exact mathematical object remains necessary for a paper;
7. the strongest safe abstract and conclusion sentences.

Return `FATAL`, `MAJOR`, `MINOR`, and `CLEAR` findings, a theorem-by-theorem
table, exact replacement language, and `PASS`, `PASS WITH WORDING`, or `FAIL`.

```yaml
aristotle:
  project_id: 46e899bd-a59e-440d-9169-e8d530b39409
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-paper-f-selector-capstone-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/46e899bd-a59e-440d-9169-e8d530b39409
  status: harvested/integrated-with-packaging-disposition
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

The review packet failed to build because it was intentionally flattened
without the live `PhysicsSM` import tree or the `GradedDecompUniqueness`
dependency. Those are packet defects, not live failures: all four live modules
and the aggregate guard compile in the repository. The report independently
rechecked the torsor/naturality/rigidity mathematics and found it sound.
Accepted semantic findings: call the present result a moduli/torsor and selector
obstruction package, not a completed physical classification; full invariance
is a sufficient assumed obstruction rather than a minimal hypothesis; the
injectivity iff is exact but elementary; a standalone paper still needs an
intrinsic selector plus explicit physical equivalence/forgetful maps. Full
report: `PAPER_F_SELECTOR_CAPSTONE_AUDIT_2026-07-10.md`.
