# Codex proof job: four-component invariant block plus two auxiliaries

Close every proof in `InvariantBlock/Core.lean` without changing definitions,
statements, inner-product convention, or controls. Prove that the canonical
four-component inclusion into `C^4 x C^2` is injective and isometric, that a
block coin exactly intertwines the supplied four-component Dirac evolution on
its invariant image, and that a displayed nonzero auxiliary vector lies outside
that image.

This is the constructive successor to the landed `6 != 4` no-go and `6 = 4+2`
dimension theorem. It demonstrates a mathematically coherent invariant-sector
architecture. It does not prove the actual D4 six-channel coin has this block
form, derive the auxiliary interpretation, or identify the supplied `H` with the
landed Clifford symbol until a separate instantiation theorem is given.

Run `lake env lean InvariantBlock/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/dirac-aux-invariant-block-20260710-20260710-030144.md`.

```yaml
aristotle:
  project_id: 4475a2ed-fef9-4239-af57-c5516772ab87
  target_file: InvariantBlock/Core.lean
  expected_module: InvariantBlock.Core
  submission_project: AgentTasks/aristotle-submit/codex-dirac-aux-invariant-block-20260710-project
  output_dir: AgentTasks/aristotle-output/4475a2ed-fef9-4239-af57-c5516772ab87
  status: integrated-with-corrected-zero-preservation-hypothesis
```
