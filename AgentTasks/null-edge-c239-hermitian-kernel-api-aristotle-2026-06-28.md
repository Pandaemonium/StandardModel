# Aristotle task C239: Hermitian kernel API and proof skeleton

Date: 2026-06-28

Purpose:

```text
Design the smallest Lean/API theorem proving that the proposed null-edge
overlap kernel H_ne = gamma5(D + E - mI) is Hermitian under explicit
gamma5-Hermiticity assumptions.
```

Prompt:

```text
AgentTasks/aristotle-prompts/gate-c1-hermitian-kernel-api-c239.prompt.md
```

Submission project:

```text
AgentTasks/aristotle-submit/gate-c1-hermitian-kernel-api-c239
```

Status:

```text
integrated.
```

Aristotle metadata:

```yaml
aristotle:
  project_id: f37276a8-2e8a-4530-9f81-5dc26b7939a4
  task_id: cda8493c-e18a-403c-8d79-b68c1bbd1ca7
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/gate-c1-hermitian-kernel-api-c239
  output_dir: AgentTasks/aristotle-output/f37276a8-2e8a-4530-9f81-5dc26b7939a4
  status: integrated
```

Submission note:

```text
Prompt/project-dir submission only. Requested theorem/API design or standalone
Mathlib-oriented code if feasible.
```

Integration note:

```text
Fetched Aristotle output:
  AgentTasks/aristotle-output/f37276a8-2e8a-4530-9f81-5dc26b7939a4.

Copied returned Lean API into:
  PhysicsSM/Draft/NullEdge/GateC1/NullEdgeOverlapKernel.lean.

Adapted namespace to:
  PhysicsSM.Draft.NullEdge.GateC1.NullEdgeOverlapKernel.

Preserved local conditional GW algebra lemma:
  normalized_ginspargWilson_of_involutions.

Updated docs:
  Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md section 62;
  Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md section 38.

No local live-repo Lean check was run during integration.
```
