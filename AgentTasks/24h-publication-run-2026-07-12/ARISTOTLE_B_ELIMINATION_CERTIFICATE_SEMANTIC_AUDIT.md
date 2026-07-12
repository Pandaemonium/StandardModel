# Aristotle audit: exact elimination certificate semantic alignment

Adversarially audit the generated Lean certificate against its exact CAS source
and the displayed stationary-Weyl numerator system. This is a semantic audit,
not a request to admire that `ring` succeeds.

Check all of the following independently:

1. `certFx`, `certFy`, and `certFz` match the displayed numerator polynomials,
   including every sign and integer scale.
2. `certRootPoly` and `certExcludedPoly` match the independently classified
   quintic and positive sextic.
3. The generated `certQx`, `certQy`, and `certQz` match the exact generator
   hashes and contain no truncation or transcription drift.
4. The Lean theorem includes the mandatory `(1 + tz^2)^2` factor and makes no
   false bare-ideal-membership claim.
5. The real consequence cancels only a provably nonzero chart factor and draws
   exactly the three permitted factor alternatives.
6. State clearly that this certificate does not itself connect the numerator
   equations to the imported live matrix `weylStep`; identify the exact bridge
   still owed.

Return findings ordered by severity, with file/line references and a verdict:
SOUND, SOUND WITH SCOPE CORRECTION, or UNSOUND. Do not edit files.

```yaml
aristotle:
  project_id: f1cac1e4-b5d9-4a6c-aa26-954f6d9f6fdc
  task_id: 246527ab-a1b6-4d7d-8aeb-74ad4c899f55
  target_file: PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylEliminationCertificate.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylEliminationCertificate
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-elimination-semantic-audit-20260712-project
  output_dir: AgentTasks/24h-publication-run-2026-07-12/B_ELIMINATION_CERTIFICATE_SEMANTIC_AUDIT_REPORT.md
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
