# claude-detp-uniqueness — mass^2 = det P is the CANONICAL choice: the unique invariant quadratic vanishing on null edges

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

The program's [orig] core is that `mass^2 = det P` (the Plucker disagreement of two null edges). A fair
objection: why the determinant and not some other function? This job answers it -- `det` is not one
choice among many, it is FORCED. Prove that on real symmetric `2x2` matrices, the determinant is (up to
scale) the UNIQUE quadratic form that (i) vanishes on every rank-<=1 ("null edge") matrix and (ii) is
invariant under the congruence action of `SL(2,R)` (`P |-> A^T P A`, `det A = 1`). So the mass invariant
is canonical, not conventional.

## The model (finite, real; the 3-dim space of symmetric 2x2)

A symmetric `2x2` real matrix `P = !![a, b; b, c]` <-> coordinates `(a, b, c) in R^3`. A quadratic form
`Q(P) = alpha a^2 + beta b^2 + gamma c^2 + delta a b + eps a c + zeta b c` (6 real coefficients). The
determinant is `det P = a c - b^2` (the quadratic with `eps = 1, beta = -1`, rest 0). "Null edge" =
rank <= 1 = `det P = 0` with `P` PSD; the rank-1 PSD matrices are exactly `edge v = v v^T`.

## Targets (real/rational; ring/norm_num/decide/fin_cases/linear-algebra; NO transcendental, NO Complex, NO nlinarith deg>=3)

1. `det_vanishes_on_edges`: `det (edge v) = 0` for every `v : Fin 2 -> R` (the determinant vanishes on
   all null edges). By `Matrix.det_fin_two` + `ring`.
2. `det_congruence_relative_invariant`: `det (A^T * P * A) = (det A)^2 * det P`; in particular for
   `det A = 1`, `det (A^T P A) = det P` (SL(2) congruence-invariant). Via `Matrix.det_mul`, `det_transpose`.
3. `edge_span` (support lemma): the rank-1 matrices `edge e0, edge e1, edge (e0+e1)` (i.e.
   `!![1,0;0,0], !![0,0;0,1], !![1,1;1,1]`) span enough of the null cone to pin a quadratic vanishing on
   all of them: any quadratic `Q` (as above) with `Q(edge v) = 0` for ALL `v` has `alpha = gamma = 0`
   (from `e0, e1`) and the `a c`/`b^2` combination fixed to the `det` pattern (from mixed `v`). Compute
   `Q(edge (x,y)) = alpha x^4 + ... ` and force all coefficients to vanish; conclude `Q` is a scalar
   multiple of `(a c - b^2)` PLUS possibly the `b^2`-free... -- derive the exact linear constraints.
4. `detP_unique` (payload): if a quadratic form `Q` on symmetric `2x2` (i) vanishes on every `edge v`
   and (ii) is `SL(2,R)`-congruence invariant, then `Q = k * det` for some real `k`. State and prove the
   uniqueness (up to scale) -- the mass invariant is canonical. (Route: (i) via `edge_span` kills the
   non-det quadratics; (ii) invariance fixes the remaining freedom; assemble to `Q = k*(ac - b^2)`.)
   `uniqueness_verdict`: package -- `det P` is THE mass^2 invariant, forced by null-vanishing +
   SL(2)-invariance, not chosen. Honest scope: real symmetric `2x2` (one null-edge pair / one momentum);
   the uniqueness is among quadratic forms; provenance = classical invariant theory (the determinant as
   the SL(2) relative invariant).

MANDATORY non-degeneracy: exhibit a DIFFERENT quadratic (e.g. `Q'(P) = a c`, the "trace-like" product)
that vanishes on `edge e0, edge e1` but NOT on `edge (e0+e1)` (`Q'(!![1,1;1,1]) = 1 != 0`), showing the
null-vanishing condition is a real constraint that `det` uniquely satisfies; and show `Q' ` is not
SL(2)-invariant. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL/rational symmetric 2x2, explicit coefficient algebra; Matrix.det_fin_two/
det_mul/det_transpose + ring/norm_num/decide/fin_cases + linear constraints; NO Real.sqrt/cos/sin, NO
Complex, NO nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean (namespace
DetPUniqueness) + ARISTOTLE_SUMMARY.md.
