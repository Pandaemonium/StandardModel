# Aristotle task: massive chiral helix

## Objective

Prove every target in `MassiveChiralHelix.lean` without changing any
statement.  The finite Dirac avatar must yield both the exact dispersion
square and the transverse double-commutator coefficient `4(p^2+m^2)`.

## Review constraints

- Preserve the chiral block order and the ladder entry normalization `2`.
- Preserve the Hamiltonian `H = p D0 + m betaM` and coefficient `4`.
- Do not assume positivity or nonzero momentum/mass.
- Do not add assumptions or declarations that bypass proof.
- Run `lake env lean MassiveChiralHelix.lean` first.

## Semantic context

- Context pack:
  `AgentTasks/context-packs/massive-chiral-helix-20260714-20260714-201024.md`
- Precursor:
  `PhysicsSM/Draft/NullEdge/ChiralSpiralCommutatorAristotle.lean`.

## Submission metadata

```yaml
aristotle:
  project_id: 405506b7-e19a-471d-a973-e0669db8d91a
  task_id: a14a7403-2c8e-4897-8a96-8d68babde8ca
  target_file: AgentTasks/aristotle-standalone/massive-chiral-helix-20260714/MassiveChiralHelix.lean
  expected_module: MassiveChiralHelix
  submission_project: AgentTasks/aristotle-submit/massive-chiral-helix-20260714-project
  output_dir: AgentTasks/aristotle-output/405506b7-e19a-471d-a973-e0669db8d91a
  status: submitted
```
