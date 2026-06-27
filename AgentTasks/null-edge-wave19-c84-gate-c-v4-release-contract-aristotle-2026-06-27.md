# Aristotle task C84: Gate C v4 release contract using RegulatorLegal

```yaml
aristotle:
  project_id: 10f74338-940c-4335-8a90-280a6b1b09e1
  task_id: 217995da-fa39-4973-8bb5-4320fdd387d2
  target_file: PhysicsSM/Draft/NullEdgeRegulatorLegalGateCRelease.lean
  expected_module: PhysicsSM.Draft.NullEdgeRegulatorLegalGateCRelease
  submission_project: AgentTasks/aristotle-submit/null-edge-wave19-regulator-legality-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/10f74338-940c-4335-8a90-280a6b1b09e1
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

Create a small release-contract module connecting the new `RegulatorLegal` idea to the existing projected Gate C release decomposition.

This should not discharge Gate C. It should define the new release target cleanly:

```text
Gate C releases for (D0, R, G, Pin, Pout) only if both LiftNonOrigin and OriginWeylPure hold, plus ghost/Krein/gauge/counterterm clauses.
```


Requested deliverable:

Write `PhysicsSM/Draft/NullEdgeRegulatorLegalGateCRelease.lean`.

Requested contents:

```text
structure RegulatorLegalGateCData
structure RegulatorLegalGateCRelease
projection theorem: release -> LiftNonOrigin
projection theorem: release -> OriginWeylPure
negative theorem: LiftNonOrigin alone is insufficient for release
bridge theorem: RegulatorLegal + existing GhostZeroSafe/Krein/Gauge clauses -> named `GateC_v4_released` predicate
```

If importing C80 is impossible because C80 is not yet available, make this a companion API module with duplicated minimal predicates and note that C80 should be merged later.


Scope guardrails:

Do not claim any concrete operator satisfies the release contract. This is a contract/API job, not a proof of release. Keep it compatible with C59/C72 style projected release predicates if practical.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 10f74338-940c-4335-8a90-280a6b1b09e1
task_id: 217995da-fa39-4973-8bb5-4320fdd387d2
submission_project: AgentTasks/aristotle-submit/null-edge-wave19-regulator-legality-gate-c-20260627-project
target: PhysicsSM/Draft/NullEdgeRegulatorLegalGateCRelease.lean
```
