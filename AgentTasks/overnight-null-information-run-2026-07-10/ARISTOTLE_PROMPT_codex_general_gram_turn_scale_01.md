# Codex proof job: general spinor-pair to turn-scale theorem

Close every proof in `GeneralGramTurn/Core.lean` without changing definitions,
statements, conventions, or witness values. Prove that the nonnegative scale

`turnScale psi phi = sqrt(normSq(psi wedge phi))`

has square equal to the Pluecker norm, that the two-edge Gram determinant equals
that norm, and that the free mass operator equals the complexified turn channel
at the derived scale for every pair. Preserve the `2/5` noncollinear witness,
the collinear zero control, and the nonzero operator control.

This removes the hand-chosen `(e0,m e1)` restriction but still assumes complex
spinor decorations for the primitive steps. Do not claim that a bare graph
derives those spinors, physical units, a Higgs field, or an interacting mass.

Run `lake env lean GeneralGramTurn/Core.lean`; return the complete file and any
sign/normalization issue.

Semantic context pack:
`AgentTasks/context-packs/general-gram-turn-scale-20260710-20260710-002212.md`.

```yaml
aristotle:
  project_id: 0a3433d8-7a02-4b8b-babf-ee75f573a95c
  target_file: GeneralGramTurn/Core.lean
  expected_module: GeneralGramTurn.Core
  submission_project: AgentTasks/aristotle-submit/codex-general-gram-turn-scale-20260710-project
  output_dir: AgentTasks/aristotle-output/0a3433d8-7a02-4b8b-babf-ee75f573a95c
  status: running
```
