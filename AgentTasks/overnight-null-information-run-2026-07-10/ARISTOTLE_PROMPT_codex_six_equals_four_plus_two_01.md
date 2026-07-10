# Codex proof job: six channels decompose as four plus two

Close every proof in `FourPlusTwo/Core.lean` without changing definitions or
statements. Prove that the six-dimensional complex direction space is linearly
equivalent to a four-component candidate Dirac space plus an exactly
two-dimensional auxiliary factor, with a nonzero auxiliary-rank control.

This is the constructive complement to the landed no-go against a direct
`6 = 4` equivalence. It permits, but does not yet derive, an interpretation of
the extra two channels as gauge, constraint, ancilla, or heavy modes. Do not
claim an invariant physical Dirac sector until a coin/intertwiner theorem proves
the four-dimensional factor is dynamically preserved and the auxiliary factor
decouples or has a controlled role.

Run `lake env lean FourPlusTwo/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/six-equals-four-plus-two-20260710-20260710-025016.md`.

```yaml
aristotle:
  project_id: 96c2c965-563f-4615-b4e4-fe3611e598d5
  target_file: FourPlusTwo/Core.lean
  expected_module: FourPlusTwo.Core
  submission_project: AgentTasks/aristotle-submit/codex-six-equals-four-plus-two-20260710-project
  output_dir: AgentTasks/aristotle-output/96c2c965-563f-4615-b4e4-fe3611e598d5
  status: idle; harvested and integrated
```
