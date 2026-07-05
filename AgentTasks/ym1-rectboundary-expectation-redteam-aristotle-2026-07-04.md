# Aristotle task note: YM1 rectangular boundary expectation red-team

```yaml
aristotle:
  project_id: 0f3aa68d-3da4-416a-b1d8-051008f95714
  task_id: 17ac50d1-ea08-4386-80f7-5d945805dff7
  target_file: PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryExpectation
  submission_project: AgentTasks/aristotle-submit/ym1-rectboundary-expectation-redteam-20260704-project
  output_dir: pending
  status: submitted
```

## Purpose

Submit a post-integration semantic audit of the Q11/YM1 boundary-expectation
theorem integrated from Aristotle project `acedaea2`.

This audit should check that
`rect_boundary_wilson_loop_expectation_area_law` really supports the current
claim language:

```text
YM1/Q11 is draft-closed for the concrete rectangular boundary-circuit
expectation theorem, and only at that finite draft level.
```

It should also look for convention drift, hidden degeneracies, or stale docs
that accidentally describe the result as a false pointwise identity or as a
trusted/continuum/mass-gap theorem.

## Context Pack

```text
AgentTasks/context-packs/ym1-rectboundary-expectation-redteam-20260704-20260704-180906.md
```

## Prompt

```text
AgentTasks/aristotle-prompts/ym1-rectboundary-expectation-redteam-20260704.prompt.md
```

## Submission Record

Package command:

```text
pwsh Scripts/prepare_aristotle_submission.ps1 -JobName ym1-rectboundary-expectation-redteam-20260704 -TaskNote AgentTasks/ym1-rectboundary-expectation-redteam-aristotle-2026-07-04.md -ExtraPath AgentTasks/aristotle-prompts/ym1-rectboundary-expectation-redteam-20260704.prompt.md,AgentTasks/context-packs/ym1-rectboundary-expectation-redteam-20260704-20260704-180906.md,AgentTasks/ym1-rectboundary-ensemble-aristotle-2026-07-04.md,AgentTasks/paper-units/ym1-area-law-outline.md -CheckPath PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean -NoRemoteSpherePacking
```

Submission:

```text
Project created: 0f3aa68d-3da4-416a-b1d8-051008f95714
Task: 17ac50d1-ea08-4386-80f7-5d945805dff7
Task status after submit: QUEUED
Submit warning: clean full-project package had no .lake folder
```
