# Aristotle re-audit: Paper C full-walk controls and corrected prose

Name this project `codex-pub-paper-c-control-prose-reaudit-20260711`.

Perform a hostile review-only audit. Do not edit files and do not build the
full repository. Read the exact supplied Lean modules and the corrected Paper C
draft, Paper A abstract excerpt, GA phase excerpt, claim matrix, and gate matrix.

Audit:

1. Verify that each displayed rational matrix in
   `HalfWindingFullWalkControls.lean` matches the corresponding live `Wzero` or
   `Wfour` basis order and that each supplied left inverse has the orientation
   needed to prove injectivity of `W +/- 1`.
2. Check the four no-mode deductions for sign mistakes: which shift excludes
   `+1`, which excludes `-1`, and whether the `mulVec` composition is correct.
3. Check that `Wzero_Bfix` and `Wfour_Bfix` establish honest invariant
   compressions but do not imply a family theorem.
4. Compare every corrected prose sentence with the exact declarations in
   `ModeInvariantHalfWinding`, `HalfWindingFullWalkControls`, and
   `WallModeWitness`. Flag any surviving claim of a formal half-winding
   invariant, quantified wall-count iff, perturbation stability/protection,
   generic localization, or bridge to `PlueckerWindingDerived`.
5. Check trust disclosure: abstract engine standard-three versus explicit
   rational fixture use of `Lean.ofReduceBool`/`Lean.trustCompiler`.
6. Give PASS/FAIL, severity-ranked findings, and exact replacement text for any
   remaining overclaim. State the strongest safe one-sentence Paper C result.

The intended safe scope is: exact two-wall sign-mode existence, complete
displayed zero/four no-sign-mode controls, and exact localization only in the
separate displayed `WallModeWitness` family. No generic topological theorem.

```yaml
aristotle:
  project_id: 8f6b11dd-a9df-4167-95ca-5096d74d3f08
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-paper-c-control-prose-reaudit-20260711-project
  output_dir: AgentTasks/aristotle-output/8f6b11dd-a9df-4167-95ca-5096d74d3f08
  status: harvested-pass-corrections-applied
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Live instruction

At 01:37 PDT, after submission, the live control module gained exact complex
scalar-extension theorems for all four no-mode controls. An `instruct` message
asked the auditor to report the rational/complex gap against its snapshot but
to assess whether the described entrywise `toC` transport closes it
mathematically. The new declarations are
`toC_Wzero_no_neg_mode`, `toC_Wzero_no_pos_mode`,
`toC_Wfour_no_neg_mode`, and `toC_Wfour_no_pos_mode`.

## Harvest disposition

The hostile audit returned PASS at the intended fixture-level scope. It
independently rederived the matrix basis order, all four left inverses, sign
orientation, and compression identities. The live complex scalar extensions
close the snapshot's rational/complex comparison gap. All prose findings were
applied: the second family now claims one explicit mode at each sign rather than
`2+2` multiplicity, names `Q(i)` amplitudes, drops an unproved decay law, and is
correctly labeled kernel-only. Report:
`AgentTasks/aristotle-output/8f6b11dd-a9df-4167-95ca-5096d74d3f08/result/codex-pub-paper-c-control-prose-reaudit-20260711-project_aristotle/AUDIT_PaperC_FullWalkControls_ReAudit_2026-07-11.md`.
