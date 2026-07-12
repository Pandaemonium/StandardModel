# Hostile audit: massless ordered-Pauli crossing census

Audit the proposed exact 16-crossing census, its zero/pi branch assignment,
Jacobian signs, separate charge cancellation, torus boundary conventions, and
the narrow literature-based originality claim.  The unfinished Lean targets
are evidence to inspect, not presumed theorems.

```yaml
aristotle:
  project_id: 9abaa7c3-b32f-4e04-831d-850c06cffb1a
  task_id: 656cb806-ac71-4ef4-8edd-b1051c7969b2
  target_file: codex_24h_b_massless_bloch_crossing_classification.lean
  expected_module: MASSLESS_CENSUS_AUDIT_REPORT.md
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-massless-census-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/9abaa7c3-b32f-4e04-831d-850c06cffb1a
  status: reviewed-partially-integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Disposition

The audit independently confirmed the census mathematics and returned a
sorry-free Mathlib control proving the determinant identity, all sixteen exact
determinants, and both sector sums. That control was integrated as
`MasslessWeylChargeCensus.lean`. The audit's S1 claim that the live repository
does not build is rejected: its deliberately small packet omitted the
dependency tree, while the live aggregate guard passes. Its key semantic
warning is retained: separate zero/pi cancellation is a `2x2` Weyl-sector
statement; the `4x4` body centers carry both eigenvalues and cannot be naively
partitioned.
