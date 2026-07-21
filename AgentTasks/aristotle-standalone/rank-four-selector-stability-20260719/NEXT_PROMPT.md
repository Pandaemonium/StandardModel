# Quantitative stability of the rank-four selector

Target `RankFourSelector/Stability.lean`. Prove the uniform-gap perturbation
lemma and its rank-four polynomial-selector corollary without changing either
statement.

The key inequality is that equality of two perturbed eigenvalues would force
the original separation below the sum of two perturbation magnitudes, which is
strictly below `delta`. Use real absolute-value triangle inequalities cleanly.
Then compose with the landed exact Lagrange selector. No new assumptions or
compiler-trusted procedures. Add an axiom guard after closing both theorems and
run `lake env lean RankFourSelector/Stability.lean`. Read `CONTEXT.md`.
