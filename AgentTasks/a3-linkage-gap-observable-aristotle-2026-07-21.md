# Aristotle task: A3 observable-to-gap linkage

Date: 2026-07-21
Owner: Opus; integration owner: Codex
Work item: `MASS-ORIGIN-001`
Status: integrated and guarded

## Objective

Isolate the exact nonzero-overlap condition needed for a gauge-invariant
observable to detect the first excited transfer gap, with faster-decay and
gauge-invariance counterexamples when linkage fails.

## Claim boundary

This is a finite spectral/observable theorem. It does not derive reflection
positivity, a strict gap, overlap for the `SU(3)` plaquette, a continuum pole,
or a QCD hadron mass.

```yaml
aristotle:
  project_id: a6f3c703-1cb4-47d1-813a-f6d4b0da7a2b
  task_id: b6253bcc-8e26-4d61-8a6f-acab187bc475
  target_file: PhysicsSM/Draft/NullEdge/ObservableGapLinkage.lean
  expected_module: PhysicsSM.Draft.NullEdge.ObservableGapLinkage
  submission_project: AgentTasks/aristotle-standalone/a3-linkage-gap-observable-20260721
  output_dir: AgentTasks/aristotle-output/a6f3c703-1cb4-47d1-813a-f6d4b0da7a2b
  status: integrated
```

## Integration

The returned source was reviewed against the prompt and its completion report.
The prompt's literal claim that any three of four obligations fail was too
strong: gauge invariance is not analytically needed after overlap and the
spectral asymptotic have been supplied, though it remains required for the
intended physical gauge observable. The landed module records that correction,
retains the positive linkage theorem, the skipped-first-excitation faster-decay
witness, and both directions of gauge-invariance/overlap independence.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/ObservableGapLinkage.lean`
- `lake build PhysicsSM.Draft.NullEdge.ObservableGapLinkage`
- `lake build PhysicsSM.Draft.NullEdge.OriginMassAxiomGuard`

All passed. The guard pins the standard-three assumption footprint.
