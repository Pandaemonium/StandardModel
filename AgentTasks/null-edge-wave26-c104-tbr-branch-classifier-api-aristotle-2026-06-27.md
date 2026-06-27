# Aristotle C104: branch classifier `T_br` / `Pi_br` API and no-go fork

aristotle:
  project_id: 054ff61b-1271-432f-ae14-bde0a03b77e4
  task_id: 722c441f-cc78-49ba-b066-b58a1b973f1a
  target_file: PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean
  expected_module: PhysicsSM.Draft.NullEdgeBranchClassifierAPI
  submission_project: AgentTasks/aristotle-submit/null-edge-wave26-gate-c-branch-release-20260627-project
  output_dir: AgentTasks/aristotle-output/054ff61b-1271-432f-ae14-bde0a03b77e4
  status: integrated
  initial_project_status: RUNNING
  initial_task_status: QUEUED
  integrated: 2026-06-27

Dependency class: C1-facing branch-line design job.

Context pack:

```text
AgentTasks/context-packs/null-edge-wave26-gate-c-branch-release-20260627-121710.md
AgentTasks/null-edge-gate-c-neo4j-lit-lateral-analysis-2026-06-27.md
```

## Background

The most null-edge-native C1 route is a branch classifier or projector:

```text
T_br^2 = 1
Pi_br = (1 + T_br) / 2
```

It must be non-scalar on the balanced origin kernel and must separate branch
germs, not taste labels only. If such an object exists with locality,
gauge-neutrality, and Krein safety, it can feed projected overlap,
spinor-line Wilson, or domain-wall release. If it cannot exist under these
constraints, that no-go forces the program toward nonlocal/quasi-local or
boundary constructions.

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean
```

or return a focused report if a Lean API would be fake.

## Desired API

Suggested predicates:

```lean
BranchClassifier
TbrInvolution
TbrGaugeNeutral
TbrNonScalarOnOriginKernel
TbrSeparatesBranchGerms
TbrTasteOnly
PiBrProjector
```

Prove finite guardrails where feasible:

```text
TbrNonScalarOnOriginKernel -> not TbrTasteOnlyOnOrigin
TbrSeparatesBranchGerms -> retained and mirror labels are distinct
TbrTasteOnlyOnOrigin -> cannot polarize balanced origin kernel
```

Also state the no-go fork:

```text
no local/gauge-safe branch classifier -> C1 must use domain-wall,
projected-overlap, or controlled quasi-local field-space construction.
```

## Acceptance criteria

- Lean file compiles if a Lean artifact is created.
- No new proof placeholders or escape-hatch declarations.
- Names and docstrings must prevent this API from being mistaken for actual
  Gate C release.

## Integration review

Status: integrated 2026-06-27.

Integrated artifact:

```text
PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean
```

Result:

- Added the `T_br` / `Pi_br` algebraic branch-classifier API.
- Added projector, gauge-neutrality, non-scalar-on-origin, branch-germ
  separation, and taste-only no-go guardrails.
- Added a non-vacuous algebraic witness and the C1 route no-go fork.

Review notes:

- This is a finite algebraic API, not a physical local/gauge/Krein/ghost-safe
  Gate C release.
- The crucial open obligation is now concrete: construct an actual local
  gauge-safe branch classifier for the null-edge symbol or take the projected
  overlap / domain-wall / quasi-local fork.
