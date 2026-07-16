# Aristotle task: celestial spiral to winding density

## Objective

Prove the exact Pauli/projector bridge in `CelestialSpiralWinding.lean`
without changing any declaration statement.  The central target identifies
the oriented celestial scalar triple product with the noncommuting
antisymmetrized cubic trace used as a pointwise three-dimensional winding
density.

## Review constraints

- Do not weaken or delete theorem statements.
- Small helper lemmas are welcome.
- Preserve both the matrix-level coefficient `6` and trace-level coefficient
  `12`, plus the projector normalization and nonzero witness.
- Do not add assumptions, declarations that bypass proof, or trusted-compiler
  evaluation.
- Run `lake env lean CelestialSpiralWinding.lean` first.
- Finish with a concise report listing solved targets, statement changes,
  remaining proof holes, and assumptions used.

## Semantic context

- Context pack:
  `AgentTasks/context-packs/celestial-spiral-winding-20260714-20260714-184815.md`
- Live precursors:
  `PhysicsSM/Draft/SpinCoherentProjectorAristotle.lean` and
  `PhysicsSM/Draft/NullEdge/SpinBlindWindingObstruction.lean`

## Submission metadata

```yaml
aristotle:
  project_id: 55e27f4f-1c11-412b-8213-95bb5c6cdb76
  task_id: 50c9bf93-bcf1-49e5-9b88-70e895ecac7a
  target_file: AgentTasks/aristotle-standalone/celestial-spiral-winding-20260714/CelestialSpiralWinding.lean
  expected_module: CelestialSpiralWinding
  submission_project: AgentTasks/aristotle-submit/celestial-spiral-winding-20260714-project
  output_dir: AgentTasks/aristotle-output/55e27f4f-1c11-412b-8213-95bb5c6cdb76
  status: integrated
```

## Integration result

The returned proof file preserved every theorem signature and was copied to
the standalone target above.  It passes `lake env lean` under the pinned
toolchain, the placeholder scan is clean, and every target depends only on
`propext`, `Classical.choice`, and `Quot.sound`.
