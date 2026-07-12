# Hostile audit: corrected 3+1 charge architecture

Audit the revised Route A inference chain against the verbatim Lean sources:

1. `SU2LocalCrossingCharge` proves only the sign of a supplied real Jacobian.
2. A chirally split two-component Weyl tangent can carry local charge `+1` or
   `-1`; this must not be promoted to a four-component Dirac charge.
3. `DiracLocalChargeNeutrality` gives an explicit gapped algebraic mass homotopy
   for a full four-component Dirac block.
4. `ChiralityMixingNecessity` is coefficient algebra only; the analytic
   higher-order conclusion and global no-doubling implication remain separate.

Check vacuity, false shape, hidden topological assumptions, convention drift,
and every sentence in the memo/manuscript excerpts that outruns the kernels.
Return a severity-ranked `CORRECTED_CHARGE_AUDIT_REPORT.md` with exact safe
wording and the smallest missing theorem. Do not prove new results or rewrite
the supplied sources.

```yaml
aristotle:
  project_id: e26a3647-fb1e-419c-9600-576b3eac5aa6
  task_id: b3002737-1c34-485a-b725-1bf8f7e2a8ec
  target_file: CORRECTED_CHARGE_AUDIT_REQUEST.md
  expected_module: CORRECTED_CHARGE_AUDIT_REPORT.md
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-corrected-charge-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/e26a3647-fb1e-419c-9600-576b3eac5aa6
  status: completed-pass-with-wording-edits
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Audit report copied to `CORRECTED_CHARGE_AUDIT_REPORT.md`. Verdict: no critical
kernel flaw, no vacuity, and no hidden topology. The pointwise mass-blend prose
was narrowed from a kernel-checked null-homotopy to an algebraic gapped family;
the finite A4 partner theorem was identified as the smallest missing hinge.
Two audit gaps were superseded immediately after its snapshot: the live cubic
Weyl restriction and the analytic zero-Frechet-derivative regulator have since
landed and are separately guarded.
