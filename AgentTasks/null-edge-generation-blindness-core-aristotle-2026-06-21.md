# Aristotle task: generation-blindness core

Date: 2026-06-21

## Objective

Prove the finite generation-blindness theorem for the visible Plucker mass
functional.

Target file:

```text
NullEdgeGenerationBlindnessCore/Finite.lean
```

Expected module:

```text
NullEdgeGenerationBlindnessCore.Finite
```

## Theorem targets

```lean
complexAbsSq_spinorWedge_comm
finPairwisePluckerMass_perm
visiblePluckerMass_generationBlind
```

## Why this matters

The falsification-aware map identifies generation blindness as a cheap decisive
test: the visible rank-two null geometry should not distinguish family labels.
This target proves the narrow finite statement that relabeling hidden/internal
indices does not change the visible pairwise Plucker mass. Any family physics
must therefore enter through hidden Gram overlaps, Yukawa/flip amplitudes, or
additional internal structure, not through the visible mass functional alone.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not weaken theorem statements silently.
- Final target file should contain no proof holes or escape-hatch declarations.
- Preserve the unordered-pair convention encoded by `finPairIndexSet`.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-generation-blindness-core-20260621/NullEdgeGenerationBlindnessCore/Finite.lean
```

Result before submission: passed with exactly three intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 6dfab21d-321a-45c4-8e34-eca3e155a3c6
  task_id: 8a0b76b6-ed65-4bb0-9616-bbd2dbc9263e
  target_file: NullEdgeGenerationBlindnessCore/Finite.lean
  expected_module: NullEdgeGenerationBlindnessCore.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-generation-blindness-core-20260621-project
  output_dir: AgentTasks/aristotle-output/6dfab21d-321a-45c4-8e34-eca3e155a3c6
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`6dfab21d-321a-45c4-8e34-eca3e155a3c6`; `aristotle tasks` reported task
`8a0b76b6-ed65-4bb0-9616-bbd2dbc9263e` as `QUEUED`.

## Integration result

Integrated 2026-06-21 into:

```text
PhysicsSM/Draft/NullEdgeGenerationBlindnessCore.lean
```

and imported from:

```text
PhysicsSMDraft.lean
```

Aristotle proved all three target theorems without weakening the statements.
The result remains a narrow finite relabeling theorem: visible pairwise
Pluecker mass is invariant under a permutation of hidden/generation labels. It
does not claim anything about nonorthogonal internal Gram data, Yukawa/flip
amplitudes, or physical family structure.

Local verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeGenerationBlindnessCore.lean
lake build PhysicsSM.Draft.NullEdgeGenerationBlindnessCore
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/NullEdgeGenerationBlindnessCore.lean
```

All commands passed. The build required only local style-linter scoping around
the generated Aristotle proof script; no theorem statement was changed.
