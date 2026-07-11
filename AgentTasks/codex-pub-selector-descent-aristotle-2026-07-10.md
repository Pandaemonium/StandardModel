# Aristotle proof task: intrinsic selector descent criterion

Prove all five theorem holes in `SelectorDescent/Main.lean` without changing any
definition, theorem statement, or hypothesis.

Scientific purpose: word/solder degree and edge exchange are initially
selectors on a source presentation of carrier-square words. They count as
intrinsic selectors on represented operators only when they are independent of
the source representative. This task states the exact gate: preservation of the
evaluation kernel, with uniqueness under surjectivity.

Requirements:

- preserve the arbitrary ring and module hypotheses;
- preserve surjectivity exactly where stated;
- use the displayed quotient construction for the canonical selector;
- prove necessity, exact intertwining, uniqueness, the iff theorem, and the
  explicit relation-witness obstruction;
- do not assume injectivity, finite dimensionality, a field, positivity, or an
  inner product;
- do not add assumptions or use a compiler-trusting shortcut;
- if any statement is false, return a smallest exact counterexample rather than
  weakening it.

Success turns Paper F's “intrinsic selector” language into a theorem-level
criterion. It does not itself prove that a particular physical degree or edge
selector passes the criterion for the live carrier.

```yaml
aristotle:
  project_id: 545decd7-f32b-4780-8c53-9e151bcde74f
  target_file: SelectorDescent/Main.lean
  expected_module: SelectorDescent.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-selector-descent-20260710-project
  output_dir: AgentTasks/aristotle-output/545decd7-f32b-4780-8c53-9e151bcde74f
  status: landed
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

All five statements were proved unchanged. Integrated as
`PhysicsSM/Draft/NullEdge/ChannelSelectorDescent.lean` with the audit-required
surjectivity wording and build-enforced axiom pins.
