# Aristotle task: covariant differential curvature core

Date: 2026-06-21

## Objective

Prove the finite graph/gauge algebra behind the curvature block of the proposed
causal super-Dirac operator.

Target file:

```text
NullEdgeCovariantDifferentialCore/Curvature.lean
```

Expected module:

```text
NullEdgeCovariantDifferentialCore.Curvature
```

## Theorem targets

```lean
covariantD1_covariantD0_eq_curvature
covariantD1_covariantD0_eq_zero_of_flat
covariantD0_gauge_covariant
covariantD1_gauge_covariant
triangleCurvature_gauge_transform
```

## Why this matters

The operator-spine criterion asks for a first-order finite operator whose
square contains a curvature block.  This target isolates the minimal triangle
identity: the twisted differential applied twice equals the transport defect
`U i j * U j k - U i k`, and that defect transforms covariantly under finite
gauge changes.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not weaken theorem statements silently.
- Final target file should contain no proof holes or escape-hatch declarations.
- Keep the orientation of the triangle defect fixed as
  `U i j * U j k - U i k`.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-covariant-differential-curvature-core-20260621/NullEdgeCovariantDifferentialCore/Curvature.lean
```

Result before submission: passed with exactly five intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 9567ff08-7e88-485c-b4d0-c6dda19d5a04
  task_id: 53fafd96-4c76-4958-962a-8eb3a6b93960
  target_file: NullEdgeCovariantDifferentialCore/Curvature.lean
  expected_module: NullEdgeCovariantDifferentialCore.Curvature
  submission_project: AgentTasks/aristotle-submit/null-edge-covariant-differential-curvature-core-20260621-project
  output_dir: AgentTasks/aristotle-output/9567ff08-7e88-485c-b4d0-c6dda19d5a04
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`9567ff08-7e88-485c-b4d0-c6dda19d5a04`; `aristotle tasks` reported task
`53fafd96-4c76-4958-962a-8eb3a6b93960` as `QUEUED`.

## Integration

Integrated 2026-06-21 as:

```text
PhysicsSM/Draft/NullEdgeCovariantDifferentialCore.lean
```

The module proves the finite scalar-transport identity
`covariantD1_covariantD0_eq_curvature`, the flat-triangle corollary, and
three finite gauge-covariance laws for the zero-cochain differential,
one-cochain differential, and triangle curvature.

Verification:

```text
lake env lean PhysicsSM\Draft\NullEdgeCovariantDifferentialCore.lean
lake build PhysicsSM.Draft.NullEdgeCovariantDifferentialCore
lake env lean PhysicsSMDraft.lean
python Scripts\check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM\Draft\NullEdgeCovariantDifferentialCore.lean
git diff --check -- PhysicsSM\Draft\NullEdgeCovariantDifferentialCore.lean PhysicsSMDraft.lean
```
