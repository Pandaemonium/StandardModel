# Aristotle task C86: Gate C0 species-health release API from RA-Wilson

```yaml
aristotle:
  project_id: a1c44f87-c498-4223-b017-b6f7dbb9f13f
  task_id: ce8e876c-f76d-413b-aec9-dca2be8ad663
  target_file: PhysicsSM/Draft/NullEdgeGateC0SpeciesHealth.lean
  expected_module: PhysicsSM.Draft.NullEdgeGateC0SpeciesHealth
  submission_project: AgentTasks/aristotle-submit/null-edge-wave20-c0-c1-rawilson-20260627-project
  output_dir: AgentTasks/aristotle-output/a1c44f87-c498-4223-b017-b6f7dbb9f13f
  status: submitted
```

Context pack:

- `AgentTasks/context-packs/gate-c-c0-c1-rawilson-20260627-20260627-080920.md`

Wave context:

- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-decision-log-2026-06-27.md`
- `AgentTasks/null-edge-pro-hard-problems-briefing-2026-06-27.md`
- `PhysicsSM/Draft/NullEdgeGateCSplit.lean`
- `PhysicsSM/Draft/NullEdgeRegulatorLegalityAPI.lean`
- `PhysicsSM/Draft/NullEdgeRegulatorLegalGateCRelease.lean`
- `PhysicsSM/Draft/NullEdgeKreinOverlapSignTrap.lean`
- `AgentTasks/null-edge-taste-involution-origin-polarization-audit.md`

Kind: proof/API.

Goal:

Create a compact Gate C0 species-health API that connects the RA-Wilson gap idea to `NullEdgeGateCSplit.lean`, while explicitly keeping C0 weaker than C1.

Requested deliverable:

Write `PhysicsSM/Draft/NullEdgeGateC0SpeciesHealth.lean`.

Requested contents:

```text
structure RAWilsonC0Data
structure RAWilsonC0Certificate
def/structure FreeSpeciesHealthy
bridge theorem: RAWilsonC0Certificate -> GateC0SpeciesHealthy
projection theorem: GateC0SpeciesHealthy gives non-origin gap and origin retained
negative theorem: GateC0SpeciesHealthy alone does not imply GateC1ChiralPhysicalRelease
```

If C85 is available in this snapshot, use its abstract accretive-gap theorem as the engine. If not, leave C85 as an imported future dependency or duplicate only a minimal abstract hypothesis such as `offOriginGap : Prop`.

Scope guardrails:

Do not claim full Gate C release. Do not claim origin chirality. The point of this module is to make the phrase `RA-Wilson releases C0, not C1` precise and hard to misread.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: a1c44f87-c498-4223-b017-b6f7dbb9f13f
task_id: ce8e876c-f76d-413b-aec9-dca2be8ad663
submission_project: AgentTasks/aristotle-submit/null-edge-wave20-c0-c1-rawilson-20260627-project
```
