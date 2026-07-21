# Lemma job: MC5 composite assembly with its side conditions made explicit

Mathlib-only, abstract, scoped L2 operator norm where matrices appear.

Two structural audits established that the four-component lift is CONDITIONAL:
- reuse of a lattice-side operator is free exactly when it is `T (x) id_E`
  (equivalently, commutes with all coordinate embeddings);
- a spinor-index operation (e.g. a basis change) is NOT covered by that reuse and
  needs its own bound - but IS free if it is unitary (isometry in the L2 operator
  norm).
Assemble the composite statement so the side conditions are visible rather than
buried.

Setting: vector-valued data `f : X -> E` with `E` finite-dimensional inner-product.
Let `S` be a lattice-side operator with scalar bound `K` that acts componentwise, and
let `U` be a FIXED unitary acting on the `E` (spinor) index only.

Prove:
1. `componentwiseLift S` has bound `K` on `E`-valued data (free lift).
2. Pointwise application of the fixed unitary `U` on the `E` index is an ISOMETRY on
   `L2`-type norms (so it contributes constant 1).
3. **Composite**: the operator `f |-> U . (componentwiseLift S f)` has bound `K` -
   i.e. the composite of a componentwise lattice operator with a fixed spinor-index
   unitary inherits the scalar constant EXACTLY, with no accumulation.
4. **Necessity witness**: exhibit a NON-unitary spinor-index operator for which (3)
   FAILS with constant `K` - showing the unitarity of `U` in (3) is load-bearing, not
   decorative.
Success: 1-3 proved, 4 witnessed. This is the honest MC5 assembly: free lattice-side
reuse + isometric spinor-side change, with both hypotheses explicit.
No new axioms/native_decide; standard axioms; report axioms.
