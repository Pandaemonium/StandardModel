# Aristotle proof task: one-parameter channel-refinement moduli

Complete every theorem in
`ChannelShearModuli/Main.lean` without changing any statement.

The payload is the first exact F1 theorem for Paper F. The `3x3` shear matrices
form a faithful additive one-parameter subgroup with determinant one and column
sums one. They therefore preserve the sum of three ordered even-sector channel
vectors. Every linear type constraint represented by a submodule is preserved,
and a nonzero middle channel makes the resulting ordered refinements genuinely
distinct before quotienting by a selector-preserving equivalence.

Run only:

```text
lake env lean ChannelShearModuli/Main.lean
```

Requirements:

- preserve all twelve statements exactly;
- no new assumptions or placeholder declarations;
- keep the result generic over an arbitrary rational module where stated;
- `mixed_shear_injective` must use the explicit nonzero hypothesis, not
  proof irrelevance or function extensionality in a vacuous way;
- if any statement is false, return the smallest exact counterexample and a
  corrected statement with the same scientific role;
- return the largest proof-complete prefix even if a later theorem blocks.

Publication boundary: this proves a residual type-compatible mixing symmetry,
not a quotient classification and not physical equivalence of all refinements.
The selector/equivalence theorem remains the next rung.

```yaml
aristotle:
  project_id: c2852345-f1ec-4e1d-80ab-821626fe6090
  target_file: ChannelShearModuli/Main.lean
  expected_module: ChannelShearModuli
  submission_project: AgentTasks/aristotle-submit/codex-pub-channel-shear-moduli-20260710-project
  output_dir: AgentTasks/aristotle-output/c2852345-f1ec-4e1d-80ab-821626fe6090
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Codex disposition

All twelve requested statements were accepted unchanged, independently
compiled, and integrated as
`PhysicsSM/Draft/NullEdge/ChannelShearModuli.lean`. The landed result is a
faithful additive determinant-one shear subgroup preserving the fixed total
and every linear type submodule, with a nonzero-channel injectivity witness.

Publication boundary retained: this proves residual type-compatible moduli
before quotienting. It does not classify the full refinement torsor, define
physical equivalence, or show that all admissible decompositions lie in this
one-parameter family.
