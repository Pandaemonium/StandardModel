# Aristotle: corrected stationary-Weyl elimination certificate

The planned Aristotle handoff was closed locally before submission. The exact
generated certificate and its real root-census consequence now live in
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylEliminationCertificate.lean`.
The valid chart-cleared certificate is:

```text
(1 + tz^2)^2 tz rootPoly(tz) excludedPoly(tz)
  = Qx Fx + Qy Fy + Qz Fz.
```

The factor `(1 + tz^2)^2` is mandatory and must not be deleted. The three
numerator-zero hypotheses make the right-hand side zero; over `Real`, the chart
factor is strictly positive, so the remaining product has one of the three
displayed zero factors. The final theorem composes the exact generated
certificate with positivity and zero-product elimination.

This target formalizes the exact CAS lift only. It does not yet prove that the
three displayed numerator polynomials are the entries of the live `weylStep`;
that bridge is a separate successor theorem.

```yaml
aristotle:
  project_id: not_submitted
  task_id: not_submitted
  target_file: PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylEliminationCertificate.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylEliminationCertificate
  submission_project: not_submitted
  output_dir: PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylEliminationCertificate.lean
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
