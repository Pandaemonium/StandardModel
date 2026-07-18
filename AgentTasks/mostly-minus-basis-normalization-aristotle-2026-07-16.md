# Aristotle job: diagonal mostly-minus basis normalization

Date: 2026-07-16  
Work item: `GRAV-ORDER-OPERATOR-001`  
Status: integrated

Semantic context pack:
`AgentTasks/context-packs/mostly-minus-basis-normalization-20260716-20260716-214221.md`
(SHA-256 `6BE233E783ABF8BDF3C28CF2921DBCC24A0921A4DD069DC13F848196B108F4F7`).

## Objective

Prove the exact finite-dimensional normalization bridge from a supplied
diagonal Gram matrix

```text
diag(timeNorm, -spaceNorm, -spaceNorm, -spaceNorm)
```

with positive scales to the exact mostly-minus Minkowski matrix
`diag(1,-1,-1,-1)` in a rescaled basis.

## Exact target

`AgentTasks/aristotle-standalone/mostly-minus-basis-normalization-20260716/MostlyMinusBasisNormalization/Core.lean`

Preserve every public definition and the theorem statement. Small private
helpers are welcome. The intended proof rescales the supplied basis by
reciprocal square roots, using nonzero real units. Do not assume the normalized
basis or weaken exact matrix equality to a sign-only statement. If the target
is false, return the minimal counterexample and a corrected statement.

## Scope boundary

This is conditional finite linear algebra. It does not construct a shell
projector, time probe, rank-four sector, or causal-order selector, and it proves
no availability, overlap, refinement, continuum, curvature, or Einstein-equation
claim.

## Preflight

`lake env lean` accepts the focused source under the pinned toolchain with
exactly one intended proof-hole warning and no errors. Source SHA-256:
`FDF1527DEDC44E896587ACCD8FB070770D8C35DB69B683455136F04623264F70`.

## Submission metadata

```yaml
aristotle:
  project_id: b4aedfd5-f347-44cb-bd79-7f642abcc218
  task_id: 509c4735-0775-476c-9e2e-ce81db6e5278
  target_file: MostlyMinusBasisNormalization/Core.lean
  expected_module: MostlyMinusBasisNormalization.Core
  source_root: AgentTasks/aristotle-standalone/mostly-minus-basis-normalization-20260716
  submission_project: AgentTasks/aristotle-submit/mostly-minus-basis-normalization-20260716-project
  integration_target: PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean
  output_dir: AgentTasks/aristotle-output/b4aedfd5-f347-44cb-bd79-7f642abcc218
  status: integrated
```

Submitted as a focused Mathlib package. Aristotle reported the project as
created and the task as `QUEUED`; no wait loop was started.

## Integration

The completed candidate preserved the exact theorem statement and replaced
the single proof hole with reciprocal-square-root basis scaling. It replayed
locally under the pinned toolchain. The calculation was adapted to the
production `SectorFrame`, `sectorGram`, and `HasSectorLorentzianInertia` API in
`PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean` without changing
the public project theorem.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean
lake build PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia
```

Both passed. The production theorem's axiom audit reports only `propext`,
`Classical.choice`, and `Quot.sound`, with no suspicious source patterns.
