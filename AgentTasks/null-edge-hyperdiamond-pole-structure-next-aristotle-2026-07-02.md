# Null-edge hyperdiamond pole-structure next Aristotle job

Date: 2026-07-02
Status: integrated.

## Purpose

Send Aristotle the next hyperdiamond reconstruction/no-go target after the
fifth-vector truncation mismatch was integrated.

The goal is to add Lean predicate scaffolding, and any provable theorem, toward:

```text
hyperdiamond_no_four_edge_pole_structure
```

No named Borici-Creutz operator equivalence should be claimed without explicit
source convention data.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-hyperdiamond-pole-structure-next-20260702.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-hyperdiamond-pole-structure-next-20260702-project`
- Source root:
  `NullEdgeStandalone`

## Aristotle metadata

```yaml
aristotle:
  project_id: b9d659b1-e7fd-4c2b-ad2f-406b2722a6ab
  task_id: 9428dd68-3a54-4143-badd-f35c220e956c
  target_file: PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
  expected_module: NullEdgeStandalone
  submission_project: AgentTasks/aristotle-submit/null-edge-hyperdiamond-pole-structure-next-20260702-project
  output_dir: AgentTasks/aristotle-output/b9d659b1-e7fd-4c2b-ad2f-406b2722a6ab
  status: integrated
```

## Preflight

Codex verified the current operator scaffold locally:

```text
lake env lean PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
```

## Submission result

Submitted on 2026-07-02.

```text
Project created: b9d659b1-e7fd-4c2b-ad2f-406b2722a6ab
Task: 9428dd68-3a54-4143-badd-f35c220e956c
Initial status: QUEUED
```

The Aristotle CLI warned that the project has no `.lake` folder. This is
intentional for the focused package: the upload includes `lakefile.toml`,
`lake-manifest.json`, `lean-toolchain`, and the standalone Lean source, but not
the local dependency cache.

## Integration result

Fetched and integrated on 2026-07-02.

Integrated into `PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean`:

- `FullFirstOrderSymbol`;
- `IsExcitation`;
- `RealizedByFourEdgeStencil`;
- `GenuineFifthVectorDependence`;
- `PoleStructureNeedsFifthVector`;
- `RealizedByFourEdgeStencil.const_in_fifth`;
- `RealizedByFourEdgeStencil.isExcitation_w_indep`;
- `not_realizedByFourEdgeStencil_of_genuineFifthVectorDependence`;
- `not_realizedByFourEdgeStencil_of_poleStructureNeedsFifthVector`;
- `BoriciCreutzConventionData.fullSymbol`;
- `boriciCreutz_fullSymbol_genuineFifthVectorDependence`;
- `hyperdiamond_no_four_edge_pole_structure`.

Added report:

```text
NullEdgeStandalone/docs/NO_FOUR_EDGE_POLE_STRUCTURE_REPORT.md
```

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
```
