# Aristotle task: scalar Klein equality core

## Objective

Complete the single proof hole in
`AgentTasks/aristotle-targets/afpl_scalar_klein_equality_core.lean` without
changing the theorem statement.

This is the reduced successor to stalled project
`ac779534-f40d-4666-b98a-9d364996d6f7`. Prove the scalar doubly-stochastic
strictness lemma only. Do not attempt spectral matrix reconstruction here.

## Semantic requirements

- Allow zero entries of `lam`.
- Use strict positivity only for `mu`, exactly as stated.
- Derive tightness of every nonzero-overlap term from vanishing of the total
  scalar relative entropy; do not assume termwise equality.
- Preserve both row and column stochasticity and both normalizations.

## Suggested route

Rewrite the entropy gap as a finite sum of weighted scalar Klein gaps. Each
summand is nonnegative, with the `lam i = 0` case handled separately. Since
the total sum is zero, a term with `p i j > 0` must be tight; apply `term_eq`.

## Success criteria

- Target builds under the pinned Lean toolchain.
- No proof holes or trust-expanding declarations remain.
- The immutable theorem statement is unchanged.
- Report explicitly how the `lam i = 0` branch is excluded when `p i j != 0`.

## Aristotle metadata

- Work item: `DYN-MODULAR-001`
- Hat: Builder/Assassin
- Priority: P1
- Requested trust: kernel-checked standard-three footprint only
- Aristotle project: `be3e675b-9c6e-47d3-aa40-ae51042cc427`
