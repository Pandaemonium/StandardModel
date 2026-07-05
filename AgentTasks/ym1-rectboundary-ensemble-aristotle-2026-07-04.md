# Aristotle task note: YM1 boundary-circuit expectation bridge

```yaml
aristotle:
  project_id: acedaea2-dd0a-4672-baba-fdd3a5ba65ef
  task_id: e8617a3e-9eea-49c1-a6c0-d4819428241e
  target_file: PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryExpectation
  submission_project: AgentTasks/aristotle-submit/ym1-rectboundary-ensemble-20260704-project
  output_dir: AgentTasks/aristotle-output/ym1-rectboundary-ensemble-20260704
  status: harvested-integrated
```

## Purpose

Submit the remaining Q11/YM1 bridge theorem: on the concrete open
`Lx x Ly` rectangle, the link-ensemble expectation of the character of the
full counterclockwise boundary holonomy should equal the exact finite area law

```text
R.character 1 * wilsonNormalizedGamma beta rho R ^ (Lx * Ly).
```

The integrated `RectBoundaryLasso.lean` theorem closes the tree-slice lasso
identity.  This job asks for the expectation-level bridge to
`RectTreeGauge.rect_wilson_loop_expectation_area_law`, without claiming the
known-false pointwise identity at arbitrary tree-coordinate values.

## Context Pack

```text
AgentTasks/context-packs/ym1-rectboundary-ensemble-20260704-20260704-145108.md
```

## Local State

The target statement was checked in the ignored standalone source root:

```text
lake env lean AgentTasks/aristotle-submit/ym1-rectboundary-ensemble-20260704-source/PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
```

Result: passed with the single intended executable proof placeholder warning
in the target theorem.

## Submission Record

Prompt:

```text
AgentTasks/aristotle-prompts/ym1-rectboundary-ensemble-20260704.prompt.md
```

Focused source root:

```text
AgentTasks/aristotle-submit/ym1-rectboundary-ensemble-20260704-source
```

Focused package:

```text
AgentTasks/aristotle-submit/ym1-rectboundary-ensemble-20260704-project
```

Package command:

```text
pwsh Scripts/prepare_aristotle_focused_submission.ps1 -JobName ym1-rectboundary-ensemble-20260704 -RootModule PhysicsSM -SourceRoot AgentTasks/aristotle-submit/ym1-rectboundary-ensemble-20260704-source -LeanPath PhysicsSM.lean,PhysicsSM/Draft/NullEdge/GateYM/GaugeCoreGeneral.lean,PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean,PhysicsSM/Draft/NullEdge/GateYM/LatticeEnsemble.lean,PhysicsSM/Draft/NullEdge/GateYM/PlaquetteEnsemble.lean,PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean,PhysicsSM/Draft/NullEdge/GateYM/WilsonLocalWeight.lean,PhysicsSM/Draft/NullEdge/GateYM/FusionConvolution.lean,PhysicsSM/Draft/NullEdge/GateYM/Theorem2AreaLaw.lean,PhysicsSM/Draft/NullEdge/GateYM/IndependentPlaquetteEnsemble.lean,PhysicsSM/Draft/NullEdge/GateYM/TreeGaugeBridge.lean,PhysicsSM/Draft/NullEdge/GateYM/RectTreeGauge.lean,PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean,PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean -TaskNote AgentTasks/ym1-rectboundary-ensemble-aristotle-2026-07-04.md -ExtraPath AgentTasks/aristotle-prompts/ym1-rectboundary-ensemble-20260704.prompt.md,AgentTasks/context-packs/ym1-rectboundary-ensemble-20260704-20260704-145108.md,AgentTasks/ym1-rectboundary-lasso-aristotle-2026-07-04.md
```

The package scan reported one intended proof placeholder in the target theorem
and no executable placeholders in the included dependency files.  It also
reported two pre-existing `a x i o m` scanner hits in
`WilsonWeightPositivity.lean`; those are prose/scanner text in the dependency,
not new declarations from this submission.

A local package build attempt reached the fresh dependency-compilation stage
and timed out before producing a target diagnostic.  The timed-out package
workers were stopped by filtering command lines containing the package path,
and the package was regenerated afterward to remove temporary `.lake` state
before submission.  The target statement itself was checked against the live
repository imports as recorded above.

Submission:

```text
Project created: acedaea2-dd0a-4672-baba-fdd3a5ba65ef
Task: e8617a3e-9eea-49c1-a6c0-d4819428241e
Project status after submit: RUNNING
Task status after submit: QUEUED
Submit warning: clean focused package had no .lake folder
```

## Harvest Record

Aristotle returned a complete proof of
`rect_boundary_wilson_loop_expectation_area_law` in
`PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean`.

The result preserves the submitted theorem statement and proves the
boundary-circuit Wilson expectation area law for arbitrary finite groups. The
proof is explicitly expectation-level: it avoids the false pointwise identity
between the boundary holonomy and the reversed row-major plaquette product at a
general link field, and instead uses gauge-orbit reduction to the comb tree
slice before applying the lasso identity.

Integrated file:

```text
PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
```

Aggregator import/map update:

```text
PhysicsSM/Draft/NullEdge/GateYM.lean
```

## Local Verification

Integrated-harvest checks:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryExpectation
lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean
lake build PhysicsSM.Draft.NullEdge.GateYM
```

The main theorem dependency audit reports:

```text
[propext, Classical.choice, Quot.sound]
```

The scoped placeholder/punctuation scan on the new source and harvest notes
has no hits.
