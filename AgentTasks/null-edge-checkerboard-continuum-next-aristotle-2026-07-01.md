# Null-edge checkerboard continuum-next Aristotle job

Date: 2026-07-01
Status: submitted.

## Purpose

Ask Aristotle to prove the next finite checkerboard lemmas and recommend the
best next theorem sequence toward a rigorous continuum Dirac limit.

This job follows the integrated finite checkerboard path-sum, tuple/list bridge,
reverse-invariance, and unitary-normalization work. Codex has added a live
placeholder-free scaffold in
`NullEdgeStandalone/PhysicsSM/Draft/CheckerboardContinuumScaffold.lean` and a
focused Aristotle-only target file under `AgentTasks/aristotle-standalone/`.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-checkerboard-continuum-next-20260701.prompt.md`
- Focused source root:
  `AgentTasks/aristotle-standalone/null-edge-checkerboard-continuum-next-20260701`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-checkerboard-continuum-next-20260701-project`
- Literature review:
  `NullEdgeStandalone/docs/CHECKERBOARD_LITERATURE_REVIEW.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: d063b327-2800-413e-b7bb-4a49aff33ec0
  task_id: 5ca2110b-8fc7-438e-984a-054299ecdb6d
  target_file: PhysicsSM/Draft/CheckerboardContinuumNext.lean
  expected_module: PhysicsSM.Draft.CheckerboardContinuumNext
  submission_project: AgentTasks/aristotle-submit/null-edge-checkerboard-continuum-next-20260701-project
  output_dir: AgentTasks/aristotle-output/d063b327-2800-413e-b7bb-4a49aff33ec0
  status: submitted
```

## Requested proof targets

- `turnCountVec_mod_two_eq_endpoint`
- `endpoint_eq_iff_turnCountVec_even`
- `velocityEndpointTurnClassCount_eq_choose`
- `isotropicStep_mul`
- `isotropicStep_pow_eq`

## Requested audit targets

- Check whether the outgoing-edge convention matches the
  Earle/Jacobson-Schulman endpoint-count convention.
- Propose exact next Lean statements for spacetime endpoint count formulas.
- Propose the best analytic theorem statement for the continuum Dirac limit.
- Recommend whether the next Aristotle job should focus on finite binomial
  counts, unitary generator expansion, or analytic convergence scaffolding.

## Literature review notes

Live web/arXiv search was used because local Neo4j vector search was unavailable
on 2026-07-01 (`127.0.0.1:7687` refused connection). The review emphasizes
Feynman-Hibbs, Gersch, Jacobson-Schulman/Earle, Kauffman-Noyes,
D'Ariano-Mosco-Perinotti-Tosini, and Skopenkov-Ustinov.

## Submission result

Submitted on 2026-07-01.

```text
Project created: d063b327-2800-413e-b7bb-4a49aff33ec0
Task: 5ca2110b-8fc7-438e-984a-054299ecdb6d
Initial status: QUEUED
```

The Aristotle CLI warned that the project has no `.lake` folder. This is
intentional for the focused package: the upload includes `lakefile.toml`,
`lake-manifest.json`, `lean-toolchain`, and the three target Lean files, but not
the partial local dependency checkout created by a local smoke test.

2026-07-01 status poll: `aristotle tasks
d063b327-2800-413e-b7bb-4a49aff33ec0 --limit 10` reports task
`5ca2110b-8fc7-438e-984a-054299ecdb6d` as `IN_PROGRESS`.
