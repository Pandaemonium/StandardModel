# Aristotle task: classify permutation-natural quadratic channel selectors

- Work item: `LAB-BOOTSTRAP-001` (classification-paper frontier)
- Role: Builder / Oracle
- Target: `AgentTasks/aristotle-targets/afpl_s3_quadratic_selector_classification.lean`
- Priority: decomposition classification

## Objective

Fill exactly the three proof holes without changing definitions, theorem
statements, imports, or namespace.

1. Classify the complete six-coefficient quadratic family under adjacent
   swaps: all diagonal coefficients must agree and all cross coefficients must
   agree.
2. Prove the fixed-total identity separating the transverse coefficient
   `a - d` from the constant common-mode term.
3. Prove that `d < a` makes equal thirds the unique minimizer on every
   fixed-total fibre, preferably by reducing to
   `ChannelQuadraticSelectorFamily.positive_symmetric_unique_equal_thirds`.

## Semantic constraints

- Do not silently restrict to diagonal metrics; the cross terms are the point.
- Preserve the iff classification and the strict uniqueness conclusion.
- Keep the common-mode noncanonicity visible: permutation symmetry does not
  select numerical values of `a` and `d`.
- Do not claim that a physical action, information measure, or carrier
  dynamics chooses this quadratic family.
- Use no trust-expanding declarations or evaluator shortcuts.

## Verification

Run:

```text
lake env lean AgentTasks/aristotle-targets/afpl_s3_quadratic_selector_classification.lean
```

Return the completed target and a short explanation of why the selector
depends only on `a - d` after fixing the total.
