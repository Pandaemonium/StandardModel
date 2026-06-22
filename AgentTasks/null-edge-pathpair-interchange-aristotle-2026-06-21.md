# Aristotle task: path-pair interchange

Date: 2026-06-21

## Objective

Prove the finite vertical/horizontal interchange sanity check for the trusted
causal-diamond path-pair API, plus the Abelian `2 x 2` grid defect product.

Target file:

```text
NullEdgePathPairInterchange/Finite.lean
```

Expected module:

```text
NullEdgePathPairInterchange.Finite
```

Context pack:

```text
AgentTasks/context-packs/null-edge-pathpair-interchange-20260621-manual.md
```

## Theorem targets

```lean
pathPair_vertical_horizontal_interchange
pathPairDefect_interchange
pathPairDefect_grid_comm
```

## Why this matters

The updated program says the higher-gauge branch should first test whether the
trusted vertical and horizontal path-pair compositions really satisfy the
double-category interchange law. This job banks that finite structural theorem
before any crossed-module or fake-flatness claims.

## Constraints

- Keep this finite and structural.
- Do not define a crossed module or claim surface-transport well-definedness.
- Final target file should contain no proof holes or escape-hatch
  declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-pathpair-interchange-20260621/NullEdgePathPairInterchange/Finite.lean
```

Result before submission: passed with exactly three intended proof-hole
warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 3d595909-e7bb-4c44-a4a3-fc86f305774e
  task_id: f5155203-caa1-433f-a81b-616015df2c4e
  target_file: NullEdgePathPairInterchange/Finite.lean
  expected_module: NullEdgePathPairInterchange.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-pathpair-interchange-20260621-project
  output_dir: AgentTasks/aristotle-output/3d595909-e7bb-4c44-a4a3-fc86f305774e
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`3d595909-e7bb-4c44-a4a3-fc86f305774e`; `aristotle tasks` reported task
`f5155203-caa1-433f-a81b-616015df2c4e` as `QUEUED`.

## Integration

Integrated 2026-06-21 into:

```text
PhysicsSM/Draft/NullEdgePathPairInterchange.lean
```

Aristotle returned clean finite structural proofs for all requested targets:

```lean
pathPair_vertical_horizontal_interchange
pathPairDefect_interchange
pathPairDefect_grid_comm
```

The source result was inspected at:

```text
AgentTasks/aristotle-output/3d595909-e7bb-4c44-a4a3-fc86f305774e/extracted/project-files.tar/null-edge-pathpair-interchange-20260621-project_aristotle/NullEdgePathPairInterchange/Finite.lean
```

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgePathPairInterchange.lean
lake build PhysicsSM.Draft.NullEdgePathPairInterchange
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/NullEdgeQubitConcurrence.lean PhysicsSM/Draft/NullEdgePathPairInterchange.lean
```

Semantic review:

- proves finite interchange for the existing path-pair API;
- proves the Abelian `2 x 2` grid defect product under compatibility
  hypotheses;
- does not introduce crossed modules, fake-flatness, or surface transport.
