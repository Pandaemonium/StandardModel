# Aristotle audit: complete even Krein-sector signature

Name this project `codex-pub-krein-sector-signature-audit-20260711`.

Perform a hostile review-only audit of the supplied complete
`ChannelKreinSectorSignature/Main.lean`. Do not edit the source.

Check independently:

1. The `eta` and `Gam` signs and the six-coordinate normal form.
2. Exhaustiveness: every chirality-even, Krein-self-adjoint rational `4x4`
   matrix has the form, with no hidden reality, symmetry, or block hypothesis.
3. Coordinate uniqueness.
4. Exact self-pairing formula and the claimed four-positive/two-negative square
   decomposition.
5. Positive definiteness of the diagonal sector and strict negativity of the
   remaining plane away from zero.
6. Assumption footprint, vacuity, false shape, convention drift, and prose
   scope.

The publication boundary is binding: the theorem classifies one supplied live
Krein form. It does not make the diagonal sector physical, place named channels
in it, or derive a positive information metric.

Return PASS/FAIL, severity-ranked findings, and the strongest safe publication
sentence.

```yaml
aristotle:
  project_id: 340d96e0-e10d-475a-8410-bad3773b20fd
  target_file: ChannelKreinSectorSignature/Main.lean
  expected_module: ChannelKreinSectorSignature.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-krein-sector-signature-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/340d96e0-e10d-475a-8410-bad3773b20fd
  status: audited-pass
  run: overnight-publication-run-2026-07-11
  owner: Codex
```
