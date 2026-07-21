# Lemma job: block/direct-sum operator-norm bookkeeping (MC5 support)

Mathlib-only, abstract. A four-component estimate is being assembled from
two-component estimates; the constant bookkeeping must be stated, not assumed.
With the L2 operator norm (`open scoped Matrix.Norms.L2Operator`) prove:
1. **Unitary conjugation is an isometry**: for `U` unitary and any `A`,
   `||U * A * star U|| = ||A||` (and `||U|| = 1`).
2. **Block-diagonal norm**: for `A B : Matrix (Fin 2) (Fin 2) C`, the block-diagonal
   `Matrix.fromBlocks A 0 0 B` satisfies
   `||fromBlocks A 0 0 B|| = max ||A|| ||B||` (or `<= max` if equality is heavy) -
   i.e. assembling two 2-component estimates does NOT multiply the constant.
3. **Difference of block-diagonals**: `||fromBlocks A 0 0 B - fromBlocks A' 0 0 B'||
   <= max ||A - A'|| ||B - B'||`, the form actually needed to lift a one-step
   two-component bound to four components.
This pins whether the four-component constant accumulates as 1, sqrt 2, or 2 (the
answer should be: it does not accumulate). No new axioms/native_decide; standard
axioms; report axioms.
