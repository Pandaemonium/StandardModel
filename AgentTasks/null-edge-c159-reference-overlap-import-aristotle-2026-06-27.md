# Null-edge C159 Aristotle job: NullEdgeReferenceOverlapImport theorem package

Date: 2026-06-27

aristotle:
  project_id: a977c2ed-c8f6-4f25-8160-a8d56e5c2e2a
  task_id: b9f1fe71-7df2-4bd2-8d0a-2bd5fe82f6ee
  target_file: none-strategy-and-api-job
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-reference-import-round-20260627-project
  output_dir: AgentTasks/aristotle-output/a977c2ed-c8f6-4f25-8160-a8d56e5c2e2a
  status: integrated

## Purpose

This job was opened after the Pro sharpening that Gate C1 should be treated as a reference-kernel import problem, not as a finite-seed release problem.

See:

- Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, section 30.
- AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md, Pro sharpening update.
- $roundDir/ROUND_CONTEXT.md.
- $PromptPath.

## Prompt file

$PromptPath

## Submission output

`	ext
Project created: a977c2ed-c8f6-4f25-8160-a8d56e5c2e2a
`

## Integration status

Integrated on 2026-06-27.

Aristotle delivered:

```text
C159_REFERENCE_IMPORT_DESIGN.md
RequestProject/C159_ReferenceImport.lean
```

The design document was copied into:

```text
AgentTasks/null-edge-c159-reference-overlap-import-design-2026-06-27.md
```

The Lean artifact was preserved in the downloaded Aristotle archive:

```text
AgentTasks/aristotle-output/a977c2ed-c8f6-4f25-8160-a8d56e5c2e2a/project.zip
```

Key result:

```text
NullEdgeReferenceOverlapImport
  = finite seed input
  + sector-signature match
  + uniform gapped homotopy
  + mass-window/sign-straddling
  + separate anomaly, ghost, and control certificates
  -> GateC1_NU.
```

The Lean skeleton machine-checks the structural API: the finite seed is not the
release, GateC1_NU is strictly weaker than GateC1_local, anomaly/control
certificates are load-bearing, and locality is not obtained for free from the
homotopy.
