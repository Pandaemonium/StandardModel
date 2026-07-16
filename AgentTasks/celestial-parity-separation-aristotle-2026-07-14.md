# Aristotle task: celestial parity separation

## Objective

Prove every target in `CelestialParitySeparation.lean` without changing any
statement.  The finite result must separate the parity-even pair-metric mass
spread from the parity-odd ordered Bargmann handedness under one fixed
orientation-reversing reflection.

## Review constraints

- Preserve `mirrorZ(a) = (a0,a1,-a2)` and the right-handed cross product.
- Preserve the holonomy coefficient `I/4` and the mass-spread coefficient `2`.
- Do not add norm hypotheses; all identities are polynomial.
- Do not add assumptions or declarations that bypass proof.
- Run `lake env lean CelestialParitySeparation.lean` first.

## Semantic context

- Context pack:
  `AgentTasks/context-packs/celestial-parity-separation-20260714-20260714-200948.md`
- Precursors: `CelestialSpiralTriple.lean` and
  `PhysicsSM/Draft/NullEdge/SpinCornerBargmannAristotle.lean`.

## Submission metadata

```yaml
aristotle:
  project_id: 0e6326f7-af15-46bf-aac0-880dce8e10a7
  task_id: 7a135bf9-7701-4364-95d3-c3fa6896c299
  target_file: AgentTasks/aristotle-standalone/celestial-parity-separation-20260714/CelestialParitySeparation.lean
  expected_module: CelestialParitySeparation
  submission_project: AgentTasks/aristotle-submit/celestial-parity-separation-20260714-project
  output_dir: AgentTasks/aristotle-output/0e6326f7-af15-46bf-aac0-880dce8e10a7
  status: submitted
```
