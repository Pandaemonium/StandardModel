# codex-matrix-block-exp-lift-20260721

Run this first:

```text
lake env lean MatrixBlockExpLift.lean
```

Fill all four proof placeholders without adding assumptions, fake
declarations, compiler-trusted evaluation, or unsafe code. Preserve the exact
statements and the reindexed `blockDiag` definition.

Use Mathlib's matrix exponential API, especially `Matrix.exp_blockDiagonal'`,
`Matrix.exp_conj`, `NormedSpace.map_exp`, and the matrix unitary-group API as
appropriate. A clean proof through algebra homomorphisms/reindexing is
preferred to entrywise expansion.

These lemmas will be used to split a stalled exact factorization of the live
massive HNU exponential word. Do not broaden the task into the HNU theorem.
If a statement is false, return a concrete counterexample and the smallest
corrected theorem.
