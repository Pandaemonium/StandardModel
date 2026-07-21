# Adversarial audit + lemma: is "generalize the changing-cell lemmas from two to four components" actually free?

Mathlib-only, abstract, scoped L2 operator norm where matrices appear.

A continuum-reduction ladder proposes to "reuse the existing changing-cell
projection/interpolation lemmas, generalized from two to four components". An audit
flagged this as the least-protected step. Determine whether the generalization is
genuinely free or hides a hypothesis.

Model the situation abstractly. Let `P_L : (Z -> E) -> (Z -> E)` be a
projection/sampling operator on lattice-indexed vector-valued data with values in a
finite-dimensional inner-product space `E`, acting COMPONENTWISE (i.e. `P_L`
commutes with the inclusion of each coordinate of `E`).

Prove or refute, with explicit witnesses:
1. **Componentwise operators lift for free.** If `T` acts componentwise and is
   bounded with constant `K` on scalar data, then its vector-valued extension is
   bounded with the SAME constant `K` on `E`-valued data (use the Pythagorean
   decomposition). Prove it.
2. **Non-componentwise operators do NOT lift for free.** Exhibit a bounded operator
   on `E`-valued data that does NOT act componentwise (it MIXES components) whose
   norm strictly exceeds the max of its "component" norms - so the free-lift
   argument fails for it. This is the trap: a cell-change that mixes spinor
   components is not covered by componentwise reuse.
3. **Criterion.** State the exact criterion under which the two-to-four-component
   generalization is free: the operator must commute with the component embeddings
   (equivalently, be of the form `T (x) id_E`). Prove that this criterion is
   SUFFICIENT, and show by the witness in (2) that it is NOT automatic.
Conclusion to state plainly: reuse is free for `T (x) id_E`-shaped operators only;
any component-mixing step (e.g. a basis change acting on the spinor index) needs its
own bound. No new axioms/native_decide; standard axioms; report axioms.
