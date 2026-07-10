# Codex proof job: arbitrary-spinor Hodge-Pluecker decoder bridge

Close every proof in `SpinorHodge/Core.lean` without changing definitions,
statements, conventions, or controls. Prove that every arbitrary decorated
complex spinor pair selects the nonnegative scale
`sqrt(normSq(wedge psi phi))`, and that the corresponding decoder on the
nondegenerate nilpotent quartet assigns every exact representative class cost
exactly `normSq(wedge psi phi)`.

Preserve left nondegeneracy, genuine nilpotence, the exact/nonclosed pairing,
two distinct nonzero rational scales `2/5 -> 4/25` and `3/5 -> 9/25`, and the
collinear zero control. This is intended to compose
`GeneralGramTurnScale.turnScale` with
`PositiveHodgePhysicalMass.quartetSAt` in the live repository.

Do not claim that the spinor decorations, decoder family, preferred positive
sector, physical units, or observed masses are derived from a bare graph. The
target derives the Hodge/Pluecker equality for the supplied decorated pair.

Run `lake env lean SpinorHodge/Core.lean`; return the complete file and any
normalization mismatch.

Context pack:
`AgentTasks/context-packs/arbitrary-spinor-hodge-bridge-20260710-20260710-021250.md`.

```yaml
aristotle:
  project_id: 5f5379b8-a5b6-4928-b773-19afb8192f2b
  target_file: SpinorHodge/Core.lean
  expected_module: SpinorHodge.Core
  submission_project: AgentTasks/aristotle-submit/codex-arbitrary-spinor-hodge-bridge-20260710-project
  output_dir: AgentTasks/aristotle-output/5f5379b8-a5b6-4928-b773-19afb8192f2b
  status: idle; harvested and integrated
```
