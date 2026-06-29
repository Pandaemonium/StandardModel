# Aristotle task C233: strengthened Riesz-projector API

Date: 2026-06-28

Purpose:

```text
Design the strengthened spectral/range API needed after C229 found that
idempotent + commuting + equal rank is not enough for Riesz projector
uniqueness.
```

Prompt:

```text
AgentTasks/aristotle-prompts/gate-c1-riesz-projector-strengthening-c233.prompt.md
```

Status:

```text
submitted.
```

Aristotle metadata:

```yaml
aristotle:
  project_id: 7269a433-018f-4d26-a00b-a5a1ffe3a34c
  task_id: e1d49933-c629-494f-8668-afce52ebbdc9
  target_file: null
  expected_module: null
  submission_project: null
  output_dir: AgentTasks/aristotle-output/7269a433-018f-4d26-a00b-a5a1ffe3a34c
  status: integrated
```

Integration, 2026-06-28:

```text
Fetched and archived the project output.
Integrated the strengthened Riesz/spectral-projector API guidance into the
planning docs.

Did not port the standalone Lean artifact verbatim because its namespace/theorem
names overlap with the existing C227 OperatorFreeze API. Future live code should
use a deliberately named SpectralProjectorAPI module.

No local Lean checks were run.
```
