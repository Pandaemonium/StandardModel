# Hostile audit: full live-Bloch global chirality boundary

Audit `FullBlochGlobalChirality.lean` against the live factor order and the
manuscript. Check:

- the exact commutator formula and every sign/order;
- the determinant-one/nonzero core used in the reverse implication;
- whether `sin(theta)=0` includes all and only the globally split mass angles;
- the quarter-turn noncommuting witness;
- whether any prose confuses exit from the global chiral class with removal of
  doublers, alias freedom, or a successful massive QCA.

Return `GLOBAL_CHIRALITY_AUDIT_REPORT.md` with severity-ranked findings and
exact safe wording. Do not edit Lean.

```yaml
aristotle:
  project_id: 9cc3da00-6962-4273-95c6-6a44d25d5114
  task_id: f3ae12f5-8777-4b9f-b97e-97de358bb41e
  target_file: FullBlochGlobalChirality.lean
  expected_module: GLOBAL_CHIRALITY_AUDIT_REPORT.md
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-global-chirality-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/9cc3da00-6962-4273-95c6-6a44d25d5114
  status: reviewed-pass
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Review disposition

The audit found the central iff mathematically correct, exception-free, and
accurately scoped in the manuscript.  Its standalone packet omitted transitive
dependencies, a reproducibility defect in the audit artifact rather than in the
repository build.  The two useful low-severity successors were landed locally:
`Xi_conjTranspose` proves the advertised Hermitian grading, and
`massless_splitStep_commutes_plusProjector` states the positive-sector
invariance explicitly.  The reviewed report is stored at
`GLOBAL_CHIRALITY_AUDIT_REPORT.md` in this run directory.
