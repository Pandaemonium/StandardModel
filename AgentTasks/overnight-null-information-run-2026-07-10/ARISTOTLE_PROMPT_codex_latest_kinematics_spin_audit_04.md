# Codex audit job 04: D4, unitary step, SU(2), Gram, and Fourier chain

Independently audit every supplied source and the current theory/claim matrices.
Findings first, ordered by severity. Check:

- whether selecting twelve D4 roots after naming a time coordinate supports an
  honest 3+1 luminal alphabet and exactly what is not derived;
- whether `NormalizedCliffordUnitaryStep.step_unitary` is genuinely two-sided
  and whether its rational witness carries a nonzero mass coefficient;
- whether `SU2SpinHalfAction` correctly connects the landed determinant-fixed
  factor fiber to a defining spin-half representation without claiming a
  particle sector or spin-statistics;
- whether `GeneralGramTurnScale` really removes the canonical-pair restriction;
- whether `FiniteFourierContinuumLift` is position-space convergence only on a
  fixed finite grid;
- whether `CheckerboardOperatorHistoryBridge` is a genuine composition arrow or
  merely notation;
- every nondegeneracy control, hidden dictionary, convention mismatch, and
  docstring that outruns the kernel statement.

Return `LATEST_KINEMATICS_SPIN_AUDIT_04.md` with CLOSED/PARTIAL/OPEN findings,
the strongest honest manuscript paragraph, and the single most important exact
next theorem. Do not edit source files.

```yaml
aristotle:
  project_id: 31c1ac53-6bed-4dc6-a697-1a45888f1251
  target_file: LATEST_KINEMATICS_SPIN_AUDIT_04.md
  submission_project: AgentTasks/aristotle-submit/codex-latest-kinematics-spin-audit-20260710-04-project
  output_dir: AgentTasks/aristotle-output/31c1ac53-6bed-4dc6-a697-1a45888f1251
  status: running
```
