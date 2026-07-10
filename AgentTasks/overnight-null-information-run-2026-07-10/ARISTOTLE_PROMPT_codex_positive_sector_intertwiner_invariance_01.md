# Codex proof job: positive-sector invariance under intertwiners

Close every proof in `PositiveSector/Core.lean` without changing definitions,
statements, pairing, boost coefficients, or controls. Prove that every
pairing-preserving linear equivalence induces an equivalence of positive
sectors and preserves nonemptiness. Construct the nontrivial rational
`3-4-5` Lorentz boost, prove exact pairing preservation, positive-unit norm,
negative-direction control, and nonempty sector.

This is the finite invariant-sector-selection rung. It does not choose one
positive sector among inequivalent pairings, derive the Born rule, or prove the
intertwiner descends from a particular gauge/cohomology carrier without a
separate instantiation.

Run `lake env lean PositiveSector/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/positive-sector-intertwiner-invariance-20260710-20260710-015011.md`.

```yaml
aristotle:
  project_id: 203562ea-6e60-4248-b8ef-330eb533bad6
  target_file: PositiveSector/Core.lean
  expected_module: PositiveSector.Core
  submission_project: AgentTasks/aristotle-submit/codex-positive-sector-intertwiner-invariance-20260710-project
  output_dir: AgentTasks/aristotle-output/203562ea-6e60-4248-b8ef-330eb533bad6
  status: idle; harvested and integrated
```
