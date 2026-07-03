# Null-edge checkerboard/Borici-Creutz convention next Aristotle job

Date: 2026-07-01
Status: completed and integrated.

## Purpose

Send Aristotle the remaining high-value work after integrating the completed
next-wave job and after local Codex follow-up proved:

- `spacetimeEndpointTurnClassCount_eq_of_right_le_length`;
- `spacetimeEndpointTurnClassCount_closed_form_sum_eq_choose`;
- `BoriciCreutzConventionData`;
- `BoriciCreutzNearestPrincipalCrosswalk`;
- `boriciCreutzNearest_no_single_chirality`.

The main goal is now proof-library cleanup and convention instantiation, not a
premature named-operator equivalence claim.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-checkerboard-bc-convention-next-20260701.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-checkerboard-bc-convention-next-20260701-project`
- Source root:
  `NullEdgeStandalone`

## Requested proof/audit targets

1. Add useful kernel-checked checkerboard normalization lemmas and small
   examples around `runCount` and `spacetimeEndpointTurnClassCount_eq`.
2. Either instantiate a source-based Borici-Creutz convention into
   `BoriciCreutzConventionData` and prove a crosswalk/mismatch theorem, or
   sharpen the scaffold/report with the exact missing convention data.
3. Recommend the most important next Lean targets by claim type.

## Aristotle metadata

```yaml
aristotle:
  project_id: f88a6a21-d397-4880-961f-eeb4b3f5a918
  task_id: 4dccd792-6cfc-4a25-8ae7-3695fc1def54
  target_file: PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
  secondary_target_file: PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
  expected_module: NullEdgeStandalone
  submission_project: AgentTasks/aristotle-submit/null-edge-checkerboard-bc-convention-next-20260701-project
  output_dir: AgentTasks/aristotle-output/f88a6a21-d397-4880-961f-eeb4b3f5a918
  status: integrated
```

## Preflight

The local standalone checks passed before packaging:

```text
lake env lean PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
lake env lean PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
lake build NullEdgeStandalone
```

The Neo4j semantic index refresh was attempted, but local Neo4j was not
accepting connections on `127.0.0.1:7687`, so no fresh context pack was generated
from the graph. The submission includes explicit source files and the literature
review document instead.

## Submission result

Submitted on 2026-07-01.

```text
Project created: f88a6a21-d397-4880-961f-eeb4b3f5a918
Task: 4dccd792-6cfc-4a25-8ae7-3695fc1def54
Initial status: QUEUED
```

The Aristotle CLI warned that the project has no `.lake` folder. This is
intentional for the focused package: the upload includes `lakefile.toml`,
`lake-manifest.json`, `lean-toolchain`, and the standalone Lean source, but not
the local dependency cache.

## Completion result

The task completed successfully and was integrated on 2026-07-01.

Integrated deliverables:

- `runCount_eq_zero_of_lt`;
- `runCount_one_part`;
- `runCount_self`;
- `spacetimeEndpointTurnClassCount_eq_zero_of_right_gt_length`;
- `spacetimeEndpointTurnClassCount_eq_zero_of_left_gt_length`;
- `spacetimeEndpointTurnClassCount_closed_form_sum_eq_velocity`;
- small direct-count examples for path lengths `0`, `1`, `2`, and `3`;
- `BoriciCreutzConventionData.RequiresFifthVector`;
- `BoriciCreutzConventionData.fullFirstOrderSymbol`;
- `HyperdiamondFirstOrderStencil.linearSymbol_zero`;
- `boriciCreutz_fullSymbol_ne_nearest_of_requiresFifthVector`;
- `NullEdgeStandalone/docs/BORICI_CREUTZ_NEXT_CONVENTION_DATA.md`;
- `NullEdgeStandalone/docs/NULL_EDGE_NEXT_STEP_REPORT.md`.

The returned Borici-Creutz material is a scaffold-level truncation mismatch, not
a named-operator equivalence.

Codex local follow-up after integration added:

- `checkerStep_pow_apply_isotropic_velocityEndpoint`;
- `checkerStep_pow_apply_isotropic_spacetimeEndpoint`.
- `checkerStep_pow_apply_isotropic_spacetimeClosedForm`.

These close the next finite generating-function bridge from endpoint turn
counts back to the isotropic checkerboard propagator, including the packaged
closed-form version.
