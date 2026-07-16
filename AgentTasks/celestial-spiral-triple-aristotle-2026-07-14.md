# Aristotle task: celestial spiral triple

## Objective

Prove the Mathlib-only finite theorem packet in
`CelestialSpiralTriple.lean` without changing any declaration statement.
The semantic payload is that reversing an ordered triple of celestial null
directions preserves the parity-even angular mass spread while reversing the
parity-odd Bargmann handedness.

## Review constraints

- Do not weaken or delete theorem statements.
- Small helper lemmas are welcome.
- Keep the coordinate-axis nondegenerate witness.
- Do not add assumptions, declarations that bypass proof, or trusted-compiler
  evaluation.
- Run `lake env lean CelestialSpiralTriple.lean` first.
- Finish with a concise report listing solved targets, statement changes,
  remaining proof holes, and assumptions used.

## Semantic context

- Context pack:
  `AgentTasks/context-packs/celestial-spiral-triple-20260714-20260714-184754.md`
- Live precursor:
  `PhysicsSM/Draft/SpinCoherentProjectorAristotle.lean`
- Active manuscript:
  `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`

## Submission metadata

```yaml
aristotle:
  project_id: 694d4bce-fb16-44a1-8a00-b55ffdf3e29f
  task_id: 047426aa-e107-4c02-b072-5be58ac00be6
  target_file: AgentTasks/aristotle-standalone/celestial-spiral-triple-20260714/CelestialSpiralTriple.lean
  expected_module: CelestialSpiralTriple
  submission_project: AgentTasks/aristotle-submit/celestial-spiral-triple-20260714-project
  output_dir: AgentTasks/aristotle-output/694d4bce-fb16-44a1-8a00-b55ffdf3e29f
  status: integrated
```

## Integration result

The returned proof file preserved every theorem signature and was copied to
the standalone target above.  It passes `lake env lean` under the pinned
toolchain, the placeholder scan is clean, and every target depends only on
`propext`, `Classical.choice`, and `Quot.sound`.
