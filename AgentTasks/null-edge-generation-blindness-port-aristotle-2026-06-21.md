# Aristotle task: generation-blindness port

Date: 2026-06-21

## Objective

Port the generation-blindness theorem to the canonical trusted Pluecker
definitions in `PhysicsSM.Spinor.PluckerMass`.

Target file:

```text
NullEdgeGenerationBlindnessPort/Finite.lean
```

Expected module:

```text
NullEdgeGenerationBlindnessPort.Finite
```

Context pack:

```text
AgentTasks/context-packs/null-edge-generation-blindness-port-20260621-175331.md
```

## Theorem targets

```lean
complexAbsSq_spinorWedge_comm
finPairwisePluckerMass_perm
visiblePluckerMass_generationBlind
```

## Why this matters

The first generation-blindness result proved the finite theorem over local
standalone copies of the Pluecker definitions. The core-definition
consolidation roadmap says the next useful port is to restate and prove the
same result over the trusted `PhysicsSM.Spinor.PluckerMass` API. This removes a
definition-duplication hazard before creating `PhysicsSM/NullEdge/Core`.

## Constraints

- Keep this package focused: it may import the copied trusted
  `PhysicsSM.Spinor.PluckerMass` file, but no broader `PhysicsSM` tree.
- Do not weaken theorem statements silently.
- Preserve the unordered-pair convention encoded by the trusted
  `finPairIndexSet`.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-generation-blindness-port-20260621/NullEdgeGenerationBlindnessPort/Finite.lean
```

Result before submission: passed with exactly three intended proof-hole
warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 6d3acc77-95a1-44d1-98de-678921a97057
  task_id: 7adc2ccc-0f72-4fb5-9559-78ba12fb9c11
  target_file: NullEdgeGenerationBlindnessPort/Finite.lean
  expected_module: NullEdgeGenerationBlindnessPort.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-generation-blindness-port-20260621-project
  output_dir: AgentTasks/aristotle-output/6d3acc77-95a1-44d1-98de-678921a97057
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`6d3acc77-95a1-44d1-98de-678921a97057`; `aristotle tasks` reported task
`7adc2ccc-0f72-4fb5-9559-78ba12fb9c11` as `QUEUED`.

## Integration result

Integrated 2026-06-21 into:

```text
PhysicsSM/Draft/NullEdgeGenerationBlindnessPort.lean
```

and imported from:

```text
PhysicsSMDraft.lean
```

Aristotle proved all three port targets over the canonical trusted
`PhysicsSM.Spinor.PluckerMass` API:

- `complexAbsSq_spinorWedge_comm`;
- `finPairwisePluckerMass_perm`;
- `visiblePluckerMass_generationBlind`.

The key improvement over the earlier standalone theorem is that permutation
invariance is now stated directly for the trusted `finPairwisePluckerMass`.
Aristotle used the trusted determinant identity to reduce the proof to
permutation invariance of the finite sum of rank-one Hermitian momenta.

Local verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeGenerationBlindnessPort.lean
lake build PhysicsSM.Draft.NullEdgeGenerationBlindnessPort
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/NullEdgeGenerationBlindnessPort.lean
```

All commands passed.
