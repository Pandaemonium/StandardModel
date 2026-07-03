# Null-edge next wave after checkerboard/operator scaffold Aristotle job

Date: 2026-07-01
Status: completed and integrated.

## Purpose

Send Aristotle the highest-value remaining work after Codex integrated the
checkerboard continuum-next result and added new Lean scaffolds for:

- refined checkerboard spacetime endpoint counts;
- hyperdiamond first-order stencil/operator crosswalk;
- algebraic versus physical projector audit separation.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-next-wave-after-scaffold-20260701.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-next-wave-after-scaffold-20260701-project`
- Source root:
  `NullEdgeStandalone`

## Requested proof/audit targets

1. Prove finite binomial-product closed forms for
   `spacetimeEndpointTurnClassCount`, or the strongest clean cases toward them.
2. Instantiate or refute exact `GateCPrincipalCrosswalk` for a concrete
   hyperdiamond/Borici-Creutz-style stencil.
3. Recommend concrete Lean predicates replacing the free fields of
   `ProjectorPhysicalAudit`.
4. Rank the most important next pieces and identify the best next Aristotle
   theorem job.

## Aristotle metadata

```yaml
aristotle:
  project_id: ecbd6315-d0c4-40a1-b1e0-feebcb8f843b
  task_id: 105c1626-9698-4a44-bc90-c0778d8143e4
  target_file: PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
  secondary_target_file: PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
  expected_module: NullEdgeStandalone
  submission_project: AgentTasks/aristotle-submit/null-edge-next-wave-after-scaffold-20260701-project
  output_dir: AgentTasks/aristotle-output/ecbd6315-d0c4-40a1-b1e0-feebcb8f843b
  status: integrated
```

## Submission result

Submitted on 2026-07-01.

```text
Project created: ecbd6315-d0c4-40a1-b1e0-feebcb8f843b
Task: 58df0214-9715-4dac-9052-9bb1d1788c85
Initial status: QUEUED
```

The Aristotle CLI warned that the project has no `.lake` folder. This is
intentional for the focused package: the upload includes `lakefile.toml`,
`lake-manifest.json`, `lean-toolchain`, and the standalone Lean source, but not
the local dependency cache.

## Completion result

The initial task
`58df0214-9715-4dac-9052-9bb1d1788c85` was canceled after it looped on the
checkerboard closed-form proof. The follow-up task
`105c1626-9698-4a44-bc90-c0778d8143e4` completed.

Integrated deliverables:

- `spacetimeEndpointTurnClassCount_length_zero`;
- `spacetimeEndpointTurnClassCount_left_zero`;
- `spacetimeEndpointTurnClassCount_right_zero`;
- `spacetimeEndpointTurnClassCount_sum_eq_velocity`;
- `runCount` and its basic closed forms;
- `spacetimeEndpointTurnClassCount_eq`;
- `spacetimeEndpointTurnClassCount_eq_of_right_le_length`;
- `spacetimeEndpointTurnClassCount_closed_form_sum_eq_choose`;
- `gateCStencil`;
- `gateCStencil_crosswalk`;
- `gateCStencil_no_single_chirality`;
- `BoriciCreutzConventionData`;
- `BoriciCreutzNearestPrincipalCrosswalk`;
- `boriciCreutzNearest_no_single_chirality`;
- `AgentTasks/NULL_EDGE_NEXT_WAVE_AFTER_SCAFFOLD_REPORT.md`.

The returned code and local follow-up corollaries/scaffolds were checked locally
after integration.
