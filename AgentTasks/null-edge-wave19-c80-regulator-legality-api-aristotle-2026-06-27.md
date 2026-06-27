# Aristotle task C80: RegulatorLegal and no-irrelevant-repair API

```yaml
aristotle:
  project_id: a59f4a9d-9480-47dd-9775-7dd990e8141d
  task_id: b3d08dbd-7eea-4b98-8c82-39dc58f8e359
  target_file: PhysicsSM/Draft/NullEdgeRegulatorLegalityAPI.lean
  expected_module: PhysicsSM.Draft.NullEdgeRegulatorLegalityAPI
  submission_project: AgentTasks/aristotle-submit/null-edge-wave19-regulator-legality-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/a59f4a9d-9480-47dd-9775-7dd990e8141d
  status: submitted
```

Context pack:

- `AgentTasks/context-packs/gate-c-regulator-legality-20260627-074056.md`

Wave context:

- `AgentTasks/null-edge-wave19-regulator-legality-analysis-2026-06-27.md`
- `AgentTasks/null-edge-pro-hard-problems-briefing-2026-06-27.md`
- `AgentTasks/null-edge-flavored-mass-overlap-gate-c-strategy.md`
- `AgentTasks/null-edge-overlap-locality-gap-audit.md`
- `AgentTasks/null-edge-point-split-gauge-covariant-flavored-mass-plan.md`
- `AgentTasks/null-edge-null-wilson-operator-placement-audit-report.md`

Kind: proof/strategy.

Goal:

Create a small finite API for Gate C v4 regulator legality.

The module should formalize the distinction:

```text
LiftNonOrigin is not enough.
OriginWeylPure for a chosen grading G is a separate legal release clause.
```

It should be abstract enough to avoid heavy analytic derivatives if needed, but concrete enough to prove the key negative theorem: if a regulator has zero first-order contribution at the origin, and the bare origin linearization is not G-pure, then the regulated unprojected origin linearization is still not G-pure.


Requested deliverable:

Write `PhysicsSM/Draft/NullEdgeRegulatorLegalityAPI.lean`.

Aim for definitions/predicates such as:

```text
IsGrading
OriginWeylPure
OriginBalanced
SameOriginLinearization
LiftNonOrigin
RegulatorLegal
IrrelevantAtOrigin
```

Requested theorem shapes:

```text
same_linearization_preserves_origin_not_pure
no_irrelevant_regulator_repairs_balanced_origin
wilson_lift_not_chiral_release_schema
regulatorLegal_requires_lift_and_origin_purity
```

It is acceptable to model `linearization_at_zero` abstractly as supplied data rather than formalizing Frechet derivatives in this first module.


Scope guardrails:

Do not assert the actual null-edge operator satisfies the new predicates. Do not claim Gate C release. Do not duplicate C70 Wilson positivity. This module is an abstract legality/failure API.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: a59f4a9d-9480-47dd-9775-7dd990e8141d
task_id: b3d08dbd-7eea-4b98-8c82-39dc58f8e359
submission_project: AgentTasks/aristotle-submit/null-edge-wave19-regulator-legality-gate-c-20260627-project
target: PhysicsSM/Draft/NullEdgeRegulatorLegalityAPI.lean
```
