# Aristotle proof task: selector rigidity and finite-selector no-go

Prove all three open theorems in `SelectorRigidity/Main.lean` without changing
any statement.

Scientific role: this is Paper F's shortest noncircular selector theorem. A
selector rigidifies the full fixed-total refinement torsor exactly when its
homomorphism on zero-sum shifts is injective. In the actual rational-module
setting, one nonzero admissible direction injects `Q` into the shift group, so
no finite-valued sign/type selector can rigidify it.

Requirements:

- preserve the genuine `iff` in `selector_rigid_iff_injective`;
- use both directions of the existing `difference`/`translate` API rather than
  defining rigidity to mean injectivity;
- preserve the rational-module hypothesis and explicit nonzero `v` witness in
  `rationalShift_injective` and `no_finite_selector_rigidifies`;
- do not generalize the finite-selector no-go to arbitrary nonzero abelian
  groups: that statement is false for finite groups;
- no new assumptions, compiler-trusting shortcut, or weakened conclusion;
- if a statement is false, return the smallest exact counterexample and a
  corrected theorem with the same scientific role;
- return the largest proof-complete prefix if a later theorem blocks.

Boundary: success rules out finite-valued selectors on the type-only rational
shift torsor. It does not define physical equivalence, prove that every
physically meaningful selector is finite, or derive a preferred locality/RG
selector.

```yaml
aristotle:
  project_id: 904751e4-34f4-4798-8b13-134443e7d9c6
  target_file: SelectorRigidity/Main.lean
  expected_module: SelectorRigidity.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-selector-rigidity-20260710-project
  output_dir: AgentTasks/aristotle-output/904751e4-34f4-4798-8b13-134443e7d9c6
  status: harvested/integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

All three statements were proved unchanged and without new assumptions. The
proofs were adapted to the live torsor API as
`PhysicsSM/Draft/NullEdge/ChannelSelectorRigidity.lean`, directly compiled,
and added to the publication guard and executable verifier. The theorem keeps
the essential rational-module and explicit nonzero-direction hypotheses; no
claim is made about arbitrary abelian groups or all physical selectors.
